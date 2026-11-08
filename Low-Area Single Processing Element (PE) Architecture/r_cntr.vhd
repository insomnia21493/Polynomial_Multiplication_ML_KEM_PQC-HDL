library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity r_cntr is
  Port (
    clk : in  STD_LOGIC;
    en  : in  STD_LOGIC;
    rst : in  STD_LOGIC;
    Q   : out STD_LOGIC_VECTOR(6 downto 0)
  );
end r_cntr;

architecture rtl of r_cntr is
  signal state : unsigned(6 downto 0);
  signal sat   : std_logic;  -- '1' when state is 127
begin

  sat <= '1' when state = "1111111" else '0';  -- 127 detect

  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        state <= (others => '0');
      elsif (en = '1') and (sat = '0') then
        state <= state + 1;
      end if; -- else: hold (including when saturated)
    end if;
  end process;

  Q <= std_logic_vector(state);

end rtl;
