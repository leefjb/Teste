#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA100REC()     �Autor  �Eliane Carvalho � Data �  11/11/05  ���
�������������������������������������������������������������������������͹��
���Desc.      �Ponto Entrada ao sair da rotina de recebimento Mov.Banc�ria���
���           �Ap�s a grava��o dos dados da contabiliza��o.               ���
���Observa��es�	Utilizado para grava��o de dados complementares.          ���
���           �                                                           ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function FA100REC()  

Local aAreaAtu := GetArea()
Local aAreaSED := SED->(getarea())
Local aAreaSE5 := SE5->(getarea())


DbSelectArea("SED")
DbSetOrder(1)
DbSeek(xFilial("SED") + SE5->E5_NATUREZ )   

If RecLock("SE5",.F.)
	SE5->E5_CREDITO := SED->ED_CONTA
	MsUnlock()
Endif

RestArea(aAreaSED)
RestArea(aAreaSE5)
Restarea(aAreaAtu)


Return
                                            
