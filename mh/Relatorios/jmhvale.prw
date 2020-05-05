#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/08/00

User Function JMHVALE()        // incluido pelo assistente de conversao do AP5 IDE em 08/08/00
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("cCliente, nTamCli, cPedido, cItemPV, w_Mes, w_MesRet, w_DataEmi, n_NVias, nLin, cCidade")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN,NPOSD2,NPOSF2,W_NOREG")
SetPrvt("CPERG,NLASTKEY,LI,WNREL,WIMPRI,CSACADO,xCGC_EMP,xINSC_EMP,CCONVENIO,CSERIE,lLin")

Private cPerg := PadR("JMHVALE",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

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

cString  := "SD2"
cDesc1   := OemToAnsi("Este programa tem como objetivo, Emitir o Recibo de Consignacao")
cDesc2   := ""
cDesc3   := ""
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog := "JMHVALE"
wnrel    := "JMHVALE"      //Nome Default do relatorio em Disco
nLastKey := 0
titulo   := "Recibo de Consignacao"
cCancel  := "***** CANCELADO PELO OPERADOR *****"
nLastKey := 0
nLin     := 80

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho,,.F.)

If LastKey()==  27 .or. nLastKey ==  27
	Set Filter to
	return
endif

// Seta a tabela SD2 como default.
SetDefault(aReturn,cString)

// Se for pressionado Esc aborta o programa.
if LastKey() ==  27 .or. nLastKey ==  27
	Set Filter To
	return
endif

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Definicao do Tamanho da Nota fiscal       ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//@ PROW(),000 PSAY CHR(27)+CHR(18)

RptStatus({|| Processa(RptDetail()) })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em Disco, chama Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera relatorio para Spool da Rede                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MS_FLUSH()

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

