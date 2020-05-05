#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "MATR550.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JmhR550   º  Eliane Carvalho Barbosa Data ³  21/08/06       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relacao das Notas Fiscais de Saidas                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function JmhRsd2()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relacao das Notas Fiscais de Saidas "
Local cPict          := ""
Local titulo         := "Relacao das Notas Fiscais de Saidas "
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
Private nomeprog     := "JMH550" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "JMH550" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "Sd2"

dbSelectArea("SD2")
dbSetOrder(3)

cPerg := PadR('JMH550',Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

Pergunte(cPerg,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De Nota                              ³
//³ mv_par02             // Ate a Nota                           ³
//³ mv_par03             // De Data                              ³
//³ mv_par04             // Ate a Data                           ³
//³ mv_par05             // De Produto                           ³
//³ mv_par06             // Ate o Produto                        ³
//³ mv_par07             // Da Serie                             ³
//³ mv_par08             // Da Serie                             ³
//³ mv_par09             // Mascara para codigo do produto       ³
//³ mv_par10             // Aglutina itens grade                 ³
//³ mv_par11             // De  Grupo                            ³
//³ mv_par12             // Ate Grupo                            ³
//³ mv_par13             // De  Tipo                             ³
//³ mv_par14             // Ate Tipo                             ³
//³ mv_par15             // Utiliza Descricao -Produto ProdxCli  ³
//³ mv_par16             // Qual Moeda                           ³
//³ mv_par17             // Outras moedas                        ³
//³ mv_par18             // Lista Dev. Compras ?                 ³
//³ mv_par19             // De Cliente                           ³
//³ mv_par20             // Ate Cliente                          ³
//³ mv_par21             // Tipo de Relatorio 1 Analitico 2 Sintetico                        ³
//³ mv_par22             // Tipo de Saida                         ³
//³ mv_par23             // Codigo Fiscal                         ³
//³ mv_par24             //  Do Almoxarifado ?                    ³
//³ mv_par25             // Ate Almoxarifado ?                    ³



wnrel:="JMH550"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  15/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery,Query
Local cCLIFOR, cNome
LOCAL nTCLIFOR,nTSALDO
LOCAL lContinua	:= .T.
dbSelectArea(cString)
dbSetOrder(3)

cAliasSF2 := GetNextAlias()
cAliasSD2 := cAliasSF2
cQuery:="SELECT F2_DOC,F2_SERIE,F2_EMISSAO,F2_TIPO,F2_ICMSRET"
cQuery+=",F2_FRETE,F2_SEGURO,F2_DESPESA"
cQuery+=",F2_VALIPI,F2_VALICM,F2_VALISS,SF2.R_E_C_N_O_ SF2RECNO "
cQuery+=",D2_DOC,D2_SERIE,D2_COD,D2_GRUPO,D2_TP,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_GRADE,D2_CF,D2_TES,D2_LOCAL,D2_ITEMPV,D2_PEDIDO,D2_CONTA,D2_CCUSTO,D2_CLVL,D2_CLASFIS"
cQuery+=",D2_PRCVEN,D2_ICMSRET,D2_QUANT,D2_TOTAL,D2_EMISSAO,D2_VALIPI,D2_CODISS,D2_VALISS,D2_DESPESA,D2_VALICM,D2_CUSTO1,D2_ITEMCC "
cQuery+="FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2 WHERE "
cQuery+="F2_FILIAL='"+xFilial("SF2")+"'"
cQuery+=" AND F2_DOC>='"+mv_par01+"' AND F2_DOC<='"+mv_par02+"'"
cQuery+=" AND F2_EMISSAO>='"+DTOS(mv_par03)+"' AND F2_EMISSAO<='"+DTOS(mv_par04)+"'"
cQuery+=" AND F2_SERIE>='"+mv_par07+"' AND F2_SERIE<='"+mv_par08+"'"
cQuery+=" AND F2_CLIENTE>='"+mv_par19+"' AND F2_CLIENTE<='"+mv_par20+"'"
cQuery+=" AND (NOT "+IsRemito(2,"F2_TIPODOC")+")"
If MV_PAR18==2
	cQuery+=" AND F2_TIPO<>'D'"
Endif
cQuery+=" AND SF2.D_E_L_E_T_<>'*' "
cQuery+=" AND D2_FILIAL='"+xFilial("SD2")+"' AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA"
cQuery+=" AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE"
cQuery+=" AND D2_COD>='"+mv_par05+"' AND D2_COD<='"+mv_par06+"'"
cQuery+=" AND D2_GRUPO>='"+mv_par11+"' AND D2_GRUPO<='"+mv_par12+"'"
cQuery+=" AND D2_TP>='"+mv_par13+"' AND D2_TP<='"+mv_par14+"'"
If ! Empty(MV_PAR22)
	Query := Space(0)
	Query+=" AND D2_TES IN ("
	FOR nI:=1 to len(AllTrim(mv_par22)) step 3
		if !empty(substr(mv_par22,nI,3))
			Query+="'" + substr(mv_par22,nI,3) + "',"
		else
			exit
		endif
	NEXT
	
	Query := substr(Query,1,len(Query)-1) + ')'
	
	cQuery += Query
EndIf

If ! Empty(MV_PAR23)
	Query := Space(0)
	Query+=" AND D2_CF IN ("
	FOR nI:=1 to len(AllTrim(mv_par23)) step 5
		if !empty(substr(mv_par23,nI,5))
			Query+="'" + substr(mv_par23,nI,5) + "',"
		else
			exit
		endif
	NEXT
	Query := substr(Query,1,len(Query)-1) + ')'
	cQuery += Query
EndIf
cQuery+=" AND D2_LOCAL>='"+mv_par24+"' AND D2_LOCAL<='"+mv_par25+"'"
cQuery+=" AND SD2.D_E_L_E_T_=''"
cQuery+=" ORDER BY F2_EMISSAO,F2_DOC,F2_SERIE,D2_COD,D2_ITEM"
cQuery:=ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSF2,.F.,.T.)
TCSetField(cAliasSF2,"F2_EMISSAO","D",8,0)
TCSetField(cAliasSD2,"D2_EMISSAO","D",8,0)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	dbSelectArea((cAliasSF2))
	cDOCSER:= (cAliasSF2)->F2_DOC + (cAliasSF2)->F2_SERIE
	@ nLin ,0 PSAY "NOTA : " +(cAliasSF2)->F2_DOC
	@ nLin ,pcol() PSAY " SERIE : " +(cAliasSF2)->F2_SERIE +" "+ STR0009+DTOC((cAliasSF2)->F2_EMISSAO)+STR0010+(cAliasSD2)->D2_TIPO
	nLin := nLin + 1
	
	If (cAliasSD2)->D2_TIPO $ "BD"
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
		@ nLin ,0 PSAY STR0008 + A2_COD +" LOJA : "+ A2_LOJA +"-"+ alltrim(A2_NOME)+" CNPJ : " + A2_CGC+" NATUREZA : " + ALLTRIM(A2_NATUREZ)+ "-" + ALLTRIM(POSICIONE("SED",1,XFILIAL("SED")+A2_NATUREZ,"ED_DESCRIC"))
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
		@nLin ,0 PSAY STR0011+A1_COD+" LOJA "+A1_LOJA+"-"+alltrim(A1_NOME) +" CNPJ : "+ A1_CGC+" NATUREZA : "+ALLTRIM(A1_NATUREZ) +"-" + ALLTRIM(POSICIONE("SED",1,XFILIAL("SED")+A1_NATUREZ,"ED_DESCRIC"))
	EndIf
	
	nLin := nLin + 2
	dbSelectArea(cAliasSD2)
	
	nTQUANT :=0
	nTUNITA :=0
	nTMERCA :=0
	nTVLIPI :=0
	nTVLICM :=0
	nTVLISS :=0
	nTDESPES:=0
	nTCUSTO1:=0
	nTMARGEM:=0
	
	While !EOF().AND. (cAliasSD2)->D2_DOC+ (cAliasSD2)->D2_SERIE == cDOCSER
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		IF mv_par15 == 1
			dbSelectArea("SB1");dbSetOrder(1);dbSeek(xFilial()+(cAliasSD2)->D2_COD)
			@nLin,000 PSAY (cAliasSD2)->D2_COD
			@nLin , pcol()+1 PSAY Substr(B1_DESC,1,10)
		Else
			// tratamento de CODIGO e DESCRICAO para Jomhedica
			// obeservar documento: \\server\microsiga\documentos\DEFINICAO_AMARRACAO_PRODUTO_CONVENIO.DOC 
			SC5->( dbSeek(xFilial('SC5')+(cAliasSF2)->D2_PEDIDO) )

			dbSelectArea("SA7");dbSetOrder(2)
			If dbSeek(xFilial()+(cAliasSD2)->D2_COD+'CONVEN'+SC5->C5_CONVENI)
				If ! Empty(SA7->A7_CODCLI)
					@nLin,000 PSAY SA7->A7_CODCLI
				Else
					@nLin,000 PSAY (cAliasSD2)->D2_COD
				EndIf
				@nLin , pcol()+1 PSAY Substr(A7_DESCCLI,1,10)
			Else
				dbSelectArea("SB1");dbSetOrder(1);dbSeek(xFilial()+(cAliasSD2)->D2_COD)
				@nLin,000 PSAY (cAliasSD2)->D2_COD
				@nLin , pcol()+1 PSAY Substr(B1_DESC,1,10)
			Endif
		Endif
		dbSelectArea(cAliasSD2)
		@nLin,pcol()+1 PSAY (cAliasSD2)->D2_LOCAL
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD2)->D2_CONTA,1,10)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD2)->D2_CCUSTO,1,10)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD2)->D2_ITEMCC,1,10)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD2)->D2_CLVL,1,10)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD2)->D2_TES,1,3)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD2)->D2_CF,1,5)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD2)->D2_CLASFIS,1,3)
		@nLin,pcol()+1 PSAY SUBSTR((cAliasSD2)->D2_GRUPO,1,4)
		@nLin,pcol()+1 PSAY (cAliasSD2)->D2_QUANT Picture  "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD2)->D2_PRCVEN Picture "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD2)->D2_TOTAL Picture  "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD2)->D2_VALIPI Picture "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD2)->D2_VALICM Picture "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD2)->D2_VALISS Picture "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD2)->D2_DESPESA Picture "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (cAliasSD2)->D2_CUSTO1  Picture "@E 9,999,999.99"
		@nLin,pcol()+1 PSAY (100-(((cAliasSD2)->D2_CUSTO1/(cAliasSD2)->D2_TOTAL)* 100))  Picture "@E 9,999,999.99"
		nLin := nLin + 1
		
		nTQUANT  := nTQUANT  + (cAliasSD2)->D2_QUANT
		nTUNITA  := nTUNITA  + (cAliasSD2)->D2_PRCVEN
		nTMERCA  := nTMERCA  + (cAliasSD2)->D2_TOTAL
		nTVLIPI  := nTVLIPI  + (cAliasSD2)->D2_VALIPI
		nTVLICM  := nTVLICM  + (cAliasSD2)->D2_VALICM
		nTVLISS  := nTVLISS  + (cAliasSD2)->D2_VALISS
		nTDESPES := nTDESPES + (cAliasSD2)->D2_DESPESA
		nTCUSTO1 := nTCUSTO1 + (cAliasSD2)->D2_CUSTO1
		
		dbSkip()
		
	ENDDO
	nTMARGEM := 100-((nTCUSTO1/nTMERCA)*100)
	nLin := nLin + 1
	@nLin,70 PSAY "TOTAIS ---> R$     "
	
	@nLin,pcol()+1 PSAY nTQUANT  Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTUNITA  Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTMERCA  Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTVLIPI  Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTVLICM  Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTVLISS  Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTDESPES Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTCUSTO1 Picture "@E 9,999,999.99"
	@nLin,pcol()+1 PSAY nTMARGEM Picture "@E 9,999,999.99"
	nLin := nLin + 1
   	@nLin,000 PSAY __PrtThinLine()
	nLin := nLin + 1

	nTGQUANT:= nTGQUANT + nTQUANT
	nTGUNITA:= nTGUNITA + nTUNITA
	nTGMERCA:= nTGMERCA + nTMERCA
	nTGVLIPI:= nTGVLIPI + nTVLIPI
	nTGVLICM:= nTGVLICM + nTVLICM
	nTGVLISS:= nTGVLISS + nTVLISS
	nTGDESPES:=	nTGDESPES + nTDESPES
	nTGCUSTO1:= nTGCUSTO1 + nTCUSTO1
	
	//dbSkip()
EndDo
nTGMARGEM := 100-((nTGCUSTO1/nTGMERCA)*100)
nLin := nLin + 2
@nLin,70 PSAY "GERAL ---> R$      "
@nLin,pcol()+1 PSAY nTGQUANT   Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGUNITA   Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGMERCA  Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGVLIPI  Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGVLICM  Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGVLISS  Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGDESPES  Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGCUSTO1  Picture "@E 9,999,999.99"
@nLin,pcol()+1 PSAY nTGMARGEM Picture "@E 9,999,999.99"

nLin := nLin + 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

dbSelectArea((cAliasSD2))
dbCloseArea()

Return
