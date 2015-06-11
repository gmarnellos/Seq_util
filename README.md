# Sequence file utilities

- Filter fasta sequences by sequence length:

     Usage: filter_fasta_by_seq_length.pl \<input_fasta_file\> \<output_fasta_file\> \<minimum_length\>

- Select fasta sequences with headers that match IDs in input list (one column table):

     Usage: select_fasta_sequences_by_id.pl \<file_with_sequence_IDs_list\> \<input_fasta_file\> \<output_fasta_file\> 

- Split Illumina multiplexed fastq file entries by barcode, using a table of sample names and their corresponding barcodes:

     Usage: split_fastq_by_barcode.pl \<sample_barcode_table.txt\> \<fastq_file\> \<read 1 or 2\> \<instrument_name\> \<barcode_length\> \<barcode_Levenshtein_distance\>

