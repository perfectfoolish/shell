#!/bin/bash

function he()
{
  x=2
  num=1
  until [ $x -eq 51  ]
  do 
  num=$(($x+$num))
  x=$(($x+1))
  done
  echo "$num"
}
he
