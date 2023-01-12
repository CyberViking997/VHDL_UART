library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Uart_TX_DP is
    generic( Clk_Per_Bit : integer := 1042);
    port(Clk : in std_logic;
		DIn : in unsigned (7 DOWNTO 0);
        -- Commands from control unit
        Count_TBit_En : in std_logic;
        Count_TBit_Rst_n : in std_logic;
        Count_Bit_En : in std_logic;
        Count_Bit_Rst_n : in std_logic;
        Shift_Reg_Ld : in std_logic;
        Shift_Reg_Sh : in std_logic;
        Shift_Reg_Rst_n : in std_logic;
        Reg_In_En : in std_logic;
        Reg_In_Rst_n : in std_logic;
        Force_1 : in std_logic;
        Force_0 : in std_logic;
		-- Outputs to control unit
        Count_TBit_Tc : out std_logic;
        Count_Bit_Tc : out std_logic;
		-- OUTPUTs SIGNALs
		DOut : out std_logic);
		
end Uart_TX_DP;

architecture behavior of Uart_TX_DP IS

    component ShiftReg_NBit is
        generic ( NBit : INTEGER := 8); 
        port(Clk : in std_logic;
            Rst_n : in std_logic;
            Load : in std_logic;
            Shift : in std_logic;
            Parallel_DIn : in unsigned ( NBit-1 downto 0);
            Serial_DIn : in std_logic;
            Parallel_DOut : out unsigned ( NBit-1 downto 0);
            Serial_Dout : out std_logic);  
    end component;
    
    component Reg_NBit is
        generic ( NBit : integer:=8); 
        port(Clk : in std_logic;
            Rst_n  : in std_logic;
            En : in std_logic;
            DIn: in unsigned ( NBit-1 downto 0);
            DOut: out unsigned ( NBit-1 downto 0));
    end component;
    	
	component Counter_NBit_TC is
        generic(NBit : integer := 3;
                Max_Cnt : integer := 2**3); 
        port(Clk : in std_logic;
            Rst_n : in std_logic;
            En : in std_logic;
            Cnt : out unsigned( NBit - 1 downto 0);
            Tc : out std_logic);  
    end component;
    
    signal Data_Delayed_SIG : unsigned (7 DOWNTO 0);
    signal Shift_Reg_In : unsigned (9 DOWNTO 0);
    
BEGIN
    
    -- input register -> delay input data
    Reg_In : Reg_NBit 
        generic map( NBit => 8)
        port map(Clk => Clk,
                Rst_n => Reg_In_Rst_n,
                En => Reg_In_En,
                DIn => DIn,
                DOut => Data_Delayed_SIG);
                
    -- assign data to shift register input port
    Shift_Reg_In <= Force_0 & Data_Delayed_SIG & Force_1;
    
    -- shift register -> hold data to be sent
    PISO : ShiftReg_NBit
        generic map( NBit => 10)
        port map(Clk => Clk,
                Rst_n => Shift_Reg_Rst_n,
                Load => Shift_Reg_Ld,
                Shift => Shift_Reg_Sh,
                Parallel_DIn => Shift_Reg_In,
                Serial_DIn => '0',
                Parallel_DOut => open,
                Serial_Dout => DOut);  

    -- counter for the number of bit sent  
    Counter_Bit : Counter_NBit_TC
        generic map(NBit => 4,
                    Max_Cnt => 8) 
        port map(Clk => Clk,
                Rst_n => Count_Bit_Rst_n,
                En => Count_Bit_En,
                Cnt => open,
                Tc => Count_Bit_Tc); 
                
                 
    -- counter for the number of bit sent  
    Counter_TBit : Counter_NBit_TC
        generic map(NBit => 12,
                    Max_Cnt => (Clk_Per_Bit - 2))
        port map(Clk => Clk,
                Rst_n => Count_TBit_Rst_n,
                En => Count_TBit_En,
                Cnt => open,
                Tc => Count_TBit_Tc); 

END ARCHITECTURE behavior;	

