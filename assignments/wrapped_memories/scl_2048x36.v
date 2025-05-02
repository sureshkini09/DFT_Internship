module sram_sp_16384d_36w_16m_8b (
    input         CLK,    // Clock
    input         CEN,    // Chip Enable (active low)
    input         GWEN,   // Global Write Enable (active low)
    input  [13:0]  A,      // Address (14 bits for 16384 words)
    input  [35:0] D,      // Data Input
    input  [35:0] WEN,    // Write Enable per byte (active low)
    output [35:0] Q       // Data Output
);

// Bank select from address bits [13:11]
wire [7:0] bank_select;
wire [10:0] word_addr = A[10:0];  // Lower 11 bits for word address

// Decode bank select
assign bank_select = (CEN == 1'b1) ? 8'h00 :  // All banks disabled when CEN is high
                     (1'b1 << A[13:11]);

// Memory instances
wire [35:0] bank_out [0:7];
wire [7:0]  bank_we;

// Generate write enable for each bank (active low)
assign bank_we = {8{GWEN}} | ~bank_select;

// Generate 8 instances of 64x32 memories
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : MEM_BANKS
        SPRAM_2048x36 bank (
            .A(word_addr),       // Address
            .CE(~CEN),          // Chip Enable (active high in SCL)
            .WEB(bank_we[i]),    // Write Enable (active low)
            .OEB(1'b0),         // Output Enable (active low, always enabled)
            .CSB(~bank_select[i]), // Chip Select (active low in SCL)
            .I(D),               // Data Input
            .O(bank_out[i])      // Data Output
        );
    end
endgenerate   

// Output multiplexer
assign Q = (bank_select[0]) ? bank_out[0] :
           (bank_select[1]) ? bank_out[1] :
           (bank_select[2]) ? bank_out[2] :
           (bank_select[3]) ? bank_out[3] :
           (bank_select[4]) ? bank_out[4] :
           (bank_select[5]) ? bank_out[5] :
           (bank_select[6]) ? bank_out[6] :
           (bank_select[7]) ? bank_out[7] :
           32'h0000_0000;

endmodule
