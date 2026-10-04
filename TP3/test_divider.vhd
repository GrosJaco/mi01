-- Exemple d'instanciation du diviseur de fréquence.
entity test_divider is
    port (CLK, BTN_C : in bit; LED_0 : out bit);
end test_divider;

architecture Behavioral of test_divider is
    component clock_divider
        generic(divisor : integer);
        port(clock_in, reset : in bit;
             clock_out : out bit);
    end component clock_divider;
    
begin
    CD :  clock_divider
        -- generic map permet l'affectation d'une valeur 
        -- aux paramètres du composant. Ici divisor prend la
        -- valeur 20000000 dans l'instance CD.
        generic map(divisor => 20000000)
        port map(clock_in => CLK, reset => BTN_C, clock_out => LED_0);
end Behavioral;