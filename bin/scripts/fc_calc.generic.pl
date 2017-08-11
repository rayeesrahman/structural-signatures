#!/usr/bin/perl -w 
use strict ; 

my $a = shift @ARGV || 0 ; #die "need values" ; 
my $b = shift @ARGV || die "bg value" ; #need file with value" ; 

sub log10 {
    my $n = shift;
    return log($n)/log(10);
}

my $val = $a / $b ; 
print log10($val) , "\n" ; 
