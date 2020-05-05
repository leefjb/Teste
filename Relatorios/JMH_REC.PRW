#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/08/00
User Function JMH_REC()        // incluido pelo assistente de conversao do AP5 IDE em 08/08/00


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("cCliente, nTamCli, w_Mes, w_MesRet, w_DataEmi, n_NVias, nLin, cCidade")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN,NPOSD2,NPOSF2,W_NOREG")
SetPrvt("CPERG,NLASTKEY,LI,WNREL,WIMPRI,CSACADO,xCGC_EMP,xINSC_EMP,CCONVENIO,CSERIE,lLin")

Private cPerg := PadR("JMHRREC",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

DbSelectArea("SX1")
DBSETORDER(1)
IF !DBSEEK(cPerg)
	
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
	
ENDIF

cString  := "SD2"
cDesc1   := OemToAnsi("Este programa tem como objetivo, Emitir o Recibo de Entrega")
cDesc2   := ""
cDesc3   := ""
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog := "JMHREC"
wnrel    := "JMHREC"      //Nome Default do relatorio em Disco
cPerg    := "JMHREC"
nLastKey := 0
titulo   := "Recibo de Entrega"
cCancel  := "***** CANCELADO PELO OPERADOR *****"
nLastKey := 0
Li       := 0

Pergunte("JMHREC",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT.                       ³
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
@ PROW(),000 PSAY CHR(27)+CHR(18)

RptStatus({|| Processa(RptDetail()) })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em Disco, chama Spool.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera relatorio para Spool da Rede.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MS_FLUSH()

Return

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
cSerie    := "CRM"

DbSelectArea("SF2")
DbSetOrder(1)
dbSeek(xFilial("SF2")+MV_PAR01+cSerie,.T.)
DO WHILE SF2->F2_FILIAL ==  xFilial("SF2") .AND. SF2->F2_DOC <=  MV_PAR02 .AND. !EOF()
	
	nPosF2    := RecNo()
	n_NVias   := 1
	
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
	
	DO WHILE n_NVias > 0
		
		n_NVias :=  n_NVias - 1
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		
		DbSelectArea("SC5")
		DbSetOrder(1)
		dbSeek(xFilial("SC5")+SD2->D2_PEDIDO,.F.)
		cCliente := AllTrim(SC5->C5_CRMNOM)
		cCodCli  := AllTrim(SC5->C5_CRM)
		nTamCli  := Len(cCliente+" ("+cCodCli+")")
		cMenRec  := AllTrim(SC5->C5_MenNota)
		
		Do While .T.
			//                           012345678901234567890123456789012345678901234567890123456789012345678901234567890
			//                                     1         2         3         4         5         6         7         8 ]
			//         @ PROW(),000 PSAY "."
			@ PROW()+10,01 PSAY "                               RECIBO  DE  ENTREGA                 No.: "+SF2->F2_DOC    // SD2->D2_DOC
			@ PROW()+ 1,01 PSAY "                               -------------------"
			
			@ PROW()+ 4,01 PSAY "          Pelo  presente, entregamos o  material abaixo descrito:"
			
			@ PROW()+ 3,01 PSAY "          QTD  UN  REFERENCIA       DESCRICAO"
			
			nLin := 20
			lLin := .F.
			
			DbSelectArea("SD2")
			DbGoTo(nPosD2)
			DO WHILE SD2->D2_FILIAL==xFilial("SD2") .AND. SD2->D2_DOC==SF2->F2_DOC .AND. SD2->D2_SERIE==SF2->F2_SERIE .AND. !EOF()
				nPosD2 := RecNo()
				IncRegua()
				If SD2->D2_SERIE # cSerie
					DbSkip()
					Loop
				EndIf
				
				DbSelectArea("SB1")
				DbSeek(xFilial("SB1")+SD2->D2_COD,.F.)
				
				DbSelectArea("SD2")
				DbGoTo(nPosD2)
				@ nLin, 11 PSAY StrZero(SD2->D2_QUANT,3)
				@ nLin, 16 PSAY SD2->D2_UM
				@ nLin, 20 PSAY SD2->D2_COD
				@ nLin, 37 PSAY Substr(SB1->B1_DESC,1,40)
				nLin += 1
				DbSkip()
				If nLin > 31
					lLin := .T.
					Exit
				Else
					lLin := .F.
				EndIf
			EndDo
			If !lLin
				Exit
			Else
				nPosD2 := RecNo()
			EndIf
		EndDo
		nLin += 3
		@ nLin, 01 PSAY "          OBSERVACAO: de acordo, "
		@ nLin, 33 PSAY w_DataEmi
		nLin += 4
		@ nLin, 25 PSAY Replicate("_",(nTamCli+2))
		nLin += 1
		@ nLin, 27 PSAY cCliente + " ("+cCodCli+")"
		nLin += 4
		@ nLin, 01 PSAY "          OBSERVACAO: "+cMenRec
		
		@ 54, 01 PSAY "          * Favor nos devolver a 1a. via assinada"
		
		@ 00, 01 PSAY "."
		
	EndDo
	
	DbSelectArea("SF2")
	DbGoTo(nPosF2)
	DbSkip()
EndDo

Return
