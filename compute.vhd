library ieee;
use ieee.std_logic_1164.all;
use work.data_types.all;

entity compute is port(
	cpt_reg_output_address: in reg_output_type;
	cpt_compare_result: in std_logic_vector(31 downto 0);
	cpt_first_value: out std_logic_vector(51 downto 0);
	cpt_write_enable: out std_logic_vector(31 downto 0)
	);
end compute;

architecture compute_rtl of compute is
	signal compare_result_binary: natural;

	begin
	
	-- perform thermometer encoding
	process(cpt_compare_result)
	begin
		for thermo_it in 0 to 31 loop
			if (cpt_compare_result(thermo_it downto 0) = (thermo_it downto 0 => '0')) then
				cpt_write_enable(thermo_it) <= '0';
			else
				cpt_write_enable(thermo_it) <= '1';
			end if;
		end loop;
	end process;
	
	-- perform first_value selection
	process (compare_result_binary, cpt_reg_output_address)
	begin
		cpt_first_value <= cpt_reg_output_address(compare_result_binary);
	end process;
	
	process (cpt_compare_result)
	begin
		-- TODO may want to flip if not fast enough
		if (cpt_compare_result(31) = '1') then
			compare_result_binary <= 31;
		elsif (cpt_compare_result(30) = '1') then
			compare_result_binary <= 30;
		elsif (cpt_compare_result(29) = '1') then
			compare_result_binary <= 29;
		elsif (cpt_compare_result(28) = '1') then
			compare_result_binary <= 28;
		elsif (cpt_compare_result(27) = '1') then
			compare_result_binary <= 27;
		elsif (cpt_compare_result(26) = '1') then
			compare_result_binary <= 26;
		elsif (cpt_compare_result(25) = '1') then
			compare_result_binary <= 25;
		elsif (cpt_compare_result(24) = '1') then
			compare_result_binary <= 24;
		elsif (cpt_compare_result(23) = '1') then
			compare_result_binary <= 23;
		elsif (cpt_compare_result(22) = '1') then
			compare_result_binary <= 22;
		elsif (cpt_compare_result(21) = '1') then
			compare_result_binary <= 21;
		elsif (cpt_compare_result(20) = '1') then
			compare_result_binary <= 20;
		elsif (cpt_compare_result(19) = '1') then
			compare_result_binary <= 19;
		elsif (cpt_compare_result(18) = '1') then
			compare_result_binary <= 18;
		elsif (cpt_compare_result(17) = '1') then
			compare_result_binary <= 17;
		elsif (cpt_compare_result(16) = '1') then
			compare_result_binary <= 16;
		elsif (cpt_compare_result(15) = '1') then
			compare_result_binary <= 15;
		elsif (cpt_compare_result(14) = '1') then
			compare_result_binary <= 14;
		elsif (cpt_compare_result(13) = '1') then
			compare_result_binary <= 13;
		elsif (cpt_compare_result(12) = '1') then
			compare_result_binary <= 12;
		elsif (cpt_compare_result(11) = '1') then
			compare_result_binary <= 11;
		elsif (cpt_compare_result(10) = '1') then
			compare_result_binary <= 10;
		elsif (cpt_compare_result(9) = '1') then
			compare_result_binary <= 9;
		elsif (cpt_compare_result(8) = '1') then
			compare_result_binary <= 8;
		elsif (cpt_compare_result(7) = '1') then
			compare_result_binary <= 7;
		elsif (cpt_compare_result(6) = '1') then
			compare_result_binary <= 6;
		elsif (cpt_compare_result(5) = '1') then
			compare_result_binary <= 5;
		elsif (cpt_compare_result(4) = '1') then
			compare_result_binary <= 4;
		elsif (cpt_compare_result(3) = '1') then
			compare_result_binary <= 3;
		elsif (cpt_compare_result(2) = '1') then
			compare_result_binary <= 2;
		elsif (cpt_compare_result(1) = '1') then
			compare_result_binary <= 1;
		elsif (cpt_compare_result(0) = '1') then
			compare_result_binary <= 0;
		else
			-- if no valid comparison, simply select most recent
			compare_result_binary <= 31;
		end if;
	end process;
	
end compute_rtl;