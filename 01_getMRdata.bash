#!/usr/bin/env bash

# update google doc if we haven't checked this month
# curl valid 2014-07-29, after making link world viewable and exporting to web
if [ -n "$(find txt/ -name scanSheets.txt -mtime +30d)" ]; then
 curl -L 'https://docs.google.com/spreadsheets/d/1kzNxuRPnyalaG5K66ADFIavJOYfQl5OXQSmudNwc0Ak/export?format=tsv' > txt/scanSheets.txt
fi

# sub001	10133	20070131	ANTI	9.7960	F	070131164507	2007-01-31 00:00:00	1997-04-15 00:00:00
perl -slane 'next if /VGS/; print if !$a{$F[0]}; $a{$F[0]}++' txt/demographicsFromSQL.txt | while read \
 subjid lunaid visitdate type age sex bircid dates; do
 # remove leading 0 so we can match the sheet
 no0birc=$bircid
 while [ "${no0birc:0:1}" == "0" ]; do no0birc=${no0birc:1}; done

 echo $bircid
 grep ${no0birc} txt/scanSheets.txt
 echo
done
