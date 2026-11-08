LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
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
			
			iowe0				:	IN		std_logic;
			iowadd0				:	IN		std_logic_vector(6 downto 0);
			iowdata0			:	IN		std_logic_vector(11 downto 0);
			ioradd00			:	IN		std_logic_vector(6 downto 0);
			ioradd01			:	IN		std_logic_vector(6 downto 0);
			iodata00			:	OUT		std_logic_vector(11 downto 0);  
			iodata01			:	OUT		std_logic_vector(11 downto 0);  
			
			iowe1				:	IN		std_logic;
			iowadd1				:	IN		std_logic_vector(7 downto 0);
			iowdata1			:	IN		std_logic_vector(11 downto 0);
			ioradd10			:	IN		std_logic_vector(7 downto 0);
			ioradd11			:	IN		std_logic_vector(7 downto 0);
			iodata10			:	OUT		std_logic_vector(11 downto 0);  
			iodata11			:	OUT		std_logic_vector(11 downto 0);  
			
			iowe2				:	IN		std_logic;
			iowadd2				:	IN		std_logic_vector(6 downto 0);
			iowdata2			:	IN		std_logic_vector(11 downto 0);
			ioradd20			:	IN		std_logic_vector(6 downto 0);
			ioradd21			:	IN		std_logic_vector(6 downto 0);
			iodata20			:	OUT		std_logic_vector(11 downto 0);  
			iodata21			:	OUT		std_logic_vector(11 downto 0);  
			
			iowe3				:	IN		std_logic;
			iowadd3				:	IN		std_logic_vector(7 downto 0);
			iowdata3			:	IN		std_logic_vector(11 downto 0);
			ioradd30			:	IN		std_logic_vector(7 downto 0);
			ioradd31			:	IN		std_logic_vector(7 downto 0);
			iodata30			:	OUT		std_logic_vector(11 downto 0);  
			iodata31			:	OUT		std_logic_vector(11 downto 0);  
			
			
			
		
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
	 
	 

	 COMPONENT lutram128 IS
					PORT(
				
						clk : in std_logic;

						-- Write port
						wr_en   : in std_logic;
						wr_addr : in std_logic_vector(6 downto 0);
						wr_data : in std_logic_vector(11 downto 0);
						
						-- Read port A
						rd_addr_a : in  std_logic_vector(6 downto 0);
						rd_data_a : out std_logic_vector(11 downto 0);
						
						-- Read port B
						rd_addr_b : in  std_logic_vector(6 downto 0);
						rd_data_b : out std_logic_vector(11 downto 0)
				
						);

	 END COMPONENT;	
	 

	 COMPONENT lutram192 IS
					PORT(
				
						clk : in std_logic;

						-- Write port
						wr_en   : in std_logic;
						wr_addr : in std_logic_vector(7 downto 0);
						wr_data : in std_logic_vector(11 downto 0);
						
						-- Read port A
						rd_addr_a : in  std_logic_vector(7 downto 0);
						rd_data_a : out std_logic_vector(11 downto 0);
						
						-- Read port B
						rd_addr_b : in  std_logic_vector(7 downto 0);
						rd_data_b : out std_logic_vector(11 downto 0)
				
						);

	 END COMPONENT;	
	 	 

	 

	 COMPONENT lutrom IS
					PORT(
				
							clk       : in  std_logic;

							rd_addr_a : in  std_logic_vector(8 downto 0);
							rd_data_a : out std_logic_vector(11 downto 0);
					
							rd_addr_b : in  std_logic_vector(8 downto 0);
							rd_data_b : out std_logic_vector(11 downto 0)
							
						);

	 END COMPONENT;	
	
	 
	 
	 COMPONENT ag IS
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

	 END COMPONENT;	
	 
	 
	 
	TYPE state IS (idle , tontt, toinvntt , topwm );
	SIGNAL cur_st : state ;
	SIGNAL nxt_st : state;


	SIGNAL a0		: std_logic_vector(11 downto 0);
	SIGNAL b0		: std_logic_vector(11 downto 0);
	SIGNAL c0		: std_logic_vector(11 downto 0);
	
	SIGNAL a1		: std_logic_vector(11 downto 0);
	SIGNAL b1		: std_logic_vector(11 downto 0);
	SIGNAL c1		: std_logic_vector(11 downto 0);
		

	SIGNAL a0out	: std_logic_vector(11 downto 0);
	SIGNAL b0out	: std_logic_vector(11 downto 0);
	
	SIGNAL a1out	: std_logic_vector(11 downto 0);
	SIGNAL b1out	: std_logic_vector(11 downto 0);
	

	

	
	SIGNAL m		: std_logic_vector(1 downto 0);
	
	
	SIGNAL pdone	: std_logic;
	
	


	SIGNAL wr_en0    	: std_logic;
	SIGNAL wr_addr0  	: std_logic_vector(6 downto 0);
	SIGNAL wr_data0  	: std_logic_vector(11 downto 0);
	SIGNAL rd_addr_00	: std_logic_vector(6 downto 0);
	SIGNAL rd_data_00	: std_logic_vector(11 downto 0);
	SIGNAL rd_addr_01		: std_logic_vector(6 downto 0);
	SIGNAL rd_data_01 		: std_logic_vector(11 downto 0);
	
	SIGNAL wr_en1    	: std_logic;
	SIGNAL wr_addr1  	: std_logic_vector(7 downto 0);
	SIGNAL wr_data1  	: std_logic_vector(11 downto 0);
	SIGNAL rd_addr_10	: std_logic_vector(7 downto 0);
	SIGNAL rd_data_10	: std_logic_vector(11 downto 0);
	SIGNAL rd_addr_11		: std_logic_vector(7 downto 0);
	SIGNAL rd_data_11 		: std_logic_vector(11 downto 0);
	
	SIGNAL wr_en2    	: std_logic;
	SIGNAL wr_addr2  	: std_logic_vector(6 downto 0);
	SIGNAL wr_data2  	: std_logic_vector(11 downto 0);
	SIGNAL rd_addr_20	: std_logic_vector(6 downto 0);
	SIGNAL rd_data_20	: std_logic_vector(11 downto 0);
	SIGNAL rd_addr_21		: std_logic_vector(6 downto 0);
	SIGNAL rd_data_21 		: std_logic_vector(11 downto 0);
	
	SIGNAL wr_en3    	: std_logic;
	SIGNAL wr_addr3  	: std_logic_vector(7 downto 0);
	SIGNAL wr_data3  	: std_logic_vector(11 downto 0);
	SIGNAL rd_addr_30	: std_logic_vector(7 downto 0);
	SIGNAL rd_data_30	: std_logic_vector(11 downto 0);
	SIGNAL rd_addr_31		: std_logic_vector(7 downto 0);
	SIGNAL rd_data_31 		: std_logic_vector(11 downto 0);
	
	
	SIGNAL rd_addr_40	: std_logic_vector(8 downto 0);
	SIGNAL rd_data_40	: std_logic_vector(11 downto 0);
	SIGNAL rd_addr_41		: std_logic_vector(8 downto 0);
	SIGNAL rd_data_41 		: std_logic_vector(11 downto 0);
	
	
	
	signal 	agen			:		std_logic;
	signal 	agnrst			:		std_logic;
	signal 	agdone			:		std_logic;
	signal 	agch			:		std_logic;
	signal 	agbfmod		: 	std_logic_vector(1 DOWNTO 0);
	signal 	agra00		: 	 std_logic_vector(6 DOWNTO 0);
	signal 	agra01		: 	 std_logic_vector(6 DOWNTO 0);
	signal 	agra10		: 	 std_logic_vector(7 DOWNTO 0);
	signal 	agra11		: 	 std_logic_vector(7 DOWNTO 0);
	signal 	agra20		: 	 std_logic_vector(6 DOWNTO 0);
	signal 	agra21		: 	 std_logic_vector(6 DOWNTO 0);
	signal 	agra30		: 	 std_logic_vector(7 DOWNTO 0);
	signal 	agra31		: 	 std_logic_vector(7 DOWNTO 0);	
	signal 	agzeta0		: 	 std_logic_vector(8 DOWNTO 0);	
	signal 	agzeta1		: 	 std_logic_vector(8 DOWNTO 0);	
	signal 	agwa0		: 		 std_logic_vector(6 DOWNTO 0);
	signal 	agwa1		: 		 std_logic_vector(7 DOWNTO 0);
	signal 	agwa2		: 		 std_logic_vector(6 DOWNTO 0);
	signal 	agwa3		: 		 std_logic_vector(7 DOWNTO 0);
	
	signal 	ags		: 		 std_logic_vector(2 DOWNTO 0);
	
	
	
	
	SIGNAL ffwr_en0    		: std_logic;
	SIGNAL ffwr_addr0  		: std_logic_vector(6 downto 0);
	SIGNAL ffwr_data0  		: std_logic_vector(11 downto 0);
	SIGNAL ffrd_addr_00		: std_logic_vector(6 downto 0);
	SIGNAL ffrd_data_00		: std_logic_vector(11 downto 0);
	SIGNAL ffrd_addr_01		: std_logic_vector(6 downto 0);
	SIGNAL ffrd_data_01 	: std_logic_vector(11 downto 0);
	SIGNAL ffwr_en1    		: std_logic;
	SIGNAL ffwr_addr1  		: std_logic_vector(7 downto 0);
	SIGNAL ffwr_data1  		: std_logic_vector(11 downto 0);
	SIGNAL ffrd_addr_10		: std_logic_vector(7 downto 0);
	SIGNAL ffrd_data_10		: std_logic_vector(11 downto 0);
	SIGNAL ffrd_addr_11		: std_logic_vector(7 downto 0);
	SIGNAL ffrd_data_11 	: std_logic_vector(11 downto 0);	
	SIGNAL ffwr_en2    		: std_logic;
	SIGNAL ffwr_addr2  		: std_logic_vector(6 downto 0);
	SIGNAL ffwr_data2  		: std_logic_vector(11 downto 0);
	SIGNAL ffrd_addr_20		: std_logic_vector(6 downto 0);
	SIGNAL ffrd_data_20		: std_logic_vector(11 downto 0);
	SIGNAL ffrd_addr_21		: std_logic_vector(6 downto 0);
	SIGNAL ffrd_data_21 	: std_logic_vector(11 downto 0);
	SIGNAL ffwr_en3    		: std_logic;
	SIGNAL ffwr_addr3  		: std_logic_vector(7 downto 0);
	SIGNAL ffwr_data3  		: std_logic_vector(11 downto 0);
	SIGNAL ffrd_addr_30		: std_logic_vector(7 downto 0);
	SIGNAL ffrd_data_30		: std_logic_vector(11 downto 0);
	SIGNAL ffrd_addr_31		: std_logic_vector(7 downto 0);
	SIGNAL ffrd_data_31 	: std_logic_vector(11 downto 0);
	
	SIGNAL ffzeta0 	: std_logic_vector(11 downto 0);
	SIGNAL ffzeta1 	: std_logic_vector(11 downto 0);
	
	
	SIGNAL mux0out 	: std_logic_vector(11 downto 0);
	SIGNAL mux1out 	: std_logic_vector(11 downto 0);
	SIGNAL mux2out 	: std_logic_vector(11 downto 0);
	SIGNAL mux3out 	: std_logic_vector(11 downto 0);
	SIGNAL mux4out 	: std_logic_vector(11 downto 0);
	SIGNAL mux5out 	: std_logic_vector(11 downto 0);
	
	
	
	SIGNAL selmux0 	: std_logic_vector(1 downto 0);
	SIGNAL selmux1 	: std_logic_vector(1 downto 0);
	SIGNAL selmux2 	: std_logic_vector(1 downto 0);
	SIGNAL selmux3 	: std_logic_vector(1 downto 0);
	SIGNAL selmux4 	: std_logic;
	SIGNAL selmux5 	: std_logic_vector(1 downto 0);
	
	
	SIGNAL agwe0 	: std_logic;
	SIGNAL agwe1 	: std_logic;
	SIGNAL agwe2 	: std_logic;
	SIGNAL agwe3 	: std_logic;
	
	
	SIGNAL conidle 	: std_logic;
	
	
	
	
	
	
	

	

