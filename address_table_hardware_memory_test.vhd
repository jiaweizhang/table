library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity address_table_hardware_memory_test is port(
	-- can be configured to either be manual pushbutton or 50MHz FPGA clock
	hwtest_clock: in std_logic;
	-- can be left floating positive or be simply assigned to switch/pushbutton
	hwtest_reset: in std_logic;
	
	-- number of times table was accessed
	hwtest_access_count: out std_logic_vector(7 downto 0);
	-- number of times destination port was not found
	hwtest_not_found_count: out std_logic_vector(7 downto 0);
		
	-- number of times access differed from expected
	hwtest_access_incorrect: out std_logic_vector(7 downto 0);
	-- number of times not_found differed from expected
	hwtest_not_found_incorrect: out std_logic_vector(7 downto 0);
	-- number of times destination_port differed from expected
	hwtest_destination_port_incorrect: out std_logic_vector(7 downto 0)
);
end address_table_hardware_memory_test;

architecture address_table_hardware_memory_test_rtl of address_table_hardware_memory_test is

	signal current_source_address: std_logic_vector(47 downto 0);
	signal current_source_port: std_logic_vector(3 downto 0);
	signal current_destination_address: std_logic_vector(47 downto 0);
	signal current_destination_port: std_logic_vector(3 downto 0);
	signal current_access: std_logic;
	signal current_not_found: std_logic;
	
	signal current_address: std_logic_vector(9 downto 0);
	
	signal internal_q: std_logic_vector(127 downto 0);
	signal internal_trigger: std_logic;
	signal internal_destination_port: std_logic_vector(3 downto 0);
	signal internal_output_ready: std_logic;
	signal internal_access: std_logic;
	signal internal_not_found: std_logic;
	
	signal counter: std_logic_vector(7 downto 0);
	signal counter_access: std_logic_vector(7 downto 0);
	signal counter_not_found: std_logic_vector(7 downto 0);
	signal counter_destination_incorrect: std_logic_vector(7 downto 0);
	signal counter_access_incorrect: std_logic_vector(7 downto 0);
	signal counter_not_found_incorrect: std_logic_vector(7 downto 0);
	
	signal detected_access: std_logic;
	signal detected_not_found: std_logic;

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
	
	-- Memory hardware test initial ROM file
	-- addresses 0-1023 contain inputs and expected outputs

	-- each address is 128 bits and take the following format:
	-- [47:0] is the source_address
	-- [95:48] is the destination_address
	-- [99:96] is the source_port
	-- [103:100] is the expected destination_port
	-- [104] is the expected monitor_access
	-- [105] is the expected monitor_not_found
	-- [127:106] are empty (0)
	component hardware_memory port
	(
		address: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock: IN STD_LOGIC;
		q: OUT STD_LOGIC_VECTOR (127 DOWNTO 0)
	);
	end component;
	
	begin
		address_table_inst: address_table port map(
			clock => hwtest_clock,
			reset => '0',
			source_address => current_source_address,
			source_port => current_source_port,
			destination_address => current_destination_address,
			trigger => internal_trigger,
			destination_port => internal_destination_port,
			output_ready => internal_output_ready,
			monitor_not_found => internal_not_found,
			monitor_access => internal_access
		);
		
		hardware_memory_inst: hardware_memory port map(
			address => current_address,
			clock => hwtest_clock,
			q => internal_q
		);
		
	process(internal_q)
	begin
		current_source_address <= internal_q(47 downto 0);
		current_destination_address <= internal_q(95 downto 48);
		current_source_port <= internal_q(99 downto 96);
		current_destination_port <= internal_q(103 downto 100);
		current_access <= internal_q(104);
		current_not_found <= internal_q(105);
	end process;
	
	-- 8-bit clock counter
	process(hwtest_clock, counter)
	begin
		if (hwtest_clock'event and hwtest_clock = '1') then
			counter <= counter + '1';
		end if;
	end process;
	
	-- 8 clock cycle loop:
	-- 7nd neg edge -> increment address -> post-increment
	-- 2nd neg edge -> assert trigger -> address table starts processing at next pos clock edge
	-- 3rd neg edge -> deassert trigger
	-- 1st pos edge -> reset detected access or not_found
	-- 6th neg edge -> process access_incorrect and not_found_incorrect
	process(hwtest_clock, counter, current_address,
		detected_access, current_access, detected_not_found, current_not_found,
		internal_access, internal_not_found,
		counter_access_incorrect, counter_not_found_incorrect,
		counter_access, counter_not_found
		)
	begin
		if (hwtest_clock'event and hwtest_clock = '0') then
			if (counter(2 downto 0) = "111") then
				if (current_address = "1111111111") then
					current_address <= current_address;
				else
					current_address <= current_address + '1';
				end if;
			elsif (counter(2 downto 0) = "110") then
				if (detected_access /= current_access) then
					-- add 1 to access_incorrect counter
					counter_access_incorrect <= counter_access_incorrect + '1';
				end if;
				if (detected_not_found /= current_not_found) then
					counter_not_found_incorrect <= counter_not_found_incorrect + '1';
				end if;
			elsif (counter(2 downto 0) = "010") then
				internal_trigger <= '1';
			elsif (counter(2 downto 0) = "011") then
				internal_trigger <= '0';
			end if;
		end if;
		if (hwtest_clock'event and hwtest_clock = '1') then
			if (counter(2 downto 0) = "001") then
				detected_access <= '0';
				detected_not_found <= '0';
			end if;
			-- assert monitor signals if they are asserted in output of address table
			if (internal_access = '1') then
				detected_access <= '1';
				-- add 1 to access_counter
				counter_access <= counter_access + '1';
			end if;
			if (internal_not_found ='1') then
				detected_not_found <= '1';
				-- add 1 to not_found_counter
				counter_not_found <= counter_not_found + '1';
			end if;
		end if;
	end process;
	
	-- compare destination port when output_ready is asserted by address table
	process(internal_output_ready, current_destination_port, internal_destination_port, counter_destination_incorrect)
	begin
		if (internal_output_ready'event and internal_output_ready = '1') then
			if (current_destination_port /= internal_destination_port) then
				counter_destination_incorrect <= counter_destination_incorrect + '1';
			end if;
		end if;
	end process;
	
	-- outputs
	process(counter_access, counter_not_found, counter_access_incorrect, counter_not_found_incorrect, counter_destination_incorrect)
	begin
		hwtest_access_count <= counter_access;
		hwtest_not_found_count <= counter_not_found;
		hwtest_access_incorrect <= counter_access_incorrect;
		hwtest_not_found_incorrect <= counter_not_found_incorrect;
		hwtest_destination_port_incorrect <= counter_destination_incorrect;
	end process;
end address_table_hardware_memory_test_rtl;