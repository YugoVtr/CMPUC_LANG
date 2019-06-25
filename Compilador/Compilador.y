%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern char *nomeLabel;
int yyerror(char *s);															//funcao que entra em caso de erro
char *nomeLabel = 0;															//retorno da label pelo flex
char* resposta = 0;																//utilizado em caso de erro

char variavel[100][16];															//limitando o tamanho da variavel para 16 bytes e no maximo 100 variaveis
FILE *yyin;																		//arquivo de entrada
FILE *yyout;																	//arquivo de saida
unsigned int sp = 0;															//stack pointer indica a posicao da pilha
unsigned int qtdVariavel = 0; 													//armazena a quantidade de variaveis que tem no programa
int buscarIdVariavel(char c[]);													//retorna o indice correspondente a variavel c

unsigned int auxAtribuicao;
unsigned int auxCondicional;
unsigned int auxRepeticao;
unsigned int contadorIf = 0;
unsigned int contadorWhile = 0;

unsigned int stackIf[500]; 														//pilha para armazenar os contadores de if
unsigned int spStackIf = 0;														//stack point para o stackIf
unsigned int stackWhile[500]; 													//pilha para armazenar os contadores de while
unsigned int spStackWhile = 0;													//stack point para o stackwhile
%}


// ARITMÉTICA
%token ADD SUB MULT DIV

// DESLOCAMENTO
%token SHIFTL SHIFTR

// OPERADORES BINARIOS
%token AND OR XOR NOT

// ENTRADA E SAÍDA
%token INPUT OUTPUT

%token LABEL ERRO

// DELIMITADORES DE ESCOPO
%token ABREC FECHAC ABREP FECHAP 

// TOKENS ADICIONAIS
%token INT CHAR STRING END
%token MENOR IGUAL MAIOR NUM ENQUANTO SE SENAO
%token VIRGULA PVIRGULA

%%

programa: 
	sequenciaComandos END
;

sequenciaComandos: 
	comando PVIRGULA
|	comando PVIRGULA sequenciaComandos
;

comando: 
|	declaracao
|	atribuicao
|	expressao
|	leitura
|	impressao
|	decisao
|	repeticao
;

declaracao: 
	INT LABEL {
		strcpy(variavel[qtdVariavel++], nomeLabel);
		free(nomeLabel); 
		nomeLabel = 0;
	}
|	INT LABEL {
		strcpy(variavel[qtdVariavel++], nomeLabel);
		auxAtribuicao = buscarIdVariavel(nomeLabel);
		free(nomeLabel); 
		nomeLabel = 0;
	} 	
	MENOR IGUAL expressao {
		fprintf(yyout, "loadI %d r1\n", sp--);
		fprintf(yyout, "load r1 r2\n");
		fprintf(yyout, "loadI %d r3\n", auxAtribuicao);
		fprintf(yyout, "store r2 r3\n");
	}
;

atribuicao: 
	LABEL { 
		auxAtribuicao = buscarIdVariavel(nomeLabel); 
		free(nomeLabel); 
		nomeLabel = 0;
	}
	MENOR IGUAL expressao {
		fprintf(yyout, "loadI %d r1\n", sp--);
		fprintf(yyout, "load r1 r2\n");
		fprintf(yyout, "loadI %d r3\n", auxAtribuicao);
		fprintf(yyout, "store r2 r3\n");
	}
;

expressao: 
	expressao ADD termo {	
		fprintf(yyout, "loadI %d r1\n", sp--);
		fprintf(yyout, "load r1 r2\n");
		fprintf(yyout, "loadI %d r1\n", sp--);
		fprintf(yyout, "load r1 r3\n");
		fprintf(yyout, "add r2 r3 r1\n");
		fprintf(yyout, "loadI %d r2\n", ++sp);
		fprintf(yyout, "store r1 r2\n");
	}
| 	expressao SUB termo {	
		fprintf(yyout, "loadI %d r1\n", sp--);
		fprintf(yyout, "load r1 r2\n");
		fprintf(yyout, "loadI %d r1\n", sp--);
		fprintf(yyout, "load r1 r3\n");
		fprintf(yyout, "sub r3 r2 r1\n");
		fprintf(yyout, "loadI %d r2\n", ++sp);
		fprintf(yyout, "store r1 r2\n");
	}
| 	termo
;

termo: 
	termo MULT fator	{	
		fprintf(yyout, "loadI %d r1\n", sp--);
		fprintf(yyout, "load r1 r2\n");
		fprintf(yyout, "loadI %d r1\n", sp--);
		fprintf(yyout, "load r1 r3\n");
		fprintf(yyout, "mult r2 r3 r1\n");
		fprintf(yyout, "loadI %d r2\n", ++sp);
		fprintf(yyout, "store r1 r2\n");
	}
|	termo DIV fator {	
		fprintf(yyout, "loadI %d r1\n", sp--);
		fprintf(yyout, "load r1 r2\n");
		fprintf(yyout, "loadI %d r1\n", sp--);
		fprintf(yyout, "load r1 r3\n");
		fprintf(yyout, "div r2 r3 r1\n");
		fprintf(yyout, "loadI %d r2\n", ++sp);
		fprintf(yyout, "store r1 r2\n");
	}
