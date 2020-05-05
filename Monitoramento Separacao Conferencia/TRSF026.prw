#Include 'Totvs.ch'    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ TRSF026  ³ Autor ³ Leandro Marquardt     ³ Data ³ 11/03/15 ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio auxiliar para separacao.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRSF026( aNum )                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TRSF026( aNum )
	
	Local oReport     
	

	oReport := ReportDef( aNum )    
				
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ReportDef   ³ Autor ³ Leandro Marquardt     ³ Data ³11/03/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Definicao do objeto do relatorio personalizavel e da secao    ³±±
±±³          ³ que sera utilizada.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef( aNum )                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef( aNum ) 
	
	Local oReport, oSection, oBreak
	Local cReport		:= "TRSF026"
	Local cTitulo		:= ""
	Local cDescri		:= "Este relatorio ira imprimir os produtos com suas respectivas quantidades de venda para separação."
	Local cPerg		:= PadR( "TRSF026", Len( SX1->X1_GRUPO ) )
              
   
	If !SX1->( dbSeek(cPerg) )
		CriaSX1( cPerg )
	EndIf	
  
	oReport := TReport():New( cReport, cTitulo, cPerg, {||}, cDescri )
	
	If Pergunte(cPerg,.T.)
	    	                                                                      
		If MV_PAR01 = 1 // 1 = Sim impressora fiscal  	
	
			oReport:nFontBody := 10//08
			oReport:cFontBody := "Courier New" //"Arial"
			oReport:SetLineHeight(10)
	
			oReport:HideParamPage()	// Inibe impressao da pagina de parametros
			oReport:SetPortrait()  	// Retrato
			oReport:HideHeader()   	// Nao imprime cabecalho padrao do Protheus
			oReport:HideFooter()   	// Nao imprime rodape padrao do Protheus
			
			oReport:bAction := { |oReport| F026NFis( oReport, aNum ) }
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao da secao                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			oSection := TRSection():New( oReport, "Pedido", {"SL2"} )
			
			oSection:SetLineHeight(10)
			
			oReport:SetDevice(2) 
			oReport:SetEnvironment(2)
			oReport:lPreview := .F.
			
			oReport:oPage:setPaperSize(10)//A4

			oReport:Print(.F.)      
			
		Else	
	
			oReport:SetPortrait()	// Retrato
			oReport:nFontBody := 12
			oReport:cFontBody := "Arial"
			oReport:SetLineHeight(50)                                         
			oReport:HideParamPage()	// Inibe impressao da pagina de parametros
			
			oReport:bAction := { |oReport| F026Imp( oReport, aNum ) }
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao da secao                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			oSection := TRSection():New( oReport, "Pedido", {"SL2"} )
			
			TRCell():New( oSection, "L2_LOCALIZ"	, "SL2",  "Localização"	,/*Mascara*/,TamSX3("B1_END1")[1], /*lPixel*/, /*{|| code-block de impressao }*/,"LEFT",.T.,"LEFT",,,.T.)
			TRCell():New( oSection, "B1_REFEREN"	, "SB1",  "Referencia"	,/*Mascara*/,20, /*lPixel*/, /*{|| code-block de impressao }*/,"LEFT",.T.,"LEFT",,,.T.)
			TRCell():New( oSection, "L2_DESCRI"  	, "SL2",  "Descrição"   ,/*Mascara*/,TamSX3("L2_DESCRI")[1], /*lPixel*/, /*{|| code-block de impressao }*/,"LEFT",.T.,"LEFT",,,.T.)
			TRCell():New( oSection, "C6_QTDVEN"	, "SC6",  "Quantid."		,"@E 999999.99", TamSX3("C6_QTDVEN")[1], /*lPixel*/, /*{|| code-block de impressao }*/,"RIGHT",.T.,"RIGHT",,,.T.)
			
		   	//oSection:SetHeaderSection(.F.)
		   	
		   	oReport:PrintDialog()
		   		
		EndIf
	EndIf
		
