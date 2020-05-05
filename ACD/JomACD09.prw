#Include "Protheus.ch"
#Include "Rwmake.ch"
#INCLUDE "tbiconn.ch"
#Include "topconn.ch"
#Include "Trsf010.ch"

/* Colunas TWBrowse */
#Define NPOS_STATUS			01
#Define NPOS_C9_ITEM		02
#Define NPOS_B1_CODBAR		03
#Define NPOS_C9_PRODUTO		04
#Define NPOS_B1_DESC		05
#Define NPOS_QTDVEND		06
#Define NPOS_QTDCONF		07
#Define NPOS_B1_RASTRO		08
#Define NPOS_LOTE			09
#Define NPOS_C9_PEDIDO		10
#Define NPOS_QTDSEP			11

/* Qtde de colunas TWBrowse */
#Define NCOL_QUANT			11

/* Colunas TwBrowse NPOS_LOTE*/
#Define NLOT_NUM			01
#Define NLOT_QTCONF			02
#Define NLOT_DTVALID		03
#Define NLOT_QTLIB			04

/* Qtde de colunas TWBrowse */
#Define NLOT_QUANT			04



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ TRSF031  ³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Conferencia pedido ( Leitura )                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ u_TRSF031                                                  ³±±
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
//User Function TRSF031(cPedido, cCliente, cLoja, cOrigem, cPvVale, cNf, cSerie, nDocDe, nDocAte, cMvFluxo, nDigQtd )

