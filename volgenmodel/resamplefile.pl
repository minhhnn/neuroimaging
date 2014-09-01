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

my ($isomodel_base, $avgxfm, $modxfm, $resfile, $check);
$isomodel_base = $ARGV[0];
$avgxfm = $ARGV[1];
$modxfm = $ARGV[2];
$resfile = $ARGV[3];
$check = $ARGV[4];

my ($chkfile, $invxfm, $resxfm, $rsmpl);
$invxfm = "inv.xfm";
$resxfm = "rsmpl.xfm";
$rsmpl = "rsmpl.mnc";
$chkfile = "rsmpl.jpg";

printf STDOUT "   | $rsmpl - resampling\n";
# invert model xfm
&do_cmd("xfminvert -clobber $modxfm $invxfm");
        
# concat
&do_cmd("xfmconcat -clobber $invxfm $avgxfm $resxfm");

# resample
&do_cmd("mincresample -clobber -sinc -transformation $resxfm -like $isomodel_base $resfile $rsmpl");
&do_cmd("mincpik -clobber -triplanar -sagittal_offset 10 $rsmpl $chkfile") if $check;

sub do_cmd {
        print STDOUT "@_\n"; #if $opt{'verbose'};
        system(@_);
}
