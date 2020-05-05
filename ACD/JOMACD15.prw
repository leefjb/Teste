#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "Totvs.ch"
#DEFINE DMPAPER_A4 9


/*/{Protheus.doc} JOMACD15
//Rel Rastro ID etiquetas
@author Celso Rene
@since 17/04/2019
@version 1.0
@type function
/*/
User Function JOMACD15()


	Private Cabec1 := "ETIQUETA      PRODUTO        LOTE        V.Lote     PEDIDO   QTD.    CLIENTE       EMISSAO      NOTA          SERIE   TES"     
	//                 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012323456789012345
	//                          1         2         3         4         5         6         7         8         9        10        11        12        13        14        1	Private Cabec2      	:= ""
	Private Cabec2      	:= ""
	Private nLin        	:= 80
	Private lEnd        	:= .F.
	Private CbTxt       	:= ""
	Private Tamanho			:= "G"
	Private nTipo       	:= 18
	Private nLastKey    	:= 0
	Private cbtxt   	   	:= Space(10)
	Private cbcont	     	:= 00
	Private CONTFL      	:= 01
	Private m_pag       	:= 01
	Private cLogo       	:= "lgrl01.bmp"
	Private _cQry 			:= ""
	Private cDesc1      	:= "Relatório de rastreio de etiquetas"
	Private cDesc2      	:= ""
	Private cDesc3      	:= ""
	Private titulo      	:= "Relatório de rastreio de etiquetas"
	Private lAbortPrint		:= .F.
	Private _limite     	:= 70
	Private NomeProg    	:= "JOMACD15"
	Private cReport	    	:= "JOMACD15"
	Private cPerg     		:= "JOMACD15"
	Private cString 		:= "CB0"
	Private aOrd			:= {}
	Private	wnrel       	:= "JOMACD15"
	Private	cPag			:= "00"
	Private aReturn     	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private _nReg 			:= 0

	Private oReport 


	//////

	xGeraPerg(cPerg)
	oReport := ReportDef(cString)
	oReport:PrintDialog()

	Return()

	/////

	/*
	xGeraPerg(cPerg)
	Pergunte(cPerg,.F.)	

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)


	If (aReturn[5] == 1) // OPCAO OK - SetPrint

	If (mv_par11 == 1) //relatorio impressora

	//SetDefault(aReturn,cString)
	//If nLastKey == 27
	//Return
	//Endif
	//nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| ProcRel(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	//oReport := TReport():New( "JOMAC15", titulo, cPerg, { |oReport| ProcRel( oReport, cPerg ) }, titulo )

	//oReport := ProcRel(Cabec1,Cabec2,Titulo,nLin) 
	//oReport:PrintDialog()

	ElseIf (mv_par11 == 2) //relatorio planilha

	RptStatus({|| ImpExcel() },Titulo)

	EndIf

	EndIf
	*/

Return()


