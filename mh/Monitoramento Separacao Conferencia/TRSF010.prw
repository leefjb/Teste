#Include "Totvs.ch"
#Include "Trsf010.ch"
#Include "Msgraphi.ch"
                         
/* Colunas TWBrowse Pedido*/
#Define PV_CHECK			01
#Define PV_C5_PVSTAT	02
#Define PV_C5_ORDSEP	03
#Define PV_C5_NUM		04
#Define PV_C5_CLIENTE	05
#Define PV_C5_LOJACLI	06
#Define PV_A1_NOME		07
#Define PV_A1_MUN		08
#Define PV_C5_EMISSAO	09
#Define PV_C9_DATALIB	10
#Define PV_C5_DTASEP	11
#Define PV_C5_HRASEP	12
#Define PV_C5_USRSEP	13
#Define PV_CLIENTREG	14
#Define PV_LOJENTREG	15
#Define PV_NOMENTREG	16
#Define PV_PVVALE		17
#Define PV_ORIGEM		18
#Define PV_ITENS			19
#Define PV_NOTA			20
#Define PV_SERIE			21

/* Qtde de colunas TWBrowse Pedido*/
#Define PV_QTDCOL		21

/* Colunas TWBrowse Item Pedido */
#Define IT_C6_ITEM 		01
#Define IT_C6_PRODUTO	02
#Define IT_B1_DESC		03
#Define IT_C9_LOCAL		04
#Define IT_C6_BOXSEP	05
#Define IT_C6_USRSEP	06
#Define IT_C6_QTDVEN	07
#Define IT_C9_QTDLIB	08
#Define IT_C6_QTDSEP	09
#Define IT_C6_QTDCONF	10
#Define IT_VAZIO			11
                   
/* Qtde de colunas TWBrowse Item Pedido*/
#Define IT_QTDCOL		11