User Function JomACD09(cPedido, cCliente, cLoja, cOrigem, cPvVale, cNf, cSerie, nDocDe, nDocAte, cMvFluxo, nDigQtd)

	Local oDlgSep
	Local oBroSep
	Local oPnlCab, oPnlRod
	Local oGrpCab, oGrpRod
	Local oSayLeitura
	Local oGetLeitura
	Local oBtoOrdem, oBtoDetLe, oBtoConf, oBtoCanc, oBtoLegen
	Local oSayPv, oSayCli, oSayLoj, oSayDCl, oSayNf, oSaySer, oSayPvA, oSayPvD
	Local oFntMsg, oFntPvV
	Local oGetPv, oGetCli, oGetLoj, oGetDCl, oGetNf, oGetSer
	Local oStatus 	 

	Local aSize		:= {}
	Local aObj		:= {}
	Local aInfo		:= {}
	Local aPObj		:= {}
	Local aBrowse		:= {}
	Local aCabec		:= {}
	Local aLegenda	:= {}

	Local lValQtd		:= .F.
	Local lConf			:= .F.
	Local lQtdEmb		:= SuperGetMV( "TRS_MON005", .F., .F. ) // Considerar (somar) na leitura a quantidade por embalagem (B1_QE)
	Local lDigQtd		:= .F. //( nDigQtd = 2 ) 

	Local nZ			:= 0
	Local nOpc			:= 0
	Local nTamGetLei	:= 0

	Local cMsg		:= ""
	Local cTipoEtiq	:= SuperGetMV( "TRS_MON011", .F., "1" ) //Tipo de etiqueta 1 ou 2
	Local cGetLeitura:= ""

	Local bBtoOrdem, bWhenBto, bWhenDetL, bBtoDetLe, bBtoLegen, bBtoConf, bBtoCanc
	Local bGetLeitura
	Local bF2, bF4, bF5
	Local bLinha		:= {||} 

	Private cF031Cad	:= "Conferencia pedido (Leitura)"
	Private nF031Ord	:= 1	// Ordem de exibicao do Browse

	Private oMsgLin1, oMsgLin2, oMsgLin3, oMsgStat
	Private cMsgLin1, cMsgLin2, cMsgLin3, cMsgStat


	bF2 := SetKey( VK_F2,  )
	bF4 := SetKey( VK_F4,  )
	bF5 := SetKey( VK_F5,  )

	SetKey( VK_F2, {||} )
	SetKey( VK_F4, {||} )
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
		nTamGetLei += TamSX3("CB0_CODETI")[1]
		nTamGetLei += TamSX3("B8_DTVALID")[1]
		nTamGetLei += TamSX3("B8_LOTEFOR")[1]

		cGetLeitura:= Space( nTamGetLei + 1 )

	EndIf

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
	aAdd( aCabec, "Qt. a Vender" ) ////vendida
	aAdd( aCabec, "Qt. Separada" )
	aAdd( aCabec, "Qt. Conferida" )
	aAdd( aCabec, "Rastro" )

	oDlgSep := MSDialog():New( aSize[7], aSize[1], aSize[6], aSize[5], cF031Cad,,,,,,,,,.T.,,, )

	// Fontes
	oFntMsg := TFont():New("Arial",,-18,.T.)
	oFntPvV := TFont():New("Arial",,-16,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Bloco When dos botoes                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
	bWhenBto := { || !Empty( aBrowse[oBroSep:nAt,NPOS_C9_PRODUTO] )  }

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
	(	F031Leitur(cGetLeitura, @aBrowse, lQtdEmb, lDigQtd),;
	oDlgSep:Refresh(),;
	oBroSep:Refresh(),;
	cGetLeitura := Space( nTamGetLei + IIf( cTipoEtiq = "2", 1 , 0 ) ),;
	oGetLeitura:CtrlRefresh(),;
	oGetLeitura:SetFocus() ); 
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

	bBtoOrdem := { || IIf( !Empty( aBrowse[oBroSep:nAt,NPOS_C9_PRODUTO] ),;
	(	aBrowse := F031OrdBro(aBrowse, .F.),;
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

	bWhenDetL := {|| ( aBrowse[oBroSep:nAt,NPOS_QTDCONF] < aBrowse[oBroSep:nAt,NPOS_QTDVEND] ) .And. aBrowse[oBroSep:nAt,NPOS_B1_RASTRO] }

	bBtoDetLe := {|| F031DetaIt( aBrowse[oBroSep:nAt] ) }

	cMsg := "Verificar pendência do item posicionado"

	oBtoDetLe := TButton():New(	025,;
	125,;
	"Ver pendencia Item",;
	oGrpCab,;
	bBtoDetLe,; 
	055,; 
	010,,,.F.,.T.,.F.,cMsg,.F.,bWhenDetL,,.F. )

	bBtoLegen := {|| F031Legend(.F.) }

	cMsg := "Legenda"

	oBtoLegen := TButton():New(	040,;
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

	oSayNf := TSay():New(	005,;
	250,;
	{||"Nota Fiscal"},;
	oGrpCab,,,,;
	,,.T.,,,;
	40,;
	10)

	oSaySer := TSay():New(	005,;
	300,;
	{||"Serie"},;
	oGrpCab,,,,;
	,,.T.,,,;
	40,;
	10)

	oGetPv := TGet():New( 	015,;
	200,;
	{|| cPedido},;//bSetGet
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

	oGetNf := TGet():New( 	015,;
	250,;
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
	,,,,.F.,"",)

	oGetSer := TGet():New( 	015,;
	300,;
	{|| cSerie},;//bSetGet
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

	oSayPvA := TSay():New(	030,;
	390,;
	{|| "De / Ate" },;
	oGrpCab,,,,;
	,,.T.,,,;
	80,;
	10)

	oGetCli := TGet():New( 	040,;
	200,;
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
	,,,,.F.,"",)

	oGetLoj := TGet():New( 	040,;
	250,;
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
	,,,,.F.,"",)

	oGetDCl := TGet():New( 	040,;
	280,;
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

	oSayPvD := TSay():New(	040,;
	390,;
	{|| StrZero(nDocDe,3) +" / "+ StrZero(nDocAte,3) },;
	oGrpCab,,oFntPvV,,;
	,,.T.,CLR_BLUE,CLR_WHITE,;
	80,;
	10)

	bBtoConf := {||	lValQtd := .T.,; 
	aEval( aBrowse, {|x| IIf( x[NPOS_QTDSEP] != x[NPOS_QTDCONF] .Or. x[NPOS_QTDCONF] = 0 , lValQtd := .F., Nil) } ),;
	IIf( !lValQtd,; 
	lConf := F031PeConf(aBrowse,cOrigem, cPedido),;
	lConf := .T. ),;	
	IIf( lConf,;
	MsAguarde( {|| 	F031Confir(aBrowse,cOrigem),;
	nOpc := 1,;
	oDlgSep:End()}, "Aguarde!", "Confirmando...", .F. ),;
	Nil) }

	cMsg := "Confirmar confêrencia"

	oBtoConf := TButton():New(	005,;
	430,;
	"Confirmar",;
	oGrpCab,;
	bBtoConf,; 
	040,; 
	020,,,.F.,.T.,.F.,cMsg,.F.,{||},,.F. )

	cMsg := "Conferencia de múltiplos documentos!"
	cMsg += CRLF
	cMsg += StrZero(nDocDe,3) +" / "+ StrZero(nDocAte,3) + "."
	cMsg += CRLF
	cMsg += "O cancelamento, desfaz as demais conferencias." 
	cMsg += CRLF 
	cMsg += CRLF 
	cMsg += "Confirma?"

	bBtoCanc := {|| 	IIf(cPvVale = "S",;
	lConf := ( Aviso(cF031Cad, cMsg, {"Sim","Não"}, 3 ) = 1 ),;
	lConf := .T.),; 
	IIf(lConf, (nOpc := 0, oDlgSep:End()), Nil) }										

	oBtoCanc := TButton():New(	030,;
	430,;
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

	MsAguarde( {|| oBroSep:SetArray( aBrowse := F031OrdBro( F031Produt(cPedido, cOrigem, cMvFluxo, cNf, cSerie, cCliente, cLoja), .T. ) ) }, "Aguarde!", "Listando...", .F. )

	bLinha := {|| {	oStatus := LoadBitmap( Nil, aLegenda[ aScan( aLegenda := F031Legend(.T.), {|x| x[1] = aBrowse[oBroSep:nAt,NPOS_STATUS]} ) ][3] ),;
	aBrowse[oBroSep:nAt,NPOS_C9_ITEM],;                      
	aBrowse[oBroSep:nAt,NPOS_B1_CODBAR],;
	aBrowse[oBroSep:nAt,NPOS_C9_PRODUTO],;
	aBrowse[oBroSep:nAt,NPOS_B1_DESC],;
	Transform(aBrowse[oBroSep:nAt,NPOS_QTDVEND],"@E 999999.99"),;
	Transform(aBrowse[oBroSep:nAt,NPOS_QTDSEP],"@E 999999.99"),;
	Transform(aBrowse[oBroSep:nAt,NPOS_QTDCONF],"@E 999999.99"),;
	IIf(aBrowse[oBroSep:nAt,NPOS_B1_RASTRO], "Sim", "Nao");
	}}

	oBroSep:bLine := bLinha 

	oBroSep:aColSizes := {15, 25, 60, 60, 120, 40, 40, 40, 25}

	oBroSep:bLDblClick := {|| IIf( aBrowse[oBroSep:nAt,NPOS_QTDCONF] < aBrowse[oBroSep:nAt,NPOS_QTDVEND] .And. aBrowse[oBroSep:nAt,NPOS_B1_RASTRO],;
	F031DetaIt( aBrowse[oBroSep:nAt] ),;
	Nil);
	}

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

	SetKey( VK_F2, bF2 )
	SetKey( VK_F4, bF4 )
	SetKey( VK_F5, bF5 )

Return( (nOpc = 1) )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F031Confir³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Botao confirmar.                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F031Confir(aBrowse, cOrigem)

	Local nItem		:= 0
	Local cStatus	:= ""
	Local _cNumPV	:= ""


	If cOrigem = "FAT"

		_cNumPV := aBrowse[1][NPOS_C9_PEDIDO]

		For nItem := 1 To Len(aBrowse)

			dbSelectArea("SC5")
			dbSetOrder(1)

			If dbSeek( xFilial("SC5") + aBrowse[nItem][NPOS_C9_PEDIDO] )

				RecLock("SC5", .F.)
				SC5->C5_USRCON := CUSERNAME
				SC5->C5_PVSTAT := CONFERIDO 	
				SC5->(MsUnLock())

				dbSelectArea("SC6")
				dbSetOrder(1)

				If dbSeek( xFilial("SC6") + aBrowse[nItem][NPOS_C9_PEDIDO] + aBrowse[nItem][NPOS_C9_ITEM] )

					RecLock("SC6", .F.)
					SC6->C6_QTDCONF := aBrowse[nItem][NPOS_QTDCONF] 	
					SC6->(MsUnLock())




					/*
					//buscando etiquetas e grando flag na CB9 = itens separados
					For _x:= 1 to Len(aBrowse[nItem][9]) 

					dbSelectArea("CB9")
					dbSetOrder(3)  //CB9_FILIAL + CB9_PROD + CB9_CODETI
					If (dBseek( xFilial("CB9") + SC6->C6_PRODUTO + aBrowse[nItem][9][_x][1] ) )

					//Atualizando registro CB9
					RecLock("CB9", .F.)
					CB9->CB9_XCONF := "S" 	
					CB9->(MsUnLock())

					EndIf         

					dbCloseArea("CB9")

					Next _x
					*/

				EndIf

			EndIf

		Next nItem

		//ajustando ordem de separacao - controle emissao documento e status
		dbSelectArea("CB7")
		dbSetOrder(2)
		dbSeek(xFilial("CB7") + _cNumPV )
		If (Found() )
			RecLock("CB7", .F.)
			CB7->CB7_TIPEXP := "00*"
			CB7->CB7_STATUS := "9"
			CB7->(MsUnLock())
		EndIf

		
		//zerando as tarefas - ACD
		TCSqlExec(" UPDATE " + RetSqlName("CBF") + "  SET  D_E_L_E_T_ = '*'  WHERE CBF_XPED = '" + Alltrim(_cNumPV) + "' AND D_E_L_E_T_ = '' ")
		
		//Gerando documento de saida automaticamente
		U_JOMACD11(_cNumPV) 
		

	EndIf


Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F031PeConf³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada para validar a confirmacao leitura.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F031PeConf(aBrowse,cOrigem,cPedido)

	Local cMsg			:= ""
	Local cTipoVar		:= ""
	Local lConf		 	:= .F.
	Local lExistBlock	:= ExistBlock("F031CONF")

	If lExistBlock

		lConf := ExecBlock("F031CONF",.F.,.F.,{aClone(aBrowse),cOrigem,cPedido})

		cTipoVar := ValType(lConf)

		If cTipoVar != "L"

			lConf := .F.

			cMsg := "Ponto de Entrada: F031CONF"
			cMsg += CRLF 
			cMsg += "O tipo de retorno deste ponto de entrada,"
			cMsg += "precisa ser do tipo lógico ( L )!"
			cMsg += CRLF
			cMsg += "L -> " + cTipoVar
			cMsg += CRLF
			cMsg += "Contate o administrador do sistema."

			Help("",1,"TRSF031|F031PECONF",,cMsg,1,0)

		EndIf

	EndIf

	If !lExistBlock

		If !lConf

			cMsg := "Há inconsistência na conferencia!"
			cMsg += CRLF
			cMsg += CRLF
			cMsg += "Confirmar?"
			cMsg += CRLF
			cMsg += CRLF
			cMsg += "Veja a lista de produto(s):"
			cMsg += CRLF
			aEval( aBrowse, {|x| IIf( x[NPOS_QTDVEND] != x[NPOS_QTDCONF] .Or. x[NPOS_QTDSEP] != x[NPOS_QTDCONF],;
			cMsg	+= "Produto:" + AllTrim(x[NPOS_C9_PRODUTO]);
			+ " Qt. Venda: " + cValToChar(x[NPOS_QTDVEND]);
			+ " Qt. Separada: " + cValToChar(x[NPOS_QTDSEP]);
			+ " Qt. Conferida: " + cValToChar(x[NPOS_QTDCONF]);
			+ CRLF,;
			Nil) } )

			lConf := ( Aviso(cF031Cad, cMsg, {"Sim","Não"}, 3) = 1 )

		EndIf

	EndIf

Return( lConf )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F031Leitur³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Leitura do Get.                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F031Leitur(cGetLeitura, aBrowse, lQtdEmb, lDigQtd)

	Local nQtdEmb		:= 0
	Local nPosItem	:= 0
	Local nPosLote	:= 0
	Local nTamProd	:= TamSx3("B1_COD")[1]
	Local nTamLote	:= TamSx3("C6_LOTECTL")[1]
	Local cProduto	:= PadR( SubStr( cGetLeitura, 1, nTamProd ), nTamProd )
	Local cLoteCtl	:= PadR( SubStr( cGetLeitura, (nTamProd+1), nTamLote ), nTamLote )
	Local cProdPE		:= ""
	Local lOk     	:= .T.
	Local lF031Msg	:= ExistBlock("F031MSG")
	Local lF031VQtd	:= ExistBlock("F031VQTD")
	Local lFGenLPro	:= ExistBlock("FGENLPRO")
	Local lFGenQE	:= ExistBlock("FGENQE")

	Local bValLote	:= {|aLote| nPosLote := aScan( aLote, {|y| y[NLOT_NUM] = cLoteCtl .And. y[NLOT_QTCONF] < y[NLOT_QTLIB] } ) }


	//Ponto de entrada para permitir alterar localizacao do codigo do produto 
	If lFGenLPro

		cProdPE := ExecBlock("FGENLPRO",.F.,.F.,{cGetLeitura})

		If ValType(cProdPE) = "C"
			cProduto := cProdPE
		EndIf

	EndIf

	SB1->( dbSetOrder(1) )  //B1_FILIAL + B1_COD


	If ( nPosItem := aScan( aBrowse, {|x| x[NPOS_C9_PRODUTO] = cProduto .And. Eval(bValLote, x[NPOS_LOTE]) > 0 } ) ) = 0

		SB1->( dbSetOrder(5) )//B1_FILIAL + B1_CODBAR

		nTamProd := TamSx3("B1_CODBAR")[1]
		cProduto := SubStr( cGetLeitura, 1 , nTamProd )

		If ( nPosItem := aScan( aBrowse, {|x| x[NPOS_B1_CODBAR] = cProduto .And. Eval(bValLote, x[NPOS_LOTE]) > 0 } ) ) = 0

			lOk := .F.

			cMsgLin1 := cProduto									//-- Produto + Lote
			cMsgLin2 := ""											//-- Descricao Produto
			cMsgLin3 := "Produto não faz parte deste documento"		//-- Mensagem
			cMsgStat := ""											//-- Status quantidades Vendida X Conferida

			oMsgLin1:SetText(cMsgLin1)
			oMsgLin2:SetText(cMsgLin2)
			oMsgLin3:SetText(cMsgLin3)
			oMsgStat:SetText(cMsgStat)

		EndIf

	EndIf 

	/*		//processo antigo
	If ( nPosItem := aScan( aBrowse, {|x| x[NPOS_C9_PRODUTO] = cProduto .And. Eval(bValLote, x[NPOS_LOTE]) > 0 } ) ) = 0

	SB1->( dbSetOrder(5) )//B1_FILIAL + B1_CODBAR

	nTamProd := TamSx3("B1_CODBAR")[1]
	cProduto := SubStr( cGetLeitura, 1 , nTamProd )

	If ( nPosItem := aScan( aBrowse, {|x| x[NPOS_B1_CODBAR] = cProduto .And. Eval(bValLote, x[NPOS_LOTE]) > 0 } ) ) = 0

	lOk := .F.

	cMsgLin1 := cProduto									//-- Produto + Lote
	cMsgLin2 := ""											//-- Descricao Produto
	cMsgLin3 := "Produto não faz parte deste documento"		//-- Mensagem
	cMsgStat := ""											//-- Status quantidades Vendida X Conferida

	oMsgLin1:SetText(cMsgLin1)
	oMsgLin2:SetText(cMsgLin2)
	oMsgLin3:SetText(cMsgLin3)
	oMsgStat:SetText(cMsgStat)

	EndIf

	EndIf
	*/		

	//Validar Quantidades
	If lOk

		If aBrowse[nPosItem,NPOS_QTDCONF] = aBrowse[nPosItem,NPOS_QTDVEND]

			lOk := .F.

			cMsgLin1 := cProduto +" Etiqueta: "+ cLoteCtl		//-- Produto + Etiqueta
			cMsgLin2 := aBrowse[nPosItem,NPOS_B1_DESC]		//-- Descricao Produto
			cMsgLin3 := "Produto já conferido"					//-- Mensagem
			cMsgStat := StrZero(aBrowse[nPosItem,NPOS_QTDCONF], IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEND])) <= 6, 3, 6 ) )+" / "+;
			StrZero(aBrowse[nPosItem,NPOS_QTDVEND], IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEND])) <= 6, 3, 6 ))	//-- Status quantidades Vendida X Conferida

			oMsgLin1:SetText(cMsgLin1)
			oMsgLin2:SetText(cMsgLin2)
			oMsgLin3:SetText(cMsgLin3)
			oMsgStat:SetText(cMsgStat)

		Else

			If aBrowse[nPosItem,NPOS_QTDCONF] < aBrowse[nPosItem,NPOS_QTDVEND]

				If aBrowse[nPosItem,NPOS_LOTE][nPosLote][NLOT_QTCONF] = aBrowse[nPosItem,NPOS_LOTE][nPosLote][NLOT_QTLIB]

					lOk := .F.

					cMsgLin1 := cProduto +" Etiqeta: "+ cLoteCtl	//-- Produto + Etiqueta
					cMsgLin2 := aBrowse[nPosItem,NPOS_B1_DESC]		//-- Descricao Produto
					cMsgLin3 := "Produto + Etiqueta já conferido"	//-- Mensagem
					cMsgStat := StrZero(aBrowse[nPosItem,NPOS_QTDCONF],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEND])) <= 6, 3, 6 ) )+" / "+;
					StrZero(aBrowse[nPosItem,NPOS_QTDVEND],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEND])) <= 6, 3, 6 ))	//-- Status quantidades Vendida X Conferida

					oMsgLin1:SetText(cMsgLin1)
					oMsgLin2:SetText(cMsgLin2)
					oMsgLin3:SetText(cMsgLin3)
					oMsgStat:SetText(cMsgStat)


				EndIf
			EndIf
		EndIf

	EndIf

	//-- Conferencia Ok  
	If lOk

		nQtdEmb := 1

		If lDigQtd

			If lF031VQtd

				lDigQtd := ExecBlock("F031VQTD",.F.,.F.,{cProduto})

				If ValType(lDigQtd) <> "L"
					lDigQtd := .F.
				EndIf

			EndIf

			If lDigQtd
				//	nQtdEmb := F031QtdDig( aBrowse[nPosItem,NPOS_QTDCONF], aBrowse[nPosItem,NPOS_QTDVEND] )
				nQtdEmb := 1			
			EndIf

		Else

			SB1->( dbSeek( xFilial("SB1") + cProduto ) )

			If lQtdEmb

				//Ponto de entrada para customizar a quantidade por embalagem
				If lFGenQE

					nQtdEmb := ExecBlock("FGENQE",.F.,.F.,{cGetLeitura,cProduto})

					If ValType( nQtdEmb ) = "N" 

						If !F031ValQt( nQtdEmb, aBrowse[nPosItem,NPOS_QTDCONF], aBrowse[nPosItem,NPOS_QTDVEND], .T. ) 

							lOk := .F.

							cMsgLin1 := cProduto +" Etiqeta: "+ cLoteCtl							 //-- Produto + Lote
							cMsgLin2 := aBrowse[nPosItem,NPOS_B1_DESC]				    			 //-- Descricao Produto
							cMsgLin3 := "Quantidade separada nao confere com a quantidade vendida."	 //-- Mensagem
							cMsgStat := StrZero(aBrowse[nPosItem,NPOS_QTDCONF], IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEND])) <= 6, 3, 6 ) )+" / "+;
							StrZero(aBrowse[nPosItem,NPOS_QTDVEND], IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEND])) <= 6, 3, 6 ))	//-- Status quantidades Vendida X Conferida

							oMsgLin1:SetText(cMsgLin1)
							oMsgLin2:SetText(cMsgLin2)
							oMsgLin3:SetText(cMsgLin3)
							oMsgStat:SetText(cMsgStat)

						EndIf

					Else
						nQtdEmb := 1
					EndIf

				Else

					If SB1->B1_QE > 0

						nQtdEmb := ( nQtdEmb * SB1->B1_QE )

					EndIf

				EndIf

			EndIf

		EndIf

		If lOk

			//-- Soma quantidade conferida
			aBrowse[nPosItem,NPOS_QTDCONF] += nQtdEmb

			//-- Soma quantidade do lote
			aBrowse[nPosItem,NPOS_LOTE][nPosLote][NLOT_QTCONF] += nQtdEmb

			//-- Status
			If aBrowse[nPosItem,NPOS_QTDCONF] = aBrowse[nPosItem,NPOS_QTDVEND] 
				aBrowse[nPosItem,NPOS_STATUS] := "C"// C = Conferido
			ElseIf aBrowse[nPosItem,NPOS_QTDCONF] < aBrowse[nPosItem,NPOS_QTDVEND]
				aBrowse[nPosItem,NPOS_STATUS] := "E"// E = Em conferencia
			EndIf

			cMsgLin1 := cProduto +" Etiqeta: "+ cLoteCtl		//-- Produto + Lote
			cMsgLin2 := aBrowse[nPosItem,NPOS_B1_DESC]	//-- Descricao Produto
			cMsgLin3 := "Leitura Ok"							//-- Mensagem
			cMsgStat := StrZero(aBrowse[nPosItem,NPOS_QTDCONF],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEND])) <= 6, 3, 6 ) )+" / "+;
			StrZero(aBrowse[nPosItem,NPOS_QTDVEND],IIf( Len(cValToChar(aBrowse[nPosItem,NPOS_QTDVEND])) <= 6, 3, 6 ))	//-- Status quantidades Vendida X Conferida

			oMsgLin1:SetText(cMsgLin1)
			oMsgLin2:SetText(cMsgLin2)
			oMsgLin3:SetText(cMsgLin3)
			oMsgStat:SetText(cMsgStat)

		EndIf

	EndIf

	If	!lOk .And. lF031Msg

		ExecBlock("F031MSG",.F.,.F., { cMsgLin1, cMsgLin2, cMsgLin3, cMsgStat } )

	EndIf

