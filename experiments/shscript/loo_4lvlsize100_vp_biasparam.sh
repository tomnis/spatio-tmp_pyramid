#!/bin/sh

cd /u/tomas/thesis
echo $2
matlab -nodesktop -r "setup; load allpyramidslvl4size100; leave_one_out_sw_varypoolsize('/u/tomas/thesis/results/leave_one_out_b$2/leave_one_out_4lvlsize100_varypoolsize/', allpyramids{$2}{1}, $1); exit;"
