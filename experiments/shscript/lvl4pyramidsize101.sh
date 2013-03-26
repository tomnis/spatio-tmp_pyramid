#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; lvl4pyramidsize101($1); exit;"
