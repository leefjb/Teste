#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/08/00


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JMHEST6A  ³ Autor ³ Reiner Trennepohl    ³ Data ³ 17/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Estoques  / Saldo apenas em Qtd.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutencao³ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function JMHEST6A()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local Titulo   := "Relacao da Posicao do Estoque e Terceiros" //"Relacao da Posicao do Estoque"
Local wnrel    := "JMHEST6A"
Local cDesc1   := "Este relatorio emite a posicao dos saldos de cada produto em " //"Este relatorio emite a posicao dos saldos e empenhos de cada  produto"
Local cDesc2   := "estoque. Ele tambem mostrara' o saldo em Terceiros."       //"em estoque. Ele tambem mostrara' o saldo disponivel ,ou seja ,o saldo"
Local cDesc3   := ""       //"subtraido dos empenhos."
Local cString  := "SB1"
Local aOrd     := {OemToAnsi(" Por Codigo         "),OemToAnsi(" Por Tipo           "),OemToAnsi(" Por Descricao     "),OemToAnsi(" Por Grupo        "),OemToAnsi(" Por Almoxarifado   ")}    //" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "###" Por Almoxarifado   "
Local lGo      := .F.
Local lEnd     := .F.
Local Tamanho  := "M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn  := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }   //"Zebrado"###"Administracao"
PRIVATE nLastKey := 0 ,cPerg := "JMHEST6A"
PRIVATE cIndex, cKey, cFilter, nIndex 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                ³
//³ mv_par01     // Aglutina por: Almoxarifado / Filial / Empresa       ³
//³ mv_par02     // Filial de       *                                   ³
//³ mv_par03     // Filial ate      *                                   ³
//³ mv_par04     // almoxarifado de   *                                 ³
//³ mv_par05     // almoxarifado ate     *                              ³
//³ mv_par06     // codigo de       *                                   ³
//³ mv_par07      // codigo ate      *                                  ³
//³ mv_par08     // tipo de         *                                   ³
//³ mv_par09     // tipo ate        *                                   ³
//³ mv_par10     // grupo de        *                                   ³
//³ mv_par11     // grupo ate       *                                   ³
//³ mv_par12     // descricao de    *                                   ³
//³ mv_par13     // descricao ate   *                                   ³
//³ mv_par14     // imprime produtos: Todos /Positivos /Negativos       ³
//³ mv_par15     // Saldo a considerar : Atual / Fechamento / Movimento ³
//³ mv_par16     // Qual Moeda (1 a 5)                                  ³
//³ mv_par17     // Aglutina por UM ?(S)im (N)ao                        ³
//³ mv_par18     // Lista itens zerados ? (S)im (N)ao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
If nLastKey = 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey = 27
	Set Filter to
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
RptStatus( { | lEnd | cFileTRB := r6aSelect( @lEnd ) },Titulo+": Preparacao..." )

If !Empty( cFileTRB )
	RptStatus({|lEnd| R6AIMPRIME( @lEnd,cFileTRB,Titulo,wNRel,Tamanho,Tipo,aReturn[ 8 ] )},titulo)
EndIf  

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³r6aSelect³ Autor ³ Reiner Trennepohl      ³ Data ³ 07/09/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preparacao do Arquivo de Trabalho p/ Relatorio             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST6A                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function r6aSelect( lEnd )

Local cFileTRB := "",;
	cIndxKEY := "",;
	aSizeQT  := TamSX3( "B2_QATU" ),;
	aSizeVL  := TamSX3( "B2_VATU1"),;
	cDescGru := Space(30),;
	aSaldo   := {},;
	nQuant   := 0,;
	nValor   := 0,;
	nQuantT  := 0,;
	nValorT  := 0,;
	cFilOK   := cFilAnt,;
	cAl := "SB2",cQry, lExcl := .f.,aStru := {}

Local aCampos := {	{ "FILIAL","C",02,00 },;
                    { "CODIGO","C",15,00 },;
                    { "Local ","C",02,00 },;
                    { "TIPO  ","C",02,00 },;
                    { "GRUPO ","C",04,00 },;
                    { "DESGRU","C",30,00 },;
                    { "DESCRI","C",45,00 },;
                    { "UM    ","C",02,00 },;
                    { "VALORT","N",aSizeVL[ 1 ]+1, aSizeVL[ 2 ] },;  // em Terceiros
                    { "QUANTT","N",aSizeQT[ 1 ]+1, aSizeQT[ 2 ] },;  // em Terceiros
                    { "VALOR ","N",aSizeVL[ 1 ]+1, aSizeVL[ 2 ] },;
                    { "QUANT ","N",aSizeQT[ 1 ]+1, aSizeQT[ 2 ] } }

