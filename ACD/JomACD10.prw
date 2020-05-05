#include "Totvs.ch"
#DEFINE DMPAPER_A4 9

/*/{Protheus.doc} JOMACD10
//Ajustado o fonte JMHR436.prw - Relatorio rastreabilidade Lote - projeto ACD
@author Celso Rene
@since 11/12/2018
@version 1.0
@return ${return}, ${return_description}
@param cAlias, characters, descricao
@param cRecno, characters, descricao
@param nOpc, numeric, descricao
@type function
/*/
User Function JOMACD10( cAlias, cRecno, nOpc )

	Local oReport

	oReport := ReportDef()
	oReport:PrintDialog()

Return


/*/{Protheus.doc} ReportDef
//Definicao do objeto do relatorio personalizavel e das  secoes que serao utilizadas - uso JMHR801
@author Celso Rene
@since 29/10/2018
@version 1.0
@type function
/*/
Static Function ReportDef()

	Local oReport 
	Local oSection1
	Local oSection2
	Local oSection3

	Local cReport := "JOMACD10"
	Local cTitulo := "Rastreamento de Produto/Lote Unificado"
	Local cDescri := "Este relatorio ira emitir, Rastreamento de Produto/Lote Unificado."
	Local aOrdem  := {}
	Local cPerg   := PadR("JMHR436",Len(SX1->X1_GRUPO)) //usando a mesma pergunta do relatorio JMHR436

	CriaSX1( cPerg )

	Pergunte(cPerg, .F.)

	oReport := TReport():New( cReport, cTitulo, cPerg, { |oReport| Imprimir( oReport, cPerg ) }, cDescri )

	oReport:DisableOrientation()
	oReport:SetPortrait()
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


	oSection3 := TRSection():New( oReport, "Etiquetas", {"CB9"} )
	oSection3:SetLeftMargin(7)
	TRCell():New( oSection3, "CB9_ORDSEP"     , "CB9",  "Ord. Sep. ", PesqPictQt("CB9_ORDSEP",8),  TamSX3("CB9_ORDSEP")[1] , /*lPixel*/, /*{|| code-block de impressao }*/ , , .T. )
	TRCell():New( oSection3, "CB9_CODETI"     , "CB9",  "I.D. Etiq. ", "@!" , 10 , /*lPixel*/, /*{|| code-block de impressao }*/ )


Return(oReport)


