#!/bin/bash - 
#===============================================================================
#
#          FILE: ID_if_forrevreadidsareidenticalinsam.sh
# 
#         USAGE: ./ID_if_forrevreadidsareidenticalinsam.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 01/23/20 16:47
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
read1=$1
read2=$2
val=$(echo $read1 | awk '$NF ~/.gz$/ {printf "zipped"}$NF !~/.gz$/ {printf "unz"}')
if [[ $val == "zipped" ]];then
echo $(zcat $read1 | head -n1 | awk '{print $1}') $(zcat $read2 | head -n1 | awk '{print $1}') | awk '$1==$2{print "2"} $1 !=$2 {printf "1"}'
else
	echo $(cat $read1 | head -n1 | awk '{print $1}') $(cat $read2 | head -n1 | awk '{print $1}') | awk '$1==$2{print "2"} $1 !=$2 {printf "1"}'
fi