BEGIN


	bfc0		:	bf PORT MAP(clk => clk,  bfmod => m , a => a0  , b => b0 , c => c0 , aout => a0out   , bout => b0out   );
	bfc1		:	bf PORT MAP(clk => clk,  bfmod => m , a => a1  , b => b1 , c => c1 , aout => a1out   , bout => b1out   );

	lutram0   :  	lutram128 PORT MAP(
	
	clk 	  =>   clk,      
	wr_en     =>  wr_en0     ,      
	wr_addr   =>  wr_addr0   ,      
	wr_data   =>  wr_data0   ,      
	rd_addr_a =>  rd_addr_00 ,      
	rd_data_a =>  rd_data_00 ,      
	rd_addr_b =>  rd_addr_01 ,      
	rd_data_b =>  rd_data_01  );       
	
	
	lutram1   :  	lutram192 PORT MAP(
	
	clk 	  =>   clk,      
	wr_en     =>  wr_en1     ,      
	wr_addr   =>  wr_addr1   ,      
	wr_data   =>  wr_data1   ,      
	rd_addr_a =>  rd_addr_10 ,      
	rd_data_a =>  rd_data_10 ,     
	rd_addr_b =>  rd_addr_11 ,      
	rd_data_b =>  rd_data_11  );    
	
	
	
	lutram2   :  	lutram128 PORT MAP(
	
	clk 	  =>   clk,      
	wr_en     =>  wr_en2     ,      
	wr_addr   =>  wr_addr2   ,      
	wr_data   =>  wr_data2   ,      
	rd_addr_a =>  rd_addr_20 ,      
	rd_data_a =>  rd_data_20 ,      
	rd_addr_b =>  rd_addr_21 ,      
	rd_data_b =>  rd_data_21  );    
	
	
	
	lutram3   :  	lutram192 PORT MAP(
	
	clk 	  =>   clk,      
	wr_en     =>  wr_en3     ,      
	wr_addr   =>  wr_addr3   ,      
	wr_data   =>  wr_data3   ,      
	rd_addr_a =>  rd_addr_30 ,      
	rd_data_a =>  rd_data_30 ,      
	rd_addr_b =>  rd_addr_31 ,      
	rd_data_b =>  rd_data_31  );    
	
	
	zetarom	:	lutrom PORT MAP(
	clk			=>  clk ,
	rd_addr_a   =>   rd_addr_40 ,
	rd_data_a   =>   rd_data_40 ,
	rd_addr_b   =>   rd_addr_41 ,
	rd_data_b   =>   rd_data_41 );
	
	
	
	
	
	addreessgeneration	:	ag PORT MAP(
	clk				=> clk	,
	nrst			=> 	   agnrst ,
	en				=> agen	    ,
	mode		   =>  agbfmod	 ,
	ra00		   =>  agra00	 ,
	ra01		   =>  agra01	 ,
	ra10		   =>  agra10	 ,
	ra11		  => 	agra11	,
	ra20		  => 	agra20	,
	ra21		  => 	agra21	,
	ra30		  => 	agra30	,
	ra31		  => 	agra31	,
	zeta0		  => agzeta0	,
	zeta1         => agzeta1	,
	wa0			  => 	agwa0	,
	wa1			  => 	agwa1	,
	wa2			  => 	agwa2	,
	wa3			  => 	agwa3	,
	we0			=> agwe0,
	we1         => agwe1,
	we2         => agwe2,
	we3	        => agwe3,
	ch	=> agch,
	sout => ags,
	done	=> agdone
	
	
	);
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	done <= pdone;
	
	
	
		wr_en0    	<=	ffwr_en0    	;
		wr_addr0  	<=	ffwr_addr0  	;
		wr_data0  	<=	ffwr_data0  	;
		rd_addr_00	<=	ffrd_addr_00	;
		rd_addr_01	<=	ffrd_addr_01	;
		wr_en1    	<=	ffwr_en1    	;
		wr_addr1  	<=	ffwr_addr1  	;
		wr_data1  	<=	ffwr_data1  	;
		rd_addr_10	<=	ffrd_addr_10	;
		rd_addr_11	<=	ffrd_addr_11	;
		wr_en2    	<=	ffwr_en2    	;
		wr_addr2  	<=	ffwr_addr2  	;
		wr_data2  	<=	ffwr_data2  	;
		rd_addr_20	<=	ffrd_addr_20	;
		rd_addr_21	<=	ffrd_addr_21	;
		wr_en3    	<=	ffwr_en3    	;
		wr_addr3  	<=	ffwr_addr3  	;
		wr_data3  	<=	ffwr_data3  	;
		rd_addr_30	<=	ffrd_addr_30	;
		rd_addr_31	<=	ffrd_addr_31	;
	
	
	
	
	
		iodata00	<= 	ffrd_data_00 when cur_st = idle else (others => '0');
		iodata01	<= 	ffrd_data_01 when cur_st = idle else (others => '0');
		iodata10	<= 	ffrd_data_10 when cur_st = idle else (others => '0');
		iodata11	<= 	ffrd_data_11 when cur_st = idle else (others => '0');
		iodata20	<= 	ffrd_data_20 when cur_st = idle else (others => '0');
		iodata21	<= 	ffrd_data_21 when cur_st = idle else (others => '0');
		iodata30	<= 	ffrd_data_30 when cur_st = idle else (others => '0');
		iodata31	<= 	ffrd_data_31 when cur_st = idle else (others => '0');
		
		
		
		
		
		
		
		a0 <= mux0out;
		b0 <= mux1out;
		c0 <= mux2out;
		a1 <= mux3out;
		b1 <= mux4out;
		c1 <= mux5out;
		
	    
	
	
	
	
	
	
