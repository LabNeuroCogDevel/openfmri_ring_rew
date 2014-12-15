#!/usr/bin/env bash

set -e
# neutral, reward X cue, prep, resp (correct only)
cd $(dirname $0)

ofmriDir="../"
task=task001
model=model001
modelsdir=$ofmriDir/models/$model
[ ! -r $modelsdir ] && mkdir -p $modelsdir
cat > $modelsdir/condtion_key.txt <<EOF 
$task cond001 correct reward cue
$task cond002 correct reward prep
$task cond003 correct reward resp
$task cond004 correct neutral cue
$task cond005 correct neutral prep
$task cond006 correct neutral resp

EOF


# go through each subjects behavioral
for bd in $ofmriDir/sub*/behav/task001_run*/behavdata.txt; do 

  [[ "$bd" =~ (sub[0-9]{3}).*task001_(run[0-9]{3}) ]] || continue
  subj=${BASH_REMATCH[1]}
  run=${BASH_REMATCH[2]}

  modelrun="$ofmriDir/$subj/model/$model/onsets/task001_$run"
  [ ! -r $modelrun ] &&  mkdir -p $modelrun


  ## write condition

  # $bh -- behav file looks like
  # trial, trgt XDAT, score, latency , onset of cue (seconds), EPrime frame,dot position, EP num
  #   1  164   2  350   0  neutral426  426   0
  #   2  181   1  483   6  reward007   7     2

  [ $(ls $modelrun | wc -l) -gt 0 ] && rm $modelrun/cond*.txt
  #  Order:   Cue (1.5s) | Red Centered Cross (1.5s) | Dot (1.5s)  |
  sed 1d $bd | while read t xdat score lat onset  frame  pos epnum; do
     case "$score$frame" in
      1reward*)   n=0;;
      1neutral*)  n=1;;
      *)          continue;;
     esac

     # all events are 1.5 (1 TR) long
     # all trials are weighted equally (hence the last "1")
     for event in 0 1 2; do
        tonset=$(perl -e "print $onset+1.5*$event")
        condn=$(printf %03d $((($event+1 + $n*3))) )
        # 1 = cue, 2 = prep, 3 = resp | reward
        # 4        5         6        | neutral
        echo -e "$tonset\t1.5\t1" >>  $modelrun/cond$condn
     done
  done


done

