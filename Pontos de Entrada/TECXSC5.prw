/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � TECXSC5   � Autor � Marllon Figueiredo � Data � 06/05/2005 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada na inclusao da Ordem de Servico (Field Ser���
���          � vice) para gravar o codigo do vendedor e sua respectiva    ���
���          � comissao no pedido de vendas                               ���
��           �                                                             ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TECXSC5()
Local aArea      := GetArea()

/*
dbSelectArea('SC5')
If dbSeek(xFilial('SC5')+M->C5_NUM)
	SA3->( dbSeek(xFilial('SA3')+M->AB6_VEND1) )

	RecLock('SC5',.f.)
	SC5->C5_VEND1    := SA3->A3_COD
	SC5->C5_COMIS1   := SA3->A3_COMIS
	SC5->C5_SACADO   := M->AB6_CODCLI
	SC5->C5_LSACADO  := M->AB6_LOJA
	
    MsUnLock()
EndIf
*/

RestArea(aArea)

Return