/* Resolucao do Monitor */
Static aMonitor	:= GetScreenRes()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ TRSF010  ³ Autor ³ Jeferson Dambros      ³ Data ³Set/2014  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monitoramento Pedido de venda e orcamento                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ u_TRSF010                                                  ³±±
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
User Function TRSF010()     

	Local oDlgMon
	Local oBrowPv
	Local oBrowIt
	Local oStatus
	Local oPanel1, oPanel2
	Local oGroup1, oGroup2
	Local oBtoAtual, oBtoParam, oBtoOrdem, oBtoVisPv, oBtoSair, oBtoRCar, oBtoOrdPr, oBtoLegen
	Local oBtoESep, oBtoFPed, oBtoPrepD, oBtoInf
	
	//Local oOk	:= LoadBitmap(GetResources(),"CHECKED")
	//Local oNo	:= LoadBitmap(GetResources(),"UNCHECKED")
	
	Local oOk	:= LoadBitmap(GetResources(),"LBOK")
	Local oNo	:= LoadBitmap(GetResources(),"LBNO")
	
	Local oGrafico
	Local oTimer
	
	Local lMvCpoEnt 	:= .T.

	Local aSize		:= {}
	Local aObj		:= {}
	Local aInfo		:= {}
	Local aPObj		:= {}
	Local aBrowPv		:= {}
	Local aCabPv		:= {}
	Local aBrowIt		:= {}
	Local aCabIt		:= {}
	
	Local bBtoAtual, bBtoParam, bBtoOrdem, bBtoVisPv, bBtoSair, bBtoRCar, bBtoOrdPr, bBtoLegen
	Local bBtoESep, bBtoFPed, bBtoPrepD, bBtoInf
	Local bWhenBto
	Local bLinhaPv
	Local bLinhaIt
	Local bAtuTela, bBrowPv, bBrowIt, bGrafico
	Local bSetTimer
	Local bOrigFat, bSelOrig
	Local bFluxo
	Local bSelMuito, bSelUnico 
	
	Local nColBto		:= 0
	Local nScan		:= 0
	Local nTimer		:= ( ( 5 * 60 ) * 1000 ) // Tempo padrao de 5 minutos
	
	Local cMvFluxo	:= ""
	Local cPerg		:= PadR("TRSF010",Len(SX1->X1_GRUPO))
	Local cMsg		:= ""
	
	Private cF010Cad	:= "Monitor Pedido"
	Private nF010Ord	:= 1	// Ordem de exibicao do Browse
	
	// Campos utilizados no cliente / loja de entrega
	Private aF010MvCpo := {} 
	
	
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

	// Limpo o cache de parametros
	SuperGetMv()
	
	cMvFluxo 	:= AllTrim( SuperGetMV( "TRS_MON001", .F., "" ) )
	
	aF010MvCpo	:= Eval( {|| 	aF010MvCpo := StrToKArr( Upper( SuperGetMv( "TRS_MON006", .F., "C5_CLIENT|C5_LOJAENT", ) ), "|" ),;
							 	IIf( Len(aF010MvCpo) = 0, {"C5_CLIENT", "C5_LOJAENT"}, aF010MvCpo ) } )

	If u_TRSF011()// Validar a existencia dos campos + autorizacao de uso da rotina 
		
		If !SX1->( dbSeek(cPerg) )
			F010CriaSx(cPerg)
		EndIf
		
		If Pergunte(cPerg, .T.)
	  
			// Retorna a area util das janelas
			aSize := MsAdvSize(.F.,,) 
			 
			// Sera utilizada duas areas na janela 
			aAdd( aObj, { 100, 013, .T., .T. }) 
			aAdd( aObj, { 100, 050, .T., .T. })  
			aAdd( aObj, { 100, 037, .T., .T. })  
			 
			// Calculo automatico das dimensoes dos objetos (altura/largura) em pixel 
			aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 5, 5 }
			aPObj := MsObjSize( aInfo, aObj, .T. )   
			
			//Cabec Pedido
			aAdd( aCabPv, "" )
			aAdd( aCabPv, "Situacao" )
			aAdd( aCabPv, "Ordem" )
			aAdd( aCabPv, "Pedido" )
			aAdd( aCabPv, "Cliente" )
			aAdd( aCabPv, "Loja" )
			aAdd( aCabPv, "Nome CLiente" )
			aAdd( aCabPv, "Município" )
			aAdd( aCabPv, "Dt Emissão" )
			aAdd( aCabPv, "Ent. Cliente" )
			aAdd( aCabPv, "Ent. Loja " )
			aAdd( aCabPv, "Ent. Nome" )
			aAdd( aCabPv, "Doc. Saida" )
			aAdd( aCabPv, "Serie" )
			aAdd( aCabPv, "Dt Liber." )
			aAdd( aCabPv, "Dt Separ." )
			aAdd( aCabPv, "Hr Separ." )
			aAdd( aCabPv, "Usuário Separação" )
			aAdd( aCabPv, "Ent." )
			aAdd( aCabPv, "Origem" )
			
			//Cabec Item pedido
			aAdd( aCabIt, "Item" )
			aAdd( aCabIt, "Produto" )
			aAdd( aCabIt, "Descrição" )
			aAdd( aCabIt, "Local" )
			aAdd( aCabIt, "N. Caixa" )
			aAdd( aCabIt, "Separador" )
			aAdd( aCabIt, "Qtd Venda" )
			aAdd( aCabIt, "Qtd Liberada" )
			aAdd( aCabIt, "Qtd Separada" )
			aAdd( aCabIt, "Qtd Conferida" )
			aAdd( aCabIt, "" )
							
			oDlgMon := MSDialog():New( aSize[7], aSize[1], aSize[6], aSize[5], cF010Cad,,,,,,,,,.T.,,, )
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Bloco responsavel por atualizar a TELA         ³
				//³                                                ³
				//³ Obs. Utilizado em quase todos os botoes.       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				bAtuTela := {|| 	Eval(bBrowPv),;
									Eval(bGrafico),;
									Eval(bBrowIt);
								}
								
				// Timer
				bSetTimer := {||	IIf( (nTimer := F010TimerB(nTimer)) = 0, oTimer:DeActivate(), (oTimer:Activate(), oTimer:nInterval := nTimer) ) }
				
				oTimer := TTimer():New( nTimer, {|| Eval(bAtuTela) }, oDlgMon )
	   			
	   			oTimer:Activate()
	   			   			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Bloco When dos botoes                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				bWhenBto := {|| !Empty( aBrowPv[oBrowPv:nAt,PV_C5_NUM] )  }
				
				bOrigFat := {|z| IIf( z <> "FAT", ( Aviso(cF010Cad, "Utilize esta opção."+CRLF+"Apenas para pedido de venda ( Origem = FAT ).",{"Ok"} ), .F. ), .T.) }
				
				bFluxo := {|x,y| IIf( x = FATURAMENTO_EXCLUIDO, .T., IIf( y = "2", (x = CONFERIDO), (x = SEPARADO) ) ) }

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Painel 1 Botoes Default                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				oPanel1 := TPanel():Create( oDlgMon, aPObj[1,1], aPObj[1,2], "",,,,,, (aPObj[1,2]+245), (aPObj[1,3]-2))
				oGroup1 := TGroup():New( 0, 0, (aPObj[1,3]-2), (aPObj[1,2]+245), "Função", oPanel1,,,.T.)
				
				bBtoAtual := { || MsAguarde( bAtuTela, "Aguarde!", "Atualizando...", .F. ) }
								
				cMsg := "| F5 | Atualizar status"
				
				oBtoAtual := TButton():New(	aPObj[1,1]+005,;
												aPObj[1,2]+005,;
												"| F5 | Atualizar",;
												oPanel1,;
												bBtoAtual,;
												R(070)[2],;
												010,,,.F.,.T.,.F.,cMsg,.F.,,,.F. )
				
				bBtoParam := { || IIf( Pergunte(cPerg, .T.), Eval(bAtuTela), Nil) }
				
				cMsg := "| F4 | Parâmetros"
								
				oBtoParam := TButton():New(	aPObj[1,1]+005,;
												aPObj[1,2]+090,;
												"| F4 | Parâmetros",;
												oPanel1,;
												bBtoParam,;
												R(070)[2],;
												010,,,.F.,.T.,.F.,cMsg,.F.,,,.F. )
				
				bBtoLegen := { || F010Legend() }
	
				cMsg := "| F7 | Legenda"
				
				oBtoLegen := TButton():New(	aPObj[1,1]+005,;
												aPObj[1,2]+170,;
												"| F7 | Legenda",;
												oPanel1,;
												bBtoLegen,;
												R(070)[2],;
												010,,,.F.,.T.,.F.,cMsg,.F.,,,.F. )
				
				bBtoOrdem := { || IIf( !Empty( aBrowPv[oBrowPv:nAt,PV_C5_NUM] ),;
											(	aBrowPv := F010OrdBro(aBrowPv, .F.),;
												oBrowPv:SetArray( aBrowPv ),; 
												oBrowPv:bLine := bLinhaPv,;
												oBrowPv:GoTop(),;
												oBrowPv:nAt := 1,;
												oBrowPv:Refresh(),;
												Eval(bGrafico),;
												Eval(bBrowIt)),;	// .T.
											Nil);				   // .F.
								}
				
				cMsg := "| F2 | Ordem de exibição"
								
				oBtoOrdem := TButton():New(	aPObj[1,1]+020,;
				 								aPObj[1,2]+005,;
				 								"| F2 | Ordem",;
				 								oPanel1,;
				 								bBtoOrdem,; 
				 								R(070)[2],; 
				 								010,,,.F.,.T.,.F.,cMsg,.F.,bWhenBto,,.F. )
				
				bBtoVisPv := { || IIf( !Empty( aBrowPv[oBrowPv:nAt,PV_C5_NUM] ), F010VisuPv( aBrowPv[oBrowPv:nAt,PV_C5_NUM], aBrowPv[oBrowPv:nAt,PV_ORIGEM] ), Nil) }
				
				cMsg := "| F6 | Visualizar pedido"
				
				oBtoVisPv := TButton():New(	aPObj[1,1]+020,;
												aPObj[1,2]+090,;
												"| F6 | Visualizar",;
												oPanel1,;
												bBtoVisPv,;
												R(070)[2],;
												010,,,.F.,.T.,.F.,cMsg,.F.,bWhenBto,,.F. )
				
				bBtoSair  := { || oDlgMon:End() }
				
				oBtoSair  := TButton():New(	aPObj[1,1]+018,;
												aPObj[1,2]+252,;
												"Sair",;
												oDlgMon,;
												bBtoSair,;
												030,;
												020,,,.F.,.T.,.F.,,.F.,,,.F. )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Painel 2 Botoes variaveis (permissao de acesso)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				oPanel2 := TPanel():Create( oDlgMon, aPObj[1,1], (aPObj[1,2]+285), "",,,,,, (aPObj[1,4]-205), (aPObj[1,3]-2))
				oGroup2 := TGroup():New( 0, 0, (aPObj[1,3]-2), (aPObj[1,4]-285), "Processo", oPanel2,,,.T.)
				
				bBtoESep := { ||  IIf( ( aScan( aBrowPv, {|x| (x[PV_CHECK] = .T.) } ) ) > 0,;
											 MsAguarde( {|| IIF( F010EnvSep(aBrowPv), Eval(bAtuTela), Nil ) },; 
															  "Aguarde!",;
															  "Enviando pedido...",;
															  .F. ),;
											 Aviso(cF010Cad, "Nenhum pedido selecionado!", {"Ok"} ) );
							  	}
				
				nColBto := 010
				oBtoESep := TButton():New(	aPObj[1,1]+005,;
												aPObj[1,2]+nColBto,;
												"Enviar p/ Separação",;
												oPanel2,;
												bBtoESep,;
												R(070)[2],;
												010,,,.F.,.T.,.F.,,.F.,bWhenBto,,.F. )
		
				bBtoOrdPr := { || IIf( aBrowPv[oBrowPv:nAt,PV_C5_PVSTAT] < EM_SEPARACAO,;
											(	F010OrdPri(aBrowPv,oBrowPv:nAt),;
												Eval(bAtuTela);
											),;
											Aviso(cF010Cad, "Impossível alterar prioridade!"+CRLF+"Verifique o Status.", {"Ok"});
										 );
								}
				
				nColBto += 080
				oBtoOrdPr := TButton():New(	aPObj[1,1]+005,;
												aPObj[1,2]+nColBto,;
												"Ordem Prioridade",;
												oPanel2,;
												bBtoOrdPr,;
												R(070)[2],;
												010,,,.F.,.T.,.F.,,.F.,bWhenBto,,.F. )
												
				bBtoPrepD := { || IIf( Eval(bOrigFat, aBrowPv[oBrowPv:nAt,PV_ORIGEM]),;
										(;
											F010FatPed(aBrowPv[oBrowPv:nAt,PV_C5_NUM], 2),;
							 				aBrowPv := {},;
							 				oBrowPv:SetArray( aBrowPv := F010OrdBro( F010Pedido(cPerg), .T.) ),;
							 				oBrowPv:bLine := bLinhaPv,;
							 				oBrowPv:GoTop(),;
							 				oBrowPv:nAt := 1,;
							 				oBrowPv:Refresh();
							 			),;//.T.
							 		 Nil);//.F.
								}
				
				nColBto += 080
				oBtoPrepD := TButton():New(	aPObj[1,1]+005,;
												aPObj[1,2]+nColBto,;
												"Prep. Docs. Saida",;
												oPanel2,;
												bBtoPrepD,;
												R(070)[2],;
												010,,,.F.,.T.,.F.,,.F.,bWhenBto,,.F. )
												
				bBtoRCar := { || IIf( Eval(bOrigFat, aBrowPv[oBrowPv:nAt,PV_ORIGEM]),;
										IIf( aBrowPv[oBrowPv:nAt,PV_C5_PVSTAT] <> PEDIDO_INCLUIDO,;
											(;
											IIf( Aviso(cF010Cad, "Confirma o retorno ?", {"Sim", "Não"} ) = 1,;
												  (	;	
												  		F010RetCar(aBrowPv[oBrowPv:nAt,PV_C5_NUM]),;
										  				Eval(bAtuTela);
										  	  		),;//.T.
										  	  		Nil);//.F.
											),;//.T.
											Aviso(cF010Cad, "Impossível retornar!"+CRLF+"Verifique o Status.", {"Ok"}) ),;//.F.
									 Nil);
									}
				
				nColBto := 010
				oBtoRCar := TButton():New(	aPObj[1,1]+020,;
												aPObj[1,2]+nColBto,;
												"Retornar Carteira",;
												oPanel2,;
												bBtoRCar,;
												R(070)[2],;
												010,,,.F.,.T.,.F.,,.F.,bWhenBto,,.F. )
				
				bBtoFPed := { || IIf( Eval(bOrigFat, aBrowPv[oBrowPv:nAt,PV_ORIGEM]),;
										IIf( Eval( bFluxo, aBrowPv[oBrowPv:nAt,PV_C5_PVSTAT], cMvFluxo ),;
											(;
										 		F010FatPed(aBrowPv[oBrowPv:nAt,PV_C5_NUM], 1),;
										 		aBrowPv := {},;
										 		oBrowPv:SetArray( aBrowPv := F010OrdBro( F010Pedido(cPerg), .T.) ),;
										 		oBrowPv:bLine := bLinhaPv,;
										 		oBrowPv:GoTop(),;
										 		oBrowPv:nAt := 1,;
										 		oBrowPv:Refresh();
											),;//.T.
											Aviso(cF010Cad, "Impossível faturar o pedido!"+CRLF+"Verifique o Status.", {"Ok"}) ),;//.F.
									Nil);
								}
				
				nColBto += 080
				oBtoFPed := TButton():New(	aPObj[1,1]+020,;
												aPObj[1,2]+nColBto,;
												"Faturar Pedido",;
												oPanel2,;
												bBtoFPed,;
												R(070)[2],;
												010,,,.F.,.T.,.F.,,.F.,bWhenBto,,.F. )
												
				bBtoInf := {|| IIf( Eval(bOrigFat, aBrowPv[oBrowPv:nAt,PV_ORIGEM]), F010Transp(aBrowPv[oBrowPv:nAt,PV_C5_NUM]), Nil ) }
				
				nColBto += 080
				oBtoInf := TButton():New(	aPObj[1,1]+020,;
												aPObj[1,2]+nColBto,;
												"Inf. Transportadora",;
												oPanel2,;
												bBtoInf,;
												R(070)[2],;
												010,,,.F.,.T.,.F.,,.F.,bWhenBto,,.F. )												
												
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ TWBrowse                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				bBrowPv := {|| 	aBrowPv := {},;
									oBrowPv:SetArray( aBrowPv := F010OrdBro( F010Pedido(cPerg), .T.) ),;
									oBrowPv:bLine := bLinhaPv,;
									oBrowPv:Refresh();
								}
								
				// Utilizo no duplo clique. Validar a marcacao de registro com a mesma origem
				bSelOrig := { |z| nScan := aScan( aBrowPv, {|x| x[PV_CHECK] = .T.} ),;
									IIf( nScan > 0, IIf( z = aBrowPv[nScan,PV_ORIGEM], .T., .F.), .T. );
								 } 
	
				oBrowPv := TWBrowse():New( 	aPObj[2,1],; 
												aPObj[2,2],;
												aPObj[2,4],;
												(aPObj[2,3]-aPObj[2,1]),;
												,;
												aCabPv,;
												,;
												oDlgMon,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		
				MsAguarde( {|| oBrowPv:SetArray( aBrowPv := F010OrdBro( F010Pedido(cPerg), .T.) ) }, "Aguarde!", "Listando pedido...", .F. )
	
				bLinhaPv := {|| {	IIf(aBrowPv[oBrowPv:nAt,PV_CHECK],oOK,oNO),;
									oStatus := LoadBitmap( Nil, PV_STATUS[aScan(PV_STATUS, {|x| x[1] = aBrowPv[oBrowPv:nAt,PV_C5_PVSTAT]})][3] ),;
									aBrowPv[oBrowPv:nAt,PV_C5_ORDSEP],;                      
									aBrowPv[oBrowPv:nAt,PV_C5_NUM],;
									aBrowPv[oBrowPv:nAt,PV_C5_CLIENTE],;
									aBrowPv[oBrowPv:nAt,PV_C5_LOJACLI],;
									aBrowPv[oBrowPv:nAt,PV_A1_NOME],;
									aBrowPv[oBrowPv:nAt,PV_A1_MUN],;
									aBrowPv[oBrowPv:nAt,PV_C5_EMISSAO],;
									aBrowPv[oBrowPv:nAt,PV_CLIENTREG],;
									aBrowPv[oBrowPv:nAt,PV_LOJENTREG],;
									aBrowPv[oBrowPv:nAt,PV_NOMENTREG],;
									aBrowPv[oBrowPv:nAt,PV_NOTA],;
									aBrowPv[oBrowPv:nAt,PV_SERIE],;
									aBrowPv[oBrowPv:nAt,PV_C9_DATALIB],;
									aBrowPv[oBrowPv:nAt,PV_C5_DTASEP],;
									aBrowPv[oBrowPv:nAt,PV_C5_HRASEP],;
									aBrowPv[oBrowPv:nAt,PV_C5_USRSEP],;
									aBrowPv[oBrowPv:nAt,PV_PVVALE],;
									aBrowPv[oBrowPv:nAt,PV_ORIGEM];
									}}
									
				oBrowPv:aColSizes := {10, 10, 30, 30, 30, 15, 100, 60, 40, 30, 15, 50, 35, 5, 30, 30, 15, 40, 10, 10}
				
				oBrowPv:bLine := bLinhaPv 
							
				// Selecionar pedido
				// Todos os pedidos do mesmo cliente de entrega
				bSelMuito := {||	aEval(aBrowPv, {|x| IIf(	x[PV_CLIENTREG] = aBrowPv[oBrowPv:nAt,PV_CLIENTREG] .And.;
																	x[PV_LOJENTREG] = aBrowPv[oBrowPv:nAt,PV_LOJENTREG] .And.;
																	x[PV_C5_ORDSEP] = aBrowPv[oBrowPv:nAt,PV_C5_ORDSEP] .And.;
																	x[PV_C5_PVSTAT] = PEDIDO_INCLUIDO .And.;
																 	x[PV_PVVALE] = "S",;
																	x[PV_CHECK] := !x[PV_CHECK],;//.T.
																	Nil ) } );//.F.
					 			}
				
				// Apenas o item posicionado 
				bSelUnico := {|| aBrowPv[oBrowPv:nAt,PV_CHECK] := !aBrowPv[oBrowPv:nAt,PV_CHECK] }
  
/*									
				oBrowPv:bLDblClick := {|| IIf( !Empty(aBrowPv[oBrowPv:nAt,PV_C5_NUM]),;
													IIf(	aBrowPv[oBrowPv:nAt,PV_C5_PVSTAT] = PEDIDO_INCLUIDO .And. Eval(bSelOrig, aBrowPv[oBrowPv:nAt,PV_ORIGEM]),;
															( IIf( aBrowPv[oBrowPv:nAt,PV_PVVALE] = "S", Eval(bSelMuito), Eval(bSelUnico) ), oBrowPv:Refresh() ),;
															Aviso(	cF010Cad,;
																	"Seleção não permitida!"+CRLF+;
																	"Verifique o status ou a origem do registro. "+;
																	"( Marque apenas pedido de venda ou orçamento ).",; 
																	{"Ok"})),;
													Nil)}
*/


				oBrowPv:bLDblClick := {|| IIf( !Empty(aBrowPv[oBrowPv:nAt,PV_C5_NUM]),;
													IIf(	aBrowPv[oBrowPv:nAt,PV_C5_PVSTAT] = PEDIDO_INCLUIDO .And. Eval(bSelOrig, aBrowPv[oBrowPv:nAt,PV_ORIGEM]),;
															( IIf( aBrowPv[oBrowPv:nAt,PV_PVVALE] = "S", Eval(bSelUnico), Eval(bSelUnico) ), oBrowPv:Refresh() ),;
															Aviso(	cF010Cad,;
																	"Seleção não permitida!"+CRLF+;
																	"Verifique o status ou a origem do registro. "+;
																	"( Marque apenas pedido de venda ou orçamento ).",; 
																	{"Ok"})),;
													Nil)}

				
				oBrowPv:bChange := {||	Eval(bGrafico),;
											Eval(bBrowIt);
											}
		
				oBrowPv:bHeaderClick := {|| Eval(bSetTimer) }
		
				oBrowPv:Refresh()
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Rodape                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
				// Grafico
				
				bGrafico := {|| oGrafico := F010Grafic(aBrowPv[oBrowPv:nAt,PV_ITENS], oGrafico, aPObj[3,1], aPObj[3,2], (aPObj[3,2]+160), (aPObj[3,3]-aPObj[3,1]), @oDlgMon) }
				
				oGrafico := Eval(bGrafico)
				
				// TWBrowse
				
				bBrowIt := {|| 	aBrowIt := {},;
									oBrowIt:SetArray( aBrowIt := aBrowPv[oBrowPv:nAt,PV_ITENS] ),;
									oBrowIt:bLine := bLinhaIt,;
									oBrowIt:Refresh()}
				
				oBrowIt := TWBrowse():New( aPObj[3,1], (aPObj[3,2]+165), (aPObj[3,4]-(aPObj[3,2]+165)), (aPObj[3,3]-aPObj[3,1]),,,, oDlgMon,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	
				oBrowIt:aHeaders := aCabIt
		
				oBrowIt:SetArray( aBrowIt := aBrowPv[oBrowPv:nAt,PV_ITENS] )
				
				bLinhaIt := { || {	aBrowIt[oBrowIt:nAt][IT_C6_ITEM],;
										aBrowIt[oBrowIt:nAt][IT_C6_PRODUTO],;
										aBrowIt[oBrowIt:nAt][IT_B1_DESC],;
										aBrowIt[oBrowIt:nAt][IT_C9_LOCAL],;
										aBrowIt[oBrowIt:nAt][IT_C6_BOXSEP],;
										aBrowIt[oBrowIt:nAt][IT_C6_USRSEP],;
										aBrowIt[oBrowIt:nAt][IT_C6_QTDVEN],;
										aBrowIt[oBrowIt:nAt][IT_C9_QTDLIB],;
										aBrowIt[oBrowIt:nAt][IT_C6_QTDSEP],;
										aBrowIt[oBrowIt:nAt][IT_C6_QTDCONF],;
										aBrowIt[oBrowIt:nAt][IT_VAZIO];
										}}
				
				oBrowIt:aColSizes := {15, 35, 100, 30, 30, 30, 40, 40, 40, 40, 5}
	
				oBrowIt:bLine := bLinhaIt
		
				oBrowIt:Refresh()	
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ SetKey                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				
				SetKey( VK_F2, bBtoOrdem )
				SetKey( VK_F4, bBtoParam )
				SetKey( VK_F5, bBtoAtual )
				SetKey( VK_F6, bBtoVisPv )
				SetKey( VK_F7, bBtoLegen )
				SetKey( VK_F9, bSetTimer )
	
			oDlgMon:Activate( {||.T.} , , ,.T., , , )
			
			SetKey( VK_F2,  )
			SetKey( VK_F4,  )
			SetKey( VK_F5,  )
			SetKey( VK_F6,  )
			SetKey( VK_F7,  )
			SetKey( VK_F9,  )
			
		EndIf// Pergunte
		
	EndIf//u_TRSF011
	
Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010Grafic³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monta o grafico.                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F010Grafic(aBrowIt, oGrafico, nTop, nBotton, nLargura, nAltura, oDlgMon)
    
	Local aQtd := {0,0,0,0}
	

	If oGrafico <> Nil
	
		// Destroi e recria o objeto
		// OBS: Necessário para manutenção de recursos do sistema
		FreeObj(oGrafico)

	EndIf 
	
	aEval(aBrowIt, {|x|	aQtd[1] += x[IT_C6_QTDVEN],; 
							aQtd[2] += x[IT_C9_QTDLIB],;
							aQtd[3] += x[IT_C6_QTDSEP],;
							aQtd[4] += x[IT_C6_QTDCONF] })

   oGrafico := TMSGraphic():New(nTop, nBotton, oDlgMon,,,, nLargura, nAltura)    
    
	oGrafico:SetTitle( "Status do pedido ( Por Total / Quantidade )", "", CLR_HBLUE, A_CENTER, .F. )
    
   	oGrafico:SetMargins(2,8,2,6)
       	
   	oGrafico:SetRangeY(0,aQtd[1])
   	
	nSerie := oGrafico:CreateSerie( GRP_BAR, "", 0 )

   oGrafico:Add(nSerie, aQtd[1], "Ven.", CLR_YELLOW )  
   oGrafico:Add(nSerie, aQtd[2], "Lib.", CLR_YELLOW )  
   oGrafico:Add(nSerie, aQtd[3], "Sep.", CLR_YELLOW )      
   oGrafico:Add(nSerie, aQtd[4], "Conf.", CLR_YELLOW )  

Return( oGrafico )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010RetCar³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retornar o status do pedido para incluido.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F010RetCar(cPedido)

	Local lOk 		:= .T.
	Local lSepLibEst	:= SuperGetMV( "TRS_MON007", .F., .F. ) //Rotina de separação: .T. = Separar com liberação de estoque. .F. = Separa sem liberação de estoque.
	Local cStatus		:= ""
	
	
	SD2->( dbSetOrder(8) )
	SC9->( dbSetOrder(1) )
	
	If SD2->( dbSeek(xFilial("SD2")+cPedido) )
	
		Aviso(cF010Cad, "Impossível retornar!"+CRLF+"Pedido faturado.", {"Ok"})
		
		lOk := .F.
	
	EndIf
	
	If lOk
	
		If SC9->( dbSeek(xFilial("SC9")+cPedido) )
		
			Aviso(cF010Cad, "Impossível retornar!"+CRLF+"Pedido liberado.", {"Ok"})
			
			lOk := .F.
		
		EndIf
	
	EndIf

	If lOk
	
		If lSepLibEst
			cStatus := PEDIDO_INCLUIDO
		Else
			cStatus := LIB_COMERCIAL
		EndIf
	
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek( xFilial("SC5") + cPedido )
							
		RecLock("SC5", .F.)
			SC5->C5_PVSTAT := cStatus
			SC5->C5_DTASEP := CToD("")
			SC5->C5_HRASEP := ""
			SC5->C5_USRSEP := ""
			SC5->C5_PVVALE := "N"//N=Nao
		MsUnLock()

		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek( xFilial("SC6") + cPedido )
		
		While !Eof() .And. SC6->C6_NUM = cPedido
		
			RecLock("SC6", .F.)
				SC6->C6_QTDSEP	:= 0
				SC6->C6_USRSEP	:= ""
				SC6->C6_QTDCONF	:= 0
				SC6->C6_BOXSEP	:= ""
			MsUnLock()
		
			dbSkip()
			
		EndDo

	EndIf

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010FatPed³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Executar as rotinas de faturamento padrao do sistema.      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F010FatPed(cPedido, nTipo)


	If nTipo = 1
	
		dbSelectArea("SC5")
		dbSetOrder(1)
		
		If dbSeek(xFilial("SC5")+cPedido,.F.)
				
			Ma410PvNfs("SC5",SC5->(RecNo()),3)
			
		EndIf
	
	ElseIf nTipo = 2
		
		MATA460()		
	
	EndIf 

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010OrdPri³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alterar a Ordem de prioridade.                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F010OrdPri(aBrowPv, nLinSel)

	Local aRet		:= {}
	Local aPergs		:= {}
	Local aPedido		:= {}
	Local nX			:= 0
	Local nTamOrdem	:= TamSX3("C5_ORDSEP")[1]
	Local cOrdem		:= Space(nTamOrdem)
	
	
	aAdd( aPergs,{1, "Prioridade", cOrdem, "@R 999999", "!Empty(MV_PAR01)", "", ".T.", nTamOrdem, .F.} )
	
	If ParamBox(aPergs, "Ordem Prioridade", @aRet,,,.T.,,,,,.F.)
	
		// Ordem digitada
		aRet[1]:= StrZero( Val(aRet[1]), nTamOrdem )
	
		// Ultima ordem nas tabelas 
		cOrdem := U_F010OrdSep()
		
		If aRet[1] > cOrdem

			Soma1( cOrdem )

			Aviso(	cF010Cad,; 
					"Impossível alterar para essa ordem!" + CRLF +; 
					IIf( cOrdem != aBrowPv[nLinSel,PV_C5_ORDSEP], "Ordem alterada para: " + CRLF + cOrdem, "" ),;
					{"Ok"})

		Else
			
			cOrdem := aRet[1]
			
		EndIf
		
		If aBrowPv[nLinSel,PV_ORIGEM] = "FAT"// Faturamento
		
			If aBrowPv[nLinSel,PV_PVVALE] = "N"//N=Nao
		
				aAdd( aPedido, aBrowPv[nLinSel,PV_C5_NUM] )
						
			Else
					
				//-- Buscar todo pedido que pertence ao grupo
				aEval( aBrowPv, {|x| IIf( 	x[PV_CLIENTREG] = aBrowPv[nLinSel,PV_CLIENTREG] .And.;
												x[PV_LOJENTREG] = aBrowPv[nLinSel,PV_LOJENTREG] .And.;
												x[PV_PVVALE] = "S" .And.;
												x[PV_C5_PVSTAT] < EM_SEPARACAO,;
												aAdd( aPedido, x[PV_C5_NUM] ),;//.T.
												Nil ) } )//.F.
			EndIf
		
			dbSelectArea("SC5")
			dbSetOrder(1)
	
			For nX := 1 To Len(aPedido)
			
				dbSeek( xFilial("SC5") + aPedido[nX] )
										
				RecLock("SC5", .F.)
					SC5->C5_ORDSEP := cOrdem
				MsUnLock()
				
			Next nX
			
		Else// Loja

			dbSelectArea("SL1")
			dbSetOrder(1)
			dbSeek( xFilial("SL1") + aBrowPv[nLinSel,PV_C5_NUM] )
									
			RecLock("SL1", .F.)
				SL1->L1_ORDSEP := cOrdem
			MsUnLock()
			
		EndIf
		
	EndIf
	
Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010EnvSep³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alterar o Status para enviar pedido para separacao.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F010EnvSep(aBrowPv)
	
	Local aPedido		:= {}
	Local lOk 		:= .T.
	Local cQuery		:= ""
	Local cAreaPv		:= GetNextAlias()
	Local cRelSep		:= AllTrim( SuperGetMV( "TRS_MON012", .F., "1" ) )
	Local nZ			:= 0
	
	
	For nZ := 1 To Len(aBrowPv)
	
		If aBrowPv[nZ][PV_CHECK]
		
			If aBrowPv[nZ][PV_ORIGEM] = "FAT"
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³                                                           ³
				//³Controle de Itens que devem passar pela Separacao          ³
				//³1 = Separa                                                 ³
				//³2 = Nao Separa                                             ³
				//³                                                           ³
				//³Todo o item cujo o campo C6_ENVSEP = '2' devera ser libera-³
				//³do antes de enviar a Separacao.                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
				cQuery := " SELECT 	C6_NUM,"		
				cQuery += "			C6_ITEM,"	
				cQuery += "			C6_PRODUTO,"
				
				cQuery += " 			ISNull( ( SELECT MAX(C9_SEQUEN) SEQUEN "
				cQuery += " 							FROM " + RetSQLName("SC9")
				cQuery += " 							WHERE C9_FILIAL 	= '" + xFilial("SC9") + "'"
				cQuery += " 							 AND C9_PEDIDO	= C6_NUM"
				cQuery += " 							 AND C9_ITEM		= C6_ITEM"
				cQuery += " 							 AND C9_PRODUTO	= C6_PRODUTO"
				cQuery += " 							 AND D_E_L_E_T_ <> '*' "
				cQuery += " 			), ' ' ) C9_SEQUEN "
				
				cQuery += " FROM		" + RetSQLName("SC6") +" SC6"	
				cQuery += " WHERE		C6_FILIAL	= '" + xFilial("SC6") +"'"		 
				cQuery += "   	AND	C6_NUM		= '"+ aBrowPv[nZ][PV_C5_NUM] +"'"   
				cQuery += "   	AND	C6_ENVSEP	= '2'" //-- 2 = Nao Separar  
				cQuery += "		AND	D_E_L_E_T_	<> '*'"
				
				cQuery := ChangeQuery(cQuery)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAreaPv,.F.,.T.)
				
				(cAreaPv)->( dbGoTop() )
				
				lOk := .T.
				
				While (cAreaPv)->( !Eof() )
				
					If Empty( (cAreaPv)->C9_SEQUEN )
					
						lOk := .F.
						
						Exit
					
					EndIf
					
					(cAreaPv)->( dbSkip() )
					
			 	EndDo
			 	
			 	(cAreaPv)->( dbCloseArea() )
			
				If lOk
				
					aAdd(aPedido, { aBrowPv[nZ][PV_ORIGEM], aBrowPv[nZ][PV_C5_NUM] } )
				
				Else
					
					dbSelectArea("SX3")
					dbSetOrder(2) 
					dbSeek("C6_ENVSEP")
					
					Aviso(	cF010Cad,;
							"Faça a liberação no pedido de venda, para todo item, onde o campo: "; 
							+ CRLF;
							+ AllTrim(SX3->X3_TITULO) + " ( C6_ENVSEP ), foi preenchido com ( Não )!";
							+ CRLF;
							+ "Após liberar o item, envie o pedido a separação.",;
							{"Ok"}, 3 )
				EndIf
				
			ElseIf aBrowPv[nZ][PV_ORIGEM] = "LOJ"

				dbSelectArea("SL1")
				dbSetOrder(1)
				dbSeek( xFilial("SL1") + aBrowPv[nZ,PV_C5_NUM] )
				
				lOk := .T.
				
				If SL1->L1_PVSTAT = PEDIDO_INCLUIDO
				
					aAdd(aPedido, { aBrowPv[nZ][PV_ORIGEM], aBrowPv[nZ][PV_C5_NUM] } )
				
				Else
				
					lOk := .F.
 
		 			Aviso(	cF010Cad,; 
		 					"Status atual do pedido:"; 
		 					+ CRLF;
		 					+ SL1->L1_PVSTAT +" - "+ PV_STATUS[aScan(PV_STATUS,{|x| x[1] = SL1->L1_PVSTAT})][2]; 
		 					+ CRLF;
		 					+ "Pedido não pode ser enviado a separação!",;
		 					{"Ok"}, 3 )
				EndIf
				
			EndIf
			
		EndIf
		
		If !lOk
			Exit
		EndIf
	
	Next nZ

	If lOk
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ponto de Entrada                     ³
		//³                                     ³
		//³Para validacao do usuario            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("F010ESEP")
		
			lOk := ExecBlock( "F010ESEP", .F., .F., aClone(aPedido) )
					
			If ValType(lOk) != "L" 
			
				lOk := .F.
						
				Help(	"",;
						1,;
						"TRSF010|F010ESEP",;
						,;
						"Ponto de Entrada: F010ESEP";
						+ CRLF; 
						+ "O tipo de retorno deste ponto de entrada, precisa ser do tipo lógico ( L )!";
						+ CRLF;
						+ "L -> " + ValType(lOk);
						+ CRLF;
						+ "Contate o administrador do sistema.",;
						1,;
						0)
					
			EndIf
			
		EndIf
	
		If lOk
		
			For nZ := 1 To Len(aPedido)
			
				If aPedido[nZ,1] = "FAT"
						
					dbSelectArea("SC5")
					dbSetOrder(1)
					dbSeek( xFilial("SC5") + aPedido[nZ,2] )
											
					RecLock("SC5", .F.)
						SC5->C5_PVSTAT := ENVIADO_SEPARACAO
					MsUnLock()
					
				ElseIf aPedido[nZ,1] = "LOJ"

					dbSelectArea("SL1")
					dbSetOrder(1)
		
					dbSeek( xFilial("SL1") + aPedido[nZ,2] )
									
					RecLock("SL1", .F.)
						SL1->L1_PVSTAT := ENVIADO_SEPARACAO
					MsUnLock()
				
				EndIf
						
			Next nZ
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Impressao relatorio auxiliar         ³
			//³                                     ³
			//³1 = Nao, 2 = Somente Faturamento,    ³
			//³3 = Somente Loja, 4 = Ambos          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  			
  			If cRelSep $ "23"

				If aPedido[Len(aPedido),1] = "LOJ"
					U_TRSF026(aPedido)
				ElseIf aPedido[Len(aPedido),1] = "FAT"
					U_TRSF026(aPedido)
				EndIf
  			
  			ElseIf cRelSep = "4" 
			
				U_TRSF026(aPedido)
				
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ponto de Entrada                     ³
			//³                                     ³
			//³Ao final do envio a separacao        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If ExistBlock("F010EFIM")
				ExecBlock( "F010EFIM", .F., .F., aClone(aPedido) )
			EndIf			
		
		EndIf
		
	EndIf

Return( lOk )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010Pedido³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna todos os pedidos conforme parametros.              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F010Pedido(cPerg)  

	Local cQuery		:= ""
	Local cAreaPv		:= GetNextAlias()
	Local cAreaIt		:= GetNextAlias()
	Local cMvStatus	:= ""
	Local aBrowPv		:= {}
	Local aBrowIt		:= {}
	Local nLin		:= 0

		
	Pergunte(cPerg, .F.)
	
	cQuery := " SELECT 	C5_NUM NUM,"		
	cQuery += "			C5_CLIENTE CLIENTE,"	
	cQuery += "			C5_LOJACLI LOJACLI,"
	cQuery += "			C5_EMISSAO EMISSAO,"		
	cQuery += "			C5_DTASEP DTASEP,"	
	cQuery += "			C5_HRASEP HRASEP,"	
	cQuery += "			C5_USRSEP USRSEP,"	
	cQuery += "			C5_PVSTAT PVSTAT,"	
	cQuery += "			C5_ORDSEP ORDSEP,"	
	cQuery += "			A1_NOME NOME,"
	cQuery += "			A1_MUN MUN,"
	cQuery += "			C5_PVVALE PVVALE,"
	cQuery += "			'FAT' ORIGEM,"
	cQuery += "			C5_NOTA NOTA,"
	cQuery += "			C5_SERIE SERIE,"

	aEval( aF010MvCpo, {|x| cQuery += x + ", "}, 1, 2 )
		
	cQuery += " 			ISNull( ( SELECT A1_NOME "
	cQuery += " 							FROM " + RetSQLName("SA1")
	cQuery += " 							WHERE 	A1_FILIAL 	= '" + xFilial("SA1") + "'"
	cQuery += " 								AND	A1_COD	 = SC5." + aF010MvCpo[1] 
	cQuery += " 								AND	A1_LOJA = SC5." + aF010MvCpo[2]
	cQuery += " 								AND	D_E_L_E_T_ <> '*' "
	cQuery += " 			), ' ' ) NOM_CLIENTREG, "
	
	cQuery += " 			ISNull( ( SELECT TOP 1 C9_DATALIB "
	cQuery += " 							FROM " + RetSQLName("SC9")
	cQuery += " 							WHERE 	C9_FILIAL 	= '" + xFilial("SC9") + "'"
	cQuery += " 								AND	C9_PEDIDO	= SC5.C5_NUM"
	cQuery += " 								AND	D_E_L_E_T_ <> '*' "
	cQuery += " 			), ' ' ) DATALIB"
	
	cQuery += " FROM		" + RetSQLName("SC5") +" SC5,"	
	cQuery += "			" + RetSQLName("SA1") +" SA1"
		
	cQuery += " WHERE		SC5.C5_FILIAL  = '" + xFilial("SC5") 	+ "'"		 
	
	If Empty(MV_PAR01)
		cQuery += "	AND	SC5.C5_PVSTAT  <> ' '" 		
   Else 
    	
   		cMvStatus := AllTrim( MV_PAR01 )
    	
    	If Right(cMvStatus,1) = "/" 
    		cMvStatus := SubStr( cMvStatus, 1, (Len(cMvStatus)-1) )
    	EndIf
    	
		cQuery += "	AND	SC5.C5_PVSTAT  IN " + FormatIn( cMvStatus, "/" )	 		
		
	EndIf
	
	If !Empty(MV_PAR06)
		cQuery += "  	AND	SC5." + aF010MvCpo[1] + " = '" + MV_PAR06 + "'"
		cQuery += "  	AND	SC5." + aF010MvCpo[2] + " = '" + MV_PAR07 + "'"
	EndIf

	cQuery += "   	AND	SC5.C5_TIPO	 = 'N'" //-- N = Normal  
	cQuery += "   	AND	SC5.C5_NUM     >= '" + MV_PAR02	 + "'" 		
	cQuery += "   	AND	SC5.C5_NUM     <= '" + MV_PAR03	 + "'" 		
	cQuery += "   	AND	SC5.C5_EMISSAO >= '" + DToS(MV_PAR04) + "'" 		
	cQuery += "   	AND	SC5.C5_EMISSAO <= '" + DToS(MV_PAR05) + "'" 		

	cQuery += " 		AND	SA1.A1_FILIAL = '" + xFilial("SA1") + "'"		 
	cQuery += " 		AND	SA1.A1_COD    = SC5.C5_CLIENTE"			
	cQuery += " 		AND	SA1.A1_LOJA   = SC5.C5_LOJACLI"			

	cQuery += "		AND	SA1.D_E_L_E_T_ <> '*'" 	  
	cQuery += "		AND	SC5.D_E_L_E_T_ <> '*'" 	  

	cQuery += " UNION ALL"
	
	cQuery += " SELECT 	L1_NUM NUM,"		
	cQuery += "			L1_CLIENTE CLIENTE,"	
	cQuery += "			L1_LOJA LOJACLI,"
	cQuery += "			L1_EMISSAO EMISSAO,"		
	cQuery += "			L1_DTASEP DTASEP,"	
	cQuery += "			L1_HRASEP HRASEP,"	
	cQuery += "			L1_USRSEP USRSEP,"	
	cQuery += "			L1_PVSTAT PVSTAT,"	
	cQuery += "			L1_ORDSEP ORDSEP,"	
	cQuery += "			A1_NOME NOME,"
	cQuery += "			A1_MUN MUN,"
	cQuery += "			' ' PVVALE,"
	cQuery += "			'LOJ' ORIGEM,"
	cQuery += "			L1_DOC NOTA,"
	cQuery += "			L1_SERIE SERIE,"
	cQuery += "			L1_CLIENTE " + aF010MvCpo[1] +"," 	
	cQuery += "			L1_LOJA "  + aF010MvCpo[2] +","
	cQuery += "			A1_NOME NOM_CLIENTREG,"
	cQuery += " 			' ' DATALIB"
			
	cQuery += " FROM		" + RetSQLName("SL1") +" SL1,"	
	cQuery += "			" + RetSQLName("SA1") +" SA1"
		
	cQuery += " WHERE		SL1.L1_FILIAL  = '" + xFilial("SL1") 	+ "'"		 
	
	If Empty(MV_PAR01)
		cQuery += "	AND	SL1.L1_PVSTAT  <> ' '" 		
   Else 
    	
   		cMvStatus := AllTrim( MV_PAR01 )
    	
    	If Right(cMvStatus,1) = "/" 
    		cMvStatus := SubStr( cMvStatus, 1, (Len(cMvStatus)-1) )
    	EndIf
    	
		cQuery += "	AND	SL1.L1_PVSTAT  IN " + FormatIn( cMvStatus, "/" )	 		
		
	EndIf
	
	cQuery += "   	AND	SL1.L1_NUM     >= '" + MV_PAR02	 + "'" 		
	cQuery += "   	AND	SL1.L1_NUM     <= '" + MV_PAR03	 + "'" 		
	cQuery += "   	AND	SL1.L1_EMISSAO >= '" + DToS(MV_PAR04) + "'" 		
	cQuery += "   	AND	SL1.L1_EMISSAO <= '" + DToS(MV_PAR05) + "'" 
	cQuery += "   	AND	SL1.L1_PVSTAT	<> ' '"		

	cQuery += " 		AND	SA1.A1_FILIAL = '" + xFilial("SA1") + "'"		 
	cQuery += " 		AND	SA1.A1_COD    = SL1.L1_CLIENTE"			
	cQuery += " 		AND	SA1.A1_LOJA   = SL1.L1_LOJA"			

	cQuery += "		AND	SA1.D_E_L_E_T_ <> '*'" 	  
	cQuery += "		AND	SL1.D_E_L_E_T_ <> '*'"
	
	cQuery += " ORDER BY ORIGEM, NUM " 	  

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAreaPv,.F.,.F.)
	
	TcSetField( cAreaPv, "EMISSAO", "D", 08, 00 )
	TcSetField( cAreaPv, "DTASEP",  "D", 08, 00 )
	TcSetField( cAreaPv, "DATALIB", "D", 08, 00 )
	
	(cAreaPv)->( dbGoTop() )
	
	While (cAreaPv)->( !Eof() )
	
		aBrowIt := {}

		If (cAreaPv)->ORIGEM = "FAT"
		
			cQuery := " SELECT 	C6_ITEM 	ITEM,"		
			cQuery += "			C6_PRODUTO	PRODUTO,"	
			cQuery += "			C6_NUM 	NUM,"	
			cQuery += "			C6_QTDVEN 	QTDVEN,"	
			cQuery += "			C6_QTDSEP 	QTDSEP,"	
			cQuery += "			C6_QTDCONF	QTDCONF,"	
			cQuery += "			C6_USRSEP 	USRSEP,"	
			cQuery += "			B1_DESC 	DESCRICAO,"	
			
			cQuery += " 			ISNull( ( SELECT SUM(C9_QTDLIB) QTDLIB "
			cQuery += " 							FROM " + RetSQLName("SC9")
			cQuery += " 							WHERE C9_FILIAL 	= '" + xFilial("SC9") + "'"
			cQuery += " 							 AND C9_PEDIDO	= SC6.C6_NUM"
			cQuery += " 							 AND C9_ITEM		= SC6.C6_ITEM"
			cQuery += " 							 AND C9_PRODUTO	= SC6.C6_PRODUTO"
			cQuery += " 							 AND D_E_L_E_T_ <> '*' "
			cQuery += " 			), 0 ) 	QTDLIB,"
		
			cQuery += " 			C6_BOXSEP 	BOXSEP,"
		
			cQuery += " 			ISNull( ( SELECT TOP 1 C9_LOCAL"
			cQuery += " 							FROM " + RetSQLName("SC9")
			cQuery += " 							WHERE C9_FILIAL 	= '" + xFilial("SC9") + "'"
			cQuery += " 							 AND C9_PEDIDO	= SC6.C6_NUM"
			cQuery += " 							 AND C9_ITEM		= SC6.C6_ITEM"
			cQuery += " 							 AND C9_PRODUTO	= SC6.C6_PRODUTO"
			cQuery += " 							 AND D_E_L_E_T_ <> '*' "
			cQuery += " 			), ' ' ) 	ARMAZEM"
		
			cQuery += " FROM " + RetSQLName("SC6") +" SC6"
				
			cQuery += " INNER JOIN	" + RetSQLName("SB1") +" SB1"  
			cQuery += " 		ON	B1_FILIAL	= '" + xFilial("SB1") +"'"
			cQuery += " 		AND	B1_COD 	= C6_PRODUTO"
									
			cQuery += " WHERE		SC6.C6_FILIAL	= '" + xFilial("SC6") + "'"		 
			cQuery += "   	AND	SC6.C6_NUM		= '" + (cAreaPv)->NUM + "'" 		
			cQuery += "		AND	SC6.D_E_L_E_T_ <> '*'"
			
			cQuery += " ORDER BY ITEM "
			
		Else

			cQuery := " SELECT 	L2_ITEM 	ITEM,"		
			cQuery += "			L2_PRODUTO	PRODUTO,"	
			cQuery += "			L2_NUM 	NUM,"	
			cQuery += "			L2_QUANT 	QTDVEN,"	
			cQuery += "			L2_QTDSEP 	QTDSEP,"	
			cQuery += "			L2_QTDCONF	QTDCONF,"	
			cQuery += "			L2_USRSEP 	USRSEP,"	
			cQuery += "			B1_DESC 	DESCRICAO,"	
			cQuery += " 			L2_QUANT 	QTDLIB,"
			cQuery += " 			L2_BOXSEP 	BOXSEP,"
			cQuery += " 			L2_LOCAL 	ARMAZEM"
		
			cQuery += " FROM " + RetSQLName("SL2") +" SL2"
				
			cQuery += " INNER JOIN	" + RetSQLName("SB1") +" SB1"  
			cQuery += " 		ON	B1_FILIAL	= '" + xFilial("SB1") +"'"
			cQuery += " 		AND	B1_COD 	= L2_PRODUTO"
									
			cQuery += " WHERE		SL2.L2_FILIAL	= '" + xFilial("SL2") + "'"		 
			cQuery += "   	AND	SL2.L2_NUM		= '" + (cAreaPv)->NUM + "'"
			cQuery += "		AND	SL2.D_E_L_E_T_ <> '*'"
			
			cQuery += " ORDER BY ITEM " 	  		
		
		EndIf
		
		cQuery := ChangeQuery(cQuery)
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAreaIt,.F.,.T.)
	
		TcSetField( cAreaIt, "QTDLIB", "N", 14, 02 )
		TcSetField( cAreaIt, "QTDSEP", "N", 14, 02 )
		TcSetField( cAreaIt, "QTDCONF", "N", 14, 02 )
		
		(cAreaIt)->( dbGoTop() )
		
		While (cAreaIt)->( !Eof() )	
	
			aAdd(aBrowIt, Array(IT_QTDCOL) )
			
			nLin := Len(aBrowIt)
			
			aBrowIt[nLin][IT_C6_ITEM] 		:= (cAreaIt)->ITEM
			aBrowIt[nLin][IT_C6_PRODUTO] 	:= (cAreaIt)->PRODUTO
			aBrowIt[nLin][IT_B1_DESC] 		:= (cAreaIt)->DESCRICAO
			aBrowIt[nLin][IT_C9_LOCAL] 		:= (cAreaIt)->ARMAZEM
			aBrowIt[nLin][IT_C6_BOXSEP] 	:= (cAreaIt)->BOXSEP
			aBrowIt[nLin][IT_C6_USRSEP] 	:= (cAreaIt)->USRSEP
			aBrowIt[nLin][IT_C6_QTDVEN] 	:= (cAreaIt)->QTDVEN
			aBrowIt[nLin][IT_C9_QTDLIB] 	:= (cAreaIt)->QTDLIB
			aBrowIt[nLin][IT_C6_QTDSEP] 	:= (cAreaIt)->QTDSEP
			aBrowIt[nLin][IT_C6_QTDCONF] 	:= (cAreaIt)->QTDCONF
			aBrowIt[nLin][IT_VAZIO] 			:= ""
		
			dbSelectArea(cAreaIt)
			dbSkip()
			
		EndDo
	
		(cAreaIt)->( dbCloseArea() )
	
		If Len(aBrowIt) = 0
	
			aAdd(aBrowIt, Array(IT_QTDCOL) )
			
			nLin := Len(aBrowIt)
	
			aBrowIt[nLin][IT_C6_ITEM] 		:= ""
			aBrowIt[nLin][IT_C6_PRODUTO] 	:= ""
			aBrowIt[nLin][IT_B1_DESC] 		:= ""
			aBrowIt[nLin][IT_C9_LOCAL] 		:= ""
			aBrowIt[nLin][IT_C6_BOXSEP] 	:= ""
			aBrowIt[nLin][IT_C6_USRSEP] 	:= ""
			aBrowIt[nLin][IT_C6_QTDVEN] 	:= 0
			aBrowIt[nLin][IT_C9_QTDLIB] 	:= 0
			aBrowIt[nLin][IT_C6_QTDSEP] 	:= 0
			aBrowIt[nLin][IT_C6_QTDCONF] 	:= 0
			aBrowIt[nLin][IT_VAZIO] 			:= ""
			
		EndIf
		
		aAdd( aBrowPv, Array(PV_QTDCOL) )
		
		nLin := Len(aBrowPv)
		
		aBrowPv[nLin][PV_CHECK]			:= .F.
		aBrowPv[nLin][PV_C5_PVSTAT]		:= (cAreaPv)->PVSTAT
		aBrowPv[nLin][PV_C5_ORDSEP]		:= (cAreaPv)->ORDSEP
		aBrowPv[nLin][PV_C5_NUM] 		:= (cAreaPv)->NUM
		aBrowPv[nLin][PV_C5_CLIENTE] 	:= (cAreaPv)->CLIENTE
		aBrowPv[nLin][PV_C5_LOJACLI] 	:= (cAreaPv)->LOJACLI
		aBrowPv[nLin][PV_A1_NOME] 		:= (cAreaPv)->NOME
		aBrowPv[nLin][PV_A1_MUN] 		:= (cAreaPv)->MUN
		aBrowPv[nLin][PV_C5_EMISSAO] 	:= (cAreaPv)->EMISSAO
		aBrowPv[nLin][PV_C9_DATALIB] 	:= (cAreaPv)->DATALIB
		aBrowPv[nLin][PV_C5_DTASEP] 	:= (cAreaPv)->DTASEP
		aBrowPv[nLin][PV_C5_HRASEP] 	:= (cAreaPv)->HRASEP
		aBrowPv[nLin][PV_C5_USRSEP] 	:= (cAreaPv)->USRSEP
		aBrowPv[nLin][PV_CLIENTREG] 	:= IIf( Empty( (cAreaPv)->&(aF010MvCpo[1]) ), (cAreaPv)->CLIENTE, (cAreaPv)->&(aF010MvCpo[1]) )
		aBrowPv[nLin][PV_LOJENTREG] 	:= IIf( Empty( (cAreaPv)->&(aF010MvCpo[2]) ), (cAreaPv)->LOJACLI, (cAreaPv)->&(aF010MvCpo[2]) )
		aBrowPv[nLin][PV_NOMENTREG] 	:= (cAreaPv)->NOM_CLIENTREG
		aBrowPv[nLin][PV_PVVALE]			:= (cAreaPv)->PVVALE
		aBrowPv[nLin][PV_ORIGEM]	 		:= (cAreaPv)->ORIGEM
		aBrowPv[nLin][PV_ITENS]	 		:= aBrowIt
		aBrowPv[nLin][PV_NOTA]	 		:= (cAreaPv)->NOTA
		aBrowPv[nLin][PV_SERIE]	 		:= (cAreaPv)->SERIE

		dbSelectArea(cAreaPv)
		dbSkip()
		
	EndDo
	
	(cAreaPv)->( dbCloseArea() )
	
	If Len(aBrowPv) = 0
	
		aAdd(aBrowIt, Array(IT_QTDCOL) )
			
		nLin := Len(aBrowIt)
	
		aBrowIt[nLin][IT_C6_ITEM] 		:= ""
		aBrowIt[nLin][IT_C6_PRODUTO] 	:= ""
		aBrowIt[nLin][IT_B1_DESC] 		:= ""
		aBrowIt[nLin][IT_C9_LOCAL] 		:= ""
		aBrowIt[nLin][IT_C6_BOXSEP] 	:= ""
		aBrowIt[nLin][IT_C6_USRSEP] 	:= ""
		aBrowIt[nLin][IT_C6_QTDVEN] 	:= 0
		aBrowIt[nLin][IT_C9_QTDLIB] 	:= 0
		aBrowIt[nLin][IT_C6_QTDSEP] 	:= 0
		aBrowIt[nLin][IT_C6_QTDCONF] 	:= 0
		aBrowIt[nLin][IT_VAZIO] 			:= ""
	
		aAdd( aBrowPv, Array(PV_QTDCOL) )
		
		nLin := Len(aBrowPv)
		
		aBrowPv[nLin][PV_CHECK]			:= .F.
		aBrowPv[nLin][PV_C5_PVSTAT]		:= "999"
		aBrowPv[nLin][PV_C5_ORDSEP]		:= ""
		aBrowPv[nLin][PV_C5_NUM] 		:= ""
		aBrowPv[nLin][PV_C5_CLIENTE] 	:= ""
		aBrowPv[nLin][PV_C5_LOJACLI] 	:= ""
		aBrowPv[nLin][PV_A1_NOME] 		:= ""
		aBrowPv[nLin][PV_A1_MUN] 		:= ""
		aBrowPv[nLin][PV_C5_EMISSAO] 	:= CToD("//")
		aBrowPv[nLin][PV_C9_DATALIB] 	:= CToD("//")
		aBrowPv[nLin][PV_C5_DTASEP] 	:= CToD("//")
		aBrowPv[nLin][PV_C5_HRASEP] 	:= ""
		aBrowPv[nLin][PV_C5_USRSEP] 	:= ""
		aBrowPv[nLin][PV_CLIENTREG] 	:= ""
		aBrowPv[nLin][PV_LOJENTREG] 	:= ""
		aBrowPv[nLin][PV_NOMENTREG] 	:= ""
		aBrowPv[nLin][PV_PVVALE]			:= "N"
		aBrowPv[nLin][PV_ORIGEM]	 		:= ""
		aBrowPv[nLin][PV_ITENS]	 		:= aBrowIt

	EndIf