/*/{Protheus.doc} Imprimir
//Funcao responsavel pela impressao. - Uso JMHR801
@author solutio02
@since 29/10/2018
@version 1.0
@return ${return}, ${return_description}
@param oReport, object, descricao
@param cPerg, characters, descricao
@type function
/*/
Static Function Imprimir(oReport,cPerg)

	Local oSection1 	:= oReport:Section(1)
	Local oSection2 	:= oReport:Section(2)
	Local oSection3 	:= oReport:Section(3)
	Local cQuery	:= ""
	Local cTipoMov	:= ""
	Local cLocalOri	:= ""
	Local cLocalDes	:= ""
	Local aMov		:= {}
	Local aRet		:= {}
	Local lLocaliz	:= .T.
	Local nX			:= 0
	Local nReg		:= 0

	Private _cxEtiq := "" //controle ID etiqueta
	Private _cDoc	:= ""

	Pergunte(cPerg, .F.)

	cQuery += " SELECT  D5_FILIAL, D5_PRODUTO, B8_LOTECTL, D5_LOTECTL, D5_DATA, D5_LOCAL, D5_DTVALID, D5_CLIFOR, D5_LOJA, D5_DOC, D5_SERIE, D5_ORIGLAN, D5_NUMSEQ, D5_QUANT " + chr(13)
	cQuery +=        ", B1_DESC, B1_TIPO, B1_UM "  + chr(13)
	cQuery += " FROM ( "  + chr(13)
	//-- Lotes Criados por Doc de Entrada
	cQuery += " 		SELECT D5_FILIAL, D5_PRODUTO, B8_LOTECTL, D5_LOTECTL, D5_DATA, D5_LOCAL, D5_DTVALID, D5_CLIFOR, D5_LOJA, D5_DOC, D5_SERIE, D5_ORIGLAN, D5_NUMSEQ, D5_QUANT "  + chr(13)
	cQuery += " 		 FROM " + RetSqlName("SB8") + " ORI "  + chr(13)
	cQuery += " 		INNER JOIN " + RetSqlName("SD5") + " SD5 "  + chr(13)
	cQuery += " 		   ON SD5.D5_FILIAL  =  ORI.B8_FILIAL "  + chr(13)
	cQuery += " 		  AND SD5.D5_PRODUTO =  ORI.B8_PRODUTO "  + chr(13)
	cQuery += " 		  AND SD5.D5_LOTECTL =  ORI.B8_LOTECTL "  + chr(13)
	cQuery += " 		  AND SD5.D5_DATA    >= '" + DTOS(MV_PAR05) + "' "  + chr(13)
	cQuery += " 		  AND SD5.D5_DATA    <= '" + DTOS(MV_PAR06) + "' "  + chr(13)
	cQuery += " 		  AND D5_ESTORNO     <> 'S' "  + chr(13)
	cQuery += " 		  AND CHARINDEX(D5_DOC,'X') = 0 "  + chr(13)
	cQuery += " 		  AND SD5.D_E_L_E_T_ <> '*' "  + chr(13)
	cQuery += " 		WHERE ORI.B8_FILIAL  =  '" + xFilial("SB8") + "' "  + chr(13)
	cQuery += " 		  AND ORI.B8_PRODUTO >= '" + MV_PAR01 + "' "  + chr(13)
	cQuery += " 		  AND ORI.B8_PRODUTO <= '" + MV_PAR02 + "' "  + chr(13)
	cQuery += " 		  AND ORI.B8_LOTECTL >= '" + MV_PAR03 + "' "  + chr(13)
	cQuery += " 		  AND ORI.B8_LOTECTL <= '" + MV_PAR04 + "' "  + chr(13)
	cQuery += " 		  AND ORI.B8_LOCAL   >= '' "  + chr(13)
	cQuery += " 		  AND ORI.B8_LOCAL   <= 'ZZ' "  + chr(13)
	cQuery += " 		  AND ORI.B8_LOTEUNI <> 'S' "  + chr(13)
	cQuery += " 		  AND ORI.D_E_L_E_T_ <> '*' "  + chr(13)
	cQuery += " 		UNION ALL " + chr(13)
	//-- Lotes Criados por Lote Unico 
	cQuery += " 		SELECT D5_FILIAL, D5_PRODUTO, B8_LTCTORI B8_LOTECTL, D5_LOTECTL, D5_DATA, D5_LOCAL, D5_DTVALID, D5_CLIFOR, D5_LOJA, D5_DOC, D5_SERIE, D5_ORIGLAN, D5_NUMSEQ, D5_QUANT "  + chr(13)
	cQuery += " 		 FROM " + RetSqlName("SB8") + " UNI "  + chr(13)
	cQuery += " 		INNER JOIN " + RetSqlName("SD5") + " SD5 "  + chr(13)
	cQuery += " 		   ON SD5.D5_FILIAL  =  UNI.B8_FILIAL "  + chr(13)
	cQuery += " 		  AND SD5.D5_PRODUTO =  UNI.B8_PRODUTO "  + chr(13)
	cQuery += " 		  AND SD5.D5_LOTECTL =  UNI.B8_LOTECTL "  + chr(13)
	cQuery += " 		  AND SD5.D5_DATA    >= '" + DTOS(MV_PAR05) + "' "  + chr(13)
	cQuery += " 		  AND SD5.D5_DATA    <= '" + DTOS(MV_PAR06) + "' "  + chr(13)
	cQuery += " 		  AND D5_ESTORNO     <> 'S' "  + chr(13)
	cQuery += " 		  AND CHARINDEX(D5_DOC,'X') = 0 "  + chr(13)
	cQuery += " 		  AND SD5.D_E_L_E_T_ <> '*' "  + chr(13)
	cQuery += " 		WHERE UNI.B8_FILIAL  =  '" + xFilial("SB8") + "' "  + chr(13)
	cQuery += " 		  AND UNI.B8_PRODUTO >= '" + MV_PAR01 + "' "  + chr(13)
	cQuery += " 		  AND UNI.B8_PRODUTO <= '" + MV_PAR02 + "' "  + chr(13)
	cQuery += " 		  AND UNI.B8_LTCTORI >= '" + MV_PAR03 + "' "  + chr(13)
	cQuery += " 		  AND UNI.B8_LTCTORI <= '" + MV_PAR04 + "' "  + chr(13)
	cQuery += " 		  AND UNI.B8_LOCAL   >= '' "  + chr(13)
	cQuery += " 		  AND UNI.B8_LOCAL   <= 'ZZ' "  + chr(13)
	cQuery += " 		  AND UNI.B8_LOTEUNI =  'S' "  + chr(13)
	cQuery += " 		  AND UNI.B8_ORIGLAN =  'MI' "  + chr(13)
	cQuery += " 		  AND UNI.D_E_L_E_T_ <> '*' "  + chr(13)
	cQuery += " 		) AS TRABA, " + RetSqlName("SB1") + " SB1 "  + chr(13)
	cQuery += " WHERE SB1.B1_FILIAL  =  '" + xFilial("SB1") + "' "  + chr(13)
	cQuery += "   AND SB1.B1_COD     =  TRABA.D5_PRODUTO "  + chr(13)
	cQuery += "   AND SB1.B1_RASTRO  =  'L' "  + chr(13)
	cQuery += "   AND SB1.D_E_L_E_T_ <> '*' "  + chr(13)
	//-- Descarta Transferencias Internas
	cQuery += "   AND NOT EXISTS (	SELECT 1 "  + chr(13)
	cQuery += " 					FROM " + RetSqlName("SD3") + " SD3 "  + chr(13)
	cQuery += " 					WHERE SD3.D3_FILIAL  =  TRABA.D5_FILIAL "  + chr(13)
	cQuery += " 					  AND SD3.D3_COD     =  TRABA.D5_PRODUTO "  + chr(13)
	cQuery += " 					  AND SD3.D3_DOC     =  TRABA.D5_DOC "  + chr(13)
	cQuery += " 					  AND SD3.D3_LOCAL   =  TRABA.D5_LOCAL "  + chr(13)
	cQuery += " 					  AND SD3.D3_NUMSEQ  =  TRABA.D5_NUMSEQ "  + chr(13)
	cQuery += " 					  AND SD3.D_E_L_E_T_ <> '*') "  + chr(13)
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

				If	TMPR->D5_ORIGLAN <= "500"

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

				//Consultando se existe etiqueta
				If (_cDoc == "" .or. _cDoc == TMPR->D5_DOC )
					_aCB9 := BuscaEtic(cProduto,TMPR->D5_LOTECTL,cLote,TMPR->D5_DATA,TMPR->D5_ORIGLAN,TMPR->D5_LOCAL,TMPR->D5_DOC ,TMPR->D5_SERIE , TMPR->D5_CLIFOR , TMPR->D5_LOJA)					
				ELse
					_cxEtiq := ""
					_aCB9 := BuscaEtic(cProduto,TMPR->D5_LOTECTL,cLote,TMPR->D5_DATA,TMPR->D5_ORIGLAN,TMPR->D5_LOCAL,TMPR->D5_DOC ,TMPR->D5_SERIE , TMPR->D5_CLIFOR , TMPR->D5_LOJA)
				EndIf

				//preparando array para nao repetir as etiquetas conforme item do documento
				If (Len(_aCB9) > 0 )

					_aCB9x:= _aCB9
					_aCB9 := {}
					For _y:= 1 to Len(_aCB9x)
						If !(_aCB9x[_y][4] $ _cxEtiq ) 
							aadd(_aCB9, { _aCB9x[_y][1],;
							_aCB9x[_y][2],; 	
							_aCB9x[_y][3],;
							_aCB9x[_y][4],;			
							_aCB9x[_y][5] })	
						EndIf				
					Next _y

				EndIf

				For _x:= 1 to Len(_aCB9)

					If !(_aCB9[_x][4] $ _cxEtiq ) .and. _x <= _aCB9[_x][5] 
						oSection3:Init()
						oSection3:Cell("CB9_ORDSEP"):SetBlock({ || _aCB9[_x][2] } )
						oSection3:Cell("CB9_CODETI"):SetBlock({ || _aCB9[_x][4] } )

						_cxEtiq += _aCB9[_x][4] + ","

						oSection3:PrintLine()

					EndIf

				Next _x

				_cDoc 	:= TMPR->D5_DOC 


				If (Len(_aCB9) > 0)
					oSection3:Finish()
					oSection2:Init()
					oSection2:Finish()
				EndIf

				_aCB9 := {}

				dbSelectArea("TMPR")
				dbSkip()

			EndDo

			oSection2:Finish()
			oSection1:Finish()
			oReport:EndPage()

		EndDo

	EndIf

	TMPR->(dbCloseArea())

