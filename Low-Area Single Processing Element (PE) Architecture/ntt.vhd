LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL; 
LIBRARY std;
USE std.standard.all;
LIBRARY work;
USE work.ALL;


ENTITY ntt IS

	PORT(
	
			clk         	:   IN  	std_logic;
			nrst        	:   IN  	std_logic;
			
			en	        	:   IN  	std_logic;
			mode	        :	IN		std_logic_vector(1 downto 0);
			
			wein0			:	IN		std_logic;
			wein1			:	IN		std_logic;
			addin0			:	IN		std_logic_vector(8 downto 0);
			addin1			:	IN		std_logic_vector(8 downto 0);
			din0			:	IN		std_logic_vector(11 downto 0);  
			din1			:	IN		std_logic_vector(11 downto 0);  
			dout0			:	OUT		std_logic_vector(11 downto 0);
			dout1			:	OUT		std_logic_vector(11 downto 0);
			
		
			done        	:   OUT 	std_logic
	
	);


END ntt;





ARCHITECTURE behaviour OF ntt IS

--	attribute dont_touch : string;
--    attribute dont_touch of behaviour : architecture is "yes";

	 COMPONENT bf IS
					PORT(
					
							clk			:	in		std_logic;
							bfmod		: 	IN  std_logic_vector(1 DOWNTO 0);
							
							a		: 	IN  std_logic_vector(11 DOWNTO 0);
							b		: 	IN  std_logic_vector(11 DOWNTO 0);
							c 		: 	IN 	std_logic_vector(11 DOWNTO 0);
							
							aout		: 	OUT std_logic_vector(11 DOWNTO 0);
							bout		: 	OUT std_logic_vector(11 DOWNTO 0)
				
				);

	 END COMPONENT;	
	 
	 

	 COMPONENT true_dpram_0 IS
					PORT(
				
							clk			:	in		std_logic;
							we_a		:	in		std_logic;
							we_b		:	in		std_logic;
							data_a		:	in		std_logic_vector(11 downto 0);
							data_b		:	in		std_logic_vector(11 downto 0);
							addr_a		:	in		std_logic_vector(8 downto 0);
							addr_b		:	in		std_logic_vector(8 downto 0);
							q_a			:	out		std_logic_vector(11 downto 0);
							q_b			:	out		std_logic_vector(11 downto 0)
				
						);

	 END COMPONENT;	
	 
	 
	 COMPONENT true_dpram_1 IS
					PORT(
				
							clk			:	in		std_logic;
							we_a		:	in		std_logic;
							we_b		:	in		std_logic;
							data_a		:	in		std_logic_vector(11 downto 0);
							data_b		:	in		std_logic_vector(11 downto 0);
							addr_a		:	in		std_logic_vector(7 downto 0);
							addr_b		:	in		std_logic_vector(7 downto 0);
							q_a			:	out		std_logic_vector(11 downto 0);
							q_b			:	out		std_logic_vector(11 downto 0)
				
						);

	 END COMPONENT;	
	 

	 COMPONENT ROM IS
					PORT(
				
							clk   : in std_logic;
							addr  : in std_logic_vector(8 downto 0);
							dout  : out std_logic_vector(11 downto 0)
							
						);

	 END COMPONENT;	
	 
	 COMPONENT r_cntr IS
					PORT(
							clk : in  STD_LOGIC;
							en	 : in  STD_LOGIC;
							rst : in  STD_LOGIC;
							Q   : out STD_LOGIC_VECTOR(6 downto 0)
							
						);

	 END COMPONENT;	
	 
	  COMPONENT w_cntr IS
					PORT(
							clk : in  STD_LOGIC;
							en	 : in  STD_LOGIC;
							rst : in  STD_LOGIC;
							Q   : out STD_LOGIC_VECTOR(6 downto 0)
							
						);

	 END COMPONENT;	
	 
	 
	 
	TYPE state IS (idle , tontt, toinvntt , topwm );
	SIGNAL cur_st : state ;
	SIGNAL nxt_st : state;



	SIGNAL s		: std_logic_vector(2 downto 0);
	
	SIGNAL a		: std_logic_vector(11 downto 0);
	SIGNAL b		: std_logic_vector(11 downto 0);
	SIGNAL c		: std_logic_vector(11 downto 0);
	SIGNAL aout		: std_logic_vector(11 downto 0);
	SIGNAL bout		: std_logic_vector(11 downto 0);
	
	
	SIGNAL wea0		: std_logic;
	SIGNAL wea1		: std_logic;
	SIGNAL web0		: std_logic;
	SIGNAL web1		: std_logic;
	SIGNAL da0		: std_logic_vector(11 downto 0);
	SIGNAL da1		: std_logic_vector(11 downto 0);
	SIGNAL db0		: std_logic_vector(11 downto 0);
	SIGNAL db1		: std_logic_vector(11 downto 0);
	SIGNAL a0out	: std_logic_vector(11 downto 0);
	SIGNAL b0out	: std_logic_vector(11 downto 0);
	SIGNAL a1out	: std_logic_vector(11 downto 0);
	SIGNAL b1out	: std_logic_vector(11 downto 0);
	
	SIGNAL a0		: std_logic_vector(8 downto 0);
	SIGNAL a1		: std_logic_vector(7 downto 0);
	SIGNAL b0		: std_logic_vector(8 downto 0);
	SIGNAL b1		: std_logic_vector(7 downto 0);
	
	SIGNAL zetain	: std_logic_vector(8 downto 0);
	SIGNAL zetaout	: std_logic_vector(11 downto 0);
	
	
	SIGNAL rcntren	: std_logic;
	SIGNAL wcntren	: std_logic;
	SIGNAL rcntrrst	: std_logic;
	SIGNAL wcntrrst	: std_logic;
	
	SIGNAL rcntr	: std_logic_vector(6 downto 0);
	SIGNAL wcntr	: std_logic_vector(6 downto 0);
	
	SIGNAL ra		: std_logic_vector(8 downto 0);
	SIGNAL rb		: std_logic_vector(8 downto 0);
	SIGNAL rc		: std_logic_vector(8 downto 0);
	SIGNAL waout	: std_logic_vector(8 downto 0);
	SIGNAL wbout	: std_logic_vector(8 downto 0);
	
	
	SIGNAL mux0		: std_logic_vector(1 downto 0);
	SIGNAL mux1		: std_logic_vector(1 downto 0);
	SIGNAL mux2		: std_logic_vector(1 downto 0);
	SIGNAL mux3		: std_logic_vector(1 downto 0);
	SIGNAL mux4		: std_logic;
	SIGNAL mux5		: std_logic;
	SIGNAL mux6		: std_logic;
	SIGNAL mux7		: std_logic;
	SIGNAL mux8		: std_logic_vector(1 downto 0);
	SIGNAL mux9		: std_logic;
	
	SIGNAL mux0out	: std_logic_vector(8 downto 0);
	SIGNAL mux1out	: std_logic_vector(8 downto 0);
	SIGNAL mux2out	: std_logic_vector(8 downto 0);
	SIGNAL mux3out	: std_logic_vector(8 downto 0);
	
	SIGNAL mux4out	: std_logic_vector(11 downto 0);
	SIGNAL mux5out	: std_logic_vector(11 downto 0);
	SIGNAL mux6out	: std_logic_vector(11 downto 0);
	
	SIGNAL mux7out	: std_logic_vector(11 downto 0);
	SIGNAL mux8out	: std_logic_vector(11 downto 0);
	SIGNAL mux9out	: std_logic_vector(11 downto 0);
	
	SIGNAL m		: std_logic_vector(1 downto 0);
	SIGNAL bfmod		: std_logic_vector(1 downto 0);
	
	SIGNAL pdone	: std_logic;
	
	
	SIGNAL aout_out		: std_logic_vector(11 downto 0);
	SIGNAL bout_out		: std_logic_vector(11 downto 0);
	SIGNAL a0out_out	: std_logic_vector(11 downto 0);
	SIGNAL b0out_out	: std_logic_vector(11 downto 0);
	SIGNAL a1out_out	: std_logic_vector(11 downto 0);
	SIGNAL b1out_out	: std_logic_vector(11 downto 0);
	SIGNAL zetaout_out	: std_logic_vector(11 downto 0);
	

	

	
	signal pow0 : std_logic_vector(8 downto 0);
	signal pow1 : std_logic_vector(8 downto 0);
	
	signal pow2 : std_logic_vector(8 downto 0);
	signal pow3 : std_logic_vector(8 downto 0);
	
	SIGNAL rvalid0	: std_logic;
	SIGNAL rvalid1	: std_logic;
	SIGNAL rvalid2	: std_logic;
	SIGNAL rvalid3	: std_logic;
	SIGNAL rvalid4	: std_logic;
	
	SIGNAL rvalid5	: std_logic;
	SIGNAL rvalid6	: std_logic;
	SIGNAL rvalid7	: std_logic;
	SIGNAL rvalid8	: std_logic;
	SIGNAL rvalid9	: std_logic;
	SIGNAL rvalid10	: std_logic;
	SIGNAL rvalid11	: std_logic;
	SIGNAL rvalid12	: std_logic;
	SIGNAL rvalid13	: std_logic;
	SIGNAL rvalid14	: std_logic;
	
	SIGNAL addtemp0		: std_logic_vector(8 downto 0);
	SIGNAL addtemp1		: std_logic_vector(8 downto 0);
	SIGNAL addtemp2		: std_logic_vector(8 downto 0);
	SIGNAL addtemp3		: std_logic_vector(8 downto 0);
	SIGNAL addtemp4		: std_logic_vector(8 downto 0);
	
	SIGNAL addtemp5		: std_logic_vector(8 downto 0);
	SIGNAL addtemp6		: std_logic_vector(8 downto 0);
	SIGNAL addtemp7		: std_logic_vector(8 downto 0);
	SIGNAL addtemp8		: std_logic_vector(8 downto 0);
	SIGNAL addtemp9		: std_logic_vector(8 downto 0);
	SIGNAL addtemp10		: std_logic_vector(8 downto 0);
	SIGNAL addtemp11		: std_logic_vector(8 downto 0);
	SIGNAL addtemp12		: std_logic_vector(8 downto 0);
	

