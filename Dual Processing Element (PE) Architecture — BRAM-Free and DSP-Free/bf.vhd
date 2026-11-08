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

		COMPONENT r2 IS
		PORT(
		    clk	:	IN		std_logic;  
			a	:	IN		std_logic_vector(11 downto 0);
			b	:	IN		std_logic_vector(11 downto 0);
			cout	:	OUT		std_logic_vector(11 downto 0)
			
		);
		END COMPONENT;
		
	 COMPONENT ms IS
		PORT(
			
			clk         : IN  std_logic;
			direction   : IN  std_logic;
			a           : IN  std_logic_vector(11 DOWNTO 0);
			b           : IN  std_logic_vector(11 DOWNTO 0);
			result      : OUT std_logic_vector(11 DOWNTO 0)
				
		);
		END COMPONENT;
		
			
	 COMPONENT ma IS
		PORT(
			clk       : IN  std_logic;
			conintt   : IN  std_logic;
			a         : IN  std_logic_vector(11 DOWNTO 0);
			b         : IN  std_logic_vector(11 DOWNTO 0);
			result    : OUT std_logic_vector(11 DOWNTO 0)
				
		);
		END COMPONENT;
		


		
        SIGNAL mmin0f  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mmin1f  : std_logic_vector(11 DOWNTO 0);
        SIGNAL mmoutf  : std_logic_vector(11 DOWNTO 0);
        
		SIGNAL msin0f  : std_logic_vector(11 DOWNTO 0);
		SIGNAL msin1f  : std_logic_vector(11 DOWNTO 0);
		SIGNAL msoutf  : std_logic_vector(11 DOWNTO 0);
		SIGNAL msoutf0  : std_logic_vector(11 DOWNTO 0);
		SIGNAL msoutf1  : std_logic_vector(11 DOWNTO 0);
		
		SIGNAL main0f  : std_logic_vector(11 DOWNTO 0);
		SIGNAL main1f  : std_logic_vector(11 DOWNTO 0);
		SIGNAL maoutf  : std_logic_vector(11 DOWNTO 0);
		SIGNAL maoutf0  : std_logic_vector(11 DOWNTO 0);
		SIGNAL maoutf1  : std_logic_vector(11 DOWNTO 0);
		SIGNAL maoutf2  : std_logic_vector(11 DOWNTO 0);
		SIGNAL maoutf3  : std_logic_vector(11 DOWNTO 0);
		SIGNAL maoutf4  : std_logic_vector(11 DOWNTO 0);
		SIGNAL maoutf5  : std_logic_vector(11 DOWNTO 0);
		SIGNAL maoutf6  : std_logic_vector(11 DOWNTO 0);
		SIGNAL maoutf7  : std_logic_vector(11 DOWNTO 0);
		SIGNAL maoutf8  : std_logic_vector(11 DOWNTO 0);
		
		
		
		
		
        SIGNAL m0  : std_logic;
        SIGNAL m1  : std_logic;
		
		
        SIGNAL conintt  : std_logic;
        SIGNAL direction  : std_logic;
		
		SIGNAL fa  : std_logic_vector(11 DOWNTO 0);
		SIGNAL fb  : std_logic_vector(11 DOWNTO 0);
		SIGNAL fc  : std_logic_vector(11 DOWNTO 0);
		
		SIGNAL mux00in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux01in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux10in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux11in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux20in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux21in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux30in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux31in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux40in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux41in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux50in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux51in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux60in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux61in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux70in  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux71in  : std_logic_vector(11 DOWNTO 0);
		
		SIGNAL mux0out  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux1out  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux2out  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux3out  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux4out  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux5out  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux6out  : std_logic_vector(11 DOWNTO 0);
		SIGNAL mux7out  : std_logic_vector(11 DOWNTO 0);
		
		SIGNAL mux0c  : std_logic;
		SIGNAL mux1c  : std_logic;
		SIGNAL mux2c  : std_logic;
		SIGNAL mux3c  : std_logic;
		SIGNAL mux4c  : std_logic;
		SIGNAL mux5c  : std_logic;
		SIGNAL mux6c  : std_logic;
		SIGNAL mux7c  : std_logic;
		
		
		SIGNAL af0  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af1  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af2  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af3  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af4  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af5  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af6  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af7  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af8  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af9  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af10  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af11  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af12  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af13  : std_logic_vector(11 DOWNTO 0);
		SIGNAL af14  : std_logic_vector(11 DOWNTO 0);
		
		
		
		SIGNAL cf0  : std_logic_vector(11 DOWNTO 0);
		SIGNAL cf1  : std_logic_vector(11 DOWNTO 0);
		SIGNAL cf2  : std_logic_vector(11 DOWNTO 0);
		SIGNAL cf3  : std_logic_vector(11 DOWNTO 0);
		SIGNAL cf4  : std_logic_vector(11 DOWNTO 0);
		SIGNAL cf5  : std_logic_vector(11 DOWNTO 0);
		
		SIGNAL bf0  : std_logic_vector(11 DOWNTO 0);
		SIGNAL bf1  : std_logic_vector(11 DOWNTO 0);
		SIGNAL bf2  : std_logic_vector(11 DOWNTO 0);
		SIGNAL bf3  : std_logic_vector(11 DOWNTO 0);
		SIGNAL bf4  : std_logic_vector(11 DOWNTO 0);
		

				
