LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL; 
LIBRARY std;
USE std.standard.all;
LIBRARY work;
USE work.ALL;


ENTITY modmul IS

	PORT(
	clk	:	IN		std_logic;
	A	:	IN		std_logic_vector(11 downto 0);
	B	:	IN		std_logic_vector(11 downto 0);
	R	:	OUT		std_logic_vector(11 downto 0)

	
	);


END modmul;

ARCHITECTURE behaviour OF modmul IS




COMPONENT intmul IS
		PORT(
							
			A		: IN  std_logic_vector(11 DOWNTO 0);
			B		: IN  std_logic_vector(11 DOWNTO 0);
			P		: OUT  std_logic_vector(23 DOWNTO 0)
			
		);
		END COMPONENT;

COMPONENT r3 IS
		PORT(
            clk : IN  std_logic;
			c		: IN  std_logic_vector(23 DOWNTO 0);
			cout		: OUT  std_logic_vector(11 DOWNTO 0)
			
		);
		END COMPONENT;




		SIGNAL ptemp  	  : std_logic_vector(23 DOWNTO 0);
		SIGNAL ptempreg  	  : std_logic_vector(23 DOWNTO 0);

		

				
BEGIN


		
		myintmul : intmul PORT MAP (		
			A	=> A,
			B	=> B, 
			P	=> ptemp 
		);
		
		red : r3 PORT MAP (	
		    clk => clk,
			c	=> ptempreg,
			cout	=> R
		);
		
		
		
PROCESS(clk)
  BEGIN
  
  IF  clk'EVENT AND clk = '1' THEN
		

			ptempreg <= ptemp; 

	END IF;      
          
  END PROCESS;

			
END behaviour;
