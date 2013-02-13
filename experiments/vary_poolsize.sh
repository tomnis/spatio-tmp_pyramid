#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; vary_poolsize; save(condor_poolsize);"