Return( oReport )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ F026NFis    ³ Autor ³ Maia                  ³ Data ³24/08/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime na impressora nao fiscal                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F026Imp( oReport, aNum )                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function F026NFis( oReport, aNum ) 

	Local cQuery		:= ""
	Local cAliasQry	:= GetNextAlias()
	Local cReferen 	:= ""
	Local nLinRefe 	:= 0
	Local nLinha		:= 0	
	Local oSection	:= oReport:Section(1)	
	Local nTotQtd		:= 0
	Local nX			:= 0
	Local nY			:= 0
	Local nPag		:= 0    
	Local cCondPgto	:= ""
	Local cDescProd	:= ""
	Local nLinDescP	:= 0
	Local nTotEnd 	:= 0
	
	Local Cobscli 	:= ""
	Local nLMemo 		:= 0     
	Local nLCorrente	:= 0
	Local nContLin	:= 0

	Local oFont10n 	:= TFont():New("Courier New",,10,,.T.)
   	Local oFont10  	:= TFont():New("Courier New",,10,,.F.)
   	Local oFont12n 	:= TFont():New("Courier New",,12,,.T.)
	
	 
	For nX := 1 To Len( aNum )
	
		nPag := 1

		If aNum[nX,1] = "LOJ" 
		
			cQuery := " SELECT	L2_ITEM	ITEM, " 
			cQuery += " 	   		L2_PRODUTO	PROD, " 
			cQuery += " 	   		B1_DESC	DESCRI, " 
			cQuery += " 	   		L2_QUANT	QUANT, " 
			cQuery += " 	   		L2_VRUNIT	VALOR, " 
			cQuery += " 	   		L1_FRETE  	FRETE, " 
			cQuery += " 	   		L2_LOCALIZ	LOCALIZ," 
			cQuery += " 	   		L2_LOCAL 	LOCAL,"        
			cQuery += " 	   		L1_CLIENTE	CLIENTE," 
			cQuery += " 	   		L1_VEND	VEND,"          
			cQuery += " 	   		L1_EMISSAO	EMISSAO," 
			cQuery += " 	   		L1_FILIAL	FILIAL," 
			cQuery += " 	   		L1_TRANSP	TRANSP," 
			cQuery += " 	   		L1_COND 	CONDPAG,"  
			cQuery += " 	   		B1_END1 	ENDFIL1,"  
			cQuery += " 	   		B1_END2 	ENDFIL2,"  
			cQuery += " 	   		B1_REFEREN	REFERENCIA "  
			
			cQuery += " FROM " + RetSqlName("SL2") +  " SL2 " 
			
			/* ORCAMENTO */
			cQuery += " INNER JOIN " + RetSqlName("SL1") + " SL1 ON " 
			cQuery += "      SL1.L1_FILIAL   = SL2.L2_FILIAL " 
			cQuery += "  AND SL1.L1_NUM      = SL2.L2_NUM "   
			cQuery += "  AND SL1.D_E_L_E_T_ 	<> '*' " 
			
			/* PRODUTO */
			cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON " 
			cQuery += "      SB1.B1_FILIAL   = '" + xFilial("SB1") + "'"
			cQuery += "  AND SB1.B1_COD      = SL2.L2_PRODUTO "   
			cQuery += "  AND SB1.D_E_L_E_T_ 	<> '*' " 

			cQuery += " WHERE SL2.L2_FILIAL 	= '"+ xFilial( "SL2" ) +"'"  
			cQuery += " 	AND SL2.L2_NUM 		= '" + aNum[nX,2] + "' " 
			cQuery += " 	AND SL2.D_E_L_E_T_ 	<> '*' "	 
			
			cQuery += " ORDER BY B1_END1, B1_END2 "	  
			
		Else   
		
			cQuery := " SELECT	C6_ITEM	ITEM, " 
			cQuery += " 	   		C6_PRODUTO	PROD, " 
			cQuery += " 			B1_DESC 	DESCRI," 
			cQuery += " 	   		C6_QTDVEN 	QUANT, " 
			cQuery += " 	   		C6_PRCVEN 	VALOR, " 
			cQuery += " 	   		C5_FRETE  	FRETE, " 
			cQuery += " 	   		C6_LOCALIZ	LOCALIZ,"        
			cQuery += " 	   		C6_LOCAL 	LOCAL,"        
			cQuery += " 	   		C5_CLIENTE	CLIENTE," 
			cQuery += " 	   		C5_VEND1	VEND," 
			cQuery += " 	   		C5_EMISSAO	EMISSAO," 
			cQuery += " 	   		C5_FILIAL	FILIAL," 
			cQuery += " 	   		C5_TRANSP	TRANSP," 
			cQuery += " 	   		C5_CONDPAG	CONDPAG," 
			cQuery += " 	   		B1_END1 	ENDFIL1,"  
			cQuery += " 	   		B1_END2 	ENDFIL2,"  
			cQuery += " 	   		B1_REFEREN	REFERENCIA "  
			                                          
			cQuery += " FROM " + RetSqlName("SC6") + " SC6 " 

			/* PEDIDO */
			cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 ON " 
			cQuery += "      SC5.C5_FILIAL   = SC6.C6_FILIAL " 
			cQuery += "  AND SC5.C5_NUM      = SC6.C6_NUM "   
			cQuery += "  AND SC5.D_E_L_E_T_ 	<> '*' " 

			/* PRODUTO */
			cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON " 
			cQuery += "      SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
			cQuery += "  AND SB1.B1_COD     = SC6.C6_PRODUTO "   
			cQuery += "  AND SB1.D_E_L_E_T_ <> '*' " 

			cQuery += " WHERE	SC6.C6_FILIAL 	= '"+ xFilial( "SC6" ) +"'"  
			cQuery += " 	AND	SC6.C6_NUM 		= '" + aNum[nX,2] + "' " 
			cQuery += " 	AND	SC6.D_E_L_E_T_ 	<> '*' "
				 
			cQuery += " ORDER BY B1_END1, B1_END2 " 
				
		EndIf

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)
		
		(cAliasQry)->( dbGoTop() )
			
		oSection:Init()
				
		cNomEmp:=""                    
		dbSelectArea( "SM0" )
		dbSetOrder( 1 )
		dbGoTop()
		While SM0->( !EOF() )
			If SM0->M0_CODIGO = cEmpAnt //-- Somente as filiais da empresa logada
	          cNomEmp:= SM0->M0_NOME
			EndIf
			SM0->( dbSkip() )
		EndDo

		SM0->( dbSeek(cEmpAnt+cFilAnt) )        
		
		nLinha:=50
		oReport:Say( nLinha,0050,cNomEmp, ofont10 )
		oReport:SkipLine()

		nLinha+=50
		oReport:Say( nLinha,0050,"Pedido..: " + aNum[nX,2] + " - " + aNum[nX,1], ofont12n )
		oReport:SkipLine()
                                          
		nLinha+=50       
		oReport:Say( nLinha,0050,"Filial....: " + (cAliasQry)->FILIAL  + " Data..: " + Transform(Stod((cAliasQry)->EMISSAO),"@R 99/99/9999") , ofont10)
		oReport:SkipLine()
                                  
		cNomCli:=""              
		dbselectarea("SA1")
		Dbsetorder(1)
		if dbseek(xfilial("SA1") + (cAliasQry)->CLIENTE)
		   cNomCli:= SA1->A1_NOME 
		Endif   
	
		nLinha+=50  
		oReport:Say( nLinha,0050,"Cliente...: " + cNomCli, ofont10 )
		oReport:SkipLine()
		                            
		cNomVend:=""              
		dbselectarea("SA3")
		Dbsetorder(1)
		if dbseek(xfilial("SA3") + (cAliasQry)->VEND)
		   cNomVend:= SA3->A3_NOME 
		Endif   
	
		nLinha+=50  
		oReport:Say( nLinha,0050,"Vendedor..: " + cNomVend , ofont10)
		oReport:SkipLine()
		
		cNomTransp:=""              
		dbselectarea("SA4")
		Dbsetorder(1)
		if dbseek(xfilial("SA4") + (cAliasQry)->TRANSP)
		   cNomTransp:= SA4->A4_NOME 
		Endif   
	
		nLinha+=50  
		oReport:Say( nLinha,0050,"Transport.: " + cvaltochar( (cAliasQry)->TRANSP) + "-" + cNomTransp , ofont10)
		oReport:SkipLine()
		 
		If ValType( (cAliasQry)->CONDPAG ) = "N"
			cCondPgto := StrZero( (cAliasQry)->CONDPAG, TamSx3("E4_CODIGO")[1] )
		Else
			cCondPgto := (cAliasQry)->CONDPAG
		EndIf

		cDescCond:=""              
		dbselectarea("SE4")
		Dbsetorder(1)
		if dbseek(xfilial("SE4") + cCondPgto)
		   cDescCond:= SE4->E4_DESCRI 
		Endif   
			
    	nLinha+=50
		oReport:Say( nLinha,0050,"Pgto......: " + cCondPgto + "-" + cDescCond , ofont10)
		oReport:SkipLine()

		nLinha+=50
		//                                 1         2         3         4
      	//                        1234567890123456789012345678901234567890
		oReport:Say( nLinha,0050,"----------------------------------------" , ofont10)
		oReport:SkipLine()
		
		If (cAliasQry)->( !EoF() )
		
			nVlrTot:= 0
		
			While (cAliasQry)->( !EoF() )              
			
				cEndereco:=""
				/*
				Dbselectarea("SBF")
				DbSetOrder(1)
				if dbSeek( xFilial("SBF")+(cAliasQry)->LOCAL+(cAliasQry)->LOCALIZ+(cAliasQry)->PROD, .T. )
				  cEndereco:= SBF->BF_LOCALIZ
				endif
				*/
				
				If cFilAnt = "0101"
					cEndereco := (cAliasQry)->ENDFIL1 
				ElseIf cFilAnt = "0102"
					cEndereco := (cAliasQry)->ENDFIL2 
				EndIf
				
				nLinha += F026Final( @oReport, @oSection, @nLinha )
				oReport:Say( nLinha,0050,"Endereço:", ofont12n)
				oReport:Say( nLinha,0275,cEndereco, ofont12n)
				oReport:SkipLine()
								                  
				While (cAliasQry)->( !EoF() ) .And. ( cEndereco = (cAliasQry)->ENDFIL1 .Or. cEndereco = (cAliasQry)->ENDFIL2 )
				
					nLinha += F026Final( @oReport, @oSection, @nLinha ) //50
					oReport:Say( nLinha,0075,"Quantid." , ofont10n )
					oReport:Say( nLinha,0275,"Referência" , ofont10n)
					oReport:SkipLine()
	
					/*
					nLinha += F026Final( @oReport, @oSection, @nLinha ) //50
					oReport:Say( nLinha,0075,Transform((cAliasQry)->QUANT,"@E 9,999.99") , ofont10  )
					oReport:Say( nLinha,0275,(cAliasQry)->REFERENCIA , ofont10 )
					oReport:SkipLine()
					*/

					nLinha += F026Final( @oReport, @oSection, @nLinha ) //50
					oReport:Say( nLinha, 0075, Transform((cAliasQry)->QUANT,"@E 9,999.99"), ofont10 )
					
					cReferen := AllTrim( (cAliasQry)->REFERENCIA )
					nLinRefe := MlCount( cReferen, 25, , .F. )
					
					For nY := 1 To nLinRefe
						
						oReport:Say( nLinha, 0275, MemoLine( cReferen, 25, nY ), ofont10 )
						oReport:SkipLine()
						
						If nY < nLinRefe
							nLinha += F026Final( @oReport, @oSection, @nLinha ) //50
						EndIf
						
					Next nY
					
					nLinha += F026Final( @oReport, @oSection, @nLinha ) //50
					oReport:Say( nLinha, 0075, "Descrição", ofont10n )
					oReport:SkipLine()
					
					cDescProd 	:= AllTrim( (cAliasQry)->DESCRI )
					nLinDescP 	:= MlCount( cDescProd, 40, , .F. ) 
					
					For nY := 1 To nLinDescP
						nLinha += F026Final( @oReport, @oSection, @nLinha ) //50                        
						oReport:Say( nLinha, 0075, MemoLine(cDescProd, 40, nY), ofont10 )
						oReport:SkipLine()
					Next nY

					nTotQtd += (cAliasQry)->QUANT
					nVlrTot += (cAliasQry)->QUANT * (cAliasQry)->VALOR
				   		
					(cAliasQry)->( dbSkip() )
					
				EndDo
				
			EndDo
                     
        	//                                 1         2         3         4
        	//                        1234567890123456789012345678901234567890
        	nLinha += F026Final( @oReport, @oSection, @nLinha )//50
			oReport:Say( nLinha,0050,"----------------------------------------" , ofont10)
			oReport:SkipLine() 
	
			nLinha += F026Final( @oReport, @oSection, @nLinha )//50
			oReport:Say(nLinha,0050,+"Total de Produtos: " + Transform(nTotQtd,"@E 999,999.99"), ofont10 )
			oReport:SkipLine()  
	
			nLinha += F026Final( @oReport, @oSection, @nLinha)//50
			oReport:Say( nLinha,0050,"Valor Total......: " + Transform(nVlrTot,"@E 999,999.99") , ofont10)
			oReport:SkipLine()
	                                             
	    	nLinha += F026Final( @oReport, @oSection, @nLinha )//50
			oReport:Say( nLinha,0050,"Valor Frete......: " + Transform( (cAliasQry)->FRETE,"@E 999,999.99") , ofont10)
			oReport:SkipLine() 
	    		                         
      		nLinha += F026Final( @oReport, @oSection, @nLinha )//50
			oReport:Say( nLinha,0050,"Observação.......: " , ofont10)
			oReport:SkipLine()
			
			If aNum[nX,1] = "LOJ"
			
				dbSelectArea("SL1")
				dbSetOrder(1)
				dbSeek( xFilial("SL1") + aNum[nX,2] )
			
				cObsCli := Upper( AllTrim( SL1->L1_OBS ) )
				
			Else
			
				dbSelectArea("SC5")
				dbSetOrder(1)
				dbSeek( xFilial("SC5") + aNum[nX,2] )
			
				cObsCli := Upper( AllTrim( SC5->C5_OBS ) )
				
			EndIf
			
			nLMemo 	:= 0     
			nLCorrente	:= 0
			nLMemo 	:= MLCount( cObsCli, 40 , , .F.)
			  
			For nLCorrente := 1 To nLMemo
			
				nLinha += F026Final( @oReport, @oSection, @nLinha ) //50
				oReport:Say( nLinha, 0050, MemoLine( cObscli, 40, nLCorrente ), ofont10 )
				oReport:SkipLine()
			
			Next nLCorrente

      		nLinha += ( F026Final( @oReport, @oSection, @nLinha ) + 10 ) //60
			oReport:Say(nLinha,0050,+"Quant Volumes....: ___________________" , ofont10)
			oReport:SkipLine()  
      		
      		nLinha += ( F026Final( @oReport, @oSection, @nLinha ) + 10 ) //60
			oReport:Say(nLinha,0050,+"Separador .......: ___________________" , ofont10)
			oReport:SkipLine()  
      		
      		nLinha += ( F026Final( @oReport, @oSection, @nLinha ) + 10 ) //60
			oReport:Say(nLinha,0050,+"Conferente.......: ___________________" , ofont10)
			oReport:SkipLine()  
			
		Else

			oReport:SkipLine()
			oReport:Say( oReport:Row(),005,"Não há registros para exibir." )
			oReport:SkipLine(2)
			
		EndIf
			
		oSection:Finish()
		
		oReport:EndPage(.T.)

		nTotQtd := 0
		
		(cAliasQry)->( dbCloseArea() )
		
	Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ F026Final   ³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Controle de final de pagina.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F026Final( oReport, oSection, nLinha, nLimit )                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function F026Final( oReport, oSection, nLinha )

	If oReport:Row() >= 670 // 700 // Limite da pagina

		oSection:Finish()
	
		oReport:EndPage(.T.)
		
		oSection:Init()
		
		oReport:SetRow( 10 )
		
		nLinha := oReport:Row()
							
	EndIf