Return(.F.)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F031Produt³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna todos os produtos liberados ainda nao conferido.   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F031Produt(cPedido, cOrigem, cMvFluxo, cNf, cSerie, cCliente, cLoja)  

	Local cQuery		:= ""
	Local cArea			:= GetNextAlias()
	Local cItemPv		:= ""	
	Local aBrowse		:= {}
	Local aLotPed		:= {}
	Local nQtdPed		:= 0
	Local nScan			:= 0
	Local lLjQtVe		:= SuperGetMV( "TRS_MON013", .F., .F. ) //Para toda conferencia do loja, considerar a quantidade do cupom fiscal (L2_QUANT), e nao a separada (L2_QTDSEP).


	If cOrigem = "FAT"

		If cMvFluxo = "1"

			cQuery += " SELECT  NUM,ITEM,PRODUTO,LOTE,DTVALID,QTDLIB,RASTRO,DESCRIC,CODBAR,QTDSEP FROM ( " + chr(13)
			cQuery += " SELECT 	D2_PEDIDO		NUM,"	+chr(13)
			cQuery += "			D2_ITEMPV		ITEM,"	 +chr(13)
			cQuery += "			B1_COD			PRODUTO," +chr(13)
			cQuery += "			CB9.CB9_CODETI AS LOTE, " +chr(13) 	//D2_LOTECTL		LOTE,
			cQuery += "			CB0.CB0_DTVLD  AS DTVALID, " +chr(13)  //D2_DTVALID		DTVALID,
			cQuery += "			CB9.CB9_QTESEP AS QTDLIB, " +chr(13)   //D2_QUANT		QTDLIB,) 		
			cQuery += "			B1_RASTRO		RASTRO,"  +chr(13)		
			cQuery += "			B1_DESC		DESCRIC," +chr(13)		
			cQuery += "			B1_CODBAR		CODBAR," +chr(13)

			cQuery += " 			ISNull( ( SELECT C6_QTDSEP " +chr(13) 
			cQuery += " 						FROM " + RetSQLName("SC6") + "" +chr(13)
			cQuery += " 						WHERE 	C6_FILIAL 	= '" + xFilial("SC6") + "'" +chr(13)
			cQuery += " 							AND	C6_NUM	  = D2_PEDIDO" +chr(13)
			cQuery += " 							AND	C6_ITEM   = D2_ITEMPV" +chr(13)
			cQuery += " 							AND	C6_ENVSEP = 1" +chr(13)
			cQuery += " 							AND	D_E_L_E_T_ <> '*' " +chr(13)
			cQuery += " 			), 0 ) QTDSEP "	+chr(13)

			//cQuery += "  CB9.CB9_QTESEP AS QTDSEP "

			cQuery += "  ,SD2.D2_ITEM AS ITEMDOC " +chr(13)

			cQuery += " FROM		" + RetSQLName("SD2") +" SD2" +chr(13)	

			cQuery += " INNER JOIN	" + RetSQLName("SB1") +" SB1" +chr(13)  
			cQuery += " 		ON	B1_FILIAL	= '" + xFilial("SB1") +"'" +chr(13)
			cQuery += " 		AND	B1_COD 	= D2_COD" +chr(13)

			cQuery += " INNER JOIN " + RetSQLName("CB9") +" CB9 ON CB9.CB9_PEDIDO = SD2.D2_PEDIDO AND CB9.CB9_PROD = SD2.D2_COD AND CB9.D_E_L_E_T_='' " + chr(13) //AND CB9.CB9_XCONF <> 'S' 
			cQuery += " INNER JOIN " + RetSQLName("CB0") +" CB0 ON CB0.CB0_CODPRO = CB9.CB9_PROD AND CB0.CB0_CODETI = CB9.CB9_CODETI AND CB0.D_E_L_E_T_ = '' " + chr(13) 

			cQuery += " WHERE		SD2.D2_FILIAL		= '" + xFilial("SD2") + "'" +chr(13)		 
			cQuery += "   	AND	SD2.D2_DOC 		= '" + cNf +"'" +chr(13) 		
			cQuery += "   	AND	SD2.D2_SERIE 		= '" + cSerie +"'" +chr(13) 		
			cQuery += "   	AND	SD2.D2_CLIENTE 	= '" + cCliente +"'" +chr(13)		
			cQuery += "   	AND	SD2.D2_LOJA 		= '" + cLoja +"'" +chr(13) 		

			cQuery += "		AND	SD2.D_E_L_E_T_ <> '*'" +chr(13) 	  
			cQuery += "		AND	SB1.D_E_L_E_T_ <> '*'" +chr(13)	  

			cQuery += "	) AS TABELA " +chr(13)
			cQuery += "	GROUP BY NUM,ITEM,PRODUTO,LOTE,DTVALID,QTDLIB,RASTRO,DESCRIC,CODBAR,QTDSEP "	 


		Else

			cQuery := " SELECT  NUM,ITEM,PRODUTO,LOTE,DTVALID,QTDLIB,RASTRO,DESCRIC,CODBAR,QTDSEP FROM ( " + chr(13)
			cQuery += " SELECT 	SC6.C6_NUM		NUM,"	+chr(13)
			cQuery += "			SC6.C6_ITEM		ITEM,"	 +chr(13)
			cQuery += "			B1_COD			PRODUTO," +chr(13)
			cQuery += "			CB9.CB9_CODETI AS LOTE, " +chr(13) 	//D2_LOTECTL		LOTE,
			cQuery += "			CB0.CB0_DTVLD  AS DTVALID, " +chr(13)  //D2_DTVALID		DTVALID,
			cQuery += "			CB9.CB9_QTESEP AS QTDLIB, " +chr(13)   //D2_QUANT		QTDLIB,) 		
			cQuery += "			B1_RASTRO		RASTRO,"  +chr(13)		
			cQuery += "			B1_DESC		DESCRIC," +chr(13)		
			cQuery += "			B1_CODBAR		CODBAR," +chr(13)

			cQuery += " 			ISNull( ( SELECT SC62.C6_QTDSEP " +chr(13) 
			cQuery += " 						FROM " + RetSQLName("SC6") + " SC62" +chr(13)
			cQuery += " 						WHERE 	SC62.C6_FILIAL 	= '" + xFilial("SC6") + "'" +chr(13)
			cQuery += " 							AND	SC62.C6_NUM	  = SC6.C6_NUM" +chr(13)
			cQuery += " 							AND	SC62.C6_ITEM   = SC6.C6_ITEM" +chr(13)
			cQuery += " 							AND	SC62.C6_ENVSEP = 1" +chr(13)
			cQuery += " 							AND	SC62.D_E_L_E_T_ <> '*' " +chr(13)
			cQuery += " 			), 0 ) QTDSEP "	+chr(13)

			//cQuery += "  CB9.CB9_QTESEP AS QTDSEP "

			cQuery += "  ,SC6.C6_ITEM AS ITEMDOC " +chr(13)

			cQuery += " FROM		" + RetSQLName("SC6") +" SC6" +chr(13)	

			cQuery += " INNER JOIN	" + RetSQLName("SB1") +" SB1" +chr(13)  
			cQuery += " 		ON	B1_FILIAL	= '" + xFilial("SB1") +"'" +chr(13)
			cQuery += " 		AND	B1_COD 	= C6_PRODUTO" +chr(13)

			cQuery += " INNER JOIN " + RetSQLName("CB8") +" CB8 ON CB8.CB8_FILIAL = '" + xFilial("CB8") + "' AND CB8.CB8_PEDIDO = SC6.C6_NUM AND CB8.CB8_ITEM = SC6.C6_ITEM AND CB8.CB8_PROD = SC6.C6_PRODUTO AND CB8.D_E_L_E_T_='' " + chr(13)
			cQuery += " INNER JOIN " + RetSQLName("CB9") +" CB9 ON CB9.CB9_FILIAL = '" + xFilial("CB9") + "' AND CB9.CB9_PEDIDO = CB8.CB8_PEDIDO AND CB9.CB9_PROD = CB8.CB8_PROD AND CB9.D_E_L_E_T_='' AND CB9.CB9_ITESEP = CB8.CB8_ITEM " + chr(13) //--AND CB9.CB9_XCONF <> 'S'
			cQuery += " INNER JOIN " + RetSQLName("CB0") +" CB0 ON CB0.CB0_FILIAL = '" + xFilial("CB0") + "' AND CB0.CB0_CODPRO = CB9.CB9_PROD AND CB0.CB0_CODETI = CB9.CB9_CODETI AND CB0.D_E_L_E_T_ = '' " + chr(13)  

			cQuery += " WHERE		SC6.C6_FILIAL		= '" + xFilial("SC6") + "'" +chr(13)		 
			cQuery += "   	AND	SC6.C6_NUM 		= '" + cPedido + "' " +chr(13)
			cQuery += "   	AND	SC6.C6_NOTA 		= '' " +chr(13) 				
			cQuery += "   	AND	SC6.C6_CLI 	= '" + cCliente +"'" +chr(13)		
			cQuery += "   	AND	SC6.C6_LOJA 		= '" + cLoja +"'" +chr(13) 		

			cQuery += "		AND	SC6.D_E_L_E_T_ <> '*'" +chr(13) 	  
			cQuery += "		AND	SB1.D_E_L_E_T_ <> '*'" +chr(13)	  

			cQuery += "	) AS TABELA " +chr(13)
			cQuery += "	GROUP BY NUM,ITEM,PRODUTO,LOTE,DTVALID,QTDLIB,RASTRO,DESCRIC,CODBAR,QTDSEP "	

			/*cQuery := " SELECT 	C9_PEDIDO		NUM," +chr(13)	 	
			cQuery += "			C9_ITEM		ITEM,"	+chr(13) 
			cQuery += "			C9_PRODUTO		PRODUTO," +chr(13) 		
			cQuery += "			C9_LOTECTL		LOTE," +chr(13)		
			cQuery += "			C9_DTVALID		DTVALID," +chr(13)		
			cQuery += "			C9_QTDLIB		QTDLIB," +chr(13)		
			cQuery += "			B1_RASTRO		RASTRO," +chr(13)		
			cQuery += "			B1_DESC		DESCRIC," +chr(13)		
			cQuery += "			B1_CODBAR		CODBAR," +chr(13)

			cQuery += " 			ISNull( ( SELECT C6_QTDSEP " +chr(13)
			cQuery += " 							FROM " + RetSQLName("SC6") +" " +chr(13)
			cQuery += " 							WHERE 	C6_FILIAL 	= '" + xFilial("SC6") + "'" +chr(13)
			cQuery += " 								AND	C6_NUM	 = C9_PEDIDO" +chr(13)
			cQuery += " 								AND	C6_ITEM = C9_ITEM"    
			cQuery += " 							AND	C6_ENVSEP = 1" + chr(13)
			cQuery += " 								AND	D_E_L_E_T_ <> '*' " + chr(13)
			cQuery += " 			), 0 ) QTDSEP "	+chr(13) 

			cQuery += " FROM		" + RetSQLName("SC9") + " SC9" +chr(13)	

			cQuery += " INNER JOIN	" + RetSQLName("SB1") + " SB1" +chr(13) 
			cQuery += " 		ON	B1_FILIAL	= '" + xFilial("SB1") + "'" +chr(13)
			cQuery += " 		AND	B1_COD 	= C9_PRODUTO" +chr(13)

			cQuery += " WHERE		SC9.C9_FILIAL		= '" + xFilial("SC9") + "'" +chr(13)		 
			cQuery += "   	AND	SC9.C9_PEDIDO		= '" + cPedido + "'" +chr(13) 		 
			cQuery += "   	AND	SC9.C9_QTDLIB		> 0" +chr(13)		
			cQuery += "  		AND	SC9.C9_NFISCAL	= ' '" +chr(13)		
			cQuery += "  		AND	SC9.C9_SERIENF	= ' '" +chr(13)

			cQuery += "		AND	SC9.D_E_L_E_T_ <> '*'" +chr(13)	  
			cQuery += "		AND	SB1.D_E_L_E_T_ <> '*'" +chr(13)	  
			*/


		EndIf

	EndIf

	/*cQuery += " 	 ORDER BY	NUM," 
	cQuery += " 				ITEM," 	  
	cQuery += " 				PRODUTO," 	  
	cQuery += " 				LOTE"*/

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArea,.F.,.T.)

	TcSetField( cArea, "DTVALID", "D", 08, 00 )

	(cArea)->( dbGoTop() )

	While (cArea)->( !Eof() )

		aAdd( aBrowse, Array(NCOL_QUANT) )

		aBrowse[Len(aBrowse)][NPOS_STATUS]		:= "N" // N = Nao conferido ou E = Em conferencia ou C = Conferido
		aBrowse[Len(aBrowse)][NPOS_C9_ITEM]		:= (cArea)->ITEM
		aBrowse[Len(aBrowse)][NPOS_B1_CODBAR]	:= (cArea)->CODBAR
		aBrowse[Len(aBrowse)][NPOS_C9_PRODUTO]	:= (cArea)->PRODUTO
		aBrowse[Len(aBrowse)][NPOS_B1_DESC]		:= (cArea)->DESCRIC
		aBrowse[Len(aBrowse)][NPOS_B1_RASTRO]	:= ( (cArea)->RASTRO = "L" )// L = Lote
		aBrowse[Len(aBrowse)][NPOS_QTDCONF]		:= 0
		aBrowse[Len(aBrowse)][NPOS_C9_PEDIDO]	:= (cArea)->NUM
		aBrowse[Len(aBrowse)][NPOS_QTDSEP]		:= (cArea)->QTDSEP

		nQtdPed := 0
		aLotPed := {}
		cItemPv := (cArea)->ITEM

		While (cArea)->( !Eof() ) .And. cItemPv = (cArea)->ITEM

			If ( nScan := aScan(aLotPed, {|x| x[NLOT_NUM] = (cArea)->LOTE} ) ) = 0

				aAdd(aLotPed, Array(NLOT_QUANT) )

				aLotPed[Len(aLotPed)][NLOT_NUM]			:= (cArea)->LOTE		//1 Num Lote
				aLotPed[Len(aLotPed)][NLOT_QTCONF]		:= 0					//2 Quantidade conferida lote
				aLotPed[Len(aLotPed)][NLOT_DTVALID]		:= (cArea)->DTVALID		//3 Data validade lote
				aLotPed[Len(aLotPed)][NLOT_QTLIB]		:= (cArea)->QTDLIB		//4 Quantidade lote

			Else

				aLotPed[nScan,NLOT_QTLIB] += (cArea)->QTDLIB

			EndIf

			nQtdPed += (cArea)->QTDLIB

			dbSelectArea(cArea)
			dbSkip()

		EndDo	

		aBrowse[Len(aBrowse)][NPOS_QTDVEND]	:= nQtdPed
		aBrowse[Len(aBrowse)][NPOS_LOTE]	:= aLotPed

	EndDo

	(cArea)->( dbCloseArea() )

	If Len(aBrowse) = 0

		aAdd( aBrowse, Array(NCOL_QUANT) )

		aBrowse[Len(aBrowse)][NPOS_STATUS]		:= "N" // N = Nao conferido ou E = Em conferencia ou C = Conferido
		aBrowse[Len(aBrowse)][NPOS_C9_ITEM]		:= ""
		aBrowse[Len(aBrowse)][NPOS_B1_CODBAR]	:= ""
		aBrowse[Len(aBrowse)][NPOS_C9_PRODUTO]	:= ""
		aBrowse[Len(aBrowse)][NPOS_B1_DESC]		:= ""
		aBrowse[Len(aBrowse)][NPOS_B1_RASTRO]	:= .F.
		aBrowse[Len(aBrowse)][NPOS_QTDCONF]		:= 0
		aBrowse[Len(aBrowse)][NPOS_C9_PEDIDO]	:= ""
		aBrowse[Len(aBrowse)][NPOS_QTDSEP]		:= 0
		aBrowse[Len(aBrowse)][NPOS_QTDVEND]		:= 0
		aBrowse[Len(aBrowse)][NPOS_LOTE]		:= {}

	EndIf

