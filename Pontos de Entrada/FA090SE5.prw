#Include "protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA090SE5 � Autor � Marllon Figueiredo � Data � 17/09/2007  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar o historico da baixa conforme ���
���          � o historico do titulo (SE2->E2_HIST)                       ���
���          � Executado na rotina de Baixa Automatica                    ���
�������������������������������������������������������������������������͹��
���Uso       � EXCLUSIVO JOMHEDICA                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function FA090SE5()

If ! Empty(SE2->E2_HIST)
	Reclock("SE5",.f.)
	SE5->E5_HISTOR := SE2->E2_HIST
	MsUnlock()
Else
	Reclock("SE5",.f.)
	SE5->E5_HISTOR := SE2->E2_NOMFOR
	MsUnlock()
EndIf

Return