Return()

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


/*/{Protheus.doc} CriaSX1
//Cria as perguntas no dicionario para o relatorio JMHR436
@author Celso Rene
@since 29/10/2018
@version 1.0
@type function
/*/
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
	PutSx1( cPerg,"01","Produto de?"     ,""     ,""	,"mv_ch1" ,"C" ,nProdTam ,0   ,1      ,"G" ,"" 	   		,""      ,"SB1"  	 ,""   ,"MV_PAR01",""    ,""      ,""	   ,""	  ,""    ,""      ,""      ,""    ,""	   ,""      ,""    ,""      ,""      ,""    ,""      ,""	  ,aHelp[01],""      ,""	  ,""  )
	PutSx1( cPerg,"02","Produto ate?"    ,""     ,""	,"mv_ch2" ,"C" ,nProdTam ,0   ,1      ,"G" ,""          ,""      ,"SB1"  	 ,""   ,"MV_PAR02",""    ,""      ,""	   ,""	  ,""    ,""      ,""      ,""    ,""	   ,""      ,""    ,""      ,""      ,""    ,""      ,""	  ,aHelp[02],""      ,""	  ,""  )
	PutSx1( cPerg,"03","Lote Origem de?" ,""     ,""	,"mv_ch3" ,"C" ,nLoteTam ,0   ,1      ,"G" ,"" 	   		,""      ,""  	 ,""   ,"MV_PAR03",""    ,""      ,""	   ,""	  ,""    ,""      ,""      ,""    ,""	   ,""      ,""    ,""      ,""      ,""    ,""      ,""	  ,aHelp[03],""      ,""	  ,""  )
	PutSx1( cPerg,"04","Lote Origem ate?",""     ,""	,"mv_ch4" ,"C" ,nLoteTam ,0   ,1      ,"G" ,""          ,""      ,""  	 ,""   ,"MV_PAR04",""    ,""      ,""	   ,""	  ,""    ,""      ,""      ,""    ,""	   ,""      ,""    ,""      ,""      ,""    ,""      ,""	  ,aHelp[04],""      ,""	  ,""  )
	PutSx1( cPerg,"05","Data Movto de?"  ,""     ,""	,"mv_ch5" ,"D" ,8		 ,0   ,1      ,"G" ,""		    ,""   	 ,""  	 ,""   ,"MV_PAR05",""    ,""      ,""	   ,""    ,""    ,""      ,""      ,""    ,""	   ,""	    ,""    ,""      ,""      ,""    ,""      ,""	  ,aHelp[05],""      ,""	  ,""  )
	PutSx1( cPerg,"06","Data Movto até?" ,""     ,""    ,"mv_ch6" ,"D" ,8		 ,0   ,1      ,"G" ,"" 		    ,""   	 ,""     ,""   ,"MV_PAR06",""    ,""      ,""	   ,""	  ,""    ,""      ,""      ,""    ,""	   ,""	    ,""    ,""    	,""      ,""    ,""      ,""	  ,aHelp[06],""      ,""	  ,""  )

