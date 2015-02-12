#!/bin/bash
# KC705 bit image load script
# usage: kc705_load top

CMD_FILE=/tmp/$USER_$$
#PROJECT=$1
PROJECT=top

cd runs/$PROJECT.runs/impl_1

echo setMode -bscan >$CMD_FILE
echo setCable -p auto >>$CMD_FILE
echo identify >>$CMD_FILE
echo assignfile -p 2 -file $PROJECT.bit >>$CMD_FILE
echo program -p 2 >>$CMD_FILE
echo quit >>$CMD_FILE

#cat $CMD_FILE
impact -batch $CMD_FILE
rm -f $CMD_FILE
