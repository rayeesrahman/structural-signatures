#!/usr/bin/perl -w
use strict; 
use warnings ; 
use 5.10.1 ; 
use Data::Dumper; 

my $non = shift || die "need all non nib folds  (tmp_dir/2_non.undergenes.over/underfolds.csv )" ; 
my $nib = shift || die "need nib mat (tmp_die/2_nib.over/undergenes.overfolds.mat)" ; 
my $thres = shift || die "need threshold number of counts to remove folds " ; 

my %non_fam ;
my %non_fam_fix; 

open(NON , "<$non" ); 
while(<NON>)
{
    chomp; 
    my @dat = split "," , $_ ; 
    my $famname = $dat[2] ; 
    $famname =~ s/\-/^/g ;
	$famname =~ s/\//\|/g ;
	$famname =~ s/\s+/_/g ;
	$famname =~ s/\r//g ; 
    $non_fam_fix{$famname} = $dat[2] ; 
    $non_fam{$famname}++ ; 
}
close NON ; 


open(NIB, "<$nib") ; 
my @nib = <NIB> ; 
my $header = $nib[0] ; 
my @header = split "," , $header ; 
my $header_counter = 0 ; 
my %header_to_remove ; 
foreach my $famname ( @header )
{
    $famname =~ s/\-/^/g ;
	$famname =~ s/\//\|/g ;
	$famname =~ s/\s+/_/g ;
	$famname =~ s/\r//g ;

    if (exists $non_fam{$famname} )
    {
        if  ($non_fam{$famname} >= $thres )
        {
            $header_to_remove{$header_counter} = 1 ;
        } 

    } 
    $header_counter++ ;
}

foreach my $line (@nib) 
{
    chomp $line ;
    my @dat = split "," ,  $line ; 
    my @final_out ; 
    my $colnum = 0 ; 
    foreach my $col (@dat)
    { 
        if (exists $header_to_remove{$colnum} )
        {
            #push @final_out, $col ;  
        }
        else
        {
            push @final_out, $col ;
        }
            $colnum++ ;
     }
    say join "," , @final_out ; 
}