Return(aBrowse)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F031OrdBro³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alterar ordem de exibicao TWBrowse.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F031OrdBro(aBrowse, lAuto)

	Local aRet		:= {}
	Local aPergs	:= {}
	Local aOpcoes	:= {}
	Local lConfirm	:= .T.


	aAdd( aOpcoes, "1 - Item + Produto" )
	aAdd( aOpcoes, "2 - Item + Cod. Bar" )
	aAdd( aOpcoes, "3 - Status + Produto" )
	aAdd( aOpcoes, "4 - Qtd. Conferida + Produto" )
	aAdd( aOpcoes, "5 - Qtd. Vendida + Produto" )

	aAdd( aPergs,{3, "Ordem Apresentação", nF031Ord, aOpcoes, 150, "", .F.} )

	If !lAuto

		If ParamBox(aPergs, cF031Cad +" - Ordem", @aRet,,,.T.,,,,,.F.)
			nF031Ord	:= aRet[1]
		Else
			lConfirm := .F.
		EndIf

	EndIf

	If lConfirm

		If nF031Ord = 1
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPOS_C9_ITEM]+x[NPOS_C9_PRODUTO] < y[NPOS_C9_ITEM]+y[NPOS_C9_PRODUTO] })
		ElseIf nF031Ord = 2  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPOS_C9_ITEM]+x[NPOS_B1_CODBAR] < y[NPOS_C9_ITEM]+y[NPOS_B1_CODBAR] })
		ElseIf nF031Ord = 3  	
			aBrowse := ASort(aBrowse,,,{|x, y| x[NPOS_STATUS]+x[NPOS_C9_PRODUTO] < y[NPOS_STATUS]+y[NPOS_C9_PRODUTO] })
		ElseIf nF031Ord = 4  	
			aBrowse := ASort(aBrowse,,,{|x, y| cValToChar(x[NPOS_QTDCONF])+x[NPOS_C9_PRODUTO] < cValToChar(y[NPOS_QTDCONF])+y[NPOS_C9_PRODUTO] })
		ElseIf nF031Ord = 5  	
			aBrowse := ASort(aBrowse,,,{|x, y| cValToChar(x[NPOS_QTDVEND])+x[NPOS_C9_PRODUTO] < cValToChar(y[NPOS_QTDVEND])+y[NPOS_C9_PRODUTO] })
		EndIf

	EndIf

