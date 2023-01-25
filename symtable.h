#include <string>
#include <vector>
#include <iostream>

using namespace std;

enum vartype {none, integer, real};
enum class inputtype {identifier = 0, number = 1, temporary = 2};
struct entry {
string name;
vartype type;
int value;
u_int32_t address; //zmiena 32 bitowa - obsluga real 8 bajtów
};

typedef vector<entry> symtable_t;

extern symtable_t symtable;

int addtotable(const string& s, inputtype input_type);
int findintable(const string& s);

