#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; leave_one_out_main; exit;"
