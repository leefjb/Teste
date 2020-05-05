#Include "Protheus.ch"
#Include "Trsf010.ch"

/* Colunas TWBrowse */
#Define NPOS_STATUS		01
#Define NPOS_ITEM		02
#Define NPOS_CODBAR		03
#Define NPOS_PRODUTO	04
#Define NPOS_DESC		05
#Define NPOS_QTDVEN		06
#Define NPOS_QTDSEP		07
#Define NPOS_RASTRO		08
#Define NPOS_LOCAL		09
#Define NPOS_LOCALIZ	10
#Define NPOS_SALDO		11
#Define NPOS_LPARCIAL	12

/* Qtde de colunas TWBrowse */
#Define NCOL_QUANT		12

/* Colunas aConferir */
#Define NCOL_PEDIDO		01
#Define NCOL_ORIGEM		02
#Define NCOL_CLIENT		03
#Define NCOL_LOJA		04
#Define NCOL_CAIXA		05
#Define NCOL_LOCAL		06
#Define NCOL_FLUXO		07
#Define NCOL_DIGQTD		08

/* Colunas aSeparar*/
#Define NSEP_PRODUTO	01	
#Define NSEP_LOTE		02
#Define NSEP_QTD			03
#Define NSEP_DTVALID	04


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ TRSF025  ³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Separacao ( Leitura )                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ u_TRSF025                                                  ³±±
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
User Function TRSF025(aConferir)

	Local oDlgSep
	Local oBroSep
	Local oPnlCab, oPnlRod
	Local oGrpCab, oGrpRod
	Local oSayLeitura
	Local oGetLeitura
	Local oBtoOrdem, oBtoConf, oBtoCanc, oBtoLegen
	Local oSayPv, oSayCli, oSayLoj, oSayDCl, oSayCx
	Local oSayLoc, oSayEnd, oSayPro, oSayDes1, oSayDes2, oSaySal, oSayQtd, oSayApo
	Local oFntMsg, oFntPvV, oFont, oFont7
	Local oGetPv, oGetCli, oGetLoj, oGetDCl, oGetCx
	Local oStatus 

	Local aSize		:= {}
	Local aObj		:= {}
	Local aInfo		:= {}
	Local aPObj		:= {}
	Local aBrowse		:= {}
	Local aCabec		:= {}
	Local aLegenda	:= {}
	
	Local cMsg		:= ""
	Local cTipoEtiq	:= SuperGetMV( "TRS_MON011", .F., "1" ) //Modelo de etiqueta 1 ou 2
	Local cGetLeitura:= ""
	
	Local lValQtd		:= .F.
	Local lConf		:= .F.
	Local lQtdEmb		:= SuperGetMV( "TRS_MON005", .F., .F. ) // Considerar (somar) na leitura a quantidade por embalagem (B1_QE)
	Local lUsaLote	:= ( cTipoEtiq = "2" )
	Local lDigQtd		:= ( aConferir[Len(aConferir),NCOL_DIGQTD] = "Sim" )
	
	Local nZ			:= 0
	Local nOpc		:= 0
	Local nTamGetLei	:= 0
	Local nPosItem	:= 0
	
	Local bBtoOrdem, bWhenBto, bBtoLegen, bBtoConf, bBtoCanc
	Local bGetLeitura, bProxItem, bRefresh, bRefLeit, bLeitPar
	Local bF2, bF5
	Local bLinha		:= {||} 
	
	Private cF025Cad	:= "Separação (Leitura)"
	Private nF025Ord	:= 1	// Ordem de exibicao do Browse
	
	Private oMsgLin1, oMsgLin2, oMsgLin3, oMsgStat
	Private cMsgLin1, cMsgLin2, cMsgLin3, cMsgStat
	
	Private aSeparar := {}
	
	Private lSepLibEst := SuperGetMV( "TRS_MON007", .F., .F. ) //Rotina de separação: .T. = Separar com liberação de estoque. .F. = Separa sem liberação de estoque.
	

	bF2 := SetKey( VK_F2,  )
	bF5 := SetKey( VK_F5,  )
	
	SetKey( VK_F2, {||} )
	SetKey( VK_F5, {||} )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Modelo de Etiqueta                             ³
	//³ 1 = B1_COD                                     ³
	//³ 2 = B1_COD|B8_LOTECTL|B8_DTVALID|B8_LOTEFOR    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If cTipoEtiq = "1"
	
		nTamGetLei := TamSX3("B1_COD")[1]
		cGetLeitura:= Space( nTamGetLei )
	
	Else
	
		nTamGetLei := TamSX3("B1_COD")[1]
		nTamGetLei += TamSX3("B8_LOTECTL")[1]
		nTamGetLei += TamSX3("B8_DTVALID")[1]
		nTamGetLei += TamSX3("B8_LOTEFOR")[1]
		
		cGetLeitura:= Space( nTamGetLei + 1 )
		
	EndIf
	
	If l020Coletor
	
		DEFINE FONT oFont NAME "Arial" SIZE 9,15
		DEFINE FONT oFont7 NAME "Arial" SIZE 7,13

		aBrowse	:= F025Produt(@aConferir)
		nPosItem	:= 1
		
		oDlgSep := MSDialog():New( 000, 000, 260, 230, cF025Cad,,,,,,,,,.T.,,, )
		
			bRefLeit := {||;
								cGetLeitura := Space( nTamGetLei + IIf( cTipoEtiq = "2", 1 , 0 ) ),;
								oGetLeitura:CtrlRefresh(),;
								oGetLeitura:SetFocus();
				 		 }
		
			bRefresh := {||;	
								oSayPv:CtrlRefresh(),;
								oSayEnd:CtrlRefresh(),;
								oSayPro:CtrlRefresh(),;	
								oSayDes2:CtrlRefresh(),;
								oSayQtd:CtrlRefresh(),;
								oSaySal:CtrlRefresh(),;
								oSayApo:CtrlRefresh(),;
								oDlgSep:Refresh();
							}
							
			bProxItem := {||;
								IIf( Len(aBrowse) > nPosItem,;
									  nPosItem++,;
									  (; 
									  	 Iw_Msgbox( "Leitura finalizada!", cF025Cad, "ALERT" ),;
									  	 Eval(bBtoConf);
									  	);
									  );	
								}
		
			oDlgSep:lEscClose := .F.
		
			oSayPv		:= TSay():Create(oDlgSep,{||"Pedido: " + IIf(Len(aConferir)>1,"...", AllTrim(aConferir[Len(aConferir),NCOL_PEDIDO])) },005,002,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,070,008)		
			
			oSayCx		:= TSay():Create(oDlgSep,{||"Cx: " + AllTrim( aConferir[Len(aConferir),NCOL_CAIXA] ) },005,065,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,050,008)		
					
			oSayLoc 	:= TSay():Create(oDlgSep,{||"Local: " + AllTrim( aBrowse[nPosItem,NPOS_LOCAL] )	}, 015, 002,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,060,008)
			
			oSayEnd 	:= TSay():Create(oDlgSep,{||"End.: " + AllTrim( aBrowse[nPosItem,NPOS_LOCALIZ] ) }, 015, 065,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,060,008)
					
			oSayPro 	:= TSay():Create(oDlgSep,{||"Prod: " + AllTrim( aBrowse[nPosItem,NPOS_PRODUTO] ) },035,002,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,120,008)	
				
			oSayDes1 	:= TSay():Create(oDlgSep,{||"Desc: " },045,002,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,035,008)
			
			oSayDes2 	:= TSay():Create(oDlgSep,{|| Left( aBrowse[nPosItem,NPOS_DESC], 40 ) },045,025,,oFont7,,,,.T.,CLR_BLUE,CLR_WHITE,080,020)
					    
			oSayQtd 	:= TSay():Create(oDlgSep,{||"Qtd Vend: " + cValToChar( aBrowse[nPosItem,NPOS_QTDVEN] ) },065,002,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,120,010)
			
			oSaySal 	:= TSay():Create(oDlgSep,{||"Saldo: " + cValToChar( aBrowse[nPosItem,NPOS_SALDO] ) },075,002,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,060,010)
					
			oSayApo 	:= TSay():Create(oDlgSep,{||"Apont: " + cValToChar( aBrowse[nPosItem,NPOS_QTDSEP] ) },075,060,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,060,010)
							
			bGetLeitura := {|| IIf(	Empty(cGetLeitura), .T.,;
										(;
											F025Leitur(cGetLeitura, @aBrowse, lUsaLote, lQtdEmb, nPosItem, lDigQtd),;
											IIf( aBrowse[nPosItem,NPOS_QTDSEP] = aBrowse[nPosItem,NPOS_QTDVEN], Eval(bProxItem), Nil ),;
											Eval(bRefresh),;
											Eval(bRefLeit),;
											.F.;
										 ); 
										)}			
										
			oGetLeitura := TGet():New( 	085,;
											002,;
											{|u| IIf(PCount()>0, cGetLeitura := u, cGetLeitura) },;//bSetGet
											oDlgSep,;
											110,;
											010,;
											"@!",;
											bGetLeitura,;//bValid
											CLR_BLUE,;
											CLR_WHITE,;
											,,,;
											.T.,;//lPixel
											,,;
											{||.T.},;//bWhen
											,,,,.F.,"",cGetLeitura)
											
			bLeitPar := {||; 
						   		MsgYesNo( 	"Leitura parcial!    " + CRLF +;
											"Ir para o próximo   " + CRLF +;
											"item?               ",;
											cF025Cad );
							}
	
			bBtoConf := {|| lConf := .T.,;
							  IIf( nPosItem < Len(aBrowse), IIf( (aBrowse[nPosItem,NPOS_LPARCIAL] := Eval(bLeitPar) ), ( lConf := .F., Eval(bProxItem), Eval(bRefresh), Eval(bRefLeit) ), Nil ), Nil ),;
							  IIf( lConf,;
									(;
										lValQtd := .T.,;									
										aEval( aBrowse, {|x| IIf( x[NPOS_QTDVEN] != x[NPOS_QTDSEP] .Or. x[NPOS_QTDSEP] = 0 , lValQtd := .F., Nil ) } ),;
										IIf( !lValQtd,;
	 										  lConf := F025PeConf(aBrowse),;
											  lConf := .T. ),;
										IIf( lConf,;
											(;
												F025Confir(@aConferir, lQtdEmb),;
												nOpc := 1,;
												oDlgSep:End();
										 	),;
											Nil);
									 ),;
							   Nil) }
				
			oBtoConf := TButton():New(	110,;
		 									025,;
		 									"Ok",;
		 									oDlgSep,;
		 									bBtoConf,; 
		 									030,; 
		 									010,,,.F.,.T.,.F.,"",.F.,{|| },,.F. )
		 									
			//       1234567890123456789012
			//                1         2 
			cMsg := "Separação de pedido"
			cMsg += CRLF 
			cMsg += "aglutinado!"
			cMsg += CRLF
			cMsg += "O cancelamento, desfaz" 
			cMsg += CRLF 
			cMsg += "as demais separações.
			cMsg += CRLF
			cMsg += CRLF 
			cMsg += "Confirma?"
			 								
			bBtoCanc := {|| 	IIf(Len(aConferir) > 1,;
										lConf := MsgYesNo(cMsg, cF025Cad),;
									 	lConf := .T.),; 
								IIf(lConf, ( nOpc := 0, oDlgSep:End() ), Nil)}										
		 	
		 	oBtoCanc := TButton():New(	110,;
		 									065,;
		 									"X",;
		 									oDlgSep,;
		 									bBtoCanc,; 
		 									030,; 
		 									010,,,.F.,.T.,.F.,"",.F.,{|| },,.F. )
		
		oDlgSep:Activate(,,,.T.,{||,.T.},,{||} )
			
	Else
	
		// Retorna a area util das janelas
		aSize := MsAdvSize(.F.,,) 
		 
		// Area da janela 
		aAdd( aObj, { 100, 023, .T., .T. }) // Cabecalho  
		aAdd( aObj, { 100, 057, .T., .T. }) // TWbrowse  
		aAdd( aObj, { 100, 020, .T., .T. }) // Rodape 
		 
		// Calculo automatico das dimensoes dos objetos (altura/largura) em pixel 
		aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 5, 5 }
		aPObj := MsObjSize( aInfo, aObj, .T. )   
	
		aAdd( aCabec, "" )
		aAdd( aCabec, "Item" )
		aAdd( aCabec, "Codigo de Barras" )
		aAdd( aCabec, "Produto" )
		aAdd( aCabec, "Descrição" )
		aAdd( aCabec, "Qt. Vendida" )
		aAdd( aCabec, "Qt. Separada" )
		aAdd( aCabec, "Rastro" )
		
		oDlgSep := MSDialog():New( aSize[7], aSize[1], aSize[6], aSize[5], cF025Cad,,,,,,,,,.T.,,, )
		
			// Fontes
			oFntMsg := TFont():New("Arial",,-18,.T.)
			oFntPvV := TFont():New("Arial",,-16,.T.)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Bloco When dos botoes                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
			bWhenBto := { || !Empty( aBrowse[oBroSep:nAt,NPOS_PRODUTO] )  }
						
			bRefLeit := {||;
								cGetLeitura := Space( nTamGetLei + IIf( cTipoEtiq = "2", 1 , 0 ) ),;
								oGetLeitura:CtrlRefresh(),;
								oGetLeitura:SetFocus();
				 		 }
		
			bRefresh := {||;	
								oDlgSep:Refresh(),;
								oBroSep:Refresh();
							}
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cabecalho                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			oPnlCab := TPanel():Create( oDlgSep, aPObj[1,1], aPObj[1,2], "",,,,,, aPObj[1,4], aPObj[1,3] )
			oGrpCab := TGroup():New( 0, 0, (aPObj[1,3]-aPObj[1,1]), aPObj[1,4], "", oPnlCab,,,.T.)
			
			//Get Leitura
			oSayLeitura := TSay():New(	005,;
											005,;
											{||"Leitura"},;
											oGrpCab,,,,;
											,,.T.,,,;
											40,;
											10)
			
			bGetLeitura := {|| IIf(	Empty(cGetLeitura), .T.,;
										(	F025Leitur(cGetLeitura, @aBrowse, lUsaLote, lQtdEmb, nPosItem, lDigQtd),;
											Eval(bRefresh),;
											Eval(bRefLeit),;
											.F. ); 
										)}
	
			oGetLeitura := TGet():New( 	015,;
											005,;
											{|u| IIf(PCount()>0, cGetLeitura := u, cGetLeitura) },;//bSetGet
											oGrpCab,;
											100,;
											010,;
											"@!",;
											bGetLeitura,;//bValid
											,,,,,;
											.T.,;//lPixel
											,,;
											{||.T.},;//bWhen
											,,,,.F.,"",cGetLeitura)
	
			bBtoOrdem := { || IIf( !Empty( aBrowse[oBroSep:nAt,NPOS_PRODUTO] ),;
											(	aBrowse := F025OrdBro(aBrowse, .F.),;
												oBroSep:SetArray( aBrowse ),; 
												oBroSep:bLine := bLinha,;
												oBroSep:GoTop(),;
												oBroSep:nAt := 1,;
												oBroSep:Refresh()),; // .T.
											Nil);						// .F.
								}
				
			cMsg := "Ordem de exibição"
								
			oBtoOrdem := TButton():New(	010,;
			 								125,;
			 								"Ordem exibição",;
			 								oGrpCab,;
			 								bBtoOrdem,; 
			 								055,; 
			 								010,,,.F.,.T.,.F.,cMsg,.F.,{||},,.F. )
			
			bBtoLegen := {|| F025Legend(.F.) }
				
			cMsg := "Legenda"
								
			oBtoLegen := TButton():New(	025,;
			 								125,;
			 								"Legenda",;
			 								oGrpCab,;
			 								bBtoLegen,; 
			 								055,; 
			 								010,,,.F.,.T.,.F.,cMsg,.F.,{||},,.F. )			
			
			oSayPv := TSay():New(	005,;
										200,;
										{||"Pedido"},;
										oGrpCab,,,,;
										,,.T.,,,;
										40,;
										10)
			 								
			oSayCx := TSay():New(	005,;
										250,;
										{||"Caixa"},;
										oGrpCab,,,,;
										,,.T.,,,;
										40,;
										10)
	
			oGetPv := TGet():New( 	015,;
										200,;
										{|| IIf(Len(aConferir)>1,"...", AllTrim(aConferir[Len(aConferir),NCOL_PEDIDO])) },;//bSetGet
										oGrpCab,;
										040,;
										010,;
										"@!",;
										{||.T.},;//bValid
										,,,,,;
										.T.,;//lPixel
										,,;
										{||.F.},;//bWhen
										,,,,.F.,"",)
			 								
			oGetCx := TGet():New( 	015,;
										250,;
										{|| aConferir[Len(aConferir),5]},;//bSetGet
										oGrpCab,;
										040,;
										010,;
										"@!",;
										{||.T.},;//bValid
										,,,,,;
										.T.,;//lPixel
										,,;
										{||.F.},;//bWhen
										,,,,.F.,"",)
																			
			oSayCli := TSay():New(	030,;
										200,;
										{||"Cliente"},;
										oGrpCab,,,,;
										,,.T.,,,;
										40,;
										10)
										
			oSayLoj := TSay():New(	030,;
										250,;
										{||"Loja"},;
										oGrpCab,,,,;
										,,.T.,,,;
										40,;
										10)
										
			oSayDCl := TSay():New(	030,;
										280,;
										{||"Descrição"},;
										oGrpCab,,,,;
										,,.T.,,,;
										40,;
										10)
	
			oGetCli := TGet():New( 	040,;
										200,;
										{|| aConferir[Len(aConferir),NCOL_CLIENT] },;//bSetGet
										oGrpCab,;
										040,;
										010,;
										"@!",;
										{||.T.},;//bValid
										,,,,,;
										.T.,;//lPixel
										,,;
										{||.F.},;//bWhen
										,,,,.F.,"",)
			 								
			oGetLoj := TGet():New( 	040,;
										250,;
										{|| aConferir[Len(aConferir),NCOL_LOJA]},;//bSetGet
										oGrpCab,;
										020,;
										010,;
										"@!",;
										{||.T.},;//bValid
										,,,,,;
										.T.,;//lPixel
										,,;
										{||.F.},;//bWhen
										,,,,.F.,"",)
												 								
			oGetDCl := TGet():New( 	040,;
										280,;
										{|| Posicione( "SA1", 1, xFilial("SA1") + aConferir[Len(aConferir),NCOL_CLIENT] + aConferir[Len(aConferir),NCOL_LOJA], "A1_NOME" ) },;//bSetGet
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
	
			bBtoConf := {||	lValQtd := .T.,;
								aEval( aBrowse, {|x| IIf( x[NPOS_QTDVEN] != x[NPOS_QTDSEP] .Or. x[NPOS_QTDSEP] = 0, lValQtd := .F., Nil ) } ),;
								IIf( !lValQtd,; 
										lConf := F025PeConf(aBrowse),;
										lConf := .T. ),;	
								IIf( lConf,;
									 	MsAguarde( {|| 	F025Confir(@aConferir, lQtdEmb),;
															nOpc := 1,;
															oDlgSep:End()}, "Aguarde!", "Confirmando...", .F. ),;
									 Nil) }
			
			cMsg := "Confirmar separação"
			
			oBtoConf := TButton():New(	005,;
			 								430,;
			 								"Confirmar",;
			 								oGrpCab,;
			 								bBtoConf,; 
			 								040,; 
			 								020,,,.F.,.T.,.F.,cMsg,.F.,{||},,.F. )
			 								
			cMsg := "Separação de pedido aglutinado!"
			cMsg += CRLF
			cMsg += "O cancelamento, desfaz as demais separações." 
			cMsg += CRLF 
			cMsg += CRLF 
			cMsg += "Confirma?"
			 								
			bBtoCanc := {|| 	IIf( Len(aConferir) > 1,;
										lConf := ( Aviso(cF025Cad, cMsg, {"Sim","Não"}, 3 ) = 1 ),;
									 	lConf := .T.),; 
								IIf(lConf, ( nOpc := 0, oDlgSep:End() ), Nil)}										
	
			oBtoCanc := TButton():New(	030,;
			 								430,;
			 								"Cancelar",;
			 								oGrpCab,;
			 								bBtoCanc,; 
			 								040,; 
			 								020,,,.F.,.T.,.F.,"Cancelar separação",.F.,{||},,.F. )
	
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
	
			MsAguarde( {|| oBroSep:SetArray( aBrowse := F025OrdBro( F025Produt(@aConferir), .T. ) ) }, "Aguarde!", "Listando...", .F. )
			
			bLinha := {|| {	oStatus := LoadBitmap( Nil, aLegenda[ aScan( aLegenda := F025Legend(.T.), {|x| x[1] = aBrowse[oBroSep:nAt,NPOS_STATUS]} ) ][3] ),;
								aBrowse[oBroSep:nAt,NPOS_ITEM],;                      
								aBrowse[oBroSep:nAt,NPOS_CODBAR],;
								aBrowse[oBroSep:nAt,NPOS_PRODUTO],;
								aBrowse[oBroSep:nAt,NPOS_DESC],;
								Transform(aBrowse[oBroSep:nAt,NPOS_QTDVEN],"@E 999999.99"),;
								Transform(aBrowse[oBroSep:nAt,NPOS_QTDSEP],"@E 999999.99"),;
								IIf(aBrowse[oBroSep:nAt,NPOS_RASTRO], "Sim", "Nao");
								}}
			
			oBroSep:bLine := bLinha 
			
			oBroSep:aColSizes := {15, 25, 60, 60, 120, 40, 40, 25}
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Rodape                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			oPnlRod := TPanel():Create( oDlgSep, aPObj[3,1], aPObj[3,2], "",,,,,, aPObj[3,4], aPObj[3,3] )
			oGrpRod := TGroup():New( 0, 0, (aPObj[3,3]-aPObj[3,1]), aPObj[3,4], "Última Leitura / Mensagens", oPnlRod,,,.T.)
						
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
		
			oDlgSep:lEscClose := .F. // Desabilita a tecla ESC
			
			oDlgSep:Refresh()
	
		oDlgSep:Activate(,,,.T.,{|| lConf},,{||} )
		
	EndIf
	
	SetKey( VK_F2, bF2 )
	SetKey( VK_F5, bF5 )
	

Return( (nOpc = 1) )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F025Confir³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Botao confirmar.                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F025Confir(aConferir, lQtdEmb)

	Local nPv				:= 0
	Local nScan			:= 0
	Local nQtdSep			:= 0
	Local nQtd_Vend		:= 0
	Local nQtd_Lote		:= 0
	Local dDtValid		:= CToD("")
	Local cStatus			:= ""
	Local cLote			:= ""
	Local lMvSepLib 		:= IIf( aConferir[Len(aConferir),NCOL_FLUXO] = "2", SuperGetMV( "TRS_MON007", .F., .F. ), .T. ) // Se separa com ou sem liberacao de estoque
	Local lF025ApCo		:= ExistBlock("F025APCO")
	
	
	aSeparar := ASort(aSeparar,,,{|x, y| x[NSEP_PRODUTO]+x[NSEP_LOTE]+cValToChar(x[NSEP_QTD]) > y[NSEP_PRODUTO]+y[NSEP_LOTE]+cValToChar(y[NSEP_QTD]) } )
	
	For nPv := 1 To Len(aConferir)
	
		If aConferir[nPv,NCOL_ORIGEM] = "FAT"
		
			Begin Transaction
			
				If aConferir[nPv,NCOL_FLUXO] = "1"
					cStatus := SEPARADO
				Else
					cStatus := ENVIADO_CONFERENCIA
				EndIf
							
				// forca o flag do SC5
				dbSelectArea( "SC5" )
				dbSetOrder(1)//C5_FILIAL+C5_NUM
				dbSeek( xFilial( "SC5" ) + aConferir[nPv,NCOL_PEDIDO] )
					
				RecLock( "SC5", .F. )
	
					If lMvSepLib
						SC5->C5_LIBEROK := "S"
					EndIf
					
					SC5->C5_PVSTAT := cStatus
					SC5->C5_USRSEP := __CUSERID
					SC5->C5_DTASEP := Date()
					SC5->C5_HRASEP := SubStr( Time(), 1, TamSx3("C5_HRASEP")[1] )	
					
				MsUnLock()
		
				dbSelectArea( "SC6" )
				dbSetOrder( 1 ) // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
				dbSeek( xFilial( "SC6" ) + SC5->C5_NUM )
					
				While SC6->( !Eof() ) .And. xFilial("SC6") + SC6->C6_NUM = xFilial("SC5") + SC5->C5_NUM
					
					RecLock( "SC6",.F. )
					
						If aConferir[nPv,NCOL_FLUXO] = "2" .And. !lMvSepLib 
							
							nQtd_Vend := SC6->C6_QTDLIB
							
							If nQtd_Vend = 0
								nQtd_Vend := F025ItSC9()
								dbSelectArea("SC6")
							EndIf
							
						Else
							nQtd_Vend := SC6->C6_QTDVEN
						EndIf
						
						nQtdSep := 0
						
						While nQtd_Vend > nQtdSep
						
							//Busco o proximo produto com a quantidade separada maior que zero e menor que a vendida
							If ( nScan := aScan( aSeparar,{|x| x[NSEP_PRODUTO] = SC6->C6_PRODUTO .And. x[NSEP_QTD] > 0 .And. x[NSEP_QTD] <= nQtd_Vend } ) ) > 0 
							
								cLote 		:= aSeparar[nScan,NSEP_LOTE]
								dDtValid	:= aSeparar[nScan,NSEP_DTVALID]
								nQtd_Lote	:= 0
								
								While 	nQtd_Vend > nQtdSep .And.; 
										SC6->C6_PRODUTO = aSeparar[nScan,NSEP_PRODUTO] .And.;
										cLote = aSeparar[nScan,NSEP_LOTE]
										
									If aSeparar[nScan,NSEP_QTD] = 0
										Exit
									EndIf
	
									nQtd_Lote	+= aSeparar[nScan,NSEP_QTD]
									
									nQtdSep 	+= aSeparar[nScan,NSEP_QTD]
									
									aSeparar[nScan,NSEP_QTD] := 0
									
									If Len(aSeparar) > nScan
										nScan++
									EndIf
								
								EndDo
								
								SC6->C6_LOTECTL	:= cLote 
								SC6->C6_DTVALID	:= dDtValid
								SC6->C6_USRSEP	:= __CUSERID
								SC6->C6_QTDSEP	:= ( SC6->C6_QTDSEP + nQtd_Lote ) 
								SC6->C6_BOXSEP	:= aConferir[nPv,NCOL_CAIXA]
		
								If lMvSepLib
									MaLibDoFat( SC6->( Recno() ), nQtd_Lote, .F., .F., .T., .T., .T., .T., , , , , , , )
								EndIf
		
								SC6->C6_LOTECTL := ""
								SC6->C6_DTVALID := CToD("")
								
							Else
							
								Exit
							
							EndIf
						
						EndDo
					
					MsUnLockAll()
								
					dbSelectArea("SC6")
					dbSkip()
				
				EndDo
			
			End Transaction
		
		ElseIf aConferir[nPv,NCOL_ORIGEM] = "LOJ"

			dbSelectArea("SL1")
			dbSetOrder(1)
		
			dbSeek( xFilial("SL1") + aConferir[nPv,NCOL_PEDIDO] )
			
			If SL1->L1_PVSTAT > SEPARADO
				cStatus := SL1->L1_PVSTAT
			Else
				cStatus := SEPARADO
			EndIf
		
			RecLock("SL1", .F.)
				SL1->L1_PVSTAT := cStatus
				SL1->L1_USRSEP := __CUSERID 
				SL1->L1_DTASEP := Date()
				SL1->L1_HRASEP := SubStr( Time(), 1, TamSx3("L1_HRASEP")[1] )	
			MsUnLock()
			
			dbSelectArea("SL2")
			dbSetOrder(1)
			
			dbSeek( xFilial("SL2") + aConferir[nPv,NCOL_PEDIDO] )
			
			While SL2->( !Eof() ) .And. xFilial("SL2") + SL2->L2_NUM = xFilial("SL1") + SL1->L1_NUM
		
				nQtd_Vend	:= SL2->L2_QUANT
				nQtdSep 	:= 0
				
				While nQtd_Vend > nQtdSep
				
					//Busco o proximo produto com a quantidade separada maior que zero
					If ( nScan := aScan( aSeparar,{|x| x[NSEP_PRODUTO] = SL2->L2_PRODUTO .And. x[NSEP_QTD] > 0 .And. x[NSEP_QTD] <= nQtd_Vend  } ) ) > 0 
					
						cLote 		:= aSeparar[nScan,NSEP_LOTE]
						dDtValid	:= aSeparar[nScan,NSEP_DTVALID]
						nQtd_Lote	:= 0
						
						While 	nQtd_Vend > nQtdSep .And.;
								SL2->L2_PRODUTO = aSeparar[nScan,NSEP_PRODUTO] .And.;
								cLote = aSeparar[nScan,NSEP_LOTE]
						
							If aSeparar[nScan,NSEP_QTD] = 0
								Exit
							EndIf
						
							nQtd_Lote	+= aSeparar[nScan,NSEP_QTD]
							
							nQtdSep 	+= aSeparar[nScan,NSEP_QTD]
							
							aSeparar[nScan,NSEP_QTD] := 0
							
							If Len(aSeparar) > nScan
								nScan++
							EndIf
						
						EndDo
						
						RecLock("SL2", .F.)
							SL2->L2_USRSEP := __CUSERID
							SL2->L2_QTDSEP := ( SL2->L2_QTDSEP + nQtd_Lote )
							SL2->L2_BOXSEP := aConferir[nPv,NCOL_CAIXA]
						MsUnLock()
						
					Else
					
						Exit
					
					EndIf
				
				EndDo
							
				dbSelectArea("SL2")
				dbSkip()
			
			EndDo

		EndIf//aConferir	
	
	Next nPv
	
	If lF025ApCo
		ExecBlock("F025APCO",.F.,.F.,aClone(aConferir))
	EndIf

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F025ItSC9 ³ Autor ³ Jeferson Dambros      ³ Data ³ Ago/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao temporaria.                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F025ItSC9()

	Local cQuery := ""
	Local cArea	:= GetNextAlias() 


	/* 
	Como na COMESPE o sistema não esta preenchendo o campo C6_QTDLIB. 
	Estou buscando essa quantidade no SC9
	*/

	cQuery := " SELECT	MAX( C9_SEQUEN ) C9_SEQUEN, C9_QTDLIB" 		
	cQuery += " FROM	" + RetSQLName("SC9") 
	cQuery += " WHERE		C9_FILIAL	= '" + xFilial("SC9") + "'"		 
	cQuery += "		AND	C9_PEDIDO	= '" + SC6->C6_NUM + "'" 		
	cQuery += "		AND	C9_ITEM	= '" + SC6->C6_ITEM + "'" 		
	cQuery += "		AND	C9_PRODUTO	= '" + SC6->C6_PRODUTO + "'" 		
	cQuery += "  		AND	C9_QTDLIB	> 0" 	
	cQuery += "		AND	D_E_L_E_T_ <> '*'"
	cQuery += " GROUP BY	 C9_SEQUEN, C9_QTDLIB"
	
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArea,.F.,.T.)
	
	nQtdLib := (cArea)->C9_QTDLIB
	
	(cArea)->( dbCloseArea() )
	
