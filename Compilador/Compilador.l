%option yylineno 
%{
#include <stdlib.h>
#include "Compilador.tab.h"
#define inicio if(1)
extern char *nomeLabel;
short int executar = 1;
%}


%%

"+"		{inicio if(executar){ return ADD;}		}	
"-"		{inicio if(executar){ return SUB;}		}  
"*"		{inicio if(executar){ return MULT;}		} 
"/"		{inicio if(executar){ return DIV;}		}
"<<"		{inicio if(executar){ return SHIFTL;}	}
">>"		{inicio if(executar){ return SHIFTR;}	}
"&"		{inicio if(executar){ return AND;}		}
"|"		{inicio if(executar){ return OR;}		}
"^"		{inicio if(executar){ return XOR;}		}
"!"		{inicio if(executar){ return NOT;}		}
"input"		{inicio if(executar){return INPUT;}		}
"output"	{inicio if(executar){return OUTPUT;}		}
"int"		{inicio if(executar) { return INT;}		}
"char"		{inicio if(executar) { return CHAR;}	}
"string"	{inicio if(executar) { return STRING;}		}
"enquanto"	{inicio if(executar) { return ENQUANTO;}	}
"se"		{inicio if(executar) { return SE;}		}
"senao"		{inicio if(executar) { return SENAO;}		}
"fim"		{inicio if(executar) { return END;}		}
[a-zA-Z]([a-zA-Z]|[0-9])*	{inicio if(executar){
					nomeLabel = malloc(sizeof(char)*16);
					strcpy(nomeLabel, yytext); 
					return LABEL;
				}}
"<"		{inicio if(executar) { return MENOR;}		}
"="		{inicio if(executar) { return IGUAL;}		}
">"		{inicio if(executar) { return MAIOR;}		}
[0-9]+		{inicio if(executar) { yylval = atoi(yytext);	return NUM;		}}
[ \t\n]		{/*ignora tab e espaco*/}
"{"		{inicio if(executar) { return ABREC;}	}
"}"		{inicio if(executar) { return FECHAC;}	}
"("		{inicio if(executar) { return ABREP;}	}
")"		{inicio if(executar) { return FECHAP;}	}

";"		{inicio if(executar) { return PVIRGULA;}	}
","		{inicio if(executar) { return VIRGULA;}		}
.		{inicio if(executar) { return ERRO;}		}
%%
