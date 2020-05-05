#INCLUDE "PROTHEUS.CH"
#INCLUDE "SIGAWIN.CH"     

/*
Jean Rehermann | Solutio IT
Programa de impressão de etiquetas
Alterado para o novo formato de etiqueta bi-cortada
Inseri Order By nas queries pois ocorria sair lotes fora de sequencia
*/

//Colunas do array aEtq1 e aEtq2, 
//utilizado, funcao ImpEtqNF
#DEFINE LOTECTL		1
#DEFINE VENCTOLOTE	2
#DEFINE LOTEFOR		3
#DEFINE LTCTORI		4
#DEFINE CODPROD		5
#DEFINE DTESTER		6
#DEFINE LOTEFOR2D	7
#DEFINE LOTECTL2D	8
#DEFINE VENLOTE2D	9
#DEFINE CODPROD2D	10
#DEFINE CODBARR		11
#DEFINE DESCPROD	12
#DEFINE ESTER		13
#DEFINE VLESTER		14
#DEFINE CALIBRE		15
#DEFINE COMPRIMENTO	16
#DEFINE REGANVISA	17
#DEFINE QE			18
#DEFINE NOMEFABR	19
#DEFINE CNPJFABR	20

//Tamanho do array aEtq1 e aEtq2 (funcao ImpEtqNF)
#DEFINE TAM_ETIQ	20

//------------------------------------------------------------------------------------------------
// Impressao de etiqueta com codigo de barras 2D
User Function JMHR025V2()

	Local cPerg       := 'JMHR025'
	
	Private nOpcBrow  := 0
	
	Private cCadastro := 'Impressão de Etiquetas de Lote'
	Private aRotina   := {{ 'Pesquisar'				, 'AxPesqui'		, 0, 1 },;
					      { 'Visualizar'			, 'AxVisual'		, 0, 2 },;
					      { 'Etiqueta'				, 'U_JMHR024'		, 0, 3 },;
					      { 'Etiq. 2D p/Item'		, 'U_JR025V2S(1)'	, 0, 3 },;
					      { 'Etiq. 2D p/Lote'		, 'U_JR025V2S(2)'	, 0, 3 } }
	
	
	// perguntas
	PutSx1( cPerg,"01","Origem?   ", "","","mv_ch1","N",1,0,0,"C","","","","","mv_par01","Nota Entrada","Nota Entrada","Nota Entrada","","Lotes","Lotes","Lotes","","","","","","","","","","","","")
	
	If Pergunte(cPerg, .T.)
	
		nOpcBrow := MV_PAR01

		If nOpcBrow = 1
			dbSelectArea('SD1')
			mBrowse( 6, 1, 22, 75, "SD1" )
		Else                                                
			dbSelectArea('SB8')
			mBrowse( 6, 1, 22, 75, "SB8" )
		EndIf
	
	Endif

Return

