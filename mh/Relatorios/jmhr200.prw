#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Original  ³ JMHR200  ³ Autor ³ Marllon Figueiredo    ³ Data ³09/08/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do vale de consignados                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Jomhedica / Faturamento                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function JMHR200()
SetPrvt("cCliente, nTamCli, cPedido, cItemPV, w_Mes, w_MesRet, w_DataEmi, n_NVias, nLin, cCidade")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN,NPOSD2,NPOSF2,W_NOREG")
SetPrvt("CPERG,NLASTKEY,LI,WNREL,WIMPRI,CSACADO,xCGC_EMP,xINSC_EMP,CCONVENIO,CSERIE,lLin")

Private cPerg := "JMHR200   "
Private oFont, oFont2, oFont3, oFont4, oFont5, oFont5b, oFont6, oFont7, oPrn

nHeight10  := 10
nHeight12  := 12
nHeight15  := 15
lBold	   := .F.
lUnderLine := .F.

oFont	:= TFont():New( "Arial",,nheight15   ,,lBold ,,,,,lUnderLine )
oFont2  := TFont():New( "Arial",,nheight15+12,,!lBold,,,,,lUnderLine )
oFont3  := TFont():New( "Arial",,nheight15+10,,!lBold,,,,,lUnderLine )
oFont4  := TFont():New( "Arial",,nheight15   ,,!lBold,,,,,lUnderLine )
oFont5b := TFont():New( "Arial",,nheight12   ,,!lBold,,,,,lUnderLine )
oFont5  := TFont():New( "Arial",,nheight12   ,,lBold,,,,,lUnderLine )
oFont6  := TFont():New( "Arial",,nheight10   ,,!lBold,,,,,lUnderLine )
oFont7  := TFont():New( "Arial",,nheight10-2 ,,lBold ,,,,,lUnderLine )

DbSelectArea("SX1")
DBSETORDER(1)
IF !DBSEEK(cPerg+"01")
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "01"
	SX1->X1_PERGUNTA := "Da Nota        ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := TamSXG("018")[1]
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR01"
	SX1->X1_VARIAVL  := "mv_ch1"
	MsUnlock()
EndIf	
IF !DBSEEK(cPerg+"02")
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "02"
	SX1->X1_PERGUNTA := "Ate Nota       ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := TamSXG("018")[1]
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR02"
	SX1->X1_VARIAVL  := "mv_ch2"
	MsUnlock()
EndIf
IF !DBSEEK(cPerg+"03")
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "03"
	SX1->X1_PERGUNTA := "Da Serie       ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 03
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR03"
	SX1->X1_VARIAVL  := "mv_ch3"
	MsUnlock()
ENDIF

Pergunte(cPerg,.T.)

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Definicao do Tamanho da Nota fiscal       ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( {|| RptDetail() },"Imprimindo o Vale...","Aguarde....." )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JMHVALE   ºAutor  ³Microsiga           º Data ³  05/30/06   º±±
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


oPrn   := TMSPrinter():New('VALE CONSIGNADO')
//oPrn:Setup()
nLin   := 5000
nCol   := 50
nIncr  := 50

DbSelectArea("SM0")                   // * Contas a Receber
dbSetOrder(1)
cCidade := Alltrim(SM0->M0_CIDCOB)
w_Mes   :=  Month(dDataBase)
Do Case
	Case w_Mes ==  1
		w_MesRet :=  "Janeiro"
	Case w_Mes ==  2
		w_MesRet :=  "Fevereiro"
	Case w_Mes ==  3
		w_MesRet :=  "Marco"
	Case w_Mes ==  4
		w_MesRet :=  "Abril"
	Case w_Mes ==  5
		w_MesRet :=  "Maio"
	Case w_Mes ==  6
		w_MesRet :=  "Junho"
	Case w_Mes ==  7
		w_MesRet :=  "Julho"
	Case w_Mes ==  8
		w_MesRet :=  "Agosto"
	Case w_Mes ==  9
		w_MesRet :=  "Setembro"
	Case w_Mes ==  10
		w_MesRet :=  "Outubro"
	Case w_Mes ==  11
		w_MesRet :=  "Novembro"
	Case w_Mes ==  12
		w_MesRet :=  "Dezembro"
