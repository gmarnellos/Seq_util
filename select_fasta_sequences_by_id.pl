#!/usr/bin/perl -w

use warnings;
use strict;

#print "\nUsage: select_fasta_sequences_by_id.pl <sequence_IDs_file> <input_fasta_file> <output_fasta_file> \n";

## input for script

my $seqIDs = $ARGV[0];
my $infile = $ARGV[1];
my $outfile = $ARGV[2];

open SEQIDS, "< $seqIDs" or die "Can't open $seqIDs : $!";

open INFILE, "< $infile" or die "Can't open $infile : $!";

open OUTFILE, "> $outfile" or die "Can't open $outfile : $!";


my ($id_entry);
my (@ids, @entry_elements);

my @id_entries=<SEQIDS>;

print "Number of ID entries: ", $#id_entries + 1 , "\n";

my $i;

for ( $i=0; $i <= $#id_entries; $i++ ) {

  $id_entry = $id_entries[$i];

  chomp $id_entry;

  @entry_elements = split(" ", $id_entry);

  $ids[$i] = $entry_elements[0];

  print "ID $i is : $ids[$i] \n";

}

close SEQIDS;


local $/ = ">";
my ($sequence, $header, $temp);

while ($sequence = <INFILE>) {

    chomp $sequence;

    if ($sequence ne '') {
       ($header) = $sequence =~ /^(.+)\n/;

       for ( $i=0; $i <= $#ids; $i++ ) {
          if ($header ne '' and $header =~ /^$ids[$i]/) {
             print OUTFILE ">$sequence\n"; 
          }  
       }
    }
}


close INFILE;

close OUTFILE;


########################################
