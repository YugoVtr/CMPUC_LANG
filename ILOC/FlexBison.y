%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
char* resp = 0;			//caso de erro
int registradores[10];		//registradores disponíveis
int memoria[500];		//memoria interna de inteiros 
char memoriaChar[500];		//memoria interna de caracteres
int linha[500];			//armazenar a linha de cada label
char labelN[500][16]; 		//limitando o tamanho da label a 16 caracteres
unsigned int pc;		//nao utilizado ainda
extern int yylineno;		//armazena a linha atual do flex
extern int yylex();		
extern void yyrestart(FILE *f);	//utilizado para reiniciar a leitura do arquivo
extern short int executar;	//flag de execução: 0- nao executar | 1- executar
extern int pularLinha;		//armazena a linha que o jump deve ir
short int modoIdLabel;		//utilizado para mapear as linhas das labels no inicio do codigo
char *nomeLabel = 0;		//retorno da label pelo flex
FILE *yyin;			//arquivo de entrada
int qtdLinha = 0;		//utilizado para armazenar as linhas nas posicoes corretas do vetor linha e labelN

int aux;
int yyerror(char *s);		//funçao que entra em caso de erro**
int buscarLabelLinha(char c[]);	//retorna a linha que está a label c[] ***
void iniciaLinha();		//inicia o vetor linha com 0.***
void pular(int linha);
short int testarBit(int reg, short int nbit);  //se o registrador em binario for 1 no bit nbit retorna 1 caso contrario retorna 0
%}

//Aritmética
%token ADD SUB MULT DIV ADDI SUBI RSUBI MULTI DIVI RDIVI
//Deslocamentos (Shifts)
%token LSHIFT LSHIFTI RSHIFT RSHIFTI
//Operações binárias
%token AND ANDI OR ORI XOR XORI
//Operações de memória
%token LOAD LOADAI LOADAO CLOAD CLOADAI CLOADAO LOADI
%token STORE STOREAI STOREAO CSTORE CSTOREAI CSTOREAO
//Operações de cópia registrador-para-registrador
%token I2I C2C C2I I2C
//Operações de fluxo de controle
%token CMP_LT CMP_LE CMP_EQ CMP_GE CMP_GT CMP_NE CBR
//Sintaxe alternativa de comparação e desvio
%token COMP CBR_LT CBR_LE CBR_EQ CBR_GE CBR_GT CBR_NE
//Saltos
%token JUMPI JUMP TBL
//Tokens adicionais 
%token NUM REG
%token LABEL CARACTERE
%token APAR FPAR DOISPONTOS
%token NOP ERRO
%token OUTPUTI OUTPUTC

%%

listaInstrucoes: instrucao
| LABEL {if(modoIdLabel){/*armazenar a linha de cada label*/ 
						if(nomeLabel){ linha[qtdLinha] = yylineno;
							strcpy(labelN[qtdLinha], nomeLabel);
							qtdLinha++;
							free(nomeLabel); nomeLabel = 0;}} }  DOISPONTOS listaInstrucoes 

