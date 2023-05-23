#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
else
  echo "args:"
  for i in $*; do 
    echo $i 
  done
  echo ""
fi


if [ "${1}" == "yes" ]; then 
  run_capsule="yes"
else
  run_capsule="no"
fi


if [ -z ${2} ]; then
  all_rpm=$(find -L ../data -name "*rpm*")
else
  all_rpm=${2}
fi 


if [ -z ${3} ]; then
  metadata=$(find -L ../data -name "Metadata*")
else
  metadata=${3}
fi 


if [ -z ${4} ]; then
  target_list=$(find -L ../data -name "*arget*")
else
  target_list=${4}
fi 



# if [ -z ${3} ]; then
#   treatment=
# else
#   treatment=${3}
# fi 