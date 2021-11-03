# CTRL_REG: 0x00
|bit no.|7|6|5|4|3|2|1|0|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|r/w|-|W|-|-|-|-|-|W|
|Name|N/A|A|N/A|N/A|N/A|N/A|N/A|B|

- A[0:0] - Apply TEST_REG0 changes
- B[0:0] - Apply TEST_REG0 changes
# CTRL_REG_B: 0x01
|bit no.|7|6|5|4|3|2|1|0|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|r/w|-|-|W|-|-|-|-|W|
|Name|N/A|N/A|CX|N/A|N/A|N/A|N/A|DX|

- CX[0:0] - CX description
- DX[0:0] - DX description
# CTRL_REG_C: 0x02
|bit no.|7|6|5|4|3|2|1|0|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|r/w|-|-|-|-|W|W|-|-|
|Name|N/A|N/A|N/A|N/A|FX|EX|N/A|N/A|

- EX[0:0] - EX description
- FX[0:0] - FX description
# TEST_REG0: 0x03
|bit no.|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|r/w|-|-|-|-|-|-|-|-|-|-|-|RW|RW|RW|RW|RW|
|Name|N/A|N/A|N/A|N/A|N/A|N/A|N/A|N/A|N/A|N/A|N/A|BX1|BX0|TB2|TB1|TB0|

- TB[2:0] - test bits
- BX[1:0] - another test bits
