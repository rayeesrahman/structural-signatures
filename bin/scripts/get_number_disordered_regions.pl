#!/usr/bin/perl -w
use strict ; 
my $diso = shift @ARGV  || die "need diso without header\n" ; 
my $thres = shift @ARGV  || die "need diso region threshold\n" ; 
my $num = 0 ; 

open(F, "<$diso") ; 
my @dat ; 
while(<F>)
{
	my @data = split("\t",$_) ;
	 
	push @dat , $data[2]; 
}
push @dat, 0 ;
my $i = 0; 
foreach (@dat)
{

	chomp;
	if ($_ > .5)
	{
		$i++ ;
		next ;
	}
	else 
	{
		if ($i >= $thres)
		{
			$num++;
			$i = 0 ; 
			next; 
		}
		else 
		{
			$i=0;
			next ;
		}
		
	}
}
print "$num\n "; 