#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RECKEYNF  บAutor  ณ Cristiano Oliveira บ Data ณ 27/01/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava a chave da NF nas tabelas SF3 e SFT sem imp. a DANFE บฑฑ
ฑฑบ          ณ Filtra SF2/SF1 e pega o cod. retorno SEFAZ na tab. SPED050 บฑฑ
ฑฑบ          ณ Rotina executada via SCHEDULE - Diariamente                บฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RECKEYNF  บAutor  ณ Cristiano Oliveira บ Data ณ 17/02/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Melhoria para executar a rotina via agendamento (SCHEDULE) บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JOMHEDICA                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
      
User Function RECKEYNF()

	Local cQuery   := ""
	Local nContP   := 0
	Local nContE   := 0
	Local nContS   := 0
	Local nSeekSF3 := 0
	Local nSeekSFT := 0           

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' USER 'schedule' PASSWORD 'schedule' TABLES 'SF1,SF1,SF2,SD2,SF3,SFT,SPED054' MODULO 'FIN'
	


//=========================================================================================================================================================

	/*---------------------------------+
	| Consulta de Produtos Consignados |
	+---------------------------------*/           	      
	/*
 SELECT
 	SF1.F1_FILIAL AS FILIAL, 
 	SF1.F1_DOC AS NFISCAL, 
 	SF1.F1_SERIE AS SERIE, 
	SFT.FT_TIPOMOV AS TIPOMOV, 
	S54.NFE_CHV AS KEYNFE, 
	S54.CSTAT_SEFR AS CODRSEF,
	SFT.FT_CLIEFOR AS CLIEFOR,
	SFT.FT_LOJA AS LOJA,
	SFT.FT_ITEM AS ITEM,
	SFT.FT_PRODUTO AS PRODUTO,
	SF3.F3_ENTRADA AS ENTRADA,
	SF3.F3_CFO AS CFO,
	SF3.F3_ALIQICM AS ALIQICM
FROM 
SD1010 SD1 
	INNER JOIN 
SF1010 SF1 
	ON  SD1.D1_FILIAL = SF1.F1_FILIAL 
	AND SD1.D1_DOC = SF1.F1_DOC 
	AND SD1.D1_SERIE = SF1.F1_SERIE 
	INNER JOIN 
SF3010 SF3 
	ON  SF3.F3_FILIAL = SF1.F1_FILIAL 
	AND SF3.F3_NFISCAL = SF1.F1_DOC 
	AND SF3.F3_SERIE = SF1.F1_SERIE 
	INNER JOIN 
SFT010 SFT 
	ON  SFT.FT_FILIAL = SF1.F1_FILIAL 
	AND SFT.FT_NFISCAL = SF1.F1_DOC 
	AND SFT.FT_SERIE = SF1.F1_SERIE 
	AND SFT.FT_TIPOMOV = 'E' 
	INNER JOIN 
	SPED054 S54 
	ON S54.NFE_ID = (SF1.F1_SERIE + SF1.F1_DOC) 
	WHERE 
	   (SF1.F1_CHVNFE <> ' ' OR S54.NFE_CHV <> ' ') 
	AND SF3.F3_CHVNFE = ' ' 
	AND SFT.FT_CHVNFE = ' ' 
	AND	SF1.D_E_L_E_T_ <> '*' 
	AND SF3.D_E_L_E_T_ <> '*' 
	AND SFT.D_E_L_E_T_ <> '*' 
	AND S54.D_E_L_E_T_ <> '*' 

GROUP BY
	SF1.F1_FILIAL,
 	SF1.F1_DOC,  
 	SF1.F1_SERIE, 
	SFT.FT_TIPOMOV,
	S54.NFE_CHV,
	S54.CSTAT_SEFR,
	SFT.FT_CLIEFOR,
	SFT.FT_LOJA,
	SFT.FT_ITEM,
	SFT.FT_PRODUTO,
	SF3.F3_ENTRADA,
	SF3.F3_CFO,
	SF3.F3_ALIQICM 
		
	UNION ALL 

	SELECT 
		SF2.F2_FILIAL AS FILIAL, 
		SF2.F2_DOC AS NFISCAL, 
		SF2.F2_SERIE AS SERIE, 
		SFT.FT_TIPOMOV AS TIPOMOV, 
		S54.NFE_CHV AS KEYNFE, 
		S54.CSTAT_SEFR AS CODRSEF, 
		SFT.FT_CLIEFOR AS CLIEFOR,
		SFT.FT_LOJA AS LOJA,
		SFT.FT_ITEM AS ITEM,
		SFT.FT_PRODUTO AS PRODUTO,
		SF3.F3_ENTRADA AS ENTRADA,
		SF3.F3_CFO AS CFO,
		SF3.F3_ALIQICM AS ALIQICM
	FROM 
SD2010 SD2 
	INNER JOIN 
SF2010 SF2 
	ON  SD2.D2_FILIAL = SF2.F2_FILIAL 
	AND SD2.D2_DOC = SF2.F2_DOC 
	AND SD2.D2_SERIE = SF2.F2_SERIE 
	INNER JOIN 
SF3010 SF3 
	ON  SF3.F3_FILIAL = SF2.F2_FILIAL 
	AND SF3.F3_NFISCAL = SF2.F2_DOC 
	AND SF3.F3_SERIE = SF2.F2_SERIE 
	INNER JOIN 
SFT010 SFT 
	ON  SFT.FT_FILIAL = SF2.F2_FILIAL 
	AND SFT.FT_NFISCAL = SF2.F2_DOC 
	AND SFT.FT_SERIE = SF2.F2_SERIE 
	AND SFT.FT_TIPOMOV = 'S' 
	INNER JOIN 
		SPED054 S54 
		ON S54.NFE_ID = (SF2.F2_SERIE + SF2.F2_DOC) 
	WHERE 
	   (SF2.F2_CHVNFE <> ' ' OR S54.NFE_CHV <> ' ') 
	AND SF3.F3_CHVNFE = ' ' 
	AND SFT.FT_CHVNFE = ' ' 
	AND	SF2.D_E_L_E_T_ <> '*' 
	AND SF3.D_E_L_E_T_ <> '*' 
	AND SFT.D_E_L_E_T_ <> '*' 
	AND S54.D_E_L_E_T_ <> '*' 
	
GROUP BY
	SF2.F2_FILIAL,
 	SF2.F2_DOC,  
 	SF2.F2_SERIE, 
	SFT.FT_TIPOMOV,
	S54.NFE_CHV,
	S54.CSTAT_SEFR,
	SFT.FT_CLIEFOR,
	SFT.FT_LOJA,
	SFT.FT_ITEM,
	SFT.FT_PRODUTO,
	SF3.F3_ENTRADA,
	SF3.F3_CFO,
	SF3.F3_ALIQICM 
	*/                                      

	// ENTRADAS	
	cQuery := " SELECT " + CRLF
	cQuery += " 	SF1.F1_FILIAL AS FILIAL, " + CRLF
	cQuery += " 	SF1.F1_DOC AS NFISCAL, " + CRLF
	cQuery += " 	SF1.F1_SERIE AS SERIE, " + CRLF
	cQuery += "		SFT.FT_TIPOMOV AS TIPOMOV, " + CRLF
	cQuery += "		S54.NFE_CHV AS KEYNFE, " + CRLF
	cQuery += "		S54.CSTAT_SEFR AS CODRSEF, " + CRLF
	cQuery += "		SFT.FT_CLIEFOR AS CLIEFOR, " + CRLF
	cQuery += "		SFT.FT_LOJA AS LOJA, " + CRLF
	cQuery += "		SFT.FT_ITEM AS ITEM, " + CRLF
	cQuery += "		SFT.FT_PRODUTO AS PRODUTO, " + CRLF
	cQuery += "		SF3.F3_ENTRADA AS ENTRADA, " + CRLF
	cQuery += "		SF3.F3_CFO AS CFO, " + CRLF
	cQuery += "		SF3.F3_ALIQICM AS ALIQICM " + CRLF
	cQuery += "	FROM " + CRLF
	cQuery += 		RetSQLName("SD1") + " SD1 " + CRLF
	cQuery += "	INNER JOIN " + CRLF
	cQuery += 		RetSQLName("SF1") + " SF1 " + CRLF
	cQuery += "	ON  SD1.D1_FILIAL = SF1.F1_FILIAL " + CRLF
	cQuery += "	AND SD1.D1_DOC = SF1.F1_DOC " + CRLF
	cQuery += "	AND SD1.D1_SERIE = SF1.F1_SERIE " + CRLF
	cQuery += "	INNER JOIN " + CRLF
	cQuery += 		RetSQLName("SF3") + " SF3 " + CRLF
	cQuery += "	ON  SF3.F3_FILIAL = SF1.F1_FILIAL " + CRLF
	cQuery += "	AND SF3.F3_NFISCAL = SF1.F1_DOC " + CRLF
	cQuery += "	AND SF3.F3_SERIE = SF1.F1_SERIE " + CRLF
	cQuery += "	INNER JOIN " + CRLF
	cQuery += 		RetSQLName("SFT") + " SFT " + CRLF
	cQuery += "	ON  SFT.FT_FILIAL = SF1.F1_FILIAL " + CRLF
	cQuery += "	AND SFT.FT_NFISCAL = SF1.F1_DOC " + CRLF
	cQuery += "	AND SFT.FT_SERIE = SF1.F1_SERIE " + CRLF
	cQuery += "	AND SFT.FT_TIPOMOV = 'E' " + CRLF    
	cQuery += "	INNER JOIN " + CRLF   
	cQuery += "		SPED054 S54 " + CRLF
	cQuery += "		ON S54.NFE_ID = (SF1.F1_SERIE + SF1.F1_DOC) " + CRLF
	cQuery += "	WHERE " + CRLF
	cQuery += "	   (SF1.F1_CHVNFE <> ' ' OR S54.NFE_CHV <> ' ') " + CRLF
	cQuery += "	AND SF3.F3_CHVNFE = ' ' " + CRLF
	cQuery += "	AND SFT.FT_CHVNFE = ' ' " + CRLF     

	// COMENTAR APOS RODAR ESTE PERIODO
