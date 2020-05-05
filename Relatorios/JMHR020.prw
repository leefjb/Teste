#include "protheus.ch"
#include "sigawin.ch"
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

User Function JMHR020()

Private cCadastro := "Impressão de Etiquetas de Lote"
Private aRotina := {{ "Pesquisar",  "AxPesqui", 0, 1 },;
					{ "Visualizar", "AxVisual", 0, 2 },;
					{ "Etiqueta",   "U_SelLote", 0, 3 },;
					{ "Etiqueta2",  "U_JR020Sel", 0, 4 } }


//dbSelectArea('SB8')
//mBrowse( 6, 1, 22, 75,"SB8" )

dbSelectArea('SD1')
mBrowse( 6, 1, 22, 75,"SD1")

Return



/********************************************************************************************/
User Function SelLote()
Local oDlg
Local nQuant    := SD1->D1_QUANT  //SB8->B8_SALDO
Local lOk       := .f.


DEFINE DIALOG odLG FROM 100,004 To 198,230 TITLE "Etiquetas"  PIXEL

@ 001,003 Say 'Quantidade:' PIXEL
@ 002,035 Get nQuant  Picture "999"  PIXEL

DEFINE SBUTTON FROM 35, 050 TYPE 1 ENABLE OF oDlg PIXEL ACTION (lOk := .t., oDlg:End())

ACTIVATE DIALOG oDlg CENTERED

If lOk
	ImpEtqLt( nQuant )
EndIf

Return



/********************************************************************************************/
Static Function ImpEtqLt( nQuant )
Local x
Local cLote1, cData1, cLote2, cData2, nHdl, cLoteF1, cLoteF2

nQtd := (nQuant/2)
If nQtd > Int(nQuant/2)
	nQuant := Int(nQuant/2)+1
Else
	nQuant := Int(nQuant/2)
EndIf

