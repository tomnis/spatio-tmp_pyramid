#!/bin/sh

cd /u/tomas/thesis
echo $2
matlab -nodesktop -r "setup; load allpyramidslvl4size100perm132ga; leave_one_out_sw_ga_vp('/u/tomas/thesis/results/gatech/leave_one_out_b$2/leave_one_out_4lvlsize100/', allpyramids{$2}{1}, $1); exit;"
