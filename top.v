`timescale 1ns / 1ps

//defining fields for ir
`define op_code ir[31:27]
`define rdst ir[26:22]
`define rsrc1 ir[21:17]
`define immode ir[16]
`define rsrc2 ir[15:11]
`define immsrc ir[15:0]

//defining fields for AU
`define movsgpr 5'b00000
`define movv 5'b00001
`define radd 5'b00010
`define rsub 5'b00011
`define rmul 5'b00100
//logical instructions
`define ror 5'b00101
`define rand 5'b00110
`define rxor 5'b00111
`define rxnor 5'b01000
`define rnand 5'b01001
`define rnor 5'b01010
`define rnot 5'b01011///11
///------------memory operation
`define storereg 5'b01100//12
`define storedin 5'b01101//13
`define senddout 5'b01110//14
`define sendreg 5'b01111//15
//-------------------jump and branching opr.
`define jump 5'b10000
`define jumpcarry 5'b10001
`define jumpsign 5'b10010
`define jumpzero 5'b10011
`define jumpoverflow 5'b10100
`define jumpnocarry 5'b10101
`define jumpnosign 5'b10110
`define jumpnozero 5'b10111
`define jumpnooverflow 5'b11000
`define halt 5'b11001

module top(
input clk,sys_rst,
input [15:0]din,
output reg [15:0]dout
);


reg [31:0]ir;
reg [15:0]gpr[31:0];
reg [31:0]mul_res;
reg [15:0]sgpr;
reg sign=0,carry=0,overflow=0,zero=0;
reg [16:0]temp_sum;
reg [15:0]data_mem[15:0];
reg [31:0]inst_mem[15:0];
reg jump_flag=1'b0,stop=1'b0;

task decode_inst();
begin
case(`op_code)
`movsgpr:
begin
gpr[ `rdst ] <= sgpr;
end

`movv:
begin
if(`immode)
gpr[`rdst] = `immsrc;

else
gpr[`rdst] = gpr[`rsrc1];
end

`radd:
begin
if(`immode)
gpr[`rdst]=gpr[`rsrc1]+`immsrc;
else
gpr[`rdst]=gpr[`rsrc1]+gpr[`rsrc2];
end

`rsub:
begin 
if(`immode)
gpr[`rdst] = gpr[`rsrc1] - `immsrc;

else
gpr[`rdst] = gpr[`rsrc1] - gpr[`rsrc2];
end