For x := 1 To nQuant

	//cLote1  := Substr(SB8->B8_LOTECTL,5)+Space(8-Len(Substr(SB8->B8_LOTECTL,5)))     //PEGA DEPOIS DA STRING AUTO
	//cLote2  := Substr(SB8->B8_LOTECTL,5)+Space(8-Len(Substr(SB8->B8_LOTECTL,5)))
	//cData1  := SB8->B8_PRODUTO
	//cData2  := SB8->B8_PRODUTO
	//cLoteF1 := Substr(SB8->B8_LOTEFOR,1,16)
	//cLoteF2 := Substr(SB8->B8_LOTEFOR,1,16)
	
	cLote1  := Substr(SD1->D1_LOTECTL,5)+Space(8-Len(Substr(SD1->D1_LOTECTL,5)))     //PEGA DEPOIS DA STRING AUTO
	cLote2  := Substr(SD1->D1_LOTECTL,5)+Space(8-Len(Substr(SD1->D1_LOTECTL,5)))
	cData1  := SD1->D1_COD
	cData2  := SD1->D1_COD
	cLoteF1 := Substr(SD1->D1_LOTEFOR,1,16)
	cLoteF2 := Substr(SD1->D1_LOTEFOR,1,16)

    //modelo via codigo de maquina
	nHdl := fOpen('LPT1')
	fWrite(nHdl,'^XA')
	fWrite(nHdl,'^DFR:FORM.ZPL^FS')
	fWrite(nHdl,'^FO35,085^AF^FN1^FS')
	fWrite(nHdl,'^FO35,115^AF^FN2^FS')
	fWrite(nHdl,'^FO35,148^AF^FN3^FS')
	fWrite(nHdl,'^FO35,208^AC^FN4^FS')
	fWrite(nHdl,'^FO35,230^AC^FN5^FS')
	fWrite(nHdl,'^FO35,250^AD^FN6^FS')
	fWrite(nHdl,'^XZ')
	fWrite(nHdl,'^XA^XFR:FORM.ZPL^FS')
	fWrite(nHdl,'^FN1^FD' + SPACE(05) + cLote1 + SPACE(19) + cLote2 + '^FS')
	fWrite(nHdl,'^FN2^FD' + SPACE(05) + cLoteF1+ SPACE(11) + cLoteF2 + '^FS')
	fWrite(nHdl,'^FN3^FD' +   'Prd: ' + cData1 + SPACE(07) + 'Prd: ' + cData2 + '^FS')
	fWrite(nHdl,'^FN4^FD' + SPACE(06) + cLote1 + SPACE(09) + cLote1 + SPACE(10) + cLote2 + SPACE(09) + cLote2 + '^FS')
	fWrite(nHdl,'^FN5^FD'             + cLoteF1 + cLoteF2 + SPACE(3) + cLoteF1 + cLoteF2 + '^FS')
	fWrite(nHdl,'^FN6^FD'             + cData1 + SPACE(01) + cData1 + SPACE(04) + cData2 + SPACE(01) + cData2 + '^FS')
	fWrite(nHdl,'^XZ')
	fClose(nHdl)
    
    /*
	//FUNCIONAL tarascon ao mexer, ta pronto....em stand by.......
	MSCBPrinter( 'ZEBRA', "LPT1",,, .f.,,,, )		// seta tipo de impressora no padrao ZPL
	MSCBCHKStatus(.f.)
	MSCBBegin( 1, 1 )		// inicializa montagem da imagem
	         //C x L
	MSCBSAYBAR(16,08,AllTrim(SB8->B8_PRODUTO),"N","C",5,.f.,.F.,,,3,2,.T.) //monta codigo de barras
	MSCBSAYBAR(70,08,AllTrim(SB8->B8_PRODUTO),"N","C",5,.f.,.F.,,,3,2,.T.) //monta codigo de barras

	MSCBSAYBAR(16,15,AllTrim(SB8->B8_LOTECTL),"N","C",5,.f.,.F.,,,3,2,.T.) //monta codigo de barras
	MSCBSAYBAR(70,15,AllTrim(SB8->B8_LOTECTL),"N","C",5,.f.,.F.,,,3,2,.T.) //monta codigo de barras

	MSCBSAY(14,25,cLote1,"N","9","014,014,014")
	MSCBSAY(38,25,cLote2,"N","9","014,014,014")

	MSCBSAY(65,25,cLote1,"N","9","014,014,014")
	MSCBSAY(90,25,cLote2,"N","9","014,014,014")
	
	MSCBSAY(05,28,cLoteF1,"N","9","014,014,014")
	MSCBSAY(30,28,cLoteF2,"N","9","014,014,014")

	MSCBSAY(56,28,cLoteF1,"N","9","014,014,014")
	MSCBSAY(81,28,cLoteF2,"N","9","014,014,014")
	
	MSCBSAY(05,31,cData1,"N","9","014,014,014")
	MSCBSAY(30,31,cData2,"N","9","014,014,014")
	 
	MSCBSAY(56,31,cData1,"N","9","014,014,014")
	MSCBSAY(81,31,cData2,"N","9","014,014,014")
	
	MSCBEnd()				// fim da imagem da etiqueta
	MSCBClosePrinter()
	*/
	
/*
MSCBSAYBAR
Descrição: 
	Imprime Código de Barras
Parâmetros:
	nXmm         = Posição X em Milímetros                        
	nYmm         = Posição Y em Milímetros                        
	cConteudo    = String a ser impressa                          
	cRotação     = String com o tipo de Rotação
	cTypePrt     = String com o Modelo de Código de Barras 
 			   Zebra:	
				2 - Interleaved 2 of 5
				3 - Code 39
				8 - EAN 8
				E - EAN 13
				U - UPC A
				9 - UPC E
				C - CODE 128
	[nAltura]    = Altura do código de Barras em Milímetros       
     *[lDigver]    = Imprime dígito de verificação               
	[lLinha]     = Imprime a linha de código                   
     *[lLinBaixo]  = Imprime a linha de código acima das barras 
	[cSubSetIni] = Utilizado no code 128                           
	[nLargura]   = Largura da barra mais fina em pontos default 3
	[nRelacao]   = Relacao entre as barras finas e grossas em    
	               pontos default 2                              
	[lCompacta]  = Compacta o código de barra                    
	[lSerial] = Se for verdadeiro, irá serializar o código conforme a 			quantidade de etiquetas impressa.
	[cIncr]   = String com o incremento dos código para serialização
 	[lZerosL] = Na serialização colocará zeros a esquerda do código

Exemplo:
	MSCBSAYBAR(20,22,AllTrim(SB1->B1_CODBAR),"N","C",13)

*/

