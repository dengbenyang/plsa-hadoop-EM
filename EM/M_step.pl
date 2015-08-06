#!/usr/bin/env perl

use strict;

my $topic = 50;
my $story = "";
my $user = "";
my $all  = 0;
my @sz; ##story, topic count
my @zu; ##topic distribute on docs
my @nz; ##topic all val cnt
my %storyset;

while(chomp(my $line = <STDIN>))
{
    my @pieces = split /\t/, $line;

    if(index($pieces[0], "") == 0)
    {
        $nz[$pieces[1]] += $pieces[2];
    }
    elsif($pieces[1] eq "0_s_z")
    {
        if($pieces[0] eq $story)
        {
            $sz[$pieces[2]] += $pieces[3];
        }
        else
        {
            &printSz($story);
            $story = $pieces[0];
            $sz[$pieces[2]] = $pieces[3];
        }
    }
    elsif($pieces[1] eq "1_z_u")
    {
        if($pieces[0] ne $user)
        {
            &printZu($user, $all);
            $user = $pieces[0];
            $all = 0;
        }
        $storyset{$pieces[3]} = $pieces[5];
        $zu[$pieces[2]] += $pieces[4];
        $all += $pieces[4];
    }
}

&printSz($story);
&printZu($user, $all);

for(my $k = 0; $k < $topic; $k++)
{
    print "\t$k\t$nz[$k]#topic\n";
}

###############function defined###########################
sub printSz
{
    my $story = shift;
    return if $story eq "";
    for(my $k = 0; $k < $topic; $k++)
    {
        print "$story\t0_s_z\t$k\t$sz[$k]#data\n";
    }
    undef @sz;
    @sz = ();
}

sub printZu
{
    my $user = shift;
    my $all = shift;
    return if $user eq "";
    return if $all == 0;
    for(my $k = 0; $k < $topic; $k++)
    {
        my $val = $zu[$k]/$all;
        foreach my $kk(keys %storyset)
        {
            print "$kk\t1_z_u\t$user\t$k\t$val\t$storyset{$kk}#data\n";
        }
    }
    undef @zu;
    undef %storyset;
}