If (mv_par01 == 1)
	If (aReturn[ 8 ] == 5)
		cIndxKEY := "Local+"
	Else
		cIndxKEY := "FILIAL+"
	EndIf
	
	If (mv_par17 == 1)
		cIndxKEY += "UM+"
	EndIf
	
	Do Case
		Case (aReturn[ 8 ] == 1)
			cIndxKEY += "CODIGO+Local"
		Case (aReturn[ 8 ] == 2)
			cIndxKEY += "TIPO+CODIGO+Local"
		Case (aReturn[ 8 ] == 3)
			cIndxKEY += "DESCRI+CODIGO+Local"
		Case (aReturn[ 8 ] == 4)
			cIndxKEY += "GRUPO+CODIGO+Local"
		Case (aReturn[ 8 ] == 5)
			cIndxKEY += "CODIGO+FILIAL"
	EndCase
Else
	If (aReturn[ 8 ] == 5)
		cIndxKEY := "Local+"
	Else
		cIndxKEY := ""
	EndIf
	
	If (mv_par17 == 1)
		cIndxKEY += "UM+"
	EndIf
	
	Do Case
		Case (aReturn[ 8 ] == 1)
			cIndxKEY += "CODIGO+FILIAL+Local"
		Case (aReturn[ 8 ] == 2)
			cIndxKEY += "TIPO+CODIGO+FILIAL+Local"
		Case (aReturn[ 8 ] == 3)
			cIndxKEY += "DESCRI+CODIGO+FILIAL+Local"
		Case (aReturn[ 8 ] == 4)
			cIndxKEY += "GRUPO+CODIGO+FILIAL+Local"
		Case (aReturn[ 8 ] == 5)
			cIndxKEY += "CODIGO+FILIAL"
	EndCase
EndIf

cFileTRB := CriaTrab( nil,.F. )

DbSelectArea( 0 )
DbCreate( cFileTRB,aCampos )

DbUseArea( .F.,,cFileTRB,cFileTRB,.F.,.F. )
IndRegua( cFileTRB,cFileTRB,cIndxKEY,,,OemToAnsi("Organizando Arquivo..."))   //"Organizando Arquivo..."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho usando indice condicional.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB6")
cIndex  := CriaTrab(NIL,.F.)
cKey    := 'B6_FILIAL+B6_TPCF+B6_PRODUTO'
cFilter := SB6->(DbFilter())
If Empty( cFilter )
	cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'" .And. B6_PODER3 == "R"'
Else
	cFilter := cFilter+' .And. (B6_FILIAL == "'+xFilial('SB6')+'") .And. B6_PODER3 == "R"'
EndIf
IndRegua("SB6",cIndex,cKey,,cFilter," Criando Indice ...    ")
nIndex := RetIndex("SB6")
#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)

DbSelectArea( "SB2" )
SetRegua( LastRec() )

