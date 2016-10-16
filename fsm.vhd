library ieee;
use ieee.std_logic_1164.all;
use work.data_types.all;

entity fsm is port (
	fsm_clock: in std_logic;
	fsm_reset: in std_logic;
	fsm_trigger: in std_logic;
	fsm_compute_output: in std_logic_vector(3 downto 0);
	fsm_state: out state_type;
	fsm_input_ready: out std_logic;
	fsm_output_ready: out std_logic;
	fsm_destination_port: out std_logic_vector(3 downto 0)
	);
end fsm;

architecture fsm_rtl of fsm is
	signal state_reg: state_type;
	signal state_next: state_type;
	
	begin
	
	-- TODO unsure if we added fsm_compute_output to sensitivity list
	process (fsm_clock, fsm_reset, fsm_compute_output)
	begin
		fsm_destination_port <= fsm_compute_output;
		if (fsm_reset = '1') then
			state_reg <= reset_state;
		elsif (fsm_clock'event and fsm_clock = '1') then
			state_reg <= state_next;
		end if;
	end process;

	process (state_reg, fsm_trigger)
	begin
		fsm_state <= state_reg;
		case state_reg is
			when reset_state =>
				if (fsm_trigger = '1') then
					state_next <= read_state;
				else
					state_next <= reset_state;
				end if;
				fsm_input_ready <= '1';
				fsm_output_ready <= '0';
			when read_state => 
				fsm_input_ready <= '0';
				fsm_output_ready <= '0';
				state_next <= write_state;
			when write_state =>
				fsm_input_ready <= '0';
				fsm_output_ready <= '1';
				state_next <= reset_state;
		end case;
	end process;
	
end fsm_rtl;