#include "protheus.ch"
#include "sigawin.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡„o    ³ JMHA010  ³ Autor ³ FABIO BRIDDI          ³ Data ³09.10.2006³±±
±±³Fun‡„o    ³ JMHF020  ³ Adap  ³ Marcelo Tarasconi     ³ Data ³22.08.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ INTERFACE PARA FACILITAR O CONTROLE DE VALES ENVIADOS AOS  ³±±
±±³          ³ CLIENTES (CONSIGNACAO/RETORNO/FATURAMENTO)                 ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function JMHF020()

Local aObjects		:= {}
Local aInfo			:= {}
Local cPerg := PadR("JMF020",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

Local aOrdem      := {"1 - Produto",;
			          "2 - Lote",;
				      "3 - Numero do Vale"}
Local cOrdem      := Space(1)
Local cChave      := Space(100)

Private oOk    := Loadbitmap(GetResources(), "LBOK")
Private oNo    := Loadbitmap(GetResources(), "LBNO")
Private aVales := {}
Private oVales
Private cCliente, cLoja, dDaEmissao, dAteEmissao
Private lMsHelpAuto := .T. 
Private lFirst      := .t.
Private cProduto
Private cItem
Private cNumLote
Private dValidade
Private nQtdeFat
Private nQtdeRep

Private cCliVale    := Space(6)
Private cLojCliVale := Space(2)
Private nPrcVend    := 0
Private cCusto      := Space(9)
Private cItemCTB    := Space(3)
Private cVendFat    := Space(6)
Private cSubLote    := Space(10)
Private cLocal      := Space(2)
Private nOpc        := 0

If Empty(M->C5_CLIENTE) .or. Empty(M->C5_LOJACLI)
   Alert('Para usar este recurso voce precisa informar o cliente!')
   Return()
EndIf

If Empty(M->C5_CLIVALE) .or. Empty(M->C5_LJCVALE)
   Alert('Para usar este recurso voce precisa informar o cliente vale!')
   Return()
EndIf

AjustaSX1(cPerg)
Pergunte(cPerg,.T.)

cCliente	:= M->C5_CLIVALE
cLoja		:= M->C5_LJCVALE
dDaEmissao	:= DTOS(MV_PAR01)
dAteEmissao	:= DTOS(MV_PAR02)

Processa( {|| JMHF020B() },"Selecionando Vales","Aguarde..." )

If Len(aVales) = 0
	Iw_MsgBox("Não há dados para esta seleção","Seleção de Vales","ALERT")
	Return
EndIf

// Dimensoes padroes
aSize := MsAdvSize()
AAdd( aObjects, { 100, 065, .T., .T. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj := MsObjSize( aInfo, aObjects,.T.)

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+cCliente+cLoja)
cNomCli := AllTrim(SA1->A1_NOME)
cEndCli := AllTrim(SA1->A1_END)
cCidCli := AllTrim(SA1->A1_MUN)
cEstCli := AllTrim(SA1->A1_EST)

// ordena a principio por produto
aVales := aSort( aVales,,, {|x,y| x[5] < y[5]} )

Define MsDialog oDlgPrin From aSize[7],00 TO aSize[6],aSize[5] Title "Seleção de Vales" Of oMainWnd Pixel
	Define Font oBold Name "Arial" Size 0, -15 Bold

	@ aSize[7]    ,010 Say "Cliente: " + AllTrim(cCliente) + "-" + cLoja + " " + cNomCli Size 600,015 Of oDlgPrin Pixel Font oBold
	@ aSize[7]+012,010 Say "Endereço: " + cEndCli + " - " + cCidCLi + " - " + cEstCli Size 500,015 Of oDlgPrin Pixel Font oBold

	@ (aSize[6]/2)-055,010 Say 'Ordens'
	@ (aSize[6]/2)-045,010 ComboBox cOrdem   Items aOrdem  Size 100,015  Of oDlgPrin Pixel on Change (SetOrdem(cOrdem), oVales:Refresh(), oVales:SetFocus())

	@ (aSize[6]/2)-045,150 Get cChave Size 150,010  Of oDlgPrin Pixel Valid (SeekChave(cChave, cOrdem), oVales:Refresh(), oVales:SetFocus())

	@ aSize[7]+30     ,000	ListBox oVales ;
							Fields HEADER "  ","Vale","Serie","Emissão","Produto","Descrição","Lote","Validade","Qtde Orig","Saldo","Preço Venda";
							Size (aSize[5]/2),(aSize[6]/2)-100;
							Pixel Of oDlgPrin ;
				            On dblClick( aVales := SDTroca( oVales:nAt, aVales ), oVales:Refresh() )						   

	oVales:SetArray(aVales)
	oVales:bLine:={|| {If(aVales[oVales:nAt,01],oOk,oNo),;
					 aVales[oVales:nAt,02],aVales[oVales:nAt,03],aVales[oVales:nAt,04],aVales[oVales:nAt,05],;
					 aVales[oVales:nAt,06],aVales[oVales:nAt,07],aVales[oVales:nAt,08],aVales[oVales:nAt,09],;
					 aVales[oVales:nAt,10],aVales[oVales:nAt,11],aVales[oVales:nAt,14]}}

	oVales:Refresh()

Activate msDialog oDlgPrin Centered On Init EnchoiceBar( oDlgPrin, { || If( /*fGrava(nAt)*/ .t. , nOpc := 1, nOpc := 2 ), If( nOpc == 1, JMHF020SEL(oVales:nAt)/*oDlgPrin:End()*/, Nil ) }, { || nOpc := 2, oDlgPrin:End() },, )   

Return

/*
----------------------------------------------------------------------------------------------------------------
*/

Static Function SetOrdem( cOrdem )

// por produto
If Substr(cOrdem,1,1) = '1'
	aVales := aSort( aVales,,, {|x,y| x[5] < y[5]} )
EndIf
// por lote
If Substr(cOrdem,1,1) = '2'
	aVales := aSort( aVales,,, {|x,y| x[7] < y[7]} )
EndIf
// por vale
If Substr(cOrdem,1,1) = '3'
	aVales := aSort( aVales,,, {|x,y| x[2] < y[2]} )
EndIf

Return nil

/*
----------------------------------------------------------------------------------------------------------------
*/

Static Function SeekChave( cChave, cOrdem )
Local nPos    := 0
Local nCol

If Substr(cOrdem,1,1) = '1'
	nCol := 5  // produto
ElseIf Substr(cOrdem,1,1) = '2'
	nCol := 7  // lote
ElseIf Substr(cOrdem,1,1) = '3'
	nCol := 2  // vale
EndIf

nPos := aScan(aVales, {|x| AllTrim(x[nCol]) == AllTrim(cChave)})
If nPos > 0
	oVales:nAt := nPos
EndIf

Return( .t. )

/*
----------------------------------------------------------------------------------------------------------------
*/

Static Function JMHF020B()

Local nPTipFat  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_TIPFAT" } )
Local nPCodProd := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_PRODUTO" } )



cQuery := "SELECT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, B6_DOC, B6_SERIE, B6_EMISSAO, B6_QUANT, B6_SALDO, 
cQuery +=        "B6_TES, B6_TIPO,  B6_IDENT, B6_IDENTB6, B6_TPCF, B6_PODER3, B1_DESC, "
cQuery +=        "D2_LOTECTL, D2_DTVALID, D2_ITEM, D2_PRCVEN "
cQuery += "FROM " + RetSQLName("SB6") + " SB6, "
cQuery +=           RetSQLName("SB1") + " SB1, "
cQuery +=           RetSQLName("SD2") + " SD2 "
cQuery += "WHERE SB6.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' AND SD2.D_E_L_E_T_ = ' ' "
cQuery += "AND   B6_FILIAL   = '" + xFilial('SB6') + "' "
cQuery += "AND   B6_CLIFOR   = '" + cCliente       + "' "
cQuery += "AND   B6_LOJA     = '" + cLoja          + "' "
If ! Empty(aCols[n,nPCodProd])
	cQuery += "AND   B6_PRODUTO  = '" + aCols[n,nPCodProd] + "' "
EndIf
If aCols[n,nPTipFat] == '1'  //Tip Fat = 1 Faturamento com reposicao - so vai pegar serie PER
	cQuery += "AND   B6_SERIE    IN ('PER') "
ElseIf aCols[n,nPTipFat] $ '2/3/4'  //Se for qq outro tipo, nao iremos pegar PER
	cQuery += "AND   B6_SERIE   NOT IN ('PER') "
EndIf

cQuery += "AND   B6_SALDO    > 0 "
cQuery += "AND   B6_PODER3   = 'R' "
cQuery += "AND   B6_EMISSAO >= '" + dDaEmissao     + "' "
cQuery += "AND   B6_EMISSAO <= '" + dAteEmissao    + "' "
cQuery += "AND   B1_FILIAL   = '" + xFilial('SB1') + "' "
cQuery += "AND   B1_COD      = B6_PRODUTO "
cQuery += "AND   D2_FILIAL   = '" + xFilial('SD2') + "' "
cQuery += "AND   D2_DOC      = B6_DOC "
cQuery += "AND   D2_SERIE    = B6_SERIE "
cQuery += "AND   D2_CLIENTE  = B6_CLIFOR "
cQuery += "AND   D2_LOJA     = B6_LOJA "
cQuery += "AND   D2_COD      = B6_PRODUTO "
cQuery += "AND   D2_IDENTB6  = B6_IDENT "
cQuery += "ORDER BY B6_EMISSAO, B6_DOC, B6_SERIE "
cQuery := ChangeQuery( cQuery )
DbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T. )
TCSetField("TRB","B6_EMISSAO","D",8,0)
TCSetField("TRB","D2_DTVALID","D",8,0)

DbSelectArea("TRB")
Count to nQtdReg
DbGoTop()

ProcRegua(nQtdReg)

Do While !EOF()
	IncProc()

	AAdd(aVales,{	.f.,;					//01 - .T. Marcado .F. Desmarcado
					TRB->B6_DOC,;			//02 - Num Vale - Consignado
					TRB->B6_SERIE,;			//03 - Serie Vale
					TRB->B6_EMISSAO,;		//04 - Emissao Vale
					TRB->B6_PRODUTO,;		//05 - Codigo Produto
					AllTrim(TRB->B1_DESC),;	//06 - Descricao Produto
					TRB->D2_LOTECTL,;		//07 - Numero Lote
					TRB->D2_DTVALID,;		//08 - Validade Lote
					TransForm(TRB->B6_QUANT,"@E 99,999.99"),;	//09 - Quantidade Original Vale
					TransForm(TRB->B6_SALDO,"@E 99,999.99"),;	//10 - Quantidade Saldo Vale
					TransForm(TRB->D2_PRCVEN,"@E 999,999.999"),;	//11 - preco de venda
					TRB->B6_CLIFOR,;		//12 - Cliente Vale
					TRB->B6_LOJA,;			//13 - Loja Cliente
					TRB->D2_ITEM,;			//14 - Item no Vale Original
					TRB->B6_IDENT})		    //15 - Indent B6

	DbSkip()
EndDo

DbSelectArea("TRB")
DbCloseArea()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³JMH010SEL ºAutor  ³ Fabio Briddi       º Data ³  10/10/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Troca o Flag de Marcacao e Solicita Dados Aicionais        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ JMHA010                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function JMHF020SEL(nIt)

Local nPProduto	:= aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == 'C6_PRODUTO' } )
Local nPLocal   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_LOCAL" } )
Local nPUM      := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_UM" } )
Local nPLocal   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_LOCAL" } )
Local nPDescri  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_DESCRI" } )
Local nPSegUM   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_SEGUM" } )
Local nPConta   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_CONTA" } )
Local nPCCusto  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_CCUSTO" } )
Local nPItemCTB := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_ITEMCTB" } )