/*
-------------------------------------------------------------------------------------------------------------------------------------
*/
User Function JR025V2S(nOpc)

	Local oDlg
	Local nQuant	:= 0
	Local nX		:= 0
	Local nY		:= 0
	Local cQuery	:= ""
	Local cProduto	:= ""
	Local cPerg		:= "JMHR025L"
	Local aProd		:= {}
	Local lOk		:= .F.
	Local cLoteI    := "0000000000"
	Local cLoteF    := "0000000000"
	Local aLotes    := {}
	Local nLotes    := 0
	Local cLotes    := ""
	Local nTamLt    := 10
	Local _nJ       := 0
	
	If nOpcBrow = 1// Documento de entrada
	    
		If nOpc = 1//Impressao por item
	
			cQuery := " SELECT 	B8_PRODUTO,"
			cQuery += " 		B8_DTVALID,"
			cQuery += " 		B8_LOTEFOR,"
			cQuery += " 		B8_LOTECTL,"
			cQuery += " 		B8_LTCTORI,"
			cQuery += " 		B8_SALDO"
			cQuery += " FROM 	" + RetSQLName("SB8")
			cQuery += " WHERE	B8_FILIAL	= '" + xFilial("SB8")			+ "'"
			cQuery += " 	AND	B8_LTCTORI	= '" + SD1->D1_LOTEFOR			+ "'"
			cQuery += " 	AND	B8_DTVORI	= '" + DToS(SD1->D1_DTVALID)	+ "'"
			cQuery += " 	AND	B8_DOCORI	= '" + SD1->D1_DOC				+ "'"
			cQuery += " 	AND	B8_SERORI	= '" + SD1->D1_SERIE			+ "'"
			cQuery += " 	AND	B8_FORORI	= '" + SD1->D1_FORNECE			+ "'"
			cQuery += " 	AND	B8_LOJORI	= '" + SD1->D1_LOJA				+ "'"
			cQuery += " 	AND	B8_SALDO	> 0"
			cQuery += " 	AND	B8_LANORI	= 'NF'"
			cQuery += " 	AND	D_E_L_E_T_ <> '*'"
			cQuery += " ORDER BY B8_LOTECTL ASC "
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRAB1", .F., .T.)
			
			TcSetField("TRAB1", "B8_DTVALID", "D")
		
			TRAB1->( dbGoTop() )
		
			While TRAB1->(!Eof())
	
				aAdd(aProd, {	TRAB1->B8_PRODUTO,;
								TRAB1->B8_DTVALID,;
								TRAB1->B8_LOTEFOR,;
								TRAB1->B8_LOTECTL,;
								TRAB1->B8_SALDO,;
								SD1->D1_DTESTER,;
								TRAB1->B8_LTCTORI;
								})
				
				TRAB1->( dbSkip() )
				
			EndDo
			
			TRAB1->( dbCloseArea() )
			
		ElseIf nOpc = 2//Impressao por Lote
		    
		    If !SX1->( dbSeek(cPerg) )
				R025PergLote(cPerg)
			EndIf
		
			If ( lOk := Pergunte(cPerg, .T.) )
				
				cQuery := " SELECT 	B8_PRODUTO,"
				cQuery += " 		B8_DTVALID,"
				cQuery += " 		B8_LOTEFOR,"
				cQuery += " 		B8_LOTECTL,"
				cQuery += " 		B8_LTCTORI,"
				cQuery += " 		B8_SALDO"
				cQuery += " FROM 	" + RetSQLName("SB8")
				cQuery += " WHERE	B8_FILIAL	= '" + xFilial("SB8")	+ "'"
				cQuery += " 	AND	B8_LOTECTL	>= '" + MV_PAR01		+ "'"
				cQuery += " 	AND	B8_LOTECTL	<= '" + MV_PAR02		+ "'"
				cQuery += " 	AND	B8_SALDO	> 0"
				cQuery += " 	AND	D_E_L_E_T_ <> '*'"
				cQuery += " ORDER BY B8_LOTECTL ASC "
				
				cQuery := ChangeQuery(cQuery)
				
				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRAB1", .F., .T.)
				
				TcSetField("TRAB1", "B8_DTVALID", "D")
			
				TRAB1->( dbGoTop() )
			
				While TRAB1->(!Eof())
		
					aAdd(aProd, {	TRAB1->B8_PRODUTO,;
									TRAB1->B8_DTVALID,;
									TRAB1->B8_LOTEFOR,;
									TRAB1->B8_LOTECTL,;
									TRAB1->B8_SALDO,;
									CToD("//"),;
									TRAB1->B8_LTCTORI;
									})
					
					TRAB1->( dbSkip() )
					
				EndDo
				
				TRAB1->( dbCloseArea() )
		    
		    EndIf
		EndIf
		
	Else// Saldo por lote
	
		If nOpc = 1//Impressao por item
		
			nQuant   := SB8->B8_SALDO
			cProduto := SB8->B8_PRODUTO
		
			Define Dialog odLG From 100,004 To 198,230 Title "Etiquetas"  Pixel
			
				@ 001,003 Say 'Quantidade:' Pixel
				@ 002,035 Get nQuant  Picture "999"  Pixel
				
				Define SButton From 35, 050 Type 1 Enable Of oDlg Pixel Action ( lOk := .T., oDlg:End() )
				
			Activate Dialog oDlg Centered		
			
			If lOk
			
				For nX := 1 To nQuant
	
					aAdd(aProd, {	SB8->B8_PRODUTO,;
									SB8->B8_DTVALID,;
									SB8->B8_LOTEFOR,;
									SB8->B8_LOTECTL,;
									SB8->B8_SALDO,;
									Ctod(""),;
									SB8->B8_LTCTORI;
									})
				Next nX
	
			EndIf
			
		ElseIf nOpc = 2//Impressao por Lote
		    
		    //If !SX1->( dbSeek(cPerg) )
				R025PergLote(cPerg)
			//EndIf
		
			If ( lOk := Pergunte(cPerg, .T.) )

				nTamLt := TamSX3("B8_LOTECTL")[1]
				cLoteI := Right( "0000000000"+ AllTrim( MV_PAR01 ), nTamLt )
				cLoteF := Right( "0000000000"+ AllTrim( MV_PAR02 ), nTamLt )
				
				cQuery := " SELECT 	B8_PRODUTO,"
				cQuery += " 		B8_DTVALID,"
				cQuery += " 		B8_LOTEFOR,"
				cQuery += " 		B8_LOTECTL,"
				cQuery += " 		B8_LTCTORI,"
				cQuery += " 		B8_SALDO"
				cQuery += " FROM 	" + RetSQLName("SB8")
				cQuery += " WHERE	B8_FILIAL	= '" + xFilial("SB8")	+ "'"
				If Empty( MV_PAR03 ) // Jean Rehermann | SOLUTIO IT - 24/08/2016 - Definida pergunta para lotes não sequenciais
					cQuery += " 	AND	B8_LOTECTL	>= '" + cLoteI		+ "'"
					cQuery += " 	AND	B8_LOTECTL	<= '" + cLoteF		+ "'"
				Else
					aLotes := StrTokArr( mv_par03, ",./|;-" ) // Crio array com token separador
					If ValType(aLotes) == "A"
						nLotes := Len( aLotes )
						If nLotes > 0
							cLotes := ""
							For _nJ := 1 To nLotes
								// crio string formatada pelo campo B8_LOTECTL (10 caracteres com zeros à esquerda)
								cLotes += Right( "0000000000"+ AllTrim( aLotes[ _nJ ] ), nTamLt ) + Iif( nLotes > _nJ, ",", "" )
							Next
						EndIf
					EndIf
					cQuery += "     AND	B8_LOTECTL IN "+ U_InSqlSep( cLotes, "", "," ) // Formata a instrução IN do sql ('item 1','item 2',...)
				EndIf
				cQuery += " 	AND	B8_SALDO	> 0"
				cQuery += " 	AND	D_E_L_E_T_ <> '*'"
				cQuery += " ORDER BY B8_LOTECTL ASC "
				
				cQuery := ChangeQuery(cQuery)
				MemoWrite("SQL_ETIQUETAS.TXT",cQuery)
				
				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRAB1", .F., .T.)
				
				TcSetField("TRAB1", "B8_DTVALID", "D")
			
				TRAB1->( dbGoTop() )
			
				While TRAB1->(!Eof())
		
					aAdd(aProd, {	TRAB1->B8_PRODUTO,;
									TRAB1->B8_DTVALID,;
									TRAB1->B8_LOTEFOR,;
									TRAB1->B8_LOTECTL,;
									TRAB1->B8_SALDO,;
									CToD("//"),;
									TRAB1->B8_LTCTORI;
									})
					
					TRAB1->( dbSkip() )
					
				EndDo
				
				TRAB1->( dbCloseArea() )
		    
		    EndIf
		EndIf
	EndIf
	
	If Len(aProd) > 0

		MsAguarde({|| ImpEtqNF( aProd )},"Aguarde!","Imprimindo etiqueta...",.F.)

	Else
        If lOk
			Aviso(cCadastro,"Produto nao controla lote, ou lote sem saldo!",{"Ok"},3)
		EndIf
	EndIf

