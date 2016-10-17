-- synthesis library my_lib
library ieee;
use ieee.std_logic_1164.all;

package data_types is 
     type state_type is
		(reset_state, 
		read_state,
		write_state);
	type reg_output_type is array (0 to 31) of std_logic_vector(51 downto 0);
end data_types;