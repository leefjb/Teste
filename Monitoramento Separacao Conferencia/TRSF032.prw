#Include "Protheus.ch"

/* Colunas TWBrowse (NF) */
#Define NPOS_STATUS			01
#Define NPOS_D2_ITEMPV		02
#Define NPOS_B1_CODBAR		03
#Define NPOS_D2_COD			04
#Define NPOS_B1_DESC		05
#Define NPOS_QTDVEND		06
#Define NPOS_QTDCONF		07
#Define NPOS_B1_RASTRO		08
#Define NPOS_LOTE			09
#Define NPOS_D2_PEDIDO		10

/* Qtde de colunas TWBrowse */
#Define NCOL_QUANT			10

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ TRSF032  ³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Conferencia pedido ( Leitura )                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ u_TRSF032                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
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
User Function TRSF032(cNf, cSerie, cCliente, cLoja, cPvVale, nDocDe, nDocAte)

	Local oDlgSep
	Local oBroSep
	Local oPnlCab, oPnlRod
	Local oGrpCab, oGrpRod
	Local oSayLeitura
	Local oGetLeitura
	Local oBtoOrdem, oBtoDetLe, oBtoConf, oBtoCanc, oBtoLegen
	Local oSayNf, oSaySer, oSayCli, oSayLoj, oSayDCl
	Local oFntMsg, oFntPvV
	Local oGetNf, oGetSer, oGetCli, oGetLoj, oGetDCl
	Local oStatus
	Local oSayPvV, oGetPvV, oSayPvA, oSayPvD 	 

	Local aSize		:= {}
	Local aObj		:= {}
	Local aInfo		:= {}
	Local aPObj		:= {}
	Local aBrowse	:= {}
	Local aCabec	:= {}
	Local aLegenda	:= {}
	
	Local lValQtd	:= .F.
	Local lConf		:= .F.
		
	Local nZ		:= 0
	Local nOpc		:= 0
	
	Local cMsg		  := ""
	Local cGetLeitura := ""
	
	Local bBtoOrdem, bWhenBto, bWhenDetL, bBtoDetLe, bBtoLegen, bBtoConf, bBtoCanc
	Local bGetLeitura 
	Local bLinha		:= {||} 
	
	Private cF032Cad	:= "Conferencia pedido (Leitura)"
	Private nF032Ord	:= 1	// Ordem de exibicao do Browse
	
	Private oMsgLin1, oMsgLin2, oMsgLin3, oMsgStat

	// Retorna a area util das janelas
	aSize := MsAdvSize( .F. , , ) 
	 
	// Area da janela 
	aAdd( aObj, { 100, 023, .T., .T. }) // Cabecalho  
	aAdd( aObj, { 100, 057, .T., .T. }) // TWbrowse  
	aAdd( aObj, { 100, 020, .T., .T. }) // Rodape 
	 
	// Calculo automatico das dimensoes dos objetos (altura/largura) em pixel 
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 5, 5 }
	aPObj := MsObjSize( aInfo, aObj, .T. )   

	aAdd( aCabec, "" )
	aAdd( aCabec, "Item" )
	aAdd( aCabec, "Cod. Bar" )
	aAdd( aCabec, "Produto" )
	aAdd( aCabec, "Descrição" )
	aAdd( aCabec, "Qt. Vendida" )
	aAdd( aCabec, "Qt. Conferida" )
	aAdd( aCabec, "Rastro" )
	
	oDlgSep := MSDialog():New( aSize[7], aSize[1], aSize[6], aSize[5], cF032Cad,,,,,,,,,.T.,,, )
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Bloco When dos botoes                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
		bWhenBto := { || !Empty( aBrowse[oBroSep:nAt,NPOS_D2_COD] )  }
	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cabecalho                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		oPnlCab := TPanel():Create( oDlgSep, aPObj[1,1], aPObj[1,2], "",,,,,, aPObj[1,4], aPObj[1,3] )
		oGrpCab := TGroup():New( 0, 0, (aPObj[1,3]-aPObj[1,1]), aPObj[1,4], "", oPnlCab,,,.T.)
		
		//Get Leitura
		cGetLeitura := Space(55)
		
		oSayLeitura := TSay():New(	005,;
										010,;
										{||"Leitura"},;
										oGrpCab,,,,;
										,,.T.,,,;
										40,;
										10)
		
		bGetLeitura := {|| IIf(	Empty(cGetLeitura), .T.,;
									(	F032Leitur(cGetLeitura, @aBrowse),;
										oDlgSep:Refresh(),;
										oBroSep:Refresh(),;
										cGetLeitura := Space(55),;
										oGetLeitura:CtrlRefresh(),;
										oGetLeitura:SetFocus() ); 
									)}

		oGetLeitura := TGet():New( 	015,;
										010,;
										{|u| IIf(PCount()>0, cGetLeitura := u, cGetLeitura) },;//bSetGet
										oGrpCab,;
										120,;
										010,;
										"@!",;
										bGetLeitura,;//bValid
										,,,,,;
										.T.,;//lPixel
										,,;
										{||.T.},;//bWhen
										,,,,.F.,"",cGetLeitura)

		bBtoOrdem := { || IIf( !Empty( aBrowse[oBroSep:nAt,NPOS_D2_COD] ),;
										(	aBrowse := F032OrdBro(aBrowse, .F.),;
											oBroSep:SetArray( aBrowse ),; 
											oBroSep:bLine := @bLinha,;
											oBroSep:GoTop(),;
											oBroSep:nAt := 1,;
											oBroSep:Refresh()),; // .T.
										Nil);						// .F.
							}
			
		cMsg := "Ordem de exibição"
							
		oBtoOrdem := TButton():New(	010,;
		 								150,;
		 								"Ordem exibição",;
		 								oGrpCab,;
		 								bBtoOrdem,; 
		 								070,; 
		 								010,,,.F.,.T.,.F.,cMsg,.F.,{||},,.F. )
		
		bWhenDetL := {|| ( aBrowse[oBroSep:nAt,NPOS_QTDCONF] < aBrowse[oBroSep:nAt,NPOS_QTDVEND] ) .And. aBrowse[oBroSep:nAt,NPOS_B1_RASTRO] }
		
		bBtoDetLe := {|| F032DetaIt( aBrowse[oBroSep:nAt] ) }
			
		cMsg := "Verificar pendência do item posicionado"
							
		oBtoDetLe := TButton():New(	025,;
		 								150,;
		 								"Ver pendencia Item",;
		 								oGrpCab,;
		 								bBtoDetLe,; 
		 								070,; 
		 								010,,,.F.,.T.,.F.,cMsg,.F.,bWhenDetL,,.F. )
		 								
		bBtoLegen := {|| F032Legend(.F.) }
			
		cMsg := "Legenda"
							
		oBtoLegen := TButton():New(	010,;
		 								230,;
		 								"Legenda",;
		 								oGrpCab,;
		 								bBtoLegen,; 
		 								070,; 
		 								010,,,.F.,.T.,.F.,cMsg,.F.,{||},,.F. )
		 								
		oSayNf := TSay():New(	005,;
									320,;
									{||"Nf"},;
									oGrpCab,,,,;
									,,.T.,,,;
									40,;
									10)
		 								
		oGetNf := TGet():New( 	015,;
									320,;
									{|| cNf},;//bSetGet
									oGrpCab,;
									040,;
									010,;
									"@!",;
									{||.T.},;//bValid
									,,,,,;
									.T.,;//lPixel
									,,;
									{||.F.},;//bWhen
									,,,,.F.,"",cNf)
		
		oSaySer := TSay():New(	005,;
									370,;
									{||"Serie"},;
									oGrpCab,,,,;
									,,.T.,,,;
									40,;
									10)
		 								
		oGetSer := TGet():New( 	015,;
									370,;
									{|| cSerie},;//bSetGet
									oGrpCab,;
									020,;
									010,;
									"@!",;
									{||.T.},;//bValid
									,,,,,;
									.T.,;//lPixel
									,,;
									{||.F.},;//bWhen
									,,,,.F.,"",cSerie)
									
		oSayPvV := TSay():New(	005,;
									510,;
									{||"Pv Vale"},;
									oGrpCab,,,,;
									,,.T.,,,;
									30,;
									10)
		 								
		oGetPvV := TGet():New( 	015,;
									510,;
									{|| cPvVale },;//bSetGet
									oGrpCab,;
									010,;
									010,;
									"@!",;
									{||.T.},;//bValid
									,,,,,;
									.T.,;//lPixel
									,,;
									{||.F.},;//bWhen
									,,,,.F.,"",)
		
		oFntPvV := TFont():New("Arial",,-16,.T.)
		
		oSayPvA := TSay():New(	030,;
									510,;
									{|| "De / Ate" },;
									oGrpCab,,,,;
									,,.T.,,,;
									80,;
									10)

		oSayPvD := TSay():New(	040,;
									510,;
									{|| StrZero(nDocDe,3) +" / "+ StrZero(nDocAte,3) },;
									oGrpCab,,oFntPvV,,;
									,,.T.,CLR_BLUE,CLR_WHITE,;
									80,;
									10)
		
		oSayCli := TSay():New(	030,;
									320,;
									{||"Cliente"},;
									oGrpCab,,,,;
									,,.T.,,,;
									40,;
									10)
		 								
		oGetCli := TGet():New( 	040,;
									320,;
									{|| cCliente},;//bSetGet
									oGrpCab,;
									040,;
									010,;
									"@!",;
									{||.T.},;//bValid
									,,,,,;
									.T.,;//lPixel
									,,;
									{||.F.},;//bWhen
									,,,,.F.,"",cCliente)

		oSayLoj := TSay():New(	030,;
									370,;
									{||"Loja"},;
									oGrpCab,,,,;
									,,.T.,,,;
									40,;
									10)
		 								
		oGetLoj := TGet():New( 	040,;
									370,;
									{|| cLoja},;//bSetGet
									oGrpCab,;
									020,;
									010,;
									"@!",;
									{||.T.},;//bValid
									,,,,,;
									.T.,;//lPixel
									,,;
									{||.F.},;//bWhen
									,,,,.F.,"",cLoja)

		oSayDCl := TSay():New(	030,;
									400,;
									{||"Descrição"},;
									oGrpCab,,,,;
									,,.T.,,,;
									40,;
									10)
		 								
		oGetDCl := TGet():New( 	040,;
									400,;
									{|| Posicione( "SA1", 1, xFilial("SA1") + cCliente + cLoja, "A1_NOME" ) },;//bSetGet
									oGrpCab,;
									100,;
									010,;
									"@!",;
									{||.T.},;//bValid
									,,,,,;
									.T.,;//lPixel
									,,;
									{||.F.},;//bWhen
									,,,,.F.,"",;
									"")//cVar
		
		bBtoConf := {||	aEval( aBrowse, {|x| IIf( x[NPOS_QTDVEND] != x[NPOS_QTDCONF], lValQtd := .F., lValQtd := .T.) } ),;
							IIf( !lValQtd,; 
									lConf := MsgYesNo("Existe(m) item(ns) não conferido(s)!"+CRLF+"Confirma?", cF032Cad),;
									lConf := .T. ),;	
							IIf( lConf,;
								 	MsAguarde( {|| 	F032Confirm(aBrowse),;
														nOpc := 1,;
														oDlgSep:End()}, "Aguarde!", "Confirmando...", .F. ),;
								 Nil) }
		
		oBtoConf := TButton():New(	005,;
		 								560,;
		 								"Confirmar",;
		 								oGrpCab,;
		 								bBtoConf,; 
		 								040,; 
		 								020,,,.F.,.T.,.F.,"Confirmar confêrencia",.F.,{||},,.F. )
										
		cMsg := "Conferencia de múltiplos documentos!"
		cMsg += CRLF
		cMsg += StrZero(nDocDe,3) +" / "+ StrZero(nDocAte,3) + "."
		cMsg += CRLF
		cMsg += "O cancelamento, desfaz as demais conferencias." 
		cMsg += CRLF 
		cMsg += CRLF 
		cMsg += "Confirma?"
		
		bBtoCanc := {|| 	IIf(cPvVale = "S",;
									lConf := MsgYesNo(cMsg, cF032Cad),;
								 	lConf := .T.),; 
							IIf(lConf, (nOpc := 0, oDlgSep:End()), Nil)}
		
		oBtoCanc := TButton():New(	030,;
		 								560,;
		 								"Cancelar",;
		 								oGrpCab,;
		 								bBtoCanc,; 
		 								040,; 
		 								020,,,.F.,.T.,.F.,"Cancelar confêrencia",.F.,{||},,.F. )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TWBrowse                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		oBroSep := TWBrowse():New( 	aPObj[2,1],; 
										aPObj[2,2],;
										aPObj[2,4],;
										(aPObj[2,3]-aPObj[2,1]),;
										,;
										aCabec,;
										,;
										oDlgSep,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		MsAguarde( {|| oBroSep:SetArray( aBrowse := F032OrdBro( F032Produt(cNf, cSerie, cCliente, cLoja), .T. ) ) }, "Aguarde!", "Listando...", .F. )
		
		bLinha := {|| {	oStatus := LoadBitmap( Nil, aLegenda[ aScan( aLegenda := F032Legend(.T.), {|x| x[1] = aBrowse[oBroSep:nAt,NPOS_STATUS]} ) ][3] ),;
							aBrowse[oBroSep:nAt,NPOS_D2_ITEMPV],;                      
							aBrowse[oBroSep:nAt,NPOS_B1_CODBAR],;
							aBrowse[oBroSep:nAt,NPOS_D2_COD],;
							aBrowse[oBroSep:nAt,NPOS_B1_DESC],;
							aBrowse[oBroSep:nAt,NPOS_QTDVEND],;
							aBrowse[oBroSep:nAt,NPOS_QTDCONF],;
							IIf(aBrowse[oBroSep:nAt,NPOS_B1_RASTRO], "Sim", "Nao");
							}}
		
		oBroSep:bLine := @bLinha 
		
		oBroSep:aColSizes := {15, 25, 60, 60, 120, 40, 40, 25}
		
		oBroSep:bLDblClick := {|| IIf( aBrowse[oBroSep:nAt,NPOS_QTDCONF] < aBrowse[oBroSep:nAt,NPOS_QTDVEND] .And. aBrowse[oBroSep:nAt,NPOS_B1_RASTRO],;
			 								F032DetaIt( aBrowse[oBroSep:nAt] ),;
			 								Nil);
			 						}
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Rodape                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		oPnlRod := TPanel():Create( oDlgSep, aPObj[3,1], aPObj[3,2], "",,,,,, aPObj[3,4], aPObj[3,3] )
		oGrpRod := TGroup():New( 0, 0, (aPObj[3,3]-aPObj[3,1]), aPObj[3,4], "Última Leitura / Mensagens", oPnlRod,,,.T.)
		
		oFntMsg := TFont():New("Arial",,-18,.T.)
					
		oMsgLin1:= TSay():New(	010,;
									010,;
									{||""},;
									oGrpRod,;
									,;
									oFntMsg,;
									,,,;
									.T.,,,;
									400,;
									(aPObj[3,3]-aPObj[3,1]) )
									
		oMsgLin2:= TSay():New(	025,;
									010,;
									{||""},;
									oGrpRod,;
									,;
									ofntMsg,;
									,,,;
									.T.,,,;
									400,;
									(aPObj[3,3]-aPObj[3,1]) )
									
		oMsgLin3:= TSay():New(	040,;
									010,;
									{||""},;
									oGrpRod,;
									,;
									ofntMsg,;
									,,,;
									.T.,,,;
									400,;
									(aPObj[3,3]-aPObj[3,1]) )
									
		oMsgStat:= TSay():New(	010,;
									500,;
									{||""},;
									oGrpRod,;
									,;
									ofntMsg,;
									,,,;
									.T.,,,;
									200,;
									(aPObj[3,3]-aPObj[3,1]) )
		
		oDlgSep:Refresh()

	oDlgSep:Activate( {||.T.},,,.T.,,,)

Return( (nOpc = 1) )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F032Confir³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Botao confirmar.                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F032Confir(aBrowse)

	Local nItem := 0

	
	For nItem := 1 To Len(aBrowse)
	
		dbSelectArea("SC5")
		dbSetOrder(1)//C5_FILIAL + C5_NUM
	
		If dbSeek( xFilial("SC5") + aBrowse[nItem][NPOS_D2_PEDIDO] )
		
			RecLock("SC5", .F.)
				SC5->C5_USRCON := CUSERNAME 	
			MsUnLock()
			
			dbSelectArea("SC6")
			dbSetOrder(1)//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			
			If dbSeek( xFilial("SC6") + aBrowse[nItem][NPOS_D2_PEDIDO] + aBrowse[nItem][NPOS_D2_ITEMPV] )

				RecLock("SC6", .F.)
					SC6->C6_QTDCONF := aBrowse[nItem][NPOS_QTDCONF] 	
				MsUnLock()
			
			EndIf
		
		EndIf
	
	Next nItem	

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F032Leitur³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Leitura do Get.                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F032Leitur(cGetLeitura, aBrowse)

	Local nPosItem	:= 0
	Local nPosLote	:= 0
	Local nTamProd	:= TamSx3("B1_COD")[1]
	Local nTamLote	:= TamSx3("C6_LOTECTL")[1]
 
	Local cProduto	:= SubStr( cGetLeitura, 1 ,nTamProd )
	Local cLoteCtl	:= SubStr( cGetLeitura, (nTamProd+1), nTamLote )
	
	Local lOk     	:= .T. 
	
	
	//Validade Produto
	If ( nPosItem := aScan( aBrowse, {|x| x[NPOS_D2_COD] = cProduto} ) ) = 0
	
		nTamProd := TamSx3("B1_CODBAR")[1]
		cProduto := SubStr( cGetLeitura, 1 , nTamProd )
	
		If ( nPosItem := aScan( aBrowse, {|x| x[NPOS_B1_CODBAR] = cProduto} ) ) = 0
		
			lOk := .F.
			
			oMsgLin1:SetText(cProduto)// Produto + Lote
 			oMsgLin2:SetText("")// Descricao Produto
 			oMsgLin3:SetText("Produto não faz parte deste documento")// Mensagem
 			oMsgStat:SetText("")// Status quantidades Vendida X Conferida
		
		EndIf
	
	EndIf 
  	
 	//Validar Lote
 	If lOk
		
		If ( nPosLote := aScan( aBrowse[nPosItem, NPOS_LOTE], {|x| x[1] = cLoteCtl} ) ) = 0
		
			lOk := .F.
			
			oMsgLin1:SetText(cProduto +" Lote: "+ cLoteCtl)// Produto + Lote
 			oMsgLin2:SetText(aBrowse[nPosItem,NPOS_B1_DESC])// Descricao Produto
 			oMsgLin3:SetText("Lote não faz parte deste documento")// Mensagem
 			oMsgStat:SetText(StrZero(aBrowse[nPosItem,NPOS_QTDCONF],3)+" / "+StrZero(aBrowse[nPosItem,NPOS_QTDVEND],3))// Status quantidades Vendida X Conferida
		
		EndIf

 	EndIf
 	
 	//Validar Quantidades
 	If lOk
 	
		If aBrowse[nPosItem,NPOS_QTDCONF] = aBrowse[nPosItem,NPOS_QTDVEND]
		
			lOk := .F.
 				
			oMsgLin1:SetText(cProduto + " Lote: " + cLoteCtl)// Produto + Lote
 			oMsgLin2:SetText(aBrowse[nPosItem,NPOS_B1_DESC])// Descricao Produto
 			oMsgLin3:SetText("Produto já conferido")// Mensagem
 			oMsgStat:SetText(StrZero(aBrowse[nPosItem,NPOS_QTDCONF],3)+" / "+StrZero(aBrowse[nPosItem,NPOS_QTDVEND],3))// Status quantidades Vendida X Conferida

		Else
		
			If aBrowse[nPosItem,NPOS_QTDCONF] < aBrowse[nPosItem,NPOS_QTDVEND]
			
				If aBrowse[nPosItem,NPOS_LOTE][nPosLote][2] = aBrowse[nPosItem,NPOS_LOTE][nPosLote][4]
			
					lOk := .F.
			
					oMsgLin1:SetText(cProduto +" Lote: "+ cLoteCtl)// Produto + Lote
	 				oMsgLin2:SetText(aBrowse[nPosItem,NPOS_B1_DESC])// Descricao Produto
	 				oMsgLin3:SetText("Produto + Lote já conferido")// Mensagem
	 				oMsgStat:SetText(StrZero(aBrowse[nPosItem,NPOS_QTDCONF],3)+" / "+StrZero(aBrowse[nPosItem,NPOS_QTDVEND],3))// Status quantidades Vendida X Conferida
		
				EndIf
			EndIf
		EndIf
		
 	EndIf

	//Conferencia Ok  
	If lOk
	
		//Soma quantidade conferida
		aBrowse[nPosItem,NPOS_QTDCONF] += 1
		
		//Soma quantidade do lote
		aBrowse[nPosItem,NPOS_LOTE][nPosLote][2] += 1
		
		//Status
		If aBrowse[nPosItem,NPOS_QTDCONF] = aBrowse[nPosItem,NPOS_QTDVEND] 
			aBrowse[nPosItem,NPOS_STATUS] := "C"// C = Conferido
		ElseIf aBrowse[nPosItem,NPOS_QTDCONF] < aBrowse[nPosItem,NPOS_QTDVEND]
			aBrowse[nPosItem,NPOS_STATUS] := "E"// E = Em conferencia
		EndIf
		
		oMsgLin1:SetText(cProduto + " Lote: "+ cLoteCtl)// Produto + Lote
		oMsgLin2:SetText(aBrowse[nPosItem,NPOS_B1_DESC])// Descricao Produto
		oMsgLin3:SetText("Leitura Ok")// Mensagem
		oMsgStat:SetText(StrZero(aBrowse[nPosItem,NPOS_QTDCONF],3)+" / "+StrZero(aBrowse[nPosItem,NPOS_QTDVEND],3))// Status quantidades Vendida X Conferida
			
	EndIf
	
Return(.F.)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F032Produt³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna todos os produtos da NF ainda nao conferida.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F032Produt(cNf, cSerie, cCliente, cLoja)  

	Local cQuery	:= ""
	Local cArea	:= GetNextAlias()
	Local cPedido	:= ""
	Local cItemPv	:= ""	
	Local aBrowse	:= {}
	Local aLotPed	:= {}
	Local nQtdPed	:= 0
	Local nScan	:= 0

	cQuery := " SELECT 	D2_DOC,"		
	cQuery += "			D2_SERIE,"	
	cQuery += "			D2_CLIENTE," 		
	cQuery += "			D2_LOJA," 		
	cQuery += "			D2_PEDIDO," 	
	cQuery += "			D2_ITEMPV," 		
	cQuery += "			D2_QUANT," 		
	cQuery += "			D2_COD," 		
	cQuery += "			D2_LOTECTL," 		
	cQuery += "			D2_EMISSAO," 		
	cQuery += "			D2_DTVALID," 		
	cQuery += "			B1_RASTRO," 		
	cQuery += "			B1_DESC," 		
	cQuery += "			B1_CODBAR"	
			
	cQuery += " FROM		" + RetSQLName("SD2") +" SD2"	

	cQuery += " INNER JOIN	" + RetSQLName("SB1") +" SB1"  
	cQuery += " 		ON	B1_FILIAL	= '" + xFilial("SB1") +"'"
	cQuery += " 		AND	B1_COD 	= D2_COD"

	cQuery += " WHERE		SD2.D2_FILIAL		= '" + xFilial("SD2") +"'"		 
	cQuery += "   	AND	SD2.D2_DOC 		= '" + cNf +"'" 		
	cQuery += "   	AND	SD2.D2_SERIE 		= '" + cSerie +"'" 		
	cQuery += "   	AND	SD2.D2_CLIENTE 	= '" + cCliente +"'" 		
	cQuery += "   	AND	SD2.D2_LOJA 		= '" + cLoja +"'" 		
	
	cQuery += "		AND	SD2.D_E_L_E_T_ <> '*'" 	  
	cQuery += "		AND	SB1.D_E_L_E_T_ <> '*'" 	  
	
	cQuery += " ORDER BY	D2_DOC," 
	cQuery += " 			D2_SERIE," 	  
	cQuery += " 			D2_CLIENTE," 	  
	cQuery += " 			D2_LOJA," 	  	
	cQuery += " 			D2_PEDIDO," 	  
	cQuery += " 			D2_ITEMPV," 	  
	cQuery += " 			D2_LOTECTL" 	  


      
    /*********************************************************************************************                       
	*	CRISTIANO OLIVEIRA - VERIFICAO DE CONSULTA PARA AJUSTES DO NAO SEPARAVEIS - 08/08/2016   *
	*********************************************************************************************/                        
	MemoWrite("cprova\TRSF032-TESTE.SQL", cQuery)



	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArea,.F.,.T.)
	
	TcSetField( cArea, "D2_EMISSAO", "D", 08, 00 )
	TcSetField( cArea, "D2_DTVALID", "D", 08, 00 )

	(cArea)->( dbGoTop() )
	
	While (cArea)->( !Eof() )
	
		aAdd( aBrowse, Array(NCOL_QUANT) )
		
		aBrowse[Len(aBrowse)][NPOS_STATUS]			:= "N" // N = Nao conferido ou E = Em conferencia ou C = Conferido
		aBrowse[Len(aBrowse)][NPOS_D2_ITEMPV]		:= (cArea)->D2_ITEMPV
		aBrowse[Len(aBrowse)][NPOS_B1_CODBAR]		:= (cArea)->B1_CODBAR
		aBrowse[Len(aBrowse)][NPOS_D2_COD]			:= (cArea)->D2_COD
		aBrowse[Len(aBrowse)][NPOS_B1_DESC]		:= (cArea)->B1_DESC
		aBrowse[Len(aBrowse)][NPOS_B1_RASTRO]		:= ( (cArea)->B1_RASTRO = "L" )// L = Lote
		aBrowse[Len(aBrowse)][NPOS_QTDCONF]		:= 0
		aBrowse[Len(aBrowse)][NPOS_D2_PEDIDO]		:= (cArea)->D2_PEDIDO
				
		nQtdPed := 0
		aLotPed := {}
		cPedido := (cArea)->D2_PEDIDO
		cItemPv := (cArea)->D2_ITEMPV
		
		While (cArea)->( !Eof() )	.And. cPedido = (cArea)->D2_PEDIDO;
										.And. cItemPv = (cArea)->D2_ITEMPV

			If ( nScan := aScan(aLotPed, {|x| x[1] = (cArea)->D2_LOTECTL} ) ) = 0
		
				aAdd( aLotPed, {	(cArea)->D2_LOTECTL,;//1 Num Lote
								 	0,;						//2 Quantidade conferida
								 	(cArea)->D2_DTVALID,;//3 Data validade lote
								 	(cArea)->D2_QUANT;	//4 Quantidade lote
								 })
			Else
				
				aLotPed[nScan,4] += (cArea)->D2_QUANT
			
			EndIf
			
			nQtdPed += (cArea)->D2_QUANT

			dbSelectArea(cArea)
			dbSkip()

		EndDo	
		
		aBrowse[Len(aBrowse)][NPOS_QTDVEND]:= nQtdPed
		aBrowse[Len(aBrowse)][NPOS_LOTE]	:= aLotPed
			
	EndDo
	
	(cArea)->( dbCloseArea() )
	
	If Len(aBrowse) = 0

		aAdd( aBrowse, Array(NCOL_QUANT) )
		
		aBrowse[Len(aBrowse)][NPOS_STATUS]		:= "N" // N = Nao conferido ou E = Em conferencia ou C = Conferido
		aBrowse[Len(aBrowse)][NPOS_D2_ITEMPV]	:= ""
		aBrowse[Len(aBrowse)][NPOS_B1_CODBAR]	:= ""
		aBrowse[Len(aBrowse)][NPOS_D2_COD]		:= ""
		aBrowse[Len(aBrowse)][NPOS_B1_DESC]	:= ""
		aBrowse[Len(aBrowse)][NPOS_B1_RASTRO]	:= .F.
		aBrowse[Len(aBrowse)][NPOS_QTDCONF]	:= 0
		aBrowse[Len(aBrowse)][NPOS_QTDVEND]	:= 0
		aBrowse[Len(aBrowse)][NPOS_LOTE]		:= {}
		aBrowse[Len(aBrowse)][NPOS_D2_PEDIDO]	:= ""
		
	EndIf

