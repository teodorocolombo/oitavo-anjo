# oitavo-anjo
Oitavo anjo do apocalipse, tenebroso como um eclipse

### ***BNF:***

``````
<program> -> //empty | <program> <statement>

<statement> -> VAR ID ATRIB <expression> PEV
               | READ ID PEV
               | PRINT <expression> PEV
               | WHILE LPAR <condition> RPAR <statement>
               | LCHAV <program> RCHAV
               | ID ATRIB <expression> PEV
               | <if-statement>

<if-statement> -> IF LPAR <condition> RPAR LCHAV <program> RCHAV <else-statement>

<else-statement> -> //empty | ELSE LCHAV <program> RCHAV

<condition> -> <expression> EQ <expression>
               | <expression> NEQ <expression>
               | <expression> GT <expression>
               | <expression> LT <expression>
               | <expression> GTE <expression>
               | <expression> LTE <expression>

<expression> -> <expression> PLUS <expression>
                | <expression> MINUS <expression>
                | <term>

<term> -> <term> MULT <factor>
          | <term> DIV <factor>
          | <term> MOD <factor>
          | <factor>

<factor> -> NUM | ID | LPAR <expression> RPAR
