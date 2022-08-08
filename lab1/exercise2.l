LETTERS [a-zA-Z]
DIGIT [0-9]
ID {LETTERS}({LETTERS}|{DIGIT})*
INTEGERS [+-]?{DIGIT}+
DECIMALS ({INTEGERS}?"."{DIGIT}+)|({INTEGERS}"."[{DIGIT}+]?)
REALS ({INTEGERS}|{DECIMALS})[eE]{INTEGERS}


%%

{ID}
{INTEGERS} {printf("INTEGER: %s\n", yytext);}
{DECIMALS} {printf("DECIMAL: %s\n", yytext);}
{REALS} {printf("REAL: %s\n", yytext);}
.
\n


%%

int main() {
    yylex();
    return 0;
}