/*/{Protheus.doc} xQuery
//Query - selecao itens do relatorio
@author Celso Rene
@since 17/04/2019
@version 1.0
@type function
/*/
Static Function xQuery()

	Local _cQuery 	:= ""  

	_cQuery := "SELECT * FROM ( " + chr(13)

	//etiquetas separadas
	_cQuery += " SELECT " + chr(13)
	_cQuery += " CB9.CB9_CODETI ETIQUETA " + chr(13)
	_cQuery += " ,CB9.CB9_PROD PRODUTO " + chr(13)
	_cQuery += " ,SB1.B1_DESC DESPROD  " + chr(13)
	_cQuery += " ,CB9.CB9_ORDSEP ORDSEP " + chr(13)
	_cQuery += " ,CB9.CB9_PEDIDO PEDIDO " + chr(13)
	_cQuery += " ,CB9.CB9_ITESEP ITEM " + chr(13)
	_cQuery += " ,CB9.CB9_LOCAL ALMOX " + chr(13)
	_cQuery += " ,CB9.CB9_LOTECT LOTE " + chr(13)
	_cQuery += " ,CB9.CB9_QTESEP QUANT " + chr(13)
	_cQuery += " ,CB7.CB7_CLIENT CLIENTE " + chr(13)
	_cQuery += " ,CB7.CB7_LOJA LOJA " + chr(13)
	_cQuery += " ,SA1.A1_NREDUZ NOMECLI " + chr(13)
	_cQuery += " ,CB7.CB7_NOTA NOTA " + chr(13)
	_cQuery += " ,CB7.CB7_SERIE SERIE " + chr(13)
	_cQuery += " , ISNULL(SF2.F2_EMISSAO,CB7.CB7_DTFIMS) AS EMISSAO " + chr(13)
	_cQuery += " ,'' AF " + chr(13)
	_cQuery += " ,'SEPARADA' TABELA " + chr(13) //CB9 - 
	_cQuery += " , SC6.C6_TES TES " + chr(13)
	_cQuery += " ,'S' TIPO " + chr(13)
	_cQuery += " FROM " + Retsqlname("CB9") + " CB9 " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SB1") + " SB1 ON SB1.D_E_L_E_T_='' AND SB1.B1_COD = CB9.CB9_PROD " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("CB7") + " CB7 ON CB7.D_E_L_E_T_='' AND CB7.CB7_ORDSEP = CB9.CB9_ORDSEP AND CB7.CB7_PEDIDO = CB9.CB9_PEDIDO AND CB7.CB7_CLIENT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND CB7.CB7_DTFIMS BETWEEN '" + DtoS(mv_par09) + "' AND '" + DtoS(mv_par10) + "' " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SC5") + " SC5 ON SC5.D_E_L_E_T_='' AND SC5.C5_NUM = CB7.CB7_PEDIDO " + chr(13) // AND SC5.C5_EMISSAO BETWEEN '" + DtoS(mv_par09) + "' AND '" + DtoS(mv_par10) + "'
	_cQuery += " INNER JOIN " + Retsqlname("SC6") + " SC6 ON SC6.D_E_L_E_T_='' AND SC6.C6_NUM = CB9.CB9_PEDIDO AND SC6.C6_PRODUTO = CB9.CB9_PROD AND SC6.C6_ITEM = CB9.CB9_ITESEP " + chr(13)
	_cQuery += " LEFT JOIN  " + Retsqlname("SF2") + " SF2 ON SF2.F2_DOC = CB7.CB7_NOTA AND SF2.F2_SERIE = CB7.CB7_SERIE AND SF2.D_E_L_E_T_='' " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SA1") + " SA1 ON SA1.D_E_L_E_T_='' AND SA1.A1_COD = CB7.CB7_CLIENT AND SA1.A1_LOJA = CB7.CB7_LOJA " + chr(13)
	_cQuery += " WHERE CB9.D_E_L_E_T_='' " + chr(13)
	_cQuery += " AND CB9.CB9_PROD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND CB9.CB9_CODETI BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " + chr(13)
	_cQuery += " AND CB9.CB9_LOTECT BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'  "  + chr(13)

	_cQuery += "UNION ALL " + chr(13)

	//etiquetas separadas - reutilizadas
	_cQuery += " SELECT " + chr(13) 
	_cQuery += " ZZH.ZZH_CODETI ETIQUETA " + chr(13)
	_cQuery += " ,ZZH.ZZH_PROD PRODUTO " + chr(13)
	_cQuery += " ,SB1.B1_DESC DESPROD  " + chr(13)
	_cQuery += " ,ZZH.ZZH_ORDSEP ORDSEP " + chr(13)
	_cQuery += " ,ZZH.ZZH_PEDIDO PEDIDO " + chr(13)
	_cQuery += " ,ZZH.ZZH_ITSEP ITEM " + chr(13)
	_cQuery += " ,ZZH.ZZH_LOCAL ALMOX " + chr(13)
	_cQuery += " ,ZZH.ZZH_LOTECT LOTE " + chr(13)
	_cQuery += " ,ZZH.ZZH_QTESEP QUANT " + chr(13)
	_cQuery += " ,CB7.CB7_CLIENT CLIENTE " + chr(13)
	_cQuery += " ,CB7.CB7_LOJA LOJA " + chr(13)
	_cQuery += " ,SA1.A1_NREDUZ NOMECLI " + chr(13)
	_cQuery += " ,CB7.CB7_NOTA NOTA " + chr(13)
	_cQuery += " ,CB7.CB7_SERIE SERIE " + chr(13)
	_cQuery += " , ISNULL(SF2.F2_EMISSAO,CB7.CB7_DTFIMS) AS EMISSAO " + chr(13)
	_cQuery += " ,'' AF " + chr(13)
	_cQuery += " ,'HIST. SEPARACAO' TABELA " + chr(13) //ZZH
	_cQuery += " , SC6.C6_TES TES " + chr(13)
	_cQuery += " ,'S' TIPO " + chr(13)
	_cQuery += " FROM " + Retsqlname("ZZH") + " ZZH " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SB1") + " SB1 ON SB1.D_E_L_E_T_='' AND SB1.B1_COD = ZZH.ZZH_PROD " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("CB7") + " CB7  ON CB7.D_E_L_E_T_='' AND CB7.CB7_ORDSEP = ZZH.ZZH_ORDSEP AND CB7.CB7_PEDIDO = ZZH.ZZH_PEDIDO AND CB7.CB7_CLIENT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND CB7.CB7_DTFIMS BETWEEN '" + DtoS(mv_par09) + "' AND '" + DtoS(mv_par10) + "' " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SC5") + " SC5 ON SC5.D_E_L_E_T_='' AND SC5.C5_NUM = CB7.CB7_PEDIDO " + chr(13) // AND SC5.C5_EMISSAO BETWEEN '" + DtoS(mv_par09) + "' AND '" + DtoS(mv_par10) + "' 
	_cQuery += " INNER JOIN " + Retsqlname("SC6") + " SC6 ON SC6.D_E_L_E_T_='' AND SC6.C6_NUM = ZZH.ZZH_PEDIDO AND SC6.C6_PRODUTO = ZZH.ZZH_PROD AND SC6.C6_ITEM = ZZH.ZZH_ITSEP " + CHR(13)
	_cQuery += " LEFT JOIN " + Retsqlname("SF2") + " SF2 ON SF2.F2_DOC = CB7.CB7_NOTA AND SF2.F2_SERIE = CB7.CB7_SERIE AND SF2.D_E_L_E_T_='' " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SA1") + " SA1 ON SA1.D_E_L_E_T_='' AND SA1.A1_COD = CB7.CB7_CLIENT AND SA1.A1_LOJA = CB7.CB7_LOJA " + chr(13)
	_cQuery += " WHERE ZZH.D_E_L_E_T_='' " + chr(13) 
	_cQuery += " AND ZZH.ZZH_PROD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND ZZH.ZZH_CODETI BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " + chr(13)
	_cQuery += " AND ZZH.ZZH_LOTECT BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'  " + chr(13)

	_cQuery += "UNION ALL " + chr(13)

	//etiquetas pedidos de vendas geradas da A.F. e sem separacao
	_cQuery += " SELECT " + chr(13) 
	_cQuery += " SC6.C6_XETIQ ETIQUETA " + chr(13)
	_cQuery += " ,SC6.C6_PRODUTO PRODUTO " + chr(13)
	_cQuery += " ,SB1.B1_DESC DESPROD  " + chr(13)
	_cQuery += " ,'' ORDSEP " + chr(13)
	_cQuery += " ,SC6.C6_NUM PEDIDO " + chr(13)
	_cQuery += " ,SC6.C6_ITEM ITEM " + chr(13)
	_cQuery += " ,SC6.C6_LOCAL ALMOX " + chr(13)
	_cQuery += " ,SC6.C6_LOTECTL LOTE " + chr(13)
	_cQuery += " ,SC6.C6_QTDVEN QUANT " + chr(13)
	_cQuery += " ,SC6.C6_CLI CLIENTE " + chr(13)
	_cQuery += " ,SC6.C6_LOJA LOJA " + chr(13)
	_cQuery += " ,SA1.A1_NREDUZ NOMECLI " + chr(13)
	_cQuery += " ,SC6.C6_NOTA NOTA " + chr(13)
	_cQuery += " ,SC6.C6_SERIE SERIE " + chr(13)
	_cQuery += " , ISNULL(SF2.F2_EMISSAO,SC5.C5_EMISSAO) AS EMISSAO " + chr(13)
	_cQuery += " ,SC5.C5_AF AF " + chr(13)
	_cQuery += " ,'A.F. COM PEDIDO' TABELA " + chr(13) //SC6AF
	_cQuery += " ,SC6.C6_TES TES " + chr(13)
	_cQuery += " ,'S' TIPO " + chr(13)
	_cQuery += " FROM " + Retsqlname("SC6") + " SC6 " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SB1") + " SB1 ON SB1.D_E_L_E_T_='' AND SB1.B1_COD = SC6.C6_PRODUTO " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SC5") + " SC5 ON SC5.D_E_L_E_T_='' AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_AF <> '' AND SC5.C5_EMISSAO BETWEEN '" + DtoS(mv_par09) + "' AND '" + DtoS(mv_par10) + "' " + chr(13)
	_cQuery += " LEFT JOIN " + Retsqlname("SF2")  + " SF2 ON SF2.F2_DOC = SC6.C6_NOTA AND SF2.F2_SERIE = SC6.C6_SERIE " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SA1") + " SA1 ON SA1.D_E_L_E_T_='' AND SA1.A1_COD = SC6.C6_CLI AND SA1.A1_LOJA = SC6.C6_LOJA " + chr(13)
	_cQuery += " WHERE NOT EXISTS (SELECT TOP 1 CB7.CB7_ORDSEP FROM  " + Retsqlname("CB7") + " CB7 WHERE CB7.D_E_L_E_T_ = '' AND CB7.CB7_PEDIDO = SC6.C6_NUM) " + chr(13)
	_cQuery += " AND RTRIM(SC6.C6_XETIQ) <> '' AND SC6.C6_BLQ = '' " + chr(13)
	_cQuery += " AND SC6.C6_PRODUTO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND SC6.C6_XETIQ BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " + chr(13)
	_cQuery += " AND SC6.C6_LOTECTL BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND SC6.C6_CLI BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "  + chr(13)   	

	_cQuery += "UNION ALL " + chr(13)

	//etiquetas pedidos de vendas geradas sem A.F. e sem separacao
	_cQuery += " SELECT " + chr(13) 
	_cQuery += " SC6.C6_XETIQ ETIQUETA " + chr(13)
	_cQuery += " ,SC6.C6_PRODUTO PRODUTO " + chr(13)
	_cQuery += " ,SB1.B1_DESC DESPROD " + chr(13)
	_cQuery += " ,'' ORDSEP " + chr(13)
	_cQuery += " ,SC6.C6_NUM PEDIDO " + chr(13)
	_cQuery += " ,SC6.C6_ITEM ITEM " + chr(13)
	_cQuery += " ,SC6.C6_LOCAL ALMOX " + chr(13)
	_cQuery += " ,SC6.C6_LOTECTL LOTE " + chr(13)
	_cQuery += " ,SC6.C6_QTDVEN QUANT " + chr(13)
	_cQuery += " ,SC6.C6_CLI CLIENTE " + chr(13)
	_cQuery += " ,SC6.C6_LOJA LOJA " + chr(13)
	_cQuery += " ,SA1.A1_NREDUZ NOMECLI " + chr(13)
	_cQuery += " ,SC6.C6_NOTA NOTA " + chr(13)
	_cQuery += " ,SC6.C6_SERIE SERIE " + chr(13)
	_cQuery += " , ISNULL(SF2.F2_EMISSAO,SC5.C5_EMISSAO) AS EMISSAO " + chr(13)
	_cQuery += " ,SC5.C5_AF AF " + chr(13)
	_cQuery += " ,'PEDIDO SEM A.F. ' TABELA  " + chr(13) //SC6SAF 
	_cQuery += " ,SC6.C6_TES TES " + chr(13)
	_cQuery += " ,'S' TIPO " + chr(13)
	_cQuery += " FROM " + Retsqlname("SC6") + " SC6 " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SB1") + " SB1 ON SB1.D_E_L_E_T_='' AND SB1.B1_COD = SC6.C6_PRODUTO  " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SC5") + " SC5 ON SC5.D_E_L_E_T_='' AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_AF = '' AND SC5.C5_AF <> '' AND SC5.C5_EMISSAO BETWEEN '" + DtoS(mv_par09) + "' AND '" + DtoS(mv_par10) + "' " + chr(13)
	_cQuery += " LEFT JOIN " + Retsqlname("SF2") + " SF2 ON SF2.F2_DOC = SC6.C6_NOTA AND SF2.F2_SERIE = SC6.C6_SERIE " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SA1") + " SA1 ON SA1.D_E_L_E_T_='' AND SA1.A1_COD = SC6.C6_CLI AND SA1.A1_LOJA = SC6.C6_LOJA  " + chr(13)
	_cQuery += " WHERE NOT EXISTS (SELECT TOP 1 CB7.CB7_ORDSEP FROM " + Retsqlname("CB7") + " CB7 WHERE CB7.D_E_L_E_T_ = '' AND CB7.CB7_PEDIDO = SC6.C6_NUM)  " + chr(13)
	_cQuery += " AND RTRIM(SC6.C6_XETIQ) <> '' AND SC6.C6_BLQ = '' " + chr(13)
	_cQuery += " AND SC6.C6_PRODUTO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND SC6.C6_XETIQ BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " + chr(13)
	_cQuery += " AND SC6.C6_LOTECTL BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND SC6.C6_CLI BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "  + chr(13)   	


	If (mv_par11 == 2) //relatorio planilha - excel - somenta planilha = A.F. com devolucao e sem pedido de venda
		
		_cQuery += "UNION ALL " + chr(13)

		//etiquetas - A.F. e sem pedido de venda 
		_cQuery += " SELECT " + chr(13)
		_cQuery += " SZP.ZP_ETIQ ETIQUETA " + chr(13)
		_cQuery += " ,SZP.ZP_PRODUTO PRODUTO " + chr(13)
		_cQuery += " ,SB1.B1_DESC DESPROD  " + chr(13)
		_cQuery += " ,'' ORDSEP " + chr(13)
		_cQuery += " ,SZO.ZO_PEDIDO PEDIDO " + chr(13)
		_cQuery += " ,SZP.ZP_ITEM ITEM " + chr(13)
		_cQuery += " ,SZP.ZP_LOCORIG ALMOX " + chr(13)
		_cQuery += " ,SZP.ZP_LOTECTL LOTE " + chr(13)
		_cQuery += " ,SZP.ZP_QTDE QUANT " + chr(13)
		_cQuery += " ,SZO.ZO_CLIFAT CLIENTE " + chr(13)
		_cQuery += " ,SZO.ZO_LOJFAT LOJA " + chr(13)
		_cQuery += " ,SA1.A1_NREDUZ NOMECLI " + chr(13)
		_cQuery += " ,SZO.ZO_NFSAISA NOTA " + chr(13)
		_cQuery += " ,SZO.ZO_SERSAID SERIE " + chr(13)
		_cQuery += " ,SF1.F1_EMISSAO AS EMISSAO " + chr(13)
		_cQuery += " ,SZP.ZP_NUM AF " + chr(13) 
		_cQuery += " ,'A.F. SEM PEDIDO ' TABELA " + chr(13)
		_cQuery += " ,'' TES " + chr(13)
		_cQuery += " ,'S' TIPO " + chr(13)
		_cQuery += " FROM " + Retsqlname("SZP") + " SZP " + chr(13)
		_cQuery += " INNER JOIN " + Retsqlname("SB1") + " SB1 ON SB1.D_E_L_E_T_='' AND SB1.B1_COD = SZP.ZP_PRODUTO " + chr(13)
		_cQuery += " INNER JOIN " + Retsqlname("SZO") + " SZO ON SZO.D_E_L_E_T_='' AND SZO.ZO_NUM = SZP.ZP_NUM AND SZO.ZO_PEDIDO = '' AND SZO.ZO_STATUS IN ('9','5') AND SZO.ZO_TIPO = '1' AND SZO.ZO_CLIENTE BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' " + chr(13)
		_cQuery += " INNER JOIN " + Retsqlname("SA1") + " SA1 ON SA1.D_E_L_E_T_='' AND SA1.A1_COD = SZO.ZO_CLIENTE AND SA1.A1_LOJA = SZO.ZO_LOJA " + chr(13)
		_cQuery += " INNER JOIN " + Retsqlname("SF1") + " SF1 ON SF1.D_E_L_E_T_='' AND SF1.F1_DOC = SZO.ZO_NFENTRA AND SF1.F1_SERIE = SZO.ZO_SERENTR AND SF1.F1_FORNECE = SZO.ZO_CLIENTE AND SF1.F1_LOJA = SZO.ZO_LOJA AND SF1.F1_EMISSAO BETWEEN '" + DtoS(mv_par09) + "' AND '" + DtoS(mv_par10) + "' " + chr(13)
		_cQuery += " WHERE SZP.D_E_L_E_T_='' AND RTRIM(SZP.ZP_ETIQ) <> '' " +chr(13) 
		_cQuery += " AND SZP.ZP_PRODUTO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND SZP.ZP_ETIQ BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " + chr(13)
		_cQuery += " AND SZP.ZP_LOTECTL BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "

	EndIf   

	_cQuery += "UNION ALL " + chr(13)

	//etiquetas - devolucoes
	_cQuery += " SELECT " + chr(13) 
	_cQuery += " SD1.D1_XIDETIQ ETIQUETA " + chr(13) 
	_cQuery += " ,SD1.D1_COD PRODUTO " + chr(13)
	_cQuery += " ,SB1.B1_DESC DESPROD " + chr(13)
	_cQuery += " ,'' ORDSEP " + chr(13)
	_cQuery += " ,'' PEDIDO " + chr(13)
	_cQuery += " ,SD1.D1_ITEM ITEM " + chr(13)
	_cQuery += " ,SD1.D1_LOCAL ALMOX " + chr(13)
	_cQuery += " ,SD1.D1_LOTECTL LOTE " + chr(13)
	_cQuery += " ,SD1.D1_QUANT QUANT " + chr(13)
	_cQuery += " ,SD1.D1_FORNECE CLIENTE " + chr(13)
	_cQuery += " ,SD1.D1_LOJA LOJA " + chr(13)
	_cQuery += " ,SA1.A1_NREDUZ NOMECLI " + chr(13)
	_cQuery += " ,SD1.D1_DOC NOTA " + chr(13)
	_cQuery += " ,SD1.D1_SERIE SERIE " + chr(13)
	_cQuery += " ,SD1.D1_EMISSAO AS EMISSAO " + chr(13)
	_cQuery += " ,'' AF " + chr(13)
	_cQuery += " ,'DEV. ENTRADA' TABELA " + chr(13) //SD1
	_cQuery += " , SD1.D1_TES TES " + chr(13)	
	_cQuery += " ,'E' TIPO " + chr(13) 
	_cQuery += " FROM " + Retsqlname("SD1") + " SD1 " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SB1") + " SB1 ON SB1.D_E_L_E_T_='' AND SB1.B1_COD = SD1.D1_COD " + chr(13) 
	_cQuery += " INNER JOIN " + Retsqlname("SA1") + " SA1 ON SA1.D_E_L_E_T_='' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA " + chr(13)
	_cQuery += " WHERE SD1.D_E_L_E_T_ = '' AND SD1.D1_TIPO IN ('D','B') " + chr(13)
	_cQuery += " AND EXISTS (SELECT TOP 1 CB7.CB7_ORDSEP FROM " + Retsqlname("CB7") + " CB7 WHERE CB7.D_E_L_E_T_='' AND CB7.CB7_NOTA = SD1.D1_NFORI AND CB7.CB7_SERIE = SD1.D1_SERIORI) " + chr(13)
	_cQuery += " AND SD1.D1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND SD1.D1_XIDETIQ BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' AND SD1.D1_XIDETIQ <> '' " + chr(13)
	_cQuery += " AND SD1.D1_LOTECTL BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' " + chr(13)
	_cQuery += " AND SD1.D1_FORNECE BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'" + chr(13)

	_cQuery += "  ) AS TABETIQ " + chr(13)
	_cQuery += "  ORDER BY ETIQUETA , EMISSAO , NOTA " 


