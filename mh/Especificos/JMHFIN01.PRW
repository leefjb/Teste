#include "rwmake.ch"

User Function JMHFIN01()

//FINALIDADE, IMPRESSAO DE DUPLICATAS.
//RAFAEL, ANALISTA MICROSIGA

SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("CPERG,NLASTKEY,LI,WNREL,WIMPRI,CSACADO,xCGC_EMP,xINSC_EMP,CCONVENIO,")

cPerg    := PadR("DUPLT",Len(SX1->X1_GRUPO))

DBSELECTAREA("SX1")
DBSETORDER(1)
IF !DBSEEK("DUPLT")
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "01"
	SX1->X1_PERGUNTA := "Imprimir Por   ?"
	SX1->X1_TIPO     := "N"
	SX1->X1_TAMANHO  := 01
	SX1->X1_PRESEL   := 02
	SX1->X1_GSC      := "C"
	SX1->X1_VAR01    := "MV_PAR01"
	SX1->X1_VARIAVL  := "mv_ch1"
	SX1->X1_DEF01    := "Nota"
	SX1->X1_DEF02    := "Emissao"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "02"
	SX1->X1_PERGUNTA := "Da Nota        ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 09
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR02"
	SX1->X1_VARIAVL  := "mv_ch2"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "03"
	SX1->X1_PERGUNTA := "Ate Nota       ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 09
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR03"
	SX1->X1_VARIAVL  := "mv_ch3"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "04"
	SX1->X1_PERGUNTA := "Serie          ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 03
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR04"
	SX1->X1_VARIAVL  := "mv_ch4"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "05"
	SX1->X1_PERGUNTA := "Da Data        ?"
	SX1->X1_TIPO     := "D"
	SX1->X1_TAMANHO  := 08
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR05"
	SX1->X1_VARIAVL  := "mv_ch5"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "06"
	SX1->X1_PERGUNTA := "Ate Data        ?"
	SX1->X1_TIPO     := "D"
	SX1->X1_TAMANHO  := 08
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR06"
	SX1->X1_VARIAVL  := "mv_ch6"
	MsUnlock()
ENDIF

tamanho  := "P"
wnrel    := "JMHFIN01"
limite   := 80
titulo   := "EMISSAO DE DUPLICATAS"
cDesc1   := OemToAnsi("Este programa ir  emitir as Duplicatas conforme")
cDesc2   := OemToAnsi("parametros especificados.")
cDesc3   := ""
cString  := "SE1"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
cPerg    := PadR("DUPLT",Len(SX1->X1_GRUPO))
nLastKey := 0
Li       := 80
M_PAG    := 1

Pergunte(cPerg,.F.)


// Envia controle para a funcao SETPRINT.

SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If LastKey() == 27 .Or. nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .Or. nLastKey == 27
	Return
Endif

IF MV_PAR01 == 1
	Processa( {|| FDUPLN() },"Imprimindo Duplicatas ","Aguarde...." )
ELSE
	Processa( {|| FDUPLE() },"Imprimindo Duplicatas ","Aguarde...." )
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em Disco, chama Spool.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera relatorio para Spool da Rede.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MS_FLUSH()

RETURN


STATIC FUNCTION FDUPLN() //POR ORDEM DE NOTA

//@ PROW() ,000 PSAY CHR(27)+ chr(18)+ " "

DBSELECTAREA("SM0")
DBSETORDER(1)
xCGC_EMP  := SM0->M0_CGC
xINSC_EMP := SM0->M0_INSC

DBSELECTAREA("SX5")
DbSetOrder(1)
DBSELECTAREA("SA3")
DbSetOrder(1)
DBSELECTAREA("SC5")
DbSetOrder(1)
DBSELECTAREA("SA1")
DbSetOrder(1)
DBSELECTAREA("SE1")

DbOrderNickName("SE1NUMERO")
DBSEEK(xFilial("SE1")+MV_PAR02+MV_PAR04,.T.)

@ PROW(),0 PSAY CHR(27)+ chr(15)
@ PROW(),0 PSAY CHR(27)+ chr(50)