BEGIN

	
	
	
	bfc_modmul :  r2 PORT MAP( clk => clk, a => mmin0f , b => mmin1f  , cout => mmoutf );
	
	bfc_modadd: ma PORT MAP( clk => clk, conintt => conintt ,  a => main0f , b => main1f , result => maoutf );
	
	bfc_modsub: ms PORT MAP( clk => clk, direction=>  direction , a => msin0f , b => msin1f , result =>  msoutf );
	
	
	main0f <= mux0out;
	main1f <= mux1out;
	
	msin0f <= mux2out;
	msin1f <= mux3out;
	
	mmin0f <= mux4out;
	mmin1f <= mux5out;
	
	aout <= mux6out;
	bout <= mux7out;

	
PROCESS(clk)
  BEGIN
  
  IF  clk'EVENT AND clk = '1' THEN
			
		m0 <= bfmod(0);	
		m1 <= bfmod(1);	
	
		conintt <= m0;
		direction <= m0;
		
		mux0c <= m0;
		mux1c <= m0;
		mux2c <= m0;
		mux3c <= m0;
		mux4c <= m0;
		mux5c <= m0;
		mux6c <= m0;
		mux7c <= m0 or m1;
		
		
		
		
			
		fa <= a;	
		fb <= b;	
		fc <= c;	
			
			
		IF mux0c = '0' THEN
            mux0out <= mux00in;
        ELSE
            mux0out <= mux01in;
        END IF;
		
		IF mux1c = '0' THEN
            mux1out <= mux10in;
        ELSE
            mux1out <= mux11in;
        END IF;
			
		IF mux2c = '0' THEN
            mux2out <= mux20in;
        ELSE
            mux2out <= mux21in;
        END IF;	
			
		
		IF mux3c = '0' THEN
            mux3out <= mux30in;
        ELSE
            mux3out <= mux31in;
        END IF;
		
		
		IF mux4c = '0' THEN
            mux4out <= mux40in;
        ELSE
            mux4out <= mux41in;
        END IF;
		
		
		IF mux5c = '0' THEN
            mux5out <= mux50in;
        ELSE
            mux5out <= mux51in;
        END IF;
		
		
		
		IF mux6c = '0' THEN
            mux6out <= mux60in;
        ELSE
            mux6out <= mux61in;
        END IF;
		
		IF mux7c = '0' THEN
            mux7out <= mux70in;
        ELSE
            mux7out <= mux71in;
        END IF;
		
		-- NTT
		
		mux40in <= fb;
		
		mux50in <= fc;
		
		mux00in<= af14;
		
		af0 <= fa;
		af1 <= af0;
		af2 <= af1;
		af3 <= af2;
		af4 <= af3;
		af5 <= af4;
		af6 <= af5;
		af7 <= af6;
		af8 <= af7;
		af9 <= af8;
		af10 <= af9;
		af11 <= af10;
		af12 <= af11;
		af13 <= af12;
		af14 <= af13;
		
		
		mux10in <= mmoutf;
		
		mux20in <= af14;
		
		mux30in <= mmoutf;
		
		mux60in <= maoutf;
		
		mux70in <= msoutf1;
		
		msoutf0 <= msoutf;
		
		msoutf1 <= msoutf0;
		
		-- INTT
		
		
		mux21in <= fa; 
		
		mux31in <= fb;
		
		mux41in <= msoutf;
		
		mux51in <= cf4;
		
		cf0 <= fc;
		cf1 <= cf0;
		cf2 <= cf1;
		cf3 <= cf2;
		cf4 <= cf3;
		cf5 <= cf4;
		
		mux71in <= mmoutf;
		
		mux61in <= maoutf8;
		
		maoutf1 <= maoutf;
		maoutf2 <= maoutf1;
		maoutf3 <= maoutf2;
		maoutf4 <= maoutf3;
		maoutf5 <= maoutf4;
		maoutf6 <= maoutf5;
		maoutf7 <= maoutf6;
		maoutf8 <= maoutf7;
		
		mux01in <= af4;
		
		mux11in <= bf4;
		
		bf0 <= fb;
		bf1 <= bf0;
		bf2 <= bf1;
		bf3 <= bf2;
		bf4 <= bf3;
		
		
		
		
			
	END IF;      
          
END PROCESS;

			
	
	
END behaviour;
