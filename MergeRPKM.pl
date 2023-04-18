# ceci est un script qui permet la génération des plots de corélation des RPKM
#!/usr/bin/perl -w


use strict;
use warnings;
no warnings 'uninitialized';

my $to_remove_from_file_title = "/home/Rnaseq/Cufflinks/"; 

 
my $to_remove_from_file_title1 = "/genes.fpkm_value"; 
my $to_remove_from_file_title2 = "/cufflinks_hg19"; 
my $to_remove_from_file_title3 = "/cufflinks_ERCC92"; 
my @header; $header[0] = "Gene_id";



my %output_table;
for (my $i = 0; $i <= $#ARGV; $i++) {
    if (-e($ARGV[$i])) {
	open (F, $ARGV[$i]) or die "Cannot open file: ".$ARGV[$i]."\n";
	while(<F>) {
	    $_ =~ /^([^\t]+)\t([0-9]+)/;
	    $output_table{$1}[$i] = $2; 
	}
	close F;
	my $title = $ARGV[$i];
	$title =~ s/$to_remove_from_file_title//;
	$title =~ s/$to_remove_from_file_title1//;
	$title =~ s/$to_remove_from_file_title2//;
	$title =~ s/$to_remove_from_file_title3//;
	push @header, $title;
    } else {
	print STDERR "invalid parameter: ".$ARGV[$i].""; exit;
    }
}

print join("\t", @header)."\n";
foreach (sort {$a cmp $b;} keys %output_table) {
    print $_."\t";
    print join("\t", @{$output_table{$_}})."\n";
}
# paste <file1> <file2> <file3> <file4>| awk '{print $1,$2,$4,$8}'
