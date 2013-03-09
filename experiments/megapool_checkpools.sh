#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; try_megapool_checkpools($1); exit;"
