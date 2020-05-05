#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VlCCSE5  �Autor  �               � Data �  09/12/05         ���
�������������������������������������������������������������������������͹��
���Desc.  Valida a edi��o do centro de custo e item da conta  no SX3
Retorno esperado:	    .T. ou .F.
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP E5_CCUSTO , E5_ITEMCTB                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VlCCSE5()

Local lRet:=.F.
Local aAreaAtu := GetArea()
Local aAreaSED := SED->(getarea())


DbSelectArea("SED")
DbSetOrder(1)
DbSeek(xFilial("SED") + M->E5_NATUREZ )

If SUBSTR(SED->ED_CONTA,1,4) $ "1109" .or. SUBSTR(SED->ED_CONTA,1,1) > "2"
	lRet := .T.
Else
	lRet := .F.
Endif

RestArea(aAreaSED)
Restarea(aAreaAtu)

Return lRet
