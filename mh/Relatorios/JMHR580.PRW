#Include "protheus.ch"
#include "sigawin.ch"

#DEFINE STR0001 "Faturamento por Vendedor"
#DEFINE STR0002 "Este relatorio emite a relacao de faturamento. Podera ser"
#DEFINE STR0003 "emitido por ordem de Cliente ou por Valor (Ranking).     "
#DEFINE STR0004 "Se no TES estiver gera duplicata (N), nao sera computado."
#DEFINE STR0005 "Zebrado"
#DEFINE STR0006 "Administracao"
#DEFINE STR0007 "FATURAMENTO POR VENDEDOR  (ORDEM DECRESCENTE POR CODIGO) - "
#DEFINE STR0008 "FATURAMENTO POR VENDEDOR  (RANKING) - "
#DEFINE STR0009 "CODIGO   NOME DO VENDEDOR                                FATURAMENTO          VALOR DA                 VALOR  RANKING"
#DEFINE STR0010 "                                                         SEM ICM/IPI         MERCADORIA                TOTAL         "
#DEFINE STR0011 "Selecionando Registros..."
#DEFINE STR0012 "CANCELADO PELO OPERADOR"
#DEFINE STR0013 "Venda Sem Vendedor"
#DEFINE STR0014 "T O T A L --->"
#DEFINE STR0015 "Faturamento por Vendedor"
#DEFINE STR0016 "Este relatorio emite a relacao de faturamento. Podera ser"
#DEFINE STR0017 "emitido por ordem de Cliente ou por Valor (Ranking).     "
#DEFINE STR0018 "Se no TES estiver gera duplicata (N), nao sera computado."
#DEFINE STR0019 "Faturamento S/ ICM/IPI"
#DEFINE STR0020 "Valor da Mercadoria"
#DEFINE STR0021 "Valor Total"
#DEFINE STR0022 "Ranking"
#DEFINE STR0023 "(Ordem Decrescente de Vendedor)"
#DEFINE STR0024 "(Ordem Crescente de Ranking)"
#DEFINE STR0025 "Vendas sem Vendedor"
#DEFINE STR0026 "Vendedores"
#DEFINE STR0027 "Notas de Saida"
#DEFINE STR0028 "Devolucoes"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JMHR580  ³ Adapt ³ Fabio Briddi          ³ Data ³ 29/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fun‡…o    ³ MATR580  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Estatistica de Venda por Ordem de Vendedor                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR580(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Verificar Indexacao com vendedor                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ BRUNO        ³18/11/98³XXXXXX³Tratamento dos impostos para localizaco-³±±
±±³              ³        ³      ³es no exterior.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Viviani      ³19/11/98³18137 ³Acerto do MV_PAR09 e MV_PAR08 que esta- ³±±
±±³              ³        ³      ³vam invertidos em cDupli e cEstoq       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Viviani      ³25/11/98³Melhor³Acrescimo do xMoeda p/ conversao.       ³±±
±±³ Edson        ³30/03/99³xxxxxx³Passar tamanho na SetPrint.             ³±±
±±³ Marcello     ³26/08/00³oooooo³Impressao de casas decimais de acordo   ³±±
±±³              ³        ³      ³com a moeda selecionada.                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function JMHR580()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt  := ""
Local titulo := OemToAnsi(STR0001)	//"Faturamento por Vendedor"
Local cDesc1 := OemToAnsi(STR0002)	//"Este relatorio emite a relacao de faturamento. Podera ser"
Local cDesc2 := OemToAnsi(STR0003)	//"emitido por ordem de Cliente ou por Valor (Ranking).     "
Local CbCont,cabec1,cabec2,wnrel
Local tamanho   := "M"
Local limite    := 132
Local cString   := "SF2"
Local lContinua := .T.
Local cMoeda,nMoeda
Local cNFiscal

