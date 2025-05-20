<img src="Blank diagram.png" width="1200" height="800">

here we have 8 blocks 
we will understnad each block functionality and code the block according to it 

  1. Input Buffer
Function: Temporarily holds external input data (din) before it's stored or processed.

Your Code Reference:

verilog
Copy
Edit
input [15:0] din;
din is the 16-bit input buffer.

Used in storedin instruction to write into data memory: data_mem[immsrc] = din;

🔷 2. Output Buffer
Function: Sends processed data to an external destination (dout).

Your Code Reference:

verilog
Copy
Edit
output reg [15:0] dout;
Controlled via senddout instruction:

verilog
Copy
Edit
dout = data_mem[`immsrc];
🔷 3. General-Purpose Registers (GPR)
Function: Stores operands and intermediate values.

Your Code Reference:

verilog
Copy
Edit
reg [15:0] gpr[31:0]; // 32 registers of 16-bit
Used throughout instructions like movv, radd, rsub, etc.

🔷 4. Arithmetic Unit (AU)
Function: Performs arithmetic operations like add, subtract, multiply.

Your Code Reference:

verilog
Copy
Edit
`radd, `rsub, `rmul
Add/Sub:

verilog
Copy
Edit
gpr[rdst] = gpr[rsrc1] + gpr[rsrc2]; // for add
Multiply:

verilog
Copy
Edit
mul_res = gpr[rsrc1] * gpr[rsrc2];
gpr[rdst] = mul_res[15:0];
sgpr = mul_res[31:16];
🔷 5. Logic Unit
Function: Handles logical bitwise operations: AND, OR, XOR, NOT, etc.

Your Code Reference:

verilog
Copy
Edit
`ror, `rand, `rxor, `rxnor, `rnand, `rnor, `rnot
Example for XOR:

verilog
Copy
Edit
gpr[rdst] = gpr[rsrc1] ^ gpr[rsrc2];
🔷 6. Data Memory
Function: Temporarily stores data accessed during execution.

Your Code Reference:

verilog
Copy
Edit
reg [15:0] data_mem[15:0]; // 16 memory locations
Accessed using instructions like storereg, sendreg.

🔷 7. Instruction Register (IR)
Function: Holds the currently executing instruction.

Your Code Reference:

verilog
Copy
Edit
reg [31:0] ir;
Updated in fetch state:

verilog
Copy
Edit
ir = inst_mem[pc];
🔷 8. Program Memory
Function: Stores the list of instructions (inst_mem) loaded from a file.

Your Code Reference:

verilog
Copy
Edit
reg [31:0] inst_mem[15:0]; // 16 instructions
$readmemb("finalmem.mem", inst_mem);
🔷 9. Control Unit (CU)
Function: Manages FSM-based control flow for instruction execution (idle, fetch, decode, delayinst, nextinst, halt).

Your Code Reference:

verilog
Copy
Edit
reg [2:0] state, nextstate;
parameter idle=0, fetch=1, decode=2, nextinst=3, halt=4, delayinst=5;
