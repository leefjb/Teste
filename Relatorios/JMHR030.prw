/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ JMHR030  ³ Autor ³ Giovanni              ³ Data ³02/10/2014³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rel. Divergencias Contagem Fisica X Saldo Poder Terceiros  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_JMHR030()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico JOMHEDICA                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JMHR030()

	Local oReport
	
	oReport := ReportDef()
	oReport:printDialog()	

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ReportDef ³ Autor ³Giovanni Melo          ³ Data ³ 02/10/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Definicao da estrutura do relatorio                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³JMHR030                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

	Local aOrdem  := {"B6_FILIAL + B6_CLIFOR + B6_LOJA + B6_PRODUTO"}
	Local cTitulo := "Relatório Conferência Poder de Terceiros"
	Local cDescri := ""
	Local cReport := "JMHR030"
	Local cPerg   := PadR( cReport, Len(SX1->X1_GRUPO) )
	Local oReport
	Local oSecCli
	Local oSecPro
	Local oSecDoc
	Local oBreak

	
	cDescri := "Este relatório emite a listagem de divergências entre "
	cDescri += "a Contagem Física importada X Saldo em Poder de Terceiros."
	
	CriaSX1(cPerg)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criacao e montagem das definicoes da impressao        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	oReport := TReport():New( cReport, cTitulo, cPerg, { |oReport| Imprime( oReport , cPerg) }, cDescri )
	oReport:SetPortrait()
	oReport:DisableOrientation()
	oReport:HideParamPage()
	oReport:SetTotalInLine(.F.)
	oReport:SetLineHeight(50)
	oReport:nFontBody := 09
	oReport:lBold := .F.	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a secao Clientes                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSecCli := TRSection():New( oReport, "Cliente", { "SA1", "SB6" }, aOrdem )
	
	TRCell():New( oSecCli,"B6_CLIFOR"  , "SB6" , "Cliente"        , PesqPict("SB6","B6_CLIFOR")  , TamSX3("B6_CLIFOR")[1]  ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecCli,"A1_NOME"    , "SA1" , "Nome"           , PesqPict("SB6","A1_NOME")    , TamSX3("A1_NOME")[1]    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecCli,"ZD_DOC"     , "SZD" , "Documento"      , PesqPict("SZD","ZD_DOC")     , TamSX3("ZD_DOC")[1]     ,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a secao Produtos                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSecPro := TRSection():New( oSecCli, "Produto", { "SB6", "SB1", "SD2", "SZD" } , aOrdem )
	
	oSecPro:SetTotalInLine(.F.)
	
	TRCell():New( oSecPro,"B6_PRODUTO"  , "SB6" , "Codigo"        , PesqPict("SB6","B6_PRODUTO") , TamSX3("B6_PRODUTO")[1] ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecPro,"B1_DESC"     , "SB1" , "Descricao"     , PesqPict("SB1","B1_DESC")    , 						30 ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecPro,"D2_LOTECTL"  , "SD2" , "Lote"          , PesqPict("SD2","D2_LOTECTL") , TamSX3("D2_LOTECTL")[1] ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecPro,"B6_SALDO"    , "SB6" , "Sdo. Protheus" , PesqPict("SB6","B6_SALDO")   , TamSX3("B6_SALDO")[1]   ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecPro,"ZD_QTDE"     , "SZD" , "Sdo. Contagem" , PesqPict("SB6","B6_SALDO")   , TamSX3("B6_SALDO")[1]   ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecPro,"DIVERGENCIA" , ""    , "Divergencia"   , PesqPict("SB6","B6_SALDO")   , TamSX3("B6_SALDO")[1]   ,/*lPixel*/,/*{|| code-block de impressao }*/)
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Total Produtos                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBreak := TRBreak():New(oSecPro, oSecPro:Cell("B6_PRODUTO"), "Total :",.F.)
	 
	TRFunction():New(oSecPro:Cell("B6_SALDO" )   , "TOT1", "SUM", oBreak,,,, .F., .F.)
	TRFunction():New(oSecPro:Cell("ZD_QTDE" )    , "TOT2", "SUM", oBreak,,,, .F., .F.)
	TRFunction():New(oSecPro:Cell("DIVERGENCIA" ), "TOT3", "SUM", oBreak,,,, .F., .F.)

Return(oReport)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Imprime   ³ Autor ³Giovanni Melo          ³ Data ³ 02/10/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Impressao do relatorio                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ReportDef                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Imprime(oReport, cPerg)

	Local oSecCli   := oReport:Section(1)
	Local oSecPro   := oReport:Section(1):Section(1)
	Local cAliasTmp := GetNextAlias()
	Local lTroca    := .F.           
	Local lCabecPro := .T.
	Local lDivZero	:= .F.
	Local lCliTroca	:= .T.
	Local cQuery    := ""
	Local cCliIni   := ""
	Local cLojaIni  := ""
	Local cCliFin   := ""
	Local cLojaFin  := ""
	Local cDocImp   := ""
	Local cProdAnt  := ""
	Local cCliAnt   := ""
	Local cLojAnt   := ""
	Local nRecTmp   := 0
	Local nDiv      := 0
	Local dDataImp  := ""
	

	dbSelectArea("SZD")
	dbSetOrder(1)

	Pergunte(cPerg, .F.)
	
	cCliIni   := MV_PAR01
	cLojaIni  := MV_PAR02
	cCliFin   := MV_PAR03
	cLojaFin  := MV_PAR04
	cDocImp   := MV_PAR05   
	lDivZero  := ( MV_PAR06 == 1 )


	cQuery := " SELECT TB_FILIAL, "
	cQuery += "        TB_CLIENTE, "
	cQuery += "        TB_LOJA, "
	cQuery += "        TB_NOMECLI, "	
	cQuery += "        TB_PRODUTO, "
	cQuery += "        TB_DESCPROD, "
	cQuery += "        TB_LOTECTL, "
	cQuery += "        B6_SALDO, "
	cQuery += "        ZD_QTDE "
	cQuery += " FROM   ("   

	cQuery += "    SELECT TB_FILIAL, "
	cQuery += "           TB_CLIENTE, "
	cQuery += "           TB_LOJA, "
	cQuery += "           TB_NOMECLI, "	
	cQuery += "           TB_PRODUTO, "
	cQuery += "           TB_DESCPROD, "
	cQuery += "           TB_LOTECTL, "
	cQuery += "           SUM(B6_SALDO)  AS B6_SALDO, "
	cQuery += "           SUM(ZD_QTDE)   AS ZD_QTDE "
	cQuery += "    FROM   ("
	cQuery += "          SELECT B6_FILIAL     AS TB_FILIAL, "
	cQuery += "                 B6_CLIFOR     AS TB_CLIENTE, "
	cQuery += "                 B6_LOJA       AS TB_LOJA, "
	cQuery += "                 A1_NOME       AS TB_NOMECLI, "
	cQuery += "                 B6_PRODUTO    AS TB_PRODUTO, "
	cQuery += "                 B1_DESC       AS TB_DESCPROD, "
	cQuery += "                 D2_LOTECTL    AS TB_LOTECTL, "
	cQuery += "                 SUM(B6_SALDO) AS B6_SALDO, "
	cQuery += "                 SUM(0)        AS ZD_QTDE "
	cQuery += "          FROM   " + RetSqlName('SB6') + " SB6, "
	cQuery +=                       RetSqlName('SD2') + " SD2, "
	cQuery +=                       RetSqlName('SA1') + " SA1, "
	cQuery +=                       RetSqlName('SB1') + " SB1 "	
	cQuery += "          WHERE  SB6.B6_FILIAL  =  '" + xFilial("SB6") + "' "
	cQuery += "            AND  SB6.B6_CLIFOR  >= '" + cCliIni   + "' "
	cQuery += "            AND  SB6.B6_CLIFOR  <= '" + cCliFin   + "' "
	cQuery += "            AND  SB6.B6_LOJA    >= '" + cLojaIni  + "' "
	cQuery += "            AND  SB6.B6_LOJA    <= '" + cLojaFin  + "' "
	cQuery += "            AND  SB6.B6_TES     >= '500' "
	cQuery += "            AND  SB6.B6_TIPO    =  'E' "
	cQuery += "            AND  SB6.B6_PODER3  =  'R' "
	cQuery += "            AND  SB6.B6_TPCF    =  'C' "
	cQuery += "            AND  SB6.D_E_L_E_T_ <> '*' "
	
	cQuery += "            AND  SD2.D2_FILIAL  =  SB6.B6_FILIAL "
	cQuery += "            AND  SD2.D2_DOC     =  SB6.B6_DOC "
	cQuery += "            AND  SD2.D2_SERIE   =  SB6.B6_SERIE "
	cQuery += "            AND  SD2.D2_CLIENTE =  SB6.B6_CLIFOR "
	cQuery += "            AND  SD2.D2_LOJA    =  SB6.B6_LOJA "
	cQuery += "            AND  SD2.D2_TIPO    =  'N' "
	cQuery += "            AND  SD2.D2_IDENTB6 =  SB6.B6_IDENT "
	cQuery += "            AND  SD2.D_E_L_E_T_ <> '*' "

	cQuery += "            AND  SA1.A1_FILIAL  = '" + xFilial("SA1") + "' "
	cQuery += "            AND  SA1.A1_COD     = SB6.B6_CLIFOR "
	cQuery += "            AND  SA1.D_E_L_E_T_ <> '*' "

	cQuery += "            AND  SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	cQuery += "            AND  SB1.B1_COD     = SB6.B6_PRODUTO "
	cQuery += "            AND  SB1.D_E_L_E_T_ <> '*' "
	
	cQuery += "          GROUP BY B6_FILIAL, B6_CLIFOR, B6_LOJA, A1_NOME, B6_PRODUTO, B1_DESC, D2_LOTECTL "
	cQuery += "          UNION ALL "
	cQuery += "          SELECT ZD_FILIAL    AS TB_FILIAL, " 
	cQuery += "                 ZD_CLIENTE   AS TB_CLIENTE, "
	cQuery += "                 ZD_LOJA      AS TB_LOJA, "
	cQuery += "                 A1_NOME      AS TB_NOMECLI, "
	cQuery += "                 ZD_PRODUTO   AS TB_PRODUTO, "
	cQuery += "                 B1_DESC      AS TB_DESCPROD, " 
	cQuery += "                 ZD_LOTECTL   AS TB_LOTECTL, "
	cQuery += "                 SUM(0)       AS B6_SALDO, "
	cQuery += "                 SUM(ZD_QTDE) AS ZD_QTDE "
	cQuery += "          FROM   " + RetSqlName('SZD') + " SZD, "
	cQuery +=                       RetSqlName('SA1') + " SA1, "
	cQuery +=                       RetSqlName('SB1') + " SB1 "
	cQuery += "          WHERE  SZD.ZD_FILIAL  =  '" + xFilial("SZD") + "' "
	cQuery += "            AND  SZD.ZD_CLIENTE >= '" + cCliIni  + "' "
	cQuery += "            AND  SZD.ZD_CLIENTE <= '" + cCliFin  + "' "
	cQuery += "            AND  SZD.ZD_LOJA    >= '" + cLojaIni + "' "
	cQuery += "            AND  SZD.ZD_LOJA    <= '" + cLojaFin + "' "
	cQuery += "            AND  SZD.ZD_DOC     =  '" + cDocImp  + "' "
	cQuery += "            AND  SZD.D_E_L_E_T_ <> '*' "

	cQuery += "            AND  SA1.A1_FILIAL  = '" + xFilial("SA1") + "' "
	cQuery += "            AND  SA1.A1_COD     = ZD_CLIENTE "
	cQuery += "            AND  SA1.D_E_L_E_T_ <> '*' "
	
	cQuery += "            AND  SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	cQuery += "            AND  SB1.B1_COD     = SZD.ZD_PRODUTO "
	cQuery += "            AND  SB1.D_E_L_E_T_ <> '*' "
	
	cQuery += "          GROUP BY ZD_FILIAL, ZD_CLIENTE, ZD_LOJA, A1_NOME, ZD_PRODUTO, B1_DESC, ZD_LOTECTL "
	cQuery += "              ) AS TRABA "
	cQuery += "    GROUP BY TB_FILIAL, TB_CLIENTE, TB_LOJA, TB_NOMECLI, TB_PRODUTO, TB_DESCPROD, TB_LOTECTL" 
	cQuery += " ) AS TRAB2"
	
	If ! lDivZero
		cQuery += " WHERE B6_SALDO <> ZD_QTDE"     //  mv_par_06 = nao : lista só o que tem divergencia
	Else
		cQuery += " WHERE (B6_SALDO <> 0 or ZD_QTDE <> 0)"    // lista tudo
	EndIf
	
	cQuery += " ORDER BY TB_FILIAL, TB_CLIENTE, TB_LOJA, TB_PRODUTO, TB_LOTECTL "	
		
	dbUseArea( .T.,"TOPCONN",TcGenQry(,,cQuery), cAliasTmp,.F.,.T. )
	
	Count To nRecTmp
	
	(cAliasTmp)->(dbGoTop())
	
	oReport:SetMeter(nRecTmp)
		
	If (cAliasTmp)->(! EoF())
	
		SZD->( dbSeek( xFilial("SZD") + cDocImp ) )
			
		dDataImp := SZD->ZD_DTAIMP
		
		While (cAliasTmp)->(!EoF())
		
			oSecCli:Init(.F.) //-- Inicializa Secao Cliente
			
			cCliAnt  := (cAliasTmp)->TB_CLIENTE
			cLojAnt  := (cAliasTmp)->TB_LOJA

			//-- Cabecalho do cliente
			oReport:PrtLeft("Cliente: "+cCliAnt+" - "+cLojAnt+" - Empresa: "+(cAliasTmp)->TB_NOMECLI)
			oReport:SkipLine()	
			oReport:PrtLeft("Documento Contagem: " + cDocImp + " - Data: " + DToC(dDataImp))
			oReport:SkipLine()
			
			lCabecPro := .T.			
			lCliTroca := .T.
			
			While (cAliasTmp)->(! EoF()) .And. (cAliasTmp)->TB_CLIENTE = cCliAnt;
                                         .And. (cAliasTmp)->TB_LOJA    = cLojAnt

				cProdAnt := (cAliasTmp)->TB_PRODUTO
				
				oSecPro:Init(lCabecPro) //-- Inicializa Secao Produto
				
				lCabecPro := .F.
				lTroca	  := .T.
						
				While (cAliasTmp)->(!EoF()) .And. (cAliasTmp)->TB_CLIENTE = cCliAnt;
                                            .And. (cAliasTmp)->TB_LOJA    = cLojAnt;
                                            .And. (cAliasTmp)->TB_PRODUTO = cProdAnt
					
					oReport:IncMeter()                                             
					
					nDiv := ( (cAliasTmp)->B6_SALDO - (cAliasTmp)->ZD_QTDE )
					
					If oReport:nDevice = 4 //4=Planilha
				
						If lCliTroca
						
							oSecCli:Cell("B6_CLIFOR"):Show()
							oSecCli:Cell("A1_NOME"):Show()
							oSecCli:Cell("ZD_DOC"):Show()
			
							oSecCli:Cell("B6_CLIFOR"):SetBlock({ || cCliAnt + " - " + cLojAnt } )
							oSecCli:Cell("A1_NOME"):SetBlock({ || (cAliasTmp)->TB_NOMECLI } )
							oSecCli:Cell("ZD_DOC"):SetBlock({ || cDocImp } )
							oSecCli:PrintLine()        
							
							lCliTroca := .F.
							
						Else
								
							oSecCli:Cell("B6_CLIFOR"):Hide()
							oSecCli:Cell("A1_NOME"):Hide()
							oSecCli:Cell("ZD_DOC"):Hide()
							
						EndIf
						
					Else
					
						oSecCli:Cell("B6_CLIFOR"):Disable()
						oSecCli:Cell("A1_NOME"):Disable()               
						oSecCli:Cell("ZD_DOC"):Disable()
						oSecCli:PrintLine()
		
					EndIf
						
					If lTroca // Trocou o produto?

						oSecPro:Cell("B6_PRODUTO"):Show()
						oSecPro:Cell("B1_DESC")   :Show() 

						lTroca := .F.
						
					Else
						oSecPro:Cell("B6_PRODUTO"):Hide()
						oSecPro:Cell("B1_DESC")   :Hide() 
					EndIf
									
					oSecPro:Cell("B6_PRODUTO") :SetBlock({ || (cAliasTmp)->TB_PRODUTO } )
					oSecPro:Cell("B1_DESC")    :SetBlock({ || (cAliasTmp)->TB_DESCPROD } )
					oSecPro:Cell("D2_LOTECTL") :SetBlock({ || (cAliasTmp)->TB_LOTECTL } )
					oSecPro:Cell("B6_SALDO")   :SetBlock({ || (cAliasTmp)->B6_SALDO } )
					oSecPro:Cell("ZD_QTDE")    :SetBlock({ || (cAliasTmp)->ZD_QTDE } )
					oSecPro:Cell("DIVERGENCIA"):SetBlock({ || nDiv } )				
					oSecPro:PrintLine()
				
					dbSelectArea(cAliasTmp)
					(cAliasTmp)->(dbSkip())
				
				EndDo

				oSecPro:Finish() //-- Encerra Secao Produto     
				oReport:SkipLine()
				
			EndDo
	
			oSecCli:Finish() //-- Encerra Secao Cliente
			oReport:EndPage()
			
		EndDo
		
	EndIf
		
	(cAliasTmp)->(dbCloseArea())
	
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CriaSX1   ³ Autor ³Giovanni Melo          ³ Data ³ 02/10/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Criacao do grupo de perguntas                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ReportDef                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CriaSX1(cPerg)

	Local aHelp1  := {}
	Local aHelp2  := {}
	Local aHelp3  := {}
	Local aHelp4  := {}
	Local aHelp5  := {}
	Local aHelp6  := {}

				  
	AAdd(aHelp1, "Código do cliente inicial" )

	AAdd(aHelp2, "Loja do cliente inicial" )

	AAdd(aHelp3, "Código do cliente final" )

	AAdd(aHelp4, "Loja do cliente final" )

	AAdd(aHelp5, "Número do documento gerado na " )
	AAdd(aHelp5, "importação da contagem de Saldos " )
	AAdd(aHelp5, "Físicos no cliente" )
	
	AAdd(aHelp6, "Lista os produtos com divergencia" )
	AAdd(aHelp6, "zerada." )

	//      Grupo	,cOrdem	,cPergunt       			,cPerSpa				,cPerEng				,cVar    	,cTipo	,nTamanho	,nDecimal	,nPresel	,cGSC	,cValid		,cF3	,cGrpSxg	,cPyme	,cVar01    	,cDef01     ,cDefSpB1	,cDefEng1		,cCnt01	,cDef02 	,cDefSpa2,cDefEng2	,cDef03     ,cDefSpa3	,cDefEng3	,cDef04	,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
	PutSx1( cPerg	,"01"  	,"Cliente De"				,"Cliente De"			,"Cliente De"			,"mv_ch0" 	,"C"  	,6      	,0       	,1      	,"G" 	,""   		,"SA1"	,""    		,""    	,"MV_PAR01"	,""			 ,""      		,""    	 	,""     ,""			,""      ,""      	,""    		,""     	,""    	,""			,""      ,""      ,""    ,""      ,""      ,aHelp1 	,""      ,""      ,""   )
	PutSx1( cPerg	,"02"  	,"Loja De"					,"Loja De"				,"Loja De"				,"mv_ch1" 	,"C"  	,2      	,0       	,1      	,"G" 	,""   		,""		,""    		,""    	,"MV_PAR02"	,""			 ,""      		,""    	 	,""		,""			,""      ,""      	,""    		,""     	,""    	,""    		,""      ,""      ,""    ,""      ,""      ,aHelp2 	,""      ,""      ,""   )
	PutSx1( cPerg	,"03"  	,"Cliente Ate"				,"Cliente Ate"	 		,"Cliente Ate"			,"mv_ch2" 	,"C"  	,6      	,0       	,1      	,"G" 	,""   		,"SA1"	,""    		,""    	,"MV_PAR03"	,""			 ,""      		,""    	 	,""		,""			,""      ,""      	,""    		,""     	,""    	,""     	,""      ,""      ,""    ,""      ,""      ,aHelp3 	,""      ,""      ,""   )
	PutSx1( cPerg	,"04"  	,"Loja Ate"					,"Loja Ate"		 		,"Loja Ate"				,"mv_ch3" 	,"C"  	,2      	,0       	,1      	,"G" 	,""   		,""		,""    		,""    	,"MV_PAR04"	,""			 ,""      		,""    	 	,""     ,""			,""      ,""      	,""    		,""     	,""    	,""     	,""      ,""      ,""    ,""      ,""      ,aHelp4	,""      ,""      ,""   )
	PutSx1( cPerg	,"05"  	,"Doc. Importacao"			,"Doc. Importacao"		,"Doc. Importacao"		,"mv_ch4" 	,"C"  	,9      	,0       	,1      	,"G" 	,""   		,"SZD"	,""    		,""    	,"MV_PAR05"	,""			 ,""      		,""    	 	,""     ,""			,""      ,""      	,""    		,""     	,""    	,""     	,""      ,""      ,""    ,""      ,""      ,aHelp5	,""      ,""      ,""   )
	PutSx1( cPerg	,"06"  	,"Listar diverg. zerada"	,"Listar diverg. zerada","Listar diverg. zerada","mv_ch5" 	,"N"  	,1      	,0       	,1      	,"C" 	,""   		,""		,""    		,""    	,"MV_PAR06"	,"Sim"		 ,""      		,""    	 	,""     ,"Nao"		,""      ,""      	,""    		,""     	,""    	,""     	,""      ,""      ,""    ,""      ,""      ,aHelp6	,""      ,""      ,""   )

Return
