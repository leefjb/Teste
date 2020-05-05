#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
//#INCLUDE "MATR080.CH"  // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
#define STR0009 "** RELACAO DAS NOTAS FISCAIS DE COMPRAS **"  // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
#define STR0010 "RELACAO DE NOTAS FISCAIS"  // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
#define STR0011 "RELACAO DOS ITENS DAS NOTAS"  // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJMHR080   บ  Eliane Carvalho Barbosa Data ณ  21/08/06       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relacao das Notas Fiscais de Entradas                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function JMHR080()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relacao das Notas Fiscais de Saidas "
Local cPict          := ""
Local titulo         := "Relacao das Notas Fiscais de Entradas "
Local nLin           := 80
Local Cabec1         := "PRODUTO"+SPACE(9)+"DESCRICAO"+SPACE(02)+"AL"+SPACE(01)+"CONTA"+SPACE(06)+"C.CUSTO"+SPACE(03)+"IT.CONTA"+SPACE(02)+"CL.VALOR"+SPACE(02)+"TES"+SPACE(01)+"CFO"+SPACE(03)+"ST"+SPACE(02)+"GRUPO"+SPACE(01)+"QTD."+SPACE(10)+"VL.UNIT."+SPACE(06)+"VL.TOTAL"+SPACE(06)+"VL.IPI"+SPACE(07)+"VL.ICM"+SPACE(07)+"VL.ISS"+SPACE(07)+"DESP.ACESS"+SPACE(03)+"CUSTO"+SPACE(08)+"MARGEM BRUTA %"   //STR0006
Local Cabec2         := " "
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "JMHR080" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "JMHR080" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SD1"

dbSelectArea("SD1")
dbSetOrder(1)

