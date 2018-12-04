`include "perceptron.v"

module backprop_tb;
// common
reg clk, reset;
integer i, j;
// vars
reg [31:0] input_1;
reg [31:0] input_2;
reg update;
reg [31:0] step;
reg [31:0] target_1;
reg [31:0] target_2;
// layers
wire [31:0] o_1_1;
wire [31:0] o_1_2;
wire [31:0] o_1_3;
wire [31:0] o_2_1;
wire [31:0] o_2_2;
wire [31:0] delta_w_out_1_1;
wire [31:0] delta_w_out_1_2;
wire [31:0] delta_w_out_1_3;
wire [31:0] delta_w_out_2_1;
wire [31:0] delta_w_out_2_2;
hlayer_2_2_backprop layer_1_1(clk, reset, input_1, input_2, o_1_1, step, delta_w_out_2_1, delta_w_out_2_2, delta_w_out_1_1, update);
hlayer_2_2_backprop layer_1_2(clk, reset, input_1, input_2, o_1_2, step, delta_w_out_2_1, delta_w_out_2_2, delta_w_out_1_2, update);
hlayer_2_2_backprop layer_1_3(clk, reset, input_1, input_2, o_1_3, step, delta_w_out_2_1, delta_w_out_2_2, delta_w_out_1_3, update);
olayer_3_backprop   layer_2_1(clk, reset, o_1_1, o_1_2, o_1_3, o_2_1, step, target_1, delta_w_out_2_1, update);
olayer_3_backprop   layer_2_2(clk, reset, o_1_1, o_1_2, o_1_3, o_2_2, step, target_2, delta_w_out_2_2, update);
// tmp
reg [31:0] weight [11:0];
reg [31:0] bias [4:0];
// test vector
wire [31:0] one;
const_one cone(one);
initial begin
  update <= 0;
  step <= 32'b00000000000110011001100110011001;
  target_1 <= one;
  target_2 <= 0;
  // init data
  $readmemb("weight.txt", weight);
  $readmemb("bias.txt", bias);
  input_1 <= 32'b00001000000000000000000000000000; // 8
  input_2 <= 32'b00000101000000000000000000000000; // 5
  layer_1_1.layer.w1 <= weight[0];
  layer_1_1.layer.w2 <= weight[1];
  layer_1_2.layer.w1 <= weight[2];
  layer_1_2.layer.w2 <= weight[3];
  layer_1_3.layer.w1 <= weight[4];
  layer_1_3.layer.w2 <= weight[5];
  layer_2_1.layer.w1 <= weight[6];
  layer_2_1.layer.w2 <= weight[7];
  layer_2_1.layer.w3 <= weight[8];
  layer_2_2.layer.w1 <= weight[9];
  layer_2_2.layer.w2 <= weight[10];
  layer_2_2.layer.w3 <= weight[11];
  layer_1_1.layer.b <= bias[0];
  layer_1_2.layer.b <= bias[1];
  layer_1_3.layer.b <= bias[2];
  layer_2_1.layer.b <= bias[3];
  layer_2_2.layer.b <= bias[4];
  // monitor
  // $monitor("%h", clk);
  // begin
  // clk <= 1;
  // reset <= 1;
  // update <= 0;
  // #20;
  // clk <= 0;
  // #20;
  for(i=0; i<10; i++) begin
    clk <= 1;
    reset <= 0;
    #20;
    clk <= 0;
    #20;
  end
  // $display("%h %h", weight[0], weight[1]);
  // $display("%h %h", hlayer.x1.w1, hlayer.x1.w2);
  $display("input_1=%h\tinput_2=%h", input_1, input_2);
  $display("o_1_1=%h\to_1_2=%h\to_1_3=%h", o_1_1, o_1_2, o_1_3);
  $display("o_2_1=%h\to_2_2=%h", o_2_1, o_2_2);
  $display("%h", layer_2_1.new_weight1);
  clk <= 1;
  update <= 1;
  #20;
  clk <= 0;
  #20;

  // $display("layer_o_2_1=%h", layer_2_1.o);
  // $display("derivation_2_1=%h", layer_2_1.derivation);
  // $display("target_2_1=%h", layer_2_1.target);
  // $display("target_diff_2_1=%h", layer_2_1.target_diff);
  // $display("d_2_1=%h", delta_w_out_2_1);

  // $display("step=%h", layer_1_1.step);
  // $display("w_1_1_1=%h\tw_1_1_2=%h", layer_1_1.new_weight1, layer_1_1.new_weight2);
  // $display("w_1_2_1=%h\tw_1_2_2=%h", layer_1_2.new_weight1, layer_1_2.new_weight2);
  // $display("w_1_3_1=%h\tw_1_3_2=%h", layer_1_3.new_weight1, layer_1_3.new_weight2);
  // $display("dw_2_1_1=%h", layer_2_1.calc_weight1.delta_weight);
  // $display("w_2_1_1=%h\tw_2_1_2=%h\tw_2_1_3=%h", layer_2_1.new_weight1, layer_2_1.new_weight2, layer_2_1.new_weight3);
  // $display("w_2_2_1=%h\tw_2_2_2=%h\tw_2_2_3=%h", layer_2_2.new_weight1, layer_2_2.new_weight2, layer_2_2.new_weight3);

  for(j=0; j<4; j++) begin
  for(i=0; i<10; i++) begin
    clk <= 1;
    reset <= 0;
    #20;
    clk <= 0;
    #20;
  end
  clk <= 1;
  update <= 1;
  #20;
  clk <= 0;
  #20;
  $display("");
  $display("input_1=%h\tinput_2=%h", input_1, input_2);
  $display("o_1_1=%h\to_1_2=%h\to_1_3=%h", o_1_1, o_1_2, o_1_3);
  $display("o_2_1=%h\to_2_2=%h", o_2_1, o_2_2);
  $display("%h", layer_2_1.new_weight1);
  end

  for(j=0; j<1000; j++) begin
  for(i=0; i<10; i++) begin
    clk <= 1;
    reset <= 0;
    #20;
    clk <= 0;
    #20;
  end
  clk <= 1;
  update <= 1;
  #20;
  clk <= 0;
  #20;
  end
  $display("");
  $display("input_1=%h\tinput_2=%h", input_1, input_2);
  $display("o_1_1=%h\to_1_2=%h\to_1_3=%h", o_1_1, o_1_2, o_1_3);
  $display("o_2_1=%h\to_2_2=%h", o_2_1, o_2_2);
  $display("%h", layer_2_1.new_weight1);
  end
endmodule
