#INCLUDE "protheus.ch"

/*/
Jean Rehermann | SOLUTIO IT  - 02/09/2016 - Comissões por item de venda
---------------------------------------------------------------------------------------------
Tabela onde ficam gravadas as comissões com os valores utilizados em tempo de processamento
para o cálculo de cada item das notas de venda geradoras do títulos baixados que geraram
comissão no E3
/*/

User Function JMHA211

	Private cString   := "SZE"
	Private cCadastro := "Comissões por Item"
	Private aRotina := {{ "Pesquisar" ,"AxPesqui"  , 0, 1 } ,;
						{ "Visualizar","AxVisual"  , 0, 2 } ,;
						{ "Alterar"   ,"AxAltera"  , 0, 4 } ,;
						{ "Relatório" ,"U_JMHA211R", 0, 2 } ,;
						{ "Auditoria" ,"U_JMHA211A", 0, 2 } ,;
						{ "Sanear"    ,"U_JMHA211S", 0, 2 }  ;
						}

	dbSelectArea("SZE")
	dbSetOrder(1)

	dbSelectArea( cString )
	mBrowse( 6, 1, 22, 75, cString )

Return

// Função de saneamento - Utilizado para limpar os dados não necessários da tabela
User Function JMHA211S

	Local cPerg  := "JMHA211S"
	Local cQuery := ""
	Local aP     := {}
	Local cSave  := ""
	
	aAdd( aP, { "Vendedor De  ?","C",6,0,"G","","SA3","","","","","" } )
	aAdd( aP, { "Vendedor Ate ?","C",6,0,"G","","SA3","","","","","" } )
	aAdd( aP, { "Data de      ?","D",8,0,"G","","   ","","","","","" } )
	aAdd( aP, { "Data Ate     ?","D",8,0,"G","","   ","","","","","" } )

	J211PERG( cPerg, aP )
	If !Pergunte( cPerg )
		Return
	EndIf
	
	cQuery := "DELETE FROM "+ RetSqlName("SZE")
	cQuery += " WHERE ZE_VEND  BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' "
	cQuery += " AND ZE_DEMISE3 BETWEEN '"+ DtoS( mv_par03 ) +"' AND '"+ DtoS( mv_par04 ) +"' "
	cQuery += " AND ZE_FILIAL = '"+ xFilial("SZE") +"' "
	
	cQuery := ChangeQuery( cQuery )
	
	If MsgYesNo("Esta rotina irá apagar os registros desta tabela que corresponderem aos parâmetros informados. Continuar?")
		TcSqlExec( cQuery )
		cSave := "\CPROVA\JMHA211_DELETE_"+ Dtos( Date() ) +"_"+ StrTran( Time(), ":", "" ) +".sql"
		MemoWrite( cSave, cQuery )
		MsgAlert("Execução concluída!")
	EndIf
	
Return

// Função de Auditoria - Utilizado para gerar os dados para a auditoria podendo ser relatório ou exportação Excel
User Function JMHA211A

	Local cPerg   := "JMHA211E"
	Local cQuery  := ""
	Local cAlias  := ""
	Local cCampos := "ZE_VEND,ZE_GRUPO,ZE_CODFAIX,ZE_TPFAIXA,ZE_DESCF,ZE_QTDPARC,ZE_CLIENTE,ZE_LOJA,ZE_E3PREFI,ZE_E3NUM,ZE_E3PARC,ZE_E3TIPO,ZE_E3SEQ,ZE_E1PREFI,ZE_E1NUM,ZE_E1PARC,ZE_E1TIPO,ZE_BASENF,ZE_COMISNF,ZE_PERCNF,ZE_DEMISE1,ZE_DEMISE3,ZE_TOTALD2,ZE_PRODD2,ZE_PVD2,ZE_DESCCOM,ZE_BASEITE,ZE_PERCITE,ZE_COMIITE"
	Local aP      := {} 
	Local aTit    := {}
	Local aItens  := {}
	Local aItem   := {}
	Local aCab    := {}
	Local nX      := 0
	
	aAdd( aP, { "Vendedor De  ?","C",6,0,"G","","SA3","","","","","" } )
	aAdd( aP, { "Vendedor Ate ?","C",6,0,"G","","SA3","","","","","" } )
	aAdd( aP, { "Data de      ?","D",8,0,"G","","   ","","","","","" } )
	aAdd( aP, { "Data Ate     ?","D",8,0,"G","","   ","","","","","" } )
	aAdd( aP, { "Grupo De     ?","C",4,0,"G","","SBM","","","","","" } )
	aAdd( aP, { "Grupo Ate    ?","C",4,0,"G","","SBM","","","","","" } )
	aAdd( aP, { "Faixa De     ?","C",6,0,"G","","SZB","","","","","" } )
	aAdd( aP, { "Faixa Ate    ?","C",6,0,"G","","SZB","","","","","" } )
	aAdd( aP, { "Gerar        ?","C",1,0,"C","","   ","Relatório","Excel","","","" } )

	J211PERG( cPerg, aP )
	If !Pergunte( cPerg )
		Return
	EndIf

	DbSelectArea("SX3")
	DbSetOrder(1)
	MsSeek("SZE")
	While ( !EoF() .And. SX3->X3_ARQUIVO == "SZE" )
		If X3USO(SX3->X3_USADO) .AND. AllTrim( SX3->X3_CAMPO ) $ cCampos
			aAdd( aTit, SX3->X3_TITULO )
			aAdd( aCab, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
		EndIf
		SX3->( dbSkip() )
	EndDo

	cQuery := "SELECT "+ cCampos
	cQuery += " FROM "+ RetSqlName("SZE")
	cQuery += " WHERE ZE_FILIAL = '"+ xFilial("SZE") +"' AND D_E_L_E_T_ = ' ' "
	cQuery += " AND ZE_VEND    BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' "
	cQuery += " AND ZE_DEMISE3 BETWEEN '"+ DtoS( mv_par03 ) +"' AND '"+ DtoS( mv_par04 ) +"' "
	cQuery += " AND ZE_GRUPO   BETWEEN '"+ mv_par05 +"' AND '"+ mv_par06 +"' "
	cQuery += " AND ZE_CODFAIX BETWEEN '"+ mv_par07 +"' AND '"+ mv_par08 +"' "
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAlias := GetNextAlias(), .F., .T.)

	While (cAlias)->( !Eof() )

		aItem := Array( Len( aCab ) )
		
		For nX := 1 to Len( aCab )
			If aCab[ nX ][ 2 ] == "C"
				aItem[ nX ] := Iif( mv_par09 == 2, CHR(160), "" ) + (cAlias)->&( aCab[ nX ][ 1 ] )
			Else
				aItem[ nX ] := (cAlias)->&( aCab[ nX ][ 1 ] )
			EndIf
		Next nX
	 
		aAdd( aItens, aItem )
		aItem := {}
	 
		(cAlias)->( dbSkip() )
	End
	
	(cAlias)->( dbCloseArea() )
	
	If mv_par09 == 2
		DlgToExcel( { { "GETDADOS", "Auditoria de Comissões", aCab, aItens } } )
    Else
    	JMH211A2( aCab, aTit, aItens )
    EndIf