Return( nQtdLib )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F025PeConf³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada para validar a confirmacao leitura.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F025PeConf(aBrowse)

	Local cMsg			:= ""
	Local cTipoVar		:= ""
	Local lConf		 	:= .F.
	Local lExistBlock	:= ExistBlock("F025CONF")
		

	If lExistBlock
	
		lConf := ExecBlock("F025CONF",.F.,.F.,aClone(aBrowse))
		
		cTipoVar := ValType(lConf)
		
		If cTipoVar != "L"
			
			lConf := .F.
			
			If l020Coletor
			
				//       1234567890123456789012
				//                1         2 
				cMsg := "Ponto de Entrada:"
				cMsg += CRLF
				cMsg += "F025CONF"
				cMsg += CRLF
				cMsg += "O retorno deste ponto"
				cMsg += CRLF
				cMsg += "precisa lógico ( L )!"
				
				Iw_Msgbox( cMsg, cF025Cad, "ALERT" )
			
			Else

				cMsg := "Ponto de Entrada: F025CONF"
				cMsg += CRLF 
				cMsg += "O tipo de retorno deste ponto de entrada,"
				cMsg += "precisa ser do tipo lógico ( L )!"
				cMsg += CRLF
				cMsg += "L -> " + cTipoVar
				cMsg += CRLF
				cMsg += "Contate o administrador do sistema."
				
				Help("",1,"TRSF025|F025PECONF",,cMsg,1,0)
			
			EndIf
			
		EndIf
  		
 	EndIf
 	
 	If !lExistBlock
 	
 		If !lConf
 		
 			If l020Coletor
 			
 				//       1234567890123456789012
				//                1         2 
				cMsg := "Há inconsistência na"
				cMsg += CRLF
				cMsg += "separação!" 				
				cMsg += CRLF
				cMsg += CRLF
				cMsg += "Confirmar?" 				
				
				lConf := MsgYesNo( cMsg, cF025Cad )
 			
 			Else
 		
	 			cMsg := "Há inconsistência na separação!"
	 			cMsg += CRLF
	 			cMsg += CRLF
	 			cMsg += "Confirmar?"
	 			cMsg += CRLF
	 			cMsg += CRLF
	 			cMsg += "Veja a lista de produto(s):"
	 			cMsg += CRLF
	 			aEval( aBrowse, {|x| IIf( x[NPOS_QTDVEN] != x[NPOS_QTDSEP] .Or. x[NPOS_QTDSEP] = 0 ,;
	 											cMsg	+= "Produto:" + AllTrim(x[NPOS_PRODUTO]);
	 											 		+ " Qt. Venda: " + cValToChar(x[NPOS_QTDVEN]);
	 											 		+ " Qt. Separada: " + cValToChar(x[NPOS_QTDSEP]);
	 											 		+ CRLF,;
	 									Nil) } )
	 									
	 			lConf := ( Aviso(cF025Cad, cMsg, {"Sim","Não"}, 3 ) = 1 )
	 			
 			EndIf
 		EndIf
 	EndIf

