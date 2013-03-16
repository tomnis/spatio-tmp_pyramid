#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; lvl4pyramidsize300_mult_pats($1); exit;"
