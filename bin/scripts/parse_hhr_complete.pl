#!/usr/bin/perl 
use strict;
use 5.14.1 ;

my $file = shift  ||  die "need hhpred input as arg 1" ; 
my $scop = shift || die "need scope total as arg 2 "; 
my $type_ana = shift ||  die "need type class, fold , superfamily , family as arg 3" ;
my $ethres = shift || 10  ; #die "need scop evalue threshold as arg 4";4
my $pthres = shift || 1 ; #die "need pvalue threshold as arg 5 " ;
my $prob = shift || 0 ;  #probabliy as arg 6
my $ident = shift || 0 ; #percent identity as arg 7
my $cover = shift || 0  ; #coverage as arg 8
my %scopid_info ;
my %scops ;

open(HHR, "<" . $file ) ;
open(SCOP, "<"  . $scop ) ;
while (<SCOP>)
{
    chomp ; 
    my ($type, $id, $annot) = split /\|/, $_  ; 
    #$annot =~ s/\r//g ;
	#$annot =~ s/,/:/g ; 
	#$annot =~ s/\-/^/g ;
	#$annot =~ s/\//\|/g ;
	#$annot =~ s/\s+/_/g ; 
    $scopid_info{$type}{$id} = $annot ;  
}

close ( SCOP);
my @hhr = <HHR> ;
foreach (@hhr)
{
	chomp  $_;
	next unless $_ =~ m/^\s+[0-9]+/gi ; 
	chomp $_ ;
	my @data = split ('\s+', $_) ;
	$data[3] =~ m/([a-z]\.[0-9]+\.[0-9]+\.[0-9]+)/gi; 
	my $fold = $1 ; 
    my $prob ; 
	my $pvalue ; 
	my $evalue ; 
    my $col ; 
    my $hhmlen ; 
	for ( my $i =  0 ;  $i < scalar @data ; $i++ ) 
	{
		my $info = $data[$i] ; 
		if ($info =~ m/^[0-9]+\.[0-9]$/gi ) 
		{
			$prob = $info ;
            $evalue = lc($data[$i+1]) ; 
            $pvalue = lc($data[$i+2]) ; 
            $col = $data[$i+5] ; 
            $hhmlen = $data[$i+8] ; 
            $hhmlen =~ s/\(//gi ;
            $hhmlen =~ s/\)//gi ;        
			last;  
		} 
	}
    my $cov = $col / $hhmlen ; 
    $scops{$data[1]}{$fold}{'prob'} =  $prob ; 
    $scops{$data[1]}{$fold}{'evalue'} = $evalue ; 
    $scops{$data[1]}{$fold}{'pvalue'} = $pvalue ; 
    $scops{$data[1]}{$fold}{'coverage'} =  $cov ; 
}

for (my $i = 0 ; $i < scalar @hhr ; $i++ )
{
    next unless $hhr[$i] =~ m/^No / ;
    $hhr[$i] =~ m/No ([0-9]+)/gi ; 
    my $num = $1 ;
    my $l =  $hhr[$i+2] ; 
    my $linfo = $hhr[$i+1] ; 
    my @datinfo = split " " , $linfo ; 
    my $f = $datinfo[1] ; 
    my @dat = split " " , $l ; 
    $dat[4] =~ s/Identities=//gi ; 
    $dat[4] =~ s/%$//gi ; 
    $scops{$num}{$f}{'ident'} = $dat[4] ; 
}
close HHR; 
$file =~ m/\/human_proteome_hhpred\/.+\/(\S+).hhr$/ ; 
my $name  = $1 ;
my %seen ; 
#say "Name,Structure,Probablity,E-value,P-value,Coverage,Percent Identity,Structure Name" ;
foreach my $num (sort {$a<=>$b} keys %scops)
{
    foreach my $fold ( keys %{ $scops{$num} })
    {
        my $ana ; 
        my $t ; 
        if ( $type_ana =~ m/class/i )
        {
            $fold =~ /(^[a-k])\./ ; 
            $t= "class" ;
            $ana = $1 ;
        }
        elsif ( $type_ana =~ m/fold/i )
        {
            $fold =~ /(^[a-k]\.[0-9]+).+/ ; 
            $ana = $1 ;
            $t = "folds"; 
        }
        elsif ($type_ana =~ m/superfamily/i )
        {
            $fold =~ /(^[a-k]\.[0-9]+\.[0-9]+).+/ ; 
            $ana = $1 ;
            $t = "superfamilies";
        }
        else 
        {
            $ana = $fold ;  
            $t = "families"; 
        }
        if ( exists $seen{$ana} )
        {
            next ;
        } 
        else
        {
            if ( $scops{$num}{$fold}{'prob'} >= $prob && $scops{$num}{$fold}{'evalue'} <= $ethres  && $scops{$num}{$fold}{'pvalue'} <= $pthres  && $scops{$num}{$fold}{'coverage'} >= $cover && $scops{$num}{$fold}{'ident'} >= $ident) 
            {
                say "$name,$ana,$scops{$num}{$fold}{'prob'},$scopid_info{$t}{$ana} " ;   
                $seen{$ana} = 1; 
            }
        }
    }
}
#