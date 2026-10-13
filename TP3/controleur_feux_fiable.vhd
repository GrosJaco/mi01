library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controleur_feux_fiable is
    port (
        CLK     : in bit;
        BTN_C   : in bit;
        LED_3_0 : out bit_vector(3 downto 0);
        LED_7_4 : out bit_vector(3 downto 0) 
    );
end controleur_feux_fiable;


architecture Behavioral of controleur_feux_fiable is


    component clock_divider
        generic(divisor : integer);
        port(
            clock_in : in bit;
            reset : in bit;
            clock_out : out bit
        );
    end component;


    signal clk_1Hz : bit;


    type state_type is (PHASE_1, PHASE_2, PHASE_3, PHASE_4);
    signal etat_courant : state_type := PHASE_1;


    signal compteur : integer range 0 to 10 := 0;


begin



    diviseur_inst : clock_divider
        generic map (divisor => 100000000)
        port map (
            clock_in => CLK,
            reset => '0',
            clock_out => clk_1Hz
        );

    process(clk_1Hz)
    begin
        if clk_1Hz'event and clk_1Hz = '1' then
            if BTN_C = '1' then
                etat_courant <= PHASE_1;
                compteur <= 0;
            else
                compteur <= compteur + 1;

                case etat_courant is
                    when PHASE_1 =>
                        if compteur >= 7 then
                            etat_courant <= PHASE_2;
                            compteur <= 0;
                        end if;

                    when PHASE_2 =>
                        if compteur >= 1 then
                            etat_courant <= PHASE_3;
                            compteur <= 0;
                        end if;

                    when PHASE_3 =>
                        if compteur >= 7 then
                            etat_courant <= PHASE_4;
                            compteur <= 0;
                        end if;

                    when PHASE_4 =>
                        if compteur >= 1 then
                            etat_courant <= PHASE_1;
                            compteur <= 0;
                        end if;
                end case;
            end if;
        end if;
    end process;

    process(etat_courant)
    begin
        case etat_courant is
            when PHASE_1 =>
                LED_3_0 <= "0001";
                LED_7_4 <= "0100";
            when PHASE_2 =>
                LED_3_0 <= "0010";
                LED_7_4 <= "0100";
            when PHASE_3 =>
                LED_3_0 <= "0100"; 
                LED_7_4 <= "0001";
            when PHASE_4 =>
                LED_3_0 <= "0100"; 
                LED_7_4 <= "0010";
        end case;
    end process;


end Behavioral;


-- 
