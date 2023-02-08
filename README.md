# Compilation_flex_bison_recursiveDescentParser
> The project was built in C , Flex & Bison

### `Description `
---
The program reads input information about departing flights.
And prints a message comparing the number of flights departing "before noon" to the number of flights departing "after noon". Cargo flights are not taken into account.

##### `input` 
---
> flights_input.txt file

The input includes information about outgoing flights.

```
<departures>
  
LY1 00:10a.m. "JFK"  
  
BA289 10:15p.m. "Heathrow" cargo 
  
AF1234 03:20p.m. "Charles de Gaulle"
  
OP78 05:37a.m. "Athens" freight
  
AA17 11:00a.m. "LAX"
  
 ```
#### `A list of the types of tokens that the lexical analyzer should recognize.`
--- 
| example for lexeme | Token Type |
| ----------- | ----------- |
| < departures > | DEPARTURES |
| LY1 AF1234 | FLIGHT_NUMBER |
| 00:10a.m. 10:15p.m. | TIME |
| “JFK” “Charles de Gaulle”| AIRPORT |
| cargo | CARGO |
| freight | FREIGHT |


##### `Output` 
---
### BottomUp Version
<img width="570" alt="Screenshot 2023-02-08 at 19 55 06" src="https://user-images.githubusercontent.com/72464761/217612654-20615ede-b6a9-4f44-9c84-914552168c2a.png">



### TopDown Version
<img width="570" alt="Screenshot 2023-02-08 at 19 53 00" src="https://user-images.githubusercontent.com/72464761/217612066-71fafa2c-f291-4eff-82c4-5aa93737577d.png">




##### `Steps for running the program` 
---
 ```
1. flex flights.lex 
A lex.yy.c file will be created
2. bison -d flights.y
A flights.tab.h and flights.tab.c files will be created
 ```
