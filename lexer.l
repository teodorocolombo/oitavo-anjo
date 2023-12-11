%{
#include <stdio.h>
#include "parser.tab.h"
%}

%option noyywrap


%%
[^ \n]{7}"/"[^ \n]* { return DIV; }
[^ \n]{7}"*"[^ \n]* { return MULT; }
[^ \n]{7}"+"[^ \n]* { return PLUS; }
[^ \n]{7}"-"[^ \n]* { return MINUS; }
[^ \n]{7}"("[^ \n]* { return LPAR; }
[^ \n]{7}")"[^ \n]* { return RPAR; }
[^ \n]{7}"{"[^ \n]* { return LCHAV; }
[^ \n]{7}"}"[^ \n]* { return RCHAV; }
[^ \n]{7}";"[^ \n]* { return PEV; }
[^ \n]{7}"M"[^ \n]* { return MOD; }

[^ \n]{7}"=="[^ \n]* { return EQ; }
[^ \n]{7}"="[^ \n]* { return ATRIB; }
[^ \n]{7}"!="[^ \n]* { return NEQ;}
[^ \n]{7}">="[^ \n]* { return GTE; }
[^ \n]{7}"<="[^ \n]* { return LTE; }
[^ \n]{7}">"[^ \n]* { return GT; }
[^ \n]{7}"<"[^ \n]* { return LT; }

[^ \n]{7}"v"[^ \n]* { return VAR; }

[^ \n]{7}"i"[^ \n]* { return IF; }
[^ \n]{7}"e"[^ \n]* { return ELSE; }
[^ \n]{7}"w"[^ \n]* { return WHILE; }
[^ \n]{7}"p"[^ \n]* { return PRINT; }
[^ \n]{7}"r"[^ \n]* { return READ; }

[^ \n]{7}[0-9]+[^ \n]* {
    yylval.int_val = atoi(yytext + 7); // Skip first seven characters
    return NUM;
}
[^ \n]{7}[^ \n]* {
    yylval.str_val = strdup(yytext + 7); // Skip first seven characters
    return ID;
}

" " {}
"\n" {}
%%
