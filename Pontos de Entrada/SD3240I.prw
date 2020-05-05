#include "protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SD3240I  �Autor  �Marllon Figueiredo  � Data �  09/04/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto Entrada para gravacao do numero do lote do fornecedor���
���          � informado na mov. interna (SD3)                            ���
�������������������������������������������������������������������������͹��
���Uso       � Inclusao de Mov. Interno                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/  

User Function SD3240I()

Local aArea    := GetArea()
Local aAreaSB8 := SB8->( GetArea() )


dbSelectArea('SB8')
dbSetOrder(3)
If dbSeek(xFilial('SB8')+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_LOTECTL)
	RecLock('SB8',.F.)
		SB8->B8_LOTEFOR := SD3->D3_LOTEFOR
	MsUnLock()
EndIf

RestArea(aAreaSB8)
RestArea(aArea)

Return
