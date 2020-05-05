#include "protheus.ch"
#include "sigawin.ch"

//------------------------------------------------------------------------------------------------
// Impressao de etiqueta com codigo de barras normal
User Function JMHR024()
Local oDlg
Local nQuant    := 0
Local cProduto  := ''


If MV_PAR01 = 1
	nQuant   := SD1->D1_QUANT
	cProduto := SD1->D1_COD
Else
	nQuant   := SB8->B8_SALDO
	cProduto := SB8->B8_PRODUTO
EndIf

Define Dialog odLG From 100,004 To 198,230 Title "Etiquetas"  Pixel

	@ 001,003 Say 'Quantidade:' Pixel
	@ 002,035 Get nQuant  Picture "999"  Pixel
	
	Define SButton From 35, 050 Type 1 Enable Of oDlg Pixel Action (ImpEtq1d( nQuant, cProduto ), oDlg:End())
	
Activate Dialog oDlg Centered

Return

/*
-------------------------------------------------------------------------------------------------------------------------------------
*/

Static Function ImpEtq1d( nQuant, cProduto )
Local x
Local cLote1, cData1, cLote2, cData2, nHdl, cLoteF1, cLoteF2

nQtd := (nQuant/2)
If nQtd > Int(nQuant/2)
	nQuant := Int(nQuant/2)+1
Else
	nQuant := Int(nQuant/2)
EndIf

DbSelectArea("SB1")
DbSetOrder(1) 
SB1->(DbSeek(xFilial("SB1")+cProduto))

If MV_PAR01 = 1
	cLoteCtl		:=	AllTrim(SD1->D1_LOTECTL)
	cVenctoLote		:=	SubStr(DtoC(SD1->D1_DTVALID),4)
	cLoteFor		:=	SubStr(SD1->D1_LOTEFOR,1,16)
	cCodProd		:=	AllTrim(SD1->D1_COD)
	cCodBarr		:=	AllTrim(SB1->B1_CODBAR)
	cDtEster		:=	DTOC(SD1->D1_DTESTER)
Else
	cLoteCtl		:=	AllTrim(SB8->B8_LOTECTL)
	cVenctoLote		:=	SubStr(DtoC(SB8->B8_DTVALID),4)
	cLoteFor		:=	SubStr(SB8->B8_LOTEFOR,1,16)
	cCodProd		:=	AllTrim(SB8->B8_PRODUTO)
	cCodBarr		:=	AllTrim(SB1->B1_CODBAR)
	cDtEster		:=	''
EndIf

cDescProd		:=	AllTrim(Left(SB1->B1_DESC,100))
cEster			:=	AllTrim(SB1->B1_ESTERIL)
cVlEster		:=	AllTrim(SB1->B1_VLESTER)
cCalibre		:=	AllTrim(SB1->B1_CALIBRE)
cComprimento	:=	AllTrim(SB1->B1_COMPRIM)
cRegAnvisa		:=	AllTrim(SB1->B1_RMS)
nQE             :=  SB1->B1_QE

DbSelectArea("SA2")
DbSetOrder(1)
SA2->( DbSeek(xFilial("SA2") + SB1->B1_CODFAB) )
cNomeFabr		:=	Substr(SA2->A2_NOME,1,28)
cDadosFabr		:=	AllTrim(SA2->A2_MUN) + If(AllTrim(SA2->A2_EST)<>"EX"," - " + AllTrim(SA2->A2_EST), " - " + AllTrim(SA2->A2_PAISORI))

