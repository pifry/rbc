LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY test0 IS
    PORT (
        rst_a_i     : STD_LOGIC;
        clk_i       : STD_LOGIC;

        CTRL_REG_A_o : OUT std_logic_vector(0 downto 0);
        CTRL_REG_B_o : OUT std_logic_vector(0 downto 0);
        CTRL_REG_B_CX_o : OUT std_logic_vector(0 downto 0);
        CTRL_REG_B_DX_o : OUT std_logic_vector(0 downto 0);
        TEST_REG0_TB_o : OUT std_logic_vector(2 downto 0);
        TEST_REG0_TB_i : IN std_logic_vector(2 downto 0);
        TEST_REG0_BX_o : OUT std_logic_vector(1 downto 0);
        TEST_REG0_BX_i : IN std_logic_vector(1 downto 0);

        avl_addr_i : IN std_logic_vector(16 downto 0);
        avl_data_b : INOUT std_logic_vector(7 downto 0);
        avl_write_i : IN std_logic;
        avl_read_i : IN std_logic

        -- avl_addr_i  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        -- avl_data_b  : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        -- avl_write_i : IN STD_LOGIC;
        -- avl_read_i  : IN STD_LOGIC
    );
END ENTITY test0;

ARCHITECTURE rtl OF test0 IS

BEGIN

    avl_read : PROCESS (clk_i, rst_a_i)
    BEGIN
        IF rst_a_i = '1' THEN
            avl_data_b <= (OTHERS => 'Z');
            ELSIF rising_edge(clk_i) THEN
            IF avl_read_i = '1' THEN
                CASE (to_integer(unsigned(avl_addr_i))) IS
                    when 0 =>
                        avl_data_b(8 - 1 downto 0) <= "00000000";
                    when 1 =>
                        avl_data_b(8 - 1 downto 0) <= "00000000";
                    when 2 =>
                        avl_data_b(16 - 1 downto 0) <= "00000000000" & TEST_REG0_BX_i & TEST_REG0_TB_i;
                    WHEN OTHERS =>
                        avl_data_b <= (OTHERS => 'Z');
                END CASE;
                ELSE
                avl_data_b <= (OTHERS => 'Z');
            END IF;
        END IF;
    END PROCESS avl_read;

    avl_write : PROCESS (clk_i, rst_a_i)
    BEGIN
        IF rst_a_i = '1' THEN
            CTRL_REG_A_o <= (others => '0');
            CTRL_REG_B_o <= (others => '0');
            CTRL_REG_B_CX_o <= (others => '0');
            CTRL_REG_B_DX_o <= (others => '0');
            TEST_REG0_TB_o <= (others => '0');
            TEST_REG0_BX_o <= (others => '0');
            ELSIF rising_edge(clk_i) THEN
            IF avl_write_i = '1' THEN
                CASE (to_integer(unsigned(avl_addr_i))) IS
                    when 0 =>
                        CTRL_REG_A_o <= avl_data_b(6 downto 6);
                        CTRL_REG_B_o <= avl_data_b(0 downto 0);
                    when 1 =>
                        CTRL_REG_B_CX_o <= avl_data_b(5 downto 5);
                        CTRL_REG_B_DX_o <= avl_data_b(0 downto 0);
                    when 2 =>
                        TEST_REG0_TB_o <= avl_data_b(2 downto 0);
                        TEST_REG0_BX_o <= avl_data_b(4 downto 3);
                    WHEN OTHERS =>
                        NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS avl_write;

END ARCHITECTURE rtl;
