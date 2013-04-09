#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; try_gigapool($1); exit;"
