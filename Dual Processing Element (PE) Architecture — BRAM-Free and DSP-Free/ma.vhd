LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
USE std.standard.ALL;

LIBRARY work;
USE work.ALL;


ENTITY ma IS

    PORT(
        clk       : IN  std_logic;
        conintt   : IN  std_logic;
        a         : IN  std_logic_vector(11 DOWNTO 0);
        b         : IN  std_logic_vector(11 DOWNTO 0);
        result    : OUT std_logic_vector(11 DOWNTO 0)
    );

END ma;


ARCHITECTURE behaviour OF ma IS


        --------------------------------------------------------------
        -- Stage 1 signals
        --------------------------------------------------------------
        SIGNAL sum_s1       : std_logic_vector(13 DOWNTO 0);
        SIGNAL conintt_s1   : std_logic;


        --------------------------------------------------------------
        -- Stage 2 signals
        --------------------------------------------------------------
        SIGNAL sum_delay_s2 : std_logic_vector(14 DOWNTO 0);
        SIGNAL add_value_s2 : std_logic_vector(14 DOWNTO 0);


        --------------------------------------------------------------
        -- Stage 3 signals
        --------------------------------------------------------------
        SIGNAL adjusted_s3  : std_logic_vector(14 DOWNTO 0);


        --------------------------------------------------------------
        -- Stage 4 signals
        --------------------------------------------------------------
        SIGNAL adjusted_delay_s4 : std_logic_vector(14 DOWNTO 0);
        SIGNAL correction_s4     : std_logic_vector(14 DOWNTO 0);


        --------------------------------------------------------------
        -- Stage 5 signals
        --------------------------------------------------------------
        SIGNAL result_s5 : std_logic_vector(14 DOWNTO 0);


        --------------------------------------------------------------
        -- Constants
        --------------------------------------------------------------

        -- 1665
        CONSTANT ADD_VALUE : std_logic_vector(14 DOWNTO 0) :=
            "000011010000001";

        -- 3329
        CONSTANT Q : std_logic_vector(14 DOWNTO 0) :=
            "000110100000001";

        -- 6658 = 2 * 3329
        CONSTANT TWO_Q : std_logic_vector(14 DOWNTO 0) :=
            "001101000000010";

        -- -3329 in 15-bit two's complement
        CONSTANT NEG_Q : std_logic_vector(14 DOWNTO 0) :=
            "111001011111111";

        -- -6658 in 15-bit two's complement
        CONSTANT NEG_TWO_Q : std_logic_vector(14 DOWNTO 0) :=
            "110010111111110";

        -- Zero
        CONSTANT ZERO_15 : std_logic_vector(14 DOWNTO 0) :=
            "000000000000000";


        --------------------------------------------------------------
        -- Prevent DSP inference
        --------------------------------------------------------------
        ATTRIBUTE use_dsp : STRING;
        ATTRIBUTE use_dsp OF behaviour : ARCHITECTURE IS "no";


BEGIN


PROCESS(clk)
BEGIN

    IF clk'EVENT AND clk = '1' THEN


        --------------------------------------------------------------
        -- Stage 1
        --
        -- Calculate a + b.
        -- Register conintt so it remains aligned with sum_s1.
        --------------------------------------------------------------
        sum_s1 <=
            ("00" & a) +
            ("00" & b);

        conintt_s1 <= conintt;


        --------------------------------------------------------------
        -- Stage 2
        --
        -- If conintt is one and the original sum is odd,
        -- select 1665. Otherwise, select zero.
        --
        -- No arithmetic operation is performed in this stage.
        --------------------------------------------------------------
        
		
		 IF conintt_s1 = '1'  THEN

            sum_delay_s2 <= "00" & sum_s1(13 DOWNTO 1);

        ELSE

            sum_delay_s2 <= '0' & sum_s1;

        END IF;

        IF conintt_s1 = '1' AND sum_s1(0) = '1' THEN

            add_value_s2 <= ADD_VALUE;

        ELSE

            add_value_s2 <= ZERO_15;

        END IF;


        --------------------------------------------------------------
        -- Stage 3
        --
        -- Add the selected value to the original sum.
        --
        -- This stage contains one 15-bit adder.
        --------------------------------------------------------------
        adjusted_s3 <=
            sum_delay_s2 + add_value_s2;


        --------------------------------------------------------------
        -- Stage 4
        --
        -- Select the modular-correction value.
        --
        -- adjusted_s3 >= 6658 : add -6658
        -- adjusted_s3 >= 3329 : add -3329
        -- otherwise           : add zero
        --------------------------------------------------------------
        adjusted_delay_s4 <= adjusted_s3;

        IF adjusted_s3 >= TWO_Q THEN

            correction_s4 <= NEG_TWO_Q;

        ELSIF adjusted_s3 >= Q THEN

            correction_s4 <= NEG_Q;

        ELSE

            correction_s4 <= ZERO_15;

        END IF;


        --------------------------------------------------------------
        -- Stage 5
        --
        -- Perform modular correction.
        --
        -- This stage contains one 15-bit adder.
        --------------------------------------------------------------
        result_s5 <=
            adjusted_delay_s4 + correction_s4;


    END IF;

END PROCESS;


    --------------------------------------------------------------
    -- Final modular output is between 0 and 3328.
    --------------------------------------------------------------
    result <= result_s5(11 DOWNTO 0);


END behaviour;