Return(aBrowse)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F031DetaIt³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Detalhes do item selecionado.                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F031DetaIt(aItem)

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

	aAdd( aCabec, "Etiqueta" )
	aAdd( aCabec, "Dt Validade" )
	aAdd( aCabec, "" )

	oDlgLot := MSDialog():New( 000, 000, 500, 800, cF031Cad +" - Detalhes" ,,,,,,,,,.T.,,, )

	oSayIte := TSay():New(	005,;
	010,;
	{||"Item"},;
	oDlgLot,,,,;
	,,.T.,,,;
	20,;
	10)

	oGetIte := TGet():New( 	015,;
	010,;
	{|| aItem[NPOS_C9_ITEM]},;//bSetGet
	oDlgLot,;
	020,;
	010,;
	"@!",;
	{||.T.},;//bValid
	,,,,,;
	.T.,;//lPixel
	,,;
	{||.F.},;//bWhen
	,,,,.F.,"",aItem[NPOS_C9_ITEM])

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
±±³Funcao    ³F031Legend³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Legenda de Status.                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function F031Legend(lAuto)

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

		BrwLegenda(cF031Cad + " - Legenda", cDescric, aLegenda)

	EndIf

Return(aOpcao)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F031QtdDig³ Autor ³ Jeferson Dambros      ³ Data ³ Jun/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Digitar a quantidade que sera digitada.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F031QtdDig()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN01 - Quantidade                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRSF031                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function F031QtdDig(nQtdConf, nQtdVend)

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
		@ 010,050	MsGet oQtde Var nQtde Picture PesqPictQt("C6_QTDVEN", nTamQtInt, nTamQtDec) Size 060,005 Of oDlg Pixel When .T. Valid ( F031ValQt( nQtde, nQtdConf, nQtdVend, .F. ) )

		DEFINE SBUTTON oBtn1 FROM 045,080 TYPE 1 PIXEL ACTION ( lContinua:= .f., oDlg:End() ) ENABLE OF oDlg

		oDlg:Activate(,,,.T.,{||,.T.},,{||} )

	EndDo

