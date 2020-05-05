#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR260  ³ Autor ³ Eveli Morasco         ³ Data ³ 01/03/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Estoques                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Pim.³09/12/97³09827A³Ajuste da descricao p/ 30 caracteres.     ³±±
±±³Fernando J. ³25/09/98³17720A³ Corre‡„o no Salto de Linhas.             ³±±
±±³Fernando J. ³02/12/98³18752A³A fun‡„o PesqPictQT foi substituida pela  ³±±
±±³            ³        ³      ³PesqPict.                                 ³±±
±±³Fernando J. ³21/12/98³18920A³Possibilitar filtragem pelo usuario.      ³±±
±±³Rodrigo Sart³08/02/99³META  ³Avaliacao da qtd empenhada prevista.      ³±±
±±³Cesar       ³30/03/99³XXXXXX³Manutencao na SetPrint()                  ³±±
±±³Patricia Sal³28/01/00³002121³Aumento da picture dos campos.            ³±±
±±³Jeremias    ³09.02.00³Melhor³Validacao da comparacao dos valores e da  ³±±
±±³            ³        ³      ³qtde quando do calculo do custo medio.    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

USER Function JMHEST

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local Titulo   := "Relacao da Posicao do Estoque" //STR0001 //
Local wnrel    := "MATR260"
Local cDesc1   := "Este relatorio emite a posicao dos saldos e empenhos de cada  produto"//STR0002 //
Local cDesc2   := "em estoque. Ele tambem mostrara' o saldo disponivel ,ou seja ,o saldo"//STR0003       //
Local cDesc3   := "subtraido dos empenhos." //STR0004       //
Local cString  := "SB1"
Local aOrd     := {OemToAnsi(" Por Codigo         "),OemToAnsi(" Por Tipo           "),OemToAnsi(" Por Descricao     "),OemToAnsi(" Por Grupo        "),OemToAnsi(" Por Almoxarifado   ")}    //" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "###" Por Almoxarifado   "
//Local aOrd     := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009)}    //" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "###" Por Almoxarifado   "
Local lEnd     := .F.
Local Tamanho  := "M"
LOCAL aHelpPor:={},aHelpEng:={},aHelpSpa:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn  := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }   //"Zebrado"###"Administracao"
//PRIVATE aReturn  := {OemToAnsi(STR0010), 1,OemToAnsi(STR0011), 2, 2, 1, "",1 }   //"Zebrado"###"Administracao"
PRIVATE nLastKey := 0
PRIVATE lCusUnif := SuperGetMV('MV_CUSFIL',.F.) //-- Identifica qdo utiliza custo por empresa

