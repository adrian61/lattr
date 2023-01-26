#include <string>

using namespace std;

int yylex();
int yylex_destroy();
void yyerror(char const *);
void emit(char const *s);
void gencode(string, int, int,int);