Return(aBrowPv)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010OrdBro³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alterar ordem de exibicao TWBrowse.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F010OrdBro(aBrowPv, lAuto)

	Local aRet		:= {}
	Local aPergs		:= {}
	Local aOpcoes		:= {}
	Local lConfirm	:= .T.
	
	
	aAdd( aOpcoes, "1 - Número Pedido" )
	aAdd( aOpcoes, "2 - Ordem + Número Pedido" )
	aAdd( aOpcoes, "3 - Cliente + Número Pedido" )
	aAdd( aOpcoes, "4 - Município + Cliente + Número Pedido" )
	aAdd( aOpcoes, "5 - Data Emissão + Número Pedido" )
	aAdd( aOpcoes, "6 - Data Liberação + Número Pedido" )
	aAdd( aOpcoes, "7 - Cliente Entrega + Cliente + Número Pedido" )

	aAdd( aPergs,{3, "Ordem Apresentação", nF010Ord, aOpcoes, 150, "", .F.} )
	
	If !lAuto
	
		If ParamBox(aPergs, "Ordem", @aRet,,,.T.,,,,,.F.)
			nF010Ord	:= aRet[1]
		Else
			lConfirm := .F.
		EndIf
		
	EndIf
	
	If lConfirm
	
		If nF010Ord = 1
			aBrowPv := ASort(aBrowPv,,,{|x, y| x[PV_ORIGEM]+x[PV_C5_NUM] < y[PV_ORIGEM]+y[PV_C5_NUM] })
		ElseIf nF010Ord = 2  	
			aBrowPv := ASort(aBrowPv,,,{|x, y| x[PV_ORIGEM]+x[PV_C5_ORDSEP]+x[PV_C5_NUM] < y[PV_ORIGEM]+y[PV_C5_ORDSEP]+y[PV_C5_NUM] })
		ElseIf nF010Ord = 3  	
			aBrowPv := ASort(aBrowPv,,,{|x, y| x[PV_ORIGEM]+x[PV_C5_CLIENTE]+x[PV_C5_LOJACLI]+x[PV_C5_NUM] < y[PV_ORIGEM]+y[PV_C5_CLIENTE]+y[PV_C5_LOJACLI]+y[PV_C5_NUM] })
		ElseIf nF010Ord = 4  	
			aBrowPv := ASort(aBrowPv,,,{|x, y| x[PV_ORIGEM]+x[PV_A1_MUN]+x[PV_C5_CLIENTE]+x[PV_C5_LOJACLI]+x[PV_C5_NUM] < y[PV_ORIGEM]+y[PV_A1_MUN]+y[PV_C5_CLIENTE]+y[PV_C5_LOJACLI]+y[PV_C5_NUM] })
		ElseIf nF010Ord = 5  	
			aBrowPv := ASort(aBrowPv,,,{|x, y| x[PV_ORIGEM]+DToS(x[PV_C5_EMISSAO])+x[PV_C5_NUM] < y[PV_ORIGEM]+DToS(y[PV_C5_EMISSAO])+y[PV_C5_NUM] })
		ElseIf nF010Ord = 6  	
			aBrowPv := ASort(aBrowPv,,,{|x, y| x[PV_ORIGEM]+DToS(x[PV_C9_DATALIB])+x[PV_C5_NUM] < y[PV_ORIGEM]+DToS(y[PV_C9_DATALIB])+y[PV_C5_NUM] })
		ElseIf nF010Ord = 7  	
			aBrowPv := ASort(aBrowPv,,,{|x, y| x[PV_ORIGEM]+x[PV_CLIENTREG]+x[PV_LOJENTREG]+x[PV_C5_CLIENTE]+x[PV_C5_LOJACLI]+x[PV_C5_NUM] < y[PV_ORIGEM]+y[PV_CLIENTREG]+y[PV_LOJENTREG]+y[PV_C5_CLIENTE]+y[PV_C5_LOJACLI]+y[PV_C5_NUM] } )
		EndIf
		
	EndIf