PROCESS(clk)
	BEGIN
  
	IF  clk'EVENT AND clk = '1' THEN
				
			IF nrst = '0' THEN
					
				cur_st		<=	idle;
				
				
				agnrst  <='0';
	
			ELSIF nrst='1' THEN
				
				
				cur_st <= nxt_st;
				
				pdone		<=	'0';
				

				
				conidle <= '0';
				
				
				ffrd_data_00 <= rd_data_00 ;
				ffrd_data_01 <= rd_data_01 ;
				ffrd_data_10 <= rd_data_10 ;
				ffrd_data_11 <= rd_data_11 ;
				ffrd_data_20 <= rd_data_20 ;
				ffrd_data_21 <= rd_data_21 ;
				ffrd_data_30 <= rd_data_30 ;
				ffrd_data_31 <= rd_data_31 ;
				
				ffwr_en0 <= '0'; 
				ffwr_en1 <= '0';
				ffwr_en2 <= '0';
				ffwr_en3 <= '0';
				
				
				
				
				ffwr_data0  <= a0out;
				ffwr_data1  <= b0out;
				ffwr_data2  <= a1out;
				ffwr_data3  <= b1out;
				
				
				
				ffwr_addr0  <= agwa0; 	
				ffwr_addr1  <= agwa1;
				ffwr_addr2  <= agwa2;
				ffwr_addr3  <= agwa3;
				
				
				
				ffrd_addr_00 <= agra00 ;
				ffrd_addr_01 <= agra01 ;
				ffrd_addr_10 <= agra10 ;
				ffrd_addr_11 <= agra11 ;
				ffrd_addr_20 <= agra20 ;
				ffrd_addr_21 <= agra21 ;
				ffrd_addr_30 <= agra30 ;
				ffrd_addr_31 <= agra31 ;
				
				
				rd_addr_40 <= agzeta0;
				rd_addr_41 <= agzeta1;
				
				ffzeta0 <= rd_data_40;
				ffzeta1 <= rd_data_41;
				
				
					
					
					
					
					
					
				
				
				
				
				
					case selmux0 is
						when "00"   => mux0out <= ffrd_data_00;
						when "01"   => mux0out <= ffrd_data_20;
						when others => mux0out <= ffrd_data_10;
					end case;
					
					
					case selmux1 is
						when "00"   => mux1out <= ffrd_data_01;
						when "01"   => mux1out <= ffrd_data_21;
						when others => mux1out <= ffrd_data_10;
					end case;
					
					
					
					
					case selmux2 is
						when "00"   => mux2out <= ffzeta0;
						when "01"   => mux2out <= ffrd_data_10;
						when "10" => mux2out <= ffrd_data_30;
						when others => mux2out <= ffrd_data_11;
					end case;
					
				
					
					case selmux3 is
						when "00"   => mux3out <= ffrd_data_10;
						when "01"   => mux3out <= ffrd_data_30;
						when others => mux3out <= ffrd_data_31;
					end case;
					
					
					
					
					
					if selmux4 = '0' then
						mux4out <= ffrd_data_11;
					else
						mux4out <= ffrd_data_31;
					end if;
					
					
					case selmux5 is
						when "00"   => mux5out <= ffzeta1;
						when "01"   => mux5out <= ffrd_data_00;
						when others => mux5out <= ffrd_data_20;
					end case;
					
					
				
				
				
				agen <= '0';
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				IF cur_st = idle THEN
					
					
					conidle <= '1';
					
					selmux0 <= "00";
					selmux1 <= "00";
					selmux2 <= "00";
					selmux3 <= "00";
					selmux4 <= '0';
					selmux5 <= "00";
				
					
					
													
					m(0)	<=	mode(0) and not(mode(1));
					m(1)	<=	mode(1);								
													
													
													
													
													
													
					
					ffwr_en0    	<=   iowe0	  ;
					ffwr_addr0  	<=   iowadd0  ;
					ffwr_data0  	<=   iowdata0 ;
					ffrd_addr_00	<=   ioradd00 ;
					ffrd_addr_01	<= 	 ioradd01 ;
					ffwr_en1    	<= 	iowe1	  ;
					ffwr_addr1  	<=  iowadd1	  ;
					ffwr_data1  	<=  iowdata1  ;
					ffrd_addr_10	<=  ioradd10  ;
					ffrd_addr_11	<= ioradd11   ;
					ffwr_en2    	<= iowe2	  ;
					ffwr_addr2  	<= iowadd2	  ;
					ffwr_data2  	<= iowdata2   ;
					ffrd_addr_20	<= ioradd20   ;
					ffrd_addr_21	<= ioradd21   ;
					ffwr_en3    	<= iowe3	  ;
					ffwr_addr3  	<= iowadd3	  ;
					ffwr_data3  	<= iowdata3   ;
					ffrd_addr_30	<= ioradd30   ;
					ffrd_addr_31	<= ioradd31   ;
					
					
					agbfmod <= m;
					
					agnrst  <='1';
				
				ELSIF cur_st = tontt THEN
						
						
						ffwr_en0 <= agwe0;
						ffwr_en1 <= agwe1;
						ffwr_en2 <= agwe2;
						ffwr_en3 <= agwe3;
						
					

						agen <= '1';
						
						pdone <= agdone;
			
						selmux0(0) <= not selmux0(0);
						selmux1(0) <= not selmux1(0);
						selmux3(0) <= not selmux3(0);
						selmux4 <= not selmux4;
				
			
					
		
				
				ELSIF cur_st = toinvntt THEN
					
						ffwr_en0 <= agwe0;
						ffwr_en1 <= agwe1;
						ffwr_en2 <= agwe2;
						ffwr_en3 <= agwe3;
						
					

						agen <= '1';
						
						pdone <= agdone;
						
						
						if  agch  ='1' THEN
						
							selmux0(0) <= not selmux0(0);
							selmux1(0) <= not selmux1(0);
							selmux3(0) <= not selmux3(0);
							selmux4 <= not selmux4;
				
						end if;
				
				
						
				ELSIF cur_st = topwm THEN
						
						ffwr_en0 <= agwe0;
						ffwr_en1 <= agwe1;
						ffwr_en2 <= agwe2;
						ffwr_en3 <= agwe3;
					
						CASE ags IS 
						
							WHEN "000" =>
							
								selmux1 <= "00";
								selmux2 <= "01";
								
								selmux4 <= '0';
								selmux5 <= "01";
							
							
							WHEN "001" =>
								
								selmux1 <= "01";
								selmux2 <= "10";
								
								selmux4 <= '1';
								selmux5 <= "10";
							
							
							
				        	WHEN "010" =>
								
								
								
								selmux1 <= "10";
								selmux2 <= "00";
								
								selmux4 <= '1';
								selmux5 <= "00";
				        	
				        	
				        	WHEN "011" =>
				        	
								selmux0 <= "10";
								selmux1 <= "00";
								selmux2 <= "11";
								selmux3 <= "01";
								selmux4 <= '1';
							    selmux5 <= "10";
				        	
				        	
				        	
				        	
				        	WHEN Others =>
				        	
								selmux0 <= "10";
								selmux1 <= "01";
								selmux2 <= "10";
								selmux3 <= "10";
								selmux4 <= '0';
								selmux5 <= "01";
								
								
								
				        	
				        END CASE;  
						
						
						agen <= '1';
						
						pdone <= agdone;
						
				
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
	  