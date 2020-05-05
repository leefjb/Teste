#include "rwmake.ch"
#include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ JMHA110  ³ Adatp ³ Fabio Briddi          ³ Data ³ 29/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´±±
±±³Original  ³ ARTP020  ³ Autor ³ Marllon Figueiredo    ³ Data ³ 19/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Pick List Pedidos de Vendas                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Jomhedica / Faturamento                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function JMHA110()

Private	cPerg      := PadR("JMHA110",Len(SX1->X1_GRUPO)," ")

//+----------------------------------------------------------------------------
//| Cria as perguntas em SX1
//+----------------------------------------------------------------------------
//      Grupo,cOrdem,cPergunt  ,cPerSpa,cPerEng,cVar    ,cTipo,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3,cGrpSxg,cPyme,cVar01    ,cDef01,cDefSpB1,cDefEng1,cCnt01,cDef02          ,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
PutSx1( cPerg,"01"  ,"Pedido ?",""     ,""     ,"mv_ch1","C"  ,006     ,       0,      0,"G" ,""    , "SC5",     "",   "","mv_par01",""    ,""      ,""      ,""    ,""              ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""      ,""      ,""      ,"")

Do While .t.
	If Pergunte(cPerg,.T.)
		PVConfere()
	Else
		Exit
	EndIf
EndDo

Return


//---------------------------------------------------------------------------
// processamento da conferencia
Static Function PVConfere()
//-- Genericas
//-- Dialog
Local aButtons		:= {}
Local oDlgEsp

//-- Cabecalho

//-- ListBox

//-- Controle de dimensoes de objetos
Local aObjects		:= {}
Local aInfo			:= {}
Private aPosObj := {}


//-- Enchoice 
Private aTela[0][0]
Private aGets[0]
Private oPanel
Private oPanel1

//-- GetDados
Private oGetD


//-- Cabecalho


//-- RodaPe
Private oPanel2
Private oMsgLin1, oMsgLin2, oMsgLin3, oStatus

Private	lOk        := .F.
Private	nTamCodProd:= TamSX3("B1_COD")[1]
//Private	nTamCodBar := TamSX3("B1_CODBAR")[1]
Private	nTamCodBar := TamSX3("B1_COD")[1]
Private	nTamLote   := TamSX3("B8_LOTECTL")[1]
Private	cCodProd   := Space(nTamCodProd)
Private	cCodBar    := Space(nTamCodBar)
Private nBuffer    := 33    // CODPROD / LOTE / VALIDADE / LOTEFOR
Private	cLeitura   := Space(nBuffer)
Private	cLote      := Space(nTamLote)
Private nQtd       := 1
Private	aList      := Array(0) //-- Array para uso na ListBox, este Array pode ser incrementado durante o processameno
Private	aItens     := Array(0) //-- Array para controle dos Itens do Pedido (exatamente igual ao aCols do Pedido), este Array nao sofre alteracoes durante o processamento
Private	aProdLote  := Array(0) //-- Array para controle de Saldo Lote (Somente Produto, Lote e Qtde ja Separada no Pedido)

Private nPosSldLote := 0


//-- Definicao das colunas da ListBox
Private nPos_ITEMPV  := 1
Private nPos_COD     := 2
Private nPos_DESC    := 3
Private nPos_QTDVEN  := 4
Private nPos_QTDSEP  := 5
Private nPos_LOTECTL := 6
Private nPos_DTVALID := 7
Private nPos_SLDSB8  := 8
Private nPos_CODBAR  := 2  //9
Private nPos_SEQ     := 10
Private nPos_RASTRO  := 11
Private nPos_RECNO   := 12
Private nPos_TESEST  := 13
Private nPos_VAZIO   := 14

Private lBloqueia    := .f.

aAdd( aButtons, { 'EDITABLE', { || InputQtd() },  'Quantidade' } )
aAdd( aButtons, { 'EDITABLE', { || InputBlq() },  'Bloqueia' } )
//aAdd( aButtons, { 'EDITABLE', { || Reconfere() }, 'Reconfere' } )

