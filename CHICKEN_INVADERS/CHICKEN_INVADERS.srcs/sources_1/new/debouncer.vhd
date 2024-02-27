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

entity debouncer is
    Port ( CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           ENABLE : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
    signal count: STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal q0,q1,q2,en: STD_LOGIC;
begin
    process(clk,count)
    begin
    if (clk='1' and clk'event) then count<=count+1;
    end if;
    end process;
    
    process(count,q0)
    begin
        if(count =x"ff") then
            q0<=Btn;
        end if;
    end process;
    
    process(q1,q2)
    begin
        q1<=q0;
        q2<=q1;
    end process; 

    enable <= q2 and q1;
end Behavioral;