/* Machine-generated using Migen */

`include "lm32_include.v"

module soc(
);

reg clkfx_sys_clkout;

initial
begin
	clkfx_sys_clkout = 1;
end

always #5 clkfx_sys_clkout = ~clkfx_sys_clkout;

wire sram0_wishbone_stb_i;
wire [2:0] cpu0_dbus_wishbone_cti_o;
wire clkfx_sys_PSEN;
reg wishbonecon0_wishbone_cyc_o;
wire wishbonecon0_wishbone_err_i;
wire cpu0_ibus_wishbone_stb_o;
wire cpu0_ibus_wishbone_cyc_o;
wire [3:0] cpu0_dbus_wishbone_sel_o;
wire [31:0] cpu0__inst_I_ADR_O;
wire cpu0_dbus_wishbone_ack_i;
wire [31:0] sram0_wishbone_adr_i;
wire cpu0_dbus_wishbone_err_i;
reg wishbonecon0_grant;
wire [31:0] cpu0_ibus_wishbone_adr_o;
wire [31:0] sram0_wishbone_dat_i;
wire cpu0_dbus_wishbone_stb_o;
reg frag_slave_sel_r;
wire [1:0] sram0_wishbone_bte_i;
wire [31:0] cpu0_dbus_wishbone_adr_o;
wire wishbonecon0_wishbone_ack_i;
wire [31:0] cpu0_ibus_wishbone_dat_o;
wire [31:0] sram0_wishbone_dat_o;
wire [31:0] cpu0_ibus_wishbone_dat_i;
reg [3:0] wishbonecon0_wishbone_sel_o;
reg [2:0] wishbonecon0_wishbone_cti_o;
wire sram0_wishbone_cyc_i;
wire cpu0_dbus_wishbone_we_o;
reg sram0_wishbone_err_o;
wire [31:0] frag_partial_adr;
wire frag_slave_sel;
wire cpu0_ibus_wishbone_err_i;
wire [31:0] cpu0_dbus_wishbone_dat_i;
wire [31:0] cpu0__inst_D_ADR_O;
reg [31:0] wishbonecon0_wishbone_dat_o;
wire cpu0_ibus_wishbone_ack_i;
wire cpu0__inst_I_RTY_I;
reg sram0_wishbone_ack_o;
reg wishbonecon0_wishbone_stb_o;
wire cpu0_ibus_wishbone_we_o;
wire clkfx_sys_RST;
wire [1:0] wishbonecon0_request;
wire [2:0] cpu0_ibus_wishbone_cti_o;
wire sram0_wishbone_we_i;
wire cpu0_dbus_wishbone_cyc_o;
wire cpu0__inst_I_LOCK_O;
wire [1:0] cpu0_ibus_wishbone_bte_o;
wire reset0_sys_rst;
reg [31:0] cpu0_interrupt;
wire [2:0] sram0_wishbone_cti_i;
reg [3:0] frag_we;
reg wishbonecon0_wishbone_we_o;
wire [31:0] wishbonecon0_wishbone_dat_i;
wire cpu0__inst_D_RTY_I;
reg [31:0] wishbonecon0_wishbone_adr_o;
wire [3:0] cpu0_ibus_wishbone_sel_o;
wire cpu0__inst_D_LOCK_O;
wire [3:0] sram0_wishbone_sel_i;
wire [31:0] cpu0_dbus_wishbone_dat_o;
wire [1:0] cpu0_dbus_wishbone_bte_o;
reg [1:0] wishbonecon0_wishbone_bte_o;

// synthesis translate off
reg dummy_s;
initial dummy_s <= 1'b0;
// synthesis translate on

// synthesis translate off
reg dummy_d;
// synthesis translate on
always @(*) begin
	frag_we <= 4'd0;
	frag_we[0] <= (((sram0_wishbone_cyc_i & sram0_wishbone_stb_i) & sram0_wishbone_we_i) & sram0_wishbone_sel_i[0]);
	frag_we[1] <= (((sram0_wishbone_cyc_i & sram0_wishbone_stb_i) & sram0_wishbone_we_i) & sram0_wishbone_sel_i[1]);
	frag_we[2] <= (((sram0_wishbone_cyc_i & sram0_wishbone_stb_i) & sram0_wishbone_we_i) & sram0_wishbone_sel_i[2]);
	frag_we[3] <= (((sram0_wishbone_cyc_i & sram0_wishbone_stb_i) & sram0_wishbone_we_i) & sram0_wishbone_sel_i[3]);
// synthesis translate off
	dummy_d <= dummy_s;
// synthesis translate on
end
assign frag_partial_adr = sram0_wishbone_adr_i[31:0];
assign clkfx_sys_PSEN = 1'd0;
assign clkfx_sys_RST = 1'd0;
assign cpu0__inst_I_RTY_I = 1'd0;
assign cpu0__inst_D_RTY_I = 1'd0;
assign cpu0_ibus_wishbone_adr_o = cpu0__inst_I_ADR_O[31:2];
assign cpu0_dbus_wishbone_adr_o = cpu0__inst_D_ADR_O[31:2];

// synthesis translate off
reg dummy_d_1;
// synthesis translate on
always @(*) begin
	wishbonecon0_wishbone_adr_o <= 30'd0;
	case (wishbonecon0_grant)
		1'd0: begin
			wishbonecon0_wishbone_adr_o <= cpu0_ibus_wishbone_adr_o;
		end
		default: begin
			wishbonecon0_wishbone_adr_o <= cpu0_dbus_wishbone_adr_o;
		end
	endcase
// synthesis translate off
	dummy_d_1 <= dummy_s;
// synthesis translate on
end

// synthesis translate off
reg dummy_d_2;
// synthesis translate on
always @(*) begin
	wishbonecon0_wishbone_dat_o <= 32'd0;
	case (wishbonecon0_grant)
		1'd0: begin
			wishbonecon0_wishbone_dat_o <= cpu0_ibus_wishbone_dat_o;
		end
		default: begin
			wishbonecon0_wishbone_dat_o <= cpu0_dbus_wishbone_dat_o;
		end
	endcase
// synthesis translate off
	dummy_d_2 <= dummy_s;
// synthesis translate on
end

// synthesis translate off
reg dummy_d_3;
// synthesis translate on
always @(*) begin
	wishbonecon0_wishbone_sel_o <= 4'd0;
	case (wishbonecon0_grant)
		1'd0: begin
			wishbonecon0_wishbone_sel_o <= cpu0_ibus_wishbone_sel_o;
		end
		default: begin
			wishbonecon0_wishbone_sel_o <= cpu0_dbus_wishbone_sel_o;
		end
	endcase
// synthesis translate off
	dummy_d_3 <= dummy_s;
// synthesis translate on
end

// synthesis translate off
reg dummy_d_4;
// synthesis translate on
always @(*) begin
	wishbonecon0_wishbone_cyc_o <= 1'd0;
	case (wishbonecon0_grant)
		1'd0: begin
			wishbonecon0_wishbone_cyc_o <= cpu0_ibus_wishbone_cyc_o;
		end
		default: begin
			wishbonecon0_wishbone_cyc_o <= cpu0_dbus_wishbone_cyc_o;
		end
	endcase
// synthesis translate off
	dummy_d_4 <= dummy_s;
// synthesis translate on
end

// synthesis translate off
reg dummy_d_5;
// synthesis translate on
always @(*) begin
	wishbonecon0_wishbone_stb_o <= 1'd0;
	case (wishbonecon0_grant)
		1'd0: begin
			wishbonecon0_wishbone_stb_o <= cpu0_ibus_wishbone_stb_o;
		end
		default: begin
			wishbonecon0_wishbone_stb_o <= cpu0_dbus_wishbone_stb_o;
		end
	endcase
// synthesis translate off
	dummy_d_5 <= dummy_s;
// synthesis translate on
end

// synthesis translate off
reg dummy_d_6;
// synthesis translate on
always @(*) begin
	wishbonecon0_wishbone_we_o <= 1'd0;
	case (wishbonecon0_grant)
		1'd0: begin
			wishbonecon0_wishbone_we_o <= cpu0_ibus_wishbone_we_o;
		end
		default: begin
			wishbonecon0_wishbone_we_o <= cpu0_dbus_wishbone_we_o;
		end
	endcase
// synthesis translate off
	dummy_d_6 <= dummy_s;
// synthesis translate on
end

// synthesis translate off
reg dummy_d_7;
// synthesis translate on
always @(*) begin
	wishbonecon0_wishbone_cti_o <= 3'd0;
	case (wishbonecon0_grant)
		1'd0: begin
			wishbonecon0_wishbone_cti_o <= cpu0_ibus_wishbone_cti_o;
		end
		default: begin
			wishbonecon0_wishbone_cti_o <= cpu0_dbus_wishbone_cti_o;
		end
	endcase
// synthesis translate off
	dummy_d_7 <= dummy_s;
// synthesis translate on
end

// synthesis translate off
reg dummy_d_8;
// synthesis translate on
always @(*) begin
	wishbonecon0_wishbone_bte_o <= 2'd0;
	case (wishbonecon0_grant)
		1'd0: begin
			wishbonecon0_wishbone_bte_o <= cpu0_ibus_wishbone_bte_o;
		end
		default: begin
			wishbonecon0_wishbone_bte_o <= cpu0_dbus_wishbone_bte_o;
		end
	endcase
// synthesis translate off
	dummy_d_8 <= dummy_s;
// synthesis translate on
end
assign cpu0_ibus_wishbone_dat_i = wishbonecon0_wishbone_dat_i;
assign cpu0_dbus_wishbone_dat_i = wishbonecon0_wishbone_dat_i;
assign cpu0_ibus_wishbone_ack_i = (wishbonecon0_wishbone_ack_i & (wishbonecon0_grant == 1'd0));
assign cpu0_dbus_wishbone_ack_i = (wishbonecon0_wishbone_ack_i & (wishbonecon0_grant == 1'd1));
assign cpu0_ibus_wishbone_err_i = (wishbonecon0_wishbone_err_i & (wishbonecon0_grant == 1'd0));
assign cpu0_dbus_wishbone_err_i = (wishbonecon0_wishbone_err_i & (wishbonecon0_grant == 1'd1));
assign wishbonecon0_request = {cpu0_dbus_wishbone_cyc_o, cpu0_ibus_wishbone_cyc_o};
assign frag_slave_sel = /*(wishbonecon0_wishbone_adr_o[28:26] == 3'd0)*/ 1;
assign sram0_wishbone_adr_i = wishbonecon0_wishbone_adr_o;
assign sram0_wishbone_dat_i = wishbonecon0_wishbone_dat_o;
assign sram0_wishbone_sel_i = wishbonecon0_wishbone_sel_o;
assign sram0_wishbone_stb_i = wishbonecon0_wishbone_stb_o;
assign sram0_wishbone_we_i = wishbonecon0_wishbone_we_o;
assign sram0_wishbone_cti_i = wishbonecon0_wishbone_cti_o;
assign sram0_wishbone_bte_i = wishbonecon0_wishbone_bte_o;
assign sram0_wishbone_cyc_i = (wishbonecon0_wishbone_cyc_o & frag_slave_sel);
assign wishbonecon0_wishbone_ack_i = sram0_wishbone_ack_o;
assign wishbonecon0_wishbone_err_i = sram0_wishbone_err_o;
assign wishbonecon0_wishbone_dat_i = ({32{frag_slave_sel_r}} & sram0_wishbone_dat_o);

always @(posedge clkfx_sys_clkout) begin
	if (reset0_sys_rst) begin
		wishbonecon0_grant <= 1'd0;
		sram0_wishbone_ack_o <= 1'd0;
		frag_slave_sel_r <= 1'd0;
	end else begin
		sram0_wishbone_ack_o <= 1'd0;
		if (((sram0_wishbone_cyc_i & sram0_wishbone_stb_i) & (~sram0_wishbone_ack_o))) begin
`ifdef CFG_RANDOM_WISHBONE_LATENCY
			if ($random() % 2)