SETPRC(0,0)

IF Found()
	WHILE !EOF() .AND. SE1->E1_NUM >= MV_PAR02 .AND. SE1->E1_NUM <= MV_PAR03 .AND. SE1->E1_PREFIXO == MV_PAR04
		
	 /*	If SE1->E1_SALDO == 0
			DbSkip()
			Loop
		Endif  */
		wIMPRI := .T.
		SC5->(DBSEEK(xFILIAL("SC5") + SE1->E1_PEDIDO))
		cConvenio := SC5->C5_DESCCON
		IF !EMPTY(SC5->C5_SACADO) .AND. !EOF()
			cSacado := SC5->C5_SACADO + SC5->C5_LSACADO
		ELSE
			cSacado := SE1->E1_CLIENTE + SE1->E1_LOJA
		ENDIF
		
		IF wIMPRI
			@ Prow() + 4 ,074 PSAY "Classificacao Financeira : A"
			@ Prow() + 1 ,074 PSAY "Representante : " + SE1->E1_VEND1 +CHR(27)+chr(18)
			@ Prow() + 1 ,043 PSAY "CGC           : " + xCGC_EMP
			@ Prow() + 1 ,043 PSAY "Insc Estadual : " + xINSC_EMP
			@ Prow() + 3 ,005 Psay CHR(27)+chr(15)+AllTrim(SM0->M0_ENDENT)+", "+AllTrim(SM0->M0_COMPENT)+" - "+AllTrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
			@ Prow()     ,089 Psay CHR(27)+chr(18)+DToC(SE1->E1_Emissao)
			
			@ Prow() + 3 ,007 PSAY TRANSFORM(SE1->E1_VALOR, "@E 999,999.99")
			@ Prow()     ,021 PSAY SE1->E1_NUM
			@ Prow()     ,033 PSAY TRANSFORM(SE1->E1_VALOR, "@E 999,999.99")
			@ Prow()     ,047 PSAY SE1->E1_NUM + SE1->E1_PARCELA
			@ Prow()     ,057 PSAY SE1->E1_VENCTO
			@ Prow()     ,070 PSAY cCONVENIO
			
			SA1->(DBSEEK(xFILIAL("SA1") + cSacado) )
			
			@ Prow() + 4 ,021 PSAY SUBSTR(SA1->A1_NOME,1,57)
			@ Prow() + 1 ,021 PSAY SA1->A1_END
			@ Prow()     ,072 PSAY SA1->A1_CEP PICTURE "@R 99999-999"
			@ Prow() + 1 ,021 PSAY SUBSTR(SA1->A1_MUN,1,20)
			@ Prow()     ,066 PSAY SA1->A1_EST
			@ Prow()     ,073 PSAY SA1->A1_COD
			@ Prow() + 1 ,021 PSAY SA1->A1_ENDCOB
			@ Prow() + 1 ,021 PSAY SUBSTR(SA1->A1_MUNC,1,20)
			@ Prow()     ,066 PSAY SA1->A1_ESTC
			@ Prow()     ,071 PSAY SA1->A1_CEPC PICTURE "@R 99999-999"
			@ Prow() + 1 ,021 PSAY SA1->A1_CGC  PICTURE "@R 99.999.999/9999-99"
			@ Prow()     ,062 PSAY SA1->A1_INSCR
			@ Prow() + 2 ,021 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),1,58)) + REPLICATE("*",57),1,57)
			@ Prow() + 1 ,021 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),59,58)) + REPLICATE("*",57),1,57)
		EndIF
		
		@ Prow() + 10 ,000 PSAY CHR(27)+ chr(15)+" "
		DbSelectArea("SE1")
		DBSKIP()
	ENDDO
EndIf

RETURN


STATIC FUNCTION FDUPLE()   // POR ORDEM DE EMISSAO

DBSELECTAREA("SM0"); DBSETORDER(1)
xCGC_EMP  := SM0->M0_CGC
xINSC_EMP := SM0->M0_INSC

