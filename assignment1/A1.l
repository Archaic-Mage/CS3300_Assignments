digit [0-9]
letter [a-zA-z]
indentifier {letter}({letter}|{digit})*
integers [-+]?{digit}+


%% 

"#defineStmt2"  { return T_DS2;     }
"#defineStmt1"  { return T_DS1;     }
"#defineStmt0"  { return T_DS0;     }
"#defineStmt"   { return T_DS;      }
"#defineExpr2"  { return T_EXP2;    }
"#defineExpr1"  { return T_EXP1;    }
"#defineExpr0"  { return T_EXP0;    }
"#defineExpr"   { return T_EXP;     }
"class"         { return T_CLASS;   }
"public"        { return T_PUBLIC;  }
"private"       { return T_PRIVATE; }
"protected"     { return T_PROTECTED;}
"void"          { return T_VOID;    }
"static"        { return T_STATIC;  }
"main"          { return T_MAIN;    }  
"extends"       { return T_EXTENDS; }
"new"           { return T_NEW;     }
"if"            { return T_IF;      }
"else"          { return T_ELSE;    }
"int"           { return T_INT;     }
"boolean"       { return T_BOOL;    }
"String"        { return T_STRING;  }
"return"        { return T_RETURN;  }
"while"         { return T_WHILE;   }
"true"          { return T_TRUE;    }
"false"         { return T_FALSE;   }
"this"          { return T_THIS;    }
"+"             { return yytext[0]; }
"-"             { return yytext[0]; }
"*"             { return yytext[0]; }
"/"             { return yytext[0]; }
"&&"            { return T_AND;     }
"||"            { return T_OR;      }
">"             { return T_GREAT;   }
">="            { return T_GREATEQ; }
"<"             { return T_SMALL;   }
"<="            { return T_SMALLEQ; }
"=="            { return T_COMPARE; }
"!="            { return T_NOTEQ;   }
"!"             { return yytext[0]; }
"="             { return yytext[0]; }
";"             { return yytext[0]; }
":"             { return yytext[0]; }
","             { return yytext[0]; }
"("             { return yytext[0]; }
")"             { return yytext[0]; }
"["             { return yytext[0]; }
"]"             { return yytext[0]; }
"{"             { return yytext[0]; }
"}"             { return yytext[0]; }
"?"             { return yytext[0]; }
"System.out.println" { return T_PRINT; }
{indentifier}   { yylval.id = yytext;
                  return T_ID;      }
{integers}      { yylval.num = atoi(yytext);
                  return T_NUM;     }

%%

int main() {
    yylex();
    return 0;
}

