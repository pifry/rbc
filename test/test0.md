# CTRL_REG
|bit no.|7|6|5|4|3|2|1|0|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|r/w|-|W|-|-|-|-|-|W|
|Name|N/A|A|N/A|N/A|N/A|N/A|N/A|B|

- A[1:0] - Apply TEST_REG0 changes
- B[1:0] - Apply TEST_REG0 changes
# CTRL_REG_B
|bit no.|7|6|5|4|3|2|1|0|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|r/w|-|-|W|-|-|-|-|W|
|Name|N/A|N/A|CX|N/A|N/A|N/A|N/A|DX|

- CX[1:0] - CX description
- DX[1:0] - DX description
# TEST_REG0
|bit no.|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|r/w|-|-|-|-|-|-|-|-|-|-|-|RW|RW|RW|RW|RW|
|Name|N/A|N/A|N/A|N/A|N/A|N/A|N/A|N/A|N/A|N/A|N/A|BX1|BX0|TB2|TB1|TB0|

- TB[3:0] - test bits
- BX[2:0] - another test bits
