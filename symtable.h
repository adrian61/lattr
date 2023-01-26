#include <string>
#include <vector>
#include <iostream>

using namespace std;

enum vartype {none=0, integer=1, real=2}; //obsluga real jest zbedna na tym etapie kompilatora
enum class inputtype {identifier = 0, number = 1, temporary = 2};
struct entry {
string name;
vartype type = none;
int value = 0;
int32_t address = -1; //zmiena 32 bitowa - obsluga real 8 bajtów, powinno być u_int32_t, ale na potrzeby implementacji address -1 jest jako NULL
};

typedef vector<entry> symtable_t;

extern symtable_t symtable;

int addtotable(const string& s, inputtype input_type);
int findintable(const string& s);
void printtable();