Return( lConf )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F025Leitur³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Leitura do Get.                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F025Leitur(cGetLeitura, aBrowse, lUsaLote, lQtdEmb, nPosItem, lDigQtd)

	Local nQtdSep			:= 0
	Local nTamProd		:= TamSx3("B1_COD")[1]
	Local nTamLote		:= TamSx3("C6_LOTECTL")[1]
	Local nTamDtaL		:= TamSX3("C6_DTVALID")[1]
 	Local nScan			:= 0
	Local cProduto		:= PadR( SubStr( cGetLeitura, 1, nTamProd ), nTamProd )
	Local cLoteCtl		:= PadR( SubStr( cGetLeitura, (nTamProd+1), nTamLote ), nTamLote )
	Local cMsg			:= ""
	Local cProdPE			:= ""
	Local dDtaLote		:= SToD( SubStr( cGetLeitura, (nTamProd+nTamLote+1), nTamDtaL ) )
	Local lOk     		:= .T.
	Local lF025Msg		:= ExistBlock("F025MSG")
	Local lF025VQtd		:= ExistBlock("F025VQTD")
	Local lFGenLPro		:= ExistBlock("FGENLPRO")
	Local lFGenQE			:= ExistBlock("FGENQE")
	
	Default nPosItem		:= 0
	
	
	//Ponto de entrada para permitir alterar localizacao do codigo do produto 
	If lFGenLPro
		
		cProdPE := ExecBlock("FGENLPRO",.F.,.F.,{cGetLeitura})
				
		If ValType(cProdPE) = "C"
			cProduto := cProdPE
		EndIf
		
	EndIf
	
	SB1->( dbSetOrder(1) )// B1_FILIAL + B1_COD
	
	//Validar Produto
	If ( nPosItem := aScan( aBrowse, {|x| x[NPOS_PRODUTO] = cProduto .And. x[NPOS_LPARCIAL] = .F. .And. x[NPOS_QTDSEP] < x[NPOS_QTDVEN] } ) ) = 0
	
		SB1->( dbSetOrder(5) )//B1_FILIAL + B1_CODBAR
	
		nTamProd := TamSx3("B1_CODBAR")[1]
		cProduto := SubStr( cGetLeitura, 1 , nTamProd )
	
		If ( nPosItem := aScan( aBrowse, {|x| x[NPOS_CODBAR] = cProduto .And. x[NPOS_LPARCIAL] = .F. .And. x[NPOS_QTDSEP] < x[NPOS_QTDVEN] } ) ) = 0
		
			lOk := .F.
			
			If l020Coletor
			
				//       1234567890123456789012
				//                1         2 
				cMsg := "Produto leitura dife-"
				cMsg += CRLF
				cMsg += "rente do item ou, não"
				cMsg += CRLF
				cMsg += "faz parte deste docu-"
				cMsg += CRLF
				cMsg += "mento." 
				
				Iw_Msgbox( cMsg, cF025Cad, "ALERT" )
			
			Else
			
				cMsgLin1 := cProduto										//-- Produto + Lote
 				cMsgLin2 := ""											//-- Descricao Produto
 				cMsgLin3 := "Produto não faz parte deste documento"	//-- Mensagem
 				cMsgStat := ""											//-- Status quantidades Vendida X Conferida
				
				oMsgLin1:SetText(cMsgLin1)
 				oMsgLin2:SetText(cMsgLin2)
 				oMsgLin3:SetText(cMsgLin3)
 				oMsgStat:SetText(cMsgStat)
 				
 			EndIf
			
		EndIf
	
	EndIf
	
  	//Validar Quantidades
 	If lOk
 	
		// Quantidade ja separada = quantidade venda
		If aBrowse[nPosItem,NPOS_QTDSEP] = aBrowse[nPosItem,NPOS_QTDVEN]
		
			lOk := .F.
			
			If l020Coletor
			
				//       1234567890123456789012
				//                1         2 
				cMsg := "Produto ja separado"

				Iw_Msgbox( cMsg, cF025Cad, "ALERT" )				
			
			Else
			
				cMsgLin1 := cProduto + " Lote: " + cLoteCtl			//-- Produto + Lote
 				cMsgLin2 := aBrowse[nPosItem,NPOS_DESC]				//-- Descricao Produto
 				cMsgLin3 := "Produto ja separado"						//-- Mensagem
 				
 				// Status quantidades Vendida X Conferida
 				cMsgStat := StrZero(aBrowse[nPosItem,NPOS_QTDSEP],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEN])) <= 6, 3, 6 ))
 				cMsgStat += " / "
 				cMsgStat += StrZero(aBrowse[nPosItem,NPOS_QTDVEN],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEN])) <= 6, 3, 6 ))
				
				oMsgLin1:SetText(cMsgLin1)
 				oMsgLin2:SetText(cMsgLin2)
 				oMsgLin3:SetText(cMsgLin3)
 				oMsgStat:SetText(cMsgStat)
	 		
	 		EndIf
	 		
		EndIf
		
	EndIf
  	
	If lOk
	
		nQtdSep := 1
		
		SB1->( dbSeek( xFilial("SB1") + cProduto ) )
		
		If lDigQtd
		
			If lF025VQtd
				
				lDigQtd := ExecBlock("F025VQTD",.F.,.F.,{cProduto})
				
				If ValType( lDigQtd ) <> "L"
					lDigQtd := .F.
				EndIf
				
			EndIf
		
			If lDigQtd
				nQtdSep := F025QtdDig( aBrowse[nPosItem,NPOS_QTDSEP], aBrowse[nPosItem,NPOS_QTDVEN], aBrowse[nPosItem,NPOS_SALDO] )
			EndIf
			
		Else
			
			If lQtdEmb
			
				//Ponto de entrada para customizar a quantidade por embalagem
				If lFGenQE
					
					nQtdSep := ExecBlock("FGENQE",.F.,.F.,{cGetLeitura,cProduto})
							
					If ValType( nQtdSep ) = "N" 
						
						If !F025ValQt( nQtdSep, aBrowse[nPosItem,NPOS_QTDSEP], aBrowse[nPosItem,NPOS_QTDVEN], aBrowse[nPosItem,NPOS_SALDO], .T. )
							
							lOk := .F.
							
							If l020Coletor
					
								//       1234567890123456789012
								//                1         2 
								cMsg := "Qtde separada nao"
								cMsg += CRLF
								cMsg += "confere com a qtde"
								cMsg += CRLF
								cMsg += "vendida."
								
								Iw_Msgbox( cMsg, cF025Cad, "ALERT" )
							
							Else
							
								cMsgLin1 := cProduto + " Lote: " + cLoteCtl										//-- Produto + Lote
				 				cMsgLin2 := aBrowse[nPosItem,NPOS_DESC]											//-- Descricao Produto
				 				cMsgLin3 := "Quantidade separada nao confere com a quantidade vendida."		//-- Mensagem
				 				
				 				// Status quantidades Vendida X Conferida
				 				cMsgStat := StrZero(aBrowse[nPosItem,NPOS_QTDSEP],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEN])) <= 6, 3, 6 ))
				 				cMsgStat += " / "
				 				cMsgStat += StrZero(aBrowse[nPosItem,NPOS_QTDVEN],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEN])) <= 6, 3, 6 ))
								
								oMsgLin1:SetText(cMsgLin1)
				 				oMsgLin2:SetText(cMsgLin2)
				 				oMsgLin3:SetText(cMsgLin3)
				 				oMsgStat:SetText(cMsgStat)
							
							EndIf
						EndIf
						
					Else
						nQtdSep := 1
					EndIf
					
				Else

					If SB1->B1_QE > 0
						
						nQtdSep := ( nQtdSep * SB1->B1_QE )
						
					EndIf
					
				EndIf
				
			EndIf					
			
		EndIf

	EndIf
	
	// Validar Saldo em Estoque somente se, a separacao for com liberacao de estoque
	If lOk .And. lSepLibEst
		
		If aBrowse[nPosItem,NPOS_SALDO] < ( aBrowse[nPosItem,NPOS_QTDSEP] + nQtdSep )
		
			lOk := .F.
		
		EndIf
		
		If lOk
		
			If lUsaLote 
			
				dbSelectArea("SB8")
				dbSetOrder(3)// B8_FILIAL + B8_PRODUTO + B8_LOCAL + B8_LOTECTL
			
				If ( lOk := SB8->( dbSeek( xFilial("SB8") + cProduto + aBrowse[nPosItem,NPOS_LOCAL] + cLoteCtl ) ) )
					
					If ( SB8->B8_SALDO - SB8->B8_EMPENHO ) = 0
					
						lOk := .F.
					
					EndIf
					
					If lOk
						
						If ( nScan := aScan(aSeparar, {|x| x[NSEP_PRODUTO] + x[NSEP_LOTE] = cProduto + cLoteCtl } ) ) > 0
						
							If aSeparar[nScan,NSEP_QTD] = ( SB8->B8_SALDO - SB8->B8_EMPENHO )
							
								lOk := .F.
								
							EndIf 
						EndIf 						
					EndIf
				EndIf
				
			EndIf

		EndIf
		
		If !lOk
		
			If l020Coletor
	
				//       1234567890123456789012
				//                1         2 
				cMsg := "Produto sem saldo"
				cMsg += CRLF
				cMsg += "em estoque"
				
				Iw_Msgbox( cMsg, cF025Cad, "ALERT" )
			
			Else
			
				cMsgLin1 := cProduto + " Lote: " + cLoteCtl			//-- Produto + Lote
 				cMsgLin2 := aBrowse[nPosItem,NPOS_DESC]				//-- Descricao Produto
 				cMsgLin3 := "Produto sem saldo em estoque"			//-- Mensagem
 				
 				// Status quantidades Vendida X Conferida
 				cMsgStat := StrZero(aBrowse[nPosItem,NPOS_QTDSEP],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEN])) <= 6, 3, 6 ))
 				cMsgStat += " / "
 				cMsgStat += StrZero(aBrowse[nPosItem,NPOS_QTDVEN],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEN])) <= 6, 3, 6 ))
				
				oMsgLin1:SetText(cMsgLin1)
 				oMsgLin2:SetText(cMsgLin2)
 				oMsgLin3:SetText(cMsgLin3)
 				oMsgStat:SetText(cMsgStat)
	 		
	 		EndIf
		EndIf
		
	EndIf
	
	//Conferencia Ok 
	If lOk

		//Soma quantidade separada
		aBrowse[nPosItem,NPOS_QTDSEP] += nQtdSep
		
		//Status
		If aBrowse[nPosItem,NPOS_QTDSEP] = aBrowse[nPosItem,NPOS_QTDVEN] 
			aBrowse[nPosItem,NPOS_STATUS] := "S"// S = Separado
		ElseIf aBrowse[nPosItem,NPOS_QTDSEP] < aBrowse[nPosItem,NPOS_QTDVEN]
			aBrowse[nPosItem,NPOS_STATUS] := "E"// E = Em separacao
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³                                           ³
		//³Array com os produtos que estou separando. ³
		//³                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		aAdd( aSeparar, { SB1->B1_COD, cLoteCtl, nQtdSep, dDtaLote } )
		
		If !l020Coletor
		
			cMsgLin1 := cProduto + " Lote: " + cLoteCtl			//-- Produto + Lote
 			cMsgLin2 := aBrowse[nPosItem,NPOS_DESC]				//-- Descricao Produto
 			cMsgLin3 := "Leitura Ok"									//-- Mensagem
 				
 			// Status quantidades Vendida X Conferida
 			cMsgStat := StrZero(aBrowse[nPosItem,NPOS_QTDSEP],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEN])) <= 6, 3, 6 ))
 			cMsgStat += " / "
 			cMsgStat += StrZero(aBrowse[nPosItem,NPOS_QTDVEN],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEN])) <= 6, 3, 6 ))
				
			oMsgLin1:SetText(cMsgLin1)
 			oMsgLin2:SetText(cMsgLin2)
 			oMsgLin3:SetText(cMsgLin3)
 			oMsgStat:SetText(cMsgStat)
								
		EndIf
		
	Else

		If	lF025Msg

			ExecBlock("F025MSG",.F.,.F., { cMsgLin1, cMsgLin2, cMsgLin3, cMsgStat } )
		
		EndIf		

	EndIf
	
