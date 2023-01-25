%{
// obsluzyc instrukcje write
// oprocz id, liczby w tablicy symboli, czyli pole okreslajace, co jest przechowywane w tablicy symboli
// emit gdy cos jest zmienna to tryb adresowania bezposredniego, gdy stala liczba tryb adresowania natychmiastowego (czyli z #)
// gencode( const string *mnemonic, int index_var1, int index_var2, int index_var3);
// funkcja okresla typ - nie musi, bo wszystko ma byc integer
#include "global.h"
#include "symtable.h"
#include <fstream>
u_int32_t first_free_address = 0;
int next_temporary = 0;
ofstream file;
vector <int> id_vector;
int lineno = 1;
%}

%token T_INTEGER
%token T_REAL
%token ID
%token T_ASSIGN
%token T_PROGRAM
%token T_VAR
%token T_BEGIN
%token T_END

%%
start: program { file << "exit";
                 file.close();
               }
program:   T_PROGRAM ID '(' identifier_list ')' ';'
        declarations {
                      file.open("output.asm");
                      file << "jump.i #lab0" << endl << "lab0:"<< endl;
                     }
        compound_statement

identifier_list: ID { id_vector.push_back($1);
                      cout << $1 << endl;
                     }
               | identifier_list ',' ID {id_vector.push_back($3); cout << $3 << endl;}

declarations: declarations T_VAR identifier_list ':' type ';' {
                                                                for(int i=0; i< (int) id_vector.size(); i++)
                                                                {
                                                                  
                                                                  if($5 == integer)
                                                                    first_free_address += 4;
                                                                    symtable[id_vector[i]].type = integer;
                                                                    symtable[id_vector[i]].address = first_free_address;
                                                                  if($5 == real)
                                                                    first_free_address += 8;
                                                                    symtable[id_vector[i]].type = real;
                                                                    symtable[id_vector[i]].address = first_free_address;
                                                                }
                                                                 id_vector.clear();
                                                              }
              | /* epsilon/empty */ {}
type: T_INTEGER {$$ = integer;}
      | T_REAL {$$ = real;}

compound_statement : T_BEGIN optional_statements T_END '.'

optional_statements : statement_list
                      |

statement_list : statement
                | statement_list ';' statement


statement: ID T_ASSIGN e {emit("id.place ':=' E.place");}
e: e '+' e {/*E.place = newtemp; */
              int newtemp = addtotable("$t",inputtype::temporary);
               symtable[newtemp].value = symtable[$1].value + symtable[$3].value;
                emit("id.place ':=' E1.place '+' E2.place");
                }
    | e '*' e {/*E.place = newtemp; */
              int newtemp = addtotable("$t",inputtype::temporary);
               symtable[newtemp].value = symtable[$1].value * symtable[$3].value;
                emit("id.place ':=' E1.place '*' E2.place");
                }
    | '-' e {/*E.place = newtemp; */
              int newtemp = addtotable("$t",inputtype::temporary);
                emit("id.place 'uminus' E1.place");}
    | '(' e ')' {emit("();");/*E.place = E1.place; */}
    | ID  {emit("id");/*E.place:=id.place;*/}



%%
void yyerror(char const *s) {
  printf("%d, %s\n", lineno, s);
};

void emit(string s){
cout << s << endl;
}

int main(){
  yyparse();
};

symtable_t symtable;

int addtotable(const string& s, inputtype input_type) {
if (findintable(s) == -1) {

entry new_entry;
    switch(input_type) {
      case inputtype::identifier:
            new_entry.name = s;
            new_entry.address = 0;
            // new_entry.value = -1;
            symtable.push_back(new_entry);
            return symtable.size() - 1;
            break;
      case inputtype::temporary:
            new_entry.name = s +to_string(next_temporary);
            next_temporary +=1;
            new_entry.address = first_free_address;
            first_free_address +=4;
            new_entry.value = -1;
            new_entry.type = integer;
            symtable.push_back(new_entry);
            return symtable.size() - 1;
            break;
    }
    return -1;
}
else findintable(s);
return -2;
};

int findintable(const string& s)
{
int i;
for(i=0;i<symtable.size();i++)
  if(symtable[i].name==s)
    return i;
return -1;
};