#IFDEF TOP
	aStru := dbStruct()
	
	cQuery := "SELECT * FROM " + RetSqlName("SB2")
	cQuery += " WHERE B2_FILIAL BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'"
	cQuery += "   AND B2_LOCAL  BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'"
	cQuery += "   AND B2_COD    BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'"
	cQuery += "   AND D_E_L_E_T_ = ' '"
	cAl := "xxSB2"
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAl, .F., .T.)
	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			TCSetField(cAl, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next
#ELSE
	dbSetOrder(1)
	dbSeek(MV_PAR02+MV_PAR06+MV_PAR04,.t.)
#ENDIF

IF xFilial("SB2") != "  "
	lExcl := .t.
Endif

While !Eof()

	nQuantT := 0
	nValorT := 0
	IF lExcl
		cFilAnt := (cAl)->B2_FILIAL
	Endif
	IncRegua()
	
	If ((((cAl)->B2_FILIAL >= MV_PAR02) .And. ((cAl)->B2_FILIAL <= MV_PAR03)) .And. ;
		(((cAl)->B2_Local  >= MV_PAR04) .And. ((cAl)->B2_Local  <= MV_PAR05)) .And. ;
		(((cAl)->B2_COD    >= MV_PAR06) .And. ((cAl)->B2_COD    <= MV_PAR07)))
		
		dbSelectArea( "SB1" )
		dbSetOrder(1)
		
		If (DbSeek( xFilial()+(cAl)->B2_COD) )
			If (((SB1->B1_TIPO  >= MV_PAR08) .And. (SB1->B1_TIPO  <= MV_PAR09)) .And. ;
				((SB1->B1_GRUPO >= MV_PAR10) .And. (SB1->B1_GRUPO <= MV_PAR11)) .And. ;
				((SB1->B1_DESC  >= MV_PAR12) .And. (SB1->B1_DESC  <= MV_PAR13)) .And. ;
				((!Empty(aReturn[7]) .And. &(aReturn[7])).Or.Empty(aReturn[7])))
				
				Do Case
					Case (mv_par15 == 1)
						nQuant := (cAl)->B2_QATU
					Case (mv_par15 == 2)
						nQuant := (cAl)->B2_QFIM
					OtherWise
						nQuant := (aSaldo := CalcEst( (cAl)->B2_COD,(cAl)->B2_Local,dDataBase+1,(cAl)->B2_FILIAL ))[ 1 ]
				EndCase
				
				DbSelectArea( "SBM" )
				dbSetOrder(1)
				If (DbSeek( xFilial()+SB1->B1_GRUPO ) )
				   cDescGru := SBM->BM_DESC
				Else
				   cDescGru := "S/Grupo Cadastrado"
				EndIf
								
				DbSelectArea( "SB1" )
			    Do Case
					Case (mv_par15 == 1)
						nValor := (cAl)->(FieldGet( FieldPos( "B2_VATU"+Str( mv_par16,1 ) ) ))
					Case (mv_par15 == 2)
						nValor := (cAl)->(FieldGet( FieldPos( "B2_VFIM"+Str( mv_par16,1 ) ) ))
					OtherWise
						nValor := aSaldo[ 1+mv_par16 ]
			   EndCase
					
			   If QtdComp(nValor) < QtdComp(0)
				  nValor := ((cAl)->(FieldGet( FieldPos( "B2_CM"+Str( mv_par16,1 ) ) ))*nQuant)
			   EndIf
					
			   dbSelectArea("SB6")
			   dbSeek(xFilial("SB6")+"C"+SB1->B1_COD) 
			   Do While !EOF() .And. xFilial("SB6") == B6_FILIAL;
			                   .And. B6_TPCF == "C" .And. B6_PRODUTO == SB1->B1_COD  
                  If B6_SALDO > 1   
					
				     nQuantT += B6_SALDO
			  	  
				  EndIf
				  dbSkip()
			   EndDo	   
			   nValorT := ((cAl)->(FieldGet( FieldPos( "B2_CM"+Str( mv_par16,1 ) ) ))*nQuantT)
			   
			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³ Verifica se devera ser impresso itens zerados                ³
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   DbSelectArea( cAl )
			   If mv_par18 == 2 .And. ( nQuant = 0 .And. nQuantT = 0 )
			  	  dbSkip()
				  Loop
			   EndIf
				
			   If ((mv_par14 == 1) .Or. ;
			      ((mv_par14 == 2) .And.(nQuant >= 0 .Or. nQuantT >= 0))  .Or. ;
			      ((mv_par14 == 3) .And.(nQuant < 0 .Or. nQuantT < 0 ))) 	
			           
				   DbSelectArea( cFileTRB )
				   DbAppend()
					
					FIELD->FILIAL := (cAl)->B2_FILIAL
					FIELD->CODIGO := (cAl)->B2_COD
					FIELD->LOCAL  := (cAl)->B2_Local
					FIELD->TIPO   := SB1->B1_TIPO
					FIELD->GRUPO  := SB1->B1_GRUPO
					FIELD->DESGRU := cDescGru
					FIELD->DESCRI := SB1->B1_DESC
					FIELD->UM     := SB1->B1_UM 
					FIELD->QUANT  := nQuant
					FIELD->VALOR  := nValor
					FIELD->QUANTT := nQuantT
					FIELD->VALORT := nValorT
					
			   EndIf	
			EndIf
		EndIf
		
		DbSelectArea( cAl )
	EndIf
	
	DbSkip()
EndDo

cFilAnt := cFilOk

#IFDEF TOP
	dbSelectArea(cAl)
	dbCloseArea()
	ChkFIle("SB2",.f.)
	
#Endif      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve condicao original ao SB6 e apaga arquivo de trabalho.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SB6")
dbSelectArea("SB6")
dbSetOrder(1)
cIndex += OrdBagExt()
Ferase(cIndex)

dbSelectArea("SB1")
Set Filter to

Return( cFileTRB )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R6AIMPRIME³ Autor ³ Reiner Trennepohl     ³ Data ³ 07/09/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preparacao do Arquivo de Trabalho p/ Relatorio             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ jmhest6a                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function R6AIMPRIME( lEnd,cFileTRB,cTitulo,wNRel,cTam,nTipo,nOrdem )

#define DET_SIZE  14

#define DET_CODE   1
#define DET_TIPO   2
#define DET_GRUP   3 
#define DET_DESGRU 4
#define DET_DESC   5
#define DET_UM     6
#define DET_FL     7
#define DET_ALMX   8
#define DET_QEST   9
#define DET_QTER  10
#define DET_TOTAL 11
#define DET_VEST  12
#define DET_VTER  13
#define DET_KEYV  14

#define ACM_SIZE   6

#define ACM_CODE   1
#define ACM_QEST   2
#define ACM_QTER   3
#define ACM_TOTAL  4
#define ACM_VEST   5
#define ACM_VTER   6

Local aPrnDET   := nil,;
      aTotUM    := nil,;
      aTotORD   := nil

Local cLPrnCd   := "",;
      nInKeyV   := 0

Local lPrintCAB := .F.,;
      lPrintDET := .F.,; 
      lPrintTOT := .F.,;
      lPrintOUT := .F.,;
      lPrintLIN := .F.

Local nTotQtdEst:=0,;  
      nTotQtdTer:=0,;
      nTotValEst:=0,;
      nTotValTer:=0,;
      nTotValTot:=0

Local cPicture  := PesqPict("SB2", If( (mv_par15 == 1),"B2_QATU","B2_QFIM" ),14 )
Local cPicVal   := PesqPict("SB2","B2_VATU"+Str(mv_par16,1),15)
Private Li    := 80,;
M_Pag := 1

cCab01 := OemToAnsi("CODIGO            GRUPO                           DESCRICAO                                              ___________SALDO___________")   
cCab02 := OemToAnsi("-------------------------------------------------------------------------------------------------------- EM ESTOQUE     EM TERCEIROS")   
//                   0123456789012345  123456789012345678901234567890  123456789012345678901234567890123456789012345      999,999,999.99   999,999,999.99 
//                   0         1         2         3         4         5         6         7         8         9        10        11        12        13
//                   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

DbSelectArea( cFileTRB ) ; DbGoTop()

While !Eof()
	
	If (LastKey() == 286) ; Exit ; EndIf
	
	If (aPrnDET == nil)
		
		aPrnDET := Array( DET_SIZE )
		
		aPrnDET[ DET_CODE   ] := FIELD->CODIGO
		aPrnDET[ DET_TIPO   ] := FIELD->TIPO
		aPrnDET[ DET_GRUP   ] := FIELD->GRUPO
		aPrnDET[ DET_DESGRU ] := FIELD->DESGRU
		aPrnDET[ DET_DESC   ] := FIELD->DESCRI
		aPrnDET[ DET_UM     ] := FIELD->UM
		
		aPrnDET[ DET_FL   ] := ""
		aPrnDET[ DET_ALMX ] := ""
		aPrnDET[ DET_QEST ] := 0
		aPrnDET[ DET_QTER ] := 0
		aPrnDET[ DET_VEST ] := 0
		aPrnDET[ DET_VTER ] := 0 
		aPrnDET[ DET_TOTAL] := 0
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
			aPrnDET[ DET_ALMX ] := FIELD->Local
			
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
	
	aPrnDET[ DET_QEST ] += FIELD->QUANT
	aPrnDET[ DET_QTER ] += FIELD->QUANTT
	aPrnDET[ DET_VEST ] += FIELD->VALOR
	aPrnDET[ DET_VTER ] += FIELD->VALORT
	aPrnDET[ DET_TOTAL] += (FIELD->VALOR+FIELD->VALORT)
	
	If (mv_par17 == 1)
		
		aTotUM[ ACM_QEST ] += FIELD->QUANT
		aTotUM[ ACM_QTER ] += FIELD->QUANTT
		aTotUM[ ACM_VEST ] += FIELD->VALOR
		aTotUM[ ACM_VTER ] += FIELD->VALORT
		aTotUM[ ACM_TOTAL] += (FIELD->VALOR+FIELD->VALORT)
	EndIf
	
	If ((nOrdem == 2) .Or. (nOrdem == 4))
		
		aTotORD[ ACM_QEST ] += FIELD->QUANT
		aTotORD[ ACM_QTER ] += FIELD->QUANTT
		aTotORD[ ACM_VEST ] += FIELD->VALOR
		aTotORD[ ACM_VTER ] += FIELD->VALORT
		aTotORD[ ACM_TOTAL] += (FIELD->VALOR+FIELD->VALORT)
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
			
			@ Li,000 PSay aPrnDET[ DET_CODE   ]
			@ Li,018 PSay aPrnDET[ DET_DESGRU ]
			@ Li,050 PSay aPrnDET[ DET_DESC   ]
			
			lPrintCAB := .F. ; lPrintOUT := .F.
		EndIf
		
		@ Li,101 PSay aPrnDET[ DET_QEST ] Picture cPicture
		@ Li,118 PSay aPrnDET[ DET_QTER ] Picture cPicture
		
		nTotQtdEst+=aPrnDET[ DET_QEST ]
		nTotQtdTer+=aPrnDET[ DET_QTER ]
		nTotValEst+=aPrnDET[ DET_VEST ]
		nTotValTer+=aPrnDET[ DET_VTER ] 
		nTotValTot+=aPrnDET[ DET_TOTAL]
		
		aPrnDET := nil ; Li++
		
		If (((nOrdem == 2) .Or. (nOrdem == 4)) .And. ;
			!(aTotORD[ ACM_CODE ] == If( (nOrdem == 2),FIELD->TIPO,FIELD->GRUPO )))
			
			Li++
			
			@ Li,018 PSay OemToAnsi("Total do ")+If( (nOrdem == 2),OemToAnsi("Tipo"),OemToAnsi("Grupo"))+" : "+aTotORD[ ACM_CODE ]   //"Total do "###"Tipo"###"Grupo"
			
			@ Li,101 PSay aTotORD[ ACM_QEST ] Picture cPicture
			@ Li,118 PSay aTotORD[ ACM_QTER ] Picture cPicture
			
			Li++
			
			aTotORD   := nil ; lPrintLIN := .T.
			lPrintTOT := .F. ; lPrintOUT := .T.
		EndIf
		
		If ((mv_par17 == 1) .And. ;
			!(aTotUM[ ACM_CODE ] == FIELD->UM))
			
			Li++
			
			@ Li,018 PSay OemToAnsi("Total Unidade Medida : ")+aTotUM[ ACM_CODE ]   //"Total Unidade Medida : "
			@ Li,101 PSay aTotUM[ ACM_QEST ] Picture cPicture
   		    @ Li,118 PSay aTotUM[ ACM_QTER ] Picture cPicture
		
			Li++
			
			aTotUM    := nil ; lPrintLIN := .T.
			lPrintTOT := .F. ; lPrintOUT := .T.
		EndIf
		
		If lPrintLIN
			Li++ ; lPrintLIN := .F.
		EndIf
	EndIf
EndDo

If nTotQtdEst + nTotQtdTer + nTotValEst + nTotValTer # 0
	If Li > 56
		Cabec(cTitulo,cCab01,cCab02,wnRel,cTam,nTipo)
	EndIf
	Li += If(mv_par17#1,1,0)
	@ Li,018 PSay OemToAnsi( "Total Geral : ") // "Total Geral : "
	@ Li,101 PSay nTotQtdEst Picture cPicture  
	@ Li,118 PSay nTotQtdTer Picture cPicture  
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
FErase( cFileTRB+".DBF" ) ; FErase( cFileTRB+OrdBagExt() )

DbSelectArea( "SB1" )

Return( nil )
