#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; load allpyramidslvl4size100; lvl4pyramidsize100_maxerr($1, $2); exit;"
