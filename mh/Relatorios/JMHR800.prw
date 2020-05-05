#include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ JMHR800  ³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2013 ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de comissao.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_JMHR800()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Jomhedica                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function JMHR800()
	
	Local oReport

	oReport := ReportDef()
	oReport:PrintDialog()	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Jeferson Dambros    º Data ³  Set/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Jomhedica                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

	Local oReport 
	Local oSecVend
	Local oSecClie
	Local oSecMovi
	Local oSecLinh

	Local oBreak1
	
	Local aPerg 	:= {}
	Local cPerg	:= ""
	Local nN		:= 0
	
	Local cReport	:= "JMHR800"
	Local cTitulo	:= "Comissoes por Linha de Produto"
	Local cDescri	:= "Este relatorio ira emitir o relatorio de comissao, conforme os parametros."
	Local aOrdem	:= {"Vendedor + Cliente + Loja + NF"}
	
	
	//Cria o grupo de perguntas
	cPerg := CriaSx1()

	Pergunte( cPerg, .F. )
	
	oReport := TReport():New( cReport, cTitulo, "JMHR800", { |oReport| Imprimir( oReport, cPerg ) }, cDescri )
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a secao Vendedor                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSecVend := TRSection():New( oReport, "Vendedor", {"SA3"} , aOrdem )
	
	TRCell():New( oSecVend, "A3_COD"	, "SA3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSecVend, "A3_NOME"	, "SA3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a secao Cliente                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSecClie := TRSection():New( oSecVend, "Cliente", {"SA1"} , aOrdem )
	
	oSecClie:SetLeftMargin(3)
	
	TRCell():New( oSecClie, "A1_COD"  	, "SA1" ,"Codigo"         	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecClie, "A1_LOJA"  	, "SA1" ,"Loja"  		    ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecClie, "A1_NOME"  	, "SA1" ,"Nome do cliente"	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a secao Movimentos                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSecMovi := TRSection():New( oSecVend, "Movimentos", {"SE3", "SE1", "SD2"} , aOrdem )
	
	oSecMovi:SetLeftMargin(5)
	
	TRCell():New( oSecMovi, "E1_PREFIXO" 	, "SE1" ,"Prf"   			,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E1_NUM"	 	, "SE1" ,"Numero"			,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E1_PARCELA"	, "SE1" ,"P  "				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E1_EMISSAO"	, "SE1" ,"Emissao"		,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E1_VENCREA"	, "SE1" ,"Venc.Real"		,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E3_EMISSAO"	, "SE3" ,"Dt. Baixa"		,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E1_VALOR" 		, "SE1" ,"Valor Titulo"  ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E3_BASE" 		, "SE3" ,"Base Comissao" ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "B1_GRUPO" 		, "SB1" ,"Grupo"     		,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	TRCell():New( oSecMovi, "D2_DESC"		, "SD2" ,"% Desconto"		,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	TRCell():New( oSecMovi, "D2_TOTAL" 		, "SD2" ,"Valor Item"  	    ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E3_PORC" 		, "SE3" ,"% Comissao"  	    ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "E3_COMIS" 		, "SE3" ,"Vlr Comis."  	    ,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)

	TRCell():New( oSecMovi, "D2_CUSTO1"		, "SD2" ,"Custo p/Parcel"	,/*Picture*/,1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecMovi, "MARG_1" 		, "XXX" ,"Margem" 	 	    ,"@E 999.99",6.2,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a secao Participacao Vendedor por Linha       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oSecLinh := TRSection():New( oSecVend, "Participacao", {"SE3","SD2"} , aOrdem )
	
	oSecLinh:SetLeftMargin(3)
	
	TRCell():New( oSecLinh, "LINHAP" 		, "XXX" ,"Grupo de Produto"	,"@!"					,25,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecLinh, "FAIXA" 		, "XXX" ,"Faixa "	        ,"@!"					,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	TRCell():New( oSecLinh, "DTINI" 		, "XXX" ,"Vigencia Ini"	    ,"@!"					,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecLinh, "DTFIM" 		, "XXX" ,"Vigencia Final"	,"@!"					,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	TRCell():New( oSecLinh, "BASE"	 		, "XXX" ,"Base de Calculo"	,"@E 99,999,999.99"		,11.2,/*lPixel*/,/*{|| code-block de impressao }*/)
	//TRCell():New( oSecLinh, "CUSTO"			, "XXX" ,"Custo Total" 		,"@E 99,999,999.99"		,11.2,/*lPixel*/,/*{|| code-block de impressao }*/)
	//TRCell():New( oSecLinh, "RESULT" 		, "XXX" ,"Resultado R$"		,"@E 99,999,999.99"		,11.2,/*lPixel*/,/*{|| code-block de impressao }*/)
	//TRCell():New( oSecLinh, "MARG_2" 		, "XXX" ,"Margem"			,"@E 999.99"			,6.2,/*lPixel*/,/*{|| code-block de impressao }*/)
	//TRCell():New( oSecLinh, "IMPOST"		, "XXX" ,"Imp.Federais" 	,"@E 99,999,999.99"		,11.2,/*lPixel*/,/*{|| code-block de impressao }*/)
	//TRCell():New( oSecLinh, "VALICM"		, "XXX" ,"ICMS" 			,"@E 99,999,999.99"		,11.2,/*lPixel*/,/*{|| code-block de impressao }*/)
	//TRCell():New( oSecLinh, "VALIPI"		, "XXX" ,"IPI" 				,"@E 99,999,999.99"		,11.2,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSecLinh, "COMIS"			, "XXX" ,"Comissao" 		,"@E 99,999,999.99"		,11.2,/*lPixel*/,/*{|| code-block de impressao }*/)

		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Total por Vendedor                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oBreak1 := TRBreak():New(oSecVend, oSecLinh:Cell("LINHAP"), "Total Vendedor :",.f.)
	                   
	TRFunction():New(oSecLinh:Cell("BASE" ), "TOT1", "SUM", oBreak1,,,, .F., .F.)
	//TRFunction():New(oSecLinh:Cell("CUSTO"), "TOT2", "SUM", oBreak1,,,, .F., .F.)
	//TRFunction():New(oSecLinh:Cell("RESULT"), "TOT3", "SUM", oBreak1,,,, .F., .F.)
	//TRFunction():New(oSecLinh:Cell("MARG_2"), "TOT4", "SUM", oBreak1,,,, .F., .F.)
	//TRFunction():New(oSecLinh:Cell("IMPOST"), "TOT5", "SUM", oBreak1,,,, .F., .F.)
	//TRFunction():New(oSecLinh:Cell("VALICM"), "TOT6", "SUM", oBreak1,,,, .F., .F.)
	//TRFunction():New(oSecLinh:Cell("VALIPI"), "TOT7", "SUM", oBreak1,,,, .F., .F.)
	TRFunction():New(oSecLinh:Cell("COMIS"), "TOT9", "SUM", oBreak1,,,, .F., .F.)
	
Return(oReport)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Imprimir  ºAutor  ³Jeferson Dambros    º Data ³  Jul/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao responsavel pela impressao.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Jomhedica                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Imprimir(oReport, cPerg)

	Local cQuery	:= ""
	Local nRegistro	:= 0
	
	Local lSaltPag	:= .F.
	Local lMargem	:= .F.
	Local lAnalitico:= .F.
	
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
	
	Local nImpFed 	:= GetMV('JO_IMPFED')    // CSLL=1,02%   PIS=3%  COFINS=0,65%  Imp.Renda=1,08%
	Local nPos		:= 0
	Local nQtdParc	:= 0
	Local nValComis	:= 0
	Local nPerComis	:= 0
	Local nPercent 	:= 0
	Local nTotPer 	:= 0
	Local nPerDesc	:= 0	
	
	Local aVend		:= {}
	Local aNF      	:= {}
	Local aLinha	:= {}
	 		
	Local oSecVend	:= oReport:Section(1)
	Local oSecClie	:= oReport:Section(1):Section(1)
	Local oSecMovi	:= oReport:Section(1):Section(2)
	Local oSecLinh	:= oReport:Section(1):Section(3)
	
	SA3->( dbSetOrder(1) )
	SE1->( dbSetOrder(1) )
	SBM->( dbSetOrder(1) )
	
	Pergunte(cPerg, .F.)
  
	//Fernando Mazza - Ajuste do titulo solicitado em 20/05/14 por josiel 		                                                         
	cTitulo := oReport:cTitle
	oReport:cTitle := cTitulo + " - Periodo de Apuracao: " + DtoC( Mv_Par01 ) + " a " +   DtoC( Mv_Par02 )
	
	
	lAnalitico	:= ( MV_PAR09 == 1 ) 
	lSaltPag	:= ( MV_PAR10 == 1 )
	lMargem		:= ( MV_PAR11 == 1 )
		
		                         
	//TITULOS BAIXADOS NORMAL ( SEM LIQUIDACAO OU FATURA )	
	cQuery  := "SELECT A1_NOME, B1_GRUPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCREA, E1_VALOR,"
	cQuery  +=        "E3_CODCLI, E3_LOJA, E3_BASE, E3_SERIE, E3_EMISSAO, E3_SEQ, E3_VEND, E3_PORC, E3_COMIS, E3_DESCFIN, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO," 
	cQuery  +=        "D2_DOC, D2_SERIE, D2_TOTAL, D2_CUSTO1, D2_VALIPI, D2_VALICM, D2_DESC, D2_PEDIDO, D2_COD, D2_PRCVEN "
	
	cQuery  += "FROM " + RetSqlName("SE3") +" SE3, " 
	cQuery  += "    " + RetSqlName("SD2") +" SD2, " 
	cQuery  += "    " + RetSqlName("SB1") +" SB1, " 
	cQuery  += "    " + RetSqlName("SF4") +" SF4, " 
	cQuery  += "    " + RetSqlName("SA1") +" SA1, " 
	cQuery  += "    " + RetSqlName("SE1") +" SE1 " 

	cQuery  += "WHERE E3_FILIAL       = '" + xFilial('SE3') + "' "
	cQuery  += "AND   E3_DATA         = '' "
	cQuery  += "AND   E3_EMISSAO     >= '" + Dtos(MV_PAR01)  + "' "
	cQuery  += "AND   E3_EMISSAO     <= '" + Dtos(MV_PAR02)  + "' "
	cQuery  += "AND   E3_VEND        >= '" + MV_PAR07       + "' "
	cQuery  += "AND   E3_VEND        <= '" + MV_PAR08       + "' "
	cQuery  += "AND   E3_CODCLI      >= '" + MV_PAR03       + "' "
	cQuery  += "AND   E3_LOJA        >= '" + MV_PAR04       + "' "
	cQuery  += "AND   E3_CODCLI      <= '" + MV_PAR05       + "' "
	cQuery  += "AND   E3_LOJA        <= '" + MV_PAR06       + "' "
	cQuery  += "AND   E3_ORIPROG      = 'JMHA210' "//Campo Especifico
	cQuery  += "AND   D2_FILIAL       = '" + xFilial('SD2') + "' "
	cQuery  += "AND   D2_DOC          = E3_NUM "
	cQuery  += "AND   D2_SERIE        = E3_SERIE "
	cQuery  += "AND   D2_CLIENTE      = E3_CODCLI "
	cQuery  += "AND   D2_LOJA         = E3_LOJA "
	
	cQuery  += "AND   B1_FILIAL       = '" + xFilial('SB1') + "' "
	cQuery  += "AND   B1_COD          = D2_COD "
	cQuery  += "AND   B1_GRUPO        = D2_GRUPO "//  E3_GRUPO --Campo Especifico -- CRISTIANO OLIVEIRA 20170316 
	
	cQuery  += "AND   F4_FILIAL       = '" + xFilial('SF4') + "' "
	cQuery  += "AND   F4_CODIGO       = D2_TES "
	cQuery  += "AND   F4_DUPLIC       = 'S' "
	
	cQuery  += "AND   A1_FILIAL       = '" + xFilial('SA1') + "' "
	cQuery  += "AND   A1_COD          = D2_CLIENTE "
	cQuery  += "AND   A1_LOJA         = D2_LOJA "
	
	cQuery  += "AND   E1_FILIAL       = '" + xFilial('SE1') + "' "
	cQuery  += "AND   E1_NUM          = E3_NUM "
	cQuery  += "AND   E1_PREFIXO      = E3_PREFIXO "
	cQuery  += "AND   E1_PARCELA      = E3_PARCELA "
	cQuery  += "AND   E1_TIPO         = E3_TIPO "
	
	cQuery  += "AND   SE3.D_E_L_E_T_  <> '*' "
	cQuery  += "AND   SD2.D_E_L_E_T_  <> '*' "
	cQuery  += "AND   SB1.D_E_L_E_T_  <> '*' "
	cQuery  += "AND   SF4.D_E_L_E_T_  <> '*' "
	cQuery  += "AND   SA1.D_E_L_E_T_  <> '*' "
	cQuery  += "AND   SE1.D_E_L_E_T_  <> '*' "

	cQuery  += "ORDER BY E3_VEND,  E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E3_SEQ "
	
	cQuery  := ChangeQuery(cQuery)
	                           
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "COMISSAO", .F., .T.)
	
	// converte campos DATA/NUMERICO
	TCSetField('COMISSAO', "E1_EMISSAO", "D", 8, 0)
	TCSetField('COMISSAO', "E3_EMISSAO", "D", 8, 0)
	TCSetField('COMISSAO', "E3_BASE",    "N", 14,2)
	TCSetField('COMISSAO', "D2_TOTAL",   "N", 14,2)
	TCSetField('COMISSAO', "E1_VENCREA", "D", 8,0)
	TCSetField('COMISSAO', "E1_VALOR",   "N", 14,2)
	TCSetField('COMISSAO', "D2_CUSTO1",  "N", 14,2)
		
	Count To nRegistros
	
	oReport:SetMeter(nRegistros)
	
	COMISSAO->( dbGoTop() )
	While COMISSAO->( !Eof() )
	
		oReport:IncMeter()
		
		cVendedor:= COMISSAO->E3_VEND
		
		aAdd(aVend, {	cVendedor	,; 
						{}			,;//2  Array com a NF do VENDEDOR + GRUPO
						{}			})//3  Array com os totais por GRUPO
						
		aNF 	:= {}
		aLinha 	:= {}
        
		// retorna o total baixado
	   //	nTotNota := Fatur(cVendedor , COMISSAO->( B1_GRUPO ) )
		 

		While COMISSAO->( !Eof() )  .And. cVendedor == COMISSAO->E3_VEND
		
			aItem 	:= {}
			nTotPer:= 0
			
			//cNF	    := COMISSAO->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E3_SEQ)
			
			cNF	    := COMISSAO->( E3_PREFIXO + E3_NUM + E3_PARCELA + E3_TIPO+E3_SEQ + DTOS(E3_EMISSAO) )
			
			nBaseTit := 0         
			While COMISSAO->( !Eof() )  .And. cVendedor == COMISSAO->E3_VEND;
										.And. cNF == COMISSAO->( E3_PREFIXO + E3_NUM + E3_PARCELA + E3_TIPO+E3_SEQ  + DTOS(E3_EMISSAO))	//cNF == COMISSAO->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E3_SEQ)
			
			    //Retorna o percentual de desconto
				nPerDesc := FaixaDesc(COMISSAO->D2_COD, COMISSAO->D2_PRCVEN ) 
                                                                          
				aRet := TipoFaixa( cVendedor , COMISSAO->B1_GRUPO, COMISSAO->E1_EMISSAO )
                             
                cTipoFaixa := aRet[1] //
				cFaixa     := aRet[2] // Cod Faixa de comissao
				
				// posiciono na nota 
				SF2->( dbSeek(xFilial('SF2')+COMISSAO->E1_NUM+COMISSAO->E1_PREFIXO) )
				// condicao de pagamento
				SE4->( dbSeek(xFilial('SE4')+SF2->F2_COND) )
				nQtdParc := RetQtdParc(SE4->E4_COND, COMISSAO->E1_PREFIXO, COMISSAO->E1_NUM, COMISSAO->E1_TIPO)

				nFaixa := 0                                     

				// desconto financeiro -> baixa parcial ou descrecimo or Pagto parcela fatura/liq
				nPDescFin := COMISSAO->E3_DESCFIN / 100
            	
				// Valor base menos desconto financeiro percentual
            	nValBase := (COMISSAO->D2_TOTAL/nQtdParc)
            	nValBase -= Round( ( nValBase * nPDescFin ) ,2)
                
				If cTipoFaixa == "1"
					aRet   := Faixa( 0, nPerDesc, cVendedor,COMISSAO->B1_GRUPO , COMISSAO->E1_EMISSAO)						
					nFaixa := aRet[1]
				Else
					nFaixa := COMISSAO->E3_PORC
				EndIf

				//calcula a comissao 	
				nPerComis := nFaixa  
				// Jean Rehermann | Solutio IT - 17/05/2016 - Alterado para efetuar corretamente o arredondamento
				nValComis := Round( (( nPerComis * nValBase )/100), 2 ) //NoRound( (( nPerComis * nValBase )/100), 2 )
                
				aAdd(aItem, { 	COMISSAO->E1_PREFIXO	,;// 1
								COMISSAO->E1_NUM		,;// 2
								COMISSAO->E1_PARCELA	,;// 3
								COMISSAO->E1_TIPO		,;// 4
								COMISSAO->E3_BASE		,;// 5 Valor BASE
								nValComis				,;// 6 Valor da COMISSAO
								nPerComis				,;// 7 Percentual de COMISSAO
								COMISSAO->E3_CODCLI		,;// 8
								COMISSAO->E3_LOJA		,;// 9
								COMISSAO->A1_NOME		,;// 10
								COMISSAO->E3_SEQ		,;// 11
								COMISSAO->E1_EMISSAO	,;// 12
								COMISSAO->D2_PEDIDO		,;// 13
						        COMISSAO->D2_CUSTO1/nQtdParc ,;// 14     
				               	nValBase                 	,;// 15
				               	COMISSAO->D2_VALICM/nQtdParc ,;// 16
				               	COMISSAO->D2_VALIPI/nQtdParc ,;// 17
				               	COMISSAO->E1_VENCREA	,;// 18
				               	nPerDesc				,;// 19
				               	COMISSAO->E1_VALOR		,;// 20
	       					   	COMISSAO->B1_GRUPO		,;// 21
	       					   	COMISSAO->E3_EMISSAO	,;// 22
	       					   	cFaixa 					})// 23
			
 
				
				
				COMISSAO->( dbSkip() )
			EndDo
			    
			//For nI := 1 to Len( aItem)			
			//	aItem[nI][5] := nBaseTit
			//Next		
			
			//If Len(aItem) > 0
				//Incluir no ultimo item a diferenca do percentual ponderado
			//	aItem[Len(aItem),7] := ( aItem[Len(aItem),7] + (nPercent - nTotPer) )
			//EndIf 
			
			// ordeno por Grupo
			aItem := aSort(aItem,,, {|x,y| x[21] + x[23] <= y[21]+y[23] })

			// Jean Rehermann | Solutio IT - 17/05/2016 - Avalia se na divisão pelos itens o valor final arredondado fecha com o valor total
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
			For nZ := 1 To Len(aItem)
			
				// total por linha de produto
				nPos := aScan( aLinha, {|x| x[1] == aItem[nZ,21]  .And. x[10] == aItem[nZ,23]    } )
				
				If nPos > 0

					//If cGrupo != aItem[nZ,21]		 
						//aLinha[nPos,2] += aItem[nZ,5]
					//	aLinha[nPos,2] += aItem[nZ,15]
								
					//	cGrupo := aItem[nZ,21]		 
					//EndIf                           
					                                   
					aLinha[nPos,2] += aItem[nZ,15]
					aLinha[nPos,3] += aItem[nZ,6]
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
				
				aAdd(aNF, aItem[nZ])
			
			Next nZ
			
		EndDo
		
		// adiciono as NF do VENDEDOR
		aVend[Len(aVend),2]:= aNF
		// adiciono o total por GRUPO / LINHA
		aVend[Len(aVend),3]:= aLinha
		
	EndDo
	COMISSAO->( dbCloseArea() )
	
	oReport:SetMeter(Len(aVend))

	For nZ := 1 To Len(aVend)	
	
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
				                                    
				
				DbSelectArea( "SZB")
				DbSetOrder(1)
				DbSeek( xFilial("SZB") + aVend[nZ,2][nY,23] )
				
				cTipoFaixa := SZB->ZB_TIPO //TipoFaixa( aVend[nZ,1], aVend[nZ,2][nY,21] )				
				
				//cTipoFaixa := TipoFaixa( aVend[nZ,1], aVend[nZ,2][nY,21] )
				
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
				
				oSecMovi:Cell("E3_BASE"):SetBlock({ || nVlrBs          } )			
				
				oSecMovi:Cell("B1_GRUPO"):SetBlock({ || aVend[nZ,2][nY,21] } )			
				
				If cTipoFaixa == "1" //1=Percentual
					oSecMovi:Cell("D2_DESC"):Show() 
					oSecMovi:Cell("D2_DESC"):SetBlock({ || aVend[nZ,2][nY,19] } )			
				Else
					oSecMovi:Cell("D2_DESC"):Hide()								
				EndIf
				oSecMovi:Cell("D2_TOTAL"):SetBlock({ || aVend[nZ,2][nY,15] } ) 
				
				//-- Esta coluna demostra o percentual ponderado por ITEM
				//-- foi desativada por solicitacao da Jomhedica 02/10/13
				//oSecMovi:Cell("E3_PORC"):Disable()
				oSecMovi:Cell("E3_PORC"):SetBlock({ || aVend[nZ,2][nY,7] } )
				//--
				
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
		
		// ordeno por Linha
		aVend[nZ,3] := aSort(aVend[nZ,3],,, {|x,y| x[1] <= y[1]})
		
		oReport:SkipLine()
		oReport:Box(oReport:Row(),oReport:Col()+40,oReport:Row()+40,oReport:Col()+515)
		oReport:Say(oReport:Row(),oReport:Col()+45,"Participação por linha de produto")
		oReport:SkipLine()

		oSecLinh:Init()
		nVal_Comis := 0
		nVal_Base  := 0
		nBase_Bonus := 0 
		
		For nY := 1 To Len(aVend[nZ,3])
		
			SBM->( dbSeek(xFilial('SBM')+aVend[nZ,3][nY,1]) )
		
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
			//oSecLinh:Cell("CUSTO"):SetBlock({ ||  aVend[nZ,3][nY,5]  } )
			//oSecLinh:Cell("RESULT"):SetBlock({ ||  (aVend[nZ,3][nY,2] - aVend[nZ,3][nY,5])  } )
			
			//If !lMargem			
			//	oSecLinh:Cell("MARG_2"):Disable()
			//EndIf
			//oSecLinh:Cell("MARG_2"):SetBlock({ || ((aVend[nZ,3][nY,6] - aVend[nZ,3][nY,5])/aVend[nZ,3][nY,5])*100 } )			
			
			//oSecLinh:Cell("IMPOST"):SetBlock({ || aVend[nZ,3][nY,2]*(nImpFed/100) } )
			//oSecLinh:Cell("VALICM"):SetBlock({ ||  aVend[nZ,3][nY,7]  } )
			//oSecLinh:Cell("VALIPI"):SetBlock({ ||  aVend[nZ,3][nY,8]  } )
			oSecLinh:Cell("COMIS"):SetBlock({ ||  aVend[nZ,3][nY,3]  } )

			oSecLinh:PrintLine()                
        
			nVal_Comis += aVend[nZ,3][nY,3]
			nVal_Base  += aVend[nZ,3][nY,2]
		

		Next nY
		oSecLinh:Finish()						
		
		oSecVend:Finish() 
		        
		//////total geral por vendedor
		oReport:SkipLine()
		oReport:SkipLine()
		                       
		
		oReport:Say(oReport:Row(),oReport:Col()+100," Valor Bruto      : " + Transform( nVal_Comis , "@E 999,999,999.99")      )
		oReport:SkipLine()		
		
		//funcao que calcula o valor do bonus
		nVal_Bonus:= FaixaBonus( aVend[nZ,1] , nBase_Bonus )
		
		oReport:Say(oReport:Row(),oReport:Col()+100," Valor Bonus   (+): " + Transform( nVal_Bonus , "@E 999,999,999.99")      )
		oReport:SkipLine()		
		
		// condicao para calculo do IR do vendedor
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
					
		nVal_Imp := Round( 	((nVal_Comis +  nVal_Bonus ) * nPerImp ) / 100 , 2 )
		If nPerImp > 0
			oReport:Say(oReport:Row(),oReport:Col()+100," Valor Impostos(-): " + Transform( nVal_Imp , "@E 999,999,999.99")+ " (" + cValtoChar(nPerImp) + " % )" )
			oReport:SkipLine()
		EndIf
		
		oReport:SkipLine()                                                 
		
		nVal_Liq := (nVal_Comis +  nVal_Bonus ) - nVal_Imp
		oReport:Say(oReport:Row(),oReport:Col()+100," Valor Liquido    : " + Transform( nVal_Liq , "@E 999,999,999.99")      )
		
		oReport:SkipLine()
		
		If lSaltPag
			oReport:EndPage()		
		EndIf
			
	Next nZ
	
Return
                                       



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Fatur	   ³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna a produtividade do periodo informado               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/               
Static Function Fatur( cVend , cGrupo )

	Local cQuery 	:= ""
	Local nFat	:= 0
	    
	/*
	cQuery  := "SELECT SUM(D2_TOTAL) D2_TOTAL "
	
	cQuery  += "FROM" + RetSqlName("SF2") +" SF2, " 
	cQuery  += "    " + RetSqlName("SD2") +" SD2, "  
	cQuery  += "    " + RetSqlName("SF4") +" SF4 " 

	cQuery  += "WHERE F2_FILIAL       = '" + xFilial('SF2') + "' "
	cQuery  += "AND   F2_VEND1        = '" + cVend + "' "
	cQuery  += "AND   F2_EMISSAO      >='" + DtoS(MV_PAR01) + "' "
	cQuery  += "AND   F2_EMISSAO      <='" + DtoS(MV_PAR02) + "' "
	
	cQuery  += "AND   D2_FILIAL       = '" + xFilial('SD2') + "' "
	cQuery  += "AND   D2_DOC          = F2_DOC "
	cQuery  += "AND   D2_SERIE        = F2_SERIE "
	cQuery  += "AND   D2_CLIENTE      = F2_CLIENTE "
	cQuery  += "AND   D2_LOJA         = F2_LOJA "
	
	cQuery  += "AND   F4_FILIAL       = '" + xFilial('SF4') + "' "
	cQuery  += "AND   F4_CODIGO       = D2_TES "
	cQuery  += "AND   F4_DUPLIC       = 'S' "
	
	cQuery  += "AND   SD2.D_E_L_E_T_  <> '*' "
	cQuery  += "AND   SF2.D_E_L_E_T_  <> '*' "
	cQuery  += "AND   SF4.D_E_L_E_T_  <> '*' "
	    */
	cQuery  := "SELECT SUM( E3_BASE ) E3_BASE "
	
	cQuery  += "FROM" + RetSqlName("SE3") +" SE3 " 

	cQuery  += "WHERE E3_FILIAL       = '" + xFilial('SE3') + "' "
	cQuery  += "AND   E3_VEND          = '" + cVend  + "' "
	cQuery  += "AND   E3_GRUPO         = '" + cGrupo + "' "
	cQuery  += "AND   E3_EMISSAO      >='" + DtoS(MV_PAR01) + "' "
	cQuery  += "AND   E3_EMISSAO      <='" + DtoS(MV_PAR02) + "' "
	cQuery  += "AND   SE3.D_E_L_E_T_  <> '*' "
	    
	cQuery  := ChangeQuery(cQuery)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "FATUR", .F., .T.)
	
	FATUR->(dbGoTop())
	If FATUR->(!Eof())
		nFat := FATUR->E3_BASE  //D2_TOTAL 
	EndIf
	FATUR->(dbCloseArea())

Return(nFat)







/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Faixa     ³ Autor ³ Jeferson Dambros      ³ Data ³ Ago/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o percentual de comissao                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/               
Static Function Faixa(nVenda, nDesc, cVend, cGrupo, dDtEmis)
	
	Local cQuery := ""
	Local nFaixa := 0
	Local cFaixa := ""                                             
	
	DbSelectArea("SBM")
	DbSetOrder(1)
	DbSeek( xFilial("SBM") + cGrupo )
	
   	If !Empty( SBM->BM_GRPCOMI ) //Grupo de comissao
		cGrupo := SBM->BM_GRPCOMI	
   	EndIf	
	
	
	   
	If nVenda > 0  .And. nDesc == 0  	
	
		// Tabela especifica ( Regras de COMISSAO )
		// Procuro a faixa do VENDEDOR + GRUPO + VENDA
		cQuery := " SELECT ZB_COMIS, ZB_FAIXA "
		cQuery += " FROM " + RetSqlName("SZB")
		cQuery += " WHERE ZB_FILIAL  = '" + xFilial("SZB") + "'"
		cQuery += "	AND ZB_VEND    = '"+ cVend	+"'"
		cQuery += "	AND ZB_GRUPO   = '"+ cGrupo +"'"
		cQuery += "	AND ZB_FAXDE   <= "+ cValToChar(nVenda) 
		cQuery += "	AND ZB_FAXATE  >= "+ cValToChar(nVenda)
		cQuery += "	AND ZB_VIGENC  <= '"+ DToS(dDtEmis) + "'"
		cQuery += "	AND ZB_VIGEFIM >= '"+ DToS(dDtEmis) + "'"
		cQuery += "	AND D_E_L_E_T_ <> '*' "
		
		cQuery := ChangeQuery(cQuery)                           
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "FAIXA", .F., .T.)
	
		TcSetField("FAIXA","ZB_COMIS","N",6,2)
		
		FAIXA->(dbGoTop())
		If FAIXA->(!Eof())
					  
			nFaixa := FAIXA->ZB_COMIS
			cFaixa := FAIXA->ZB_FAIXA
	
		Else // Se nao existir, procuro a faixa do GRUPO + VENDA 
		
			FAIXA->(dbCloseArea())
		
			cQuery := " SELECT ZB_COMIS, ZB_FAIXA "
			cQuery += " FROM " + RetSqlName("SZB")
			cQuery += " WHERE ZB_FILIAL  = '" + xFilial("SZB") + "'"
			cQuery += "	AND ZB_VEND    = ''"
			cQuery += "	AND ZB_GRUPO   = '"+ cGrupo +"'"
			cQuery += "	AND ZB_FAXDE   <= "+ cValToChar(nVenda) 
			cQuery += "	AND ZB_FAXATE  >= "+ cValToChar(nVenda)
			cQuery += "	AND ZB_VIGENC  <= '"+ DToS(dDtEmis) + "'"
			cQuery += "	AND ZB_VIGEFIM >= '"+ DToS(dDtEmis) + "'"
			cQuery += "	AND D_E_L_E_T_ <> '*' "
			
			cQuery := ChangeQuery(cQuery)                           
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "FAIXA", .F., .T.)
		
			TcSetField("FAIXA","ZB_COMIS","N",6,2)
	
			FAIXA->(dbGoTop())
			If FAIXA->(!Eof())
					  
				nFaixa := FAIXA->ZB_COMIS
				cFaixa := FAIXA->ZB_FAIXA
			
			EndIf
			
		EndIf
		
		FAIXA->(dbCloseArea())
	
	EndIf	
	// Se não encontrar a faixa pelo valor, 
	// busco pelo VENDEDOR + GRUPO + DESCONTO
	If nVenda == 0 .And. nDesc >= 0
		
		cQuery := " SELECT ZB_COMIS, ZB_FAIXA "
		cQuery += " FROM " + RetSqlName("SZB")
		cQuery += " WHERE ZB_FILIAL  = '" + xFilial("SZB") + "'"
		cQuery += "	AND ZB_VEND    = '"+ cVend	+"'"
		cQuery += "	AND ZB_GRUPO   = '"+ cGrupo	+"'"
		cQuery += "	AND ZB_FAXDE   <= "+ cValToChar(nDesc) 
		cQuery += "	AND ZB_FAXATE  >= "+ cValToChar(nDesc)
		cQuery += "	AND ZB_VIGENC  <= '"+ DToS(dDtEmis) + "'"
		cQuery += "	AND ZB_VIGEFIM >= '"+ DToS(dDtEmis) + "'"
		cQuery += "	AND D_E_L_E_T_ <> '*' "
		
		cQuery := ChangeQuery(cQuery)                           
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "FAIXA", .F., .T.)
	
		TcSetField("FAIXA","ZB_COMIS","N",6,2)
	
		FAIXA->(dbGoTop())
		If FAIXA->(!Eof())
			
			nFaixa := FAIXA->ZB_COMIS
			cFaixa := FAIXA->ZB_FAIXA
			
		Else // Se nao existir, procuro a faixa do GRUPO + DESCONTO
			
			FAIXA->(dbCloseArea())
			
			cQuery := " SELECT ZB_COMIS, ZB_FAIXA "
			cQuery += " FROM " + RetSqlName("SZB")
			cQuery += " WHERE ZB_FILIAL  = '" + xFilial("SZB") + "'"
			cQuery += "	AND ZB_VEND    = ''"
			cQuery += "	AND ZB_GRUPO   = '"+ cGrupo + "'"
			cQuery += "	AND ZB_FAXDE   <= "+ cValToChar(nDesc) 
			cQuery += "	AND ZB_FAXATE  >= "+ cValToChar(nDesc)
			cQuery += "	AND ZB_VIGENC  <= '"+ DToS(dDtEmis) + "'"
			cQuery += "	AND ZB_VIGEFIM >= '"+ DToS(dDtEmis) + "'"
			cQuery += "	AND D_E_L_E_T_ <> '*' "
			
			cQuery := ChangeQuery(cQuery)                           
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "FAIXA", .F., .T.)
		
			TcSetField("FAIXA","ZB_COMIS","N",6,2)
	
			FAIXA->(dbGoTop())
			If FAIXA->(!Eof())
					  
				nFaixa := FAIXA->ZB_COMIS
				cFaixa := FAIXA->ZB_FAIXA
				
			EndIf
		EndIf
		
		FAIXA->(dbCloseArea())
		
	EndIf	
	
