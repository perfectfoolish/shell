#!/bin/bash

function paixu()
{
  for a in $*
  do 
    echo $a
  done | sort -n
}
paixu $*
