digit [0-9]
letter [a-zA-Z]
identifier {letter}({letter}|{digit}|_)*
integers {digit}+

%% 

"//".*[\n]" "*          { addE(createNode(strdup(yytext), 2)); }
"#defineStmt2"          { addE(createNode(strdup(yytext), 1));
                            return T_DS2;     }
"#defineStmt1"          { addE(createNode(strdup(yytext), 1));
                            return T_DS1;     }
"#defineStmt0"          { addE(createNode(strdup(yytext), 1));
                            return T_DS0;     }
"#defineStmt"           { addE(createNode(strdup(yytext), 1));
                            return T_DS;      }
"#defineExpr2"          { addE(createNode(strdup(yytext), 1));
                            return T_EXP2;    }
"#defineExpr1"          { addE(createNode(strdup(yytext), 1));
                            return T_EXP1;    }
"#defineExpr0"          { addE(createNode(strdup(yytext), 1));
                            return T_EXP0;    }
"#defineExpr"           { addE(createNode(strdup(yytext), 1));
                            return T_EXP;     }
"class"                 { addE(createNode(strdup(yytext), 1));
                            return T_CLASS;   }
"public"                { addE(createNode(strdup(yytext), 1));
                            return T_PUBLIC;  }
"void"                  { addE(createNode(strdup(yytext), 1));
                            return T_VOID;    }
"static"                { addE(createNode(strdup(yytext), 1));
                            return T_STATIC;  }
"main"                  { addE(createNode(strdup(yytext), 1));
                            return T_MAIN;    }  
"extends"               { addE(createNode(strdup(yytext), 1));
                            return T_EXTENDS; }
"new"                   { addE(createNode(strdup(yytext), 1));
                            return T_NEW;     }
"if"                    { addE(createNode(strdup(yytext), 1));
                            return T_IF;      }
"else"                  { addE(createNode(strdup(yytext), 1));
                            return T_ELSE;    }
"int"                   { addE(createNode(strdup(yytext), 1));
                            return T_INT;     }
"boolean"               { addE(createNode(strdup(yytext), 1));
                            return T_BOOL;    }
"String"                { addE(createNode(strdup(yytext), 1));
                            return T_STRING;  }
"return"                { addE(createNode(strdup(yytext), 1));
                            return T_RETURN;  }
"while"                 { addE(createNode(strdup(yytext), 1));
                            return T_WHILE;   }
"true"                  { addE(createNode(strdup(yytext), 1));
                            return T_TRUE;    }
"false"                 { addE(createNode(strdup(yytext), 1));
                            return T_FALSE;   }
"this"                  { addE(createNode(strdup(yytext), 1));
                            return T_THIS;    }
"length"                { addE(createNode(strdup(yytext), 1));
                            return T_LENGTH;  }
"."                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"+"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"-"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"*"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"/"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"&&"                    { addE(createNode(strdup(yytext), 1));
                            return T_AND;     }
"||"                    { addE(createNode(strdup(yytext), 1));
                            return T_OR;      }
"<="                    { addE(createNode(strdup(yytext), 1));
                            return T_SMALLEQ; }
"!="                    { addE(createNode(strdup(yytext), 1));
                            return T_NOTEQ;   }
"!"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"="                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
";"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
":"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
","                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"("                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
")"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"["                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"]"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"{"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"}"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"?"                     { addE(createNode(strdup(yytext), 1));
                            return yytext[0]; }
"System.out.println"    { addE(createNode(strdup(yytext), 1));
                            return T_PRINT; }
{identifier}            { addE(createNode(strdup(yytext), 1));
                            yylval.id = strdup(yytext);
                            return T_ID;      }
{integers}              { addE(createNode(strdup(yytext), 1));
                            yylval.num = atoi(yytext);
                            return T_NUM;     }
.                       { addE(createNode(strdup(yytext), 2)); }
\n                      { addE(createNode(strdup(yytext), 2)); }
%%