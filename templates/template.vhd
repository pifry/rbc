LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY entity_name IS
    PORT (
        rst_a_i     : STD_LOGIC;
        clk_i       : STD_LOGIC;

-- {port_declaration}

        avl_addr_i  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        avl_data_b  : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        avl_write_i : IN STD_LOGIC;
        avl_read_i  : IN STD_LOGIC
    );
END ENTITY entity_name;

ARCHITECTURE rtl OF entity_name IS

BEGIN

    avl_read : PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            avl_data_b <= (OTHERS => 'Z');
            ELSIF rising_edge(clk) THEN
            IF avl_read_i = '1' THEN
                CASE (avl_addr_i) IS
-- {read_process}
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
-- {default_values}
            ELSIF rising_edge(clk) THEN
            IF avl_write_i = '1' THEN
                CASE (avl_addr_i) IS
-- {write_process}
                    WHEN OTHERS =>
                        NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS avl_write;

END ARCHITECTURE rtl;
