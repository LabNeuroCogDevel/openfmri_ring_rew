#!/usr/bin/env bash
uploaddir=$(cd $(dirname $0)/..; pwd)/
host=openfmri #lonestar.tacc.utexas.edu # but through a proxy because we're blocked
echo "uploading $uploaddir to $host"
## upload files to openfmri
rsync --checksum -nLrzvhi --exclude scripts/.git --exclude scripts/Raw/  --exclude scripts/tmp/  --exclude scripts/Raw_nii/ \
 $uploaddir lncd@$host:/corral-repl/utexas/poldracklab/openfmri/inprocess/pitt/ring_rew 

ssh lncd@$host '/corral-repl/utexas/poldracklab/software_lonestar/local/bin/fixperms /corral-repl/utexas/poldracklab/openfmri/inprocess/pitt/ring_rew'
