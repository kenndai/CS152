%{
    int rowNum = 1;
    int columnNum = 0; 
%}

IDENT       ([a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9])|([a-zA-Z])
NUMBER      [0-9]+
COMMENT     ##.*\n
UNDEREND    [a-zA-Z][a-zA-Z0-9_]*_
ERRBEGIN    [0-9_][a-zA-Z0-9_]*[a-zA-Z0-9]

%%
function	{ printf("FUNCTION\n"); columnNum += yyleng; }
beginparams { printf("BEGIN_PARAMS\n"); columnNum += yyleng; }
endparams   { printf("END_PARAMS\n"); columnNum += yyleng; }
beginlocals	{ printf("BEGIN_LOCALS\n"); columnNum += yyleng; }
endlocals	{ printf("END_LOCALS\n"); columnNum += yyleng; }
beginbody	{ printf("BEGIN_BODY\n"); columnNum += yyleng; }
endbody 	{ printf("END_BODY\n"); columnNum += yyleng; }
integer 	{ printf("INTEGER\n"); columnNum += yyleng; }
array   	{ printf("ARRAY\n"); columnNum += yyleng; }
of      	{ printf("OF\n"); columnNum += yyleng; }
if          { printf("IF\n"); columnNum += yyleng; }
then    	{ printf("THEN\n"); columnNum += yyleng; }
endif   	{ printf("ENDIF\n"); columnNum += yyleng; }
else    	{ printf("ELSE\n"); columnNum += yyleng; }
while   	{ printf("WHILE\n"); columnNum += yyleng; }
do      	{ printf("DO\n"); columnNum += yyleng; }
beginloop	{ printf("BEGINLOOP\n"); columnNum += yyleng; }
endloop 	{ printf("ENDLOOP\n"); columnNum += yyleng; }
continue	{ printf("CONTINUE\n"); columnNum += yyleng; }
read    	{ printf("READ\n"); columnNum += yyleng; }
write   	{ printf("WRITE\n"); columnNum += yyleng; }
and         { printf("AND\n"); columnNum += yyleng; }
or          { printf("OR\n"); columnNum += yyleng; }
not         { printf("NOT\n"); columnNum += yyleng; }
true        { printf("TRUE\n"); columnNum += yyleng; }
false       { printf("FALSE\n"); columnNum += yyleng; }
return      { printf("RETURN\n"); columnNum += yyleng; }

"-"         { printf("SUB\n"); columnNum += yyleng; }
"+"         { printf("ADD\n"); columnNum += yyleng; }
"*"         { printf("MULT\n"); columnNum += yyleng; }
"/"         { printf("DIV\n"); columnNum += yyleng; }
"%"         { printf("MOD\n"); columnNum += yyleng; }

"=="   	    { printf("EQ\n"); columnNum += yyleng; }
"<>"       	{ printf("NEQ\n"); columnNum += yyleng; }
"<"        	{ printf("LT\n"); columnNum += yyleng; }
">"        	{ printf("GT\n"); columnNum += yyleng; }
"<="       	{ printf("LTE\n"); columnNum += yyleng; }
">="       	{ printf("GTE\n"); columnNum += yyleng; }

{IDENT}   	{ printf("IDENT %s\n", yytext); columnNum += yyleng; }
{NUMBER}    { printf("NUMBER %d\n", atoi(yytext)); columnNum += yyleng; }
{COMMENT}   { printf("Comment\n"); }
{UNDEREND}  { printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", rowNum, columnNum, yytext); exit(1); }
{ERRBEGIN}  { printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", rowNum, columnNum, yytext); exit(1); }

";"        	{ printf("SEMICOLON\n"); columnNum += yyleng; }
":"        	{ printf("COLON\n"); columnNum += yyleng; }
","        	{ printf("COMMA\n"); columnNum += yyleng; }
"("        	{ printf("L_PAREN\n"); columnNum += yyleng; }
")"         { printf("R_PAREN\n"); columnNum += yyleng; }
"["        	{ printf("L_SQUARE_BRACKET\n"); columnNum += yyleng; }
"]"        	{ printf("R_SQUARE_BRACKET\n"); columnNum += yyleng; }
":="       	{ printf("ASSIGN\n"); columnNum += yyleng; }

"\n"        { rowNum++; columnNum = 0; }
"\t"        { columnNum += yyleng; }
" "         { columnNum += yyleng; }

.           { printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", rowNum, columnNum, yytext); exit(1); }

%%

main (int argc, char** argv) {
    ++argv, --argc;
    if (argc > 0) yyin = fopen(argv[0], "r");
    else yyin = stdin;
    yylex();
}
