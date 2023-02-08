%{

#include <string.h>
#include <stdio.h>

#include "flights.h"

union _lexVal lexicalValue; // semantic value of current token

%}

/* it give us the option to continue to the next filen */
%option noyywrap 
/* tell as what the number of line */

%option yylineno 

/* exclusive start condition -- deals with C++ style comments */
%x STAR_COMMENT


%%

\<departures> { return DEPARTURES; } //example for <intial>

[A-Z]{2}[A-Za-z0-9]{1,4} {  return FLIGHTNUMBER; }

((1[0-2]{1})|(0[0-9]{1})):([0-5]{1}[0-9]{1})[ap]\.m\. { 
			char* timeStat = strstr(yytext, "a.m");
			if(timeStat)
	                            lexicalValue.time = AM;
			else
			    lexicalValue.time = PM;

			return TIME;}

\"[A-Za-z][A-Za-z ]*\"  {    return AIRPORT; }

[c][a][r][g][o] { strcpy (lexicalValue.flightType, yytext); return CARGO; }

[f][r][e][i][g][h][t] { strcpy (lexicalValue.flightType, yytext); return FREIGHT; }

[\n\t\r ]+  /* skip white space */

"/*"        { BEGIN(STAR_COMMENT); }
<STAR_COMMENT>.  { /* skip character inside comment */ }
<STAR_COMMENT>"*/" { BEGIN(0); }

"//".*      { /* skip comment starting with "//" */ }

.         { char e[100];
            sprintf(e, "unrecognized token %c(%x)", yytext[0], yytext[0]);  
            errorMsg(e);  
            exit(1);
          }
%%
/* useful for error messages */
char *token_name(enum token token)
{
    static char *names[] = {
		"EOF", "DEPARTURES", "FLIGHTNUMBER", "TIME", "AIRPORT",
        "CARGO", "FREIGHT" };  
 
    return token <= COMMA ? names[token] : "unknown token";
}



