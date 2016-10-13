library ieee;
use ieee.std_logic_1164.all;

entity table is
	port(
		-- 50 MHz clock
		clock: in std_logic;
		-- 48-bit source MAC address
		source_address: in std_logic_vector(47 downto 0);
		-- one-hot encoded source port (0-3)
		source_port: in std_logic_vector(3 downto 0);
		-- 48-bit destination MAC address 
		destination_address: in std_logic_vector(47 downto 0);
		-- trigger for table to latch input values
		trigger: in std_logic;
		
		-- one-hot encoded destination port (0-3)
		destination_port: out std_logic_vector(3 downto 0);
		-- signal showing output is valid (single clock cycle)
		output_ready: out std_logic;
		-- signal showing trigger can be pulled
		input_ready: out std_logic;
		
		-- signal showing port not found for an address 
		-- guaranteed active for single cycle only
		monitor_not_found: out std_logic;
		-- signal showing access (read and write)
		-- guaranteed active for single cycle only
		monitor_access: out std_logic
		);

end table;

architecture table_rtl of table is	
	-- 32-bit bus for register write-enable
	signal write_enable: std_logic_vector(31 downto 0);
	-- 32-bit bus for register output
	signal reg_output: std_logic_vector(31 downto 0);
	-- 32-bit bus for comparison with SA/DA (1 == same)
	signal comparison_result: std_logic_vector(31 downto 0);
	-- 52-bit bus for value to be stored into first register
	signal first_value: std_logic_vector(51 downto 0);
	
	-- registers module goes here
	--
	-- Takes clock, write_enable, first_value
	-- Emits reg_output
	
	
	-- comparison module goes here
	--
	-- Takes SA/DA, FSM state, reg_output 
	-- Emits comparison_result
	
	
	-- compute module goes here
	--
	-- Takes reg_output, comparison_result, FSM state, SA/DA [for first_value]
	-- Emits write_enable, first_value, destination_port
	
	
	-- FSM module goes here
	--
	-- Takes trigger
	-- Emits output_ready, input_ready
	
	begin 
	
end table_rtl;