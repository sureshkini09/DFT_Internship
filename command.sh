
# perl command to replace one keyword with another 
perl -i -pe 's/\.A\(/\.AN\(/g if /NAND2BX4/' ../inputs/rtl/vorca_fixed.v

#perl command to ground SI and SE pins
perl -0777 -pe "s/\.SE\s*\(\s*.*?\s*\)/.SE(1'b0)/gs; s/\.SI\s*\(\s*.*?\s*\)/.SI(1'b0)/gs;" cpu_sys.v > cpu_sys_modified.v