dbSelectArea("SB1")
dbSetOrder(1)
If ( !MsSeek(xFilial("SB1")+aVales[ nIt ][ 5 ],.F.) )
	Help(" ",1,"C6_PRODUTO")
	lContinua := .F.
	lRetorno  := .F.

Else

	gdFieldPut('C6_PRODUTO', aVales[ nIt ][ 5 ], n )
	gdFieldPut('C6_UM', SB1->B1_UM, n )
	gdFieldPut('C6_LOCAL', SB1->B1_LOCPAD, n )
	gdFieldPut('C6_DESCRI', PadR(SB1->B1_DESC,TamSx3("C6_DESCRI")[1]), n )
	gdFieldPut('C6_SEGUM', SB1->B1_SEGUM, n )
	gdFieldPut('C6_CONTA', SB1->B1_CTAREC, n )
	gdFieldPut('C6_CCUSTO', RetCCusto( aVales[nIt,5] ), n )
	gdFieldPut('C6_ITEMCTB', RetItCtb( M->C5_LOJACLI, aVales[nIt,5] ), n )
	gdFieldPut('C6_IDENTB6', aVales[nIt,15] , n )
	gdFieldPut('C6_QTDVEN', Val(aVales[nIt,10])*1 , n )//quando foi feito o transform o campo virou caracter
	gdFieldPut('C6_QTDREP', Val(aVales[nIt,10])*1 , n )//quando foi feito o transform o campo virou caracter
	//gdFieldPut('C6_PRCVEN', Val(aVales[nIt,11]) , n )
	gdFieldPut('C6_QTDLIB', Val(aVales[nIt,10])*1 , n )
	//gdFieldPut('C6_VALOR', (Val(aVales[nIt,10])*1) * (Val(aVales[nIt,11])) , n )
	gdFieldPut('C6_NFORI', aVales[nIt,2] , n )
	gdFieldPut('C6_SERIORI', aVales[nIt,3] , n )
	gdFieldPut('C6_ITEMORI', aVales[nIt,14] , n )
	gdFieldPut('C6_LOTECTL', aVales[nIt,7] , n )
	gdFieldPut('C6_DTVALID', aVales[nIt,8] , n )

