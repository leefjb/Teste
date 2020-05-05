#Include "Protheus.ch"
#Include "Trsf010.ch"    

/* Colunas TWBrowse */
#Define NPCHECK			01
#Define NPC5_NUM		02
#Define NPC5_EMISSAO	03
#Define NPC5_CLIENTE	04
#Define NPC5_LOJACLI	05
#Define NPA1_NOME		06
#Define NPF2_DOC		07
#Define NPF2_SERIE		08
#Define NPC6_BOXSEP		09
#Define NPCLIENTREG		10
#Define NPLOJENTREG		11
#Define NPNOMENTREG		12
#Define NPC5_PVVALE		13
#Define NPORIGEM		14
#Define NPC5_ORDSEP		15
#Define NP_VAZIO		16              


/* Qtde de colunas TWBrowse */
#Define NCOL_QUANT		16

/*/{Protheus.doc} JomACD08
//Conferencia separacao pedido de venda - Refatorado o fonte: TRSF030()
@author Celso Rene
@since 22/11/2018
@version 1.0
@type function
/*/
User Function JomACD08()


	Local oDlgDoc
	Local oBroDoc
	Local oOk			:= LoadBitmap(GetResources(),"CHECKED")
	Local oNo			:= LoadBitmap(GetResources(),"UNCHECKED")

	Local cStatus	:= ""
	Local cMvFluxo	:= "2" ///////AllTrim( SuperGetMV( "TRS_MON001", .F., "" ) )
	Local cPerg		:= PadR("TRSF030",Len(SX1->X1_GRUPO))
	Local cTipoEtiq	:= SuperGetMV( "TRS_MON011", .F., "1" ) //Tipo de etiqueta 1 ou 2

	Local aSize		:= {}
	Local aObj		:= {}
	Local aInfo		:= {}
	Local aPObj		:= {}
	Local aBrowse	:= {}
	Local aCabec	:= {}
	Local aButtons	:= {}

	Local lConferido:= .F.

	Local nZ		:= 0
	Local nPosMarq	:= 0
	Local nScan		:= 0

	Local bLinha	:= {||}
	Local bBtoOrdem	:= {||}
	Local bBtoEncCa	:= {||}
	Local bBtoEncOk	:= {||}
	Local bBtoAtual	:= {||}
	Local bAtuaBrow	:= {||}
	Local bBtoParam	:= {||}
	Local bSelMuito, bSelUnico, bStatus

	Private cF030Cad	:= "Conferencia pedido (Browse) - Separação ACD "
	Private nF030Ord	:= 1	// Ordem de exibicao do Browse

	// Campos utilizados no cliente / loja de entrega
	Private aF030MvCpo := Eval( {||	aF030MvCpo := StrToKArr( Upper( SuperGetMv( "TRS_MON006", .F., "C5_CLIENT|C5_LOJAENT", ) ), "|" ),;
	IIf(Len(aF030MvCpo) = 0, {"C5_CLIENT", "C5_LOJAENT"}, aF030MvCpo ) } )


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

	// Cristiano Oliveira - Descontinuar AUTORIZACAO DE USO DA ROTINA - Migração P12 - 24/08/2017	
	//	If u_TRSF011()// Validar a existencia dos campos + autorizacao de uso da rotina

	If !SX1->( dbSeek(cPerg) )
		F030CriaSx(cPerg)
	EndIf

	Pergunte(cPerg, .F.)

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
	aAdd( aCabec, "Nota Fiscal")
	aAdd( aCabec, "Serie" )
	aAdd( aCabec, "Caixa" )
	aAdd( aCabec, "Ent. Cliente" )
	aAdd( aCabec, "Ent. Loja" )
	aAdd( aCabec, "Ent. Nome" )
	aAdd( aCabec, "Ent." )
	aAdd( aCabec, "Origem" )
	aAdd( aCabec, "" )

	oDlgDoc := MSDialog():New( aSize[7], aSize[1], aSize[6], aSize[5], cF030Cad,,,,,,,,,.T.,,, )

	// Verificar o status atual do pedido de venda / orcamento
	bStatus := {|a,b,c| IIf(  a = "FAT",;
	(;
	SC5->( dbSeek( xFilial("SC5") + b ) ),;
	cStatus := SC5->C5_PVSTAT,;
	lConferido := ( SC5->C5_PVSTAT $ IIf( c = "1", FATURADO, ENVIADO_CONFERENCIA+SEPARADO ) ),;
	),;
	(;
	SL1->( dbSeek( xFilial("SL1") + b ) ),;
	cStatus := SL1->L1_PVSTAT,;
	lConferido := ( SL1->L1_PVSTAT $ SEPARADO+ENVIADO_CONFERENCIA+CONFERIDO+FATURADO ),;
	);
	),;
	IIf( !lConferido,;
	(; 
	Aviso(	cF030Cad,; 
	"Status atual do pedido:" + CRLF +;
	cStatus +" - "+ PV_STATUS[aScan(PV_STATUS,{|x| x[1] = cStatus})][2] + CRLF +;
	"Pedido não pode ser conferido!",;
	{"Ok"} ),;
	Eval(bBtoAtual),;
	),;
	Nil),;
	lConferido;	
	}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TWBrowse                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	bAtuaBrow := {|| 	aBrowse := F030OrdBro( F030Produt(cMvFluxo), .T.),;
	oBroDoc:SetArray( aBrowse ),; 
	oBroDoc:bLine := bLinha,;
	oBroDoc:GoTop(),;
	oBroDoc:nAt := 1,;
	oBroDoc:Refresh();
	}

	oBroDoc := TWBrowse():New( 	aPObj[1,1],; 
	aPObj[1,2],;
	aPObj[1,4],;
	(aPObj[1,3]-aPObj[1,1]),;
	,;
	aCabec,;
	,;
	oDlgDoc,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

	MsAguarde( {|| oBroDoc:SetArray( aBrowse := F030OrdBro( F030Produt(cMvFluxo), .T.) ) }, "Aguarde!", "Listando...", .F. )

	bLinha := {|| {	IIf(aBrowse[oBroDoc:nAt,NPCHECK],oOK,oNO),;
	aBrowse[oBroDoc:nAt,NPC5_NUM],;                      
	aBrowse[oBroDoc:nAt,NPC5_EMISSAO],;
	aBrowse[oBroDoc:nAt,NPC5_CLIENTE],;
	aBrowse[oBroDoc:nAt,NPC5_LOJACLI],;
	aBrowse[oBroDoc:nAt,NPA1_NOME],;
	aBrowse[oBroDoc:nAt,NPF2_DOC],;
	aBrowse[oBroDoc:nAt,NPF2_SERIE],;
	aBrowse[oBroDoc:nAt,NPC6_BOXSEP],;
	aBrowse[oBroDoc:nAt,NPCLIENTREG],;
	aBrowse[oBroDoc:nAt,NPLOJENTREG],;
	aBrowse[oBroDoc:nAt,NPNOMENTREG],;
	aBrowse[oBroDoc:nAt,NPC5_PVVALE],;
	aBrowse[oBroDoc:nAt,NPORIGEM],;
	aBrowse[oBroDoc:nAt,NP_VAZIO];
	}}

	oBroDoc:bLine := bLinha 

	oBroDoc:aColSizes := {10, 30, 35, 35, 20, 100, 40, 25, 25, 35, 25, 100, 15, 15, 5}

	// Selecionar pedido
	// Todos os pedidos do mesmo cliente de entrega
	bSelMuito := {|| aEval(aBrowse, {|x| IIf(	x[NPCLIENTREG] = aBrowse[oBroDoc:nAt,NPCLIENTREG] .And.;
	x[NPLOJENTREG] = aBrowse[oBroDoc:nAt,NPLOJENTREG] .And.;
	x[NPC5_ORDSEP] = aBrowse[oBroDoc:nAt,NPC5_ORDSEP] .And.;
	x[NPC5_PVVALE] = "S",;
	x[NPCHECK] := !x[NPCHECK],;//.T.
	x[NPCHECK] := .F. ) } );//.F.
	}

	// Apenas o item posicionado 
	bSelUnico := {|| nScan := 0, aEval( aBrowse, {|x| nScan++, IIf( nScan = oBroDoc:nAt, x[NPCHECK] := !x[NPCHECK], nil ) } ) }

	//          FUNCIONANDO APENAS PARA A MARCACAO - CRISTIANO OLIVEIRA - 20161214
	//			bSelUnico := {|| nScan := 0, aEval( aBrowse, {|x| nScan++, IIf( nScan != oBroDoc:nAt .AND. x[NPCHECK] != .T., x[NPCHECK] := .F., x[NPCHECK] := .T. ) } ) } // !x[NPCHECK]

	oBroDoc:bLDblClick := {|| IIf( !Empty( aBrowse[oBroDoc:nAt,NPC5_NUM] ),;
	IIf( Eval(bStatus, aBrowse[oBroDoc:nAt,NPORIGEM], aBrowse[oBroDoc:nAt,NPC5_NUM], cMvFluxo),;
	IIf( 	aBrowse[oBroDoc:nAt,NPC5_PVVALE] = "S",; 
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

	bBtoEncOk := {|| 	IIf( !Empty( aBrowse[oBroDoc:nAt,NPC5_NUM] ) .And. ( nPosMarq := aScan( aBrowse, { |x| x[NPCHECK] = .T. } ) ) > 0 ,;
	IIf( Eval(bStatus, aBrowse[oBroDoc:nAt,NPORIGEM], aBrowse[oBroDoc:nAt,NPC5_NUM], cMvFluxo),;
	(;
	Processa( {|| lConferido := F030Confer(aBrowse, cMvFluxo, MV_PAR01) }, "Aguarde!", "Listando...", .F.),;
	IIf( 	lConferido ,;
	Eval(bAtuaBrow),;
	Nil);
	),;
	Nil),;	
	Aviso(cF030Cad,"Nenhum pedido selecionado!",{"Ok"} ) );
	}

	bBtoOrdem := { || IIf( !Empty( aBrowse[oBroDoc:nAt,NPC5_NUM] ),;
	(	aBrowse := F030OrdBro(aBrowse, .F.),;
	oBroDoc:SetArray( aBrowse ),; 
	oBroDoc:bLine := bLinha,;
	oBroDoc:GoTop(),;
	oBroDoc:nAt := 1,;
	oBroDoc:Refresh()),; // .T.
	Nil);						// .F.
	}

	bBtoAtual := { || ;
	MsAguarde( {|| 	aBrowse := {},;
	oBroDoc:SetArray( aBrowse := F030OrdBro( F030Produt(cMvFluxo), .T.) ),;
	oBroDoc:bLine := bLinha,;
	oBroDoc:Refresh();
	}, "Aguarde!", "Atualizando...", .F. );
	}

	bBtoParam := { || Pergunte(cPerg, .T.) }

	aAdd( aButtons, { "EDITABLE", bBtoOrdem,  "|F2| Ordem de exibição" } )
	If cTipoEtiq = "1"			
		aAdd( aButtons, { "EDITABLE", bBtoParam,  "|F4| Parametros" } )
	EndIf
	aAdd( aButtons, { "EDITABLE", bBtoAtual,  "|F5| Atualizar" } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SetKey                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			

	SetKey( VK_F2, bBtoOrdem )
	If cTipoEtiq = "1"
		SetKey( VK_F4, bBtoParam )
	EndIf
	SetKey( VK_F5, bBtoAtual )

	oDlgDoc:Activate( {||.T.},,,.T.,,,EnchoiceBar( oDlgDoc, bBtoEncOk, bBtoEncCa,, aButtons ) )

	SetKey( VK_F2,  )
	If cTipoEtiq = "1"
		SetKey( VK_F4,  )
	EndIf
	SetKey( VK_F5,  )

	//	EndIf// u_TRSF011()

Return


/*/{Protheus.doc} F030Confer
//Processa tela
@author solutio02
@since 30/11/2018
@version 1.0
@type function
/*/
Static Function F030Confer(aBrowse, cMvFluxo, nDigQtd)

	Local lConferido	:= .F.
	Local nDocDe		:= 0
	Local nDocAte		:= 0
	Local aConferir	:= {}
	Local cStatus		:= {}


	//-- Somente selecionados
	aEval( aBrowse, {|x| IIf( x[NPCHECK],;
	(;
	F030PvStat(x[NPC5_NUM], EM_CONFERENCIA, x[NPORIGEM], .F.),;
	nDocAte++,;
	aAdd( aConferir, {x[NPC5_NUM], x[NPC5_CLIENTE], x[NPC5_LOJACLI], x[NPORIGEM], x[NPC5_PVVALE], x[NPF2_DOC], x[NPF2_SERIE]});
	),;
	Nil);
	} )

	ProcRegua( nDocAte )

	For nDocDe := 1 To nDocAte

		IncProc( "Processando " + StrZero(nDocDe,3) +" de " + StrZero(nDocAte,3) )

		lConferido := u_JomACD09(	aConferir[nDocDe,1],;	// 1 Pedido
		aConferir[nDocDe,2],;	// 2 Cliente
		aConferir[nDocDe,3],;	// 3 Loja
		aConferir[nDocDe,4],;	// 4 Origem
		aConferir[nDocDe,5],;	// 5 Cliente Entrega ( S=Sim ou N=Nao ) 
		aConferir[nDocDe,6],;	// 6 Nota Fiscal 
		aConferir[nDocDe,7],;	// 7 Serie 
		nDocDe,;				// 8 Numero inicial de documento do grupo
		nDocAte,; 				// 9 Numero final de documento do grupo
		cMvFluxo,;				// 10 Fluzo operacional
		nDigQtd)				// 11 Digitar quantidade 1 = Nao 2 = Sim

		If !lConferido
			Exit
		EndIf 

	Next nDocDe

	//-- Se cancelar a conferencia, limpo os campos especificos
	If !lConferido

		ProcRegua( nDocAte )

		For nDocDe := 1 To nDocAte

			IncProc( "Apagando conferencia... " + aConferir[nDocDe,1] )

			If aConferir[nDocDe,4] = "FAT"
				If cMvFluxo = "1"
					cStatus := FATURADO
				Else
					cStatus := ENVIADO_CONFERENCIA
				EndIf
			Else
				cStatus := ENVIADO_CONFERENCIA
			EndIf

			F030PvStat(aConferir[nDocDe,1], cStatus, aConferir[nDocDe,4], .T.)		

		Next nDocDe	

	EndIf

Return(lConferido)


/*/{Protheus.doc} F030PvStat
//Altera status do pedido de venda ou orcamento. 
@author Celso Rene
@since 30/11/2018
@version 1.0
@type function
/*/
Static Function F030PvStat(cPedido, cStatus, cOrigem, lRetornar)


	If cOrigem = "FAT"

		dbSelectArea("SC5")
		dbSetOrder(1)

		dbSeek( xFilial("SC5") + cPedido )

		RecLock("SC5", .F.)

		SC5->C5_PVSTAT := cStatus

		If lRetornar
			SC5->C5_USRCON := ""
		EndIf

		MsUnLock()

		If lRetornar

			dbSelectArea("SC6")
			dbSetOrder(1)

			dbSeek( xFilial("SC6") + cPedido ) 

			While SC6->(!Eof()) .And. SC6->C6_NUM = cPedido

				RecLock("SC6", .F.)
				SC6->C6_QTDCONF := 0 	
				MsUnLock()

				dbSelectArea("SC6")
				dbSkip()

			EndDo

		EndIf

	ElseIf cOrigem = "LOJ"

		//Sempre verifico o status atual
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


/*/{Protheus.doc} F030Produt
//Retorna todos os produtos da NF ainda nao conferida
@author Celso Rene
@since 30/11/2018
@version 1.0
@type function
/*/
Static Function F030Produt(cMvFluxo)  

	Local cQuery	:= ""
	Local cArea		:= GetNextAlias()
	Local aBrowse	:= {}
	Local nLin		:= 0	


	cQuery := " SELECT 	DISTINCT"
	cQuery	+= "		C5_NUM 			NUM,"	 + chr(13)
	cQuery += "			C5_CLIENTE 		CLIENTE," + chr(13)	
	cQuery += "			C5_LOJACLI 		LOJACLI," + chr(13)	
	cQuery += "			A1_NOME 		NOME," + chr(13)
	cQuery += "			C5_EMISSAO 		EMISSAO," + chr(13)
	cQuery += "			C5_ORDSEP	 	ORDSEP," + chr(13)		
	cQuery += "			C5_NOTA			NOTA," + chr(13)
	cQuery += "			C5_SERIE		SERIE," + chr(13)
	cQuery += " 		C6_BOXSEP 		BOXSEP," + chr(13)

	aEval( aF030MvCpo, {|x| cQuery += x + ", "}, 1, 2 )

	cQuery += " 		ISNull( ( SELECT A1_NOME " + chr(13)
	cQuery += " 			FROM " + RetSQLName("SA1") + " " + chr(13)
	cQuery += " 			WHERE 	A1_FILIAL 	= '" + xFilial("SA1") + "' " + chr(13)
	cQuery += " 			AND	A1_COD	 = SC5." + aF030MvCpo[1]  + " " + chr(13)
	cQuery += " 			AND	A1_LOJA = SC5." + aF030MvCpo[2] + " " + chr(13) 
	cQuery += " 			AND	D_E_L_E_T_ <> '*' " + chr(13)
	cQuery += " 			), ' ' ) NOM_CLIENTREG,"
	cQuery += "			C5_PVVALE 		PVVALE," + chr(13)
	cQuery += "			'FAT' 			ORIGEM " + chr(13)
	cQuery += "			,CB7_ORDSEP ORDSEPARA " + chr(13)


	cQuery += " FROM	" + RetSQLName("SC5") 	+" SC5," + chr(13)
	cQuery += "			" + RetSQLName("SC6") 	+" SC6" + chr(13)

	cQuery += "	INNER JOIN " + RetSQLName("SA1") + " SA1 ON SA1.A1_FILIAL = '"  + xFilial("SA1") + "' AND SA1.A1_COD = SC6.C6_CLI AND SA1.A1_LOJA = SC6.C6_LOJA AND SA1.D_E_L_E_T_ = '' " + chr(13)
	cQuery += "	INNER JOIN " + RetSQLName("SF4") + " SF4 ON SF4.F4_FILIAL = '"  + xFilial("SF4") + "' AND SF4.F4_CODIGO = C6_TES AND SF4.F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = '' " + chr(13)
	cQuery += "	INNER JOIN " + RetSQLName("CB7") + " CB7 ON CB7.CB7_FILIAL = '" + xFilial("CB7") + "' AND CB7.CB7_PEDIDO = SC6.C6_NUM AND CB7.D_E_L_E_T_='' " + chr(13)
	cQuery += "	INNER JOIN " + RetSQLName("CB8") + " CB8 ON CB8.CB8_FILIAL = '" + xFilial("CB7") + "' AND CB8.CB8_ORDSEP = CB7.CB7_ORDSEP AND CB8.CB8_PEDIDO = SC6.C6_NUM AND CB8.CB8_ITEM = SC6.C6_ITEM AND CB8.CB8_PROD = SC6.C6_PRODUTO AND CB8.D_E_L_E_T_='' " + chr(13)

	cQuery += " WHERE SC5.C5_FILIAL  = '" + xFilial("SC5") 	+ "'" + chr(13)	

	cQuery += "   	AND	SC5.C5_TIPO	 = 'N'"	 + chr(13) 		//-- N = Normal  
	cQuery += "   	AND	SC5.C5_BLQ		 = ' '"	 + chr(13) //-- Nao bloqueado
	cQuery += "  	AND	SC6.C6_QTDSEP  > 0"	 + chr(13) 	//-- Separado
	//cQuery += "  	AND	SC6.C6_QTDCONF = 0"  + chr(13)		//-- Nao conferido

	If cMvFluxo = "1"
		cQuery += "  AND SC5.C5_PVSTAT  = '" + FATURADO + "'" + chr(13)
	ElseIf cMvFluxo = "2"
		cQuery += "  AND SC5.C5_PVSTAT  IN ('"+ ENVIADO_CONFERENCIA +"', '"+ SEPARADO +"' )" + chr(13)
		cQuery += "  AND SC5.C5_NOTA	 = ''" + chr(13)	//-- Nao faturado
	EndIf

	cQuery += " 	AND	SC6.C6_FILIAL = '" + xFilial("SC6") + "'" + chr(13)		 
	cQuery += " 	AND	SC6.C6_NUM    = SC5.C5_NUM"	+ chr(13)				

	cQuery += "		AND	SC5.D_E_L_E_T_ <> '*'" + chr(13)
	cQuery += "		AND	SC6.D_E_L_E_T_ <> '*'" + chr(13)   

	/*cQuery += " UNION ALL" + chr(13)

	cQuery += " SELECT 	DISTINCT " + chr(13)
	cQuery += "			L1_NUM 		NUM," + chr(13)		
	cQuery += "			L1_CLIENTE 	CLIENTE," + chr(13)	
	cQuery += "			L1_LOJA 		LOJACLI," + chr(13)	
	cQuery += "			A1_NOME 		NOME," + chr(13)
	cQuery += "			L1_EMISSAO 	EMISSAO," + chr(13)	
	cQuery += "			L1_ORDSEP	 	ORDSEP," + chr(13)		
	cQuery += "			L1_DOC 		NOTA," + chr(13)
	cQuery += "			L1_SERIE 		SERIE," + chr(13)
	cQuery += "			' ' 			BOXSEP," + chr(13)
	cQuery += "			L1_CLIENTE "	+ aF030MvCpo[1] +"," + chr(13) //-- Cliente entrega 	
	cQuery += "			L1_LOJA "  	+ aF030MvCpo[2] +"," + chr(13) //-- Loja cliente entrega
	cQuery += "			A1_NOME 		NOM_CLIENTREG," + chr(13)
	cQuery += "			' '		 		PVVALE," + chr(13)
	cQuery += "			'LOJ' 			ORIGEM" + chr(13)

	cQuery += " FROM		" + RetSQLName("SL1") 	+" SL1," + chr(13)	
	cQuery += "			" + RetSQLName("SL2") 	+" SL2," + chr(13)
	cQuery += "			" + RetSQLName("SA1") 	+" SA1" + chr(13)

	cQuery += " WHERE		SL1.L1_FILIAL  = '" + xFilial("SL1") + "'" + chr(13)

	cQuery += "		AND	SL1.L1_PVSTAT IN ('"+ SEPARADO +"', '"+ ENVIADO_CONFERENCIA +"', '" + CONFERIDO + "', '" + FATURADO + "')" + chr(13)

	cQuery += "   	AND	SL2.L2_QTDCONF = 0" + chr(13)	//-- Nao conferido
	cQuery += "   	AND	SL2.L2_QTDSEP	> 0" + chr(13)	//-- Separado

	cQuery += " 		AND	SL2.L2_FILIAL = '" + xFilial("SL2") + "'" + chr(13)		 
	cQuery += " 		AND	SL2.L2_NUM    = SL1.L1_NUM" + chr(13)			

	cQuery += " 		AND	SA1.A1_FILIAL = '" + xFilial("SA1") + "'" + chr(13)		 
	cQuery += " 		AND	SA1.A1_COD    = SL1.L1_CLIENTE"	+ chr(13)		
	cQuery += " 		AND	SA1.A1_LOJA   = SL1.L1_LOJA" + chr(13)			

	cQuery += "		AND	SL1.D_E_L_E_T_ <> '*'" + chr(13) 	  
	cQuery += "		AND	SL2.D_E_L_E_T_ <> '*'" + chr(13) 	  
	cQuery += "		AND	SA1.D_E_L_E_T_ <> '*'" + chr(13)
	*/

	cQuery += " ORDER BY ORIGEM, NUM"	  

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArea,.F.,.F.)

	TcSetField( cArea, "EMISSAO", "D", 08, 00 )

	(cArea)->( dbGoTop() )

	While (cArea)->( !Eof() )

		aAdd( aBrowse, Array(NCOL_QUANT) )

		nLin := Len(aBrowse)

		aBrowse[nLin][NPCHECK]		:= .F.
		aBrowse[nLin][NPC5_NUM]		:= (cArea)->NUM	
		aBrowse[nLin][NPC5_EMISSAO]	:= (cArea)->EMISSAO
		aBrowse[nLin][NPC5_CLIENTE]	:= (cArea)->CLIENTE
		aBrowse[nLin][NPC5_LOJACLI]	:= (cArea)->LOJACLI
		aBrowse[nLin][NPA1_NOME]		:= (cArea)->NOME
		aBrowse[nLin][NPF2_DOC]		:= (cArea)->NOTA
		aBrowse[nLin][NPF2_SERIE]	:= (cArea)->SERIE
		aBrowse[nLin][NPC6_BOXSEP]	:= (cArea)->BOXSEP
		aBrowse[nLin][NPCLIENTREG]	:= IIf( !Empty( (cArea)->&(aF030MvCpo[1]) ), (cArea)->&(aF030MvCpo[1]), (cArea)->CLIENTE )
		aBrowse[nLin][NPLOJENTREG]	:= IIf( !Empty( (cArea)->&(aF030MvCpo[2]) ), (cArea)->&(aF030MvCpo[2]), (cArea)->LOJACLI )
		aBrowse[nLin][NPNOMENTREG]	:= IIf( !Empty( (cArea)->NOM_CLIENTREG ), (cArea)->NOM_CLIENTREG, (cArea)->NOME )
		aBrowse[nLin][NPC5_PVVALE]	:= (cArea)->PVVALE
		aBrowse[nLin][NPORIGEM]		:= (cArea)->ORIGEM
		aBrowse[nLin][NPC5_ORDSEP]	:= (cArea)->ORDSEP
		aBrowse[nLin][NP_VAZIO]		:= ""

		dbSelectArea(cArea)
		dbSkip()

	EndDo

	(cArea)->( dbCloseArea() )

	If Len(aBrowse) = 0

		aAdd( aBrowse, Array(NCOL_QUANT) )

		nLin := Len(aBrowse)

		aBrowse[nLin][NPCHECK]		:= .F.
		aBrowse[nLin][NPC5_NUM]		:= ""	
		aBrowse[nLin][NPC5_EMISSAO]	:= CToD("//")
		aBrowse[nLin][NPC5_CLIENTE]	:= ""
		aBrowse[nLin][NPC5_LOJACLI]	:= ""
		aBrowse[nLin][NPA1_NOME]		:= ""
		aBrowse[nLin][NPF2_DOC]		:= ""
		aBrowse[nLin][NPF2_SERIE]	:= ""
		aBrowse[nLin][NPC6_BOXSEP]	:= ""
		aBrowse[nLin][NPCLIENTREG]	:= ""
		aBrowse[nLin][NPLOJENTREG]	:= ""
		aBrowse[nLin][NPNOMENTREG]	:= ""
		aBrowse[nLin][NPC5_PVVALE]	:= ""
		aBrowse[nLin][NPORIGEM]		:= ""
		aBrowse[nLin][NPC5_ORDSEP]	:= ""
		aBrowse[nLin][NP_VAZIO]		:= ""

	EndIf

Return(aBrowse)



/*/{Protheus.doc} F030OrdBro
//Alterar ordem de exibicao TWBrowse.
@author Celso Rene
@since 30/11/2018
@version 1.0
@type function
/*/
Static Function F030OrdBro(aBrowse, lAuto)

	Local aRet		:= {}
	Local aPergs		:= {}
	Local aOpcoes		:= {}
	Local lConfirm	:= .T.


	aAdd( aOpcoes, "1 - Pedido + Cliente + Loja" )
	aAdd( aOpcoes, "2 - Cliente + Loja + Pedido" )
	aAdd( aOpcoes, "3 - Data Emissão" )
	aAdd( aOpcoes, "4 - Nome Cliente + Pedido" )

	aAdd( aPergs,{3, "Ordem Apresentação", nF030Ord, aOpcoes, 150, "", .F.} )

	If !lAuto

		If ParamBox(aPergs, "Ordem", @aRet,,,.T.,,,,,.F.)
			nF030Ord	:= aRet[1]
		Else
			lConfirm := .F.
		EndIf

	EndIf

	If lConfirm

		If nF030Ord = 1
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPORIGEM]+x[NPC5_NUM]+x[NPC5_CLIENTE]+x[NPC5_LOJACLI] < y[NPORIGEM]+y[NPC5_NUM]+y[NPC5_CLIENTE]+y[NPC5_LOJACLI] })
		ElseIf nF030Ord = 2  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPORIGEM]+x[NPC5_CLIENTE]+x[NPC5_LOJACLI]+x[NPC5_NUM] < y[NPORIGEM]+y[NPC5_CLIENTE]+y[NPC5_LOJACLI]+y[NPC5_NUM] })
		ElseIf nF030Ord = 3  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPORIGEM]+DToS(x[NPC5_EMISSAO]) < y[NPORIGEM]+DToS(y[NPC5_EMISSAO]) })
		ElseIf nF030Ord = 4  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPORIGEM]+x[NPA1_NOME]+x[NPC5_NUM] < y[NPORIGEM]+y[NPA1_NOME]+y[NPC5_NUM] })
		EndIf

	EndIf

Return(aBrowse)


/*/{Protheus.doc} F030CriaSx
//Criar o grupo de perguntas. 
@author solutio02
@since 30/11/2018
@version 1.0
@type function
/*/
Static Function F030CriaSx(cPerg)

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

	//			Texto Pergunta	       	Tipo 	Tam 	Dec  G=get ou C=Choice  	Val   	F3		Def01 	  Def02 	 Def03   Def04   Def05
	aAdd(aP,{	"Informar Quantidade ?", 	"N",	1,		0,	 "C",					"",	  "",	   	"Nao",	 "Sim",		"",		"",		"" })


	//          012345678912345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//                   1         2         3         4         5         6         7         8         9        10        11        12
	aAdd(aHelp,{"Informar quantidade na leitura do item."})


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



Return()
