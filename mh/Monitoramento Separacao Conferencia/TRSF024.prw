#Include "Protheus.ch"
#Include "Trsf010.ch"

/* Colunas TWBrowse */
#Define NP_CHECK			01
#Define NP_NUM			02
#Define NP_EMISSAO		03
#Define NP_CLIENTE		04
#Define NP_LOJA			05
#Define NP_NOME			06
#Define NP_CLIENTREG	07
#Define NP_LOJENTREG	08
#Define NP_NOMENTREG	09
#Define NP_PVVALE		10
#Define NP_ORIGEM		11
#Define NP_ORDSEP		12
#Define NP_VAZIO			13

/* Qtde de colunas TWBrowse */
#Define NCOL_QUANT		13

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ TRSF024  ³ Autor ³ Jeferson Dambros      ³ Data ³ Mar/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Separacao ( Browse )                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ u_TRSF024                                                  ³±±
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
User Function TRSF024()

	Local oDlgDoc
	Local oBroDoc
	Local oOk			:= LoadBitmap(GetResources(),"CHECKED")
	Local oNo			:= LoadBitmap(GetResources(),"UNCHECKED")
	Local oSayLoca, oSayPedi, oSayCli1, oSayCli2, oSayTran, oSayPvVa
	Local oSayDigQ, oSayCliL, oSayCaix
	Local oGetLoca, oGetCliL, oGetCaix
	Local oBtn1, oBtn2, oFont9, oFont7, oBtoBusc, oCboDigQ 	
	
	Local cStatus		:= ""
	Local cMvFluxo	:= AllTrim( SuperGetMV( "TRS_MON001", .F., "" ) )
	Local cTipoEtiq	:= SuperGetMV( "TRS_MON011", .F., "1" ) // Modelo de etiqueta 1 ou 2
	Local cCaixa		:= Space( TamSX3("C6_BOXSEP")[1] ) 
	Local cCliLoja	:= Space( TamSX3("C5_CLIENTE")[1] + TamSX3("C5_LOJACLI")[1] )
	Local cDigQtd		:= ""
	Local cLocal  	:= SuperGetMV( "TRS_MON008", .F., "" ) // Local Padrao para Separacao
	Local cLocVal  	:= AllTrim( SuperGetMV( "TRS_MON009", .F., "" ) )	// Locais Validos para Separacao
	
	Local aSize		:= {}
	Local aObj		:= {}
	Local aInfo		:= {}
	Local aPObj		:= {}
	Local aBrowse		:= {}
	Local aCabec		:= {}
	Local aButtons	:= {}
	Local aCboItem	:= {}
	
	Local nScan		:= 0

	Local lConferido	:= .F.
	
	Local bLinha		:= {||}
	Local bBtoOrdem	:= {||}
	Local bBtoEncCa	:= {||}
	Local bBtoEncOk	:= {||}
	Local bBtoAtual	:= {||}
	Local bStatus		:= {||}
	Local bSelMuito, bSelUnico, bSelecion
	Local bBtoBusc, bAtualiz, bValLoca
	
	Private cF024Cad	:= "Separação (Browse)"
	Private nF024Ord	:= 1	// Ordem de exibicao do Browse
	
	// Campos utilizados no cliente / loja de entrega
	Private aF024MvCpo := Eval( {||	aF024MvCpo := StrToKArr( Upper( SuperGetMv( "TRS_MON006", .F., "C5_CLIENT|C5_LOJAENT", ) ), "|" ),;
										 	IIf(Len(aF024MvCpo) = 0, {"C5_CLIENT", "C5_LOJAENT"}, aF024MvCpo ) } )
	

	dbSelectArea("SC5")
	dbSetOrder(1)

	dbSelectArea("SC6")
	dbSetOrder(1)

	dbSelectArea("SC9")
	dbSetOrder(1)

	dbSelectArea("SL1")
	dbSetOrder(1)

	dbSelectArea("SL2")
	dbSetOrder(1)

	dbSelectArea("SLQ")
	dbSetOrder(1)

	dbSelectArea("SLR")
	dbSetOrder(1)	

	If Type("l020Coletor") <> "L"
		Private l020Coletor := .F.
	EndIf 
	
	If Empty(cLocal)
		cLocal := Space( TamSX3("C6_LOCAL")[1] )
	EndIf
		 
	If u_TRSF011()// Validar a existencia dos campos + autorizacao de uso da rotina
	
		If l020Coletor
		
			DEFINE FONT oFont9 NAME "Arial" SIZE 9,15
			DEFINE FONT oFont7 NAME "Arial" SIZE 7,13
			
			aCboItem:= {'Sim','Não'}
			cDigQtd := aCboItem[2]
			aBrowse := F024Produt( cMvFluxo, cLocal, "ZZZZ" )
				
			oDlgDoc := MSDialog():New( 000, 000, 260, 230, cF024Cad,,,,,,,,,.T.,,, )
			
				// Verificar o status atual do pedido de venda / orcamento
				bStatus := {|a,b| IIf(  a = "FAT",;
											(;
												SC5->( dbSeek( xFilial("SC5") + b ) ),;
												cStatus := SC5->C5_PVSTAT,;
												lConferido := ( SC5->C5_PVSTAT $ ( ENVIADO_SEPARACAO + IIf( F024ValLo( b, cLocal ), EM_SEPARACAO, "" ) ) ),;
											),;
									  		(;
									  			SL1->( dbSeek( xFilial("SL1") + b ) ),;
									  			cStatus := SL1->L1_PVSTAT,;
									  			lConferido := ( SL1->L1_PVSTAT $ (  ENVIADO_SEPARACAO + FATURADO + IIf( F024ValLo( b, cLocal ), EM_SEPARACAO, "" ) ) ),;
										  	);
									    ),;
									 IIf( !lConferido,;
									    	(; 
									    		Iw_Msgbox("Status atual do pedi" + CRLF +;
									    					"do." + CRLF +;
									    					cStatus +" - "+ PV_STATUS[aScan(PV_STATUS,{|x| x[1] = cStatus})][2] + CRLF +;
									    					"Pedido não pode ser" + CRLF +;
									    					"separado!",;
									    					cF024Cad,;
									    					"ALERT" );
										  		 ),;
									   		Nil),;
									 lConferido;	
								}
			
 				bAtualiz := {|Z| 	aBrowse := F024Produt( cMvFluxo, cLocal, Z ),;
									aBrowse := ASort( aBrowse,,,{|x, y| x[NP_ORDSEP]+x[NP_NUM] > y[NP_ORDSEP]+y[NP_NUM] } ),;
 									oSayPedi:CtrlRefresh(),; 
									oSayCli2:CtrlRefresh(),; 
									oSayPvVa:CtrlRefresh(); 
								} 
 				
				oDlgDoc:lEscClose := .F.
				
				oSayCliL := TSay():Create(oDlgDoc,{||"Cli.Ent/Loja:"},007,003,,oFont9,,,,.T.,CLR_BLUE,CLR_WHITE,070,010)
		
				oGetCliL := TGet():New( 	005,;
											053,;
											{|u| IIf(PCount()>0, cCliLoja := u, cCliLoja) },;//bSetGet
											oDlgDoc,;
											040,;
											010,;
											"@!",;
											{||},;//bValid
											CLR_BLUE,;
											CLR_WHITE,;
											,,,;
											.T.,;//lPixel
											,,;
											{||.T.},;//bWhen
											,,,,.F.,"",cCliLoja)
	
				bValLoca := {||	IIf( 	Empty(cLocVal),;
											.T.,;
											IIf( Empty(cLocal),;
												 .T.,;
												 IIf( cLocal $ cLocVal, .T., ( Iw_Msgbox( "Local Inválido", cF024Cad, "ALERT" ), .F. ) ) );
										 ) } 
	
				oSayLoca := TSay():Create(oDlgDoc,{||"Local:"},022,023,,oFont9,,,,.T.,CLR_BLUE,CLR_WHITE,080,010)
		
				oGetLoca := TGet():New( 	020,;
											053,;
											{|u| IIf(PCount()>0, cLocal := u, cLocal) },;//bSetGet
											oDlgDoc,;
											010,;
											010,;
											"@!",;
											bValLoca,;//bValid
											CLR_BLUE,;
											CLR_WHITE,;
											,,,;
											.T.,;//lPixel
											,,;
											{||.T.},;//bWhen
											,,,,.F.,"",cLocal)
											
				oSayCaix := TSay():Create(oDlgDoc,{||"Caixa:"},037,023,,oFont9,,,,.T.,CLR_BLUE,CLR_WHITE,080,010)
		
				oGetCaix := TGet():New( 	035,;
											053,;
											{|u| IIf(PCount()>0, cCaixa := u, cCaixa) },;//bSetGet
											oDlgDoc,;
											040,;
											010,;
											"@!",;
											{||},;//bValid
											CLR_BLUE,;
											CLR_WHITE,;
											,,,;
											.T.,;//lPixel
											,,;
											{||.T.},;//bWhen
											,,,,.F.,"",cCaixa)

				oSayDigQ := TSay():Create(oDlgDoc,{||"Inform. Qtd:" },050,003,,oFont9,,,,.T.,CLR_BLUE,CLR_WHITE,060,010)
				
				oCboDigQ := TComboBox():New(	049,;
													053,;
													{|u| IIf( PCount()>0, cDigQtd:=u, cDigQtd) },; 
													aCboItem,;
													040,;
													020,;
													oDlgDoc,;
													,;
													{||},;
													{||.T.},;
													CLR_BLUE,;
													CLR_WHITE,;
													.T.,;
													oFont9,;
													,,;
													{|| ( cTipoEtiq = "1" ) },;
													,,,,"cDigQtd")	

				oSayPedi := TSay():Create(oDlgDoc,{||"Pedido: " + aBrowse[Len(aBrowse),NP_NUM] },065,003,,oFont9,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)
	
				oSayCli1 := TSay():Create(oDlgDoc,{||"Cliente:" },075,003,,oFont9,,,,.T.,CLR_BLUE,CLR_WHITE,040,008)                                                                                                                               
				oSayCli2 := TSay():Create(oDlgDoc,{||Left( aBrowse[ Len(aBrowse), NP_NOMENTREG], 40 ) },075,034,,oFont7,,,,.T.,CLR_BLUE,CLR_WHITE,070,020)                                                                                                                               
	
				oSayPvVa := TSay():Create(oDlgDoc,{||"Pv.Aglu: " + aBrowse[Len(aBrowse),NP_PVVALE] },095,003,,oFont9,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)
				
				bBtoBusc := {|| 	Eval(bAtualiz, cCliLoja),; 
									IIf( Empty(aBrowse[Len(aBrowse),NP_NUM] ), Iw_Msgbox( "Nenhum pedido encon-"+CRLF+"trado!", cF024Cad, "ALERT" ), Nil ) }
				
				oBtoBusc := TButton():New(	110,;
		 										003,;
		 										"Buscar",;
		 										oDlgDoc,;
		 										bBtoBusc,; 
		 										025,; 
		 										010,,,.F.,.T.,.F.,"",.F.,{|| },,.F. )
		 										
				// Selecionar pedido
				// Todos os pedidos do mesmo cliente de entrega
				bSelMuito := {|| aEval(aBrowse, {|x| IIf(	x[NP_CLIENTREG] = aBrowse[Len(aBrowse),NP_CLIENTREG] .And.;
																 	x[NP_LOJENTREG] = aBrowse[Len(aBrowse),NP_LOJENTREG] .And.;
																 	x[NP_ORDSEP] = aBrowse[Len(aBrowse),NP_ORDSEP] .And.;
														 			x[NP_PVVALE] = "S",;
																	x[NP_CHECK] := !x[NP_CHECK],;//.T.
																	x[NP_CHECK] := .F. ) } );//.F.
							 			}
		
				// Apenas o item posicionado
				bSelUnico := {|| aBrowse[Len(aBrowse),NP_CHECK] := !aBrowse[Len(aBrowse),NP_CHECK] }
									
				bSelecion := {||; 
									IIf( 	aBrowse[Len(aBrowse),NP_PVVALE] = "S",; 
											Eval(bSelMuito),;
											Eval(bSelUnico));
									}		 										
	
				bBtoEncOk := {|| IIf( !Empty(cCaixa),;
										IIf( 	Eval(bStatus, aBrowse[Len(aBrowse),NP_ORIGEM], aBrowse[Len(aBrowse),NP_NUM]),;
												(;
													Eval(bSelecion),;
													F024Confer(aBrowse, cMvFluxo, cLocal, cCaixa, cDigQtd, cLocVal, cTipoEtiq ),;
													Eval(bAtualiz,"ZZZZ"),;
													cLocal := IIf( !Empty( cLocal := SuperGetMV( "TRS_MON008", .F., "" ) ), cLocal, Space( TamSX3("C6_LOCAL")[1] ) ),;
													cCaixa := Space( TamSX3("C6_BOXSEP")[1] ),; 
													cCliLoja := Space( TamSX3("C5_CLIENTE")[1] + TamSX3("C5_LOJACLI")[1] ),;
													ObjectMethod( oGetCliL, "SetFocus()" ); 
												),;
												Nil),;
										Iw_Msgbox( "Preencha o número da"+CRLF+"caixa!", cF024Cad, "ALERT" );
									 );
									}
				
				oBtoOk	  := TButton():New(	110,;
		 										040,;
		 										"Ok",;
		 										oDlgDoc,;
		 										bBtoEncOk,; 
		 										025,; 
		 										010,,,.F.,.T.,.F.,"",.F.,{|| !Empty(aBrowse[Len(aBrowse),NP_NUM]) },,.F. )

				bBtoEncCa := {|| oDlgDoc:End() }
				
				oBtoCa	  := TButton():New(	110,;
		 										070,;
		 										"X",;
		 										oDlgDoc,;
		 										bBtoEncCa,; 
		 										025,; 
		 										010,,,.F.,.T.,.F.,"",.F.,{||},,.F. )
	
			oDlgDoc:Activate(,,,.T.,{||,.T.},,{||} )
		
		Else
		
			// Retorna a area util das janelas
			aSize := MsAdvSize(.T.,,) 
			 
			// Area da janela 
			aAdd( aObj, { 100, 100, .T., .T. })  
			 
			// Calculo automatico das dimensoes dos objetos (altura/largura) em pixel 
			aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 5, 5 }
			aPObj := MsObjSize( aInfo, aObj, .T. )   
			
			aAdd( aCabec, "" )
			aAdd( aCabec, "Pedido" )
			aAdd( aCabec, "Dt Emissão" )
			aAdd( aCabec, "Cliente" )
			aAdd( aCabec, "Loja" )
			aAdd( aCabec, "Nome CLiente" )
			aAdd( aCabec, "Ent. Cliente" )
			aAdd( aCabec, "Ent. Loja" )
			aAdd( aCabec, "Ent. Nome" )
			aAdd( aCabec, "Ent." )
			aAdd( aCabec, "Origem" )
			aAdd( aCabec, "" )
			
			oDlgDoc := MSDialog():New( aSize[7], aSize[1], aSize[6], aSize[5], cF024Cad,,,,,,,,,.T.,,, )
			
				// Verificar o status atual do pedido de venda / orcamento
				bStatus := {|a,b| IIf(  a = "FAT",;
											(;
												SC5->( dbSeek( xFilial("SC5") + b ) ),;
												cStatus := SC5->C5_PVSTAT,;
												lConferido := ( SC5->C5_PVSTAT $ ( ENVIADO_SEPARACAO + EM_SEPARACAO ) ),;
											),;
									  		(;
									  			SL1->( dbSeek( xFilial("SL1") + b ) ),;
									  			cStatus := SL1->L1_PVSTAT,;
									  			lConferido := ( SL1->L1_PVSTAT $ ( ENVIADO_SEPARACAO + FATURADO + EM_SEPARACAO ) ),;
										  	);
									    ),;
									 IIf( !lConferido,;
									    	(; 
												Aviso(	cF024Cad,; 
														"Status atual do pedido:" + CRLF +;
														cStatus +" - "+ PV_STATUS[aScan(PV_STATUS,{|x| x[1] = cStatus})][2] + CRLF +;
														"Pedido não pode ser separado!",;
														{"Ok"} ),;
												Eval(bBtoAtual);
									  		 ),;
									   		Nil),;
									 lConferido;	
								}
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ TWBrowse                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
				oBroDoc := TWBrowse():New( 	aPObj[1,1],; 
												aPObj[1,2],;
												aPObj[1,4],;
												(aPObj[1,3]-aPObj[1,1]),;
												,;
												aCabec,;
												,;
												oDlgDoc,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		
				MsAguarde( {|| oBroDoc:SetArray( aBrowse := F024OrdBro( F024Produt( cMvFluxo, cLocal, cCliLoja ), .T.) ) }, "Aguarde!", "Listando...", .F. )
				
				bLinha := {|| {	IIf(aBrowse[oBroDoc:nAt,NP_CHECK],oOK,oNO),;
									aBrowse[oBroDoc:nAt,NP_NUM],;                      
									aBrowse[oBroDoc:nAt,NP_EMISSAO],;
									aBrowse[oBroDoc:nAt,NP_CLIENTE],;
									aBrowse[oBroDoc:nAt,NP_LOJA],;
									aBrowse[oBroDoc:nAt,NP_NOME],;
									aBrowse[oBroDoc:nAt,NP_CLIENTREG],;
									aBrowse[oBroDoc:nAt,NP_LOJENTREG],;
									aBrowse[oBroDoc:nAt,NP_NOMENTREG],;
									aBrowse[oBroDoc:nAt,NP_PVVALE],;
									aBrowse[oBroDoc:nAt,NP_ORIGEM],;
									aBrowse[oBroDoc:nAt,NP_VAZIO];
									}}
				
				oBroDoc:bLine := bLinha
				
				// Selecionar pedido
				// Todos os pedidos do mesmo cliente de entrega
				bSelMuito := {|| 	aEval(aBrowse, {|x| IIf(	x[NP_CLIENTREG] = aBrowse[oBroDoc:nAt,NP_CLIENTREG] .And.;
																 	x[NP_LOJENTREG] = aBrowse[oBroDoc:nAt,NP_LOJENTREG] .And.;
																 	x[NP_ORDSEP] = aBrowse[oBroDoc:nAt,NP_ORDSEP] .And.;
														 			x[NP_PVVALE] = "S",;
																	x[NP_CHECK] := !x[NP_CHECK],;//.T.
																	x[NP_CHECK] := .F. ) } );//.F.
							 			}
		
				// Apenas o item posicionado
				//bSelUnico := {|| aBrowse[oBroDoc:nAt,NP_CHECK] := !aBrowse[oBroDoc:nAt,NP_CHECK] }
				bSelUnico := {|| nScan := 0, aEval( aBrowse, {|x| nScan++, IIf( nScan != oBroDoc:nAt, x[NP_CHECK] := .F., x[NP_CHECK] := !x[NP_CHECK] ) } ) }
									
				oBroDoc:bLDblClick := {|| IIf( !Empty( aBrowse[oBroDoc:nAt,NP_NUM] ),;
													IIf( Eval(bStatus, aBrowse[oBroDoc:nAt,NP_ORIGEM], aBrowse[oBroDoc:nAt,NP_NUM]),;
											  			IIf( 	aBrowse[oBroDoc:nAt,NP_PVVALE] = "S",; 
											  					Eval(bSelMuito),;
											  					Eval(bSelUnico) ),;
											  			Nil),;
											  Nil),;
											  oBroDoc:Refresh();
										 }
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ EnchoiceBar                                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
				bBtoEncCa := {|| oDlgDoc:End() }
				
				bBtoEncOk := {|| 	IIf( !Empty( aBrowse[oBroDoc:nAt,NP_NUM] ) .And. ( aScan( aBrowse, { |x| x[NP_CHECK] = .T. } ) ) > 0 ,;
											IIf( Eval(bStatus, aBrowse[oBroDoc:nAt,NP_ORIGEM], aBrowse[oBroDoc:nAt,NP_NUM]),;
												(;
													Processa( {|| lConferido := F024Confer(aBrowse, cMvFluxo, cLocal, cCaixa, cDigQtd, cLocVal, cTipoEtiq) }, "Aguarde!", "Listando...", .F.),;
													IIf( lConferido ,;
															(;
																aBrowse := F024OrdBro( F024Produt( cMvFluxo, cLocal, cCliLoja ), .T.),;
																oBroDoc:SetArray( aBrowse ),; 
																oBroDoc:bLine := bLinha,;
																oBroDoc:GoTop(),;
																oBroDoc:nAt := 1,;
																oBroDoc:Refresh();
															),; 
															Nil);
												),;
												Nil),;		
											Aviso(cF024Cad, "Nenhum pedido selecionado!", {"Ok"} ) );
								}
				
				bBtoOrdem := { || IIf( !Empty( aBrowse[oBroDoc:nAt,NP_NUM] ),;
												(	aBrowse := F024OrdBro(aBrowse, .F.),;
													oBroDoc:SetArray( aBrowse ),; 
													oBroDoc:bLine := bLinha,;
													oBroDoc:GoTop(),;
													oBroDoc:nAt := 1,;
													oBroDoc:Refresh()),; // .T.
												Nil);						// .F.
									}
				
				bBtoAtual := { || ;
								MsAguarde( {|| 	aBrowse := {},;
													oBroDoc:SetArray( aBrowse := F024OrdBro( F024Produt( cMvFluxo, cLocal, cCliLoja ), .T.) ),;
													oBroDoc:bLine := bLinha,;
													oBroDoc:Refresh();
												}, "Aguarde!", "Atualizando...", .F. );
									}
				
				aAdd( aButtons, { "EDITABLE", bBtoOrdem,  "|F2| Ordem de exibição" } )
				aAdd( aButtons, { "EDITABLE", bBtoAtual,  "|F5| Atualizar" } )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ SetKey                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				
				SetKey( VK_F2, bBtoOrdem )
				SetKey( VK_F5, bBtoAtual )
		
			oDlgDoc:Activate( {||.T.},,,.T.,,,EnchoiceBar( oDlgDoc, bBtoEncOk, bBtoEncCa,, aButtons ) )
			
			SetKey( VK_F2,  )
			SetKey( VK_F5,  )
			
		EndIf// l020Coletor

	EndIf// u_TRSF011()

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F024Confer³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela de conferencia.                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F024Confer( aBrowse, cMvFluxo, cLocal, cCaixa, cDigQtd, cLocVal, cTipoEtiq )

	Local lConferido	:= .F.
	Local lInfCaixa	:= .F.
	Local aConferir	:= {}
	Local nX			:= 0
	Local bValLoca	:= {||}
	Local bValTipE	:= {||}
	Local bValCaix	:= {||}
	Local bOk			:= {||}
	Local cMsg		:= ""
	Local cPerg		:= PadR( "TRSF024", Len( SX1->X1_GRUPO ) )
	
	
	// Quando nao for por coletor, solicito o numero da caixa, local e se a quantidade sera digitada manualmente
	If !l020Coletor // aBrowse[ aScan(aBrowse, { |x| x[NP_CHECK] = .T. } ), NP_ORIGEM ] = "FAT" .And. !l020Coletor
	
		If !SX1->( dbSeek( cPerg ) )
			F024CriaSx( cPerg )
		EndIf
		
		bValCaix	:= {|| !Empty( MV_PAR01 )  }
		
		bValTipE	:= {|| IIf( cTipoEtiq = "2" .And. MV_PAR03 = 1, .F. , .T. ) }
		
		bValLoca 	:= {|| IIf( Empty( MV_PAR02 ), .T., IIf( MV_PAR02 $ cLocVal, .T., .F. ) ) }
		
		bOk			:= {||	cMsg := "",;
							IIf( Eval(bValCaix), cMsg += "", cMsg += "Preencha a identificação da caixa! " + CRLF ),;
							IIf( Eval(bValTipE), cMsg += "", cMsg += "Para o tipo de etiqueta com lote. Não é possível informar a quantidade!" + CRLF ),;
							IIf( Eval(bValLoca), cMsg += "", cMsg += "Local Inválido! Verifique os locais válidos preenchidos no parametro TRS_MON009." + CRLF ),;
							IIf( Empty(cMsg), .T., ( Aviso(cF024Cad, cMsg, {"Ok"}, 3 ), .F. ) ) }
		While .T.
		
			If ( lInfCaixa := Pergunte( cPerg, .T. ) )
			
				If Eval( bOk )
					
					cCaixa 	:= Upper( MV_PAR01 )
					cLocal 	:= MV_PAR02
					cDigQtd 	:= IIf( MV_PAR03 = 1, "Sim", "Não" )
				
					Exit
					
				EndIf
			Else
				Exit
			EndIf
			
		EndDo
		
	Else
	
		lInfCaixa := .T.
		
	EndIf
	
	If lInfCaixa
	
		// Somente selecionados
		
		ProcRegua( Len(aBrowse) )
		
		For nX := 1 To Len(aBrowse)
		
			IncProc( "Processando..." )
		
			If aBrowse[nX, NP_CHECK]
			
				F024PvStat( aBrowse[nX,NP_NUM], EM_SEPARACAO, aBrowse[nX,NP_ORIGEM], .F.)
				
				aAdd( aConferir, { 	aBrowse[nX,NP_NUM],;
										aBrowse[nX,NP_ORIGEM],;
										aBrowse[nX,NP_CLIENTREG],;
										aBrowse[nX,NP_LOJENTREG],;
										cCaixa,;
										cLocal,;
										cMvFluxo,;
										cDigQtd;
										} )
			
			EndIf
		
		Next nX
		
		// Tela responsavel pela leitura
		lConferido := u_TRSF025( aConferir )	
		
		// Se cancelar a conferencia, limpo os campos especificos
		If !lConferido
		
			ProcRegua( Len(aConferir) )
		
			For nX := 1 To Len(aConferir)
			
				IncProc( "Apagando conferencia..." )
				
				F024PvStat(aConferir[nX,1], ENVIADO_SEPARACAO, aConferir[nX,2], .T.)		
			
			Next nX
				
		EndIf
		
	EndIf
	
Return( lConferido )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F024PvStat³ Autor ³ Jeferson Dambros      ³ Data ³ Abr/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Altera status do pedido de venda ou orçamento.             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F024PvStat( cPedido, cStatus, cOrigem, lRetornar )

	
	If cOrigem = "FAT"
	
		dbSelectArea("SC5")
		dbSetOrder(1)
		
		dbSeek( xFilial("SC5") + cPedido )
		
		RecLock("SC5", .F.)
		
			SC5->C5_PVSTAT := cStatus
			
			If lRetornar
				SC5->C5_USRSEP := ""
				SC5->C5_DTASEP := CToD("//")
				SC5->C5_HRASEP := ""
			EndIf
			
		MsUnLock()
		
		If lRetornar
		
			dbSelectArea("SC6")
			dbSetOrder(1)
		
			dbSeek( xFilial("SC6") + cPedido ) 
		
			While SC6->(!Eof()) .And. SC6->C6_NUM = cPedido
						
				RecLock("SC6", .F.)
					SC6->C6_QTDSEP := 0
					SC6->C6_USRSEP := ""
					SC6->C6_BOXSEP := ""	
				MsUnLock()
					
				dbSelectArea("SC6")
				dbSkip()
							
			EndDo

		EndIf
		
	ElseIf cOrigem = "LOJ"

		dbSelectArea("SL1")
		dbSetOrder(1)
		
		dbSeek( xFilial("SL1") + cPedido )
		
		If SL1->L1_PVSTAT != FATURADO
		
			RecLock("SL1", .F.)
				SL1->L1_PVSTAT := cStatus
			MsUnLock()
			
		EndIf
	
	EndIf
	
Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F024Produt³ Autor ³ Jeferson Dambros      ³ Data ³ Mar/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna todos os produtos da NF ainda nao conferida.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F024Produt( cMvFluxo, cLocal, cCliLoja )  

	Local cQyPadrao	:= ""
	Local cArea		:= GetNextAlias()
	Local cF024Qbpv	:= ""
	Local cMsg		:= ""
	Local aBrowse		:= {}
	Local aQuery		:= {}
	Local nLin		:= 0
	Local lF024Qbpv	:= ExistBlock("F024QBPV")
	Local lSepLibEst	:= SuperGetMV( "TRS_MON007", .F., .F. ) //Rotina de separação: .T. = Separar com liberação de estoque. .F. = Separa sem liberação de estoque.
	Local lOk			:= .F.
	
		
	cQyPadrao := " SELECT 	DISTINCT "		
	cQyPadrao += "			C5_NUM		NUM,"
	cQyPadrao += "			C5_CLIENTE	CLIENTE,"	
	cQyPadrao += "			C5_LOJACLI	LOJACLI,"	
	cQyPadrao += "			A1_NOME	NOME,"
	cQyPadrao += "			C5_EMISSAO	EMISSAO,"		
	cQyPadrao += "			C5_ORDSEP	ORDSEP,"

	aEval( aF024MvCpo, {|x| cQyPadrao += x + ", "}, 1, 2 )// Cliente e Loja de entrega

	cQyPadrao += " 			ISNull( ( SELECT A1_NOME "
	cQyPadrao += " 							FROM " + RetSQLName("SA1")
	cQyPadrao += " 							WHERE 	A1_FILIAL 	= '" + xFilial("SA1") + "'"
	cQyPadrao += " 								AND	A1_COD	 = SC5." + aF024MvCpo[1] 
	cQyPadrao += " 								AND	A1_LOJA = SC5." + aF024MvCpo[2]
	cQyPadrao += " 								AND	D_E_L_E_T_ <> '*' "
	cQyPadrao += " 			), ' ' ) NOM_CLIENTREG,"
	
	cQyPadrao += "			C5_PVVALE 	PVVALE,"
	cQyPadrao += "			'FAT'		ORIGEM"
			
	cQyPadrao += " FROM		" + RetSQLName("SC5") + " SC5, "	
	cQyPadrao += "  			" + RetSQLName("SC6") + " SC6, "
		
	If cMvFluxo = "2" .And. !lSepLibEst// Para o fluxo 2, listo apenas os liberados
		cQyPadrao += "  		" + RetSQLName("SC9") + " SC9, "	
	EndIf
	
	cQyPadrao += "  			" + RetSQLName("SF4") + " SF4, "	
	cQyPadrao += "  			" + RetSQLName("SA1") + " SA1"	

	cQyPadrao += " WHERE		SC5.C5_FILIAL	= '" + xFilial("SC5") + "'"		 
	cQyPadrao += "		AND	SC5.C5_PVSTAT IN ( '" + ENVIADO_SEPARACAO + "', '" + EM_SEPARACAO + "' )"	
	cQyPadrao += "   		AND	SC5.C5_TIPO	= 'N'" // N = Normal
	
	If !Empty(cCliLoja)
		cQyPadrao += "	AND	SC5." + aF024MvCpo[1] +	" + SC5." + aF024MvCpo[2] + " = '"+ cCliLoja +"'"
	EndIf

	cQyPadrao += " 		AND	SC6.C6_FILIAL = '" + xFilial("SC6") + "'"		 
	cQyPadrao += " 		AND	SC6.C6_NUM    = SC5.C5_NUM"
	
	If !Empty(cLocal)
		cQyPadrao += "	AND	SC6.C6_LOCAL	= '"+ cLocal +"'"
	EndIf
	cQyPadrao += " 		AND	SC6.C6_QTDSEP = 0"
	cQyPadrao += " 		AND	SC6.C6_USRSEP = ''"
	cQyPadrao += " 		AND	SC6.C6_BOXSEP = ''"	

	cQyPadrao += " 		AND	SA1.A1_FILIAL = '" + xFilial("SA1") + "'"		 
	cQyPadrao += " 		AND	SA1.A1_COD    = SC5.C5_CLIENTE"			
	cQyPadrao += " 		AND	SA1.A1_LOJA   = SC5.C5_LOJACLI"	
 
	cQyPadrao += " 		AND	SF4.F4_FILIAL	= '" + xFilial("SF4") + "'"
	cQyPadrao += " 		AND	SF4.F4_CODIGO = SC6.C6_TES"
	cQyPadrao += "   		AND	SF4.F4_ESTOQUE= 'S'" // S = Controla estoque Sim
	
	If cMvFluxo = "2" .And. !lSepLibEst // Para o fluxo 2, listo apenas os liberados

		cQyPadrao += " 	AND	SC9.C9_FILIAL	= '" + xFilial("SC9") + "'"
		cQyPadrao += " 	AND	SC9.C9_PEDIDO	= SC5.C5_NUM"
	
		cQyPadrao += "  	AND	SC9.C9_QTDLIB	> 0"
		cQyPadrao += "  	AND	SC9.C9_BLEST	= ' '" 		
		cQyPadrao += "  	AND	SC9.C9_BLCRED	= ' '"
		cQyPadrao += "	AND	SC9.D_E_L_E_T_ <> '*'"
		
	EndIf 		

	cQyPadrao += "		AND	SC5.D_E_L_E_T_ <> '*'" 	  
	cQyPadrao += "		AND	SC6.D_E_L_E_T_ <> '*'" 	  
	cQyPadrao += "		AND	SA1.D_E_L_E_T_ <> '*'"
	cQyPadrao += "		AND	SF4.D_E_L_E_T_ <> '*'" 	  
	
	cQyPadrao += " UNION ALL"
	
	cQyPadrao += " SELECT 	L1_NUM 		NUM,"		
	cQyPadrao += "			L1_CLIENTE 	CLIENTE,"	
	cQyPadrao += "			L1_LOJA 		LOJACLI,"	
	cQyPadrao += "			A1_NOME 		NOME,"
	cQyPadrao += "			L1_EMISSAO 	EMISSAO,"	
	cQyPadrao += "			L1_ORDSEP	 	ORDSEP,"		
	cQyPadrao += "			L1_CLIENTE "	+ aF024MvCpo[1] +"," // Cliente entrega 	
	cQyPadrao += "			L1_LOJA "  	+ aF024MvCpo[2] +"," // Loja cliente entrega
	cQyPadrao += "			A1_NOME 		NOM_CLIENTREG,"
	cQyPadrao += "			' '		 		PVVALE,"
	cQyPadrao += "			'LOJ' 			ORIGEM"
	cQyPadrao += " FROM		" + RetSQLName("SL1") +" SL1,"	
	cQyPadrao += "			" + RetSQLName("SA1") +" SA1"
		
	cQyPadrao += " WHERE		SL1.L1_FILIAL = '" + xFilial("SL1") + "'"	
		 
	cQyPadrao += "		AND	SL1.L1_PVSTAT IN ( '" + ENVIADO_SEPARACAO + "', '" + EM_SEPARACAO + "' )"
	
	cQyPadrao += "   		AND	SL1.L1_DOC		= ' '" 		
	cQyPadrao += "   		AND	SL1.L1_SERIE	= ' '" 		

	cQyPadrao += " 		AND	SA1.A1_FILIAL	= '" + xFilial("SA1") + "'"		 
	cQyPadrao += " 		AND	SA1.A1_COD    = SL1.L1_CLIENTE"			
	cQyPadrao += " 		AND	SA1.A1_LOJA   = SL1.L1_LOJA"			

	cQyPadrao += "		AND	SA1.D_E_L_E_T_ <> '*'" 	  
	cQyPadrao += "		AND	SL1.D_E_L_E_T_ <> '*'" 	

	cQyPadrao += " ORDER BY ORIGEM, NUM, CLIENTE, LOJACLI" 	
	
	If l020Coletor
	
		If lF024Qbpv
			
			cF024Qbpv := ExecBlock( "F024QBPV", .F., .F., { cCliLoja } )
		
			If ValType( cF024Qbpv ) <> "C"
			
				cMsg := "Ponto de Entrada:"
				cMsg += CRLF
				cMsg += "F024QBPV"
				cMsg += CRLF 
				cMsg += "O tipo de retorno,"
				cMsg += CRLF 
				cMsg += "precisa ser caracter."
				cMsg += CRLF
				cMsg += "C -> " + ValType(cF024Qbpv)
				cMsg += CRLF
				cMsg += "Contate o administra-"
				cMsg += CRLF
				cMsg += "dor do sistema!"
	
				Iw_MsgBox( cMsg, "PE: F024QBPV", "ALERT" )
				
				cF024Qbpv := ""
	
			Else
	            
				If !Empty(cF024Qbpv)
	
					aAdd( aQuery, cF024Qbpv )
	
				EndIf
	
			EndIf
			
		EndIf
		
	EndIf
	
	// So ira executar a Query padrao se nao existir o ponto de entrada F024QBPV
	If !lF024Qbpv .Or. Empty(cF024Qbpv)
		aAdd( aQuery, cQyPadrao )
	EndIf

	For	 nLin := 1 To Len( aQuery )
	
		cQyPadrao := ChangeQuery( aQuery[nLin] )
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQyPadrao),cArea,.F.,.T.)
	
		TcSetField( cArea, "EMISSAO", "D", 08, 00 )

		// Se foi encontrado o registro				
		If	(cArea)->( Eof() )

			(cArea)->( dbCloseArea() )
			
			lOk := .F.
		
		Else
		
			lOk := .T.

			Exit

		EndIf
	
	Next nLin
	
	If lOk
	
		(cArea)->( dbGoTop() )
		
		While (cArea)->( !Eof() )
		
			aAdd( aBrowse, Array(NCOL_QUANT) )
			
			nLin := Len(aBrowse)	
			
			aBrowse[nLin][NP_CHECK]		:= .F.
			aBrowse[nLin][NP_NUM]		:= (cArea)->NUM	
			aBrowse[nLin][NP_EMISSAO]	:= (cArea)->EMISSAO
			aBrowse[nLin][NP_CLIENTE]	:= (cArea)->CLIENTE
			aBrowse[nLin][NP_LOJA]		:= (cArea)->LOJACLI
			aBrowse[nLin][NP_NOME]		:= (cArea)->NOME
			aBrowse[nLin][NP_CLIENTREG]	:= IIf( Empty( (cArea)->&(aF024MvCpo[1]) ), (cArea)->CLIENTE, (cArea)->&(aF024MvCpo[1]) )
			aBrowse[nLin][NP_LOJENTREG]	:= IIf( Empty( (cArea)->&(aF024MvCpo[2]) ), (cArea)->LOJACLI, (cArea)->&(aF024MvCpo[2]) )
			aBrowse[nLin][NP_NOMENTREG]	:= (cArea)->NOM_CLIENTREG
			aBrowse[nLin][NP_PVVALE]		:= (cArea)->PVVALE
			aBrowse[nLin][NP_ORIGEM]		:= (cArea)->ORIGEM
			aBrowse[nLin][NP_ORDSEP]		:= (cArea)->ORDSEP
			aBrowse[nLin][NP_VAZIO]		:= ""
		
			dbSelectArea(cArea)
			dbSkip()
			
		EndDo
		
		(cArea)->( dbCloseArea() )
		
	EndIf
	
	If Len(aBrowse) = 0
	
		aAdd( aBrowse, Array(NCOL_QUANT) )
		
		nLin := Len(aBrowse)

		aBrowse[nLin][NP_CHECK]		:= .F.
		aBrowse[nLin][NP_NUM]		:= ""	
		aBrowse[nLin][NP_EMISSAO]	:= CToD("//")
		aBrowse[nLin][NP_CLIENTE]	:= ""
		aBrowse[nLin][NP_LOJA]		:= ""
		aBrowse[nLin][NP_NOME]		:= ""
		aBrowse[nLin][NP_CLIENTREG]	:= ""
		aBrowse[nLin][NP_LOJENTREG]	:= ""
		aBrowse[nLin][NP_NOMENTREG]	:= ""
		aBrowse[nLin][NP_PVVALE]		:= ""
		aBrowse[nLin][NP_ORIGEM]		:= ""
		aBrowse[nLin][NP_ORDSEP]		:= ""
		aBrowse[nLin][NP_VAZIO]		:= ""

	EndIf

