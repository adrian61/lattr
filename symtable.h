#include <string>
#include <vector>
#include <iostream>

using namespace std;

enum vartype {none, integer, real};
struct entry {
string name;
vartype type;
u_int32_t address; //zmiena 32 bitowa - obsluga real 8 bajtów
};

typedef vector<entry> symtable_t;

extern symtable_t symtable;

int addtotable(const string& s);
int findintable(const string& s);

