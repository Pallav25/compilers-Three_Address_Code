%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_TEMP 10

int reg_count = 2;
int mem_count = 0;  


%}

%code requires{
    #include"intcodegen.h"
}
%union {
    
    char *strVal;
    int intVal;
    argtype ar;
}

%token <strVal> ID
%token <intVal> NUM
%token SET ADD SUB MUL DIV MOD EXPO LPAREN RPAREN 

%type <strVal> EXPR OP STMT SETSTMT EXPRSTMT PROGRAM
%type <ar> ARG
%%

PROGRAM: STMT PROGRAM
       | STMT
       ;

STMT: SETSTMT
    | EXPRSTMT
    ;

SETSTMT: LPAREN SET ID NUM RPAREN {
            int pos = lookup($3);
            if(pos == -1){
                pos = mem_count++;
                insert($3, pos);
            }
            printf("MEM[%d] = %d;\n", pos, $4);
            printf("mprn(MEM, %d);\n", pos);
        }
       | LPAREN SET ID ID RPAREN{
            int pos = lookup($3);
            if(pos == -1){
                pos = mem_count++;
                insert($3, pos);
            }
            int pos2 = lookup($4);
            if(pos2 == -1){
                printf("Variable %s not found", $4);
            }
            //no direct interaction from MEM to MEM
            printf("R[0] = MEM[%d];\n", pos2);
            printf("MEM[%d] = R[0];\n", pos);
            printf("mprn(MEM, %d);\n", pos);
       }
       | LPAREN SET ID EXPR RPAREN{
            int pos = lookup($3);
            if(pos == -1){
                pos = mem_count++;
                insert($3, pos);
            }
            printf("MEM[%d] = %s;\n", pos, $4);
            printf("mprn(MEM, %d);\n", pos);
            reg_count--;
       }
       ;

EXPRSTMT: EXPR{
            printf("eprn(R, %d);\n", --reg_count);
        }
        ;

EXPR: LPAREN OP ARG ARG RPAREN {
    if(($3).type == TYPEID && ($4).type == TYPEID) { // Both are IDs
        int pos = lookup(($3).val.sval);
        int pos2 = lookup(($4).val.sval);
        if(pos == -1) {
            printf("Variable %s not found", ($3).val.sval);
        }
        if(pos2 == -1) {
            printf("Variable %s not found", ($4).val.sval);
        }
        printf("R[0] = MEM[%d];\n", pos);
        printf("R[1] = MEM[%d];\n", pos2);
        if(strcmp($2, "**") != 0) 
            printf("R[%d] = R[0] %s R[1];\n", reg_count++, $2);
        else 
            printf("R[%d] = pwr(R[0], R[1]);\n", reg_count++);
        char *result = (char *)malloc(10);
        sprintf(result, "R[%d]", reg_count - 1);
        $$ = result;
    } else if(($3).type == TYPEID) { // First is ID
        int pos = lookup(($3).val.sval);
        if(pos == -1) {
            printf("Variable %s not found", ($3).val.sval);
        }
        printf("R[0] = MEM[%d];\n", pos);
        if(($4).type == TYPENUM) { // Second is NUM
            if(strcmp($2, "**") != 0) 
                printf("R[%d] = R[0] %s %d;\n", reg_count++, $2, ($4).val.ival);
            else 
                printf("R[%d] = pwr(R[0], %d);\n", reg_count++, ($4).val.ival);
            char *result = (char *)malloc(10);
            sprintf(result, "R[%d]", reg_count - 1);
            $$ = result;
        } else {
            if(strcmp($2, "**") != 0) 
                printf("%s = R[0] %s %s;\n", ($4).val.sval,$2, ($4).val.sval);
            else 
                printf("%s = pwr(R[0], %s);\n", ($4).val.sval, ($4).val.sval);
            $$ = ($4).val.sval;
        }
        
    } else if(($4).type == TYPEID) {
        int pos = lookup(($4).val.sval);
        if(pos == -1) {
            printf("Variable %s not found", ($4).val.sval);
        }
        printf("R[0] = MEM[%d];\n", pos);
        if(($3).type == TYPENUM) { // First is NUM
            if(strcmp($2, "**") != 0) 
                printf("R[%d] = %d %s R[0];\n", reg_count++, ($3).val.ival, $2);
            else 
                printf("R[%d] = pwr(%d, R[0]);\n", reg_count++, ($3).val.ival);
            char *result = (char *)malloc(10);
            sprintf(result, "R[%d]", reg_count - 1);
            $$ = result;
        } else {
            if(strcmp($2, "**") != 0) 
                printf("%s = %s %s R[0];\n", ($3).val.sval, ($3).val.sval, $2);
            else 
                printf("%s = pwr(%s, R[0]);\n", ($3).val.sval, ($3).val.sval);
            $$ = ($3).val.sval;
        }
    } else if(($3).type == TYPENUM && ($4).type == TYPENUM) { // Both are NUMs
        if(strcmp($2, "**") != 0) 
            printf("R[%d] = %d %s %d;\n", reg_count++, ($3).val.ival, $2, ($4).val.ival);
        else 
            printf("R[%d] = pwr(%d, %d);\n", reg_count++, ($3).val.ival, ($4).val.ival);
        char *result = (char *)malloc(10);
        sprintf(result, "R[%d]", reg_count - 1);
        $$ = result;
    } else if(($3).type == TYPENUM) { // First is NUM
        $$ = ($4).val.sval;
        if(strcmp($2, "**") != 0) 
            printf("%s = %d %s %s;\n", ($4).val.sval, ($3).val.ival, $2, ($4).val.sval);
        else 
            printf("%s = pwr(%d, %s);\n", ($4).val.sval, ($3).val.ival, ($4).val.sval);
    } else if(($4).type == TYPENUM) { // Second is NUM
        $$ = ($3).val.sval;
        if(strcmp($2, "**") != 0) 
            printf("%s = %s %s %d;\n", ($3).val.sval, ($3).val.sval, $2, ($4).val.ival);
        else 
            printf("%s = pwr(%s, %d);\n", ($3).val.sval, ($3).val.sval, ($4).val.ival);
    } else {
        if(strcmp($2, "**") != 0) 
            printf("R[%d] = %s %s %s;\n", reg_count - 2, ($3).val.sval, $2, ($4).val.sval);
        else 
            printf("R[%d] = pwr(%s, %s);\n", reg_count - 2, ($3).val.sval, ($4).val.sval);
        char *result = (char *)malloc(10);
        sprintf(result, "R[%d]", reg_count - 2);
        $$ = result;
        reg_count--;
    }
}
    ;

OP: ADD { $$ = "+"; }
  | SUB { $$ = "-"; }
  | MUL { $$ = "*"; }
  | DIV { $$ = "/"; }
  | MOD { $$ = "%"; }
  | EXPO { $$ = "**"; }
  ;
ARG: ID {
    $$ = newArgtype(TYPEID, 0, $1);
    }
   | NUM { 
    $$ = newArgtype(TYPENUM, $1, NULL);
    }
   | EXPR { 
    $$ = newArgtype(TYPEEXPR, 0, $1);
    }
   ;

%%


int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}