Return()



/*/{Protheus.doc} BuscaEtic
//Busca etiquetas - CB9 (itens separados) e ZZH (historicos separacoes - itens separados com devolução - reutilizacao etiqueta )
@author Celso Rene
@since 17/12/2018
@version 1.0
@type function
/*/
Static Function BuscaEtic(_cProduto, _cLotectl ,_cLoteF , _cData ,_cLan, _cLocal, _cDoc, _cSerie, _cClifor, _cLoja )

	Local _cQuery2	:= "" //query etiquetas documento de saida
	Local _cQuery3	:= "" //query etiquetas devolucao documento de entrada
	Local _aEtiqR	:= {} 



	If ( _cLan >= "500" ) 

		_cQuery2 += "  SELECT * FROM ( " + chr(13)
		_cQuery2 += " SELECT ISNULL(CB9.CB9_FILIAL,'') AS CB9_FILIAL , ISNULL(CB9_CODETI,'') AS CB9_CODETI , ISNULL(CB9.CB9_PROD,'') AS CB9_PROD ,CB9.CB9_LOTECT, SD2.D2_LOTECTL, SD5.D5_DATA, SD5.D5_LOCAL, " + chr(13) 
		_cQuery2 += " SD5.D5_DTVALID ,SD5.D5_CLIFOR, SD5.D5_LOJA, SD5.D5_DOC, SD5.D5_SERIE, SD5.D5_ORIGLAN, SD5.D5_NUMSEQ, ISNULL(CB9.CB9_QTESEP,0) AS CB9_QTESEP , ISNULL(CB9.CB9_ORDSEP,'') AS CB9_ORDSEP " + chr(13)

		_cQuery2 += " FROM " + RetSqlName("SD2") + " SD2 " + chr(13) 
		_cQuery2 += " INNER JOIN " + RetSqlName("SD5") + " SD5 " + chr(13) 
		_cQuery2 += " ON SD5.D5_FILIAL = SD2.D2_FILIAL " + chr(13)
		_cQuery2 += " AND SD5.D5_PRODUTO = SD2.D2_COD " + chr(13) 
		_cQuery2 += " AND SD5.D5_LOTECTL = SD2.D2_LOTECTL " + chr(13)
		_cQuery2 += " AND SD5.D5_DATA = '" + _cData + "' " + chr(13)
		_cQuery2 += " AND SD5.D5_ESTORNO <> 'S' " + chr(13)
		_cQuery2 += " AND SD5.D5_ORIGLAN = '" + _cLan + "' " + chr(13)
		_cQuery2 += " AND CHARINDEX(D5_DOC,'X') = 0 " + chr(13)
		_cQuery2 += " AND SD5.D_E_L_E_T_ <> '*' " + chr(13) 

		_cQuery2 += " INNER JOIN " + RetSqlName("CB7") + " CB7 ON CB7.D_E_L_E_T_ = '' AND CB7.CB7_FILIAL = '" + xFilial("CB7") + "' AND CB7.CB7_PEDIDO = SD2.D2_PEDIDO AND CB7.CB7_NOTA = SD5.D5_DOC AND CB7.CB7_SERIE = SD5.D5_SERIE " + chr(13)
		_cQuery2 += " AND CB7.CB7_ORDSEP = SD2.D2_ORDSEP " + chr(13)

		_cQuery2 += " INNER JOIN " + RetSqlName("CB8") + " CB8 ON CB8.D_E_L_E_T_ = '' AND CB8.CB8_FILIAL = '" + xFilial("CB8") + "' AND CB8.CB8_ORDSEP = CB7.CB7_ORDSEP AND CB8.CB8_PROD = SD2.D2_COD AND CB8.CB8_ITEM = SD2.D2_ITEMPV AND CB8.CB8_PEDIDO = SD2.D2_PEDIDO " + chr(13)
		_cQuery2 += " INNER JOIN " + RetSqlName("CB9") + " CB9 ON CB9.D_E_L_E_T_ = '' AND CB9.CB9_FILIAL = '" + xFilial("CB9") + "' AND CB9.CB9_PROD = CB8.CB8_PROD AND CB9.CB9_ORDSEP = CB7.CB7_ORDSEP AND CB9.CB9_ITESEP = CB8.CB8_ITEM AND CB9.CB9_SEQUEN = CB8.CB8_SEQUEN AND CB9.CB9_LOTECT = SD2.D2_LOTECTL AND CB9.CB9_PEDIDO = SD2.D2_PEDIDO " + chr(13)

		_cQuery2 += " WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' "  + chr(13) 
		_cQuery2 += " AND SD2.D2_COD = '" + _cProduto + "' " + chr(13) 
		_cQuery2 += " AND SD2.D2_LOTECTL = '" + _cLotectl + "' " + chr(13)
		_cQuery2 += " AND SD2.D2_LOCAL = '" + _cLocal + "'  " + chr(13)
		_cQuery2 += " AND SD2.D2_EMISSAO = '" + _cData + "'  " + chr(13)
		_cQuery2 += " AND SD2.D2_TES = '" + _cLan + "' " + chr(13)
		_cQuery2 += " AND SD2.D2_DOC = '" + _cDoc + "' AND SD2.D2_SERIE = '" + _cSerie + "' AND SD2.D2_CLIENTE = '" + _cClifor + "' AND SD2.D2_LOJA = '" + _cLoja + "' " + chr(13)
		_cQuery2 += " AND SD2.D_E_L_E_T_ <> '*' " + chr(13) 


		_cQuery2 += " UNION ALL " + chr(13)


		_cQuery2 += " SELECT ISNULL(ZZH.ZZH_FILIAL,'') AS CB9_FILIAL , ISNULL(ZZH.ZZH_CODETI,'') AS CB9_CODETI , ISNULL(ZZH.ZZH_PROD,'') AS CB9_PROD , ZZH.ZZH_LOTECT AS CB9_LOTECT, SD2.D2_LOTECTL, SD5.D5_DATA, SD5.D5_LOCAL, " + chr(13) 
		_cQuery2 += " SD5.D5_DTVALID ,SD5.D5_CLIFOR, SD5.D5_LOJA, SD5.D5_DOC, SD5.D5_SERIE, SD5.D5_ORIGLAN, SD5.D5_NUMSEQ, ISNULL(ZZH.ZZH_QTESEP,0) AS CB9_QTESEP , ISNULL(ZZH.ZZH_ORDSEP,'') AS CB9_ORDSEP " + chr(13)

		_cQuery2 += " FROM " + RetSqlName("SD2") + " SD2 " + chr(13) 
		_cQuery2 += " INNER JOIN " + RetSqlName("SD5") + " SD5 " + chr(13) 
		_cQuery2 += " ON SD5.D5_FILIAL = SD2.D2_FILIAL " + chr(13)
		_cQuery2 += " AND SD5.D5_PRODUTO = SD2.D2_COD " + chr(13) 
		_cQuery2 += " AND SD5.D5_LOTECTL = SD2.D2_LOTECTL " + chr(13)
		_cQuery2 += " AND SD5.D5_DATA = '" + _cData + "' " + chr(13)
		_cQuery2 += " AND SD5.D5_ESTORNO <> 'S' " + chr(13)
		_cQuery2 += " AND SD5.D5_ORIGLAN = '" + _cLan + "' " + chr(13)
		_cQuery2 += " AND CHARINDEX(D5_DOC,'X') = 0 " + chr(13)
		_cQuery2 += " AND SD5.D_E_L_E_T_ <> '*' " + chr(13) 

		_cQuery2 += " INNER JOIN " + RetSqlName("CB7") + " CB7 ON CB7.D_E_L_E_T_ = '' AND CB7.CB7_FILIAL = '" + xFilial("CB7") + "' AND CB7.CB7_PEDIDO = SD2.D2_PEDIDO AND CB7.CB7_NOTA = SD5.D5_DOC AND CB7.CB7_SERIE = SD5.D5_SERIE " + chr(13)
		_cQuery2 += " AND CB7.CB7_ORDSEP = SD2.D2_ORDSEP " + chr(13)

		_cQuery2 += " INNER JOIN " + RetSqlName("CB8") + " CB8 ON CB8.D_E_L_E_T_ = '' AND CB8.CB8_FILIAL = '" + xFilial("CB8") + "' AND CB8.CB8_ORDSEP = CB7.CB7_ORDSEP AND CB8.CB8_PROD = SD2.D2_COD AND CB8.CB8_ITEM = SD2.D2_ITEMPV AND CB8.CB8_PEDIDO = SD2.D2_PEDIDO " + chr(13)
		_cQuery2 += " INNER JOIN " + RetSqlName("ZZH") + " ZZH ON ZZH.D_E_L_E_T_ = '' AND ZZH.ZZH_FILIAL = '" + xFilial("ZZH") + "' AND ZZH.ZZH_PROD = CB8.CB8_PROD AND ZZH.ZZH_ORDSEP = CB7.CB7_ORDSEP AND ZZH.ZZH_ITSEP = CB8.CB8_ITEM AND ZZH.ZZH_SEQUEN = CB8.CB8_SEQUEN AND ZZH.ZZH_LOTECT = SD2.D2_LOTECTL AND ZZH.ZZH_PEDIDO = CB8.CB8_PEDIDO " + chr(13)

		_cQuery2 += " WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' "  + chr(13) 
		_cQuery2 += " AND SD2.D2_COD = '" + _cProduto + "' " + chr(13) 
		_cQuery2 += " AND SD2.D2_LOTECTL = '" + _cLotectl + "' " + chr(13)
		_cQuery2 += " AND SD2.D2_LOCAL = '" + _cLocal + "'  " + chr(13)
		_cQuery2 += " AND SD2.D2_EMISSAO = '" + _cData + "'  " + chr(13)
		_cQuery2 += " AND SD2.D2_TES = '" + _cLan + "' " + chr(13)
		_cQuery2 += " AND SD2.D2_DOC = '" + _cDoc + "' AND SD2.D2_SERIE = '" + _cSerie + "' AND SD2.D2_CLIENTE = '" + _cClifor + "' AND SD2.D2_LOJA = '" + _cLoja + "' " + chr(13)
		_cQuery2 += " AND SD2.D_E_L_E_T_ <> '*' " + chr(13) 

		_cQuery2 += " ) AS TABELA "

		_cQuery2 += " GROUP BY CB9_FILIAL , CB9_CODETI,CB9_PROD ,CB9_LOTECT, D2_LOTECTL, D5_DATA, D5_LOCAL, " + chr(13) 
		_cQuery2 += " D5_DTVALID ,D5_CLIFOR, D5_LOJA, D5_DOC, D5_SERIE, D5_ORIGLAN,D5_NUMSEQ ,CB9_QTESEP , CB9_ORDSEP " 



		_cQuery2 := ChangeQuery(_cQuery2)

		If (Select("TMPE") <> 0)
			TMPE->(dbCloseArea())
		Endif

		dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery2), "TMPE", .F., .T.)



		While TMPE->(!Eof())

			//If !( TMPE->CB9_CODETI $_cxEtiq)

			aadd(_aEtiqR, { TMPE->CB9_PROD,;
			TMPE->CB9_ORDSEP,; 	
			TMPE->CB9_LOTECT,;
			TMPE->CB9_CODETI,;			
			TMPE->CB9_QTESEP })

			//_cxEtiq += TMPE->CB9_CODETI + ","

			//EndIf

			dbSelectArea("TMPE")
			dbSkip()
		EndDo


		dbCloseArea("TMPE")


	Else 

		_cQuery3 := " SELECT ISNULL(SD1.D1_FILIAL,'') AS CB9_FILIAL , ISNULL(SD1.D1_XIDETIQ,'') AS CB9_CODETI , ISNULL(SD1.D1_COD,'') AS CB9_PROD , SD1.D1_LOTECTL AS CB9_LOTECT, SD1.D1_LOTECTL, SD5.D5_DATA, SD5.D5_LOCAL, " + chr(13) 
		_cQuery3 += " SD5.D5_DTVALID ,SD5.D5_CLIFOR, SD5.D5_LOJA, SD5.D5_DOC, SD5.D5_SERIE, SD5.D5_ORIGLAN, SD5.D5_NUMSEQ, ISNULL(SD1.D1_QUANT,0) AS CB9_QTESEP , ISNULL(SD2.D2_ORDSEP,'') AS CB9_ORDSEP " + chr(13) 
		_cQuery3 += " ,SD1.D1_NFORI,SD1.D1_ITEMORI,SD1.D1_FORNECE,SD1.D1_LOJA " + chr(13)

		_cQuery3 += " FROM " + RetSqlName("SD1") + " SD1 " + chr(13) 

		_cQuery3 += " INNER JOIN " + RetSqlName("SD2") + " SD2 ON SD2.D_E_L_E_T_ = '' AND SD2.D2_FILIAL = SD1.D1_FILIAL AND SD2.D2_DOC = SD1.D1_NFORI AND SD2.D2_SERIE = SD1.D1_SERIORI AND SD2.D2_COD = SD1.D1_COD AND SD2.D2_LOTECTL = SD1.D1_LOTECTL " + chr(13)
		_cQuery3 += " AND SD2.D2_ITEM = SD1.D1_ITEMORI AND SD2.D2_CLIENTE = SD1.D1_FORNECE AND SD2.D2_LOJA = SD1.D1_LOJA " + chr(13) 

		_cQuery3 += " INNER JOIN " + RetSqlName("SD5") + " SD5 " + chr(13) 
		_cQuery3 += " ON SD5.D5_FILIAL = SD1.D1_FILIAL " + chr(13)
		_cQuery3 += " AND SD5.D5_PRODUTO = SD1.D1_COD " + chr(13) 
		_cQuery3 += " AND SD5.D5_LOTECTL = SD1.D1_LOTECTL " + chr(13)
		_cQuery3 += " AND SD5.D5_DATA = '" + _cData + "' " + chr(13)
		_cQuery3 += " AND SD5.D5_ESTORNO <> 'S' " + chr(13)
		_cQuery3 += " AND SD5.D5_ORIGLAN = '" + _cLan + "' " + chr(13)
		_cQuery3 += " AND CHARINDEX(D5_DOC,'X') = 0 " + chr(13)
		_cQuery3 += " AND SD5.D_E_L_E_T_ <> '*' " + chr(13) 

		_cQuery3 += " WHERE SD1.D1_FILIAL = '" + xFilial("SD2") + "' "  + chr(13) 
		_cQuery3 += " AND SD1.D1_COD = '" + _cProduto + "' " + chr(13) 
		_cQuery3 += " AND SD1.D1_LOTECTL = '" + _cLotectl + "' " + chr(13)
		_cQuery3 += " AND SD1.D1_LOCAL = '" + _cLocal + "'  " + chr(13)
		_cQuery3 += " AND SD1.D1_EMISSAO = '" + _cData + "'  " + chr(13)
		_cQuery3 += " AND SD1.D1_TES = '" + _cLan + "' " + chr(13)
		_cQuery3 += " AND SD1.D1_DOC = '" + _cDoc + "' AND SD1.D1_SERIE = '" + _cSerie + "' AND SD1.D1_FORNECE = '" + _cClifor + "' AND SD1.D1_LOJA = '" + _cLoja + "' " + chr(13)
		_cQuery3 += " AND SD1.D1_XIDETIQ <> '' " + chr(13)
		_cQuery3 += " AND SD1.D_E_L_E_T_ <> '*' " + chr(13)


		_cQuery3 := ChangeQuery(_cQuery3)

		If (Select("TMPD") <> 0)
			TMPD->(dbCloseArea())
		Endif

		dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery3), "TMPD", .F., .T.)



		While TMPD->(!Eof())

			//If !( TMPD->CB9_CODETI $_cxEtiq)
			aadd(_aEtiqR, { TMPD->CB9_PROD,;
			TMPD->CB9_ORDSEP,; 	
			TMPD->CB9_LOTECT,;
			TMPD->CB9_CODETI,;			
			TMPD->CB9_QTESEP })

			//_cxEtiq += TMPD->CB9_CODETI + ","
			//EndIf

			dbSelectArea("TMPD")
			dbSkip()
		EndDo


		TMPD->(dbCloseArea())


	EndIf


Return(_aEtiqR)