Next

Return



/*------------------------------------------------------------------------------------------------------------------------------------*/
User Function JR020Sel()
Local oDlg
Local nQuant    := SD1->D1_QUANT  //SB8->B8_SALDO
Local dDTESTER  := dDataBase
Local lOk       := .f.


Define Dialog odLG From 100,004 To 198,230 Title "Etiquetas"  Pixel

	@ 001,003 Say 'Quantidade:' Pixel
	@ 002,035 Get nQuant  Picture "999"  Pixel
	@ 015,003 Say 'Esterelização:' Pixel
	@ 016,035 Get dDTESTER  Pixel

	Define SButton From 35, 050 Type 1 Enable Of oDlg Pixel Action (lOk := .t., oDlg:End())

Activate Dialog oDlg Centered

If lOk
	ImpEtqLt2( nQuant, dDTESTER )
EndIf
	
Return



/*------------------------------------------------------------------------------------------------------------------------------------*/
Static Function ImpEtqLt2( nQuant, dDTESTER )
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
//SB1->(DbSeek(xFilial("SB1")+SB8->B8_PRODUTO))
SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))

//cLoteCtl		:=	AllTrim(SB8->B8_LOTECTL)
//cVenctoLote		:=	SubStr(DtoC(SB8->B8_DTVALID),4)
//cLoteFor		:=	SubStr(SB8->B8_LOTEFOR,1,16)
//cCodProd		:=	AllTrim(SB8->B8_PRODUTO)
//cDtEster		:=	DTOC(dDTESTER)

/*                
CRISTIANO OLIVEIRA - SOLUTIO IT #15112
Campo de Impressão da Data de Validade
*/
cImpVal         :=  SB1->B1_VALIMP 
       
If cImpVal == "2"   // 2 = NAO IMPRIMIR DATA
	cVenctoLote		:=  "INDETERMINADO"
Else
	cVenctoLote		:=	SubStr(DtoC(SD1->D1_DTVALID),4)
EndIf

cLoteCtl		:=	AllTrim(SD1->D1_LOTECTL)
cLoteFor		:=	SubStr(SD1->D1_LOTEFOR,1,16)
cCodProd		:=	AllTrim(SD1->D1_COD)
cDtEster		:=	DTOC(dDTESTER)

cDescProd		:=	AllTrim(Left(SB1->B1_DESC,100))
cEster			:=	AllTrim(SB1->B1_ESTERIL)
cVlEster		:=	AllTrim(SB1->B1_VLESTER)
cCalibre		:=	AllTrim(SB1->B1_CALIBRE)
cComprimento	:=	AllTrim(SB1->B1_COMPRIM)
cRegAnvisa		:=	AllTrim(SB1->B1_RMS)
nQE             :=  SB1->B1_QE        

DbSelectArea("SA2") ; DbSetOrder(1)
SA2->( DbSeek(xFilial("SA2") + SB1->B1_CODFAB) )
cNomeFabr		:=	AllTrim(SA2->A2_NOME)
cDadosFabr		:=	AllTrim(SA2->A2_MUN) + If(AllTrim(SA2->A2_EST)<>"EX"," - " + AllTrim(SA2->A2_EST),"") + " - " + AllTrim(SA2->A2_PAISORI)

