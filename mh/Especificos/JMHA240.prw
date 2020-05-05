#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JMHA240 ºAutor  ³ Cristiano Oliveira º Data ³  11/01/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.Prog.³ Fechamento Mensal de Estoque em Poder de Terceiros         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.Fun. ³ Consultar os Processamentos Realizados                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ JOMHEDICA                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// *** CRIAR MV PARA GRAVAR O FECHAMENTO E VALIDAR SE JA FOI FECHADO QUANDO MOVIMENTAR ALGO ***

User Function JMHA240()

	Private nOpcBrow  := 1
	Private cCadastro := 'Fechamento de Consignados'
	Private aRotina   := {{ 'Pesquisar' , 'AxPesqui'   , 0, 1 },;
					      { 'Visualizar', 'AxVisual'   , 0, 2 },;
					      { 'Fechamento' , 'U_JMHA241()', 0, 3 } }

	dbSelectArea('ZZ9')
	mBrowse( 6, 1, 22, 75, "ZZ9" )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JMHA240 ºAutor  ³ Cristiano Oliveira º Data ³  11/01/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.Fun. ³ Parametros                                                 º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function JMHA241()

	Local cTitulo 	:= "Fechamento de Consignados"
	Local cPerg		:= PadR("JMHA241",Len( SX1->X1_GRUPO ))
	Local lOK		:= .F.

    PutSx1( cPerg, "01","Data Inicial","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01",,,,,,,,"","","","","","","","","",,,,"")
    PutSx1( cPerg, "02","Data Final  ","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02",,,,,,,,"","","","","","","","","",,,,"")

	lOk := Pergunte(cPerg, .T.)

	If lOk
	   	Processa({|| J241SQL()}, cTitulo )
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JMHA240 ºAutor  ³ Cristiano Oliveira º Data ³  11/01/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.Fun. ³ Consulta SQL e Gravacao ZZ9                                º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function J241SQL()

	Local cQuery   := ""
	Local nSaldo   := 0
	Local nPreco   := 0
	Local nCusto   := 0
	Local nSalAnt  := 0
	Local nContTB1 := 0
	Local nContTB2 := 0

	/*-----------------------------------------+
	| Validacao do Preenchimento de Parametros |
	+-----------------------------------------*/
	If EMPTY(mv_par01) .OR. EMPTY(mv_par02)
		MsgAlert("O preenchimento das datas inicial e final é obritório. Verifique os parâmetros!")
		Return
	EndIf

	/*---------------------------------+
	| Consulta de Produtos Consignados |
	+---------------------------------*/
	cQuery := " SELECT " + CRLF
	cQuery += "     B6_FILIAL, " + CRLF
	cQuery += "     B6_PRODUTO, " + CRLF
	cQuery += "	    B6_LOCAL, " + CRLF
	cQuery += "	    B6_CLIFOR, " + CRLF
	cQuery += "	    B6_LOJA, " + CRLF
	cQuery += "		SUM(CASE WHEN B6_PODER3 = 'R' THEN B6_QUANT ELSE '0' END) AS REMESSA, " + CRLF
	cQuery += "		SUM(CASE WHEN B6_PODER3 = 'D' THEN B6_QUANT ELSE '0' END) AS DEVOLUCAO, " + CRLF
	cQuery += "		SUM(CASE WHEN B6_PODER3 = 'R' THEN B6_CUSTO1 ELSE '0' END) AS CUSTOREM, " + CRLF
	cQuery += "		SUM(CASE WHEN B6_PODER3 = 'D' THEN B6_CUSTO1 ELSE '0' END) AS CUSTODEV, " + CRLF
	cQuery += "		SUM(CASE WHEN B6_PODER3 = 'R' THEN B6_PRUNIT ELSE '0' END) AS PRECOREM, " + CRLF
	cQuery += "		SUM(CASE WHEN B6_PODER3 = 'D' THEN B6_PRUNIT ELSE '0' END) AS PRECODEV " + CRLF
	cQuery += "	FROM " + RetSQLName("SB6") + " SB6 (NOLOCK) " + CRLF
	cQuery += "	WHERE B6_EMISSAO >= '" + DTOS(mv_par01) + "' " + CRLF
	cQuery += "	  AND B6_EMISSAO <= '" + DTOS(mv_par02) + "' " + CRLF
	cQuery += "	  AND D_E_L_E_T_ <> '*' " + CRLF
	cQuery += "	GROUP BY " + CRLF
	cQuery += "	    B6_FILIAL, " + CRLF
	cQuery += "	    B6_PRODUTO, " + CRLF
	cQuery += "	    B6_LOCAL, " + CRLF
	cQuery += "	    B6_CLIFOR, " + CRLF
	cQuery += "	    B6_LOJA " + CRLF
	cQuery += "	ORDER BY " + CRLF
	cQuery += "	    B6_FILIAL, " + CRLF
	cQuery += "	    B6_PRODUTO, " + CRLF
	cQuery += "	    B6_LOCAL, " + CRLF
	cQuery += "	    B6_CLIFOR, " + CRLF
	cQuery += "	    B6_LOJA " + CRLF

    //MemoWrite("\cprova\jmha240.txt", cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TB1",.F.,.T.)

	ProcRegua(RecCount())

	TB1->(dbGoTop())

	While TB1->(!EOF())

		IncProc()
		nContTB1 += 1

		/*----------------------------------+
		| Pega o saldo do ultimo fechamento |
		+----------------------------------*/

		// --> QUERY NO ZZ9 AQUI COM ORDER BY NO ZZ9_PERIOD (DECRESCENTE

		cQuery := " SELECT " + CRLF
		cQuery += " 	ZZ9_SALDO AS SALANT" + CRLF
		cQuery += "	FROM " + RetSQLName("ZZ9") + " ZZ9 (NOLOCK) " + CRLF
		cQuery += "	WHERE ZZ9_FILIAL = '" + TB1->B6_FILIAL + "' " + CRLF
		cQuery += "	  AND ZZ9_PROD   = '" + TB1->B6_PRODUTO + "' " + CRLF
		cQuery += "	  AND ZZ9_LOCAL  = '" + TB1->B6_LOCAL + "' " + CRLF
		cQuery += "	  AND ZZ9_CLI    = '" + TB1->B6_CLIFOR + "' " + CRLF
		cQuery += "	  AND ZZ9_LOJA   = '" + TB1->B6_LOJA + "' " + CRLF
		cQuery += "	  AND D_E_L_E_T_ <> '*' " + CRLF
		cQuery += "	ORDER BY " + CRLF
		cQuery += "	  ZZ9_PERIOD DESC " + CRLF

		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TB2",.F.,.T.)

		If TB2->(!EOF())
			nSalAnt	 := TB2->SALANT
			nContTB2 += 1
		Else
			nSalAnt := 0
		EndIf
		TB2->(dbCloseArea())

		/*------------------------------------------------------------------+
		| Calcula o saldo atual pelo saldo anterior + REMESSAS - DEVOLUCOES |
		+------------------------------------------------------------------*/
		nSaldo := (nSalAnt + TB1->REMESSA) - TB1->DEVOLUCAO
		nCusto := (nSalAnt + TB1->CUSTOREM) - TB1->CUSTODEV
		nPreco := (nSalAnt + TB1->PRECOREM) - TB1->PRECODEV
		// -----------------------------------------------------

		/*-----------------+
		| Gravacao da ZZ9  |
		+-----------------*/
		RecLock("ZZ9", .T.)
		ZZ9->ZZ9_FILIAL := TB1->B6_FILIAL
		ZZ9->ZZ9_PROD   := TB1->B6_PRODUTO
		ZZ9->ZZ9_LOCAL  := TB1->B6_LOCAL
		ZZ9->ZZ9_CLI    := TB1->B6_CLIFOR
		ZZ9->ZZ9_LOJA   := TB1->B6_LOJA
		ZZ9->ZZ9_PERIOD := SUBSTR(DTOS(mv_par02), 1, 6)
		ZZ9->ZZ9_REM    := TB1->REMESSA
		ZZ9->ZZ9_DEV    := TB1->DEVOLUCAO
		ZZ9->ZZ9_SALANT := nSalAnt
		ZZ9->ZZ9_SALDO  := nSaldo
		ZZ9->ZZ9_PRECO  := nPreco
		ZZ9->ZZ9_CUSTO  := nCusto
		ZZ9->ZZ9_DTINI  := mv_par01
		ZZ9->ZZ9_DTFIM  := mv_par02
		ZZ9->ZZ9_DTPROC := dDataBase
		ZZ9->ZZ9_USPROC := cUserName
		MsUnlock()

		dbSelectArea("TB1")
		dbSkip()

	EndDo
	TB1->(dbCloseArea())

	MsgInfo("PROCESSADOS: " + cValToChar(nContTB1) + " | ATUALIZADOS:" + cValToChar(nContTB2) + " | INCLUÍDOS: " + cValToChar(nContTB1 - nContTB2))

Return