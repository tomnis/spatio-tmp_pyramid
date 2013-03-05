#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; lvl4pyramidsize300($1); exit;"