EndCase
w_DataEmi :=  cCidade+", "+StrZero(Day(dDatabase),2)+" de "+w_MesRet+" de "+Subs(DToS(dDataBase),1,4)+"."
cSerie    := MV_PAR03

DbSelectArea("SF2")
DbSetOrder(1)
dbSeek(xFilial("SF2")+MV_PAR01+cSerie,.T.)
DO WHILE  !EOF() .AND. SF2->F2_FILIAL ==  xFilial("SF2") .AND. SF2->F2_DOC <=  MV_PAR02
	
	nPosF2    := RecNo()
	
	DbSelectArea("SD2")
	DbSetOrder(3)
	w_NoReg :=  Lastrec()
	
	dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE,.F.)
	nPosD2  := RecNo()
	If SD2->D2_SERIE # cSerie
		DbSelectArea("SF2")
		DbGoTo(nPosF2)
		DbSkip()
		Loop
	EndIf
	
	cPedido := SD2->D2_PEDIDO
	cItemPV := SD2->D2_ITEMPV
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	dbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA,.F.)
	cCliente := SA1->A1_NOME
	cCodCli  := SD2->D2_CLIENTE
	nTamCli  := Len(cCliente)
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	dbSeek(xFilial("SC5")+SD2->D2_PEDIDO,.F.)
	
	DbSelectArea("SC6")
	DbSetOrder(1)
	
	
	DbSelectArea("SD2")
	DbGoTo(nPosD2)
	nProdutos := 0
	nPag := 1

	// inicia novo vale
	ImpCabec()

	DO WHILE !EOF() .AND. SD2->D2_FILIAL==xFilial("SD2") .AND. SD2->D2_DOC==SF2->F2_DOC .AND. SD2->D2_SERIE==SF2->F2_SERIE
		If nLin > 2620
			ImpCabec()
		EndIf

		nPosD2 := RecNo()
		If SD2->D2_SERIE # cSerie
			DbSelectArea("SD2")
			DbSkip()
			Loop
		EndIf
		
		SC6->( DbSeek(xFilial("SC6")+ SD2->D2_Pedido + SD2->d2_ItemPv ) )
		SC5->( DbSeek(xFilial("SC5")+ SD2->D2_Pedido ) )
		
		If SC6->C6_IMPNF <> "1"
			DbSelectArea("SD2")
			DbSkip()
			Loop
		EndIf
		
		DbSelectArea("SB1")
		DbSeek(xFilial("SB1")+SD2->D2_COD,.F.)
		
		DbSelectArea("SD2")
		DbGoTo(nPosD2)

		oPrn:Say( nLin, nCol+0200, StrZero(SD2->D2_QUANT,3), oFont5, 100 )
		oPrn:Say( nLin, nCol+0350, SD2->D2_UM, oFont5, 100 )

		If SC5->C5_CONVENI == '02' .and. SC5->C5_CLIENTE == '00019 '
			dbSelectArea("SA7")
			dbSetOrder(1)
			If SA7->( dbSeek(xFilial('SA7')+'CONVEN'+SC5->C5_CONVENI+SD2->D2_COD) ) .and. ! Empty(SA7->A7_PRODUTO)
				oPrn:Say( nLin, nCol+450, SA7->A7_CODCLI, oFont5, 100 )
			Endif
		Else
			oPrn:Say( nLin, nCol+450, SD2->D2_COD, oFont5, 100 )
		EndIf

		oPrn:Say( nLin, nCol+0800, Substr(SB1->B1_DESC,1,40), oFont5, 100 )
		oPrn:Say( nLin, nCol+2000, SD2->D2_LOTECTL, oFont5, 100 )
		
		nLin += nIncr
		
		nProdutos++
		DbSelectArea("SD2")
		DbSkip()
		
	EndDo
	
	// finaliza o vale
	ImpRodape()
	
	DbSelectArea("SF2")
	DbSetOrder(1)
	DbSkip()
