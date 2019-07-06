// https://www.gnu.org/software/bison/manual/html_node/Precedence-Decl.html#Precedence-Decl
// https://www.gnu.org/software/bison/manual/html_node/Token-Decl.html
// https://www.tiendalinux.com/docs/manuales/bison/bison-es-1.27.html

// Por contemplar q una variable pueda ser el resultado de llamar a una función
// Parentesis en operaciones

%{
  #include <stdio.h>
  #include "table_manager.c"
  #include "codeGenerator.c"
  extern FILE *yyin; 
  extern int numlin; 
  int yydebug=1; 
  void yyerror (char const*);
%}

%union { int number; char* string; }

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
%token <number> QUOTE
%token <string> STRING
%token <string> VARIABLE
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

%left '-' '+'
%left '*' '/'

%%

root : declaration 
     | function
     ;

declaration : INT VARIABLE SEMICOLON {insertVariable($<string>2);}
            ;

function : INT VARIABLE {insertFunction($<string>2);}  OPENINGBRACKET {openScope();} params {closingScope();}CLOSINGBRACKET OPENINGCURLYBRACKET {openScope();} codeSet {closingScope();} CLOSINGCURLYBRACKET 
         ;

params : INT VARIABLE {insertVariable($<string>2);} COMMA params 
       | INT VARIABLE {insertVariable($<string>2);}
       ;

codeSet : declaration codeSet
        | instruction codeSet
        | controlStructure codeSet
        | declaration
        | instruction
        | controlStructure
        ;

instruction : assignation
            | aritmeticOperation SEMICOLON
            | return SEMICOLON
            | print SEMICOLON
            | BREAK SEMICOLON {breakCode();}
            ;

assignation : VARIABLE '=' NUMBER SEMICOLON {assignValue($<string>2,$<number>3);}
            ;  

aritmeticOperation : aritmeticOperation '-' aritmeticOperation {$$ = substract($<number>1,$<number>3);}
            | aritmeticOperation '+' aritmeticOperation {$$ = add($<number>1,$<number>3);}
            | aritmeticOperation '*' aritmeticOperation {$$ = multiply($<number>1, $<number>3);}
            | aritmeticOperation '/' aritmeticOperation {$$ = divide($<number>1, $<number>3);}
            | OPENINGBRACKET aritmeticOperation CLOSINGBRACKET {$$ = $<number>2;}
            | NUMBER {$$ = $<number>1;}
            ;

return : RETURN VARIABLE {returnVariable($<number>2);}
       | RETURN NUMBER {returnValue($<number>2);}
       ; 

print : PRINT OPENINGBRACKET printableElement CLOSINGBRACKET 
      ;

printableElement : VARIABLE {printVariable($<number>1);)}
                 | QUOTE text QUOTE {printText(($<number>1);)}
                 | printableElement '+' printableElement {printLineJump();}
                 ;

text : TEXT {$$ = $<number>1;}
     | ' '  {$$ = $<number>1;}
     ;

controlStructure : structuresWord OPENINGBRACKET {openScope();} logicalOperation {closingScope();} CLOSINGBRACKET OPENINGCURLYBRACKET {openScope();} codeSet {closing();} CLOSINGCURLYBRACKET
                 ;

structuresWord : IF {startIf();}
               | ELSE {startElse();}
               | WHILE {startWhile();}
               ;

logicalOperation : VARIABLE logicalOperator VARIABLE {logicalOperate(($<number>1),($<number>3),($<string>1))}
                 | VARIABLE logicalOperator NUMBER {logicalOperate(($<number>1),($<number>3),($<string>1))}
                 | NUMBER logicalOperator NUMBER {logicalOperate(($<number>1),($<number>3),($<string>1))}
                 | NUMBER logicalOperator VARIABLE {logicalOperate(($<number>1),($<number>3),($<string>1))}
                 ;

logicalOperator : EQUAL ($$ = "eq")
                | NOTEQUAL ($$ = "neq")
                | GREATER ($$ = "gt")
                | MINOR ($$ = "mt")
                | GREATEREQUAL ($$ = "ge")
                | MINOREQUAL ($$ = "me")
                ;

%%

int main(int argc, char** argv) {
  if (argc>1) yyin=fopen(argv[1],"r");
  yyparse();
}

void yyerror (char const *s) {
  fprintf (stderr, "ERROR SINTACTICO [%d]: %s\n", numlin, s);
}