EndIf

oDlgPrin:End()

Return()

/*
-----------------------------------------------------------------------------------------------------------------
*/

Static Function fGrava(nIt)
lTudoOk := .T.

cProduto    := aVales[nIt,05]
cItem       := Space(1)
cNumLote	:= Space(10)
dValidade	:= aVales[nIt,08] 

// posiciona no produto para validacoes
SB1->( dbSeek(xFilial('SB1')+cProduto) )

If nQtdeFat > Destrans(aVales[nIt,10])
	Alert("Quantidade a Faturar Maior que Saldo !")
	lTudoOk := .F.
EndIf
If nQtdeFat = 0
	Alert("Quantidade a Faturar Zerada !")
	lTudoOk := .F.
EndIf
If nPrcVend = 0
	Alert("Preço de Venda Zerado !")
	lTudoOk := .F.
EndIf

If SubStr(cItem,1,1) = "1"
	If nQtdeRep = 0
		Alert("Quantidade a Repor Zerada !")
		lTudoOk := .F.
	EndIf
	If nQtdeFat > Destrans(aVales[nIt,10])
		Alert("Quantidade a Faturar Maior que Saldo !")
		lTudoOk := .F.
	EndIf
	If SB1->B1_RASTRO <> 'N'
		If Empty(cNumLote)  // .Or. !ExistCpo("SB8",xFilial("SB8")+cProduto+cNumLote)
			Alert("Número do Lote em Branco !")
			lTudoOk := .F.
		Else
			// PRODUTO + LOCAL + DATA VALIDADE + LOTE + SUB-LOTE
			If ! SB8->( dbSeek(xFilial("SB8")+cProduto+cLocal+Dtos(dValidade)+cNumLote+cSubLote) )
				Alert("Número do Lote Inexistente !")
				lTudoOk := .F.
			Else
				dValidade := Posicione("SB8",5,xFilial("SB8")+cProduto+cNumLote,"B8_DTVALID")
			EndIf
		EndIf
	EndIf
