library ieee;  
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Uart_TX IS
    generic( Clk_Per_Bit : integer := 1042);
    port(Clk : in std_logic;
        Rst_n : in std_logic;
        Write : in std_logic;
		DIn : in unsigned (7 downto 0);
		TX : out std_logic;
		Done : out std_logic);
end entity Uart_TX;

architecture Behavior OF Uart_TX IS
    
    component Uart_TX_DP is
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
    end component;

    component Uart_TX_CU IS
        port(Clk : in std_logic;
            -- inputs from outside world
            Rst_n : in std_logic;
            Write : in std_logic;
            -- inputs from module
            Count_TBit_Tc : in std_logic;
            Count_Bit_Tc : in std_logic;
            -- outputs to module
            Count_TBit_En : out std_logic;
            Count_TBit_Rst_n : out std_logic;
            Count_Bit_En : out std_logic;
            Count_Bit_Rst_n : out std_logic;
            Shift_Reg_Ld : out std_logic;
            Shift_Reg_Sh : out std_logic;
            Shift_Reg_Rst_n : out std_logic;
            Reg_In_En : out std_logic;
            Reg_In_Rst_n : out std_logic;
            Force_1 : out std_logic;
            Force_0 : out std_logic;
            -- output to the outside world
            Done : out std_logic);
    end component;
    
    signal Force_1_SIG, Force_0_SIG : std_logic;        -- signal to force start and stop bit
    signal Count_TBit_En_SIG, Count_TBit_Rst_n_SIG, Count_TBit_Tc_SIG : std_logic;
    signal Count_Bit_En_SIG, Count_Bit_Rst_n_SIG, Count_Bit_Tc_SIG : std_logic;
    signal Shift_Reg_Ld_SIG, Shift_Reg_Sh_SIG, Shift_Reg_Rst_n_SIG : std_logic;
    signal Reg_In_En_SIG, Reg_In_Rst_n_SIG : std_logic;
    
    
begin
    
    Datapath : Uart_TX_DP 
        generic map(Clk_Per_Bit => Clk_Per_Bit)
        port map(Clk => Clk,
                DIn => DIn,
                Count_TBit_En => Count_TBit_En_SIG,
                Count_TBit_Rst_n => Count_TBit_Rst_n_SIG,
                Count_Bit_En => Count_Bit_En_SIG,
                Count_Bit_Rst_n => Count_Bit_Rst_n_SIG,
                Shift_Reg_Ld => Shift_Reg_Ld_SIG,
                Shift_Reg_Sh => Shift_Reg_Sh_SIG,
                Shift_Reg_Rst_n => Shift_Reg_Rst_n_SIG,
                Reg_In_En => Reg_In_En_SIG,
                Reg_In_Rst_n => Reg_In_Rst_n_SIG,
                Force_1 => Force_1_SIG,
                Force_0 => Force_0_SIG,
                Count_TBit_Tc => Count_TBit_Tc_SIG,
                Count_Bit_Tc => Count_Bit_Tc_SIG,
                DOut => TX); 
                            
    Control_Unit : Uart_TX_CU
        port map(Clk => Clk,
            Rst_n => Rst_n,
            Write => Write,
            Count_TBit_Tc => Count_TBit_Tc_SIG,
            Count_Bit_Tc => Count_Bit_Tc_SIG,
            Count_TBit_En => Count_TBit_En_SIG,
            Count_TBit_Rst_n => Count_TBit_Rst_n_SIG,
            Count_Bit_En => Count_Bit_En_SIG,
            Count_Bit_Rst_n => Count_Bit_Rst_n_SIG,
            Shift_Reg_Ld => Shift_Reg_Ld_SIG,
            Shift_Reg_Sh => Shift_Reg_Sh_SIG,
            Shift_Reg_Rst_n => Shift_Reg_Rst_n_SIG,
            Reg_In_En => Reg_In_En_SIG,
            Reg_In_Rst_n => Reg_In_Rst_n_SIG,
            Force_1 => Force_1_SIG,
            Force_0 => Force_0_SIG,
            Done => Done);

end architecture;