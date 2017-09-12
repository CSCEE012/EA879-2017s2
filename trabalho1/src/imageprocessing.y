%{
#include <stdio.h>
#include "imageprocessing.h"
#include <FreeImage.h>

void yyerror(char *c);
int yylex(void);

%}
%union {
  char    strval[50];
  int     ival;
  float   fval;
}
%token <strval> STRING
%token <ival> VAR IGUAL EOL ASPA MULTI DIVI C1 C2
%token <fval> NUM
%left SOMA

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL
        |
        ;

EXPRESSAO:
    | STRING IGUAL STRING {
        printf("Copiando %s para %s\n", $3, $1);
        imagem I = abrir_imagem($3);
        printf("Li imagem %d por %d\n", I.width, I.height);
        salvar_imagem($1, &I);
        liberar_imagem(&I);
                          }

    | STRING IGUAL STRING MULTI NUM{
        printf("Multiplicando brilho por %f \n", $5);
        imagem I = abrir_imagem($3);
        printf("Li imagem %d por %d\n", I.width, I.height);
        multi_imagem(&I,$5);
        salvar_imagem($1, &I);
        liberar_imagem(&I);
                          }

    | STRING IGUAL STRING DIVI NUM{
        printf("Dividindo brilho por %f \n", $5);
        imagem I = abrir_imagem($3);
        printf("Li imagem %d por %d\n", I.width, I.height);
        divi_imagem(&I,$5);
        salvar_imagem($1, &I);
        liberar_imagem(&I);
                          }

    | C1 STRING C2 {
        printf("Procurando valor máximo \n");
        imagem I = abrir_imagem($2);
        printf("Li imagem %d por %d\n", I.width, I.height);
        maximo_imagem(&I);
        liberar_imagem(&I);
                          }

    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  FreeImage_Initialise(0);
  yyparse();
  return 0;

}