Return( { nFaixa , cFaixa } )

                                                            
/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FaixaBonus ³ Autor ³ Fernando Mazzarolo  ³ Data ³ out/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o Valor Bonus                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/               
Static Function FaixaBonus( _cVend , _nBase_Bonus )
	Local nRet := 0

	cQuery := " SELECT ZB_VALOR , ZB_FAIXA "
	cQuery += " FROM " + RetSqlName("SZB")
	cQuery += " WHERE ZB_FILIAL  = '" + xFilial("SZB") + "'"
	cQuery += "	AND ZB_VEND    = '" + _cVend + "'"
	cQuery += "	AND ZB_GRUPO   = ''"
	cQuery += "	AND ZB_FAXDE   <= "+ cValToChar(_nBase_Bonus) 
	cQuery += "	AND ZB_FAXATE  >= "+ cValToChar(_nBase_Bonus)
	//cQuery += "	AND ZB_VIGENC  <= '"+ DToS(dDtEmis) + "'"
	//cQuery += "	AND ZB_VIGEFIM >= '"+ DToS(dDtEmis) + "'"
	cQuery += "	AND D_E_L_E_T_ <> '*' "
	
	cQuery := ChangeQuery(cQuery)                           
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "FAIXA", .F., .T.)

	TcSetField("FAIXA","ZB_VALOR","N",6,2)

	FAIXA->(dbGoTop())
	If FAIXA->(!Eof())
			  
		nRet := FAIXA->ZB_VALOR
		
	EndIf

	FAIXA->(dbCloseArea())

