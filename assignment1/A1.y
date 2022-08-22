%{
/*
  CS3300: Assignment P0
  Author: Soham Tripathy CS20B073
  Topic: Flex and Bison

  Comment: Thank You For The Assignment  (-_-)
           Please don't give penalty     (T_T)

*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//for storing the token stream
typedef struct Node {
    char* value;            //value of tokens
    struct Node* next;      //to traverse through the tokens
    struct Node* prev;
} Node;

//for traversing tokens and printing them
struct Node *head = NULL;
struct Node *tail = NULL;

//creating a node for token
Node* createNode(char* s) {
  Node* nwNode = (Node *) malloc(sizeof(Node));
  nwNode->value = s;
  nwNode->next = NULL;
  nwNode->prev = NULL;
  return nwNode;
}

//adding the node to the token stream, at tail
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

//for storing arguments in the Macro replacement
typedef struct Argument { //                                            for example - x(arg) called as x((0+1))
  char* id;               //stores argument id                          id = arg                   
  Node* from;             //replacement of the argument - from          from = (           
  Node* to;               //replacement of the argument - to            to = )
  struct Argument* next;  //for traversing through                      
  struct Argument* prev;
} Argument;


//for storing the Macro replacements
typedef struct Macro {            
  char* id;                   //macro identifier
  Argument* arg_head;         //stores the argument list head
  Argument* arg_tail;         //stores the argument list tail
  Node* from;                 //replacement
  Node* to;
  struct Macro* next;         //for traversing
  struct Macro* prev;
} Macro;

//for storing the macros
struct Macro* _head = NULL;
struct Macro* _tail = NULL;

//creating a macro
struct Macro *_temp = NULL;       //contains the current parsing macro

void createAndAddMacro() {
  Macro* nwMacro = (Macro *) malloc(sizeof(Macro));

  nwMacro->arg_head = NULL;
  nwMacro->arg_tail = NULL;
  nwMacro->next = NULL;
  nwMacro->prev = NULL;

  if(_head == NULL) {
    _head = nwMacro;
    _tail = nwMacro;
    _temp = nwMacro;
    return;
  }

  nwMacro->prev = _tail;
  _tail->next = nwMacro;
  _tail = nwMacro;

  _temp = nwMacro;
}

//creating arguments for the macro
//adds the arguments to the current macro being processed
void addArg(char* _arg) {
  Argument* nwArg = (Argument*) malloc(sizeof(Argument));
  nwArg->id = _arg;

  if(_temp->arg_head == NULL) {
    _temp->arg_head = nwArg;
    _temp->arg_tail = nwArg;
    return;
  }

  nwArg->prev = _temp->arg_tail;
  _temp->arg_tail->next = nwArg;
  _temp->arg_tail = nwArg;
  return;
}

/* Replacement Policy */

//Contains information about the current macro matched
typedef struct ReplaceMacro {
  Macro* replace_macro;               //The matched macro
  Argument* rep_arg_head;             //Argument list containg information about what to replace it with
  Argument* rep_arg_tail;             
  Argument* processed_arg;            //Current argument being processed
  Node* replace_from;                 //Replace from in the file
  Node* replace_to;                   //Replace to in the file
  struct ReplaceMacro* next;          //traversing
  struct ReplaceMacro* prev;
} ReplaceMacro;

//For keeping track of Macro inside Macro
ReplaceMacro* test_head;
ReplaceMacro* test_tail;
int process_macro = 0;

//Temp Variable used to link arguments while parsing
Argument* rep_arg;


//Creates a duplicate of the Argument and stores it in Replace Macro
void addRepArg(Argument* rep) {
  Argument* nwArg = (Argument*) malloc(sizeof(Argument));

  nwArg->id = rep->id;
  nwArg->from = rep->from;
  nwArg->to = rep->to;

  if(test_tail->rep_arg_head == NULL) {
    test_tail->rep_arg_head = nwArg;
    test_tail->rep_arg_tail = nwArg;
    return;
  }

  nwArg->prev = test_tail->rep_arg_tail;
  test_tail->rep_arg_tail->next = nwArg;
  test_tail->rep_arg_tail = nwArg; 
}

//Creates a Replace Macro
void createReplaceMacro(Macro* rep_mac) {
  ReplaceMacro* nwRepMac = (ReplaceMacro*) malloc(sizeof(ReplaceMacro));

  nwRepMac->replace_macro = rep_mac;

  if(test_head == NULL) {
    test_head = nwRepMac;
    test_tail = nwRepMac;
    return;
  }

  nwRepMac->prev = test_tail;
  test_tail->next = nwRepMac;
  test_tail = nwRepMac;
}

//Checks if 'id' is matched to any Macro definition
Macro* findMacroMatch(char* id) {
  Macro* curr = _head;
  while(curr != NULL) {
    if(strcmp(curr->id, id) == 0) {
      return curr;
    }

    curr = curr->next;
  }

  return NULL;
}

//If 'id' matches then creates a Replace Macro
void findCreateMacroMatch(char* id) {
  Macro* match = findMacroMatch(id);
  if(match != NULL) {
    createReplaceMacro(match);
    process_macro++;
  } else process_macro= 0;
}

//Finds if the Argument 'id' matches with anything in the replacement
Argument* findArgMatch(Node* to_match) {
  Argument* curr = test_tail->rep_arg_head;
  while(curr != NULL) {
    if(strcmp(curr->id, to_match->value) == 0) {
      return curr;
    }
    curr = curr->next;
  }

  return NULL;
}

//Creates a replacement linked list to go from 'replace_from' to 'replace_to'
Node* rep_head = NULL;
Node* rep_tail = NULL;

//Creates a duplicate of the given node from the linked list of tokens
void copyAndAddNode(Node* to_copy) {
  Node* nwNode = (Node*) malloc(sizeof(Node));
  nwNode->value = to_copy->value;
  
  if(rep_head == NULL) {
    rep_head = nwNode;
    rep_tail = nwNode;
    return;      
  } 

  nwNode->prev = rep_tail;
  rep_tail->next = nwNode;
  rep_tail = nwNode;
}

//Creates the replacement linked list
//and Replaces them
void replaceMacroFunc(ReplaceMacro* rep) {
  
  rep_head = NULL;
  rep_tail = NULL;

  Node* curr = rep->replace_macro->from;

  while(curr != NULL && curr != rep->replace_macro->to) {   
    Argument* match_arg = findArgMatch(curr);               //checking for argument match
    if(match_arg == NULL) copyAndAddNode(curr);
    else {
      Node* curr_node = match_arg->from;
      while(curr_node != NULL && curr_node != match_arg->to) {
        copyAndAddNode(curr_node);
        curr_node = curr_node->next;
      }
      if(curr_node != NULL) copyAndAddNode(curr_node);
    }
    curr = curr->next;
  }

  if(curr != NULL) {
    Argument* match_arg = findArgMatch(curr); 
    if(match_arg == NULL) copyAndAddNode(curr);
    else {
      Node* curr_node = match_arg->from;
      while(curr_node != NULL && curr_node != match_arg->to) {
        copyAndAddNode(curr_node);
        curr_node = curr_node->next;
      }
      if(curr_node != NULL) copyAndAddNode(curr_node);
    }
  }


  rep->replace_from->prev->next = rep_head;
  tail = rep_tail;

  //remove the processed Replace Macro from the list (useful in Macro in Macro)
  if(test_tail == test_head) {
    test_tail = NULL;
    test_head =NULL;
    process_macro = 0;
  } else {
    test_tail = test_tail->prev;
    free(rep);
  }
}

//variable to tell if the there is macro in macro
int in_mac = 0;

//debug function to print characters

/*uncomment and remove return */

/* it can be used to print character stream */

// void print(char* j) {
//   return;
//   printf("%s\n", j);
//   fflush(stdout);
// }

/* it can be used to print linked list from Node 1 to Node 2 */

// void printN(Node* a, Node* b) {
//   return;
//   Node* curr = a;

//   while(curr!=NULL && curr!=b) {
//     printf("%s", curr->value);
//     curr = curr->next;
//   }
//   if(curr!= NULL) printf("%s\n",curr->value);
// }

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
                    | {createAndAddMacro();} macro-definition macro-definition-loop
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

method-declaration-loop: /* empty string */
                    |   method-declaration-loop method-declaration
;

type-identifiers:  /* empty string */
                | type-identifiers type-identifier semi-colon
;

type-identifier:  type id
;

method-declaration: public type-identifier o-b type-identifiers-comma c-b o-c-b type-identifiers statements return expression semi-colon c-c-b
; 

type-identifiers-comma: /* empty string */
                      | type-identifier comma-type-identifiers
;

comma-type-identifiers: /*empty string */
                      | comma type-identifier comma-type-identifiers 
;

type: int o-s-b c-s-b
  | boolean
  | int 
  | id
;

statements: /* empty string */
          | statement statements
;

statement: o-c-b statements c-c-b
          | print o-b expression c-b semi-colon
          | id equal expression semi-colon
          | id o-s-b expression c-s-b equal expression semi-colon
          | if-statement
          | if-statement else statement
          | while o-b expression c-b statement 
          | id o-b {findCreateMacroMatch(tail->prev->value); 
                    if(process_macro) { 
                      test_tail->replace_from = tail->prev; 
                      rep_arg = test_tail->replace_macro->arg_head; 
                      test_tail->processed_arg = test_tail->replace_macro->arg_head;
                    }
                  } expressions-comma c-b semi-colon 
                  { if(process_macro) {
                      if(test_tail->processed_arg!=NULL) {
                        yyerror("error");
                      }
                      test_tail->replace_to = tail; 
                      replaceMacroFunc(test_tail); 
                      in_mac = 1;
                    }
                  }
;

if-statement: if o-b expression c-b statement
;

expressions-comma: /* empty string */
                | {if(process_macro) {
                    if(rep_arg == NULL) {
                      yyerror("error");
                    }
                    rep_arg->from = tail->prev; 
                    addRepArg(rep_arg);
                    } 
                  in_mac = 0;
                  } expression 
                  { if(process_macro) {
                      rep_arg = test_tail->rep_arg_tail; 
                      if(in_mac) rep_arg->to = tail;
                      else rep_arg->to = tail->prev; 
                      rep_arg->from = rep_arg->from->next; 
                      rep_arg = test_tail->processed_arg->next; 
                      test_tail->processed_arg = test_tail->processed_arg->next;
                    }
                  } comma-expressions
;

comma-expressions: /* empty string */
                | comma { if(process_macro) {
                            if(rep_arg == NULL) {
                              yyerror("error");
                            }
                            rep_arg->from = tail; 
                            addRepArg(rep_arg);
                          } 
                          in_mac = 0;
                        } expression 
                        { if(process_macro) {
                            rep_arg = test_tail->rep_arg_tail; 
                            if(in_mac) rep_arg->to = tail; 
                            else rep_arg->to = tail->prev;
                            rep_arg->from = rep_arg->from->next; 
                            rep_arg = test_tail->processed_arg->next; 
                            test_tail->processed_arg = test_tail->processed_arg->next;
                          } 
                        } comma-expressions
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
          | id o-b {findCreateMacroMatch(tail->prev->value); 
                    if(process_macro) {
                      test_tail->replace_from = tail->prev; 
                      rep_arg = test_tail->replace_macro->arg_head; 
                      test_tail->processed_arg = test_tail->replace_macro->arg_head;
                    }
                  } expressions-comma c-b 
                  { if(process_macro) {
                      if(test_tail->processed_arg!=NULL) {
                        yyerror("error");
                      }
                      test_tail->replace_to = tail; 
                      replaceMacroFunc(test_tail); 
                      in_mac = 1;
                    }
                  }
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

macro-definition: macro-def-expression {head = tail;}   /* removing macros from the printing list */
                | macro-def-statement {head = tail;}
;

macro-def-statement: define-stmt id {_temp->id = tail->value;} o-b id {addArg(tail->value);} comma id {addArg(tail->value);} comma id {addArg(tail->value);} comma-identifiers c-b o-c-b {_temp->from = tail;} statements c-c-b {_temp->to = tail->prev; _temp->from = _temp->from->next;}
                    | define-stmt-0 id {_temp->id = tail->value;} o-b c-b o-c-b {_temp->from = tail;} statements c-c-b {_temp->to = tail->prev; _temp->from = _temp->from->next;}
                    | define-stmt-1 id {_temp->id = tail->value;} o-b id {addArg(tail->value);} c-b o-c-b {_temp->from = tail;} statements c-c-b {_temp->to = tail->prev; _temp->from = _temp->from->next;}
                    | define-stmt-2 id {_temp->id = tail->value;} o-b id {addArg(tail->value);} comma id {addArg(tail->value);} c-b o-c-b {_temp->from = tail;} statements c-c-b {_temp->to = tail->prev; _temp->from = _temp->from->next;}
; 

macro-def-expression: define-expr id {_temp->id = tail->value;} o-b id {addArg(tail->value);} comma id {addArg(tail->value);} comma id {addArg(tail->value);} comma-identifiers c-b o-b {_temp->from = tail;} expression c-b {_temp->to = tail;}
                    | define-expr-0 id {_temp->id = tail->value;} o-b c-b o-b {_temp->from = tail;} expression c-b {_temp->to = tail;}
                    | define-expr-1 id {_temp->id = tail->value;} o-b id {addArg(tail->value);} c-b o-b {_temp->from = tail;} expression c-b {_temp->to = tail;}
                    | define-expr-2 id {_temp->id = tail->value;} o-b id {addArg(tail->value);} comma id {addArg(tail->value);} c-b o-b {_temp->from = tail;} expression c-b {_temp->to = tail;}
;

comma-identifiers: /* empty string */
                | comma id {addArg(tail->value);} comma-identifiers
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
  printf ("//Failed to parse input code\n");
  exit(1);
}

int main () {
  
  yyparse();
  
  /* Macro* mac_curr = _head;

  while(mac_curr != NULL) {
    printf("%s\n", mac_curr->id);
    Argument* arg_curr = mac_curr->arg_head;
    while(arg_curr != NULL) {
      printf("%s\n", arg_curr->id);
      arg_curr = arg_curr->next;
    }
    Node* temp = mac_curr->from;
    while(temp != NULL && temp != mac_curr->to) {
      printf("%s", temp->value);
      temp = temp->next;
    }
    if(temp != NULL) printf("%s\n", temp->value);
    mac_curr = mac_curr->next;
  } */

  Node* curr = head;

  while(curr != NULL) {
    printf("%s", curr->value);
    curr = curr->next;
  }

	return 0;
}

#include "lex.yy.c"