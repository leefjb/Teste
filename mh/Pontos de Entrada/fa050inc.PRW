#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050INC()�Autor  �Eliane Carvalho     � Data �  11/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.       � Ponto Entrada Ap�s a valida��o do TudoOk, na             ���
���            � inclus�o do contas a pagar.                              ���
���Observa��es:	Utilizado para validar a inclus�o do contas a pagar.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������͹��
��           � Eliane Carvalho  Data 24/01/2006                            ��
�� Altera�ao � Incluida Valida   campos E1_CLVL                            ��
�� Altera�ao � Retirada a Valida   campos E1_CLVL                          ��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050INC()

Local aAreaAtu := GetArea()
Local aAreaSED := SED->(getarea())
Local Ok    := .t.

If Inclui
	DbSelectArea("SED")
	DbSetOrder(1)
	DbSeek(xFilial("SED") + M->E2_NATUREZ )
	If  SUBSTR(SED->ED_CONTA,1,1) > "2"
		If EMPTY(M->E2_CCUSTO)
			MsgBox("Obrigatorio Informar Centro de Custo!")
			Ok 	:= .f.
		EndIf
		If Empty(M->E2_ITEMCTB)
			MsgBox("Obrigatorio Informar Item Conta!")
			Ok 	:= .f.
		EndIf
		// 	IF EMPTY(M->E2_CLVL)
		//	MsgBox("Obrigatorio Informar Classe de Valor!")
		//	Ok 	:= .f.
		//	ENDIF */
	EndIf
EndIf
RestArea(aAreaSED)
Restarea(aAreaAtu)
Return ok
