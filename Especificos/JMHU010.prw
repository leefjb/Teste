#INCLUDE 'TOTVS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JMHU010  ºAutor  ³ Cristiano Oliveira º Data ³ 13/09/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preencher o fechamento de saldos da contabilizacao para os º±±
±±º          ³ meses que nao tiveram movimento. Replica o valor anterior. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ JOMHEDICA - Exibicao de Saldos por Contas no BI MACHINE    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function JMHU010()                                                                   

	Local aSays		:= {}
	Local aButtons	:= {}
	Local cCadastro	:= OemToAnsi("Atualiza Saldos s/ Movimento")
	Local nOpca		:= 0

	Private cPerg	:= "J010QU"
	Private oProcess
    
//	ValidPerg()               
	
	Aadd(aSays,OemToAnsi("Atualiza fechamentos de saldos contabeis."))
	Aadd(aSays,OemToAnsi("Cria registros para meses sem movimentos."))
	Aadd(aSays,OemToAnsi("Tabela CQ0010. Utilizado no BI MACHINE."))

	aAdd(aButtons, {  5,.T.,{ || Pergunte(cPerg,.T.) } } )
	aAdd(aButtons, {  1,.T.,{ |o| nOpca := 1,IF( gpconfOK(), FechaBatch(), nOpca := 0 ) } } )
	aAdd(aButtons, {  2,.T.,{ |o| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpca == 1
//		oProcess := MsNewProcess():New({|| J010UCT7() }, "Atualizacao de Saldos", "Atualizando...",.F.)
		oProcess := MsNewProcess():New({|| J010UCQ0() }, "Atualizacao de Saldos", "Atualizando...",.F.)
		oProcess:Activate()   	
	Endif

Return        
                 
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ºPrograma  ³ J010UCQ0 ºAutor  ³ Cristiano Oliveira    ³ Data ³12/01/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Executa update na tabela CQ0                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/               

Static Function J010UCQ0()

	Local cQuery1  := ""
	Local cQuery2  := ""  
	Local cQuery3  := ""  
	Local nI       := 0
	Local aMesCQ0A := {}
	Local aMesCQ0B := {}
	                                                                                    	
	cQuery1  += " SELECT CT1_CONTA "
	cQuery1  += " FROM " + RetSqlName("CT1") +" CT1 " 
	cQuery1  += " WHERE CT1_FILIAL  = '" + xFilial('CT1') + "' "
	cQuery1  += " AND   CT1_CONTA   >= '" + MV_PAR03 + "' "
	cQuery1  += " AND   CT1_CONTA   <= '" + MV_PAR04 + "' "
	cQuery1  += " AND   D_E_L_E_T_  <> '*' "
        
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery1), "TMPCT1", .F., .T.)
    cQuery1 := ""
               
	While TMPCT1->( !Eof() )
	
		cQuery2  += " SELECT CQ0_CONTA, CQ0_DATA "
		cQuery2  += " FROM " + RetSqlName("CQ0") +" CQ0 " 
		cQuery2  += " WHERE CQ0_FILIAL  = '" + xFilial('CQ0') + "' "
		cQuery2  += " AND   CQ0_CONTA   = '" + TMPCT1->CT1_CONTA + "' "
		cQuery2  += " AND   CQ0_DATA   >= '" + DTOS(MV_PAR01) + "' "
		cQuery2  += " AND   CQ0_DATA   <= '" + DTOS(MV_PAR02) + "' "
		cQuery2  += " AND   D_E_L_E_T_  <> '*' "     
		cQuery2  += " ORDER BY CQ0_DATA "     

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery2), "TMPCQ0", .F., .T.)
	    cQuery2 := ""   
		
		While TMPCQ0->( !Eof() )
	          
			AADD(aMesCQ0A, {CQ0_CONTA, SUBSTR(CQ0_DATA, 1, 6)})					

			dbSelectArea("TMPCQ0")
			dbSkip()	
		EndDo
	
	    dbSelectArea("TMPCQ0")    
		DbCloseArea()
		         
		// Verifica se faltou algum mes e monta array com os meses que estao faltando
		sDtIni := SUBSTR(DTOS(MV_PAR01), 1, 6)
		sDtFim := SUBSTR(DTOS(MV_PAR02), 1, 6)
		sDtAux := sDtIni                    

		While sDtFim != (sDtAux)

			If aScan( aMesCQ0A, { |x| AllTrim( x[ 2 ] ) == sDtAux } ) == 0
   				AADD(aMesCQ0B, {TMPCT1->CT1_CONTA, sDtAux})
			EndIf
			
			If SUBSTR(sDtAux, 5, 2) == "12"
				sDtAux := cValToChar((VAL(SUBSTR(sDtAux, 1, 4)) + 1)) + "01"
			Else
				sDtAux := cValToChar(VAL(sDtAux) + 1)
			EndIf
                     
			Loop
		EndDo 
		aMesCQ0A := {} 
		
		// Percorre o array com as posicoes faltando e cria fechamentos de saldo para estes meses
		If Len(aMesCQ0B) > 0 // Testa se achou meses sem o fechamento
			For nI := 1 To Len(aMesCQ0B)                   
			                                           
				cStrData := aMesCQ0B[nI, 2] + "28"
			
				cQuery3  += " SELECT TOP 1 * "
				cQuery3  += " FROM " + RetSqlName("CQ0") +" CQ0 " 
				cQuery3  += " WHERE CQ0_FILIAL  = '" + xFilial('CQ0') + "' "
				cQuery3  += " AND   CQ0_CONTA   = '" + aMesCQ0B[nI, 1] + "' "
				cQuery3  += " AND   CQ0_DATA    < '" + cStrData + "' "
				cQuery3  += " AND   D_E_L_E_T_  <> '*' "     
				cQuery3  += " ORDER BY CQ0_DATA DESC "     
		
				dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery3), "ULTCQ0", .F., .T.)
				cQuery3 := ""
				    
				If ULTCQ0->( !Eof() )

					// dbSelectArea("CQ0")
					RecLock("CQ0", .T. )
					CQ0->CQ0_FILIAL := ULTCQ0->CQ0_FILIAL
					CQ0->CQ0_CONTA  := ULTCQ0->CQ0_CONTA 
					CQ0->CQ0_MOEDA  := ULTCQ0->CQ0_MOEDA 
					CQ0->CQ0_DATA   := STOD(cStrData)
					CQ0->CQ0_DEBITO := 0 // ULTCQ0->CQ0_DEBITO
					CQ0->CQ0_CREDIT := 0 // ULTCQ0->CQ0_CREDIT
					CQ0->CQ0_TPSALD := ULTCQ0->CQ0_TPSALD
					CQ0->CQ0_STATUS := ULTCQ0->CQ0_STATUS
