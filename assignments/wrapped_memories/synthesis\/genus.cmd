# Cadence Genus(TM) Synthesis Solution, Version 20.11-s111_1, built Apr 26 2021 14:57:38

# Date: Fri May 02 16:45:40 2025
# Host: APL9.kletech.ac.in (x86_64 w/Linux 4.18.0-425.3.1.el8.x86_64) (6cores*12cpus*1physical cpu*12th Gen Intel(R) Core(TM) i5-12500 18432KB)
# OS:   Red Hat Enterprise Linux release 8.7 (Ootpa)

read_lib /jk/SCLPDK_V3.0_KIT/scl180/memory/spram/6M1L/SPRAM_2048x36/SPRAM_2048x36_min_SP.lib ../../../inputs/lib/slow.lib
read_hdl ../scl_2048x36.v
elaborate
syn_gen
syn_map
syn_opt
write_hdl > scl_16384x36_syn.v