//-- Dimensoes padroes
aSize := MsAdvSize()
AAdd( aObjects, { 100, 015, .T., .T. } ) // -- Coordenadas do Cabecalho (enchoice)
AAdd( aObjects, { 100, 060, .T., .T. } ) // -- Coordenadas do GetDados
AAdd( aObjects, { 100, 030, .T., .T. } ) // -- Coordenadas do RodaPe
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj := MsObjSize( aInfo, aObjects,.T.)


	DbSelectArea("SC6")
	DbSetOrder(1)
	If DbSeek(xFilial("SC6")+MV_PAR01, .T.)
		cNumPv	:= SC6->C6_NUM
		cCodCli	:= SC6->C6_CLI
		cLojCli	:= SC6->C6_LOJA
		cNomCli	:= Posicione("SA1",1,xFilial("SA1")+cCodCli+cLojCli,"A1_NOME")

		Do	While !Eof() .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == MV_PAR01
			// verifica se tem saldo a liberar
			If SC6->C6_QTDVEN - SC6->C6_QTDENT - SC6->C6_QTDEMP <= 0
				DbSelectArea('SC6')
				DbSkip()
				Loop
			EndIf
			
			// posiciona nos registros
			SB1->( dbSeek(xFilial('SB1')+SC6->C6_PRODUTO) )
			SF4->( dbSeek(xFilial('SF4')+SC6->C6_TES) )

			AAdd(aList,Array(nPos_VAZIO))
			aList[Len(aList),nPos_ITEMPV]  := SC6->C6_ITEM
			aList[Len(aList),nPos_COD]     := SC6->C6_PRODUTO
			aList[Len(aList),nPos_DESC]    := Left(SB1->B1_DESC,40)
			aList[Len(aList),nPos_QTDVEN]  := SC6->C6_QTDVEN - SC6->C6_QTDENT - SC6->C6_QTDEMP  //SC6->C6_QTDVEN
			aList[Len(aList),nPos_QTDSEP]  := 0
			aList[Len(aList),nPos_LOTECTL] := ""
			aList[Len(aList),nPos_DTVALID] := Ctod("")
			aList[Len(aList),nPos_SLDSB8]  := 0
			aList[Len(aList),nPos_CODBAR]  := SB1->B1_COD   //SB1->B1_CODBAR
			aList[Len(aList),nPos_RASTRO]  := (SB1->B1_RASTRO == "L")
			aList[Len(aList),nPos_SEQ]     := 1
			aList[Len(aList),nPos_RECNO]   := SC6->(RecNo())
			aList[Len(aList),nPos_TESEST]  := Iif(SF4->F4_ESTOQUE=='S',.T.,.F.)
			aList[Len(aList),nPos_VAZIO]   := ""

			AAdd(aItens,Array(nPos_VAZIO))
			aItens[Len(aItens),nPos_ITEMPV]  := SC6->C6_ITEM
			aItens[Len(aItens),nPos_COD]     := SC6->C6_PRODUTO
			aItens[Len(aItens),nPos_DESC]    := Left(SB1->B1_DESC,40)
			aItens[Len(aItens),nPos_QTDVEN]  := SC6->C6_QTDVEN - SC6->C6_QTDENT - SC6->C6_QTDEMP  //SC6->C6_QTDVEN
			aItens[Len(aItens),nPos_QTDSEP]  := 0
			aItens[Len(aItens),nPos_LOTECTL] := ""
			aItens[Len(aItens),nPos_DTVALID] := Ctod("")
			aItens[Len(aItens),nPos_SLDSB8]  := 0
			aItens[Len(aItens),nPos_CODBAR]  := SB1->B1_COD   //SB1->B1_CODBAR
			aItens[Len(aItens),nPos_RASTRO]  := (SB1->B1_RASTRO == "L")
			aItens[Len(aItens),nPos_SEQ]     := 1
			aItens[Len(aItens),nPos_RECNO]   := SC6->(RecNo())
			aItens[Len(aItens),nPos_TESEST]  := Iif(SF4->F4_ESTOQUE=='S',.T.,.F.)
			aItens[Len(aItens),nPos_VAZIO]   := ""

			If (nPosSldLote := AScan(aProdLote, { |x| x[nPos_CODBAR] + x[nPos_LOTECTL] == SB1->B1_COD + SC6->C6_LOTECTL })) = 0
				AAdd(aProdLote,Array(nPos_VAZIO))
				nPosSldLote := Len(aProdLote)
			EndIf
			aProdLote[nPosSldLote,nPos_COD]     := SC6->C6_PRODUTO
			aProdLote[nPosSldLote,nPos_QTDSEP]  := 0
			aProdLote[nPosSldLote,nPos_SLDSB8]  := 0
			aProdLote[nPosSldLote,nPos_LOTECTL] := SC6->C6_LOTECTL
			aProdLote[nPosSldLote,nPos_CODBAR]  := SB1->B1_COD   //SB1->B1_CODBAR
			aProdLote[nPosSldLote,nPos_RASTRO]  := (SB1->B1_RASTRO == "L")

			DbSelectArea('SC6')
			DbSkip()
		EndDo
		
		// testa se encontrou algum registro, pois o array nao pode ser passado vazio para a listbox
		If !Empty(aList)

			ASort(aList,,, {|x,y| x[nPos_ITEMPV] + x[nPos_CODBAR] + StrZero(x[nPos_SEQ],3) <  y[nPos_ITEMPV] + y[nPos_CODBAR] + StrZero(y[nPos_SEQ],3)})

			Define MsDialog oDlgEsp Title 'Pedido de Venda' From aSize[7],00 To aSize[6],aSize[5] Pixel // -- Monta a Janela maior onde montara o Enchoice e o GetDados
			Define Font oBold Name "Arial" Size 000, 030 Bold
			
				//-- Dados do Cabecalho
				@ (aPosObj[1,1]) , (aPosObj[1,2]) To (aPosObj[1,3]), (aPosObj[1,4]) Label "" Pixel Of oPanel1
			
				@ (aPosObj[1,1]+005), (015)	Say	"Número Pedido :" Pixel
			  	@ (aPosObj[1,1]+005), (070)	MsGet oGetA	var	cNumPv	Picture	"@!"	Size (030), (005) Of oDlgEsp Pixel When .F. //INCLUI
			  
				@ (aPosObj[1,1]+005), (160)	Say	"Cliente :" Pixel
				@ (aPosObj[1,1]+005), (210)	MsGet oGetB	var	cCodCli	Picture	"@!"	Size 030,010 Of oDlgEsp Pixel When .F.
				@ (aPosObj[1,1]+005), (240)	MsGet oGetC	var	cLojCli	Picture	"@!"	Size 020,010 Of oDlgEsp Pixel When .F.
				@ (aPosObj[1,1]+005), (270)	MsGet oGetD	var	cNomCli	Picture	"@!"	Size 170,010 Of oDlgEsp Pixel When .F.
			
				@ (aPosObj[1,1]+020), (015)	Say	"Leitura:" Pixel
				@ (aPosObj[1,1]+020), (035) MsGet oGetLeit Var cLeitura  SIZE 200,10 Pixel VALID ((ValProd(oList) .and. ValItem(oList)) .or. Empty(cLeitura)) WHEN ! lBloqueia

				//-- Monta a ListBox
				@ (aPosObj[ 2, 1 ]), (aPosObj[ 2, 2 ])	LISTBOX oList ;
								FIELDS HEADER  'Item','Produto','Descricao','Vendido','Separado','Num.Lote','Dt Validade','Saldo Lote','','';
								SIZE (aPosObj[ 2, 4 ]), (aPosObj[ 2, 3 ]-aPosObj[ 2, 1 ]) ;
								PIXEL OF oDlgEsp
			
			 	oList:SetArray(aList)
				oList:bLine:={|| {	aList[oList:nAt, nPos_ITEMPV ],;
									aList[oList:nAt, nPos_COD    ],;
									aList[oList:nAt, nPos_DESC   ],;
									aList[oList:nAt, nPos_QTDVEN ],;
									aList[oList:nAt, nPos_QTDSEP ],;
									aList[oList:nAt, nPos_LOTECTL],;
									Dtoc(aList[oList:nAt, nPos_DTVALID]),;
									aList[oList:nAt, nPos_SLDSB8 ],;
									aList[oList:nAt, nPos_CODBAR ],;
									aList[oList:nAt, nPos_SEQ    ]}}
				oList:Refresh()
				
				//-- Dados do RodaPe
				@ (aPosObj[3,1]) , (aPosObj[3,2]) To (aPosObj[3,3]), (aPosObj[3,4]) Label ' Última Leitura / Mensagens ' Pixel Of oPanel2
			
				@ (aPosObj[3,1]+010), (010) Say oMsgLin1 PROMPT '' Size 600,015 Of oDlgEsp Pixel Font oBold COLOR CLR_HBLUE //-- Primeira Linha de Informcoes no Rodape 
				@ (aPosObj[3,1]+030), (010) Say oMsgLin2 PROMPT '' Size 600,015 Of oDlgEsp Pixel Font oBold COLOR CLR_HBLUE //-- Segunda Linha de Informcoes no Rodape
				@ (aPosObj[3,1]+050), (010) Say oMsgLin3 PROMPT '' Size 600,015 Of oDlgEsp Pixel Font oBold COLOR CLR_RED //-- Terceira Linha de Informcoes no Rodape

				@ (aPosObj[3,1]+010), (aPosObj[3,4]-100) Say oStatus PROMPT '' Size 100,015 Of oDlgEsp Pixel Font oBold COLOR CLR_RED //-- Status: Qtde Pedida X Lidas

			//Activate MsDialog oDlgEsp On Init EnchoiceBar( oDlgEsp , {||IIf(ValGeral(),oDlgEsp:End(),oGetCod:SetFocus())} , {||IIf(Iw_MsgBox("Abandona Rotina ?","","YESNO"),oDlgEsp:End(),oGetCod:SetFocus())} , , aButtons )
			Activate MsDialog oDlgEsp On Init EnchoiceBar( oDlgEsp , {||IIf(ValGeral(),oDlgEsp:End(),oGetLeit:SetFocus())} , {||IIf(Iw_MsgBox("Abandona Rotina ?","","YESNO"),oDlgEsp:End(),oGetLeit:SetFocus())} , , aButtons )

		Else
			Iw_MsgBox("Número Pedido Inválido!","","INFO")
		EndIf
	Else
		Iw_MsgBox("Número Pedido Inválido!","","INFO")
	EndIf
	