Return

// Gera relatório de auditoria
Static Function JMH211A2( aCabX3, aTitulos, aItens )

	Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2  := "de conferência de comissões."
	Local cDesc3  := "Relatório de Auditoria de Comissões"
	Local cPict   := ""
	Local titulo  := "Relatório de Auditoria de Comissões"
	Local Cabec1  := ""
	Local Cabec2  := ""
	Local nLin    := 80
	Local imprime := .T.
	Local aOrd    := {}
	
	Private nLastKey    := 0
	Private cbcont      := 0
	Private CONTFL      := 1
	Private m_pag       := 1
	Private nTipo       := 18
	Private limite      := 220
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private Tamanho     := "G"
	Private NomeProg    := "JMHA211A"
	Private wnrel       := "JMHA211A"
	Private cbtxt       := Space(10)
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}

	wnrel := SetPrint( "", NomeProg, "", @titulo, cDesc1, cDesc2, cDesc3, .T., aOrd, .T., Tamanho,, .T. )

	If nLastKey == 27
		Return
	Endif
	
	SetDefault( aReturn, cString )
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If( aReturn[ 4 ] == 1, 15, 18 )
	
	RptStatus( { || RunReport( Cabec1, Cabec2, Titulo, nLin, aCabX3, aTitulos, aItens ) }, Titulo )

Return

// Executa a montagem do relatório de conferência
Static Function RunReport( Cabec1, Cabec2, Titulo, nLin, aCabX3, aTitulos, aItens )

	Local cCabTit := ""
	Local cLinha  := ""
	Local nI      := 0
	Local nX      := 0
	Local nLin    := nLin
	
	For nI := 1 To Len( aTitulos )
		If aCabX3[ nI, 2 ] == "N"
			cCabTit += " "+ PadL( aTitulos[ nI ], Len( Transform( 0, PesqPict( "SZE", aCabX3[ nI, 1 ] ) ) ) )
		Else
			cCabTit += PadR( aTitulos[ nI ], Iif( aCabX3[ nI, 2 ] == "C", aCabX3[ nI, 3 ], 10 ) ) + " "
		EndIf
	Next
	
	SetRegua( Len( aItens ) )

	For nI := 1 To Len( aItens )
	
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 65
			Cabec( Titulo, cCabTit, Cabec2, NomeProg, Tamanho, nTipo )
			nLin := 8
		Endif

		cLinha := ""
		
		For nX := 1 To Len( aItens[ nI ] )
			
			If aCabX3[ nX, 2 ] == "C"
				cLinha += PadR( aItens[ nI, nX ], aCabX3[ nX, 3 ] ) +" "
			EndIf
			If aCabX3[ nX, 2 ] == "D"
				cLinha += DtoC( StoD( aItens[ nI, nX ] ) ) +" "
			EndIf
			If aCabX3[ nX, 2 ] == "N"
				cLinha += Transform( aItens[ nI, nX ], PesqPict( "SZE", aCabX3[ nX, 1 ] ) ) +" "
			EndIf

		Next
		
		@ nLin, 00 PSAY cLinha

		nLin += 1 // Avanca a linha de impressao

	Next

	SET DEVICE TO SCREEN

	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

