#!/usr/bin/env perl

use strict;

my $topic = 50;
my @pz_dw;

my $pre = "";
my @Nz;
my $user = "";
my %storys = ();
while(chomp(my $line = <STDIN>))
{
    next if $line eq $pre;
    $pre = $line;

    my($u, $s, $cnt) = split /\t/, $line;
    for(my $i = 0; $i < $topic; $i++)
    {
        my $rd = rand();
        $Nz[$i] += $rd;
        print "$s\t0_s_z\t$i\t$rd#data\n";  #p(s|z)对应的计数,N(s,z)
    }
    
    if($u ne $user)
    {
        &init($user) if $user ne "";
        $user = $u;
        undef %storys;
        %storys = ();
    }
    $storys{$s} += $cnt;
}
&init($user);

for(my $k = 0; $k < $topic; $k++)
{
    print "\t$k\t$Nz[$k]#topic\n";  #p(s|z)对应的分母，N(z)
}

sub init
{
    my $u = shift;
    my $norm = 0;
    my @pu_z;
    for(my $i = 0; $i < $topic; $i++)
    {
        my $rd = rand();
        $pu_z[$i] = $rd;
        $norm += $rd;
    }
    for(my $i = 0; $i < $topic; $i++)
    {
        $pu_z[$i] /= $norm;
        foreach my $k(keys %storys)
        {
            print "$k\t1_z_u\t$u\t$i\t$pu_z[$i]\t$storys{$k}\t#data\n";  #p(z|u)初始化
        }
    }
}
