#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <traducer.c>

int pointer = 73728;
int framePointer;

// A symbol is everything inside the table, 
// could be a variable or a function
struct Symbol {
    char id[20];
    char type;
    int address;
    int params;
}

void insertSymbol(char *id, int params){
    struct Symbol* id = malloc(sizeof(struct symbol));

    symbol.id = malloc(sizeof(char) * strlen(id)); //¿Es necesario?
    strcpy(symbol.id, id);

    symbol.address = getAddress();
    symbol.params = params;
    if(params > 0){
        symbol.type = "f"
    } else {
        symbol.type = "v"
    } 
}

void assignValueToVariable(char *id, int value){
    int address = getVariableAddress(id);
    storeValue(address, value); --> traducer.c
}

void getValueForVariable(char *id){
    // int getValue(address); --traducer.c
}

int getAddress() {
    pointer = pointer - 4;
    return pointer;
}

