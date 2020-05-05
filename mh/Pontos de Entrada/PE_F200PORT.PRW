#INCLUDE "PROTHEUS.CH"

/*
Jean Rehermann | SOLUTIO IT - 18/07/2016 - Ponto de entrada no processamento do retorno do cnab
O ponto de entrada F200PORT é utilizado para definir o banco a ser utilizado na baixa do título no retorno CNAB a Receber
.T. = Utiliza o portador do título, ignorando o banco do retorno CNAB(padrão caso não exista o ponto de entrada)
.F. = Utiliza o banco do retorno CNAB
*/

User Function F200PORT()

	Local _lAltPor := .F.

Return _lAltPor