Static Function RptDetail

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
	//	n_NVias   := 1
	aEtiqueta := {}
	
	DbSelectArea("SD2")
	DbSetOrder(3)
	w_NoReg :=  Lastrec()
	SetRegua(w_NoReg) //Ajusta numero de elementos da regua de relatorios
	dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE,.F.)
	nPosD2  := RecNo()
	If SD2->D2_SERIE # cSerie
		DbSelectArea("SF2")
		DbGoTo(nPosF2)
		DbSkip()
		Loop
	EndIf
	
	DbSelectArea("SZ3")
	DbSetOrder(5)
	If dbSeek(xFilial("SZ3")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
		Do While SZ3->Z3_FILIAL == xFilial("SZ3") .AND. SZ3->Z3_NFSAIDA+SZ3->Z3_SERISAI == SF2->F2_DOC+SF2->F2_SERIE .AND. !EOF()
			If SZ3->Z3_SITUACA == "CON"
				aAdd(aEtiqueta,SZ3->Z3_CODETIQ)
			EndIf
			dbSkip()
		EndDo
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
	DO WHILE !EOF() .AND. SD2->D2_FILIAL==xFilial("SD2") .AND. SD2->D2_DOC==SF2->F2_DOC .AND. SD2->D2_SERIE==SF2->F2_SERIE
		IF nLin > 44
			
			nLin := 0
			nLin := nLin+06
			@ nLin,01 PSAY "                              RECIBO DE CONSIGNACAO                 No.: "+SD2->D2_DOC
			nLin++
			@ nLin,01 PSAY "                              ---------------------                 Pag: "+StrZero(nPag,2)
			nPag++
			nLin := nLin+3
			@ nLin,01 PSAY "          Pelo  presente, entregamos ao hospital o  material  em consignacao"
			nLin++
			@ nLin,01 PSAY "          abaixo descrito:"
			nLin := nLin+2                                                                       
			//             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			@ nLin,01 PSAY "          QTD  UN  REFERENCIA       DESCRICAO                                  LOTE"
			nLin := nLin+2
		End
		nPosD2 := RecNo()
		IncRegua()
		If SD2->D2_SERIE # cSerie
			DbSkip()
			Loop
		EndIf
		
		SC6->( DbSeek(xFilial("SC6")+ SD2->D2_Pedido + SD2->d2_ItemPv ) )
		SC5->( DbSeek(xFilial("SC5")+ SD2->D2_Pedido ) )
		
		If SC6->C6_IMPNF <> "1"
			DbSkip()
			Loop
		EndIf
		
		DbSelectArea("SB1")
		DbSeek(xFilial("SB1")+SD2->D2_COD,.F.)
		
		DbSelectArea("SD2")
		DbGoTo(nPosD2)
		@ nLin, 11 PSAY StrZero(SD2->D2_QUANT,3)
		@ nLin, 16 PSAY SD2->D2_UM

		If SC5->C5_CONVENI == '02' .and. SC5->C5_CLIENTE == '00019 '
			dbSelectArea("SA7")
			dbSetOrder(1)
			If SA7->( dbSeek(xFilial('SA7')+'CONVEN'+SC5->C5_CONVENI+SD2->D2_COD) ) .and. ! Empty(SA7->A7_PRODUTO)
				@ nLin, 20 PSay SA7->A7_CODCLI
			Endif
		Else
			@ nLin, 20 PSAY SD2->D2_COD
		EndIf
		
		@ nLin, 37 PSAY Substr(SB1->B1_DESC,1,40)
		
		@ nLin, 80 PSAY SD2->D2_LOTECTL
		
		nLin += 1
		nProdutos++
		DbSelectArea("SD2")
		DbSkip()
		
	EndDo
	
	// completa o preenchimento com nada
	__nCol := 12
	For nStart := 1 to (20-nProdutos)
		@ nLin, __nCol PSAY "**"
		__nCol += 4
		nLin++
	Next
	
	nLin += 1
	@ nLin, 01 PSAY "          Ficando o hospital responsavel por tal material,  ate  a sua"
	nLin += 1
	@ nLin, 01 PSAY "          devolucao, ou solicitacao e faturamento do(s) mesmo(s)."
	nLin += 2
	@ nLin, 01 PSAY "          De Acordo:"
	@ nLin, 33 PSAY w_DataEmi
	nLin += 4
	@ nLin, 75-(nTamCli+2) PSAY Replicate("_",(nTamCli+2))
	nLin += 1
	@ nLin, 75-nTamCli PSAY cCliente
	nLin += 1
	@ nLin, 75-nTamCli PSAY "("+cCodCli+")"
	
	If Len(aEtiqueta) > 0
		
		nLin += 2
		@ nLin, 01 PSAY "          Relacao das Etiquetas Enviadas"
		nLin +=  1
		nCol := 11
		nEtq :=  1
		For i := 1 To Len(aEtiqueta)
			
			If nEtq == 7
				@ nLin, nCol PSAY aEtiqueta[i]
				nEtq :=  1
				nLin +=  1
				nCol := 11
			Else
				If i == Len(aEtiqueta)
					@ nLin, nCol PSAY aEtiqueta[i]
				Else
					@ nLin, nCol PSAY aEtiqueta[i]+" - "
				EndIf
				nEtq +=  1
				nCol += 10
			EndIf
			
		Next
		
	EndIf
	
	IF nLin > 45
		nLin := 0
		nLin := nLin+06
		@ nLin,01 PSAY "                              RECIBO DE CONSIGNACAO                 No.: "+SD2->D2_DOC
		nLin++
		@ nLin,01 PSAY "                              ---------------------                 Pag: "+StrZero(nPag,2)
		nPag++
		nLin := nLin+3
		@ nLin,01 PSAY "          Pelo  presente, entregamos ao hospital o  material  em consignacao"
		nLin++
		@ nLin,01 PSAY "          abaixo descrito:"
		nLin := nLin+2
		@ nLin,01 PSAY "          QTD  UN  REFERENCIA       DESCRICAO"
		nLin := nLin+1
		// preenche com nada
		__nCol := 12
		For nStart := 1 to 20
			@ nLin, __nCol PSAY "**"
			__nCol += 4
			nLin++
		Next
		nLin += 1
		@ nLin, 01 PSAY "          Ficando o hospital responsavel por tal material,  ate  a sua"
		nLin += 1
		@ nLin, 01 PSAY "          devolucao, ou solicitacao e faturamento do(s) mesmo(s)."
		nLin += 2
		@ nLin, 01 PSAY "          De Acordo:"
		@ nLin, 33 PSAY w_DataEmi
		nLin += 4
		@ nLin, 75-(nTamCli+2) PSAY Replicate("_",(nTamCli+2))
		nLin += 1
		@ nLin, 75-nTamCli PSAY cCliente
		nLin += 1
		@ nLin, 75-nTamCli PSAY "("+cCodCli+")"
	End
	
	@ 48, 01 PSAY "          Data cirurgia .: "+DToC(SC5->C5_DTCIRUG)
	@ 49, 01 PSAY "          Convenio ......: "+SC5->C5_DESCCON
	@ 50, 01 PSAY "          Paciente ......: "+SC5->C5_PACIENT
	@ 51, 01 PSAY "          Cirurgiao .....: "+SC5->C5_CRMNOM
	@ 52, 01 PSAY "          Representante .: ("+SC5->C5_VEND1+")"
	@ 53, 01 PSAY "          Observacao ....: "+Substr(SC5->C5_MENNOTA,1,43)
	@ 54, 01 PSAY "                           "+Substr(SC5->C5_MENNOTA,44)
	@ 55, 01 PSAY "          * Favor nos devolver a 1a. via assinada"
	nLin:= 80
	
	DbSelectArea("SF2")
	DbSetOrder(1)
	//DbGoTo(nPosF2)
	DbSkip()
EndDo

Return
