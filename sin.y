// https://www.gnu.org/software/bison/manual/html_node/Precedence-Decl.html#Precedence-Decl
// https://www.gnu.org/software/bison/manual/html_node/Token-Decl.html
// https://www.tiendalinux.com/docs/manuales/bison/bison-es-1.27.html

// Por contemplar q una variable pueda ser el resultado de llamar a una función
// Parentesis en operaciones

%{
  #include <stdio.h>
  #include "table_manager.c"
  extern FILE *yyin; 
  extern int numlin; 
  int yydebug=1; 
  void yyerror (char const*);
%}

%union { int number; char* string;}

%token <number> NUMBER
%token <number> INT
%token <number> EQUAL
%token <number> NOTEQUAL
%token <number> GREATER
%token <number> MINOR
%token <number> GREATEREQUAL
%token <number> MINOREQUAL
%token <number> OPPOSITE
%token <number> IF
%token <number> ELSE
%token <number> WHILE
%token <number> OPENINGCURLYBRACKET
%token <number> CLOSINGCURLYBRACKET
%token <number> OPENINGBRACKET
%token <number> CLOSINGBRACKET
%token <number> PRINT
%token <number> RETURN
%token <number> FUNC
%token <number> COMMA
%token <number> SEMICOLON
%token <number> BREAK
%token <string> STRING
%token <string> VARIABLE
%token <string> FUNCNAME
%token <string> TEXT

%type <number> root
%type <number> declaration
%type <number> function
%type <number> params
%type <number> codeSet
%type <number> instruction
%type <number> assignation
%type <number> aritmeticOperation
%type <number> return
%type <number> print
%type <number> printableElement
%type <number> text
%type <number> controlStructure
%type <number> structuresWord
%type <number> logicalOperation
%type <number> logicalOperator
%type <number> logicalElement

%left '-' '+'
%left '*' '/'

//Donde haya { openScope() y closeScope }

%%

root : declaration 
     | function
     ;

declaration : INT VARIABLE SEMICOLON
            ;

function : INT VARIABLE OPENINGBRACKET params CLOSINGBRACKET OPENINGCURLYBRACKET codeSet CLOSINGCURLYBRACKET
         ;

params : INT VARIABLE COMMA params
       | INT VARIABLE 
       ;

codeSet : declaration 
        | instruction
        | controlStructure
        | codeSet codeSet
        ;

instruction : assignation SEMICOLON
            | aritmeticOperation SEMICOLON
            | return SEMICOLON
            | print SEMICOLON
            | BREAK SEMICOLON
            ;

assignation : VARIABLE '=' NUMBER 
            ;  

aritmeticOperation : aritmeticOperation '-' aritmeticOperation
            | aritmeticOperation '+' aritmeticOperation
            | aritmeticOperation '*' aritmeticOperation
            | aritmeticOperation '/' aritmeticOperation
            | '(' aritmeticOperation ')' {$$ = $2;}
            | NUMBER {$$ = $1;}
            ;

return : return VARIABLE
       | return NUMBER
       ; 

print : PRINT OPENINGBRACKET printableElement CLOSINGBRACKET 
      ;

printableElement : VARIABLE
                 | '\"' text '\"'
                 | printableElement '+' printableElement
                 ;

text : TEXT
     | ' '
     ;

controlStructure : structuresWord OPENINGBRACKET logicalOperation CLOSINGBRACKET OPENINGCURLYBRACKET codeSet CLOSINGCURLYBRACKET
                 ;

structuresWord : IF
               | ELSE
               | WHILE
               ;

logicalOperation : logicalElement logicalOperator logicalElement
                 ;

logicalOperator : EQUAL 
                | NOTEQUAL
                | GREATER
                | MINOR
                | GREATEREQUAL
                | MINOREQUAL
                ;

logicalElement : aritmeticOperation
               | VARIABLE
               | NUMBER
               ;    

%%

int main(int argc, char** argv) {
  if (argc>1) yyin=fopen(argv[1],"r");
  yyparse();
}

void yyerror (char const *s) {
  fprintf (stderr, "ERROR SINTACTICO [%d]: %s\n", numlin, s);
}
