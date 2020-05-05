#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT241TOK ºAutor  ³ Cristiano Oliveira º Data ³ 08/03/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tem a finalidade de ser utilizado como validação da        º±±
±±º          ³ inclusão do movimento pelo usuário.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ JOMHEDICA                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT241TOK()

	Local lRet := .F.
	
	// POSICIONA NO PRODUTO
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1") + aCols[1,1])

	// VERIFICA SE EXISTE RASTREABILIDADE DO PRODUTO
	If !Empty(SB1->B1_RASTRO)  
	
		// VERIFICA SE A DATA DE VENCIMENTO É MENOR OU IGUAL A HOJE
		If aCols[1,20] <= DDATABASE
			lRet := MsgYesNo("Você tem certeza que o vencimento " + DtoC(aCols[1,20]) + " está correto?")
		
			If lRet
				nAviso := AVISO("ATENCAO", "Você realmente tem certeza que o vencimento " + DtoC(aCols[1,20]) + " está correto?", { "SIM", "NAO" }, 1)
			
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