Return( .F. )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F025Produt³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna todos os produtos.                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F025Produt(aConferir)

	Local cQuery		:= ""
	Local cArea		:= GetNextAlias()
	Local cAreaSC9	:= ""
	Local cPedido		:= ""
	Local aBrowse		:= {}
	Local nQtdLib		:= 0
	Local nScan		:= 0
	Local nSaldoB2	:= 0
		
	
	aEval( aConferir, {|x| nScan++, cPedido += x[NCOL_PEDIDO] + IIf( nScan < Len(x), "/", "" ) } )
	
	If aConferir[Len(aConferir),NCOL_ORIGEM] = "FAT"
		
		cQuery := " SELECT 	"
		cQuery += " 		 	C6_NUM 		NUM,"
		cQuery += "			C6_ITEM		ITEM,"
		cQuery += "			C6_PRODUTO		PRODUTO,"
		
		If aConferir[Len(aConferir),NCOL_FLUXO] = "2" .And. !lSepLibEst
			
			// 21.08.15 - Temporariamente assim, pois na COMESPE, o sistema nao esta gravando esse campo
			//cQuery += " 	C6_QTDLIB 		QTDLIB,"
			cQuery += " 		( CASE WHEN C6_QTDLIB > 0 THEN C6_QTDLIB ELSE C9_QTDLIB END ) QTDLIB,
			 
		Else
			cQuery += " 		C6_QTDVEN 		QTDLIB,"
		EndIf		
		
		cQuery += "			B1_RASTRO		RASTRO," 		
		cQuery += "			B1_DESC		DESCRIC," 		
		cQuery += "			B1_CODBAR		CODBAR,"
		cQuery += "			C6_LOCAL		LOCAL,"
		cQuery += "			C6_LOCALIZ		LOCALIZ"
				
		cQuery += " FROM		" + RetSQLName("SC6") + " SC6,"	
		cQuery += " 			" + RetSQLName("SB1") + " SB1,"  

		If aConferir[Len(aConferir),NCOL_FLUXO] = "2" .And. !lSepLibEst // Para o fluxo 2, listo apenas os liberados
			cQuery += "  		" + RetSQLName("SC9") + " SC9, "	
		EndIf
  
		cQuery += " 			" + RetSQLName("SF4") + " SF4"  
		
		cQuery += " WHERE		SC6.C6_FILIAL	= '" + xFilial("SC6") + "'"		 
		
		cQuery += "   	AND	SC6.C6_NUM		IN " + FormatIn( cPedido, "/" )	  
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³                                                           ³
		//³Controle de Itens que devem passar pela Separacao          ³
		//³1 = Separa                                                 ³
		//³2 = Nao Separa                                             ³
		//³                                                           ³
		//³Mesmo que o TES esteja configurado para Movimentar Estoque ³
		//³nao sera lido na Separacao e devera ser liberdado no       ³
		//³Pedido de Venda antes da Separacao                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery += "		AND	SC6.C6_ENVSEP = '1'"
		
		If !Empty(aConferir[Len(aConferir),NCOL_LOCAL])
			cQuery += "	AND	SC6.C6_LOCAL = '" + aConferir[Len(aConferir),NCOL_LOCAL] + "'"
		EndIf
		
		cQuery += "   	AND	SF4.F4_ESTOQUE= 'S'" // S = Controla estoque Sim

		cQuery += " 		AND	SB1.B1_FILIAL	= '" + xFilial("SB1") + "'"
		cQuery += " 		AND	SB1.B1_COD 	= SC6.C6_PRODUTO"
	
		cQuery += " 		AND	SF4.F4_FILIAL	= '" + xFilial("SF4") + "'"
		cQuery += " 		AND	SF4.F4_CODIGO = SC6.C6_TES"

		If aConferir[Len(aConferir),NCOL_FLUXO] = "2" .And. !lSepLibEst // Para o fluxo 2, listo apenas os liberados
		
			cQuery += " 	AND	SC9.C9_FILIAL	= '" + xFilial("SC9") + "'"
			cQuery += " 	AND	SC9.C9_PEDIDO	= SC6.C6_NUM"
			cQuery += " 	AND	SC9.C9_ITEM	= SC6.C6_ITEM"

			cQuery += "	AND	SC9.C9_QTDLIB	> 0" 		
			cQuery += "  	AND	SC9.C9_NFISCAL= ' '" 		
			cQuery += "  	AND	SC9.C9_SERIENF= ' '"
			cQuery += "  	AND	SC9.C9_BLEST	= ' '" 		
			cQuery += "  	AND	SC9.C9_BLCRED	= ' '"
			cQuery += "	AND	SC9.D_E_L_E_T_<> '*'"
			
		EndIf 		
		
		cQuery += "		AND	SC6.D_E_L_E_T_<> '*'" 	  
		cQuery += "		AND	SB1.D_E_L_E_T_<> '*'"
		cQuery += "		AND	SF4.D_E_L_E_T_<> '*'"
		
	ElseIf aConferir[Len(aConferir),NCOL_ORIGEM] = "LOJ"
	
		cQuery := " SELECT 	L2_NUM			NUM,"		
		cQuery += "			L2_ITEM		ITEM,"	
		cQuery += "			L2_PRODUTO		PRODUTO,"	
		cQuery += "			L2_QUANT 		QTDLIB,"	
		cQuery += "			B1_RASTRO		RASTRO," 		
		cQuery += "			B1_DESC 		DESCRIC," 		
		cQuery += "			B1_CODBAR 		CODBAR,"
		cQuery += "			L2_LOCAL		LOCAL,"
		cQuery += "			L2_LOCALIZ		LOCALIZ"

		cQuery += " FROM " + RetSQLName("SL2") +" SL2,"
		cQuery += "      " + RetSQLName("SB1") +" SB1"  
									
		cQuery += " WHERE		SL2.L2_FILIAL	= '" + xFilial("SL2") + "'"	
		
		cQuery += "   	AND	SL2.L2_NUM		IN " + FormatIn( cPedido, "/" )	 
		
		cQuery += " 		AND	SB1.B1_FILIAL	= '" + xFilial("SB1") + "'"
		cQuery += " 		AND	SB1.B1_COD 	= SL2.L2_PRODUTO"
		
		cQuery += "		AND	SL2.D_E_L_E_T_ <> '*'"
		cQuery += "		AND	SB1.D_E_L_E_T_ <> '*'"
		
	EndIf
	
	cQuery += " 	 ORDER BY	NUM," 
	cQuery += " 				ITEM," 	  
	cQuery += " 				PRODUTO" 	  

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArea,.F.,.T.)
	
	(cArea)->( dbGoTop() )
	
	While (cArea)->( !Eof() )
		
		nQtdLib := (cArea)->QTDLIB
		
		If 	aConferir[Len(aConferir),NCOL_ORIGEM] = "FAT" .And.;
			aConferir[Len(aConferir),NCOL_FLUXO] = "2" .And. !lSepLibEst
		
			If nQtdLib = 0
			
				cQuery := "SELECT C9_QTDLIB"
				cQuery += " 	FROM " + RetSQLName("SC9")
				cQuery += " 	WHERE C9_FILIAL 	= '" + xFilial("SC9") + "'"
				cQuery += " 		 AND C9_PEDIDO	= '" + (cArea)->NUM +"'"
				cQuery += " 		 AND C9_ITEM		= '" + (cArea)->ITEM  +"'"
				cQuery += " 		 AND C9_PRODUTO	= '" + (cArea)->PRODUTO +"'"
				cQuery += " 		 AND D_E_L_E_T_ <> '*' "
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(cAreaSC9 := GetNextAlias()),.F.,.T.)

				(cAreaSC9)->( dbGoTop() )

				nQtdLib := (cAreaSC9)->C9_QTDLIB 
				
				(cAreaSC9)->( dbCloseArea() )
				
			EndIf	
			
		EndIf
		
		dbSelectArea(cArea)
	
		// Busco o saldo somente se, a separacao for com liberacao
		If lSepLibEst

			dbSelectArea("SB2")
			dbSetOrder(1)
				
			If SB2->( dbSeek( xFilial("SB2") + (cArea)->PRODUTO + (cArea)->LOCAL ) )
				nSaldoB2 := SaldoSB2(Nil,.T.)
			Else
				nSaldoB2 := 0
			EndIf
		
		Else
		
			nSaldoB2 := nQtdLib
			
		EndIf
		
		aAdd( aBrowse, Array(NCOL_QUANT) )
	
		aBrowse[Len(aBrowse)][NPOS_STATUS]		:= "N" // N = Nao separado ou E = Em separacao ou S = Separado
		aBrowse[Len(aBrowse)][NPOS_ITEM]		:= (cArea)->ITEM
		aBrowse[Len(aBrowse)][NPOS_CODBAR]		:= (cArea)->CODBAR
		aBrowse[Len(aBrowse)][NPOS_PRODUTO]	:= (cArea)->PRODUTO
		aBrowse[Len(aBrowse)][NPOS_DESC]		:= (cArea)->DESCRIC
		aBrowse[Len(aBrowse)][NPOS_QTDVEN]		:= nQtdLib
		aBrowse[Len(aBrowse)][NPOS_QTDSEP]		:= 0
		aBrowse[Len(aBrowse)][NPOS_RASTRO]		:= ( (cArea)->RASTRO = "L" )// L = Lote
		aBrowse[Len(aBrowse)][NPOS_LOCAL]		:= (cArea)->LOCAL
		aBrowse[Len(aBrowse)][NPOS_LOCALIZ]	:= (cArea)->LOCALIZ
		aBrowse[Len(aBrowse)][NPOS_SALDO]		:= nSaldoB2
		aBrowse[Len(aBrowse)][NPOS_LPARCIAL]	:= .F.
		
		dbSelectArea(cArea)
		dbSkip()
			
	EndDo
	
	(cArea)->( dbCloseArea() )
	
	If Len(aBrowse) = 0

		aAdd( aBrowse, Array(NCOL_QUANT) )
		
		aBrowse[Len(aBrowse)][NPOS_STATUS]		:= "N" // N = Nao separado ou E = Em separacao ou S = Separado
		aBrowse[Len(aBrowse)][NPOS_ITEM]		:= ""
		aBrowse[Len(aBrowse)][NPOS_CODBAR]		:= ""
		aBrowse[Len(aBrowse)][NPOS_PRODUTO]	:= ""
		aBrowse[Len(aBrowse)][NPOS_DESC]		:= ""
		aBrowse[Len(aBrowse)][NPOS_QTDVEN]		:= 0
		aBrowse[Len(aBrowse)][NPOS_QTDSEP]		:= 0
		aBrowse[Len(aBrowse)][NPOS_RASTRO]		:= .F.
		aBrowse[Len(aBrowse)][NPOS_LOCAL]		:= ""
		aBrowse[Len(aBrowse)][NPOS_LOCALIZ]	:= ""
		aBrowse[Len(aBrowse)][NPOS_SALDO]	 	:= 0
		aBrowse[Len(aBrowse)][NPOS_LPARCIAL]	:= .F.
		
	EndIf