cPerg := PadR("JMH080",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

Pergunte(cPerg,.f.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01 // Produto de                                       ณ
//ณ mv_par02 // Produto ate                                      ณ
//ณ mv_par03 // Data de                                          ณ
//ณ mv_par04 // Data ate                                         ณ
//ณ mv_par05 // Lista os itens da nota                           ณ
//ณ mv_par06 // Grupo de                                         ณ
//ณ mv_par07 // Grupo ate                                        ณ
//ณ mv_par08 // Fornecedor de                                    ณ
//ณ mv_par09 // Fornecedor ate                                   ณ
//ณ mv_par10 // Almoxarifado de                                  ณ
//ณ mv_par11 // Almoxarifado ate                                 ณ
//ณ mv_par12 // De  Nota                                         ณ
//ณ mv_par13 // Ate Nota                                         ณ
//ณ mv_par14 // De  Serie                                        ณ
//ณ mv_par15 // Ate Serie                                        ณ
//ณ mv_par16 // Tes                                              ณ
//ณ mv_par17 // Cfop                                             ณ
//ณ mv_par18 // Moeda                                            ณ
//ณ mv_par19 // Outras moedas                                    ณ
//ณ mv_par20 // Imprimi Total                                    ณ
//ณ mv_par21 // Descricao do produto                             ณ



wnrel:="JMHR080"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  15/07/05   บฑฑ
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

Local nOrdem
Local cQuery,Query
LOCAL cQryAd      := ""
Local lContinua   := .T.
LOCAL lEasy       := If(GetMV("MV_EASY")=="S",.T.,.F.)
LOCAL aCampos     := {}
dbSelectArea(cString)
dbSetOrder(1)

Pergunte(cPerg,.f.)

aStrucSF1 := SF1->(dbStruct())
aStrucSD1 := SD1->(dbStruct())
cALiasSF1 := "QRYSD1"
cAliasSD1 := "QRYSD1"
cALiasSB1 := IIF(!lEasy,"QRYSD1","SB1")
cALiasSA1 := "QRYSD1"
cALiasSA2 := "QRYSD1"
lQuery :=.T.

cQuery := "SELECT "
If nOrdem == 1
	cQuery += "SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD,SD1.D1_ITEM,"
ElseIf nOrdem == 2
	cQuery += "SD1.D1_FILIAL,SD1.D1_COD,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
ElseIf nOrdem == 3
	cQuery += "SD1.D1_FILIAL,SD1.D1_DTDIGIT,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
ElseIf nOrdem == 4
	cQuery += "SD1.D1_FILIAL,SD1.D1_EMISSAO,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
ElseIf nOrdem == 5
	cQuery += "SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_ITEM,"
Endif

cQuery += "D1_DTDIGIT,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_VALFRE,D1_DESPESA,D1_SEGURO,D1_PEDIDO,D1_ITEMPC,"
cQuery += "D1_TES,D1_IPI,D1_PICM,D1_TIPO,D1_CF,D1_GRUPO,D1_LOCAL,D1_ITEM,D1_EMISSAO,D1_VALDESC,D1_ICMSRET,D1_VALICM,D1_VALIPI,"
cQuery += "D1_CONTA,D1_CLVL,D1_CLASFIS,D1_CUSTO,"
For nX := 1 To Len(acampos)
	cQuery +=acampos[nX]+","
Next nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEsta rotina foi escrita para adicionar no select os campos         ณ
//ณusados no filtro do usuario quando houver, a rotina acrecenta      ณ
//ณsomente os campos que forem adicionados ao filtro testando         ณ
//ณse os mesmo jแ existem no select ou se forem definidos novamente   ณ
//ณpelo o usuario no filtro, esta rotina acrecenta o minimo possivel  ณ
//ณde campos no select pois pelo fato da tabela SD1 ter muitos campos |
//ณe a query ter UNION ao adicionar todos os campos do SD1 estava     |
//ณderrubando o TOP CONNECT e abortando o sistema.                    |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(aReturn[7])
	For nX := 1 To SD1->(FCount())
		cName := SD1->(FieldName(nX))
		If AllTrim( cName ) $ aReturn[7]
			If aStrucSD1[nX,2] <> "M"
				If !cName $ cQuery .And. !cName $ cQryAd
					cQryAd += cName +","
				Endif
			EndIf
		EndIf
	Next nX
Endif

cQuery += cQryAd

cQuery += "F1_FILIAL,F1_MOEDA,F1_TXMOEDA,F1_DTDIGIT,F1_TIPO,F1_COND,F1_VALICM,F1_VALIPI,F1_VALIMP1,"
cQuery += "F1_FRETE,F1_DESPESA,F1_SEGURO,F1_DESCONT,F1_VALMERC,F1_DOC,F1_SERIE,F1_EMISSAO,F1_FORNECE,F1_LOJA,F1_VALBRUT,"

If !lEasy
	cQuery += "B1_DESC,B1_GRUPO,"
EndIf

cQuery += "A1_NOME,A1_MUN,SD1.R_E_C_N_O_ SD1RECNO "
cQuery += "FROM "+RetSqlName("SF1")+" SF1 ,"+RetSqlName("SD1")+" SD1 ,"

If !lEasy
	cQuery += RetSqlName("SB1")+" SB1 ,"
EndIf

cQuery += RetSqlName("SA1")+" SA1  "
cQuery += "WHERE "
cQuery += "SF1.F1_FILIAL='"+xFilial("SF1")+"' AND "
cQuery += "NOT ("+IsRemito(3,'SF1.F1_TIPODOC')+ ") AND "
cQuery += "SF1.D_E_L_E_T_ <> '*' AND "
cQuery += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
cQuery += "SD1.D1_DOC = SF1.F1_DOC AND "
cQuery += "SD1.D1_SERIE = SF1.F1_SERIE AND "
cQuery += "SD1.D1_FORNECE = SF1.F1_FORNECE AND "
cQuery += "SD1.D1_LOJA = SF1.F1_LOJA AND "
cQuery += "SD1.D1_TIPO IN ('D','B') AND "
cQuery += "SD1.D1_TIPODOC = SF1.F1_TIPODOC AND "
cQuery += "SD1.D_E_L_E_T_ <> '*' AND "

If !lEasy
	cQuery += "SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
	cQuery += "SB1.B1_COD = SD1.D1_COD AND "
	cQuery += "SB1.D_E_L_E_T_ <> '*' AND "
EndIf
cQuery += "SA1.A1_FILIAL ='"+xFilial("SA1")+"' AND "
cQuery += "SA1.A1_COD = SD1.D1_FORNECE AND "
cQuery += "SA1.A1_LOJA = SD1.D1_LOJA AND "
cQuery += "SA1.D_E_L_E_T_ <> '*' AND "
cQuery += "D1_COD >= '"  		    + MV_PAR01	+ "' AND "
cQuery += "D1_COD <= '"  	        + MV_PAR02	+ "' AND "
cQuery += "D1_DTDIGIT >= '" + DTOS(MV_PAR03)	+ "' AND "
cQuery += "D1_DTDIGIT <= '" + DTOS(MV_PAR04)	+ "' AND "
cQuery += "D1_GRUPO >= '"  		+ MV_PAR06	+ "' AND "
cQuery += "D1_GRUPO <= '"  		+ MV_PAR07	+ "' AND "
cQuery += "D1_FORNECE >= '"  		+ MV_PAR08	+ "' AND "
cQuery += "D1_FORNECE <= '"  		+ MV_PAR09	+ "' AND "
cQuery += "D1_LOCAL >= '"  		+ MV_PAR10	+ "' AND "
cQuery += "D1_LOCAL <= '"  		+ MV_PAR11	+ "' AND "
cQuery += "D1_DOC >= '"  	    	+ MV_PAR12	+ "' AND "
cQuery += "D1_DOC <= '"  		    + MV_PAR13	+ "' AND "
cQuery += "D1_SERIE >= '"  		+ MV_PAR14	+ "' AND "
cQuery += "D1_SERIE <= '"  		+ MV_PAR15	+ "' "
If ! Empty(MV_PAR16)
	Query := Space(0)
	Query+=" AND D1_TES IN ("
	FOR nI:=1 to len(AllTrim(mv_par16)) step 3
		if !empty(substr(mv_par16,nI,3))
			Query+="'" + substr(mv_par16,nI,3) + "',"
		else
			exit
		endif
	NEXT
	
	Query := substr(Query,1,len(Query)-1) + ')'
	
	cQuery += Query
EndIf

If ! Empty(MV_PAR17)
	Query := Space(0)
	Query+=" AND D1_CF IN ("
	FOR nI:=1 to len(AllTrim(mv_par17)) step 5
		if !empty(substr(mv_par17,nI,5))
			Query+="'" + substr(mv_par17,nI,5) + "',"
		else
			exit
		endif
	NEXT
	Query := substr(Query,1,len(Query)-1) + ')'
	cQuery += Query
EndIf

//cQuery += "D1_TES >= '"  	        + MV_PAR16	+ "' AND "
//  cQuery += "D1_TES <= '"  	        + MV_PAR17	+ "' "
cQuery += " UNION "
cQuery += "SELECT "
If nOrdem == 1
	cQuery += "SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD,SD1.D1_ITEM,"
ElseIf nOrdem == 2
	cQuery += "SD1.D1_FILIAL,SD1.D1_COD,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
ElseIf nOrdem == 3
	cQuery += "SD1.D1_FILIAL,SD1.D1_DTDIGIT,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
ElseIf nOrdem == 4
	cQuery += "SD1.D1_FILIAL,SD1.D1_EMISSAO,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
ElseIf nOrdem == 5
	cQuery += "SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_ITEM,"
Endif

cQuery += "D1_DTDIGIT,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_VALFRE,D1_DESPESA,D1_SEGURO,D1_PEDIDO,D1_ITEMPC,"
cQuery += "D1_TES,D1_IPI,D1_PICM,D1_TIPO,D1_CF,D1_GRUPO,D1_LOCAL,D1_ITEM,D1_EMISSAO,D1_VALDESC,D1_ICMSRET,D1_VALICM,D1_VALIPI,"
cQuery += "D1_CONTA,D1_CLVL,D1_CLASFIS,D1_CUSTO,"
For nX := 1 To Len(acampos)
	cQuery +=acampos[nX]+","
Next nX

cQuery += cQryAd
cQuery += "F1_FILIAL,F1_MOEDA,F1_TXMOEDA,F1_DTDIGIT,F1_TIPO,F1_COND,F1_VALICM,F1_VALIPI,F1_VALIMP1,"
cQuery += "F1_FRETE,F1_DESPESA,F1_SEGURO,F1_DESCONT,F1_VALMERC,F1_DOC,F1_SERIE,F1_EMISSAO,F1_FORNECE,F1_LOJA,F1_VALBRUT,"

If !lEasy
	cQuery += "B1_DESC,B1_GRUPO,"
EndIf

cQuery += "A2_NOME,A2_MUN,SD1.R_E_C_N_O_ SD1RECNO "
cQuery += "FROM "+RetSqlName("SF1")+" SF1 ,"+RetSqlName("SD1")+" SD1 ,"

If !lEasy
	cQuery += RetSqlName("SB1")+" SB1 ,"
EndIf

cQuery += RetSqlName("SA2")+" SA2 "
cQuery += "WHERE "
cQuery += "SF1.F1_FILIAL='"+xFilial("SF1")+"' AND "
cQuery += "SF1.D_E_L_E_T_ <> '*' AND "
cQuery += "NOT ("+IsRemito(3,'SF1.F1_TIPODOC')+ ") AND "
cQuery += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
cQuery += "SD1.D1_DOC = SF1.F1_DOC AND "
cQuery += "SD1.D1_SERIE = SF1.F1_SERIE AND "
cQuery += "SD1.D1_FORNECE = SF1.F1_FORNECE AND "
cQuery += "SD1.D1_LOJA = SF1.F1_LOJA AND "
cQuery += "SD1.D1_TIPO NOT IN ('D','B') AND "
cQuery += "SD1.D1_TIPODOC = SF1.F1_TIPODOC AND "
cQuery += "SD1.D_E_L_E_T_ <> '*' AND "

If !lEasy
	cQuery += "SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
	cQuery += "SB1.B1_COD = SD1.D1_COD AND "
	cQuery += "SB1.D_E_L_E_T_ <> '*' AND "
EndIf

cQuery += "SA2.A2_FILIAL ='"+xFilial("SA2")+"' AND "
cQuery += "SA2.A2_COD = SD1.D1_FORNECE AND "
cQuery += "SA2.A2_LOJA = SD1.D1_LOJA AND "
cQuery += "SA2.D_E_L_E_T_ <> '*' AND "
cQuery += "D1_COD >= '"  		    + MV_PAR01	+ "' AND "
cQuery += "D1_COD <= '"  	        + MV_PAR02	+ "' AND "
cQuery += "D1_DTDIGIT >= '" + DTOS(MV_PAR03)	+ "' AND "
cQuery += "D1_DTDIGIT <= '" + DTOS(MV_PAR04)	+ "' AND "
cQuery += "D1_GRUPO >= '"  		+ MV_PAR06	+ "' AND "
cQuery += "D1_GRUPO <= '"  		+ MV_PAR07	+ "' AND "
cQuery += "D1_FORNECE >= '"  		+ MV_PAR08	+ "' AND "
cQuery += "D1_FORNECE <= '"  		+ MV_PAR09	+ "' AND "
cQuery += "D1_LOCAL >= '"  		+ MV_PAR10	+ "' AND "
cQuery += "D1_LOCAL <= '"  		+ MV_PAR11	+ "' AND "
cQuery += "D1_DOC >= '"  	    	+ MV_PAR12	+ "' AND "
cQuery += "D1_DOC <= '"  		    + MV_PAR13	+ "' AND "
cQuery += "D1_SERIE >= '"  		+ MV_PAR14	+ "' AND "
cQuery += "D1_SERIE <= '"  		+ MV_PAR15	+ "' "
If ! Empty(MV_PAR16)
	Query := Space(0)
	Query+=" AND D1_TES IN ("
	FOR nI:=1 to len(AllTrim(mv_par16)) step 3
		if !empty(substr(mv_par16,nI,3))
			Query+="'" + substr(mv_par16,nI,3) + "',"
		else
			exit
		endif
	NEXT
	
	Query := substr(Query,1,len(Query)-1) + ')'
	
	cQuery += Query
EndIf

If ! Empty(MV_PAR17)
	Query := Space(0)
	Query+=" AND D1_CF IN ("
	FOR nI:=1 to len(AllTrim(mv_par17)) step 5
		if !empty(substr(mv_par17,nI,5))
			Query+="'" + substr(mv_par17,nI,5) + "',"
		else
			exit
		endif
	NEXT
	Query := substr(Query,1,len(Query)-1) + ')'
	cQuery += Query
EndIf
If nOrdem == 1
	cQuery += " ORDER BY 1,2,3,4,5,6,7"
ElseIf nOrdem == 2
	cQuery += " ORDER BY 1,2,3,4,5,6"
ElseIf nOrdem == 3
	cQuery += " ORDER BY 1,2,3,4,5,6"
ElseIf nOrdem == 4
	cQuery += " ORDER BY 1,2,3,4,5,6"
ElseIf nOrdem == 5
	cQuery += " ORDER BY 1,2,3,4,5,6"
Endif
cQuery := ChangeQuery(cQuery)

MEMOwrit('QUERY_JMHR080.SQL', cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'QRYSD1', .T., .T.)

For nX := 1 to Len(aStrucSD1)
	If aStrucSD1[nX,2] != 'C' .And. FieldPos(aStrucSD1[nx,1]) > 0
		TCSetField('QRYSD1', aStrucSD1[nX,1], aStrucSD1[nX,2],aStrucSD1[nX,3],aStrucSD1[nX,4])
	EndIf
Next nX

For nX := 1 to Len(aStrucSF1)
	If aStrucSF1[nX,2] != 'C'.And. FieldPos(aStrucSF1[nx,1]) > 0
		TCSetField('QRYSD1', aStrucSF1[nX,1], aStrucSF1[nX,2],aStrucSF1[nX,3],aStrucSF1[nX,4])
	EndIf
Next nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbGoTop()
nTGQUANT :=0
nTGUNITA :=0
nTGMERCA :=0
nTGVLIPI :=0
nTGVLICM :=0
nTGVLISS :=0
nTGDESPES:=0
nTGCUSTO1:=0
nTGMARGEM:=0


SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .and. lContinua
	
	IF lEnd
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	IncRegua()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	dbSelectArea((cAliasSF1))
	cDOCSER:= (cAliasSF1)->F1_DOC + (cAliasSF1)->F1_SERIE
	@ nLin ,0 PSAY "NOTA : " +(cAliasSF1)->F1_DOC
	@ nLin ,pcol() PSAY " SERIE : " +(cAliasSF1)->F1_SERIE +" "+ STR0009+DTOC((cAliasSF1)->F1_EMISSAO)+STR0010+(cAliasSD1)->D1_TIPO
	nLin := nLin + 1
	@nLin ,0 PSAY STR0011+(cAliasSF1)->F1_FORNECE+" LOJA "+(cAliasSF1)->F1_LOJA //+"-"+alltrim((cAliasSA1)->A1_NOME) //+" CNPJ : "+ A1_CGC+" NATUREZA : "+ALLTRIM(A1_NATUREZ) +"-" + ALLTRIM(POSICIONE("SED",1,XFILIAL("SED")+A1_NATUREZ,"ED_DESCRIC"))
	
	nLin := nLin + 2
	dbSelectArea(cAliasSD1)
	
	nTQUANT :=0
	nTUNITA :=0
	nTMERCA :=0
	nTVLIPI :=0
	nTVLICM :=0
	nTVLISS :=0
	nTDESPES:=0
	nTCUSTO1:=0
	nTMARGEM:=0
	
	While !EOF().AND. (cAliasSD1)->F1_DOC+ (cAliasSD1)->F1_SERIE == cDOCSER
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If lAbortPrint
			
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@nLin,000 PSAY (cAliasSD1)->D1_COD
		IF ! Empty(MV_PAR21)
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial()+(cAliasSD1)->D1_COD)
			@nLin , pcol()+1 PSAY Substr(SB1->B1_DESC,1,10)
		Else
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial()+(cAliasSD1)->D1_COD)
			@nLin , pcol()+1 PSAY Substr(SB1->B1_DESC,1,10)
		Endif

		dbSelectArea(cAliasSD1)
		@nLin,pcol()+1 PSAY (cAliasSD1)->D1_LOCAL
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD1)->D1_CONTA,1,10)
//		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD1)->D1_CCUSTO,1,10)
//		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD1)->D1_ITEMCC,1,10)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD1)->D1_CLVL,1,10)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD1)->D1_TES,1,3)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD1)->D1_CF,1,5)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD1)->D1_CLASFIS,1,3)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD1)->D1_GRUPO,1,4)
		@nLin,pcol()+1 PSAY (cAliasSD1)->D1_QUANT Picture  "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD1)->D1_VUNIT Picture "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD1)->D1_TOTAL Picture  "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD1)->D1_VALIPI Picture "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD1)->D1_VALICM Picture "@E 9,999,999.99"
