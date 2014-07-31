#!/usr/bin/env bash

# update google doc if we haven't checked this month
# curl valid 2014-07-29, after making link world viewable and exporting to web
if [ -z "$(find txt/ -name scanSheets.txt -mtime -30d)" ]; then
 curl -L 'https://docs.google.com/spreadsheets/d/1kzNxuRPnyalaG5K66ADFIavJOYfQl5OXQSmudNwc0Ak/export?format=tsv' > txt/scanSheets.txt
fi

# mount wallace here
[ ! -d Raw/050715115003 ] && sshfs foranw@wallace:/data/Luna1/Raw/BIRC Raw


# sub001	10133	20070131	ANTI	9.7960	F	070131164507	2007-01-31 00:00:00	1997-04-15 00:00:00
perl -slane 'next if /VGS/; print if !$a{$F[0]}; $a{$F[0]}++' txt/demographicsFromSQL.txt | while read \
 subjid lunaid visitdate type age sex bircid dates; do

 ### get scan number for each run

 # remove leading 0 so we can match the sheet
 no0birc=$bircid
 while [ "${no0birc:0:1}" == "0" ]; do no0birc=${no0birc:1}; done

 # 1-based index fields of interest:
 # 6 7 8 9     (Anti, VGS is 10 11 12)
 # 13 14 15 16 (Anti only)
 #BIRC            date            luna    age   sex     mprage     Ring_Reward_Anti                 Ring_Reward_Vgs         Chuck_Ring_Reward       
 #80104154413     1/4/2008        10483   15      m     4           9       10      11      12      6       7       8
 read mprage r1 r2 r3 r4 <<< $(perl -slane "BEGIN{@a=(0)x5}; next unless /${no0birc}/;\$a[0]=\$F[5];  \$a[\$_]|=join(\"\t\",@F[5+\$_,12+\$_]) for (1..4); print \"@a\";  " txt/scanSheets.txt)
 # skip anyone who has no runs, mprage+runs are 0 0 0 0 0 if the bircid is known, is undefined otherwise
 [ -z "$mprage" ] && echo "$lunaid/$visitdate:$bircid NO SCANSHEET" && continue

 echo "$lunaid/$visitdate ($bircid)"

 for run in mprage r1 r2 r3 r4; do
   
   [ -z "${!run}" -o ${!run} -eq 0 ] && echo "$lunaid/$visitdate/$rn NO RUN" && continue

   filename=${lunaid}_${visitdate}-$bircid-$run-${!run}
   echo -e "\t$run: $filename"

   ## generate nii.gz files for each mprage/run
   # a bunch of junk files get output by dimon
   # so do this in a tmp dir
   if [ ! -r Raw_nii/$filename.nii.gz  ]; then
     cd tmp
     Dimon -infile_pattern "../Raw/$bircid/${!run}/*dcm" -dicom_org -gert_write_as_nifti  -gert_to3d_prefix "$filename" -gert_create_dataset -gert_outdir ../Raw_nii/ 
     gzip ../Raw_nii/$filename.nii 
     3dNotes -h "# lunaid=$lunaid visitdate=$visitdate scanid=$bircid ANTIrun=$run scannum=${!run} age=$age sex=$sex" ../Raw_nii/$filename.nii.gz
     cd -
   fi
 done
 
done

umount Raw

# everything makes sense:
# for n in *nii.gz; do read birc <<< $(3dNotes $n 2>/dev/null | perl -lne 'print $1  if m:../Raw/(\d{12})/:'); [ "$birc" = "${n:15:12}" ]; echo "$birc $n"; done

