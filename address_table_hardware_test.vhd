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
		(reset_state,
			seen_state,
			final_state);
	signal test_state: test_state_type;
	signal test_state_next: test_state_type;

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
			reset => '0',
			source_address => (44 downto 0 => '0') & test_source_address,
			source_port => test_source_port,
			destination_address => (44 downto 0 => '0') & test_destination_address,
			trigger => internal_trigger,
			destination_port => internal_destination_port,
			output_ready => internal_output_ready
		);
		
	process(test_clock, test_reset, test_state_next)
	begin
		if (test_clock'event and test_clock = '0') then
			test_state <= test_state_next;
		end if;
	end process;
	
	process (test_clock, test_state, test_push_pin)
	begin
		case test_state is
			when reset_state =>
				-- if PP is pushed, set to seen_state
				if (test_push_pin = '0') then
					test_state_next <= seen_state;
				-- if PP is not pushed, set to reset_state
				else
					test_state_next <= reset_state;
				end if;
			when seen_state =>
				-- always move on
				test_state_next <= final_state;
			when final_state =>
				-- if PP is pushed, keep at final_state
				if (test_push_pin = '0') then
					test_state_next <= final_state;
				-- if PP is not pushed, we can reset
				else
					test_state_next <= reset_state;
				end if;
		end case;
	end process;
	
	process(test_state)
	begin
		case test_state is
			when reset_state =>
				internal_trigger <= '0';
			when seen_state =>
				internal_trigger <= '1';
			when final_state =>
				internal_trigger <= '0';
		end case;
	end process;
	
	--process(test_state)
	--begin
	--	case test_state is
	--		when reset_state =>
	--			test_destination_port <= "1000";
	--		when seen_state =>
	--			test_destination_port <= "0100";
	--		when final_state =>
	--			test_destination_port <= "0010";
	--	end case;
	--end process;
		
	process (test_clock, internal_output_ready, internal_trigger, test_state_next)
	begin
		--test_not_found <= internal_output_ready;
		--if (test_clock'event and test_clock = '1' and internal_output_ready = '1') then
		if (internal_output_ready'event and internal_output_ready = '1') then
			-- latch output
			test_destination_port <= internal_destination_port;
			--test_not_found <= internal_trigger;
			test_not_found <= internal_destination_port(3) and internal_destination_port(2) and internal_destination_port(1) and internal_destination_port(0);
		end if;
	end process;
	
end address_table_hardware_test_rtl;