//					CQ0->CQ0_ATUDEB := ULTCQ0->CQ0_ATUDEB
//					CQ0->CQ0_ATUCRD := ULTCQ0->CQ0_ATUCRD
//					CQ0->CQ0_ANTDEB := ULTCQ0->CQ0_ANTDEB
//					CQ0->CQ0_ANTCRD := ULTCQ0->CQ0_ANTCRD
//					CQ0->CQ0_LPDEB  := ULTCQ0->CQ0_LPDEB 
//					CQ0->CQ0_LPCRD  := ULTCQ0->CQ0_LPCRD 
					CQ0->CQ0_SLBASE := ULTCQ0->CQ0_SLBASE
//					CQ0->CQ0_DTLP   := ULTCQ0->CQ0_DTLP  
					CQ0->CQ0_LP     := ULTCQ0->CQ0_LP    
//					CQ0->CQ0_AUTOBI := "S"
					MsUnLock()
					
				EndIf

				dbSelectArea("ULTCQ0")
				DbCloseArea()				

			Next nI
			
			aMesCQ0B := {}
			
		EndIf
		        
		dbSelectArea("TMPCT1")
		dbSkip()	
	EndDo
                    
 	dbSelectArea("TMPCT1")
	DbCloseArea()

Return()    
            
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ºPrograma  ³ J010UCT7 ºAutor  ³ Cristiano Oliveira    ³ Data ³13/09/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Executa update na tabela CT7                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/               

