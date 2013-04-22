#!/bin/sh

cd /u/tomas/thesis
echo "usage: <run number> <bias type> <pool size> <boosting rounds> <number levels>"
echo run $1
echo bias type $2
echo pool size $3
echo boosting rounds $4
echo pyramid lvls $5
matlab -nodesktop -r "setup; load allpyramidslvl$5size100; leave_one_out_sw_1vall('/u/tomas/thesis/results/leave_one_out_b$2/pyramids$5lvlsize$3_1vall/', allpyramids{$2}{1}, $1, $3, $4); exit;"