Return
/*
-------------------------------------------------------------------------------------------------------------------------------------
*/
Static Function ImpEtqNF( aProd )

	Local nX
	Local aEtq1 := Array(TAM_ETIQ)
	Local aEtq2 := Array(TAM_ETIQ)
	

	SB1->( dbSetOrder(1) )
	SA2->( dbSetOrder(1) )

	nX := 0

	While ( nX < Len(aProd) )
	
		nX++
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ E T I Q U E T A  1          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		aEtq1[LOTECTL]	:= AllTrim( aProd[nX,4] )
		aEtq1[LOTEFOR]	:= SubStr( aProd[nX,3], 1, 16 )
		aEtq1[LTCTORI]	:= AllTrim( aProd[nX,7] )
		aEtq1[CODPROD]	:= AllTrim( aProd[nX,1] )
		aEtq1[DTESTER]	:= DtoC( aProd[nX,6] )
		aEtq1[LOTEFOR2D]	:= aProd[nX,3]
		aEtq1[LOTECTL2D]	:= aProd[nX,4]
		aEtq1[VENLOTE2D]	:= DtoS( aProd[nX,2] )  // formato AAAAMMDD
		
		SB1->( dbSeek( xFilial("SB1") + aProd[nX,1]))
		      
      	If SB1->B1_VALIMP == "2"   // 2 = NAO IMPRIMIR DATA			
			aEtq1[VENCTOLOTE]	:= "INDETERMINADO"
		Else
			aEtq1[VENCTOLOTE]	:= SubStr( DtoC( aProd[nX,2] ), 4 )
		EndIf
	    
		aEtq1[CODPROD2D]	:= SB1->B1_COD
		aEtq1[CODBARR]	:= AllTrim( SB1->B1_CODBAR )
		aEtq1[DESCPROD]	:= AllTrim( Left( SB1->B1_DESC, 100 ) )
		aEtq1[ESTER]		:= AllTrim( SB1->B1_ESTERIL )
		aEtq1[VLESTER]	:= AllTrim( SB1->B1_VLESTER )
		aEtq1[CALIBRE]	:= AllTrim( SB1->B1_CALIBRE )
		aEtq1[COMPRIMENTO]:= AllTrim( SB1->B1_COMPRIM )
		aEtq1[REGANVISA]	:= AllTrim( SB1->B1_RMS )
		aEtq1[QE]			:= SB1->B1_QE
		
		SA2->( dbSeek(xFilial("SA2") + SB1->B1_CODFAB ) )
		
		aEtq1[NOMEFABR]	:=	AllTrim( Substr(SA2->A2_NOME,1,50) )
		aEtq1[CNPJFABR]	:=	" - "+ Transform(SA2->A2_CGC, "@R 99.999.999/9999-99")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ E T I Q U E T A  2          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nX < Len(aProd) 
			
			nX++
			aEtq2[CODPROD]	:= AllTrim( aProd[nX,1] )
						
			/*                
			CRISTIANO OLIVEIRA - SOLUTIO IT #15112
			Campo de Impressão da Data de Validade
			*/ 
					
			//DbSelectArea("SB1")
			//DbSetOrder(1) 
			//If SB1->(DbSeek(xFilial("SB1")+aProd[nX,1]))
				   
				If SB1->B1_VALIMP == "2"   // 2 = NAO IMPRIMIR DATA			
					aEtq2[VENCTOLOTE]	:= "INDETERMINADO"
				Else
					aEtq2[VENCTOLOTE]	:= SubStr( DtoC( aProd[nX,2] ), 4 )
				EndIf
			
			//EndIf                                                           
				
			aEtq2[LOTEFOR]	:= SubStr( aProd[nX,3], 1, 16 )
			aEtq2[LOTECTL]	:= AllTrim( aProd[nX,4] )
			aEtq2[LTCTORI]	:= AllTrim( aProd[nX,7] )
			aEtq2[DTESTER]	:= DtoC( aProd[nX,6] )
			aEtq2[LOTEFOR2D]	:= aProd[nX,3]
			aEtq2[LOTECTL2D]	:= aProd[nX,4]
			aEtq2[VENLOTE2D]	:= DtoS( aProd[nX,2] )  // formato AAAAMMDD
			
			SB1->( dbSeek( xFilial("SB1") + aProd[nX,1]))
			
			aEtq2[CODPROD2D]	:= SB1->B1_COD
			aEtq2[CODBARR]	:= AllTrim( SB1->B1_CODBAR )
			aEtq2[DESCPROD]	:= AllTrim( Left( SB1->B1_DESC, 100 ) )
			aEtq2[ESTER]		:= AllTrim( SB1->B1_ESTERIL )
			aEtq2[VLESTER]	:= AllTrim( SB1->B1_VLESTER )
			aEtq2[CALIBRE]	:= AllTrim( SB1->B1_CALIBRE )
			aEtq2[COMPRIMENTO]:= AllTrim( SB1->B1_COMPRIM )
			aEtq2[REGANVISA]	:= AllTrim( SB1->B1_RMS )
			aEtq2[QE]			:= SB1->B1_QE
			
			SA2->( dbSeek(xFilial("SA2") + SB1->B1_CODFAB ) )
			
			aEtq2[NOMEFABR]	:=	AllTrim( Substr(SA2->A2_NOME,1,50) )
			aEtq2[CNPJFABR]	:=	" - "+ Transform(SA2->A2_CGC, "99.999.999/9999-99")
		
		Else
		
			aEtq2 := aEtq1
			
		EndIf

		nCol1 := 002
		nCol2 := 054
        ALERT("STOP DEBUG")
		MSCBPrinter( 'ZEBRA', "LPT1",,, .f.,,,, )		// seta tipo de impressora no padrao ZPL
		MSCBCHKStatus(.f.)
		MSCBBegin( 1, 1 )		// inicializa montagem da imagem
	
		nLin  := 11
		cLinha := aEtq1[CODPROD]
		MsCbSay( nCol1+5    , nLin , cLinha				, "N" , "0" , "025,020" )
	                    
		cLinha := aEtq2[CODPROD]
		MsCbSay( nCol2+5    , nLin , cLinha				, "N" , "0" , "025,020" )

		nLin  += 2.5

		cLinha := 'Série: '+aEtq1[LOTECTL2D]
		MsCbSay( nCol1+5    , nLin , cLinha				, "N" , "0" , "025,020" )
	                    
		cLinha := 'Série: '+aEtq2[LOTECTL2D]
		MsCbSay( nCol2+5    , nLin , cLinha				, "N" , "0" , "025,020" )
	
		nLin  += 4.5

		If	!Empty( aEtq1[LOTEFOR] )
			MsCbSay( nCol1+5 , nLin , PadR("L. For: " + aEtq1[LOTEFOR] ,50), "N" , "0" , "020,016" , , , , , .F. )
			MsCbSay( nCol2+5 , nLin , PadR("L. For: " + aEtq2[LOTEFOR] ,50), "N" , "0" , "020,016" , , , , , .F. )
		Else
			MsCbSay( nCol1+5 , nLin , PadR("L. Orig.: " + aEtq1[LTCTORI] ,50), "N" , "0" , "020,016" , , , , , .F. )
			MsCbSay( nCol2+5 , nLin , PadR("L. Orig.: " + aEtq2[LTCTORI] ,50), "N" , "0" , "020,016" , , , , , .F. )
		EndIf

		nLin  += 7.5
	
		cLinha := aEtq1[CODPROD] + " " + aEtq1[DESCPROD]
		cLinha := SubStr(cLinha,01,45)
		MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "020,016" )
		
		cLinha := aEtq2[CODPROD] + " " + aEtq2[DESCPROD]
		cLinha := SubStr(cLinha,01,45)
		MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "020,016" )
	
		nLin  += 2.5

		cLinha := aEtq1[CODPROD] + " " + aEtq1[DESCPROD]
		cLinha := SubStr(cLinha,46,45)
		MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "020,016" )
		
		cLinha := aEtq2[CODPROD] + " " + aEtq2[DESCPROD]
		cLinha := SubStr(cLinha,46,45)
		MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "020,016" )
	
		nLin  += 2.5

		cLinha := "Fabricado Por: "+ SubStr( aEtq1[NOMEFABR], 1, 40 )
		MsCbSay( nCol1 , nLin , cLinha	, "N" , "0" , "020,016" )
		
		cLinha := "Fabricado Por: "+ SubStr( aEtq2[NOMEFABR], 1, 40 )
		MsCbSay( nCol2 , nLin , cLinha	, "N" , "0" , "020,016" )
		
		nLin  += 2.5

		cLinha := AllTrim( SubStr( aEtq1[NOMEFABR], 41 ) ) + aEtq1[CNPJFABR]
		MsCbSay( nCol1 , nLin , cLinha	, "N" , "0" , "020,016" )
		
		cLinha := AllTrim( SubStr( aEtq2[NOMEFABR], 41 ) ) + aEtq2[CNPJFABR]
		MsCbSay( nCol2 , nLin , cLinha	, "N" , "0" , "020,016" )

		nLin  += 2.5

		MsCbSay( nCol1 , nLin , "Reg.ANVISA: " + aEtq1[REGANVISA] +" Vencto.: " + aEtq1[VENCTOLOTE], "N" , "0" , "020,016" )
		MsCbSay( nCol2 , nLin , "Reg.ANVISA: " + aEtq2[REGANVISA] +" Vencto.: " + aEtq2[VENCTOLOTE], "N" , "0" , "020,016" )


		nLin  += 3.1  // Primeiro Corte

		
		cLinha := aEtq1[CODPROD] + " " + aEtq1[DESCPROD]
		cLinha := SubStr(cLinha,01,45)
		MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "020,016" )
		
		cLinha := aEtq2[CODPROD] + " " + aEtq2[DESCPROD]
		cLinha := SubStr(cLinha,01,45)
		MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "020,016" )
	
		nLin  += 2.5

		cLinha := aEtq1[CODPROD] + " " + aEtq1[DESCPROD]
		cLinha := SubStr(cLinha,46,45)
		MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "020,016" )
		
		cLinha := aEtq2[CODPROD] + " " + aEtq2[DESCPROD]
		cLinha := SubStr(cLinha,46,45)
		MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "020,016" )
	
		nLin  += 2.5

		cLinha := "Fabricado Por: "+ SubStr( aEtq1[NOMEFABR], 1, 40 )
		MsCbSay( nCol1 , nLin , cLinha	, "N" , "0" , "020,016" )
		
		cLinha := "Fabricado Por: "+ SubStr( aEtq2[NOMEFABR], 1, 40 )
		MsCbSay( nCol2 , nLin , cLinha	, "N" , "0" , "020,016" )
		
		nLin  += 2.5

		cLinha := AllTrim( SubStr( aEtq1[NOMEFABR], 41 ) ) + aEtq1[CNPJFABR]
		MsCbSay( nCol1 , nLin , cLinha	, "N" , "0" , "020,016" )
		
		cLinha := AllTrim( SubStr( aEtq2[NOMEFABR], 41 ) ) + aEtq2[CNPJFABR]
		MsCbSay( nCol2 , nLin , cLinha	, "N" , "0" , "020,016" )

		nLin  += 2.5

		If	!Empty( aEtq1[LOTEFOR] )
			MsCbSay( nCol1 , nLin , PadR("L. For: " + aEtq1[LOTEFOR] + " - Série: "+aEtq1[LOTECTL2D] ,50), "N" , "0" , "020,016" , , , , , .F. )
			MsCbSay( nCol2 , nLin , PadR("L. For: " + aEtq2[LOTEFOR] + " - Série: "+aEtq2[LOTECTL2D] ,50), "N" , "0" , "020,016" , , , , , .F. )
		Else
			MsCbSay( nCol1 , nLin , PadR("L. Orig.: " + aEtq1[LTCTORI] + " - Série: "+aEtq1[LOTECTL2D] ,50), "N" , "0" , "020,016" , , , , , .F. )
			MsCbSay( nCol2 , nLin , PadR("L. Orig.: " + aEtq2[LTCTORI] + " - Série: "+aEtq2[LOTECTL2D] ,50), "N" , "0" , "020,016" , , , , , .F. )
		EndIf

		nLin  += 2.5

		MsCbSay( nCol1 , nLin , "Reg.ANVISA: " + aEtq1[REGANVISA] +" Vencto.: " + aEtq1[VENCTOLOTE], "N" , "0" , "020,016" )
		MsCbSay( nCol2 , nLin , "Reg.ANVISA: " + aEtq2[REGANVISA] +" Vencto.: " + aEtq2[VENCTOLOTE], "N" , "0" , "020,016" )


		nLin  += 3.1  // Segundo Corte

		
		cLinha := aEtq1[CODPROD] + " " + aEtq1[DESCPROD]
		cLinha := SubStr(cLinha,01,45)
		MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "020,016" )
		
		cLinha := aEtq2[CODPROD] + " " + aEtq2[DESCPROD]
		cLinha := SubStr(cLinha,01,45)
		MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "020,016" )
	
		nLin  += 2.5

		cLinha := aEtq1[CODPROD] + " " + aEtq1[DESCPROD]
		cLinha := SubStr(cLinha,46,45)
		MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "020,016" )
		
		cLinha := aEtq2[CODPROD] + " " + aEtq2[DESCPROD]
		cLinha := SubStr(cLinha,46,45)
		MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "020,016" )
	
		nLin  += 2.5

		cLinha := "Fabricado Por: "+ SubStr( aEtq1[NOMEFABR], 1, 40 )
		MsCbSay( nCol1 , nLin , cLinha	, "N" , "0" , "020,016" )
		
		cLinha := "Fabricado Por: "+ SubStr( aEtq2[NOMEFABR], 1, 40 )
		MsCbSay( nCol2 , nLin , cLinha	, "N" , "0" , "020,016" )
		
		nLin  += 2.5

		cLinha := AllTrim( SubStr( aEtq1[NOMEFABR], 41 ) ) + aEtq1[CNPJFABR]
		MsCbSay( nCol1 , nLin , cLinha	, "N" , "0" , "020,016" )
		
		cLinha := AllTrim( SubStr( aEtq2[NOMEFABR], 41 ) ) + aEtq2[CNPJFABR]
		MsCbSay( nCol2 , nLin , cLinha	, "N" , "0" , "020,016" )

		nLin  += 2.5

		If	!Empty( aEtq1[LOTEFOR] )
			MsCbSay( nCol1 , nLin , PadR("L. For: " + aEtq1[LOTEFOR] + " - Série: "+aEtq1[LOTECTL2D] ,50), "N" , "0" , "020,016" , , , , , .F. )
			MsCbSay( nCol2 , nLin , PadR("L. For: " + aEtq2[LOTEFOR] + " - Série: "+aEtq2[LOTECTL2D] ,50), "N" , "0" , "020,016" , , , , , .F. )
		Else
			MsCbSay( nCol1 , nLin , PadR("L. Orig.: " + aEtq1[LTCTORI] + " - Série: "+aEtq1[LOTECTL2D] ,50), "N" , "0" , "020,016" , , , , , .F. )
			MsCbSay( nCol2 , nLin , PadR("L. Orig.: " + aEtq2[LTCTORI] + " - Série: "+aEtq2[LOTECTL2D] ,50), "N" , "0" , "020,016" , , , , , .F. )
		EndIf

		nLin  += 2.5

		MsCbSay( nCol1 , nLin , "Reg.ANVISA: " + aEtq1[REGANVISA] +" Vencto.: " + aEtq1[VENCTOLOTE], "N" , "0" , "020,016" )
		MsCbSay( nCol2 , nLin , "Reg.ANVISA: " + aEtq2[REGANVISA] +" Vencto.: " + aEtq2[VENCTOLOTE], "N" , "0" , "020,016" )
		
		// ^FOx,y    - coordenadas do codigo de barras
		// ^BQa,b,c  - seta codigo de barras: a=N (Normal) b=modelo Defaul=2 c=fator de magnitude 1 a 10
		// ^FD       - modo
		// ^FS       - finaliza o comando ^FO
		MSCBWrite("^FO260,064^BQN,2,4^FDQA,"+aEtq1[CODPROD2D]+aEtq1[LOTECTL2D]+aEtq1[VENLOTE2D]+aEtq1[LOTEFOR2D]+"^FS")
		MSCBWrite("^FO680,064^BQN,2,4^FDQA,"+aEtq2[CODPROD2D]+aEtq2[LOTECTL2D]+aEtq2[VENLOTE2D]+aEtq2[LOTEFOR2D]+"^FS")
