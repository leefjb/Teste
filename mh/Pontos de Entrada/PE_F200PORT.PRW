#INCLUDE "PROTHEUS.CH"

/*
Jean Rehermann | SOLUTIO IT - 18/07/2016 - Ponto de entrada no processamento do retorno do cnab
O ponto de entrada F200PORT � utilizado para definir o banco a ser utilizado na baixa do t�tulo no retorno CNAB a Receber
.T. = Utiliza o portador do t�tulo, ignorando o banco do retorno CNAB(padr�o caso n�o exista o ponto de entrada)
.F. = Utiliza o banco do retorno CNAB
*/

User Function F200PORT()

	Local _lAltPor := .F.

Return _lAltPor