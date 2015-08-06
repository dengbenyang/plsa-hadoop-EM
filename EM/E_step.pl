#!/usr/bin/env perl

use strict;


###############################
#计算p(s,u,z,参数)
#=p(z|u)*p(s|z)
#=p(z|u)*N(s,z)/N(z)
##############################

my $topic = 50;
my @Nz;
open(FILE, "topic") or die "$!\n";
while(chomp(my $line = <FILE>))
{
    my @pieces = split /\t/, $line;
    $Nz[$pieces[1]] += $pieces[2];
}
close FILE;

my $u = "";
my @nz;  ###update news topic all cnt
my $story = "";
my @sz; ##story count in topic dsitribute
my @suz = ();
my $all = 0;


while(chomp(my $line = <STDIN>))
{
    my @pieces = split /\t/, $line;
    
    if($pieces[1] eq "0_s_z")
    {
        if($pieces[0] eq $story)
        {
            $sz[$pieces[2]] += $pieces[3];
        }
        else
        {
            &printALL($u);
            $u = "";
            $story = $pieces[0];
            undef @sz;
            $sz[$pieces[2]] = $pieces[3];
        }
    }
    elsif($pieces[1] eq "1_z_u")
    {
        ####filed name: story label user topic p(z|u)
        if($pieces[0] eq $story)
        {
            my ($story, $label, $user, $t, $prob, $cnt) = @pieces;
            my $pz_us = $prob*$sz[$t]/$Nz[$t];
            if($user eq $u)
            {
                $suz[$t] += $pz_us;
                $all += $pz_us;
            }
            else
            {
                if($all > 0)
                {
                    my $val = int(1000*log($all));
                    print STDERR "reporter:counter:EM_parameter,log-likely,$val\n";
                }
                &printALL($u, $cnt);
                $u = $user;
                @suz = ();
                $suz[$t] = $pz_us;
                $all = $pz_us;
            }
        }
    }
}
&printALL($u);

for(my $k = 0; $k < $topic; $k++)
{
    print "\t$k\t$nz[$k]\n";
}

#####################################################
sub printALL
{
    my $u = shift;
    my $cnt = shift;
    return if $u eq "";
    return if $all == 0;
    for(my $k = 0; $k < $topic; $k++)
    {
        my $unit = $suz[$k]/$all;
        print "$story\t0_s_z\t$k\t$unit\n";
        $nz[$k] += $unit;
        print "$u\t1_z_u\t$k\t$story\t$unit\t$cnt\n";
    }
}
