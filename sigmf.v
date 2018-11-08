////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Institution   : Bandung Institute of Technology
// Engineer      : Jhonson Lee
//
// Create Date   : 11/14/2017
// Design Name   : Sigmoid Function
// Module Name   : sigmf
// Project Name  : LSI Design Contest in Okinawa 2018
// Target Devices: Neural Network
// Tool versions : FPGA
//
// Description:
// 		Calculation sigmoid function as the activation function for neural network
//
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Based on MacClaurin Series with 3 Terms.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
`include "conf.v"
`timescale 1ns/100ps
module sigmf(in, out);

parameter DWIDTH = 32;
parameter one = 32'b0000_0001_0000_0000_0000_0000_0000_0000; //variable for decimal value of 1

input signed [DWIDTH-1:0] in;
output signed [DWIDTH-1:0] out;

wire [2:0] ctrl;
wire signed [DWIDTH-1:0] term1, term2, term3;
wire signed [DWIDTH-1:0] c_term2, c_term3;
wire signed [DWIDTH-1:0] x, mid, result;


assign x = in[DWIDTH-1] ? (~in+1-mid) : (in-mid);

segmentation seg(in, ctrl);
mid_val     midvalue(ctrl, mid);
coef_term1  coef1(ctrl, term1);
coef_term2  coef2(ctrl, c_term2);
coef_term3  coef3(ctrl, c_term3);
//coef_term4  coef4(ctrl, c_term4);
mult    ser_term2(c_term2, x, term2);
mult_3in    ser_term3(c_term3, x, x, term3);
//mult_4in    ser_term4(c_term4, x, x, x, term4);
adder_4in   finaladd(term1, term2, term3, result);

assign out = in[DWIDTH-1] ? (one-result) : result;

endmodule

module segmentation(in, ctrl);

parameter DWIDTH = 32;

input [DWIDTH-1:0] in;
output [2:0] ctrl;

wire [15:0] t;
wire [DWIDTH-1:0] temp;

assign temp = (~in+1);

assign t = in[DWIDTH-1] ? temp[29:14] : in[29:14] ;

assign ctrl[2] = t[13] || (~t[13]&&t[12]) || (t[14]&&~t[13]&&~t[12]);
assign ctrl[1] = t[11] || (t[13]&&~t[11]) || (t[14]&&~t[13]&&~t[11]);
assign ctrl[0] = (~t[14]&&~t[13]&&~t[12]&&t[10]);

endmodule


module mid_val(in, out);

parameter DWIDTH = 32;

input [2:0] in;
output reg signed [DWIDTH-1:0] out;

always@(in)
begin
  case(in)
    0 : out = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
	1 : out = 32'b0000_0001_1000_0000_0000_0000_0000_0000;
	2 : out = 32'b0000_0010_1000_0000_0000_0000_0000_0000;
	3 : out = 32'b0000_0011_1000_0000_0000_0000_0000_0000;
	4 : out = 32'b0000_0101_0000_0000_0000_0000_0000_0000;
	5 : out = 32'b0000_0101_0000_0000_0000_0000_0000_0000;
	default : out = 0;

  endcase

end

endmodule

module mult_3in (A, B, C, Out);

parameter DWIDTH=32;
parameter frac=24;

input signed [DWIDTH-1:0] A, B, C;
output signed [DWIDTH-1:0] Out;

wire signed [4*DWIDTH-1:0] temp;

assign temp = A*B*C;
assign Out = temp[((4*DWIDTH-1)-(3*DWIDTH)+(2*frac)):2*frac];

endmodule

module adder_4in(A, B, C, out);

parameter DWIDTH=32;
parameter frac=24;

input signed [DWIDTH-1:0] A, B, C;
output signed [DWIDTH-1:0] out;

assign out = A + B + C;

endmodule