//		@nLin,pcol()+1 PSAY (cAliasSD1)->D1_VALISS Picture "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD1)->D1_DESPESA Picture "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD1)->D1_CUSTO  Picture "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (100-(((cAliasSD1)->D1_CUSTO/(cAliasSD1)->D1_TOTAL)* 100))  Picture "@E 9,999,999.99"
		nLin := nLin + 1
		
		nTQUANT  := nTQUANT  + (cAliasSD1)->D1_QUANT
		nTUNITA  := nTUNITA  + (cAliasSD1)->D1_VUNIT
		nTMERCA  := nTMERCA  + (cAliasSD1)->D1_TOTAL
		nTVLIPI  := nTVLIPI  + (cAliasSD1)->D1_VALIPI
		nTVLICM  := nTVLICM  + (cAliasSD1)->D1_VALICM
//		nTVLISS  := nTVLISS  + (cAliasSD1)->D1_VALISS
		nTDESPES := nTDESPES + (cAliasSD1)->D1_DESPESA
		nTCUSTO1 := nTCUSTO1 + (cAliasSD1)->D1_CUSTO
		
		dbSkip()
		
	ENDDO
	nTMARGEM := 100-((nTCUSTO1/nTMERCA)*100)
	nLin := nLin + 3
	@nLin,70 PSAY "TOTAIS ---> R$     "
	
	@nLin,pcol()+1 PSAY nTQUANT  Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTUNITA  Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTMERCA  Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTVLIPI  Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTVLICM  Picture "@E 9,999,999.99"
