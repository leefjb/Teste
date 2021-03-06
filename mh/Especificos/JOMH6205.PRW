#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � JOMH6205   �Autor  Ary Andrade        � Data �  09/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  COFINS - Busca para contabiliza��o de Reten��o            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function JOMH6205()

Local _aArea    := GetArea()
Local nCOFINS := 0

cPref := SF2->F2_SERIE
cNota := SF2->F2_DOC

DbSelectArea("SE1")
DbSetOrder(1)
DbSeek(xFilial("SE1")+CPREF+CNOTA )
While !eof() .And. SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM == xFilial("SE1")+CPREF+CNOTA
	If SE1->E1_TIPO == "CF-"
		nCOFINS := SE1->E1_VALOR
	EndIf
    dbskip()
enddo
RestArea(_aArea)
Return(nCOFINS)



