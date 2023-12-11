%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    typedef struct {
        int startLabel;
        int endLabel;
    } Label;

    Label labelStack[1000];
    int labelStackTop = -1;

    void pushLabel(int start, int end) {
        labelStackTop++;
        labelStack[labelStackTop].startLabel = start;
        labelStack[labelStackTop].endLabel = end;
    }

    Label popLabel() {
        if (labelStackTop < 0) {
            fprintf(stderr, "Error: No labels to pop from the stack.\n");
            exit(EXIT_FAILURE);
        }

        Label label = labelStack[labelStackTop];
        labelStackTop--;
        return label;
    }


    int labelCounter = 0;

    typedef struct {
        char *identifier;
        int address;
    } Symbol;

    Symbol symbolTable[1000];
    int numSymbols = 0;

    int createNewLabel() {
        return labelCounter++;
    }

    int getAddress(char *identifier) {
        for (int i = 0; i < numSymbols; i++) {
            if (!strcmp(symbolTable[i].identifier, identifier))
                return symbolTable[i].address;
        }
        return -1; // Not found
    }

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
%left PLUS MINUS
%left MULT DIV

%%

program:
    | program statement
    ;

statement:
    VAR ID ATRIB expression PEV {
        printf("ATR %%%d\n", numSymbols);
        symbolTable[numSymbols].identifier = strdup($2);
        symbolTable[numSymbols].address = numSymbols;
        numSymbols++;
    }
    | READ ID PEV {
        printf("LEIA\n");
        printf("ATR %%%d\n", getAddress($2));
    }
    | PRINT expression PEV {
        printf("IMPR\n");
    }
    | WHILE {
        int startLabel = createNewLabel();
        int endLabel = createNewLabel();
        pushLabel(startLabel, endLabel);
        printf("R%02d: NADA\n", startLabel);
    } LPAR condition {
        Label currentLabel = labelStack[labelStackTop];
        printf("GFALSE R%02d\n", currentLabel.endLabel);
    } RPAR statement {
        Label currentLabel = popLabel();
        printf("GOTO R%02d\n", currentLabel.startLabel);
        printf("R%02d: NADA\n", currentLabel.endLabel);
        
    }
    
    | LCHAV program RCHAV { /* Code block */ }
    | ID ATRIB expression PEV {
        printf("ATR %%%d\n", getAddress($1));
    }
    | ifs
    ;

/* ifStatement:
    IF LPAR condition RPAR {
        int label = createNewLabel();
        pushLabel(label, label);
        printf("GFALSE R%02d\n", label);
    } LCHAV program RCHAV {
        Label currentLabel = labelStack[labelStackTop];
        printf("R%02d: NADA\n", currentLabel.endLabel);
        popLabel();
    }
    | IF LPAR condition RPAR {
        int startLabel = createNewLabel();
        int endLabel = createNewLabel();
        pushLabel(startLabel, endLabel);
        printf("GFALSE R%02d\n", startLabel);
    }
    LCHAV program RCHAV {
        Label currentLabel = labelStack[labelStackTop];
        printf("GOTO R%02d\n", currentLabel.endLabel);
    }
     ELSE {
        Label currentLabel = labelStack[labelStackTop];
        printf("R%02d: NADA\n", currentLabel.startLabel);
     }
     LCHAV program RCHAV {
        Label currentLabel = labelStack[labelStackTop];
        printf("R%02d: NADA\n", currentLabel.endLabel);
        popLabel();
    }
    ; */

ifs:
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
    else
    ;

else:
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
    extern int yylineno;
    fprintf(stderr, "Error at line %d: %s\n", yylineno, s);
}

