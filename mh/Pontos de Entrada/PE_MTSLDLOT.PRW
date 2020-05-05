/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MTSLDLOT ³ Autor ³ Fabio Briddi          ³ Data ³ Ago/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ P.E. Avalia se Utiliza ou Registro                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ ExpA1 := Estrut(ExpC1, ExpN1, ExpL1, ExpL2)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Localiz.  ³ Utilizado para manipulacao do Registro de movimentação     ³±±
±±³          ³ interna de transferência (RE4) gerado pela rotina MATA261  ³±±
±±³          ³                                                            ³±±
±±³          ³ Chamado apos a gravacao dos movimentos do registro de      ³±±
±±³          ³ de Saida RE4.                                              ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ParamIxb[01] - Caracter - Codigo do Produto                ³±±
±±³          ³ ParamIxb[02] - Caracter - Local (Almoxarifado)             ³±±
±±³          ³ ParamIxb[03] - Caracter - Lote                             ³±±
±±³          ³ ParamIxb[04] - Caracter - Lote Fornecedor                  ³±±
±±³          ³ ParamIxb[05] - Caracter - Localizacao                      ³±±
±±³          ³ ParamIxb[06] - Caracter - Numero de Serie                  ³±±
±±³          ³ ParamIxb[07] - Numerico - Quantidade Empenho               ³±±
±±³          ³ ParamIxb[08] - Logico   - Consulta                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno:  ³ lRet - .T. = Utiliza Registro / .F. - Nao Utiliza Registro ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observa‡„o³ Utilizado para Descartar uso indevido de Lotes que nao     ³±±
±±³          ³ tenham sido gerados pela rotina de Lote Unico              ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Jomhedica / Faturamento                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function _MTSLDLOT()

	Local cProduto := AllTrim(ParamIxb[01])
	Local cLocal   := AllTrim(ParamIxb[02])
	Local cLoteCtl := AllTrim(ParamIxb[03])
	Local cNumLote := AllTrim(ParamIxb[04])
	Local lRet     := .T.
	Local aAreaSB8 := SB8->(GetArea())
	
	
	//-- Somente Libera o Lote para Liberacao se for gerado pela rotina Lote Unico
	
	If	( "MATA410" $ AllTrim(FunName()) ) .Or.;
		( "MATA440" $ AllTrim(FunName()) ) .Or.;
		( "MATA45"  $ AllTrim(FunName()) )		//-- Para Executar somente nas Liberacoes e Pedidos de Vendas
	
		cChvSeek := xFilial("SB8")
		cChvSeek += PadR(cProduto , TamSX3("B8_PRODUTO")[1])
		cChvSeek += PadR(cLocal   , TamSX3("B8_LOCAL")[1])
		cChvSeek += PadR(cLoteCtl , TamSX3("B8_LOTECTL")[1])
		cChvSeek += PadR(cNumLote , TamSX3("B8_NUMLOTE")[1])
	
		SB8->( dbSetOrder(3) ) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
	
		If	SB8->( dbSeek( cChvSeek ) )
	
			If	SB8->B8_LOTEUNI <> "S"
	
				lRet := .F.
			EndIf
	
		Else
	
			lRet := .F.
		EndIf
	
	EndIf
	
	RestArea(aAreaSB8)

Return( lRet )

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/
