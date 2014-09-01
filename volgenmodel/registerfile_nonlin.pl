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

my ($prevmodxfm, $identxfm, $conf_fname, $fitmsk, $isomodel_base, $fitfile, $modxfm);
$prevmodxfm = $ARGV[0];
$identxfm = $ARGV[1];
$conf_fname = $ARGV[2];
$fitmsk = $ARGV[3];
$isomodel_base = $ARGV[4];
$fitfile = $ARGV[5];
$modxfm = $ARGV[6];

# register each file in the input series
my $initcnctxfm = "init.xfm";
&do_cmd("xfmconcat -clobber $prevmodxfm $identxfm $initcnctxfm");

&do_cmd("/opt/neuroimaging/scripts/nlpfit -clobber -init_xfm $initcnctxfm -config $conf_fname -source_mask $fitmsk $isomodel_base $fitfile $modxfm");

sub do_cmd {
        print STDOUT "@_\n"; #if $opt{'verbose'};
        system(@_);
}

