LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
LIBRARY std;
USE std.standard.all;
use ieee.numeric_std.all;
LIBRARY work;
USE work.ALL;

ENTITY r2 IS

	PORT(
		clk		: IN  std_logic;
		a		: IN  std_logic_vector(11 DOWNTO 0);
		b		: IN  std_logic_vector(11 DOWNTO 0);
		cout	: OUT  std_logic_vector(11 DOWNTO 0)
	);


END r2;

ARCHITECTURE behaviour OF r2 IS



    TYPE word24_array_12 IS ARRAY (0 TO 11) OF
        unsigned(23 DOWNTO 0);

    TYPE word24_array_6 IS ARRAY (0 TO 5) OF
        unsigned(23 DOWNTO 0);

    TYPE word24_array_3 IS ARRAY (0 TO 2) OF
        unsigned(23 DOWNTO 0);

    SIGNAL pp_comb : word24_array_12;
    SIGNAL pp_s0   : word24_array_12;

    SIGNAL mult_s1 : word24_array_6;
    SIGNAL mult_s2 : word24_array_3;

    SIGNAL mult_s3_sum  : unsigned(23 DOWNTO 0);
    SIGNAL mult_s3_pass : unsigned(23 DOWNTO 0);

    SIGNAL product_s4 : unsigned(23 DOWNTO 0);


		
        SIGNAL c  : std_logic_vector(23 DOWNTO 0);
        
		SIGNAL cu  : std_logic_vector(11 DOWNTO 0);
		SIGNAL cd  : std_logic_vector(11 DOWNTO 0);
		SIGNAL cdreg0  : std_logic_vector(11 DOWNTO 0);
		SIGNAL cdreg1  : std_logic_vector(11 DOWNTO 0);
		SIGNAL cdreg2  : std_logic_vector(11 DOWNTO 0);
		SIGNAL cdreg3  : std_logic_vector(11 DOWNTO 0);
		SIGNAL cdreg4  : std_logic_vector(11 DOWNTO 0);
        
		SIGNAL creg  : std_logic_vector(23 DOWNTO 0);
		
		
        SIGNAL cureg  : std_logic_vector(11 DOWNTO 0);
        SIGNAL cureg0  : std_logic_vector(11 DOWNTO 0);
		
		ATTRIBUTE use_dsp : STRING;
		ATTRIBUTE use_dsp OF creg : SIGNAL IS "no";
		
		
        SIGNAL temp1  : std_logic_vector(18 DOWNTO 0);
        SIGNAL temp1reg  : std_logic_vector(18 DOWNTO 0);
        SIGNAL temp2  : std_logic_vector(18 DOWNTO 0);
        SIGNAL temp2reg  : std_logic_vector(18 DOWNTO 0);
		
        SIGNAL temp2temp  : std_logic_vector(10 DOWNTO 0);
        SIGNAL temp2temp0  : std_logic_vector(10 DOWNTO 0);
		
        SIGNAL temp2d  : std_logic_vector(7 DOWNTO 0);
        
		
        SIGNAL temp3reg  : std_logic_vector(12 DOWNTO 0);
        SIGNAL temp3  : std_logic_vector(12 DOWNTO 0);
		
        SIGNAL temp4  : std_logic_vector(12 DOWNTO 0);
        SIGNAL temp4reg  : std_logic_vector(12 DOWNTO 0);
		
        SIGNAL temp5reg  : std_logic_vector(12 DOWNTO 0);
        SIGNAL temp5  : std_logic_vector(12 DOWNTO 0);
        
        SIGNAL temp7  : std_logic_vector( 14 DOWNTO 0);
		
        SIGNAL correct  : std_logic_vector(14 DOWNTO 0);
        SIGNAL correctreg  : std_logic_vector(14 DOWNTO 0);
        
      

		
		SIGNAL temp6  : std_logic_vector(13 DOWNTO 0);
		SIGNAL temp6reg0  : std_logic_vector(13 DOWNTO 0);
		SIGNAL temp6reg1  : std_logic_vector(13 DOWNTO 0);

				
