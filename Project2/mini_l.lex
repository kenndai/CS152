%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "calc.tab.h"

%}

IDENT       ([a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9])|([a-zA-Z])
NUMBER      [0-9]+
COMMENT     ##.*\n
UNDEREND    [a-zA-Z][a-zA-Z0-9_]*_
ERRBEGIN    [0-9_][a-zA-Z0-9_]*[a-zA-Z0-9]

%%
function	{ return FUNCTION; columnNum += yyleng; }
beginparams { return BEGIN_PARAMS; columnNum += yyleng; }
endparams   { return END_PARAMS; columnNum += yyleng; }
beginlocals	{ return BEGIN_LOCALS; columnNum += yyleng; }
endlocals	{ return END_LOCALS; columnNum += yyleng; }
beginbody	{ return BEGIN_BODY; columnNum += yyleng; }
endbody 	{ return END_BODY; columnNum += yyleng; }
integer 	{ return INTEGER; columnNum += yyleng; }
array   	{ return ARRAY; columnNum += yyleng; }
of      	{ return OF; columnNum += yyleng; }
if          { return IF; columnNum += yyleng; }
then    	{ return THEN; columnNum += yyleng; }
endif   	{ return ENDIF; columnNum += yyleng; }
else    	{ return ELSE; columnNum += yyleng; }
while   	{ return WHILE; columnNum += yyleng; }
do      	{ return DO; columnNum += yyleng; }
beginloop	{ return BEGINLOOP; columnNum += yyleng; }
endloop 	{ return ENDLOOP; columnNum += yyleng; }
continue	{ return CONTINUE; columnNum += yyleng; }
read    	{ return READ; columnNum += yyleng; }
write   	{ return WRITE; columnNum += yyleng; }
and         { return AND; columnNum += yyleng; }
or          { return OR; columnNum += yyleng; }
not         { return NOT; columnNum += yyleng; }
true        { return TRUE; columnNum += yyleng; }
false       { return FALSE; columnNum += yyleng; }
return      { return RETURN; columnNum += yyleng; }

"-"         { return SUB; columnNum += yyleng; }
"+"         { return ADD; columnNum += yyleng; }
"*"         { return MULT; columnNum += yyleng; }
"/"         { return DIV; columnNum += yyleng; }
"%"         { return MOD; columnNum += yyleng; }

"=="   	    { return EQ; columnNum += yyleng; }
"<>"       	{ return NEQ; columnNum += yyleng; }
"<"        	{ return LT; columnNum += yyleng; }
">"        	{ return GT; columnNum += yyleng; }
"<="       	{ return LTE; columnNum += yyleng; }
">="       	{ return GTE; columnNum += yyleng; }

{IDENT}   	{ return IDENT); columnNum += yyleng; }
{NUMBER}    { return NUMBER); columnNum += yyleng; }
{COMMENT}   { }
{UNDEREND}  { return Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", rowNum, columnNum, yytext); exit(1); }
{ERRBEGIN}  { return Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", rowNum, columnNum, yytext); exit(1); }

";"        	{ return SEMICOLON; columnNum += yyleng; }
":"        	{ return COLON; columnNum += yyleng; }
","        	{ return COMMA; columnNum += yyleng; }
"        	{ return L_PAREN; columnNum += yyleng; }
")"         { return R_PAREN; columnNum += yyleng; }
"["        	{ return L_SQUARE_BRACKET; columnNum += yyleng; }
"]"        	{ return R_SQUARE_BRACKET; columnNum += yyleng; }
":="       	{ return ASSIGN; columnNum += yyleng; }

"\n"        { rowNum++; columnNum = 0; }
"\t"        { columnNum += yyleng; }
" "         { columnNum += yyleng; }

.           { return Error at line %d, column %d: unrecognized symbol \"%s\"\n", rowNum, columnNum, yytext); exit(1); }

%%