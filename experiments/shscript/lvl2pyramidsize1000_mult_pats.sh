#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; lvl2pyramidsize1000_mult_pats($1); exit;"