Return( nRet )

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³TipoFaixa ³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o tipo de faixa.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/               
Static Function TipoFaixa(cVend, cGrupo , dEmissao )
	
	Local cQuery 		:= ""
	Local cTipoFaixa	:= ""           
	Local cFaixa     	:= ""           
	
	DbSelectArea("SBM")
	DbSetOrder(1)
	DbSeek( xFilial("SBM") + cGrupo )
	
   	If !Empty( SBM->BM_GRPCOMI ) //Grupo de comissao
   		cGrupo := SBM->BM_GRPCOMI	
  	EndIf	
	
	
	cQuery := " SELECT ZB_TIPO,ZB_FAIXA "
	cQuery += " FROM " + RetSqlName("SZB")
	cQuery += " WHERE ZB_FILIAL	= '"+ xFilial("SZB")	+"'"
	cQuery += "	  AND ZB_VEND	= '"+ cVend 			+"'"
	cQuery += "	  AND ZB_GRUPO	= '"+ cGrupo 			+"'"  
	cQuery += "	  AND ZB_VIGENC  <= '"+ DToS(dEmissao) + "'"
	cQuery += "	  AND ZB_VIGEFIM >= '"+ DToS(dEmissao) + "'"
	cQuery += "	  AND D_E_L_E_T_ <> '*' "
	
	cQuery := ChangeQuery(cQuery)                           
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "TPFAIXA", .F., .T.)
	
	TPFAIXA->(dbGoTop())
	If TPFAIXA->(!Eof())
		cTipoFaixa := TPFAIXA->ZB_TIPO
		cFaixa     := TPFAIXA->ZB_FAIXA
	EndIf
	TPFAIXA->(dbCloseArea())

