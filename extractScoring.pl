#!/usr/bin/env perl
## NORMAL ULSAGE
# need to export
# export filebasedir='/mnt/B/bea_res/Data/Tasks/Anti/Basic/'
# extractScoring.pl   
#
## DEGUBING
# export DEBUG=1
# extractScoring.pl  /mnt/B/bea_res/Data/Tasks/Anti/Basic/10166/20050804/Scored/fs_10166_anti.xls

## CODE FROM autoeyescoring/compareToManual.pl



use strict;
use warnings;

use Data::Dumper;
use File::Find;
use File::Basename;
use File::Path;
#use File::Find::Rule;
use Spreadsheet::ParseExcel;
#use Getopt::Std;
#use v5.14;

######
# 
# find all fs*xls files and check %correct against auto
#
# write manual scoring to text file (from xls) if it doesn't already exist
#  as "/txt/$subj.$rundate.$run.manual.txt"
#
#####


$ENV{filebasedir}="~/rcn/bea_res/Data/Tasks/SlotRewards/Basic" if ! $ENV{filebasedir};
my $basedir =$ENV{filebasedir};

my $p = Spreadsheet::ParseExcel->new();


my @scoreSheets;
if(@ARGV) { 
 @scoreSheets=@ARGV; 
} else {
  sub wanted {push @scoreSheets, $File::Find::name if  m:(fs|finalscor).*xls:i};
  find( {wanted => \&wanted,no_chdir=>1,follow=>1}, $basedir );
  #@scoreSheets=qw(/mnt/B/bea_res/Data/Tasks/BarsBehavioral/Basic/10156/20110810/Scored/Run02/fs_10156_bars2.xls
  #                );
  #                #/mnt/B/bea_res/Data/Tasks/BarsBehavioral/Basic/10847/20100920/Scored/Run01/fs_10847_bars1.xls
}
print "looking through ".($#scoreSheets+1)." files\n";
for my $xlsfn (@scoreSheets){
  ################################
  # manual scoring parse
  ################################
  next if $xlsfn =~ /^$/;
  next if $xlsfn =~ /bak/;
  print "looking at: $xlsfn\n" if $ENV{DEBUG};
  my ($subj,$rundate,$run,$type,$scorer)=(0)x5;
  $subj    = $1 if $xlsfn =~ m:/(\d{5})/:;
  $rundate = $1 if $xlsfn =~ m:/(\d{8})/:;
  $type    = $1 if $xlsfn =~ m:(vgs|anti):i;

  my $hasrundir = $xlsfn =~ m:/Run:;
  if($hasrundir) {
   $run     = $1 if $xlsfn =~ m:Run0?(\d):;
  }else{
   #$run     = $1 if $xlsfn =~ m:(\d).xls.*:;
   $run=1;
  }

  my $basename = dirname($xlsfn);
  $basename = dirname($basename) if $hasrundir;

  # for anti this is in subj/date dir b/c there is no rundir
  # for bars and scannerbars this is in subj/date/run#/
  my $xlstxtfn = "txt/behave/$subj.$rundate.$type.$run.manual.txt";
  print "saving to $xlstxtfn\n" if $ENV{DEBUG};
  
  my @trialsacs; # array of trials with an array of hashes lat dlat dacc
  my @manualT;   # array of trials with hash for countToCorrect and fist lat

  if(! -e $xlstxtfn) {

     my $xlsp = $p->parse($xlsfn);
     if(!$xlsp ) { print STDERR "$xlsfn is empty?\n"; next }
     my @worksheets = $xlsp->worksheets();
     if($#worksheets <=0 ) { print STDERR "$xlsfn is empty?\n"; next }
     my $xls    = $worksheets[0];
     my @xdats;
     my @trialA;

     $scorer = $xls->get_cell(1,0)->unformatted();
     $scorer =~ s/scorer:? ?//i;
     $scorer = uc($scorer);
     $scorer =~ s/[^A-Z]//gi;
     $scorer="JP" if $scorer =~ /justin/i;
     $scorer="unknown" if $scorer =~ /^$/;


     my ($rowstart,$rowend) = $xls->row_range();
     my $trial_num=0; # for slotrew, fixations counted as trials, so trial number cannot be trusted
     for my $row (5..$rowend){

      my $tmp = $xls->get_cell( $row, 2 );
      my $trial = $tmp? $tmp->value(): 0;
      last if $trial =~ /^$|-1/;
      $trial_num++ if $row<6 || $xls->get_cell($row-1,2)->value() != $trial;
      $trialA[$trial_num] = $trial; 

      $tmp = $xls->get_cell( $row, 1 );
      my $xdat = $tmp? $tmp->value(): 0;

      $tmp = $xls->get_cell( $row, 6 );
      my $lat   = $tmp? $tmp->value(): -1;

      $tmp = $xls->get_cell( $row, 7 );
      my $dlat  = $tmp? $tmp->value(): -1;

      $tmp = $xls->get_cell( $row, 9 );
      my $dacc  = $tmp? $tmp->value(): -1;
      #print "$row\t$trial\t$lat\t$dlat\t$dacc\n";
      $xdats[$trial_num] = $xdat;
      push @{$trialsacs[$trial_num]}, {dlat=>$dlat,lat=>$lat,dacc=>$dacc} if $dlat > 0;
     }

     for my $trial (1..$#trialsacs){
      my @dlats=map {$_->{dlat}} @{$trialsacs[$trial]};
      my $countToCorrect;
      if   ( scalar(grep(/4/,@dlats) ) > 0 ){$countToCorrect= 2 }
      elsif( scalar(grep(/2/,@dlats) ) > 0 ){$countToCorrect= 0 } 
      elsif( scalar(grep(/1/,@dlats) ) > 0 ){$countToCorrect= 1 }
      else                                  {$countToCorrect=-1 }

      #print "$trial: ";#, join(" ", map {$_->{dlat}} @{$trialsacs[$trial]}), "\n";
      #print $countToCorrect, "\n";
      my $lat=-1;
      my $ttrial=@{$trialsacs[$trial]}[0]->{ttrial} if(@{$trialsacs[$trial]}); 
      $lat = @{$trialsacs[$trial]}[0]->{lat} if(@{$trialsacs[$trial]}>0);
      $manualT[$trial]={xdat=>$xdats[$trial]||-1, count=>$countToCorrect ,lat=>$lat, ttrial=>$trialA[$trial]}
     }

     mkpath(dirname($xlstxtfn)) if( ! -d dirname($xlstxtfn) );
     # write to txt file for faster processing
     if($#manualT>0 and open my $txtfh, '>', $xlstxtfn){
        print "writting $xlstxtfn\n";
        print $txtfh "$scorer\n";
        print $txtfh join("\t",$_,@{$manualT[$_]}{qw/ttrial xdat count lat/})."\n" for (1..$#manualT);
        close $txtfh;
     } else {
      print STDERR "$xlstxtfn not written!(have $#manualT trials in $xlsfn)\n";
     }

  }else{
     open my $txtfh, '<', $xlstxtfn;
     $scorer = <$txtfh>;
     chomp($scorer);
     while(<$txtfh>){
      chomp;
      #read trial count lat into manualT
      my ($trial, $count, $lat) = split(/\t/);
      $manualT[$trial] ={count=>$count ,lat=>$lat };

     }
     close $txtfh;
  }
}

