LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; 
LIBRARY std;
USE std.standard.all;
LIBRARY work;
USE work.ALL;


ENTITY ag IS

	PORT(
	
		clk			:	in		std_logic;
		nrst			:	in		std_logic;
		en			:	in		std_logic;
		mode		: 	IN  std_logic_vector(1 DOWNTO 0);
		
		ra00		: 	OUT  std_logic_vector(6 DOWNTO 0);
		ra01		: 	OUT  std_logic_vector(6 DOWNTO 0);
		ra10		: 	OUT  std_logic_vector(7 DOWNTO 0);
		ra11		: 	OUT  std_logic_vector(7 DOWNTO 0);
		ra20		: 	OUT  std_logic_vector(6 DOWNTO 0);
		ra21		: 	OUT  std_logic_vector(6 DOWNTO 0);
		ra30		: 	OUT  std_logic_vector(7 DOWNTO 0);
		ra31		: 	OUT  std_logic_vector(7 DOWNTO 0);
		
		zeta0		: 	OUT  std_logic_vector(8 DOWNTO 0);
		zeta1		: 	OUT  std_logic_vector(8 DOWNTO 0);
		
		wa0		: 	OUT  std_logic_vector(6 DOWNTO 0);
		wa1		: 	OUT  std_logic_vector(7 DOWNTO 0);
		wa2		: 	OUT  std_logic_vector(6 DOWNTO 0);
		wa3		: 	OUT  std_logic_vector(7 DOWNTO 0);
		
		we0		: 	OUT  std_logic;
		we1		: 	OUT  std_logic;
		we2		: 	OUT  std_logic;
		we3		: 	OUT  std_logic;
		
		ch		: 	OUT  std_logic;
		
		sout		: 	OUT  std_logic_vector(2 DOWNTO 0);
		
		
		done		: 	OUT  std_logic
	
	);


END ag;





ARCHITECTURE behaviour OF ag IS

--	attribute dont_touch : string;
--    attribute dont_touch of behaviour : architecture is "yes";

	 COMPONENT r_cntr IS
					PORT(
					
						clk 	: in  STD_LOGIC;
						rst : in  STD_LOGIC;
						en  	: in  STD_LOGIC;
						half : out  STD_LOGIC;
						allone  : out  STD_LOGIC;
						Q   	: out STD_LOGIC_VECTOR(5 downto 0)
					
				
				);

	 END COMPONENT;	
	 
	 

	 COMPONENT w_cntr IS
					PORT(
				
							clk : in  STD_LOGIC;
							rst : in  STD_LOGIC;
							en  : in  STD_LOGIC;
							allone : out  STD_LOGIC;
							Q   : out STD_LOGIC_VECTOR(5 downto 0)
				
						);

	 END COMPONENT;	
	 

	 
	 
	TYPE state IS (idle , tontt, toinvntt , topwm );
	SIGNAL cur_st : state ;
	SIGNAL nxt_st : state;

	SIGNAL ren  			: std_logic;
	SIGNAL rrst  			: std_logic;
	SIGNAL rallone  		: std_logic;
	SIGNAL rhalf  		: std_logic;
	SIGNAL rcout   			: std_logic_vector(5 downto 0);

	SIGNAL wen  			: std_logic;
	SIGNAL wrst  			: std_logic;
	SIGNAL wallone  		: std_logic;
	SIGNAL wcout   			: std_logic_vector(5 downto 0);
	

	
	SIGNAL m		: std_logic_vector(1 downto 0);
	SIGNAL bfmod0		: std_logic_vector(1 downto 0);
	SIGNAL bfmod1		: std_logic_vector(1 downto 0);
	
	SIGNAL pdone	: std_logic;
	
	SIGNAL pp	: std_logic;
	SIGNAL padding	: std_logic;
	
	
	
	SIGNAL s		: std_logic_vector(2 downto 0);
	SIGNAL spwm		: std_logic_vector(2 downto 0);
	SIGNAL spwm0		: std_logic_vector(2 downto 0);
	SIGNAL spwm1		: std_logic_vector(2 downto 0);
	SIGNAL spwm2		: std_logic_vector(2 downto 0);
	SIGNAL spwm3		: std_logic_vector(2 downto 0);
	SIGNAL sw		: std_logic_vector(2 downto 0);
	
	SIGNAL pow0		: std_logic_vector(8 downto 0);
	SIGNAL pow1		: std_logic_vector(8 downto 0);
	SIGNAL pow2		: std_logic_vector(8 downto 0);
	SIGNAL pow3		: std_logic_vector(8 downto 0);
	
	SIGNAL selpow		: std_logic_vector(2 downto 0);
	
	
	SIGNAL delay_cnt : std_logic_vector(4 downto 0);
	SIGNAL delay_cntpwm : std_logic_vector(4 downto 0);
	
	
	SIGNAL ch0 : std_logic;
	SIGNAL ch1 : std_logic;
	SIGNAL ch2 : std_logic;
	SIGNAL ch3 : std_logic;

	SIGNAL wt0  : std_logic;
	SIGNAL wt1  : std_logic;
	SIGNAL wt2  : std_logic;
	SIGNAL wt3  : std_logic;
	SIGNAL wt4  : std_logic;
	SIGNAL wt5  : std_logic;
	SIGNAL wt6  : std_logic;
	SIGNAL wt7  : std_logic;


