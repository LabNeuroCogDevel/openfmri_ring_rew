#!/usr/bin/env bash
#set -xe
#
# use bea_res eye data file structure 
# and SQL database export 
# to find all BIRID+LUNA IDs and visit dates
# for all ring reward people
#
# WF 20140734
#

#lncddb.acct.upmchs.net (10.145.64.124)
beares="$HOME/rcn/bea_res"
# save file
demotxt="txt/demographicsFromSQL.txt"

# vars to name subjects
luanidold=0
subid=1;
for task in ANTI VGS; do
for d in $beares/Data/Tasks/RingRewards$task/Basic/*/*/; do
 lunaid=$(basename $(dirname $d))
 scandate=$(basename $d)
 printf "$lunaid	$scandate	$task	"
 mysql -u lncd  -h lncddb.acct.upmchs.net  lunadb_nightly -BNe "
    select datediff(log.VisitDate,DateOfBirth)/365.25 as age,
          case sexID when 1 then 'M' when 2 then 'F' else '?' end as sex, 
          b.BIRCID, Diagnosed+Clinical
    from tbircids as b join tsubjectinfo as i on b.lunaid=i.lunaid 
    join tvisitlog as log on log.VisitID=b.VisitID
    where b.lunaID = $lunaid and
          date_format(log.VisitDate,'%Y%m%d') = $scandate;" |tr -d "\n"
 echo
done; done | sort | while read lunaid  rest; do
 [[ "$rest" =~ (1|2)$ ]] && echo "$lunaid $scandate $task is clinical?" 1>&2 && continue
 [ "$lunaid" != "$luanidold" ] && let count++
 luanidold=$lunaid

 printf "sub%03d	$lunaid	$rest\n" $count
done|tee $demotxt
