---------------------------------------------------------------------------------- 
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Petr Kastanek
-- Date: 2019-04-18
-- Design: top
-- Description: Top module for implementation stopwatch counter into 7-segment display.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Entity declaration for top level
--------------------------------------------------------------------------------
entity top is
    port (
        -- Global input signals at Coolrunner-II board
        sw_i : in std_logic_vector(1-1 downto 0);     -- set
        btn_i : in std_logic_vector(1-1 downto 0);		-- reset
		  clk_i : in std_logic;   -- just for disp_mux to light four 7-segment displays
        
        

        -- Global output signals at Coolrunner-II board
        disp_digit_o : out std_logic_vector(4-1 downto 0);  -- 7-segment
        disp_sseg_o  : out std_logic_vector(7-1 downto 0)
    );
end top;

--------------------------------------------------------------------------------
-- Architecture declaration for top level
--------------------------------------------------------------------------------
architecture Behavioral of top is
	signal sec_f_io : std_logic_vector(4-1 downto 0);
	signal sec_s_io : std_logic_vector(4-1 downto 0);
	signal min_f_io : std_logic_vector(4-1 downto 0);	
	signal min_s_io : std_logic_vector(4-1 downto 0);begin

-- sub-block of stopwatch counter
    CNT : entity work.cnt        
			port map (
            rst_n_i => sw_i(0),
				set_i => btn_i(0),
				
				sec_f_o => sec_f_io, 
				sec_s_o => sec_s_io,	
				min_f_o => min_f_io, 
				min_s_o => min_s_io        
			);
    
-- sub-block of display multiplexer
    DISPMUX : entity work.disp_mux
        port map (
            data0_i => sec_f_io,
            data1_i => sec_s_io,
            data2_i => min_f_io,
            data3_i => min_s_io,
            clk_i => clk_i,
            
            an_o => disp_digit_o,
            sseg_o => disp_sseg_o
        );
end Behavioral;
