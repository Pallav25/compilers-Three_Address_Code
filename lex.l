%{

%}

/*Identifier Definition*/
IDENT_START  [a-zA-Z_]
NUMBER   [0-9]
IDENT  {IDENT_START}({IDENT_START}|{NUMBER})*

/* Signed Integer Definition */
SIGNED_INT  [+-]?{NUMBER}+

%%


"set"   {return SET;}
{IDENT}  {yylval.strVal = strdup(yytext); return ID;}
{SIGNED_INT} {yylval.intVal = atoi(yytext); return NUM;}
"("    { return LPAREN;}
")"    { return RPAREN;}
"+"    { return ADD;}
"-"    { return SUB;}
"*"    { return MUL;}
"/"    { return DIV;}
"%"    { return MOD;}
"**"    { return EXPO;}

%%

int yywrap(void){
    return 1;
}
