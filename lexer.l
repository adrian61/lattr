%{
#include "symtable.h"
#include "parser.hpp"
extern int lineno;
%}

%option noyywrap

ID	[a-z][a-z0-9]*


%%
[ \t\r] {}
[\n]    {lineno++;}
program { return T_PROGRAM; }
begin   { return T_BEGIN; }
end     { return T_END; }
var     { return T_VAR; }
integer	{ return T_INTEGER; }
real	{ return T_REAL; }
":="    { return T_ASSIGN; }
{ID}	{ yylval=addtotable(string(yytext,yyleng), inputtype::identifier);
          return ID; }
.	    { return yytext[0]; }

%%