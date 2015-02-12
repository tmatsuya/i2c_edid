BOARD_SRC=$(wildcard $(BOARD_DIR)/*.v)

EDID_SRC=$(wildcard $(CORES_DIR)/i2c_edid/rtl/*.v)

CORES_SRC=$(EDID_SRC)
