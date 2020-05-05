#Define CRLF ( chr(13)+chr(10) )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ JMHF080  ³ Autor ³ Andre Luis            ³ Data ³ Jun/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Transferencia interna de lote.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ u_JMHF080                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Jomhedica                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function JMHF080( aTransf, lEstorno,nlinha )

	Local cMsg	:= ""
	Local cDoc 	:= ""
	Local cMvPar := "ES_SEQLTUN"//Ultimo Lote gravado no parametro
	Local cLote	:= ""
	Local cQuery := ""
	
	Local aAuto	:= {}
	Local aItem	:= {}
	Local aMsg	:= {}
	Local aDoc	:= {}
	
	Local nItem	:= 0
	Local nP		:= 0	
	
	Local lSeek	:= .T.


	SB1->( dbSetOrder(1) )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Conteudo array aTransf      ³
	//³                             ³
	//³ aTransf[01] - Produto       ³
	//³ aTransf[02] - Local         ³
	//³ aTransf[03] - Quantidade    ³
	//³ aTransf[04] - Data Validade ³
	//³ aTransf[05] - LoteCTL       ³
	//³ aTransf[06] - Emissao       ³
	//³ aTransf[07] - Documento(NF) ³
	//³ aTransf[08] - Serie(NF)     ³
	//³ aTransf[09] - Fornecedor    ³
	//³ aTransf[10] - Loja          ³
	//³ aTransf[11] - ORIGLAN       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lEstorno  
	
	   IF nlinha==1
		   cQuery := " SELECT TOP 1 R_E_C_N_O_ TRECNO," 
		   cQuery += "				D3_DOC," 
		   cQuery += "				D3_EMISSAO"  
		Else 
		   cQuery := " SELECT DISTINCT D3_FILIAL, D3_DOC, D3_EMISSAO, MIN(R_E_C_N_O_) TRECNO "
		EndIF
		
		cQuery += " FROM 	" + RetSQLName("SD3")
		cQuery += " WHERE	D3_FILIAL	= '" + xFilial("SD3")	+ "'"
		cQuery += " 	AND	D3_DOCORI	= '" + aTransf[Len(aTransf),07]	+ "'"
		cQuery += " 	AND	D3_SERORI	= '" + aTransf[Len(aTransf),08]	+ "'"
		cQuery += " 	AND	D3_FORORI	= '" + aTransf[Len(aTransf),09]	+ "'"
		cQuery += " 	AND	D3_LOJORI	= '" + aTransf[Len(aTransf),10]	+ "'"
		cQuery += " 	AND	D3_LANORI	= '" + aTransf[Len(aTransf),11]	+ "'"
		cQuery += " 	AND	D3_TM		= '999' " // Transferencia ( ORIGEM )
		cQuery += " 	AND	D3_ESTORNO	<> 'S'"
		cQuery += " 	AND	D_E_L_E_T_ <> '*'"  
		
		IF nlinha==2   
		   cQuery += " GROUP BY D3_FILIAL, D3_DOC, D3_EMISSAO "
		EndIF
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPD3", .F., .T.)

		TcSetField("TMPD3", "D3_EMISSAO", "D")
		
		TMPD3->( dbGoTop() )
		
		aAdd(aAuto,{TMPD3->D3_DOC, TMPD3->D3_EMISSAO} )
	
		If Len(aAuto) > 0

			lAutoErrNoFile:= .T.
	 		lMsErroAuto 	:= .F.
		
			dbSelectArea("SD3")
			dbGoTo( TMPD3->TRECNO )			
		
			MATA261(aAuto,4)
			
			If lMsErroAuto
				
				cMsg := "ERRO. Verifique a mensagem abaixo:" + CRLF
				
				aMsg := GetAutoGRLog()
				
			Else
				
				cMsg := "Estorno realizado com sucesso!" + CRLF
				cMsg += "Documento: " + TMPD3->D3_DOC + CRLF 
				cMsg += "Emissao: " + DToC( TMPD3->D3_EMISSAO )

			EndIf
			
			aEval( aMsg, {|x| cMsg += x + CRLF })
			
		EndIf
	
		TMPD3->( dbCloseArea() )
		
		If !Empty(cMsg)
			Aviso("Estorno", cMsg, {"Ok"}, 3)
		EndIf
	
	Else
		
		dbSelectArea("SD3")
		dbSetOrder(1)
		
		cDoc := NextNumero("SD3",2,"D3_DOC",.T.)
		
		dbSelectArea("SX6")
		dbSetOrder(1)
		
		lSeek := dbSeek( cFilAnt + cMvPar )
		
		If !lSeek
			lSeek := dbSeek( Space(Len(cFilAnt)) + cMvPar )
		EndIf
	
		If !lSeek .Or. Empty( SX6->X6_CONTEUD )
		
			cMsg := "Impossivel transferir! Verifique o parametro." + CRLF
			cMsg += "Parametro: " + cMvPar + CRLF 
			cMsg += IIf(!lSeek .And. Empty( SX6->X6_CONTEUD ), "Em branco e nao cadastrado.", IIf(!lSeek, "Em branco.","Nao cadastrado."))
	
			Help("",1,"JMHF080",,cMsg,1,0)
		
		Else
		
			aAdd(aAuto,{ cDoc, MsDate() } )
			
			For nItem := 1 To Len(aTransf)
			
				SB1->( dbSeek(xFilial("SB1")+aTransf[nItem,1]) )
				
				If SB1->B1_RASTRO = "L" //L=Lote
			
					For nP := 1 To aTransf[nItem,3]
				
						aItem := {}
				
						RecLock("SX6", .F.)
							SX6->X6_CONTEUD := Soma1( AllTrim(SX6->X6_CONTEUD) )			
						MsUnLock()
						
						cLote := AllTrim( SX6->X6_CONTEUD )	
						
						//Origem
						aAdd(aItem,SB1->B1_COD)  		//D3_COD
						aAdd(aItem,SB1->B1_DESC)		//D3_DESCRI
						aAdd(aItem,SB1->B1_UM)  		//D3_UM
						aAdd(aItem,aTransf[nItem,02])	//D3_LOCAL
						aAdd(aItem,"")					//D3_LOCALIZ
				
						//Destino
						aAdd(aItem,SB1->B1_COD)  		//D3_COD
						aAdd(aItem,SB1->B1_DESC)		//D3_DESCRI
						aAdd(aItem,SB1->B1_UM)  		//D3_UM
						aAdd(aItem,aTransf[nItem,02])	//D3_LOCAL
						aAdd(aItem,"")					//D3_LOCALIZ
				
						//Origem
						aAdd(aItem,"")					//D3_NUMSERI
						aAdd(aItem,aTransf[nItem,05])	//D3_LOTECTL
						aAdd(aItem,"")         			//D3_NUMLOTE
						aAdd(aItem,aTransf[nItem,04])	//D3_DTVALID
						aAdd(aItem,0)					//D3_POTENCI
						aAdd(aItem,1)					//D3_QUANT
						aAdd(aItem,0)					//D3_QTSEGUM
						aAdd(aItem,"")   				//D3_ESTORNO
						aAdd(aItem,"")         			//D3_NUMSEQ
				
						//Destino
						aAdd(aItem,cLote)				//D3_LOTECTL
						aAdd(aItem,aTransf[nItem,04])	//D3_DTVALID
						aAdd(aItem,"")					//D3_ITEMGRD
				
						//Campos especificos Jomhedica
						aAdd(aItem,aTransf[nItem,05])	//Lote
						aAdd(aItem,aTransf[nItem,04])	//Data Validade
						aAdd(aItem,aTransf[nItem,07])	//Documento(NF)
						aAdd(aItem,aTransf[nItem,08])	//Serie(NF)     
						aAdd(aItem,aTransf[nItem,09])	//Fornecedor    
						aAdd(aItem,aTransf[nItem,10])	//Loja          
						aAdd(aItem,aTransf[nItem,11])	//ORIGLAN
						
						aAdd(aAuto,aItem)
						
						//Array para mostrar no final da inclusao
						aAdd(aMsg, cLote)
						
					Next nP
				
				EndIf//B1_RASTRO
			
			Next nItem
			
			If Len(aAuto) > 1
	
				lAutoErrNoFile	:= .T.
		 		lMsErroAuto 	:= .F.
			
				MSExecAuto({|x,y| MATA261(x,y)}, aAuto, 3)
				
				If lMsErroAuto
					
					cMsg := "Erro. Verifique a mensagem abaixo:" + CRLF
					
					aMsg := GetAutoGRLog()
	
					aEval(aMsg,{|x| cMsg += x + CRLF })
					
				Else
				
					cMsg := "Efetuada com sucesso!" + CRLF
					cMsg += "Lote(s) transferido(s):" + CRLF
					
					If Len(aMsg) > 1
						cMsg += "De: " + aMsg[1]
						cMsg += CRLF
						cMsg += "Ate: " + aMsg[Len(aMsg)]
					Else
						cMsg += aMsg[Len(aMsg)]
					EndIf
					
				EndIf
				
				Aviso("Transferencia", cMsg, {"Ok"}, 3)
				
			EndIf//aAuto	
				
		EndIf//lSeek
		
	EndIf//lEstorno	

Return
