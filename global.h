#include <string>

using namespace std;

int yylex(); //zwraca wartość zwracającą typ tokenu
int yylex_destroy(); //free resources used by the scanner.
void yyerror(char const *); //obsluga błędów
void gencode(string, int, int,int); //generacja kodu