EndDo

oPrn:EndPage()  // FECHAMENTO DA PAGINA
oPrn:Preview()
//oPrn:Print()  // Visualiza antes de imprimi

Return


Static Function ImpCabec()

	nLin   := 50
	nCol   := 50
	nIncr  := 50


	oPrn:EndPage()  // FECHAMENTO DA PAGINA
	oPrn:StartPage()   // Inicia uma nova página

	cBitMap := u_JMHF060()  //"logo_jomhedica.bmp"
	//oPrn:SayBitmap( nLin, nCol+100, cBitMap, 590, 190 )
	oPrn:SayBitmap( nLin, nCol+100, cBitMap, 800, 208 )

	nLin   += 220
	
	oPrn:Say( nLin, nCol+0850, "RECIBO DE CONSIGNAÇÃO", oFont5, 100 )
	oPrn:Say( nLin, nCol+1450, "No.: "+SD2->D2_DOC, oFont5, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+1450, "Pag.: "+StrZero(nPag,2), oFont5, 100 )
	nLin += nIncr
	nLin += nIncr
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, "Pelo presente, entregamos ao hospital o material em consignação", oFont5, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, "abaixo descrito:", oFont5, 100 )

	nLin += nIncr
	nLin += nIncr

	//             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	oPrn:Say( nLin, nCol+200, "QTD", oFont5b, 100 )
	oPrn:Say( nLin, nCol+350, "UN", oFont5b, 100 )
	oPrn:Say( nLin, nCol+450, "REFERÊNCIA", oFont5b, 100 )
	oPrn:Say( nLin, nCol+800, "DESCRIÇÃO", oFont5b, 100 )
	oPrn:Say( nLin, nCol+2000, "LOTE", oFont5b, 100 )

	nLin += nIncr
	nLin += nIncr

Return



Static Function ImpRodape()

	nLin += nIncr
	nLin += nIncr

	oPrn:Say( nLin, nCol+0200, "Ficando o hospital responsavel por tal material, até a sua", oFont5, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, "devolução, ou solicitação e faturamento do(s) mesmo(s).", oFont5, 100 )
	nLin += nIncr
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, "De Acordo:  " + w_DataEmi, oFont5, 100 )
	nLin += nIncr
	nLin += nIncr
	nLin += nIncr
	nLin += nIncr
	
	oPrn:Say( nLin, nCol+0200, Replicate("_",(nTamCli+2)), oFont5, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, cCliente, oFont5, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, "("+cCodCli+")", oFont5, 100 )

	nLin += nIncr
	nLin += nIncr

	oPrn:Say( nLin, nCol+0200, "Data cirurgia: ", oFont5, 100 )
	oPrn:Say( nLin, nCol+0500, DToC(SC5->C5_DTCIRUG), oFont5b, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, "Convênio: ", oFont5, 100 )
	oPrn:Say( nLin, nCol+0500, SC5->C5_DESCCON, oFont5b, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, "Paciente: ", oFont5, 100 )
	oPrn:Say( nLin, nCol+0500, SC5->C5_PACIENT, oFont5b, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, "Cirurgião: ", oFont5, 100 )
	oPrn:Say( nLin, nCol+0500, SC5->C5_CRMNOM, oFont5b, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, "Representante: ", oFont5, 100 )
	oPrn:Say( nLin, nCol+0500, "("+SC5->C5_VEND1+")", oFont5b, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, "Observação: ", oFont5, 100 )
	oPrn:Say( nLin, nCol+0500, Substr(SC5->C5_MENNOTA,1,43), oFont5b, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, " ", oFont5, 100 )
	oPrn:Say( nLin, nCol+0500, Substr(SC5->C5_MENNOTA,44), oFont5b, 100 )
	nLin += nIncr
	oPrn:Say( nLin, nCol+0200, "* Favor nos devolver a 1a. via assinada", oFont5, 100 )
	nLin += nIncr

Return
