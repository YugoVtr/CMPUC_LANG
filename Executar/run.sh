rm -f *.c *.h
bison -d ../Compilador/Compilador.y
flex ../Compilador/Compilador.l
gcc lex.yy.c Compilador.tab.c -lfl
