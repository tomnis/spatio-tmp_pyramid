#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; try_gigapool3v($1); exit;"
