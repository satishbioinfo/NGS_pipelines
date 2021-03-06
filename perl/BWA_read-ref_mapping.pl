#!/usr/bin/perl
### Author: Satishkumar R G #####
### bioinformatics (dot) satish (at)gmail (dot)com #####

### Script Description: Performs mapping of Paired End data reads to the reference #####
#######################################################

use strict;
use warnings;
use Getopt::Long;
exit(main());

sub main{
my $settings={};
GetOptions ($settings, qw (idir=s odir=s rpath=s));
my $indir = $$settings{idir} or die usage ();
my $outdir = $$settings{odir} or die usage ();
my $ref = $$settings{rpath} or die usage ();
mapmodule ($indir, $outdir, $ref);
return 0;
}

##### Step1 : Mapping Module -- Performs mapping using BWA meme #####
#####################################################################

sub mapmodule{

my ($indir, $outdir, $ref)=@_;

opendir (DIR, "$indir") or die "unable to open $!";
my @list = grep /\.fastq/, readdir DIR;
close DIR;

my %hash;

for (my $i=0; $i<= $#list; $i++)
{
chomp ($list[$i]);
print "$list[$i]\n";
my @a = split(/\_/,$list[$i]);
$hash{$a[0]} = " ";
}
############################
### Creating a map folder ##
############################

my $mapfold = $outdir."Map_folder";

system ('mkdir $mapfold');
system ('chmod 777 -R $mapfold');

########################################
### Creating a  SAM folder map folder ##
########################################

my $smfold = $mapfold."/SAM";

system ('mkdir $smfold');
system ('chmod 777 -R $smfold');

chomp($ref);

foreach my $key (sort keys %hash){
my $inf1 = $indir.$key."_R1.fastq";
my $inf2 = $indir.$key."_R2.fastq";

print "$inf1\n$inf2\n";

my $ofile = $smfold."/".$key.".sam";

print "$ofile\n";
####################################################

###### Add your BWA Path here ####################

system ("/home/satishk/bwa-0.7.17/bwa mem $ref $inf1 $inf2 >$ofile");

####################################################
print "Completed Mapping Sample :".$key."\n";
}
return 1;
}

sub usage{
"Performing Mapping using bwa
Usage $0 -i <Input folder> -o <Output Folder> -r <reference genome>";
}
