LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
USE std.standard.ALL;

LIBRARY work;
USE work.ALL;


ENTITY ms IS

    PORT(
        clk         : IN  std_logic;
        direction   : IN  std_logic;
        a           : IN  std_logic_vector(11 DOWNTO 0);
        b           : IN  std_logic_vector(11 DOWNTO 0);
        result      : OUT std_logic_vector(11 DOWNTO 0)
    );

END ms;


ARCHITECTURE behaviour OF ms IS


        SIGNAL left_s1       : std_logic_vector(12 DOWNTO 0);
        SIGNAL right_s1      : std_logic_vector(12 DOWNTO 0);

        SIGNAL difference_s2 : std_logic_vector(12 DOWNTO 0);
        SIGNAL result_s3     : std_logic_vector(12 DOWNTO 0);

        -- 3329 represented as a positive signed 13-bit number.
        CONSTANT Q : std_logic_vector(12 DOWNTO 0) :=
            "0110100000001";

        ATTRIBUTE use_dsp : STRING;
        ATTRIBUTE use_dsp OF behaviour : ARCHITECTURE IS "no";


BEGIN


PROCESS(clk)
BEGIN

    IF clk'EVENT AND clk = '1' THEN

        --------------------------------------------------------------
        -- Stage 1
        --
        -- direction = '0' : a - b
        -- direction = '1' : b - a
        --------------------------------------------------------------
        IF direction = '0' THEN

            left_s1  <= '0' & a;
            right_s1 <= '0' & b;

        ELSE

            left_s1  <= '0' & b;
            right_s1 <= '0' & a;

        END IF;


        --------------------------------------------------------------
        -- Stage 2
        --
        -- Signed subtraction because STD_LOGIC_SIGNED is used.
        --------------------------------------------------------------
        difference_s2 <= left_s1 - right_s1;


        --------------------------------------------------------------
        -- Stage 3
        --
        -- If the subtraction is negative, add 3329.
        --------------------------------------------------------------
        IF difference_s2(12) = '1' THEN

            result_s3 <= difference_s2 + Q;

        ELSE

            result_s3 <= difference_s2;

        END IF;


    END IF;

END PROCESS;


    result <= result_s3(11 DOWNTO 0);


END behaviour;