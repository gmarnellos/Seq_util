#!/usr/bin/perl -w

use warnings;
use strict;

#print "\nUsage: filter_fasta_by_seq_length.pl <input_file> <output_file> <minimum_length>\n";

## input for script

my $infile = $ARGV[0];
my $outfile = $ARGV[1];
my $minlen = $ARGV[2];
   
#my @fields;
my ($header, $sequence, $sequenceout);


open FQFILE, "< $infile" or die "Can't open $infile : $!";
open OUTFILE, "> $outfile" or die "Can't open $outfile : $!";

local $/ = ">";
my $count = 0;

while ($sequence = <FQFILE>) {

    chomp $sequence;

    ($header) = $sequence =~ /^(.+)\n/;
    $sequence =~ s/^.+\n//;
    $sequenceout = $sequence;
    $sequence =~ s/\n//g; # remove endlines

    if ($count && length($sequence) >= $minlen) { 
	print OUTFILE ">$header", "\n$sequenceout"; 
    }

    $count++;
}

close FQFILE;
close OUTFILE;

exit;

################################################


