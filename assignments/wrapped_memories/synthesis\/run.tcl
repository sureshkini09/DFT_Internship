read_lib /jk/SCLPDK_V3.0_KIT/scl180/memory/spram/4M1L/SPRAM_64x64/SPRAM_64x64_min.lib /jk/SCLPDK_V3.0_KIT/scl180/memory/spram/6M1L/SP_SRAM_spram_8192_32/spram_8192_32_min.lib ../../../inputs/lib/slow.lib
read_hdl ../scl_32768x33.v
elaborate
syn_gen
syn_map
syn_opt
write_hdl > scl_32768x33_syn.v
