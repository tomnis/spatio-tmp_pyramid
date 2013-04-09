#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; try_megapool_mult_pats($1); exit;"
