library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Counter_NBit_TC is
    generic(NBit : integer := 3;
            Max_Cnt : integer := 2**3); 
    port(Clk : in std_logic;
        Rst_n : in std_logic;
        En : in std_logic;
        Cnt : out unsigned( NBit - 1 downto 0);
        Tc : out std_logic);
        
end Counter_NBit_TC;

architecture behavior of Counter_NBit_TC is    
    
    signal cnt_SIG : UNSIGNED ( NBit-1 DOWNTO 0 );
    
begin
    
    -- Assign internal count to Cnt
    Cnt <= cnt_SIG;
    
    Count_Update : process(Rst_n, Clk)
    begin
        if (Rst_n = '0') then
            cnt_SIG <= (others => '0');
            Tc <= '0';
        elsif Clk = '1' then
            if Rst_n = '1' and En = '1' then
                if cnt_SIG < Max_Cnt then
                    cnt_SIG <= cnt_SIG + 1;
                    Tc <= '0';
                else
                    cnt_SIG <= (others => '0');
                    Tc <= '1';
                end if;
            end if;
        end if;
    end process;
    
END ARCHITECTURE behavior;	