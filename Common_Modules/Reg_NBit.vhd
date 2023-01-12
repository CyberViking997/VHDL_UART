library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_NBit is
        generic ( NBit : integer:=8); 
        port(Clk : in std_logic;
            Rst_n  : in std_logic;
            En : in std_logic;
            DIn: in unsigned ( NBit-1 downto 0);
            DOut: out unsigned ( NBit-1 downto 0));
end Reg_NBit;

architecture Behavior of Reg_NBit IS
    
    signal Data_SIG : unsigned ( NBit-1 DOWNTO 0);
    
begin
    
    -- assign data to output
    DOut <= Data_SIG;
    
    Data_Process : process (Clk, Rst_n) begin
        if Rst_n = '0' then
            Data_SIG <= (others => '0');
        elsif En = '1' then
            if Clk = '1' then
                Data_SIG <= DIn;
            end if;
        end if;

    end process;
    
    
END ARCHITECTURE Behavior;	
