`default_nettype none

module tt_um_aegis_x_turbo (
    input  wire [7:0] ui_in,    // [3:0] Data nibble, [4] Start, [5] Mode
    output wire [7:0] uo_out,   // [7:0] Result Byte
    input  wire [7:0] uio_in,   // Bidirectional path - not used
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,      // always 1
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Pipeline Registers
    reg [63:0] reg_a, reg_b;
    reg [127:0] acc;
    reg [4:0]  pipe_step;
    
    // Stage 1: Partial Product Generation
    wire [67:0] partial_prod = reg_a * ui_in[3:0];
    
    // All outputs must be assigned
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;
    assign uo_out  = acc[7:0]; // Outputting the lower byte of the current hash

    // --- High Hashrate Execution Engine ---
    always @(posedge clk) begin
        if (!rst_n) begin
            acc       <= 128'b0;
            pipe_step <= 5'b0;
            reg_a     <= 64'h0;
            reg_b     <= 64'h0;
        end else if (ui_in[4]) begin // Start Pulse
            if (pipe_step < 16) begin
                // The "Turbo" Shift-and-Add Pipelined Math
                acc <= acc + (partial_prod << (pipe_step * 4));
                pipe_step <= pipe_step + 1;
            end
        end else begin
            // Load state: If start is low, we load data from ui_in
            reg_a <= {reg_a[59:0], ui_in[3:0]};
            pipe_step <= 0;
        end
    end

    // List unused signals to prevent synthesis warnings
    wire _unused = &{ena, uio_in, 1'b0};

endmodule
