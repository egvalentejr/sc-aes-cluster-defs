#!/bin/bash
# Run this script to go through all starcluster clusters and tag the 
# corresponding volumes with the instance tags
# 
# Notes:
# Obtain cluster names
# starcluster listclusters 2>/dev/null |grep @sc | awk '{print $1}'
# OR
# starcluster listclusters 2>/dev/null | awk /.*@sc.*/'{print $1}'
# Obtain clusters that are running
# starcluster listclusters 2>/dev/null | awk -F "-" '/.*master.*running.*/ {print $1}'

# Obtain cluster hosts and instance ids
# starcluster listclusters 2>/dev/null | awk '/.*i-.*/ {print $0}' 

for c in `starcluster listclusters 2>/dev/null |grep @sc | awk '{print $1}'`; do
  echo "Cluster: " $c
  for info in `starcluster listclusters $c 2>/dev/null | awk '/.*i-.*/ {print $1"|"$3}'`; do
    h=`echo "$info" | awk -F"|" '{print $1}'`
    i=`echo "$info" | awk -F"|" '{print $2}'`
    echo "  tagging host: $h, $i"
    ./copy_instance_tags_to_volumes.rb $i    
  done
done




