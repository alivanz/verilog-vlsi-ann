`include "perceptron.v"

module ann_tb;
// common
reg clk, reset;
integer i;
// layers
reg [31:0] a,b;
wire [31:0] k1, k2;
wire [31:0] o1, o2, o3;
wire [31:0] ans1, ans2;
ilayer ilayerx(clk, reset, a, b, k1, k2);
hlayer2_3 hlayer(clk, reset, k1, k2, o1, o2, o3);
hlayer3_2 olayer(clk, reset, o1, o2, o3, ans1, ans2);
// tmp
reg [31:0] weight [11:0];
reg [31:0] bias [4:0];
// test vector
initial begin
  // init data
  $readmemb("weight.txt", weight);
  $readmemb("bias.txt", bias);
  a <= 32'b00001000000000000000000000000000; // 8
  b <= 32'b00000101000000000000000000000000; // 5
  hlayer.x1.w1 <= weight[0];
  hlayer.x1.w2 <= weight[1];
  hlayer.x2.w1 <= weight[2];
  hlayer.x2.w2 <= weight[3];
  hlayer.x3.w1 <= weight[4];
  hlayer.x3.w2 <= weight[5];
  olayer.x1.w1 <= weight[6];
  olayer.x1.w2 <= weight[7];
  olayer.x1.w3 <= weight[8];
  olayer.x2.w1 <= weight[9];
  olayer.x2.w2 <= weight[10];
  olayer.x2.w3 <= weight[11];
  hlayer.x1.b <= bias[0];
  hlayer.x2.b <= bias[1];
  hlayer.x3.b <= bias[2];
  olayer.x1.b <= bias[3];
  olayer.x2.b <= bias[4];
  // monitor
  // $monitor("%h", clk);
  // begin
  clk <= 1;
  reset <= 1;
  #20;
  clk <= 0;
  #20;
  for(i=0; i<10; i++) begin
    clk <= 1;
    reset <= 0;
    #20;
    clk <= 0;
    #20;
  end
  // $display("%h %h", weight[0], weight[1]);
  // $display("%h %h", hlayer.x1.w1, hlayer.x1.w2);
  $display("k1=%h\tk2=%h", k1, k2);
  $display("o1=%h\to2=%h\to3=%h", o1, o2, o3);
  $display("ans1=%h\tans2=%h", ans1, ans2);
end
endmodule
