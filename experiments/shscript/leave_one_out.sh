#!/bin/sh

# 4/2: is this deprecated?
cd /u/tomas/thesis
matlab -nodesktop -r "setup; leave_one_out_main; exit;"