Return(_cQuery)



/*/{Protheus.doc} ImpExcel
//Impressao reltorio - formato Excel
@author Celso Rene
@since 17/04/2019
@version 1.0
@type function
/*/
Static Function ImpExcel()

	Private _aItens		:= {}
	Private oProcess  	:= Nil

	//query para selecao dos registros - movimentos etiquetas
	_cQry := xQuery()

	If Select("TMP") <> 0
		TMP->(DbCloseArea())
	EndIf

	TcQuery _cQry New Alias "TMP"

	DbSelectArea("TMP")
	TMP->(DbGotop())

	If TMP->( EOF() )
		MsgInfo("Conforme parametros informados não foi encontrado nenhum registro!","Registros não encontrados")
		dbCloseArea("TMP")
		Return()
	ELse
		dbSelectArea("TMP")
		//Contando os registros e voltando ao topo da tabela
		Count To _nReg
		TMP->(DbGoTop())
	EndIf	


	ProcRegua(_nReg)

	Do While TMP->(!EOF())


		//buscando informacoes no pedido de venda
		_cPaciente := ""
		_cCliVale  := ""
		_cLojaVale  := ""
		_cNomeVale  := ""	
		If !(Empty(TMP->PEDIDO) )
			dbSelectARea("SC5")
			dbSetOrder(1)
			dbSeek(xFilial("SC5") + TMP->PEDIDO )
			If (Found())
				_cPaciente := Alltrim(SC5->C5_PACIENTE) //Posicione("SC5",1,xFilial("SC5") + TMP->PEDIDO ,"C5_PACIENTE")
				_cCliVale  	:= SC5->C5_CLIVALE
				_cLojaVale  := SC5->C5_LJCVALE
				_cNomeVale  := Posicione("SA1",1,xFilial("SA1") + _cCliVale + _cLojaVale ,"A1_NREDUZ")
			EndIf
		EndIf

		//busca data validade do lote
		_dVldLote  := DtoC(Posicione("SB8",3,xfilial("SB8") + TMP->PRODUTO + TMP->ALMOX + TMP->LOTE ,"B8_DTVALID"))

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1") + TMP->PRODUTO)

		_nQuant := If (Empty(TMP->NOTA),0, TMP->QUANT)
		//tratamento quantidade - quando devolvido (-)
		/*If (TMP->TIPO == "E")
		_nQuant := _nQuant * -1 
		EndIf*/

		//adicionando itens para impressao funcionalidade Excel
		Aadd( _aItens,{ ;
		CHR(160) + TMP->ETIQUETA 			,;		 
		CHR(160) + TMP->PRODUTO 			,;
		CHR(160) + TMP->DESPROD 			,;
		CHR(160) + SB1->B1_TIPO				,;										    
		CHR(160) + SB1->B1_UM				,;
		CHR(160) + TMP->LOTE 				,;
		CHR(160) + _dVldLote				,;
		CHR(160) + TMP->PEDIDO 				,;
		CHR(160) + TMP->ORDSEP 				,;
		CHR(160) + TMP->AF 					,;
		CHR(160) + TMP->ALMOX				,;
		If ( TMP->TES < "500"  ,_nQuant,0 ) ,;
		If ( TMP->TES >= "500" ,_nQuant,0 ) ,;
		DtoC(StoD(TMP->EMISSAO))			,;
		CHR(160) + TMP->TES					,; //CHR(160) + TMP->TIPO				,;
		CHR(160) + Alltrim(Posicione("SF4",1,xFilial("SF4") + TMP->TES, "F4_TEXTO") ) ,;
		CHR(160) + Alltrim(TMP->NOTA)		,;
		CHR(160) + Alltrim(TMP->SERIE)		,; 	
		CHR(160) + TMP->CLIENTE				,;
		CHR(160) + TMP->LOJA				,;
		CHR(160) + Alltrim(TMP->NOMECLI)	,;
		CHR(160) + _cPaciente        		,;	
		CHR(160) + _cCliVale				,;
		CHR(160) + _cLojaVale				,;
		CHR(160) + _cNomeVale  				,;		   
		CHR(160) + TMP->TABELA				;
		})


		IncProc(TMP->ETIQUETA)
		TMP->(DbSkip())		

	EndDo


	dbCloseArea("TMP")

	oProcess := MsNewProcess():New({|lEnd| xImpExcel(oProcess)},"Gerando Rel. Rastro Etiquetas",.T.)
	oProcess:Activate()


