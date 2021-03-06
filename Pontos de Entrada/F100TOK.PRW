#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F100TOK()      �Autor  �Eliane Carvalho � Data �  11/09/05  ���
�������������������������������������������������������������������������͹��
���Desc.      �Ponto Entrada ao sair da rotina de recebimento Mov.Banc�ria���
���           �Ap�s a grava��o dos dados da contabiliza��o.               ���
���Observa��es�	Utilizado para validar os dados da movimenta��o banc�ria. ���
���           �                                                           ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������͹��
��           � Eliane Carvalho  Data 27/01/2006                            ��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F100TOK() 

Local aAreaAtu := GetArea()
Local aAreaSE5 := SE5->(getarea())
Local aAreaSED := SED->(getarea())
Local Ok    := .t.      

If INCLUI
	DbSelectArea("SED")
	DbSetOrder(1)
	DbSeek(xFilial("SED") + M->E5_NATUREZ )
	If SUBSTR(SED->ED_CONTA,1,4) $ "1109" .or. SUBSTR(SED->ED_CONTA,1,1) > "2"
		IF Empty(M->E5_CCUSTO)
			MsgBox("Obrigatorio Informar Centro de Custo!")
			Ok 	:= .f.
		EndIf
		If Empty(M->E5_ITEMCTB)
			MsgBox("Obrigatorio Informar Item Conta!")
			Ok 	:= .f.
		EndIf
	EndIf
EndIf
RestArea(aAreaSED)
RestArea(aAreaSE5)
Restarea(aAreaAtu)

Return ok