Private cPerg := PadR("JMHREST",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

//Ajustasx1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                ³
//³ mv_par01     // Aglutina por: Almoxarifado / Filial / Empresa       ³
//³ mv_par02     // Filial de       *                                   ³
//³ mv_par03     // Filial ate      *                                   ³
//³ mv_par04     // almoxarifado de *                                   ³
//³ mv_par05     // almoxarifado ate*                                   ³
//³ mv_par06     // codigo de       *                                   ³
//³ mv_par07     // codigo ate      *                                   ³
//³ mv_par08     // tipo de         *                                   ³
//³ mv_par09     // tipo ate        *                                   ³
//³ mv_par10     // grupo de        *                                   ³
//³ mv_par11     // grupo ate       *                                   ³
//³ mv_par12     // descricao de    *                                   ³
//³ mv_par13     // descricao ate   *                                   ³
//³ mv_par14     // imprime produtos: Todos /Positivos /Negativos       ³
//³ mv_par15     // Saldo a considerar : Atual / Fechamento / Movimento |
//³ mv_par16     // Qual Moeda (1 a 5)                                  ³
//³ mv_par17     // Aglutina por UM ?(S)im (N)ao                        ³
//³ mv_par18     // Lista itens zerados ? (S)im (N)ao                   ³
//³ mv_par19     // Imprimir o Valor ? Custo / Custo Std / Ult Prc Compr³
//³ mv_par20     // Data de Referencia                                  ³
//³ mv_par21     // Lista valores zerados ? (S)im (N)ao                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Aadd( aHelpPor, "Data de referencia para calculo do saldo" )
//Aadd( aHelpPor, "do produto quando utiliza saldo por     " )
//Aadd( aHelpPor, "movimento.                              " )
//Aadd( aHelpEng, "Reference date for product`s balances   " )
//Aadd( aHelpEng, "calculation, when using balance per     " )
//Aadd( aHelpEng, "transaction/movement.                   " )
//Aadd( aHelpSpa, "Fecha de referencia para calculo del    " )
//Aadd( aHelpSpa, "saldo del producto cuando usa saldo por " )
//Aadd( aHelpSpa, "movimiento.                             " )
//PutSx1( "MTR260", "20","Data de Referencia  ","Data de Referencia  ","Reference Date           ","mv_chK","D",8,0,0,"G","","","","",;
//	"mv_par20","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

pergunte(cPerg,.F.)

//If lCusUnif //-- Ajusta as perguntas para Custo Unificado
//	MA260PergU()
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
If nLastKey = 27
	dbClearFilter()
	Return
Endif
/*
If lCusUnif .And. ((mv_par01==1).Or.!(mv_par04=='**').Or.!(mv_par05=='**').Or.aReturn[8]==5) //-- Ajusta as perguntas para Custo Unificado
	If Aviso(STR0024, STR0025+CHR(10)+CHR(13)+STR0029+CHR(10)+CHR(13)+STR0026+CHR(10)+CHR(13)+STR0027+CHR(10)+CHR(13)+STR0028+CHR(10)+CHR(13)+STR0030, {STR0031,STR0032}) == 2
		dbClearFilter()
		Return Nil
	EndIf	
EndIf
*/
If mv_par04 == '**'
	mv_par04 := '  '
EndIf
If mv_par05 == '**'
	mv_par05 := 'zz'
Endif

SetDefault(aReturn,cString)
If nLastKey = 27
	dbClearFilter()
	Return
Endif

mv_par16 := If( ((mv_par16 < 1) .Or. (mv_par16 > 5)),1,mv_par16 )
Tipo     := IIF(aReturn[4]==1,15,18)

If Type("NewHead")#"U"
	Titulo := (NewHead+" ("+AllTrim( aOrd[ aReturn[ 8 ] ] )+")")
Else
	Titulo += " ("+AllTrim( aOrd[ aReturn[ 8 ] ] )+")"
EndIf

cFileTRB := ""
RptStatus( { | lEnd | cFileTRB := r260Select( @lEnd ) },Titulo+": Preparacao..." ) //": Preparacao..."

If !Empty( cFileTRB )
	RptStatus({|lEnd| R260Imprime( @lEnd,cFileTRB,Titulo,wNRel,Tamanho,Tipo,aReturn[ 8 ] )},titulo)
EndIf

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R260SELECT³ Autor ³ Ben-Hur M. Castilho   ³ Data ³ 20/11/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preparacao do Arquivo de Trabalho p/ Relatorio             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R260Select( lEnd )
PRIVATE cFileTRB := ""
PRIVATE cQuery := "",;
	cIndxKEY := "",;
	aSizeQT  := TamSX3( "B2_QATU" ),;
  	aSizeVL  := TamSX3( "B2_CM1"),;
	aSaldo   := {},;
	nQuant   := 0,;
	nValor   := 0,;
	nQuantR  := 0,;
	nValorR  := 0,;
	cFilOK   := cFilAnt,;
	cAl1	 := "SB1", cAl2 := "SB2", lExcl := .f.,dDataRef

PRIVATE aCampos := {	{ "FILIAL","C",02,00 },;
	{ "CODIGO","C",15,00 },;
	{ "LOCAL ","C",02,00 },;
	{ "TIPO  ","C",02,00 },;
	{ "GRUPO ","C",04,00 },;
	{ "DESCRI","C",21,00 },;
	{ "UM    ","C",02,00 },;
	{ "VALORR","N",aSizeVL[ 1 ]+1, aSizeVL[ 2 ] },;
	{ "QUANTR","N",aSizeQT[ 1 ]+1, aSizeQT[ 2 ] },;
	{ "VALOR ","N",aSizeVL[ 1 ]+1, aSizeVL[ 2 ] },;
	{ "QUANT ","N",aSizeQT[ 1 ]+1, aSizeQT[ 2 ] } }

PRIVATE aStruSB1 := {}
PRIVATE cName
PRIVATE cQryAd := ""
PRIVATE nX

pergunte(cPerg,.F.)

dDataRef := Iif(Empty(mv_par20),dDataBase,mv_par20)

If (mv_par01 == 1)
	If (aReturn[ 8 ] == 5)
		cIndxKEY := "LOCAL+"
	Else
		cIndxKEY := "FILIAL+"
	EndIf
	
	If (mv_par17 == 1)
		cIndxKEY += "UM+"
	EndIf
	
	Do Case
	Case (aReturn[ 8 ] == 1)
		cIndxKEY += "CODIGO+LOCAL"
	Case (aReturn[ 8 ] == 2)
		cIndxKEY += "TIPO+CODIGO+LOCAL"
	Case (aReturn[ 8 ] == 3)
		cIndxKEY += "DESCRI+CODIGO+LOCAL"
	Case (aReturn[ 8 ] == 4)
		cIndxKEY += "GRUPO+CODIGO+LOCAL"
	Case (aReturn[ 8 ] == 5)
		cIndxKEY += "CODIGO+FILIAL"
	EndCase
Else
	If (aReturn[ 8 ] == 5)
		cIndxKEY := "LOCAL+"
	Else
		cIndxKEY := ""
	EndIf
	
	If (mv_par17 == 1)
		cIndxKEY += "UM+"
	EndIf
	
	Do Case
	Case (aReturn[ 8 ] == 1)
		cIndxKEY += "CODIGO+FILIAL+LOCAL"
	Case (aReturn[ 8 ] == 2)
		cIndxKEY += "TIPO+CODIGO+FILIAL+LOCAL"
	Case (aReturn[ 8 ] == 3)
		cIndxKEY += "DESCRI+CODIGO+FILIAL+LOCAL"
	Case (aReturn[ 8 ] == 4)
		cIndxKEY += "GRUPO+CODIGO+FILIAL+LOCAL"
	Case (aReturn[ 8 ] == 5)
		cIndxKEY += "CODIGO+FILIAL"
	EndCase
EndIf

cFileTRB := CriaTrab( nil,.F. )

DbSelectArea( 0 )
DbCreate( cFileTRB,aCampos )

DbUseArea( .F.,,cFileTRB,cFileTRB,.F.,.F. )
IndRegua( cFileTRB,cFileTRB,cIndxKEY,,,OemToAnsi("Organizando Arquivo..."))   //"Organizando Arquivo..."

DbSelectArea( "SB2" )
SetRegua( LastRec() )

#IFDEF TOP
	cQuery := "SELECT B2_FILIAL, B2_LOCAL, B2_COD, B2_QATU, B2_QFIM,B2_CM1, B2_VATU2, B2_VATU3, B2_VATU4, B2_VATU5, "
	cQuery += " B2_VFIMFF1, B2_VFIMFF2, B2_VFIMFF3, B2_VFIMFF4, B2_VFIMFF5, B2_QEMP, B2_RESERVA, B2_QEMPSA, B2_VFIM1, "
	cQuery += " B2_VFIM2, B2_VFIM3, B2_VFIM4, B2_VFIM5, B1_COD, B1_FILIAL, B1_TIPO, B1_GRUPO, B1_DESC, B1_GRUPO, B1_CUSTD, B1_UPRC, B1_UM "

	aStruSB1 := SB1->(dbStruct())

	If !Empty(aReturn[7])
		For nX := 1 To SB1->(FCount())
			cName := SB1->(FieldName(nX))
			If AllTrim( cName ) $ aReturn[7]
				If aStruSB1[nX,2] <> "M"
					If !cName $ cQuery .And. !cName $ cQryAd
						cQryAd += "," + cName
					EndIf
				EndIf
			EndIf
		Next nX
	EndIf

	cQuery += cQryAd

	cQuery += " FROM " + RetSqlName("SB2") + " B2, " + RetSqlName("SB1") + " B1"
	cQuery += " WHERE B2_FILIAL BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'"
	cQuery += "   AND B2_LOCAL  BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'"
	cQuery += "   AND B2_COD    BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'"
	cQuery += "   AND B2.D_E_L_E_T_ = ' '"
	cQuery += "   AND B2_COD = B1_COD"
	cQuery += "   AND B1_FILIAL = '" + xFilial( "SB1" ) + "'"
	cQuery += "   AND B1.D_E_L_E_T_ = ' '"
	cQuery += "   AND B1_TIPO  between '" + MV_PAR08 + "' AND '" + MV_PAR09 + "'"
	cQuery += "   AND B1_GRUPO between '" + MV_PAR10 + "' AND '" + MV_PAR11 + "'"
	cQuery += "   AND B1_DESC  between '" + MV_PAR12 + "' AND '" + MV_PAR13 + "'"
	
	cAl1 := "xxSB2"
	cAl2 := "xxSB2"
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAl2, .F., .T.)

	aEval(SB2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAl2,x[1],x[2],x[3],x[4]),Nil)})
	aEval(SB1->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAl2,x[1],x[2],x[3],x[4]),Nil)})
