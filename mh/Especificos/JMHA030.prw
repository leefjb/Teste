#Include 'Protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ JMHA030  ³ Autor ³ Jeferson Dambros      ³ Data ³ Abr/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gerar lote unico.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ u_JMHA030                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                        ³±±
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
User Function JMHA030()

	Processa( {|lEnd| A030MontAc(@lEnd) }, "Aguarde!", "Gerando os dados...", .T. )
	
Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A030MontAc³ Autor ³ Jeferson Dambros      ³ Data ³ Abr/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao principal, responsavel por montar o acols.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function A030MontAc(lEnd)
	
	Local cMsg	:= ""
	Local cQuery	:= ""
	Local cArea	:= ""
	Local cCampo	:= ""
	Local cPerg	:= PadR("JMHA030",Len(SX1->X1_GRUPO))
	Local cMvPar	:= "ES_SEQLTUN"
	Local lSeek	:= .F.
	Local nZ		:= 0
	Local nX		:= 0
	Local nLin	:= 0
	Local nQtdReg	:= 0
	
	Default lEnd	:= .F.

	A030CriaSx(cPerg)

	dbSelectArea("SX6")
	dbSetOrder(1)

	lSeek := dbSeek( cFilAnt + cMvPar )

	If !lSeek
		lSeek := dbSeek( Space(Len(cFilAnt)) + cMvPar )
	EndIf

	If !lSeek .Or. Empty( SX6->X6_CONTEUD )

		cMsg := "Impossivel utilizar essa rotina! Verifique o parametro." 
		cMSg += CRLF
		cMsg += "Parametro: " + cMvPar 
		cMsg += CRLF 
		cMsg += IIf(!lSeek .And. Empty( SX6->X6_CONTEUD ), "Em branco e nao cadastrado.", IIf(!lSeek, "Em branco.","Nao cadastrado."))

		Aviso("Atenção",cMsg,{"Ok"},3)

	Else

		If Pergunte(cPerg,.T.)

			aCols 	:= {}
			n 		:= 0

			cQuery := " SELECT 	B8_PRODUTO," 
			cQuery += " 			B8_ORIGLAN," 
			cQuery += " 			B8_SALDO," 
			cQuery += " 			B8_LOTECTL,"
			cQuery += " 			B8_DTVALID," 
			cQuery += " 			B8_LOCAL," 
			cQuery += " 			B8_DOC," 
			cQuery += " 			B8_SERIE," 
			cQuery += " 			B8_CLIFOR," 
			cQuery += " 			B8_LOJA," 
			cQuery += " 			B1_DESC," 
			cQuery += " 			B1_UM"
			cQuery += " 	FROM 	" + RetSQLName("SB8") +" SB8,"
			cQuery += " 			" + RetSQLName("SB1") +" SB1"
			cQuery += " 	WHERE 	SB8.B8_FILIAL	= '" + xFilial("SB8") + "'"
			cQuery += "		AND	SB8.B8_DOC		= '"+ MV_PAR01 +"'"
			cQuery += " 	AND	SB8.B8_SERIE	= '"+ MV_PAR02 +"'"
			cQuery += " 	AND	SB8.B8_CLIFOR	= '"+ MV_PAR03 +"'"
			cQuery += " 	AND	SB8.B8_LOJA		= '"+ MV_PAR04 +"'"
			If	!Empty(MV_PAR05)
				cQuery += " 	AND	SB8.B8_PRODUTO	= '"+ MV_PAR05 +"'"
			EndIf
			If	!Empty(MV_PAR06)
				cQuery += " 	AND	SB8.B8_LOTECTL	= '"+ MV_PAR06 +"'"
			EndIf
			cQuery += "   	AND	SB8.B8_SALDO	> 0"
			cQuery += "   	AND	SB8.B8_LOTEUNI	<> 'S'"
			cQuery += "   	AND	SB8.D_E_L_E_T_	<> '*'"
			cQuery += " 	AND	SB1.B1_FILIAL	= '" + xFilial("SB1") + "'"
			cQuery += "		AND	SB1.B1_COD		= B8_PRODUTO"
			cQuery += "   	AND	SB1.D_E_L_E_T_	<> '*'"
			cQuery += "   ORDER BY B8_PRODUTO"
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), (cArea := GetNextAlias()), .F., .T.)
			
			TcSetField( cArea, "B8_DTVALID", "D", 08, 00 )
			
			Count To nQtdReg
	
			(cArea)->( dbGoTop() )
	
			ProcRegua(nQtdReg)
			
			While (cArea)->( !Eof() )
			
				IncProc()
				
				For nZ := 1 To (cArea)->B8_SALDO
				
					If lEnd
						Exit 
					EndIf
				
					n++
					
					RecLock("SX6", .F.)
						SX6->X6_CONTEUD := Soma1( AllTrim(SX6->X6_CONTEUD) )			
					MsUnLock()
	
					aAdd(aCols, Array(Len(aHeader)+1))
					
					nLin := Len(aCols)
					
					For nX := 1 To Len(aHeader)
						
						cCampo := Alltrim(aHeader[nX,2])
						
						If IsHeadRec(aHeader[nX][2])
							aCols[nLin][nX] := 0
						ElseIf IsHeadAlias(aHeader[nX][2])
							aCols[nLin][nX] := "SD3"
						ElseIf aHeader[nX,8] == "C"
							aCols[nLin,nX] := Space(aHeader[nX,4])
						ElseIf aHeader[nX,8] == "N"
							aCols[nLin,nX] := 0
						ElseIf aHeader[nX,8] == "D" .And. cCampo != "D3_DTVALID"
							aCols[nLin][nX] := dDataBase
			 			ElseIf aHeader[nX,8] == "D" .And. cCampo == "D3_DTVALID"
							aCols[nLin][nX] := CriaVar("D3_DTVALID")
						ElseIf aHeader[nX,8] == "M"
							aCols[nLin,nX] := ''
						Else
							aCols[nLin,nX] := .F.
						EndIf
						
					Next nX                 
					aCols[nLin,Len(aHeader)+1] := .F.  
					
					//Origem
					aCols[nLin][01] := (cArea)->B8_PRODUTO	//D3_COD
					aCols[nLin][02] := (cArea)->B1_DESC		//D3_DESCRI
					aCols[nLin][03] := (cArea)->B1_UM  		//D3_UM
					aCols[nLin][04] := (cArea)->B8_LOCAL		//D3_LOCAL
					//aCols[nLin][05] := ""						//D3_LOCALIZ
			
					//Destino
					aCols[nLin][06] := (cArea)->B8_PRODUTO		//D3_COD
					aCols[nLin][07] := (cArea)->B1_DESC		//D3_DESCRI
					aCols[nLin][08] := (cArea)->B1_UM  		//D3_UM
					aCols[nLin][09] := (cArea)->B8_LOCAL		//D3_LOCAL
					//aCols[nLin][10] := ""						//D3_LOCALIZ
			
					//Origem
					//aCols[nLin][11] := ""						//D3_NUMSERI
					aCols[nLin][12] := (cArea)->B8_LOTECTL		//D3_LOTECTL
					aCols[nLin][13] := ""         				//D3_NUMLOTE
					aCols[nLin][14] := (cArea)->B8_DTVALID		//D3_DTVALID
					aCols[nLin][15] := 0						//D3_POTENCI
					aCols[nLin][16] := 1						//D3_QUANT
					//aCols[nLin][17] := 1						//D3_QTSEGUM
					//aCols[nLin][18] := ""   					  //D3_ESTORNO
					//aCols[nLin][19] := SOMA1(GETMV("MV_DOCSEQ"))//D3_NUMSEQ
			
					//Destino
					aCols[nLin][20] := AllTrim(SX6->X6_CONTEUD)//D3_LOTECTL
					aCols[nLin][21] := (cArea)->B8_DTVALID		//D3_DTVALID
					//aCols[nLin][22] := ""						//D3_ITEMGRD
			
					//Campos especificos Jomhedica

					aCols[nLin][23] := (cArea)->B8_LOTECTL		//Lote
					aCols[nLin][24] := (cArea)->B8_DTVALID		//Data Validade
					aCols[nLin][25] := (cArea)->B8_DOC			//Documento(NF)
					aCols[nLin][26] := (cArea)->B8_SERIE		//Serie(NF)     
					aCols[nLin][27] := (cArea)->B8_CLIFOR		//Fornecedor    
					aCols[nLin][28] := (cArea)->B8_LOJA		//Loja          
					aCols[nLin][29] := (cArea)->B8_ORIGLAN		//ORIGLAN

				Next nZ			
	
				(cArea)->( dbSkip() )
				
			EndDo
			
			(cArea)->( dbCloSeArea() )
			
			If Len(aCols) = 0
			
				cMsg := "Verifique os parametros!" 
				cMSg += CRLF
				cMsg += "Verifique também, se o documento possui saldo!" 
	
				Aviso("Atenção", cMsg, {"Ok"}, 3)
			
				n := 1

				aAdd(aCols, Array(Len(aHeader)+1))
				
				nLin := Len(aCols)
				
				For nX := 1 To Len(aHeader)
					
					cCampo := Alltrim(aHeader[nX,2])
					
					If IsHeadRec(aHeader[nX][2])
						aCols[nLin][nX] := 0
					ElseIf IsHeadAlias(aHeader[nX][2])
						aCols[nLin][nX] := "SD3"
					ElseIf aHeader[nX,8] == "C"
						aCols[nLin,nX] := Space(aHeader[nX,4])
					ElseIf aHeader[nX,8] == "N"
						aCols[nLin,nX] := 0
					ElseIf aHeader[nX,8] == "D" .And. cCampo != "D3_DTVALID"
						aCols[nLin][nX] := dDataBase
					ElseIf aHeader[nX,8] == "D" .And. cCampo == "D3_DTVALID"
						aCols[nLin][nX] := CriaVar("D3_DTVALID")
					ElseIf aHeader[nX,8] == "M"
						aCols[nLin,nX] := ''
					Else
						aCols[nLin,nX] := .F.
					EndIf
					
				Next nX                 
				aCols[nLin,Len(aHeader)+1] := .F.
			
			EndIf
			
			oGet:ForceRefresh()
		
		EndIf//Pergunte
		
	EndIf//lSeek


Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A030CriaSx³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grupo de perguntas.                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function A030CriaSx(cPerg)

	Local aP	 	:= {}
	Local aHelp	:= {}
	Local nI	 	:= 0
	Local cSeq	:= ""
	Local cMvCh	:= ""
	Local cMvPar	:= ""
	
	//			Texto Pergunta   Tipo 	Tam 	  						Dec  G=get ou C=Choice  		Val    F3		Def01 	  Def02 	 Def03   Def04   Def05
	aAdd(aP,{	"Documento ?",	"C",	TamSX3("F1_DOC")[1],			0,		"G",				"",	 	"",		   "",		"",		"",		"",		""})
	aAdd(aP,{	"Serie ?",		"C",	TamSX3("F1_SERIE")[1],			0,		"G",				"",	 	"",		   "",		"",		"",		"",		""})
	aAdd(aP,{	"Fornecedor ?",	"C",	TamSX3("F1_FORNECE")[1],		0,		"G",				"",	 	"",			"",		"",		"",		"",		""})
	aAdd(aP,{	"Loja ?",		"C",	TamSX3("F1_LOJA")[1],			0,		"G",				"",	 	"",		   "",		"",		"",		"",		""})
	aAdd(aP,{	"Produto ?",	"C",	TamSX3("B1_COD")[1],			0,		"G",				"",	 	"",		   "",		"",		"",		"",		""})
	aAdd(aP,{	"Lote ?",		"C",	TamSX3("B8_LOTECTL")[1],		0,		"G",				"",	 	"",		   "",		"",		"",		"",		""})
	
	//           012345678912345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//                    1         2         3         4         5         6         7         8         9        10        11        12
	aAdd(aHelp, {"Numero do Documento de Entrada"})
	aAdd(aHelp, {"Serie do Documento de Entrada"})
	aAdd(aHelp, {"Codigo do Fornecedor"})
	aAdd(aHelp, {"Loja do Fornecedor"})
	aAdd(aHelp, {"Código do Produto"})
	aAdd(aHelp, {"Número do Lote"})
	
	
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
	
Return