Return( { cTipoFaixa , cFaixa } )


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FaixaDesc ³ Autor ³ Jeferson Dambros      ³ Data ³ Ago/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o percentual de desconto                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/               
Static Function FaixaDesc(cProduto, nValor)

	Local nPerDesc := 0
	
	// Tabela de preco
	Local cTabPrec := PadR( AllTrim( GetMV("JO_TABDESC") ), TamSX3("DA0_CODTAB")[1] )
		
	
	DA1->( dbSetOrder(1) )
	
	If DA1->( dbSeek(xFilial("DA1")+ cTabPrec + cProduto) )
	
		If DA1->DA1_PRCVEN > 0  .And. DA1->DA1_PRCVEN > nValor
	
			nPerDesc := 100 - Round( ( nValor / DA1->DA1_PRCVEN ) * 100 , 2 )
			
			If nPerDesc >= 100
				nPerDesc := 0
			EndIf
		
		EndIf
	
	EndIf

Return(nPerDesc)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RetQtdParc³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna a quantidade de parcela por NF                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/               
Static Function RetQtdParc(_cCondPgto, _cPrefixo, _cNum, _cTipo)
	
	Local nQtd   := 1
	Local cCond  := Alltrim(_cCondPgto)
	Local nPos
	
	/*
	If SE4->E4_TIPO <> '9'
		While Len(cCond) > 0
			nPos := At(',', cCond)
			If nPos > 0
				cCond := SubStr(cCond, nPos+1)
				nQtd++
			Else
				Exit
		    EndIf
		EndDo
	Else
	 */
	 
		// verifico quantos titulos foram gerados
		nQtd := 0
		
		SE1->( dbSetOrder(1) )		
		SE1->( dbSeek(xFilial("SE1")+_cPrefixo+_cNum) )
		
		While !SE1->( Eof() ) .And. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial("SE1")+_cPrefixo + _cNum
			
			If _cTipo == SE1->E1_TIPO
				nQtd++
			EndIf
			
			SE1->( dbSkip() )
			
		EndDo
		
	//EndIf