Return( aBrowse )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F024OrdBro³ Autor ³ Jeferson Dambros      ³ Data ³ Mar/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alterar ordem de exibicao TWBrowse.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F024OrdBro( aBrowse, lAuto )

	Local aRet		:= {}
	Local aPergs		:= {}
	Local aOpcoes		:= {}
	Local lConfirm	:= .T.


	aAdd( aOpcoes, "1 - Pedido + Cliente + Loja" )
	aAdd( aOpcoes, "2 - Cliente + Loja + Pedido" )
	aAdd( aOpcoes, "3 - Data Emissão" )
	aAdd( aOpcoes, "4 - Nome Cliente + Pedido" )

	aAdd( aPergs,{3, "Ordem Apresentação", nF024Ord, aOpcoes, 150, "", .F.} )
	
	If !lAuto
	
		If ParamBox(aPergs, "Ordem", @aRet,,,.T.,,,,,.F.)
			nF024Ord	:= aRet[1]
		Else
			lConfirm := .F.
		EndIf
		
	EndIf
	
	If lConfirm
	
		If nF024Ord = 1
			aBrowse := ASort(aBrowse,,,{|x, y| x[NP_ORIGEM]+x[NP_NUM]+x[NP_CLIENTE]+x[NP_LOJA] < y[NP_ORIGEM]+y[NP_NUM]+y[NP_CLIENTE]+y[NP_LOJA] })
		ElseIf nF024Ord = 2  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NP_ORIGEM]+x[NP_CLIENTE]+x[NP_LOJA]+x[NP_NUM] < y[NP_ORIGEM]+y[NP_CLIENTE]+y[NP_LOJA]+y[NP_NUM] })
		ElseIf nF024Ord = 3  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NP_ORIGEM]+DToS(x[NP_EMISSAO]) < y[NP_ORIGEM]+DToS(y[NP_EMISSAO]) })
		ElseIf nF024Ord = 4  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NP_ORIGEM]+x[NP_NOME]+x[NP_NUM] < y[NP_ORIGEM]+y[NP_NOME]+y[NP_NUM]})
		EndIf
		
	EndIf
		
