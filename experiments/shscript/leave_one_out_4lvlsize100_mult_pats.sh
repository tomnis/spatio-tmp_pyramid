#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; load allpyramidslvl4size100; leave_one_out_sw_mult_pats('/u/tomas/thesis/results/leave_one_out_4lvlsize100_mult_pats/', allpyramids{3}{1}, $1); exit;"
