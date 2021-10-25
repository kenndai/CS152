%option noyywrap

%{
    #include "y.tab.h"
    int rowNum = 1;
    int columnNum = 0; 
%}

IDENT       ([a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9])|([a-zA-Z])
NUMBER      [0-9]+
COMMENT     ##.*\n
UNDEREND    [a-zA-Z][a-zA-Z0-9_]*_
ERRBEGIN    [0-9_][a-zA-Z0-9_]*[a-zA-Z0-9]

%%
function	{ columnNum += yyleng; return FUNCTION; }
beginparams { columnNum += yyleng; return BEGIN_PARAMS; }
endparams   { columnNum += yyleng; return END_PARAMS; }
beginlocals	{ columnNum += yyleng; return BEGIN_LOCALS; }
endlocals	{ columnNum += yyleng; return END_LOCALS; }
beginbody	{ columnNum += yyleng; return BEGIN_BODY; }
endbody 	{ columnNum += yyleng; return END_BODY; }
integer 	{ columnNum += yyleng; return INTEGER; }
array   	{ columnNum += yyleng; return ARRAY; }
of      	{ columnNum += yyleng; return OF; }
if          { columnNum += yyleng; return IF; }
then    	{ columnNum += yyleng; return THEN; }
endif   	{ columnNum += yyleng; return ENDIF; }
else    	{ columnNum += yyleng; return ELSE; }
while   	{ columnNum += yyleng; return WHILE; }
do      	{ columnNum += yyleng; return DO; }
beginloop	{ columnNum += yyleng; return BEGINLOOP; }
endloop 	{ columnNum += yyleng; return ENDLOOP; }
continue	{ columnNum += yyleng; return CONTINUE; }
read    	{ columnNum += yyleng; return READ; }
write   	{ columnNum += yyleng; return WRITE; }
and         { columnNum += yyleng; return AND; }
or          { columnNum += yyleng; return OR; }
not         { columnNum += yyleng; return NOT; }
true        { columnNum += yyleng; return TRUE; }
false       { columnNum += yyleng; return FALSE; }
return      { columnNum += yyleng; return RETURN; }

"-"         { columnNum += yyleng; return SUB; }
"+"         { columnNum += yyleng; return ADD; }
"*"         { columnNum += yyleng; return MULT; }
"/"         { columnNum += yyleng; return DIV; }
"%"         { columnNum += yyleng; return MOD; }

"=="   	    { columnNum += yyleng; return EQ; }
"<>"       	{ columnNum += yyleng; return NEQ; }
"<"        	{ columnNum += yyleng; return LT; }
">"        	{ columnNum += yyleng; return GT; }
"<="       	{ columnNum += yyleng; return LTE; }
">="       	{ columnNum += yyleng; return GTE; }

{IDENT}   	{ columnNum += yyleng; return IDENT; }
{NUMBER}    { columnNum += yyleng; return NUMBER; }
{COMMENT}   { }
{UNDEREND}  { printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", rowNum, columnNum, yytext); exit(1); }
{ERRBEGIN}  { printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", rowNum, columnNum, yytext); exit(1); }

";"        	{ columnNum += yyleng; return SEMICOLON; }
":"        	{ columnNum += yyleng; return COLON; }
","        	{ columnNum += yyleng; return COMMA; }
"("        	{ columnNum += yyleng; return L_PAREN; }
")"         { columnNum += yyleng; return R_PAREN; }
"["        	{ columnNum += yyleng; return L_SQUARE_BRACKET; }
"]"        	{ columnNum += yyleng; return R_SQUARE_BRACKET; }
":="       	{ columnNum += yyleng; return ASSIGN; }

"\n"        { rowNum++; columnNum = 0; }
"\t"        { columnNum += yyleng; }
" "         { columnNum += yyleng; }

.           { printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", rowNum, columnNum, yytext); exit(1); }

%%