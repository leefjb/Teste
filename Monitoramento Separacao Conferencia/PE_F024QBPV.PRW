#Define CRLF Chr(13) + Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ F024QBPV ³ Autor ³ Jeferson Dambros      ³ Data ³ Mai/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada fonte TRSF024, na funcao F024Produt,      ³±±
±±³          ³ responsavel por buscar o proximo pedido a ser separado.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ u_F024QBPV                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cQuery                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F024QBPV()

	Local cCliLoja	:= ParamIxb[1]
	Local cQuery		:= ""
	Local aUserInfo	:= UserInfo()
	Local cUser		:= Upper( AllTrim( aUserInfo[1] ) )
	Local lColetor	:= ( cUser $ Upper( AllTrim( SuperGetMv( "ES_COLETOR", .F., "", ) ) ) )


	cQuery := " SELECT 	DISTINCT "		
	cQuery += "			C5_NUM		NUM,"
	cQuery += "			C5_CLIENTE	CLIENTE,"	
	cQuery += "			C5_LOJACLI	LOJACLI,"	
	cQuery += "			A1_NOME	NOME,"
	cQuery += "			C5_EMISSAO	EMISSAO,"		
	cQuery += "			C5_ORDSEP	ORDSEP,"
	cQuery += "			C5_CLIVALE,"
	cQuery += "			C5_LJCVALE,"

	cQuery += " 			ISNull( ( SELECT A1_NOME "
	cQuery += " 							FROM " + RetSQLName("SA1")
	cQuery += " 							WHERE 	A1_FILIAL 	= '" + xFilial("SA1") + "'"
	cQuery += " 								AND	A1_COD	 = C5_CLIVALE" 
	cQuery += " 								AND	A1_LOJA = C5_LJCVALE"
	cQuery += " 								AND	D_E_L_E_T_ <> '*' "
	cQuery += " 			), ' ' ) NOM_CLIENTREG,"
	
	cQuery += "			C5_PVVALE 	PVVALE,"
	cQuery += "			'FAT'		ORIGEM"
	
	cQuery += " FROM	" + RetSQLName("SC5") + " SC5,"
	cQuery += "  		" + RetSQLName("SA1") + " SA1"	 
	
	cQuery += " WHERE SC5.C5_FILIAL	 	= '" + xFilial("SC5") + "' "
	cQuery += "		AND SC5.C5_NOTA		= '' "
	
	If lColetor
		cQuery += "	AND SC5.C5_COLETOR 	= '" + cUser + "' "
	EndIf 
	
  	cQuery += "   	AND SC5.C5_PVSTAT 	IN ('050','055')" 

  	If !Empty(cCliLoja)
		cQuery += " 	AND SC5.C5_CLIVALE + SC5.C5_LJCVALE = '" + cCliLoja + "'"
	EndIf
	
	cQuery += " 		AND	SA1.A1_FILIAL 	= '" + xFilial("SA1") + "'"		 
	cQuery += " 		AND	SA1.A1_COD    	= SC5.C5_CLIENTE"			
	cQuery += " 		AND	SA1.A1_LOJA   	= SC5.C5_LOJACLI"	

	cQuery += "		AND SC5.D_E_L_E_T_  <> '*' "
	cQuery += "		AND SA1.D_E_L_E_T_  <> '*' "
	
	cQuery += " ORDER BY C5_ORDSEP, C5_NUM "

Return( cQuery )
                         

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ UserInfo ³ Autor ³ Jeferson Dambros      ³ Data ³ Jun/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Informacoes do usuario.                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function UserInfo()

	Local aUserInfo := {}
	aAuxInfo  := GetUserInfo()
	
	If ( nPos := aScan( aAuxInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
		aUserInfo := aAuxInfo[nPos]
	EndIf

Return( aUserInfo )