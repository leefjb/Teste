#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120LOK()     �Autor  �Eliane Carvalho� Data �  09/12/05   ���
�������������������������������������������������������������������������͹��
���Desc.  Valida Retorno esperado:	    .T. ou .F.                        ���
�������������������������������������������������������������������������͹��
��           � Eliane Carvalho  Data 24/01/2006                            ��
�� Altera�ao � Valida   campos C7_CLVL acols pedido de Compra              ��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT120LOK()

Local aArea    := GetArea()
Local cContaC7 := ""
Local lReturn  := .t.
Local nPosCc   := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C7_CC"})
Local nPosICtb   := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C7_ITEMCTA"})
Local nPosConta  := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C7_CONTA"})
Local nPosClvl   := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C7_CLVL"})

cContaC7 := aCols[n,nPosConta]  // n=linha      nPosTes=Coluna

IF INCLUI .OR. ALTERA
	IF  SUBSTR(cContaC7,1,1) > "2"
		If Empty(aCols[n,nPosICtb])
			MsgBox("Obrigatorio Informar Item Conta!")
			lReturn	:= .f.
		ENDIF
		If Empty(aCols[n,nPosCc])
			MsgBox("Obrigatorio Informar Centro de Custo!")
			lReturn := .f.
		EndIf 
 	/*	If Empty(aCols[n,nPosClvl])
			MsgBox("Obrigatorio Informar Classe de Valor!")
			lReturn := .f.
		EndIf */
	EndIf
EndIf
RestArea(aArea)
Return(lReturn)


