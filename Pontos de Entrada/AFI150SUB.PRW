#INCLUDE "PROTHEUS.CH"

/*
Jean Rehermann | SOLUTIO IT - 13/07/2016 - Valida a subconta de acordo com o banco selecionado nos par�metros
da rotina FINA150 (gera��o de arquivos de remessa banc�ria)
*/
User Function AFI150SUB()
	
	Local _lOk := .F.
	// Regra - Se banco 001 a subconta deve ser 002 | Se banco 341 a subconta deve ser 001
	_lOk := Iif( MV_PAR05 == "001", MV_PAR08 $ "002", Iif( MV_PAR05 == "341", MV_PAR08 $ "001", .T. ) )
	
Return _lOk