// Relatório de Comissões - Gera relatório idêntico ao JMHR800 porém sem fazer cálculos
User Function JMHA211R

	Local oReport
	Local cPerg := "JMHR800"
	
	// Jean Rehermann - Solutio IT - 07/04/2017 - Incluída a pergunta se aglutina por item
	PutSx1( cPerg,"12","Aglutina os Itens?","Aglutina os Itens?","Aglutina os Itens?","mv_ch12","N",01,0,1,"C","","","","","MV_PAR12","Sim","Sim","Sim","","Não","Não","Não","","","","","","","","","",,"","","")
	
	oReport := ReportDef()
	oReport:PrintDialog()	

Return

// Função que define o layout do relatório
Static Function ReportDef()

	Local oReport 
	Local oSecVend
	Local oSecClie
	Local oSecMovi
	Local oSecLinh
	Local oBreak1
	Local nN      := 0
	Local cReport := "JMHA211R"
	Local cPerg   := "JMHR800"
	Local cTitulo := "Comissoes por Linha de Produto"
	Local cDescri := "Este relatorio ira emitir o relatorio de comissao, conforme os parametros."
	Local aOrdem  := {"Vendedor + Cliente + Loja + NF"}
	Local lAglut
	
	Pergunte( cPerg, .F. )
	lAglut  := ( mv_par12 == 1 )
	oReport := TReport():New( cReport, cTitulo, "JMHR800", { |oReport| Imprimir( oReport, cPerg, lAglut ) }, cDescri )
	
	// Define a seção Vendedor
	oSecVend := TRSection():New( oReport, "Vendedor", {"SA3"} , aOrdem )
	TRCell():New( oSecVend, "A3_COD"	, "SA3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSecVend, "A3_NOME"	, "SA3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	
	// Define a secao Cliente
	oSecClie := TRSection():New( oSecVend, "Cliente", {"SA1"} , aOrdem )
	oSecClie:SetLeftMargin(3)
	TRCell():New( oSecClie, "A1_COD"  	, "SA1" ,"Codigo"         	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecClie, "A1_LOJA"  	, "SA1" ,"Loja"  		    ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecClie, "A1_NOME"  	, "SA1" ,"Nome do cliente"	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	// Define a secao Movimentos
	oSecMovi := TRSection():New( oSecVend, "Movimentos", {"SE3", "SE1", "SD2"} , aOrdem )
	oSecMovi:SetLeftMargin(5)
	
	TRCell():New( oSecMovi, "E1_PREFIXO" 	, "SE1" ,"Prf"   		 ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E1_NUM"	 	, "SE1" ,"Numero"		 ,/*Picture*/,9,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E1_PARCELA"	, "SE1" ,"P  "			 ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E1_EMISSAO"	, "SE1" ,"Emissao"		 ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E1_VENCREA"	, "SE1" ,"Venc.Real"	 ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E3_EMISSAO"	, "SE3" ,"Dt. Baixa"	 ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E1_VALOR" 		, "SE1" ,"Valor Titulo"  ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E3_BASE" 		, "SE3" ,"Base Comissao" ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "B1_GRUPO" 		, "SB1" ,"Grupo"     	 ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	// 03/05/2017 - Não será inserida coluna com produto pois assim não seria possível aglutinar os itens...
	// Jean Rehermann - Solutio IT - 07/04/2017 - Se aglutina pelo item mostra o código e a descrição
	If lAglut
//		TRCell():New( oSecMovi, "B1_COD" 	, "SB1" ,"Produto"		 ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
//		TRCell():New( oSecMovi, "B1_DESC" 	, "SB1" ,"Descrição"	 ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	EndIf
	
	TRCell():New( oSecMovi, "D2_DESC"		, "SD2" ,"% Desconto"	 ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	// Jean Rehermann - Solutio IT - 03/05/2017 - Se aglutina pelo item nesta coluna mostrará a base aglutinada e não o valor de cada item
	If lAglut
		TRCell():New( oSecMovi, "D2_TOTAL" 		, "SD2" ,"Valor Base"  	 ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	Else
		TRCell():New( oSecMovi, "D2_TOTAL" 		, "SD2" ,"Valor Item"  	 ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	EndIf
	TRCell():New( oSecMovi, "E3_PORC" 		, "SE3" ,"% Comissao"  	 ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E3_COMIS" 		, "SE3" ,"Vlr Comis."  	 ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "D2_CUSTO1"		, "SD2" ,"Custo p/Parcel",/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "MARG_1" 		, "XXX" ,"Margem" 	 	 ,"@E 999.99",6.2,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	// Define a secao Participacao Vendedor por Linha
	oSecLinh := TRSection():New( oSecVend, "Participacao", {"SE3","SD2"} , aOrdem )
	oSecLinh:SetLeftMargin(3)
	TRCell():New( oSecLinh, "LINHAP" 		, "XXX" ,"Grupo de Produto"	,"@!"					,25,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecLinh, "FAIXA" 		, "XXX" ,"Faixa "	        ,"@!"					,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecLinh, "DTINI" 		, "XXX" ,"Vigencia Ini"	    ,"@!"					,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecLinh, "DTFIM" 		, "XXX" ,"Vigencia Final"	,"@!"					,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecLinh, "BASE"	 		, "XXX" ,"Base de Calculo"	,"@E 99,999,999.99"		,11.2,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecLinh, "COMIS"			, "XXX" ,"Comissao" 		,"@E 99,999,999.99"		,11.2,/*lPixel*/,/*{|| code-block de impressao }*/)

		
	// Total por Vendedor
	oBreak1 := TRBreak():New(oSecVend, oSecLinh:Cell("LINHAP"), "Total Vendedor :",.f.)
	TRFunction():New(oSecLinh:Cell("BASE" ), "TOT1", "SUM", oBreak1,,,, .F., .F.)
	TRFunction():New(oSecLinh:Cell("COMIS"), "TOT9", "SUM", oBreak1,,,, .F., .F.)
	
Return(oReport)

// Função com a lógica do relatório
Static Function Imprimir(oReport, cPerg, lAglut)

	Local lSaltPag	:= .F.
	Local lMargem	:= .F.
	Local lAnalitico:= .F.
	Local cQuery	:= ""
	Local cVendedor	:= ""
	Local cClie 	:= ""
	Local cNf		:= ""
	Local cPref 	:= ""
	Local cNum  	:= ""
	Local cPar  	:= ""
	Local cTip  	:= ""	 
	Local cGrupo	:= ""
	Local cTipoFaixa:= ""
	Local nZ		:= 0
	Local nY		:= 0
	Local nPos		:= 0
	Local nQtdParc	:= 0
	Local nValComis	:= 0
	Local nPerComis	:= 0
	Local nPercent 	:= 0
	Local nTotPer 	:= 0
	Local nPerDesc	:= 0	
	Local nRegistro	:= 0
	Local aVend		:= {}
	Local aNF      	:= {}
	Local aLinha	:= {}
	Local oSecVend	:= oReport:Section(1)
	Local oSecClie	:= oReport:Section(1):Section(1)
	Local oSecMovi	:= oReport:Section(1):Section(2)
	Local oSecLinh	:= oReport:Section(1):Section(3)
	Local nImpFed 	:= GetMV('JO_IMPFED') // CSLL=1,02%   PIS=3%  COFINS=0,65%  Imp.Renda=1,08%
	
	SA3->( dbSetOrder(1) )
	SE1->( dbSetOrder(1) )
	SBM->( dbSetOrder(1) )
	
	Pergunte(cPerg, .F.)
  
	cTitulo := oReport:cTitle
	oReport:cTitle := cTitulo + " - Periodo de Apuracao: " + DtoC( Mv_Par01 ) + " a " +   DtoC( Mv_Par02 )
	
	lAnalitico	:= ( MV_PAR09 == 1 ) 
	lSaltPag	:= ( MV_PAR10 == 1 )
	lMargem		:= ( MV_PAR11 == 1 )
		                         
	cQuery  := "SELECT * "
	cQuery  += "FROM " + RetSqlName("SZE") +" SZE " 
	cQuery  += "WHERE ZE_FILIAL       = '" + xFilial('SZE') + "' "
	cQuery  += "AND   ZE_DEMISE3     >= '" + Dtos(MV_PAR01)  + "' "
	cQuery  += "AND   ZE_DEMISE3     <= '" + Dtos(MV_PAR02)  + "' "
	cQuery  += "AND   ZE_VEND        >= '" + MV_PAR07       + "' "
	cQuery  += "AND   ZE_VEND        <= '" + MV_PAR08       + "' "
	cQuery  += "AND   ZE_CLIENTE     >= '" + MV_PAR03       + "' "
	cQuery  += "AND   ZE_LOJA        >= '" + MV_PAR04       + "' "
	cQuery  += "AND   ZE_CLIENTE     <= '" + MV_PAR05       + "' "
	cQuery  += "AND   ZE_LOJA        <= '" + MV_PAR06       + "' "
	cQuery  += "AND   SZE.D_E_L_E_T_  <> '*' "
	cQuery  += "ORDER BY ZE_VEND, ZE_E3PREFI, ZE_E3NUM, ZE_E3PARC, ZE_E3TIPO, ZE_E1PREFI, ZE_E1NUM, ZE_E1PARC, ZE_E1TIPO, ZE_E3SEQ "
	
	cQuery  := ChangeQuery(cQuery)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "COMISSAO", .F., .T.)
	
	// converte campos DATA/NUMERICO
	TCSetField('COMISSAO', "ZE_DEMISE1", "D", 8, 0)
	TCSetField('COMISSAO', "ZE_DEMISE3", "D", 8, 0)
	TCSetField('COMISSAO', "ZE_BASENF" , "N", 14,2)
	TCSetField('COMISSAO', "ZE_TOTALD2", "N", 14,2)
	TCSetField('COMISSAO', "ZE_E1VENCR", "D", 8,0)
	TCSetField('COMISSAO', "ZE_E1VALOR", "N", 14,2)
	TCSetField('COMISSAO', "ZE_D2CUST1", "N", 14,2)
		
	Count To nRegistros
	oReport:SetMeter(nRegistros)
	
	COMISSAO->( dbGoTop() )
	While COMISSAO->( !Eof() )
	
		oReport:IncMeter()
		cVendedor:= COMISSAO->ZE_VEND
		
		aAdd(aVend, {	cVendedor	,; 
						{}			,;//2  Array com a NF do VENDEDOR + GRUPO
						{}			})//3  Array com os totais por GRUPO

		aNF 	:= {}
		aLinha 	:= {}

		While COMISSAO->( !Eof() )  .And. cVendedor == COMISSAO->ZE_VEND

			aItem   := {}
			nTotPer := 0
			cNF	    := COMISSAO->( ZE_E3PREFI + ZE_E3NUM + ZE_E3PARC + ZE_E3TIPO + ZE_E3SEQ + DTOS( ZE_DEMISE3 ) )

			While COMISSAO->( !Eof() )  .And. cVendedor == COMISSAO->ZE_VEND;
										.And. cNF == COMISSAO->( ZE_E3PREFI + ZE_E3NUM + ZE_E3PARC + ZE_E3TIPO + ZE_E3SEQ + DTOS( ZE_DEMISE3 ) )

				nPerDesc   := COMISSAO->ZE_DESCCOM // Desconto Comercial
                cTipoFaixa := COMISSAO->ZE_TPFAIXA // Tipo de Cálculo (1 = % Desconto/2 = Volume Faturamento )
				cFaixa     := COMISSAO->ZE_CODFAIX // Código Faixa de Comissao
				nQtdParc   := COMISSAO->ZE_QTDPARC // Quantidade de parcelas
				nPDescFin  := COMISSAO->ZE_DESCF   // Desconto Financeiro -> Baixa parcial ou Decrescimo ou Pagto parcela fatura/liq
				nValBase   := COMISSAO->ZE_BASEITE // Base de Comissão do item
				nPerComis  := COMISSAO->ZE_PERCITE // Percentual de comissão do item
				nValComis  := COMISSAO->ZE_COMIITE // Valor de comissão do item
                
				aAdd( aItem, {	COMISSAO->ZE_E1PREFI	,;// 1
								COMISSAO->ZE_E1NUM		,;// 2
								COMISSAO->ZE_E1PARC	    ,;// 3
								COMISSAO->ZE_E1TIPO		,;// 4
								COMISSAO->ZE_BASENF		,;// 5 Valor BASE
								nValComis				,;// 6 Valor da COMISSAO
								nPerComis				,;// 7 Percentual de COMISSAO
								COMISSAO->ZE_CLIENTE	,;// 8
								COMISSAO->ZE_LOJA		,;// 9
								Posicione("SA1", 1, xFilial("SA1")+COMISSAO->ZE_CLIENTE+COMISSAO->ZE_LOJA, "A1_NOME"),;// 10
								COMISSAO->ZE_E3SEQ		,;// 11
								COMISSAO->ZE_DEMISE1	,;// 12
								COMISSAO->ZE_PVD2		,;// 13
						        COMISSAO->ZE_D2CUST1 / nQtdParc ,;// 14     
				               	nValBase                ,;// 15
				               	COMISSAO->ZE_D2ICMS / nQtdParc ,;// 16
				               	COMISSAO->ZE_D2IPI  / nQtdParc ,;// 17
				               	COMISSAO->ZE_E1VENCR	,;// 18
				               	nPerDesc				,;// 19
				               	COMISSAO->ZE_E1VALOR	,;// 20
	       					   	COMISSAO->ZE_GRUPO		,;// 21
	       					   	COMISSAO->ZE_DEMISE3	,;// 22
	       					   	cFaixa 					,;// 23
	       					   	COMISSAO->ZE_PRODD2		})// 24

				COMISSAO->( dbSkip() )
			EndDo
			    
			// Ordeno por grupo de produto e faixa de comissao
			aItem := aSort( aItem,,, { |x,y| x[21] + x[23] <= y[21] + y[23] } )

			// Avalia se na divisão pelos itens o valor final arredondado fecha com o valor total
			If Len( aItem ) > 1 // Apenas quando houver mais de um item (divisão)
				
				nSumItem := 0
				nTotSum  := 0
				
				aEval( aItem, { |o| nSumItem += o[ 6 ] } ) // Soma o valor de comissão calculado para cada item
				nSumItem := Round( nSumItem, 2 )
				aEval( aItem, { |o| nTotSum += ( o[ 15 ] * ( o[ 7 ] / 100 ) ) } )
				nTotSum := Round( nTotSum, 2 )
				//Round( aItem[ 1, 20 ] * ( aItem[ 1, 7 ] / 100 ), 2 ) // Calculo o total da comissão
				
				If nSumItem != nTotSum // Verifico se existe diferenças provocadas por arredondamentos
					_nDif := nTotSum - nSumItem // Calcula a diferença que pode ser positiva ou negativa
					aItem[ Len( aItem ), 6 ] += _nDif // Somo no último item a diferença, o que pode aumentar ou diminuir o valor
				EndIf
			
			EndIf

			cGrupo := ""
			
			For nZ := 1 To Len( aItem )
			
				// Total por linha de produto
				nPos := aScan( aLinha, {|x| x[1] == aItem[nZ,21]  .And. x[10] == aItem[nZ,23]    } )
				
				If nPos > 0

					aLinha[nPos,2] += aItem[nZ,15]
					aLinha[nPos,3] += aItem[nZ,06]
					aLinha[nPos,5] += aItem[nZ,14]	     
					aLinha[nPos,6] += aItem[nZ,15]	
					aLinha[nPos,8] += aItem[nZ,17]	
					aLinha[nPos,9] += aItem[nZ,19]	
		
				Else
			
					cGrupo := aItem[nZ,21]
							
					aAdd( aLinha, { aItem[nZ,21]	,; //1 grupo de produto
									aItem[nZ,15]	,; //2 valor base
									aItem[nZ,6]		,; //3 valor de comissao
									0				,; //4 Percentual de comissao
							        aItem[nZ,14]	,; //5 custo    
					               	aItem[nZ,15]	,; //6 valor base
					               	aItem[nZ,16]	,; //7 valor icm
					               	aItem[nZ,17]	,; //8 valor ipi
					               	aItem[nZ,19]	,; //9 perc desconto
					               	aItem[nZ,23]	}) //10 faixa
				EndIf
				
				// Quando houver aglutinação dos itens (mv_par12 = 1)
				If lAglut

					// Aglutina a nota pelo grupo de produto e % comissao
					nPos := aScan( aNF, {|x| x[1]+x[2]+x[3]+x[4] == aItem[nZ,1]+aItem[nZ,2]+aItem[nZ,3]+aItem[nZ,4] .And. x[21] == aItem[nZ,21] .And. x[7] == aItem[nZ,7] } )
					
					If nPos > 0
	
						aNF[ nPos, 15 ] += aItem[ nZ, 15 ]	 // Valor Base
						aNF[ nPos, 06 ] += aItem[ nZ, 06 ]	 // Valor de Comissão
			
					Else
						aAdd( aNF, aItem[nZ] )
					EndIf
				Else
					aAdd( aNF, aItem[nZ] )
				EndIf
			
			Next nZ
			
		EndDo
		
		// adiciono as NF do VENDEDOR
		aVend[ Len( aVend ), 2 ] := aNF
		
		// adiciono o total por GRUPO / LINHA
		aVend[ Len( aVend ), 3 ] := aLinha
		
	EndDo
	COMISSAO->( dbCloseArea() )
	
	oReport:SetMeter( Len( aVend ) )

	For nZ := 1 To Len( aVend )
	
		oReport:IncMeter()
		
		If Len(aVend[nZ,2]) == 0
			Loop
		EndIf                
		
		// Posiciona no cadastro do Vendedor
		SA3->( dbSeek(xFilial("SA3") + aVend[nZ,1] ))
			
		oSecVend:Init()
		oSecVend:Cell("A3_COD"):SetBlock({ || SA3->A3_COD } )
		oSecVend:Cell("A3_NOME"):SetBlock({ || SA3->A3_NOME } )
	 	oSecVend:PrintLine()				
		
		If lAnalitico
		
			// ordeno por cliente + loja + prefixo + nf
			aVend[nZ,2] := aSort(aVend[nZ,2],,, {|x,y| x[8]+x[9]+x[1]+x[2]+x[3]+x[4]+DTOS(x[22])+x[21] <= y[8]+y[9]+y[1]+y[2]+y[3]+y[4]+DTOS(Y[22])+y[21]})
			
			cClie := ""
			cNum  := ""
			cNf	  := ""	
	        cGrupo:= ""
	        
			For nY := 1 To Len( aVend[nZ,2] )		   
			
				If oReport:Cancel()
					Exit
				EndIf  
				                                    
				DbSelectArea("SZB")
				DbSetOrder(1)
				DbSeek( xFilial("SZB") + aVend[nZ,2][nY,23] )
				
				cTipoFaixa := SZB->ZB_TIPO
				
				If 	cClie != aVend[nZ,2][nY,8] + aVend[nZ,2][nY,9] .And.;
					cNum  != aVend[nZ,2][nY,1] + aVend[nZ,2][nY,2] + aVend[nZ,2][nY,3] + aVend[nZ,2][nY,4] + DTOS( aVend[nZ,2][nY,22] )
					
					cClie := aVend[nZ,2][nY,8] + aVend[nZ,2][nY,9]
					cNum  := aVend[nZ,2][nY,1] + aVend[nZ,2][nY,2] + aVend[nZ,2][nY,3] + aVend[nZ,2][nY,4] + DTOS( aVend[nZ,2][nY,22] )
	
					If nY > 1
						oSecMovi:Finish()
						oSecClie:Finish() 
					EndIf
								
					oSecClie:Init()
					oSecClie:Cell("A1_COD"):SetBlock({ || aVend[nZ,2][nY,8] } )
					oSecClie:Cell("A1_LOJA"):SetBlock({ || aVend[nZ,2][nY,9] } )
					oSecClie:Cell("A1_NOME"):SetBlock({ || aVend[nZ,2][nY,10] } )
			 		oSecClie:PrintLine()							
			 		
			 		oSecMovi:Init()					

			    EndIf
			    
   				If cNf == aVend[nZ,2][nY,1] + aVend[nZ,2][nY,2] + aVend[nZ,2][nY,3] + aVend[nZ,2][nY,4] + DTOS( aVend[nZ,2][nY,22] )
   				
	   				oSecMovi:Cell("E1_PREFIXO"):Hide()
					oSecMovi:Cell("E1_NUM"):Hide()
					oSecMovi:Cell("E1_PARCELA"):Hide()
					oSecMovi:Cell("E1_EMISSAO"):Hide()
					oSecMovi:Cell("E1_VENCREA"):Hide()
					oSecMovi:Cell("E3_EMISSAO"):Hide()
					oSecMovi:Cell("E1_VALOR"):Hide()
					
					If cTipoFaixa == "2" //valor
						If cGrupo == aVend[nZ,2][nY,21] 
							oSecMovi:Cell("E3_BASE"):Hide()	
						Else
							oSecMovi:Cell("E3_BASE"):Show()
							cGrupo := aVend[nZ,2][nY,21]
						EndIf
					
					Else //por % desc
					 	oSecMovi:Cell("E3_BASE"):Show()
						cGrupo := aVend[nZ,2][nY,21]
					EndIf	
				Else                              
				
	   				cNf := aVend[nZ,2][nY,1] + aVend[nZ,2][nY,2] + aVend[nZ,2][nY,3] + aVend[nZ,2][nY,4]+ DTOS( aVend[nZ,2][nY,22] )
	   				
	   				cGrupo := aVend[nZ,2][nY,21]
	   				
					oSecMovi:Cell("E1_PREFIXO"):Show()
					oSecMovi:Cell("E1_NUM"):Show()
					oSecMovi:Cell("E1_PARCELA"):Show()
					oSecMovi:Cell("E1_EMISSAO"):Show()
					oSecMovi:Cell("E1_VENCREA"):Show()
					oSecMovi:Cell("E1_VALOR"):Show()
					oSecMovi:Cell("E3_EMISSAO"):Show()
					oSecMovi:Cell("E3_BASE"):Show()
					
	   			EndIf
			
				oSecMovi:Cell("E1_PREFIXO"):SetBlock({ || aVend[nZ,2][nY,1] } )
				oSecMovi:Cell("E1_NUM"):SetBlock({ || aVend[nZ,2][nY,2] } )
				oSecMovi:Cell("E1_PARCELA"):SetBlock({ || aVend[nZ,2][nY,3] } )
				oSecMovi:Cell("E1_EMISSAO"):SetBlock({ || aVend[nZ,2][nY,12] } )
				oSecMovi:Cell("E1_VENCREA"):SetBlock({ || aVend[nZ,2][nY,18] } )
				oSecMovi:Cell("E3_EMISSAO"):SetBlock({ || aVend[nZ,2][nY,22] } )
				oSecMovi:Cell("E1_VALOR"):SetBlock({ || aVend[nZ,2][nY,20] } )
				
				nVlrBs := Iif( cTipoFaixa == "1" , aVend[nZ,2][nY,15] , aVend[nZ,2][nY,5] )

				oSecMovi:Cell("E3_BASE"):SetBlock({ || nVlrBs } )			
				oSecMovi:Cell("B1_GRUPO"):SetBlock({ || aVend[nZ,2][nY,21] } )			
				
				// 03/05/2017 - Não será impresso produto para poder fazer a aglutinação dos itens
				If lAglut
					//oSecMovi:Cell("B1_COD"):SetBlock({ || aVend[nZ,2][nY,24] } )
					//oSecMovi:Cell("B1_DESC"):SetBlock({ || Left( Posicione("SB1", 1, xFilial("SB1") + aVend[nZ,2][nY,24], "B1_DESC"), 15 ) } )					
				EndIf
				
				If cTipoFaixa == "1" //1=Percentual
					oSecMovi:Cell("D2_DESC"):Show() 
					oSecMovi:Cell("D2_DESC"):SetBlock({ || aVend[nZ,2][nY,19] } )			
				Else
					oSecMovi:Cell("D2_DESC"):Hide()								
				EndIf
				
				oSecMovi:Cell("D2_TOTAL"):SetBlock({ || aVend[nZ,2][nY,15] } ) 
				oSecMovi:Cell("E3_PORC"):SetBlock({ || aVend[nZ,2][nY,7] } )
				oSecMovi:Cell("E3_COMIS"):SetBlock({ || aVend[nZ,2][nY,6] } )
				
				If !lMargem			
					oSecMovi:Cell("D2_CUSTO1"):Disable()
					oSecMovi:Cell("MARG_1"):Disable()
				EndIf
				oSecMovi:Cell("D2_CUSTO1"):SetBlock({ || aVend[nZ,2][nY,14] } )			
				oSecMovi:Cell("MARG_1"):SetBlock({ || ( (aVend[nZ,2][nY,15] - aVend[nZ,2][nY,14]) / aVend[nZ,2][nY,14])*100 } )
						
				oSecMovi:PrintLine()	
				
			Next nY				
		
			oSecMovi:Finish()
			oSecClie:Finish() 
			
		EndIf
		
		// Ordeno por Linha
		aVend[nZ,3] := aSort( aVend[nZ,3],,, { |x,y| x[1] <= y[1] } )
		
		oReport:SkipLine()
		oReport:Box(oReport:Row(),oReport:Col()+40,oReport:Row()+40,oReport:Col()+515)
		oReport:Say(oReport:Row(),oReport:Col()+45,"Participação por linha de produto")
		oReport:SkipLine()

		oSecLinh:Init()
		nVal_Comis := 0
		nVal_Base  := 0
		nBase_Bonus := 0 

		For nY := 1 To Len( aVend[ nZ, 3 ] )

			SBM->( dbSeek( xFilial('SBM') + aVend[nZ,3][nY,1] ) )

			If oReport:Cancel()
				Exit
			EndIf

			DbSelectArea("SZB")
			DbSetorder(1)
			DbSeek( xFilial("SZB") + aVend[nZ,3][nY,10] )

			If SZB->ZB_PAGABON == "S"				
				nBase_Bonus += aVend[nZ,3][nY,2]
			EndIf 	

			oSecLinh:Cell("LINHAP"):SetBlock({ || aVend[nZ,3][nY,1] +"-"+Left(SBM->BM_DESC,20)} ) 
			oSecLinh:Cell("FAIXA"):SetBlock({ ||  aVend[nZ,3][nY,10]  } )

			oSecLinh:Cell("DTINI"):SetBlock({ ||  SZB->ZB_VIGENC  } )
			oSecLinh:Cell("DTFIM"):SetBlock({ ||  SZB->ZB_VIGEFIM } )

			oSecLinh:Cell("BASE"):SetBlock({ ||  aVend[nZ,3][nY,2]  } )
			oSecLinh:Cell("COMIS"):SetBlock({ ||  aVend[nZ,3][nY,3]  } )

			oSecLinh:PrintLine()                

			nVal_Comis += aVend[nZ,3][nY,3]
			nVal_Base  += aVend[nZ,3][nY,2]

		Next nY

		oSecLinh:Finish()						
		oSecVend:Finish() 
		        
		// Total geral por vendedor
		oReport:SkipLine()
		oReport:SkipLine()
		                       
		oReport:Say(oReport:Row(),oReport:Col()+100," Valor Bruto      : " + Transform( nVal_Comis , "@E 999,999,999.99")      )
		oReport:SkipLine()		
		
		// Funcao que calcula o valor do bonus
		nVal_Bonus:= FaixaBonus( aVend[nZ,1] , nBase_Bonus )
		oReport:Say(oReport:Row(),oReport:Col()+100," Valor Bonus   (+): " + Transform( nVal_Bonus , "@E 999,999,999.99")      )
		oReport:SkipLine()		
		
		// Condicao para calculo do IR do vendedor
		If SA3->A3_COMIR == '2'
			nPerImp := 0
		Else
			If SA3->A3_IMPCOM > 0
				nPerImp := SA3->A3_IMPCOM
			Else
			
				If (nVal_Comis +  nVal_Bonus ) > 5000
					nPerImp := GetNewPar("ES_IMPVEND", 6.15 )
				Else
					nPerImp := GetNewPar("ES_IMPIR"  , 1.50 )
				EndIf	
			
			EndIf
		EndIf		
					
		nVal_Imp := Round( ( ( nVal_Comis +  nVal_Bonus ) * nPerImp ) / 100 , 2 )
		If nPerImp > 0
			oReport:Say(oReport:Row(),oReport:Col()+100," Valor Impostos(-): " + Transform( nVal_Imp , "@E 999,999,999.99")+ " (" + cValtoChar(nPerImp) + " % )" )
			oReport:SkipLine()
		EndIf
		
		oReport:SkipLine()                                                 
		
		nVal_Liq := ( nVal_Comis + nVal_Bonus ) - nVal_Imp
		oReport:Say(oReport:Row(),oReport:Col()+100," Valor Liquido    : " + Transform( nVal_Liq , "@E 999,999,999.99")      )
		
		oReport:SkipLine()
		
		If lSaltPag
			oReport:EndPage()		
		EndIf
			
	Next nZ
	
Return

// Função que grava as perguntas de cada rotina
Static Function J211PERG( cPerg, aP )

	Local nI	 := 0
	Local cSeq	 := ""
	Local cMvCh	 := ""
	Local cMvPar := ""

	For nI := 1 To Len( aP )
		
		cSeq   := StrZero( nI, 2, 0 )
		cMvCh  := "MV_CH"+ Iif( nI <= 9, CHR( nI + 48 ), CHR( nI + 87 ) )
		cMvPar := "MV_PAR"+ cSeq
		
		PutSx1(cPerg,cSeq,aP[nI,1],aP[nI,1],aP[nI,1],cMvCh,aP[nI,2],aP[nI,3],aP[nI,4],1,aP[nI,5],aP[nI,6],aP[nI,7],"","",cMvPar,;
		aP[nI,8],aP[nI,8],aP[nI,8],"",aP[nI,9],aP[nI,9],aP[nI,9],aP[nI,10],aP[nI,10],aP[nI,10],aP[nI,11],aP[nI,11],aP[nI,11],aP[nI,12],;
		aP[nI,12],aP[nI,12],{},{},{},"")
		
	Next nI

Return()

// Retorna o valor do bonus
Static Function FaixaBonus( _cVend , _nBase_Bonus )

	Local nRet := 0

	cQuery := " SELECT ZB_VALOR , ZB_FAIXA "
	cQuery += " FROM " + RetSqlName("SZB")
	cQuery += " WHERE ZB_FILIAL  = '" + xFilial("SZB") + "'"
	cQuery += "	AND ZB_VEND    = '" + _cVend + "'"
	cQuery += "	AND ZB_GRUPO   = ''"
	cQuery += "	AND ZB_FAXDE   <= "+ cValToChar(_nBase_Bonus) 
	cQuery += "	AND ZB_FAXATE  >= "+ cValToChar(_nBase_Bonus)
	cQuery += "	AND D_E_L_E_T_ <> '*' "
	
	cQuery := ChangeQuery(cQuery)                           
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "FAIXA", .F., .T.)

	TcSetField("FAIXA","ZB_VALOR","N",6,2)

	FAIXA->( dbGoTop() )
	If FAIXA->( !Eof() )
		nRet := FAIXA->ZB_VALOR
	EndIf

	FAIXA->( dbCloseArea() )

Return( nRet )
