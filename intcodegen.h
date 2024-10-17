#ifndef INTCODEGEN_H
#define INTCODEGEN_H

#define MEM_SIZE 65536
#define REG_SIZE 12
#define TABLE_SIZE 100

#define TYPEID 1
#define TYPENUM 0
#define TYPEEXPR 2

// Symbol table entry
typedef struct Symbol {
    char *name;
    int location;
    struct Symbol *next;
} Symbol;

typedef struct argtype {
    int type;
    //union of int and string
    union {
        int ival;
        char *sval;
    } val;
} argtype;

// Function to lookup a variable in the symbol table
int lookup(const char *name);

// Function to insert a new variable into the symbol table
void insert(const char *name, int location);

// Function to generate a new argtype node
argtype newArgtype(int type, int ival, char *sval);

#endif // INTCODEGEN_H