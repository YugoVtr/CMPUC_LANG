cd ../Compilador
rm -f *.c *.h
bison -d Compilador.y
flex Compilador.l
gcc lex.yy.c Compilador.tab.c -lfl
rm -f *.c *.h
cd ../Executar

cp ../Compilador/saida.mva ../MVA/entrada.mva

cd ../MVA
rm -f *.c *.h
bison -d MVA.y
flex MVA.l
gcc lex.yy.c MVA.tab.c -lfl
rm -f *.c *.h
cd ../Executar
