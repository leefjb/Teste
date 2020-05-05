#include "rwmake.ch"

//=============================================================================
//Programa.......: JMHG06// MICROSIGA PORTO ALEGRE.
//Objetivo.......: GATILHO ACIONADO PELO CAMPO D1_TES, BUSCA O CUSTO MEDIO DO
//               : PRODUTO E GRAVA NO CAMPO D1_VUNIT.
//               : PS..! UTILIZADO PARA CONSERVAR O CUSTO MEDIO QUANDO A ENTRADA FOR:
//               : RECEBIMENTO MATERIAL NEGOCIAD0(TROCADO/EMPRESTADO/BRINDE), ATUALIZANDO
//               : A QUANTIDADE EM ESTOQUE.
//               : PERMISSA!! A TES DEVERA TER NO CAMPO TIPO DE MOVIMENTO F4_TPMOV O CODIGO MATERIAL NEGOCIADO
//               : QUE ESTA CADASTRADO NA TABELA DJ DO SX5
//-----------------------------------------------------------------------------
//Autor             |   Data   | Alteracao
//ELIANE  CARVALHO  | 28/10/04 |
//
//------------------|----------|-----------------------------------------------------
/*
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
� Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*/

User Function JMHG06(lTES)

Local aArea    := GetArea()
Local nRecZ3   := 0
Local cAlias   := ''
Local lOk      := 0
Local nPos     := 0
Local cLocPad  := ''
Local nCusto   := 0
Local cCodProd := Space(15)
Local lCalCus  := .F.

nPos     := aScan(aHeader,{|X| ALLTRIM(X[2]) == "D1_VUNIT" })
nCusto   := aCols[ n, nPos]
nPos     := aScan(aHeader,{|X| ALLTRIM(X[2]) == "D1_COD" })
cCodProd := aCols[ n, nPos]
nPos     := aScan(aHeader,{|X| ALLTRIM(X[2]) == "D1_TES" })
cTES     := aCols[ n, nPos]
nPos     := aScan(aHeader,{|X| ALLTRIM(X[2]) == "D1_QUANT" })
nQtdVen  := aCols[ n, nPos]


If !lCalCus
	
	DbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek( xFilial("SF4")+cTES )
	
	If F4_TPMOV == "8" .AND. F4_ESTOQUE=="S"
		
		lCalCus := .T.
		
	EndIf
	
EndIf

If lCalCus
	
	DbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+cCodProd)
	cLocPad := SB1->B1_LOCPAD
	
	DbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(xFilial("SB2")+cCodProd+cLocPad)
		nCusto := SB2->B2_CM1
	EndIf
	If nCusto == 0
		Alert("O Custo Medio do Produto " +cCodProd + " Almoxarifado " +  cLocPad +" deve ser corrigido,Valor zerado, Verifique!")
	EndIf
	
EndIf

RestArea(aArea)// retorna area original

// nPos            := aScan(aHeader,{|X| ALLTRIM(X[2]) == "D1_TOTAL" })
// aCols[ n, nPos] := Round( nQtdVen * nCusto,2)

Return(nCusto)

