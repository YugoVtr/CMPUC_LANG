cd ../Compilador
rm -f *.c *.h *.out *.mva
bison -d Compilador.y
flex Compilador.l
gcc lex.yy.c Compilador.tab.c 
./a.out
cp ../Compilador/saida.mva ../MVA/entrada.mva
rm -f *.c *.h *.out *.mva
cd ../Executar


cd ../MVA
rm -f *.c *.h
bison -d MVA.y
flex MVA.l
gcc lex.yy.c MVA.tab.c 
rm -f *.c *.h

./a.out
rm -f *.out

cd ../Executar