#ELSE
	dbSetOrder(1)
	dbSeek(MV_PAR02+MV_PAR06+MV_PAR04,.t.)
#ENDIF

IF xFilial("SB2") != "  "
	lExcl := .t.
Endif

While !Eof()
	IF lExcl
		cFilAnt := (cAl2)->B2_FILIAL
	Endif
	IncRegua()
	
	If ((((cAl2)->B2_FILIAL >= MV_PAR02) .And. ((cAl2)->B2_FILIAL <= MV_PAR03)) .And. ;
			(((cAl2)->B2_Local  >= MV_PAR04) .And. ((cAl2)->B2_Local  <= MV_PAR05)) .And. ;
			(((cAl2)->B2_COD    >= MV_PAR06) .And. ((cAl2)->B2_COD    <= MV_PAR07)))
		
		#IFNDEF TOP
		dbSelectArea( cAl1 )
		dbSetOrder(1)
		If (DbSeek( xFilial()+(cAl2)->B2_COD) )
		#ENDIF
			If ((((cAl1)->B1_TIPO  >= MV_PAR08) .And. ((cAl1)->B1_TIPO  <= MV_PAR09)) .And. ;
					(((cAl1)->B1_GRUPO >= MV_PAR10) .And. ((cAl1)->B1_GRUPO <= MV_PAR11)) .And. ;
					(((cAl1)->B1_DESC  >= MV_PAR12) .And. ((cAl1)->B1_DESC  <= MV_PAR13)) .And. ;
					((!Empty(aReturn[7]) .And. &(aReturn[7])).Or.Empty(aReturn[7])))
				
				Do Case
				Case (mv_par15 == 1)
					nQuant := (cAl2)->B2_QATU
				Case (mv_par15 == 2)
					nQuant := (cAl2)->B2_QFIM
				OtherWise
					nQuant := (aSaldo := CalcEst( (cAl2)->B2_COD,(cAl2)->B2_LOCAL,dDataRef+1,(cAl2)->B2_FILIAL ))[ 1 ]
				EndCase
				
				
				dbSelectArea( cAl1 )
				If  ((mv_par14 == 1) .Or. ;
						((mv_par14 == 2) .And.(nQuant >= 0)) .Or. ;
						((mv_par14 == 3) .And.(nQuant < 0)))
					
					Do Case
					Case (mv_par15 == 1)
						nValor := (cAl2)->(FieldGet( FieldPos( "B2_CM"+Str( mv_par16,1 ) ) ))
					Case (mv_par15 == 2)
						nValor := (cAl2)->(FieldGet( FieldPos( "B2_CM"+Str( mv_par16,1 ) ) ))
					Case (mv_par15 == 3)
						nValor := aSaldo[ 1+mv_par16 ]
					EndCase
					Do Case
					Case (mv_par19 == 2)
						nValor := nQuant * SB1->B1_CUSTD
					Case (mv_par19 == 3)
						nValor := nQuant * SB1->B1_UPRC
					EndCase
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se devera ser impresso itens zerados                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (mv_par18==2)  .And. (QtdComp(nQuant)==QtdComp(0))
						dbSelectArea( cAl2 )
						dbSkip()
						Loop
					EndIf					
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se devera ser impresso valores zerados              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (mv_par21==2) .And. (QtdComp(nValor)==QtdComp(0))
						dbSelectArea( cAl2 )
						dbSkip()
						Loop
					EndIf
					
					nQuantR := (cAl2)->B2_QEMP + AvalQtdPre("SB2",1,NIL,cAl2) + (cAl2)->B2_RESERVA + (cAl2)->B2_QEMPSA
					nValorR := (QtdComp(nValor) / QtdComp(nQuant)) * QtdComp(nQuantR)
					
					DbSelectArea( cFileTRB )
					DbAppend()
					
					FIELD->FILIAL := (cAl2)->B2_FILIAL
					FIELD->CODIGO := (cAl2)->B2_COD
					FIELD->LOCAL  := (cAl2)->B2_LOCAL
					FIELD->TIPO   := (cAl1)->B1_TIPO
					FIELD->GRUPO  := (cAl1)->B1_GRUPO
					FIELD->DESCRI := (cAl1)->B1_DESC
					FIELD->UM     := (cAl1)->B1_UM
					FIELD->QUANTR := nQuantR
					FIELD->VALORR := nValorR
					FIELD->QUANT  := nQuant
					FIELD->VALOR  := nValor
				EndIf
			EndIf
		#IFNDEF TOP
		EndIf
		#ENDIF
		DbSelectArea( cAl2 )
	EndIf
	
	DbSkip()
