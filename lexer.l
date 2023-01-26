%{
#include "symtable.h"
#include "parser.hpp"
extern int lineno;
%}

%option noyywrap

ID	[a-z]({NUM}|[a-z])*
NUM  [0-9]+


%%
[ \t\r] {}
[\n]    {lineno++;}
begin   { return T_BEGIN; }
end     { return T_END; }
program { return T_PROGRAM; }
write   { return T_WRITE; }
var     { return T_VAR; }
integer	{ return T_INTEGER; }
real	{ return T_REAL; }
":="    { return T_ASSIGN; }
{ID}	{ yylval=addtotable(string(yytext,yyleng), inputtype::identifier); return ID;}
{NUM}   {yylval=addtotable(string(yytext,yyleng), inputtype::number); return NUM;}
.	    { return yytext[0]; }

%%