Return(aBrowse)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F032OrdBro³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alterar ordem de exibicao TWBrowse.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F032OrdBro(aBrowse, lAuto)

	Local aRet		:= {}
	Local aPergs		:= {}
	Local aOpcoes		:= {}
	Local lConfirm	:= .T.
	

	aAdd( aOpcoes, "1 - Item + Produto" )
	aAdd( aOpcoes, "2 - Item + Cod. Bar" )
	aAdd( aOpcoes, "3 - Status + Produto" )
	aAdd( aOpcoes, "4 - Qtd. Conferida + Produto" )
	aAdd( aOpcoes, "5 - Qtd. Vendida + Produto" )

	aAdd( aPergs,{3, "Ordem Apresentação", nF032Ord, aOpcoes, 150, "", .F.} )
	
	If !lAuto
	
		If ParamBox(aPergs, cF032Cad +" - Ordem", @aRet,,,.T.,,,,,.F.)
			nF032Ord	:= aRet[1]
		Else
			lConfirm := .F.
		EndIf
		
	EndIf
	
	If lConfirm
	
		If nF032Ord = 1
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPOS_D2_ITEMPV]+x[NPOS_D2_COD] < y[NPOS_D2_ITEMPV]+y[NPOS_D2_COD] })
		ElseIf nF032Ord = 2  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPOS_D2_ITEMPV]+x[NPOS_B1_CODBAR] < y[NPOS_D2_ITEMPV]+y[NPOS_B1_CODBAR] })
		ElseIf nF032Ord = 3  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPOS_STATUS]+x[NPOS_D2_COD] < y[NPOS_STATUS]+y[NPOS_D2_COD] })
		ElseIf nF032Ord = 4  	
			aBrowse := ASort(aBrowse,,,{|x, y| cValToChar(x[NPOS_QTDCONF])+x[NPOS_D2_COD] < cValToChar(y[NPOS_QTDCONF])+y[NPOS_D2_COD] })
		ElseIf nF032Ord = 5  	
			aBrowse := ASort(aBrowse,,,{|x, y| cValToChar(x[NPOS_QTDVEND])+x[NPOS_D2_COD] < cValToChar(y[NPOS_QTDVEND])+y[NPOS_D2_COD] })
		EndIf
		
	EndIf
		
