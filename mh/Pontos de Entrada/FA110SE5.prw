#Include "protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA110SE5 � Autor � Marllon Figueiredo � Data � 17/09/2007  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar o historico da baixa conforme ���
���          � o historico do titulo (SE1->E1_HIST)                       ���
���          � Executado na rotina de Baixa Automatica                    ���
�������������������������������������������������������������������������͹��
���Uso       � EXCLUSIVO JOMHEDICA                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function FA110SE5()

If ! Empty(SE1->E1_HIST)
	Reclock("SE5",.f.)
	SE5->E5_HISTOR := SE1->E1_HIST
	MsUnlock()
Else
	Reclock("SE5",.f.)
	SE5->E5_HISTOR := SE1->E1_NOMCLI
	MsUnlock()
EndIf

Return