EndDo

cFilAnt := cFilOk

#IFDEF TOP
	dbSelectArea(cAl2)
	dbCloseArea()
	ChkFIle("SB2",.f.)
#ENDIF

dbSelectArea("SB1")
dbClearFilter()

Return( cFileTRB )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R260IMPRIM³ Autor ³ Ben-Hur M. Castilho   ³ Data ³ 20/11/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preparacao do Arquivo de Trabalho p/ Relatorio             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function R260Imprime( lEnd,cFileTRB,cTitulo,wNRel,cTam,nTipo,nOrdem )

#define DET_SIZE  13

#define DET_CODE   1
#define DET_TIPO   2
#define DET_GRUP   3
#define DET_DESC   4
#define DET_UM     5
#define DET_FL     6
#define DET_ALMX   7
#define DET_SALD   8
#define DET_EMPN   9
#define DET_DISP  10
#define DET_VEST  11
#define DET_VEMP  12
#define DET_KEYV  13

#define ACM_SIZE   6

#define ACM_CODE   1
#define ACM_SALD   2
#define ACM_EMPN   3
#define ACM_DISP   4
#define ACM_VEST   5
#define ACM_VEMP   6

Local aPrnDET   := nil,;
	aTotUM    := nil,;
	aTotORD   := nil