//	cQuery += "	AND SF1.F1_DTDIGIT >= '20170201' " + CRLF
	
//	cQuery += "	AND	SF1.D_E_L_E_T_ <> '*' " + CRLF // - AS NOTAS DELETADAS PODEM ESTAR CANCELADAS MAS CONTINUAM NOS LIVROS FISCAIS ( ! )
	cQuery += "	AND SF3.D_E_L_E_T_ <> '*' " + CRLF
	cQuery += "	AND SFT.D_E_L_E_T_ <> '*' " + CRLF
	cQuery += "	AND S54.D_E_L_E_T_ <> '*' " + CRLF     
	cQuery += "	GROUP BY " + CRLF
	cQuery += "		SF1.F1_FILIAL, " + CRLF
	cQuery += "		SF1.F1_DOC, " + CRLF  
	cQuery += "		SF1.F1_SERIE, " + CRLF 
	cQuery += "		SFT.FT_TIPOMOV, " + CRLF
	cQuery += "		S54.NFE_CHV, " + CRLF
	cQuery += "		S54.CSTAT_SEFR, " + CRLF
	cQuery += "		SFT.FT_CLIEFOR, " + CRLF
	cQuery += "		SFT.FT_LOJA, " + CRLF
	cQuery += "		SFT.FT_ITEM, " + CRLF
	cQuery += "		SFT.FT_PRODUTO, " + CRLF
	cQuery += "		SF3.F3_ENTRADA, " + CRLF
	cQuery += "		SF3.F3_CFO, " + CRLF
	cQuery += "		SF3.F3_ALIQICM  " + CRLF
		
	cQuery += "	UNION ALL " + CRLF
    
	// SAIDAS
	cQuery += "	SELECT " + CRLF
	cQuery += "		SF2.F2_FILIAL AS FILIAL, " + CRLF
	cQuery += "		SF2.F2_DOC AS NFISCAL, " + CRLF
	cQuery += "		SF2.F2_SERIE AS SERIE, " + CRLF
	cQuery += "		SFT.FT_TIPOMOV AS TIPOMOV, " + CRLF
	cQuery += "		S54.NFE_CHV AS KEYNFE, " + CRLF
	cQuery += "		S54.CSTAT_SEFR AS CODRSEF, " + CRLF
	cQuery += "		SFT.FT_CLIEFOR AS CLIEFOR, " + CRLF
	cQuery += "		SFT.FT_LOJA AS LOJA, " + CRLF
	cQuery += "		SFT.FT_ITEM AS ITEM, " + CRLF
	cQuery += "		SFT.FT_PRODUTO AS PRODUTO, " + CRLF
	cQuery += "		SF3.F3_ENTRADA AS ENTRADA, " + CRLF
	cQuery += "		SF3.F3_CFO AS CFO, " + CRLF
	cQuery += "		SF3.F3_ALIQICM AS ALIQICM " + CRLF
	cQuery += "	FROM " + CRLF
	cQuery += 		RetSQLName("SD2") + " SD2 " + CRLF
	cQuery += "	INNER JOIN " + CRLF                     
	cQuery += 		RetSQLName("SF2") + " SF2 " + CRLF
	cQuery += "	ON  SD2.D2_FILIAL = SF2.F2_FILIAL " + CRLF
	cQuery += "	AND SD2.D2_DOC = SF2.F2_DOC " + CRLF
	cQuery += "	AND SD2.D2_SERIE = SF2.F2_SERIE " + CRLF
	cQuery += "	INNER JOIN " + CRLF  
	cQuery += 		RetSQLName("SF3") + " SF3 " + CRLF
	cQuery += "	ON  SF3.F3_FILIAL = SF2.F2_FILIAL " + CRLF
	cQuery += "	AND SF3.F3_NFISCAL = SF2.F2_DOC " + CRLF
	cQuery += "	AND SF3.F3_SERIE = SF2.F2_SERIE " + CRLF
	cQuery += "	INNER JOIN " + CRLF
	cQuery += 		RetSQLName("SFT") + " SFT " + CRLF
	cQuery += "	ON  SFT.FT_FILIAL = SF2.F2_FILIAL " + CRLF
	cQuery += "	AND SFT.FT_NFISCAL = SF2.F2_DOC " + CRLF
	cQuery += "	AND SFT.FT_SERIE = SF2.F2_SERIE " + CRLF
	cQuery += "	AND SFT.FT_TIPOMOV = 'S' " + CRLF
	cQuery += "	INNER JOIN " + CRLF   
	cQuery += "		SPED054 S54 " + CRLF
	cQuery += "		ON S54.NFE_ID = (SF2.F2_SERIE + SF2.F2_DOC) " + CRLF
	cQuery += "	WHERE " + CRLF
	cQuery += "	   (SF2.F2_CHVNFE <> ' ' OR S54.NFE_CHV <> ' ') " + CRLF
	cQuery += "	AND SF3.F3_CHVNFE = ' ' " + CRLF
	cQuery += "	AND SFT.FT_CHVNFE = ' ' " + CRLF                  
	
	// COMENTAR APOS RODAR ESTE PERIODO
