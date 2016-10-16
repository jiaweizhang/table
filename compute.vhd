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
		for cmp_it in 0 to 31 loop
			if (cpt_compare_result(cmp_it) = '1') then
				cpt_first_value <= cpt_reg_output_address(cmp_it);
			else
				cpt_first_value <= (51 downto 0 => 'Z');
			end if;
		end loop;
	end process;
	
end compute_rtl;