Return()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunçào	 ³ ValProd  ºAutor  ³ Fabio Briddi       º Data ³ 25/03/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se o Produto Lido                                   º±±
±±º          ³ Se Controla Rastro tem de Informar Lote                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValProd()
Local nPos       := 0
Local aArea      := GetArea()
Local lOkProd    := .F.
Local lOkCont    := .F.
Local lOkLote    := .T.

cCodBar  := Substr(cLeitura,1,nTamCodBar)
cLote    := Substr(cLeitura,nTamCodBar+1,nTamLote)

// debug
//msginfo('VALPROD  ['+cCodBar+'] - ['+cLote+']')

If ! lBloqueia

	If ! Empty(cCodBar)
		//-- Primeiro procuro pelo produto, para validar a leitura. Se produto nao esta no pedido nao segue
		For	nPosItens := 1 To Len(aItens)
			If	aItens[nPosItens,nPos_CODBAR] == cCodBar
				cItemPv := aItens[nPosItens,nPos_ITEMPV]
				cCodProd := aItens[nPosItens,nPos_COD]
				lOkProd := .T.
				//-- Destaco o Produto lido no Rodape
				oMsgLin1:SetText(aItens[nPosItens,nPos_COD]+' Lote: '+cLote)
				oMsgLin2:SetText(aItens[nPosItens,nPos_DESC])
				oMsgLin3:SetText("")
				oStatus:SetText(StrZero(aItens[nPosItens,nPos_QTDVEN],3)+" / "+StrZero(aItens[nPosItens,nPos_QTDSEP],3))
	
				//-- Localizo Item+Produto no Array da ListBox
				nPosProd := AScan(aList, {|x| x[nPos_ITEMPV] + x[nPos_CODBAR] == aItens[nPosItens,nPos_ITEMPV] + aItens[nPosItens,nPos_CODBAR]})
	
				//-- Verifico se a Contagem do Item+Produto ja nao foi atendida totalmente
				If	aItens[nPosItens,nPos_QTDSEP] < aItens[nPosItens,nPos_QTDVEN]
					//-- Testo se Produto Controla Lote - e o TES movimenta estoque
					If	aItens[nPosItens,nPos_RASTRO] .and. aItens[nPosItens,nPos_TESEST]
						lOkLote := .F.
					Else
						lOkLote := .T.
						lOkProd := .T.
						//aList[nPosProd,nPos_QTDSEP]        += nQtd //-- Incremento 1 na Contagem do Item+Produto+Lote
						//aItens[nPosItens,nPos_QTDSEP]      += nQtd //-- Incremento 1 na COntagem do Item+Produto
						//aProdLote[nPosSldLote,nPos_QTDSEP] += nQtd //-- Incremento 1 na Contagem do Produto + Lote
					EndIf
					Exit //-- Sai do Looping para nao Incremetar em 2 produtos iguais no mesmo Pedido
				EndIf
			EndIf
		Next
	
		If ! lOkProd //-- Nao encontrei Produto no Pedido
			oMsgLin3:SetText("Leitura Inválida para este Produto!")
			oStatus:SetText("")
			//-- Limpo, atualizo e devolvo o foco das Variaveis para a proxima leitura
			cCodBar  := Space(nTamCodBar)
			cLote    := Space(nTamLote)
			cLeitura := Space(nBuffer)
			oList:Refresh()
			oGetLeit:SetFocus()
		EndIf
	Else
		oMsgLin3:SetText("Leitura Inválida! (valprod)")
		oStatus:SetText("")
	EndIf

