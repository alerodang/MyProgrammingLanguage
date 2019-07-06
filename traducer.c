#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <trable_manager.c>

void assignValueToVariable(char *id, int value){
    int address = getSymbol(id).address;
    storeValue(address, value);
}

void storeValue(address, value){

}

int getValue(address){

}