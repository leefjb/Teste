#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO5     บ Autor ณ AP5 IDE            บ Data ณ  15/02/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP5 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5 IDE                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function JMHFAT03()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := "Posicao do Faturamento por CRM"
Local cPict   := ""
Local titulo  := "Faturamento CRM "
Local nLin    := 80
Local Cabec1  := ""
Local Cabec2  := ""
Local imprime := .T.

Private cString     := "SD2"
Private CbTxt       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 80
Private tamanho     := "M"
Private nomeprog    := "JMHFAT03"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := PadR("FFAT03",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
Private m_pag       := 01
Private wnrel       := "JMHFAT03"

ValidPerg()

pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

If MV_PAR06 == 1
	Cabec1  := "Cod CRM   Nome                                           Total CRM         Total CMV"
	Cabec2  := "Cod Produto      Descricao                                         Quantidade     Total Produto      CMV Produto"
	//          012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
	//                    1         2         3         4         5         6         7         8         9         1
	//          999999    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999.999.999,99    999.999.999,99
	//          999999999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   9999,99    999.999.999,99   999.999.999,99
Else
	Cabec1  := "Cod CRM   Nome                                           Total CRM         Total CMV"
	Cabec2  := ""
	//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
	//                    1         2         3         4         5         6         7         8         9
	//          99999     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999.999.999,99    999.999.999,99
EndIf

titulo += DTOC(MV_PAR01) + " a " + DTOC(MV_PAR02)

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP5 IDE            บ Data ณ  29/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

DbSelectArea("SZ1"); DbSetOrder(1)
DbSelectArea("SC5"); DbSetOrder(1)
DbSelectArea("SC6"); DbSetOrder(1)
DbSelectArea("SA1"); DbSetOrder(1)
DbSelectArea("SF2"); DbSetOrder(1)
dbSelectArea("SD2"); DbSetOrder(5)
dbSelectArea("SB1"); DbSetOrder(1)

//Local
cEst     := Space(2)
cVend1   := Space(6)
cCRM     := Space(6)
cNomeCRM := Space(40)
nn       := 0
ii       := 0
nTotal   := 0
nTotal2  := 0
aCRMx    := {}
aCRMy    := {}
aCRMz    := {}
aCRMw    := {}

dbSelectArea(cString)
SetRegua(RecCount())
dbSeek(xFilial("SD2")+DTOS(MV_PAR01),.T.)
Do While !EOF() .And. SD2->D2_EMISSAO <= MV_PAR02
	
	If ! (SD2->D2_SERIE $ "UNI/1  /")
		DbSkip()
		Loop
	EndIf
	
	If MV_PAR07 = 1
		SF4->( dbSeek(xFilial("SF4")+ SD2->D2_TES ) )
		If SF4->F4_DUPLIC <> "S"
			dbSkip()
			Loop
		EndIf
	EndIf
	
	SC6->( DbSeek(xFilial("SC6")+ SD2->D2_Pedido + SD2->d2_ItemPv ) )
	
	If SC6->C6_IMPNF <> "1"
		DbSkip()
		Loop
	EndIf
	
	SF2->( DbSeek(xfilial("SF2")+ SD2->D2_Doc + SD2->D2_Serie) )
	
	If SF2->F2_EST == Space(2)
		DbSkip()
		Loop
	EndIf
	
	If MV_PAR04 # Space(2) .And. MV_PAR04 # SF2->F2_EST  // UF
		DbSkip()
		Loop
	EndIf
	cEst := SF2->F2_EST
	
	SC5->( DbSeek(XFILIAL("SC5") + SD2->D2_Pedido) )
	
	If SC5->C5_Vend1 == Space(6) .Or. SC5->C5_CRM == Space(6)
		DbSkip()
		Loop
	EndIf
	
	If MV_PAR05 # Space(6) .And. MV_PAR05 # SC5->C5_Vend1 // Vendedor
		DbSkip()
		Loop
	EndIf
	cVend1 := SC5->C5_Vend1
	
	If MV_PAR03 # Space(6) .And. MV_PAR03 # SC5->C5_CRM   // CRM
		DbSkip()
		Loop
	EndIf
	cCRM := SubStr(SC5->C5_CRM,1,5)
	
	SZ1->( DbSeek(XFILIAL("SZ1") + cCRM) )
	cNomeCRM := SZ1->Z1_NOME
	
	If MV_PAR06 == 1
		
		SB1->( DbSeek(XFILIAL("SB1") + SD2->D2_COD) )
		cDescProd := Substr(SB1->B1_DESC,1,35)
		
		nn := Ascan(aCRMw,cCRM+SD2->D2_COD)
		If nn == 0
			aAdd(aCRMw, cCRM+SD2->D2_COD)
			aAdd(aCRMz, {cCRM+SD2->D2_COD, cDescProd, SD2->D2_QUANT, SD2->D2_TOTAL})
		Else
			aCRMz[nn,3] += SD2->D2_QUANT
			aCRMz[nn,4] += SD2->D2_TOTAL
		EndIf
	EndIf
	
	nn := Ascan(aCRMx,cCRM)
	If nn == 0
		aAdd(aCRMx,cCRM)
		aAdd(aCRMy , { cCRM, cNomeCRM, SD2->D2_TOTAL } )
	Else
		aCRMy[nn,3] += SD2->D2_TOTAL
	EndIf
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

If MV_PAR06 == 1
	aSort(aCRMz,,,{|x,y| x[1] > y[1]} )
EndIf

aSort(aCRMy,,,{|x,y| x[3] > y[3]} )

nTotal   := 0
nTotal2  := 0

If Len(aCRMy) > 0
	
	For nn := 1 To Len(aCRMy)
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
			
		Endif
		
		@ nLin, 00 PSAY aCRMy[nn,1]
		@ nLin, 10 PSAY Substr(aCRMy[nn,2],1,40)
		@ nLin, 52 PSAY aCRMy[nn,3] Picture "@E 99,999,999.99"
		@ nLin, 70 PSAY aCRMy[nn,3]*MV_PAR08 Picture "@E 99,999,999.99"
		nTotal  += aCRMy[nn,3]
		nTotal2 += aCRMy[nn,3]*MV_PAR08
		nLin   += 1 // Avanca a linha de impressao
		If MV_PAR06 == 1
			ni := Ascan(aCRMw,aCRMy[nn,1])
			If ni > 0
				nLin += 1 // Avanca a linha de impressao
				For ii := ni To Len(aCRMz)
					If SubStr(aCRMz[ii,1],1,5) == aCRMy[nn,1]
						@ nLin, 00 PSAY SubStr(aCRMz[ii,1],6)
						@ nLin, 17 PSAY Substr(aCRMz[ii,2],1,50)
						@ nLin, 70 PSAY aCRMz[ii,3] Picture "@E 9999.99"
						@ nLin, 81 PSAY aCRMz[ii,4] Picture "@E 999,999,999.99"
						@ nLin, 98 PSAY aCRMz[ii,4]*MV_PAR08 Picture "@E 999,999,999.99"
						nLin += 1 // Avanca a linha de impressao
					Else
						Exit
					EndIf
				Next
				nLin += 1 // Avanca a linha de impressao
			EndIf
		EndIf
	Next
Else
	Alert(Substr(cUsuario,7,13) + ", Nao Foi Selecionado Nenhuma Nota, Verifique Parametros!")
	Return
EndIf

nLin += 1 // Avanca a linha de impressao

@ nLin, 17 PSAY "Total Geral .: "
@ nLin, 52 PSAY nTotal  Picture "@E 999,999,999.99"
@ nLin, 70 PSAY nTotal2 Picture "@E 999,999,999.99"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  29/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)

