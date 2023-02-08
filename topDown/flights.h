#ifndef FLIGHTS

#define GENERAL_SIZE 50
// yylex returns 0 when EOF is encountered
enum token {
     DEPARTURES = 1, 
     FLIGHTNUMBER,
     TIME,
     AIRPORT,
     CARGO, 
     FREIGHT,
     COMMA
     
};

char *token_name(enum token token);

enum timeOfDay { AM, PM };

// semantic values for tokens
union _lexVal{
    char flightType[GENERAL_SIZE]; // semantic value for flightType
    enum timeOfDay time; // semantic value for TIME
};

extern union _lexVal lexicalValue;// like yylval when we use bison

void errorMsg(const char *s);

#endif
