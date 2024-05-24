module register_file #(
    //I believe that the shell supports 4096 addresses for the 322mhz box 
    parameter int ENTRIES = 12,
    parameter int DATA_WIDTH =  32
) (
    //axi_lite_register interface (between system configuration)
    input wire system_reg_en,
    input wire system_reg_we,
    input wire [$clog2(ENTRIES) - 1 : 0] system_reg_addr,
    input wire [DATA_WIDTH - 1 : 0] system_reg_din,
    output logic [DATA_WIDTH - 1 : 0] system_reg_dout,

    //internal read interface
    input wire internal_read,
    input wire [$clog2(ENTRIES) - 1 : 0] internal_reg_addr,
    output logic [DATA_WIDTH - 1 : 0] internal_reg_out    
);
    logic [DATA_WIDTH - 1 : 0] registers [ENTRIES];

    /**
    TODO:
     - An initial block here that reads from a file (readmemb/h) to initialize
    the contents of the registers. Use a module parameter for the path to the
    file?
    - Make configurable for a given number of internal clients. Would make it possible
    for both CMAC interfaces to read simultaneously
    **/
    initial begin
        for(int i = 0; i < ENTRIES; i++) begin
            registers[i] = 0;
        end        
    end

    always_latch begin
        system_reg_dout = 0;
        internal_reg_out = 0;
        
        if(system_reg_we) begin
            //write
            registers[system_reg_addr] = system_reg_din;
        end
        //both can read simultaneously
        if(system_reg_en && ~system_reg_we) begin
            //system register read
            system_reg_dout = registers[system_reg_addr];
        end
        if(internal_read) begin
            //internal read
            internal_reg_out = registers[internal_reg_addr];
        end
    end
endmodule: register_file