EndIf

RestArea(aArea)

Return(.T.)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunçào	 ³ ValItem  ºAutor  ³ Fabio Briddi       º Data ³ 29/01/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se o Produto e Lote podem ser separados para o      º±±
±±º          ³ Pedido se a quantidade total ja foi separada               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValItem()
Local nPos       := 0
Local aArea      := GetArea()
Local lOkProd    := .F.
Local lOkCont    := .F.
Local lOkLote    := .T.
Local lSldLote   := .T.

cCodBar  := Substr(cLeitura,1,nTamCodBar)
cLote    := Substr(cLeitura,nTamCodBar+1,nTamLote)

// debug
//msginfo('VALITEM   ['+cCodBar+'] - ['+cLote+']')

If ! lBloqueia

	If ! Empty(cCodBar) .and. ! Empty(cLote)
		//-- Primeiro procuro pelo produto, para validar a leitura. Se produto nao esta no pedido nao segue
		For	nPosItens := 1 To Len(aItens)
			If	aItens[nPosItens,nPos_CODBAR] == cCodBar
				cItemPv := aItens[nPosItens,nPos_ITEMPV]
				cCodProd := aItens[nPosItens,nPos_COD]
				lOkProd := .T.
				//-- Destaco o Produto lido no Rodape
				oMsgLin1:SetText(aItens[nPosItens,nPos_COD]+' Lote: '+cLote)
				oMsgLin2:SetText(aItens[nPosItens,nPos_DESC])
				oMsgLin3:SetText("")
				oStatus:SetText(StrZero(aItens[nPosItens,nPos_QTDVEN],3)+" / "+StrZero(aItens[nPosItens,nPos_QTDSEP],3))
				//-- Verifico se a Contagem do Item+Produto ja nao foi atendida totalmente
				If	aItens[nPosItens,nPos_QTDSEP] < aItens[nPosItens,nPos_QTDVEN]
					//-- Testo se Produto+Lote Existe no SB8
					If ValLote(cCodProd, cLote)
						//aList[nPosItens,nPos_DTVALID] := SB8->B8_DTVALID
						lOkLote := .T.
						//-- Localizo Item+Produto no Array da ListBox
						nPosProd    := AScan(aList, {|x| x[nPos_ITEMPV] + x[nPos_CODBAR] == aItens[nPosItens,nPos_ITEMPV] + aItens[nPosItens,nPos_CODBAR]})
						//-- Localizo Item+Produto no Array da Produtos e Lote
						If	(nPosSldLote := AScan(aProdLote, { |x| x[nPos_CODBAR] + x[nPos_LOTECTL] == cCodBar + cLote })) = 0
							AAdd(aProdLote,Array(nPos_VAZIO))
							nPosSldLote := Len(aProdLote)
							aProdLote[nPosSldLote,nPos_COD]     := cCodProd
							aProdLote[nPosSldLote,nPos_QTDSEP]  := 0
							aProdLote[nPosSldLote,nPos_SLDSB8]  := (SB8->B8_SALDO - SB8->B8_EMPENHO)
							aProdLote[nPosSldLote,nPos_LOTECTL] := cLote
							aProdLote[nPosSldLote,nPos_CODBAR]  := cCodBar
						Else
							aProdLote[nPosSldLote,nPos_SLDSB8]  -= nQtd
						EndIf
						If	(aProdLote[nPosSldLote,nPos_SLDSB8] - nQtd) < 0
							lOkLote := .F.
							lSldLote := .F.
							Exit
						EndIf
						If	Empty(aList[nPosProd,nPos_LOTECTL]) //-- Ainda nao foi lido nenhuma vez
							aList[nPosItens,nPos_DTVALID]      := SB8->B8_DTVALID
							aList[nPosProd,nPos_LOTECTL]       := cLote
							aList[nPosProd,nPos_QTDSEP]        += nQtd //-- Incremento 1 na Contagem do Item+Produto+Lote
							aItens[nPosItens,nPos_QTDSEP]      += nQtd //-- Incremento 1 na COntagem do Item+Produto
							aProdLote[nPosSldLote,nPos_QTDSEP] += nQtd //-- Incremento 1 na Contagem do Produto + Lote
							oStatus:SetText(StrZero(aItens[nPosItens,nPos_QTDVEN],3)+" / "+StrZero(aItens[nPosItens,nPos_QTDSEP],3))
							lOkCont := .T.
							Exit //-- Sai do Looping para nao Incremetar em 2 produtos iguais no mesmo Pedido
						Else
							//-- Verifico se ja foi lido este Lote para este item do pedido
							If	(nPosProd := AScan(aList, { |x| x[nPos_ITEMPV] + x[nPos_CODBAR] + x[nPos_LOTECTL] == cItemPv + cCodBar + cLote })) > 0
								//-- Encotrando Item+Produto+Lote basta incrementar a contagem
								aList[nPosProd,nPos_QTDSEP]        += nQtd //-- Incremento 1 na Contagem do Item+Produto+Lote
								aItens[nPosItens,nPos_QTDSEP]      += nQtd //-- Incremento 1 na Contagem do Item+Produto
								aProdLote[nPosSldLote,nPos_QTDSEP] += nQtd //-- Incremento 1 na Contagem do Produto + Lote
								oStatus:SetText(StrZero(aItens[nPosItens,nPos_QTDVEN],3)+" / "+StrZero(aItens[nPosItens,nPos_QTDSEP],3))
								lOkCont := .T.
								Exit //-- Sai do Looping para nao Incremetar em 2 produtos iguais no mesmo Pedido
							Else
								//-- Adiciono nova linha no Aaray da ListBox em uma nova sequencia com o Lote lido
								aItens[nPosItens,nPos_SEQ]    += nQtd //-- Incremento 1 na Sequencia do Item+Produto
								AAdd(aList,Array(nPos_VAZIO))
								nPosProd := Len(aList)
								aList[nPosProd,nPos_ITEMPV]        := aItens[nPosItens,nPos_ITEMPV]
								aList[nPosProd,nPos_COD]           := aItens[nPosItens,nPos_COD]
								aList[nPosProd,nPos_DESC]          := aItens[nPosItens,nPos_DESC]
								aList[nPosProd,nPos_QTDVEN]        := 0
								aList[nPosProd,nPos_QTDSEP]        := 0
								aList[nPosProd,nPos_LOTECTL]       := cLote
								aList[nPosProd,nPos_DTVALID]       := SB8->B8_DTVALID
								aList[nPosProd,nPos_CODBAR]        := aItens[nPosItens,nPos_CODBAR]
								aList[nPosProd,nPos_SEQ]           := aItens[nPosItens,nPos_SEQ]
								aList[nPosProd,nPos_RECNO]         := aItens[nPosItens,nPos_RECNO]
								aList[nPosProd,nPos_VAZIO]         := ""
								aList[nPosProd,nPos_QTDSEP]        += nQtd //-- Incremento 1 na Contagem do Item+Produto+Lote
								aItens[nPosItens,nPos_QTDSEP]      += nQtd //-- Incremento 1 na Contagem do Item+Produto
								aProdLote[nPosSldLote,nPos_QTDSEP] += nQtd //-- Incremento 1 na Contagem do Produto + Lote
								//-- Reordeno o Array da ListBox e atualizo na tela
								ASort(aList,,, {|x,y| x[nPos_ITEMPV] + x[nPos_CODBAR] + StrZero(x[nPos_SEQ],3) <  y[nPos_ITEMPV] + y[nPos_CODBAR] + StrZero(y[nPos_SEQ],3)})
								oStatus:SetText(StrZero(aItens[nPosItens,nPos_QTDVEN],3)+" / "+StrZero(aItens[nPosItens,nPos_QTDSEP],3))
								oList:Refresh()
								lOkCont := .T.
								Exit //-- Sai do Looping para nao Incremetar em 2 produtos iguais no mesmo Pedido
							EndIf
						EndIf
					Else
						lOkLote := .F.
						Exit //-- Sai do Looping para nao Incremetar em 2 produtos iguais no mesmo Pedido
					EndIf
				EndIf
			EndIf
		Next
	
		If ! lOkProd //-- Nao encontrei Produto no Pedido
			oMsgLin3:SetText("Leitura Inválida para este Produto!")
			oStatus:SetText("")
		Else
			If ! lOkLote //-- Encontrei Produto mas Lote e invalido 
				If	lSldLote
					oMsgLin3:SetText("Lote Inválido para este Produto!")
				Else
					oMsgLin3:SetText("Lote Sem Saldo!")
				EndIf
			Else
				If	!lOkCont //-- Encontrei Produto mas nao contado no Pedido
					oMsgLin3:SetText("Produto Totamente Separado!")
				Else
					//-- Atualiza Saldo SB8 no ListBox (B8_SALDO - B8_EMPENHO - menos qtde ja contado)
					For nTmp := 1 To Len(aList)
						If	(aList[nTmp,nPos_CODBAR] == cCodBar) .And. (aList[nTmp,nPos_LOTECTL] == cLote)
							aList[nTmp,nPos_SLDSB8] := ((SB8->B8_SALDO-SB8->B8_EMPENHO)-aProdLote[nPosSldLote,nPos_QTDSEP])
						EndIf
					Next
				EndIf
			EndIf
		EndIf
	EndIf
	
	//-- Limpo, atualizo e devolvo o foco das Variaveis para a proxima leitura
	cCodBar  := Space(nTamCodBar)
	cLote    := Space(nTamLote)
	cLeitura := Space(nBuffer)
	nQtd     := 1
	oList:Refresh()
	oGetLeit:SetFocus()

