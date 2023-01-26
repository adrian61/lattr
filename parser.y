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
vector <int> id_vector; //wektor z
int lineno = 1;
symtable_t symtable;
%}

%token T_PROGRAM
%token T_VAR
%token T_BEGIN
%token T_END
%token T_WRITE
%token T_ASSIGN
%token T_INTEGER
%token T_REAL
%token ID
%token NUM
%token T_DIV
%token T_MOD

%%
/*nie terminal*/
start: program { file << "exit";
                 file.close();
               }
program:   T_PROGRAM ID '(' program_identifier_list ')' ';'
        declarations {
                      file.open("output.asm");
                      file << "jump.i #lab0" << endl << "lab0:"<< endl;
                     }
        compound_statement

program_identifier_list: ID | program_identifier_list ',' ID /* program x(in,out)*/

identifier_list: ID { id_vector.push_back($1); }
               | identifier_list ',' ID { id_vector.push_back($3); }

declarations: declarations T_VAR identifier_list ':' type ';' {
                                                                for(int i=0; i< (int) id_vector.size(); i++) {
                                                                 symtable[id_vector[i]].type=static_cast<vartype>($5);
                                                                 symtable[id_vector[i]].address = first_free_address;
                                                                 if (static_cast<vartype>($5) == integer){
                                                                  first_free_address += 4;}
                                                                 if (static_cast<vartype>($5) == real){
                                                                  first_free_address += 8;}
                                                                }
                                                                 id_vector.clear();
                                                              }
              | /* epsilon/empty */
type: T_INTEGER {$$ = integer; }
      | T_REAL {$$ = real;}

compound_statement : T_BEGIN optional_statements T_END '.' {}


optional_statements : statement
                | optional_statements ';' statement
                
statement: ID T_ASSIGN expression {//emit("id.place ':=' E.place");
                                  // $1 = $3
                                  gencode("mov", $3, $1, -1);
                                  }
           | T_WRITE '(' identifier_list ')' { for(int i=0; i< (int) id_vector.size(); i++) gencode("write", id_vector[i], -1, -1);
                                              id_vector.clear();
                                              }
expression: expression '+' expression {/*E.place = newtemp; */
                                      int newtemp = addtotable("$t",inputtype::temporary);
                                      // symtable[newtemp].value = symtable[$1].value + symtable[$3].value;
                                      // emit("id.place ':=' E1.place '+' E2.place");
                                      $$ = newtemp;
                                      gencode("add", $1, $3, newtemp);
                                      }
    | expression '*' expression {/*E.place = newtemp; */
                                int newtemp = addtotable("$t",inputtype::temporary);
                                // symtable[newtemp].value = symtable[$1].value * symtable[$3].value;
                                // emit("id.place ':=' E1.place '*' E2.place");
                                $$ = newtemp;
                                gencode("mul", $1, $3, newtemp);
                                }
    | expression T_DIV expression {/*E.place = newtemp; */
                                  int newtemp = addtotable("$t",inputtype::temporary);
                                  // symtable[newtemp].value = symtable[$1].value / symtable[$3].value;
                                  // emit("id.place ':=' E1.place '*' E2.place");
                                  $$ = newtemp;
                                  gencode("div", $1, $3, newtemp);
                                  }
    | expression T_MOD expression {/*E.place = newtemp; */
                                  int newtemp = addtotable("$t",inputtype::temporary);
                                  // symtable[newtemp].value = symtable[$1].value / symtable[$3].value;
                                  // emit("id.place ':=' E1.place '*' E2.place");
                                  $$ = newtemp;
                                  gencode("mod", $1, $3, newtemp);
                                  }
    | expression '-' expression {/*E.place = newtemp; */
                                int newtemp = addtotable("$t",inputtype::temporary);
                                // symtable[newtemp].value = symtable[$1].value * symtable[$3].value;
                                // emit("id.place ':=' E1.place '*' E2.place");
                                $$ = newtemp;
                                gencode("sub", $1, $3, newtemp);
                                }
    | '-' expression {/*E.place = newtemp; */
                      //emit("id.place 'uminus' E1.place");
                      int newtemp = addtotable("$t",inputtype::temporary);
                      int zerotemp = addtotable("0", inputtype::number);
                      symtable[zerotemp].value = 0;
                      symtable[zerotemp].type = integer;
                      $$ = newtemp;
                      gencode("sub", zerotemp, $2, newtemp);
                      }
    | '(' expression ')' {/*E.place = E1.place; */ $$=$2;}
    | ID  {/*E.place:=id.place;*/
            $$ = $1;}
    | NUM { $$ = $1;}



%%
void yyerror(char const *s) {
  printf("%d, %s\n", lineno, s);
  printtable();
  yylex_destroy();
  exit(1);
};


int main(){
  yyparse();
  printtable();
  yylex_destroy();
  exit(0);
};

void gencode(string mnemonic, int i1, int i2, int i3) //przekazuje indeksy w tablicy symboli
{

  string var1 = "", var2 = "", var3 = "", postfix ="";
  if(i1 >= 0)
    if (isdigit(symtable[i1].name[0])) {
      var1 = "#" + symtable[i1].name;
    }
    else var1 = to_string(symtable[i1].address);
  if(i2 >= 0)
   if (isdigit(symtable[i2].name[0])) {
      var1 = "#" + symtable[i2].name;
    }
    else var1 = to_string(symtable[i2].address);
  if(i3 >= 0)
   if (isdigit(symtable[i3].name[0])) {
      var1 = "#" + symtable[i3].name;
    }
    else var1 = to_string(symtable[i3].address);

  if (symtable[i1].type == integer) {
      postfix = ".i ";
    }
    else postfix = ".r ";
  
  file << mnemonic + postfix << var1 << var2 << var3 << endl;
}



int addtotable(const string& s, inputtype input_type) {
if (findintable(s) == -1) {
entry new_entry;
    switch(input_type) {
      case inputtype::identifier:
            new_entry.name = s;
            new_entry.address = 0;
            new_entry.value = -1;
            new_entry.type = none;
            symtable.push_back(new_entry);
            return symtable.size() - 1;
            break;
      case inputtype::number:
            new_entry.name = s;
            new_entry.value = stoi(s);
            new_entry.type = integer;
            symtable.push_back(new_entry);
            return symtable.size() - 1;
            break;
      case inputtype::temporary:
            new_entry.name = s + to_string(next_temporary);
            next_temporary +=1;
            new_entry.address = first_free_address;
            first_free_address += 4;
            new_entry.value = -1;
            new_entry.type = integer;
            symtable.push_back(new_entry);
            return symtable.size() - 1;
            break;
    }
    return -1;
}
else  return findintable(s);
return -1;
};

int findintable(const string& s)
{
int i;
for(i=0;i<symtable.size();i++)
  if(symtable[i].name==s)
    return i;
return -1;
};

void printtable(){
    string column_names[4] = {"name", "type", "value", "address"};
    for(int i=0; i<4; i++) cout << "|" << column_names[i] << "\t";
    cout << endl << string(50,'-') << endl;
    for(int i=0; i < (int)symtable.size(); i++) {
        string value, type, address;
        if (symtable[i].type == 0) type = "none";
        else if (symtable[i].type == 1) type = "int";
        else if (symtable[i].type == 2) type = "real";
        if (symtable[i].value == -1 ) value = "-";
        else value = to_string(symtable[i].value);
        if (symtable[i].address == -1) address = "-";
        else address = to_string(symtable[i].address);
        cout << "|" << symtable[i].name << "\t|" << type << "\t|" << value << "\t|" << address << endl;
    }
    cout<<endl;
}