Return(aBrowse)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F032DetaIt³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Detalhes do item selecionado.                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F032DetaIt(aItem)

	Local oDlgLot
	Local oBroLot
	Local oSayIte, oSayPro
	Local oGetIte, oGetPro
	Local aCabec		:= {}
	Local aBrowse		:= {}
	Local nX			:= 0

	
	//Somente Lote nao lido
	For nX := 1 To Len( aItem[NPOS_LOTE] )
	
		If aItem[NPOS_LOTE][nX][2] = 0
		
			aAdd(aBrowse, { aItem[NPOS_LOTE][nX,1], aItem[NPOS_LOTE][nX,3], "" } )
		
		Endif
	
	Next nX
	
	If Len(aBrowse) = 0
	
		aBrowse := { { "", CToD("//"), "" } }
		
	EndIf

	aAdd( aCabec, "Lote" )
	aAdd( aCabec, "Dt Validade" )
	aAdd( aCabec, "" )

	oDlgLot := MSDialog():New( 000, 000, 500, 800, cF032Cad +" - Detalhes" ,,,,,,,,,.T.,,, )
	
		oSayIte := TSay():New(	005,;
									010,;
									{||"Item"},;
									oDlgLot,,,,;
									,,.T.,,,;
									20,;
									10)
		 								
		oGetIte := TGet():New( 	015,;
									010,;
									{|| aItem[NPOS_D2_ITEMPV]},;//bSetGet
									oDlgLot,;
									020,;
									010,;
									"@!",;
									{||.T.},;//bValid
									,,,,,;
									.T.,;//lPixel
									,,;
									{||.F.},;//bWhen
									,,,,.F.,"",aItem[NPOS_D2_ITEMPV])
									
		oSayPro := TSay():New(	005,;
									050,;
									{||"Produto"},;
									oDlgLot,,,,;
									,,.T.,,,;
									20,;
									10)
		 								
		oGetPro := TGet():New( 	015,;
									050,;
									{|| aItem[NPOS_B1_DESC]},;//bSetGet
									oDlgLot,;
									120,;
									010,;
									"@!",;
									{||.T.},;//bValid
									,,,,,;
									.T.,;//lPixel
									,,;
									{||.F.},;//bWhen
									,,,,.F.,"",aItem[NPOS_B1_DESC])
		

		oBroLot := TWBrowse():New( 030, 005, 395, 220,,,, oDlgLot,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		oBroLot:aHeaders := aCabec

		oBroLot:SetArray( aBrowse )

		oBroLot:bLine := { || {	aBrowse[oBroLot:nAt][01],;
									aBrowse[oBroLot:nAt][02],;
									aBrowse[oBroLot:nAt][03];
								}}

		oDlgLot:Refresh()

	oDlgLot:Activate( {||.T.} , , ,.T., , , )

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F032Legend³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Legenda de Status.                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F032Legend(lAuto)

	Local aLegenda	:= {}
	Local cDescric	:= "Status"
	Local aOpcao		:= {}
	
	Default lAuto	:= .F.
	

	aAdd( aOpcao, {"N","Não Conferido","BR_VERMELHO"} )
	aAdd( aOpcao, {"E","Em Conferencia","BR_AMARELO"} )
	aAdd( aOpcao, {"C","Conferido","BR_VERDE"} )
	
	If !lAuto
		
		aAdd( aLegenda, {aOpcao[1,3], aOpcao[1,1] + " - " + aOpcao[1,2]} )
		aAdd( aLegenda, {aOpcao[2,3], aOpcao[2,1] + " - " + aOpcao[2,2]} )
		aAdd( aLegenda, {aOpcao[3,3], aOpcao[3,1] + " - " + aOpcao[3,2]} )
		
		BrwLegenda(cF032Cad + " - Legenda", cDescric, aLegenda)
		
	EndIf
		
Return(aOpcao)