Return ( nQtde )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ F031ValQt³ Autor ³ Jeferson Dambros      ³ Data ³ Jun/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida a quantidade que sera digitada.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F031ValQt()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL01 - Verdadeiro ou Falso                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRSF031                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function F031ValQt( nQtde, nQtdConf, nQtdVend, lExibirMsg )

	Local lRet	:= .T.
	Local cMsg	:= ""


	If nQtde == 0 .Or. nQtde < 0 

		lRet := .F.

		If !lExibirMsg

			cMsg := "Quantidade Inválida!"

			Aviso(cF031Cad, cMsg, {"Ok"}, 3 )

		EndIf			

	EndIf

	If lRet

		// Quantidade digitada + Quantidade ja separada
		// nao pode ser maior que o pedido
		If ( nQtde + nQtdConf ) > nQtdVend

			lRet := .F.

			If !lExibirMsg 

				cMsg := "Quantidade Inválida!"
				cMsg += CRLF
				cMsg += "Quantidade apontada, não pode ser maior, que a quantidade do pedido."
				cMsg += CRLF
				cMsg += "Apont: " + cValToChar( nQtdConf + nQtde )
				cMsg += CRLF
				cMsg += "Qtd Item:" + cValToChar( nQtdVend )

				Aviso(cF031Cad, cMsg, {"Ok"}, 3 )

			EndIf

		EndIf

	EndIf

Return ( lRet )