DbSelectArea("SA3"); DbSetOrder(1)
DbSelectArea("SC5"); DbSetOrder(1)
DbSelectArea("SA1"); DbSetOrder(1)
DbSelectArea("SE1"); DbSetOrder(23)
DbSeek(xFilial("SE1")+DTOS(MV_PAR05),.T.)

SETPRC(0,0)
If Found()
	
	@ PROW(),0 PSAY CHR(27)+ chr(15)
	@ PROW(),0 PSAY CHR(27)+ chr(50)
	
	
	Do While !EOF() .AND.E1_EMISSAO <= MV_PAR06
		
		If E1_PREFIXO # MV_PAR04
			dbSkip()
			Loop
		EndIf
		
		wIMPRI := .T.
		
		SC5->(DBSEEK(xFILIAL("SC5") + SE1->E1_PEDIDO))
		cConvenio := SC5->C5_DESCCON
		IF !EMPTY(SC5->C5_SACADO) .AND. !EOF()
			cSacado := SC5->C5_SACADO + SC5->C5_LSACADO
		ELSE
			cSacado := SE1->E1_CLIENTE + SE1->E1_LOJA
		ENDIF
		
		IF wIMPRI
			@ Prow() + 4 ,074 PSAY "Classificacao Financeira : A"
			@ Prow() + 1 ,074 PSAY "Representante : " + SE1->E1_VEND1 +CHR(27)+chr(18)
			@ Prow() + 1 ,043 PSAY "CGC           : " + xCGC_EMP
			@ Prow() + 1 ,043 PSAY "Insc Estadual : " + xINSC_EMP
			@ Prow() + 3 ,005 Psay CHR(27)+chr(15)+AllTrim(SM0->M0_ENDENT)+", "+AllTrim(SM0->M0_COMPENT)+" - "+AllTrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
			@ Prow()     ,089 Psay CHR(27)+chr(18)+DToC(SE1->E1_Emissao)
			
			@ Prow() + 3 ,007 PSAY TRANSFORM(SE1->E1_VALOR, "@E 999,999.99")
			@ Prow()     ,021 PSAY SE1->E1_NUM
			@ Prow()     ,033 PSAY TRANSFORM(SE1->E1_VALOR, "@E 999,999.99")
			@ Prow()     ,047 PSAY SE1->E1_NUM + SE1->E1_PARCELA
			@ Prow()     ,057 PSAY SE1->E1_VENCTO
			@ Prow()     ,070 PSAY cCONVENIO
			
			SA1->(DBSEEK(xFILIAL("SA1") + cSacado) )
			
			@ Prow() + 4 ,021 PSAY SUBSTR(SA1->A1_NOME,1,57)
			@ Prow() + 1 ,021 PSAY SA1->A1_END
			@ Prow()     ,072 PSAY SA1->A1_CEP PICTURE "@R 99999-999"
			@ Prow() + 1 ,021 PSAY SUBSTR(SA1->A1_MUN,1,20)
			@ Prow()     ,066 PSAY SA1->A1_EST
			@ Prow()     ,073 PSAY SA1->A1_COD
			@ Prow() + 1 ,021 PSAY SA1->A1_ENDCOB
			@ Prow() + 1 ,021 PSAY SUBSTR(SA1->A1_MUNC,1,20)
			@ Prow()     ,066 PSAY SA1->A1_ESTC
			@ Prow()     ,071 PSAY SA1->A1_CEPC PICTURE "@R 99999-999"
			@ Prow() + 1 ,021 PSAY SA1->A1_CGC  PICTURE "@R 99.999.999/9999-99"
			@ Prow()     ,062 PSAY SA1->A1_INSCR
			@ Prow() + 2 ,021 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),1,58)) + REPLICATE("*",57),1,57)
			@ Prow() + 1 ,021 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),59,58)) + REPLICATE("*",57),1,57)
		EndIF
		
		@ Prow() + 10 ,000 PSAY CHR(27)+ chr(15)+" "
		
		
		DbSelectArea("SE1")
		DbSkip()
	EndDO
EndIf

RETURN