//	cQuery += "	AND SF2.F2_EMISSAO >= '20170201' " + CRLF
	
//	cQuery += "	AND	SF2.D_E_L_E_T_ <> '*' " + CRLF // - AS NOTAS DELETADAS PODEM ESTAR CANCELADAS MAS CONTINUAM NOS LIVROS FISCAIS ( ! )
	cQuery += "	AND SF3.D_E_L_E_T_ <> '*' " + CRLF
	cQuery += "	AND SFT.D_E_L_E_T_ <> '*' " + CRLF
	cQuery += "	AND S54.D_E_L_E_T_ <> '*' " + CRLF
	cQuery += "	GROUP BY " + CRLF
	cQuery += "	SF2.F2_FILIAL, " + CRLF
	cQuery += "	SF2.F2_DOC, " + CRLF  
	cQuery += "	SF2.F2_SERIE, " + CRLF 
	cQuery += "	SFT.FT_TIPOMOV, " + CRLF
	cQuery += "	S54.NFE_CHV, " + CRLF
	cQuery += "	S54.CSTAT_SEFR, " + CRLF
	cQuery += "	SFT.FT_CLIEFOR, " + CRLF
	cQuery += "	SFT.FT_LOJA, " + CRLF
	cQuery += "	SFT.FT_ITEM, " + CRLF
	cQuery += "	SFT.FT_PRODUTO, " + CRLF
	cQuery += "	SF3.F3_ENTRADA, " + CRLF
	cQuery += "	SF3.F3_CFO, " + CRLF
	cQuery += "	SF3.F3_ALIQICM  " + CRLF
		
    MemoWrite("\cprova\reckeynf_sql.txt", cQuery)
                            
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)
	
	While TMP->(!EOF())
		
		nContP += 1
			
		/*-----------------+
		| Gravacao da SF3  |
		+-----------------*/
		DbSelectArea("SF3")
		DbSetOrder(1) // FILIAL + DTOS(ENTRADA) + NFISCAL + SERIE + CLIEFOR + LOJA + CFO + STR(ALIQICM, 5, 2)
