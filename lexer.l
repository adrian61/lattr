%{
#include "symtable.h"
#include "parser.hpp"
%}

%option noyywrap

ID	[a-z][a-z0-9]*

%%
[ \n\t] {}
integer	{return T_INTEGER;}
real	{return T_REAL;}
{ID}	{yylval=addtotable(string(yytext,yyleng));return ID;}
.	{return yytext[0];}

%%