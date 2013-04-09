#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; load gigapool3; leave_one_out_sw('/u/tomas/thesis/results/leave_one_out_gigapool3v/', gigapool, $1); exit;"
