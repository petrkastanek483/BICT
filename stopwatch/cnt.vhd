--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Petr Kastanek 
-- Date: 2019-04-18
-- Design: cnt
-- Description: Counter for stopwatch.
--------------------------------------------------------------------------------
-- TODO: count seconds and minutes
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;    -- for  arithmetic operations

--------------------------------------------------------------------------------
-- Entity declaration for counter
--------------------------------------------------------------------------------
entity cnt is
    generic (
        N_BIT : integer := 4        -- default number of bits
    );
    port (
        -- Entity input signals
--        clk_n_i   : in std_logic;
	  set_i    : in std_logic;     -- set  =0: stop
                                    --       =1: count
        rst_n_i : in std_logic;     -- reset =0: reset active
                                    --       =1: no reset
        -- Entity output signals
        sec_f_o : out std_logic_vector(N_BIT-1 downto 0);
	sec_s_o : out std_logic_vector(N_BIT-1 downto 0);
	min_f_o : out std_logic_vector(N_BIT-1 downto 0);
	min_s_o : out std_logic_vector(N_BIT-1 downto 0)
    );
end cnt;

--------------------------------------------------------------------------------
-- Architecture declaration for counter
--------------------------------------------------------------------------------
architecture Behavioral of cnt is
    signal sec_fi_o  : std_logic_vector(N_BIT-1 downto 0);
    signal sec_si_o : std_logic_vector(N_BIT-1 downto 0);
	signal min_fi_o : std_logic_vector(N_BIT-1 downto 0);
    signal min_si_o : std_logic_vector(N_BIT-1 downto 0);
    
   signal sec_fis_o  : std_logic_vector(N_BIT-1 downto 0);
    signal sec_sis_o : std_logic_vector(N_BIT-1 downto 0);
	signal min_fis_o : std_logic_vector(N_BIT-1 downto 0);
    signal min_sis_o : std_logic_vector(N_BIT-1 downto 0);
    
    signal sec_fin_o  : std_logic_vector(N_BIT-1 downto 0);
    signal sec_sin_o : std_logic_vector(N_BIT-1 downto 0);
	signal min_fin_o : std_logic_vector(N_BIT-1 downto 0);
    signal min_sin_o : std_logic_vector(N_BIT-1 downto 0);
    
    signal clk_sfi_o: std_logic := '1';
	 signal clk_ssi_o: std_logic := '1';
	 signal clk_mfi_o: std_logic := '1';
	 signal clk_msi_o: std_logic := '1';
    
Begin
--------------------------------------------------------------------------------
-- Declaration of clock signals.
--------------------------------------------------------------------------------

clk_sfi_o <=  '0' after 500 ms when clk_sfi_o = '1' else -- for seconds
        '1' after 500 ms when clk_sfi_o = '0';

clk_ssi_o <=  '0' after 5000 ms when clk_ssi_o = '1' else -- for tens of seconds
        '1' after 5000 ms when clk_ssi_o = '0';

clk_mfi_o <=  '0' after 50000 ms when clk_mfi_o = '1' else -- for minutes
        '1' after 50000 ms when clk_mfi_o = '0';

clk_msi_o <=  '0' after 500000 ms when clk_msi_o = '1' else -- for tens of minutes
        '1' after 500000 ms when clk_msi_o = '0';


--------------------------------------------------------------------------------
-- Register
--------------------------------------------------------------------------------
p_cnt: process(clk_ssi_o,clk_mfi_o,clk_msi_o,clk_sfi_o,rst_n_i,sec_fi_o,sec_si_o,min_fi_o,min_si_o,set_i,sec_fis_o,sec_sis_o,min_fis_o,min_sis_o)
    begin 
	 
			if (rst_n_i = '0') then              --synchronous reset

                sec_fi_o <= (others => '0');
                sec_si_o <= (others => '0');   
                min_fi_o <= (others => '0');   
                min_si_o <= (others => '0');
					 
					 elsif (rst_n_i = '1' and set_i = '0') then   -- stopped time
							sec_fi_o <= sec_fis_o;
							sec_si_o <= sec_sis_o;  
							min_fi_o <= min_fis_o;   
							min_si_o <= min_sis_o; 
					
						elsif (rst_n_i = '1' and set_i = '1') then --  counting
                  
							if rising_edge(clk_sfi_o) then
           
                        if sec_fi_o = "1001" then	-- countig seconds		
                            sec_fi_o <= "0000";
                             
                        else
                            sec_fi_o <= sec_fin_o;
                        end if;
							end if;	
							
							if rising_edge(clk_ssi_o)  then  -- counting tens of seconds
								if sec_si_o = "0101" then
                                sec_si_o <= "0000";
                                
                                else
                                sec_si_o <= sec_sin_o;
           
                            end if;
                     end if;      
                     
							if rising_edge(clk_mfi_o)  then  -- counting minutes
								if min_fi_o = "1001" then
                                min_fi_o <= "0000";
                                
                                else
                                min_fi_o <= min_fin_o;
                            end if;
                     end if;                   
                     
							if rising_edge(clk_msi_o)  then  -- counting tens of minutes
								if min_si_o = "0101" then
                                min_si_o <= "0000";
                                else
                                min_si_o <= min_sin_o;
                            end if;
							end if;
			end if;                        
               
end process p_cnt;

    
--------------------------------------------------------------------------------
-- Next-state logic
--------------------------------------------------------------------------------    
   sec_fin_o <= sec_fi_o + 1;
	sec_sin_o <= sec_si_o + 1;
	min_fin_o <= min_fi_o + 1;
	min_sin_o <= min_si_o + 1;
--------------------------------------------------------------------------------
-- Stop-state logic
--------------------------------------------------------------------------------   
	sec_fis_o <= sec_fi_o;
	sec_sis_o <= sec_si_o;
	min_fis_o <= min_fi_o;
	min_sis_o <= min_si_o;	
--------------------------------------------------------------------------------
-- Output logic
--------------------------------------------------------------------------------   
   sec_f_o <= sec_fi_o ;
	sec_s_o <= sec_si_o ;
	min_f_o <= min_fi_o ;
	min_s_o <= min_si_o ;

end Behavioral;


