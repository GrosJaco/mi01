library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carrefour is
    port (
        CLK     : in  bit;
        BTN_C   : in  bit;
        LED_3_0 : out bit_vector(2 downto 0); 
        LED_7_4 : out bit_vector(2 downto 0) 
    );
end entity carrefour;

architecture Behavioral of carrefour is

    component clock_divider is
        generic (divisor : integer);
        port (
            clock_in  : in  bit;
            reset     : in  bit;
            clock_out : out bit
        );
    end component;

    signal clk_1hz : bit;
    signal timer   : integer range 0 to 19 := 0;

begin

    -- Diviseur 100 MHz -> 1 Hz
    DIV_1HZ : clock_divider
        generic map (divisor => 100000000)
        port map (
            clock_in  => CLK,
            reset     => BTN_C,
            clock_out => clk_1hz
        );

    -- Cycle de 20 secondes
    process(clk_1hz, BTN_C)
    begin
        if BTN_C = '1' then
            timer <= 0;
        elsif clk_1hz'event and clk_1hz = '1' then
            if timer = 19 then
                timer <= 0;
            else
                timer <= timer + 1;
            end if;
        end if;
    end process;

    process(timer)
    begin
        if timer < 8 then
            -- 0 à 7: 1 Vert, 2 Rouge
            LED_3_0 <= "001";
            LED_7_4 <= "100";
        elsif timer < 10 then
            -- 8 à 9: 1 Orange, 2 Rouge
            LED_3_0 <= "010";
            LED_7_4 <= "100";
        elsif timer < 18 then
            -- 10 à 17: 1 Rouge, 2 Vert
            LED_3_0 <= "100";
            LED_7_4 <= "001";
        else
            -- 18 à 19: 1 Rouge, 2 Orange
            LED_3_0 <= "100";
            LED_7_4 <= "010";
        end if;
    end process;

end architecture Behavioral;