//	@nLin,pcol()+1 PSAY nTVLISS  Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTDESPES Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTCUSTO1 Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTMARGEM Picture "@E 9,999,999.99"
	nLin := nLin + 2
	nTGQUANT:= nTGQUANT + nTQUANT
	nTGUNITA:= nTGUNITA + nTUNITA
	nTGMERCA:= nTGMERCA + nTMERCA
	nTGVLIPI:= nTGVLIPI + nTVLIPI
	nTGVLICM:= nTGVLICM + nTVLICM
//	nTGVLISS:= nTGVLISS + nTVLISS
	nTGDESPES:=	nTGDESPES + nTDESPES
	nTGCUSTO1:= nTGCUSTO1 + nTCUSTO1
	
	dbSkip()
EndDo
nTGMARGEM := 100-((nTGCUSTO1/nTGMERCA)*100)
nLin := nLin + 3
@nLin,70 PSAY "GERAL ---> R$      "
@nLin,pcol()+1 PSAY nTGQUANT   Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGUNITA   Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGMERCA  Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGVLIPI  Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGVLICM  Picture "@E 9,999,999.99"
//@nLin,pcol()+1 PSAY nTGVLISS  Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGDESPES  Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGCUSTO1  Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGMARGEM Picture "@E 9,999,999.99"

nLin := nLin + 1
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

dbSelectArea((cAliasSD1))
dbCloseArea()

Return