BEGIN


	bfc		:	bf PORT MAP(clk => clk,  bfmod => bfmod , a => a  , b => b , c => c , aout => aout_out   , bout => bout_out   );

	bram0   :  	true_dpram_0 PORT MAP( clk => clk   , we_a =>  wea0  , we_b => web0 , data_a => da0   , data_b	=> db0   ,  addr_a	=>  a0 , addr_b =>  b0 , q_a => a0out_out , q_b =>  b0out_out  );
	bram1	:  	true_dpram_1 PORT MAP( clk => clk  ,  we_a =>  wea1  , we_b => web1 , data_a => da1   , data_b	=> db1   ,  addr_a	=>  a1 , addr_b =>  b1 , q_a => a1out_out , q_b =>  b1out_out  );
	
	zetarom	:	ROM PORT MAP( clk => clk , addr => zetain , dout => zetaout_out);
	
	rcntr_m	: 	r_cntr PORT MAP( clk => clk , en => rcntren , rst => rcntrrst, Q => rcntr );
	wcntr_m	: 	w_cntr PORT MAP( clk => clk , en => wcntren , rst => wcntrrst, Q => wcntr );
	
	
	
	
	
	
	m(0)	<=	mode(0) and not(mode(1));
	m(1)	<=	mode(1);
	
	
	
	
	
	done <= pdone;
	
	
	
	
	dout0	<= a1out_out when cur_st = idle else (Others => '0');
	dout1   <= b1out_out when cur_st = idle else (Others => '0');
	
	mux0out	<=	ra WHEN mux0 = "01" else waout when mux0 = "10" else rc when mux0 = "11" else addin0;
	mux1out	<=	rb WHEN mux1 = "01" else wbout when mux1 = "10" else addin1;
	mux2out	<=	waout WHEN mux2 = "01" else ra when mux2 = "10" else addin0;
	mux3out	<=	wbout WHEN mux3 = "01" else rb when mux3 = "10" else waout when mux3 = "11" else addin1;
	
	mux4out	<=	din0 when mux4 = '0' else aout;
	mux5out	<=	din1 when mux5 = '0' else bout;
	mux6out	<=	aout when mux6 = '0' else bout;
	
	mux7out	<=	a0out when mux7 = '0' else a1out;
	mux8out	<=	b0out when mux8 = "00" else b1out when mux8 = "01" else a1out;
	mux9out	<=	zetaout when mux9 = '0' else a0out;
	
	with s select  pow0 <= 	"000000001" when "000",         
							"000000010" when "001",  
							"000000100" when "010",  
							"000001000" when "011",  
							"000010000" when "100",  
							"000100000" when "101",  
							"001000000" when others; 
							
	with s select  pow1 <= 	"000000001" when "000",         
							"000000011" when "001",  
							"000000111" when "010",  
							"000001111" when "011",  
							"000011111" when "100",  
							"000111111" when "101",  
							"001111111" when others; 
							
	with s select  pow2 <= 	"011000000" when "000",         
							"010100000" when "001",  
							"010010000" when "010",  
							"010001000" when "011",  
							"010000100" when "100",  
							"010000010" when "101",  
							"010000001" when others; 
							
	with s select  pow3 <= 	"000111111" when "000",         
							"000011111" when "001",  
							"000001111" when "010",  
							"000000111" when "011",  
							"000000011" when "100",  
							"000000001" when "101",  
							"000000000" when others; 
	
	
	
	
	aout	<= aout_out;			
	bout	<= bout_out;
	a0out   <= a0out_out;
	b0out   <= b0out_out;
	a1out   <= a1out_out;
	b1out   <= b1out_out;
	zetaout <= zetaout_out;
	
	
	addtemp0 <= "00" & rcntr ;
	
	addtemp5 <= '0' & rcntr & '0' ;
	
	addtemp1 <= "01" & rcntr;
	
	addtemp6 <= '0' & rcntr & '1';
	
	addtemp10 <= "11" & rcntr;
	
	addtemp12 <= "10" & rcntr;
	
	addtemp2 <= (("00"&rcntr) or pow0) and pow1;
	
	addtemp7 <= (("00" & not(rcntr)) and pow3) or pow2;
	
	addtemp11 <= ("000" & rcntr(6 downto 1)) or (rcntr(0) & '0' & not(rcntr(0)) & "000000");
	
	
	ra <= addtemp0 when (cur_st = tontt or (cur_st = topwm and (s="001" or s="011"))) else addtemp5 when cur_st = toinvntt else addtemp1 when (cur_st = topwm and (s="000" or s="010" or s="100" ));
	
	
	rb <= addtemp1 when cur_st = tontt else addtemp6 when cur_st = toinvntt else addtemp10 when (cur_st = topwm and (s="000" or s="011"))  else addtemp12 when (cur_st = topwm and (s="010" or s="100"));
	
	
	
	rc <= addtemp2 when cur_st = tontt  else addtemp7 when cur_st = toinvntt else addtemp11 when (cur_st = topwm and s="001")   else addtemp0 when (cur_st = topwm and s="010") else addtemp1 when (cur_st = topwm and s="100" ) ;
	
	addtemp3 <= '0' & wcntr & '0';
	
	addtemp8 <= "00" & wcntr;
	
	waout <= addtemp3 when cur_st = tontt else addtemp8 when cur_st = toinvntt ;
	
	addtemp4 <= '0' & wcntr & '1';
	
	addtemp9 <= "01" & wcntr;
	
	wbout <= addtemp4 when cur_st = tontt  else addtemp9 when (cur_st = toinvntt or (cur_st = topwm and (s="001" or s="011" or s="100" ))) else addtemp8 when (cur_st = topwm and (s="000" or s="010")) ;
	
							

	
