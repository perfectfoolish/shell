#!/bin/bash
#check peer status

while [[ true ]]; do
    sleep 1;
    ceictims -vvvvvvvvvrx "sip show peers like $1" | grep $1 
done
