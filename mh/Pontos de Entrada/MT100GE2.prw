#include 'protheus.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT100GE2 � Autor � Marllon Figueiredo � Data � 24/09/2007  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar o nome do fornecedor no histo-���
���          � rico do titulo a fim de ser impresso no extrato bancario   ���
���          � gerado por baixas automaticas do contas a pagar.           ���
�������������������������������������������������������������������������͹��
���Uso       � EXCLUSIVO JOMHEDICA                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT100GE2()

	Local aArea     := GetArea()
	Local aAreaSE2  := SE2->( GetArea() )

	/* gravar historico no titulo a pagar conforme necessidade do cliente */
	dbSelectArea('SE2')

	RecLock('SE2', .f.)
	SE2->E2_HIST    := SA2->A2_NREDUZ
	MsUnLock()
	
	RestArea( aAreaSE2 )
	RestArea( aArea )
	
Return