For x := 1 To nQuant

	nCol1 := 002
	nCol2 := 054

	MSCBPrinter( 'ZEBRA', "LPT1",,, .f.,,,, )		// seta tipo de impressora no padrao ZPL
	MSCBCHKStatus(.f.)
	MSCBBegin( 1, 1 )		// inicializa montagem da imagem

	nLin  := 010
	cLinha := cCodProd + " " + SubStr(cDescProd,01,12)
	MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "025,020" )
	MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "025,020" )

	nLin  += 003
	cLinha := SubStr(cDescProd,13,28)
	MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "025,020" )
	MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "025,020" )

	nLin  += 003
	cLinha := SubStr(cDescProd,41,28)
	MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "025,020" )
	MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "025,020" )

	cTamFonte := "020,016"
	nLin  += 004

	MsCbSay( nCol1 , nLin , PadR(OemToAnsi("Contem: "+Str(nQE,2)+" Unidade(s)"),50)	, "N" , "0" , cTamFonte , , , , , .F. )
	MsCbSay( nCol2 , nLin , PadR(OemToAnsi("Contem: "+Str(nQE,2)+" Unidade(s)"),50)	, "N" , "0" , cTamFonte , , , , , .F. )

	nLin  += 002.5
	MsCbSay( nCol1 , nLin , PadR(OemToAnsi("Calibre: " + cCalibre + " Comprimento: " + cComprimento),60)	, "N" , "0" , cTamFonte , , , , , .F. )
	MsCbSay( nCol2 , nLin , PadR(OemToAnsi("Calibre: " + cCalibre + " Comprimento: " + cComprimento),60)	, "N" , "0" , cTamFonte , , , , , .F. )

	nLin  += 002.5
	MsCbSay( nCol1 , nLin , PadR("Lote: " + cLoteCtl + "  Vencimento: " + cVenctoLote,50)	, "N" , "0" , cTamFonte , , , , , .F. )
	MsCbSay( nCol2 , nLin , PadR("Lote: " + cLoteCtl + "  Vencimento: " + cVenctoLote,50)	, "N" , "0" , cTamFonte , , , , , .F. )

	If	!Empty(cEster)
		nLin  += 002.5
		MsCbSay( nCol1 , nLin , PadR("Esterilizacao: " + cEster,50)	, "N" , "0" , cTamFonte , , , , , .F. )
		MsCbSay( nCol2 , nLin , PadR("Esterilizacao: " + cEster,50)	, "N" , "0" , cTamFonte , , , , , .F. )
	
		nLin  += 002.5
		MsCbSay( nCol1 , nLin , PadR("Data Esterilizacao: " + cDtEster + " - Validade: " + cVlEster ,50)	, "N" , "0" , cTamFonte , , , , , .F. )
		MsCbSay( nCol2 , nLin , PadR("Data Esterilizacao: " + cDtEster + " - Validade: " + cVlEster ,50)	, "N" , "0" , cTamFonte , , , , , .F. )
	EndIf
	
	nLin  += 003
	MsCbSay( nCol1 , nLin , PadR("ESTERIL / PRODUTO MEDICO DE USO UNICO",50)	, "N" , "0" , cTamFonte , , , , , .F. )
	MsCbSay( nCol2 , nLin , PadR("ESTERIL / PRODUTO MEDICO DE USO UNICO",50)	, "N" , "0" , cTamFonte , , , , , .F. )

	nLin  += 003
	MsCbSay( nCol1 , nLin , PadR("PROIBIDO REPROCESSAR",50)	, "N" , "0" , cTamFonte , , , , , .F. )
	MsCbSay( nCol2 , nLin , PadR("PROIBIDO REPROCESSAR",50)	, "N" , "0" , cTamFonte , , , , , .F. )

	nLin  += 003
	MsCbSay( nCol1 , nLin , PadR("Armazenamento/Uso/Precaucoes do Produto:",50)	, "N" , "0" , cTamFonte , , , , , .F. )
	MsCbSay( nCol2 , nLin , PadR("Armazenamento/Uso/Precaucoes do Produto:",50)	, "N" , "0" , cTamFonte , , , , , .F. )

	nLin  += 002.5
	MsCbSay( nCol1 , nLin , PadR("VIDE INSTRUCOES DE USO",50)	, "N" , "0" , cTamFonte , , , , , .F. )
	MsCbSay( nCol2 , nLin , PadR("VIDE INSTRUCOES DE USO",50)	, "N" , "0" , cTamFonte , , , , , .F. )

	nLin  += 003
	MsCbSay( nCol1 , nLin , "Fabricado Por:"	, "N" , "0" , cTamFonte )
	MsCbSay( nCol2 , nLin , "Fabricado Por:"	, "N" , "0" , cTamFonte )

	nLin  += 002.5
	MsCbSay( nCol1 , nLin , cNomeFabr	, "N" , "0" , cTamFonte )
	MsCbSay( nCol2 , nLin , cNomeFabr	, "N" , "0" , cTamFonte )

	nLin  += 002.5
	MsCbSay( nCol1 , nLin , cDadosFabr	, "N" , "0" , cTamFonte )
	MsCbSay( nCol2 , nLin , cDadosFabr	, "N" , "0" , cTamFonte )

	cTamFonte := "022,018"
	nLin  += 003
	MsCbSay( nCol1 , nLin , "Reg. ANVISA N.: " + cRegAnvisa	, "N" , "0" , cTamFonte )
	MsCbSay( nCol2 , nLin , "Reg. ANVISA N.: " + cRegAnvisa	, "N" , "0" , cTamFonte )

	cTamFonte := "020,016"

	nLin  := 059
	MsCbSay( nCol1 + 10 , nLin , cLoteCtl	, "N" , "0" , cTamFonte )
	MsCbSay( nCol1 + 35 , nLin , cLoteCtl	, "N" , "0" , cTamFonte )
	MsCbSay( nCol2 + 10 , nLin , cLoteCtl	, "N" , "0" , cTamFonte )
	MsCbSay( nCol2 + 35 , nLin , cLoteCtl	, "N" , "0" , cTamFonte )

	nLin  += 002.5
	MsCbSay( nCol1 + 10 , nLin , "Val.: " + cVenctoLote	, "N" , "0" , cTamFonte )
	MsCbSay( nCol1 + 35 , nLin , "Val.: " + cVenctoLote	, "N" , "0" , cTamFonte )
	MsCbSay( nCol2 + 10 , nLin , "Val.: " + cVenctoLote	, "N" , "0" , cTamFonte )
	MsCbSay( nCol2 + 35 , nLin , "Val.: " + cVenctoLote	, "N" , "0" , cTamFonte )

	nLin  += 003.5
	MsCbSay( nCol1 + 10 , nLin , cLoteFor	, "N" , "0" , cTamFonte )
	MsCbSay( nCol1 + 35 , nLin , cLoteFor	, "N" , "0" , cTamFonte )
	MsCbSay( nCol2 + 10 , nLin , cLoteFor	, "N" , "0" , cTamFonte )
	MsCbSay( nCol2 + 35 , nLin , cLoteFor	, "N" , "0" , cTamFonte )

