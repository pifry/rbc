LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY {entity_name} IS
    PORT (
        rst_a_i     : STD_LOGIC;
        clk_i       : STD_LOGIC;

        CTRL_REG_A : OUT std_logic_vector(0 downto 0);
        CTRL_REG_B : OUT std_logic_vector(0 downto 0);
        CTRL_REG_B_CX : OUT std_logic_vector(0 downto 0);
        CTRL_REG_B_DX : OUT std_logic_vector(0 downto 0);
        TEST_REG0_TB : IN std_logic_vector(2 downto 0);
        TEST_REG0_BX : IN std_logic_vector(1 downto 0);

        avl_addr_i  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        avl_data_b  : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        avl_write_i : IN STD_LOGIC;
        avl_read_i  : IN STD_LOGIC
    );
END ENTITY {entity_name};

ARCHITECTURE rtl OF {entity_name} IS

BEGIN

    avl_read : PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            avl_data_b <= (OTHERS => 'Z');
            ELSIF rising_edge(clk) THEN
            IF avl_read_i = '1' THEN
                CASE (avl_addr_i) IS
                    when 0 =>
                        avl_data_b <= "0" & CTRL_REG_A & "00000" & CTRL_REG_B;
                    when 1 =>
                        avl_data_b <= "00" & CTRL_REG_B_CX & "0000" & CTRL_REG_B_DX;
                    when 2 =>
                        avl_data_b <= "00000000000" & TEST_REG0_BX & TEST_REG0_TB;
                    WHEN OTHERS =>
                        avl_data_b <= (OTHERS => 'Z');
                END CASE;
                ELSE
                avl_data_b <= (OTHERS => 'Z');
            END IF;
        END IF;
    END PROCESS avl_read;

    avl_write : PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            CTRL_REG_A <= (others => '0');
            CTRL_REG_B <= (others => '0');
            CTRL_REG_B_CX <= (others => '0');
            CTRL_REG_B_DX <= (others => '0');
            TEST_REG0_TB <= (others => '0');
            TEST_REG0_BX <= (others => '0');
            ELSIF rising_edge(clk) THEN
            IF avl_write_i = '1' THEN
                CASE (avl_addr_i) IS
                    when 0 =>
                        CTRL_REG_A <= avl_data_b(6 downto 6);
                        CTRL_REG_B <= avl_data_b(0 downto 0);
                    when 1 =>
                        CTRL_REG_B_CX <= avl_data_b(5 downto 5);
                        CTRL_REG_B_DX <= avl_data_b(0 downto 0);
                    when 2 =>
                        TEST_REG0_TB <= avl_data_b(2 downto 0);
                        TEST_REG0_BX <= avl_data_b(4 downto 3);
                    WHEN OTHERS =>
                        NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS avl_write;

END ARCHITECTURE rtl;
