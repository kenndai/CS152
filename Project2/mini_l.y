%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);

int numCount, eqCount, plusCount, minusCount, multCount, divCount, l_parenCount, r_parenCount = 0;

%}

%token NUMBER EQUAL
%left L_PAREN R_PAREN 
%left PLUS MINUS
%left MULT DIV /* the lower the line, the higher the precedence */
%start expr 

%%

expr:  
    NUMBER                        { numCount++; }
    | NUMBER EQUAL                { eqCount++; }
    | expr PLUS expr              { plusCount++; }
    | expr MINUS expr             { minusCount++; }
    | MINUS expr                  { minusCount++;}
    | expr MULT expr              { multCount++; }
    | expr DIV expr               { divCount++; }
    | L_PAREN expr R_PAREN        { l_parenCount++; r_parenCount++; }
    | L_PAREN expr R_PAREN EQUAL  { l_parenCount++; r_parenCount++; eqCount++; }

%%

int main(int argc, char* argv[]) {
  argc--; argv++;
  if (argc > 0) yyin = fopen(argv[0], "r");
  else yyin = stdin;

  do {
    printf("Parse.\n");
    yyparse();
  } while(!feof(yyin));

  printf("Syntax is correct!\n");
  printf("NUMBERS: %d\n", numCount);
  printf("EQUALS: %d\n", eqCount);
  printf("PLUSES: %d\n", plusCount);
  printf("MINUSES: %d\n", minusCount);
  printf("MULTS: %d\n", multCount);
  printf("DIVS: %d\n", divCount);
  printf("L_PARENS: %d\n", l_parenCount);
  printf("R_PARENS: %d\n", r_parenCount);
  return 0;
}

void yyerror(const char* s) {
  fprintf(stderr, "Parse error: %s. Syntax does not follow grammar!\n", s);
  exit(1);
}