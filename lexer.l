%{
#include "symtable.h"
#include "parser.hpp"
extern int lineno; //zmienna zdefiniowana w innym miejscu
%}

%option noyywrap

ID	[a-z]({NUM}|[a-z])*
NUM  [0-9]+


%%
[ \t\r] {}
[\n]    {lineno++;} /* nowa linia - do obslugi bledow */
begin   { return T_BEGIN; }
end     { return T_END; }
program { return T_PROGRAM; }
write   { return T_WRITE; }
var     { return T_VAR; }
integer	{ return T_INTEGER; }
real	{ return T_REAL; }
":="    { return T_ASSIGN; }
"/"|div { return T_DIV; }

mod|"%" { return T_MOD;}
{ID}	{ yylval=addtotable(yytext, inputtype::identifier); return ID;} /* id yylval= value associated with token*/
{NUM}   {yylval=addtotable(yytext, inputtype::number); return NUM;} /* num */
.	    { return yytext[0]; } /* Pojedynczy nierozpoznany znak poza nowa linia. */

%%

/* https://www.epaperpress.com/lexandyacc/prl.html */