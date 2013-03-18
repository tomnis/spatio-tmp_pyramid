#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; lvl3pyramidsize500split60($1); exit;"
