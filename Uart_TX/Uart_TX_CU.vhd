library ieee;
use ieee.std_logic_1164.all;

entity Uart_TX_CU is
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
end Uart_TX_CU;

architecture Behavioral of Uart_TX_CU is 
    
    type FSM_STATE is (RST_S, IDLE_S, LOAD_S, CNT_S, SHIFT_S, DONE_S);
    signal Present_State, Next_State : FSM_STATE;		
begin 

    -- update current state
	state_update_process: process(Clk, Rst_n)
	begin
		if (Rst_n = '0') then
				Present_State <= RST_S;
		elsif rising_edge(Clk) then
				Present_State <= Next_State;
		end if;
	end process;
	
    -- calculate next state
	next_state_process: process(Present_State, Write, Count_TBit_Tc, Count_Bit_Tc)
	begin 
		case Present_State is
		    when RST_S =>
		        Next_State <= IDLE_S;
		        
			when IDLE_S => 
				if (Write = '1') then 
				    Next_State <= LOAD_S;
				else 
				    Next_State <= IDLE_S;
				end if;
		
			when LOAD_S =>
				Next_State <= CNT_S;
			
			when CNT_S =>
                if (Count_Bit_Tc = '1' and Count_TBit_Tc = '1') then 
                    Next_State <= DONE_S;
                elsif (Count_TBit_Tc = '1') then
                    Next_State <= SHIFT_S;
                else
                   Next_State <= CNT_S; 
                end if;
							
			when SHIFT_S => 
				Next_State <= CNT_S;
				
			when DONE_S => 
				Next_State <= IDLE_S;
		end case;
	end process;
	
    -- output generation process
	output_process: process(Present_State)
	begin 	
		case Present_State is
		    when RST_S =>
                Count_TBit_En <= '0';
                Count_TBit_Rst_n <= '0';
                Count_Bit_En <= '0';
                Count_Bit_Rst_n <= '0';
                Shift_Reg_Ld <= '0';
                Shift_Reg_Sh <= '0';
                Shift_Reg_Rst_n <= '0';
                Reg_In_En <= '0';
                Reg_In_Rst_n <= '0';
                Force_1 <= '0';
                Force_0 <= '0';

                Done <= '0';
                
			when IDLE_S =>
				Count_TBit_En <= '0';
                Count_TBit_Rst_n <= '1';
                Count_Bit_En <= '0';
                Count_Bit_Rst_n <= '0';
                Shift_Reg_Ld <= '0';
                Shift_Reg_Sh <= '0';
                Shift_Reg_Rst_n <= '1';
                Reg_In_En <= '1';
                Reg_In_Rst_n <= '1';
                Force_1 <= '1';
                Force_0 <= '0';

                Done <= '0';
				
			when LOAD_S =>
				Count_TBit_En <= '0';
                Count_TBit_Rst_n <= '1';
                Count_Bit_En <= '0';
                Count_Bit_Rst_n <= '1';
                Shift_Reg_Ld <= '1';
                Shift_Reg_Sh <= '0';
                Shift_Reg_Rst_n <= '1';
                Reg_In_En <= '0';
                Reg_In_Rst_n <= '1';
                Force_1 <= '1';
                Force_0 <= '0';

                Done <= '0';
				
			when CNT_S =>
				Count_TBit_En <= '1';
                Count_TBit_Rst_n <= '1';
                Count_Bit_En <= '0';
                Count_Bit_Rst_n <= '1';
                Shift_Reg_Ld <= '0';
                Shift_Reg_Sh <= '0';
                Shift_Reg_Rst_n <= '1';
                Reg_In_En <= '0';
                Reg_In_Rst_n <= '1';
                Force_1 <= '1';
                Force_0 <= '0';

                Done <= '0';
			
			when SHIFT_S => 
				Count_TBit_En <= '0';
                Count_TBit_Rst_n <= '0';
                Count_Bit_En <= '1';
                Count_Bit_Rst_n <= '1';
                Shift_Reg_Ld <= '0';
                Shift_Reg_Sh <= '1';
                Shift_Reg_Rst_n <= '1';
                Reg_In_En <= '0';
                Reg_In_Rst_n <= '1';
                Force_1 <= '1';
                Force_0 <= '0';

                Done <= '0';
				
			when DONE_S => 
				Count_TBit_En <= '0';
                Count_TBit_Rst_n <= '0';
                Count_Bit_En <= '0';
                Count_Bit_Rst_n <= '0';
                Shift_Reg_Ld <= '0';
                Shift_Reg_Sh <= '0';
                Shift_Reg_Rst_n <= '0';
                Reg_In_En <= '0';
                Reg_In_Rst_n <= '0';
                Force_1 <= '1';
                Force_0 <= '0';

                Done <= '1';
		end case;
	end process output_process;
end architecture;	