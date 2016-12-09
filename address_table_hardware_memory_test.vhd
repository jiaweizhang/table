library ieee;
use ieee.std_logic_1164.all;

entity address_table_hardware_memory_test is port(
	-- can be configured to either be manual pushbutton or 50MHz FPGA clock
	hwtest_clock: in std_logic;
	-- can be left floating positive or be simply assigned to switch/pushbutton
	hwtest_reset: in std_logic;
		
	-- 2 7 segment bit vector showing number of accesses
	hwtest_access: out std_logic_vector(7 downto 0);
	-- 2 7 segment bit vector showing number of not_found destination addresses
	hwtest_not_found: out std_logic_vector(7 downto 0)
);
end address_table_hardware_memory_test;

architecture address_table_hardware_memory_test_rtl of address_table_hardware_memory_test is
begin

end address_table_hardware_memory_test_rtl;