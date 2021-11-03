LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY test0 IS
    PORT (
        rst_a_i : in STD_LOGIC;
        clk_i   : in STD_LOGIC;

        CTRL_REG_A_o : OUT std_logic_vector(0 downto 0);
        CTRL_REG_B_o : OUT std_logic_vector(0 downto 0);
        CTRL_REG_B_CX_o : OUT std_logic_vector(0 downto 0);
        CTRL_REG_B_DX_o : OUT std_logic_vector(0 downto 0);
        CTRL_REG_C_read_o : OUT std_logic;
        CTRL_REG_C_EX_o : OUT std_logic_vector(0 downto 0);
        CTRL_REG_C_FX_o : OUT std_logic_vector(0 downto 0);
        TEST_REG0_TB_o : OUT std_logic_vector(2 downto 0);
        TEST_REG0_TB_i : IN std_logic_vector(2 downto 0);
        TEST_REG0_BX_o : OUT std_logic_vector(1 downto 0);
        TEST_REG0_BX_i : IN std_logic_vector(1 downto 0);

        avl_address_i : IN std_logic_vector(8 - 1 downto 0);
        avl_writedata_i : IN std_logic_vector(16 - 1 downto 0);
        avl_readdata_o : OUT std_logic_vector(16 - 1 downto 0);
        avl_readdatavalid_o : OUT std_logic;
        avl_write_i : IN std_logic;
        avl_read_i : IN std_logic

    );
END ENTITY test0;

ARCHITECTURE rtl OF test0 IS

BEGIN

    avl_read : PROCESS (clk_i, rst_a_i)
    BEGIN
        IF rst_a_i = '1' THEN
            avl_readdata_o <= (OTHERS => '0');
        ELSIF rising_edge(clk_i) THEN
            IF avl_read_i = '1' THEN
                avl_readdatavalid_o <= '1';
                CASE (to_integer(unsigned(avl_address_i))) IS
                    when 0 =>
                        avl_readdata_o(8 - 1 downto 0) <= "00000000";
                    when 1 =>
                        avl_readdata_o(8 - 1 downto 0) <= "00000000";
                    when 2 =>
                        avl_readdata_o(8 - 1 downto 0) <= "00000000";
                    when 3 =>
                        avl_readdata_o(16 - 1 downto 0) <= "00000000000" & TEST_REG0_BX_i & TEST_REG0_TB_i;
                    WHEN OTHERS =>
                        avl_readdata_o <= (OTHERS => '0');
                END CASE;
            ELSE
                avl_readdata_o <= (OTHERS => '0');
                avl_readdatavalid_o <= '0';
            END IF;
        END IF;
    END PROCESS avl_read;

    read_ind: process(clk_i, rst_a_i)
        procedure reset is
        begin 
            CTRL_REG_C_read_o <= '0';            
        end procedure reset;
    begin
        if rst_a_i = '1' then
            reset;
        elsif rising_edge(clk_i) then
            IF avl_read_i = '1' THEN
                CASE (to_integer(unsigned(avl_address_i))) IS
                    when 2 =>
                        CTRL_REG_C_read_o <= '1';
                    WHEN OTHERS =>
                        reset;
                END CASE;
            ELSE
                reset;
            END IF;
        end if;
    end process read_ind;

    avl_write : PROCESS (clk_i, rst_a_i)
    BEGIN
        IF rst_a_i = '1' THEN
            CTRL_REG_A_o <= (others => '0');
            CTRL_REG_B_o <= (others => '0');
            CTRL_REG_B_CX_o <= (others => '0');
            CTRL_REG_B_DX_o <= (others => '0');
            CTRL_REG_C_EX_o <= (others => '0');
            CTRL_REG_C_FX_o <= (others => '0');
            TEST_REG0_TB_o <= (others => '0');
            TEST_REG0_BX_o <= (others => '0');
        ELSIF rising_edge(clk_i) THEN
            IF avl_write_i = '1' THEN
                CASE (to_integer(unsigned(avl_address_i))) IS
                    when 0 =>
                        CTRL_REG_A_o <= avl_writedata_i(6 downto 6);
                        CTRL_REG_B_o <= avl_writedata_i(0 downto 0);
                    when 1 =>
                        CTRL_REG_B_CX_o <= avl_writedata_i(5 downto 5);
                        CTRL_REG_B_DX_o <= avl_writedata_i(0 downto 0);
                    when 2 =>
                        CTRL_REG_C_EX_o <= avl_writedata_i(2 downto 2);
                        CTRL_REG_C_FX_o <= avl_writedata_i(3 downto 3);
                    when 3 =>
                        TEST_REG0_TB_o <= avl_writedata_i(2 downto 0);
                        TEST_REG0_BX_o <= avl_writedata_i(4 downto 3);
                    WHEN OTHERS =>
                        NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS avl_write;

END ARCHITECTURE rtl;
