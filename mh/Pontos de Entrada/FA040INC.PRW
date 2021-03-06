#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA040INC() �Autor  �Eliane Carvalho     � Data �  08/12/05  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto entrada p�s a valid. TudOk, inclus�o contas a pagar  ���
���Observa��es:	Utilizado para a validar a altera��o.                     ���
�������������������������������������������������������������������������͹��
��           � Eliane Carvalho  Data 24/01/2006                            ��
�� Altera�ao � Valida   campos E1_CLVL                                     ��
�� Altera�ao � Retirada Valida   campos E1_CLVL                            ��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA040INC()

Local aAreaAtu := GetArea()
Local aAreaSED := SED->(getarea())
Local Ok    := .t.

If INCLUI
	DbSelectArea("SED")
	DbSetOrder(1)
	DbSeek(xFilial("SED") + M->E1_NATUREZ )
	If  SUBSTR(SED->ED_CONTA,1,1) > "2"
		If Empty(M->E1_CCUSTO)
			MsgBox("Obrigatorio Informar Centro de Custo!")
			Ok 	:= .f.
		EndIf
		IF Empty(M->E1_ITEMCTB)
			MsgBox("Obrigatorio Informar Item Conta!")
			Ok 	:= .f.
		EndIf
		//	IF EMPTY(M->E1_CLVL)
		//		MsgBox("Obrigatorio Informar Classe de Valor!")
		//		Ok 	:= .f.
		//	ENDIF
	EndIf
	
EndIf
RestArea(aAreaSED)
Restarea(aAreaAtu)

Return Ok