Return( aBrowse )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F025OrdBro³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alterar ordem de exibicao TWBrowse.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F025OrdBro(aBrowse, lAuto)

	Local aRet		:= {}
	Local aPergs		:= {}
	Local aOpcoes		:= {}
	Local lConfirm	:= .T.
	

	aAdd( aOpcoes, "1 - Item + Produto" )
	aAdd( aOpcoes, "2 - Item + Cod. Bar" )
	aAdd( aOpcoes, "3 - Status + Produto" )
	aAdd( aOpcoes, "4 - Qtd. Conferida + Produto" )
	aAdd( aOpcoes, "5 - Qtd. Vendida + Produto" )

	aAdd( aPergs,{3, "Ordem Apresentação", nF025Ord, aOpcoes, 150, "", .F.} )
	
	If !lAuto
	
		If ( lConfirm := ParamBox(aPergs, cF025Cad +" - Ordem", @aRet,,,.T.,,,,,.F.) )
			nF025Ord	:= aRet[1]
		EndIf
		
	EndIf
	
	If lConfirm
	
		If nF025Ord = 1
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPOS_ITEM]+x[NPOS_PRODUTO] < y[NPOS_ITEM]+y[NPOS_PRODUTO] })
		ElseIf nF025Ord = 2  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPOS_ITEM]+x[NPOS_CODBAR] < y[NPOS_ITEM]+y[NPOS_CODBAR] })
		ElseIf nF025Ord = 3  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPOS_STATUS]+x[NPOS_PRODUTO] < y[NPOS_STATUS]+y[NPOS_PRODUTO] })
		ElseIf nF025Ord = 4  	
			aBrowse := ASort(aBrowse,,,{|x, y| cValToChar(x[NPOS_QTDSEP])+x[NPOS_PRODUTO] < cValToChar(y[NPOS_QTDSEP])+y[NPOS_PRODUTO] })
		ElseIf nF025Ord = 5  	
			aBrowse := ASort(aBrowse,,,{|x, y| cValToChar(x[NPOS_QTDVEN])+x[NPOS_PRODUTO] < cValToChar(y[NPOS_QTDVEN])+y[NPOS_PRODUTO] })
		EndIf
		
	EndIf
		
