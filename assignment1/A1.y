%{
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>

 int yylex (void);
 void yyerror (const char *);
%}

%union {
  int num;
  char* id;
}

%token <num> T_NUM
%token <id> T_ID
%token T_DS, T_DS0, T_DS1, T_DS2, T_EXP, T_EXP0, T_EXP1, T_EXP2
%token T_CLASS, T_PUBLIC, T_PRIVATE, T_PROTECTED, T_VOID, T_STATIC, T_MAIN, T_EXTENDS, T_THIS
%token T_NEW, T_IF, T_ELSE, T_RETURN, T_WHILE 
%token T_INT, T_BOOL, T_TRUE, T_FALSE, T_STRING
%token T_AND, T_OR, T_GREAT, T_GREATEQ, T_SMALL, T_SMALLEQ, T_COMPARE, T_NOTEQ
%token T_PRINT

%%

goal: macro-definition-loop main-class type-definition-loop EOF
;

macro-definition-loop:                  /* empty string */
                    |   macro-definition-loop macro-definition
;

type-definition-loop: 
                    |   type-definition-loop type-definition
;

main-class: T_CLASS T_ID '{' T_PUBLIC T_STATIC T_VOID T_MAIN '(' T_STRING '[' ']' T_ID ')' '{' T_PRINT '(' expression ')' ';' '}' '}'
;

type-definition: T_CLASS T_ID '{' type-identifiers method-declaration-loop '}'
            |   T_CLASS T_ID T_EXTENDS T_ID '{' type-identifiers method-declaration-loop '}'
;

method-declaration-loop: 
                    |   method-declaration-loop method-declaration
;

method-declaration: 

%%

void yyerror (const char *s) {
  printf ("Unexpected syntax\n");
}

int main () {
  yyparse ();
	return 0;
}

#include "lex.yy.c"