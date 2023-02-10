%code {
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex(void);
void yyerror (const char *msg);
}

%code requires {
enum timeOfDay { AM, PM };
#define GENERAL_SIZE 50


struct max_count 
{
    int countAm;  // numbers of before noon flights
    int countPm;  // numbers of after noon flights     
};

} /* code requires */


%union {
  struct max_count max_count;
  char departures[GENERAL_SIZE]; 
  char flightNumber[GENERAL_SIZE];
  char airport[GENERAL_SIZE];
  char flightType[GENERAL_SIZE];
  enum timeOfDay time;
}


%token <departures> DEPARTURES
%token <time> TIME
%token <flightNumber> FLIGHTNUMBER
%token <airport> AIRPORT
%token <flightType> CARGO FREIGHT


%nterm <max_count> list_of_flights
%nterm <time> flight
%nterm <flightType> cargo_spec



%define parse.error verbose

/* %error-verbose */
%%


input: DEPARTURES list_of_flights
{	
	if($2.countAm > $2.countPm)
	{
	   printf("There were more flights before noon.\n");
	}
	else if($2.countAm < $2.countPm) 
	{
	   printf("There were more flights after noon.\n");
	}
};


list_of_flights: list_of_flights flight
{
	
	if($2 == AM) 
	{
	    $$.countAm =$$.countAm + 1;
	}
	else if($2 == PM) 
	{
	    $$.countPm = $$.countPm + 1;	  
	}
};


list_of_flights: %empty
	 { $$.countAm = 0; $$.countPm = 0; };


flight: FLIGHTNUMBER TIME AIRPORT cargo_spec
{
	if(strcmp($4,"NULL") == 0)
	{
	$$ = $2;
	} 
};


cargo_spec: 
   CARGO { strcpy($$ , $1); }
 | FREIGHT {strcpy($$ , $1); }
 | %empty {strcpy($$ , "NULL"); };
	
	
%%
int main (int argc, char **argv)
{
   extern FILE *yyin; // defined by flex
   if (argc != 2) {
      fprintf(stderr, "Usage: %s <input file name>\n", argv [0]);
      exit (1);
   }

   yyin = fopen (argv[1], "r");
   if (yyin == NULL) { fprintf(stderr, "failed to open file %s\n", argv[1]); exit(1);}

   yyparse();
   
   fclose (yyin);
   exit (0);
}

void yyerror (const char *msg){
    extern int yylineno; // defined by flex
	fprintf(stderr, "line %d: %s\n", yylineno, msg);
}
	