|	fator
;

fator: 
	LABEL {
		auxAtribuicao = buscarIdVariavel(nomeLabel); 
		free(nomeLabel); 
		nomeLabel = 0;
		fprintf(yyout, "loadI %d r2\n", auxAtribuicao);
		fprintf(yyout, "load r2 r3\n");
		fprintf(yyout, "loadI %d r1\n", ++sp);
		fprintf(yyout, "store r3 r1\n");
	}
|	NUM	{
		fprintf(yyout, "loadI %d r1\n", ++sp);						
		fprintf(yyout, "loadI %d r2\n", $1);
		fprintf(yyout, "store r2 r1\n");
	}
| 	ABREC expressao FECHAC
;

leitura: 
	INPUT listaIdentificadores
;

listaIdentificadores:
|	LABEL
|	LABEL VIRGULA listaIdentificadores
;

impressao:
	OUTPUT listaExpressoes {
		fprintf(yyout, "loadI %d r1\n", sp--);
		fprintf(yyout, "load r1 r2\n");
		fprintf(yyout, "output r2\n");
	}
;

listaExpressoes: 
|	expressao
| 	expressao VIRGULA listaExpressoes
;

decisao: 
	SE comparacao ABREC {
		fprintf(yyout, " IIf%d IElse%d\n", contadorIf, contadorIf);  
		fprintf(yyout, "IIf%d:\n", contadorIf);
		stackIf[spStackIf++] = contadorIf++;
	}
	sequenciaComandos FECHAC {
		auxCondicional = stackIf[--spStackIf];
		fprintf(yyout, "jumpI FElse%d\n", auxCondicional);
	}
	SENAO ABREC {
		fprintf(yyout, "IElse%d:\n", auxCondicional);
		stackIf[spStackIf++] = auxCondicional;
	} 
	sequenciaComandos FECHAC {
		auxCondicional = stackIf[--spStackIf];
		fprintf(yyout, "FElse%d:\n", auxCondicional);
	}
;

comparacao: 
	expressao MAIOR expressao	{
		fprintf(yyout, "loadI %d r5\n", sp--);
		fprintf(yyout, "load r5 r2\n");
		fprintf(yyout, "loadI %d r5\n", sp--);
		fprintf(yyout, "load r5 r1\n");
		fprintf(yyout, "comp r1 r2 r9\n");
		fprintf(yyout, "cbr_GT r9 ");
	}
|	expressao IGUAL expressao	{
		fprintf(yyout, "loadI %d r5\n", sp--);
		fprintf(yyout, "load r5 r2\n");
		fprintf(yyout, "loadI %d r5\n", sp--);
		fprintf(yyout, "load r5 r1\n");
		fprintf(yyout, "comp r1 r2 r9\n");
		fprintf(yyout, "cbr_EQ r9 ");
	}
| 	expressao MENOR expressao	{
		fprintf(yyout, "loadI %d r5\n", sp--);
		fprintf(yyout, "load r5 r2\n");
		fprintf(yyout, "loadI %d r5\n", sp--);
		fprintf(yyout, "load r5 r1\n");
		fprintf(yyout, "comp r1 r2 r9\n");
		fprintf(yyout, "cbr_LT r9 ");
	}
|	expressao	{
		fprintf(yyout, "loadI %d r5\n", sp--);
		fprintf(yyout, "load r5 r1\n");
		fprintf(yyout, "cbr r1 "); 
	}
;

repeticao: ENQUANTO {
	fprintf(yyout, "IWhile%d:\n", contadorWhile);
	stackWhile[spStackWhile++] = contadorWhile++;
}
comparacao ABREC {
	auxRepeticao = stackWhile[--spStackWhile];
	fprintf(yyout, " IWhileCod%d FWhile%d\n", auxRepeticao, auxRepeticao);  
	fprintf(yyout, "IWhileCod%d:\n", auxRepeticao);
	stackWhile[spStackWhile++] = auxRepeticao;
}
sequenciaComandos FECHAC {
	auxRepeticao = stackWhile[--spStackWhile];
	fprintf(yyout, "jumpI IWhile%d\n", auxRepeticao);
	fprintf(yyout, "FWhile%d:\n", auxRepeticao);
}
;

%%

int main(int argc, char **argv){
	
	yyin = fopen("entrada.cmp", "r");
	yyout = fopen("saida.mva", "w");
	yyparse();
	if(resposta){
		printf("%s\n", resposta);
		free(resposta);
		resposta = 0;
	}
	return 0;
}

int yyerror(char *s){
	resposta = malloc(sizeof("Deu Ruim.\n"));
	strcpy(resposta, "Deu ruim.\n");
	return 0;
}

int buscarIdVariavel(char c[]){
	for(int i=0; i< qtdVariavel; i++){
		if(strcmp(variavel[i], c) == 0){
			return i;
		}
	}
}
