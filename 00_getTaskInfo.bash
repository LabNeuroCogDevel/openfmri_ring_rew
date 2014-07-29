#!/usr/bin/env bash
beares="$HOME/rcn/bea_res"
taskInfo=txt/taskInfo
[ -d $taskInfo ] || mkdir -p $taskInfo
for f in $beares/MR_Scanner_Experiments/Scanner\ Tasks/BIRC\ tasks/*RING\ Chuck*es;do
 filename="$taskInfo/$(basename "$f"|perl -pe 's/\s+//g' )";
 [ -r "$filename" ] || cp "$f" "$filename"


  # create timing from eprime schedual
  perl -lne '
    BEGIN{
      $totaltime=0;
      $count=0;
      %key=(disacq=>6000,
        fix=>1500,
        neutral=>1500*3,
        reward=>1500*3,
        Catch1=>1500*2,
        Catch2=>1500
       );

     # build chucks monstrosity: individually named procedures for each dot location
     for my $r (qw/neutral reward/){
        $key{$r.$_}=$key{$r} for qw/007 108 214 426 532 633/;
        $key{$r.$_}=$key{$_} for qw/Catch1 Catch2/;
     }
    }


    if(/^Levels\([0-9]+\).ValueString="(.*)"/){

     my @trial=split(/\\t/,$1);
     next unless $key{$trial[2]}; # skip lines we dont have a key for (this is done or taskrewars -- junk)

     # print the line if its not a fix
     print join("\t",$totaltime/1000,@trial[2,3],$count) if $trial[2] !~ /fix|disacq/;

     # increates total time
     my $time=$trial[0]*$key{$trial[2]};  # numresp*known time = time of this thing
     $totaltime+=$time;
     $count+=$trial[0];

    }
    print STDERR  "Wrong Timing!! $count: $totaltime" if $count>140 and $totaltime!=(60*5+9)*1000; # total time should be 5min 9sec
    ' \
 "$filename" > "txt/$(basename $filename .es).txt"
 # R
 #  wide <- do.call(cbind,lapply(as.list(Sys.glob('txt/0*Chuck*txt')),function(x){a<-read.table(x,sep="\t")[,c(1,2)]}))
done
