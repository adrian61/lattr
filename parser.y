%{
// obsluzyc instrukcje write
// oprocz id, liczby w tablicy symboli, czyli pole okreslajace, co jest przechowywane w tablicy symboli
// emit gdy cos jest zmienna to tryb adresowania bezposredniego, gdy stala liczba tryb adresowania natychmiastowego (czyli z #)
// gencode( const string *mnemonic, int index_var1, int index_var2, int index_var3);
// funkcja okresla typ - nie musi, bo wszystko ma byc integer
#include "global.h"
#include "symtable.h"
u_int32_t first_free_address = 0;
%}

%token T_INTEGER
%token T_REAL
%token ID
%token T_ASSIGN

%%
start: prog {for(int i=0;i<symtable.size();i++) cout << symtable[i].name<< " " <<symtable[i].type << " " << symtable[i].address <<endl;};
prog:   decl ';' prog 
     |  decl ';'
     | opt_s

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
opt_s: s
    | opt_s ';' s
s: ID T_ASSIGN e {emit("id.place ':=' E.place");}
e: e '+' e {/*E.place = newtemp; */
            emit("id.place ':=' E1.place '+' E2.place");}
    | e '*' e {/*E.place = newtemp; */
                emit("id.place ':=' E1.place '*' E2.place");}
    | '-' e {/*E.place = newtemp; */
                emit("id.place 'uminus' E1.place");}
    | '(' e ')' {emit("();");/*E.place = E1.place; */}
    | ID  {emit("id");/*E.place:=id.place;*/}



%%
void yyerror(char const *s) {
  printf("%s\n",s);
};

void emit(string s){
cout << s << endl;
}

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