Return(aBrowPv)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010VisuPv³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Visualizar o pedido.                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F010VisuPv(cPedido, cOrigem)


	If cOrigem = "FAT"

		aRotina := { 	{ OemToAnsi("Pesquisar"),"AxPesqui" ,0,1},;
						{ OemToAnsi("Visualizar"),"A410Visual",0,2},;	
						{ OemToAnsi("Incluir"),"A410Copia",0,3}}
	
		dbSelectArea("SC5")
		dbSetOrder(1)
		
		dbSeek( xFilial("SC5") + cPedido )
		
		A410Visual( "SC5", SC5->(Recno()), 2 )
	
	Else
	
		lAutoExec := .F.
	
		aRotina:= {	{ OemToAnsi("Pesquisar"), "AxPesqui" 	, 0 , 1 , , .F. },;	
						{ OemToAnsi("Visualizar"), "LJ7Venda" 	, 0 , 2 , , .T. } }
	
		dbSelectArea("SL1")
		dbSetOrder(1)
		
		dbSeek( xFilial("SL1") + cPedido )
	
		Lj7Venda("SL1", SL1->(Recno()), 2)
	
	EndIf
	
Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010Legend³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Legenda do Status pedido.                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F010Legend()

	Local aLegenda	:= {}
	Local cDescric	:= "Status Pedido"
	Local nZ			:= 0		 

	
	For nZ := 1 To Len(PV_STATUS)
		aAdd(aLegenda, {PV_STATUS[nZ,3], PV_STATUS[nZ,1] +" - "+ PV_STATUS[nZ,2]} )
	Next nZ
	
	BrwLegenda(cF010Cad, cDescric, aLegenda)
		
Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010TimerB³ Autor ³ Jeferson Dambros      ³ Data ³ Dez/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Definir o tempo de atualizacao do browse.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F010TimerB(nTimer)

	Local aRet	:= {}
	Local aPergs	:= {}
	Local cTimer	:= ""
		

	nTimer := ( nTimer / 1000 )
	
	cTimer := PadR( nTimer, 3 )
	
	aAdd( aPergs,{1, "Tempo / Segundos", cTimer, "@R 999", "( Val(MV_PAR01) >= 0 )", "", ".T.", 0, .F.} )
	
	If ParamBox(aPergs, "Atualizar Browse em:", @aRet,,,.T.,,,,,.F.)
	
		nTimer := Val( aRet[1] )
				
	EndIf
	
