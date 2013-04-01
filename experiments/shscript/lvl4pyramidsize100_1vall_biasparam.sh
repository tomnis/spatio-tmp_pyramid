#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; lvl4pyramidsize100_1vall($1, $2); exit;"
