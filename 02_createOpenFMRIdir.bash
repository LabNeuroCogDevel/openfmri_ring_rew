#!/usr/bin/env bash

# link in anatomy/highres001.nii.gz
# link in data for BOLD/task* and anatomy
# writes demographic.txt


openfmridir=".."
study="ringrewad"
[ ! -d $openfmridir ]  && mkdir $openfmridir

# input from demographic file generated by 00_getDemographics.bash
# looks like
#    sub001	10133	20070131	ANTI	9.7960	F	070131164507  0
while read subjid lunaid visit task age sex birc rest; do
   mprage="$(ls $PWD/Raw_nii/${lunaid}_$visit-$birc-mprage-*.nii.gz 2>/dev/null)"
   for i in 1 2 3 4; do
      unset r$i
      printf -v r$i "$(ls $PWD/Raw_nii/${lunaid}_$visit-$birc-r$i-*.nii.gz 2>/dev/null)"
   done
   
   # check that at least something exists
   [ -z "$mprage$r1$r2$r3$r4" ] && echo "NO DATA $subjid $lunaid $visit $birc" && continue

   for var in mprage r1 r2 r3 r4; do
    [ -z "${!var}" ] && echo "$subjid $lunaid $visit $birc: no $var" && continue
    if [ $var == "mprage" ]; then
      newfile="../$subjid/anatomy/highres001.nii.gz"
      runn=""
    else
      runn=${var: -1}
      newfile="../$subjid/BOLD/task001_run00$runn/bold.nii.gz"
    fi

    # create folder and link
    newdir=$(dirname $newfile)
    [ -d "$newdir" ] || mkdir -p $newdir
    [ -r "$newfile" ] || ln -s "${!var}" "$newfile"


    # create taskbehave.txt
    if [ -n "$runn" ]; then
      export scorefile="txt/behave/$lunaid.$visit.Anti.$runn.manual.txt"
      [ ! -r $scorefile ] && echo "NO SCORE $subjid $lunaid $visit $birc $runn: $scorefile" && continue

      order="txt/041609_RINGChuckRewards-v.$runn.txt"
      behavfile="../$subjid/behav/task001_run00$runn/behavdata.txt"
      [ ! -d $(dirname $behavfile) ] && mkdir -p $(dirname $behavfile)
      # paste order file and score file 
      # and 
      #paste <(sed 1d $scorefile) <(grep -v Catch $order) |tee $behavfile
      paste \
        <( cut -f 2-  $scorefile | 
          perl -slane '
            BEGIN{our $i=1;sub pl {print join("\t",($i,-1,-1,-1));$i++}}
            next if $.<=1;
            pl() while($i<$F[0]);
            print; $i++;
            END{pl() while $i<29}' ) \
         <( grep -v Catch $order ) > $behavfile

      # check file is right length and width
      perl -salne 'BEGIN{$a=100}; $a=$#F if($a>$#F); END{print "WARNING: $a $. $ENV{scorefile}" if $a!=7 || $.!=28}' $behavfile
    
    fi



   done

done < txt/demographicsFromSQL.txt 