Return( ( nTimer  * 1000 ) )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010CriaSx³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Criar o grupo de perguntas.                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F010CriaSx(cPerg)

	Local aP		:= {}
	Local aHelp	:= {}
	Local nI		:= 0
	Local cSeq	:= ""
	Local cMvCh	:= ""
	Local cMvPar	:= ""
	Local nCpoPv	:= Max( TamSX3("C5_NUM")[1], TamSX3("L1_NUM")[1] )


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
	aAdd(aP,{	"Status ?",   				"C",	60,								0,		"G",					"",	 "",	   	"",			 "",		"",		"",		"" })
	aAdd(aP,{	"Pedido De ?",				"C",	nCpoPv,						0,		"G",					"",	 "",		"",			 "",		"",		"",		"" })
	aAdd(aP,{	"Pedido Ate ?",				"C",	nCpoPv,						0,		"G",					"",	 "",		"",			 "",		"",		"",		"" })
	aAdd(aP,{	"Emissao De ?",				"D",	08,								0,		"G",					"",	 "",	   	"",			 "",		"",		"",		"" })
	aAdd(aP,{	"Emissao Ate ?",				"D",	08,								0,		"G",					"",	 "",	   	"",			 "",		"",		"",		"" })
	aAdd(aP,{	"Cliente Entrega ?",			"C",	TamSX3(aF010MvCpo[1])[1],	0,		"G",					"",	 "SA1",	"",			 "",		"",		"",		"" })
	aAdd(aP,{	"Loja Entrega ?",				"C",	TamSX3(aF010MvCpo[2])[1],	0,		"G",					"",	 "",		"",			 "",		"",		"",		"" })
	

    //          012345678912345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    //                   1         2         3         4         5         6         7         8         9        10        11        12
	aAdd(aHelp,{"Status do pedido.", "Para exibir todos. O parametro precisa", "estar em branco","Utilize a barra '/' para separar os", "status. Ex.: 010/020 ou 010"})
	aAdd(aHelp,{"Número do pedido inicial."})
	aAdd(aHelp,{"Número do pedido final."})
	aAdd(aHelp,{"Data de emissão inicial."})
	aAdd(aHelp,{"Data de emissão final."})
	aAdd(aHelp,{"Código cliente de entrega"})
	aAdd(aHelp,{"Loja cliente de entrega"})


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


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010OrdSep³ Autor ³ Jeferson Dambros      ³ Data ³ Mar/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a ultima ordem utilizada.                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function F010OrdSep()

	Local cQuery		:= ""
	Local cOrdSep		:= ""
	Local cArea		:= GetNextAlias()
	Local nTamOrdem	:= TamSX3("C5_ORDSEP")[1]


	cQuery := " SELECT 	ISNULL( MAX(C5_ORDSEP), '"+ Replicate("0", nTamOrdem) + "' ) ORDSEP" 
	cQuery += " FROM	" + RetSQLName("SC5")
	cQuery += " WHERE	 	C5_FILIAL	= '" + xFilial("SC5") + "'"		
	cQuery += "	AND 	D_E_L_E_T_ <> '*'" 	  

	cQuery += " UNION ALL"
	
	cQuery += " SELECT 	ISNULL( MAX(L1_ORDSEP), '"+ Replicate("0", nTamOrdem) + "' ) ORDSEP" 
	cQuery += " FROM	" + RetSQLName("SL1")
	cQuery += " WHERE	 	L1_FILIAL	= '" + xFilial("SL1") + "'"		
	cQuery += "	AND 	D_E_L_E_T_ <> '*'" 	  
	 	  
	cQuery := ChangeQuery(cQuery)
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArea,.F.,.T.)
	
	(cArea)->( dbGoTop() )
	
	cOrdSep := (cArea)->ORDSEP
		
	While (cArea)->( !Eof() )
		
		If (cArea)->ORDSEP > cOrdSep 
		
			cOrdSep := (cArea)->ORDSEP
		
		EndIf
		
		(cArea)->( dbSkip() )
		
	EndDo

	(cArea)->( dbCloseArea() )

