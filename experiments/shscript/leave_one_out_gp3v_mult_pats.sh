#!/bin/sh

cd /u/tomas/thesis
matlab -nodesktop -r "setup; load gigapool3; leave_one_out_sw_mult_pats('/u/tomas/thesis/results/leave_one_out_gigapool3v_mult_pats/', gigapool, $1); exit;"