Return( aBrowse )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F025Legend³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Legenda de Status.                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F025Legend(lAuto)

	Local aLegenda	:= {}
	Local cDescric	:= "Status"
	Local aOpcao		:= {}
	
	Default lAuto	:= .F.
	

	aAdd( aOpcao, {"N","Não Separado","BR_VERMELHO"} )
	aAdd( aOpcao, {"E","Em Separação","BR_AMARELO"} )
	aAdd( aOpcao, {"S","Separado","BR_VERDE"} )
	
	If !lAuto
		
		aAdd( aLegenda, {aOpcao[1,3], aOpcao[1,1] + " - " + aOpcao[1,2]} )
		aAdd( aLegenda, {aOpcao[2,3], aOpcao[2,1] + " - " + aOpcao[2,2]} )
		aAdd( aLegenda, {aOpcao[3,3], aOpcao[3,1] + " - " + aOpcao[3,2]} )
		
		BrwLegenda(cF025Cad + " - Legenda", cDescric, aLegenda)
		
	EndIf
		
Return( aOpcao )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F025QtdDig³ Autor ³ Jeferson Dambros      ³ Data ³ Jun/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Digitar a quantidade que sera digitada.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F025QtdDig()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN01 - Quantidade                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRSF025                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function F025QtdDig(nQtdSep, nQtdVen, nQtdSal )

	Local oDlg		:= Nil
	Local oFnt		:= Nil
	Local oBtn1		:= Nil
	Local oQtde		:= Nil
	Local nQtde		:= 0
	Local nTamQtInt	:= TamSx3("C6_QTDVEN")[1]
	Local nTamQtDec	:= TamSx3("C6_QTDVEN")[2]
	Local lContinua	:= .t.
	
	
	DEFINE FONT oFnt NAME "Arial" SIZE 9,15

	While lContinua
	
		dbSelectArea("SC6")
	
		oDlg := MSDialog():New(000,000,130,230,"Informar Quantidade",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
		
			@ 010,002 SAY "Quantidade: " SIZE 080,010 FONT oFnt of oDlg COLOR CLR_BLUE PIXEL
			@ 010,050	MsGet oQtde Var nQtde Picture PesqPictQt("C6_QTDVEN", nTamQtInt, nTamQtDec) Size 060,005 Of oDlg Pixel When .T. Valid ( F025ValQt( nQtde, nQtdSep, nQtdVen, nQtdSal, .F. ) )
					
			DEFINE SBUTTON oBtn1 FROM 045,080 TYPE 1 PIXEL ACTION ( lContinua:= .f., oDlg:End() ) ENABLE OF oDlg
	
		oDlg:Activate(,,,.T.,{||,.T.},,{||} )

	EndDo

Return ( nQtde )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ F025ValQt³ Autor ³ Jeferson Dambros      ³ Data ³ Jun/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida a quantidade que sera digitada.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F025ValQt()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL01 - Verdadeiro ou Falso                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRSF025                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function F025ValQt( nQtde, nQtdSep, nQtdVen, nQtdSal, lExibirMsg )

	Local lRet	:= .T.
	Local cMsg	:= ""
	
	
	If nQtde == 0 .Or. nQtde < 0
	
		lRet := .F.
		
		If !lExibirMsg 
	
			cMsg := "Quantidade Inválida!"
			
			If !l020Coletor 
				Aviso(cF025Cad, cMsg, {"Ok"}, 3 )			
			Else
				Iw_MsgBox( cMsg,"Quantidade","ALERT" )
			EndIf
			
		EndIf
		
	EndIf
	
	If lRet
	
		// Quantidade digitada + Quantidade ja separada
		// nao pode ser maior que o pedido
		If ( nQtde + nQtdSep ) > nQtdVen
		
			lRet := .F.
			
			If !lExibirMsg 
		
				If !l020Coletor 
	
					cMsg := "Quantidade Inválida!"
					cMsg += CRLF
					cMsg += "Quantidade apontada, não pode ser maior, que a quantidade do pedido."
					cMsg += CRLF
					cMsg += "Apont: " + cValToChar( nQtdSep + nQtde )
					cMsg += CRLF
					cMsg += "Qtd Item:" + cValToChar( nQtdVen )
					
					Aviso(cF025Cad, cMsg, {"Ok"}, 3 )
					
				Else
				
					cMsg := "Quantidade Inválida!"
					cMsg += CRLF
					cMsg += CRLF
					cMsg += "Quantidade apontada,"
					cMsg += CRLF
					cMsg += "não pode ser maior,"
					cMsg += CRLF
					cMsg += "que a quantidade"
					cMsg += CRLF
					cMsg += "do pedido."
					cMsg += CRLF
					cMsg += CRLF
					cMsg += "Apont: " + cValToChar( nQtdSep + nQtde )
					cMsg += CRLF
					cMsg += "Qtd Item:" + cValToChar( nQtdVen )
					
					Iw_MsgBox( cMsg, "Quantidade", "ALERT" )
					
				EndIf
				
			EndIf
			
		EndIf
	
	EndIf
	
	// Quantidade digitada + quantidade ja apontada
	// nao pode ser maior que o saldo SB2 do pedido
	If lRet .And. lSepLibEst
	
		If ( nQtde + nQtdSep ) > nQtdSal
		
			lRet := .F.
		
			If !lExibirMsg
			
				If !l020Coletor
	
					cMsg := "Quantidade Inválida!"
					cMsg += CRLF
					cMsg += "Saldo insuficiente."
					cMsg += CRLF
					cMsg += "Apont: " + cValToChar( nQtdSep + nQtde )
					cMsg += CRLF
					cMsg += "Saldo: " + cValToChar( nQtdSal )
					
					Aviso(cF025Cad, cMsg, {"Ok"}, 3 )
					
				Else
				
					cMsg := "Quantidade Inválida!"
					cMsg += CRLF
					cMsg += CRLF
					cMsg += "Saldo insuficiente."
					cMsg += CRLF
					cMsg += CRLF
					cMsg += "Apont: " + cValToChar( nQtdSep + nQtde )
					cMsg += CRLF
					cMsg += "Saldo: " + cValToChar( nQtdSal )
				
					Iw_MsgBox( cMsg, "Quantidade", "ALERT" )
					
				EndIf
		
			EndIf			
		
		EndIf
	
	EndIf 

Return ( lRet )