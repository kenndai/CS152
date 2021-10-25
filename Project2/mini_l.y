%{
#include <stdio.h>
#include <stdlib.h>

extern FILE * yyin;
extern int rowNum; 
extern int columnNum;

void yyerror(const char* s);
%}

%union {
  char* identVal;
  int num_val;
}

%start Program

%token <identVal> IDENT
%token <num_val> NUMBER

%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE TRUE FALSE RETURN SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET
%right ASSIGN
%left OR 
%left AND 
%right NOT
%left LT LTE GT GTE EQ NEQ
%left ADD SUB
%left MULT DIV MOD/* the lower the line, the higher the precedence */

%%

Program:
  Function-Loop { printf("Program -> Function-Loop\n"); }

Function-Loop:
  Function Function-Loop { printf("Function-Loop -> Function Function-Loop\n"); }
  | { printf("Function-Loop -> epsilon\n"); }

Function:
  FUNCTION IDENT SEMICOLON BEGIN_PARAMS Declaration-Loop END_PARAMS BEGIN_LOCALS Declaration-Loop END_LOCALS BEGIN_BODY Statement-Loop END_BODY
  { printf("Function -> FUNCTION IDENT SEMICOLON BEGIN_PARAMS Declaration-Loop END_PARAMS BEGIN_LOCALS Declaration-Loop END_LOCALS BEGIN_BODY Statement-Loop END_BODY\n"); }

Declaration-Loop:
  Declaration SEMICOLON Declaration-Loop { printf("Declaration-Loop -> Declaration SEMICOLON Declaration-Loop\n"); }
  | { printf("Declaration-Loop -> epsilon\n"); }

Ident-Loop:
  IDENT { printf("Ident-Loop -> IDENT\n"); }
  | IDENT COMMA Ident-Loop { printf("Ident-Loop -> IDENT COMMA Ident-Loop\n"); }

Declaration:
  Ident-Loop COLON INTEGER { printf("Declaration -> Ident-Loop COLON INTEGER\n"); }
  | Ident-Loop COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
  { printf("Declaration -> Ident-Loop COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n"); }

Statement-Loop:
  Statement SEMICOLON { printf("Statement-Loop -> Statement SEMICOLON\n"); }
  | Statement SEMICOLON Statement-Loop { printf("Statement-Loop -> Statement SEMICOLON Statement-Loop\n"); }

Statement:
  Var ASSIGN Expression { printf("Statement -> Var ASSIGN Expression\n"); }
  | IF Bool-Expr THEN Statement-Loop ENDIF { printf("Statement -> IF Bool-Expr THEN Statement-Loop ENDIF\n"); }
  | IF Bool-Expr THEN Statement-Loop ELSE Statement-Loop ENDIF { printf("Statement -> IF Bool-Expr THEN Statement-Loop ELSE Statement-Loop ENDIF\n"); }
  | WHILE Bool-Expr BEGINLOOP Statement-Loop ENDLOOP { printf("Statement -> WHILE Bool-Expr BEGINLOOP Statement-Loop ENDLOOP\n"); }
  | DO BEGINLOOP Statement-Loop ENDLOOP WHILE Bool-Expr { printf("Statement -> DO BEGINLOOP Statement-Loop ENDLOOP WHILE Bool-Expr\n"); }
  | READ Var-Loop { printf("Statement -> READ Var-Loop\n"); }
  | WRITE Var-Loop { printf("Statement -> WRITE Var-Loop\n"); }
  | CONTINUE { printf("Statement -> CONTINUE\n"); }
  | RETURN Expression { printf("Statement -> RETURN Expression\n"); }

Bool-Expr:
  Relation-And-Expr { printf("Bool-Expr -> Relation-And-Expr\n"); }
  | Relation-And-Expr OR Bool-Expr { printf("Bool-Expr -> Relation-And-Expr OR Bool-Expr\n"); }

Relation-And-Expr:
  Relation-Expr { printf("Relation-And-Expr -> Relation-Expr\n"); }
  | Relation-Expr AND Relation-And-Expr { printf("Relation-And-Expr -> Relation-Expr AND Relation-And-Expr\n"); }

