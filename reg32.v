module reg32(clk, reset, d, q);
input clk, reset;
input [31:0] d;
output [31:0] q;
reg [31:0] q;
always @ (negedge clk) begin
  if (reset) begin
    q <= 0;
  end else begin
    q <= d;
  end
end
endmodule
