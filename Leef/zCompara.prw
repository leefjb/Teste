//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} zCompara
Comparação de campos do Dicionário x SQL Server
@author Atilio
@since 02/08/2016
@version 1.0
	@example
	u_zCompara()
/*/

User Function zCompara()
	Local aArea		:= GetArea()
	Local aAreaX2		:= SX2->(GetArea())
	Local aAreaX3		:= SX3->(GetArea())
	Local oReport
	Private cPerg		:= "X_ZCOMPARA"
	Private cAliasDe	:= ""
	Private cAliasAt	:= ""
	Private nTipo		:= 0

	//Enquanto a pergunta for confirmada, define as propriedades do Report e imprime
	fVldPerg(cPerg)
	While Pergunte(cPerg,.T.)
		cAliasDe := MV_PAR01
		cAliasAt := MV_PAR02
		nTipo    := MV_PAR03
		
		//Definindo atributos e propriedades e gerando relatório TReport
		oReport := fReportDef()
		oReport:PrintDialog()
	EndDo
	
	RestArea(aAreaX3)
	RestArea(aAreaX2)
	RestArea(aArea)
Return

/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Autor: Daniel Atilio                                                          |
 | Data:  02/08/2016                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/

Static Function fReportDef()
	Local oReport
	Local oSectPar := nil
	Local oSectCom := nil

	//Criação do componente de impressão
	oReport := TReport():New(	"zCompara",;														//Nome do Relatório
									"Compara��o Dicion�rio x SQL",;									//Título
									,;																	//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
									{|oReport| fRepPrint(oReport)},;								//Bloco de código que será executado na confirmação da impressão
									)																	//Descrição
	oReport:SetLandscape(.T.)   //Define a orientação de página do relatório como paisagem  ou retrato. .F.=Retrato; .T.=Paisagem
	oReport:SetTotalInLine(.F.) //Define se os totalizadores serão impressos em linha ou coluna
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	
	//*******************
	// PARÂMETROS
	//*******************
	
	//Criando a seção de parâmetros e as células
	oSectPar := TRSection():New(	oReport,;				//Objeto TReport que a seção pertence
										"Par�metros",;		//Descrição da seção
										{""})					//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectPar:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Células da seção parâmetros
	TRCell():New(		oSectPar,"PARAM"			,"   ","Par�metro",	"@!"       ,         30,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(		oSectPar,"CONTEUDO"		,"   ","Conte�do",	"@!"       ,         30,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	//*******************
	// Comparacao
	//*******************
	
	//Criando a seção de dados e as células
	oSectCom := TRSection():New(	oReport,;					//Objeto TReport que a seção pertence
										"Comparacao",;			//Descrição da seção
										{""})						//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectCom:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(	oSectCom,"XX_ALISQL"		,"","Alias SQL"		,/*Picture*/, 06,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(	oSectCom,"XX_ALIPRO"		,"","Alias Protheus"	,/*Picture*/, 03,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(	oSectCom,"XX_CAMSQL"		,"","Campo"			,/*Picture*/, 10,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(	oSectCom,"XX_TIPSQL"		,"","Tip.SQL"			,/*Picture*/, 15,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(	oSectCom,"XX_TIPPRO"		,"","Tip.Protheus"	,/*Picture*/, 15,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(	oSectCom,"XX_TAMSQL"		,"","Tam.SQL"			,/*Picture*/, 03,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(	oSectCom,"XX_TAMPRO"		,"","Tam.Protheus"	,/*Picture*/, 03,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(	oSectCom,"XX_STATUS"		,"","Status"			,/*Picture*/, 10,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,RGB(255,000,000)/*nClrFore*/,/*lBold*/)
	TRCell():New(	oSectCom,"XX_OBSERV"		,"","Observacao"		,/*Picture*/, 99,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	//Acrescentando totalizador nos dados
	oFunTot := TRFunction():New(oSectCom:Cell("XX_ALISQL"),,"COUNT",,,"@E 99999999999")
	oFunTot := TRFunction():New(oSectCom:Cell("XX_ALIPRO"),,"COUNT",,,"@E 99999999999")
	oFunTot:SetEndReport(.F.)	//Define se será impresso o total também ao finalizar o relatório (Total Geral)

Return oReport

/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Autor: Daniel Atilio                                                          |
 | Data:  02/08/2016                                                             |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/

Static Function fRepPrint(oReport)
	Local cQryCom := ""
	Local oSecPar := Nil
	Local oSecCom := Nil
	Local cAliasSQL := ""
	Local cAliasPro := ""
	Local cCampoSQL := ""
	Local cTipoSQL  := ""
	Local cTipoPro  := ""
	Local xTamanSQL := ""
	Local xTamanPro := ""
	Local cStatus   := ""
	Local cObserv   := ""
	
	DbSelectArea("SX2")
	SX2->(DbSetOrder(1)) //X2_CHAVE
	SX2->(DbGoTop())
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2)) //X3_CAMPO
	SX3->(DbGoTop())
	
	//Pegando as seções do relatório
	oSecPar := oReport:Section(1)
	oSecCom := oReport:Section(2)

	//Setando os conteúdos da seção de parâmetros
	oSecPar:Init()
	oSecPar:Cell("PARAM"):SetValue("Alias De?")
	oSecPar:Cell("CONTEUDO"):SetValue(cAliasDe)
	oSecPar:PrintLine()
	oSecPar:Cell("PARAM"):SetValue("Alias At�?")
	oSecPar:Cell("CONTEUDO"):SetValue(cAliasAt)
	oSecPar:PrintLine()
	oSecPar:Cell("PARAM"):SetValue("Tipo?")
	oSecPar:Cell("CONTEUDO"):SetValue(Iif(nTipo==1, "Ambos", Iif(nTipo==2, "Diferentes", "Iguais")))
	oSecPar:PrintLine()
	oSecPar:Finish()

	//Montando consulta de dados dos Comparacao
	cQryCom := " SELECT DISTINCT "															+STR_PULA
	cQryCom += " 	tab.name AS TABELA, "													+STR_PULA
	cQryCom += "     colunas.name AS COLUNA, "											+STR_PULA
	cQryCom += "     tipos.Name AS TIPO, "													+STR_PULA
	cQryCom += "     colunas.max_length AS TAM_MAX "										+STR_PULA
	cQryCom += " FROM "																		+STR_PULA
	cQryCom += " 	sys.tables tab "															+STR_PULA
	cQryCom += "  INNER JOIN sys.columns colunas ON ( "									+STR_PULA
	cQryCom += " 		tab.object_id = colunas.object_id "								+STR_PULA
	cQryCom += " 		AND colunas.name NOT IN ('D_E_L_E_T_', 'R_E_C_N_O_', 'R_E_C_D_E_L_') "	+STR_PULA
	cQryCom += " 	) "																			+STR_PULA
	cQryCom += " 	INNER JOIN sys.types tipos ON ( "										+STR_PULA
	cQryCom += " 		colunas.user_type_id = tipos.user_type_id "						+STR_PULA
	cQryCom += " 	) "																			+STR_PULA
	cQryCom += " 	LEFT OUTER JOIN sys.index_columns indices_colunas ON ( "			+STR_PULA
	cQryCom += " 		indices_colunas.object_id = colunas.object_id "					+STR_PULA
	cQryCom += " 		AND indices_colunas.column_id = colunas.column_id "				+STR_PULA
	cQryCom += " 	) "																			+STR_PULA
	cQryCom += " 	LEFT OUTER JOIN sys.indexes indices ON ( "							+STR_PULA
	cQryCom += " 		indices_colunas.object_id = indices.object_id "					+STR_PULA
	cQryCom += " 		AND indices_colunas.index_id = indices.index_id "				+STR_PULA
	cQryCom += " 	) "																			+STR_PULA
	cQryCom += " WHERE "																		+STR_PULA
	cQryCom += " 	tab.name >= '"+cAliasDe+cEmpAnt+"0' "									+STR_PULA
	cQryCom += " 	AND tab.name <= '"+cAliasAt+cEmpAnt+"0' "								+STR_PULA
	cQryCom += " 	AND tab.name NOT IN ('SCHDTSK', 'SX2"+cEmpAnt+"0') "					+STR_PULA
	cQryCom += " 	AND tab.name NOT LIKE 'XX%' "											+STR_PULA
	cQryCom += " 	AND tab.name NOT LIKE '%_SP%' "											+STR_PULA
	cQryCom += " 	AND tab.name NOT LIKE 'TOP%' "											+STR_PULA
	cQryCom += " ORDER BY "																	+STR_PULA
	cQryCom += " 	TABELA, COLUNA "															+STR_PULA

	//Executando consulta e setando o total da régua
	TCQuery cQryCom New Alias "QRY_COM"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSecCom:Init()
	QRY_COM->(DbGoTop())
	cTabAtual:=""
	nTabAtual:=0
	While ! QRY_COM->(Eof())
		cAliasSQL := QRY_COM->TABELA
		cAliasPro := ""
		cCampoSQL := QRY_COM->COLUNA
		cTipoSQL  := QRY_COM->TIPO
		cTipoPro  := ""
		xTamanSQL := QRY_COM->TAM_MAX
		xTamanPro := 0
		cStatus   := "IGUAL"
		cObserv   := ""
		// Assis Leef - 11/03/2020 - Rotina para busca o Numero de Campos no SQL 
		if 	cTabAtual<>SubStr(QRY_COM->TABELA, 1, 3)
		    if cTabAtual>0
		       
		    endif 
			cTabAtual:= SubStr(QRY_COM->TABELA, 1, 3)
			cQuery := "SELECT COUNT (*)  AS N_CAMPO FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '" + RetSqlName('SA1') + "'"
			TcQuery cQuery New Alias "QRYSQL"
			dbSelectArea("QRYSQL")
			nTabAtual:=QRYSQL->N_CAMPO
			QRYSQL->(DbCloseArea())
	    endif
		// FINAL - Assis Leef - 11/03/2020 - Rotina para busca o Numero de Campos no SQL 
		
		//Se conseguir posicionar na tabela
		If SX2->(DbSeek(SubStr(QRY_COM->TABELA, 1, 3)))
			cAliasPro := SX2->X2_CHAVE
		Else
			cStatus := "DIFERENTE"
			cObserv += "Tabela inexistente no Protheus; "
		EndIf
		
		//Se conseguir posicionar na coluna
		If SX3->(DbSeek(QRY_COM->COLUNA))
			cTipoPro  := SX3->X3_TIPO
			xTamanPro := SX3->X3_TAMANHO
			
			//Comparação de Tamanho
			If xTamanPro != xTamanSQL
				If 	!(Alltrim(Upper(cTipoSQL)) == 'FLOAT' .And. xTamanSQL == 8) .And.;
					!(Alltrim(Upper(cTipoSQL)) == 'IMAGE' .And. xTamanSQL == 16 .And. xTamanPro == 10)
					cStatus := "DIFERENTE"
					cObserv += "Tamanho diferente Protheus x SQL; "
				EndIf
			EndIf
			
			//Comparação de Tipo
			If 	(cTipoPro $ ('C;D') .And. Alltrim(Upper(cTipoSQL)) != 'VARCHAR') .Or.;
				(cTipoPro $ ('N') .And. Alltrim(Upper(cTipoSQL)) != 'FLOAT') .Or.;
				(cTipoPro $ ('M') .And. Alltrim(Upper(cTipoSQL)) != 'IMAGE')
				cStatus := "DIFERENTE"
				cObserv += "Tipo diferente Protheus x SQL; "
			EndIf
			
		Else
			cStatus := "DIFERENTE"
			cObserv += "Campo inexistente no Protheus; "
		EndIf
		
		//Transformando os números
		xTamanSQL := Transform(xTamanSQL, "@E 999")
		xTamanPro := Transform(xTamanPro, "@E 999")
		
		//Se não tiver na filtragem, pula a impressão
		If (nTipo == 2 .And. cStatus == "IGUAL") .Or. (nTipo == 3 .And. cStatus == "DIFERENTE")
			oReport:IncMeter()
			QRY_COM->(DbSkip())
			Loop
		EndIf
		
		//Imprimindo
		oSecCom:Cell("XX_ALISQL"):SetValue(cAliasSQL)
		oSecCom:Cell("XX_ALIPRO"):SetValue(cAliasPro)
		oSecCom:Cell("XX_CAMSQL"):SetValue(cCampoSQL)
		oSecCom:Cell("XX_TIPSQL"):SetValue(cTipoSQL)
		oSecCom:Cell("XX_TIPPRO"):SetValue(cTipoPro)
		oSecCom:Cell("XX_TAMSQL"):SetValue(xTamanSQL)
		oSecCom:Cell("XX_TAMPRO"):SetValue(xTamanPro)
		oSecCom:Cell("XX_STATUS"):SetValue(cStatus)
		oSecCom:Cell("XX_OBSERV"):SetValue(cObserv)
		oSecCom:PrintLine()
		
		//Incrementando contador
		oReport:IncMeter()
		QRY_COM->(DbSkip())
	EndDo
	
	//Finalizando a seção de dados
	oSecCom:Finish()	
	QRY_COM->(DbCloseArea())
Return

/*---------------------------------------------------------------------*
 | Func:  fVldPerg                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  02/08/2016                                                   |
 | Desc:  Função para criar o grupo de perguntas                       |
 *---------------------------------------------------------------------*/

Static Function fVldPerg(cPerg)
	//(	  cGrupo,     cOrdem,	         cPergunt,cPergSpa,		  cPergEng,             cVar, cTipo,nTamanho,	 nDecimal,    nPreSel,         cGSC,cValid,        cF3,cGrpSXG,	     cPyme,	        cVar01,	cDef01,	cDefSpa1,cDefEng1,	cCnt01,      cDef02,cDefSpa2, cDefEng2, 	cDef03,cDefSpa3,cDefEng3,	cDef04,cDefSpa4,	cDefEng4,	cDef05,	cDefSpa5,	cDefEng5,	aHelpPor,	aHelpEng,	aHelpSpa,	cHelp)
//	PutSx1(cPerg,		"01",		"Alias De?",		"",				"",			"mv_ch0",	"C", 	 003,			0,			0,			"G",	"", 		"",		"",			"",		"mv_par01", 	"",		  "",      "",		"",		     "",	  "",		"",			"", 	 "",	  "",		"",      "",			"",			"",			"",			"",			{},			{},			{},			"")
//	PutSx1(cPerg,		"02",		"Alias Até?",		"",				"",			"mv_ch1",	"C",     003,			0,			0,			"G",	"", 		"",		"",			"",		"mv_par02", 	"",	      "",	   "",		"",          "",      "",		"",			"",	 	 "",	  "",		"",		 "",			"",			"",			"",			"",			{},			{},			{},			"")
//	PutSx1(cPerg,		"03",		"Tipo?",			"",				"",			"mv_ch2",	"N",	 001,			0,			0,			"C",	"", 		"",		"",			"",		"mv_par03","Ambos",	      "",	   "",		"","Diferentes",	  "",		"",	  "Iguais",	     "",	  "",		"",		 "",			"",			"",			"",			"",			{},			{},			{},			"")
   dbSelectArea('SX1')
   If !DbSeek(cPerg+'01')
      RecLock("SX1",.T.)
      Replace X1_GRUPO   With cPerg                ,;
      X1_ORDEM   With "01"                    ,;
      X1_PERGUNT With "Alias de " ,;
      X1_VARIAVL With "mv_ch0"                ,;
      X1_TIPO    With "C"                     ,;
      X1_TAMANHO With 3                      ,;
      X1_VAR01   With "MV_PAR01"              ,;
      X1_GSC     With "G"
      MsUnlock()
   endif   
   If !DbSeek(cPerg+'02')
      RecLock("SX1",.T.)
      Replace X1_GRUPO   With cPerg                ,;
      X1_ORDEM   With "02"                    ,;
      X1_PERGUNT With "Alias ate" ,;
      X1_VARIAVL With "mv_ch1"                ,;
      X1_TIPO    With "C"                     ,;
      X1_TAMANHO With 3                      ,;
      X1_VAR01   With "MV_PAR02"              ,;
      X1_GSC     With "G"
      MsUnlock()
   Endif

   If !DbSeek(cPerg+'03')
      RecLock("SX1",.T.)
      Replace X1_GRUPO   With cPerg           ,;
      X1_ORDEM   With "03"                    ,;
      X1_PERGUNT With "Tipo Filtro"    ,;
      X1_VARIAVL With "mv_ch2"                ,;
      X1_TIPO    With "N"                     ,;
      X1_TAMANHO With 1                       ,;
      X1_VAR01   With "MV_PAR03"              ,;
      X1_GSC     With "G"                     ,;
      X1_DEF01   With "Ambos"                 ,;
      X1_DEF02   With "Diferentes"            ,;
      X1_DEF03   With "Iguais"                
      MsUnlock()
   EndIf

Return
