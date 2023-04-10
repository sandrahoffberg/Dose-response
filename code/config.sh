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


if [ -z ${1} ]; then
  all_rpm=$(find -L ../data -name "*rpm*")
else
  all_rpm=${1}
fi 


if [ -z ${2} ]; then
  metadata=$(find -L ../data -name "metadata")
else
  metadata=${2}
fi 


if [ -z ${3} ]; then
  treatment=
else
  treatment=${3}
fi 


if [ -z ${4} ]; then
  target_list=$(find -L ../data -name "target*")
else
  target_list=${4}
fi 


if [ -z ${5} ]; then
  dose_response_fits=$(find -L ../data -name "dose")
else
  dose_response_fits=${5}
fi 


if [ -z ${6} ]; then
  gene=
else
  gene=${6}
fi 
