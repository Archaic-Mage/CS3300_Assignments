%{
int to_map = 0;
int done[2] = {0, 0};
char from[8][65];
char to[8][65];
int maps = 0;
%}

DIGIT [0-9]
LETTER [a-zA-Z]
ID {LETTER}({LETTER}|{DIGIT})*

%%

"#define" {to_map = 1;} 
{ID} {
    if(to_map) {
        if(!done[0]) {
            int i = 0;
            while(yytext[i] != '\0') {
                from[maps][i] = yytext[i];
                i++;
            }
            done[0] = 1;
        } else {
            int i = 0; 
            while(yytext[i] != '\0') {
                to[maps][done[1]] = yytext[i];
                i++;
                done[1]++;
            }
        }
    } 
    else {
        
        int is_eq = 1;
        for(int i = 0; i<maps; i++) {
            is_eq = 1;
            for(int j = 0; j<=yyleng; j++) {
                if(from[i][j] != yytext[j]) {
                    is_eq = 0;
                    break;
                }
            } 
            if(is_eq) {
                int j = 0;
                while(to[i][j] != '\0') {
                    printf("%c", to[i][j]);
                    j++;
                }
                printf("%c", to[i][j]);
                break;
            }
        }     
        if(!is_eq) printf("%s", yytext);
    }
}
. {
    if(to_map) {

     if(done[1]) {
        to[maps][done[1]] = yytext[0];
        done[1]++;
     } else {
        if(yytext[0] != ' ') {
            to[maps][done[1]] = yytext[0];
            done[1]++;
            }
        } 
    } else printf("%s", yytext);
}

\n {
    if(to_map) {
        to[maps][done[1]] = '\0';
        maps++;
        to_map = 0;
        done[0] = 0;
        done[1] = 0;
    }

    printf("\n");
}
%%
int main() {
    yylex();
    return 0;
}