Return( 50 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ F026Imp     ³ Autor ³ Leandro Marquardt     ³ Data ³11/03/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o objeto oReport definido na funcao ReportDef.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F026Imp( oReport, aNum )                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function F026Imp( oReport, aNum ) 

	Local cQuery		:= ""
	Local cAliasQry	:= GetNextAlias()
	Local nLinha		:= 0	
	Local oSection 	:= oReport:Section(1)	
	Local nTotQtd		:= 0
	Local nX			:= 0
	Local nPag		:= 0
	                               
	
	For nX := 1 to Len( aNum )
	
		nPag := 1

		If aNum[nX,1] = "LOJ" 
		
			cQuery := " SELECT	L2_ITEM	ITEM, " 
			cQuery += " 	   		L2_PRODUTO	PROD, " 
			cQuery += " 	   		B1_DESC		DESCRI, " 
			cQuery += " 	   		L2_QUANT	QUANT, " 
			cQuery += " 	   		L2_VRUNIT	VALOR, " 
			cQuery += " 	   		L1_FRETE  	FRETE, " 
			cQuery += " 	   		L2_LOCALIZ	LOCALIZ," 
			cQuery += " 	   		L2_LOCAL 	LOCAL,"        

			cQuery += " 	   		L1_CLIENTE	CLIENTE," 
			cQuery += " 	   		L1_VEND		VEND,"          
			cQuery += " 	   		L1_EMISSAO	EMISSAO," 
			cQuery += " 	   		L1_FILIAL	FILIAL," 
			cQuery += " 	   		L1_TRANSP	TRANSP," 
			cQuery += " 	   		L1_COND 	CONDPAG,"  
			cQuery += " 	   		L1_OBS   	OBSERV,"  
			cQuery += " 	   		B1_END1 	ENDFIL1,"  
			cQuery += " 	   		B1_END2 	ENDFIL2,"  
			cQuery += " 	   		B1_REFEREN 	REFERENCIA "  
			
			cQuery += " FROM " + RetSqlName("SL2") +  " SL2 " 
			
			/* ORCAMENTO */
			cQuery += " INNER JOIN " + RetSqlName("SL1") + " SL1 ON " 
			cQuery += "      SL1.L1_FILIAL   = SL2.L2_FILIAL " 
			cQuery += "  AND SL1.L1_NUM      = SL2.L2_NUM "   
			cQuery += "  AND SL1.D_E_L_E_T_ 	<> '*' " 
			
			/* PRODUTO */
			cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON " 
			cQuery += "      SB1.B1_FILIAL   = '" + xFilial("SB1") + "'"
			cQuery += "  AND SB1.B1_COD      = SL2.L2_PRODUTO "   
			cQuery += "  AND SB1.D_E_L_E_T_ 	<> '*' " 

			cQuery += " WHERE 	L2_FILIAL 	= '"+ xFilial( "SL2" ) +"'"  
			cQuery += " 	AND L2_NUM 		= '" + aNum[nX,2] + "' " 
			cQuery += " 	AND SL2.D_E_L_E_T_ 	<> '*' "	 

			cQuery += " ORDER BY B1_END1, B1_END2 " 
			
		Else   
		
			cQuery := " SELECT	C6_ITEM	ITEM, " 
			cQuery += " 	   		C6_PRODUTO	PROD, " 
			cQuery += "				B1_DESC 	DESCRI, " 
			cQuery += " 	   		C6_QTDVEN 	QUANT, " 
			cQuery += " 	   		C6_PRCVEN 	VALOR, " 
			cQuery += " 	   		C5_FRETE  	FRETE, " 
			cQuery += " 	   		C6_LOCALIZ	LOCALIZ,"        
			cQuery += " 	   		C6_LOCAL 	LOCAL,"        
			cQuery += " 	   		C5_CLIENTE	CLIENTE," 
			cQuery += " 	   		C5_VEND1	VEND," 
			cQuery += " 	   		C5_EMISSAO	EMISSAO," 
			cQuery += " 	   		C5_FILIAL	FILIAL," 
			cQuery += " 	   		C5_TRANSP	TRANSP," 
			cQuery += " 	   		C5_CONDPAG	CONDPAG," 
			cQuery += " 	   		C5_OBS   	OBSERV,"  
			cQuery += " 	   		B1_END1 	ENDFIL1,"  
			cQuery += " 	   		B1_END2 	ENDFIL2,"  
			cQuery += " 	   		B1_REFEREN 	REFERENCIA "  
			                                          
			cQuery += " FROM " + RetSqlName("SC6") + " SC6 " 

			/* Pedido */
			cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 ON " 
			cQuery += "      SC5.C5_FILIAL   = SC6.C6_FILIAL " 
			cQuery += "  AND SC5.C5_NUM      = SC6.C6_NUM "   
			cQuery += "  AND SC5.D_E_L_E_T_ 	<> '*' " 
			
			/* PRODUTO */
			cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON " 
			cQuery += "      SB1.B1_FILIAL   = '" + xFilial("SB1") + "'"
			cQuery += "  AND SB1.B1_COD      = SC6.C6_PRODUTO "   
			cQuery += "  AND SB1.D_E_L_E_T_ <> '*' " 
			
			cQuery += " WHERE SC6.C6_FILIAL 	= '"+ xFilial( "SC6" ) +"'"  
			cQuery += " 	AND SC6.C6_NUM 		= '" + aNum[nX,2] + "' " 
			cQuery += " 	AND SC6.D_E_L_E_T_ 	<> '*' "	 

			cQuery += " ORDER BY B1_END1, B1_END2 " 
				
		EndIf

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)
		
		(cAliasQry)->( dbGoTop() )
		
		oSection:Init(.F.)
		oReport:cTitle := "Separação do Pedido número: " + aNum[nX,2] 
		oReport:SetOnPageNumber({ || nPag })
		
		//F026Cabec( oReport, aNum[nX,2] )  
		
		nLinha := oReport:Row()	
		
		If (cAliasQry)->( !EoF() )
		
			While (cAliasQry)->( !EoF() )
			
				If oReport:Row() > 2955 // Limite da pagina
				
					nPag++					
					oReport:SkipLine()
					oReport:PrintText("Continua na próxima página...")
					oReport:EndPage(.T.)
					oReport:SetOnPageNumber({ || nPag })
					
					//F026Cabec( oReport, aNum[nX,2] )
					nLinha := oReport:Row()	
					
				EndIf
				
				cEndereco:=""
				
				If cFilAnt = "0101"
					cEndereco := (cAliasQry)->ENDFIL1 
				ElseIf cFilAnt = "0102"
					cEndereco := (cAliasQry)->ENDFIL2 
				EndIf

				oSection:Cell("L2_LOCALIZ"):SetBlock({ || cEndereco } )
				oSection:Cell("B1_REFEREN"):SetBlock({ || (cAliasQry)->REFERENCIA } )
				oSection:Cell("L2_DESCRI"):SetBlock({ || (cAliasQry)->DESCRI } )
				oSection:Cell("C6_QTDVEN"):SetBlock({ || (cAliasQry)->QUANT } )
		   		
		   		oSection:PrintLine()  

				nTotQtd += (cAliasQry)->QUANT
			   		
				nLinha += 54
				
				(cAliasQry)->( dbSkip() )
				
			EndDo
			
		Else
			
			oReport:SkipLine()
			oReport:Say( oReport:Row(),005,"Não há registros para exibir." )
			oReport:SkipLine(2)
			
		EndIf
		
		F026Total( oReport, nTotQtd )	
			
		oReport:EndPage(.T.)
		
		nTotQtd := 0
		
		(cAliasQry)->( dbCloseArea() )
		
	Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ F026Cabec   ³ Autor ³ Leandro Marquardt     ³ Data ³11/03/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do cabecalho.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F026Cabec( oReport )                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function F026Cabec( oReport ) 
	
	Local oFont14 := TFont():New("Arial",,14,,.F.)	
	
	/*
	oReport:Say( 250,0005,"Item" )
	oReport:Say( 250,0170,"Produto" )
	oReport:Say( 250,0570,"Descrição" )
	oReport:Say( 250,1320,"Quant." )
	oReport:Say( 250,1600,"Localizacao" )
	oReport:Say( 250,1950,"Qtd. Separada." )
	*/
	
	oReport:Say( 250,0005,"Localizacao" )
	oReport:Say( 250,0530,"Produto" )
	oReport:Say( 250,0800,"Descrição" )
	oReport:Say( 250,1790,"Quantidade" )
	
	oReport:SkipLine()
	oReport:ThinLine()
	oReport:SkipLine()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ F026Total   ³ Autor ³ Leandro Marquardt     ³ Data ³12/03/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao da quantidade total de produtos.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F026Total( oReport, nTotQtd )                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function F026Total( oReport, nTotQtd )

	Local oFont14 := TFont():New("Arial",,14,,.T.)
	
	dbSelectArea("SC6")
	
	oReport:ThinLine()
	oReport:SkipLine()
	oReport:Say( oReport:Row(),010,"Total de Produtos: " + Transform( nTotQtd, PesqPict("SC6","C6_QTDVEN") ),oFont14 )
	
