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


$| = 0;

use strict;
use warnings "all";

my ($config_file, $end_stage, $cmodel, $model_norm_thresh, $model_min_step, $check);
$config_file = $ARGV[0];
$end_stage = $ARGV[1];
$cmodel = $ARGV[2];
$model_norm_thresh = $ARGV[3];
$model_min_step = $ARGV[4];
$check = $ARGV[5];

# set up the @conf array
my(@conf, $buf);
# read in @conf
$buf = `cat $config_file`;

# slurp
if(eval($buf)){
	print STDOUT "Read config from $config_file\n";
}
else{
	die "Error reading config from $config_file (fix it!)\n\n";
}

print STDOUT "  + End stage: $end_stage\n";

# create the ISO model
my($isomodel_base, $modelmaxstep);
$isomodel_base = "fit-model-iso";
   
printf STDOUT "   | $isomodel_base - creating\n";
$modelmaxstep = $conf[$end_stage]{'step'}/4;

# check that the resulting model won't be too large
   # this seems confusing but it actually makes sense...
if($modelmaxstep < $model_min_step){
	$modelmaxstep = $model_min_step;
}

print "   -- Model Max step: $modelmaxstep\n";
&do_cmd("/opt/neuroimaging/scripts/mincnorm -clobber -cutoff $model_norm_thresh -threshold -threshold_perc $model_norm_thresh -threshold_blur 3 -threshold_mask $isomodel_base.msk.mnc $cmodel $isomodel_base.nrm.mnc");
&do_cmd("/opt/neuroimaging/scripts/voliso -clobber -maxstep $modelmaxstep $isomodel_base.nrm.mnc $isomodel_base.mnc");
&do_cmd("mincpik -clobber -triplanar -horizontal -scale 4 -tilesize 400 -sagittal_offset 10 $isomodel_base.mnc $isomodel_base.jpg") if $check;
   
# create the isomodel fit mask
#chomp($step_x = `mincinfo -attvalue xspace:step $isomodel_base.msk.mnc`);
my($step_x);
$step_x = 1;
my ($step_x_value);
$step_x_value = $step_x * 15;
&do_cmd("mincblur -clobber -fwhm $step_x_value $isomodel_base.msk.mnc $isomodel_base.msk");
&do_cmd("mincmath -clobber -gt -const 0.1 $isomodel_base.msk_blur.mnc $isomodel_base.fit-msk.mnc");

 # linear or nonlinear fit
print STDOUT "---Non Linear fit---\n";

# create nlin fiit config
my ($conf_fname, $s);
$conf_fname = "fit.conf";
print STDOUT "    + Creating $conf_fname +\n";

open(CONF, ">$conf_fname");
print CONF "# $conf_fname -- created by \n#\n" . "# End stage: $end_stage\n" . "\n\n";

print CONF "\@conf = (\n";
foreach $s (0..$end_stage){
     	print CONF "   {'step' => " . $conf[$s]{'step'} . ", 'blur_fwhm' => " . $conf[$s]{'blur_fwhm'} . ", 'iterations' => " . $conf[$s]{'iterations'} . "},\n";
}
print CONF "   );\n";
close(CONF);

sub do_cmd {
        print STDOUT "@_\n"; #if $opt{'verbose'};
        system(@_);
}
