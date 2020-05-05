#Define CRLF ( Chr(13) + Chr(10) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TRSF011     ³ Autor ³ Leandro Marquardt     ³ Data ³07/04/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao que verifica a existencia dos campos usados na rotina. ³±±
±±³          ³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_TRSF011()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                             ³±±
±±³            ³        ³      ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TRSF011()

	Local cMsg		:= ""
	Local lOk			:= .T.
	Local lAmbHml		:= ( SM0->M0_CODIGO == "99" )
	Local nCont		:= 0
	Local cTab		:= ""

	Local aAutoriz	:= {}                                  
	Local aMvCpoEnt	:= {}
	Local aMvPar		:= {} 
	
	Local aCpos 	:= {"C5_PVSTAT","C5_ORDSEP","C5_USRSEP","C5_DTASEP","C5_HRASEP",;
					 	 "C5_USRCON","C5_PVVALE","C6_QTDSEP",;
					  	 "C6_USRSEP","C6_BOXSEP","C6_QTDCONF","C9_BOXSEP","C9_QTDSEP",;
					  	 "C9_QTDCONF","C9_USRSEP","C9_DTASEP","C9_HRASEP","L1_PVSTAT",;
					  	 "L1_ORDSEP","L1_USRSEP","L1_DTASEP","L1_HRASEP","L1_USRCON",;
					  	 "L2_BOXSEP","L2_QTDSEP","L2_QTDCONF","L2_USRSEP","L2_DTASEP",;
					  	 "L2_HRASEP","LQ_PVSTAT","LQ_ORDSEP","LQ_USRSEP","LQ_DTASEP",;
					   	 "LQ_HRASEP","LQ_USRCON","LR_BOXSEP","LR_QTDSEP","LR_QTDCONF",;
					  	 "LR_USRSEP","LR_DTASEP","LR_HRASEP"}
					  	 
	
	If Type("l020Coletor") <> "L"
		Private l020Coletor := .F.
	EndIf 
					  	 
	aAdd(aMvPar, SuperGetMV( "TRS_MON001", .F., "" ) ) // Define o Fluxo operacional ( 1 ou 2 )  
	aAdd(aMvPar, 55 )											// Descontinuado o seu uso --> aAdd(aMvPar, SuperGetMV( "TRS_MON002", .F., "" ) )
	aAdd(aMvPar, "C6_PRODUTO" )								// Descontinuado o seu uso --> aAdd(aMvPar, SuperGetMV( "TRS_MON003", .F., "" ) )
	aAdd(aMvPar, .F.)											// Descontinuado o seu uso --> aAdd(aMvPar, SuperGetMV( "TRS_MON004", .F., "" ) )
	aAdd(aMvPar, SuperGetMV( "TRS_MON005", .F., "" ) )	// Considerar (Somar) na Leitura a quantidade por embalagem (B1_QE). Sendo .T. = Considerar e .F. = Não considerar 
	aAdd(aMvPar, SuperGetMv( "TRS_MON006", .F., "C5_CLIENT|C5_LOJAENT", ) ) // Campos utilizados como cliente + Loja de entrega.  
	aAdd(aMvPar, SuperGetMV( "TRS_MON007", .F., "" ) )	// Rotina de separação: .T. = Separar com liberação de estoque. .F. = Separa sem liberação de estoque. 
	aAdd(aMvPar, SuperGetMV( "TRS_MON008", .F., "" ) )	// Local padrao para Separacao de Pedidos. Ex.: 01                                                      
	aAdd(aMvPar, SuperGetMV( "TRS_MON009", .F., "" ) )	// Locais validos para Separacao de Pedidos. Ex.: 01/02/03                                               
	aAdd(aMvPar, SuperGetMV( "TRS_MON010", .F., "" ) )	// Indica se sera Utilizado Aglutinacao de Entregas. .T. = Sim, .F. = Nao  
	aAdd(aMvPar, SuperGetMV( "TRS_MON011", .F., "" ) )	// Modelo de etiqueta ( 1 = B1_COD ou 2 = B1_COD|B8_LOTE|B8_DTVALID|B8_LOTEFOR )                             
	
	aMvCpoEnt	:= StrToKArr( Upper( aMvPar[6] ), "|" )
	
	//-- Verifica se Empresa esta autorizada a utilizar a rotina
	aAutoriz := IIf( lAmbHml, {.T., ""}, u_SFAUTORI( {"TRSF010", SM0->M0_CGC, "0010"} ) )
	
	If !aAutoriz[1]
	
		lOk  := .F.
		
		If l020Coletor
		
			//       1234567890123456789012
			//                1         2 
			cMsg := "Empresa não autorizada"
			
		Else
		
			cMsg := aAutoriz[2]
			
		EndIf
		
		Conout("TRSF011 - Inicio Log - Data: " + DToC(dDatabase)+" Hora: "+cValToChar(Time()))
		Conout("TRSF011 - Mensagem: " + aAutoriz[2] )
		Conout("TRSF011 - Mensagem: Verifique a existencia do arquivo trs.cfg, na pasta system.")
		Conout("TRSF011 - Fim Log - Data: " + DToC(dDatabase)+" Hora: "+cValToChar(Time()))
	
	//-- Verifica a existecia SOMENTE dos parametros obrigatorios		  
	ElseIf 	Empty( aMvPar[1] ) 				.Or. ValType( aMvPar[5] ) <> "L" 	.Or. Empty( aMvPar[6] ) .Or.;
			 	ValType( aMvPar[7] ) <> "L" 	.Or. ValType( aMvPar[10] ) <> "L" 	.Or. Empty( aMvPar[11] ) 
		
		lOk  := .F.
		
		If l020Coletor
			
			//       1234567890123456789012
			//                1         2 
			cMsg := "Verique o preenchimen-"
			cMsg += CRLF
			cMsg += "to dos parametros."
			cMsg += CRLF
			cMsg += "TRS_MON (001, 005, 006"		
			cMsg += CRLF
			cMsg += "007, 010 e 011)"
					
		Else
		
			cMsg := "Verifique o preenchimento, ou, se os parâmetros TRS_MON001, "
			cMsg += "TRS_MON005, TRS_MON006, TRS_MON007, TRS_MON010 e TRS_MON011. "
			cMsg += "Foram criados corretamente. "
			
		EndIf
		
	Else

		//-- Adiciono os campos especificos, referente ao cliente de entrega
		aEval( aMvCpoEnt, {|x| aAdd(aCpos, x) } )
	
		For nCont := 1 to Len( aCpos )
			
			cTab := "S" + SubStr(aCpos[nCont],1,2)
			
			dbSelectArea(cTab)
			dbSetOrder(1)
			
			If (cTab)->(FieldPos( aCpos[nCont] )) = 0
			
				lOk  := .F.
			
				If l020Coletor
			
					//       1234567890123456789012
					//                1         2
					cMsg := "Problema no dicionario" 
					cMsg += CRLF
					cMsg += "de dados. Verifique os"
					cMsg += CRLF
					cMsg += "campos necessarios pa-"
					cMsg += CRLF
					cMsg += "ra o funcionamento "
					cMsg += CRLF
					cMsg += "desta rotina."
					 
				Else

					cMsg := "Os campos abaixo não foram criados. Para continuar com a rotina, favor criá-los."
					cMsg += CRLF
					cMsg += aCpos[nCont]
					cMsg += CRLF
				
				EndIf	
			
			EndIf
		
		Next nCont
	
	EndIf
	
	If !lOk
		If l020Coletor
			Iw_Msgbox( cMsg, "TRSF011|Validação|", "ALERT" )
		Else
			Aviso("TRSF011 | Validação", cMsg, {"Ok"}, 3)
		EndIf
	EndIf	
	
Return(lOk)