CC = gcc

OBJECTS = lex.yy.o flights.tab.o

flights: $(OBJECTS)
	$(CC) $(OBJECTS)  -o flights


lex.yy.c: flights.lex
	flex flights.lex
	
flights.tab.c flights.tab.h: flights.y
	bison -d flights.y
	
lex.yy.o: lex.yy.c flights.tab.h

flights.tab.o: flights.tab.c

clean:
	rm -f flights flights.tab.c flights.tab.h lex.yy.c $(OBJECTS)
	
	