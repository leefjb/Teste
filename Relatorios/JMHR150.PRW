#include "protheus.ch"

#define _ITEM     1
#define _PRODUTO  2
#define _DESC     3
#define _UM       4
#define _QUANT    5
#define _DATPRF   6
#define _LOTE     7
#define _DATLOT   8
#define _QTDNF    9
#define _NUMNFE   10

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Original  ³ JMHR150  ³ Autor ³ Marllon Figueiredo    ³ Data ³09/08/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Recebimento de produtos - Inspecao - POP05                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Jomhedica / Faturamento                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function JMHR150()
SetPrvt("cCliente, nTamCli, cPedido, cItemPV, w_Mes, w_MesRet, w_DataEmi, n_NVias, nLin, cCidade")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN,NPOSD2,NPOSF2,W_NOREG")
SetPrvt("CPERG,NLASTKEY,LI,WNREL,WIMPRI,CSACADO,xCGC_EMP,xINSC_EMP,CCONVENIO,CSERIE,lLin")

Private cPerg := "JMHR150   "
Private oFont, oFont2, oFont3, oFont4, oFont5, oFont5b, oFont6, oFont7, oPrn

nHeight09  := 09
nHeight10  := 10
nHeight12  := 12
nHeight15  := 15
lBold	   := .F.
lUnderLine := .F.

oFont	:= TFont():New( "Arial",,nheight15   ,,lBold ,,,,,lUnderLine )
oFont2  := TFont():New( "Arial",,nheight15+12,,!lBold,,,,,lUnderLine )
oFont3  := TFont():New( "Arial",,nheight15+10,,!lBold,,,,,lUnderLine )
oFont4  := TFont():New( "Arial",,nheight15   ,,!lBold,,,,,lUnderLine )
oFont4b := TFont():New( "Arial",,nheight10   ,,!lBold,,,,,lUnderLine )
oFont5  := TFont():New( "Arial",,nheight12   ,,lBold,,,,,lUnderLine )
oFont5b := TFont():New( "Arial",,nheight12   ,,!lBold,,,,,lUnderLine )
oFont6  := TFont():New( "Arial",,nheight09   ,,lBold,,,,,lUnderLine )
oFont7  := TFont():New( "Arial",,nheight10-2 ,,lBold ,,,,,lUnderLine )