//-- Primeira Etiqueta
	nCol1 := 002
	nCol2 := 054

//	MSCBSAYBAR(nXmm         ,nYmm,cConteudo         ,cRotacao,cTypePrt,nAltura,lDigVer,lLinha,lLinBaixo,cSubSetIni,nLargura,nRelacao,lCompacta,lSerial,cIncr,lZerosL)
	MsCbSayBar(nCol1 + 038 ,015 ,cLoteCtl          ,"R"     ,"C"     ,5      ,.F.    ,.F.   ,         ,"B"       ,2       ,1       ,         ,       ,     ,       ) //monta codigo de barras
	MsCbSayBar(nCol1 + 044 ,015 ,cCodBarr          ,"R"     ,"C"     ,5      ,.F.    ,.F.   ,         ,"B"       ,2       ,1       ,         ,       ,     ,       ) //monta codigo de barras

//-- Segunda Etiqueta

//	MSCBSAYBAR(nXmm        ,nYmm,cConteudo         ,cRotacao,cTypePrt,nAltura,lDigVer,lLinha,lLinBaixo,cSubSetIni,nLargura,nRelacao,lCompacta,lSerial,cIncr,lZerosL)
	MsCbSayBar(nCol2 + 038 ,015 ,cLoteCtl          ,"R"     ,"C"     ,5      ,.F.    ,.F.   ,         ,"B"       ,2       ,1       ,         ,       ,     ,       ) //monta codigo de barras
	MsCbSayBar(nCol2 + 044 ,015 ,cCodBarr          ,"R"     ,"C"     ,5      ,.F.    ,.F.   ,         ,"B"       ,2       ,1       ,         ,       ,     ,       ) //monta codigo de barras

	MsCbEnd()				// fim da imagem da etiqueta
	MsCbClosePrinter()

Next

Return