PROCESS(clk)
	BEGIN
  
	IF  clk'EVENT AND clk = '1' THEN
				
			IF nrst = '0' THEN
					
				cur_st		<=	idle;
				
				bfmod		<=	(Others => '0'); 
				
				a			<=	(Others => '0'); 
				b			<=	(Others => '0'); 
				c			<=	(Others => '0'); 
				
				wea0		<=	'0'; 	
				wea1		<=	'0'; 	
				web0		<=	'0'; 	
				web1		<=	'0'; 	
				
				da0			<=	(Others => '0'); 
				da1			<=	(Others => '0'); 
				db0			<=	(Others => '0'); 
				db1			<=	(Others => '0'); 
				
				a0			<=	(Others => '0'); 
				a1			<=	(Others => '0'); 
				b0			<=	(Others => '0'); 
				b1			<=	(Others => '0'); 
				
				zetain		<=	(Others => '0'); 
				
				
				
				rcntren		<=	'0'; 
				wcntren		<=	'0'; 
				rcntrrst	<=	'1'; 	
				wcntrrst	<=	'1'; 	
				
				s			<=	(Others => '0'); 
				
		
				pdone		<=	'0';
				
				mux0	<=	(Others => '0'); 
				mux1    <=	(Others => '0'); 
				mux2    <=	(Others => '0'); 
				mux3    <=	(Others => '0'); 
				mux4    <=	'0';
				mux5    <=	'0';
				mux6    <=	'0';
				mux7    <=	'0';
				mux8    <=	(Others => '0'); 
				mux9    <=	'0';
				
				
				rvalid0	<= '0';
				rvalid1 <= '0';
				rvalid2 <= '0';
				rvalid3 <= '0';
				rvalid4 <= '0';
				
				rvalid5 <= '0';
				rvalid6 <= '0';
				rvalid7 <= '0';
				rvalid8 <= '0';
				rvalid9 <= '0';
				rvalid10 <= '0';
				rvalid11 <= '0';
				rvalid12 <= '0';
				rvalid13 <= '0';
				rvalid14 <= '0';
				
				
				
				
	
			ELSIF nrst='1' THEN
				
				
				cur_st <= nxt_st;
				
				pdone		<=	'0';
				
				a0	<=	mux0out;
				b0	<=	mux1out;
				
				a1	<=	mux2out(7 downto 0);
				b1	<=	mux3out(7 downto 0);
				
				da0	<=	mux4out;
				db0	<=	mux5out;
				da1 <=	aout;
				db1 <=	mux6out;
				
				
				a	<=	mux7out;
				b	<=	mux8out;
				c	<=	mux9out;
				
				
				
				zetain	<=	rc;
				

				
				IF cur_st = idle THEN
					
					rcntren		<=	'0'; 
				    wcntren		<=	'0'; 
				    rcntrrst	<=	'1'; 	
				    wcntrrst	<=	'1'; 	
					
					mux0 <= "00";
					mux1 <= "00";
					mux2 <= "00";
					mux3 <= "00";
					
					mux4    <=	'0';
					mux5    <=	'0';
					mux6    <=	'0';
					mux7    <=	'0';
					mux8    <=	(Others => '0'); 
					mux9    <=	'0';
					
					
					wea0 <=  wein0;
					web0 <=  wein1;
					
					wea1 <= '0';
					web1 <= '0';
					
					bfmod <= m;
					
					
					s	<=	(Others => '0'); 
					
					

					
					rvalid0	<= '0';
					rvalid1 <= '0';
					rvalid2 <= '0';
					rvalid3 <= '0';
					rvalid4 <= '0';
					
					rvalid5 <= '0';
					rvalid6 <= '0';
					rvalid7 <= '0';
					rvalid8 <= '0';
					rvalid9 <= '0';
					rvalid10 <= '0';
					rvalid11 <= '0';
					rvalid12 <= '0';
					rvalid13 <= '0';
					rvalid14 <= '0';
				
					
					
					
					
				
				ELSIF cur_st = tontt THEN
					
					rvalid14 <= rvalid13;
					rvalid13 <= rvalid12;
					rvalid12 <= rvalid11;
					rvalid11 <= rvalid10;
					rvalid10 <= rvalid9;
					rvalid9 <= rvalid8;
					
					rvalid8 <= rvalid7;
					rvalid7 <= rvalid6;
					rvalid6 <= rvalid5;
					rvalid5 <= rvalid4;
					
					rvalid4 <= rvalid3;
					rvalid3 <= rvalid2;
					rvalid2 <= rvalid1;
					rvalid1 <= rvalid0;
					
					
					rcntren		<=	'1'; 
				    wcntren		<=	'1' and rvalid11; 
				    rcntrrst	<=	'0'; 	
				    wcntrrst	<=	'0'; 

					wea0 <=	 ('1' xor not(s(0))) and rvalid12;
					web0 <=  ('1' xor not(s(0))) and rvalid12;
					wea1 <=	 ('1' xor s(0)) and rvalid12;
					web1 <=  ('1' xor s(0)) and rvalid12;
					
			
					
					

					
					
					if s(0) = '0'  then
						
						rvalid0 <= '1';
						
						mux0 <= "01";
						mux1 <= "01";
						
						mux2 <= "01";
						mux3 <= "01";
						
						mux6 <= '1';
						
						mux7 <= '0';
						mux8 <= "00";
						mux9 <= '0';
		
						
						
					end if;
					
					
					if s(0) = '1' then
						
						rvalid0 <= '1';

						
						mux0 <= "10";
						mux1 <= "10";
						
						mux2 <= "10";
						mux3 <= "10";
						
						mux4 <= '1';
						mux5 <= '1';
						
						mux7 <= '1';
						mux8 <= "01";
						mux9 <= '0';
						
			
						
					end if;

					
					
					if rcntr = "1111111" then
						
						rvalid0 <= '0';
						rcntren		<=	'0'; 
						rcntrrst	<=	'1'; 
						
					end if;
					
					if wcntr = "1111111"  then
						
						rvalid0 <= '0';
						rvalid1 <= '0';
						rvalid2 <= '0';
						rvalid3 <= '0';
						rvalid4 <= '0';
						rvalid5 <= '0';
						rvalid6 <= '0';
						rvalid7 <= '0';
						rvalid8 <= '0';
						rvalid9 <= '0';
						rvalid10 <= '0';
						rvalid11 <= '0';
						rvalid12 <= '0';
						rvalid13 <= '0';
						rvalid14 <= '0';
						s <= s + "001";
						rcntren		<=	'0'; 
						wcntren		<=	'0'; 
						rcntrrst	<=	'1'; 	
						wcntrrst	<=	'1'; 
						
					end if;
					
			
					
					
					if s = "111" then
						wea0 <=	'0';
						web0 <= '0';
						wea1 <=	'0';
						web1 <= '0';
						rcntren		<=	'0'; 
						wcntren		<=	'0'; 
						rcntrrst	<=	'1'; 	
						wcntrrst	<=	'1'; 	
						pdone <= '1';
						
					end if;
				
				
				ELSIF cur_st = toinvntt THEN
					
					rvalid14 <= rvalid13;
					rvalid13 <= rvalid12;
					rvalid12 <= rvalid11;
					rvalid11 <= rvalid10;
					rvalid10 <= rvalid9;
					rvalid9 <= rvalid8;
					
					rvalid8 <= rvalid7;
					rvalid7 <= rvalid6;
					rvalid6 <= rvalid5;
					rvalid5 <= rvalid4;
					
					rvalid4 <= rvalid3;
					rvalid3 <= rvalid2;
					rvalid2 <= rvalid1;
					rvalid1 <= rvalid0;
					
					
					rcntren		<=	'1'; 
				    wcntren		<=	'1' and rvalid11; 
				    rcntrrst	<=	'0'; 	
				    wcntrrst	<=	'0'; 

					wea0 <=	 ('1' xor not(s(0))) and rvalid12;
					web0 <=  ('1' xor not(s(0))) and rvalid12;
					wea1 <=	 ('1' xor s(0)) and rvalid12;
					web1 <=  ('1' xor s(0)) and rvalid12;
					
			
					
					

					
					
					if s(0) = '0'  then
						
						rvalid0 <= '1';
						
						mux0 <= "01";
						mux1 <= "01";
						
						mux2 <= "01";
						mux3 <= "01";
						
						mux6 <= '1';
						
						mux7 <= '0';
						mux8 <= "00";
						mux9 <= '0';
		
						
						
					end if;
					
					
					if s(0) = '1' then
						
						rvalid0 <= '1';

						
						mux0 <= "10";
						mux1 <= "10";
						
						mux2 <= "10";
						mux3 <= "10";
						
						mux4 <= '1';
						mux5 <= '1';
						
						mux7 <= '1';
						mux8 <= "01";
						mux9 <= '0';
						
			
						
					end if;

					if rcntr = "1111111" then
						
						rvalid0 <= '0';
						rcntren		<=	'0'; 
						rcntrrst	<=	'1'; 
						
					end if;
					
					if wcntr = "1111111" then
						
						rvalid0 <= '0';
						rvalid1 <= '0';
						rvalid2 <= '0';
						rvalid3 <= '0';
						rvalid4 <= '0';
						rvalid5 <= '0';
						rvalid6 <= '0';
						rvalid7 <= '0';
						rvalid8 <= '0';
						rvalid9 <= '0';
						rvalid10 <= '0';
						rvalid11 <= '0';
						rvalid12 <= '0';
						rvalid13 <= '0';
						rvalid14 <= '0';
						s <= s + "001";
						rcntren		<=	'0'; 
						wcntren		<=	'0'; 
						rcntrrst	<=	'1'; 	
						wcntrrst	<=	'1'; 
						
					end if;

					
					
					if s = "111" then
						wea0 <=	'0';
						web0 <= '0';
						wea1 <=	'0';
						web1 <= '0';
						rcntren		<=	'0'; 
						wcntren		<=	'0'; 
						rcntrrst	<=	'1'; 	
						wcntrrst	<=	'1'; 	
						pdone <= '1';
						
					end if;
				
				
				ELSIF cur_st = topwm THEN
					
					wea0 <=	'0';
					web0 <= '0';
					wea1 <=	'0';
					web1 <= '0';
					
					rvalid14 <= rvalid13;
					rvalid13 <= rvalid12;
					rvalid12 <= rvalid11;
					rvalid11 <= rvalid10;
					rvalid10 <= rvalid9;
					rvalid9 <= rvalid8;
					
					rvalid8 <= rvalid7;
					rvalid7 <= rvalid6;
					rvalid6 <= rvalid5;
					rvalid5 <= rvalid4;
					
					rvalid4 <= rvalid3;
					rvalid3 <= rvalid2;
					rvalid2 <= rvalid1;
					rvalid1 <= rvalid0;
					
					rcntren		<=	'1'; 
				    wcntren		<=	'1' and rvalid11; 
				    rcntrrst	<=	'0'; 	
				    wcntrrst	<=	'0'; 
					
					
					if s = "000" then
					
						rvalid0 <= '1';

						
						mux0 <= "01";
						mux1 <= "01";
						
						mux2 <= "01";
						mux3 <= "01";
						
						--mux4 <= '1';
						--mux5 <= '1';
						mux6 <= '1';
						
						--mux7 <= '1';
						mux8 <= "00";
						mux9 <= '1';
						
						wea0 <=	 '0';
						web0 <=  '0';
						wea1 <=	 '0';
						web1 <=  '1' and rvalid12;
						
					
					elsif s = "001" then
					
					
						rvalid0 <= '1';

						
						--mux0 <= "01";
						--mux1 <= "01";
						
						mux2 <= "10";
						mux3 <= "01";
						
						--mux4 <= '1';
						--mux5 <= '1';
						mux6 <= '1';
						
						--mux7 <= '1';
						mux8 <= "11";
						mux9 <= '0';
						
						wea0 <=	 '0';
						web0 <=  '0';
						wea1 <=	 '0';
						web1 <=  '1' and rvalid12;
					
					
					elsif s = "010" then
						
						rvalid0 <= '1';

						
						mux0 <= "11";
						mux1 <= "01";
						
						mux2 <= "10";
						mux3 <= "01";
						
						--mux4 <= '1';
						--mux5 <= '1';
						mux6 <= '0';
						
						mux7 <= '1';
						mux8 <= "00";
						mux9 <= '1';
						
						wea0 <=	 '0';
						web0 <=  '0';
						wea1 <=	 '0';
						web1 <=  '1' and rvalid12;
					
					
					
					elsif s = "011" then
					
						rvalid0 <= '1';

						
						mux0 <= "01";
						mux1 <= "01";
						
						mux2 <= "01";
						mux3 <= "01";
						
						--mux4 <= '1';
						--mux5 <= '1';
						mux6 <= '1';
						
						--mux7 <= '1';
						mux8 <= "00";
						mux9 <= '1';
						
						wea0 <=	 '0';
						web0 <=  '0';
						wea1 <=	 '0';
						web1 <=  '1' and rvalid12;
						
					
					
					
					elsif s = "100" then
						
						rvalid0 <= '1';

						
						mux0 <= "11";
						mux1 <= "01";
						
						mux2 <= "10";
						mux3 <= "01";
						
						--mux4 <= '1';
						--mux5 <= '1';
						mux6 <= '0';
						
						mux7 <= '1';
						mux8 <= "00";
						mux9 <= '1';
						
						wea0 <=	 '0';
						web0 <=  '0';
						wea1 <=	 '0';
						web1 <=  '1' and rvalid12;
					
					
					
					else
					
						wea0 <=	'0';
						web0 <= '0';
						wea1 <=	'0';
						web1 <= '0';
						rcntren		<=	'0'; 
						wcntren		<=	'0'; 
						rcntrrst	<=	'1'; 	
						wcntrrst	<=	'1'; 	
						pdone <= '1';
						
					
					end if;
					
					if rcntr = "1111111" then
						
						rvalid0 <= '0';
						rcntren		<=	'0'; 
						rcntrrst	<=	'1'; 
						
					end if;
					
					
					if wcntr = "1111111" then
						
						
						rvalid0 <= '0';
						rvalid1 <= '0';
						rvalid2 <= '0';
						rvalid3 <= '0';
						rvalid4 <= '0';
						rvalid5 <= '0';
						rvalid6 <= '0';
						rvalid7 <= '0';
						rvalid8 <= '0';
						rvalid9 <= '0';
						rvalid10 <= '0';
						rvalid11 <= '0';
						rvalid12 <= '0';
						rvalid13 <= '0';
						rvalid14 <= '0';
						s <= s + "001";
						rcntren		<=	'0'; 
						wcntren		<=	'0'; 
						rcntrrst	<=	'1'; 	
						wcntrrst	<=	'1'; 
						
					end if;

					
					
				
					
					
					
					
				
				
				END IF;
				
			
			
			END IF;
		
		
	END IF;	
 
 
END PROCESS;



 PROCESS (cur_st, en, mode, m , pdone)    --add done
	BEGIN
   
	nxt_st <= cur_st;
   
	

   
    CASE cur_st  IS
	
		WHEN idle =>
			
			IF en = '1'   THEN
			
				IF	m	=	"00" THEN
			
					nxt_st <= tontt;
			
				elsif	m	= "01" THEN
				
					nxt_st <= toinvntt;
				
				else
				
					nxt_st <= topwm;
				
				END IF;
			
			END IF;
			
			
			
      
		WHEN tontt =>
			
			IF pdone = '1'   THEN
			
			nxt_st <= idle;
			
			END IF;
			
			
		WHEN toinvntt =>
			
			IF pdone = '1'   THEN
			
			nxt_st <= idle;
			
			END IF;
	  
		WHEN topwm =>
			
			IF pdone = '1'   THEN
			
			nxt_st <= idle;
			
			END IF;
	
	END CASE;  
	
	
	
END PROCESS;
	
END behaviour;
	  