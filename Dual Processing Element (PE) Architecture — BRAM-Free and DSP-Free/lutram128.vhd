library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lutram128 is
    port (
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
end entity lutram128;

architecture rtl of lutram128 is

    type ram_type is array (0 to 127)
        of std_logic_vector(11 downto 0);

    signal ram : ram_type;

    -- Registered inputs
    signal wr_en_reg     : std_logic;
    signal wr_addr_reg   : std_logic_vector(6 downto 0);
    signal wr_data_reg   : std_logic_vector(11 downto 0);
    signal rd_addr_a_reg : std_logic_vector(6 downto 0);
    signal rd_addr_b_reg : std_logic_vector(6 downto 0);

    -- Asynchronous LUTRAM outputs
    signal ram_data_a : std_logic_vector(11 downto 0);
    signal ram_data_b : std_logic_vector(11 downto 0);

    -- Force distributed RAM on Xilinx devices
    attribute ram_style : string;
    attribute ram_style of ram : signal is "distributed";

begin

    ---------------------------------------------------------------------------
    -- Input registers
    ---------------------------------------------------------------------------
    process (clk)
    begin
        if rising_edge(clk) then
            wr_en_reg     <= wr_en;
            wr_addr_reg   <= wr_addr;
            wr_data_reg   <= wr_data;
            rd_addr_a_reg <= rd_addr_a;
            rd_addr_b_reg <= rd_addr_b;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Synchronous LUTRAM write
    ---------------------------------------------------------------------------
    process (clk)
    begin
        if rising_edge(clk) then
            if wr_en_reg = '1' then
                ram(to_integer(unsigned(wr_addr_reg))) <= wr_data_reg;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Two asynchronous LUTRAM reads
    ---------------------------------------------------------------------------
    ram_data_a <= ram(to_integer(unsigned(rd_addr_a_reg)));
    ram_data_b <= ram(to_integer(unsigned(rd_addr_b_reg)));

    ---------------------------------------------------------------------------
    -- Output registers
    ---------------------------------------------------------------------------
    process (clk)
    begin
        if rising_edge(clk) then
            rd_data_a <= ram_data_a;
            rd_data_b <= ram_data_b;
        end if;
    end process;

end architecture rtl;