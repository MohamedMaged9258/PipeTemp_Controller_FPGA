library verilog;
use verilog.vl_types.all;
entity RisingEdgeDetector is
    port(
        clk             : in     vl_logic;
        \signal\        : in     vl_logic;
        detected_edge   : out    vl_logic
    );
end RisingEdgeDetector;
