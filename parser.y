%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
	
    // struct para labels
    typedef struct {
        int startLabel;
        int endLabel;
    } Label;

    // pilha de labels (max 1000)
    Label labelStack[1000];
    int labelStackTop = -1;

    // inserir label na pilha de labels
    void pushLabel(int start, int end) {
        labelStackTop++;
        labelStack[labelStackTop].startLabel = start;
        labelStack[labelStackTop].endLabel = end;
    }

    // remover label do topo
    Label popLabel() {
        // pop em stack vazia
        if (labelStackTop < 0) {
            printf("ERROR\n");
            exit(EXIT_FAILURE);
        }

        Label label = labelStack[labelStackTop];
        labelStackTop--;
        return label;
    }


    int labelCounter = 0;

    // struct para simbolos/tokens
    typedef struct {
        char *identifier;
        int address;
    } Symbol;

    // pilha de tokens
    Symbol symbolTable[1000];
    int numSymbols = 0;

    int createNewLabel() {
        return labelCounter++;
    }

    // procurar endereço de determinado ID
    int getAddress(char *identifier) {
        for (int i = 0; i < numSymbols; i++) {
            if (!strcmp(symbolTable[i].identifier, identifier))
                return symbolTable[i].address;
        }
        return -1;
    }

    // liberar espaco de memoria
    void freeSymbolTable() {
        for (int i = 0; i < numSymbols; i++) {
            free(symbolTable[i].identifier);
        }
    }

%}

%union {
    char *str_val;
    int int_val;
}

%token VAR PRINT READ IF ELSE WHILE
%token PLUS MINUS MULT DIV EQ NEQ GT LT GTE LTE MOD
%token LPAR RPAR LCHAV RCHAV ATRIB PEV
%token <int_val> NUM
%token <str_val> ID
// faz o token ser associado a esquerda
%left PLUS MINUS
%left MULT DIV

%%

program:
    | program statement
    ;

statement:
    // atribuicao
    VAR ID ATRIB expression PEV {
        printf("ATR %%%d\n", numSymbols);
        symbolTable[numSymbols].identifier = strdup($2);
        symbolTable[numSymbols].address = numSymbols;
        numSymbols++;
    }
    // leitura
    | READ ID PEV {
        printf("LEIA\n");
        printf("ATR %%%d\n", getAddress($2));
    }
    // print
    | PRINT expression PEV {
        printf("IMPR\n");
    }
    // laco
    | WHILE {
        // inicia as labels para inicio e fim do while
        int startLabel = createNewLabel();
        int endLabel = createNewLabel();
        // adiciona na pilha de labels
        pushLabel(startLabel, endLabel);
        printf("R%02d: NADA\n", startLabel);
    } LPAR condition {
        // pega o label do topo da pilha e direciona para o seu fim
        Label currentLabel = labelStack[labelStackTop];
        printf("GFALSE R%02d\n", currentLabel.endLabel);
    } RPAR statement {
        // tira elemento do topo da pilha 
        Label currentLabel = popLabel();
        printf("GOTO R%02d\n", currentLabel.startLabel);
        printf("R%02d: NADA\n", currentLabel.endLabel);
        
    }
    
    | LCHAV program RCHAV {}
    | ID ATRIB expression PEV {
        printf("ATR %%%d\n", getAddress($1));
    }
    | ifStatement
    ;

ifStatement:
    IF LPAR condition RPAR {
            int startLabel = createNewLabel();
            int endLabel = createNewLabel();
            pushLabel(startLabel, endLabel);
            printf("GFALSE R%02d\n", startLabel);
    }
    LCHAV program RCHAV {
        Label currentLabel = labelStack[labelStackTop];
        printf("GOTO R%02d\n", currentLabel.endLabel);
    }
    elseStatement
    ;

elseStatement:
    {
        Label currentLabel = popLabel();
        printf("R%02d: NADA\n", currentLabel.startLabel);
        printf("R%02d: NADA\n", currentLabel.endLabel);
        
    }
    | ELSE {
        Label currentLabel = labelStack[labelStackTop];
        printf("R%02d: NADA\n", currentLabel.startLabel);
     }
     LCHAV program RCHAV {
        Label currentLabel = popLabel();
        printf("R%02d: NADA\n", currentLabel.endLabel);
        
    }
    ;

condition:
    expression EQ expression { 
        printf("IGUAL \n");
    }
    | expression NEQ expression{ 
        printf("DIFER \n");
    }
    | expression GT expression { 
        printf("MAIOR \n");
    }
    | expression LT expression { 
        printf("MENOR \n");
    }
    | expression GTE expression{ 
        printf("MAIOREQ \n");
    }
    | expression LTE expression{ 
        printf("MENOREQ \n");
    }
    ;

expression:
    expression PLUS expression {
        printf("SOMA \n");
    }
    | expression MINUS expression {
        printf("SUB \n");
    }
    | term
    ;

term:
    term MULT factor {
        printf("MULT \n");
    }
    | term DIV factor { 
        printf("DIV \n");
    }
    | term MOD factor {
        printf("MOD \n");
    }
    | factor
    ;

factor:
    NUM {
        printf("PUSH %d\n", $1);
    }
    | ID {
        printf("PUSH %%%d\n", getAddress($1));
    }
    | LPAR expression RPAR {}
    ;


%%

extern FILE *yyin;

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1], "r"); 
    yyparse();
    printf("SAIR\n");
    fclose(yyin);   
    freeSymbolTable();
    return 0;

}

void yyerror(char *s) {
    printf("ERROR\n");
}

