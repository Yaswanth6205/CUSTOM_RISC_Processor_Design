

here we have 8 blocks 
we will understnad each block functionality and code the block according to it 

<p> 🔷1. Input Buffer /n
Function: Temporarily holds external input data (din) before it's stored or processed.\n
Your Code Reference:
input [15:0] din;
din is the 16-bit input buffer.

Used in storedin instruction to write into data memory: data_mem[immsrc] = din;
</p>
<p>
🔷 2. Output Buffer
Function: Sends processed data to an external destination (dout).

Your Code Reference:
output reg [15:0] dout;
Controlled via senddout instruction:dout = data_mem[`immsrc];
</p>
<p>
🔷 3. General-Purpose Registers (GPR)
Function: Stores operands and intermediate values.
Your Code Reference:
reg [15:0] gpr[31:0]; // 32 registers of 16-bit
Used throughout instructions like movv, radd, rsub, etc.
</p>
<p>
🔷 4. Arithmetic Unit (AU)
Function: Performs arithmetic operations like add, subtract, multiply.
Your Code Reference:
`radd, `rsub, `rmul
Add/Sub:
gpr[rdst] = gpr[rsrc1] + gpr[rsrc2]; // for add
Multiply:
mul_res = gpr[rsrc1] * gpr[rsrc2];
gpr[rdst] = mul_res[15:0];
sgpr = mul_res[31:16];

</p>
<p>
🔷 5. Logic Unit
Function: Handles logical bitwise operations: AND, OR, XOR, NOT, etc.
Your Code Reference:
`ror, `rand, `rxor, `rxnor, `rnand, `rnor, `rnot
Example for XOR:
gpr[rdst] = gpr[rsrc1] ^ gpr[rsrc2];
</p>
<p>
🔷 6. Data Memory
Function: Temporarily stores data accessed during execution.
Your Code Reference:
reg [15:0] data_mem[15:0]; // 16 memory locations
Accessed using instructions like storereg, sendreg.
</p>
<p>
🔷 7. Instruction Register (IR)
Function: Holds the currently executing instruction.
Your Code Reference:
reg [31:0] ir;
Updated in fetch state:
ir = inst_mem[pc];

</p>

<p>
🔷 8. Program Memory
Function: Stores the list of instructions (inst_mem) loaded from a file.
Your Code Reference:
reg [31:0] inst_mem[15:0]; // 16 instructions
$readmemb("finalmem.mem", inst_mem);
</p>
<p>
🔷 9. Control Unit (CU)
Function: Manages FSM-based control flow for instruction execution (idle, fetch, decode, delayinst, nextinst, halt).
Your Code Reference:
reg [2:0] state, nextstate;
parameter idle=0, fetch=1, decode=2, nextinst=3, halt=4, delayinst=5;
</p>