//	    If DbSeek(TMP->FILIAL + TMP->NFISCAL + TMP->SERIE)			
		If DbSeek(TMP->FILIAL + TMP->ENTRADA + TMP->NFISCAL + TMP->SERIE + TMP->CLIEFOR + TMP->LOJA + TMP->CFO + STR(TMP->ALIQICM, 5, 2))			
         
			If TMP->CODRSEF == '102'
				RecLock("SF3", .F.)
				SF3->F3_CHVNFE  := ""
				SF3->F3_CODRSEF := TMP->CODRSEF 
				MsUnlock()
			Else
				RecLock("SF3", .F.)
				SF3->F3_CHVNFE  := TMP->KEYNFE
				SF3->F3_CODRSEF := TMP->CODRSEF 
				MsUnlock()
			EndIf
				              
			nSeekSF3 += 1                                                         
		EndIf
					     
		/*-----------------+
		| Gravacao da SFT  |
		+-----------------*/
  		DbSelectArea("SFT")
		DbSetOrder(1) // FILIAL + TIPOMOV  + SERIE + NFISCAL + CLIEFOR + LOJA + ITEM + PRODUTO
//	    If DbSeek(TMP->FILIAL + TMP->TIPOMOV + TMP->NFISCAL + TMP->SERIE)			
		If DbSeek(TMP->FILIAL + TMP->TIPOMOV  + TMP->SERIE + TMP->NFISCAL + TMP->CLIEFOR + TMP->LOJA + TMP->ITEM + TMP->PRODUTO)			
			
			If TMP->CODRSEF == '102'
				RecLock("SFT", .F.)
				SFT->FT_CHVNFE  := ""
				MsUnlock()         
			Else
				RecLock("SFT", .F.)
				SFT->FT_CHVNFE  := TMP->KEYNFE
				MsUnlock()         
			EndIf
          
			nSeekSFT += 1
		EndIf
	
		/*-----------------+
		| Contagem Ent/Sai |
		+-----------------*/
		If TMP->TIPOMOV = "E" 
			nContE += 1
		ElseIf TMP->TIPOMOV = "S"
			nContS += 1
		EndIf
							
		dbSelectArea("TMP")
		dbSkip()
		
	EndDo
	TMP->(dbCloseArea()) 
	
	cMsgES := "PROCESSADOS: " + cValToChar(nContP) + " | ENTRADAS:" + cValToChar(nContE) + " | SAอDAS: " + cValToChar(nContS)
  	cLogSC := "SF3: " + cValToChar(nSeekSF3) + " | SFT:" + cValToChar(nSeekSFT)
    
    MemoWrite("\cprova\reckeynf_" + DTOS(dDataBase) + SUBSTR(TIME(),1,2) + SUBSTR(TIME(),4,2)+ SUBSTR(TIME(),7,2) + ".txt", cMsgES + CRLF + cLogSC)
    
    // REMOVER DEPOIS DO TESTE
