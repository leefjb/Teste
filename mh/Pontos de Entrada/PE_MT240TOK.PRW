#INCLUDE "TOTVS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT241TOK �Autor  � Cristiano Oliveira � Data � 08/03/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Tem a finalidade de ser utilizado como valida��o da        ���
���          � inclus�o do movimento pelo usu�rio.                        ���
�������������������������������������������������������������������������͹��
���Uso       � JOMHEDICA                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT240TOK()

	Local lRet := .F.
	
	// POSICIONA NO PRODUTO
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1") + M->D3_COD)

	// VERIFICA SE EXISTE RASTREABILIDADE DO PRODUTO
	If !Empty(SB1->B1_RASTRO)  
	
		// VERIFICA SE A DATA DE VENCIMENTO � MENOR OU IGUAL A HOJE
		If M->D3_DTVALID <= DDATABASE
			lRet := MsgYesNo("Voc� tem certeza que o vencimento " + DtoC(M->D3_DTVALID) + " est� correto?")
		
			If lRet
				nAviso := AVISO("ATENCAO", "Voc� realmente tem certeza que o vencimento " + DtoC(M->D3_DTVALID) + " est� correto?", { "SIM", "NAO" }, 1)
			
				If nAviso == 1
					lRet := .T.
				Else
					lRet := .F.
				EndIf
			EndIf		
		Else
			lRet := .T.
		EndIf
	Else
		lRet := .T.
	EndIf     
	
Return(lRet)