//		MSCBWrite("^FO250,270^BQN,2,4^FDQA,"+cCodProd2D+cLoteCtl2D+cVenLote2D+cLoteFor2D+"^FS")
//		MSCBWrite("^FO670,270^BQN,2,4^FDQA,"+cCodProd2D+cLoteCtl2D+cVenLote2D+cLoteFor2D+"^FS")
	
		MsCbEnd()				// fim da imagem da etiqueta
		MsCbClosePrinter()
	    
	EndDo
	
Return                    
/*
-------------------------------------------------------------------------------------------------------------------------------------
*/
Static Function R025PergLote(cPerg)

Local aP	 := {}
Local aHelp	 := {}
Local nI	 := 0
Local cSeq	 := ""
Local cMvCh	 := ""
Local cMvPar := ""

//			Texto Pergunta	 Tipo 	Tam 	  						Dec   	G=get ou C=Choice  	Val  F3		Def01 	  Def02 	 Def03   Def04   Def05
aAdd(aP,{	"Lote De ?",	"C",	TamSX3("B8_LOTECTL")[1],		0,		"G",				"",	 "",		   "",		"",		"",		"",		""})
aAdd(aP,{	"Lote Ate?",	"C",	TamSX3("B8_LOTECTL")[1],		0,		"G",				"",	 "",		   "",		"",		"",		"",		""})
aAdd(aP,{	"Lotes?   ",	"C",	                     99,		0,		"G",				"",	 "",		   "",		"",		"",		"",		""})

