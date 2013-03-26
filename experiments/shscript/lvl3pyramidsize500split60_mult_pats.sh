#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; lvl3pyramidsize500split60_mult_pats($1); exit;"
