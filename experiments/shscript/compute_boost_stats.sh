#!/bin/sh

cd /u/tomas/thesis
echo $1
matlab -nodesktop -r "setup; stats=compute_boost_stats(500, 10, 3, '$1'); save(stats$1500);"
