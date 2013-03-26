#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; lvl3pyramidsize500($1); exit;"
