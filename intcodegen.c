#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "expr.tab.h"
#include "intcodegen.h"

#define MEM_SIZE 65536
#define REG_SIZE 12

// Head of the symbol table linked list
Symbol *symbolTable = NULL;

// Function to lookup a variable in the symbol table
int lookup(const char *name) {
    Symbol *current = symbolTable;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current->location;
        }
        current = current->next;
    }
    return -1; // Not found
}

// Function to insert a new variable into the symbol table
void insert(const char *name, int location) {
    Symbol *newSymbol = (Symbol *)malloc(sizeof(Symbol));
    newSymbol->name = strdup(name);
    newSymbol->location = location;
    newSymbol->next = symbolTable;
    symbolTable = newSymbol;
}

// Function to generate a new argtype node
argtype newArgtype(int type, int ival, char *sval) {
    argtype *newArg = (argtype *)malloc(sizeof(argtype));
    newArg->type = type;
    if (type == TYPENUM) {
        newArg->val.ival = ival;
    } else {
        newArg->val.sval = strdup(sval);
    }
    return *newArg;
}

int main() {
    printf("#include <stdio.h>\n");
    printf("#include <stdlib.h>\n");
    printf("#include \"aux_.c\"\n");
    printf("int main() {\n");
    printf("int MEM[65536];\n");
    printf("int R[12];\n\n");
    yyparse();
    printf("exit(0);\n");
    printf("}\n");
    return 0;
}