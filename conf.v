
module coef_term1(in, out);

parameter DWIDTH = 32;

parameter t01 = 32'b0000_0000_1000_0000_0000_0000_0000_0000 ;
parameter t12 = 32'b0000_0000_1101_0001_0100_0000_0000_0000 ;
parameter t23 = 32'b0000_0000_1110_1100_1000_0000_0000_0000 ;
parameter t34 = 32'b0000_0000_1111_1000_0100_0000_0000_0000 ;
parameter t46 = 32'b0000_0000_1111_1110_0100_0000_0000_0000 ;
parameter t00 = 32'b0000_0001_0000_0000_0000_0000_0000_0000 ;


input [2:0] in;
output reg [DWIDTH-1:0] out;

always@(in)
begin
  case (in)
    0 : out = t01;
	1 : out = t12;
	2 : out = t23;
	3 : out = t34;
	4 : out = t46;
	5 : out = t46;
	default : out = t00;
  endcase
end

endmodule

module coef_term2(in, out);

parameter DWIDTH=32;

parameter t01 = 32'b0000_0000_0100_0000_0000_0000_0000_0000 ;
parameter t12 = 32'b0000_0000_0010_0110_0000_0000_0000_0000 ;
parameter t23 = 32'b0000_0000_0001_0001_1100_0000_0000_0000 ;
parameter t34 = 32'b0000_0000_0000_0111_0100_0000_0000_0000 ;
parameter t46 = 32'b0000_0000_0000_0001_1000_0000_0000_0000 ;
parameter t00 = 32'b0000_0000_0000_0000_0000_0000_0000_0000 ;

input [2:0] in;
output reg [DWIDTH-1:0] out;

always@(in)
begin
  case (in)
    0 : out = t01;
	1 : out = t12;
	2 : out = t23;
	3 : out = t34;
	4 : out = t46;
	5 : out = t46;
	default : out = t00;
  endcase
end

endmodule

module coef_term3(in, out);

parameter DWIDTH=32;

parameter t01 = 32'b0000_0000_0000_0000_0000_0000_0000_0000 ;
parameter t12 = 32'b1111_1111_1111_0100_0000_0000_0000_0000 ;
parameter t23 = 32'b1111_1111_1111_1000_1000_0000_0000_0000 ;
parameter t34 = 32'b1111_1111_1111_1100_1100_0000_0000_0000 ;
parameter t46 = 32'b1111_1111_1111_1111_0100_0000_0000_0000 ;
parameter t00 = 32'b0000_0000_0000_0000_0000_0000_0000_0000 ;

input [2:0] in;
output reg [DWIDTH-1:0] out;

always@(in)
begin
  case (in)
    0 : out = t01;
	1 : out = t12;
	2 : out = t23;
	3 : out = t34;
	4 : out = t46;
	5 : out = t46;
	default : out = t00;
  endcase
end

endmodule
