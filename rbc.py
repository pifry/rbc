import yaml
import io
from io import open
import argparse
import logging
from logging import info


class Protocol:

    class Register:

        class Field:

            READABLE = ('R', 'RW')
            WRITABLE = ('W', 'RW')

            def __init__(self, data, parent) -> None:
                self._data = data
                self.name = self._data['name']
                self.width = self._data['width']
                self.offset = self._data['offset']
                self.direction = self._data['direction']
                self.description = self._data['description']
                if "activation_bit" in self._data:
                    self.activation_bit = self._data['activation_bit']
                else:
                    self.activation_bit = None
                self.parent = parent

            def range(self):
                return "{left} downto {right}".format(
                    left=self.width - 1,
                    right=0)

            def absolute_range(self):
                return "{left} downto {right}".format(
                    left=self.width - 1 + self.offset,
                    right=self.offset)

            def full_name(self) -> str:
                return f'{self.parent}_{self.name}'

            def get_vhdl_type(self):
                return "std_logic" if self.width == 1 else \
                    f"std_logic_vector({self.range()})"

        def __init__(self, description) -> None:
            self.name = description['name']
            self.width = description['width']
            self.__fields_dict__ = description['fields']

        def fields(self):
            return (Protocol.Register.Field(field, self.name) for field in self.__fields_dict__)

    def __init__(self, description) -> None:
        self.__registers_dict__ = description

    def registers(self):
        return (Protocol.Register(register) for register in self.__registers_dict__)

    def required_bus_data_width(self):
        return 16

    def required_bus_address_width(self):
        return 7


class TextDoc:

    def save(self, filename) -> None:
        info(f"Saving into {filename}")
        with open(filename, 'w') as file:
            file.write(str(self))


class Template:
    def __init__(self, template) -> None:
        self.__template__ = template

    def __str__(self) -> str:
        text = self.__template__
        for method_name in (method for method in dir(self) if method.startswith('template_')):
            text = text.replace(
                self.templ_prefix + "{" + method_name[9:] + "}", getattr(self, method_name)())
        return text


class Markdown(TextDoc):
    def __init__(self, protocol) -> None:
        super().__init__()
        self.protocol = protocol

    def get_header(self, register) -> str:
        text = "|bit no."
        for i in range(register.width - 1, -1, -1):
            text += "|"+str(i)
        text += "|\n|:---:" + register.width * "|:---:" + "|\n"
        return text

    def get_direction(self, register) -> str:
        text = "|r/w"
        for i in range(register.width - 1, -1, -1):
            text += "|"
            field_text = "-"
            for field in register.fields():
                if i >= field.offset and i < field.offset + field.width:
                    field_text = field.direction
            text += field_text
        text += "|\n"
        return text

    def get_names(self, register) -> str:
        text = "|Name"
        for i in range(register.width-1, -1, -1):
            text += "|"
            field_text = "N/A"
            for field in register.fields():
                if i >= field.offset and i < field.offset + field.width:
                    if field.width == 1:
                        field_text = field.name
                    else:
                        field_text = field.name + str(i - field.offset)
            text += field_text
        text += "|\n"
        return text

    def get_title(self, register) -> str:
        text = "# " + register.name + '\n'
        return text

    def get_table(self, register) -> str:
        return self.get_header(register) + \
            self.get_direction(register) + \
            self.get_names(register)

    def get_description(self, register) -> str:
        text = ""
        for field in register.fields():
            text += f"- {field.name}[{field.width}:{0}] - {field.description}\n"
        if field.activation_bit:
            text += f"\n*WARNING:* Changes to this register must be applied by writing '1' to the {field.activation_bit} bit.\n"

        return text

    def get_register(self, register):
        return self.get_title(register) + self.get_table(register) + "\n" + self.get_description(register)

    def __str__(self) -> str:
        text = ""
        for register in self.protocol.registers():
            text += self.get_register(register)
        return text


