%{
#include "symtable.h"
u_int32_t first_free_address = 0;
%}

%token T_INTEGER
%token T_REAL
%token ID

%%
start: prog {for(int i=0;i<symtable.size();i++) cout << symtable[i].name<< " " <<symtable[i].type << " " << symtable[i].address <<endl;};
prog:   decl ';' prog 
     |  decl ';'

decl: ID list {symtable[$1].type=(vartype)$2; symtable[$1].address= first_free_address;
if( $2 == integer) first_free_address+=4;
else if ($2 == real) first_free_address+=8;
else cout << "error";

}
list: ',' ID list {$$ = $3; symtable[$2].type=(vartype)$3; symtable[$2].address= first_free_address;
if( $3 == integer) first_free_address+=4;
else if ($3== real) first_free_address+=8;}
     | ':' type {$$=$2;}
type: T_INTEGER {$$ = integer;}
      | T_REAL {$$ = real;}

%%
void yyerror(char const *s) {
  printf("%s\n",s);
};

int main(){
  yyparse();
};

symtable_t symtable;

int addtotable(const string& s)
{
int i;
for(i=0;i<symtable.size();i++)
  if(symtable[i].name==s)
    return i;
entry d;
d.name=s;
d.type=none;
symtable.push_back(d);
return i;
};

int findintable(const string& s)
{
int i;
for(i=0;i<symtable.size();i++)
  if(symtable[i].name==s)
    return i;
return -1;
};