//  MSGINFO(cMsgES + CRLF + cLogSC)
                     
//=========================================================================================================================================================
                                                                                                                   
    RESET ENVIRONMENT
    
Return


/*
  
Jean Herrmann - SOLUTIO IT - Preencher Chave em Notas s๓ com 1 item gravado - 17/02/2017

Local cArea := ""
Local cChave := ""
Local cLog := ""

cQuery := "SELECT F1_CHVNFE, F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO, "
cQuery += "(SELECT TOP 1 F3_CHVNFE FROM SF3010 WHERE F3_NFISCAL = F1_DOC AND F3_SERIE = F1_SERIE AND D_E_L_E_T_ = ' ') F3_CHVNFE, "
cQuery += "(SELECT TOP 1 FT_CHVNFE FROM SFT010 WHERE FT_NFISCAL = F1_DOC AND FT_SERIE = F1_SERIE AND D_E_L_E_T_ = ' ') FT_CHVNFE  "
cQuery += "FROM SF1010 "
cQuery += "WHERE F1_ESPECIE = 'SPED' "
cQuery += "  AND F1_CHVNFE = ' ' "
cQuery += "  AND F1_FORMUL = 'S' "
cQuery += "  AND F1_STATUS <> ' ' "
cQuery += "  AND F1_SERIE = '1  ' "
cQuery += "  AND F1_DTDIGIT BETWEEN '20170101' AND '20170131' "
cQuery += "  AND D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), (cArea := GetNextAlias()), .F., .T.)
	              
While !(cArea)->(Eof())
	
	If !Empty( (cArea)->F3_CHVNFE )
		cChave := AllTrim( (cArea)->F3_CHVNFE )
	ElseIf !Empty( (cArea)->FT_CHVNFE )
		cChave := AllTrim( (cArea)->FT_CHVNFE )
	Else
		cChave := ""
	EndIf
	
	If !Empty( cChave )                                                   

		dbSelectArea("SF1")
		dbSetOrder(1)
		If dbSeek( (cArea)->F1_FILIAL + (cArea)->F1_DOC + (cArea)->F1_SERIE + (cArea)->F1_FORNECE + (cArea)->F1_LOJA + (cArea)->F1_TIPO )
			If Empty( SF1->F1_CHVNFE )
				RecLock("SF1",.F.)
					SF1->F1_CHVNFE := cChave
					cLog += "SF1" +"|"+ cValToChar(SF1->( Recno() ) ) +"|"+ SF1->F1_DOC +"|"+ SF1->F1_SERIE +"|"+ SF1->F1_FORNECE +"|"+ SF1->F1_LOJA +"|"+ SF1->F1_CHVNFE + CHR(13)
				SF1->( MsUnLock() )
			EndIf
		EndIf
		
		dbSelectArea("SF3")
		dbSetOrder(6)
		If dbSeek( (cArea)->F1_FILIAL + (cArea)->F1_DOC + (cArea)->F1_SERIE )
			While !SF3->( Eof() ) .And. (cArea)->F1_FILIAL + (cArea)->F1_DOC + (cArea)->F1_SERIE == SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE
				If Empty( SF3->F3_CHVNFE )
					RecLock("SF3",.F.)
						SF3->F3_CHVNFE := cChave
						cLog += "SF3" +"|"+ cValToChar(SF3->( Recno() ) ) +"|"+ SF3->F3_NFISCAL +"|"+ SF3->F3_SERIE +"|"+ SF3->F3_CHVNFE + CHR(13)					
					SF3->( MsUnLock() )
				EndIf
				SF3->( dbSkip() )
			End
		EndIf

		dbSelectArea("SFT")
		dbSetOrder(6)
		If dbSeek( (cArea)->F1_FILIAL + "E" + (cArea)->F1_DOC + (cArea)->F1_SERIE )
			While !SFT->( Eof() ) .And. (cArea)->F1_FILIAL + "E" + (cArea)->F1_DOC + (cArea)->F1_SERIE == SFT->FT_FILIAL + "E" +  SFT->FT_NFISCAL + SFT->FT_SERIE
				If Empty( SFT->FT_CHVNFE )
					RecLock("SFT",.F.)
						SFT->FT_CHVNFE := cChave
						cLog += "SFT" +"|"+ cValToChar(SFT->( Recno() ) ) +"|"+ SFT->FT_NFISCAL +"|"+ SFT->FT_SERIE +"|"+ SFT->FT_CHVNFE + CHR(13)					
					SFT->( MsUnLock() )
				EndIf
				SFT->( dbSkip() )
			End
		EndIf

	EndIf	
	
	(cArea)->(dbSkip())
End
MemoWrite("C:\temp\log_chave_notas.txt", cLog)
(cArea)->(dbCloseArea())

*/