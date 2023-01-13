%{
#include "symtable.h"
%}

%token INT
%token REAL
%token ID

%%
start: prog {for(int i=0;i<symtable.size();i++) cout << symtable[i].name<< " " <<symtable[i].type<<endl;};
prog:   decl ';' prog 
     |  decl ';'
decl:   type list;
type:   INT  {$$=integer;}
   |    REAL {$$=real;}
list:   list ',' ID {symtable[$3].type=(vartype)$0;}
   |    ID {symtable[$1].type=(vartype)$0;}

%%
void yyerror(char const *s)
{
  printf("%s\n",s);
};

int main()
{
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