EndIf

oVales:Refresh()

Return( lTudoOk )


********************************************************************************
Static Function SDTroca( nIt, aVetor )

If !aVetor[ nIt, 1 ] //Verifica se eh falso
	
	For i:=1 to Len(aVetor)
 	   If i == nIt
	      aVetor[ i, 1 ] := .t. //entao eh true
	      aVetor[ nIt, 1 ] := .t. //entao eh true
	   Else
		  aVetor[ i, 1 ] := .f. //entao eh true
	   EndIf
	Next
	
Else
	
	aVetor[ nIt, 1 ] := .f.
EndIf

Return( aVetor )

***********************************************************************************************
Static Function RetItCtb( cLoja, cCodProd )
Local cItemCtb    := Space(3)


SB1->( dbSeek(xFilial('SB1')+cCodProd) )

If SubStr(SB1->B1_CONTA,1,1) > '2'
	If cLoja == '02'
		cItemCtb := '102'
	Else
		cItemCtb := '101'
	EndIf
EndIf

Return( cItemCtb )


********************************************************************************
Static Function RetCCusto( cCodProd )
Local cCCusto    := Space(9)


SB1->( dbSeek(xFilial('SB1')+cCodProd) )

If SubStr(SB1->B1_CONTA,1,1) > '2'
	cCCusto    := '103103'
EndIf

Return( cCCusto )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ AjustaSX1  ³ Autor ³ FABIO BRIDDI        ³ Data ³09/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Definicao do Grupo de Perguntas da Rotina.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AjustaSx1(cPerg)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cPerg - Grupo de Perguntas                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ JOMHA010                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
*/

Static Function AjustaSX1(cPerg)

//..  Grupo Ordem Perguntas                   Var     Tip Tm Dc    GSC Vl   F3         Variavel  01 02 03 04 05
PutSx1(cPerg,"01","Da Emissão ?      ","","","mv_ch1","D",08,00,00,"G","",""   ,"","","MV_PAR01","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Até Emissão ?     ","","","mv_ch2","D",08,00,00,"G","",""   ,"","","MV_PAR02","","","","","","","","","","","","","","","","","")

Return