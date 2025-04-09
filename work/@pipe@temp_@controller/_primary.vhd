library verilog;
use verilog.vl_types.all;
entity PipeTemp_Controller is
    generic(
        PERIOD          : integer := 15
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        Temp_Data       : in     vl_logic_vector(7 downto 0);
        Alarm           : out    vl_logic;
        Shutdown        : out    vl_logic;
        Done            : out    vl_logic;
        units_seconds_segment_leds: out    vl_logic_vector(6 downto 0);
        tens_seconds_segment_leds: out    vl_logic_vector(6 downto 0);
        units_minutes_segment_leds: out    vl_logic_vector(6 downto 0);
        tens_minutes_segment_leds: out    vl_logic_vector(6 downto 0);
        minutes_tens    : out    vl_logic_vector(3 downto 0);
        minutes_units   : out    vl_logic_vector(3 downto 0);
        seconds_tens    : out    vl_logic_vector(3 downto 0);
        seconds_units   : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PERIOD : constant is 1;
end PipeTemp_Controller;