Static Function J010UCT7()

	Local cQuery1  := ""
	Local cQuery2  := ""  
	Local cQuery3  := ""  
	Local nI       := 0
	Local aMesCT7A := {}
	Local aMesCT7B := {}
	                                                                                    	
	cQuery1  += " SELECT CT1_CONTA "
	cQuery1  += " FROM " + RetSqlName("CT1") +" CT1 " 
	cQuery1  += " WHERE CT1_FILIAL  = '" + xFilial('CT1') + "' "
	cQuery1  += " AND   CT1_CONTA   >= '" + MV_PAR03 + "' "
	cQuery1  += " AND   CT1_CONTA   <= '" + MV_PAR04 + "' "
	cQuery1  += " AND   D_E_L_E_T_  <> '*' "
        
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery1), "TMPCT1", .F., .T.)
    cQuery1 := ""
               
	While TMPCT1->( !Eof() )
	
		cQuery2  += " SELECT CT7_CONTA, CT7_DATA "
		cQuery2  += " FROM " + RetSqlName("CT7") +" CT7 " 
		cQuery2  += " WHERE CT7_FILIAL  = '" + xFilial('CT7') + "' "
		cQuery2  += " AND   CT7_CONTA   = '" + TMPCT1->CT1_CONTA + "' "
		cQuery2  += " AND   CT7_DATA   >= '" + DTOS(MV_PAR01) + "' "
		cQuery2  += " AND   CT7_DATA   <= '" + DTOS(MV_PAR02) + "' "
		cQuery2  += " AND   D_E_L_E_T_  <> '*' "     
		cQuery2  += " ORDER BY CT7_DATA "     

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery2), "TMPCT7", .F., .T.)
	    cQuery2 := ""   
		
		While TMPCT7->( !Eof() )
	          
			AADD(aMesCT7A, {CT7_CONTA, SUBSTR(CT7_DATA, 1, 6)})					

			dbSelectArea("TMPCT7")
			dbSkip()	
		EndDo
	
	    dbSelectArea("TMPCT7")    
		DbCloseArea()
		         
		// Verifica se faltou algum mes e monta array com os meses que estao faltando
		sDtIni := SUBSTR(DTOS(MV_PAR01), 1, 6)
		sDtFim := SUBSTR(DTOS(MV_PAR02), 1, 6)
		sDtAux := sDtIni                    

		While sDtFim != (sDtAux)

			If aScan( aMesCT7A, { |x| AllTrim( x[ 2 ] ) == sDtAux } ) == 0
   				AADD(aMesCT7B, {TMPCT1->CT1_CONTA, sDtAux})
			EndIf
			
			If SUBSTR(sDtAux, 5, 2) == "12"
				sDtAux := cValToChar((VAL(SUBSTR(sDtAux, 1, 4)) + 1)) + "01"
			Else
				sDtAux := cValToChar(VAL(sDtAux) + 1)
			EndIf
                     
			Loop
		EndDo 
		aMesCT7A := {}
		// Percorre o array com as posicoes faltando e cria fechamentos de saldo para estes meses
		If Len(aMesCT7B) > 0 // Testa se achou meses sem o fechamento
			For nI := 1 To Len(aMesCT7B)                   
			                                           
				cStrData := aMesCT7B[nI, 2] + "28"
			
				cQuery3  += " SELECT TOP 1 * "
				cQuery3  += " FROM " + RetSqlName("CT7") +" CT7 " 
				cQuery3  += " WHERE CT7_FILIAL  = '" + xFilial('CT7') + "' "
				cQuery3  += " AND   CT7_CONTA   = '" + aMesCT7B[nI, 1] + "' "
				cQuery3  += " AND   CT7_DATA    < '" + cStrData + "' "
				cQuery3  += " AND   D_E_L_E_T_  <> '*' "     
				cQuery3  += " ORDER BY CT7_DATA DESC "     
		
				dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery3), "ULTCT7", .F., .T.)
				cQuery3 := ""
				    
				If ULTCT7->( !Eof() )

					// dbSelectArea("CT7")
					RecLock("CT7", .T. )
					CT7->CT7_FILIAL := ULTCT7->CT7_FILIAL
					CT7->CT7_CONTA  := ULTCT7->CT7_CONTA 
					CT7->CT7_MOEDA  := ULTCT7->CT7_MOEDA 
					CT7->CT7_DATA   := STOD(cStrData)
					CT7->CT7_DEBITO := ULTCT7->CT7_DEBITO
					CT7->CT7_CREDIT := ULTCT7->CT7_CREDIT
					CT7->CT7_TPSALD := ULTCT7->CT7_TPSALD
					CT7->CT7_STATUS := ULTCT7->CT7_STATUS
					CT7->CT7_ATUDEB := ULTCT7->CT7_ATUDEB
					CT7->CT7_ATUCRD := ULTCT7->CT7_ATUCRD
					CT7->CT7_ANTDEB := ULTCT7->CT7_ANTDEB
					CT7->CT7_ANTCRD := ULTCT7->CT7_ANTCRD
					CT7->CT7_LPDEB  := ULTCT7->CT7_LPDEB 
					CT7->CT7_LPCRD  := ULTCT7->CT7_LPCRD 
					CT7->CT7_SLBASE := ULTCT7->CT7_SLBASE