`rmul:
begin
if(`immode)
mul_res = gpr[`rsrc1]* `immsrc;
else
begin
mul_res = gpr[`rsrc1]* gpr[`rsrc2];
end
gpr[`rdst]=mul_res[15:0];
sgpr=mul_res[31:16];
end

`ror:
begin
if(`immode)
gpr[`rdst]=gpr[`rsrc1]|`immsrc;
else
gpr[`rdst]=gpr[`rsrc1]|gpr[`rsrc2];
end


`rand:
begin
if(`immode)
gpr[`rdst]=gpr[`rsrc1]&`immsrc;
else
gpr[`rdst]=gpr[`rsrc1]&gpr[`rsrc2];
end


`rxor:
begin
if(`immode)
gpr[`rdst]=gpr[`rsrc1]^`immsrc;
else
gpr[`rdst]=gpr[`rsrc1]^gpr[`rsrc2];
end


`rxnor:
begin
if(`immode)
gpr[`rdst]=gpr[`rsrc1]~^`immsrc;
else
gpr[`rdst]=gpr[`rsrc1]~^gpr[`rsrc2];
end


`rnand:
begin
if(`immode)
gpr[`rdst]=~(gpr[`rsrc1]&`immsrc);
else
gpr[`rdst]=~(gpr[`rsrc1]& gpr[`rsrc2]);
end


`rnor:
begin
if(`immode)
gpr[`rdst]=~(gpr[`rsrc1]|`immsrc);
else
gpr[`rdst]=~(gpr[`rsrc1]|gpr[`rsrc2]);
end

`rnot:
begin
if(`immode)
gpr[`rdst]=~(`immsrc);
else
gpr[`rdst]= ~(gpr[`rsrc1]);
end

`storereg:
begin
data_mem[`immsrc] = gpr[`rsrc1];
end

`storedin:
begin
 data_mem[`immsrc] = din;
end

`senddout:
begin
 dout  = data_mem[`immsrc]; 
end


`sendreg:
begin
gpr[`rdst] =  data_mem[`immsrc];
end

`jump:
jump_flag=1'b1;

`jumpcarry:
begin
if(carry==1'b1)
jump_flag=1'b1;
else
jump_flag=1'b0;
end

`jumpzero:
begin
if(zero==1)
jump_flag=1'b1;
else
jump_flag=1'b0;
end

`jumpsign:
begin
if(sign==1'b1)
jump_flag=1'b1;
else
jump_flag=1'b0;
end

`jumpoverflow:
begin
if(overflow==1)
jump_flag=1'b1;
else
jump_flag=1'b0;
end

`jumpnocarry:
begin
if(carry==0)
jump_flag=1'b1;
else
jump_flag=1'b0;
end

`jumpnosign:
begin
if(sign==0)
jump_flag=1'b1;
else
jump_flag=1'b0;
end

`jumpnozero:
begin
if(zero==0)
jump_flag=1'b1;
else
jump_flag=1'b0;
end


`jumpnooverflow:
begin
if(overflow==0)
jump_flag=1'b1;
else
jump_flag=1'b0;
end

`halt:
begin
stop=1'b1;
end

endcase
end
endtask


task decode_flag();
begin
//---------------signflag----------------------------
if(`op_code==`rmul)
sign=sgpr[15];
else
sign=gpr[`rdst][15];
//------------------carry flag-------------------------
if(`op_code == `radd)
  if(`immode)begin
  temp_sum = gpr[`rsrc1]+`immsrc;
  carry=temp_sum[16];
  end
  else
  begin
  temp_sum=gpr[`rsrc1]+gpr[`rsrc2];
  carry=temp_sum[16];
  end
else
begin
carry=1'b0; 
end

//---------------------zeroflag------------------
 if(`op_code == `rmul)
  zero =  ~((|sgpr[15:0]) | (|gpr[`rdst]));
else
  zero =  ~(|gpr[`rdst]); 
  
 //---------------------overflow flag----------------------
 if(`op_code == `radd)
     begin
       if(`immode)
         overflow = ( (~gpr[`rsrc1][15] & ~ir[15] & gpr[`rdst][15] ) | (gpr[`rsrc1][15] & ir[15] & ~gpr[`rdst][15]) );
       else
         overflow = ( (~gpr[`rsrc1][15] & ~gpr[`rsrc2][15] & gpr[`rdst][15]) | (gpr[`rsrc1][15] & gpr[`rsrc2][15] & ~gpr[`rdst][15]));
     end
  else if(`op_code == `rsub)
    begin
       if(`immode)
         overflow = ( (~gpr[`rsrc1][15] & ir[15] & gpr[`rdst][15] ) | (gpr[`rsrc1][15] & ~ir[15] & ~gpr[`rdst][15]) );
       else
         overflow = ( (~gpr[`rsrc1][15] & gpr[`rsrc2][15] & gpr[`rdst][15]) | (gpr[`rsrc1][15] & ~gpr[`rsrc2][15] & ~gpr[`rdst][15]));
    end 
  else
     begin
     overflow = 1'b0;
     end

end
endtask

//reading instructions

initial begin
$readmemb("finalmem.mem",inst_mem);
$display("Instruction Memory Loaded:");
$display("inst_mem[0] = %b", inst_mem[0]);
$display("inst_mem[1] = %b", inst_mem[1]);
$display("inst_mem[2] = %b", inst_mem[2]);

end

reg [2:0]count=0;
integer pc=0;

//i deleted here also
//i deleted here also


//executing_instructions

//adding fsm

parameter idle=0,fetch=1,decode=2,nextinst=3,halt=4,delayinst=5;
reg [2:0]state=idle,nextstate=idle;

//fsm timing

always@(posedge clk)
begin
if(sys_rst)
state<=idle;
else
state<=nextstate;
end

//fsm flow
always @(*)
begin
case(state)
idle:
begin
ir=32'b0;
pc=0;
nextstate=fetch;
end

fetch:
begin
ir=inst_mem[pc];
jump_flag=1'b0;
nextstate=decode;
end

decode:
begin
decode_inst();
decode_flag();
nextstate=delayinst;
end

delayinst:
begin
if(count<4)
nextstate=delayinst;
else
nextstate=nextinst;
end

nextinst:
begin
nextstate=halt;
if(jump_flag==1'b1)
begin
pc=`immsrc;
end
else
begin
pc=pc+1;
end
end
halt:
begin
if(stop==1'b0)
nextstate=fetch;
else
nextstate=idle;
end

default:
nextstate=idle;

endcase
end
//-----------------------------------countupdate
always@(posedge clk)
begin
case(state)

idle:
count<=0;
fetch:
count<=0;
decode:
count<=0;
delayinst:
count<=count+1;
nextinst:
count<=0;
halt:
count<=0;
default:
count<=0;

endcase
end

initial begin
  $monitor("Time=%0t | State=%0d | nextstate=%0d| PC=%0d | IR=%b | dout=%h | jump_flag=%b |carryflag=%b|sign=%b|overflow=%b|zero=%b| stop=%b", 
            $time, state,nextstate, pc, ir, dout, jump_flag,carry,sign,overflow,zero, stop);
end


endmodule



