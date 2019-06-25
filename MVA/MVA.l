%option yylineno
%option noyywrap
%{
#include <stdlib.h>
#include <math.h>
#include "MVA.tab.h" 

short int executar = 1;
int pularLinha;
extern char *nomeLabel;

#define inicio if(!executar && yylineno == pularLinha)executar = 1;
%}

%%
"add" 		{ inicio if(executar) { return ADD; }}
"sub" 		{ inicio if(executar) {return SUB; }}
"mult" 		{ inicio if(executar) {return MULT; }}
"div" 		{ inicio if(executar) {return DIV; }}
"addI" 		{ inicio if(executar) {return ADDI; }}
"subI" 		{ inicio if(executar) {return SUBI; }}
"rsubI" 	{ inicio if(executar) {return RSUBI; }}
"multI" 	{ inicio if(executar) {return MULTI; }}
"divI" 		{ inicio if(executar) {return DIVI; }}
"rdivI" 	{ inicio if(executar) {return RDIVI; }}
"lshift" 	{ inicio if(executar) {return LSHIFT; }}
"lshiftI" 	{ inicio if(executar) {return LSHIFTI; }}
"rshift" 	{ inicio if(executar) {return RSHIFT; }}
"rshiftI" 	{ inicio if(executar) {return RSHIFTI; }}
"and"		{ inicio if(executar) {return AND; }}
"andI"		{ inicio if(executar) {return ANDI; }}
"or"		{ inicio if(executar) {return OR; }	}
"orI"		{ inicio if(executar) {return ORI; }}
"xor"		{ inicio if(executar) {return XOR; }}
"xorI" 		{ inicio if(executar) {return XORI; }}
"load" 		{ inicio if(executar) {return LOAD; }}
"loadAI" 	{ inicio if(executar) {return LOADAI; }}
"loadAO" 	{ inicio if(executar) {return LOADAO; }}
"cload" 	{ inicio if(executar) {return CLOAD; }}
"cloadAI" 	{ inicio if(executar) {return CLOADAI; }}
"cloadAO" 	{ inicio if(executar) {return CLOADAO; }}
"loadI" 	{ inicio if(executar) {return LOADI; }}
"store" 	{ inicio if(executar) {return STORE; } }
"storeAI" 	{ inicio if(executar) {return STOREAI; }}
"storeAO" 	{ inicio if(executar) {return STOREAO; }}
"cstore" 	{ inicio if(executar) {return CSTORE; }}
"cstoreAI" 	{ inicio if(executar) {return CSTOREAI; }}
"cstoreAO" 	{ inicio if(executar) {return CSTOREAO; }}
"i2i" 		{ inicio if(executar) {return I2I; }}
"c2c" 		{ inicio if(executar) {return C2C; }}
"c2i" 		{ inicio if(executar) {return C2I; }}
"i2c" 		{ inicio if(executar) {return I2C; }}
"cmp_LT"	{ inicio if(executar) {return CMP_LT; }}
"cmp_LE"	{ inicio if(executar) {return CMP_LE; }}
"cmp_EQ"	{ inicio if(executar) {return CMP_EQ; }}
"cmp_GE"	{ inicio if(executar) {return CMP_GE; }}
"cmp_GT"	{ inicio if(executar) {return CMP_GT; }}
"cmp_NE"	{ inicio if(executar) {return CMP_NE; }}
"cbr"		{ inicio if(executar) {return CBR; }}
"comp"		{ inicio if(executar) {return COMP; }}
"cbr_LT"	{ inicio if(executar) {return CBR_LT; }}
"cbr_LE"	{ inicio if(executar) {return CBR_LE; }}
"cbr_EQ"	{ inicio if(executar) {return CBR_EQ; }}
"cbr_GE"	{ inicio if(executar) {return CBR_GE; }}
"cbr_GT"	{ inicio if(executar) {return CBR_GT; }}
"cbr_NE"	{ inicio if(executar) {return CBR_NE; }}
"jump"		{ inicio if(executar) {return JUMP; }}
"jumpI"		{ inicio if(executar) {return JUMPI; }}
"tbl"		{ inicio if(executar) {return TBL; }}
"nop" 		{ inicio if(executar) {return NOP; }}
"outputI"	{ inicio if(executar) {return OUTPUTI; }}
"outputC"	{ inicio if(executar) {return OUTPUTC; }}
":"			{ inicio if(executar) {return DOISPONTOS; }}

[0-9]+ 		{ inicio if(executar) {yylval = atoi(yytext); return NUM; }	}
[r][0-9] 	{ inicio if(executar) {char valor[1]; valor[0] = yytext[1]; yylval = atoi(valor); return REG; }	}
[a-zA-Z]	{ inicio if(executar) {yylval = yytext[0]; return CARACTERE; }	}
[a-zA-Z]([a-zA-Z]|[0-9]|-)* {
	inicio if(executar) {
		nomeLabel = malloc(sizeof(char)*16);
		strcpy(nomeLabel, yytext); 
		return LABEL;
	}
}

"("			{ inicio if(executar) {return APAR; }}
")"			{ inicio if(executar) {return FPAR; }}
[ \t\n] 	{ /* ignore whitespace */ }
. 			{ printf("Caractere inválido %c\n", *yytext); }

%%
