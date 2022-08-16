%{
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>

 typedef struct Node {
    int is_main_part;
    char* value;
    struct Node* next;
    struct Node* prev;

} Node;

struct Node *head = NULL;
struct Node *tail = NULL;

Node* createNode(char* s, int part) {
  Node* nwNode = (Node *) malloc(sizeof(Node));
  nwNode->value = s;
  nwNode->next = NULL;
  nwNode->prev = NULL;
  return nwNode;
}

void addE(Node* nwNode) {
  if(head == NULL) {
    head = nwNode;
    tail = nwNode;
    return;
  } 

  nwNode->prev = tail;
  tail->next = nwNode;
  tail = nwNode;
}

void add(Node* nwNode, Node* after) {
    Node* afterNode = after->next;
    after->next = nwNode;
    nwNode->prev = after;
    nwNode->next = afterNode;
}

 int yylex (void);
 void yyerror (const char *);
%}

%union {
  int num;
  char* id;
}

%token <num> T_NUM
%token <id> T_ID
%token T_DS T_DS0 T_DS1 T_DS2 T_EXP T_EXP0 T_EXP1 T_EXP2
%token T_INT T_BOOL T_TRUE T_FALSE T_STRING
%token T_CLASS T_PUBLIC T_VOID T_STATIC T_MAIN T_EXTENDS T_THIS
%token T_NEW T_IF T_ELSE T_RETURN T_WHILE
%token T_AND T_OR T_SMALLEQ T_NOTEQ
%token T_PRINT T_LENGTH

%%

goal: macro-definition-loop main-class type-definition-loop
;

macro-definition-loop: /* empty string */
                    | macro-definition macro-definition-loop
;

type-definition-loop: /* empty string */
                    | type-definition type-definition-loop
;

class-open: class id o-c-b
;

class-extends-open: class id extends id o-c-b
;

class-body: type-identifiers method-declaration-loop c-c-b
;

main-class: class-open public static void main o-b str o-s-b c-s-b id c-b o-c-b print o-b expression c-b semi-colon c-c-b c-c-b
; 

type-definition: class-open class-body
            |   class-extends-open class-body
;

method-declaration-loop: 
                    |   method-declaration-loop method-declaration
;

type-identifiers:  
                | type-identifiers type-identifier semi-colon
;

type-identifier:  type id
;

method-declaration: public type-identifier o-b type-identifiers-comma c-b o-c-b type-identifiers statements return expression semi-colon c-c-b
; 

type-identifiers-comma: 
                      | type-identifier comma-type-identifiers
;

comma-type-identifiers: 
                      | comma type-identifier comma-type-identifiers 
;

type: int o-s-b c-s-b
  | boolean
  | int 
  | id
;

statements: 
          | statement statements
;

statement: o-c-b statements c-c-b
          | print o-b expression c-b semi-colon
          | id equal expression semi-colon
          | id o-s-b expression c-s-b equal expression semi-colon
          | if-statement
          | if-statement else statement
          | while o-b expression c-b statement 
          | id o-b expressions-comma c-b semi-colon
;

if-statement: if o-b expression c-b statement
;

expressions-comma: 
                | expression comma-expressions 
;

comma-expressions: 
                | comma expression comma-expressions
;

expression: primary-expression and primary-expression
          | primary-expression or primary-expression
          | primary-expression neq primary-expression
          | primary-expression leq primary-expression
          | primary-expression add primary-expression
          | primary-expression sub primary-expression
          | primary-expression mul primary-expression
          | primary-expression div primary-expression
          | primary-expression o-s-b primary-expression c-s-b
          | primary-expression-dot length 
          | primary-expression
          | primary-expression-dot id o-b expressions-comma c-b
          | id o-b expressions-comma c-b
;

primary-expression-dot: primary-expression dot
;

primary-expression: integer
                  | true 
                  | false 
                  | id
                  | this 
                  | new int o-s-b expression c-s-b
                  | new id o-b c-b 
                  | not expression
                  | o-b expression c-b
; 

macro-definition: macro-def-expression
                | macro-def-statement
;

macro-def-statement: define-stmt id o-b id comma id comma id comma-identifiers c-b o-c-b statements c-c-b
                    | define-stmt-0 id o-b c-b o-c-b statements c-c-b
                    | define-stmt-1 id o-b id c-b o-c-b statements c-c-b
                    | define-stmt-2 id o-b id comma id c-b o-c-b statements c-c-b
; 

macro-def-expression: define-expr id o-b id comma id comma id comma-identifiers c-b o-b expression c-b
                    | define-expr-0 id o-b c-b o-b expression c-b
                    | define-expr-1 id o-b id c-b o-b expression c-b 
                    | define-expr-2 id o-b id comma id c-b o-b expression c-b 
;

comma-identifiers: 
                | comma id comma-identifiers
;

define-expr: T_EXP                
;

define-expr-0: T_EXP0             
;

define-expr-1: T_EXP1              
;

define-expr-2: T_EXP2             
;

define-stmt: T_DS                
;

define-stmt-0: T_DS0              
;

define-stmt-1: T_DS1              
;

define-stmt-2: T_DS2              
;

class: T_CLASS                    
;

id: T_ID                          
;

integer: T_NUM                   
;

public: T_PUBLIC                  
;

/* private: T_PRIVATE               
; */

/* protected: T_PROTECTED            
; */

static: T_STATIC                
;

void: T_VOID                      
;

main: T_MAIN                     
;

print: T_PRINT                    
;

extends: T_EXTENDS                
;

return: T_RETURN                  
;

int: T_INT                        
;

boolean: T_BOOL                   
;

str: T_STRING                 
;

if: T_IF                          
;

else: T_ELSE                      
;

while: T_WHILE                    
;

and: T_AND                        
;

or: T_OR                          
;

leq: T_SMALLEQ                    
;

neq: T_NOTEQ                      
;

/* geq: T_GREATEQ                    
; */

/* gt: T_GREAT                       
; */

/* lt: T_SMALL                       
; */

length: T_LENGTH                  
;

true: T_TRUE                     
;

false: T_FALSE                    
;

new: T_NEW                        
;

this: T_THIS                      
;

/* compare: T_COMPARE                }
; */

o-b: '('                          
;

c-b: ')'                          
;

o-c-b: '{'                        
;

c-c-b: '}'                        
;

o-s-b: '['                        
;

c-s-b: ']'                        
;

semi-colon: ';'                   
;

equal: '='                        
;

add: '+'                          
;

sub: '-'                          
;

div: '/'                          
;

mul: '*'                          
;

dot: '.'                         
;

not: '!'                         
;

comma: ','                       
;

%%

void yyerror (const char *s) {
  printf ("Unexpected syntax\n");
  printf("%s\n", s);
  exit(1);
}

int main () {
  yyparse ();

  printf("\n");

  Node* curr = head;

  while(curr != NULL) {
    printf("%s", curr->value);
    curr = curr->next;
  }

	return 0;
}

#include "lex.yy.c"