Return
                    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CriaSX1     ³ Autor ³ Leandro Marquardt     ³ Data ³12/03/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Criar o grupo de perguntas.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaSX1( cPerg )

	Local cPerg	:= PadR("TRSF026",Len(SX1->X1_GRUPO))
	Local aP		:= {}
	Local nI		:= 0
	Local cSeq	:= ""
	Local cMvCh	:= ""
	Local cMvPar	:= ""
	Local aHelp	:= {}


	//--      Texto Pergunta          , Tipo     , Tam   , Dec     , G=Get/C=Combo, Val,     F3,        Def01,     Def02, Def03, Def04, Def05	
   	aAdd(aP,{"Impressora Fiscal?"    ,  "N"    ,  1    , 0  	  	, "C"         ,  "",    "",        "Sim",     "Nao",    "",    "",    "" })
   	                                                   
	//           123456789123456789012345678901234567890
	//                   1         2         3         4			
	aAdd(aHelp,{"Tipo de impressora."})
	
	For nI := 1 To Len(aP)
	
		cSeq	:= StrZero(nI,2,0)
		cMvPar	:= "mv_par"+cSeq
		cMvCh	:= "mv_ch"+IIF(nI<=9,Chr(nI+48),Chr(nI+87))
		
		PutSx1(	cPerg,;						//-- cGrupo
				cSeq,;								//-- cOrdem
				aP[nI,01],aP[nI,01],aP[nI,01],;	//-- cPergunt,cPerSpa,cPerEng
				cMvCh,;							//-- cVar
				aP[nI,02],;						//-- cTipo
				aP[nI,03],;						//-- nTamanho
				aP[nI,04],;						//-- Decimal
				0,;									//-- nPreSel
				aP[nI,05],;						//-- cGSC
				aP[nI,06],;						//-- cValid
				aP[nI,07],;						//-- cF3
				"",;								//-- cGrpSXG
				"",;								//-- cPyme
				cMvPar,;							//-- cVar01
				aP[nI,08],aP[nI,08],aP[nI,08],;	//-- cDef01,cDefSpa1,cDefEng1
				"",;								//-- cCnt01
				aP[nI,09],aP[nI,09],aP[nI,09],;	//-- cDef02,cDefSpa2,cDefEng2
				aP[nI,10],aP[nI,10],aP[nI,10],;	//-- cDef03,cDefSpa3,cDefEng3
				aP[nI,11],aP[nI,11],aP[nI,11],;	//-- cDef04,cDefSpa4,cDefEng4
				aP[nI,12],aP[nI,12],aP[nI,12],;	//-- cDef05,cDefSpa5,cDefEng5
				aHelp[nI],;						//-- aHelpPor
				{},;								//-- aHelpEng
				{},;								//-- aHelpSpa
				"")									//-- cHelp
		
	Next nI
      
Return( cPerg )