setMode -bscan
setCable -p auto
identify
assignfile -p 1 -file top.bit
program -p 1
quit
