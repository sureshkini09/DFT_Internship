import re
import argparse
from math import floor

# python3 tcd.py ../../memory/spram/4M1L/SPRAM_16x4/SPRAM_16x4.v ram.tcd

def parse_defines(verilog_text):
    """Extract numAddr, numOut, and wordDepth from `define statements."""
    defines = {}
    for match in re.finditer(r'`define\s+(\w+)\s+(\d+)', verilog_text):
        name, value = match.groups()
        defines[name] = int(value)
    # numAddr: address bits, numOut: data bits, wordDepth: number of words
    num_addr = defines.get('numAddr')
    num_bits = defines.get('numOut')
    num_words = defines.get('wordDepth', 2**num_addr if num_addr else None)
    return num_addr, num_bits, num_words, defines

def eval_expr(expr, defines):
    """Evaluate expressions like `numAddr-1` using define values."""
    expr = expr.strip()
    # Replace `define names with values
    for key, val in defines.items():
        expr = expr.replace(f'`{key}', str(val))
    return eval(expr)

def parse_ports(verilog_text, module_name, defines):
    """Extract ports and their widths for the given module."""
    # Find module port list
    m = re.search(
        rf'module\s+{module_name}\s*\(\s*([^\)]+)\)', verilog_text, re.MULTILINE)
    port_list = []
    if m:
        port_list = [p.strip().strip(',') for p in m.group(1).split()]
    # Find input/output lines within module
    port_info = {}
    module_body = re.search(
        rf'module\s+{module_name}.*?endmodule', verilog_text, re.DOTALL).group(0)
    for line in module_body.splitlines():
        line = line.strip().strip(';')
        if line.startswith('input') or line.startswith('output'):
            width = 1
            if '[' in line and ']' in line:
                w = re.search(r'\[(.*?)\]', line).group(1)
                hi, lo = [eval_expr(e.strip(), defines) for e in w.split(':')]
                width = abs(hi - lo) + 1
            names = re.sub(r'^(input|output)\s+(\[.*?\]\s*)?', '', line).split(',')
            for name in names:
                port_info[name.strip()] = (width, 'Input' if 'input' in line else 'Output')
    return port_info

def generate_tcd(module_name, num_addr, num_bits, num_words, port_info):
    """Generate a TCD formatted string based on parsed values."""
    col_bits = floor(num_addr / 2)
    row_bits = num_addr - col_bits
    
    # Build port entries
    port_entries = []
    polarity_map = {'CE': 'ActiveHigh', 'CSB': 'ActiveLow', 
                    'WEB': 'ActiveLow', 'OEB': 'ActiveLow'}
    func_map = {'CE': 'Clock', 'CSB': 'Select', 'WEB': 'WriteEnable', 
                'OEB': 'OutputEnable', 'A': 'Address', 'I': 'Data', 'O': 'Data'}
    for port, (width, direction) in port_info.items():
        func = func_map.get(port if port in func_map else port.split('[')[0], 'Unknown')
        polarity = polarity_map.get(port, '')
        pol_str = f"Polarity : {polarity};" if polarity else ""
        port_name = f"{port}[{width-1}:0]" if width > 1 else port
        port_entries.append(
            f"  Port({port_name}) {{ Direction : {direction};  Function : {func};  {pol_str} }}")

    # Assemble TCD
    tcd = []
    tcd.append(f"MemoryTemplate({module_name}) {{")
    tcd.append("  MemoryType             : SRAM;")
    tcd.append(f"  CellName               : {module_name};")
    tcd.append("  LogicalPorts           : 1RW;")
    tcd.append("  OperationSet           : Sync;")
    tcd.append("  Algorithm              : SMarch;")
    tcd.append("  BitGrouping            : 1;")
    tcd.append(f"  NumberOfWords          : {num_words};")
    tcd.append(f"  NumberOfBits           : {num_bits};")
    tcd.append("  ObservationLogic       : Off;")
    tcd.append("  InternalScanLogic      : Off;")
    tcd.append("  ShadowRead             : Off;")
    tcd.append("  TransparentMode        : None;")
    tcd.append("  MinHold                : 0.00;")
    tcd.append("  MilliWattsPerMegaHertz : 0.0;")
    tcd.append("")
    # AddressCounter section
    tcd.append("  AddressCounter {")
    tcd.append("    Function(Address) {")
    tcd.append("      LogicalAddressMap {")
    tcd.append(f"        ColumnAddress[{col_bits-1}:0] : Address[0:{col_bits-1}];")
    tcd.append(f"        RowAddress   [{row_bits-1}:0] : Address[{num_addr-1}:{col_bits}];")
    tcd.append("      }")
    tcd.append("    }")
    tcd.append("    Function(RowAddress)    { CountRange [0:" + str(2**row_bits-1) + "]; }")
    tcd.append("    Function(ColumnAddress) { CountRange [0:" + str(2**col_bits-1) + "]; }")
    tcd.append("  }")
    tcd.append("")
    # PhysicalAddressMap
    tcd.append("  PhysicalAddressMap {")
    for i in range(col_bits):
        tcd.append(f"    ColumnAddress[{i}] : c[{i}];")
    for i in range(row_bits):
        tcd.append(f"    RowAddress[{i}]    : r[{i}];")
    tcd.append("  }")
    tcd.append("")
    # Ports
    tcd.extend(port_entries)
    tcd.append("}")
    return "\n".join(tcd)

def main():
    parser = argparse.ArgumentParser(description="Convert RTL memory .v to TCD file")
    parser.add_argument("verilog_file", help="Input Verilog memory file")
    parser.add_argument("tcd_file", help="Output TCD filename")
    args = parser.parse_args()

    with open(args.verilog_file) as vf:
        verilog_text = vf.read()

    # Assuming module name matches file basename
    module_name = args.verilog_file.split('/')[-1].replace('.v', '')
    # num_addr, num_bits, num_words = parse_defines(verilog_text)
    num_addr, num_bits, num_words, defines = parse_defines(verilog_text)
    port_info = parse_ports(verilog_text, module_name, defines)
    tcd_content = generate_tcd(module_name, num_addr, num_bits, num_words, port_info)

    with open(args.tcd_file, 'w') as tf:
        tf.write(tcd_content)

if __name__ == "__main__":
    main()