Return( aBrowse )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F024ValLo ³ Autor ³ Jeferson Dambros      ³ Data ³ Jul/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validar se todos os pedidos pertencem ao mesmo local       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F024ValLo( cPedido, cLocal )

	Local cQuery	:= ""
	//Local cPedido := ""
	Local cArea	:= GetNextAlias()
	Local lRet	:= .F.
	
	//aEval( aBrowse, {|x| IIf( x[NP_NUM] $ cPedido, Nil, cPedido += x[NP_NUM] + IIf( nScan < Len(x), "/", "" ) ) } )
	
	cQuery := " SELECT 	COUNT(C6_PRODUTO) QTD_PROD "		
	cQuery += " FROM		" + RetSQLName("SC6")	
	cQuery += " WHERE		C6_FILIAL		= '" + xFilial("SC6") + "'"		 
	//cQuery += " 	AND	C6_NUM    		IN " + FormatIn( cPedido, "/" )
	cQuery += " 		AND	C6_NUM    		= '" + cPedido + "'" 
	cQuery += " 		AND	C6_LOCAL  		<> '" + cLocal + "'"
	cQuery += "		AND	D_E_L_E_T_ 	<> '*'" 	  

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArea,.F.,.T.)
	
	lRet := ( (cArea)->QTD_PROD = 0 )
	
	(cArea)->( dbCloseArea() )
	