| instrucao listaInstrucoes
| /*epsilon*/
;
instrucao: NOP
| JUMP REG		{ if(!modoIdLabel) { pular(registradores[$2]);}							} 
| JUMPI LABEL		{ if(!modoIdLabel) { pular(buscarLabelLinha(nomeLabel)); free(nomeLabel); nomeLabel = 0; }	}
| LOAD REG REG 		{ if(!modoIdLabel) { registradores[$3] = memoria[registradores[$2]]; }				}
| CLOAD REG REG		{ if(!modoIdLabel) { registradores[$3] = memoriaChar[registradores[$2]]; }			}
| STORE REG REG 	{ if(!modoIdLabel) { memoria[registradores[$3]] = registradores[$2]; }				}
| CSTORE REG REG	{ if(!modoIdLabel) { memoriaChar[registradores[$3]] = registradores[$2]; }			}
| I2I REG REG		{ if(!modoIdLabel) { registradores[$3] = registradores[$2]; }					}
| C2C REG REG		{ if(!modoIdLabel) { registradores[$3] = registradores[$2]; }					}
| C2I REG REG		{ if(!modoIdLabel) { registradores[$3] = registradores[$2] - 48; }				}
| I2C REG REG		{ if(!modoIdLabel) { registradores[$3] = registradores[$2] + 48; }				}
| LOADI NUM REG 	{ if(!modoIdLabel) { registradores[$3] = $2; }							}
| TBL REG LABEL		
| ADD REG REG REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] + registradores[$3]; }		}
| SUB REG REG REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] - registradores[$3]; }		}
| MULT REG REG REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] * registradores[$3]; }		}
| DIV REG REG REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] / registradores[$3]; }		}
| LSHIFT REG REG REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] << registradores[$3]; }		}
| RSHIFT REG REG REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] >> registradores[$3]; }		}
| AND REG REG REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] & registradores[$3]; }		}
| OR REG REG REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] | registradores[$3]; }		}
| XOR REG REG REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] ^ registradores[$3]; }		}
| LOADAO REG REG REG 	{ if(!modoIdLabel) { registradores[$4] = memoria[registradores[$2] + registradores[$3]]; }	}
| CLOADAO REG REG REG	{ if(!modoIdLabel) { registradores[$4] = memoriaChar[registradores[$2] + registradores[$3]]; }	}
| STOREAO REG REG REG 	{ if(!modoIdLabel) { memoria[registradores[$3] + registradores[$4]] = registradores[$2]; }	}
| CSTOREAO REG REG REG	{ if(!modoIdLabel) { memoriaChar[registradores[$3] + registradores[$4]] = registradores[$2]; }	}
| CMP_LT REG REG REG  	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] < registradores[$3]; }		}
| CMP_LE REG REG REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] <= registradores[$3]; }		}
| CMP_EQ REG REG REG	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] == registradores[$3]; }		}
| CMP_GE REG REG REG	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] >= registradores[$3]; }		}
| CMP_GT REG REG REG	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] > registradores[$3]; }		}
| CMP_NE REG REG REG	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] != registradores[$3]; }		}
| ADDI REG NUM REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] + $3; }				}
| SUBI REG NUM REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] - $3; }				}
| RSUBI REG NUM REG	{ if(!modoIdLabel) { registradores[$4] = $3 - registradores[$2]; }				}
| MULTI REG NUM REG	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] * $3; }				}
| DIVI REG NUM REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] / $3; }				}
| RDIVI REG NUM REG 	{ if(!modoIdLabel) { registradores[$4] = $3 / registradores[$2]; }				}
| LSHIFTI REG NUM REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] << $3; }				}
| RSHIFTI REG NUM REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] >> $3; }				}
| ANDI REG NUM REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] & $3; }				}
| ORI REG NUM REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] | $3; }				}
| XORI REG NUM REG 	{ if(!modoIdLabel) { registradores[$4] = registradores[$2] ^ $3; }				}
| LOADAI REG NUM REG 	{ if(!modoIdLabel) { registradores[$4] = memoria[registradores[$2] + $3]; }			}
| CLOADAI REG NUM REG	{ if(!modoIdLabel) { registradores[$4] = memoriaChar[registradores[$2] + $3]; }			}
| STOREAI REG REG NUM 	{ if(!modoIdLabel) { memoria[registradores[$3] + $4] = registradores[$2]; }			}
| CSTOREAI REG REG NUM	{ if(!modoIdLabel) { memoriaChar[registradores[$3] + $4] = registradores[$2]; }			}
| COMP REG REG REG	{ if(!modoIdLabel) { registradores[$4] = 0;
								   if(registradores[$2] <  registradores[$3]) registradores[$4] += 1; //caso cmp = LT
								   if(registradores[$2] <= registradores[$3]) registradores[$4] += 2; //caso cmp = LE
								   if(registradores[$2] == registradores[$3]) registradores[$4] += 4; //caso cmp = EQ
								   if(registradores[$2] >= registradores[$3]) registradores[$4] += 8; //caso cmp = GE
								   if(registradores[$2] >  registradores[$3]) registradores[$4] += 16; //caso cmp = GT
								   if(registradores[$2] != registradores[$3]) registradores[$4] += 32; //caso cmp = NE
								   }							}
| CBR REG LABEL { if(!modoIdLabel) { aux = buscarLabelLinha(nomeLabel); free(nomeLabel); nomeLabel = 0;} } 
				    LABEL	{ if(!modoIdLabel) { if(registradores[$2]) {
									pular(aux);
								   } else{		
									  pular(buscarLabelLinha(nomeLabel));
									  free(nomeLabel); nomeLabel = 0;
									 }
								   }
						}
