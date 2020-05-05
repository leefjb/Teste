#Include 'Protheus.ch'
#Include "TOTVS.CH"
#Include "TBICONN.CH"
#include 'Fileio.ch'

/*/{Protheus.doc} RECKEYNF

Grava a chave da NF nas tabelas SF3 e SFT sem imp. a DANFE
Filtra SF2/SF1 e pega o cod. retorno SEFAZ na tab. SPED050
Rotina executada via SCHEDULE - Diariamente

17/02/2017
Cristiano Oliveira 
Melhoria para executar a rotina via agendamento (SCHEDULE)

05/12/2018
Mauro Silva
Alteracoes a partir de 05/12/18. Para atender tarefa #21672.

@type function
@author Cristiano Oliveira
@since 27/01/2017
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function RECKEYNF()

	Local cQuery	:= ""
	Local nContP	:= 0
	Local nContE	:= 0
	Local nContS	:= 0
	Local nSeekSF3	:= 0
	Local nSeekSFT	:= 0

	Local nCont		:= 0
	Local _cEmp_	:= ""
	Local _cFil_	:= ""

	Local _cDir		:= "\RECKEYNF"
	Local _cTmp		:= ""
	Local _cLog		:= ""
	Local nHdlLog	:= 0
	Local nRet		:= 0

	ConOut(">>>>>> Execucao do programa RECKEYNF. " +  Time() )
	
	// Verifica a existencia do diretorio de log da rotina.
	Conout("Verifica a existencia do diretorio de log da rotina.")
	If !ExistDir(_cDir)
		Conout("Nao existe diretorio. Sera tentada a criacao.")
		nRet := MakeDir(_cDir)
		If nRet != 0
			Conout( ">>> "+ Time() + "Nao foi possivel criar o diretorio '"+_cDir+"'. Erro: " + cValToChar( FError() ) )
			Return()
		EndIf
		Conout("Diretorio criado.")
	Else
	
		Conout("Diretorio ja existe")
	EndIf

	For nCont := 1 To 2
	
		If nCont == 1
			_cEmp_	:= "01"
			_cFil_	:= "01"
		Else
			_cEmp_	:= "06"
			_cFil_	:= "01"
		EndIf
	
		// Nome do arquivo de log. Mauro - Solutio. 07/12/2018.		
		_cNome := "\Emp"+ _cEmp_ + _cFil_ + "_"+StrTran(Time(),":","") +".log"
		
		Conout("Tentando criar aquivo de log.")
		
		nHdlLog := fCreate(_cDir+_cNome)
		
		If nHdlLog >= 0
			Conout("Criacao do arquivo " + _cNome)
		Else
			Conout("Erro na criacao do arquivo." + cValToChar( FError() ))
			Return()
		EndIf
	
		// Posiciona a empresa 01, ou 06.	
		//RPCSETTYPE(3)
		//PREPARE ENVIRONMENT EMPRESA _cEmp_ FILIAL _cFil_
		WFPrepENV( _cEmp_, _cFil_)
		
		_cLog += ">>>>>>   Preparando consultas empresa "+ _cEmp_ +" ... " + Time() + CRLF
		Conout(">>>>>>   Preparando consultas empresa "+ _cEmp_ +" ... " + Time() )		
		Conout("")
		Conout("")
	
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
		
		// Abaixo, informar o banco TSS, da base que estiver rodando. Mauro - Solutio. 07/12/2018.
		cQuery += " SRVRSPOABD01.DBTSS.dbo.SPED054 S54 " + CRLF
		//cQuery += " SRVRSPOAAPP02.DBTSSDEV.dbo.SPED054 S54 " + CRLF

		cQuery += "		ON S54.NFE_ID = (SF1.F1_SERIE + SF1.F1_DOC) " + CRLF
		cQuery += "	WHERE " + CRLF
		cQuery += "	   (SF1.F1_CHVNFE <> ' ' OR S54.NFE_CHV <> ' ') " + CRLF
		cQuery += "	AND SF3.F3_CHVNFE = ' ' " + CRLF
		cQuery += "	AND SFT.FT_CHVNFE = ' ' " + CRLF
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
		
		// Abaixo, informar o banco do TSS, da base que estiver rodando. Mauro - Solutio. 07/12/2018.
		cQuery += " SRVRSPOABD01.DBTSS.dbo.SPED054 S54 " + CRLF
		//cQuery += " SRVRSPOAAPP02.DBTSSDEV.dbo.SPED054 S54 " + CRLF
	
		cQuery += "		ON S54.NFE_ID = (SF2.F2_SERIE + SF2.F2_DOC) " + CRLF
		cQuery += "	WHERE " + CRLF
		cQuery += "	   (SF2.F2_CHVNFE <> ' ' OR S54.NFE_CHV <> ' ') " + CRLF
		cQuery += "	AND SF3.F3_CHVNFE = ' ' " + CRLF
		cQuery += "	AND SFT.FT_CHVNFE = ' ' " + CRLF
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

		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

		_cLog += ">>>>>>   Realizada consulta. Iniciando gravacoes ... " + CRLF
		Conout(">>>>>>   Realizada consulta. Iniciando gravacoes ... ")
		Conout("")
                      
		_cLog += ">>>>>>   Abrindo arquivo temporario ... " + CRLF
		Conout(">>>>>>   Abrindo arquivo temporario ... ")
		Conout("")

		Do While TMP->(!EOF())

			//nContP += 1

		/*-----------------+
		| Gravacao da SF3  |
		+-----------------*/
			DbSelectArea("SF3")
			DbSetOrder(1) // FILIAL + DTOS(ENTRADA) + NFISCAL + SERIE + CLIEFOR + LOJA + CFO + STR(ALIQICM, 5, 2)
			If DbSeek(TMP->FILIAL + TMP->ENTRADA + TMP->NFISCAL + TMP->SERIE + TMP->CLIEFOR + TMP->LOJA + TMP->CFO + STR(TMP->ALIQICM, 5, 2))
                
				_cLog += "Gravando NF "+TMP->NFISCAL+" na tabela SF3 ... CODRSEF = " + TMP->CODRSEF + CRLF
				Conout("Gravando NF "+TMP->NFISCAL+" na tabela SF3 ... CODRSEF = " + TMP->CODRSEF)
				
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

				//nSeekSF3 += 1
			EndIf

		/*-----------------+
		| Gravacao da SFT  |
		+-----------------*/
			DbSelectArea("SFT")
			DbSetOrder(1) // FILIAL + TIPOMOV  + SERIE + NFISCAL + CLIEFOR + LOJA + ITEM + PRODUTO
			If DbSeek(TMP->FILIAL + TMP->TIPOMOV  + TMP->SERIE + TMP->NFISCAL + TMP->CLIEFOR + TMP->LOJA + TMP->ITEM + TMP->PRODUTO)

				_cLog += "Gravando NF "+TMP->NFISCAL+" na tabela SFT... CODRSEF = " + TMP->CODRSEF + CRLF
				Conout("Gravando NF "+TMP->NFISCAL+" na tabela SFT... CODRSEF = " + TMP->CODRSEF)
				
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
			/*
			If TMP->TIPOMOV = "E"
				nContE += 1
			ElseIf TMP->TIPOMOV = "S"
				nContS += 1
			EndIf
			*/

			dbSelectArea("TMP")
			dbSkip()

		EndDo
		TMP->(dbCloseArea())
		
		_cLog += ">>>>>>   Encerrando arquivo temporario ... " + CRLF
		Conout(">>>>>>   Encerrando arquivo temporario ... ")
		Conout("")

		_cLog += ">>>>>> Processo empresa "+_cEmp_+", finalizado ... " + Time() + CRLF
		Conout(">>>>>> Processo empresa "+_cEmp_+", finalizado ... " + Time() )
		
		Conout("")
		Conout("")
	
		RESET ENVIRONMENT
		
		fWrite(nHdlLog, _cLog )
	
		If !fClose(nHdlLog)
			conout( "Erro ao fechar arquivo, erro numero: ", FERROR() )
		EndIf

	Next nCont

Return()