#INCLUDE "Protheus.Ch"
#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAUXDIRF01 บAutor  ณJean - Solutio     บ Data ณ  30/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Programa usado para preencher o campo E2_TITPAI dos titu- บฑฑ
ฑฑบ          ณlos filhos, com informacoes do titulo pai.                  บฑฑ
ฑฑบ          ณFormato do preenchimento:                                   บฑฑ
ฑฑบ          ณ    PREFIXO+NUMERO+TIPO+FORNECEDOR+LOJA DO FORNECEDOR       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus10                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AuxDIRF01()  

	Local cPerg := "AUXDIRF"

	PutSx1( cPerg, "01","Emissใo De ?" ,"Emissใo De ?" ,"Emissใo De ?" ,"mv_ch1","D",8,0,2,"G","","","","","mv_par01"," ","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "02","Emissใo At้ ?","Emissใo At้ ?","Emissใo At้ ?","mv_ch2","D",8,0,2,"G","","","","","mv_par02"," ","","","","","","","","","","","","","","","")

	If !Pergunte( cPerg, .T. ) // Exibe a tela de parโmetros
		Return
	EndIf

	Processa( {|lEnd| GravaPIS()    }," Processando registros PAIS/PIS..."   , "Esta operacao pode levar alguns minutos...",.T.)
	Processa( {|lEnd| GravaCOFINS() }," Processando registros PAIS/COFINS...", "Esta operacao pode levar alguns minutos...",.T.)
	Processa( {|lEnd| GravaCSLL()   }," Processando registros PAIS/CSLL..."  , "Esta operacao pode levar alguns minutos...",.T.)
	Processa( {|lEnd| GravaIRRF()   }," Processando registros PAIS/IRRF..."  , "Esta operacao pode levar alguns minutos...",.T.)
	Processa( {|lEnd| CorrigePais() }," Corrigindo Registros PAIS/NF..."     , "Esta operacao pode levar alguns minutos...",.T.)
												
	Alert("Correcao concluida com Exito!  ")    

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |Aux01B    บAutor  ณJean - Solutio     บ Data ณ      30/03/17บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Inicio da execucao do programa.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaPIS()

	Local nCont        := 0  
	Local nCtMsg       := 0    
	Local nSQL2_RECNO  := 0
	Local nSQL3_RECNO  := 0
	Local nSQL4_RECNO  := 0
	Local nSQL5_RECNO  := 0
	Local cSQL2_NATUREZ:= ""
	Local cSQL3_NATUREZ:= ""
	Local cSQL4_NATUREZ:= ""
	Local cSQL5_NATUREZ:= ""
	Local aSQL1        := {}
	Local aPIS         := {}
	Local aPaiPIS      := {}


	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'NF'                  
	IncProc("Sele็ใo de registros PIS/PAIS...")

	cStm := "SELECT E2_FILIAL,E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PIS, E2_COFINS, E2_CSLL, E2_IRRF, E2_PARCELA, E2_TIPO "
	cStm += " FROM "+ RetSqlName("SE2") +" SE2"
	cStm += " WHERE "
	cStm +=         " SE2.D_E_L_E_T_ <> '*' "
	cStm +=         " AND (SE2.E2_TIPO = 'NF') "// OR SE2.E2_TIPO = 'RC') "
	cStm +=         " AND SE2.E2_PIS > 0 "
	cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
	cStm := ChangeQuery(cStm)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL1",.T.,.T.)

	DBSelectArea("SQL1")             
	While !EOF()
	  nCont++
	DBSkip()
	EndDo

	ProcRegua(nCont+nCont+1)   // Processo da regua                 

	DBGoTop()
	While !EOF()
 

		AADD(aSQL1, {SQL1->E2_PREFIXO,;  //[1 ]PREFIXO
					 SQL1->E2_NUM    ,;  //[2 ]NUMERO DO TITULO PAI 
					 SQL1->E2_TIPO   ,;  //[3 ]TIPO DO TITULO
					 SQL1->E2_FORNECE,;  //[4 ]CODIGO DO FORNECEDOR
					 SQL1->E2_LOJA   ,;  //[5 ]LOJA DO FORNECEDOR
					 SQL1->E2_PIS    ,;  //[6 ]VALOR PIS DO TITULO
					 SQL1->E2_COFINS ,;  //[7 ]VALOR DO COFINS DO TITULO
					 SQL1->E2_CSLL   ,;  //[8 ]VALOR DO CSLL DO TITULO
					 SQL1->E2_IRRF   ,;  //[9 ]VALOR DO IRRF DO TITULO
					 SQL1->E2_PARCELA,;  //[10]PARCELA
					 SQL1->E2_FILIAL})   //[11]FILIAL
					 
		// INCREMENTA A REGUA
		IncProc(nCont++) 

		nCtMsg++ 	    
		DBSelectArea("SQL1")     
		DBSkip()

	EndDo

	DBCloseArea("SQL1")

	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'TX' REFERENTE AO 'PIS' DO TITULO PAI                    
	IncProc("Sele็ใo de registros PIS/FILHOS...")

	// PROCESSA TODOS OS REGISTROS QUE ESTรO NO ARRAY
	For nX := 1 To Len(aSQL1)

		cStm := "SELECT * "
		cStm += "FROM "
		cStm += " "+RetSqlName("SE2")+" SE2 "
		cStm += " WHERE "
		cStm +=         " SE2.D_E_L_E_T_ <> '*' "
		cStm +=         " AND SE2.E2_TIPO = 'TX' "
		cStm +=         " AND SE2.E2_PREFIXO = '"+aSQL1[nX][1]+"' "
		cStm +=         " AND SE2.E2_NUM = '"+aSQL1[nX][2]+"' "	
		cStm +=         " AND SE2.E2_FILIAL = '"+aSQL1[nX][11]+"' "	
		cStm +=         " AND SE2.E2_NUM NOT LIKE '%TEST%' "	
		cStm +=         " AND SE2.E2_VALOR = "+STR(aSQL1[nX][6])+" "
		cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
		cStm := ChangeQuery(cStm)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL2",.T.,.T.)

		DBSelectArea("SQL2")             
		DBGoTop()
		While !EOF()
		
		   nSQL2_RECNO   := SQL2->R_E_C_N_O_        
		   cSQL2_NATUREZ := SQL2->E2_NATUREZ  

		   // ADICIONA OS REGISTROS REFERENTES AO PIS   
		   cMonta := aSQL1[nX][1]+aSQL1[nX][2]+aSQL1[nX][10]+aSQL1[nX][3]+aSQL1[nX][4]+aSQL1[nX][5]
		   // RECNO + NATUREZA + MONTAGEM
		   If nSQL2_RECNO > 0 .AND. "PIS" $ cSQL2_NATUREZ
			   AADD(aPIS,{SQL2->R_E_C_N_O_  ,;
						  SQL2->E2_NATUREZ  ,;
						  "1"               ,;
						  "5952"            ,;
						  cMonta})
		   EndIf	
		   
			// INCREMENTA A REGUA   
			IncProc(nCont++)   
			DBSelectArea("SQL2")             	
			DBSkip()                            	
		
		EndDo                               
		
		DBSelectArea("SQL2")             	    
		DBCloseArea("SQL2")	
		
	Next nX
	
	// INICIA A GRAVAวรO DOS REGISTROS TIPO 'TX' REFERENTE AO 'PIS' DO TITULO PAI                    
	IncProc("Reparo de registros PIS...")

	For nX := 1 To Len(aPIS)

		DbSelectArea("SE2")  
			SE2->(DbGoTop())	
			SE2->(DbGoTo(aPIS[nX][1]))
			Reclock("SE2",.F.)
				Replace SE2->E2_DIRF   With aPIS[nX][3]			
				Replace SE2->E2_CODRET With aPIS[nX][4]						
				Replace SE2->E2_TITPAI With aPIS[nX][5]	                    			
			MSUnlock()         
		DbCloseArea("SE2")
		
	Next nX

	// INCREMENTA A REGUA
	IncProc(nCont++) 

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |Aux01B    บAutor  ณJean - Solutio     บ Data ณ  30/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Inicio da execucao do programa.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaCOFINS()

	Local nCont        := 0  
	Local nCtMsg       := 0    
	Local nSQL2_RECNO  := 0
	Local nSQL3_RECNO  := 0
	Local nSQL4_RECNO  := 0
	Local nSQL5_RECNO  := 0
	Local cSQL2_NATUREZ:= ""
	Local cSQL3_NATUREZ:= ""
	Local cSQL4_NATUREZ:= ""
	Local cSQL5_NATUREZ:= ""
	Local aSQL1        := {}
	Local aCOFINS      := {}

	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'NF'                  
	IncProc("Sele็ใo de registros COFINS/PAIS...")

	cStm := "SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PIS, E2_COFINS, E2_CSLL, E2_IRRF, E2_PARCELA, E2_TIPO "
	cStm += " FROM "
	cStm += " "+ RetSqlName("SE2") +" SE2 "
	cStm += " WHERE "
	cStm +=         " SE2.D_E_L_E_T_ <> '*' "
	cStm +=         " AND (SE2.E2_TIPO = 'NF') "// OR SE2.E2_TIPO = 'RC') "
	cStm +=         " AND SE2.E2_COFINS > 0 "
	cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
	cStm := ChangeQuery(cStm)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL1",.T.,.T.)

	DBSelectArea("SQL1")             
	While !EOF()
	  nCont++
	DBSkip()
	EndDo

	ProcRegua(nCont+nCont+1)   // Processo da regua                 

	DBGoTop()
	While !EOF()
	 
		AADD(aSQL1, {SQL1->E2_PREFIXO,;  //[1 ]PREFIXO
					 SQL1->E2_NUM    ,;  //[2 ]NUMERO DO TITULO PAI 
					 SQL1->E2_TIPO   ,;  //[3 ]TIPO DO TITULO
					 SQL1->E2_FORNECE,;  //[4 ]CODIGO DO FORNECEDOR
					 SQL1->E2_LOJA   ,;  //[5 ]LOJA DO FORNECEDOR
					 SQL1->E2_PIS    ,;  //[6 ]VALOR PIS DO TITULO
					 SQL1->E2_COFINS ,;  //[7 ]VALOR DO COFINS DO TITULO
					 SQL1->E2_CSLL   ,;  //[8 ]VALOR DO CSLL DO TITULO
					 SQL1->E2_IRRF   ,;  //[9 ]VALOR DO IRRF DO TITULO
					 SQL1->E2_PARCELA,;  //[10]PARCELA
					 SQL1->E2_FILIAL})   //[11]FILIAL
					 
		// INCREMENTA A REGUA
		IncProc(nCont++) 

		nCtMsg++ 	    
		DBSelectArea("SQL1")     
		DBSkip()

	EndDo
	
	DBCloseArea("SQL1")

	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'TX' REFERENTE AO 'COFINS' DO TITULO PAI                    
	IncProc("Sele็ใo de registros COFINS/FILHOS...")

	// PROCESSA TODOS OS REGISTROS QUE ESTรO NO ARRAY
	For nX := 1 To Len(aSQL1)
		cStm := "SELECT "
		cStm +=         " * "
		cStm += "FROM "+ RetSqlName("SE2") +" SE2 "
		cStm += " WHERE "
		cStm +=         " SE2.D_E_L_E_T_ <> '*' "
		cStm +=         " AND SE2.E2_TIPO = 'TX' "
		cStm +=         " AND SE2.E2_PREFIXO = '"+aSQL1[nX][1]+"' "
		cStm +=         " AND SE2.E2_NUM = '"+aSQL1[nX][2]+"' "	
		cStm +=         " AND SE2.E2_FILIAL = '"+aSQL1[nX][11]+"' "	
		cStm +=         " AND SE2.E2_NUM NOT LIKE '%TEST%' "	
		cStm +=         " AND SE2.E2_VALOR = "+STR(aSQL1[nX][7])+" "
		cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
		cStm := ChangeQuery(cStm)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL2",.T.,.T.)

		DBSelectArea("SQL2")             
		DBGoTop()
		While !EOF()
		   nSQL2_RECNO   := SQL2->R_E_C_N_O_        
		   cSQL2_NATUREZ := SQL2->E2_NATUREZ  

		   // ADICIONA OS REGISTROS REFERENTES AO COFINS   
		   cMonta := aSQL1[nX][1]+aSQL1[nX][2]+aSQL1[nX][10]+aSQL1[nX][3]+aSQL1[nX][4]+aSQL1[nX][5]
		   // RECNO + NATUREZA + MONTAGEM
		   If nSQL2_RECNO > 0 .AND. "COFINS" $ cSQL2_NATUREZ
			   AADD(aCOFINS,{SQL2->R_E_C_N_O_  ,;
						  SQL2->E2_NATUREZ  ,;
						  "1"               ,;
						  "5952"            ,;
						  cMonta})
		   EndIf	
		   
			// INCREMENTA A REGUA   
			IncProc(nCont++)   
			DBSelectArea("SQL2")             	
			DBSkip()                            	

		EndDo                               

		DBSelectArea("SQL2")             	    
		DBCloseArea("SQL2")	
		
	Next nX
	
	// INICIA A GRAVAวรO DOS REGISTROS TIPO 'TX' REFERENTE AO 'COFINS' DO TITULO PAI                    
	IncProc("Reparo de registros COFINS...")

	For nX := 1 To Len(aCOFINS)

		DbSelectArea("SE2")  
			SE2->(DbGoTop())	
			SE2->(DbGoTo(aCOFINS[nX][1]))
			Reclock("SE2",.F.)
				Replace SE2->E2_DIRF   With aCOFINS[nX][3]			
				Replace SE2->E2_CODRET With aCOFINS[nX][4]						
				Replace SE2->E2_TITPAI With aCOFINS[nX][5]	                    			
			MSUnlock()         
		DbCloseArea("SE2")
		
	Next nX

	// INCREMENTA A REGUA
	IncProc(nCont++) 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |Aux01B    บAutor  ณJean - Solutio     บ Data ณ  30/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Inicio da execucao do programa.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaCSLL()

	Local nCont        := 0  
	Local nCtMsg       := 0    
	Local nSQL2_RECNO  := 0
	Local nSQL3_RECNO  := 0
	Local nSQL4_RECNO  := 0
	Local nSQL5_RECNO  := 0
	Local cSQL2_NATUREZ:= ""
	Local cSQL3_NATUREZ:= ""
	Local cSQL4_NATUREZ:= ""
	Local cSQL5_NATUREZ:= ""
	Local aSQL1        := {}
	Local aCSLL        := {}

	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'NF'                  
	IncProc("Sele็ใo de registros CSLL/PAIS...")

	cStm := "SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PIS, E2_COFINS, E2_CSLL, E2_IRRF, E2_PARCELA, E2_TIPO "
	cStm += " FROM "+ RetSqlName("SE2") +" SE2 "
	cStm += " WHERE "
	cStm +=         " SE2.D_E_L_E_T_ <> '*' "
	cStm +=         " AND (SE2.E2_TIPO = 'NF') "// OR SE2.E2_TIPO = 'RC') "
	cStm +=         " AND SE2.E2_CSLL > 0 "
	cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
	cStm := ChangeQuery(cStm)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL1",.T.,.T.)

	DBSelectArea("SQL1")             
	While !EOF()
	  nCont++
	DBSkip()
	EndDo

	ProcRegua(nCont+nCont+1)   // Processo da regua                 

	DBGoTop()
	While !EOF()
 
		AADD(aSQL1, {SQL1->E2_PREFIXO,;  //[1 ]PREFIXO
					 SQL1->E2_NUM    ,;  //[2 ]NUMERO DO TITULO PAI 
					 SQL1->E2_TIPO   ,;  //[3 ]TIPO DO TITULO
					 SQL1->E2_FORNECE,;  //[4 ]CODIGO DO FORNECEDOR
					 SQL1->E2_LOJA   ,;  //[5 ]LOJA DO FORNECEDOR
					 SQL1->E2_PIS    ,;  //[6 ]VALOR PIS DO TITULO
					 SQL1->E2_COFINS ,;  //[7 ]VALOR DO COFINS DO TITULO
					 SQL1->E2_CSLL   ,;  //[8 ]VALOR DO CSLL DO TITULO
					 SQL1->E2_IRRF   ,;  //[9 ]VALOR DO IRRF DO TITULO
					 SQL1->E2_PARCELA,;  //[10]PARCELA
					 SQL1->E2_FILIAL})   //[11]PARCELA
					 
		// INCREMENTA A REGUA
		IncProc(nCont++) 

		nCtMsg++ 	    
		DBSelectArea("SQL1")     
		DBSkip()

	EndDo
	
	DBCloseArea("SQL1")

	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'TX' REFERENTE AO 'CSLL' DO TITULO PAI                    
	IncProc("Sele็ใo de registros CSLL/FILHOS...")

	// PROCESSA TODOS OS REGISTROS QUE ESTรO NO ARRAY
	For nX := 1 To Len(aSQL1)
		cStm := "SELECT * "
		cStm += "FROM "+ RetSqlName("SE2") +" SE2 "
		cStm += " WHERE "
		cStm +=         " SE2.D_E_L_E_T_ <> '*' "
		cStm +=         " AND SE2.E2_TIPO = 'TX' "
		cStm +=         " AND SE2.E2_PREFIXO = '"+aSQL1[nX][1]+"' "
		cStm +=         " AND SE2.E2_NUM = '"+aSQL1[nX][2]+"' "	
		cStm +=         " AND SE2.E2_FILIAL = '"+aSQL1[nX][11]+"' "	
		cStm +=         " AND SE2.E2_NUM NOT LIKE '%TEST%' "	
		cStm +=         " AND SE2.E2_VALOR = "+STR(aSQL1[nX][8])+" "
		cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
		cStm := ChangeQuery(cStm)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL2",.T.,.T.)

		DBSelectArea("SQL2")             
		DBGoTop()
		While !EOF()
		   nSQL2_RECNO   := SQL2->R_E_C_N_O_        
		   cSQL2_NATUREZ := SQL2->E2_NATUREZ  

		   // ADICIONA OS REGISTROS REFERENTES AO CSLL   
		   cMonta := aSQL1[nX][1]+aSQL1[nX][2]+aSQL1[nX][10]+aSQL1[nX][3]+aSQL1[nX][4]+aSQL1[nX][5]
		   // RECNO + NATUREZA + MONTAGEM
		   If nSQL2_RECNO > 0 .AND. "CSLL" $ cSQL2_NATUREZ
			   AADD(aCSLL,{SQL2->R_E_C_N_O_  ,;
						  SQL2->E2_NATUREZ  ,;
						  "1"               ,;
						  "5952"            ,;
						  cMonta})
		   EndIf	
		   
			// INCREMENTA A REGUA   
			IncProc(nCont++)   
			DBSelectArea("SQL2")             	
			DBSkip()                            	

		EndDo                               
		
		DBSelectArea("SQL2")             	    
		DBCloseArea("SQL2")	
		
	Next nX
	
	// INICIA A GRAVAวรO DOS REGISTROS TIPO 'TX' REFERENTE AO 'CSLL' DO TITULO PAI                    
	IncProc("Reparo de registros CSLL...")

	For nX := 1 To Len(aCSLL)

		DbSelectArea("SE2")  
			SE2->(DbGoTop())	
			SE2->(DbGoTo(aCSLL[nX][1]))
			Reclock("SE2",.F.)
				Replace SE2->E2_DIRF   With aCSLL[nX][3]			
				Replace SE2->E2_CODRET With aCSLL[nX][4]						
				Replace SE2->E2_TITPAI With aCSLL[nX][5]	                    			
			MSUnlock()         
		DbCloseArea("SE2")
		
	Next nX

	// INCREMENTA A REGUA
	IncProc(nCont++) 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |Aux01B    บAutor  ณJean - Solutio     บ Data ณ  30/03/17  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Inicio da execucao do programa.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaIRRF()

	Local nCont        := 0  
	Local nCtMsg       := 0    
	Local nSQL2_RECNO  := 0
	Local nSQL3_RECNO  := 0
	Local nSQL4_RECNO  := 0
	Local nSQL5_RECNO  := 0
	Local cSQL2_NATUREZ:= ""
	Local cSQL3_NATUREZ:= ""
	Local cSQL4_NATUREZ:= ""
	Local cSQL5_NATUREZ:= ""
	Local aSQL1        := {}
	Local aIRRF        := {}

	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'NF'                  
	IncProc("Sele็ใo de registros IRRF/PAIS...")

	cStm := "SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PIS, E2_COFINS, E2_CSLL, E2_IRRF, E2_PARCELA, E2_TIPO, E2_NATUREZ "
	cStm += " FROM "+ RetSqlName("SE2") +" SE2 "
	cStm += " WHERE "
	cStm +=         " SE2.D_E_L_E_T_ <> '*' "
	cStm +=         " AND (SE2.E2_TIPO = 'NF') "// OR SE2.E2_TIPO = 'RC') "
	cStm +=         " AND SE2.E2_IRRF > 0 "
	cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
	cStm := ChangeQuery(cStm)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL1",.T.,.T.)

	DBSelectArea("SQL1")             
	While !EOF()
	  nCont++
	DBSkip()
	EndDo

	ProcRegua(nCont+nCont+1)   // Processo da regua                 

	DBGoTop()
	While !EOF()
 

		AADD(aSQL1, {SQL1->E2_PREFIXO,;  //[1 ]PREFIXO
					 SQL1->E2_NUM    ,;  //[2 ]NUMERO DO TITULO PAI 
					 SQL1->E2_TIPO   ,;  //[3 ]TIPO DO TITULO
					 SQL1->E2_FORNECE,;  //[4 ]CODIGO DO FORNECEDOR
					 SQL1->E2_LOJA   ,;  //[5 ]LOJA DO FORNECEDOR
					 SQL1->E2_PIS    ,;  //[6 ]VALOR PIS DO TITULO
					 SQL1->E2_COFINS ,;  //[7 ]VALOR DO COFINS DO TITULO
					 SQL1->E2_CSLL   ,;  //[8 ]VALOR DO CSLL DO TITULO
					 SQL1->E2_IRRF   ,;  //[9 ]VALOR DO IRRF DO TITULO
					 SQL1->E2_PARCELA,;  //[10]PARCELA
					 SQL1->E2_FILIAL ,;  //[11]FILIAL
					 SQL1->E2_NATUREZ})  //[12]NATUREZA
					 
		// INCREMENTA A REGUA
		IncProc(nCont++) 

		nCtMsg++ 	    
		DBSelectArea("SQL1")     
		DBSkip()

	EndDo
	
	DBCloseArea("SQL1")

	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'TX' REFERENTE AO 'IRRF' DO TITULO PAI                    
	IncProc("Sele็ใo de registros IRRF/FILHOS...")

	For nX := 1 To Len(aSQL1)
		cStm := "SELECT * "
		cStm += "FROM "+ RetSqlName("SE2") +" SE2 "
		cStm += " WHERE "
		cStm +=         " SE2.D_E_L_E_T_ <> '*' "
		cStm +=         " AND SE2.E2_TIPO = 'TX' "
		cStm +=         " AND SE2.E2_PREFIXO = '"+aSQL1[nX][1]+"' "
		cStm +=         " AND SE2.E2_NUM = '"+aSQL1[nX][2]+"' "	
		cStm +=         " AND SE2.E2_FILIAL = '"+aSQL1[nX][11]+"' "	
		cStm +=         " AND SE2.E2_NUM NOT LIKE '%TEST%' "	
		cStm +=         " AND SE2.E2_VALOR = "+STR(aSQL1[nX][9])+" "
		cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
		cStm := ChangeQuery(cStm)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL2",.T.,.T.)

		DBSelectArea("SQL2")             
		DBGoTop()
		While !EOF()
			
			nSQL2_RECNO   := SQL2->R_E_C_N_O_        
			cSQL2_NATUREZ := SQL2->E2_NATUREZ  
			cCodRetNat    := Posicione("SED",1,xFilial("SED") + cSQL2_NATUREZ,"ED_CODREIR")

			// ADICIONA OS REGISTROS REFERENTES AO IRRF   
		 	cMonta := aSQL1[nX][1]+aSQL1[nX][2]+aSQL1[nX][10]+aSQL1[nX][3]+aSQL1[nX][4]+aSQL1[nX][5]
		   
			// RECNO + NATUREZA + MONTAGEM
			If nSQL2_RECNO > 0 .AND. !cSQL2_NATUREZ $ "CSLL/PIS/COFINS"
			   
				aAdd( aIRRF, {  SQL2->R_E_C_N_O_  ,;
								SQL2->E2_NATUREZ  ,;
								"1"               ,;
								cCodRetNat        ,;
								cMonta            })
		   EndIf	
		   
			IncProc( nCont++ ) // INCREMENTA A REGUA
			
			SQL2->( DBSkip() )

		EndDo                               

		DBSelectArea("SQL2")             	    
		DBCloseArea("SQL2")	
		
	Next nX
	
	// INICIA A GRAVAวรO DOS REGISTROS TIPO 'TX' REFERENTE AO 'IRRF' DO TITULO PAI                    
	IncProc("Reparo de registros IRRF...")

	For nX := 1 To Len(aIRRF)

		DbSelectArea("SE2")  
			SE2->(DbGoTop())	
			SE2->(DbGoTo(aIRRF[nX][1]))
			Reclock("SE2",.F.)
				Replace SE2->E2_DIRF   With aIRRF[nX][3]			
				Replace SE2->E2_CODRET With aIRRF[nX][4]						
				Replace SE2->E2_TITPAI With aIRRF[nX][5]	                    			
			MSUnlock()         
		DbCloseArea("SE2")
		
	Next nX

	// INCREMENTA A REGUA
	IncProc(nCont++) 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |Aux01B    บAutor  ณJean - Solutio     บ Data ณ  30/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Inicio da execucao do programa.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CorrigePais()

	Local nCont        := 0  
	Local nCtMsg       := 0    
	Local aSQL1        := {}
	Local aSQL2        := {}
	Local aSQL3        := {}
	Local aSQL4        := {}

	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'NF'                  
	IncProc("Sele็ใo de registros PAIS/PIS...")

	cStm := "SELECT R_E_C_N_O_ REG, E2_CODRET, E2_IRRF, E2_FILIAL "
	cStm += " FROM "+ RetSqlName("SE2") +" SE2 "
	cStm += " WHERE "
	cStm +=         " SE2.D_E_L_E_T_ <> '*' "
	cStm +=         " AND (SE2.E2_TIPO = 'NF') "// OR SE2.E2_TIPO = 'RC') "
	cStm +=         " AND SE2.E2_PIS > 0 "
	cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
	cStm := ChangeQuery(cStm)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL1",.T.,.T.)

	DBSelectArea("SQL1")             
	While !EOF()
	  nCont++
	DBSkip()
	EndDo

	ProcRegua(nCont+nCont)   // Processo da regua                 

	DBGoTop()
	While !EOF()

		// ARRAY COM RECNO PAI 
		AADD(aSQL1, {SQL1->REG       ,;   //[1 ]RECNO
					 SQL1->E2_CODRET ,;   //[2 ]COD RET
					 SQL1->E2_IRRF   ,;   //[3 ]VALOR DO IRRF
					 SQL1->E2_FILIAL})    //[4 ]FILIAL
			 
		// INCREMENTA A REGUA
		IncProc(nCont++) 

		nCtMsg++ 	    
		DBSelectArea("SQL1")     
		DBSkip()
	
	EndDo

	DBCloseArea("SQL1")

	// INICIA REPARO DO TITULO PAI                    
	IncProc("Reparo de registros PAIS/PIS...")

	// FUNวรO QUE REPARA TITULOS PAIS/NF - PIS
	ReparaPAIS(aSQL1,nCont)


	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'NF'                  
	IncProc("Sele็ใo de registros PAIS/PIS...")

	cStm := "SELECT R_E_C_N_O_ REG, E2_CODRET, E2_IRRF, E2_FILIAL "
	cStm += " FROM "+ RetSqlName("SE2") +" SE2 "
	cStm += " WHERE "
	cStm +=         " SE2.D_E_L_E_T_ <> '*' "
	cStm +=         " AND (SE2.E2_TIPO = 'NF') "// OR SE2.E2_TIPO = 'RC') "
	cStm +=         " AND SE2.E2_COFINS > 0 "
	cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
	cStm := ChangeQuery(cStm)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL2",.T.,.T.)

	DBSelectArea("SQL2")             
	While !EOF()
	  nCont++
	DBSkip()
	EndDo

	ProcRegua(nCont+nCont)   // Processo da regua                 

	DBGoTop()
	While !EOF()

		// ARRAY COM RECNO PAI 
		AADD(aSQL2, {SQL2->REG       ,;   //[1 ]RECNO
					 SQL2->E2_CODRET ,;   //[2 ]COD RET
					 SQL2->E2_IRRF   ,;   //[3 ]VALOR DO IRRF
					 SQL2->E2_FILIAL})    //[4 ]FILIAL
					 
		// INCREMENTA A REGUA
		IncProc(nCont++) 

		nCtMsg++ 	    
		DBSelectArea("SQL2")     
		DBSkip()

	EndDo
	
	DBCloseArea("SQL2")
	
	// INICIA REPARO DO TITULO PAI                    
	IncProc("Reparo de registros PAIS/COFINS...")

	// FUNวรO QUE REPARA TITULOS PAIS/NF - COFINS
	ReparaPAIS(aSQL2,nCont)


	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'NF'                  
	IncProc("Sele็ใo de registros PAIS/CSLL...")

	cStm := "SELECT R_E_C_N_O_ REG, E2_CODRET, E2_IRRF, E2_FILIAL "
	cStm += " FROM "+ RetSqlName("SE2") +" SE2 "
	cStm += " WHERE "
	cStm +=         " SE2.D_E_L_E_T_ <> '*' "
	cStm +=         " AND (SE2.E2_TIPO = 'NF') "// OR SE2.E2_TIPO = 'RC') "
	cStm +=         " AND SE2.E2_CSLL > 0 "
	cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
	cStm := ChangeQuery(cStm)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL3",.T.,.T.)

	DBSelectArea("SQL3")             
	While !EOF()
	  nCont++
	DBSkip()
	EndDo

	ProcRegua(nCont+nCont)   // Processo da regua                 

	DBGoTop()
	While !EOF()

		// ARRAY COM RECNO PAI 
		AADD(aSQL3, {SQL3->REG       ,;   //[1 ]RECNO
					 SQL3->E2_CODRET ,;   //[2 ]COD RET
					 SQL3->E2_IRRF   ,;   //[3 ]VALOR DO IRRF
					 SQL3->E2_FILIAL})    //[4 ]FILIAL
					 
		// INCREMENTA A REGUA
		IncProc(nCont++) 

		nCtMsg++ 	    
		DBSelectArea("SQL3")     
		DBSkip()

	EndDo
	
	DBCloseArea("SQL3")
	
	// INICIA REPARO DO TITULO PAI                    
	IncProc("Reparo de registros PAIS/CSLL...")

	// FUNวรO QUE REPARA TITULOS PAIS/NF - CSLL
	ReparaPAIS(aSQL3,nCont)


	// INICIA O PROCESSAMENTO DOS REGISTROS TIPO 'NF'                  
	IncProc("Sele็ใo de registros PAIS/IRRF...")

	cStm := "SELECT R_E_C_N_O_ REG, E2_CODRET, E2_IRRF, E2_FILIAL, E2_FORNECE, E2_LOJA, E2_NATUREZ "
	cStm += " FROM "+ RetSqlName("SE2") +" SE2 "
	cStm += " WHERE "
	cStm +=         " SE2.D_E_L_E_T_ <> '*' "
	cStm +=         " AND (SE2.E2_TIPO = 'NF') "// OR SE2.E2_TIPO = 'RC') "
	cStm +=         " AND SE2.E2_IRRF > 0 "
	cStm +=         " AND SE2.E2_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
	cStm := ChangeQuery(cStm)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cStm),"SQL4",.T.,.T.)

	DBSelectArea("SQL4")             
	While !EOF()
		nCont++
		dbSkip()
	EndDo

	ProcRegua(nCont+nCont)   // Processo da regua                 

	DBGoTop()
	While !EOF()

		cCodRetNat := Posicione("SED",1,xFilial("SED") + SQL4->E2_NATUREZ,"ED_CODREIR")
		
		// ARRAY COM RECNO PAI 
		AADD(aSQL4, {SQL4->REG        ,;   //[1 ]RECNO
					 SQL4->E2_CODRET  ,;   //[2 ]COD RET
					 SQL4->E2_IRRF    ,;   //[3 ]VALOR DO IRRF
					 SQL4->E2_FILIAL  ,;   //[4 ]FILIAL
					 cCodRetNat       })   //[5 ]COD RET NAT
					 
		// INCREMENTA A REGUA
		IncProc(nCont++) 

		nCtMsg++ 	    
		DBSelectArea("SQL4")     
		DBSkip()

	EndDo
	
	DBCloseArea("SQL4")
	
	// INICIA REPARO DO TITULO PAI                    
	IncProc("Reparo de registros PAIS/IRRF...")

	// FUNวรO QUE REPARA TITULOS PAIS/NF - IRRF
	ReparaPAIS(aSQL4,nCont)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |Aux01B    บAutor  ณJean - Solutio     บ Data ณ  30/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Inicio da execucao do programa.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReparaPAIS(aSQL,nCont)

	Local cCodRet := "    "
    
	For nX := 1 To Len(aSQL)

		DbSelectArea("SE2")  
		
		SE2->( DbGoTop() )	
		SE2->( DbGoTo( aSQL[nX][1] ) )
		
		If aSQL[nX][3] > 0 .And. Len( aSQL[nX] ) > 4
			cCodRet := aSQL[nX][5]
		EndIf

		Reclock("SE2",.F.)
			Replace SE2->E2_DIRF   With "2"			
			Replace SE2->E2_CODRET With cCodRet
		MSUnlock()         		
		
		DbCloseArea("SE2")
		
		// INCREMENTA A REGUA
		IncProc(nCont++)
	Next nX

Return