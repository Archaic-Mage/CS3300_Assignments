%{
int cnt_spaces = 0;
%}

%%

\t {cnt_spaces+=4;}
" " {cnt_spaces++;}
. {
    for(int i = 0; i<cnt_spaces; i++) {
        printf(" ");
    }
    cnt_spaces=0;
    printf("%s", yytext);
}
\n {printf("\n"); cnt_spaces = 0;}

%%

int main() {

    yylex();
    return 0;
}
