library ieee;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity content_final_work_v2 is
    PORT(clk : IN STD_LOGIC;
        SEG_LED : OUT STD_LOGIC_VECTOR(6 downto 0);
        SEG_NCS : OUT STD_LOGIC_VECTOR(5 downto 0);
        segdot : OUT STD_LOGIC;
        key1 : IN STD_LOGIC;   --keyTimeSet
        key2 : IN STD_LOGIC;    --keyClockSet
        key5 : IN STD_LOGIC;    --keyQuitClock
        key6 : IN STD_LOGIC;    --keyNumAdd
        key7 : IN STD_LOGIC  	--keyLeftMove
    );
END content_final_work_v2;

ARCHITECTURE behav OF content_final_work_v2 IS
    SIGNAL bcd_led  :  STD_LOGIC_VECTOR(3 DOWNTO 0) := (others=>'0'); 
    SIGNAL clkcnt : STD_LOGIC_VECTOR(30 DOWNTO 0) := (others =>'0');
    SIGNAL bcddata_Time : STD_LOGIC_VECTOR(23 downto 0) := (others=>'0'); 
    SIGNAL bcddata_TimeSet : STD_LOGIC_VECTOR(23 downto 0):=(others=>'0'); 
    SIGNAL bcddata_ClockSet : STD_LOGIC_VECTOR(23 downto 0):=(others=>'0'); 

    SIGNAL a: integer range 0 to 249999999 :=0; 
    SIGNAL clk_1Hz,q : STD_LOGIC :='0';
    SIGNAL clk_1Hz_4vectors : STD_LOGIC_VECTOR(3 DOWNTO 0) :="0000";    

    SIGNAL keyTimeSetfilt : STD_LOGIC := '0';
    SIGNAL TimeSetting : STD_LOGIC := '1';
    SIGNAL keyClockSetfilt : STD_LOGIC := '0';
    SIGNAL ClockSetting : STD_LOGIC := '1'; 
    SIGNAL keyClockQuitfilt : STD_LOGIC := '0';
    SIGNAL ClockTwinkling : STD_LOGIC := '0';
    SIGNAL keyNumAddfilt : STD_LOGIC := '0';
    SIGNAL keyLeftMovefilt : STD_LOGIC := '0';
    SIGNAL LeftMoving : BIT_VECTOR(4 DOWNTO 0) :="11110";

    SHARED VARIABLE displayMode : integer := 0;

    component keyfilt is
        port (clk  : IN  STD_LOGIC;
            keyTimeSet : IN  STD_LOGIC;
            keyTimeSetfilt : OUT STD_LOGIC;
            keyClockSet : IN  STD_LOGIC;
            keyClockSetfilt : OUT STD_LOGIC;
            keyClockQuit : IN  STD_LOGIC;
            keyClockQuitfilt : OUT STD_LOGIC;
            keyNumAdd : IN  STD_LOGIC;
            keyNumAddfilt : OUT STD_LOGIC;
            keyLeftMove : IN STD_LOGIC;
            keyLeftMovefilt : OUT STD_LOGIC
            );
        end component keyfilt;

BEGIN

akeyfilt: keyfilt port map
(
	clk =>clk,
	keyTimeSet => key1,
	keyTimeSetfilt =>keyTimeSetfilt,
    keyClockSet => key2,
	keyClockSetfilt =>keyClockSetfilt, 
    keyClockQuit => key5,
	keyClockQuitfilt =>keyClockQuitfilt, 
	keyNumAdd => key6,
	keyNumAddfilt => keyNumAddfilt,
	keyLeftMove => key7,
	keyLeftMovefilt => keyLeftMovefilt
);

process(clk,clkcnt)
begin
  	if(rising_edge(clk))then
		clkcnt<= clkcnt + 1;
 	end if;
end process;

