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
 
my ($filename, $normalise, $pad, $model_norm_thresh, $iso, $check);
$filename = $ARGV[0];
$normalise = $ARGV[1];
$pad = $ARGV[2];
$model_norm_thresh = $ARGV[3];
$iso = $ARGV[4];
$check = $ARGV[5];

my ($resfile, $fitfile, $nrmfile, $chkfile, $isofile);
$resfile = "resfile.res.mnc";
$fitfile = "fitfile.fit.mnc";
$nrmfile = "nrmfile.nrm.mnc";
$isofile = "isofile.iso.mnc";
$chkfile = "chkfile.fit.jpg";

# centre the volume so that a PAT xfm has a greater chance
printf STDOUT "   | $resfile - centreing\n";
&do_cmd("/opt/neuroimaging/scripts/volcentre -clobber -zero_dircos $filename $resfile");

# normalise
if($normalise){
       	my($step_x, $step_y, $step_z);
         
      	# get step sizes
       	chomp($step_x = `mincinfo -attvalue xspace:step $filename`);
       	chomp($step_y = `mincinfo -attvalue yspace:step $filename`);
       	chomp($step_z = `mincinfo -attvalue zspace:step $filename`);
        
       	printf STDOUT "   | $nrmfile - normalising\n";
	my ($abs_value);
	$abs_value = abs($step_x + $step_y + $step_z);
        &do_cmd("mincnorm -clobber -cutoff $model_norm_thresh -threshold -threshold_perc $model_norm_thresh -threshold_blur $abs_value $resfile $nrmfile");
	&do_cmd("mv -f $nrmfile $resfile");
}
else{
       	#&do_cmd("ln -s -f $resfile $nrmfile");
}
      
# extend/pad
if($pad > 0){
       	printf STDOUT "   | $fitfile - padding\n";
	my ($pad_value);
	$pad_value = sprintf('%d', $pad/3);
       	&do_cmd("/opt/neuroimaging/scripts/volpad -clobber -distance $pad -smooth -smooth_distance $pad_value $resfile $fitfile");
}
else{
       	&do_cmd("cp -f $resfile $fitfile");
}

# isotropic resampling
if($iso){
	printf STDOUT " | $isofile - resampling isotropically\n";
        &do_cmd("/opt/neuroimaging/scripts/voliso --clobber --avgstep $fitfile $isofile");
        &do_cmd("mv -f $isofile $fitfile");
}
else{
	#&do_cmd("IMV$$-$f", "PAD$$-$f", "true");
}
      
# checkfile
&do_cmd("mincpik -clobber -triplanar -sagittal_offset 10 $fitfile $chkfile") if $check;


sub do_cmd {
   	print STDOUT "@_\n"; #if $opt{'verbose'};
      	system(@_);
}