For x := 1 To nQuant

	MSCBPrinter( 'ZEBRA', "LPT1",,, .f.,,,, )		// seta tipo de impressora no padrao ZPL
	MSCBCHKStatus(.f.)
	MSCBBegin( 1, 1 )		// inicializa montagem da imagem

	nCol1 := 007
	nCol2 := 059

	nLin  := 010
	cLinha := cCodProd + " - " + SubStr(cDescProd,01,20)
	MsCbSay( nCol1 + 2, nLin , cLinha				, "N" , "0" , "025,020" )
	MsCbSay( nCol2 + 2, nLin , cLinha				, "N" , "0" , "025,020" )

	nLin  += 003
	cLinha := SubStr(cDescProd,21,40)
	MsCbSay( nCol1 + 2, nLin , cLinha				, "N" , "0" , "025,020" )
	MsCbSay( nCol2 + 2, nLin , cLinha				, "N" , "0" , "025,020" )

	nLin  += 003
	cLinha := SubStr(cDescProd,61,40)
	MsCbSay( nCol1 + 2, nLin , cLinha				, "N" , "0" , "025,020" )
	MsCbSay( nCol2 + 2, nLin , cLinha				, "N" , "0" , "025,020" )

	cTamFonte := "020,016"
	nLin  += 004
	MsCbSay( nCol1 , nLin , Padc(OemToAnsi("Contem: "+Str(nQE,2)+" Unidade(s)"),50)	, "N" , "0" , cTamFonte , , , , , .T. )
	MsCbSay( nCol2 , nLin , Padc(OemToAnsi("Contem: "+Str(nQE,2)+" Unidade(s)"),50)	, "N" , "0" , cTamFonte , , , , , .T. )

	nLin  += 002.5
	MsCbSay( nCol1 , nLin , Padc(OemToAnsi("Calibre: " + cCalibre + " Comprimento: " + cComprimento),60)	, "N" , "0" , cTamFonte , , , , , .T. )
	MsCbSay( nCol2 , nLin , Padc(OemToAnsi("Calibre: " + cCalibre + " Comprimento: " + cComprimento),60)	, "N" , "0" , cTamFonte , , , , , .T. )

	nLin  += 002.5
	MsCbSay( nCol1 , nLin , Padc("Lote: " + cLoteCtl + "  Vencimento: " + cVenctoLote,50)	, "N" , "0" , cTamFonte , , , , , .T. )
	MsCbSay( nCol2 , nLin , Padc("Lote: " + cLoteCtl + "  Vencimento: " + cVenctoLote,50)	, "N" , "0" , cTamFonte , , , , , .T. )

	If	!Empty(cEster)
		nLin  += 002.5
		MsCbSay( nCol1 , nLin , Padc("Esterilizacao: " + cEster,50)	, "N" , "0" , cTamFonte , , , , , .T. )
		MsCbSay( nCol2 , nLin , Padc("Esterilizacao: " + cEster,50)	, "N" , "0" , cTamFonte , , , , , .T. )
	
		nLin  += 002.5
		MsCbSay( nCol1 , nLin , Padc("Data Esterilizacao: " + cDtEster + " - Validade: " + cVlEster ,50)	, "N" , "0" , cTamFonte , , , , , .T. )
		MsCbSay( nCol2 , nLin , Padc("Data Esterilizacao: " + cDtEster + " - Validade: " + cVlEster ,50)	, "N" , "0" , cTamFonte , , , , , .T. )
	EndIf
	
	nLin  += 003
	MsCbSay( nCol1 , nLin , Padc("ESTERIL / PRODUTO MEDICO DE USO UNICO",50)	, "N" , "0" , cTamFonte , , , , , .T. )
	MsCbSay( nCol2 , nLin , Padc("ESTERIL / PRODUTO MEDICO DE USO UNICO",50)	, "N" , "0" , cTamFonte , , , , , .T. )

	nLin  += 003
	MsCbSay( nCol1 , nLin , Padc("PROIBIDO REPROCESSAR",50)	, "N" , "0" , cTamFonte , , , , , .T. )
	MsCbSay( nCol2 , nLin , Padc("PROIBIDO REPROCESSAR",50)	, "N" , "0" , cTamFonte , , , , , .T. )

	nLin  += 003
	MsCbSay( nCol1 , nLin , Padc("Armazenamento / Uso / Precaucoes do Produto:",50)	, "N" , "0" , cTamFonte , , , , , .T. )
	MsCbSay( nCol2 , nLin , Padc("Armazenamento / Uso / Precaucoes do Produto:",50)	, "N" , "0" , cTamFonte , , , , , .T. )

	nLin  += 002.5
	MsCbSay( nCol1 , nLin , Padc("VIDE INSTRUCOES DE USO",50)	, "N" , "0" , cTamFonte , , , , , .T. )
	MsCbSay( nCol2 , nLin , Padc("VIDE INSTRUCOES DE USO",50)	, "N" , "0" , cTamFonte , , , , , .T. )

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

	MsCbEnd()				// fim da imagem da etiqueta
	MsCbClosePrinter()

Next

Return
