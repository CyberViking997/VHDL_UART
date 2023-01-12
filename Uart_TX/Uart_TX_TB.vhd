library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
 
entity Uart_TX_TB is
end Uart_TX_TB;
 
architecture Behavioral of Uart_TX_TB is
    
    component Uart_TX IS
        generic( Clk_Per_Bit : integer := 1042);
        port(Clk : in std_logic;
            Rst_n : in std_logic;
            Write : in std_logic;
            DIn : in unsigned (7 downto 0);
            TX : out std_logic;
            Done : out std_logic);
    end component;
    
  signal Clk_SIG : std_logic := '0';
  signal Rst_SIG : std_logic := '0';
  signal Write_SIG : std_logic := '0';
  signal DIn_SIG : unsigned(7 downto 0);
  signal TX_SIG : std_logic := '0';
  signal Done_SIG : std_logic := '0';

begin

    Clock_Process : process begin  
        Clk_SIG <= not(Clk_SIG);
        wait for 50ns;
    end process;
    
    
    -- instantiate TìUart TX
    TX : Uart_TX 
        generic map(Clk_Per_Bit => 1042)
        port map(Clk => Clk_SIG,
                Rst_n => Rst_SIG,
                Write => Write_SIG,
                DIn => DIn_SIG,
                TX => TX_SIG,
                Done => Done_SIG);
                
    
    Data_Process : process
        variable seed1, seed2: positive;  -- seed values for random generator
        variable rand: real;              -- random real-number value in range 0 to 1.0
        variable int_rand: integer;       -- random integer value in range 0..4095
    begin
        DIn_SIG <= "00000000";
        wait for 200ns;
        Rst_SIG <= '1';
        
        for i in 0 to 10 loop   -- loop for test values
            wait for 50ns;
            Write_SIG <= '1';
            
            uniform(seed1, seed2, rand);
            int_rand := integer(trunc(rand*255.0));
            DIn_SIG <= to_unsigned(int_rand, 8);
            
            
            wait for 100ns;
            Write_SIG <= '0';
            
            while Done_SIG = '0' loop
                wait for 100ns;
            end loop;
    
            
        end loop;
        
        assert false report "Simulation Finished" severity failure;

    end process;
    
    
    
   
end Behavioral;
