#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; lvl2pyramidsize1000($1); exit;"
