----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Faculty : FACULTY OF COMPUTER SCIENCE AND INFORMATION TECHNOLOGY
-- Students : PIRVULESCU GABRIELA and RISTEIU IOANA
-- Project Name : CHICKEN INVADERS
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity REG_UNIV is
    Port ( RESET,START, CLK, BUTON: in STD_LOGIC;
           ARM: out STD_LOGIC_VECTOR(8 downto 0);
           AN: out STD_LOGIC_VECTOR (7 downto 0);
           CAT: out STD_LOGIC_VECTOR (6 downto 0);
           CHICKEN1: out STD_LOGIC_VECTOR(4 downto 0);
           CHICKEN2: out STD_LOGIC_VECTOR(4 downto 0);
           CHICKEN3: out STD_LOGIC_VECTOR(4 downto 0);
           CHICKEN4: out STD_LOGIC_VECTOR(4 downto 0);
           CD1_OUT: out STD_LOGIC_VECTOR(4 downto 0);
           CD2_OUT: out STD_LOGIC_VECTOR(4 downto 0)
           );
end REG_UNIV;

architecture Behavioral of REG_UNIV is
     signal SEL: STD_LOGIC;
     signal NEW_ARM: STD_LOGIC_VECTOR (8  downto 0):="000000001";
     signal NEW_CHICKEN1,NEW_CHICKEN2,NEW_CHICKEN3,NEW_CHICKEN4: STD_LOGIC_VECTOR (4 downto 0):="11111";
     signal EN_BTN:STD_LOGIC;
     signal COUNT:integer:=1;
     signal DIVCLOCK:STD_LOGIC:='0';
    
    signal CD1,CD2:STD_LOGIC_VECTOR(4 DOWNTO 0);
    
    
    
    begin
     --  control_buton:entity  work.debouncer port map (CLK=>CLK, BTN=>BUTON, ENABLE=>EN_BTN);
      --DIVIZOR FRECVENTA JOC
        process(CLK, RESET)
          begin 
            if RESET='1'  then 
                COUNT<=1;
           elsif  (rising_edge(CLK)) then
                if(COUNT=9000000) then COUNT<=1;
                    DIVCLOCK<=NOT (DIVCLOCK);
                else 
                    COUNT<=COUNT+1;
                end if;
            end if;
       end process;
       
       --- REGISTRU SHIFTARE ARMA
       process(SEL,RESET,DIVCLOCK,START)
          begin
              if(RESET = '1')then
                    NEW_ARM<="000000001";
                    SEL<='0';
              elsif  ( DIVCLOCK'event and DIVCLOCK= '1'  and START= '1' ) then
                    if(NEW_ARM(7)='1') then
                        SEL<='1';
                    elsif (NEW_ARM(1) ='1') then 
                        SEL<='0';
                    end if; 
                    case SEL  is
                         when '0'=>NEW_ARM<=NEW_ARM(7 downto 0)&'0';
                         when others=>NEW_ARM<='0'&NEW_ARM(8 downto 1);
                    end case;
                    
                end if;
             end process; 
          --- REGISTRU ACTUALIZARE CHICKENS   
             process(DIVCLOCK,BUTON, NEW_ARM, START,RESET)
                begin
                    if(RESET = '1')then
                        NEW_CHICKEN1 <="11111";
                        NEW_CHICKEN2 <="11111";
                        NEW_CHICKEN3 <="11111";
                        NEW_CHICKEN4 <="11111";
                  
                    elsif(DIVCLOCK'event and DIVCLOCK = '1' and BUTON = '1' and START='1')then
                        case NEW_ARM is 
                            when "001000000" => NEW_CHICKEN4<="11"&NEW_CHICKEN4(1 downto 0)&'0';
                            when "000100000" => NEW_CHICKEN3<="11"&NEW_CHICKEN3(1 downto 0)&'0';
                            when "000010000" => NEW_CHICKEN2<="11"&NEW_CHICKEN2(1 downto 0)&'0';
                            when "000001000" => NEW_CHICKEN1<="11"&NEW_CHICKEN1(1 downto 0)&'0';
                            when others => NEW_CHICKEN4 <= NEW_CHICKEN4;
                         end case;
                     end if;
              end process;
        
        ARM<=NEW_ARM;
       ACTUALIZARE_TIMER: entity WORK.Count_down_timer port map(CLK=>CLK, START=>START, RESET=>RESET, DIGIT1=>CD1, DIGIT2=>CD2 );
       DISPLAY: ENTITY WORK.Display_chicken_timer port map (CLK=>CLK,D0=>CD1,D1=>CD2,D2=>"00000",D3=>"00000",D4=>NEW_CHICKEN1, D5=>NEW_CHICKEN2, D6 =>NEW_CHICKEN3, D7 =>NEW_CHICKEN4, an=>AN, cat=>CAT);
       CHICKEN1 <= NEW_CHICKEN1;
       CHICKEN2 <= NEW_CHICKEN2;
       CHICKEN3 <= NEW_CHICKEN3;
       CHICKEN4 <= NEW_CHICKEN4;
       
       CD1_OUT<=CD1;
       CD2_OUT<=CD2;
end Behavioral;