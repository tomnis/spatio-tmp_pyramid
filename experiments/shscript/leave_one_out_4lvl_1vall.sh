#!/bin/sh

cd /u/tomas/thesis
echo bias type $2
echo pool size $3
echo boosting rounds $4
matlab -nodesktop -r "setup; load allpyramidslvl4size100; leave_one_out_sw_1vall('/u/tomas/thesis/results/leave_one_out_b$2/pyramids4lvlsize$3_1vall/', allpyramids{$2}{1}, $1, $3, $4); exit;"
