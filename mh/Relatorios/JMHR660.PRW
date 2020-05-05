#INCLUDE "MATR660.CH"
#Include "protheus.ch"
#include "sigawin.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR660  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Resumo de Vendas                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR660(void)                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Verificar indexacao dentro de programa (provisoria)         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Paulo Augusto³24/05/00³Melhor³ Alterado a impressao do IPI para Iva nas³±±
±±³              ³        ³      ³ Localizacoes                            ³±±
±±³ Marcello     ³26/08/00³oooooo³Impressao de casas decimais de acordo    ³±±
±±³              ³        ³      ³com a moeda selecionada.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function JMHR660()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt
LOCAL cString:= "SD2"
LOCAL CbCont,cabec1,cabec2,wnrel
LOCAL titulo := OemToAnsi(STR0001)	//"Resumo de Vendas"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Emissao do Relatorio de Resumo de Vendas, podendo o mesmo"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"ser emitido por ordem de Tipo de Entrada/Saida, Grupo, Tipo"
LOCAL cDesc3 := OemToAnsi(STR0004)	//"de Material ou Conta Cont bil."
LOCAL tamanho:= "M"
LOCAL limite := 132
LOCAL lImprime := .T.
cGrtxt := SPACE(11)
PRIVATE aReturn := { STR0005, 1,STR0006, 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR660"
PRIVATE nLastKey := 0
PRIVATE cPerg   := PadR("JMHR660",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 00
li       := 80
m_pag    := 01
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//AjustaSX1()
pergunte("MTR660",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01      A partir de                                    ³
//³ mv_par02      Ate a Data                                     ³
//³ mv_par03      Juros p/valor presente                         ³
//³ mv_par04      Considera Devolucao NF Orig/NF Devl/Nao Cons.  ³
//³ mv_par05      Tes Qto Estoque  Mov. X Nao Mov. X Ambas       ³
//³ mv_par06      Tes Qto Duplicata Gera X Nao Gera X Ambas      ³
//³ mv_par07      Tipo de Relatorio 1 Analitico 2 Sintetico      ³
//³ mv_par08      Qual Moeda                                     ³
//³ mv_par09      Vendedor de                                    ³
//³ mv_par10      Vendedor ate                                   ³
//³ mv_par11      Considera devolucao de compras                 ³
//³ mv_par12      Imprimir documento: original/devolucao         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="MATR660"            //Nome Default do relatorio em Disco

aOrd :={STR0007,STR0008,STR0009,STR0010,STR0011,STR0036}		//"Por Tp/Saida+Produto"###"Por Tipo    "###"Por Grupo  "###"P/Ct.Contab."###"Por Produto " ### "Por Tp Saida + Serie + Nota "

wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C660Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C660IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR660                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C660Imp(lEnd,WnRel,cString)

LOCAL CbCont,cabec1,cabec2
LOCAL titulo := OemToAnsi(STR0001)//"Resumo de Vendas )
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Emissao do Relatorio de Resumo de Vendas, podendo o mesmo"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"ser emitido por ordem de Tipo de Entrada/Saida, Grupo, Tipo"
LOCAL cDesc3 := OemToAnsi(STR0004)	//"de Material ou Conta Cont bil."
LOCAL tamanho:= "M"
LOCAL limite := 132
LOCAL lImprime := .T.
LOCAL lContinua:=.T.
LOCAL nQuant1:=0,nValor1:=0,nValIpi:=0
LOCAL nTotQtd1:=0,nTotVal1:=0,nTotIpi:=0
LOCAL nQuant2:=0,nValor2:=0,nValIpi2:=0
LOCAL nTotQtd2:=0,nTotVal2:=0,nTotIpi2:=0,nIndex:=0
LOCAL lColGrup:=.T.
LOCAL lFirst:=.T.
Local cArqSD1,cKeySD1,cFilSD1,cFilSD2:="",cArqSF2, cFilSF2
Local cEstoq := If( (MV_PAR05 == 1),"S",If( (MV_PAR05 == 2),"N","SN" ) )
Local cDupli := If( (MV_PAR06 == 1),"S",If( (MV_PAR06 == 2),"N","SN" ) )
Local cArqTrab, cIndTrab
Local aCampos := {}, aTam := {}
Local nVend:= fa440CntVen()
Local lVend:= .F.
Local cVend:= "1"
Local cVendedor := ""
//LOCAL cNomevend:=""
Local aNomeVend
Local nCntFor := 1
Local cIndice := ""
Local nImpInc:=0
Local nY:=0
Local cCampImp := ""
Local aImpostos:={}
PRIVATE nDevQtd1:=0,nDevVal1:=0,nDevIPI :=0
PRIVATE nDevQtd2:=0,nDevVal2:=0

Private nDecs:=msdecimais(mv_par08)

nOrdem := aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 00
li       := 80
m_pag    := 01

IF nOrdem = 1 .Or. nOrdem = 6 	// Tes
	cVaria := "D2_TES"
	If mv_par07 == 1			// Analitico
		cDescr1 := STR0012	//"    TIPO SAIDA   "
		cDescr2 := STR0013	//"NOTA FISCAL/SERIE"
	Else							// Sintetico
		cDescr1 := STR0014	//"      ORDEM      "
		cDescr2 := STR0015	//"    TIPO SAIDA   "
	EndIf
ElseIF nOrdem = 2	  			// Por Tipo
	cVaria := "D2_TP"
	If mv_par07 == 1        // Analitico
		cDescr1 := STR0016	//"   TIPO PRODUTO  "
		cDescr2 := STR0013	//"NOTA FISCAL/SERIE"
	Else							// Sintetico
		cDescr1 := STR0014	//"      ORDEM      "
		cDescr2 := STR0017	//"   TIPO PRODUTO  "
	EndIf
ElseIF nOrdem = 3				// Por Grupo
	cVaria := "D2_GRUPO"
	If mv_par07 == 1        // Analitico
		cDescr1 := STR0018	//"    G R U P O    "
		cDescr2 := STR0013	//"NOTA FISCAL/SERIE"
	Else                    // Analitico
		cDescr1 := STR0014	//"      ORDEM      "
		cDescr2 := STR0018	//"    G R U P O    "
	EndIf
ElseIF nOrdem = 4				// Por Conta Contabil
	cVaria := "D2_CONTA"
	If mv_par07 == 1        // Analitico
		cDescr1 := STR0019	//"    C O N T A    "
		cDescr2 := STR0013	//"NOTA FISCAL/SERIE"
	Else							// Sintetico
		cDescr1 := STR0014	//"      ORDEM      "
		cDescr2 := STR0019	//"    C O N T A    "
	EndIf
Else
	cVaria := "D2_COD"		// Ordem por produto
	If mv_par07 == 1        // Analitico
		cDescr1 := STR0020	//"  P R O D U T O  "
		cDescr2 := STR0013	//"NOTA FISCAL/SERIE"
	Else							// Sintetico
		cDescr1 := STR0014	//"      ORDEM      "
		cDescr2 := STR0020	//"  P R O D U T O  "
	EndIf
EndIF 
xVend:= mv_par09 
dbSelectArea("SA3")
dbSetOrder(1) 
dbSeek(xFilial("SA3")+ xvend)
//SA3->( DbSeek(xfilial("SA3")+ xVend) )
aNomeVend := Array(0)
while !eof().and. sa3->a3_cod <= mv_par10
	Aadd(aNomeVend, sa3->a3_cod +" - "+ trim(sa3->a3_nome))
	//cNomevend:=cNomevend+ " "+ sa3->a3_cod +" - "+ trim(sa3->a3_nome) +" - "
	dbSkip()
Enddo 

If mv_par04 # 3
	dbSelectArea( "SD1" )
	cArqSD1 := CriaTrab( NIL,.F. )
	cKeySD1 := "D1_FILIAL+D1_COD+D1_SERIORI+D1_NFORI+D1_ITEMORI"
	cFilSD1 := 'D1_FILIAL=="'+xFilial("SD1")+'".And.D1_TIPO=="D"'
	cFilSD1 += ".And. D1_COD>='"+MV_PAR13+"'.And. D1_COD<='"+MV_PAR14+"'"
	cFilSD1 += '.And. !('+IsRemito(2,'D1_TIPODOC')+')'
	If (MV_PAR04 == 2)
		cFilSD1 +=".And.DTOS(D1_DTDIGIT)>='"+DTOS(MV_PAR01)+"'.And.DTOS(D1_DTDIGIT)<='"+DTOS(MV_PAR02)+"'"
	EndIf
	IndRegua("SD1",cArqSD1,cKeySD1,,cFilSD1,STR0021)		//"Selecionando Registros..."
	nIndex := RetIndex("SD1")
	#IFNDEF TOP
		dbSetIndex(cArqSD1+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	SetRegua(RecCount())
	dbGotop()
Endif

dbSelectArea("SF2")
dbSetOrder(1)
cArqSF2 := CriaTrab( NIL,.F. )
cFilSF2 := "F2_FILIAL=='"+xFilial()+"'.And."
cFilSF2 += "DTOS(F2_EMISSAO)>='"+DTOS(mv_par01)+"'.And.DTOS(F2_EMISSAO)<='"+DTOS(mv_par02)+"'"
cFilSF2 += '.And. !('+IsRemito(2,'F2_TIPODOC')+')'
IndRegua("SF2",cArqSF2,IndexKey(),,cFilSF2,STR0021)
nIndex := RetIndex("SF2")
#IFNDEF TOP
	dbSetIndex(cArqSF2+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
dbGoTop()

dbSelectArea("SD2")
aTam := TamSx3("D2_FILIAL")
Aadd(aCampos,{"D2_FILIAL","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_COD")
Aadd(aCampos,{"D2_COD","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_LOCAL")
Aadd(aCampos,{"D2_LOCAL","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_SERIE")
Aadd(aCampos,{"D2_SERIE","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_TES")
Aadd(aCampos,{"D2_TES","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_TP")
Aadd(aCampos,{"D2_TP","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_GRUPO")
Aadd(aCampos,{"D2_GRUPO","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_CONTA")
Aadd(aCampos,{"D2_CONTA","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_EMISSAO")
Aadd(aCampos,{"D2_EMISSAO","D",aTam[1],aTam[2]})
aTam := TamSx3("D2_TIPO")
Aadd(aCampos,{"D2_TIPO","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_DOC")
Aadd(aCampos,{"D2_DOC","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_QUANT")
Aadd(aCampos,{"D2_QUANT","N",aTam[1],aTam[2]})
aTam := TamSx3("D2_TOTAL")
Aadd(aCampos,{"D2_TOTAL","N",aTam[1],aTam[2]})

if cPaisloc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
	aTam := TamSx3("D2_VALIMP1")
	Aadd(aCampos,{"D2_VALIMP1","N",aTam[1],aTam[2]})
else
	aTam := TamSx3("D2_VALIPI")
	Aadd(aCampos,{"D2_VALIPI","N",aTam[1],aTam[2]})
endif

aTam := TamSx3("D2_PRCVEN")
Aadd(aCampos,{"D2_PRCVEN","N",aTam[1],aTam[2]})
aTam := TamSx3("D2_ITEM")
Aadd(aCampos,{"D2_ITEM","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_CLIENTE")
Aadd(aCampos,{"D2_CLIENTE","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_LOJA")
Aadd(aCampos,{"D2_LOJA","C",aTam[1],aTam[2]})

//Campos para guardar a moeda/taxa da nota para a conversao durante a impressao
aTam := TamSx3("F2_MOEDA")
Aadd(aCampos,{"D2_MOEDA","N",aTam[1],aTam[2]})
aTam := TamSx3("F2_TXMOEDA")
Aadd(aCampos,{"D2_TXMOEDA","N",aTam[1],aTam[2]})

cArqTrab := CriaTrab(aCampos)
Use &cArqTrab Alias TRB New Exclusive

DbSelectArea("SD2")
If !Empty(DbFilter())
	cFilSD2 :="("+DbFilter()+").And."
EndIf
cFilSD2 += "D2_FILIAL == '"+xFilial("SD2")+"'.And."
cFilSD2 += "DTOS(D2_EMISSAO) >='"+DTOS(mv_par01)+"'.And.DTOS(D2_EMISSAO)<='"+DTOS(mv_par02)+"'"
cFilSD2 += ".And. D2_COD>='"+MV_PAR13+"'.And. D2_COD<='"+MV_PAR14+"'"
cFilSD2 += '.And. !('+IsRemito(2,'D2_TIPODOC')+')'
cFilSD2 += ".And.!(D2_ORIGLAN$'LF')"
If mv_par04==3 .Or. mv_par11 == 2
	cFilSD2 += ".And.!(D2_TIPO$'BDI')"
Else
	cFilSD2 += ".And.!(D2_TIPO$'BI')"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ha necessidade de Indexacao no SD2               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cIndice := CriaTrab("",.F.)
If nOrdem = 1 .Or. nOrdem = 6	// Por Tes
	IndRegua("SD2",cIndice,"D2_FILIAL+D2_TES+"+IIf(nOrdem==1,"D2_COD","D2_SERIE+D2_DOC"),,cFilSD2,STR0021)	//"Selecionando Registros..."
	cIndTrab := SubStr(cIndice,1,7)+"A"
	IndRegua("TRB",cIndTrab,"D2_FILIAL+D2_TES+"+IIf(nOrdem==1,"D2_COD","D2_SERIE+D2_DOC"),,,STR0021)   //"Selecionando Registros..."
ElseIF nOrdem = 2			// Por Tipo
	dbSetOrder(2)
	cIndTrab := SubStr(cIndice,1,7)+"A"
	IndRegua("TRB",cIndTrab,SD2->(IndexKey()),,,STR0021)   //"Selecionando Registros..."
ElseIF nOrdem = 3			// Por Grupo
	IndRegua("SD2",cIndice,"D2_FILIAL+D2_GRUPO+D2_COD",,cFilSD2,STR0021)	//"Selecionando Registros..."
	cIndTrab := SubStr(cIndice,1,7)+"A"
	IndRegua("TRB",cIndTrab,"D2_FILIAL+D2_GRUPO+D2_COD",,,STR0021) //"Selecionando Registros..."
ElseIF nOrdem = 4			// Por Conta Contabil
	IndRegua("SD2",cIndice,"D2_FILIAL+D2_CONTA+D2_COD",,cFilSD2,STR0021)	//"Selecionando Registros..."
	cIndTrab := SubStr(cIndice,1,7)+"A"
	IndRegua("TRB",cIndTrab,"D2_FILIAL+D2_CONTA+D2_COD",,,STR0021) //"Selecionando Registros..."
Else							// Por Produto
	IndRegua("SD2",cIndice,"D2_FILIAL+D2_COD+D2_LOCAL+D2_SERIE+D2_DOC",,cFilSD2,STR0021)		//"Selecionando Registros..."
	cIndTrab := SubStr(cIndice,1,7)+"A"
	IndRegua("TRB",cIndTrab,"D2_FILIAL+D2_COD+D2_LOCAL+D2_SERIE+D2_DOC",,,STR0021)      //"Selecionando Registros..."
EndIF
nIndex := RetIndex("SD2")
If nOrdem <> 2
	#IFNDEF TOP
		dbSetIndex(cIndice+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
EndIf
SetRegua(RecCount())
dbGoTop()

While !Eof() .And. D2_FILIAL == xFilial("SD2")
	
	IF nOrdem = 2 .and. !(&cFILSD2)
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica vendedor no SF2                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbselectarea("SF2")
	dbSeek(xFilial()+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
	
	For nCntFor := 1 To nVend
		cVendedor := SF2->(FieldGet(SF2->(FieldPos("F2_VEND"+cVend))))
		If cVendedor >= mv_par09 .and. cVendedor <= mv_par10
			lVend := .T.
			Exit
		EndIf
		cVend := Soma1(cVend,1)
	Next nCntFor
	cVend := "1"
	
	If lVend
		Reclock("TRB",.T.)
		Replace TRB->D2_FILIAL  With SD2->D2_FILIAL
		Replace TRB->D2_COD     With SD2->D2_COD
		Replace TRB->D2_LOCAL   With SD2->D2_LOCAL
		Replace TRB->D2_SERIE   With SD2->D2_SERIE
		Replace TRB->D2_TES     With SD2->D2_TES
		Replace TRB->D2_TP      With SD2->D2_TP
		Replace TRB->D2_GRUPO   With SD2->D2_GRUPO
		Replace TRB->D2_CONTA   With SD2->D2_CONTA
		Replace TRB->D2_EMISSAO With SD2->D2_EMISSAO
		Replace TRB->D2_TIPO    With SD2->D2_TIPO
		Replace TRB->D2_DOC     With SD2->D2_DOC
		Replace TRB->D2_QUANT   With SD2->D2_QUANT
		
		
		if cPaisloc<>"BRA" // Localizado para imprimir o IVA 24/05/00
			Replace TRB->D2_PRCVEN  With SD2->D2_PRCVEN
			Replace TRB->D2_TOTAL   With SD2->D2_TOTAL
			
			aImpostos:=TesImpInf(SD2->D2_TES)
			
			For nY:=1 to Len(aImpostos)
				cCampImp:="SD2->"+(aImpostos[nY][2])
				If ( aImpostos[nY][3]=="1" )
					nImpInc     += xmoeda(&cCampImp,SF2->F2_MOEDA,mv_par08,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
				EndIf
			Next
			
			Replace TRB->D2_VALImP1  With nImpInc
			nImpInc:=0
		else
			If D2_TIPO <> "P" //Complemento de IPI
				Replace TRB->D2_PRCVEN  With SD2->D2_PRCVEN
				Replace TRB->D2_TOTAL   With SD2->D2_TOTAL
			Endif
			Replace TRB->D2_VALIPI  With SD2->D2_VALIPI
		endif
		
		Replace TRB->D2_ITEM    With SD2->D2_ITEM
		Replace TRB->D2_CLIENTE With SD2->D2_CLIENTE
		Replace TRB->D2_LOJA    With SD2->D2_LOJA
		
		//--------- Grava a moeda/taxa da nota para a conversao durante a impressao
		Replace TRB->D2_MOEDA   With SF2->F2_MOEDA
		Replace TRB->D2_TXMOEDA With SF2->F2_TXMOEDA
		
		MsUnlock()
		lVend := .F.
	EndIf
	dbSelectArea("SD2")
	dbSkip()
EndDo

If mv_par04 == 2
	SF1->(dbsetorder(1))
	dbSelectArea("SD1")
	dbGoTop()
	While !Eof() .And. D1_FILIAL == xFilial("SD1")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica nota fiscal de origem e vendedor no SF2             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbselectarea("SF2")
		dbseek(xFilial()+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA)
		
		For nCntFor := 1 To nVend
			cVendedor := SF2->(FieldGet(SF2->(FieldPos("F2_VEND"+cVend))))
			If cVendedor >= mv_par09 .and. cVendedor <= mv_par10
				lVend := .T.
				Exit
			EndIf
			cVend := Soma1(cVend,1)
		Next nCntFor
		cVend := "1"
		
		dbSelectArea("SD1")
		
		If lVend
			SF1->(dbseek(SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
			Reclock("TRB",.T.)
			Replace TRB->D2_FILIAL With SD1->D1_FILIAL
			Replace TRB->D2_COD With SD1->D1_COD
			Replace TRB->D2_LOCAL With SD1->D1_LOCAL
			Replace TRB->D2_SERIE With If(mv_par12==1,SD1->D1_SERIORI,SD1->D1_SERIE)
			Replace TRB->D2_TES With SD1->D1_TES
			Replace TRB->D2_TP With SD1->D1_TP
			Replace TRB->D2_GRUPO With SD1->D1_GRUPO
			Replace TRB->D2_CONTA With SD1->D1_CONTA
			Replace TRB->D2_EMISSAO With SD1->D1_DTDIGIT
			Replace TRB->D2_TIPO With SD1->D1_TIPO
			Replace TRB->D2_DOC With If(mv_par12==1,SD1->D1_NFORI,SD1->D1_DOC)
			Replace TRB->D2_QUANT With -SD1->D1_QUANT
			Replace TRB->D2_TOTAL With -(SD1->D1_TOTAL-SD1->D1_VALDESC)
			
			If cPaisloc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
				Replace TRB->D2_VALIMP1 With - SD1->D1_VALIMP1
			Else
				Replace TRB->D2_VALIPI With -SD1->D1_VALIPI
			Endif
			
			Replace TRB->D2_ITEM With SD1->D1_ITEM
			Replace TRB->D2_CLIENTE With SD1->D1_FORNECE
			Replace TRB->D2_LOJA With SD1->D1_LOJA
			
			//--------- Grava a moeda/taxa da nota para a conversao durante a impressao
			Replace TRB->D2_MOEDA   With SF2->F2_MOEDA
			Replace TRB->D2_TXMOEDA With SF2->F2_TXMOEDA
			
			MsUnlock()
			lVend := .F.
		EndIf
		dbSelectArea("SD1")
		dbSkip()
	EndDo
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Titulos e Cabecalhos de acordo com a opcao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

titulo := STR0001 + " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))
If cPaisLoc == "BRA"
	cabec1 := " " + cDescr1 + "|" + STR0022		//"                 F A T U R A M E N T O                    |            O U T R O S   V A L O R E S          |"
	cabec2 := " " + cDescr2 + "|" + STR0023		//"  QUANT.     VAL.  UNIT.    VAL.  MERCAD.       VALOR IPI |    QUANTIDADE   VALOR UNITARIO VALOR MERCADORIA |"
Else
	cabec1 := " " + cDescr1 + "|" + STR0037		//"                 F A T U R A M E N T O                    |            O U T R O S   V A L O R E S          |"
	cabec2 := " " + cDescr2 + "|" + STR0038		//"  QUANT.     VAL.  UNIT.    VAL.  MERCAD.       VALOR IMP |    QUANTIDADE   VALOR UNITARIO VALOR MERCADORIA |"
EndIf
dbSelectArea("TRB")
dbGoTop()

SetRegua(RecCount())		// Total de Elementos da regua
                       

While !Eof() .And. lImprime
	
	IncRegua()
	
	IF lEnd
		@PROW()+1,001 PSay STR0024	//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IF nOrdem = 1 .Or. nOrdem = 6		// Por Tes
		cTesalfa := D2_TES
		dbSelectArea("SF4")
		dbSeek(xFilial()+TRB->D2_TES)
		If mv_par07 == 1 					// Analitico
			cCfText := F4_TEXTO
		Else									// Sintetico
			cCfText := Subs(F4_TEXTO,1,13)
		EndIf
		dbSelectArea("TRB")
		cTesa := cTesalfa
		cCampo:= "cTesa"
	Elseif nOrdem = 2						// Por Tipo
		cTpProd := D2_TP
		cCampo  := "cTpProd"
	Elseif nOrdem = 3						// Por Grupo
		cSubtot := SubStr(D2_GRUPO,1,4)
		cTotal  := SubStr(D2_GRUPO,1,1)
		cGrupo  := D2_GRUPO
		cCampo  := "cGrupo"
		dbSelectArea("SBM")
		dbSeek(xFilial()+TRB->D2_GRUPO)
		If mv_par07 == 1  						// Analitico
			IF Found()
				cGrTxt := Substr(Trim(SBM->BM_DESC),1,16)
			Else
				cGrTxt := SPACE(11)
			Endif
		Else											// Sintetico
			IF Found()
				cGrTxt := Trim(SBM->BM_DESC)
			Else
				cGrTxt := SPACE(11)
			Endif
		EndIf
		dbSelectArea("TRB")
	Elseif nOrdem = 4								// Por Conta Contabil
		cSubtot := SubStr(D2_CONTA,1,4)
		cTotal  := SubStr(D2_CONTA,1,1)
		cConta  := D2_CONTA
		dbSelectArea("SI1")
		dbSetOrder(1)
		dbSeek(xFilial()+TRB->D2_CONTA)
		cCampo  := "cConta"
	Else
		cCodPro := D2_COD
		cCampo  := "cCodPro"
	Endif
	
	nQuant1:=0;nValor1:=0;nValIpi:=0
	nQuant2:=0;nValor2:=0;nValIpi2:=0
	lFirst:=.T.
	
	dbSelectArea("TRB")
	
	While &cCampo = &cVaria .And. !Eof() .And. lImprime
		
		IF lEnd
			@PROW()+1,001 PSay STR0024	//"CANCELADO PELO OPERADOR"
			lImprime := .F.
			Exit
		Endif
		
		IncRegua()
		  
		If li > 58
		   			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		   		    @li,000 PSay Replicate("-",132)
		   		    li++
                    For nStart := 1 To Len(aNomeVend)
			   		    If nStart = 1
				   		    @li,000 PSay "Representante: " + aNomevend[nStart]
						Else
				   		    @li,015 PSay aNomevend[nStart]
						EndIf
			   		    li++ 
					Next
		   		    @li,000 PSay Replicate("-",132)
		   		    li++
		   		    
		   			
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Trato a Devolu‡„o de Vendas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nDevQtd1:=0;nDevVal1:=0;nDevIPI:=0
		nDevQtd2:=0;nDevVal2:=0;
		
		If mv_par04 == 1  //Devolucao pela NF Original
			CalcDev(cDupli,cEstoq)
		EndIf
		
		dbSelectArea("TRB")
		
		nQuant1 -=nDevQtd1
		nQuant2 -=nDevQtd2
		If mv_par07 == 1 .And. lFirst    // Analitico
			lFirst:=.F.
			If nOrdem = 1 .Or. nOrdem = 6		// Por Tes
				@ li,000 PSay STR0025	//"TES: "
				@ li,005 PSay cTesa
				@ li,008 PSay "-"
				@ li,009 PSay AllTrim(cCftext)
			Elseif nOrdem = 3	 				// Por Grupo
				@ li,000 PSay STR0026	//"GRUPO: "
				@ li,007 PSay cGrupo
				@ li,012 PSay "-"
				@ li,013 PSay Substr(cGrTxt,1,12)
			ElseIf nOrdem = 4					// Por Conta Contabil
				@ li,000 PSay STR0027	//"CONTA: "
				@ li,008 PSay TRIM(cConta)
				@ li,030 PSay AllTrim(SI1->I1_DESC)
			Elseif nOrdem = 2					// Por Tipo de Produto
				@ li,000 PSay STR0028	//"TIPO DE PRODUTO: "
				@ li,017 PSay cTpprod
			Else					 			// Por Produto
				@ li,000 PSay STR0029	//"PRODUTO: "
				SB1->(dbSeek(xFilial("SB1")+cCodPro))
				@ li,011 PSay Trim(cCodPro) + " " + SB1->B1_DESC
			EndIf
		Endif
		
		If AvalTes(D2_TES,cEstoq,cDupli)
			lColGrup:=.T.
			If mv_par07 == 1				// Analitico
				li++
				@ li,000 PSay D2_DOC+" / "+D2_SERIE
				@ li,018 PSay "|"
				@ li,019 PSay (D2_QUANT - nDevQtd1)	Picture PesqPictQt("D2_QUANT",11)
			EndIf
			
			nQuant1  += D2_QUANT
			
			nValor1  += xMoeda(D2_TOTAL ,D2_MOEDA,mv_par08,D2_EMISSAO,nDecs+1,D2_TXMOEDA)- nDevVal1
			
			If cPaisloc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
				nValIPI  += xMoeda(D2_VALImp1,D2_MOEDA,mv_par08,D2_EMISSAO,nDecs+1,D2_TXMOEDA)  - nDevIpi
			Else
				nValIPI  += xMoeda(D2_VALIPI ,1,mv_par08,D2_EMISSAO) -  nDevIpi
			Endif
			
			If mv_par07 == 1				// Analitico
				
				@ li,031 PSay xMoeda(D2_PRCVEN,D2_MOEDA,mv_par08,D2_EMISSAO,nDecs+1,D2_TXMOEDA) 		Picture PesqPict("SD2","D2_TOTAL",12,mv_par08)
				@ li,044 PSay xMoeda(D2_TOTAL ,D2_MOEDA,mv_par08,D2_EMISSAO,nDecs+1,D2_TXMOEDA)  - nDevVal1 Picture PesqPict("SD2","D2_TOTAL",16,mv_par08)
				
				If cPaisloc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
					@ li,061 PSay xMoeda(D2_VALIMP1 ,D2_MOEDA,mv_par08,D2_EMISSAO,nDecs+1,D2_TXMOEDA) - nDevIpi      PicTure PesqPict("SD2","D2_VALIMP1",12,mv_par08)
				Else
					@ li,061 PSay xMoeda(D2_VALIPI,1,mv_par08,D2_EMISSAO)- nDevIpi 	PicTure PesqPict("SD2","D2_VALIPI",11)
				Endif
				
				@ li,074 PSay "|"
				@ li,131 PSay "|"
			EndIf
		Else
			lColGrup:=.F.
			If mv_par07 == 1 				// Analitico
				li++
				@ li,000 PSay D2_DOC+" / "+D2_SERIE
				@ li,018 PSay "|"
				@ li,074 PSay "|"
				@ li,076 PSay (D2_QUANT - nDevQtd2)	Picture PesqPictQt("D2_QUANT",11)
			EndIf
			
			nQuant2  += D2_QUANT
			
			If D2_TIPO <> "P" //Complemento de IPI
				nValor2  += xMoeda(D2_TOTAL   ,D2_MOEDA,mv_par08,D2_EMISSAO,nDecs+1,D2_TXMOEDA) - nDevVal2
			EndIf
			
			If cPaisloc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
				nValIPI2 += xMoeda(D2_VALIMP1 ,D2_MOEDA,mv_par08,D2_EMISSAO,nDecs+1,D2_TXMOEDA) - nDevIpi
			Else
				nValIPI2 += xMoeda(D2_VALIPI,1,mv_par08,D2_EMISSAO) - nDevIpi
			Endif
			
			If mv_par07 == 1				// Analitico
				If D2_TIPO <> "P" //Complemento de IPI
					@ li,088 PSay xMoeda(D2_PRCVEN,D2_MOEDA,mv_par08,D2_EMISSAO,nDecs+1,D2_TXMOEDA) 				Picture PesqPict("SD2","D2_TOTAL",12,mv_par08)
					@ li,101 PSay xMoeda(D2_TOTAL ,D2_MOEDA,mv_par08,D2_EMISSAO,nDecs+1,D2_TXMOEDA)- nDevVal2 Picture PesqPict("SD2","D2_TOTAL",16,mv_par08)
				Else
					@ li,031 PSay 0 Picture PesqPict("SD2","D2_TOTAL",12,mv_par08)
					@ li,044 PSay 0 Picture PesqPict("SD2","D2_TOTAL",16,mv_par08)
				EndIf
				
				If cPaisloc<>"BRA" // Localizado para imprimir o IVA 24/05/00
					@ li,120 PSay xMoeda(D2_VALIMP1,D2_MOEDA,mv_par08,D2_EMISSAO,nDecs+1,D2_TXMOEDA) - nDevIpi Picture PesqPict("SD2","D2_VALIMP1",12,mv_par08)
				Else
					@ li,120 PSay xMoeda(D2_VALIPI ,D2_MOEDA,mv_par08,D2_EMISSAO) - nDevIpi 	Picture PesqPict("SD2","D2_VALIPI",11,mv_par08)
				Endif
				
				@ li,131 PSay "|"
			EndIf
		EndIf
		dbSkip()
		If li > 58
			   
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo) 
				@li,000 PSay Replicate("-",132)
		   	    li++
		   	    //@li,000 PSay "Representante: " + cNomevend
		   	    //li++ 
                For nStart := 1 To Len(aNomeVend)
		   		    If nStart = 1
			   		    @li,000 PSay "Representante: " + aNomevend[nStart]
					Else
			   		    @li,015 PSay aNomevend[nStart]
					EndIf
		   		    li++ 
				Next
		   	    @li,000 PSay Replicate("-",132)
		   	    li++
		   		    
		Endif
	End
	dbSelectArea("TRB")
	IF li > 58
	   
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@li,000 PSay Replicate("-",132)
		li++
		//@li,000 PSay "Representante: " + cNomevend
		//li++ 
        For nStart := 1 To Len(aNomeVend)
   		    If nStart = 1
	   		    @li,000 PSay "Representante: " + aNomevend[nStart]
			Else
	   		    @li,015 PSay aNomevend[nStart]
			EndIf
   		    li++ 
		Next
		@li,000 PSay Replicate("-",132)
		li++
		   		    
	Endif
	
	If nQuant1 # 0 .Or. nQuant2 # 0 .Or. nValor1 # 0 .Or. nValor2 # 0 .Or. &cCampo <> &cVaria
		If !lFirst
			li++
		EndIf
		
		IF nOrdem = 1.Or. nOrdem = 6		// TES
			If mv_par07 == 1 				// ANALITICO
				@ li,000 PSay STR0030	//"TOTAL DA TES --->"
			Else								//SINTETICO
				@ li,000 PSay cTesa
				@ li,003 PSay "-"
				@ li,004 PSay AllTrim(cCftext)
			EndIf
		Elseif nOrdem = 3				  	// GRUPO
			If mv_par07 == 1				// ANALITICO
				@ li,000 PSay STR0031	//"TOTAL DO GRUPO ->"
			Else								//SINTETICO
				@ li,000 PSay cGrupo
				@ li,005 PSay "-"
				If nOrdem = 3				// GRUPO
					@ li,006 PSay Substr(cGrTxt,1,12)
				Endif
			EndIf
		ElseIf nOrdem = 4		 			// Por Conta Contabil
			If mv_par07 == 1           // Analitico
				@ li,000 PSay STR0032	//"TOTAL DA CONTA ->"
			Else								// Sintetico
				@ li,000 PSay cConta
			EndIf
		Elseif nOrdem = 2
			If mv_par07 == 1           // Analitico
				@ li,000 PSay STR0033	//"TOTAL DO TIPO -->"
			Else								// Sintetico
				@ li,009 PSay cTpprod
			EndIf
		Else
			If mv_par07 == 1           // Analitico
				@ li,000 PSay STR0034	//"TOTAL DO PRODUTO -->"
			Else								// Sintetico
				@ li,000 PSay cCodPro
			EndIf
		Endif
		If mv_par07 == 2 					// Sintetico
			@li,018 PSay "|"
		EndIf
		If nOrdem = 1						// Por Tes
			If lColGrup
				If nQuant1 # 0
					@ li,019 PSay nQuant1		Picture PesqPictQt("D2_QUANT",11)
				EndIf
				
				@ li,042 PSay nValor1                   Picture PesqPict("SD2","D2_TOTAL",18,mv_par08)
				
				If cPaisLoc<>"BRA" // Localizado para imprimir o IVA 24/05/00
					@ li,061 PSay nValIpi         PicTure PesqPict("SD2","D2_VALIMP1",12,mv_par08)
				Else
					@ li,061 PSay nValIpi			PicTure PesqPict("SD2","D2_VALIPI",11)
				Endif
				@ li,074 PSay "|"
			Else
				@ li,074 PSay "|"
				If nQuant2 # 0
					@ li,076 PSay nQuant2		Picture PesqPictQt("D2_QUANT",11)
				EndIf
				@ li,099 PSay nValor2                   Picture PesqPict("SD2","D2_TOTAL",18,mv_par08)
				
				If cPaisloc<>"BRA" // Localizado para imprimir o IVA 24/05/00
					@ li,120 PSay nValIpi2        PicTure PesqPict("SD2","D2_VALIMP1",12,mv_par08)
				Else
					@ li,120 PSay nValIpi2     	PicTure PesqPict("SD2","D2_VALIPI",11)
				Endif
				
			EndIf
		Else
			If nQuant1 # 0
				@ li,019 PSay nQuant1		Picture PesqPictQt("D2_QUANT",11)
			EndIf
			@ li,042 PSay nValor1         Picture PesqPict("SD2","D2_TOTAL",18,mv_par08)
			
			If cPaisLoc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
				@ li,061 PSay nValIpi      PicTure PesqPict("SD2","D2_VALIMP1",12,mv_par08)
			Else
				@ li,061 PSay nValIpi		PicTure PesqPict("SD2","D2_VALIPI",11)
			Endif
			
			@ li,074 PSay "|"
			If nQuant2 # 0
				@ li,076 PSay nQuant2		Picture PesqPictQt("D2_QUANT",11)
			EndIf
			@ li,099 PSay nValor2         Picture PesqPict("SD2","D2_TOTAL",18,mv_par08)
			
			If cpaisloc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
				@ li,120 PSay nValIpi2   	PicTure PesqPict("SD2","D2_VALIMP1",12,mv_par08)
			Else
				@ li,120 PSay nValIpi2  	PicTure PesqPict("SD2","D2_VALIPI",11)
			Endif
			
		EndIf
		@ li,131 PSay "|"
		li++
		@ li,000 PSay __PrtFatLine()
		li++
		nTotQtd1  += nQuant1
		nTotVal1  += nValor1
		nTotIpi   += nValIpi
		nTotQtd2  += nQuant2
		nTotVal2  += nValor2
		nTotIpi2  += nValIpi2
		
	Endif
	dbSelectArea("TRB")
End

If li != 80
	li++
	@ li,000 PSay STR0035 	//"T O T A L  -->"
	@ li,018 PSay "|"
	@ li,019 PSay nTotQtd1 Picture PesqPictQt("D2_QUANT",11)
	
	If cPaisloc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
		@ li,042 PSay nTotVal1 Picture PesqPict("SD2","D2_TOTAL",18,mv_par08)
		@ li,061 PSay nTotIpi  Picture PesqPict("SD2","D2_VALIMP1",12,mv_par08)
	Else
		@ li,042 PSay nTotVal1 Picture PesqPict("SD2","D2_TOTAL",18)
		@ li,061 PSay nTotIpi  Picture PesqPict("SD2","D2_VALIPI",12)
	Endif
	
	@ li,074 PSay "|"
	@ li,076 PSay nTotQtd2 Picture PesqPictQt("D2_QUANT",11)
	@ li,099 PSay nTotVal2 Picture PesqPict("SD2","D2_TOTAL",18,mv_par08)
	
	If cPaisLoc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
		@ li,120 PSay nTotIpi2 Picture PesqPict("SD2","D2_VALIMP1",12,mv_par08)
	Else
		@ li,120 PSay nTotIpi2 Picture PesqPict("SD2","D2_VALIPI",11)
	Endif
	
	@ li,131 PSay "|"
	li++
	@ li,00 PSay __PrtFatLine()
	
	roda(cbcont,cbtxt,tamanho)
EndIF


IF nOrdem != 2	// Nao for por tipo
	RetIndex("SD2")
	dbClearFilter()
	IF File(cIndice+OrdBagExt())
		Ferase(cIndice+OrdBagExt())
	Endif
Endif

If mv_par04 <> 3
	dbSelectArea( "SD1" )
	RetIndex("SD1")
	dbClearFilter()
	IF File(cArqSD1+OrdBagExt())
		Ferase(cArqSD1+OrdBagExt())
	Endif
	dbSetOrder(1)
Endif

Ferase(cArqSF2+GetDBExtension())
Ferase(cArqSF2+OrdbagExt())

dbSelectArea("TRB")
cExt := OrdBagExt()
dbCloseArea()
If File(cArqTrab+GetDBExtension())
	FErase(cArqTrab+GetDBExtension())    //arquivo de trabalho
Endif
If File(cIndTrab + cExt)
	FErase(cIndTrab+cExt)	 //indice gerado
Endif

dbSelectArea("SD1")
dbClearFilter()
dbSetOrder(1)
dbSelectArea("SD2")
dbClearFilter()
dbSetOrder(1)
dbSelectArea("SF2")
dbClearFilter()
dbSetOrder(1)


If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CalcDev  ³ Autor ³     Marcos Simidu     ³ Data ³ 17.02.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo de Devolucoes                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR660                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcDev(cDup,cEst)

dbSelectArea("SD1")
If dbSeek(xFilial()+TRB->D2_COD+TRB->D2_SERIE+TRB->D2_DOC+TRB->D2_ITEM)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Soma Devolucoes          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If TRB->D2_CLIENTE+TRB->D2_LOJA == D1_FORNECE+D1_LOJA
		If !(D1_ORIGLAN == "LF")
			If AvalTes(D1_TES,cEst,cDup)
				If AvalTes(D1_TES,cEst) .And. (cEst == "S" .Or. cEst == "SN" )
					nDevQtd1+= D1_QUANT
				Endif
				nDevVal1 +=xMoeda((D1_TOTAL-D1_VALDESC),TRB->D2_MOEDA,mv_par08,D1_DTDIGIT,nDecs+1,TRB->D2_TXMOEDA)
				If cPaisLoc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
					nDevipi += xMoeda(D1_VALIMP1,TRB->D2_MOEDA,mv_par08,D1_DTDIGIT,nDecs+1,TRB->D2_TXMOEDA)
				Else
					nDevipi += xMoeda(D1_VALIPI,1,mv_par08,D1_DTDIGIT)
				Endif
				
			Else
				If AvalTes(D1_TES,cEst) .And. (cEst == "S" .Or. cEst == "SN" )
					nDevQtd2+= D1_QUANT
				Endif
				nDevVal2 +=xMoeda((D1_TOTAL-D1_VALDESC),TRB->D2_MOEDA,mv_par08,D1_DTDIGIT,nDecs+1,TRB->D2_TXMOEDA)
			Endif
		Endif
	Endif
Endif
Return .T.
