#Include "rwmake.ch"
/*
�����������������������������������������������������������������������������
���Programa  �MTA410BRW �Autor  �Marllon Figueiredo  � Data �  09/10/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada com a finalidade de incluir um botao com a ���
���          �opcao de impressao da pre-nota do pedido de vendas          ���
�������������������������������������������������������������������������͹��
���Uso       � MP 10                                                      ���
�����������������������������������������������������������������������������
*/
User Function MT410BRW()

	Aadd( aRotina, { 'Pr�-Nota', "u_JMHR730" ,0,7,0} )

Return
