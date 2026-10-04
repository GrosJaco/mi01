library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carrefour_capteurs is
    port (
        CLK : in  bit;
        BTN_C : in  bit;
        BTN_G : in  bit;
        BTN_H : in  bit;
        LED_3_0 : out bit_vector(2 downto 0);
        LED_7_4 : out bit_vector(2 downto 0)
    );
end entity carrefour_capteurs;

architecture Behavioral of carrefour_capteurs is

    component clock_divider is
        generic (divisor : integer);
        port (
            clock_in : in  bit;
            reset : in  bit;
            clock_out : out bit
        );
    end component;

    type t_etat is (VERT_1, ORANGE_1, VERT_2, ORANGE_2);
    signal etat_present : t_etat := VERT_1;
    signal timer : integer range 0 to 15 := 0;
    signal clk_1hz : bit;

begin

    -- Diviseur 100 MHz vers 1 Hz
    DIV_1HZ : clock_divider
        generic map (divisor => 100000000)
        port map (
            clock_in => CLK,
            reset => '0',
            clock_out => clk_1hz
        );

    -- Machine à états
    process(clk_1hz)
    begin
        if clk_1hz'event and clk_1hz = '1' then
            if BTN_C = '1' then
                etat_present <= VERT_1;
                timer <= 0;
            else
                case etat_present is

                    when VERT_1 =>
                        if timer < 8 then
                            timer <= timer + 1;
                        elsif BTN_H = '1' then
                            etat_present <= ORANGE_1;
                            timer <= 0;
                        end if;

                    when ORANGE_1 =>
                        if timer < 1 then
                            timer <= timer + 1;
                        else
                            etat_present <= VERT_2;
                            timer <= 0;
                        end if;

                    when VERT_2 =>
                        if timer < 8 then
                            timer <= timer + 1;
                        elsif BTN_G = '1' then
                            etat_present <= ORANGE_2;
                            timer <= 0;
                        end if;

                    when ORANGE_2 =>
                        if timer < 1 then
                            timer <= timer + 1;
                        else
                            etat_present <= VERT_1;
                            timer <= 0;
                        end if;

                end case;
            end if;
        end if;
    end process;

    process(etat_present)
    begin
        case etat_present is
            when VERT_1 =>
                LED_3_0 <= "001";
                LED_7_4 <= "100";
            when ORANGE_1 =>
                LED_3_0 <= "010";
                LED_7_4 <= "100";
            when VERT_2 =>
                LED_3_0 <= "100";
                LED_7_4 <= "001";
            when ORANGE_2 =>
                LED_3_0 <= "100";
                LED_7_4 <= "010";
        end case;
    end process;

end architecture Behavioral;