Return( lRet )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F024CriaSx³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Criar o grupo de perguntas.                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F024CriaSx(cPerg)

	Local aP		:= {}
	Local aHelp	:= {}
	Local nI		:= 0
	Local cSeq	:= ""
	Local cMvCh	:= ""
	Local cMvPar	:= ""


	/*
	Parametros da funcao padrao
	---------------------------
	PutSX1(cGrupo,;
	       cOrdem,;
	       cPergunt,cPerSpa,cPerEng,;
	       cVar,;
	       cTipo,;
	       nTamanho,;
	       nDecimal,;
	       nPresel,;
	       cGSC,;
	       cValid,;
	       cF3,;
	       cGrpSxg,;
	       cPyme,;
	       cVar01,;
	       cDef01,cDefSpa1,cDefEng1,;
	       cCnt01,;
	       cDef02,cDefSpa2,cDefEng2,;
	       cDef03,cDefSpa3,cDefEng3,;
	       cDef04,cDefSpa4,cDefEng4,;
	       cDef05,cDefSpa5,cDefEng5,;
	       aHelpPor,aHelpEng,aHelpSpa,;
	       cHelp)
	*/

	//			Texto Pergunta	       	Tipo 	Tam 	  					Dec  	G=get ou C=Choice  	Val   	F3		Def01 	  Def02 	 Def03   Def04   Def05
	aAdd(aP,{	"Caixa ?",   					"C",	TamSX3("C6_BOXSEP")[01],		0,		"G",				"",	 "",	   	"",			 "",		"",		"",		"" })
	aAdd(aP,{	"Local ?",						"C",	TamSX3("C6_LOCAL")[01],		0,		"G",				"",	 "",		"",			 "",		"",		"",		"" })
	aAdd(aP,{	"Informar Qtd ?",				"N",	01,								0,		"C",				"",	 "",		"Sim",		 "Não",	"",		"",		"" })
	

    //          012345678912345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    //                   1         2         3         4         5         6         7         8         9        10        11        12
	aAdd(aHelp,{"Identificação caixa utilizada para", "separação."})
	aAdd(aHelp,{"Local onde esta armazenado o produto.", "Para separação não parcial, não", " preencha esse campo.", "Local padrão e valido, consulte", "os parametros TRS_MON008 e TRS_MON009."})
	aAdd(aHelp,{"Utilize esta opção apenas para etiqueta", "sem lote.", "Sim = Quantidade solicitada a cada item.","Não = Quantidade leitura automatica."})


	For nI := 1 To Len(aP)

		cSeq	:= StrZero(nI,2,0)
		cMvPar	:= "mv_par"+cSeq
		cMvCh	:= "mv_ch"+IIF(nI<=9,Chr(nI+48),Chr(nI+87))

		PutSx1(cPerg,;
		cSeq,;
		aP[nI,1],aP[nI,1],aP[nI,1],;
		cMvCh,;
		aP[nI,2],;
		aP[nI,3],;
		aP[nI,4],;
		0,;
		aP[nI,5],;
		aP[nI,6],;
		aP[nI,7],;
		"",;
		"",;
		cMvPar,;
		aP[nI,8],aP[nI,8],aP[nI,8],;
		"",;
		aP[nI,9],aP[nI,9],aP[nI,9],;
		aP[nI,10],aP[nI,10],aP[nI,10],;
		aP[nI,11],aP[nI,11],aP[nI,11],;
		aP[nI,12],aP[nI,12],aP[nI,12],;
		aHelp[nI],;
		{},;
		{},;
		"")

	Next nI

Return