//           0123456789123456789012345678901234567890
//                    1         2         3         4
aAdd(aHelp, {"Lote único inicial"})
aAdd(aHelp, {"Lote único final"})
aAdd(aHelp, {"Lotes não sequenciais"} )

For nI := 1 To Len(aP)
	
	cSeq	:= StrZero(nI,2,0)
	cMvPar	:= "mv_par"+cSeq
	cMvCh	:= "mv_ch"+IIF(nI<=9,Chr(nI+48),Chr(nI+87))
	
	PutSx1(cPerg,;
	cSeq,;
	aP[nI,1],aP[nI,1],aP[nI,1],;
	cMvCh,;
	aP[nI,2],;
	aP[nI,3],;
	aP[nI,4],;
	1,;
	aP[nI,5],;
	aP[nI,6],;
	aP[nI,7],;
	"",;
	"",;
	cMvPar,;
	aP[nI,8],aP[nI,8],aP[nI,8],;
	"",;
	aP[nI,9],aP[nI,9],aP[nI,9],;
	aP[nI,10],aP[nI,10],aP[nI,10],;
	aP[nI,11],aP[nI,11],aP[nI,11],;
	aP[nI,12],aP[nI,12],aP[nI,12],;
	aHelp[nI],;
	{},;
	{},;
	"")
	
Next nI

Return()