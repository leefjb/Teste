#include "protheus.ch"
#include "sigawin.ch"     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��User Func. � JMHR025  �Autor �                     � Data �   14/06/16  ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao de etiqueta com codigo de barras 2D              ���
�������������������������������������������������������������������������͹��
���Uso       � JOMHEDICA                                                  ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
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
#DEFINE DADOSFABR	20

//Tamanho do array aEtq1 e aEtq2 (funcao ImpEtqNF)
#DEFINE TAM_ETIQ	20

//------------------------------------------------------------------------------------------------
// Impressao de etiqueta com codigo de barras 2D
User Function JMHR025()

	Local cPerg       := 'JMHR025'
	
	Private nOpcBrow  := 0
	
	Private cCadastro := 'Impress�o de Etiquetas de Lote'
	Private aRotina   := {{ 'Pesquisar'				, 'AxPesqui'		, 0, 1 },;
					      { 'Visualizar'			, 'AxVisual'		, 0, 2 },;
					      { 'Etiqueta'				, 'U_JMHR024'		, 0, 3 },;
					      { 'Etiq. 2D p/Item'		, 'U_JR025Sel(1)'	, 0, 3 },;
					      { 'Etiq. 2D p/Lote'		, 'U_JR025Sel(2)'	, 0, 3 } }
	
	
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
User Function JR025Sel(nOpc)

	Local oDlg
	Local nQuant	:= 0
	Local nX		:= 0
	Local nY		:= 0
	Local cQuery	:= ""
	Local cProduto	:= ""
	Local cPerg		:= "JMHR025L"
	Local aProd		:= {}
	Local lOk		:= .F.
	
	
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
	
		//�������������������������������
		//� E T I Q U E T A  1          �
		//�������������������������������
		
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
		
		aEtq1[NOMEFABR]	:=	Substr(SA2->A2_NOME,1,28)
		aEtq1[DADOSFABR]	:=	AllTrim(SA2->A2_MUN) + If(AllTrim(SA2->A2_EST)<>"EX"," - " + AllTrim(SA2->A2_EST), " - " + AllTrim(SA2->A2_PAISORI))
		
		//�������������������������������
		//� E T I Q U E T A  2          �
		//�������������������������������

		If nX < Len(aProd) 
			
			nX++
			aEtq2[CODPROD]	:= AllTrim( aProd[nX,1] )
						
			/*                
			CRISTIANO OLIVEIRA - SOLUTIO IT #15112
			Campo de Impress�o da Data de Validade
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
			
			aEtq2[NOMEFABR]	:=	Substr(SA2->A2_NOME,1,28)
			aEtq2[DADOSFABR]	:=	AllTrim(SA2->A2_MUN) + If(AllTrim(SA2->A2_EST)<>"EX"," - " + AllTrim(SA2->A2_EST), " - " + AllTrim(SA2->A2_PAISORI))
		
		Else
		
			aEtq2 := aEtq1
			
		EndIf

		nCol1 := 002
		nCol2 := 054
	    ALERTA("STOP DEBUG TESTE")
		MSCBPrinter( 'ZEBRA', "LPT1",,, .f.,,,, )		// seta tipo de impressora no padrao ZPL
		MSCBCHKStatus(.f.)
		MSCBBegin( 1, 1 )		// inicializa montagem da imagem
	
		nLin  := 011
		cLinha := 'S�RIE: '+aEtq1[LOTECTL2D]
		MsCbSay( nCol1+10    , nLin , cLinha				, "N" , "0" , "025,020" )
	                    
		// Cristiano Oliveira - Aqui � o LOTE, mas o cliente deseja que apare�a o LABEL como S�RIE - 08/03/2016
		cLinha := 'S�RIE: '+aEtq2[LOTECTL2D]
		MsCbSay( nCol2+10    , nLin , cLinha				, "N" , "0" , "025,020" )
	
		nLin  += 006.5
		cLinha := aEtq1[CODPROD] + " " + SubStr(aEtq1[DESCPROD],01,18)
		MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "025,020" )
		
		cLinha := aEtq2[CODPROD] + " " + SubStr(aEtq2[DESCPROD],01,18)
		MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "025,020" )
	
		nLin  += 002.5
		cLinha := SubStr(aEtq1[DESCPROD],19,32)
		MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "025,020" )
		
		cLinha := SubStr(aEtq2[DESCPROD],19,32)
		MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "025,020" )
	
//		nLin  += 003
//		cLinha := SubStr(aEtq1[DESCPROD],50,32)
//		MsCbSay( nCol1    , nLin , cLinha				, "N" , "0" , "025,020" )
		
//		cLinha := SubStr(aEtq2[DESCPROD],50,32)
//		MsCbSay( nCol2    , nLin , cLinha				, "N" , "0" , "025,020" )
	
		cTamFonte := "020,016"                       
		
		dbSelectArea("SB1")
        dbSetOrder(1)
		dbSeek(xFilial("SB1") + aEtq1[5])
		
		nLin  += 005  ////////////////////////////////// B1_QE
		//MsCbSay( nCol1 , nLin , PadR(OemToAnsi("Contem: "+Str(aETQ1[QE],2)+" Unidade(s)"),50)	, "N" , "0" , cTamFonte , , , , , .F. )
		MsCbSay( nCol1 , nLin , PadR(OemToAnsi("Contem: " + cValtoChar(SB1->B1_QE) + " Unidade(s)"),50)	, "N" , "0" , cTamFonte , , , , , .F. )
		MsCbSay( nCol2 , nLin , PadR(OemToAnsi("Contem: " + cValtoChar(SB1->B1_QE) + " Unidade(s)"),50)	, "N" , "0" , cTamFonte , , , , , .F. )
	
//		nLin  += 002.5
//		MsCbSay( nCol1 , nLin , PadR(OemToAnsi("Calibre: " + aEtq1[CALIBRE] + " Comprimento: " + aEtq1[COMPRIMENTO]),60)	, "N" , "0" , cTamFonte , , , , , .F. )
//		MsCbSay( nCol2 , nLin , PadR(OemToAnsi("Calibre: " + aEtq2[CALIBRE] + " Comprimento: " + aEtq2[COMPRIMENTO]),60)	, "N" , "0" , cTamFonte , , , , , .F. )

		nLin  += 002.5
		MsCbSay( nCol1 , nLin , PadR("S�rie: " + aEtq1[LOTECTL] + "  Vencimento: " + aEtq1[VENCTOLOTE],50)	, "N" , "0" , cTamFonte , , , , , .F. )
		MsCbSay( nCol2 , nLin , PadR("S�rie: " + aEtq2[LOTECTL] + "  Vencimento: " + aEtq2[VENCTOLOTE],50)	, "N" , "0" , cTamFonte , , , , , .F. )

		nLin  += 002.5

		If	!Empty( aEtq1[LOTEFOR] )
			MsCbSay( nCol1 , nLin , PadR("L. For: " + aEtq1[LOTEFOR] ,50), "N" , "0" , cTamFonte , , , , , .F. )
			MsCbSay( nCol2 , nLin , PadR("L. For: " + aEtq2[LOTEFOR] ,50), "N" , "0" , cTamFonte , , , , , .F. )
		Else
			MsCbSay( nCol1 , nLin , PadR("L. Orig.: " + aEtq1[LTCTORI] ,50), "N" , "0" , cTamFonte , , , , , .F. )
			MsCbSay( nCol2 , nLin , PadR("L. Orig.: " + aEtq2[LTCTORI] ,50), "N" , "0" , cTamFonte , , , , , .F. )
		EndIf
	
		If	!Empty(aEtq1[ESTER])
			nLin  += 002.5
			MsCbSay( nCol1 , nLin , PadR("Esterilizacao: " + aEtq1[ESTER],50)	, "N" , "0" , cTamFonte , , , , , .F. )
			MsCbSay( nCol2 , nLin , PadR("Esterilizacao: " + aEtq2[ESTER],50)	, "N" , "0" , cTamFonte , , , , , .F. )
		
			nLin  += 002.5
			MsCbSay( nCol1 , nLin , PadR("Data Esterilizacao: " + aEtq1[DTESTER] + " - Validade: " + aEtq1[VLESTER] ,50)	, "N" , "0" , cTamFonte , , , , , .F. )
			MsCbSay( nCol2 , nLin , PadR("Data Esterilizacao: " + aEtq2[DTESTER] + " - Validade: " + aEtq2[VLESTER] ,50)	, "N" , "0" , cTamFonte , , , , , .F. )
		EndIf
		
		nLin  += 003  ////////////////////////// 
		_cUnid:= ""
		Do Case
			Case SB1->B1_ESTER == "A"
            	_cUnid:= "Nao Esteril/Uso Unico"
			Case SB1->B1_ESTER == "B"
				_cUnid:= "Esteril/Uso Unico"
			Case SB1->B1_ESTER == "C"
				_cUnid:= "Nao Esteril"
		EndCase		
		
		MsCbSay( nCol1 , nLin , PadR(_cUnid,50)	, "N" , "0" , cTamFonte , , , , , .F. )
		MsCbSay( nCol2 , nLin , PadR(_cUnid,50)	, "N" , "0" , cTamFonte , , , , , .F. )
	                            
		_cProc:= ""
		Do Case
			Case SB1->B1_ESTER == "A"
            	_cProc:= "Proibido Reprocessar"
			Case SB1->B1_ESTER == "B"
				_cProc:= "Proibido Reprocessar"
			Case SB1->B1_ESTER == "C"
				_cProc:= "Produto Reutilizavel"			
		EndCase		
	
		nLin  += 003  ///////////////////////////////////////
		MsCbSay( nCol1 , nLin , PadR(_cProc,50)	, "N" , "0" , cTamFonte , , , , , .F. )
		MsCbSay( nCol2 , nLin , PadR(_cProc,50)	, "N" , "0" , cTamFonte , , , , , .F. )
	
		nLin  += 003
		MsCbSay( nCol1 , nLin , PadR("Armaz./Uso/Precau��es do Produto:",50)	, "N" , "0" , cTamFonte , , , , , .F. )
		MsCbSay( nCol2 , nLin , PadR("Armaz./Uso/Precau��es do Produto:",50)	, "N" , "0" , cTamFonte , , , , , .F. )
	
		nLin  += 002.5
		MsCbSay( nCol1 , nLin , PadR("VIDE INSTRUCOES DE USO",50)	, "N" , "0" , cTamFonte , , , , , .F. )
		MsCbSay( nCol2 , nLin , PadR("VIDE INSTRUCOES DE USO",50)	, "N" , "0" , cTamFonte , , , , , .F. )
	
		nLin  += 003
		MsCbSay( nCol1 , nLin , "Fabricado Por:"	, "N" , "0" , cTamFonte )
		MsCbSay( nCol2 , nLin , "Fabricado Por:"	, "N" , "0" , cTamFonte )
	
		nLin  += 002.5
		MsCbSay( nCol1 , nLin , aEtq1[NOMEFABR]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol2 , nLin , aEtq2[NOMEFABR]	, "N" , "0" , cTamFonte )
	
		nLin  += 002.5
		MsCbSay( nCol1 , nLin , aEtq1[DADOSFABR]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol2 , nLin , aEtq2[DADOSFABR]	, "N" , "0" , cTamFonte )
	
		cTamFonte := "022,018"
		nLin  += 003
		MsCbSay( nCol1 , nLin , "Reg. ANVISA N.: " + aEtq1[REGANVISA]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol2 , nLin , "Reg. ANVISA N.: " + aEtq2[REGANVISA]	, "N" , "0" , cTamFonte )
	
		cTamFonte := "020,016"
	
		nLin  := 058
		MsCbSay( nCol1 + 02 , nLin , 'S�rie: '+aEtq1[LOTECTL]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol1 + 27 , nLin , 'S�rie: '+aEtq1[LOTECTL]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol2 + 02 , nLin , 'S�rie: '+aEtq2[LOTECTL]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol2 + 27 , nLin , 'S�rie: '+aEtq2[LOTECTL]	, "N" , "0" , cTamFonte )
	
		nLin  += 003.5
		MsCbSay( nCol1 + 02 , nLin , 'Prod: '+aEtq1[CODPROD2D]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol1 + 27 , nLin , 'Prod: '+aEtq1[CODPROD2D]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol2 + 02 , nLin , 'Prod: '+aEtq2[CODPROD2D]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol2 + 27 , nLin , 'Prod: '+aEtq2[CODPROD2D]	, "N" , "0" , cTamFonte )
	
		nLin  += 003.5
		MsCbSay( nCol1 + 02 , nLin , "Val.: " + aEtq1[VENCTOLOTE]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol1 + 27 , nLin , "Val.: " + aEtq1[VENCTOLOTE]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol2 + 02 , nLin , "Val.: " + aEtq2[VENCTOLOTE]	, "N" , "0" , cTamFonte )
		MsCbSay( nCol2 + 27 , nLin , "Val.: " + aEtq2[VENCTOLOTE]	, "N" , "0" , cTamFonte )
	
		// 
		// ^FOx,y    - coordenadas do codigo de barras
		// ^BQa,b,c  - seta codigo de barras: a=N (Normal) b=modelo Defaul=2 c=fator de magnitude 1 a 10
		// ^FD       - modo
		// ^FS       - finaliza o comando ^FO
		MSCBWrite("^FO260,290^BQN,2,4^FDQA,"+aEtq1[CODPROD2D]+aEtq1[LOTECTL2D]+aEtq1[VENLOTE2D]+aEtq1[LOTEFOR2D]+"^FS")
		MSCBWrite("^FO680,290^BQN,2,4^FDQA,"+aEtq2[CODPROD2D]+aEtq2[LOTECTL2D]+aEtq2[VENLOTE2D]+aEtq2[LOTEFOR2D]+"^FS")
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

//           0123456789123456789012345678901234567890
//                    1         2         3         4
aAdd(aHelp, {"Lote �nico inicial"})
aAdd(aHelp, {"Lote �nico final"})

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