Relation-Expr:
  NOT Expression Comp Expression { printf("Relation-Expr -> NOT Expression Comp Expression\n"); }
  | NOT TRUE { printf("Relation-Expr -> NOT TRUE\n"); }
  | NOT FALSE { printf("Relation-Expr -> NOT FALSE\n"); }
  | NOT L_PAREN Bool-Expr R_PAREN { printf("Relation-Expr -> NOT L_PAREN Bool-Expr R_PAREN\n"); }
  | Expression Comp Expression { printf("Relation-Expr -> Expression Comp Expression\n"); }
  | TRUE { printf("Relation-Expr -> TRUE\n"); }
  | FALSE { printf("Relation-Expr -> FALSE\n"); }
  | L_PAREN Bool-Expr R_PAREN { printf("Relation-Expr -> L_PAREN Bool-Expr R_PAREN\n"); }

Comp:
  EQ { printf("Comp -> EQ\n"); }
  | NEQ { printf("Comp -> NEQ\n"); }
  | LT { printf("Comp -> LT\n"); }
  | GT { printf("Comp -> GT\n"); }
  | LTE { printf("Comp -> LTE\n"); }
  | GTE { printf("Comp -> GTE\n"); }

Expression-Loop:
  Expression { printf("Expression-Loop -> Expression\n"); }
  | Expression COMMA Expression Expression-Loop { printf("Expression-Loop -> Expression COMMA Expression Expression-Loop\n"); }
  | { printf("Expression-Loop -> epsilon\n"); }

Expression:
  Multiplicative-Expr { printf("Expression -> Multiplicative-Expr\n"); }
  | Multiplicative-Expr ADD Expression { printf("Expression -> Multiplicative-Expr ADD Expression\n"); }
  | Multiplicative-Expr SUB Expression { printf("Expression -> Multiplicative-Expr SUB Expression\n"); }


Multiplicative-Expr:
  Term { printf("Multiplicative-Expr -> Term\n"); }
  | Term MULT Multiplicative-Expr { printf("Multiplicative-Expr -> Term MULT Multiplicative-Expr\n"); }
  | Term DIV Multiplicative-Expr { printf("Multiplicative-Expr -> Term DIV Multiplicative-Expr\n"); }
  | Term MOD Multiplicative-Expr { printf("Multiplicative-Expr -> Term MOD Multiplicative-Expr\n"); }

Term:
  SUB Var { printf("Term -> SUB Var\n"); }
  | SUB NUMBER { printf("Term -> SUB NUMBER\n"); }
  | SUB L_PAREN Expression R_PAREN  { printf("Term -> SUB L_PAREN Expression R_PAREN\n"); }
  | Var { printf("Term -> Var\n"); }
  | NUMBER  { printf("Term -> NUMBER\n"); }
  | L_PAREN Expression R_PAREN { printf("Term -> L_PAREN Expression R_PAREN\n"); }
  | IDENT L_PAREN Expression-Loop R_PAREN { printf("Term -> IDENT L_PAREN Expression-Loop R_PAREN\n"); }

Var-Loop:
  Var { printf("Var-Loop -> Var\n"); }
  | Var COMMA Var-Loop { printf("Var-Loop -> Var COMMA Var-Loop\n"); }

Var:
  IDENT { printf("Var -> IDENT\n"); }
  | IDENT L_SQUARE_BRACKET Expression R_SQUARE_BRACKET { printf("Var -> IDENT L_SQUARE_BRACKET Expression R_SQUARE_BRACKET\n"); }

%%

int main(int argc, char* argv[]) {
  argc--; argv++;
  if (argc > 0) yyin = fopen(argv[0], "r");
  else yyin = stdin;

  do {
    printf("Parse.\n");
    yyparse();
  } while(!feof(yyin));
}

void yyerror(const char* s) {
  printf("Error: Line %d, position %d: %s \n", rowNum, columnNum, s);
  exit(1);
}