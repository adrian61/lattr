#include <string>

using namespace std;

int yylex();
int yylex_destroy();
void yyerror(char const *);
void emit(string);