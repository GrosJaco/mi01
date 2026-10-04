-- Diviseur de fréquence à reset asynchrone.
-- Divise la fréquence du signal clock_in par divisor
-- f(clock_out) = f(clock_in) / (divisor)
entity clock_divider is
    -- La clause generic permet de définir des paramètres pour l'entité qui
    -- pourront être modifiés lors de l'instanciation du composant.
    generic(divisor : integer := 100000000);
    port(clock_in, reset : in bit; clock_out : out bit);
end clock_divider;

architecture Behavioral of clock_divider is
begin 
    process(clock_in, reset)
        variable c : integer range 0 to divisor - 1 := 0;
        variable clock_sync : bit;
    begin
        if reset = '1' then
            c := 0;
            clock_sync := '0';
        elsif clock_in'event and clock_in = '1' then
            -- Gestion de l'état du compteur de temps
            if (c < divisor - 1) then
                c := c + 1;
            else
                c := 0;
            end if;
            
            -- Calcul de l'état du signal divisé
            if c < (divisor / 2) then
                clock_sync := '1';
            else 
                clock_sync := '0';
            end if;
        end if;
        -- Affectation de la sortie
        clock_out <= clock_sync;
    end process;
end Behavioral;