class CHeader(TextDoc, Template):
    def __init__(self, template, protocol, name) -> None:
        Template.__init__(self, template)
        TextDoc.__init__(self)

        self.templ_prefix = "// "
        self.protocol = protocol
        self.name = name.upper()

    def template_name(self):
        return self.name

    def template_definitions(self) -> str:
        text = ""
        for i, register in enumerate(self.protocol.registers()):
            text += f'#define {register.name} {i}\n'
            for field in register.fields():
                text += f'#define {field.full_name()}_OFFSET {field.offset}\n'
        return text[:-1]


class VHDL(TextDoc, Template):

    def __init__(self, template, protocol, name) -> None:
        Template.__init__(self, template)
        TextDoc.__init__(self)

        self.templ_prefix = "-- "
        self.protocol = protocol
        self.name = name

    def template_bus_port(self):
        text = ""
        text += 8*" " + f'avl_addr_i : IN std_logic_vector({self.protocol.required_bus_data_width()} downto 0);\n'
        text += 8*" " + f'avl_data_i : INOUT std_logic_vector({self.protocol.required_bus_address_width()} downto 0);\n'
        text += 8*" " + f'avl_write_i : IN std_logic;\n'
        text += 8*" " + f'avl_read_i : IN std_logic\n'
        return text

    def template_port_declaration(self):
        text = ""
        for register in self.protocol.registers():
            for field in register.fields():

                if field.direction in field.WRITABLE :
                    text += 8*" " + \
                        f'{field.full_name()}_o : OUT std_logic_vector({field.range()});\n'

                if field.direction in field.READABLE:
                    text += 8*" " + \
                            f'{field.full_name()}_i : IN std_logic_vector({field.range()});\n'
        return text[:-1]

    def template_write_process(self) -> str:
        text = ""
        address = 0
        for register in self.protocol.registers():
            text += 20*" " + f'when {address} =>\n'
            for field in register.fields():
                if field.direction in field.WRITABLE:
                    text += 24 * " " + \
                        f"{field.full_name()}_o <= avl_data_b({field.absolute_range()});\n"
            address += 1
        return text[:-1]

    def template_default_values(self) -> str:
        text = ""
        for register in self.protocol.registers():
            for field in register.fields():
                if field.direction in field.WRITABLE:
                    text += 12*" " + f"{field.full_name()}_o <= (others => '0');\n"
        return text[:-1]

    def template_read_process(self) -> str:
        text = ""
        address = 0
        for register in self.protocol.registers():
            text += 20*" " + f'when {address} =>\n'
            text += 24*" " + f"avl_data_b({register.width} - 1 downto 0) <= "
            equation_text = ""
            zeros = ""
            i = register.width - 1
            while i >= 0:
                try:
                    field = next(field for field in register.fields()
                                 if field.offset + field.width - 1 == i and field.direction in field.READABLE)
                except StopIteration:
                    field = None
                if field:
                    i -= field.width
                    if zeros != "":
                        equation_text += f'"{zeros}" & {field.full_name()}_i'
                        zeros = ""
                    else:
                        equation_text += f'{field.full_name()}_i'
                    if i >= 0:
                        equation_text += " & "
                else:
                    zeros += "0"
                    i -= 1
            if zeros != "":
                equation_text += f'"{zeros}"'
            text += equation_text + ";\n"
            address += 1
        return text[:-1]

    def __str__(self) -> str:
        return super().__str__().replace('entity_name', self.name)


if __name__ == "__main__":

    # TODO: if verbose
    logging.basicConfig(level=logging.INFO)

    with io.open('test/test0.yml', 'r') as file:
        yaml_protocol = Protocol(yaml.safe_load(file))

    with io.open('templates/template.vhd', 'r') as file:
        vhdl_template = file.read()

    with io.open('templates/template.h', 'r') as file:
        h_template = file.read()

    vhdl = VHDL(vhdl_template, yaml_protocol, 'test0')
    vhdl.save('test/test0.vhd')

    c_header = CHeader(h_template, yaml_protocol, 'test0')
    c_header.save('test/test0.h')

    mkdw = Markdown(yaml_protocol)
    mkdw.save('test/test0.md')
