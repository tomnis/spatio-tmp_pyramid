#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; load allpyramidslvl3size500perm132; leave_one_out_sw_mult_pats('/u/tomas/thesis/results/leave_one_out_3lvlsize500_mult_pats/', allpyramids{3}{1}, $1); exit;"
