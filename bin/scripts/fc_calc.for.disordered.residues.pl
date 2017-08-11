#!/usr/bin/perl -w 
use strict ; 

my $a = shift @ARGV || 0 ; #die "need values" ; 
my $b = shift @ARGV || die "need file with value" ; 

open(F,"<$b") ; 
my @d=<F> ; 

sub log10 {
    my $n = shift;
    return log($n)/log(10);
}

if ($d[0] == 0 ) 
{
	$d[0] = .01 ;  
}

my $val = $a / $d[0] ; 
print log10($val) , "\n" ; 