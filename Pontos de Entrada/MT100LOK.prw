#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK()     ºAutor  ³Eliane Carvalhoº Data ³  11/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  Valida retorno esperado:	    .T. ou .F.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± Autor     ³ Eliane Carvalho                                             ±±
±±ºUso       ³ Alteraçao 18/01/2006 para tratar Classe de Valor Contabil  º±±
±±ºUso       ³ Alteraçao 18/01/2006 para retirar Classe de Valor Contabil  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT100LOK()

Local aArea    := GetArea()
Local cContaD1   := ""
Local lReturn  := .t.
Local nPosCc   := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_CC"})
Local nPosICtb   := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_ITEMCTA"})
Local nPosConta  := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_CONTA"})
//Local nPosClvl  := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_CLVL"})
cContaD1 := aCols[n,nPosConta]  // n=linha      nPosTes=Coluna

If INCLUI
	If  SUBSTR(cContaD1,1,1) > "2"
		If Empty(aCols[n,nPosICtb])
			MsgBox("Obrigatorio Informar Item Conta!")
			lReturn	:= .f.
		EndIf
		If Empty(aCols[n,nPosCc])
			MsgBox("Obrigatorio Informar Centro de Custo!")
			lReturn := .f.
		EndIf
		//	If Empty(aCols[n,nPosClvl])
		//		MsgBox("Obrigatorio Informar Classe de Valor!")
		//		lReturn := .f.
		//	EndIf
	EndIf
EndIf

RestArea(aArea)

Return(lReturn)
