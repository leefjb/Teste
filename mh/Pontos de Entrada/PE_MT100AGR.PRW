#include "RWMAKE.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100AGR  �Autor  �Eliane Carvalho     � Data �  15/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto ativado apos a grava��o dos dados da Nota de Entrada  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � JOMHEDICA                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
Incrementado a Impressao de Etiquetas de Lotes em 03/2007 - Fabio Briddi
*/

User Function Mt100agr()

	Local aArea     := GetArea()
	Local aAreaSF1  := SF1->( GetArea() )
	Local aAreaSD1  := SD1->( GetArea() )
	
	Private cMens := Space(Len(SF1->F1_MENOTA))
	
	If INCLUI .And. !(FunName() $ "JMHA230")
	
		@ 000,000 TO 150,500 DIALOG Tela001 TITLE "Nota Fiscal Entrada"
	
			@ 020,010 SAY "Mensagem"
			@ 020,050 Get cMens
			@ 050,050 BUTTON "_Confirma"   Size 40,15 ACTION (FContinua(),Tela001:End())
			@ 050,100 BUTTON "_Abandona"   Size 40,15 ACTION Tela001:End()
	
		ACTIVATE DIALOG Tela001 CENTERED
	
	EndIf
	
	RestArea( aAreaSF1 )
	RestArea( aAreaSD1 )
	RestArea( aArea )

Return( .t. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100AGR  �Autor  �Microsiga           � Data �  11/11/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MT100AGR                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FContinua()

	If !Empty(cMens)
	
		dbSelectArea("SF1")
		dbSeek(xFilial("SF1")+ SD1->D1_DOC+ SD1->D1_SERIE)
		IF RecLock("SF1",.f.)
			SF1->F1_MENOTA := CMENS
			SF1->F1_HORA   := Time()
			MsUnlock()
		EndIf
	
	EndIf

Return(.T.)