Return(cOrdSep)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F010Transp³ Autor ³Giovanni Melo          ³ Data ³ Abr/2015 ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Visualiza as informacoes da transportadora do PV selecionado³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³F010Transp(ExpC1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Numero do Pedido de Venda                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F010Transp( cPedido )

	Local aArea		:= GetArea()
	Local aAreaSC5	:= SC5->( GetArea() )
	

	dbSelectArea("SC5")
	dbSetOrder(1)
	
	If	dbSeek( xFilial("SC5") + cPedido )
	
		If !(SC5->C5_PVSTAT $ FATURADO + '|' + ENVIADO_SEPARACAO + "|" + EM_SEPARACAO )

			U_TRSF005B( "SC5", SC5->(Recno()), 2 )
		
		Else
					
			Aviso(	cF010Cad,;
					"Impossível alterar, informações da transportadora!" + CRLF +;
					"Verifique o Status." + CRLF +;  
				   "Por favor, selecione outro pedido.",;
				   {"Ok"},;
				   2 )	
		EndIf
	
	EndIf

	RestArea( aArea )
	RestArea( aAreaSC5 )

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   R()   ³ Autores ³ Jeferson Dambros       ³ Data ³ Dez/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal e vertical do Monitor do Usuario.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function R(nTam)

	Local aRes		:= {0,0}
	Local nLargura	:= aMonitor[1] 
	Local nAltura		:= aMonitor[2] 
	
	
	/*
	Largura X Altura 
	1280 	 X 1024		1		1			
	1156 	 X 864    		0.8		0.8
	1024 	 X 764			0.7		0.6
	800 	 X 600			0.6		0.4
	600 	 X 500			0.5		0.2
	500		 X 400			0.3		0.1	     
	*/

	If nAltura >= 1000
	
		aRes[1] := nTam
	
	ElseIf nAltura >= 800 .And. nAltura <= 999 
	
		aRes[1] := Int(nTam * 0.8)
	
	ElseIf nAltura >= 700 .And. nAltura <= 799
	
		aRes[1] := Int(nTam * 0.6)
		
	ElseIf nAltura >= 600 .And. nAltura <= 699
	
		aRes[1] := Int(nTam * 0.4)
		
	ElseIf nAltura <= 599
	
		aRes[1] := Int(nTam * 0.2)
	
	EndIf
	
	If nLargura >= 1200
	
		aRes[2] := nTam
	
	ElseIf nLargura >= 1100 .And. nLargura <= 1199 
	
		aRes[2] := Int(nTam * 0.8)
		
	ElseIf nLargura >= 1000 .And. nLargura <= 1099
	
		aRes[2] := Int(nTam * 0.7)

	ElseIf nLargura >= 800 .And. nLargura <= 999
	
		aRes[2] := Int(nTam * 0.6)
	
	ElseIf nLargura >= 600 .And. nLargura <= 799
	
		aRes[2] := Int(nTam * 0.5)
		
	ElseIf nLargura <= 599
	
		aRes[2] := Int(nTam * 0.3)
					 
	EndIf 
				
Return( aRes )