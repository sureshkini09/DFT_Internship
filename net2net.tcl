set_db common_ui false

read_hdl cpu_sys/cpu_sys.v

set_attribute target_library "NangateOpenCellLibrary_slow_conditional_ccs.lib memories/rf_2p_136d_74w_1m_4b.lib memories/rf_2p_256d_76w_1m_4b.lib memories/rf_2p_512d_76w_2m_4b.lib memories/sram_sp_16384d_36w_16m_8b.lib memories/sram_sp_32768d_33w_16m_8b.lib memories/sram_sp_512d_32w_4m_2b.lib"

set_attribute link_library "/home/01fe21bec255/DFT_Internship/inputs/lib/slow.lib memories/rf_2p_136d_74w_1m_4b.lib memories/rf_2p_256d_76w_1m_4b.lib memories/rf_2p_512d_76w_2m_4b.lib memories/sram_sp_16384d_36w_16m_8b.lib memories/sram_sp_32768d_33w_16m_8b.lib memories/sram_sp_512d_32w_4m_2b.lib"

elaborate
check_design -unresolved
syn_gen
syn_map
syn_opt

write_hdl > cpu_sys_nangate.v