// grupo de perguntas
PutSx1( cPerg,"01","Pedido ?             ", "","","mv_ch1","C",6,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",,,)
PutSx1( cPerg,"02","Nota Fiscal ?        ", "","","mv_ch2","C",9,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",,,)

If ! Pergunte(cPerg,.T.)
	Return
EndIf

If SC7->( dbSeek(xFilial('SC7')+MV_PAR01) )
	Processa( {|| RptDetail() },"Imprimindo a ficha de inspeçao...","Aguarde....." )
Else
	MsgInfo('Pedido de Compra não Localizado!')
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Microsiga           º Data ³  05/30/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RptDetail()

Local aArea    := GetArea()
Local aAreaSC7 := SC7->( GetArea() )
Local aDados   := Array(0)

// recupera os itens do pedido
dbSelectArea('SD1')
dbOrderNickName('SD1001')

dbSelectArea('SC7')
Do While !Eof() .and. SC7->C7_FILIAL ==  xFilial("SC7") .and. SC7->C7_NUM == MV_PAR01
	SB1->( dbSeek(xFilial('SB1')+SC7->C7_PRODUTO) )

	If ! SD1->( dbSeek(xFilial('SD1')+SC7->C7_NUM+SC7->C7_ITEM) )
		Aadd( aDados, { SC7->C7_ITEM,;
		                SC7->C7_PRODUTO,;
		                SB1->B1_DESC,;
		                SB1->B1_UM,;
		                SC7->C7_QUANT,;
		                SC7->C7_DATPRF,;
		                '',;
		                Ctod(''),;
						0,;
		                '' } )
	Else
		Do While ! SD1->( Eof() ) .and. SD1->D1_PEDIDO == SC7->C7_NUM .and. SD1->D1_ITEMPC == SC7->C7_ITEM
			If SD1->D1_DOC == MV_PAR02 .or. Empty(MV_PAR02)
				Aadd( aDados, { SC7->C7_ITEM,;
				                SC7->C7_PRODUTO,;
				                SB1->B1_DESC,;
				                SB1->B1_UM,;
				                SC7->C7_QUANT,;
				                SC7->C7_DATPRF,;
				                SD1->D1_LOTECTL,;
				                SD1->D1_DTVALID,;
				                SD1->D1_QUANT,;
				                SD1->D1_DOC+'/'+SD1->D1_SERIE } )
			EndIf
			SD1->( dbSkip() )
		EndDo
	EndIf
	dbSkip()
Enddo

RestArea( aAreaSC7 )
RestArea( aArea )

// INICIA IMPRESSAO
oPrn := TMSPrinter():New('INSPECAO_POP05')
oPrn:SetLandScape(.T.)
oPrn:Setup()

nLin    := 5000
nCol    := 50
nIncr   := 50
nLagPag := 3250
cItem   := 'xxxx'

For nS := 1 To Len( aDados )
	If nLin > 2200
		ImpCabec()
    EndIf

	oPrn:Say( nLin, nCol+RC(01)+05, aDados[nS, _ITEM] , oFont6, 100 )
		oPrn:Line( nLin, nCol+RC(01), nLin+70, nCol+RC(01) )        // Linha
	oPrn:Say( nLin, nCol+RC(02)+05, aDados[nS, _PRODUTO] , oFont6, 100 )
		oPrn:Line( nLin, nCol+RC(02), nLin+70, nCol+RC(02) )        // Linha
	oPrn:Say( nLin, nCol+RC(03)+05, Substr(aDados[nS, _DESC],1,40) , oFont6, 100 )
		oPrn:Line( nLin, nCol+RC(03), nLin+70, nCol+RC(03) )        // Linha
	oPrn:Say( nLin, nCol+RC(04)+05, aDados[nS, _UM] , oFont6, 100 )
		oPrn:Line( nLin, nCol+RC(04), nLin+70, nCol+RC(04) )        // Linha

	// imprime a quantidade do pedido de compras apenas no primeiro item
	If cItem <> aDados[nS, _ITEM]
		oPrn:Say( nLin, nCol+RC(05)+05, Transform(aDados[nS, _QUANT], '999999') , oFont6, 100 )
	EndIf
	oPrn:Line( nLin, nCol+RC(05), nLin+70, nCol+RC(05) )        // Linha

	oPrn:Say( nLin, nCol+RC(06)+05, Dtoc(aDados[nS, _DATPRF]) , oFont6, 100 )
		oPrn:Line( nLin, nCol+RC(06), nLin+70, nCol+RC(06) )        // Linha

	oPrn:Say( nLin, nCol+RC(07)+05, aDados[nS, _LOTE] , oFont6, 100 )
		oPrn:Line( nLin, nCol+RC(07), nLin+70, nCol+RC(07) )        // Linha
	oPrn:Say( nLin, nCol+RC(08)+05, If(!Empty(aDados[nS, _DATLOT]), Dtoc(aDados[nS, _DATLOT]), '') , oFont6, 100 )
		oPrn:Line( nLin, nCol+RC(08), nLin+70, nCol+RC(08) )        // Linha
	oPrn:Say( nLin, nCol+RC(09)+05, Transform(aDados[nS, _QTDNF], '999999') , oFont6, 100 )
		oPrn:Line( nLin, nCol+RC(09), nLin+70, nCol+RC(09) )        // Linha
		oPrn:Line( nLin, nCol+RC(10), nLin+70, nCol+RC(10) )        // Linha
		oPrn:Line( nLin, nCol+RC(11), nLin+70, nCol+RC(11) )        // Linha
		oPrn:Line( nLin, nCol+RC(12), nLin+70, nCol+RC(12) )        // Linha
		oPrn:Line( nLin, nCol+RC(13), nLin+70, nCol+RC(13) )        // Linha
		oPrn:Line( nLin, nCol+RC(14), nLin+70, nCol+RC(14) )        // Linha
	oPrn:Say( nLin, nCol+RC(15)+05, aDados[nS, _NUMNFE] , oFont6, 100 )
		oPrn:Line( nLin, nCol+RC(15), nLin+70, nCol+RC(15) )        // Linha

	nLin += nIncr
	oPrn:Line( nLin, nCol+50, nLin, nCol+nLagPag )        // Linha

	cItem := aDados[nS, _ITEM]
Next

If nLin > 1700
	nLin   := 50
	nCol   := 50
	oPrn:EndPage()      // FECHAMENTO DA PAGINA
	oPrn:StartPage()	// INICIO DE PAGINA
EndIf
ImpRodape()

oPrn:EndPage()  // FECHAMENTO DA PAGINA
oPrn:Preview()
//oPrn:Print()

Return


Static Function ImpCabec()

	nLin   := 50
	nCol   := 50
	nIncr  := 60


	oPrn:EndPage()      // FECHAMENTO DA PAGINA
	oPrn:StartPage()	// INICIO DE PAGINA
	
	cBitMap := u_JMHF060()  //"logo_jomhedica.bmp"
	oPrn:SayBitmap( nLin, nCol+100, cBitMap, 800, 208 )

	nLin   += 220
	
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xfilial('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA) )
	
	oPrn:Line( nLin, nCol+50, nLin, nCol+nLagPag )        // Linha
	oPrn:Say( nLin+05, nCol+0250, "MBPF&C - POP 05 - RECEBIMENTO DE PRODUTOS  -  INSPEÇÃO DE RECEBIMENTO", oFont5b, 100 )
	nLin += nIncr
	oPrn:Line( nLin, nCol+50, nLin, nCol+nLagPag )        // Linha
	oPrn:Line( nLin, nCol+1100, nLin+70, nCol+1100 )  // Coluna
	oPrn:Say( nLin+05, nCol+0050, "N. DO PEDIDO DE COMPRA: " + MV_PAR01, oFont5b, 100 )
	If ! Empty(MV_PAR02)
		oPrn:Say( nLin+05, nCol+1150, 'N. NOTA FISCAL: ' + MV_PAR02, oFont5b, 100 )
	Else
		oPrn:Say( nLin+05, nCol+1150, 'N. NOTA FISCAL: ' + 'DIVERSAS', oFont5b, 100 )
	EndIf
	nLin += nIncr
	oPrn:Line( nLin, nCol+50, nLin, nCol+nLagPag )        // Linha
	oPrn:Line( nLin, nCol+1100, nLin+70, nCol+1100 )  // Coluna
	oPrn:Say( nLin+05, nCol+0050, SM0->M0_NOMECOM, oFont5, 100 )
	oPrn:Say( nLin+05, nCol+1150, SA2->A2_NOME, oFont5, 100 )
	nLin += nIncr
	oPrn:Line( nLin, nCol+50, nLin, nCol+nLagPag )        // Linha
	oPrn:Line( nLin, nCol+1100, nLin+70, nCol+1100 )  // Coluna
	oPrn:Say( nLin+05, nCol+0050, SM0->M0_ENDCOB, oFont5, 100 )
	oPrn:Say( nLin+05, nCol+1150, SA2->A2_END, oFont5, 100 )
	nLin += nIncr
	oPrn:Line( nLin, nCol+50, nLin, nCol+nLagPag )        // Linha
	oPrn:Line( nLin, nCol+1100, nLin+70, nCol+1100 )  // Coluna
	oPrn:Say( nLin+05, nCol+0050, 'CEP: '+SM0->M0_CEPCOB + '  ' + Substr(SM0->M0_CIDCOB,1,20) + '  ' + SM0->M0_ESTCOB , oFont5, 100 )
	oPrn:Say( nLin+05, nCol+1150, SA2->A2_CGC, oFont5, 100 )
	nLin += nIncr
	oPrn:Line( nLin, nCol+50, nLin, nCol+nLagPag )        // Linha
	oPrn:Line( nLin, nCol+1100, nLin+70, nCol+1100 )  // Coluna
	oPrn:Say( nLin+05, nCol+0050, 'TEL: '+SM0->M0_TEL + '   FAX: ' + SM0->M0_FAX , oFont5, 100 )
	oPrn:Say( nLin+05, nCol+1150, SA2->A2_CONTATO, oFont5, 100 )
	nLin += nIncr
	oPrn:Line( nLin, nCol+50, nLin, nCol+nLagPag )        // Linha
	oPrn:Line( nLin, nCol+1100, nLin+70, nCol+1100 )  // Coluna
	oPrn:Say( nLin+05, nCol+0050, 'CNPJ/CPF: '+SM0->M0_CGC + '  IE: ' + SM0->M0_INSC , oFont5, 100 )
	nLin += nIncr
	oPrn:Line( nLin, nCol+50, nLin, nCol+nLagPag )        // Linha
	oPrn:Say( nLin+05, nCol+0050, 'DADOS DO PEDIDO' , oFont5b, 100 )
	oPrn:Line( nLin, nCol+2100, nLin+70, nCol+2100 )  // Coluna
	oPrn:Say( nLin+05, nCol+2150, 'CONFERÊNCIA - NOTA FISCAL', oFont5b, 100 )
	nLin += nIncr
	oPrn:Line( nLin, nCol+50, nLin, nCol+nLagPag )        // Linha
	
	// cabecalho
	nLin += 05
	oPrn:Say( nLin, nCol+RC(01)+05, 'Item' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(02)+05, 'Código' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(03)+05, 'Descrição Material' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(04)+05, 'Un' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(05)+05, 'Qtd. PC' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(06)+05, 'Entrega' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(07)+05, 'Lote' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(08)+05, 'Venc.Lote' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(09)+05, 'Qtd. NF' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(10)+05, 'Embal.' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(11)+05, 'Quant.' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(12)+05, 'Ident.' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(13)+05, 'Lote' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(14)+05, 'Venc' , oFont4b, 100 )
	oPrn:Say( nLin, nCol+RC(15)+05, 'Num.NF' , oFont4b, 100 )
	nLin += nIncr
	oPrn:Line( nLin, nCol+50, nLin, nCol+nLagPag )        // Linha

Return


// define o tamanho das colunas
Static Function RC(nC)
Local nT
Local nPos := 0
Local aTC  := {050,120,350,950,080,150,150,250,180,150,120,120,120,120,120,300}

For nT := 1 To nC
	nPos += aTC[nT]
Next
	
Return(nPos)


// define o tamanho das colunas
Static Function ImpRodape()

	nLin += nIncr

	oPrn:Say( nLin, nCol+050, "INSTRUÇÕES PARA CONFERENCIA DOS PRODUTOS", oFont5b, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+150, "1º Identificação: No rótulo do produto verificar se apresenta código, descrição, data de fabricação e lote.", oFont5, 100 )
	nLin += nIncr+15
	oPrn:Say( nLin, nCol+150, "2º Lote: No rótulo do produto verificar se o lote corresponde ao informado Nota Fiscal.", oFont5, 100 )
	nLin += nIncr+15
	oPrn:Say( nLin, nCol+150, "3º Vencimento: No rótulo do produto verificar o vencimento. Deve ser superior a um ano.", oFont5, 100 )
	nLin += nIncr+15
	oPrn:Say( nLin, nCol+150, "4º Embalagem: Verificar a integridade das embalagens, elas devem estar bem fechadas, isentas de sujeira e umidade.", oFont5, 100 )
	nLin += nIncr+15
	oPrn:Say( nLin, nCol+150, "5º Quantidade: Verifica-se a quantidade de cada item. Deve ser igual ao informado na Nota Fiscal.", oFont5, 100 )
	nLin += nIncr+25
	oPrn:Say( nLin, nCol+150, "Assinale com a letra 'C' para conformidade ou 'NC' para não conformidade aos quesitos relacionados acima.", oFont5, 100 )
	nLin += nIncr+15
	oPrn:Say( nLin, nCol+150, "Emissão de RNC      (     ) Sim  nº_________     (    ) Não", oFont5b, 100 )
	nLin += nIncr+15
	oPrn:Say( nLin, nCol+150, "Conferido por:__________________________________________   Em: __/___/______.", oFont5b, 100 )

Return