PRIVATE aReturn := { STR0005, 1,STR0006, 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="JMHR580"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "MTR580    "   // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01         // A partir da data                         ³
//³ mv_par02         // Ate a data                               ³
//³ mv_par03         // Do Vendedor                              ³
//³ mv_par04         // Ao Vendedor                              ³
//³ mv_par05         // Ordem (decrescente)?                     ³
//³ mv_par06         // Moeda                                    ³
//³ mv_par07         // Inclui Devolu‡„o                         ³
//³ mv_par08         // TES Qto Faturamento                      ³
//³ mv_par09         // TES Qto Estoque                          ³
//³ mv_par10         // Converte a moeda da devolucao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel  := "JMHR580"            //Nome Default do relatorio em Disco
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,"",.F.,"",,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

Processa({|lEnd| C580Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C580IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHR580			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C580Imp(lEnd,WnRel,cString)

Local titulo := OemToAnsi(STR0001)		//"Faturamento por Vendedor"
Local CbCont,cabec1,cabec2
Local tamanho:="M"
Local aCampos := {}
Local aTam	  := {}
Local nAg1:=0,nAg2:=0,nAg3:=0,nRank:=0,cVend
Local nMoeda, cMoeda:=""
Local cEstoq := If( (MV_PAR09 == 1),"S",If( (MV_PAR09 == 2),"N","SN" ) )
Local cDupli := If( (MV_PAR08 == 1),"S",If( (MV_PAR08 == 2),"N","SN" ) )

Private aTamVal:= { 16, 2 }
Private nDecs:=msdecimais(mv_par06)

nTipo:=IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1
nMoeda := mv_par06
cMoeda := GetMv("MV_MOEDA"+LTrim(STR(nMoeda)))

IF mv_par05 = 1
	titulo := OemToAnsi(STR0007)+cMoeda	//"FATURAMENTO POR VENDEDOR  (CODIGO) - "
Else
	titulo := OemToAnsi(STR0008)+cMoeda	//"FATURAMENTO POR VENDEDOR  (RANKING) - "
EndIF

cabec1 := OemToAnsi(STR0009)	//"CODIGO   NOME DO VENDEDOR                                FATURAMENTO          VALOR DA                 VALOR  RANKING"
cabec2 := OemToAnsi(STR0010)	//"                                                           SEM ICM           MERCADORIA                TOTAL         "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("F2_VEND1")
AADD(aCampos,{ "TB_VEND"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("F2_EMISSAO")
AADD(aCampos,{ "TB_EMISSAO","D",aTam[1],aTam[2] } )
aTam:=TamSX3("F2_VALFAT")
AADD(aCampos,{ "TB_VALOR1 ","N",aTam[1],aTam[2] } )
aTam:=TamSX3("F2_VALFAT")
AADD(aCampos,{ "TB_VALOR2 ","N",aTam[1],aTam[2] } )
aTam:=TamSX3("F2_VALFAT")
AADD(aCampos,{ "TB_VALOR3 ","N",aTam[1],aTam[2] } )
aTam:=TamSX3("F2_DOC")
AADD(aCampos,{ "TB_DOC    ","C",aTam[1],aTam[2] } )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq 	:= CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cNomArq,"TRB", .T. , .F. )
cNomArq1 := Subs(cNomArq,1,7)+"A"
IndRegua("TRB",cNomArq1,"TB_VEND",,,STR0011)		//"Selecionando Registros..."
aTamVal 	:= TamSX3("F2_VALFAT")
cNomArq2 := Subs(cNomArq,1,7)+"B"
IndRegua("TRB",cNomArq2,"(STRZERO(TB_VALOR3,aTamVal[1],aTamVal[2]))",,,STR0011)		//"Selecionando Registros..."
dbClearIndex()
dbSetIndex(cNomArq1+OrdBagExt())
dbSetIndex(cNomArq2+OrdBagExt())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao para gerar arquivo de Trabalho             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GeraTrab(cEstoq,cDupli)

dbSelectArea("TRB")
ProcRegua(LastRec())
If ( MV_PAR05 = 2 )
	dbSetOrder(2)
Else
	dbSetOrder(1)
EndIF
dbGoBottom()
cNFiscal := TB_DOC
While !Bof()
	
	IF lEnd
		@Prow()+1,001 PSAY STR0012		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	IncProc()
	If li > 55
		li := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li++
		@li,00 PSAY 'Periodo de: ' + Dtoc(MV_PAR01) + ' ate ' + Dtoc(MV_PAR02)
		li++
		li++
	EndIF
	cVend := TB_VEND
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ‚ venda sem vendedor                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !Empty( cVend )
		dbSelectArea("SA3")
		dbSeek(xFilial()+cVend)
		
		@li,00 PSAY A3_COD + " " +Left(A3_NOME,40)
	ELSE
		@li,00 PSAY "******" + " " + STR0013	//"Venda Sem Vendedor"
	ENDIF
	
	dbSelectArea("TRB")
	@li,50 PSAY TB_VALOR1 PicTure tm(TB_VALOR1,18,nDecs)
	@li,70 PSAY TB_VALOR2 PicTure tm(TB_VALOR2,18,nDecs)
	@li,90 PSAY TB_VALOR3 PicTure tm(TB_VALOR3,18,nDecs)
	
	IF mv_par05 == 2
		nRank++
		@li,111 PSAY nRank	PicTure "9999"
	EndIF
	li++
	
	nAg1 := nAg1 + TB_VALOR1
	nAg2 := nAg2 + TB_VALOR2
	nAg3 := nAg3 + TB_VALOR3
	
	cNFiscal := TB_DOC
	dbSkip(-1)
EndDo

IF li != 80
	@li,  0 PSAY STR0014		//"T O T A L --->"
	@li, 50 PSAY nAg1 PicTure tm(nAg1,18,nDecs)
	@li, 70 PSAY nAg2 PicTure tm(nAg2,18,nDecs)
	@li, 90 PSAY nAg3 PicTure tm(nAg3,18,nDecs)
	roda(cbcont,cbtxt)
EndIF

dbSelectArea( "TRB" )
dbCloseArea()
fErase(cNomArq+GetDBExtension())
fErase(cNomArq1+OrdBagExt())
fErase(cNomArq2+OrdBagExt())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
dbClearFilter()
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GeraTrab  ³ Autor ³ Wagner Xavier         ³ Data ³ 10.01.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera arquivo de Trabalho para emissao de Estat.de Fatur.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GeraTrab()                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraTrab(cEstoq,cDupli)

Local nContador,nTOTAL,nVALICM,nVALIPI
Local nVendedor:= Fa440CntVen()
Local aVend    := {}
Local cVend    := ""
Local aImpostos:= {}
Local nImpos	:=0.00
Local lContinua:= .F.
Local nMoedNF	 :=	1
Local nTaxa		:=	0
Local cNameSD1  :=	""
Local cNameSF1  :=	""
Local cNameSD2  :=	""
Local cNameSF2  :=	""
Local cNameSF4  :=	""
//Local cFilterQry:=	""
Local cAddField	:=	""
Local cQuery	:=	""
Local cQryAd    :=  ""
Local cName     :=  ""
Local aCampos	:=	{}
Local nCampo	:=	0
Local cCampo	:=	""
Local cAliasSD2	:=	""
Local cAliasSD1	:=	""
Local cSD2Old	:=	""
Local cSD1Old	:=	""
Local aStru		:=	{}
Local nStru		:=	0
Local nPos		:=	0
Local nValor	:=	0
Local nY        := 	0
Local aFilUsrSF1:= {}
Local lFiltro   := .T.
Local lMR580FIL := ExistBlock("MR580FIL")
Local dtMoedaDev:= CtoD("")
Local nAdic     := 0
Local nX := 0

If lMR580FIL
	aFilUsrSF1 := ExecBlock("MR580FIL",.F.,.F.,aReturn[7])
EndIf

Private cCampImp

dbSelectArea("SD2")
dbSetOrder(5)
dbSelectArea("SD1")
dbSetOrder(6)

cAliasSD2:=	GetNextAlias()

cNameSD2 := RetSqlName("SD2")
cNameSF2 := RetSqlName("SF2")
cNameSF4 := RetSqlName("SF4")

cAddField	:=	""

If SF2->(FieldPos("F2_TXMOEDA")) > 0
	cAddField += ", F2_TXMOEDA"
EndIf

If SF2->(FieldPos("F2_MOEDA")) > 0
	cAddField += ", F2_MOEDA"
EndIf

cQuery := "SELECT  SD2.*, F2_EMISSAO, F2_TIPO, F2_DOC, F2_FRETE, F2_SEGURO, F2_DESPESA, F2_FRETAUT, F2_ICMSRET, F2_VEND1 "
cQuery += " FROM " + cNameSD2 + " SD2, " + cNameSF4 + " SF4, " + cNameSF2 + " SF2 "
cQuery += " where D2_FILIAL  = '" + xFilial("SD2") + "'"
cQuery += " and D2_EMISSAO between '" + DTOS(mv_par01) + "' and '" + DTOS(mv_par02) + "'"
cQuery += " and F2_VEND1   between '" +      mv_par03  + "' and '" +      mv_par04  + "'"
cQuery += " and D2_TIPO NOT IN ('D', 'B')"
cQuery += " and F2_FILIAL  = '" + xFilial("SF2") + "'"
cQuery += " and D2_DOC     = F2_DOC"
cQuery += " and D2_SERIE   = F2_SERIE"
cQuery += " and D2_CLIENTE = F2_CLIENTE"
cQuery += " and D2_LOJA    = F2_LOJA"
cQuery += " and NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ")"
cQuery += " and F4_FILIAL  = '" + xFilial("SF4") + "'"
cQuery += " and F4_CODIGO  = D2_TES"
cQuery += " and SD2.D_E_L_E_T_ = ' '"
cQuery += " and SF2.D_E_L_E_T_ = ' '"
cQuery += " and SF4.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY " + SQLORDER (SD2->(INDEXKEY()))

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

aStru := SD2->(dbStruct())
For nStru := 1 To Len(aStru)
	If aStru[nStru,2] <> "C"
		TcSetField(cAliasSD2,aStru[nStru,1],aStru[nStru,2],aStru[nStru,3],aStru[nStru,4])
	EndIf
Next nStru

aStru	:= SF2->(dbStruct())
aCampos	:= {"F2_EMISSAO","F2_FRETE","F2_SEGURO","F2_DESPESA","F2_FRETAUT","F2_ICMSRET"}
For nCampo := 1 To Len(aCampos)
	nPos := aScan(aStru,{|x|AllTrim(x[1])==aCampos[nCampo]})
	If aStru[nPos,2] <> "C"
		TcSetField(cAliasSD2,aStru[nPos,1],aStru[nPos,2],aStru[nPos,3],aStru[nPos,4])
	EndIf
Next nCampo

ProcRegua(SD2->(LastRec())+SD1->(LastRec()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa Faturamento                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !Eof()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa Filtro do Usuario para Query                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aReturn[7]).And.!&(aReturn[7])
		dbSelectArea(cAliasSD2)
		dbSkip()
		Loop
	Endif
	
	IncProc()
	nTOTAL :=0
	nVALICM:=0
	nVALIPI:=0
	
	nTaxa	:=	IIf((cAliasSD2)->(FieldPos("F2_TXMOEDA"))>0,(cAliasSD2)->F2_TXMOEDA,0)
	nMoedNF	:=	IIf((cAliasSD2)->(FieldPos("F2_MOEDA"))>0,(cAliasSD2)->F2_MOEDA,0)
	
	If AvalTes((cAliasSD2)->D2_TES,cEstoq,cDupli)
		nVALICM += xMoeda((cAliasSD2)->D2_VALICM,1,mv_par06,(cAliasSD2)->D2_EMISSAO,nDecs+1)
		nVALIPI += xMoeda((cAliasSD2)->D2_VALIPI,1,mv_par06,(cAliasSD2)->D2_EMISSAO,nDecs+1)
		nTotal	+=	xMoeda((cAliasSD2)->D2_TOTAL,nMoedNF,mv_par06,(cAliasSD2)->D2_EMISSAO,nDecs+1,nTaxa)
		
		If ( nTotal <> 0 )
				dbSelectArea("TRB")
				dbSetOrder(1)
				cVend := (cAliasSD2)->(FieldGet(FieldPos("F2_VEND1")))
				If cVend >= mv_par03 .And. cVend <= mv_par04
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se vendedor em branco, considera apenas 1 vez        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Empty(cVend) .and. nContador > 1
						Loop
					Endif
					
					If ( aScan(aVend,cVend)==0 )
						Aadd(aVend,cVend)
					EndIf
					If (dbSeek( cVend ))
						RecLock("TRB",.F.)
					Else
						RecLock("TRB",.T.)
					EndIF
					TB_VEND    := cVend
					TB_EMISSAO := (cAliasSD2)->F2_EMISSAO
					TB_VALOR2  := TB_VALOR2+IIF((cAliasSD2)->F2_TIPO == "P",0,nTOTAL)
					TB_VALOR1  := TB_VALOR1+(nTOTAL-nVALICM)
					TB_VALOR3  := TB_VALOR3+IIF((cAliasSD2)->F2_TIPO == "P",0,nTotal)+nVALIPI
					TB_DOC	   := (cAliasSD2)->F2_DOC
					MsUnlock()
				Endif
		EndIf
	EndIf
	
	dbSelectArea(cAliasSD2)
	cSD2Old	:= (cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA
	
	// Considera Adicionais
	nAdic := 0
	If mv_par11 == 2
		nAdic := xMoeda((cAliasSD2)->F2_FRETE+(cAliasSD2)->F2_SEGURO+(cAliasSD2)->F2_DESPESA,nMoedNF,mv_par06,(cAliasSD2)->F2_EMISSAO,nDecs+1,nTaxa)
	EndIf
	nValor3  := xMoeda((cAliasSD2)->F2_FRETAUT+(cAliasSD2)->F2_ICMSRET,nMoedNF,mv_par06,(cAliasSD2)->F2_EMISSAO,nDecs+1,nTaxa)
	
	dbSkip()
	If Eof() .Or. ( (cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA!= cSD2Old )
		For nContador := 1 To Len(aVend)
			dbSelectArea("TRB")
			dbSetOrder(1)
			dbSeek(aVend[nContador])
			RecLock("TRB",.F.)
			TRB->TB_VALOR3	+= nValor3+nAdic
			MsUnLock()
		Next nContador
		aVend := {}
	EndIf
	dbSelectArea(cAliasSD2)
EndDo
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa Devolucao                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( MV_PAR07 == 1 )
	
	cAliasSD1:= GetNextAlias()
	
	cNameSD1 := RetSqlName("SD1")
	cNameSF1 := RetSqlName("SF1")
	
	cAddField	:=	""
	cQryAd      :=  ""
	
	cQuery := "select SD1.*, F1_EMISSAO, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_FRETE, F1_DESPESA, F1_SEGURO, F1_ICMSRET, F1_DTDIGIT, F2_EMISSAO, F2_VEND1"
	cQuery += " from " + cNameSD1 + " SD1, " + cNameSF4 + " SF4, " + cNameSF2 + " SF2, " + cNameSF1 + " SF1 "
	cQuery += " where D1_FILIAL  = '" + xFilial("SD1") + "'"
	cQuery += " and D1_DTDIGIT between '" + DTOS(mv_par01) + "' and '" + DTOS(mv_par02) + "'"
	cQuery += " and D1_TIPO = 'D'"
	cQuery += " and NOT ("+IsRemito(3,'SD1.D1_TIPODOC')+ ")"
	cQuery += " and F4_FILIAL  = '" + xFilial("SF4") + "'"
	cQuery += " and F4_CODIGO  = D1_TES"
	cQuery += " and F2_FILIAL  = '" + xFilial("SF2") + "'"
	cQuery += " and F2_DOC     = D1_NFORI   "
	cQuery += " and F2_SERIE   = D1_SERIORI "
	cQuery += " and F2_CLIENTE = D1_FORNECE "
	cQuery += " and F2_LOJA    = D1_LOJA "
	cQuery += " and F2_VEND1   between '" +      mv_par03  + "' and '" +      mv_par04  + "'"
	cQuery += " and F1_FILIAL  = '" + xFilial("SF1") + "'"
	cQuery += " and F1_DOC     = D1_DOC     "
	cQuery += " and F1_SERIE   = D1_SERIE"
	cQuery += " and F1_FORNECE = D1_FORNECE"
	cQuery += " and F1_LOJA    = D1_LOJA"
	cQuery += " and SD1.D_E_L_E_T_ = ' '"
	cQuery += " and SF4.D_E_L_E_T_ = ' '"
	cQuery += " and SF2.D_E_L_E_T_ = ' '"
	cQuery += " and SF1.D_E_L_E_T_ = ' '"
	//cQuery += " and (" + Left(cFilterQry,Len(cFilterQry)-4) + ")"
	cQuery += " ORDER BY " + SQLORDER (SD1->(INDEXKEY()))
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)
	
	aStru := SD1->(dbStruct())
	For nStru := 1 To Len(aStru)
		If aStru[nStru,2] <> "C"
			TcSetField(cAliasSD1,aStru[nStru,1],aStru[nStru,2],aStru[nStru,3],aStru[nStru,4])
		EndIf
	Next nStru
	
	aStru := SF2->(dbStruct())
	For nStru := 1 To Len(aStru)
		If aStru[nStru,2] <> "C"
			TcSetField(cAliasSD1,aStru[nStru,1],aStru[nStru,2],aStru[nStru,3],aStru[nStru,4])
		EndIf
	Next nStru
	
	aStru	:= SF1->(dbStruct())
	aCampos	:= {"F1_EMISSAO","F1_FRETE","F1_DESPESA","F1_SEGURO","F1_ICMSRET","F1_DTDIGIT"}
	For nCampo := 1 To Len(aCampos)
		nPos := aScan(aStru,{|x|AllTrim(x[1])==aCampos[nCampo]})
		If aStru[nPos,2] <> "C"
			TcSetField(cAliasSD1,aStru[nPos,1],aStru[nPos,2],aStru[nPos,3],aStru[nPos,4])
		EndIf
	Next nCampo
	
	While !Eof()
		IncProc()
		nTOTAL :=0
		nVALICM:=0
		nVALIPI:=0
		
		If lFiltro
			If MV_PAR10 == 1 .Or. Empty((cAliasSD1)->F2_EMISSAO)
				DtMoedaDev  := (cAliasSD1)->F1_DTDIGIT
			Else
				DtMoedaDev  := (cAliasSD1)->F2_EMISSAO
			EndIf
			
			If AvalTes((cAliasSD1)->D1_TES,cEstoq,cDupli)
				nVALICM := xMoeda((cAliasSD1)->D1_VALICM,1,mv_par06,DtMoedaDev,nDecs+1)
				nVALIPI := xMoeda((cAliasSD1)->D1_VALIPI,1,mv_par06,DtMoedaDev ,nDecs+1)
				nTOTAL  := xMoeda(((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC),1,mv_par06,DtMoedaDev,nDecs+1)
				dbSelectArea("TRB")
				dbSetOrder(1)
				cVend := (cAliasSD1)->(FieldGet((cAliasSD1)->(FieldPos("F2_VEND1"))))
				If cVend >= MV_PAR03 .And. cVend <= MV_PAR04
					If Empty(cVend) .and. nContador > 1
						Loop
					EndIf
					If ( aScan(aVend,cVend) == 0 )
						AADD(aVend,cVend)
					EndIf
					If nTOTAL > 0
						If (dbSeek( cVend ))
							RecLock("TRB",.F.)
						Else
							RecLock("TRB",.T.)
						EndIf
						TB_VEND    := cVend
						TB_EMISSAO := (cAliasSD1)->F1_EMISSAO
						TB_VALOR2  := TB_VALOR2-nTOTAL
						TB_VALOR1  := TB_VALOR1-(nTOTAL-nVALICM)
						TB_VALOR3  := TB_VALOR3-nTOTAL-nVALIPI
						TB_DOC	   := (cAliasSD1)->F1_DOC
						MsUnlock()
					EndIf
				Endif
			EndIf
			dbSelectArea(cAliasSD1)
			cSD1Old := (cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA
			nAdic := 0
			// Considera Adicionais
			If mv_par11 == 2
				nAdic := xMoeda((cAliasSD1)->F1_FRETE+(cAliasSD1)->F1_DESPESA+(cAliasSD1)->F1_SEGURO,1,mv_par06,DtMoedaDev,nDecs+1)
			EndIf
			nValor3	:= xMoeda((cAliasSD1)->F1_ICMSRET,1,mv_par06,DtMoedaDev,nDecs+1)
		EndIf
		
		dbSelectArea(cAliasSD1)
		dbSkip()
		
		If lFiltro
			If Eof() .Or. ( (cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA != cSD1Old)
				FOR nContador := 1 TO Len(aVend)
					dbSelectArea("TRB")
					dbSetOrder(1)
					cVend := aVend[nContador]
					dbSeek( cVend )
					RecLock("TRB",.F.)
					TB_VALOR3  := TB_VALOR3-nValor3-nAdic
					nValor3	:= 0
					MsUnlock()
				Next nContador
				aVend:={}
			EndIf
		EndIf
		dbSelectArea(cAliasSD1)
	EndDo
	dbCloseArea()
EndIf

Return .T.

/*/
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
/*/
