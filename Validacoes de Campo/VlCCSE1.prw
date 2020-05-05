#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VlCCSE1  �Autor  �Eliane Carvalho� Data �  07/12/05         ���
�������������������������������������������������������������������������͹��
���Desc.  Valida a edi��o do centro de custo e item da conta  no SX3
Retorno esperado:	    .T. ou .F.
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP E1_CCUSTO , E1_ITEMCTB                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VlCCSE1()

Local lRet:=.F.
Local aAreaAtu := GetArea()
Local aAreaSED := SED->(getarea())


DbSelectArea("SED")
DbSetOrder(1)
DbSeek(xFilial("SED") + M->E1_NATUREZ )

If Subs(SED->ED_CONTA,1,1) > "2"
	lRet := .T.
Else
	lRet := .F.
Endif

RestArea(aAreaSED)
Restarea(aAreaAtu)

Return lRet