BEGIN


		creg <= std_logic_vector(unsigned(a) * unsigned(b));


    partial_products :
    FOR i IN 0 TO 11 GENERATE
        pp_comb(i) <=
            shift_left(resize(unsigned(a), 24), i)
            WHEN b(i) = '1'
            ELSE (OTHERS => '0');
    END GENERATE;



		
		
		temp1reg <= ('0' & cureg & "000000") - ("00000" & cureg & "00");
		
		
		cureg <= std_logic_vector(product_s4(23 DOWNTO 12));
		
		
		temp2reg <= temp1 - ("0000000" & cu );

		temp3reg <= ( '0' & temp2(7 DOWNTO 0) & "0000") -  ( "0000" & temp2(7 DOWNTO 0) & "0");
		temp4reg <= ('0' & temp3(11 DOWNTO 0)) -  ( "00000" & temp2d);
		
		temp5reg <= temp4 -  temp2temp0;
		--temp55 <= "00" & temp5(11 DOWNTO 0) + "0001011111111" when temp5(12)='1' else "00" & temp5(11 DOWNTO 0);

		temp6 <= (temp5(12) & temp5) + ("00" & cd);
	   	
		    correctreg <=
        "000110100000001" WHEN temp6reg0(13) = '1' ELSE

        "110010111111110"
            WHEN temp6reg0 >= "01101000000010" ELSE

        "111001011111111"
            WHEN temp6reg0 >= "00110100000001" ELSE

        "000000000000000";

		
		
		cout <=  temp7(11 DOWNTO 0)  ;
		
		
		--cout <=   temp10(11 DOWNTO 0) when temp10(12)='0' else  temp11 ;
		


	
PROCESS(clk)
  BEGIN
  
  IF  clk'EVENT AND clk = '1' THEN
	
	
	      pp_s0 <= pp_comb;

            ----------------------------------------------------------
            -- M1: 12 operands → 6 operands
            -- Six adders operate in parallel.
            ----------------------------------------------------------
            mult_s1(0) <= pp_s0(0)  + pp_s0(1);
            mult_s1(1) <= pp_s0(2)  + pp_s0(3);
            mult_s1(2) <= pp_s0(4)  + pp_s0(5);
            mult_s1(3) <= pp_s0(6)  + pp_s0(7);
            mult_s1(4) <= pp_s0(8)  + pp_s0(9);
            mult_s1(5) <= pp_s0(10) + pp_s0(11);

            ----------------------------------------------------------
            -- M2: 6 operands → 3 operands
            -- Three adders operate in parallel.
            ----------------------------------------------------------
            mult_s2(0) <= mult_s1(0) + mult_s1(1);
            mult_s2(1) <= mult_s1(2) + mult_s1(3);
            mult_s2(2) <= mult_s1(4) + mult_s1(5);

            ----------------------------------------------------------
            -- M3: 3 operands → 2 operands
            ----------------------------------------------------------
            mult_s3_sum  <= mult_s2(0) + mult_s2(1);
            mult_s3_pass <= mult_s2(2);

            ----------------------------------------------------------
            -- M4: final product
            ----------------------------------------------------------
            product_s4 <= mult_s3_sum + mult_s3_pass;
	
	
	
	
	
	
	
	cdreg0 <= std_logic_vector(product_s4(11 DOWNTO 0));
	
	cdreg1 <= cdreg0;
	cdreg2 <= cdreg1;
	cdreg3 <= cdreg2;
	
	cd <= cdreg3;
	
	cu <= cureg;
	
	temp1 <= temp1reg;
	
	temp2temp	<=	temp2(18 DOWNTO 8);
	temp2temp0 <=temp2temp;
	
	temp2 <= temp2reg;
	
	temp2d <=temp2(7 DOWNTO 0);
	
	temp3 <= temp3reg;
	
	temp4 <= temp4reg;
	
	temp5 <= temp5reg;
	
	temp6reg0<= temp6;
	temp6reg1<= temp6reg0;
	correct<= correctreg;
	
	temp7 <=  (temp6reg1(13)&temp6reg1) +  correct;
	
	
  END IF;        
END PROCESS;




	
	
	
END behaviour;
