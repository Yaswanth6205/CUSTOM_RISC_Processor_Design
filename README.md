

here we have 8 blocks 
we will understnad each block functionality and code the block according to it 

<p> 🔷1. Input Buffer <br>
Function: Temporarily holds external input data (din) before it's stored or processed.<br>
Your Code Reference:<br>
input [15:0] din;<br>
din is the 16-bit input buffer.<br>

Used in storedin instruction to write into data memory: data_mem[immsrc] = din;<br>
</p>
<p>
🔷 2. Output Buffer<br>
Function: Sends processed data to an external destination (dout).<br>

Your Code Reference:<br>
output reg [15:0] dout;<br>
Controlled via senddout instruction:dout = data_mem[`immsrc];<br>
</p>
<p>
🔷 3. General-Purpose Registers (GPR)<br>
Function: Stores operands and intermediate values.<br>
Your Code Reference:<br>
reg [15:0] gpr[31:0]; // 32 registers of 16-bit<br>
Used throughout instructions like movv, radd, rsub, etc.<br>
</p>
<p>
🔷 4. Arithmetic Unit (AU)<br>
Function: Performs arithmetic operations like add, subtract, multiply.<br>
Your Code Reference:<br>
`radd, `rsub, `rmul<br>
Add/Sub:<br>
gpr[rdst] = gpr[rsrc1] + gpr[rsrc2]; // for add<br>
Multiply:<br>
mul_res = gpr[rsrc1] * gpr[rsrc2];<br>
gpr[rdst] = mul_res[15:0];<br>
sgpr = mul_res[31:16];<br>

</p>
<p>
🔷 5. Logic Unit<br>
Function: Handles logical bitwise operations: AND, OR, XOR, NOT, etc.<br>
Your Code Reference:<br>
`ror, `rand, `rxor, `rxnor, `rnand, `rnor, `rnot<br>
Example for XOR:<br>
gpr[rdst] = gpr[rsrc1] ^ gpr[rsrc2];<br>
</p>
<p>
🔷 6. Data Memory<br>
Function: Temporarily stores data accessed during execution.<br>
Your Code Reference:<br>
reg [15:0] data_mem[15:0]; // 16 memory locations<br>
Accessed using instructions like storereg, sendreg.<br>
</p>
<p>
🔷 7. Instruction Register (IR)<br>
Function: Holds the currently executing instruction.<br>
Your Code Reference:<br>
reg [31:0] ir;<br>
Updated in fetch state:<br>
ir = inst_mem[pc];<br>

</p>

<p>
🔷 8. Program Memory<br>
Function: Stores the list of instructions (inst_mem) loaded from a file.<br>
Your Code Reference:<br>
reg [31:0] inst_mem[15:0]; // 16 instructions<br>
$readmemb("finalmem.mem", inst_mem);<br>
</p>
<p>
🔷 9. Control Unit (CU)<br>
Function: Manages FSM-based control flow for instruction execution (idle, fetch, decode, delayinst, nextinst, halt).<br>
Your Code Reference:<br>
reg [2:0] state, nextstate;<br>
parameter idle=0, fetch=1, decode=2, nextinst=3, halt=4, delayinst=5;<br>
</p>
