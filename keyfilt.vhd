library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity keyfilt is
  port (clk  : in  std_logic;
		keyTimeSet : in  std_logic;
		keyTimeSetfilt : out std_logic;
		keyClockSet : in  std_logic;
		keyClockSetfilt : out std_logic;
		keyClockQuit : in  std_logic;
		keyClockQuitfilt : out std_logic;
      	keyNumAdd : in std_logic;
      	keyNumAddfilt : out std_logic;
		keyLeftMove : in std_logic;
		keyLeftMovefilt : out std_logic
		);
end keyfilt;
architecture behavioral of keyfilt is
	signal keyTimeSetcnt : integer range 0 to 50000000; 
	signal keyClockSetcnt : integer range 0 to 50000000; 
	signal keyClockQuitcnt : integer range 0 to 50000000; 
	signal keyLeftMovecnt : integer range 0 to 50000000;
    signal keyNumAddcnt : integer range 0 to 50000000;
	constant N :integer := 5000000;	
begin
	process (clk)
	begin 
		if clk'event and clk = '1' then
			if keyTimeSet = '0' then 	
				if keyTimeSetcnt /= N then 
					keyTimeSetcnt<= keyTimeSetcnt + 1;
				end if;
				if keyTimeSetcnt = N-1 then 
					keyTimeSetfilt<= '1';
				else
					keyTimeSetfilt<= '0';
				end if;
			else 				
				keyTimeSetcnt<= 0;
			end if;

			if keyClockSet = '0' then 	
				if keyClockSetcnt /= N then 
					keyClockSetcnt<= keyClockSetcnt + 1;
				end if;
				if keyClockSetcnt = N-1 then 
					keyClockSetfilt<= '1';
				else
					keyClockSetfilt<= '0';
				end if;
			else 				
				keyClockSetcnt<= 0;
			end if;

			if keyClockQuit = '0' then 	
				if keyClockQuitcnt /= N then 
					keyClockQuitcnt<= keyClockQuitcnt + 1;
				end if;
				if keyClockQuitcnt = N-1 then 
					keyClockQuitfilt<= '1';
				else
					keyClockQuitfilt<= '0';
				end if;
			else 				
			keyClockQuitcnt<= 0;
			end if;

            if keyNumAdd = '0' then 	
                if keyNumAddcnt /= N then 
                    keyNumAddcnt<= keyNumAddcnt + 1;
                end if;
                if keyNumAddcnt = N-1 then 
                    keyNumAddfilt<= '1';
                else
                    keyNumAddfilt<= '0';
                end if;
            else 				
                keyNumAddcnt<= 0;
            end if;

			if keyLeftMove = '0' then 	
				if keyLeftMovecnt /= N then 
					keyLeftMovecnt<= keyLeftMovecnt + 1;
				end if;
				if keyLeftMovecnt = N-1 then 
					keyLeftMovefilt<= '1';
				else
					keyLeftMovefilt<= '0';
				end if;
			else 				
				keyLeftMovecnt<= 0;
			end if;

		end if;	
	end process;		
end behavioral;
