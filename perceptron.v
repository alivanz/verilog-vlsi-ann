`include "reg32.v"
`include "arith.v"
`include "sigmf.v"

module ilayer(clk, reset, a,b, k1, k2);
input clk, reset;
input [31:0] a,b;
output [31:0] k1,k2;
reg32 reg_k1(clk, reset, a, k1);
reg32 reg_k2(clk, reset, b, k2);
endmodule

module hlayer2_3(clk, reset, i1, i2, o1, o2, o3);
input clk, reset;
input [31:0] i1, i2;
output [31:0] o1, o2, o3;
hlayer2_1 x1(clk, reset, i1, i2, o1);
hlayer2_1 x2(clk, reset, i1, i2, o2);
hlayer2_1 x3(clk, reset, i1, i2, o3);
endmodule

module hlayer3_2(clk, reset, i1, i2, i3, o1, o2);
input clk, reset;
input [31:0] i1, i2, i3;
output [31:0] o1, o2;
hlayer3_1 x1(clk, reset, i1, i2, i3, o1);
hlayer3_1 x2(clk, reset, i1, i2, i3, o2);
endmodule

module hlayer2_1(clk, reset, i1, i2, o);
input clk, reset;
input [31:0] i1, i2;
output [31:0] o;
// weight
reg [31:0] w1, w2;
// bias
reg [31:0] b;
// output
reg [31:0] o;
// mult
wire [31:0] r1, r2;
mult m1(i1, w1, r1);
mult m2(i2, w2, r2);
// add
wire [31:0] a1, ox;
add add1(r1, r2, a1);
add add2(a1, b, ox);
// sigmoid
wire [31:0] os;
sigmf sig(ox, os);
always @ (negedge clk) begin
  o <= os;
  // $display("i1=%h i2=%h ox=%h", i1, i2, ox);
end
endmodule

module hlayer3_1(clk, reset, i1, i2, i3, o);
input clk, reset;
input [31:0] i1, i2, i3;
output [31:0] o;
// weight
reg [31:0] w1, w2, w3;
// bias
reg [31:0] b;
// output
reg [31:0] o;
// mult
wire [31:0] r1, r2, r3;
mult m1(i1, w1, r1);
mult m2(i2, w2, r2);
mult m3(i3, w3, r3);
// add
wire [31:0] a1, a2, ox;
add add1(r1, r2, a1);
add add2(r3, b, a2);
add add3(a1, a2, ox);
// sigmoid
wire [31:0] os;
sigmf sig(ox, os);
always @ (negedge clk) begin
  o <= os;
end
endmodule
