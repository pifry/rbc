LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY entity_name IS
    PORT (
        rst_a_i : in STD_LOGIC;
        clk_i   : in STD_LOGIC;

-- {port_declaration}

-- {bus_port}
    );
END ENTITY entity_name;

ARCHITECTURE rtl OF entity_name IS

BEGIN

    avl_read : PROCESS (clk_i, rst_a_i)
    BEGIN
        IF rst_a_i = '1' THEN
            avl_readdata_o <= (OTHERS => '0');
        ELSIF rising_edge(clk_i) THEN
            IF avl_read_i = '1' THEN
                avl_readdatavalid_o <= '1';
                CASE (to_integer(unsigned(avl_address_i))) IS
-- {read_process}
                    WHEN OTHERS =>
                        avl_readdata_o <= (OTHERS => '0');
                END CASE;
            ELSE
                avl_readdata_o <= (OTHERS => '0');
                avl_readdatavalid_o <= '0';
            END IF;
        END IF;
    END PROCESS avl_read;

    avl_write : PROCESS (clk_i, rst_a_i)
    BEGIN
        IF rst_a_i = '1' THEN
-- {default_values}
        ELSIF rising_edge(clk_i) THEN
            IF avl_write_i = '1' THEN
                CASE (to_integer(unsigned(avl_address_i))) IS
-- {write_process}
                    WHEN OTHERS =>
                        NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS avl_write;

END ARCHITECTURE rtl;
