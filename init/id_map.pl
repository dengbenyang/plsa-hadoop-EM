#!/usr/bin/env perl

use strict;

my %hash;
open(DICT, "dict") or die "$!\n";
while(chomp(my $line = <DICT>))
{
    my @pieces = split /\t/, $line;
    $hash{$pieces[0]} = 1;
}
close DICT;

while(chomp(my $line = <STDIN>))
{
    my @pieces = split /\t/, $line;
    my @words = split /\s/, $pieces[1];
    foreach my $w(@words)
    {
        if(defined($hash{$w}))
        {
            print "$pieces[0]\t$w\t$hash{$w}\n";
        }
    }
}
