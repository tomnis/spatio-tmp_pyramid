#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; try_gigapool_checkpools($1); exit;"
