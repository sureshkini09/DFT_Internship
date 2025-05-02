module sram_sp_32768d_33w_16m_8b(
    input         CLK,    // Clock
    input         CEN,    // Chip Enable (active low)
    input         GWEN,   // Global Write Enable (active low)
    input  [14:0]  A,      // Address (14 bits for 16384 words)
    input  [32:0] D,      // Data Input
    input  [32:0] WEN,    // Write Enable per byte (active low)
    output [32:0] Q       // Data Output
);


module mem_32768x33_wrapper (
    input clk,
    input rst,
    input wr_en,
    input [14:0] addr, // 15-bit address for 32768
    input [32:0] din,
    output [32:0] dout
);

    // ------------------------------
    // Lower 32-bit memory blocks (4 x SPRAM_8192x32)
    // ------------------------------
    wire [31:0] dout32_bank [0:3];
    reg [31:0] dout32;
    wire [1:0] bank_sel32 = addr[14:13]; // Selects which of the four 8192x32 memory blocks to use
    wire [12:0] local_addr32 = addr[12:0]; // Provides the local address within each 8192x32 memory block

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_mem32
            SPRAM_8192x32 mem32_inst (
                .clk(clk),
                .rst(rst),
                .addr(local_addr32),
                .din(din[31:0]),
                .wr_en(wr_en && (bank_sel32 == i)),
                .dout(dout32_bank[i])
            );
        end
    endgenerate

    always @(*) begin
        case (bank_sel32)
            2'd0: dout32 = dout32_bank[0];
            2'd1: dout32 = dout32_bank[1];
            2'd2: dout32 = dout32_bank[2];
            2'd3: dout32 = dout32_bank[3];
            default: dout32 = 32'b0;
        endcase
    end

    // ------------------------------
    // Upper 1-bit memory using 8 x SPRAM_64x64 (bit-packed)
    // ------------------------------
    wire [5:0] row = addr[5:0]; // Selects the row (word address) within a 64x64 memory block
    wire [8:0] bit_idx = addr[14:6]; // Determines which bit is being accessed across the 64x64 memory banks
    wire [63:0] dout64_bank [0:7];
    reg [63:0] din64;
    reg wr_en64 [0:7];
    integer j;

    always @(*) begin
        din64 = 64'b0;
        for (j = 0; j < 8; j = j + 1)
            wr_en64[j] = 1'b0;

        din64[bit_idx[8:3]] = din[32];
        wr_en64[bit_idx[2:0]] = wr_en;
    end

    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_mem1
            SPRAM_64x64 mem1_inst (
                .clk(clk),
                .rst(rst),
                .addr(row),
                .din(din64),
                .wr_en(wr_en64[i]),
                .dout(dout64_bank[i])
            );
        end
    endgenerate

    reg dout1;
    always @(*) begin
        // Retrieves the correct bit from the 64x64 memory banks using the bit-packed layout
        dout1 = dout64_bank[bit_idx[2:0]][bit_idx[8:3]];
    end

    assign dout = {dout1, dout32};

