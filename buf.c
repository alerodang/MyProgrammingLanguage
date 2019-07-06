#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>

struct Symbol* firstSymbol;
struct Symbol* lastSymbol;
int tableSize = 0;

int tablePointer = 73728;
int currentDepth = 0;

struct Symbol {
    char* id;
    struct Symbol *previousSymbol;
    struct Symbol *nextSymbol;
    char type;
    int address;
    int framePointer;
    int parentAddress;
    int depth;
    int numberOfParams;
};

void insertFunction(char *id){
    
    struct Symbol* symbol = malloc(sizeof(struct Symbol));

    symbol->nextSymbol = NULL;
    symbol->type = "f";
    symbol->address = getAddress();
    symbol->depth = currentDepth;
    symbol->numberOfParams = 0;
    symbol->framePointer = NULL;
    symbol->parentAddress = NULL;

    symbol->id = malloc(sizeof(char) * strlen(id));
    strcpy(symbol->id, id);

    if(tableSize == 0){
        firstSymbol = symbol;
        symbol->previousSymbol = NULL;
    } else {
        symbol->previousSymbol = lastSymbol;
        lastSymbol->nextSymbol = symbol;
    }

    lastSymbol = symbol;
    tableSize++;
}

void insertParam(char *id){
    
    struct Symbol* symbol = malloc(sizeof(struct Symbol));

    symbol->nextSymbol = NULL;
    symbol->type = "p";
    symbol->depth = currentDepth;
    symbol->numberOfParams = 0;

    symbol->id = malloc(sizeof(char) * strlen(id));
    strcpy(symbol->id, id);

    if(tableSize == 0){
        firstSymbol = symbol;
        symbol->previousSymbol = NULL;
    } else {
        symbol->previousSymbol = lastSymbol;
        lastSymbol->nextSymbol = symbol;
    }

    lastSymbol = symbol;
    tableSize++;

    getLastFunction()->numberOfParams++;

}

void insertVariable(char *id){
    
    struct Symbol* symbol = malloc(sizeof(struct Symbol));

    symbol->nextSymbol = NULL;
    symbol->type = "v";
    symbol->address = getAddress();
    symbol->depth = currentDepth;
    symbol->numberOfParams = 0;
    symbol->framePointer = NULL;
    
    if(currentDepth == 0) symbol->parentAddress = NULL;
    else symbol->parentAddress = getLastFunction()->address;

    symbol->id = malloc(sizeof(char) * strlen(id));
    strcpy(symbol->id, id);

    if(tableSize == 0){
        firstSymbol = symbol;
        symbol->previousSymbol = NULL;
    } else {
        symbol->previousSymbol = lastSymbol;
        lastSymbol->nextSymbol = symbol;
    }

    lastSymbol = symbol;
    tableSize++;

}

struct Symbol* getFirstAccessibleSymbol(char* id, int scopeDepth){
    struct Symbol* currentSymbol = lastSymbol;
    int maxDepthAllowed = scopeDepth;
    for(int i = tableSize; i > 0; i--){
        if(currentSymbol->depth > maxDepthAllowed){
            continue;
        }
        if(strcmp(currentSymbol->id, id) == 0){
            return currentSymbol;
        }
    }
    return NULL;
}

struct Symbol* getSymbol(char* id){
    struct Symbol* currentSymbol = lastSymbol;
    for(int i = tableSize; i > 0; i--){
        if(strcmp(currentSymbol->id, id) == 0){
            return currentSymbol; //first
        }
    }
    return NULL;
}

struct Symbol* getLastFunction(){
    struct Symbol* currentSymbol = lastSymbol;
    for(int i = tableSize; i > 0; i--){
        if(currentSymbol->type == "f"){
            return currentSymbol;
        }
    }
    return NULL;
}

void openScope(){
    currentDepth++;
}

void closeScope(){
    currentDepth--;
}

int getAddress() {
    tablePointer = tablePointer - 4;
    return tablePointer;
}
