LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;
CONTEXT vunit_lib.vc_context;

ENTITY th_test0 IS
    PORT (
        rst_a_i : IN STD_LOGIC;

        CTRL_REG_A_o : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        CTRL_REG_B_o : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        CTRL_REG_B_CX_o : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        CTRL_REG_B_DX_o : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        TEST_REG0_TB_o : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        TEST_REG0_TB_i : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        TEST_REG0_BX_o : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        TEST_REG0_BX_i : IN STD_LOGIC_VECTOR(1 DOWNTO 0)

    );
END th_test0;

ARCHITECTURE rtl OF th_test0 IS

    CONSTANT avalon_master  : bus_master_t := new_bus(
        data_length => 32,
        address_length => 32,
        logger => get_logger("avl_bus"));

    signal clk : std_logic;

    signal avl_addr  : std_logic_vector(16 downto 0);
    signal avl_data  : std_logic_vector(7 downto 0);
    signal avl_write : std_logic;
    signal avl_read  : std_logic;

BEGIN

    dut: entity work.test0
    port map(
        rst_a_i     => rst
        clk_i       => clk

        CTRL_REG_A_o =>
        CTRL_REG_B_o =>
        CTRL_REG_B_CX_o =>
        CTRL_REG_B_DX_o =>
        TEST_REG0_TB_o => 
        TEST_REG0_TB_i => 
        TEST_REG0_BX_o => 
        TEST_REG0_BX_i => 

        avl_addr_i  => avl_addr,
        avl_data_b  => avl_data,
        avl_write_i => avl_write,
        avl_read_i  => avl_read
    );

    avl_master_inst: entity work.avalon_master
    generic map(
        bus_handle => avalon_master
    )
    port map(
        clk => clk,
        address       => avl_addr,
        byteenable    =>
        burstcount    =>
        waitrequest   =>
        write         => avl_write,
        writedata     =>
        read          => avl_read,
        readdata      =>
        readdatavalid =>
    );

END ARCHITECTURE;