| CBR_LT REG LABEL { if(!modoIdLabel) { aux = buscarLabelLinha(nomeLabel); free(nomeLabel); nomeLabel = 0;} } 
		   			LABEL { if(!modoIdLabel) { if(testarBit($2, 0)) {
									pular(aux);
								 } else { 		
									 pular(buscarLabelLinha(nomeLabel));
									 free(nomeLabel); nomeLabel = 0;
									}
								}
					      }
| CBR_LE REG LABEL { if(!modoIdLabel) { aux = buscarLabelLinha(nomeLabel); free(nomeLabel); nomeLabel = 0;} } 
		   			LABEL { if(!modoIdLabel) { if(testarBit($2, 1)) {
									pular(aux);
								 } else { 		
									 pular(buscarLabelLinha(nomeLabel));
									 free(nomeLabel); nomeLabel = 0;
									}
								}
					      }
| CBR_EQ REG LABEL { if(!modoIdLabel) { aux = buscarLabelLinha(nomeLabel); free(nomeLabel); nomeLabel = 0;} } 
		   			LABEL { if(!modoIdLabel) { if(testarBit($2, 2)) {
									pular(aux);
								 } else { 		
									 pular(buscarLabelLinha(nomeLabel));
									 free(nomeLabel); nomeLabel = 0;
									}
								}
					      }
| CBR_GE REG LABEL { if(!modoIdLabel) { aux = buscarLabelLinha(nomeLabel); free(nomeLabel); nomeLabel = 0;} } 
		   			LABEL { if(!modoIdLabel) { if(testarBit($2, 3)) {
									pular(aux);
								 } else { 		
									 pular(buscarLabelLinha(nomeLabel));
									 free(nomeLabel); nomeLabel = 0;
									}
								}
					      }
| CBR_GT REG LABEL { if(!modoIdLabel) { aux = buscarLabelLinha(nomeLabel); free(nomeLabel); nomeLabel = 0;} } 
		   			LABEL { if(!modoIdLabel) { if(testarBit($2, 4)) {
									pular(aux);
								 } else { 		
									 pular(buscarLabelLinha(nomeLabel));
									 free(nomeLabel); nomeLabel = 0;
									}
								}
					      }
| CBR_NE REG LABEL { if(!modoIdLabel) { aux = buscarLabelLinha(nomeLabel); free(nomeLabel); nomeLabel = 0;} } 
		   			LABEL { if(!modoIdLabel) { if(testarBit($2, 5)) {
									pular(aux);
								 } else { 		
									 pular(buscarLabelLinha(nomeLabel));
									 free(nomeLabel); nomeLabel = 0;
									}
								}
					      }


| OUTPUTI REG		{ if(!modoIdLabel) { int aux = $2; printf("%d", registradores[aux]); }				}
| OUTPUTC REG		{ if(!modoIdLabel) { int aux = $2; printf("%c", registradores[aux]); }				}
;

%%
int main(int argc, char **argv){
	iniciaLinha();
	//roda uma vez para identificar as linhas das labels
	modoIdLabel = 1;
	yylineno = 1;
	yyin = fopen("entrada.txt", "r");
	yyparse();
	modoIdLabel = 0;

	//roda a segunda
	
	yyin = fopen("entrada.txt", "r");
	yylineno = 1;
	yyparse();
	if(resp){
		printf("%s\n", resp);
		free(resp);
		resp = 0;
	}
	return 0;
}

int yyerror(char *s){
	resp = malloc(sizeof("Algo de errado não está certo!!"));
	strcpy(resp, "Algo de errado não está certo!!");
	return 0;
}

void iniciaLinha(){
	for(int i=0; i<500; i++){
		linha[i] = 0;
	}
}

//funçao para mapear em qual linha está cada label
int buscarLabelLinha(char c[]){
	for(int i=0; i< qtdLinha; i++){
		if(strcmp(labelN[i], c) == 0){
			return linha[i];
		}
	}
}

void pular(int linha){
	fclose(yyin);  //no reg deve conter a linha para saltar
	yyin = fopen("entrada.txt", "r"); 
	yylineno = 1;
	executar = 0;
	pularLinha = linha;
	yyrestart(yyin);	
}

short int testarBit(int reg, short int nbit){
	int saida = 0;
	int aux2;
	int aux3;
	for(int i = 0; i<6; i++){
		aux2 = 5-i;
		aux3 = 1;
		for (int j = 0; j < aux2; j++) { aux3 = aux3 * 2; }
		if(registradores[reg] / aux3){
			registradores[reg] -= aux;
			if(nbit == aux2){
				saida = 1;
			}
		}
	}
	return saida;
}
