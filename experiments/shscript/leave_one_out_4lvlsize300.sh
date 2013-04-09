#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; load allpyramidslvl4size300perm132; leave_one_out_sw('/u/tomas/thesis/results/leave_one_out_4lvlsize300/', allpyramids{3}{1}, $1); exit;"
