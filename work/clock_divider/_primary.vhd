library verilog;
use verilog.vl_types.all;
entity clock_divider is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        CLK1Hz          : out    vl_logic
    );
end clock_divider;
