
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "flights.h"
 
extern enum token yylex (void);
enum token lookahead;


struct max_count 
{
    int countAm;  // numbers of flights before noon 
    int countPm;  // numbers of flights after noon      
};


// the recursive descent parser
void start();
struct max_count list_of_flights();
enum timeOfDay flight();
char* cargo_spec();

void match(enum token expectedToken)
{
    if (lookahead == expectedToken)
        lookahead = yylex();
    else {
        char e[100]; 
        sprintf(e, "error: expected token %s, found token %s", 
                token_name(expectedToken), token_name(lookahead));
        errorMsg(e);
        exit(1);
    }
}

void parse()
{
    lookahead = yylex();
    start();
    if (lookahead != 0) {  // 0 means EOF
        errorMsg("EOF expected");
        exit(1);
    }
}

void 
start()
{
	//  start -> DEPARTURES list_of_flights
    match(DEPARTURES);
    struct max_count mc = list_of_flights();
    if (mc.countAm > mc.countPm) 
        printf("There were more flights before noon.\n");
    else if(mc.countAm < mc.countPm) 
	{
	   printf("There were more flights after noon.\n");
	}
}


  
struct max_count
list_of_flights() //list_of_flights -> list_of_flights flight
{
    enum timeOfDay tempTime;
    struct max_count mc = {0, 0};
    while (lookahead == FLIGHTNUMBER) 
    {
	    tempTime = flight(); 
		if(tempTime == AM) 
		 {
	      	 	mc.countAm =mc.countAm + 1;
		 }
		else if(tempTime == PM) 
		 {
	       		mc.countPm = mc.countPm + 1;	  
		 }
    }
    return mc;
}

enum timeOfDay
flight() // flight -> FLIGHTNUMBER TIME AIRPORT cargo_spec
{
    enum timeOfDay time;
    match(FLIGHTNUMBER);
	   
	if (lookahead == TIME)
	{
		time = lexicalValue.time;
	}
	
    match(TIME);
    match(AIRPORT);
    char* type = cargo_spec(); //maybe problem

	if(strcmp(type,"NULL") == 0)
	{
		return lexicalValue.time;
	}
}


// returns flightType of flight 
char* cargo_spec() {

	char* res= "NULL";

	if (lookahead == CARGO)
	{
		res = lexicalValue.flightType;
		match(CARGO);
	} 
	else if(lookahead == FREIGHT)
	{
		res = lexicalValue.flightType;
		match(FREIGHT);

	} 
	return res;
}


int
main (int argc, char **argv)
{
    extern FILE *yyin; // defined by flex
    if (argc != 2) {
       fprintf (stderr, "Usage: %s <input-file-name>\n", argv[0]);
	   return 1;
    }
    yyin = fopen (argv [1], "r");
    if (yyin == NULL) {
       fprintf (stderr, "failed to open %s\n", argv[1]);
	   return 2;
    }
  
    parse();
  
    fclose (yyin);
    return 0;
}

void errorMsg(const char *s)
{
  extern int yylineno; // defined by flex
  fprintf (stderr, "line %d: %s\n", yylineno, s);
}
