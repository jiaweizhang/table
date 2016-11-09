library ieee;
use ieee.std_logic_1164.all;

entity address_table_hardware_test is port(
	test_clock: in std_logic;
	test_reset: in std_logic;
	
	test_source_address: in std_logic_vector(2 downto 0);
	test_source_port: in std_logic_vector(3 downto 0);
	test_destination_address: in std_logic_vector(2 downto 0);
	
	test_push_pin: in std_logic;
	
	test_destination_port: out std_logic_vector(3 downto 0);
	test_not_found: out std_logic
);
end address_table_hardware_test;

architecture address_table_hardware_test_rtl of address_table_hardware_test is

	type test_state_type is
		(base_state,
			push_pin_state,
			assert_trigger_state,
			deassert_trigger_state,
			latch_state);
	signal test_state: test_state_type;

	signal internal_trigger: std_logic;
	signal internal_output_ready: std_logic;
	signal internal_destination_port: std_logic_vector(3 downto 0);

	component address_table port(
		clock: in std_logic;
		reset: in std_logic;		
		
		source_address: in std_logic_vector(47 downto 0);
		source_port: in std_logic_vector(3 downto 0);
		destination_address: in std_logic_vector(47 downto 0);
		trigger: in std_logic;
		
		destination_port: out std_logic_vector(3 downto 0);
		output_ready: out std_logic;
		input_ready: out std_logic;
		
		monitor_not_found: out std_logic;
		monitor_access: out std_logic
	);
	end component;
	
	begin 
		address_table_inst: address_table port map(
			clock => test_clock,
			reset => test_reset,
			source_address => (44 downto 0 => '0') & test_source_address,
			source_port => test_source_port,
			destination_address => (44 downto 0 => '0') & test_destination_address,
			trigger => internal_trigger,
			destination_port => internal_destination_port,
			output_ready => internal_output_ready
		);
		
	process(test_state, test_clock, test_reset, test_push_pin, internal_output_ready, internal_destination_port)
	begin
		case test_state is
			when base_state =>
				if (test_push_pin'event and test_push_pin ='0') then
					test_state <= push_pin_state;
					internal_trigger <= '0';
				end if;
			when push_pin_state =>
				if (test_clock'event and test_clock = '0') then
					test_state <= assert_trigger_state;
					internal_trigger <= '0';
				end if;
			when assert_trigger_state =>
				if (test_clock'event and test_clock = '0') then
					test_state <= deassert_trigger_state;
					internal_trigger <= '1';
				end if;
			when deassert_trigger_state =>
				if (test_clock'event and test_clock = '1' and internal_output_ready = '1') then
					test_state <= latch_state;
					internal_trigger <= '0';
				end if;
			when latch_state =>
				if (test_clock'event and test_clock = '1') then
					test_state <= base_state;
					internal_trigger <= '0';
					test_destination_port <= internal_destination_port;
				end if;
		end case;
	end process;
	
	process (internal_destination_port)
	begin
		test_not_found <= '1';
	end process;
	
end address_table_hardware_test_rtl;