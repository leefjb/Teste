#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA040ALT   �Autor  �Eliane Carvalho     � Data �  09/12/05  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto entrada p�s a valid. TudOk, altera��o Contas Receber ���
���Observa��es:	Utilizado para a validar a altera��o.                     ���
�������������������������������������������������������������������������͹��
��           � Eliane Carvalho  Data 24/01/2006                            ��
�� Altera�ao � Valida   campos E1_CLVL                                     ��
�� Altera�ao � Retirada Valida   campos E1_CLVL                            ��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA040ALT()

Local aAreaAtu := GetArea()
Local aAreaSED := SED->(getarea())
Local Ok    := .t.

If ALTERA
	DbSelectArea("SED")
	DbSetOrder(1)
	DbSeek(xFilial("SED") + M->E1_NATUREZ )
	
	If  Substr(SED->ED_CONTA,1,1) > "2"
		If Empty(M->E1_CCUSTO)
			MsgBox("Obrigatorio Informar Centro de Custo!")
			Ok 	:= .f.
		EndIf
		
		If Empty(M->E1_ITEMCTB)
			MsgBox("Obrigatorio Informar Item Conta!")
			Ok 	:= .f.
			
		EndIf
		//	IF EMPTY(M->E1_CLVL)
		//		MsgBox("Obrigatorio Informar Classe de Valor!")
		//		Ok 	:= .f.
		//  ENDIF
	EndIf
	
EndIf

RestArea(aAreaSED)
Restarea(aAreaAtu)
Return ok