Return( nQtd )      


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CriaSx1   ³ Autor ³ Jeferson Dambros      ³ Data ³ Set/2013 ³±±
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
	Local cPerg := PadR("JMHR800",Len(SX1->X1_GRUPO)) 
	
	
	aAdd(aP,{"Baixa De"				,"D",8,0,"G","" ,""   	,""   ,""   ,"","",""})
	aAdd(aP,{"Baixa Ate"				,"D",8,0,"G","" ,""   	,""   ,""   ,"","",""})
	aAdd(aP,{"Cliente De"			,"C",6,0,"G","" ,"SA1"   ,""   ,""   ,"","",""})
	aAdd(aP,{"Loja De"				,"C",2,0,"G","" ,""   	,""   ,""   ,"","",""})
	aAdd(aP,{"Cliente Ate"			,"C",6,0,"G","" ,"SA1"  	,""   ,""   ,"","",""})
	aAdd(aP,{"Loja Ate"				,"C",2,0,"G","" ,""   	,""   ,""   ,"","",""})
	aAdd(aP,{"Vendedor De"			,"C",6,0,"G","" ,"SA3"   ,""   ,""   ,"","",""})
	aAdd(aP,{"Vendedor Ate"			,"C",6,0,"G","" ,"SA3"   ,""   ,""   ,"","",""})
	aAdd(aP,{"Analitico/Sintetico"	,"N",1,0,"C","" ,""  		,"Analitico"   ,"Sintetico"   ,"","",""})
	aAdd(aP,{"Salta pag. Vendedor"	,"N",1,0,"C","" ,""  		,"Sim"   ,"Nao"   ,"","",""})
	aAdd(aP,{"Demostra Margem"		,"N",1,0,"C","" ,""  		,"Sim"   ,"Nao"   ,"","",""})
	

    //           0123456789123456789012345678901234567890
    //                    1         2         3         4     
	aAdd(aHelp,{"Informe o periodo inicial."})
	aAdd(aHelp,{"Informe o periodo final."})
	aAdd(aHelp,{"Codigo do cliente inicial"})
	aAdd(aHelp,{"Loja do cliente inicial"})
	aAdd(aHelp,{"Codigo do cliente final"})
	aAdd(aHelp,{"Loja do cliente final"})
	aAdd(aHelp,{"Codigo do vendedor inicial"})
	aAdd(aHelp,{"Codigo do vendedor final"})
	aAdd(aHelp,{"Analitico: Modo de impressão detalhada", "Sintetico: Modo de impressao resumida"})
	aAdd(aHelp,{"Salta a pagina por vendedor"})
	aAdd(aHelp,{"Demostra as colunas referente ao custo", "por parcela"})
	
	
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