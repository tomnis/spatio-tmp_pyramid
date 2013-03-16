#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; try_megapool($1); exit;"
