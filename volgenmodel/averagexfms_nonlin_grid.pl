#!/usr/bin/perl
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

my @modxfms = glob "modxfm*.xfm*";
my $avgxfm = "avgfile.xfm";
my ($f, $file);
for($f=0; $f<=$#modxfms; $f++){
        my $ext = $modxfms[$f] =~ /(\.[^.]+)$/;
        #$file = &basename($modxfms[$f]);
        #$file =~ s/\.xfm$//;
        my $command = "sed 's/Displacement_Volume =.*/Displacement_Volume = modxfm_grid_0.mnc.$ext;/g' $modxfms[$f] > tmp && mv tmp $modxfms[$f]";
        print $command ."\n";
        &do_cmd($command);
}
&do_cmd("/opt/neuroimaging/scripts/xfmavg -clobber -ignore_linear @modxfms $avgxfm");

sub do_cmd {
        print STDOUT "@_\n"; #if $opt{'verbose'};
        system(@_);
}