Local cLPrnCd   := ""

Local lPrintCAB := .F.,;
	lPrintDET := .F.,;
	lPrintTOT := .F.,;
	lPrintOUT := .F.,;
	lPrintLIN := .F.

Local nTotValEst:=0,;
	nTotValEmp:=0,;
	nTotValSal:=0,;
	nTotValRPR:=0,;
	nTotValRes:=0

Local cPicture  := PesqPict("SB2", If( (mv_par15 == 1),"B2_QATU","B2_QFIM" ),14 )
Local cPicVal    := PesqPict("SB2","B2_CM"+Str(mv_par16,1),15)

Private Li    := 80,;
	M_Pag := 1

cCab01 := OemToAnsi("CODIGO          TP GRUP DESCRICAO             UM FL ALM   SALDO       EMPENHO PARA     ESTOQUE      ___________V A L O R___________")
cCab02 := OemToAnsi("                                                          EM ESTOQUE  REQ/PV/RESERVA   DISPONIVEL   CUSTO UNITARIO       EMPENHADO ")
//  	                                   123456789012345 12 1234 123456789012345678901 12 12 12 999,999,999.99 999,999,999.99 9999,999,999.99 9999,999,999.99 9999,999,999.99
//      	                               0         1         2         3         4         5         6         7         8         9        10        11        12        13
//          	                           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

DbSelectArea( cFileTRB ) ; DbGoTop()

