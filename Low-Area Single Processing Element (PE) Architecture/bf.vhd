library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.ALL;

ENTITY bf IS

	PORT(
	
	    clk		: 	IN  std_logic;
		bfmod		: 	IN  std_logic_vector(1 DOWNTO 0);
		
		a		: IN  std_logic_vector(11 DOWNTO 0);
		b		: IN  std_logic_vector(11 DOWNTO 0);
		c		: IN  std_logic_vector(11 DOWNTO 0);
		
		
		aout	: OUT  std_logic_vector(11 DOWNTO 0);
		bout	: OUT  std_logic_vector(11 DOWNTO 0)
	);


END bf;


ARCHITECTURE behaviour OF bf IS

		COMPONENT modmul IS
		PORT(
		    clk	:	IN		std_logic;  
			A	:	IN		std_logic_vector(11 downto 0);
			B	:	IN		std_logic_vector(11 downto 0);
			R	:	OUT		std_logic_vector(11 downto 0)
			
		);
		END COMPONENT;
		
	 COMPONENT modsub IS
		PORT(
			
			A	:	IN		std_logic_vector(11 downto 0);
			B	:	IN		std_logic_vector(11 downto 0);
			C	:	OUT		std_logic_vector(11 downto 0)
				
		);
		END COMPONENT;
		
			
	 COMPONENT modadd IS
		PORT(
			
			A	:	IN		std_logic_vector(11 downto 0);
			B	:	IN		std_logic_vector(11 downto 0);
			C	:	OUT		std_logic_vector(11 downto 0)
					
		);
		END COMPONENT;
		
	COMPONENT devide IS
		PORT(
			
			A	:	IN		std_logic_vector(11 downto 0);
			C	:	OUT		std_logic_vector(11 downto 0)
					
		);
		END COMPONENT;

		
        SIGNAL mmin0  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mmin0f  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mmin1  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mmin1f  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mmout  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mmoutw  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mmoutf  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mmoutf1  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mmoutbout  : std_logic_vector(11 DOWNTO 0);
		
		SIGNAL main0  : std_logic_vector(11 DOWNTO 0);
		SIGNAL main0f  : std_logic_vector(11 DOWNTO 0);
        SIGNAL main1  : std_logic_vector(11 DOWNTO 0);
        SIGNAL main1f  : std_logic_vector(11 DOWNTO 0);
        SIGNAL maout  : std_logic_vector(11 DOWNTO 0);
        SIGNAL maoutw  : std_logic_vector(11 DOWNTO 0);
		
		SIGNAL msin0  : std_logic_vector(11 DOWNTO 0);
		SIGNAL msin0f  : std_logic_vector(11 DOWNTO 0);
        SIGNAL msin1  : std_logic_vector(11 DOWNTO 0);
        SIGNAL msin1f  : std_logic_vector(11 DOWNTO 0);
        SIGNAL msout  : std_logic_vector(11 DOWNTO 0);
        SIGNAL msoutw  : std_logic_vector(11 DOWNTO 0);
		
		SIGNAL mdin   : std_logic_vector(11 DOWNTO 0);
		SIGNAL mdinf   : std_logic_vector(11 DOWNTO 0);
        SIGNAL mdout  : std_logic_vector(11 DOWNTO 0);
        
		SIGNAL mdoutf0  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mdoutf1  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mdoutf2  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mdoutf3  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mdoutf4  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mdoutf5  : std_logic_vector(11 DOWNTO 0);
		
        SIGNAL mxout0  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mxout1  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mxout2  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mxout3  : std_logic_vector(11 DOWNTO 0);
		
        SIGNAL ain  : std_logic_vector(11 DOWNTO 0);
        SIGNAL af0  : std_logic_vector(11 DOWNTO 0);
        SIGNAL af1  : std_logic_vector(11 DOWNTO 0);
        SIGNAL af2  : std_logic_vector(11 DOWNTO 0);
        SIGNAL af3  : std_logic_vector(11 DOWNTO 0);
        SIGNAL af4  : std_logic_vector(11 DOWNTO 0);
        SIGNAL af5  : std_logic_vector(11 DOWNTO 0);
        SIGNAL af6  : std_logic_vector(11 DOWNTO 0);
		
        SIGNAL cin  : std_logic_vector(11 DOWNTO 0);
        SIGNAL cf  : std_logic_vector(11 DOWNTO 0);
        SIGNAL cf1  : std_logic_vector(11 DOWNTO 0);
		
		
		
        SIGNAL m0  : std_logic;
        SIGNAL m1  : std_logic;
		

				
BEGIN

	
	
	
	bfc_modmul :  modmul PORT MAP( clk => clk, A => mmin0f , B => mmin1f  , R => mmoutw );
	
	bfc_modadd: modadd PORT MAP( A => main0f , B => main1f , C => maoutw );
	
	bfc_modsub: modsub PORT MAP( A => msin0f , B => msin1f , C =>  msoutw );
	
	bfc_devided: devide PORT MAP( A => mdinf ,  C =>  mdout );
	
	
	
	m0 <= bfmod(0);	
	m1 <= bfmod(1);	
	
	ain <= af6 when m0 = '0' else a;
	cin <= cf1 when m0 = '1' else c;
	mmoutbout <= mmoutf1 when m1 = '1' else mmout;
	
	
	mxout0 <= mmout when m0 = '0' else b ;
	mxout1 <= ain when m0 = '0' else b ;
	mxout2 <= mmout when m0 = '0' else ain ;
	mxout3 <= b when m0 = '0' else msout ;
	
	main0 <= ain;
	main1 <= mxout0;
	
	msin0 <= mxout1;
	msin1 <= mxout2;
	
	mmin0 <= mxout3;
	mmin1 <= cin;
	
	mdin <= maout;
	
	aout <= maout when m0 = '0' else mdoutf5;
	bout <= msout when (m0 or m1) = '0' else mmoutbout;
	
	
	
PROCESS(clk)
  BEGIN
  
  IF  clk'EVENT AND clk = '1' THEN
		
			mmout <= mmoutw;
			maout <= maoutw;
			msout <= msoutw;
			
			af0 <= a;
			af1 <= af0;
			af2 <= af1;
			af3 <= af2;
			af4 <= af3;
			af5 <= af4;
			af6 <= af5;
			cf <= c;
			cf1 <= cf;
			mdoutf0 <= mdout;
			mdoutf1 <= mdoutf0;
			mdoutf2 <= mdoutf1;
			mdoutf3 <= mdoutf2;
			mdoutf4 <= mdoutf3;
			mdoutf5 <= mdoutf4;
			mmoutf <= mmout;
			mmoutf1 <= mmoutf;
			
			mmin0f <= mmin0; 
			mmin1f <= mmin1; 
			main0f <= main0; 
			main1f <= main1; 
			msin0f <= msin0; 
			msin1f <= msin1; 
			mdinf <= mdin; 
	END IF;      
          
END PROCESS;

			
	
	
END behaviour;
