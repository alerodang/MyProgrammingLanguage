#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>

struct Symbol* firstSymbol;
struct Symbol* lastSymbol;
struct Symbol* lastFunc;
int tableSize = 0;

int tablePointer = 73728;
int currentDepth = 0;

struct Symbol
{
    char* id;
    int address; //absolute or relative
    char type;
    int depth;
    int localVariablesAmount;
    struct Symbol *previousSymbol;
    struct Symbol *nextSymbol;
};

void insertVariable(char *id){
    struct Symbol* symbol = malloc(sizeof(struct Symbol));

    symbol->id = malloc(sizeof(char) * strlen(id));
    symbol->nextSymbol = NULL;
    symbol->localVariablesAmount = 0;
    symbol->depth = currentDepth;
    symbol->type = currentDepth == 0 ? 'g' : 'l';
    symbol->address = symbol->type == 'g' ? getStaticAddress() : getRelativeAddress();

    strcpy(symbol->id, id);

    existInScope(symbol) ? printf("Error") : linkSymbol(symbol);
}

void insertFunction(char *id){
    struct Symbol* symbol = malloc(sizeof(struct Symbol));
    
    symbol->id = malloc(sizeof(char) * strlen(id));
    symbol->nextSymbol = NULL;
    symbol->localVariablesAmount = 0;
    symbol->type = 'f';
    symbol->address = NULL;
    symbol->depth = 0;

    strcpy(symbol->id, id);

    existInScope(symbol) ? printf("Error") : linkSymbol(symbol);
    
}

int getRelativeAddress(){
    return (lastFunc->localVariablesAmount + 1) * 4;
}

int getAddress() {
    tablePointer = tablePointer - 4;
    return tablePointer;
}

void linkSymbol(struct Symbol* symbol){
    if(tableSize == 0){
        firstSymbol = symbol;
        symbol->previousSymbol = NULL;
    } else {
        lastSymbol->nextSymbol = symbol;
        symbol->previousSymbol = lastSymbol;
    }
    if(symbol->type == "f") lastFunc = symbol;
    if(symbol->type == "l") lastFunc->localVariablesAmount++;
    tableSize ++;
    lastSymbol = symbol;
}

bool existInScope(struct Symbol* symbol){
    struct Symbol* currentSymbol = lastSymbol;
    
    bool hasSameDepth;
    bool hasSameId;

    for(int i = tableSize; i > 0; i--){
        hasSameDepth = currentSymbol->depth == depth;
        hasSameId = strcmp(currentSymbol->id, id) == 0);
        hasSameDepth && hasSameId ? return true : continue;
    }
    return false;
}

void openScope(){
    currentDepth++;
}

void closeScope(){
    currentDepth++;
}