#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VlCC     �Autor  �Eliane Carvalho� Data �  30/11/05         ���
�������������������������������������������������������������������������͹��
���Desc.  Valida a edi��o do centro de custo e item contabil no SX3
Retorno esperado:	    .T. ou .F.
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VlCCPED()




// FUNCAO DESCONTINUADA 

Local lRet:=.F.

Return .T.



If Subs( GdFieldGet("C6_CONTA",n) , 1 , 1 ) > "2"
    lRet := .T.
Else
    lRet := .F.
Endif

Return lRet