`endif
				sram0_wishbone_ack_o <= 1'd1;
		end
		case (wishbonecon0_grant)
			1'd0: begin
				if ((~wishbonecon0_request[0])) begin
					if (wishbonecon0_request[1]) begin
						wishbonecon0_grant <= 1'd1;
					end
				end
			end
			1'd1: begin
				if ((~wishbonecon0_request[1])) begin
					if (wishbonecon0_request[0]) begin
						wishbonecon0_grant <= 1'd0;
					end
				end
			end
		endcase
		frag_slave_sel_r <= frag_slave_sel;
	end
end

wire reset0_trigger_reset;

assign reset0_trigger_reset = 1'b0;

m1reset m1reset(
	.trigger_reset(reset0_trigger_reset),
	.flash_rst_n(reset0_flash_rst_n),
	.sys_rst(reset0_sys_rst),
	.videoin_rst_n(reset0_videoin_rst_n),
	.ac97_rst_n(reset0_ac97_rst_n),
	.sys_clk(clkfx_sys_clkout)
);

lm32_top lm32(
	.I_ERR_I(cpu0_ibus_wishbone_err_i),
	.I_DAT_I(cpu0_ibus_wishbone_dat_i),
	.D_RTY_I(cpu0__inst_D_RTY_I),
	.D_ACK_I(cpu0_dbus_wishbone_ack_i),
	.I_ACK_I(cpu0_ibus_wishbone_ack_i),
	.D_ERR_I(cpu0_dbus_wishbone_err_i),
	.interrupt(cpu0_interrupt),
	.D_DAT_I(cpu0_dbus_wishbone_dat_i),
	.I_RTY_I(cpu0__inst_I_RTY_I),
	.I_WE_O(cpu0_ibus_wishbone_we_o),
	.I_ADR_O(cpu0__inst_I_ADR_O),
	.I_CTI_O(cpu0_ibus_wishbone_cti_o),
	.I_BTE_O(cpu0_ibus_wishbone_bte_o),
	.D_WE_O(cpu0_dbus_wishbone_we_o),
	.D_STB_O(cpu0_dbus_wishbone_stb_o),
	.D_BTE_O(cpu0_dbus_wishbone_bte_o),
	.I_CYC_O(cpu0_ibus_wishbone_cyc_o),
	.D_CYC_O(cpu0_dbus_wishbone_cyc_o),
	.D_SEL_O(cpu0_dbus_wishbone_sel_o),
	.I_SEL_O(cpu0_ibus_wishbone_sel_o),
	.I_LOCK_O(cpu0__inst_I_LOCK_O),
	.I_STB_O(cpu0_ibus_wishbone_stb_o),
	.I_DAT_O(cpu0_ibus_wishbone_dat_o),
	.D_CTI_O(cpu0_dbus_wishbone_cti_o),
	.D_DAT_O(cpu0_dbus_wishbone_dat_o),
	.D_LOCK_O(cpu0__inst_D_LOCK_O),
	.D_ADR_O(cpu0__inst_D_ADR_O),
	.clk_i(clkfx_sys_clkout),
	.rst_i(reset0_sys_rst)
);

reg [31:0] mem[0:16383];
reg [31:0] memadr;
always @(posedge clkfx_sys_clkout) begin
	if (frag_we[0])
		mem[frag_partial_adr & 32'h2EFFFFFF][7:0] <= sram0_wishbone_dat_i[7:0];
	if (frag_we[1])
		mem[frag_partial_adr & 32'h2EFFFFFF][15:8] <= sram0_wishbone_dat_i[15:8];
	if (frag_we[2])
		mem[frag_partial_adr & 32'h2EFFFFFF][23:16] <= sram0_wishbone_dat_i[23:16];
	if (frag_we[3])
		mem[frag_partial_adr & 32'h2EFFFFFF][31:24] <= sram0_wishbone_dat_i[31:24];
	memadr <= frag_partial_adr & 32'h2EFFFFFF;
end

reg do_print = 0;
reg [3:0] previous_frag_we = 4'd0;

always @(posedge clkfx_sys_clkout) begin
	previous_frag_we <= frag_we;
	if ( (|previous_frag_we) == 0 && |frag_we)
		do_print <= 1;
	else if (|previous_frag_we == |frag_we)
		do_print <= 0;
	else
		do_print <= 0;
end

always @(posedge clkfx_sys_clkout) begin
	if ( |frag_we )
		if (frag_partial_adr == 32'h11000C00)
		begin
`ifdef CFG_UART_ENABLED
			if (do_print)
			begin
				$write("%c", sram0_wishbone_dat_i[7:0]);
			end
`endif
		end
`ifdef CFG_VERBOSE_DISPLAY_ENABLED
		else
			$display("Writting 0x%08X to 0x%08X at time %d\n", sram0_wishbone_dat_i, frag_partial_adr, $time);
`endif
end

initial
begin
       $readmemh("ram.data", mem);
end

assign sram0_wishbone_dat_o = mem[memadr];

endmodule
