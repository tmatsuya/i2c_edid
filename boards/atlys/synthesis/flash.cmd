setMode -bscan
setCable -p auto
identify -inferir
identifyMPM
attachflash -position 1 -spi "N25Q128"
assignfiletoattachedflash -position 1 -file top.mcs
Program -p 1 -dataWidth 1 -spionly -e -v -loadfpga 
closeCable
quit 
