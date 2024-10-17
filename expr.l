%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "expr.tab.h"
%}

IDENTIFIER  [a-zA-Z_]([a-zA-Z_]|[0-9])*
NUMBER  [+-]?[1-9][0-9]*|[0]

%%


"set"   {return SET;}
{IDENTIFIER}  {yylval.strVal = strdup(yytext); return ID;}
{NUMBER} {yylval.intVal = atoi(yytext); return NUM;}
"("    { return LPAREN;}
")"    { return RPAREN;}
"+"    { return ADD;}
"-"    { return SUB;}
"**"   { return EXPO;}
"*"    { return MUL;}
"/"    { return DIV;}
"%"    { return MOD;}
.     { }
%%

int yywrap(void){
    return 1;
}
