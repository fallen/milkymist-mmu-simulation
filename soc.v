/* Machine-generated using Migen */
module soc(
	output reset0_flash_rst_n,
	input clkfx_sys_clkin,
	input reset0_trigger_reset,
	output reset0_videoin_rst_n,
	output reset0_ac97_rst_n
);

reg clkfx_sys_clkout;

initial clkfx_sys_clkout = 1;

always #5 clkfx_sys_clkout = ~clkfx_sys_clkout;

wire cpu0_ibus_wishbone_we_o;
wire sram0_wishbone_cyc_i;
wire [31:0] cpu0_dbus_wishbone_dat_i;
reg [1:0] wishbonecon0_wishbone_bte_o;
reg wishbonecon0_wishbone_cyc_o;
wire [2:0] cpu0_dbus_wishbone_cti_o;
wire cpu0__inst_I_LOCK_O;
wire [3:0] cpu0_dbus_wishbone_sel_o;
wire cpu0_ibus_wishbone_ack_i;
wire [31:0] cpu0_ibus_wishbone_dat_i;
wire wishbonecon0_wishbone_err_i;
wire [12:0] frag_partial_adr;
reg wishbonecon0_wishbone_stb_o;
wire [1:0] cpu0_dbus_wishbone_bte_o;
wire [3:0] cpu0_ibus_wishbone_sel_o;
wire [1:0] cpu0_ibus_wishbone_bte_o;
wire cpu0_dbus_wishbone_cyc_o;
wire frag_slave_sel;
wire clkfx_sys_PSEN;
wire wishbonecon0_wishbone_ack_i;
wire cpu0_dbus_wishbone_err_i;
wire [29:0] sram0_wishbone_adr_i;
reg wishbonecon0_grant;
wire [31:0] cpu0_ibus_wishbone_dat_o;
wire cpu0_ibus_wishbone_stb_o;
wire [29:0] cpu0_dbus_wishbone_adr_o;
reg wishbonecon0_wishbone_we_o;
wire clkfx_sys_RST;
wire [31:0] cpu0__inst_D_ADR_O;
wire [2:0] sram0_wishbone_cti_i;
reg frag_decoder0;
wire sram0_wishbone_we_i;
wire [31:0] cpu0_dbus_wishbone_dat_o;
wire [3:0] sram0_wishbone_sel_i;
reg sram0_wishbone_err_o;
wire cpu0__inst_I_RTY_I;
wire sram0_wishbone_stb_i;
wire [31:0] sram0_wishbone_dat_i;
wire [2:0] cpu0_ibus_wishbone_cti_o;
wire cpu0__inst_D_RTY_I;
reg [29:0] wishbonecon0_wishbone_adr_o;
reg [31:0] cpu0_interrupt;
wire [31:0] cpu0__inst_I_ADR_O;
wire [1:0] wishbonecon0_request;
wire cpu0_ibus_wishbone_cyc_o;
reg [31:0] wishbonecon0_wishbone_dat_o;
wire cpu0_dbus_wishbone_stb_o;
wire reset0_sys_rst;
wire cpu0_ibus_wishbone_err_i;
wire [31:0] wishbonecon0_wishbone_dat_i;
wire cpu0_dbus_wishbone_ack_i;
wire [31:0] sram0_wishbone_dat_o;
reg [3:0] wishbonecon0_wishbone_sel_o;
reg [3:0] frag_sram0;
reg [2:0] wishbonecon0_wishbone_cti_o;
wire cpu0__inst_D_LOCK_O;
reg sram0_wishbone_ack_o;
wire cpu0_dbus_wishbone_we_o;
wire [1:0] sram0_wishbone_bte_i;
wire [29:0] cpu0_ibus_wishbone_adr_o;

// synthesis translate off
reg dummy_s;
initial dummy_s <= 1'b0;
// synthesis translate on
assign cpu0__inst_I_RTY_I = 1'd0;
assign cpu0__inst_D_RTY_I = 1'd0;
assign cpu0_ibus_wishbone_adr_o = cpu0__inst_I_ADR_O[31:2];
assign cpu0_dbus_wishbone_adr_o = cpu0__inst_D_ADR_O[31:2];

// synthesis translate off
reg dummy_d;
// synthesis translate on
always @(*) begin
	frag_sram0 <= 4'd0;
	frag_sram0[0] <= (((sram0_wishbone_cyc_i & sram0_wishbone_stb_i) & sram0_wishbone_we_i) & sram0_wishbone_sel_i[3]);
	frag_sram0[1] <= (((sram0_wishbone_cyc_i & sram0_wishbone_stb_i) & sram0_wishbone_we_i) & sram0_wishbone_sel_i[2]);
	frag_sram0[2] <= (((sram0_wishbone_cyc_i & sram0_wishbone_stb_i) & sram0_wishbone_we_i) & sram0_wishbone_sel_i[1]);
	frag_sram0[3] <= (((sram0_wishbone_cyc_i & sram0_wishbone_stb_i) & sram0_wishbone_we_i) & sram0_wishbone_sel_i[0]);
// synthesis translate off
	dummy_d <= dummy_s;
// synthesis translate on
end
assign frag_partial_adr = sram0_wishbone_adr_i[12:0];
assign clkfx_sys_PSEN = 1'd0;
assign clkfx_sys_RST = 1'd0;

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
assign frag_slave_sel = (wishbonecon0_wishbone_adr_o[28] == 1'd0);
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
assign wishbonecon0_wishbone_dat_i = ({32{frag_decoder0}} & sram0_wishbone_dat_o);

always @(posedge clkfx_sys_clkout) begin
	if (reset0_sys_rst) begin
		wishbonecon0_grant <= 1'd0;
		frag_decoder0 <= 1'd0;
		sram0_wishbone_ack_o <= 1'd0;
	end else begin
		sram0_wishbone_ack_o <= 1'd0;
		if (((sram0_wishbone_cyc_i & sram0_wishbone_stb_i) & (~sram0_wishbone_ack_o))) begin
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
		frag_decoder0 <= frag_slave_sel;
	end
end

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

m1reset m1reset(
	.trigger_reset(reset0_trigger_reset),
	.flash_rst_n(reset0_flash_rst_n),
	.sys_rst(reset0_sys_rst),
	.videoin_rst_n(reset0_videoin_rst_n),
	.ac97_rst_n(reset0_ac97_rst_n),
	.sys_clk(clkfx_sys_clkout)
);

reg [31:0] mem[0:8191];
reg [12:0] memadr;
always @(posedge clkfx_sys_clkout) begin
	if (frag_sram0[0])
		mem[frag_partial_adr][7:0] <= sram0_wishbone_dat_i[7:0];
	if (frag_sram0[1])
		mem[frag_partial_adr][15:8] <= sram0_wishbone_dat_i[15:8];
	if (frag_sram0[2])
		mem[frag_partial_adr][23:16] <= sram0_wishbone_dat_i[23:16];
	if (frag_sram0[3])
		mem[frag_partial_adr][31:24] <= sram0_wishbone_dat_i[31:24];
	memadr <= frag_partial_adr;
end

initial
begin
	$readmemh("ram.data", mem);
end

assign sram0_wishbone_dat_o = mem[memadr];

endmodule
