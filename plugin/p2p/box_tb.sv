interface axil;
    logic awvalid;
    logic [31:0] awaddr;
    logic awready;
    logic wvalid;
    logic [31:0] wdata;
    logic wready;
    logic bvalid;
    logic arvalid;
    logic [31:0] araddr;
    logic arready;
    logic rvalid;
    logic [31:0] rdata;
    logic [1:0] rresp;
    logic rready;

    modport s (
        input awvalid,
        input awaddr,
        output awready,
        input wvalid,
        input wdata,
        output wready,
        output bvalid,
        output bresp,
        input bready,
        input arvalid,
        input araddr,
        output arready,
        output rvalid,
        output rdata,
        output rresp,
        input rready
    );

    modport m (
        output awvalid,
        output awaddr,
        input awready, 
        output wvalid,
        output wdata,
        input wready, 
        input bvalid, 
        input bresp, 
        output bready,
        output arvalid,
        output araddr,
        input arready, 
        input rvalid, 
        input rdata, 
        input rresp, 
        output rready
    );
endinterface

interface axis #(parameter int NUM_CMAC_PORT = 1);
    logic [NUM_CMAC_PORT-1:0] tvalid;
    logic [512*NUM_CMAC_PORT-1:0] tdata;
    logic [64*NUM_CMAC_PORT-1:0] tkeep;
    logic [NUM_CMAC_PORT-1:0] tlast;
    logic [NUM_CMAC_PORT-1:0] tuser_err;
    logic [NUM_CMAC_PORT-1:0] tready;

    modport s (
        input tvalid,
        input tdata,
        input tkeep,
        input tlast,
        input tuser_err,
        output tready
    );

    modport m (
        output tvalid,
        output tdata,
        output tkeep,
        output tlast,
        output tuser_err,
        input tready
    );
endinterface

module box_tb ();
    localparam int NUM_CMAC_PORT = 2;

    axil system_if;
    axis adap_box;
    axis box_adap;
    axis cmac_box;
    axis box_cmac;

    logic mod_rstn;
    logic mod_rst_done;
    logic axil_aclk;
    logic [NUM_CMAC_PORT - 1 : 0] cmac_clk;

    p2p_322mhz #(.NUM_CMAC_PORT(NUM_CMAC_PORT)) dut (
        //system_if
        .s_axil_awvalid                 (system_if.s.awvalid),
        .s_axil_awaddr                  (system_if.s.awaddr),
        .s_axil_awready                 (system_if.s.awready),
        .s_axil_wvalid                  (system_if.s.wvalid),
        .s_axil_data                    (system_if.s.wdata),
        .s_axil_wready                  (system_if.s.wready),
        .s_axil_bvalid                  (system_if.s.bvalid),
        .s_axil_bresp                   (system_if.s.bresp),
        .s_axil_bready                  (system_if.s.bready),
        .s_axil_arvalid                 (system_if.s.arvalid),
        .s_axil_araddr                  (system_if.s.araddr),
        .s_axil_arready                 (system_if.s.arready),
        .s_axil_rvalid                  (system_if.s.rvalid),
        .s_axil_rdata                   (system_if.s.rdata),
        .s_axil_rresp                   (system_if.s.rresp),
        .s_axil_rready                  (system_if.s.rready),
        //adap_box
        .s_axis_adap_tx_322mhz_tvalid   (adap_box.s.tvalid),
        .s_axis_adap_tx_322mhz_tdata    (adap_box.s.tdata), 
        .s_axis_adap_tx_322mhz_tkeep    (adap_box.s.tkeep),
        .s_axis_adap_tx_322mhz_tlast    (adap_box.s.tlast),
        .s_axis_adap_tx_322mhz_tuser_err(adap_box.s.tuser_err),
        .s_axis_adap_tx_322mhz_tready   (adap_box.s.tready),
        //box_adap
        .m_axis_adap_rx_322mhz_tvalid   (box_adap.m.tvalid),
        .m_axis_adap_rx_322mhz_tdata    (box_adap.m.tdata),
        .m_axis_adap_rx_322mhz_tkeep    (box_adap.m.tkeep),
        .m_axis_adap_rx_322mhz_tlast    (box_adap.m.tlast),
        .m_axis_adap_rx_322mhz_tuser_err(box_adap.m.tuser_err),
        //box_cmac
        .m_axis_cmac_tx_tvalid           (box_cmac.m.tvalid),
        .m_axis_cmac_tx_tdata            (box_cmac.m.tdata),
        .m_axis_cmac_tx_tkeep            (box_cmac.m.tkeep),
        .m_axis_cmac_tx_tlast            (box_cmac.m.tlast),
        .m_axis_cmac_tx_tuser_err        (box_cmac.m.tuser_err),
        .m_axis_cmac_tx_tready           (box_cmac.m.tready),
        //cmac_box
        .s_axis_cmac_rx_tvalid           (cmac_box.s.tvalid),
        .s_axis_cmac_rx_tdata            (cmac_box.s.tdata), 
        .s_axis_cmac_rx_tkeep            (cmac_box.s.tkeep),
        .s_axis_cmac_rx_tlast            (cmac_box.s.tlast),
        .s_axis_cmac_rx_tuser_err        (cmac_box.s.tuser_err),

        .mod_rstn                       (mod_rstn),
        .mod_rst_done                   (mod_rst_done),

        .axil_aclk                      (axil_aclk),
        .cmac_clk                       (cmac_clk)
    );


endmodule