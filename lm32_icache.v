//   ==================================================================
//   >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
//   ------------------------------------------------------------------
//   Copyright (c) 2006-2011 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED 
//   ------------------------------------------------------------------
//
//   IMPORTANT: THIS FILE IS AUTO-GENERATED BY THE LATTICEMICO SYSTEM.
//
//   Permission:
//
//      Lattice Semiconductor grants permission to use this code
//      pursuant to the terms of the Lattice Semiconductor Corporation
//      Open Source License Agreement.  
//
//   Disclaimer:
//
//      Lattice Semiconductor provides no warranty regarding the use or
//      functionality of this code. It is the user's responsibility to
//      verify the user's design for consistency and functionality through
//      the use of formal verification methods.
//
//   --------------------------------------------------------------------
//
//                  Lattice Semiconductor Corporation
//                  5555 NE Moore Court
//                  Hillsboro, OR 97214
//                  U.S.A
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                         503-286-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
//   --------------------------------------------------------------------
//                         FILE DETAILS
// Project          : LatticeMico32
// File             : lm32_icache.v
// Title            : Instruction cache
// Dependencies     : lm32_include.v
// 
// Version 3.5
// 1. Bug Fix: Instruction cache flushes issued from Instruction Inline Memory
//    cause segmentation fault due to incorrect fetches.
//
// Version 3.1
// 1. Feature: Support for user-selected resource usage when implementing
//    cache memory. Additional parameters must be defined when invoking module
//    lm32_ram. Instruction cache miss mechanism is dependent on branch
//    prediction being performed in D stage of pipeline.
//
// Version 7.0SP2, 3.0
// No change
// =============================================================================
					  
`include "lm32_include.v"

`ifdef CFG_ICACHE_ENABLED
`define LM32_IC_ADDR_OFFSET_RNG          addr_offset_msb:addr_offset_lsb
`define LM32_IC_ADDR_SET_RNG             addr_set_msb:addr_set_lsb
`define LM32_IC_ADDR_TAG_RNG             addr_tag_msb:addr_tag_lsb
`define LM32_IC_ADDR_IDX_RNG             addr_set_msb:addr_offset_lsb

`define LM32_IC_TMEM_ADDR_WIDTH          addr_set_width
`define LM32_IC_TMEM_ADDR_RNG            (`LM32_IC_TMEM_ADDR_WIDTH-1):0
`define LM32_IC_DMEM_ADDR_WIDTH          (addr_offset_width+addr_set_width)
`define LM32_IC_DMEM_ADDR_RNG            (`LM32_IC_DMEM_ADDR_WIDTH-1):0

