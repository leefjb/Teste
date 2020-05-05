#INCLUDE "TOTVS.CH"
                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M410PVNF  º Autor ³ Cristiano Oliveira º Data ³ 04/07/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CASO O PEDIDO ESTEJA SEM LOTE E VALIDADE, BUSCA DO SB8     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ JOMHÉDICA                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410PVNF()

	Local lRet     := .T.
	Local cQuery   := ""
	Local cProdTmp := "" 
	Local cPedTmp  := ""
	     
	// RECEBE O NUMERO DE PEDIDO QUE ESTÁ EM MEMÓRIA               
	cPedTmp := SC5->C5_NUM
	
	cQuery += " SELECT                                  " + CRLF
	cQuery += "   C9_FILIAL,                            " + CRLF
	cQuery += "   C9_PEDIDO,                            " + CRLF
	cQuery += "   C9_ITEM,                              " + CRLF
	cQuery += "   C9_SEQUEN,                            " + CRLF
	cQuery += "   C9_PRODUTO                            " + CRLF
	cQuery += " FROM                                    " + CRLF
	cQuery += "   SC9010 SC9                            " + CRLF
	cQuery += " WHERE                                   " + CRLF
	cQuery += "   SC9.C9_PEDIDO = '" + cPedTmp + "' AND " + CRLF     
	cQuery += "   SC9.C9_LOTECTL = '' AND               " + CRLF     
	cQuery += "   SC9.C9_DTVALID = '' AND               " + CRLF     
	cQuery += "   SC9.D_E_L_E_T_ <> '*'                 " + CRLF

	dbUseArea( .T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSC9",.F.,.T. )

  	While TMPSC9->( !EOF() )
		                 
		cProdTmp := TMPSC9->C9_PRODUTO
			
		cQuery := ""	
		cQuery += " SELECT TOP 1                                     " + CRLF
		cQuery += "   B8_LOTEFOR,                                    " + CRLF
		cQuery += "   B8_DTVALID                                     " + CRLF
		cQuery += " FROM                                             " + CRLF
		cQuery += "   SB8010 SB8                                     " + CRLF
		cQuery += " WHERE                                            " + CRLF
		cQuery += "   SB8.B8_PRODUTO = '" + cProdTmp + "' AND        " + CRLF
		cQuery += "   SB8.D_E_L_E_T_ <> '*'                          " + CRLF
		cQuery += " ORDER BY                                         " + CRLF
		cQuery += "   SB8.B8_DATA DESC                               " + CRLF
		       			
		dbUseArea( .T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSB8",.F.,.T. ) 
		TcSetField( "TMPSB8","B8_DTVALID","D",08,00 )
	  	While TMPSB8->( !EOF() )
			             
			DbSelectArea("SC9")
			DbSetOrder(1)
			If DbSeek(TMPSC9->C9_FILIAL + TMPSC9->C9_PEDIDO + TMPSC9->C9_ITEM + TMPSC9->C9_SEQUEN + TMPSC9->C9_PRODUTO)
 				RecLock("SC9", .F.)
 				SC9->C9_LOTECTL := TMPSB8->B8_LOTEFOR
 				SC9->C9_DTVALID := TMPSB8->B8_DTVALID
 				SC9->C9_BLEST   := ""
 				MsUnlock()
			EndIf
		
			TMPSB8->(DbSkip())
		EndDo
		
		TMPSB8->(DbCloseArea())
		
    	TMPSC9->(DbSkip())
	EndDo
	
	TMPSC9->(DbCloseArea())
	
Return(lRet)