While !Eof()
	
	If (LastKey() == 286) ; Exit ; EndIf
	
	If (aPrnDET == nil)
		
		aPrnDET := Array( DET_SIZE )
		
		aPrnDET[ DET_CODE ] := FIELD->CODIGO
		aPrnDET[ DET_TIPO ] := FIELD->TIPO
		aPrnDET[ DET_GRUP ] := FIELD->GRUPO
		aPrnDET[ DET_DESC ] := FIELD->DESCRI
		aPrnDET[ DET_UM   ] := FIELD->UM
		
		aPrnDET[ DET_FL   ] := ""
		aPrnDET[ DET_ALMX ] := ""
		aPrnDET[ DET_SALD ] := 0
		aPrnDET[ DET_EMPN ] := 0
		aPrnDET[ DET_DISP ] := 0
		aPrnDET[ DET_VEST ] := 0
		aPrnDET[ DET_VEMP ] := 0
		
		aPrnDET[ DET_KEYV ] := ""
	EndIf
	
	If (mv_par17 == 1) .And. (aTotUM == nil)
		
		aTotUM := { FIELD->UM,0,0,0,0,0 }
	EndIf
	
	If (((nOrdem == 2) .Or. (nOrdem == 4)) .And. (aTotORD == nil))
		
		aTotORD := { If( (nOrdem == 2),FIELD->TIPO,FIELD->GRUPO ),0,0,0,0,0 }
	EndIf
	
	Do Case
	Case (mv_par01 == 1)
		
		aPrnDET[ DET_FL   ] := FIELD->FILIAL
		aPrnDET[ DET_ALMX ] := FIELD->LOCAL
		
	Case ((mv_par01 == 2) .And. (aPrnDET[ DET_KEYV ] == ""))
		
		aPrnDET[ DET_FL   ] := FIELD->FILIAL
		aPrnDET[ DET_ALMX ] := If( (aReturn[ 8 ] == 5),FIELD->Local,"**" )
		
	Case ((mv_par01 == 3) .And. (aPrnDET[ DET_KEYV ] == ""))
		
		aPrnDET[ DET_FL   ] := "**"
		aPrnDET[ DET_ALMX ] := If( (aReturn[ 8 ] == 5),FIELD->Local,"**" )
	EndCase
	
	If aPrnDET[ DET_KEYV ] == ""
		Do Case
		Case (mv_par01 == 1)
			If (aReturn[ 8 ] == 5)
				aPrnDET[ DET_KEYV ] := FIELD->Local+FIELD->CODIGO+FIELD->FILIAL
			Else
				aPrnDET[ DET_KEYV ] := FIELD->CODIGO+FIELD->FILIAL+FIELD->Local
			Endif
		Case (mv_par01 == 2)
			If (aReturn[ 8 ] == 5)
				aPrnDET[ DET_KEYV ] := FIELD->Local+FIELD->CODIGO+FIELD->FILIAL
			Else
				aPrnDET[ DET_KEYV ] := FIELD->CODIGO+FIELD->FILIAL
			Endif
		Case (mv_par01 == 3)
			If (aReturn[ 8 ] == 5)
				aPrnDET[ DET_KEYV ] := FIELD->Local+FIELD->CODIGO
			Else
				aPrnDET[ DET_KEYV ] := FIELD->CODIGO
			Endif
		EndCase
	EndIf
	
	aPrnDET[ DET_SALD ] += FIELD->QUANT
	aPrnDET[ DET_EMPN ] += FIELD->QUANTR
	aPrnDET[ DET_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
	aPrnDET[ DET_VEST ] += FIELD->VALOR
	aPrnDET[ DET_VEMP ] += FIELD->VALORR
	
	If (mv_par17 == 1)
		
		aTotUM[ ACM_SALD ] += FIELD->QUANT
		aTotUM[ ACM_EMPN ] += FIELD->QUANTR
		aTotUM[ ACM_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
		aTotUM[ ACM_VEST ] += FIELD->VALOR
		aTotUM[ ACM_VEMP ] += FIELD->VALORR
	EndIf
	
	If ((nOrdem == 2) .Or. (nOrdem == 4))
		
		aTotORD[ ACM_SALD ] += FIELD->QUANT
		aTotORD[ ACM_EMPN ] += FIELD->QUANTR
		aTotORD[ ACM_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
		aTotORD[ ACM_VEST ] += FIELD->VALOR
		aTotORD[ ACM_VEMP ] += FIELD->VALORR
	EndIf
	
	DbSkip()
	
	Do Case
	Case (mv_par01 == 1)
		If (aReturn[ 8 ] == 5)
			lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+FIELD->CODIGO+FIELD->FILIAL)
		Else
			lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODIGO+FIELD->FILIAL+FIELD->Local)
		Endif
	Case (mv_par01 == 2)
		If (aReturn[ 8 ] == 5)
			lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+FIELD->CODIGO+FIELD->FILIAL)
		Else
			lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODIGO+FIELD->FILIAL)
		Endif
	Case (mv_par01 == 3)
		If (aReturn[ 8 ] == 5)
			lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+FIELD->CODIGO)
		Else
			lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODIGO)
		Endif
	EndCase
	
	If lCusUnif .And. lPrintDET
		If (mv_par18==2) .And. (QtdComp(aPrnDET[DET_SALD])==QtdComp(0))
			aPrnDET := Nil
			Loop	
		EndIf	
	EndIf
	Do Case
	Case ((mv_par17 == 1) .And. ;
			!(aTotUM[ ACM_CODE ] == FIELD->UM))
		
		lPrintTOT := .T.
	Case (( (nOrdem == 2) .Or. (nOrdem == 4) ) .And. ;
			!(aTotORD[ ACM_CODE ] == If( (nOrdem == 2),FIELD->TIPO,FIELD->GRUPO )))
		
		lPrintTOT := .T.
	EndCase
	
	If lPrintDET .Or. lPrintTOT
		
		If (Li > 56)
			
			Cabec( cTitulo,cCab01,cCab02,wNRel,cTam,nTipo )
		EndIf
		
		Do Case
		Case !(aPrnDET[ DET_CODE ] == cLPrnCd)
			
			cLPrnCd := aPrnDET[ DET_CODE ] ; lPrintCAB := .T.
		EndCase
		
		If lPrintCAB .Or. lPrintOUT
			
			@ Li,000 PSay aPrnDET[ DET_CODE ]
			@ Li,016 PSay aPrnDET[ DET_TIPO ]
			@ Li,019 PSay aPrnDET[ DET_GRUP ]
			@ Li,024 PSay aPrnDET[ DET_DESC ]
			@ Li,046 PSay aPrnDET[ DET_UM   ]
			
			lPrintCAB := .F. ; lPrintOUT := .F.
		EndIf
		
		@ Li,049 PSay aPrnDET[ DET_FL   ]
		@ Li,052 PSay aPrnDET[ DET_ALMX ]
		@ Li,054 PSay aPrnDET[ DET_SALD ] Picture cPicture
		@ Li,070 PSay aPrnDET[ DET_EMPN ] Picture cPicture
		@ Li,085 PSay aPrnDET[ DET_DISP ] Picture cPicture
		@ Li,100 PSay aPrnDET[ DET_VEST ] Picture cPicVal
		@ Li,117 PSay aPrnDET[ DET_VEMP ] Picture cPicVal
		
		nTotValSal+=aPrnDET[ DET_SALD ]
		nTotValRpr+=aPrnDET[ DET_EMPN ]
		nTotValRes+=aPrnDET[ DET_DISP ]
		nTotValEst+=aPrnDET[ DET_VEST ]
		nTotValEmp+=aPrnDET[ DET_VEMP ]
		
		aPrnDET := nil ; Li++
		
		If (((nOrdem == 2) .Or. (nOrdem == 4)) .And. ;
				!(aTotORD[ ACM_CODE ] == If( (nOrdem == 2),FIELD->TIPO,FIELD->GRUPO )))
			
			Li++
			
			@ Li,016 PSay OemToAnsi("Total do ")+If( (nOrdem == 2),OemToAnsi("Tipo"),OemToAnsi("Grupo"))+" : "+aTotORD[ ACM_CODE ]   //"Total do "###"Tipo"###"Grupo"
			
			@ Li,055 PSay aTotORD[ ACM_SALD ] Picture cPicture
			@ Li,070 PSay aTotORD[ ACM_EMPN ] Picture cPicture
			@ Li,085 PSay aTotORD[ ACM_DISP ] Picture cPicture
			@ Li,100 PSay aTotORD[ ACM_VEST ] Picture cPicVal
			@ Li,117 PSay aTotORD[ ACM_VEMP ] Picture cPicVal
			
			Li++
			
			aTotORD   := nil ; lPrintLIN := .T.
			lPrintTOT := .F. ; lPrintOUT := .T.
		EndIf
		
		If ((mv_par17 == 1) .And. ;
				!(aTotUM[ ACM_CODE ] == FIELD->UM))
			
			Li++
			
			@ Li,016 PSay OemToAnsi("Total Unidade Medida : ")+aTotUM[ ACM_CODE ]   //"Total Unidade Medida : "
			@ Li,055 PSay aTotUM[ ACM_SALD ] Picture cPicture
			@ Li,070 PSay aTotUM[ ACM_EMPN ] Picture cPicture
			@ Li,085 PSay aTotUM[ ACM_DISP ] Picture cPicture
			@ Li,100 PSay aTotUM[ ACM_VEST ] Picture cPicVal
			@ Li,117 PSay aTotUM[ ACM_VEMP ] Picture cPicVal
			
			Li++
			
			aTotUM    := nil ; lPrintLIN := .T.
			lPrintTOT := .F. ; lPrintOUT := .T.
		EndIf
		
		If lPrintLIN
			Li++ ; lPrintLIN := .F.
		EndIf
	EndIf