BEGIN



	rcntrmodule   :  	r_cntr PORT MAP(
	
	clk 	 =>  clk	   ,
	rst 	 =>  rrst	   ,
	en  	 =>  ren  		   ,
	half  => rhalf,
	allone   =>  rallone	   ,      
	Q   	 =>  rcout  	   );       
	
	
	wcntrmodule   :  	w_cntr PORT MAP(
	
	clk 	 =>  	clk ,
	rst		=> wrst,
	en  	 =>    wen     ,      
	allone   =>    wallone ,      
	Q   	 =>    wcout  	   );     
	
	
	
	
	with selpow select  pow0 <= 	"000000001" when "000",         
							"000000010" when "001",  
							"000000100" when "010",  
							"000001000" when "011",  
							"000010000" when "100",  
							"000100000" when "101",  
							"001000000" when others; 
							
	with selpow select  pow1 <= 	"000000001" when "000",         
							"000000011" when "001",  
							"000000111" when "010",  
							"000001111" when "011",  
							"000011111" when "100",  
							"000111111" when "101",  
							"001111111" when others; 
							
	with selpow select  pow2 <= 	"011000000" when "000",         
									"010100000" when "001",  
									"010010000" when "010",  
									"010001000" when "011",  
									"010000100" when "100",  
									"010000010" when "101",  
									"010000001" when others; 
							
	with selpow select  pow3 <= 	"000111111" when "000",         
							"000011111" when "001",  
							"000001111" when "010",  
							"000000111" when "011",  
							"000000011" when "100",  
							"000000001" when "101",  
							"000000000" when others; 
	
	

	
	
	
	
	
	done <= pdone;
	
	
	
	
	