//					CT7->CT7_DTLP   := ULTCT7->CT7_DTLP  
					CT7->CT7_LP     := ULTCT7->CT7_LP    
					CT7->CT7_AUTOBI := "S"
					MsUnLock()
					   
//					dbSelectArea("ULTCT7")
//					dbSkip()	
				EndIf

				dbSelectArea("ULTCT7")
				DbCloseArea()				

			Next nI
			
			aMesCT7B := {}
			
		EndIf
		        
		dbSelectArea("TMPCT1")
		dbSkip()	
	EndDo
                    
 	dbSelectArea("TMPCT1")
	DbCloseArea()

Return()    

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ºPrograma  ³ CriaSx1  ºAutor  ³ Cristiano Oliveira  º Data ³ 13/09/2017 º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Criar o grupo de perguntas                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/               
Static Function CriaSx1()

	Local aP 	:= {}
	Local nI 	:= 0
	Local cSeq  := ""
	Local cMvCh := ""
	Local cMvPar:= ""
	Local aHelp := {}
	Local cPerg := PadR("JMHU010",Len(SX1->X1_GRUPO)) 
		
	aAdd(aP,{"Data de"		,"D",8,0,"G",""                    ,""   	,""   ,""   ,"","",""})
	aAdd(aP,{"Data ate"		,"D",8,0,"G","(MV_PAR02>=MV_PAR01)",""   	,""   ,""   ,"","",""})
	aAdd(aP,{"Conta de"		,"C",20,0,"G",""                   ,"CT1"	,""   ,""   ,"","",""})
	aAdd(aP,{"Conta ate"    ,"C",20,0,"G",""                   ,"CT1"	,""   ,""   ,"","",""})

    //           0123456789123456789012345678901234567890
    //                    1         2         3         4     
	aAdd(aHelp,{"Informe a DATA INICIAL para a","atualizacao de saldos."})
	aAdd(aHelp,{"Informe a DATA FINAL para a","atualizacao de saldos."})
	aAdd(aHelp,{"Informe a CONTA INICIAL para a","atualizacao de saldos."})                                                                         
	aAdd(aHelp,{"Informe a CONTA FINAL para a","atualizacao de saldos."})
		
	For nI:=1 To Len(aP)
	
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
		0,;
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
      
Return( cPerg )




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ Cristiano Oliveira º Data ³  12/01/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Validar as perguntas - PROTHEUS 12                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/      
Static Function ValidPerg()

Local aRegs := {}
Local i     := 0
Local j     := 0

DbSelectArea( "SX1" )
DbSetOrder( 1 )

//         X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_GRPSXG
//         Grupo   /Ordem   /Pergunta  /         /         /Variavel  /Tipo   /Tamanho   /Decimal   /Presel   /GSC   /Valid   /Var01   /Def01   /          /          /Cnt01   /Var02   /Def02   /          /          /Cnt02   /Var03   /Def03   /          /          /Cnt03   /Var04   /Def04   /          /          /Cnt04   /Var05   /Def05   /          /          /Cnt05   /F3   /Grupo SXG
AADD( aRegs, { cPerg, "01", "Data de:"            ,"","", "mv_ch1", "D", 008,0,0,"G","","mv_par01","" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD( aRegs, { cPerg, "02", "Data ate:"           ,"","", "mv_ch2", "D", 008,0,0,"G","","mv_par02","" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD( aRegs, { cPerg, "03", "Conta de:"           ,"","", "mv_ch3", "C", 020,0,0,"G","","mv_par03","" ,"","","","","","","","","","","","","","","","","","","","","","","","CT1","","","","",""})
AADD( aRegs, { cPerg, "04", "Conta ate:"          ,"","", "mv_ch4", "C", 020,0,0,"G","","mv_par04","" ,"","","","","","","","","","","","","","","","","","","","","","","","CT1","","","","",""})

For i := 1 to Len( aRegs )
   If !DbSeek( cPerg + aRegs[ i, 2 ] )
      RecLock( "SX1", .T. )
      For j := 1 to FCount()
         If j <= Len( aRegs[ i ] )
            FieldPut( j, aRegs[ i, j ] )
         Endif
      Next j
      MsUnlock()
   Endif
Next i

Return Nil