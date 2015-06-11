#!/usr/bin/perl -w

use warnings;
use strict;
use Text::Levenshtein qw(distance);


#print "\nUsage: split_fastq_by_barcode.pl <sample_barcode_table.txt> <fastq_file> <read 1 or 2> <instrument_name> <barcode_length> <barcode_Levenshtein_distance>\n";

## input for script

my $barcode_list = $ARGV[0];

my $fastqin = $ARGV[1];
my $read = $ARGV[2];
my $instrument = "ILLUMINA";
$instrument = $ARGV[3];
my $barcodeLength = 6;
$barcodeLength = $ARGV[4];
my $barcodeDistance = 0;
$barcodeDistance = $ARGV[5];

my $undetermined = "undetermined.R$read.fastq";


## read barcodes into hash and create output filehandle for each barcode

my ($key, $value);
my %barcodes = ();
my %fh = ();

open FILE, "< $barcode_list" or die "Can't open $barcode_list : $!";

while( <FILE> ) {
#    chomp;
    ($key, $value) = split(' ');
    $barcodes{$key} = $value;
    open $fh{$key}, "> Sample_$key.$value.R$read.fastq";

}
     
close FILE;
     

## read fastq file and assign entries to barcodes

my $entry;
my $barcode;

open UNDFASTQ, "> $undetermined" or die "Can't open $undetermined : $!";
open FQFILE, "< $fastqin" or die "Can't open $fastqin : $!";

#local $/ = "\@ILLUMINA\:";  # read by FASTQ record

local $/ = "\@$instrument\:";  # read by FASTQ record

my $assigned_to_barcode = "No";

my $errcnt=0;
my $totcnt=0;

while ($entry = <FQFILE>) {

    $assigned_to_barcode = "No";
    chomp $entry;
    if ($entry ne '') {
      ($barcode) = $entry =~ /^.*\s$read\:N\:\d+\:([ACGTN]{$barcodeLength})[ACGTN]*\s*\n/; 

    if (!$barcode) {
	print "\n*** entry with unparsable barcode:\n $entry \n ---- barcode: $barcode\n";	
	$errcnt++;
    }

    $totcnt++;

      for $key (sort keys %barcodes) {
#	if ($barcodes{$key} eq $barcode) {
	if (distance($barcodes{$key}, $barcode) <= $barcodeDistance) {
#	  print {$fh{$key}} "\@ILLUMINA\:$entry";
	  print {$fh{$key}} "\@$instrument\:$entry";
	  $assigned_to_barcode = "Yes";
	}
      }

      if ($assigned_to_barcode eq "No") {
# 	print UNDFASTQ "\@ILLUMINA\:$entry";
        print UNDFASTQ "\@$instrument\:$entry";
      }
    }

}

print "\n\n******** error count : $errcnt  ******** total: $totcnt ***** \n";

## Close input and output file handles

close FQFILE;

for $key (sort keys %barcodes) {
  close $fh{$key};
}

close UNDFASTQ;


################################################

