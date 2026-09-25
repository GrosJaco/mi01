-- 1) 
-- https://machines.brunet-zamansky.fr/automate/
-- name: Exercice 3
-- init: q0
-- accept: q5
-- q0,0,q0
-- q0,1,q1

-- q1,0,q1
-- q1,1,q2

-- q2,1,q2
-- q2,0,q3

-- q3,0,q3
-- q3,1,q4

-- q4,1,q4
-- q4,0,q5


-- 2)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity exercice_4 is
    Port (
        SW_0  : in  STD_LOGIC;
        BTN_D : in  STD_LOGIC;
        LED_0 : out STD_LOGIC
    );
end entity exercice_4;

architecture detecteur of exercice_4 is
begin
    process(BTN_D)
        variable etat : integer range 0 to 5 := 0;
    begin
        if rising_edge(BTN_D) then
            case etat is
                when 0 =>
                    if SW_0 = '1' then etat := 1; end if;
                when 1 =>
                    if SW_0 = '1' then etat := 2; end if;
                when 2 =>
                    if SW_0 = '0' then etat := 3; end if;
                when 3 =>
                    if SW_0 = '1' then etat := 4; end if;
                when 4 =>
                    if SW_0 = '0' then etat := 5; end if;
                when 5 =>
                    if SW_0 = '1' then
                        etat := 1;
                    else
                        etat := 0;
                    end if;
                when others =>
                    etat := 0;
            end case;

            if etat = 5 then
                LED_0 <= '1';
            else
                LED_0 <= '0';
            end if;

        end if;
    end process;
end architecture detecteur;