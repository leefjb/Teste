#INCLUDE "MATR650.CH"
#Include "protheus.ch"
#include "sigawin.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR650  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Notas Fiscais por Transportadora                ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR650(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Verificar indexacao dentro de programa (provisoria)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Viviani       ³09/11/98³Melhor³Conversao utillizando xMoeda            ³±±
±±³Viviani       ³23/12/98³18923 ³Acerto do calculo do valor total da nota³±±
±±³              ³        ³      ³para aceitar produto negativo(desconto) ³±±
±±³ Edson   M.   ³30/03/99³XXXXXX³Passar o tamanho na SetPrint.           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function Matr650()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt,titulo
LOCAL cDesc1 :=OemToAnsi(STR0001)	//"Este programa ira emitir a relacao de notas fiscais por"
LOCAL cDesc2 :=OemToAnsi(STR0002)	//"ordem de Transportadora."
LOCAL cDesc3 :=""
LOCAL CbCont,wnrel
LOCAL tamanho:="M"
LOCAL limite :=132
LOCAL cString:="SF2"

PRIVATE aReturn := { STR0003, 1,STR0004, 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR650"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := PadR("JMH650",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
PRIVATE cVolPict:=PesqPict("SF2","F2_VOLUME1",8)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta cabecalhos e verifica tipo de impressao                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi(STR0005)	//"Relacao das Notas Fiscais para as Transportadoras"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//AjustaSX1()
pergunte("JMH650",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                            ³
//³ mv_par01        	// Da Transportadora                        ³
//³ mv_par02        	// Ate a Transportadora                     ³
//³ mv_par03        	// Da Nota                                  ³
//³ mv_par04        	// Ate a Nota                               ³
//³ mv_par05        	// Qual moeda                               ³
//³ mv_par06        	// Da Emissao                               ³
//³ mv_par07        	// Ate Emissao                              ³
//³ mv_par08        	// Representante                            ³
//³ mv_par09        	// Local Entrega                            ³
//³ mv_par10        	// Imprime Numeraçao                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="MATR650"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C650Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C650IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR650			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C650Imp(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt,titulo
LOCAL CbCont,cabec1,cabec2
LOCAL tamanho:="M"
LOCAL nNumNota,nTotVol,nTotQtde,nTotPeso,nTotVal,nQuant,lContinua:=.T.
LOCAL nTamNF := TamSX3("F2_DOC")[1]
Local cCond  := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta cabecalhos e verifica tipo de impressao                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := STR0006 + " - " + GetMv("MV_MOEDA" + STR(MV_PAR05,1))//"RELACAO DAS NOTAS FISCAIS PARA AS TRANSPORTADORAS - MOEDA"
cabec1 := STR0012	//"REC.DEP  |EMPRESA N.FISCAL          VOLUME  N O M E  D O  C L I E N T E    QUANTIDADE        VALOR  MUNICIPIO        UF  PESO BRUTO "
//cabec1 := IIF(mv_par08==1,STR0007,STR0012)	//"REC.DEP  |EMPRESA N.FISCAL          VOLUME  N O M E  D O  C L I E N T E    QUANTIDADE        VALOR  MUNICIPIO        UF  PESO BRUTO "
//*****      				012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//*****      				0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
cabec2 := STR0008	//"DATA HORA|"
nTipo  := IIF(aReturn[4]==1,15,18)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

dbSelectArea("SF2")
cIndice := criatrab("",.f.)
cCond   := "Dtos(F2_EMISSAO)>='"+Dtos(mv_par06)+"'.And.Dtos(F2_EMISSAO)<='"+Dtos(mv_par07)+"'"
cCond   += " .And. !("+IsRemito(2,'SF2->F2_TIPODOC')+")"

IndRegua("SF2",cIndice,"F2_FILIAL+F2_TRANSP+F2_DOC+F2_SERIE",,cCond,STR0009)		//"Selecionando Registros..."

dbSeek(cFilial+mv_par01,.T.)
SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. cFilial=F2_FILIAL .And. F2_TRANSP >= mv_par01 .And. F2_TRANSP <= mv_par02 .And. lContinua
	
	If F2_TIPO == "D"
		DbSkip()
		Loop
	EndIf
	
	
	IF lEnd
		@PROW()+1,001 Psay STR0010	//"CANCELADO PELO OPERADOR"
		EXIT
	ENDIF
	IncRegua()
	
	IF F2_DOC < mv_par03 .OR. F2_DOC > mv_par04
		dbSkip()
		Loop
	EndIF
	li := 80
	nNumNota:=nTotVol:=nTotQtde:=nTotPeso:=nTotVal:=nQuant:=0
	cTransp := F2_TRANSP
	dbSelectArea("SA4")
	dbSeek(cFilial+cTransp)
	dbSelectArea("SF2")
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	//------------------------------------------
	IF MV_PAR10  ==1 // SIM
		
		DbSelectArea("SX6")
		DbSetOrder(1)
		DbGoTop()
		DbSeek(Space(2) + "MV_NUMRO")
		
		
		ULTNUM := AllTrim(SX6->X6_CONTEUD)
		ULTNUM := soma1(ULTNUM)
		//Regrava o SX6 com o ultimo numero utilizado 
		@ li,01 Psay "NUMERO " + ULTNUM   //+ MV_NUNRO
		li++
		li++
		IF !EOF()
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := ULTNUM
			DbCommit()
			MsUnlock()
		ENDIF
		
	ENDIF
	IF !empty(MV_PAR08)
		@ li,01 Psay "REPRESENTANTE - "  +  POSICIONE("SA3",1,XFILIAL("SA3")+MV_PAR08,"A3_NOME") + "CPF: " + POSICIONE("SA3",1,XFILIAL("SA3")+MV_PAR08,"A3_CGC")
		li++
	ENDIF
	@ li,01 Psay "LOCAL DE ENTREGA - "  + UPPER(mv_par09)
	li++
	li++
	@ li,01 Psay "------------------------------------------------------------------------------------------------------------------------------------"
	li++
	li++
	dbSelectArea("SF2")
	@ li,04 Psay '|    | ' + F2_TRANSP + ' - ' + PadR(SA4->A4_NOME,40)
	li++
	@ li,04 Psay '|    | '
	
	While !EOF() .AND. cFilial=F2_FILIAL .And. F2_TRANSP=cTransp
		
		IF lEnd
			@PROW()+1,001 Psay STR0010		//"CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		IncRegua()
		
		IF (F2_DOC < mv_par03 .OR. F2_DOC > mv_par04)
			dbSkip()
			Loop
		EndIF
		
		If F2_TIPO == "D"
			DbSkip()
			Loop
		EndIf
		
		If  F2_TIPO == "B"
			DbSkip()
			Loop
		EndIf
		
		dbSelectArea("SD2")
		dbSetorder(3)
		dbSeek(cFilial+SF2->F2_DOC+SF2->F2_SERIE)
		cNota := SF2->F2_DOC+SF2->F2_SERIE
		While cFilial=D2_FILIAL .And. !Eof() .And. D2_DOC+D2_SERIE == cNota
			nQuant += D2_QUANT
			dbSkip()
		End
		
		IF li > 53
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		li++
		@ li,004 Psay '|    | '
		@ li,018 Psay Substr(cNota,1,ntamNF) +"-"+Substr(cNota,nTamNF+1,3)
		dbSelectArea("SF2")
		@ li,035 Psay F2_VOLUME1   PicTure cVolPict
		If F2_TIPO <> "B"
			dbSelectArea("SA1")
			dbSeek(cFilial+SF2->F2_CLIENTE+SF2->F2_LOJA)
			IF Found()
				@ li,044 Psay SUBSTR(A1_NOME,1,25)
			EndIF
		Else
			dbSelectArea("SA2")
			dbSeek(cFilial+SF2->F2_CLIENTE+SF2->F2_LOJA)
			IF Found()
				@ li,044 Psay SUBSTR(A2_NOME,1,25)
			EndIF
		Endif
		dbSelectArea("SF2")
		@ li,074 Psay nQuant		PicTure tm(nQuant,11)
		@ li,086 Psay xMoeda(F2_VALBRUT,1,mv_par05,F2_EMISSAO) PicTure TM(F2_VALBRUT,12)
		@ li,100 Psay IIF(F2_TIPO<>"B",PadR(SA1->A1_MUN,15),PadR(SA2->A2_MUN,15))
		@ li,117 Psay IIF(F2_TIPO<>"B",SA1->A1_EST,SA2->A2_EST)
		@ li,122 Psay F2_PBRUTO	Picture TM(F2_PBRUTO,9)
		nNumNota++
		nTotVol += F2_VOLUME1
		nTotQtde+= nQuant
		nTotVal += F2_VALBRUT
		nTotPeso+= F2_PBRUTO
		nQuant := 0
		dbSkip()
	End
	li++
	@ li,04 Psay '|    |'
	li++
	@ li,00 Psay __PrtFatLine()
	li++
	@ li,002 Psay STR0011	//"TOTAL ------->"
	@ li,018 Psay nNumNota	PicTure '999'
	@ li,035 Psay nTotVol   PicTure cVolPict
	@ li,074 Psay nTotQtde	PicTure tm(nTotQtde,11)
	@ li,086 Psay xMoeda(nTotVal,1,mv_par05,F2_EMISSAO)	PicTure tm(nTotVal,12)
	@ li,122 Psay nTotPeso	PicTure tm(nTotPeso,9)
	li++
	@ li,00 Psay __PrtFatLine()
	dbSelectArea("SF2")
	nNumNota := 0
	nTotVol := 0
	nTotQtde := 0
	nTotVal := 0
	nTotPeso := 0
End

/*  Aqui gravar no SX6 o MV_NUMRO
UltNF := GetMV("MV_NUMRO")
DbSelectArea("SX6")
DbSetOrder(1)
DbSeek("  MV_NUMRO")
UltNF:=STRZERO((VAL(CDoc)+1),6)
IF !EOF()
RecLock("SX6",.F.)
Replace X6_CONTEUD   With UltNF
MsUnlock()
ENDIF
** */

If li != 80
	roda(cbcont,cbtxt)
Endif

RetIndex("SF2")
dbClearFilter()
fErase(cIndice+OrdBagExt())

dbSelectArea("SD2")
dbSetOrder(1)


If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Nereu Humberto Jr     ³ Data ³08.12.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necesarias para o programa                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/* Static Function AjustaSX1()

Local aHelpPor :={}
Local aHelpEng :={}
Local aHelpSpa :={}

/*-----------------------MV_PAR01--------------------------*/
/*Aadd( aHelpPor, "Considerar Notas Fiscais de Beneficia   " )
Aadd( aHelpPor, "mento.                                  " )

Aadd( aHelpEng, "Considerar Notas Fiscais de Beneficia   " )
Aadd( aHelpEng, "mento.                                  " )

Aadd( aHelpSpa, "Considerar Notas Fiscais de Beneficia   " )
Aadd( aHelpSpa, "mento.                                  " )

PutSx1( "MTR650","08","Considerar NF Beneficiamento ?","Considerar NF Beneficiamento ?","Considerar NF Beneficiamento ?","mv_ch8",;
"N",1,0,0,"C","","","","","mv_par08","Nao","Nao","Nao","","Sim","Sim","Sim","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

Return */
