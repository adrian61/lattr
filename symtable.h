#include <string>
#include <vector>
#include <iostream>

using namespace std;

enum vartype {none, integer, real};
struct entry {
string name;
vartype type;
};

typedef vector<entry> symtable_t;

extern symtable_t symtable;

int addtotable(const string& s);
int findintable(const string& s);

int yylex();
void yyerror(char const *);