process(clk)
begin
	if(clk'event and clk='1') then
		if a=24999999 then     
			a<=0;
			q<= not q;
            clk_1Hz_4vectors <= NOT clk_1Hz_4vectors;
		else
			a<=a+1;		
		end if;
	end if;
    clk_1Hz <= q;
end process;

process(clk, clk_1Hz)
begin
    if clk = '1' then
        if keyClockQuitfilt = '1' then
            ClockTwinkling <= '0';
        elsif keyTimeSetfilt = '1' then
            bcddata_Time <= bcddata_TimeSet;
        elsif clk_1Hz'event and clk_1Hz='1' then

            if bcddata_Time(3 downto 0)=x"9" then               
                bcddata_Time(3 downto 0)<=x"0";    
            else
                bcddata_Time(3 downto 0)<=bcddata_Time(3 downto 0)+1;   
            end if;
        
            if bcddata_Time(7 downto 0)=x"59" then          
                bcddata_Time(7 downto 0)<=x"00";    
            elsif bcddata_Time(3 downto 0)=x"9"  then 
                bcddata_Time(7 downto 4)<=bcddata_Time(7 downto 4)+1;   
            end if;
            
            if bcddata_Time(11 downto 0)=x"959" then            
                bcddata_Time(11 downto 0)<=x"000";    
            elsif bcddata_Time(7 downto 0)=x"59" then
                bcddata_Time(11 downto 8)<=bcddata_Time(11 downto 8)+1;   
            end if;
        
            if bcddata_Time(15 downto 0)=x"5959" then         
                bcddata_Time(15 downto 0)<=x"0000";    
            elsif bcddata_Time(11 downto 0) =x"959" then
                bcddata_Time(15 downto 12)<=bcddata_Time(15 downto 12)+1;  
            end if;

            if bcddata_Time(19 downto 0)=x"95959" then         
                bcddata_Time(19 downto 0)<=x"00000";    
            elsif bcddata_Time(15 downto 0) =x"5959" then
                bcddata_Time(19 downto 16)<=bcddata_Time(19 downto 16)+1;   
            end if;

            if bcddata_Time(23 downto 0)=x"235959" then         
                bcddata_Time(23 downto 0)<=x"000000";    
            elsif bcddata_Time(19 downto 0) =x"95959" then
                bcddata_Time(23 downto 20)<=bcddata_Time(23 downto 20)+1;   
            end if;

            if (bcddata_Time = bcddata_ClockSet OR ClockTwinkling = '1') then
                ClockTwinkling <= '1';
            end if;

        end if; 
    end if;
end process;

process(keyNumAddfilt)
begin
	if ((keyNumAddfilt'event AND keyNumAddfilt='1') AND TimeSetting = '0') OR ((keyNumAddfilt'event AND keyNumAddfilt='1') AND ClockSetting = '0')then
        if displayMode = 1 then
            case leftMoving is
                when "11110" => bcddata_TimeSet(3 downto 0)<=bcddata_TimeSet(3 downto 0)+1;  
                when "11101" => bcddata_TimeSet(7 downto 4)<=bcddata_TimeSet(7 downto 4)+1;
                when "11011" => bcddata_TimeSet(11 downto 8)<=bcddata_TimeSet(11 downto 8)+1;
                when "10111" => bcddata_TimeSet(15 downto 12)<=bcddata_TimeSet(15 downto 12)+1; 
                when "01111" => bcddata_TimeSet(19 downto 16)<=bcddata_TimeSet(19 downto 16)+1;
                when others => NULL;
            end case;
            if bcddata_TimeSet(3 downto 0)=x"9" then               
                bcddata_TimeSet(3 downto 0)<=x"0";
            end if;
            if bcddata_TimeSet(7 downto 4)=x"5" then          
                bcddata_TimeSet(7 downto 4)<=x"0";
            end if;        
            if bcddata_TimeSet(11 downto 8)=x"9" then            
                bcddata_TimeSet(11 downto 8)<=x"0"; 
            end if;   
            if bcddata_TimeSet(15 downto 12)=x"5" then         
                bcddata_TimeSet(15 downto 12)<=x"0";
            end if;
            
            if bcddata_TimeSet(19 downto 16)=x"9" then         
                bcddata_TimeSet(19 downto 16)<=x"0";
                bcddata_TimeSet(23 downto 20)<=bcddata_TimeSet(23 downto 20)+1;      
            end if;

            if bcddata_TimeSet(23 downto 16)=x"23" then         
                bcddata_TimeSet(23 downto 16)<=x"00";
            elsif bcddata_TimeSet(19 downto 16) =x"9" then
                bcddata_TimeSet(23 downto 20)<=bcddata_TimeSet(23 downto 20)+1;      
            end if;
        elsif displayMode = 2 then
            case leftMoving is
                when "11110" => bcddata_ClockSet(3 downto 0)<=bcddata_ClockSet(3 downto 0)+1;  
                when "11101" => bcddata_ClockSet(7 downto 4)<=bcddata_ClockSet(7 downto 4)+1;
                when "11011" => bcddata_ClockSet(11 downto 8)<=bcddata_ClockSet(11 downto 8)+1;
                when "10111" => bcddata_ClockSet(15 downto 12)<=bcddata_ClockSet(15 downto 12)+1; 
                when "01111" => bcddata_ClockSet(19 downto 16)<=bcddata_ClockSet(19 downto 16)+1;
                when others => NULL;
            end case;
            if bcddata_ClockSet(3 downto 0)=x"9" then               
                bcddata_ClockSet(3 downto 0)<=x"0";
            end if;
            if bcddata_ClockSet(7 downto 4)=x"5" then          
                bcddata_ClockSet(7 downto 4)<=x"0";
            end if;        
            if bcddata_ClockSet(11 downto 8)=x"9" then            
                bcddata_ClockSet(11 downto 8)<=x"0"; 
            end if;   
            if bcddata_ClockSet(15 downto 12)=x"5" then         
                bcddata_ClockSet(15 downto 12)<=x"0";
            end if;
            
            if bcddata_ClockSet(19 downto 16)=x"9" then         
                bcddata_ClockSet(19 downto 16)<=x"0";
                bcddata_ClockSet(23 downto 20)<=bcddata_ClockSet(23 downto 20)+1;      
            end if;

            if bcddata_ClockSet(23 downto 16)=x"23" then         
                bcddata_ClockSet(23 downto 16)<=x"00";
            elsif bcddata_ClockSet(19 downto 16) =x"9" then
                bcddata_ClockSet(23 downto 20)<=bcddata_ClockSet(23 downto 20)+1;      
            end if;

        end if;
	end if;
end process;

process(clkcnt(17 downto 15))
begin
    if displayMode = 0 then
        case clkcnt(17 downto 15) is
            when "000" =>	if ClockTwinkling = '1' then
                                bcd_led<=bcddata_ClockSet(3  downto 0) OR clk_1Hz_4vectors;
                            else
                                bcd_led<=bcddata_Time(3  downto 0);
                            end if;
                            SEG_NCS <= "011111";
                            segdot <= '1';
            when "001" =>	if ClockTwinkling = '1' then
                                bcd_led<=bcddata_ClockSet(7  downto 4) OR clk_1Hz_4vectors;
                            else 
                                bcd_led<=bcddata_Time(7  downto 4);
                            end if;
                            SEG_NCS <= "101111";
                            segdot <= '1';
            when "010" =>	if ClockTwinkling = '1' then
                                bcd_led<=bcddata_ClockSet(11 downto 8) OR clk_1Hz_4vectors;
                            else
                                bcd_led<=bcddata_Time(11 downto 8);
                            end if;
                            SEG_NCS <= "110111";
                            segdot <= clk_1Hz;
            when "011" =>	if ClockTwinkling = '1' then
                                bcd_led<=bcddata_ClockSet(15 downto 12) OR clk_1Hz_4vectors;
                            else
                                bcd_led<=bcddata_Time(15 downto 12);
                            end if;
                            SEG_NCS <= "111011";
                            segdot <= '1';
            when "100" =>	if ClockTwinkling = '1' then
                                bcd_led<=bcddata_ClockSet(19  downto 16) OR clk_1Hz_4vectors;
                            else
                                bcd_led<=bcddata_Time(19  downto 16);
                            end if;
                            SEG_NCS <= "111101";
                            segdot<= clk_1Hz;
            when "101" =>	if ClockTwinkling = '1' then
                                bcd_led <= bcddata_ClockSet(23  downto 20) OR clk_1Hz_4vectors;
                            else
                                bcd_led <= bcddata_Time(23  downto 20);
                            end if;
                            SEG_NCS <= "111110";
                            segdot <= '1';
            when "110" =>   SEG_NCS <= "111111";
            when "111" =>   SEG_NCS <= "111111";
            when others => 	NULL;
        end case;
    elsif displayMode = 1 then
        case clkcnt(17 downto 15) is
            when "000" =>   if LeftMoving = "11110" then
            	                bcd_led <= bcddata_TimeSet(3  downto 0) OR clk_1Hz_4vectors;
                            else
                                bcd_led <= bcddata_TimeSet(3  downto 0);
                            end if;
                            SEG_NCS <= "011111";
                            segdot <= '1';
            when "001" =>	if LeftMoving = "11101" then
                                bcd_led <= bcddata_TimeSet(7  downto 4) OR clk_1Hz_4vectors;
                            else
                                bcd_led <= bcddata_TimeSet(7  downto 4);
                            end if;
                            SEG_NCS <= "101111";
                            segdot <= '1';
            when "010" =>	if LeftMoving = "11011" then
                                bcd_led <= bcddata_TimeSet(11  downto 8) OR clk_1Hz_4vectors;
                            else
                                bcd_led <= bcddata_TimeSet(11 downto 8);
                            end if;
                            SEG_NCS <= "110111";
                            segdot <= clk_1Hz;
            when "011" =>	if LeftMoving = "10111" then
                                bcd_led <= bcddata_TimeSet(15 downto 12) OR clk_1Hz_4vectors;
                            else
                                bcd_led <= bcddata_TimeSet(15 downto 12);
                            end if;
                            SEG_NCS <= "111011";
                            segdot<='1';
            when "100" =>	if LeftMoving = "01111" then
                                bcd_led<=bcddata_TimeSet(19  downto 16) OR clk_1Hz_4vectors;
                            else
                                bcd_led<=bcddata_TimeSet(19  downto 16);
                            end if;
                            SEG_NCS <= "111101";
                            segdot<= clk_1Hz;
            when "101" =>	bcd_led<=bcddata_TimeSet(23  downto 20);
                            SEG_NCS <= "111110";
                            segdot <= '1';
            when "110" =>   SEG_NCS <= "111111";
            when "111" =>   SEG_NCS <= "111111";
            when others => 	NULL;
        end case;
    elsif displayMode = 2 then
        case clkcnt(17 downto 15) is
            when "000" =>   if LeftMoving = "11110" then
                                bcd_led <= bcddata_ClockSet(3  downto 0) OR clk_1Hz_4vectors;
                            else
                                bcd_led <= bcddata_ClockSet(3  downto 0);
                            end if;
                            SEG_NCS <= "011111";
                            segdot <= '1';
            when "001" =>	if LeftMoving = "11101" then
                                bcd_led <= bcddata_ClockSet(7  downto 4) OR clk_1Hz_4vectors;
                            else
                                bcd_led <= bcddata_ClockSet(7  downto 4);
                            end if;
                            SEG_NCS <= "101111";
                            segdot <= '1';
            when "010" =>	if LeftMoving = "11011" then
                                bcd_led <= bcddata_ClockSet(11  downto 8) OR clk_1Hz_4vectors;
                            else
                                bcd_led <= bcddata_ClockSet(11 downto 8);
                            end if;
                            SEG_NCS <= "110111";
                            segdot <= clk_1Hz;
            when "011" =>	if LeftMoving = "10111" then
                                bcd_led <= bcddata_ClockSet(15 downto 12) OR clk_1Hz_4vectors;
                            else
                                bcd_led <= bcddata_ClockSet(15 downto 12);
                            end if;
                            SEG_NCS <= "111011";
                            segdot<='1';
            when "100" =>	if LeftMoving = "01111" then
                                bcd_led<=bcddata_ClockSet(19  downto 16) OR clk_1Hz_4vectors;
                            else
                                bcd_led<=bcddata_ClockSet(19  downto 16);
                            end if;
                            SEG_NCS <= "111101";
                            segdot<= clk_1Hz;
            when "101" =>	bcd_led<=bcddata_ClockSet(23  downto 20);
                            SEG_NCS <= "111110";
                            segdot <= '1';
            when "110" =>   SEG_NCS <= "111111";
            when "111" =>   SEG_NCS <= "111111";
            when others => 	NULL;
        end case;
    end if;
end process;

process(bcd_led)
	begin
		case bcd_led is
									 
			WHEN "0000"=>SEG_LED<="0000001";
			WHEN "0001"=>SEG_LED<="1001111";
			WHEN "0010"=>SEG_LED<="0010010";
			WHEN "0011"=>SEG_LED<="0000110";
			WHEN "0100"=>SEG_LED<="1001100";
			WHEN "0101"=>SEG_LED<="0100100";
			WHEN "0110"=>SEG_LED<="0100000";
			WHEN "0111"=>SEG_LED<="0001111";
			WHEN "1000"=>SEG_LED<="0000000";
			WHEN "1001"=>SEG_LED<="0000100";
			WHEN OTHERS=>SEG_LED<="1111111";
		end case;
end process;

--------------------------------------------------------
process(clk)
begin
  	if(rising_edge(clk))then
	  	if keyTimeSetfilt = '1' then
			TimeSetting <= not TimeSetting;
            if TimeSetting = '1' then
                displayMode := 1;
            elsif TimeSetting = '0' then
                displayMode := 0;
            end if;
		end if;

        if keyClockSetfilt = '1' then
            ClockSetting <= not ClockSetting;
            if ClockSetting = '1' then
                displayMode := 2;
            elsif ClockSetting = '0' then
                displayMode := 0;
            end if;
        end if;

        if keyLeftMovefilt = '1' then
			LeftMoving <= LeftMoving ROL 1;
		end if;
  	end if;
end process;

end behav;