EndIf

RestArea(aArea)

Return(.T.)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ValLote  ³ Autor   ³ Fabio Briddi           ³ Data ³23/02/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Valida se Lote e valido para o Prodduto                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValLote(_cCodProd,_cLote)
Local lRet := .T.

DbSelectArea("SB8")
DbSetOrder(5) //Filial + Produto + Lote
If ! DbSeek(xFilial("SB8")+_cCodProd+_cLote,.F.)
	lRet := .F.
EndIf

Return(lRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ValGeral ³ Autor   ³ Fabio Briddi           ³ Data ³23/02/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Valida se encerra a Leitura dos Itens do Pedido              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValGeral()
Local lRet := .F.
Local lLibParcial := .F.

For	nPosItens := 1 To Len(aItens)
	If	aItens[nPosItens,nPos_QTDSEP] < aItens[nPosItens,nPos_QTDVEN]
		lLibParcial := .T.
	EndIf
Next

If	lLibParcial
	If	Iw_MsgBox("Confirma Liberação Parcial do Pedido ?","","YESNO")
		lRet := .T.
	EndIf
Else
	If	Iw_MsgBox("Confirma Liberação Pedido ?","","YESNO")
		lRet := .T.
	EndIf
EndIf



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Parametros³01³ExpN1: Registro do SC6                                      ³±±
±±³          ³02³ExpN2: Quantidade a Liberar                                 ³±±
±±³          ³03³ExpL3: Bloqueio de Credito                                  ³±±
±±³          ³04³ExpL4: Bloqueio de Estoque                                  ³±±
±±³          ³05³ExpL5: Avaliacao de Credito                                 ³±±
±±³          ³06³ExpL6: Avaliacao de Estoque                                 ³±±
±±³          ³07³ExpL7: Permite Liberacao Parcial                            ³±±
±±³          ³08³ExpL8: Tranfere Locais automaticamente                      ³±±
±±³          ³09³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
±±³          ³10³       apenas avalia ).                                     ³±±
±±³          ³11³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
±±³          ³12³ExpAB: Array com Empenhos previamente escolhidos            ³±±
±±³          ³13³       (impede selecao dos empenhos pelas rotinas)          ³±±
±±³          ³14³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
±±³          ³15³ExpND: Valor a ser adicionado ao limite de credito          ³±±
±±³          ³16³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
MaLibDoFat(nRegSC6,nQtdaLib,lCredito,lEstoque,lAvCred,lAvEst,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lOkExpedicao,nVlrCred,nQtdalib2)
/*/

If	lRet
	Begin Transaction
		For	nPosList := 1 To Len(aList)

			If	aList[nPosList,nPos_QTDSEP] > 0
				nRecnoSC6 := aList[nPosList,nPos_RECNO]
				nQtdeSep  := aList[nPosList,nPos_QTDSEP]
				DbSelectArea("SC6")
				SC6->(DbGoTo(nRecnoSC6))
				RecLock("SC6",.F.)
				SC6->C6_LOTECTL := aList[nPosList,nPos_LOTECTL]
				SC6->C6_DTVALID := aList[nPosList,nPos_DTVALID]
				MsUnLock()

//				MaLibDoFat(01       ,02      ,03      ,04      ,05     ,06    ,07     ,08       ,09      ,10    ,11        ,12       ,13          ,14      ,15       )
//				MaLibDoFat(nRegSC6  ,nQtdaLib,lCredito,lEstoque,lAvCred,lAvEst,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lOkExpedicao,nVlrCred,nQtdalib2)
				MaLibDoFat(nRecnoSC6,nQtdeSep,.F.     ,.F.     ,.T.    ,.T.   ,.T.    ,.T.      ,        ,      ,          ,         ,            ,        ,         )

				DbSelectArea("SC6")
				SC6->(DbGoTo(nRecnoSC6))
				RecLock("SC6",.F.)
				SC6->C6_LOTECTL := ""
				SC6->C6_DTVALID := CTOD("")
				MsUnLock()

			EndIf

		Next

		// forca o flag do SC5
		SC5->( dbSeek(xFilial('SC5')+SC6->C6_NUM) )
		SC5->( RecLock('SC5', .f.) )
		SC5->C5_LIBEROK := 'S'
		SC5->( msUnLock() )
	
	End Transaction
EndIf

Return(lRet)


//-----------------------------------------------------------------------------
// quando necessitar informar uma quantidade grande do mesmo produto
Static function InputQtd()

	Local oTela001
	Local nQuant   := 1

	@ 000,000 TO 150,350 DIALOG oTela001 TITLE "Quantidade da Leitura"
	@ 020,010 SAY "Quantidade:" PIXEL
	@ 020,050 Get nQuant Picture '999999' PIXEL
	@ 050,050 BUTTON "Confirma"   Size 40,15 ACTION (oTela001:End()) PIXEL
	ACTIVATE DIALOG oTela001 CENTERED

	nQtd := nQuant
	//oGetQtd:Refresh()
	oGetLeit:SetFocus()
	
Return


//------------------------------------------------------------------------------------------------
Static Function InputBlq()

lBloqueia := ! lBloqueia

If ! lBloqueia
	oGetLeit:SetFocus()
EndIf

Return


//------------------------------------------------------------------------------------------------
Static Function Reconfere()

For	nPosItens := 1 To Len(aList)

// nao faz nada na jomhedica

Next

Return