`define LM32_IC_TAGS_WIDTH               (addr_tag_width+1)
`define LM32_IC_TAGS_RNG                 (`LM32_IC_TAGS_WIDTH-1):0
`define LM32_IC_TAGS_TAG_RNG             (`LM32_IC_TAGS_WIDTH-1):1
`define LM32_IC_TAGS_VALID_RNG           0

`define LM32_IC_STATE_RNG                3:0
`define LM32_IC_STATE_FLUSH_INIT         4'b0001
`define LM32_IC_STATE_FLUSH              4'b0010
`define LM32_IC_STATE_CHECK              4'b0100
`define LM32_IC_STATE_REFILL             4'b1000

`ifdef CFG_MMU_ENABLED

`define LM32_ITLB_CTRL_FLUSH		 	5'h1
`define LM32_ITLB_CTRL_UPDATE		 	5'h2
`define LM32_TLB_CTRL_SWITCH_TO_KERNEL_MODE	5'h4
`define LM32_TLB_CTRL_SWITCH_TO_USER_MODE	5'h8
`define LM32_TLB_CTRL_INVALIDATE_ENTRY		5'h10

`define LM32_TLB_STATE_CHECK		 2'b01
`define LM32_TLB_STATE_FLUSH		 2'b10

`define LM32_KERNEL_MODE		 1
`define LM32_USER_MODE			 0

`endif

/////////////////////////////////////////////////////
// Module interface
/////////////////////////////////////////////////////

module lm32_icache ( 
    // ----- Inputs -----
    clk_i,
    rst_i,    
    stall_a,
    stall_f,
    address_a,
    address_f,
    read_enable_f,
    refill_ready,
    refill_data,
    iflush,
`ifdef CFG_IROM_ENABLED
    select_f,
`endif
    valid_d,
    branch_predict_taken_d,
`ifdef CFG_MMU_ENABLED
    csr,
    csr_write_data,
    csr_write_enable,
    exception_x,
    eret_q_x,
    exception_m,
`endif
    // ----- Outputs -----
    stall_request,
    restart_request,
    refill_request,
    refill_address,
`ifdef CFG_MMU_ENABLED
    physical_refill_address,
`endif
    refilling,
`ifdef CFG_MMU_ENABLED
    itlb_miss_int,
    kernel_mode,
    pa,
    csr_read_data,
`endif
    inst
    );

/////////////////////////////////////////////////////
// Parameters
/////////////////////////////////////////////////////

parameter associativity = 1;                            // Associativity of the cache (Number of ways)
parameter sets = 512;                                   // Number of sets
parameter bytes_per_line = 16;                          // Number of bytes per cache line
parameter base_address = 0;                             // Base address of cachable memory
parameter limit = 0;                                    // Limit (highest address) of cachable memory

`ifdef CFG_MMU_ENABLED

parameter itlb_sets = 1024;				// Number of lines of ITLB
parameter page_size = 4096;				// System page size

`define LM32_ITLB_IDX_RNG		addr_itlb_index_msb:addr_itlb_index_lsb
`define LM32_ITLB_ADDRESS_PFN_RNG	addr_pfn_msb:addr_pfn_lsb
`define LM32_PAGE_OFFSET_RNG		addr_page_offset_msb:addr_page_offset_lsb
`define LM32_ITLB_INVALID_ADDRESS	{ vpfn_width{1'b1} }

localparam addr_page_offset_lsb = 0;
localparam addr_page_offset_msb = addr_page_offset_lsb + clogb2(page_size) - 2;
localparam addr_itlb_index_width = clogb2(itlb_sets) - 1;
localparam addr_itlb_index_lsb = addr_page_offset_msb + 1;
localparam addr_itlb_index_msb = addr_itlb_index_lsb + addr_itlb_index_width - 1;
localparam addr_pfn_lsb = addr_page_offset_msb + 1;
localparam addr_pfn_msb = `LM32_WORD_WIDTH - 1;
localparam vpfn_width = `LM32_WORD_WIDTH - (clogb2(page_size) - 1);
localparam addr_itlb_tag_width = vpfn_width - addr_itlb_index_width;
localparam addr_itlb_tag_lsb = addr_itlb_index_msb + 1;
localparam addr_itlb_tag_msb = addr_itlb_tag_lsb + addr_itlb_tag_width - 1;

`define LM32_ITLB_TAG_INVALID		{ addr_itlb_tag_width{ 1'b0 } }
`define LM32_ITLB_LOOKUP_RANGE		vpfn_width-1:0

/* The following define is the range containing the TAG inside the itlb_read_data wire which contains the ITLB value from BlockRAM
 * Indeed itlb_read_data contains { VALID_BIT, TAG_VALUE, LOOKUP_VALUE }
 * LM32_ITLB_TAG_RANGE is the range to extract the TAG_VALUE */
`define LM32_ITLB_TAG_RANGE		vpfn_width+addr_itlb_tag_width-1:vpfn_width

/* The following define is the range containing the TAG inside a memory address like itlb_update_vaddr_csr_reg for instance. */
`define LM32_ITLB_ADDR_TAG_RNG		addr_itlb_tag_msb:addr_itlb_tag_lsb
`define LM32_ITLB_VALID_BIT		vpfn_width+addr_itlb_tag_width

`endif

localparam addr_offset_width = clogb2(bytes_per_line)-1-2;
localparam addr_set_width = clogb2(sets)-1;
localparam addr_offset_lsb = 2;
localparam addr_offset_msb = (addr_offset_lsb+addr_offset_width-1);
localparam addr_set_lsb = (addr_offset_msb+1);
localparam addr_set_msb = (addr_set_lsb+addr_set_width-1);
localparam addr_tag_lsb = (addr_set_msb+1);
localparam addr_tag_msb = clogb2(`CFG_ICACHE_LIMIT-`CFG_ICACHE_BASE_ADDRESS)-1;
localparam addr_tag_width = (addr_tag_msb-addr_tag_lsb+1);

/////////////////////////////////////////////////////
// Inputs
/////////////////////////////////////////////////////

input clk_i;                                        // Clock 
input rst_i;                                        // Reset

input stall_a;                                      // Stall instruction in A stage
input stall_f;                                      // Stall instruction in F stage

input valid_d;                                      // Valid instruction in D stage
input branch_predict_taken_d;                       // Instruction in D stage is a branch and is predicted taken
   
input [`LM32_PC_RNG] address_a;                     // Address of instruction in A stage
input [`LM32_PC_RNG] address_f;                     // Address of instruction in F stage
input read_enable_f;                                // Indicates if cache access is valid

input refill_ready;                                 // Next word of refill data is ready
input [`LM32_INSTRUCTION_RNG] refill_data;          // Data to refill the cache with

input iflush;                                       // Flush the cache
`ifdef CFG_IROM_ENABLED
input select_f;                                     // Instruction in F stage is mapped through instruction cache
`endif

`ifdef CFG_MMU_ENABLED   
input [`LM32_CSR_RNG] csr;				// CSR read/write index
input [`LM32_WORD_RNG] csr_write_data;			// Data to write to specified CSR
input csr_write_enable;					// CSR write enable
input exception_x;					// An exception occured in the X stage
input exception_m;
input eret_q_x;
`endif

/////////////////////////////////////////////////////
// Outputs
/////////////////////////////////////////////////////

`ifdef CFG_MMU_ENABLED
output csr_read_data;
wire [`LM32_WORD_RNG] csr_read_data;
`endif

output stall_request;                               // Request to stall the pipeline
wire   stall_request;
output restart_request;                             // Request to restart instruction that caused the cache miss
reg    restart_request;
output refill_request;                              // Request to refill a cache line
wire   refill_request;
output [`LM32_PC_RNG] refill_address;               // Base address of cache refill
reg    [`LM32_PC_RNG] refill_address;               
`ifdef CFG_MMU_ENABLED
output [`LM32_PC_RNG] physical_refill_address;
reg    [`LM32_PC_RNG] physical_refill_address;
`endif
output refilling;                                   // Indicates the instruction cache is currently refilling
reg    refilling;
output [`LM32_INSTRUCTION_RNG] inst;                // Instruction read from cache
wire   [`LM32_INSTRUCTION_RNG] inst;

`ifdef CFG_MMU_ENABLED
output kernel_mode;
wire kernel_mode;
output itlb_miss_int;
wire itlb_miss_int;
output [`LM32_WORD_RNG] pa;
wire [`LM32_WORD_RNG] pa;
`endif

/////////////////////////////////////////////////////
// Internal nets and registers 
/////////////////////////////////////////////////////

wire enable;
wire [0:associativity-1] way_mem_we;
wire [`LM32_INSTRUCTION_RNG] way_data[0:associativity-1];
wire [`LM32_IC_TAGS_TAG_RNG] way_tag[0:associativity-1];
wire [0:associativity-1] way_valid;
wire [0:associativity-1] way_match;
wire miss;

wire [`LM32_IC_TMEM_ADDR_RNG] tmem_read_address;
wire [`LM32_IC_TMEM_ADDR_RNG] tmem_write_address;
wire [`LM32_IC_DMEM_ADDR_RNG] dmem_read_address;
wire [`LM32_IC_DMEM_ADDR_RNG] dmem_write_address;
wire [`LM32_IC_TAGS_RNG] tmem_write_data;

reg [`LM32_IC_STATE_RNG] state;
wire flushing;
wire check;
wire refill;

reg [associativity-1:0] refill_way_select;
reg [`LM32_IC_ADDR_OFFSET_RNG] refill_offset;
wire last_refill;
reg [`LM32_IC_TMEM_ADDR_RNG] flush_set;

`ifdef CFG_MMU_ENABLED

wire [addr_itlb_index_width-1:0] itlb_data_read_address;
wire [addr_itlb_index_width-1:0] itlb_data_write_address;
wire itlb_data_read_port_enable;
wire itlb_write_port_enable;
wire [vpfn_width + addr_itlb_tag_width + 1 - 1:0] itlb_write_data; // +1 is for valid_bit
wire [vpfn_width + addr_itlb_tag_width + 1 - 1:0] itlb_read_data; // +1 is for valid_bit
wire [`LM32_WORD_RNG] physical_address;
reg kernel_mode_reg = `LM32_KERNEL_MODE;
wire switch_to_kernel_mode;
wire switch_to_user_mode;
reg [`LM32_WORD_RNG] itlb_update_vaddr_csr_reg = `LM32_WORD_WIDTH'd0;
reg [`LM32_WORD_RNG] itlb_update_paddr_csr_reg = `LM32_WORD_WIDTH'd0;
reg [1:0] itlb_state;
reg [`LM32_WORD_RNG] itlb_ctrl_csr_reg = `LM32_WORD_WIDTH'd0;
reg itlb_updating;
reg [addr_itlb_index_width-1:0] itlb_update_set;
reg itlb_flushing;
reg [addr_itlb_index_width-1:0] itlb_flush_set;
wire itlb_miss;
reg itlb_miss_q = `FALSE;
reg [`LM32_PC_RNG] itlb_miss_addr;
wire itlb_data_valid;
wire [`LM32_ITLB_LOOKUP_RANGE] itlb_lookup;
reg go_to_user_mode;
reg go_to_user_mode_2;

`endif

genvar i, j;


/////////////////////////////////////////////////////
// Functions
/////////////////////////////////////////////////////

`include "lm32_functions.v"

/////////////////////////////////////////////////////
// Instantiations
/////////////////////////////////////////////////////

`ifdef CFG_MMU_ENABLED
// ITLB instantiation
lm32_ram
  #(
    // ----- Parameters -------
    .data_width (vpfn_width + addr_itlb_tag_width + 1),
    .address_width (addr_itlb_index_width)
// Modified for Milkymist: removed non-portable RAM parameters
    ) itlb_data_ram
    (
     // ----- Inputs -------
     .read_clk (clk_i),
     .write_clk (clk_i),
     .reset (rst_i),
     .read_address (itlb_data_read_address),
     .enable_read (itlb_data_read_port_enable),
     .write_address (itlb_data_write_address),
     .enable_write (`TRUE),
     .write_enable (itlb_write_port_enable),
     .write_data (itlb_write_data),
     // ----- Outputs -------
     .read_data (itlb_read_data)
     );
`endif


   generate
      for (i = 0; i < associativity; i = i + 1)
	begin : memories
	   
	   lm32_ram 
	     #(
	       // ----- Parameters -------
	       .data_width                 (32),
	       .address_width              (`LM32_IC_DMEM_ADDR_WIDTH)
// Modified for Milkymist: removed non-portable RAM parameters
) 
	   way_0_data_ram 
	     (
	      // ----- Inputs -------
	      .read_clk                   (clk_i),
	      .write_clk                  (clk_i),
	      .reset                      (rst_i),
	      .read_address               (dmem_read_address),
	      .enable_read                (enable),
	      .write_address              (dmem_write_address),
	      .enable_write               (`TRUE),
	      .write_enable               (way_mem_we[i]),
	      .write_data                 (refill_data),    
	      // ----- Outputs -------
	      .read_data                  (way_data[i])
	      );
	   
	   lm32_ram 
	     #(
	       // ----- Parameters -------
	       .data_width                 (`LM32_IC_TAGS_WIDTH),
	       .address_width              (`LM32_IC_TMEM_ADDR_WIDTH)
// Modified for Milkymist: removed non-portable RAM parameters
	       ) 
	   way_0_tag_ram 
	     (
	      // ----- Inputs -------
	      .read_clk                   (clk_i),
	      .write_clk                  (clk_i),
	      .reset                      (rst_i),
	      .read_address               (tmem_read_address),
	      .enable_read                (enable),
	      .write_address              (tmem_write_address),
	      .enable_write               (`TRUE),
	      .write_enable               (way_mem_we[i] | flushing),
	      .write_data                 (tmem_write_data),
	      // ----- Outputs -------
	      .read_data                  ({way_tag[i], way_valid[i]})
	      );
	   
	end
endgenerate

/////////////////////////////////////////////////////
// Combinational logic
/////////////////////////////////////////////////////

// Compute which ways in the cache match the address address being read
generate
    for (i = 0; i < associativity; i = i + 1)
    begin : match

assign way_match[i] =
`ifdef CFG_MMU_ENABLED
			(kernel_mode_reg == `LM32_USER_MODE) ?
			({way_tag[i], way_valid[i]} == {itlb_lookup, `TRUE }) : 
`endif
			({way_tag[i], way_valid[i]} == {address_f[`LM32_IC_ADDR_TAG_RNG], `TRUE});

    end
endgenerate

// Select data from way that matched the address being read     
generate
    if (associativity == 1)
    begin : inst_1
assign inst = way_match[0] ? way_data[0] : 32'b0;
    end
    else if (associativity == 2)
	 begin : inst_2
assign inst = way_match[0] ? way_data[0] : (way_match[1] ? way_data[1] : 32'b0);
    end
endgenerate

// Compute address to use to index into the data memories
generate 
    if (bytes_per_line > 4)
assign dmem_write_address = {refill_address[`LM32_IC_ADDR_SET_RNG], refill_offset};
    else
assign dmem_write_address = refill_address[`LM32_IC_ADDR_SET_RNG];
endgenerate
    
assign dmem_read_address = address_a[`LM32_IC_ADDR_IDX_RNG];

// Compute address to use to index into the tag memories                        
assign tmem_read_address = address_a[`LM32_IC_ADDR_SET_RNG];
assign tmem_write_address = flushing 
                                ? flush_set
                                : refill_address[`LM32_IC_ADDR_SET_RNG];


// Compute signal to indicate when we are on the last refill accesses
generate 
    if (bytes_per_line > 4)                            
assign last_refill = refill_offset == {addr_offset_width{1'b1}};
    else
assign last_refill = `TRUE;
endgenerate

// Compute data and tag memory access enable
assign enable = (stall_a == `FALSE);

// Compute data and tag memory write enables
generate
    if (associativity == 1) 
    begin : we_1     
assign way_mem_we[0] = (refill_ready == `TRUE);
    end
    else
    begin : we_2
assign way_mem_we[0] = (refill_ready == `TRUE) && (refill_way_select[0] == `TRUE);
assign way_mem_we[1] = (refill_ready == `TRUE) && (refill_way_select[1] == `TRUE);
    end
endgenerate                     

// On the last refill cycle set the valid bit, for all other writes it should be cleared
assign tmem_write_data[`LM32_IC_TAGS_VALID_RNG] = last_refill & !flushing;
`ifdef CFG_MMU_ENABLED
assign tmem_write_data[`LM32_IC_TAGS_TAG_RNG] = physical_refill_address[`LM32_IC_ADDR_TAG_RNG];
`else
assign tmem_write_data[`LM32_IC_TAGS_TAG_RNG] = refill_address[`LM32_IC_ADDR_TAG_RNG];
`endif

// Signals that indicate which state we are in
assign flushing = |state[1:0];
assign check = state[2];
assign refill = state[3];

assign miss = (~(|way_match)) && (read_enable_f == `TRUE) && (stall_f == `FALSE) && !(valid_d && branch_predict_taken_d);
assign stall_request = (check == `FALSE);
assign refill_request = (refill == `TRUE);
                      
/////////////////////////////////////////////////////
// Sequential logic
/////////////////////////////////////////////////////

// Record way selected for replacement on a cache miss
generate
    if (associativity >= 2) 
    begin : way_select      
always @(posedge clk_i `CFG_RESET_SENSITIVITY)
begin
    if (rst_i == `TRUE)
        refill_way_select <= {{associativity-1{1'b0}}, 1'b1};
    else
    begin        
        if (miss == `TRUE)
            refill_way_select <= {refill_way_select[0], refill_way_select[1]};
    end
end
    end
endgenerate

// Record whether we are refilling
always @(posedge clk_i `CFG_RESET_SENSITIVITY)
begin
    if (rst_i == `TRUE)
        refilling <= `FALSE;
    else
        refilling <= refill;
end

// Instruction cache control FSM
always @(posedge clk_i `CFG_RESET_SENSITIVITY)
begin
    if (rst_i == `TRUE)
    begin
        state <= `LM32_IC_STATE_FLUSH_INIT;
        flush_set <= {`LM32_IC_TMEM_ADDR_WIDTH{1'b1}};
        refill_address <= {`LM32_PC_WIDTH{1'b0}};
`ifdef CFG_MMU_ENABLED
        physical_refill_address <= {`LM32_PC_WIDTH{1'b0}};
`endif
        restart_request <= `FALSE;
    end
    else 
    begin
        case (state)

        // Flush the cache for the first time after reset
        `LM32_IC_STATE_FLUSH_INIT:
        begin            
            if (flush_set == {`LM32_IC_TMEM_ADDR_WIDTH{1'b0}})
                state <= `LM32_IC_STATE_CHECK;
            flush_set <= flush_set - 1'b1;
        end

        // Flush the cache in response to an write to the ICC CSR
        `LM32_IC_STATE_FLUSH:
        begin            
            if (flush_set == {`LM32_IC_TMEM_ADDR_WIDTH{1'b0}})
`ifdef CFG_IROM_ENABLED
	      if (select_f)
                state <= `LM32_IC_STATE_REFILL;
	      else
`endif
		state <= `LM32_IC_STATE_CHECK;
	   
            flush_set <= flush_set - 1'b1;
        end
        
        // Check for cache misses
        `LM32_IC_STATE_CHECK:
        begin            
            if (stall_a == `FALSE)
                restart_request <= `FALSE;
            if (iflush == `TRUE)
            begin
`ifdef CFG_MMU_ENABLED
                physical_refill_address <= physical_address[`LM32_PC_RNG];
`endif
                refill_address <= address_f;
                state <= `LM32_IC_STATE_FLUSH;
            end
            else if (miss == `TRUE && itlb_miss_int == `FALSE)
            begin
`ifdef CFG_MMU_ENABLED
                physical_refill_address <= physical_address[`LM32_PC_RNG];
`endif
                refill_address <= address_f;
                state <= `LM32_IC_STATE_REFILL;
            end
        end

        // Refill a cache line
        `LM32_IC_STATE_REFILL:
        begin            
            if (refill_ready == `TRUE)
            begin
                if (last_refill == `TRUE)
                begin
                    restart_request <= `TRUE;
                    state <= `LM32_IC_STATE_CHECK;
                end
            end
        end

        endcase        
    end
end

generate 
    if (bytes_per_line > 4)
    begin
// Refill offset
always @(posedge clk_i `CFG_RESET_SENSITIVITY)
begin
    if (rst_i == `TRUE)
        refill_offset <= {addr_offset_width{1'b0}};
    else 
    begin
        case (state)
        
        // Check for cache misses
        `LM32_IC_STATE_CHECK:
        begin            
            if (iflush == `TRUE)
                refill_offset <= {addr_offset_width{1'b0}};
            else if (miss == `TRUE)
                refill_offset <= {addr_offset_width{1'b0}};
        end

        // Refill a cache line
        `LM32_IC_STATE_REFILL:
        begin            
            if (refill_ready == `TRUE)
                refill_offset <= refill_offset + 1'b1;
        end

        endcase        
    end
end
    end
endgenerate

`ifdef CFG_MMU_ENABLED
   
// Compute address to use to index into the ITLB data memory
assign itlb_data_read_address = address_a[`LM32_ITLB_IDX_RNG];

// tlb_update_address will receive data from a CSR register
assign itlb_data_write_address = itlb_update_vaddr_csr_reg[`LM32_ITLB_IDX_RNG];

assign itlb_data_read_port_enable = (stall_a == `FALSE) || !stall_f;
assign itlb_write_port_enable = itlb_updating || itlb_flushing;

assign physical_address = (kernel_mode_reg == `LM32_KERNEL_MODE)
			    ? {address_f, 2'b0}
			    : {itlb_lookup, address_f[`LM32_PAGE_OFFSET_RNG+2], 2'b0};

assign itlb_write_data = (itlb_flushing == `TRUE)
			 ? {`FALSE, {addr_itlb_tag_width{1'b0}}, {vpfn_width{1'b0}}}
			 : {`TRUE, {itlb_update_vaddr_csr_reg[`LM32_ITLB_ADDR_TAG_RNG]}, itlb_update_paddr_csr_reg[`LM32_ITLB_ADDRESS_PFN_RNG]};

assign pa = physical_address;
assign kernel_mode = kernel_mode_reg;

assign switch_to_kernel_mode = (/*(kernel_mode_reg == `LM32_KERNEL_MODE) && */csr_write_enable && (csr == `LM32_CSR_TLB_CTRL) && csr_write_data[5:0] == {`LM32_TLB_CTRL_SWITCH_TO_KERNEL_MODE, 1'b0});
assign switch_to_user_mode = (/*(kernel_mode_reg == `LM32_KERNEL_MODE) && */csr_write_enable && (csr == `LM32_CSR_TLB_CTRL) && csr_write_data[5:0] == {`LM32_TLB_CTRL_SWITCH_TO_USER_MODE, 1'b0});

assign csr_read_data = {itlb_miss_addr, 2'b0};
assign itlb_miss = (kernel_mode_reg == `LM32_USER_MODE) && (read_enable_f) && ~(itlb_data_valid);
assign itlb_miss_int = (itlb_miss || itlb_miss_q);
assign itlb_read_tag = itlb_read_data[`LM32_ITLB_TAG_RANGE];
assign itlb_data_valid = itlb_read_data[`LM32_ITLB_VALID_BIT];
assign itlb_lookup = itlb_read_data[`LM32_ITLB_LOOKUP_RANGE];

`ifdef CFG_VERBOSE_DISPLAY_ENABLED
always @(posedge clk_i)
begin
	if (itlb_write_port_enable)
	begin
		$display("[ITLB data : %d] Writing 0x%08X to 0x%08X", $time, itlb_write_data, itlb_data_write_address);
	end
end
`endif

always @(posedge clk_i `CFG_RESET_SENSITIVITY)
begin
	if (rst_i == `TRUE)
		go_to_user_mode <= `FALSE;
	else
		go_to_user_mode <= (eret_q_x || switch_to_user_mode);
end

always @(posedge clk_i `CFG_RESET_SENSITIVITY)
begin
	if (rst_i == `TRUE)
		go_to_user_mode_2 <= `FALSE;
	else
		go_to_user_mode_2 <= go_to_user_mode;
end

always @(posedge clk_i `CFG_RESET_SENSITIVITY)
begin
	if (rst_i == `TRUE)
		kernel_mode_reg <= `LM32_KERNEL_MODE;
	else
	begin
		if (exception_x || switch_to_kernel_mode)
			kernel_mode_reg <= `LM32_KERNEL_MODE;
		else if (go_to_user_mode_2)
			kernel_mode_reg <= `LM32_USER_MODE;
	end
end

always @(posedge clk_i `CFG_RESET_SENSITIVITY)
begin
	if (rst_i == `TRUE)
		itlb_miss_q <= `FALSE;
	else
	begin
		if (itlb_miss && ~itlb_miss_q)
			itlb_miss_q <= `TRUE;
		else if (itlb_miss_q && exception_m)
			itlb_miss_q <= `FALSE;
	end
end

// CSR Write
always @(posedge clk_i `CFG_RESET_SENSITIVITY)
begin
	if (rst_i == `TRUE)
	begin
		itlb_ctrl_csr_reg <= `LM32_WORD_WIDTH'd0;
		itlb_update_vaddr_csr_reg <= `LM32_WORD_WIDTH'd0;
		itlb_update_paddr_csr_reg <= `LM32_WORD_WIDTH'd0;
	end
	else
	begin
		if (csr_write_enable)
		begin
			case (csr)
			`LM32_CSR_TLB_CTRL:	if (~csr_write_data[0]) itlb_ctrl_csr_reg[31:1] <= csr_write_data[31:1];
			`LM32_CSR_TLB_VADDRESS: if (~csr_write_data[0]) itlb_update_vaddr_csr_reg[31:1] <= csr_write_data[31:1];
			`LM32_CSR_TLB_PADDRESS: if (~csr_write_data[0]) itlb_update_paddr_csr_reg[31:1] <= csr_write_data[31:1];
			endcase
		end
		itlb_ctrl_csr_reg[0] <= 0;
		itlb_update_vaddr_csr_reg[0] <= 0;
		itlb_update_paddr_csr_reg[0] <= 0;
	end
end

always @(posedge clk_i `CFG_RESET_SENSITIVITY)
begin
	if (rst_i == `TRUE)
	begin
		$display("ITLB STATE MACHINE RESET");
		itlb_flushing <= 1;
		itlb_flush_set <= {addr_itlb_index_width{1'b1}};
		itlb_state <= `LM32_TLB_STATE_FLUSH;
		itlb_updating <= 0;
		itlb_miss_addr <= {`LM32_PC_WIDTH{1'b0}};
	end
	else
	begin
		case (itlb_state)

		`LM32_TLB_STATE_CHECK:
		begin
			itlb_updating <= 0;
			itlb_flushing <= 0;
			if (itlb_miss == `TRUE)
			begin
				itlb_miss_addr <= address_f;
				$display("WARNING : ITLB MISS on addr 0x%08X at time %t", address_f * 4, $time);
			end
			if (csr_write_enable && ~csr_write_data[0])
			begin
				// FIXME : test for kernel mode is removed for testing purposes ONLY
				if (csr == `LM32_CSR_TLB_CTRL /*&& (kernel_mode_reg == `LM32_KERNEL_MODE)*/)
				begin
`ifdef CFG_VERBOSE_DISPLAY_ENABLED
					$display("ITLB WCSR at %t with csr_write_data == 0x%08X", $time, csr_write_data);
`endif
					case (csr_write_data[5:1])
					`LM32_ITLB_CTRL_FLUSH:
					begin
`ifdef CFG_VERBOSE_DISPLAY_ENABLED
						$display("it's a FLUSH at %t", $time);
`endif
						itlb_flushing <= 1;
						itlb_flush_set <= {addr_itlb_index_width{1'b1}};
						itlb_state <= `LM32_TLB_STATE_FLUSH;
						itlb_updating <= 0;
					end

					`LM32_ITLB_CTRL_UPDATE:
					begin
`ifdef CFG_VERBOSE_DISPLAY_ENABLED
						$display("it's an UPDATE at %t", $time);
`endif
						itlb_updating <= 1;
					end

					`LM32_TLB_CTRL_INVALIDATE_ENTRY:
					begin
`ifdef CFG_VERBOSE_DISPLAY_ENABLED
						$display("it's an INVALIDATE ENTRY at %t", $time);
`endif
						itlb_flushing <= 1;
						itlb_flush_set <= itlb_update_vaddr_csr_reg[`LM32_ITLB_IDX_RNG];
						itlb_updating <= 0;
						itlb_state <= `LM32_TLB_STATE_CHECK;
					end

					endcase
				end
			end
		end

		`LM32_TLB_STATE_FLUSH:
		begin
			itlb_updating <= 0;
			if (itlb_flush_set == {addr_itlb_index_width{1'b0}})
				itlb_state <= `LM32_TLB_STATE_CHECK;
			itlb_flush_set <= itlb_flush_set - 1'b1;
		end

		endcase
	end
end

`endif

endmodule

`endif

