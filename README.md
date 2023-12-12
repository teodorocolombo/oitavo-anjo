# oitavo-anjo
Oitavo anjo do apocalipse, tenebroso como um eclipse

Esta linguagem é uma linguagem de programação imperativa e estruturada, similar em sintaxe à linguagem C. Ela é projetada com uma regra lexical única onde somente o oitavo caractere de qualquer sequência de caracteres é considerado relevante. Qualquer outro caractere antes ou após é desconsiderado (com exceção de numerais e variáveis).


Exemplos (X representa qualquer caractere):
```
XXXXXXX1000XXXXXX representa o número 1000.
XXXXXXXvXXXX representa a palavra-chave var (declaração de variável).
XXXXXXX;X representa o ponto e vírgula (;).
XXXXXXX) representa o fechamento de parênteses ()).
XXXXXXXteo representa a variável de valor teo.
```

Exemplo de programa contador de 1 até 100:
```
dokspacv aksicalteo ajsucor= idjsoai1 hsjrieo;
ajshcisw ksidocs( aksicalteo akj+>--<= skjsjdi100 ajanhu0) jskdioc{
    kjsortup aksicalteo jshduio;
    aksicalteo oskirht= aksicalteo jsoiw5c+ shcjdit1 sjaospd;
    aksicod}
```
Agora o código com os tokens destacados:


dokspac**v** aksical**teo** ajsucor**=** idjsoai**1** hsjrieo **;**
ajshcis**w** ksidocs **(** aksical**teo** akj+>--**<=** skjsjdi**100** ajanhu0 **)** jskdioc **{**
    kjsortu**p** aksical**teo** jshduio **;**
    aksical**teo** oskirht **=** aksical**teo** jsoiw5c **+** shcjdit**1** sjaospd **;**
    aksicod **}**

### Tokens
| Token | Produção no oitavo dígito (Padrão) | Descrição                 |
|-------|------------------------------------|---------------------------|
| DIV   | `/`                                | Divisão `/`               |
| MULT  | `*`                                | Multiplicação `*`         |
| PLUS  | `+`                                | Adição `+`                |
| MINUS | `-`                                | Subtração `-`             |
| LPAR  | `(`                                | Parêntese esquerdo `(`    |
| RPAR  | `)`                                | Parêntese direito `)`     |
| LCHAV | `{`                                | Chave esquerda `{`        |
| RCHAV | `}`                                | Chave direita `}`         |
| PEV   | `;`                                | Ponto e vírgula `;`       |
| MOD   | `M`                                | Módulo `M`                |
| EQ    | `==`                               | Igualdade `==`            |
| ATRIB | `=`                                | Atribuição `=`            |
| NEQ   | `!=`                               | Desigualdade `!=`         |
| GTE   | `>=`                               | Maior ou igual `>=`       |
| LTE   | `<=`                               | Menor ou igual `<=`       |
| GT    | `>`                                | Maior que `>`             |
| LT    | `<`                                | Menor que `<`             |
| VAR   | `v`                                | Declaração de variável    |
| IF    | `i`                                | Condicional `if`          |
| ELSE  | `e`                                | Condicional `else`        |
| WHILE | `w`                                | Loop `while`              |
| PRINT | `p`                                | Comando de impressão      |
| READ  | `r`                                | Comando de leitura        |





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