//          Grupo/Ordem/Pergunta/                   Variavel/Tipo/Tam/Dec/Pres/GSC/Valid/             Var01/     Def01______/Cnt01/  Var02 /Def02_____/Cnt02/ Var03/Def03___/Cnt03/ Var04/Def04___/Cnt04/ Var05/Def05___/Cnt05/ F3
aAdd(aRegs,{cPerg,"01","Data Inicio .:","","",         "mv_ch1","D",  8,  0, 0,  "G", "",               "MV_PAR01", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"02","Data Fim .:","","",            "mv_ch2","D",  8,  0, 0,  "G", "",               "MV_PAR02", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"03","Informe o CRM .:","","",       "mv_ch3","C",  6,  0, 0,  "G", "EXISTCPO('SZ1')","MV_PAR03", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    "SZ1"})
aAdd(aRegs,{cPerg,"04","Estado .:","","",              "mv_ch4","C",  2,  0, 0,  "G", "",               "MV_PAR04", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"05","Vendedor .:","","",            "mv_ch5","C",  6,  0, 0,  "G", "A410Vend()",     "MV_PAR05", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    "SA3"})
aAdd(aRegs,{cPerg,"06","Total por Produto .:","","",   "mv_ch6","N",  1,  0, 1,  "C", "",               "MV_PAR06", "Sim","","","",     "",   "Nao","","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"07","Considera Nota Fiscal.:","","","mv_ch7","N",  1,  0, 1,  "C", "",               "MV_PAR07", "Faturadas","","","",     "",   "Todas","","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"08","Fator de Ajuste:","","",       "mv_ch8","N",  7,  4, 0,  "G", "",               "MV_PAR08", "","","","",     "",   "","","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
