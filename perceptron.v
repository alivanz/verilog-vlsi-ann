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

module hlayer_2_2_backprop(clk, reset, i1, i2, o, delta_w_in1, delta_w_in2, delta_w_out, update);
input clk, reset;
input [31:0] i1, i2;
output [31:0] o;
input [31:0] delta_w_in1, delta_w_in2;
output [31:0] delta_w_out;
input update;
// forward
hlayer2_1 layer(clk, reset, i1, i2, o);
// calc target_diff
wire [31:0] target_diff;
add add_target(delta_w_in1, delta_w_in2, target_diff);
// back propagation
wire [31:0] derivation;
sigmoid_derivation sig_derivation(clk, reset, o, derivation);
mult mult_delta(target_diff, derivation, delta_w_out);
// Update weight
wire [31:0] new_bias;
wire [31:0] new_weight1;
wire [31:0] new_weight2;
wire [31:0] one;
const_one cone(one);
calc_new_weight calc_bias   (clk, layer.b, delta_w_out, o, one, new_bias);
calc_new_weight calc_weight1(clk, layer.w1, delta_w_out, o, i1, new_weight1);
calc_new_weight calc_weight2(clk, layer.w2, delta_w_out, o, i2, new_weight2);
always @ (negedge clk) begin
  if (update) begin
    layer.b  <= new_bias;
    layer.w1 <= new_weight1;
    layer.w2 <= new_weight2;
  end
end
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

module olayer_3_backprop(clk, reset, i1, i2, i3, o, step, target, delta_w_out, update);
input clk, reset;
input [31:0] i1, i2, i3;
output [31:0] o;
input [31:0] step;
input [31:0] target;
output [31:0] delta_w_out;
input update;
// forward
hlayer3_1 layer(clk, reset, i1, i2, i3, o);
// calc target_diff
wire [31:0] target_diff;
sub sub_target(o, target, target_diff);
// back propagation
wire [31:0] derivation;
sigmoid_derivation sig_derivation(clk, reset, o, derivation);
mult mult_delta(target_diff, derivation, delta_w_out);
// Update weight
wire [31:0] new_bias;
wire [31:0] new_weight1;
wire [31:0] new_weight2;
wire [31:0] new_weight3;
wire [31:0] one;
const_one cone(one);
calc_new_weight calc_bias   (clk, layer.b,  step, delta_w_out, one, new_bias);
calc_new_weight calc_weight1(clk, layer.w1, step, delta_w_out, o,   new_weight1);
calc_new_weight calc_weight2(clk, layer.w2, step, delta_w_out, o,   new_weight2);
calc_new_weight calc_weight3(clk, layer.w3, step, delta_w_out, o,   new_weight3);
always @ (negedge clk) begin
  if (update) begin
    layer.b  <= new_bias;
    layer.w1 <= new_weight1;
    layer.w2 <= new_weight2;
    layer.w3 <= new_weight3;
  end
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

module calc_new_weight(clk, old_weight, step, delta, out_neuron, new_weight);
input clk, reset;
input [31:0] old_weight;
input [31:0] step;
input [31:0] delta;
input [31:0] out_neuron;
output [31:0] new_weight;
reg [31:0] new_weight;
always @ (negedge clk) begin
  new_weight <= old_weight - (step * delta * out_neuron);
end
endmodule

module sigmoid_derivation(clk, reset, in, out);
input clk, reset;
input [31:0] in;
output [31:0] out;
reg [31:0] out;
wire [31:0] one;
const_one cone(one);
always @ (negedge clk) begin
  out <= (one - in) * in;
end
endmodule
