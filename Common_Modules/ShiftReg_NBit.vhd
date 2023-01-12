library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity ShiftReg_NBit is
    generic ( NBit : INTEGER := 8); 
    
    port(Clk : in std_logic;
        Rst_n : in std_logic;
        Load : in std_logic;
        Shift : in std_logic;
        Parallel_DIn : in unsigned ( NBit-1 downto 0);
        Serial_DIn : in std_logic;
        Parallel_DOut : out unsigned ( NBit-1 downto 0);
        Serial_Dout : out std_logic);
        
end ShiftReg_NBit;

Architecture Behavior of ShiftReg_NBit IS
    
    signal Data_SIG: unsigned ( NBit - 1 downto 0);
    
begin
    
    -- assign internal signal to output
    Serial_Dout <= Data_SIG(NBit - 1);
    Parallel_DOut <= Data_SIG;
    
    Reset_Process : process(Clk, Rst_n) begin
        if Rst_n = '0' then
            Data_SIG <= (OTHERS => '0');
        else
            if Load = '1' then
                if Clk = '1' then
                    Data_SIG <= Parallel_DIn;
                end if;
            elsif Shift = '1' then
                if Clk = '1' then
                    Data_SIG(NBit - 1 downto 1) <= Data_SIG(NBit - 2 downto 0);
                    Data_SIG(0) <= Serial_DIn;
                end if;
            end if;
        end if;
    end process;
    
END ARCHITECTURE Behavior;	