#!/usr/bin/perl -w 
use strict; 
use v5.10;
my $file = shift @ARGV || die "need hhpred our as arg 1 " ;
my $scop = shift @ARGV || die "need scop_families3 arg 2 " ;

my %fold_info ;
my %scops ;  
open(HHR, "<". $file) ;
open(SCOP, "<". $scop) ;
while(<SCOP>)
{
	chomp ;
	my ($fold,$annot) = split (/\|/, $_); 
	$scops{$fold} = $annot ;
}
close SCOP ;
while(<HHR>)
{
	chomp  $_;
	next unless $_ =~ m/^\s+[0-9]+/gi ; 
	chomp $_ ;
	my @data = split ('\s+', $_) ;
	$data[3] =~ m/([a-z]\.[0-9]+\.[0-9]+\.[0-9]+)/gi; 
	my $fold = $1 ; 
	my $prob ; 
	foreach my $info (@data)
	{
		next unless $info =~ m/^[0-9]+\.[0-9]$/gi ; 
		$prob = $info ; 
		last ;
	}

	next if $prob < 70 ; 
	$fold_info{$fold} =  $prob ; 
}
close HHR; 
$file =~ m/[\/]+(\S+).hhr$/ ; 
my $name  = $1 ;
foreach my $fold ( keys %fold_info)
{
	say  "$name,$fold,", $fold_info{$fold}  , "," , $scops{$fold} ;  
	next if exists $scops{$fold} ; 
	
	#say "## $fold" 	; 
}