Return()


/*/{Protheus.doc} xImpExcel
//Configurando impressao planilha em formato com layout pre-definido 
@author Celso Rene
@since 17/04/2019
@version 1.0
@type function
/*/

Static Function xImpExcel()

	Local nRet		:= 0
	Local oExcel 	:= FWMSEXCEL():New()


	If (Len(_aItens) > 0) 

		oProcess:SetRegua1(Len(_aItens))

		oExcel:AddworkSheet("JOMACD15")
		oExcel:AddTable ("JOMACD15","JOMACD15")


		//cabecalho relatorio excel
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"ETIQUETA"	 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"PRODUTO"	 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"DESC. PROD" 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"TIPO"		 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"UM"		 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"LOTE"		 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"VLD. LOTE"  	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"PEDIDO"	 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"ORD. SEP"	 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"AF"		 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"LOCAL"		 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"QTD. ENTR." 	,1,2)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"QTD. SAID."	,1,2)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"EMISSAO"	 	,1,1)
		oExcel:AddColumn("JOMACD15","JOMACD15"	,	"TES"			,1,1)
		oExcel:AddColumn("JOMACD15","JOMACD15"	,	"MOVIMENTO"	 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"DOCUMENTO"	 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"SERIE"		 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"COD. CLIENTE"	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"LOJA"		 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"NOME CLIENTE" 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"PACIENTE"	 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"COD. CLIVALE" 	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"LOJA  CLIVALE"	,1,1)
		oExcel:AddColumn("JOMACD15"	,"JOMACD15"	,	"NOME CLIVALE"	,1,1)
		oExcel:AddColumn("JOMACD15","JOMACD15"	,	"TABELA"	 	,1,1)


		oProcess:SetRegua1(Len(_aItens))

		For nI:= 1 to Len(_aItens)
			oExcel:AddRow("JOMACD15","JOMACD15",_aItens[nI])
			oProcess:IncRegua1("Imprimindo Registros: " + _aItens[nI][1] )
		Next nI


		oExcel:Activate()

		If(ExistDir("C:\Report") == .F.)
			nRet := MakeDir("C:\Report")
		Endif

		If(nRet != 0)
			MsgAlert("Erro ao criar diretório")
		Else
			oExcel:GetXMLFile("C:\Report\JOMACD15.xml")
			shellExecute("Open", "C:\Report\JOMACD15.xml", " /k dir", "C:\", 1 )
		Endif

	EndIf


Return()



/*/{Protheus.doc} GeraPerg
//rotina para gerar a SX1 - pergunta relatorio
@author Celso Rene
@since 17/04/2019
@version 1.0
@type function
/*/
Static Function xGeraPerg(_xcPerg)

	Local aP     := {}
	Local nI     := 0
	Local cSeq   := ""
	Local cMvCh  := ""
	Local cMvPar := ""
	Local aHelp  := {}

	//--      Texto Pergunta        , Tipo             , Tam                   , Dec          , G=Get/C=Combo, Val,         F3,              Def01,              Def02,        Def03, Def04, Def05
	aAdd(aP,{ "Produto de "		    , "C"              , 15					   , 0            , "G"          ,  "",       "SB1",         	    "",                 "",           "",    "",    "" })
	aAdd(aP,{ "Produto ate "		, "C"              , 15					   , 0            , "G"          ,  "",       "SB1",         	    "",                 "",           "",    "",    "" })
	aAdd(aP,{ "Cliente de "		    , "C"              , 6					   , 0            , "G"          ,  "",       "SA1",         	    "",                 "",           "",    "",    "" })
	aAdd(aP,{ "Cliente ate "		, "C"              , 6					   , 0            , "G"          ,  "",       "SA1",         	    "",                 "",           "",    "",    "" })
	aAdd(aP,{ "Lote de "		    , "C"              , 10                    , 0            , "G"          ,  "",          "",         	    "",                 "",           "",    "",    "" })
	aAdd(aP,{ "Lote ate "		    , "C"              , 10                    , 0            , "G"          ,  "",          "",         	    "",                 "",           "",    "",    "" })
	aAdd(aP,{ "Etiqueta de "		, "C"              , 10                    , 0            , "G"          ,  "",       "CB0",         	    "",                 "",           "",    "",    "" })
	aAdd(aP,{ "Etiqueta ate "		, "C"              , 10                    , 0            , "G"          ,  "",       "CB0",         	    "",                 "",           "",    "",    "" })
	aAdd(aP,{ "Emissao de "	    	, "D"              , 8                     , 0            , "G"          ,  "",          "",         	    "",                 "",           "",    "",    "" })
	aAdd(aP,{ "Emissao ate "		, "D"              , 8                     , 0            , "G"          ,  "",          "",         	    "",                 "",           "",    "",    "" })
	aAdd(aP,{ "Impressão "		    , "N"              , 1                     , 0            , "C"          ,  "",          "",     "Impressaora",         "Planilha",           "",    "",    "" })

	aAdd(aHelp,{"Informe produto de."})
	aAdd(aHelp,{"Informe produto ate."})
	aAdd(aHelp,{"Informe cliente de."})
	aAdd(aHelp,{"Informe cliente ate."})
	aAdd(aHelp,{"Informe lote de."})
	aAdd(aHelp,{"Informe lote ate."})
	aAdd(aHelp,{"Informe etiqueta de."})
	aAdd(aHelp,{"Informe etiqueta ate."})
	aAdd(aHelp,{"Informe emissao de."})
	aAdd(aHelp,{"Informe emissao ate."})
	aAdd(aHelp,{"Tipo impressao."})


	For nI := 1 To Len(aP)

		cSeq	:= StrZero(nI,2,0)
		cMvPar	:= "mv_par"+cSeq
		cMvCh	:= "mv_ch"+IIF(nI<=9,Chr(nI+48),Chr(nI+87))

		xPutSx1(	cPerg,;				//-- cGrupo
		cSeq,;							//-- cOrdem
		aP[nI,01],aP[nI,01],aP[nI,01],;	//-- cPergunt,cPerSpa,cPerEng
		cMvCh,;							//-- cVar
		aP[nI,02],;						//-- cTipo
		aP[nI,03],;						//-- nTamanho
		aP[nI,04],;						//-- Decimal
		0,;								//-- nPreSel
		aP[nI,05],;						//-- cGSC
		aP[nI,06],;						//-- cValid
		aP[nI,07],;						//-- cF3
		"",;							//-- cGrpSXG
		"",;							//-- cPyme
		cMvPar,;						//-- cVar01
		aP[nI,08],aP[nI,08],aP[nI,08],;	//-- cDef01,cDefSpa1,cDefEng1
		"",;							//-- cCnt01
		aP[nI,09],aP[nI,09],aP[nI,09],;	//-- cDef02,cDefSpa2,cDefEng2
		aP[nI,10],aP[nI,10],aP[nI,10],;	//-- cDef03,cDefSpa3,cDefEng3
		aP[nI,11],aP[nI,11],aP[nI,11],;	//-- cDef04,cDefSpa4,cDefEng4
		aP[nI,12],aP[nI,12],aP[nI,12],;	//-- cDef05,cDefSpa5,cDefEng5
		aHelp[nI],;						//-- aHelpPor
		{},;							//-- aHelpEng
		{},;							//-- aHelpSpa
		"")								//-- cHelp

	Next nI


Return()



/*/{Protheus.doc} xPutSX1
//Rotina para criar registros SX1
@author Celso Rene
@since 17/04/2019
@version 1.0
@type function
/*/
Static Function xPutSX1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	Local aArea	:= GetArea()
	Local cKey
	Local lPort	:= .F.
	Local lSpa	:= .F.
	Local lIngl	:= .F.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme	:= Iif( cPyme	== Nil, " ", cPyme		)
	cF3		:= Iif( cF3		== NIl, " ", cF3		)
	cGrpSxg	:= Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
	cCnt01	:= Iif( cCnt01	== Nil, "" , cCnt01		)
	cHelp	:= Iif( cHelp	== Nil, "" , cHelp		)

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt	:= If(! "?" $ cPergunt	.And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa		:= If(! "?" $ cPerSpa	.And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng		:= If(! "?" $ cPerEng	.And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO	With cGrupo
		Replace X1_ORDEM	With cOrdem
		Replace X1_PERGUNT	With cPergunt
		Replace X1_PERSPA	With cPerSpa
		Replace X1_PERENG	With cPerEng
		Replace X1_VARIAVL	With cVar
		Replace X1_TIPO		With cTi*po
		Replace X1_TAMANHO	With nTamanho
		Replace X1_DECIMAL	With nDecimal
		Replace X1_PRESEL	With nPresel
		Replace X1_GSC		With cGSC
		Replace X1_VALID	With cValid
		Replace X1_VAR01	With cVar01
		Replace X1_F3		With cF3
		Replace X1_GRPSXG	With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01

		If cGSC == "C"               // Mult Escolha

			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5

		EndIf

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()

	Else

		lPort	:= ! "?" $ X1_PERGUNT	.And. ! Empty(SX1->X1_PERGUNT)
		lSpa	:= ! "?" $ X1_PERSPA	.And. ! Empty(SX1->X1_PERSPA)
		lIngl	:= ! "?" $ X1_PERENG	.And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl

			RecLock("SX1",.F.)

			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf

			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf

			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf

			SX1->(MsUnLock())

		EndIf
	Endif

	RestArea( aArea )


Return()



/*/{Protheus.doc} ProcRel
//Relatorio formato impressora - nao grafico
@author Celso Rene
@since 18/04/2019
@version 1.0
@type function
/*/
Static Function ProcRel(oReport,cPerg)

	Local _cEtiq 		:= ""	
	Local oSection1 	:= oReport:Section(1)
	Local oSection2 	:= oReport:Section(2)

	If (mv_par11 == 2) //relatorio planilha - excel
		RptStatus({|| ImpExcel() },Titulo)
		Return()
	EndIf

	//query para selecao dos registros - movimentos etiquetas
	_cQry := xQuery()

	If Select("TMP") <> 0
		TMP->(DbCloseArea())
	EndIf

	TcQuery _cQry New Alias "TMP"

	DbSelectArea("TMP")
	TMP->(DbGotop())

	If TMP->( EOF() )
		MsgInfo("Conforme parametros informados não foi encontrado nenhum registro!","Registros não encontrados")
		dbCloseArea("TMP")
		Return()
	ELse
		dbSelectArea("TMP")
		//Contando os registros e voltando ao topo da tabela
		Count To _nReg
		TMP->(DbGoTop())
	EndIf	


	oReport:SetMeter(_nReg)
	oSection2:Init()

	Do While TMP->(!EOF())

		_cEtiq   := Alltrim(TMP->ETIQUETA)
		//_cProd   := TMP->PRODUTO

		//busnca do data validade do lote	
		_dVldLote  := Posicione("SB8",3,xfilial("SB8") + TMP->PRODUTO + TMP->ALMOX + TMP->LOTE ,"B8_DTVALID")

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1") + TMP->PRODUTO)

		oReport:SkipLine() 
		oSection1:Init()
		oSection1:Cell("CB9_CODETI"):SetBlock({ || TMP->ETIQUETA } )
		oSection1:Cell("B1_COD"):SetBlock({ || TMP->PRODUTO } )
		oSection1:Cell("B1_DESC"):SetBlock({ || TMP->DESPROD } )
		oSection1:Cell("B1_TIPO"):SetBlock({ || SB1->B1_TIPO } )
		oSection1:Cell("B1_UM"):SetBlock({ || SB1->B1_UM } )
		oSection1:Cell("B8_LOTECTL"):SetBlock({ || TMP->LOTE } )
		oSection1:Cell("B8_DTVALID"):SetBlock({ || _dVldLote } )
		oSection1:PrintLine()		
		oReport:SkipLine() 

		Do While TMP->(!Eof()) .And.;
		Alltrim(TMP->ETIQUETA) == Alltrim(_cEtiq)

			oReport:IncMeter()

			oSection2:Init()
			oSection2:Cell("D2_LOCAL"):SetBlock({ || TMP->ALMOX } )
			oSection2:Cell("C6_NUM"):SetBlock({ || TMP->PEDIDO } )
			oSection2:Cell("CB9_ORDSEP"):SetBlock({ || TMP->ORDSEP } )
			//oSection2:Cell("C5_AF"):SetBlock({ || TMP->AF } )
			oSection2:Cell("D2_EMISSAO"):SetBlock({ || StoD(TMP->EMISSAO) } )
			oSection2:Cell("D2_DOC"):SetBlock({ || TMP->NOTA } )
			oSection2:Cell("D2_SERIE"):SetBlock({ || TMP->SERIE } )
			oSection2:Cell("D2_TES"):SetBlock({ || TMP->TES } )
			oSection2:Cell("F4_TEXTO"):SetBlock({ || Left(Posicione("SF4",1,xFilial("SF4") + TMP->TES, "F4_TEXTO"),30 )  } )

			_nQuant := If (Empty(TMP->NOTA),0, TMP->QUANT)

			If (TMP->TES <= "500")

				oSection2:Cell("D1_QUANT"):Show()
				oSection2:Cell("D1_QUANT"):SetBlock({ || _nQuant } )

				oSection2:Cell("D2_QUANT"):SetBlock({ || 0 } )
				oSection2:Cell("C5_PACIENT"):SetBlock({ || "" } )
				oSection2:Cell("A1_NREDUZ"):SetBlock({ || Left(Alltrim(TMP->NOMECLI),30) } )

				oSection2:Cell("D2_QUANT"):Hide()
				//oSection2:Cell("C5_PACIENT"):Hide()
				//oSection2:Cell("A1_NREDUZ"):Hide()

			ElseIf (TMP->TES > "500")

				oSection2:Cell("D1_QUANT"):SetBlock({ || 0 } )
				oSection2:Cell("D1_QUANT"):Hide()

				oSection2:Cell("D2_QUANT"):Show()
				oSection2:Cell("C5_PACIENT"):Show()
				oSection2:Cell("A1_NREDUZ"):Show()

				oSection2:Cell("D2_QUANT"):SetBlock({ || _nQuant } )

				_cPaciente := Posicione("SC5",1,xFilial("SC5") + TMP->PEDIDO ,"C5_PACIENTE")

				oSection2:Cell("C5_PACIENT"):SetBlock({ || _cPaciente } )
				oSection2:Cell("A1_NREDUZ"):SetBlock({ || Left(Alltrim(TMP->NOMECLI),30) } )


			EndIf 


			oSection2:PrintLine()

			dbSelectArea("TMP")
			TMP->(DbSkip())				

		EndDo

		oSection2:Finish()
		oSection1:Finish()
		oReport:EndPage()


	EndDo


	dbCloseArea("TMP")


Return()



/*/{Protheus.doc} ReportDef
//Preparando objeto para funcionalidade TReport()
@author Celso Rene
@since 18/04/2019
@version 1.0
@type function
/*/
Static Function ReportDef()


	Pergunte(cPerg, .F.)
	oReport := TReport():New( cReport, titulo, cPerg, { |oReport| ProcRel( oReport, cPerg ) }, cDesc1  )


	oReport:DisableOrientation()
	oReport:SetPortrait()  
	oReport:NoUserFilter()
	oReport:ParamReadOnly(.F.)
	oReport:SetEdit(.F.)


	oSection1 := TRSection():New( oReport, "Produto", {"SB1"} )
	TRCell():New( oSection1, "CB9_CODETI", "CB9",  "Etiqueta"/*Titulo*/,	 /*Mascara*/,14 /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "B1_COD"    , "SB1",  "Produto"/*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "B1_DESC"   , "SB1",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "B1_TIPO"   , "SB1",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "B1_UM"     , "SB1",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "B8_LOTECTL", "SB8",  /*Titulo*/,	 /*Mascara*/,14 /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "B8_DTVALID", "SB8",  "Vld. Lote"/*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)

	oSection2 := TRSection():New( oReport, "Movimento", {"SD2"} )
	oSection2:SetLeftMargin(5)
	TRCell():New( oSection2, "D2_LOCAL"   , "SD2",  "Local"/*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D2_EMISSAO" , "SD2",  "Data"/*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "C6_NUM"     , "SC6",  "Pedido"/*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "CB9_ORDSEP" , "CB9",  "O. Sep."/*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	//TRCell():New( oSection2, "C5_AF"      , "SC5",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D2_DOC"     , "SD2",  "Documento "/*Titulo*/,	 /*Mascara*/, 22/*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D2_SERIE"   , "SD2",  /*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D2_TES" 	  , "SD2",  "TES"/*Titulo*/,	 /*Mascara*/, /*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "F4_TEXTO"   , "SF4",  "Movimento"/*Titulo*/,	 /*Mascara*/, 30/*Tam*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D1_QUANT"   , "SD1",  "Entrada"	      ,	 PesqPictQt("D1_QUANT",12), TamSX3("D1_QUANT")[1], /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "D2_QUANT"   , "SD2",  "Saida"          ,	 PesqPictQt("D2_QUANT",12), TamSX3("D2_QUANT")[1], /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "C5_PACIENT" , "SC5",  /*Titulo*/,	 /*Mascara*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "A1_NREDUZ"  , "SA1",  /*Titulo*/,	 /*Mascara*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/)


Return(oReport)
