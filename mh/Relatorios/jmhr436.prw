#include "Totvs.ch"
#DEFINE DMPAPER_A4 9
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ JMHR436  ³ Autor ³ Fabio Briddi        ³ Data ³ Ago/2015   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Rastrabilidade de Lotes                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias = Alias caso a rotina seja chamada pela MATA261     ³±±
±±³          ³ Recno = Recno posicionado                                  ³±±
±±³          ³ nOpc = acao de incluir/alterar/excluir                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Cliente DELL                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function JMHR436( cAlias, cRecno, nOpc )

	Local oReport

	oReport := ReportDef(cAlias)
	oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ReportDef ³ Autor ³ Fabio Briddi        ³ Data ³ Ago/2015    ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±ºDesc.     ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ JMHR436                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ReportDef()

	Local oReport 
	Local oSection1
	Local oSection2

	Local cReport := "JMHR436"
	Local cTitulo := "Rastreamento de Produto/Lote Unificado"
	Local cDescri := "Este relatorio ira emitir, Rastreamento de Produto/Lote Unificado."
	Local aOrdem  := {}
	Local cPerg   := PadR("JMHR436",Len(SX1->X1_GRUPO))
			
	CriaSX1( cPerg )
	
	Pergunte(cPerg, .F.)
	
	oReport := TReport():New( cReport, cTitulo, cPerg, { |oReport| Imprimir( oReport, cPerg ) }, cDescri )
	
	oReport:DisableOrientation()
	oReport:SetLandscape()
	oReport:NoUserFilter()
	oReport:ParamReadOnly(.F.)
	oReport:SetEdit(.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a secao Movimento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//TRSection():New(oParent,cTitle,uTable,aOrder,lLoadCells,lLoadOrder,uTotalText,lTotalInLine,lHeaderPage,;
	//				lHeaderBreak,lPageBreak,lLineBreak,nLeftMargin,nLeftMargin,lLineStyle,nColSpace,lAutoSize,;
	//				cCharSeparator,nLinesBefore,nCols,nClrBack,nClrFore,nPercentage)

	oSection1 := TRSection():New( oReport, "Produto", {"SB1"} )
	TRCell():New( oSection1, "D5_PRODUTO", "SD5",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "B1_DESC"   , "SB1",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "B1_TIPO"   , "SB1",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "B1_UM"     , "SB1",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "B8_LOTECTL", "SB8",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D5_DTVALID", "SD5",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)

	oSection2 := TRSection():New( oReport, "Movimento", {"SD5"} )
	oSection2:SetLeftMargin(5)
	TRCell():New( oSection2, "D5_LOCAL"   , "SD5",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D5_DATA"    , "SD5",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D5_DTVALID"	, "SD5",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D5_LOTECTL"	, "SD5",  "Lt Jom"  ,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D5_DOC"     , "SD5",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D5_SERIE"   , "SD5",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D5_ORIGLAN" , "SD5",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D5_ENTRADA" , "SD5",  "Entrada" ,	 PesqPictQt("D5_QUANT",12), TamSX3("D5_QUANT")[1], /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D5_SAIDA"   , "SD5",  "Saida"   ,	 PesqPictQt("D5_QUANT",12), TamSX3("D5_QUANT")[1], /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "C5_PACIENT"	, "SC5",  /*Titulo*/,	 /*Mascara*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "A1_NREDUZ"	, "SA1",  /*Titulo*/,	 /*Mascara*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/)

Return(oReport)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Imprimir  ºAutor  ³ Fabio Briddi       º Data ³  Ago/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao responsavel pela impressao.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ JMHR436                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function Imprimir(oReport,cPerg)

	Local oSection1 	:= oReport:Section(1)
	Local oSection2 	:= oReport:Section(2)
	Local cQuery	:= ""
	Local cTipoMov	:= ""
	Local cLocalOri	:= ""
	Local cLocalDes	:= ""
	Local aMov		:= {}
	Local aRet		:= {}
	Local lLocaliz	:= .T.
	Local nX			:= 0
	Local nReg		:= 0

	Pergunte(cPerg, .F.)

	cQuery += " SELECT  D5_FILIAL, D5_PRODUTO, B8_LOTECTL, D5_LOTECTL, D5_DATA, D5_LOCAL, D5_DTVALID, D5_CLIFOR, D5_LOJA, D5_DOC, D5_SERIE, D5_ORIGLAN, D5_NUMSEQ, D5_QUANT "
	cQuery +=        ", B1_DESC, B1_TIPO, B1_UM "
	cQuery += " FROM ( "
	//-- Lotes Criados por Doc de Entrada
	cQuery += " 		SELECT D5_FILIAL, D5_PRODUTO, B8_LOTECTL, D5_LOTECTL, D5_DATA, D5_LOCAL, D5_DTVALID, D5_CLIFOR, D5_LOJA, D5_DOC, D5_SERIE, D5_ORIGLAN, D5_NUMSEQ, D5_QUANT "
	cQuery += " 		 FROM " + RetSqlName("SB8") + " ORI "
	cQuery += " 		INNER JOIN " + RetSqlName("SD5") + " SD5 "
	cQuery += " 		   ON SD5.D5_FILIAL  =  ORI.B8_FILIAL "
	cQuery += " 		  AND SD5.D5_PRODUTO =  ORI.B8_PRODUTO "
	cQuery += " 		  AND SD5.D5_LOTECTL =  ORI.B8_LOTECTL "
	cQuery += " 		  AND SD5.D5_DATA    >= '" + DTOS(MV_PAR05) + "' "
	cQuery += " 		  AND SD5.D5_DATA    <= '" + DTOS(MV_PAR06) + "' "
	cQuery += " 		  AND D5_ESTORNO     <> 'S' "
	cQuery += " 		  AND CHARINDEX(D5_DOC,'X') = 0 "
	cQuery += " 		  AND SD5.D_E_L_E_T_ <> '*' "
	cQuery += " 		WHERE ORI.B8_FILIAL  =  '" + xFilial("SB8") + "' "
	cQuery += " 		  AND ORI.B8_PRODUTO >= '" + MV_PAR01 + "' "
	cQuery += " 		  AND ORI.B8_PRODUTO <= '" + MV_PAR02 + "' "
	cQuery += " 		  AND ORI.B8_LOTECTL >= '" + MV_PAR03 + "' "
	cQuery += " 		  AND ORI.B8_LOTECTL <= '" + MV_PAR04 + "' "
	cQuery += " 		  AND ORI.B8_LOCAL   >= '' "
	cQuery += " 		  AND ORI.B8_LOCAL   <= 'ZZ' "
	cQuery += " 		  AND ORI.B8_LOTEUNI <> 'S' "
	cQuery += " 		  AND ORI.D_E_L_E_T_ <> '*' "
	cQuery += " 		UNION ALL "
	//-- Lotes Criados por Lote Unico
	cQuery += " 		SELECT D5_FILIAL, D5_PRODUTO, B8_LTCTORI B8_LOTECTL, D5_LOTECTL, D5_DATA, D5_LOCAL, D5_DTVALID, D5_CLIFOR, D5_LOJA, D5_DOC, D5_SERIE, D5_ORIGLAN, D5_NUMSEQ, D5_QUANT "
	cQuery += " 		 FROM " + RetSqlName("SB8") + " UNI "
	cQuery += " 		INNER JOIN " + RetSqlName("SD5") + " SD5 "
	cQuery += " 		   ON SD5.D5_FILIAL  =  UNI.B8_FILIAL "
	cQuery += " 		  AND SD5.D5_PRODUTO =  UNI.B8_PRODUTO "
	cQuery += " 		  AND SD5.D5_LOTECTL =  UNI.B8_LOTECTL "
	cQuery += " 		  AND SD5.D5_DATA    >= '" + DTOS(MV_PAR05) + "' "
	cQuery += " 		  AND SD5.D5_DATA    <= '" + DTOS(MV_PAR06) + "' "
	cQuery += " 		  AND D5_ESTORNO     <> 'S' "
	cQuery += " 		  AND CHARINDEX(D5_DOC,'X') = 0 "
	cQuery += " 		  AND SD5.D_E_L_E_T_ <> '*' "
	cQuery += " 		WHERE UNI.B8_FILIAL  =  '" + xFilial("SB8") + "' "
	cQuery += " 		  AND UNI.B8_PRODUTO >= '" + MV_PAR01 + "' "
	cQuery += " 		  AND UNI.B8_PRODUTO <= '" + MV_PAR02 + "' "
	cQuery += " 		  AND UNI.B8_LTCTORI >= '" + MV_PAR03 + "' "
	cQuery += " 		  AND UNI.B8_LTCTORI <= '" + MV_PAR04 + "' "
	cQuery += " 		  AND UNI.B8_LOCAL   >= '' "
	cQuery += " 		  AND UNI.B8_LOCAL   <= 'ZZ' "
	cQuery += " 		  AND UNI.B8_LOTEUNI =  'S' "
	cQuery += " 		  AND UNI.B8_ORIGLAN =  'MI' "
	cQuery += " 		  AND UNI.D_E_L_E_T_ <> '*' "
	cQuery += " 		) AS TRABA, " + RetSqlName("SB1") + " SB1 "
	cQuery += " WHERE SB1.B1_FILIAL  =  '" + xFilial("SB1") + "' "
	cQuery += "   AND SB1.B1_COD     =  TRABA.D5_PRODUTO "
	cQuery += "   AND SB1.B1_RASTRO  =  'L' "
	cQuery += "   AND SB1.D_E_L_E_T_ <> '*' "
	//-- Descarta Transferencias Internas
	cQuery += "   AND NOT EXISTS (	SELECT 1 "
	cQuery += " 					FROM " + RetSqlName("SD3") + " SD3 "
	cQuery += " 					WHERE SD3.D3_FILIAL  =  TRABA.D5_FILIAL "
	cQuery += " 					  AND SD3.D3_COD     =  TRABA.D5_PRODUTO "
	cQuery += " 					  AND SD3.D3_DOC     =  TRABA.D5_DOC "
	cQuery += " 					  AND SD3.D3_LOCAL   =  TRABA.D5_LOCAL "
	cQuery += " 					  AND SD3.D3_NUMSEQ  =  TRABA.D5_NUMSEQ "
	cQuery += " 					  AND SD3.D_E_L_E_T_ <> '*') "
	cQuery += " ORDER BY D5_PRODUTO, D5_DATA, B8_LOTECTL, D5_LOTECTL, D5_NUMSEQ, D5_LOCAL "
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPR", .F., .T.)	
	
	Count To nReg
	
	TMPR->(dbGoTop())

	oReport:SetMeter(nReg)
	
	oSection2:Init()

	If	TMPR->(!Eof())
	
		While TMPR->(!Eof())

			cProduto := TMPR->D5_PRODUTO
			cLote    := TMPR->B8_LOTECTL

			oReport:SkipLine() 
			oSection1:Init()
			oSection1:Cell("D5_PRODUTO"):SetBlock({ || TMPR->D5_PRODUTO } )
			oSection1:Cell("B1_DESC"):SetBlock({ || TMPR->B1_DESC } )
			oSection1:Cell("B1_TIPO"):SetBlock({ || TMPR->B1_TIPO } )
			oSection1:Cell("B1_UM"):SetBlock({ || TMPR->B1_UM } )
			oSection1:Cell("B8_LOTECTL"):SetBlock({ || TMPR->B8_LOTECTL } )
			oSection1:Cell("D5_DTVALID"):SetBlock({ || TMPR->D5_DTVALID } )
		 	oSection1:PrintLine()		
			oReport:SkipLine() 

			While	TMPR->(!Eof())              .And.;
					TMPR->D5_PRODUTO = cProduto .And.;
					TMPR->B8_LOTECTL = cLote
			
					oReport:IncMeter()
				
					oSection2:Init()
					oSection2:Cell("D5_LOCAL"):SetBlock({ || TMPR->D5_LOCAL } )
					oSection2:Cell("D5_DATA"):SetBlock({ || STOD(TMPR->D5_DATA) } )
					oSection2:Cell("D5_DTVALID"):SetBlock({ || STOD(TMPR->D5_DTVALID) } )
					oSection2:Cell("D5_LOTECTL"):SetBlock({ || TMPR->D5_LOTECTL } )
					oSection2:Cell("D5_DOC"):SetBlock({ || TMPR->D5_DOC } )
					oSection2:Cell("D5_SERIE"):SetBlock({ || TMPR->D5_SERIE } )
					oSection2:Cell("D5_ORIGLAN"):SetBlock({ || TMPR->D5_ORIGLAN } )
			
					If		TMPR->D5_ORIGLAN <= "500"
			
							oSection2:Cell("D5_ENTRADA"):Show()
							oSection2:Cell("D5_ENTRADA"):SetBlock({ || TMPR->D5_QUANT } )
			
							oSection2:Cell("D5_SAIDA"):SetBlock({ || 0 } )
							oSection2:Cell("C5_PACIENT"):SetBlock({ || "" } )
							oSection2:Cell("A1_NREDUZ"):SetBlock({ || "" } )
			
							oSection2:Cell("D5_SAIDA"):Hide()
							oSection2:Cell("C5_PACIENT"):Hide()
							oSection2:Cell("A1_NREDUZ"):Hide()
			
					ElseIf	TMPR->D5_ORIGLAN > "500"
			
							oSection2:Cell("D5_ENTRADA"):SetBlock({ || 0 } )
							oSection2:Cell("D5_ENTRADA"):Hide()
			
							oSection2:Cell("D5_SAIDA"):Show()
							oSection2:Cell("C5_PACIENT"):Show()
							oSection2:Cell("A1_NREDUZ"):Show()
			
							oSection2:Cell("D5_SAIDA"):SetBlock({ || TMPR->D5_QUANT } )
			
							//-- Dados especificos da Jomhedica
							//-- Nome do Paciente e Local de uso do produto
							SD2->( dbSetOrder(3) )	//-- D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
							If	SD2->( dbSeek(xFilial('SD2')+TMPR->( D5_DOC+D5_SERIE+D5_CLIFOR+D5_LOJA+D5_PRODUTO) ) )
			
								SC5->( dbSetOrder(1) )	//-- C5_FILIAL+C5_NUM
								SC5->( dbSeek(xFilial('SC5')+SD2->D2_PEDIDO) )
				
								//-- Localizo o cliente vale
								SA1->( dbSetOrder(1) )
								If ! Empty(SC5->C5_CLIVALE) .And. !Empty(SC5->C5_LJCVALE)
									SA1->( dbSeek(xFilial("SA1")+SC5->C5_CLIVALE+SC5->C5_LJCVALE) )
								Else
									SA1->( dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI) )
								EndIf
				
								oSection2:Cell("C5_PACIENT"):SetBlock({ || SC5->C5_PACIENT } )
								oSection2:Cell("A1_NREDUZ"):SetBlock({ || SA1->A1_NREDUZ } )
			
							Else
			
								oSection2:Cell("C5_PACIENT"):SetBlock({ || "" } )
								oSection2:Cell("A1_NREDUZ"):SetBlock({ || "" } )
			
							EndIf
			
					EndIf
			
				 	oSection2:PrintLine()		
			
					dbSelectArea("TMPR")
					dbSkip()
		
			EndDo

			oSection2:Finish()
			oSection1:Finish()
			oReport:EndPage()

		EndDo

	EndIf

	TMPR->(dbCloseArea())
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CriaSX1   ³ Autor ³ Fabio Briddi        ³ Data ³ Ago/2015    ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria as perguntas no dicionario para o relatorio JMHR436   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CriaSX1(cExp1)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cExp1 = Nome da pergunta                                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHR436                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaSX1(cPerg)

	Local aHelp   := {}
	Local nLoteTam := TamSX3( "B8_LOTECTL" )[01]
	Local nProdTam := TamSX3( "B1_COD" )[01]

	aAdd( aHelp,{"Código do Produto Inicial","a ser considerado no filtro","dos movimentos."} )
	aAdd( aHelp,{"Código do Produto Final"," a ser considerado no filtro","dos movimentos."} )
	aAdd( aHelp,{"Número de Lote Origem Inicial","a ser considerado no filtro","dos movimentos."} )
	aAdd( aHelp,{"Número de Lote Origem Final"," a ser considerado no filtro","dos movimentos."} )
	aAdd( aHelp,{"Data Inicial para seleção dos movimentos."} )
	aAdd( aHelp,{"Data Final para seleção dos movimentos."} )

	//     cGrupo,cOrd,cPergunt          ,cPerSpa,cPerEng          ,cVar         ,cTipo ,nTam ,nDec,nPresel,cGSC,cValid  ,cF3  	 ,cGrpSxg,cPyme,cVar01    ,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor ,aHelpEng,aHelpSpa,cHelp
	PutSx1( cPerg,"01","Produto de?"     ,""     ,""	,"mv_ch1" ,"C" ,nProdTam ,0   ,1      ,"G" ,"" 	   		,""      ,""  	 ,""   ,"MV_PAR01",""    ,""      ,""	   ,""	  ,""    ,""      ,""      ,""    ,""	   ,""      ,""    ,""      ,""      ,""    ,""      ,""	  ,aHelp[01],""      ,""	  ,""  )
	PutSx1( cPerg,"02","Produto ate?"    ,""     ,""	,"mv_ch2" ,"C" ,nProdTam ,0   ,1      ,"G" ,""          ,""      ,""  	 ,""   ,"MV_PAR02",""    ,""      ,""	   ,""	  ,""    ,""      ,""      ,""    ,""	   ,""      ,""    ,""      ,""      ,""    ,""      ,""	  ,aHelp[02],""      ,""	  ,""  )
	PutSx1( cPerg,"03","Lote Origem de?" ,""     ,""	,"mv_ch3" ,"C" ,nLoteTam ,0   ,1      ,"G" ,"" 	   		,""      ,""  	 ,""   ,"MV_PAR03",""    ,""      ,""	   ,""	  ,""    ,""      ,""      ,""    ,""	   ,""      ,""    ,""      ,""      ,""    ,""      ,""	  ,aHelp[03],""      ,""	  ,""  )
	PutSx1( cPerg,"04","Lote Origem ate?",""     ,""	,"mv_ch4" ,"C" ,nLoteTam ,0   ,1      ,"G" ,""          ,""      ,""  	 ,""   ,"MV_PAR04",""    ,""      ,""	   ,""	  ,""    ,""      ,""      ,""    ,""	   ,""      ,""    ,""      ,""      ,""    ,""      ,""	  ,aHelp[04],""      ,""	  ,""  )
	PutSx1( cPerg,"05","Data Movto de?"  ,""     ,""	,"mv_ch5" ,"D" ,8		 ,0   ,1      ,"G" ,""		    ,""   	 ,""  	 ,""   ,"MV_PAR05",""    ,""      ,""	   ,""    ,""    ,""      ,""      ,""    ,""	   ,""	    ,""    ,""      ,""      ,""    ,""      ,""	  ,aHelp[05],""      ,""	  ,""  )
	PutSx1( cPerg,"06","Data Movto até?" ,""     ,""    ,"mv_ch6" ,"D" ,8		 ,0   ,1      ,"G" ,"" 		    ,""   	 ,""     ,""   ,"MV_PAR06",""    ,""      ,""	   ,""	  ,""    ,""      ,""      ,""    ,""	   ,""	    ,""    ,""    	,""      ,""    ,""      ,""	  ,aHelp[06],""      ,""	  ,""  )

Return
