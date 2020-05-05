/*
					If ExistBlock("MT103LDV")
						aLinha := ExecBlock("MT103LDV",.F.,.F.,{aLinha,cAliasSD2})
					EndIf
*/

#include 'protheus.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �          � Autor � Marllon Figueiredo    � Data �16/11/2010���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada para carregar dados de campos especificos ���
���          � do SD2 para o SD1                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT103LDV()

aLinha    := PARAMIXB[1]
cSD2      := PARAMIXB[2]

SC6->( dbSeek(xFilial('SC6')+(cSD2)->D2_PEDIDO+(cSD2)->D2_ITEMPV) )

AAdd( aLinha, { "D1_NFIMP", SC6->C6_IMPNF, Nil } )					
AAdd( aLinha, { "D1_KITPAI", SC6->C6_KITPAI, Nil } )					

Return( aLinha )
