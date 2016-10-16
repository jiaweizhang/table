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
	process (cpt_compare_result, cpt_reg_output_address)
	begin
		if (cpt_compare_result(31) = '1') then
			cpt_first_value <= cpt_reg_output_address(31); 
		elsif (cpt_compare_result(30) = '1') then
			cpt_first_value <= cpt_reg_output_address(30);
		elsif (cpt_compare_result(29) = '1') then
			cpt_first_value <= cpt_reg_output_address(29);
		elsif (cpt_compare_result(28) = '1') then
			cpt_first_value <= cpt_reg_output_address(28);
		elsif (cpt_compare_result(27) = '1') then
			cpt_first_value <= cpt_reg_output_address(27);
		elsif (cpt_compare_result(26) = '1') then
			cpt_first_value <= cpt_reg_output_address(26);
		elsif (cpt_compare_result(25) = '1') then
			cpt_first_value <= cpt_reg_output_address(25);
		elsif (cpt_compare_result(24) = '1') then
			cpt_first_value <= cpt_reg_output_address(24);
		elsif (cpt_compare_result(23) = '1') then
			cpt_first_value <= cpt_reg_output_address(23);
		elsif (cpt_compare_result(22) = '1') then
			cpt_first_value <= cpt_reg_output_address(22);
		elsif (cpt_compare_result(21) = '1') then
			cpt_first_value <= cpt_reg_output_address(21);
		elsif (cpt_compare_result(20) = '1') then
			cpt_first_value <= cpt_reg_output_address(20);
		elsif (cpt_compare_result(19) = '1') then
			cpt_first_value <= cpt_reg_output_address(19);
		elsif (cpt_compare_result(18) = '1') then
			cpt_first_value <= cpt_reg_output_address(18);
		elsif (cpt_compare_result(17) = '1') then
			cpt_first_value <= cpt_reg_output_address(17);
		elsif (cpt_compare_result(16) = '1') then
			cpt_first_value <= cpt_reg_output_address(16);
		elsif (cpt_compare_result(15) = '1') then
			cpt_first_value <= cpt_reg_output_address(15);
		elsif (cpt_compare_result(14) = '1') then
			cpt_first_value <= cpt_reg_output_address(14);
		elsif (cpt_compare_result(13) = '1') then
			cpt_first_value <= cpt_reg_output_address(13);
		elsif (cpt_compare_result(12) = '1') then
			cpt_first_value <= cpt_reg_output_address(12);
		elsif (cpt_compare_result(11) = '1') then
			cpt_first_value <= cpt_reg_output_address(11);
		elsif (cpt_compare_result(10) = '1') then
			cpt_first_value <= cpt_reg_output_address(10);
		elsif (cpt_compare_result(9) = '1') then
			cpt_first_value <= cpt_reg_output_address(9);
		elsif (cpt_compare_result(8) = '1') then
			cpt_first_value <= cpt_reg_output_address(8);
		elsif (cpt_compare_result(7) = '1') then
			cpt_first_value <= cpt_reg_output_address(7);
		elsif (cpt_compare_result(6) = '1') then
			cpt_first_value <= cpt_reg_output_address(6);
		elsif (cpt_compare_result(5) = '1') then
			cpt_first_value <= cpt_reg_output_address(5);
		elsif (cpt_compare_result(4) = '1') then
			cpt_first_value <= cpt_reg_output_address(4);
		elsif (cpt_compare_result(3) = '1') then
			cpt_first_value <= cpt_reg_output_address(3);
		elsif (cpt_compare_result(2) = '1') then
			cpt_first_value <= cpt_reg_output_address(2);
		elsif (cpt_compare_result(1) = '1') then
			cpt_first_value <= cpt_reg_output_address(1);
		elsif (cpt_compare_result(0) = '1') then
			cpt_first_value <= cpt_reg_output_address(0);
		else
			-- if no valid comparison, simply select most recent
			cpt_first_value <= cpt_reg_output_address(31);		
		end if;
	end process;
	
end compute_rtl;