#include "protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA010OK �Autor  � Marllon figueiredo � Data �  11/07/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto Entrada com a finalidade de armazenar algumas infor- ���
���          � macoes sobre o produto para caso do mesmo ser excluido. des���
���          � ta forma eu consigo enviar um e-mail com os dados da exclu- ���
���          � sao.                                                        ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MTA010OK()
	VAR_IXB := 	{SB1->B1_COD,;
			       SB1->B1_DESC,;
			       SB1->B1_GRUPO,;
			       dDataBase,;
			       SB1->B1_LOCPAD,;
			       SB1->B1_TIPO}
Return