EndDo

If nTotValSal + nTotValRPR + nTotValRes + nTotValEst + nTotValEmp # 0
	If Li > 56
		Cabec(cTitulo,cCab01,cCab02,wnRel,cTam,nTipo)
	EndIf
	Li += If(mv_par17#1,1,0)
	@ Li,016 PSay OemToAnsi("Total Geral : ") // "Total Geral : "
	@ Li,055 PSay nTotValSal Picture cPicture
	@ Li,070 PSay nTotValRPR Picture cPicture
	@ Li,085 PSay nTotValRes Picture cPicture
	@ Li,100 PSay nTotValEst Picture cPicVal
	@ Li,117 PSay nTotValEmp Picture cPicVal
EndIf

If (LastKey() == 286)
	@ pRow()+1,00 PSay OemToAnsi("CANCELADO PELO OPERADOR.")     //"CANCELADO PELO OPERADOR."
Else
	Roda( LastRec(), OemToAnsi("Registro(s) processado(s)"),cTam )    //"Registro(s) processado(s)"
EndIf

SET DEVICE TO SCREEN

MS_FLUSH()

If (aReturn[ 5 ] == 1)
	SET PRINTER TO
	OurSpool( wNRel )
Endif

DbSelectArea( cFileTRB )  ; DbCloseArea()
FErase( cFileTRB+GetDBExtension() ) ; FErase( cFileTRB+OrdBagExt() )

DbSelectArea( "SB1" )

Return( nil )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA260PergUºAutor  ³Microsiga           º Data ³  01/28/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Altera as Perguntas no SX1 para utilizacao do MV_CUSFIL     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MA260PergU()

Local aAreaAnt := GetArea()

If lCusUnif //-- Ajusta as perguntas para Custo Unificado
	dbSelectArea('SX1')
	dbSetOrder(1)
	If dbSeek('MTR26001', .F.) .And. !(X1_PRESEL==2.Or.X1_PRESEL==3) //-- Aglutina por Filial
		RecLock('SX1', .F.)
		Replace X1_PRESEL With 2
		MsUnlock()
	EndIf
	If dbSeek('MTR26004', .F.) .And. !(X1_CNT01=='**') //-- Armazem De **
		RecLock('SX1', .F.)
		Replace X1_CNT01 With '**'
		MsUnlock()
	EndIf
	If dbSeek('MTR26005', .F.) .And. !(X1_CNT01=='**') //-- Armazem Ate **
		RecLock('SX1', .F.)
		Replace X1_CNT01 With '**'
		MsUnlock()
	EndIf
EndIf	

RestArea(aAreaAnt)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor  ³Fernando J. Siquini º Data ³  02/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui a 21a pergunta do MTR260 no SX1                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR260                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1()

PutSx1('MTR260', '21' , 'Listar Prods C/ Valor Zerado ?', ;
	'Muestra Valores a Cero ?      ', ;
	'Show Zeroed Values ?          ', 'mv_chk', 'C', 1, 0, 2, 'C', '', '', '', '', 'mv_par21', ;
	'Sim' , ;
	'Si', ;
	'Yes', '', ;
	'Nao', ;
	'No', ;
	'No','','','','','','','','','', ;
	{'Determina se produtos que possuam o     ', ;
	'Custo apurado igual a ZERO devem ser    ', ;
	'impressos.                              '}, ;
	{'Defina si los productos con el coste   ', ;
	'calculado igual Cero tienen que ser    ', ;
	'impressos                              '}, ;
	{'Define if Products with Calculated Cost', ;
	'equal Zero have to be printed.         ', ;
	'                                       '})

Return Nil