PROCESS(clk)
	BEGIN
  
	IF  clk'EVENT AND clk = '1' THEN
				
			IF nrst = '0' THEN
					
				cur_st		<=	idle;
				
				delay_cnt <= (Others => '0');
				delay_cntpwm <= (Others => '0');
				wen       <= '0';
				wrst      <= '1';
				
	
			ELSIF nrst='1' THEN
				
				
				cur_st <= nxt_st;
				
				pdone		<=	'0';
				
				ch<='0';
				
				wt1<= wt0;
				wt2<= wt1;
				wt3<= wt2;
				wt4<= wt3;
				wt5<= wt4;
				wt6<= wt5;
				
				
				
				
				
				
				IF cur_st = idle THEN
					
					
					ch0 <= '0';
					ch1 <= '0';
					ch2 <= '0';
					ch3 <= '0';
					
					
					s	<=	(Others => '0'); 
					sw	<=	(Others => '0'); 
					spwm	<=	(Others => '0'); 
					spwm0	<=	(Others => '0'); 
					spwm1	<=	(Others => '0'); 
					spwm2	<=	(Others => '0'); 
					spwm3	<=	(Others => '0'); 
					selpow	<=	(Others => '0'); 
					
					m(0)	<=	mode(0) and not(mode(1));
					m(1)	<=	mode(1);
					
					ren <= '0';
					rrst <= '1';
					
	                wen <= '0';
				    wrst <= '1';
					
					pp <= '0';
					padding <= '0';
					
					
					we0 <=  '0';
					we1 <=  '0';
					we2 <=  '0';
					we3 <=  '0';
					
					
					delay_cnt <= (Others => '0');
					
					sout <= (Others => '0');
					
					
					wt0<='0';
					wt1<='0';
					wt2<='0';
					wt3<='0';
					wt4<='0';
					wt5<='0';
					wt6<='0';
					
					
					
					
					
				
				ELSIF cur_st = tontt THEN
					
					
						
						
						
						
				
					
					
					ren <= '1';
					rrst <= '0';
					
	                wrst <= '0';

					IF unsigned(delay_cnt) < 30 THEN
					
						delay_cnt <= std_logic_vector(unsigned(delay_cnt) + 1);
						wen <= '0';
					
					ELSE
					
						wen <= '1';
					
					END IF;
					
					
					we0 <= wen;
					we1 <= wen;
					we2 <= wen;
                    we3 <= wen;
					
					if rallone ='1' THEN
						pp <= not pp;
						selpow <= std_logic_vector(unsigned(selpow) + 1);
						
					end  if;
					
					if wallone ='1' THEN
						padding <= not padding;
						s <= std_logic_vector(unsigned(s) + 1);
						
					end  if;
						
					
					ra00	<= pp & '0' & rcout(5 downto 1)      ;
					ra01	<= pp & '1' & rcout(5 downto 1)      ;
					ra10	<= '0' & pp &'0' & rcout(5 downto 1) ;
					ra11	<= '0' & pp &'1' & rcout(5 downto 1) ;
					ra20	<= pp & '0' & rcout(5 downto 1)      ;
					ra21	<= pp & '1' & rcout(5 downto 1)      ;
					ra30	<= '0' & pp & '0' & rcout(5 downto 1);
					ra31	<= '0' & pp & '1' & rcout(5 downto 1);
					
					zeta0	<= pow0 or (pow1 and ("00" &rcout & '0') );
					zeta1	<= pow0 or (pow1 and ("00" &rcout & '1') );
					   
					wa0		<= (not padding)  & wcout ;
					wa1		<= '0' & (not padding)  & wcout;
					wa2		<= (not padding)  & wcout ;
					wa3		<= '0' & (not padding) & wcout;
			
						
				
					if s = "111" THEN 
						pdone<= '1';
						we0 <=  '0';
						we1 <=  '0';
						we2 <=  '0';
						we3 <=  '0';
					end if;
		
				
				ELSIF cur_st = toinvntt THEN
					
					
					ch0 <= rhalf or rallone;
					ch1 <= ch0;
					ch2 <= ch1;
					ch3 <= ch2;
					ch <= ch3;
					
					
					
					ren <= '1';
					rrst <= '0';
					
	                wrst <= '0';

					IF unsigned(delay_cnt) < 28 THEN
					
						delay_cnt <= std_logic_vector(unsigned(delay_cnt) + 1);
						wen <= '0';
					
					ELSE
					
						wen <= '1';
					
					END IF;
					
					
					we0 <= wen;
					we1 <= wen;
					we2 <= wen;
                    we3 <= wen;
					
					if rallone ='1' THEN
						pp <= not pp;
						selpow <= std_logic_vector(unsigned(selpow) + 1);
						
					end  if;
					
					if wallone ='1' THEN
						padding <= not padding;
						s <= std_logic_vector(unsigned(s) + 1);
						
					end  if;
						
					
					ra00	<= pp  & rcout(4 downto 0) & '0'     ;
					ra01	<= pp  & rcout(4 downto 0) & '1'     ;
					ra10	<= '0' & pp & rcout(4 downto 0)  &'0'  	;
					ra11	<= '0' & pp & rcout(4 downto 0)  &'1'  	;
					ra20	<= pp  & rcout(4 downto 0)  & '0'    ;
					ra21	<= pp  & rcout(4 downto 0)  & '1'    ;
					ra30	<= '0' & pp  & rcout(4 downto 0) & '0';
					ra31	<= '0' & pp  & rcout(4 downto 0) & '1';
					
				
					
					zeta0	<= (("000" & not(rcout  )) and pow3) or pow2 ;
					zeta1	<=  (("000" & not( rcout  )) and pow3) or pow2 ;
					-- zeta1	<=  (("00" & not(rcout  & '1')) and pow3) or pow2 ;
					   
					wa0		<= (not padding)  & wcout ;
					wa1		<= '0' & (not padding)  & wcout;
					wa2		<= (not padding)  & wcout ;
					wa3		<= '0' & (not padding) & wcout;
			
						
				
					if s = "111" THEN 
						pdone<= '1';
						we0 <=  '0';
						we1 <=  '0';
						we2 <=  '0';
						we3 <=  '0';
					end if;
					
					
					
					
					
					
					
					
					
					
						
				ELSIF cur_st = topwm THEN
		
					
					
					spwm0 <= spwm;
					spwm1 <= spwm0;
					spwm2 <= spwm1;
					spwm3 <= spwm2;
					
					sout <= spwm2;
					
					ren <= '1';
					rrst <= '0';
					
	                wrst <= '0';

					IF unsigned(delay_cntpwm) < 23 THEN
					
						delay_cntpwm <= std_logic_vector(unsigned(delay_cntpwm) + 1);
						wen <= '0';
					
					ELSE
					
						wen <= '1';
					
					END IF;
					
					
					if rallone ='1' THEN
						selpow <= std_logic_vector(unsigned(selpow) + 1);
						spwm <= std_logic_vector(unsigned(spwm) + 1);
					end  if;
					
					if wallone ='1' THEN
						sw <= std_logic_vector(unsigned(sw) + 1);
						
					end  if;
					
					
					
					
					
					
					CASE spwm IS 
					
						WHEN "000" =>
						
							ra01 <= '1'  & rcout  ; 
							ra10 <= '0' & '1'  & rcout  ; 
							
							ra11 <= "01" & rcout  ;
							
							ra00 <= '0' & rcout  ; 
							
						
						WHEN "001" =>
						
							ra21 <= '0'  & rcout  ;
							ra30 <= '0' & '1'  & rcout  ;
							ra31 <= '0' & '1'  & rcout  ;
							ra20 <= '1'  & rcout  ;
						
						WHEN "010" =>
							
					
							
							ra10 <= '0' & '1'  & rcout  ; 
							zeta0	<= "001" & rcout   ;
							ra31 <= '0' & '1'  & rcout  ;
							zeta1	<= "100" & rcout   ;
							
						WHEN "011" =>
							
							ra10 <= '0' & '1'  & rcout  ; 
							ra01 <= '0'  & rcout  ;
							ra11 <= '0' & '0'  & rcout  ;
							
							ra30 <= '0' & '1'  & rcout  ; 
							ra20 <= '0'  & rcout  ;
							ra31 <= '0' & '0'  & rcout  ;
							
							
							
							
							
							
							
						WHEN "100" =>
						
							ra10 <= '1' & '0'  & rcout  ; 
							ra21 <= '1'  & rcout  ;
							ra30 <= '0' & '0'  & rcout  ; 
							
							ra31 <= '1' & '0'  & rcout  ;
							ra11 <= '0' & '0'  & rcout  ; 
							ra00 <= '1'  & rcout  ;
						
						WHEN Others =>
						
						
						
					END CASE;  
					
					
					
					
					
					CASE sw IS 
					
						WHEN "000" =>
						
							wa1		<= '0' & '1'  & wcout;
							wa3		<= '1' & '0' & wcout;
							
							we0 <= '0';
							we1 <= wen;
							we2 <= '0';
							we3 <= wen;
							
						
						WHEN "001" =>
							
							
							wa1		<= '1' & '0'  & wcout;
							wa3		<= '0' & '1' & wcout;
						
						
						
						WHEN "010" =>
						
							wa1		<= '0' & '1'  & wcout;
							wa3		<= '0' & '1' & wcout;
						
						
						WHEN "011" =>
							
							wa0		<= '0'  & wcout ;
							wa2		<= '0'  & wcout ;
							
							we1 <= '0';
							we3 <= '0';
							
							wt0 <= '1';
							
							wrst <= not wt4;
							wen <= wt5;
							
							we0 <= wt6;
							we2 <= wt6;
							
							
							
				
							
							
						
						
						WHEN Others =>
						
							wa0		<= '0'  & wcout ;
							wa2		<= '0'  & wcout ;
						
						
						
						
					END CASE;  
					
					
					
					
					if sw = "101" THEN 
						pdone<= '1';
						we0 <=  '0';
						we1 <=  '0';
						we2 <=  '0';
						we3 <=  '0';
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
	  