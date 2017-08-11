#!/usr/bin/perl -w
use strict;
use 5.10.1 ; 
my $f1 = shift || die "need test gene set as arg 1" ;
my $f2 = shift || die "need background gene set as arg 2" ;

my %dat ;

open(F, "<$f1" );
open(FF, "<$f2") ;

while(<F>)
{
    chomp ;
    my @d = split(",") ;
    $dat{$d[1]} = $d[0] ;
}
while(<FF>)
{
    chomp ;
    my @d = split(",");
    if ( exists $dat{$d[1]})
	 {
		my $l = log($dat{$d[1]} / $d[0]);
	    my $fc = $l /log(10) ;
	    say "$d[1]\t$fc" ; 
	 }
}
	     
