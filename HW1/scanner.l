%{
    #include <stdio.h>
    char *record[300];
    int i = 0;
    int num_line = 0;
    int source = 1;
    int token = 1;
%}

key     for|do|while|break|continue|if|else|return|struct|switch|case|default|void|int|double|float|char|const|signed|unsigned|short|long
macros  NULL|__COUNTER__|__LINE__|INT_MAX|INT_MIN|CHAR_MAX|CHAR_MIN|MAX|MIN
id      [[:alpha:]_][[:alnum:]_]*
op      "+"|"-"|"*"|"/"|"%"|"++"|"--"|"<"|"<="|">"|">="|"=="|"!="|"="|"&&"|"||"|"!"|"&"|"|"
punc    ":"|";"|","|"."|"["|"]"|"("|")"|"{"|"}"
int     [\+-]?[[:digit:]]+
float   [\+-]?[[:digit:]]*\.[[:digit:]]*
char    \'.\'
str     \".*\"
comm    "//".*

%x COMMENT

%%
\n        {record[i] = yytext; ++num_line; if(source) {printf("%d:%s", num_line, record[0]);} memset(record, 0, 300); i = 0;}
{key}     {record[i] = yytext; i++; if(token) {printf("#%s:%s\n", "key", yytext);}}
{macros}  {record[i] = yytext; i++; if(token) {printf("#%s:%s\n", "macro", yytext);}}
{id}      {record[i] = yytext; i++; if(token) {printf("#%s:%s\n", "id", yytext);}}
{op}      {record[i] = yytext; i++; if(token) {printf("#%s:%s\n", "op", yytext);}}
{punc}    {record[i] = yytext; i++; if(token) {printf("#%s:%s\n", "punc", yytext);}}
{int}     {record[i] = yytext; i++; if(token) {printf("#%s:%s\n", "integer", yytext);}}
{float}   {record[i] = yytext; i++; if(token) {printf("#%s:%s\n", "float", yytext);}}
{char}    {record[i] = yytext; i++; if(token) {printf("#%s:%s\n", "char", yytext);}}
{str}     {record[i] = yytext; i++; if(token) {printf("#%s:%s\n", "string", yytext);}}
{comm}    {record[i] = yytext; i++;}

" "              {record[i] = yytext; i++;}
"/*"             {record[i] = yytext; i++; BEGIN COMMENT;}
<COMMENT>"*/"    {record[i] = yytext; i++; BEGIN 0;}
<COMMENT>.       {record[i] = yytext; i++;}
<COMMENT>\n      {record[i] = yytext; ++num_line; if(source) {printf("%d:%s", num_line, record[0]);} memset(record, 0, 300); i = 0;} 
 
"#pragma".*"source".*"off".*    {record[i] = yytext; i++; source = 0;}
"#pragma".*"source".*"on".*     {record[i] = yytext; i++; source = 1;}
"#pragma".*"token".*"off".*     {record[i] = yytext; i++; token = 0;}
"#pragma".*"token".*"on".*      {record[i] = yytext; i++; token = 1;}

%%

int main(int argc, char* argv[]){
    yylex();
    return 0;
}