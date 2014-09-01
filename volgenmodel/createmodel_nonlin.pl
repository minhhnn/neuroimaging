#! /usr/bin/env perl
#
# generate a nonlinear model
#
# Andrew Janke - a.janke@gmail.com
#
# Copyright Andrew Janke, The Australian National University.
# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose and without fee is hereby granted,
# provided that the above copyright notice appear in all copies.  The
# author and the University make no representations about the
# suitability of this software for any purpose.  It is provided "as is"
# without express or implied warranty.


use strict;
use warnings "all";
use File::Basename;

my ($symmetric, $symmetric_dir, $check);
$symmetric = $ARGV[0];
$symmetric_dir = $ARGV[1];
$check = $ARGV[2];

my($me, $history);
$me = &basename($0);

# get history string
chomp($history = `date`);
$history .= '>>>> ' . join(' ', $me, @ARGV);

my ($istdfile, @rsmpl, $iavgfile, $iavgfilechk, $istdfilechk);
$istdfile = "model.istd.mnc";
$iavgfile = "model.iavg.mnc";
$iavgfilechk = "model.iavg.jpg";
$istdfilechk = "model.istd.jpg";

@rsmpl = glob "rsmpl*";

&do_cmd("/opt/neuroimaging/scripts/mincbigaverage -clobber -float -robust -tmpdir tmp -sdfile $istdfile @rsmpl $iavgfile");
&do_cmd("mincpik -clobber -triplanar -horizontal -scale 4 -tilesize 400 -sagittal_offset 10 $iavgfile $iavgfilechk") if $check;
&do_cmd("mincpik -clobber -triplanar -horizontal -scale 4 -tilesize 400 -lookup -hotmetal -sagittal_offset 10 $istdfile $istdfilechk") if $check;

my $stage_model = "model.avg.mnc";
my $stage_modelchk = "model.avg.jpg";
# do symmetric averaging if required
if($symmetric){
	my (@fit_args, $symxfm, $symfile);
      
      	$symxfm = "model.sym.xfm";
      	$symfile = "model.iavg-short.mnc";
      
	# convert double model to short
      	&do_cmd("mincreshape -clobber -short $iavgfile $symfile");
      
      	# set up fit args
	my $conf_fname = "fit.conf";
        @fit_args = ('-nonlinear', '-config_file', $conf_fname);
	&do_cmd("echo enter > a.txt");
	my $cmd = "/opt/neuroimaging/scripts/volsymm -clobber -verbose @fit_args $symfile $symxfm $stage_model";
	&do_cmd("echo $cmd > cmd.txt");
      	&do_cmd($cmd);
	&do_cmd("echo exit > b.txt");
}
else{
	my $iavgfile_basename = &basename($iavgfile);
	&do_cmd("ln -s -f $iavgfile_basename $stage_model");
}

&do_cmd("echo enter > c.txt");
&do_cmd("mincpik -clobber -triplanar -horizontal -scale 4 -tilesize 400 -sagittal_offset 10 $stage_model $stage_modelchk") if $check;
&do_cmd("echo exit > d.txt");
sub do_cmd {
        print STDOUT "@_\n"; #if $opt{'verbose'};
        system(@_);
}
