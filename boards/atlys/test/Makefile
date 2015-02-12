SRC = tb_hdmioverip.v ../../../core/common/datacontroller.v  ../../../core/gmii2fifo48/rtl/gmii_rec.v ../../../core/fifo/test/asfifo.v ../../../core/fifo/test/afifo48.v ../../../core/fifo/test/graycounter.v ../../../core/common/timing.v

tb_system: $(SRC)
	iverilog -o tb_system $(SRC)

clean: 
	rm -f tb_system verilog.log test.vcd

.PHONY: clean isim wave
