-- StateMachineVHDL.vhd
-- Four-State Moore State Machine
-- Richard Barrezueta
-- June 14, 2024

library ieee;
use ieee.std_logic_1164.all;

entity StateMachineVHDL is
        port(
                    in_L_W	 : in	std_logic_vector(1 downto 0);
                    clk		 : in	std_logic;
                    resetn	 : in	std_logic;
                    out_CW_Y	 : out	std_logic_vector(1 downto 0)
            );
end entity;

architecture rtl of StateMachineVHDL is

        -- Build an enumerated type for the state machine
        -- Two-bit length
        type state_type is (Both_Off, Both_On, Cool);

        -- Register to hold the current state
        signal state   : state_type;

begin

        -- Logic to advance to the next state
        process (clk, resetn)
        begin
                if resetn = '0' then
                        state <= Both_Off;
                elsif (rising_edge(clk)) then
                        case state is
                                when Both_Off =>
                                        if in_L_W = "00" or in_L_W = "01" then
                                                state <= Cool;
                                        else
                                                state <= Both_On;
                                        end if;

                                when Both_On =>
                                        if in_L_W = "10" then
                                                state <= Both_Off;
                                        elsif in_L_W = "01" or in_L_W = "00" then
                                                state <= Cool;
                                        else
                                                state <= Both_On;
                                        end if;

                                when Cool =>
                                        if in_L_W = "00" then
                                                state <= Both_Off;
                                        else
                                                state <= Both_On;
                                        end if;
                        end case;
                end if;
        end process;

        -- Output depends solely on the current state
        process (state)
        begin
                case state is
                        when Both_Off =>
                                out_CW_Y <= "00";

                        when Both_On =>
                                out_CW_Y <= "11";

                        when Cool =>
                                out_CW_Y <= "10";

                end case;
        end process;
end rtl;
