LEX_FILE = expr.l
C_FILE = intcodegen.c
BISON_FILE = expr.y
BISON_OUTPUT = expr.tab.c
BISON_HEADER = expr.tab.h
LEX_OUTPUT = lex.yy.c
EXE = ./a.out
INPUT = input.txt
OUTPUT_FILE = output.c

all: 
	@rm -f $(LEX_OUTPUT) $(EXE) $(BISON_OUTPUT) $(OUTPUT_FILE) $(BISON_HEADER)
	@bison -d $(BISON_FILE) 2>/dev/null
	@flex $(LEX_FILE) 2>/dev/null
	@gcc $(C_FILE) $(LEX_OUTPUT) $(BISON_OUTPUT)
	@$(EXE) < $(INPUT) > $(OUTPUT_FILE)
	@gcc $(OUTPUT_FILE) 
	@$(EXE)

clean:
	@rm -f $(LEX_OUTPUT) $(EXE) $(BISON_OUTPUT) $(OUTPUT_FILE) $(BISON_HEADER)