#Include "Protheus.ch"
#Include "Rwmake.ch"
#INCLUDE "tbiconn.ch"
#Include "topconn.ch"


/*/{Protheus.doc} JomACD06
//Tela para Devolucao de materiais - etiquetas
@author Celso Rene
@since 18/11/2018
@version 1.0
@type function
/*/
User Function JomACD06()

	Private oDlg
	Private oButton1
	Private oButton2
	Private oComboBox1
	Private cComboBox1 := "D"
	Private oComboBox2
	Private cComboBox2 := "Sim"
	Private oGet1
	Private cGet1 := Space(TamSx3("A1_COD")[1])
	Private oGet2
	Private cGet2 := Space(TamSx3("A1_LOJA")[1])
	Private oGet3
	Private cGet3 := Space(TamSx3("F1_DOC")[1])
	Private oGet4
	Private cGet4 := Space(TamSx3("F1_SERIE")[1])
	Private oGet5
	Private cGet5 := "    "
	Private oGet6
	Private dGet6 := Date()
	Private oGet7
	Private oGet8
	Private cGet8 := Space(TamSx3("CTD_ITEM")[1])
	Private nGet7 := 0
	Private oSay1
	Private oSay2
	Private oSay3
	Private oSay4
	Private oSay5
	Private oSay6
	Private oSay7
	Private oSay8
	Private oSay9
	Private oSay10

	Private nX
	Private aHeaderEx 	:= {}
	Private aColsEx 	:= {}
	Private aFieldFill 	:= {}
	Private aFields 	:= {}
	Private aAlterFields:= {}
	Private oMSNewGetDados1


	//tela 

	DEFINE MSDIALOG oDlg TITLE "# Dev. / Ret. - Identificação por etiquetas" FROM 000, 000  TO 525, 900 COLORS 0, 16777215 PIXEL

	fMSNew()

	@ 017, 007 MSCOMBOBOX oComboBox1 VAR cComboBox1 ITEMS {"D","R"} SIZE 025, 010 OF oDlg COLORS 0, 16777215  PIXEL
	@ 007, 007 SAY oSay1 PROMPT "Tipo:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 017, 039 MSCOMBOBOX oComboBox2 VAR cComboBox2 ITEMS {"Sim ","Não"} VALID(Formulario()) SIZE 039, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 007, 039 SAY oSay2 PROMPT "Form. Próprio:" SIZE 037, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 017, 093 MSGET oGet1 VAR cGet1 VALID ExistCpo("SA1",cGet1) SIZE 049, 010 OF oDlg COLORS 0, 16777215 F3 "SA1" PIXEL
	@ 007, 094 SAY oSay3 PROMPT "Cliente:" SIZE 041, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 017, 146 MSGET oGet2 VAR cGet2 SIZE 018, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 007, 147 SAY oSay4 PROMPT "Loja:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 018, 198 MSGET oGet3 VAR cGet3 SIZE 060, 010 OF oDlg PICTURE "@E  999999999" COLORS 0, 16777215 PIXEL
	@ 008, 199 SAY oSay5 PROMPT "Número:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 017, 262 MSGET oGet4 VAR cGet4 SIZE 022, 010 OF oDlg PICTURE "@E  999" COLORS 0, 16777215 PIXEL
	@ 007, 264 SAY oSay6 PROMPT "Série" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 017, 293 MSGET oGet5 VAR cGet5 SIZE 027, 010 OF oDlg VALID Vazio() .or. ExistCpo("SX5","42"+cGet5) COLORS 0, 16777215 PIXEL
	@ 007, 293 SAY oSay7 PROMPT "Especie:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 017, 332 MSGET oGet6 VAR dGet6 SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 007, 332 SAY oSay8 PROMPT "Emissão:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 017, 385 MSGET oGet8 VAR cGet8 SIZE 035, 010 OF oDlg  F3 "CTD" VALID Vazio() .or. Existcpo("CTD") .and. AtuItem()  COLORS 0, 16777215 PIXEL
	@ 007, 385 SAY oSay10 PROMPT "Item Conta:" SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 241, 008 SAY oSay9 PROMPT "Total: " SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 238, 034 MSGET oGet7 VAR nGet7 SIZE 074, 010 OF oDlg PICTURE "@E 999,999,999.99" COLORS 0, 16777215 READONLY PIXEL

	@ 239, 137 BUTTON oButton1 PROMPT "Gerar Documento" SIZE 046, 015 OF oDlg ACTION(GeraDoc()) PIXEL
	@ 239, 390 BUTTON oButton2 PROMPT "Sair" SIZE 046, 015 OF oDlg ACTION(oDlg:end()) PIXEL

	oComboBox1:Disable()
	oComboBox2:Disable()
	oGet3:Disable()
	oGet4:Disable()
	oDlg:Refresh()

	ACTIVATE MSDIALOG oDlg



Return()



//------------------------------------------------
Static Function fMSNew()
	//------------------------------------------------
	aHeaderEx := {}	
	aColsEx := {}
	aFieldFill := {}
	aFields := {"D1_XIDETIQ","D1_ITEM","D1_COD","D1_UM","D1_TES","D1_QUANT","D1_VUNIT","D1_TOTAL","D1_LOCAL","D1_NFORI",;
	"D1_SERIORI","D1_ITEMORI","D1_IDENTB6","D1_LOTECTL","D1_DTVALID","D1_DATORI","D1_LOTEFOR","D1_CC","D1_CONTA","D1_ITEMCTA"}

	aAlterFields := {"D1_XIDETIQ"}



	// Get fields from SD1
	//aEval(ApBuildHeader("SD1", Nil), {|x| Aadd(aFields, x[2])})
	//aAlterFields := aClone(aFields)

	// Define field properties
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
		If ( SX3->(DbSeek(aFields[nX])) )
			Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX, /*SX3->X3_RELACAO*/ })
		Endif
	Next nX

	// Define field values
	For nX := 1 to Len(aFields)
		If DbSeek(aFields[nX])
			Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
		Endif
	Next nX
	Aadd(aFieldFill, .F.)
	Aadd(aColsEx, aFieldFill)

	oMSNewGetDados1 := MsNewGetDados():New( 040, 007, 231, 442, GD_INSERT+GD_DELETE+GD_UPDATE, "u_xLOK()", "u_xTOK()", "D1_ITEM", aAlterFields, 0000 , 9999, "u_xFOK()", "", "u_xDOK()", oDlg, aHeaderEx, aColsEx)


Return()


//Valida linha OK
User Function xLOK()

	Local _lRet		:= .T.
	Local nD1TOT	:= aScan( aHeader,{|x| Alltrim(x[2]) == "D1_TOTAL" })
	
	//atualizando total
	nGet7:= 0
	For _x:= 1 to Len(aCols)
		If (aCols[_x][Len(aCols[_x])] == .F.)	 
			nGet7 += aCols[_x][nD1TOT]
		EndIf	
	Next _x 
	
	SysRefresh() 
	oGet7:Refresh()
	oDlg:Refresh()
	//oMSNewGetDados1:ForceRefresh()
	

Return(_lRet)


//Valida Tudo OK
User Function xTOK()

	Local _lRet	:= .T.


Return(_lRet)


//Valida Delete OK
User Function xDOK()

	Local _lRet	:= .T.
	
	

Return(_lRet)


//Valida Filed OK
User Function xFOK()

	Local _lRet		:= .T.
	Local _cRet		:= Substr(M->D1_XIDETIQ,TamSx3("B1_COD")[1] + 1,TamSx3("CB0_CODETI")[1] ) //codigo etiqueta e lotectl = mesmo tamanho


	For _x:= 1 to Len(aCols)
		If ( Alltrim(aCols[_x][1]) == Alltrim(M->D1_XIDETIQ) .and. aCols[_x][Len(aCols[_x])] == .F. .and. _x <> n  )
			_lRet := .F.
			MsgAlert("Já informada ID da etiqueta para devolução: " + Alltrim(M->D1_XIDETIQ) + " !","# Etiqueta já informada!")
			_x:= Len(aCols)
			ZeraItem()
			oGet1:Disable()
			oGet2:Disable()
			oGet3:Disable()
			oGet4:Disable()
			oGet5:Disable()
			oGet6:Disable()
			oDlg:Refresh()
			SysRefresh()
			Return(_lRet)
		EndIF
	Next _x


	//Carregando Acols - etiqueta Documento de saida
	If (Len(Alltrim(M->D1_XIDETIQ)) > 10)
		M->D1_XIDETIQ := _cRet
		_lRet := ProcID( Alltrim(M->D1_XIDETIQ) )
	ElseIf (Len(Alltrim(M->D1_XIDETIQ)) == 10)
		_lRet := ProcID( Alltrim(M->D1_XIDETIQ) )
	ElseIf (Len(Alltrim(M->D1_XIDETIQ)) < 10)
		_lRet := .F.
		MsgAlert("Não identificado item do documento original (saída) conforme a etiqueta: " + Alltrim(M->D1_XIDETIQ) + " !","# Etiqueta não encontrada!")
		ZeraItem()
		//aCols[n][Len(aCols[n])] := .T.
	EndIf


	//bloqueando cabecalho documento
	oComboBox1:Disable()
	oComboBox2:Disable()
	oGet1:Disable()
	oGet2:Disable()
	oGet3:Disable()
	oGet4:Disable()
	oGet5:Disable()
	oGet6:Disable()
	//oGet8:Disable()
	oDlg:Refresh()
	SysRefresh()
	

Return(_lRet)



/*/{Protheus.doc} Formulario
//Validando selecao formulario
@author Celso Rene
@since 18/11/2018
@version 1.0
@type function
/*/
Static Function Formulario()

	Local _lRet	:= .T.

	If (cComboBox2 == "Sim")
		oGet3:Disable()
		oGet4:Disable()
		oDlg:Refresh()
	Else
		oGet3:Enable()
		oGet4:Enable()
		oDlg:Refresh()
	EndIf

Return(_lRet)



/*/{Protheus.doc} ProcID
//Carregando Acols - etiqueta Documento de saida
@author Celso Rene
@since 18/11/2018
@version 1.0
@type function
/*/
Static Function ProcID(_cID)

	Local _CRETID	:= _cID
	Local _cQuery	:= ""
	Local _aColsAnt		:= {}
	//Local _aArea		:= GetArea()
	Local _lRetID		:= .F.

	Local nD1ITEM  		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEM" })
	Local nD1COD 		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })
	Local nD1TES		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_TES" })
	Local nD1CF			:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CF" })
	//Local nD1DESC		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_DESC" })
	Local nD1QUANT		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT" })
	Local nD1VUNIT		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_VUNIT" })
	Local nD1TOTAL		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_TOTAL" })
	Local nD1LOCAL		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_LOCAL" })
	Local nD1UM			:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_UM" })
	Local nD1NFORI		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_NFORI" })
	Local nD1SERIO		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_SERIORI" })
	Local nD1ITEMO		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMORI" })
	Local nD1IDB6		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_IDENTB6" })
	Local nD1LOTE		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_LOTECTL" })
	Local nD1LOTEF		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_LOTEFOR" })
	Local nD1DTVL		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_DTVALID" })
	Local nD1CC			:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CC" })
	Local nD1CCD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CCENTRO" })
	Local nD1DATORI		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_DATORI" })
	Local ITEMCTA		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMCTA" })
	Local nD1CONTA		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CONTA" })
	//Local nD1VICM		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_VALICM" })
	//Local nD1PICM		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_PICM" })
	//Local nD1DATOR	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_DATORI" }) 
	//Local nD1BICM		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_BASEICM" }) 


	_aColsAnt := aCols


	_cQuery:= "  SELECT ISNULL(CB9.CB9_ORDSEP,'') AS  CB9_ORDSEP  , ISNULL(CB9.CB9_CODSEP,'') AS CB9_CODSEP , CB9.CB9_CODETI" + chr(13)
	_cQuery+= " , SD2.*  " + chr(13) //, CB0.*
	_cQuery+= " FROM "+ RETSQLNAME("CB0") + " CB0 "+ chr(13)
	_cQuery+= " INNER JOIN "+ RETSQLNAME("SD2") + " SD2 ON SD2.D2_FILIAL = CB0.CB0_FILIAL AND SD2.D2_DOC = CB0.CB0_NFSAI AND SD2.D2_COD = CB0.CB0_CODPRO  AND SD2.D2_LOTECTL = CB0.CB0_LOTE " +chr(13)
	//_cQuery+= " AND (SD2.D2_QUANT - SD2.D2_QTDEDEV ) > 0 " + chr(13)
	_cQuery+= " AND (SD2.D2_QUANT - (SELECT ISNULL(SUM(SD1.D1_QUANT),0) FROM "+ RETSQLNAME("SD1") + " SD1 WHERE SD1.D_E_L_E_T_ = '' AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_FORNECE = SD2.D2_CLIENTE AND SD1.D1_LOJA = SD2.D2_LOJA )) > 0 " + chr(13) 
	//_cQuery+= " AND SD2.D2_SERIE = '" + Alltrim(GetMV("MV_ACDSERI")) + "' "+ chr(13)
	// AND SD2.D2_DTVALID = CB0.CB0_DTVLD 
	_cQuery+= " AND SD2.D2_CLIENTE = '" + cGet1 + "' AND SD2.D2_LOJA = '" + cGet2 + "' " + chr(13)
	_cQuery+= " INNER JOIN "+ RETSQLNAME("SF4") + " SF4 ON SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = '' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.F4_PODER3 IN ('D','R') "	+ chr(13)
	_cQuery+= " INNER JOIN "+ RETSQLNAME("SB6") + " SB6 ON SB6.B6_FILIAL = '" + xFilial("SB6") + "' AND SB6.D_E_L_E_T_ = '' AND SB6.B6_IDENT = SD2.D2_IDENTB6 AND SB6.B6_TES = SD2.D2_TES AND SB6.B6_PRODUTO = SD2.D2_COD "+ chr(13)
	_cQuery+= " AND SB6.B6_DOC = SD2.D2_DOC AND SB6.B6_CLIFOR = SD2.D2_CLIENTE AND SB6.B6_SALDO > 0 " + chr(13)
	_cQuery+= " INNER JOIN "+ RETSQLNAME("CB9") + " CB9 ON CB9.D_E_L_E_T_ = '' AND CB9.CB9_FILIAL = CB0.CB0_FILIAL AND CB9.CB9_CODETI =  CB0.CB0_CODETI AND CB9.CB9_PEDIDO = SD2.D2_PEDIDO "+ chr(13)
	//_cQuery+= " LEFT JOIN "+ RETSQLNAME("CB8") + " CB8 ON CB8.D_E_L_E_T_ = '' AND CB8.CB8_FILIAL = CB0.CB0_FILIAL AND CB8.CB8_ORDSEP = CB9.CB9_ORDSEP AND CB8.CB8_ITEM = CB9.CB9_ITESEP AND CB8.CB8_PROD = CB0.CB0_CODPRO "+ chr(13)
	_cQuery+= " INNER JOIN "+ RETSQLNAME("CB7") + " CB7 ON CB7.CB7_FILIAL = CB0.CB0_FILIAL AND CB7.D_E_L_E_T_ = '' AND CB7.CB7_ORDSEP = CB9.CB9_ORDSEP "+ chr(13)
	_cQuery+= " AND CB7.CB7_PEDIDO = SD2.D2_PEDIDO " + chr(13)
	_cQuery+= " WHERE CB0.D_E_L_E_T_ = '' AND CB0.CB0_CODETI = '" + _cRetID + "'  "   + chr(13)

	_cQuery+= " UNION ALL "  + chr(13)

	_cQuery+= "  SELECT ISNULL(CB9.CB9_ORDSEP,'') AS  CB9_ORDSEP  , ISNULL(CB9.CB9_CODSEP,'') AS CB9_CODSEP , CB9.CB9_CODETI " + chr(13)
	_cQuery+= " , SD2.* " + chr(13) //, CB0.* 
	_cQuery+= " FROM "+ RETSQLNAME("CB0") + " CB0 "+ chr(13)
	_cQuery+= " INNER JOIN "+ RETSQLNAME("SD2") + " SD2 ON SD2.D2_FILIAL = CB0.CB0_FILIAL AND SD2.D2_DOC = CB0.CB0_NFSAI AND SD2.D2_COD = CB0.CB0_CODPRO  AND SD2.D2_LOTECTL = CB0.CB0_LOTE " +chr(13)
	//_cQuery+= " AND (SD2.D2_QUANT - SD2.D2_QTDEDEV ) > 0 " + chr(13)
	_cQuery+= " AND (SD2.D2_QUANT - (SELECT ISNULL(SUM(SD1.D1_QUANT),0) FROM "+ RETSQLNAME("SD1") + " SD1 WHERE SD1.D_E_L_E_T_ = '' AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_FORNECE = SD2.D2_CLIENTE AND SD1.D1_LOJA = SD2.D2_LOJA )) > 0 " + chr(13) 
	//_cQuery+= " AND SD2.D2_SERIE = '" + Alltrim(GetMV("MV_ACDSERI")) + "' "+ chr(13) 
	_cQuery+= " AND SD2.D2_CLIENTE = '" + cGet1 + "' AND SD2.D2_LOJA = '" + cGet2 + "' " + chr(13)	
	// AND SD2.D2_DTVALID = CB0.CB0_DTVLD
	_cQuery+= " INNER JOIN " + RETSQLNAME("SF4") + " SF4 ON SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = '' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.F4_PODER3 NOT IN ('D','R') " + chr(13)
	_cQuery+= " INNER JOIN " + RETSQLNAME("CB9") + " CB9 ON CB9.D_E_L_E_T_ = '' AND CB9.CB9_FILIAL = CB0.CB0_FILIAL AND CB9.CB9_CODETI =  CB0.CB0_CODETI AND CB9.CB9_PEDIDO = SD2.D2_PEDIDO "+ chr(13)
	//_cQuery+= " LEFT JOIN " + RETSQLNAME("CB8") + " CB8 ON CB8.D_E_L_E_T_ = '' AND CB8.CB8_FILIAL = CB0.CB0_FILIAL AND CB8.CB8_ORDSEP = CB9.CB9_ORDSEP AND CB8.CB8_ITEM = CB9.CB9_ITESEP AND CB8.CB8_PROD = CB0.CB0_CODPRO "+ chr(13)
	_cQuery+= " INNER JOIN " + RETSQLNAME("CB7") + " CB7 ON CB7.CB7_FILIAL = CB0.CB0_FILIAL AND CB7.D_E_L_E_T_ = '' AND CB7.CB7_ORDSEP = CB9.CB9_ORDSEP "+ chr(13)
	_cQuery+= " AND CB7.CB7_PEDIDO = SD2.D2_PEDIDO " + chr(13)
	_cQuery+= " WHERE CB0.D_E_L_E_T_ = '' AND CB0.CB0_CODETI = '" + _cRetID + "'  "  + chr(13) 


	//incluindo tratamento para retornar lote unitario nao separado - processo antigo
	_cQuery+= " UNION ALL "  + chr(13) 

	_cQuery+= " SELECT '' AS  CB9_ORDSEP  , '' AS CB9_CODSEP , SD2.D2_LOTECTL AS CB9_CODETI " + chr(13)
	_cQuery+= " , SD2.* " + chr(13)
	_cQuery+= " FROM "+ RETSQLNAME("SD2") + " SD2 " + chr(13)
	_cQuery+= " INNER JOIN "+ RETSQLNAME("SB8") + " SB8 ON SB8.D_E_L_E_T_ = '' AND SB8.B8_LOTECTL = SD2.D2_LOTECTL AND SB8.B8_PRODUTO = SD2.D2_COD AND (SB8.B8_QTDORI = 1 OR SB8.B8_LOTEUNI = 'S') " + chr(13)
	_cQuery+= " WHERE SD2.D_E_L_E_T_ = '' AND SD2.D2_CLIENTE = '" + cGet1 + "' AND SD2.D2_LOJA = '" + cGet2 + "' AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' " + chr(13)
	_cQuery+= " AND NOT EXISTS (SELECT TOP 1 CB7.CB7_ORDSEP FROM "+ RETSQLNAME("CB7") + " CB7  WHERE CB7.D_E_L_E_T_ = '' AND CB7.CB7_PEDIDO = SD2.D2_PEDIDO) " + chr(13) 
	_cQuery+= " AND (SD2.D2_QUANT - (SELECT ISNULL(SUM(SD1.D1_QUANT),0) FROM "+ RETSQLNAME("SD1") + " SD1 WHERE SD1.D_E_L_E_T_ = '' AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_FORNECE = SD2.D2_CLIENTE AND SD1.D1_LOJA = SD2.D2_LOJA )) > 0 " + chr(13)
	_cQuery+= " AND SD2.D2_LOTECTL = '" + _cRetID + "' " //AND (SD2.D2_QUANT - SD2.D2_QTDEDEV ) > 0 
	
	_cQuery+= " UNION ALL "  + chr(13)
	
	_cQuery+= " SELECT '' AS  CB9_ORDSEP  , '' AS CB9_CODSEP , SC6.C6_XETIQ AS CB9_CODETI " + chr(13) 
	_cQuery+= "  , SD2.* "  + chr(13)
	_cQuery+= "  FROM "+ RETSQLNAME("SD2") + " SD2 " + chr(13)
	_cQuery+= " INNER JOIN "+ RETSQLNAME("CB0") + " CB0  ON CB0.CB0_CODETI = '" + _cRetID + "'  AND CB0.D_E_L_E_T_='' AND CB0.CB0_XIMP <> 'S' " + chr(13)
	_cQuery+= " INNER JOIN "+ RETSQLNAME("SC6") + " SC6 ON SC6.D_E_L_E_T_ = '' AND SC6.C6_XETIQ = '" + _cRetID + "' AND SC6.C6_CLI = '" + cGet1 + "'  AND SC6.C6_LOJA = '" + cGet2 + "' " + chr(13)
	_cQuery+= " INNER JOIN "+ RETSQLNAME("SB8") + " SB8 ON SB8.D_E_L_E_T_ = '' AND SB8.B8_LOTECTL = SD2.D2_LOTECTL AND SB8.B8_PRODUTO = SD2.D2_COD AND SB8.B8_LOTEUNI <> 'S' " + chr(13)
	_cQuery+= " WHERE SD2.D_E_L_E_T_ = '' AND SD2.D2_CLIENTE = '" + cGet1 + "' AND SD2.D2_LOJA = '" + cGet2 + "' AND SD2.D2_FILIAL = '" + xFilial("SD2") +"' " + chr(13)
   	_cQuery+= " AND SD2.D2_LOTECTL = CB0.CB0_LOTE AND SD2.D2_DOC = SC6.C6_NOTA AND SD2.D2_SERIE = SC6.C6_SERIE AND SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D2_ITEMPV = SC6.C6_ITEM " + chr(13) 
 	_cQuery+= " AND NOT EXISTS (SELECT TOP 1 CB7.CB7_ORDSEP FROM "+ RETSQLNAME("CB7")+ " CB7  WHERE CB7.D_E_L_E_T_ = '' AND CB7.CB7_PEDIDO = SD2.D2_PEDIDO) " + chr(13)
 	_cQuery+= " AND (SD2.D2_QUANT - (SELECT ISNULL(SUM(SD1.D1_QUANT),0) FROM "+ RETSQLNAME("SD1")+ " SD1 WHERE SD1.D_E_L_E_T_ = '' AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_FORNECE = SD2.D2_CLIENTE AND SD1.D1_LOJA = SD2.D2_LOJA )) > 0 " 


	If( Select( "TSD2" ) <> 0 )
		TSD2->( DbCloseArea() )
	EndIf

	TcQuery _cQuery Alias "TSD2" New
	DbSelectArea("TSD2")	
	If (! TSD2->(Eof()) )
		While ( ! TSD2->(Eof()) )

			aCols[n][1] 		:= _cRetID
			aCols[n][nD1ITEM] 	:= StrZero( n, TamSx3("D1_ITEM")[1], 0 )
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1") + TSD2->D2_COD)
			aCols[n][nD1COD]	:= TSD2->D2_COD

			//aCols[n][nD1DESC]	:= Posicione("SB1",1,xFilial("SB1") + TSD2->D2_COD , "B1_DESC")
			
			//quantidade etiqueta
			_nQtdID	:= 1
			dbSelectARea("CB0")
			dbSetOrder(1) //CB0_FILIAL+CB0_CODETI                                                                                                                                         
			dbSeek(xFilial("CB0") + _cRetID )
			If Found()
				_nQtdID := CB0->CB0_QTDE
			EndIf

			_cTesDev := Posicione("SF4",1,xFilial("SF4") + TSD2->D2_TES , "F4_TESDV")
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") + _cTesDev)

			aCols[n][nD1TES]	:= _cTesDev
			aCols[n][nD1QUANT]	:= _nQtdID // 1  
			aCols[n][nD1VUNIT]	:= TSD2->D2_PRCVEN
			aCols[n][nD1TOTAL]	:= Round(aCols[n][nD1QUANT] * aCols[n][nD1VUNIT] ,2)
			//aCols[n][nD1VICM]     := TSD2->D2_VALICM
			//aCols[n][nD1PICM]     := TSD2->D2_PICM
			//aCols[n][nD1BICM]     := TSD2->D2_ALQIMP5
			//aCols[n][nD1CF]		:= Posicione("SF4",1,xFilial("SF4") + aCols[n][nD1TES] , "F4_CF")	
			aCols[n][nD1LOCAL]	:= TSD2->D2_LOCAL
			aCols[n][nD1UM]		:= TSD2->D2_UM
			aCols[n][nD1SERIO]	:= TSD2->D2_SERIE		
			aCols[n][nD1NFORI]	:= TSD2->D2_DOC
			aCols[n][nD1ITEMO]	:= TSD2->D2_ITEM
			//////////aCols[n][nD1DATOR]	:= StoD(TSD2->D2_EMISSAO)
			aCols[n][nD1IDB6]	:= TSD2->D2_IDENTB6
			aCols[n][nD1LOTE]	:= TSD2->D2_LOTECTL
			aCols[n][nD1LOTEF]	:= POSICIONE("SB8",3,xFilial("SB8") + TSD2->D2_COD + TSD2->D2_LOCAL + TSD2->D2_LOTECTL, "B8_LOTEFOR" )  
			aCols[n][nD1DTVL]	:= StoD(TSD2->D2_DTVALID)

			If ( Empty(TSD2->D2_CCUSTO) )
				If (cEmpAnt == "06")			
					aCols[n][nD1CC]		:= "300002"
				ElseIf (cEmpAnt == "01")
					aCols[n][nD1CC]		:= "300001"
				EndIf
			Else
				aCols[n][nD1CC]		:= TSD2->D2_CCUSTO
			EndIf

			aCols[n][nD1DATORI] := StoD(TSD2->D2_EMISSAO)
			If !Empty(cGet8)
				aCols[n][ITEMCTA]	:= cGet8
			Else
				aCols[n][ITEMCTA]	:= TSD2->D2_ITEMCC
			EndIf
			aCols[n][nD1CONTA]	:= TSD2->D2_CONTA


			_lRetID	:= .T. //encontrou etiqueta

			//verificando se a etiqueta ja existe no acols
			For _x:= 1 to Len(aCols)
				If (Alltrim(aCols[_x][1]) == Alltrim(aCols[n][1]) .and.  aCols[_x][Len(aCols[_x])] == .F. .and. _x <> n )
					_lRetID	:= .F.
					ZeraItem()
					_x:= Len(aCols)
				EndIF
			Next _x


			TSD2->(dbSkip())

		EndDo

		//total documento
		If (_lRetID == .T.)
			nGet7 := 0
			For _x:= 1 to Len(aCols)
				If ( aCols[_x][Len(aCols[_x])] == .F.) //verifica se a linha do acols nao esta deletada
					nGet7 += aCols[_x][nD1TOTAL]
				EndIf	
			Next _x 
		EndIf


	Else

		MsgAlert("Não identificado item do documento original (saída) conforme a etiqueta: " + _cRetID + " !","# Etiqueta não identificada!")
		ZeraItem()

	EndIf

	TSD2->(dbCloseArea())


	SysRefresh() 
	oGet7:Refresh()
	oDlg:Refresh()
	oMSNewGetDados1:ForceRefresh()


Return(_lRetID)



/*/{Protheus.doc} GeraDoc
//Carregando Cabec e Itens para e geração Documento - Execauto = .T.
@author Celso Rene
@since 18/11/2018
@version 1.0
@type function
/*/
Static Function GeraDoc()

	Local _lDoc 	:= .T.
	Local _aItens 	:= {}
	Local _aCab		:= {}

	Local nD1ITEM  		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_ITEM" })
	Local nD1COD 		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_COD" })
	Local nD1TES		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_TES" })
	Local nD1CF			:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_CF" })
	Local nD1QUANT		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_QUANT" })
	Local nD1VUNIT		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_VUNIT" })
	Local nD1TOTAL		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_TOTAL" })
	Local nD1LOCAL		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_LOCAL" })
	Local nD1UM			:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_UM" })
	Local nD1NFORI		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_NFORI" })
	Local nD1SERIO		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_SERIORI" })
	Local nD1ITEMO		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_ITEMORI" })
	Local nD1IDB6		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_IDENTB6" })
	Local nD1LOTE		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_LOTECTL" })
	Local nD1LOTEF		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_LOTEFOR" })
	Local nD1DTVL		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_DTVALID" })
	Local nD1CC			:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_CC" })
	Local nD1XID		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_XIDETIQ" })
	Local nD1CF			:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_CF" })
	Local nD1DATORI		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_DATORI" })
	Local nITEMCTA		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_ITEMCTA" })
	Local nD1CONTA		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_CONTA" })
	Local nD1XID		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_XIDETIQ" })
	//Local nD1VICM		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_VALICM" })
	//Local nD1PICM		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_PICM" })
	//Local nD1DATOR	:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_DATORI" }) 
	//Local nD1BICM		:= aScan(oMSNewGetDados1:aHeader,{|x| Alltrim(x[2]) == "D1_BASEICM" })


	//Cabecalho
	aAdd( _aCab, { "F1_TIPO"     , cComboBox1              				, Nil } ) //-- Tipo da NF   : Obrigatorio
	aAdd( _aCab, { "F1_FORMUL"   , IIf( cComboBox2 == "Sim", "S", "N" ) , Nil } ) //-- Formulario
	aAdd( _aCab, { "F1_DOC"      , cGet3  	  			    			, Nil } ) //-- Numero da NF : Obrigatorio
	aAdd( _aCab, { "F1_SERIE"    , cGet4		         				, Nil } ) //-- Serie da NF  : Obrigatorio
	aAdd( _aCab, { "F1_EMISSAO"  , dGet6		              			, Nil } ) //-- Emissao da NF        : Obrigatorio
	aadd( _aCab, { "F1_DTDIGIT"  , dDatabase      	 					, Nil  } ) //--Data DEigitacao
	aAdd( _aCab, { "F1_FORNECE"  , cGet1   	              				, Nil } ) //-- Codigo do Fornecedor : Obrigatorio
	aAdd( _aCab, { "F1_LOJA"     , cGet2                   				, Nil } ) //-- Loja do Fornecedor   : Obrigatorio
	aAdd( _aCab, { "F1_ESPECIE"  , cGet5               					, Nil } ) //-- Especie
	aadd( _aCab, { "F1_EST"      , posicione("SA1",1,xFilial("SA1")+ cGet1 + cGet2,"A1_EST")         ,Nil}) //Estado


	//nao usado - formulario tipo devolucao e formulario proprio
	/*
	//Busca a chave NF-e
	If ( Len(oMSNewGetDados1:aCols) > 0 )
		dbSelectArea("SF2")
		dbSetOrder(1)
		If (dbSeek(xFilial("SF2") + oMSNewGetDados1:aCols[1][nD1NFORI] + oMSNewGetDados1:aCols[1][nD1SERIO] + cGet1 + cGet2  ) )//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA	
			aAdd( _aCab, { "F1_CHVNFE"   , SF2->F2_CHVNFE				, Nil } ) //-- Chave da NFE
		EndIf
	EndIf
	*/


	//Montando as linhas do oMSNewGetDados1:aCols 

	For _x:= 1 to Len(oMSNewGetDados1:aCols)

		If (oMSNewGetDados1:aCols[_x][Len(oMSNewGetDados1:aCols[_x])] == .F.) 
			nValDesc := 0
			//SB1->( dbSeek( xFilial( "SB1" )+ oMSNewGetDados1:aCols[_x][nD1COD] ) )
			//cCtaProd := SB1->B1_CONTA

			aLinha := {}
			aAdd( aLinha, { "D1_COD"     , oMSNewGetDados1:aCols[_x][nD1COD]   , Nil } )
			aAdd( aLinha, { "D1_TES"     , oMSNewGetDados1:aCols[_x][nD1TES]   , Nil } )
			aAdd( aLinha, { "D1_CF"    	 , posicione("SF4",1,xFilial("SF4") + oMSNewGetDados1:aCols[_x][nD1TES],"F4_CF")    , Nil } )
			aAdd( aLinha, { "D1_QUANT"   , oMSNewGetDados1:aCols[_x][nD1QUANT] , Nil } )
			aAdd( aLinha, { "D1_VUNIT"   , oMSNewGetDados1:aCols[_x][nD1VUNIT] , Nil } )
			aAdd( aLinha, { "D1_TOTAL"   , Round(oMSNewGetDados1:aCols[_x][nD1QUANT] * oMSNewGetDados1:aCols[_x][nD1VUNIT],2) , Nil } )
			aAdd( aLinha, { "D1_LOCAL"   , oMSNewGetDados1:aCols[_x][nD1LOCAL] , Nil } )
			aAdd( aLinha, { "D1_UM"      , oMSNewGetDados1:aCols[_x][nD1UM]    , Nil } )
			Aadd( aLinha, { "D1_FORNECE" , cGet1     			 			   , Nil } )
			Aadd( aLinha, { "D1_LOJA"    , cGet2        		 			   , Nil } )
			Aadd( aLinha, { "D1_TIPO"    , cComboBox1     		 			   , Nil } )
			aAdd( aLinha, { "D1_NFORI"   , oMSNewGetDados1:aCols[_x][nD1NFORI] , Nil } )
			aAdd( aLinha, { "D1_SERIORI" , oMSNewGetDados1:aCols[_x][nD1SERIO] , Nil } )
			aAdd( aLinha, { "D1_ITEMORI" , oMSNewGetDados1:aCols[_x][nD1ITEMO] , Nil } )
			aAdd( aLinha, { "D1_IDENTB6" , oMSNewGetDados1:aCols[_x][nD1IDB6]  , Nil } )
			aAdd( aLinha, { "D1_DATORI"  , oMSNewGetDados1:aCols[_x][nD1DATORI], Nil } )
			aAdd( aLinha, { "D1_CONTA"   , oMSNewGetDados1:aCols[_x][nD1CONTA] , Nil } )
			aAdd( aLinha, { "D1_LOTECTL" , oMSNewGetDados1:aCols[_x][nD1LOTE]  , Nil } )
			aAdd( aLinha, { "D1_LOTEFOR" , oMSNewGetDados1:aCols[_x][nD1LOTEF] , Nil } )
			aAdd( aLinha, { "D1_DTVALID" , oMSNewGetDados1:aCols[_x][nD1DTVL]  , Nil } )
			aAdd( aLinha, { "D1_CC"      , oMSNewGetDados1:aCols[_x][nD1CC]    , Nil } )
			aAdd( aLinha, { "D1_XIDETIQ" , oMSNewGetDados1:aCols[_x][nD1XID]   , Nil } )
			aAdd( aLinha, { "D1_ITEMCTA" , oMSNewGetDados1:aCols[_x][nITEMCTA] , Nil } ) 

			aAdd( _aItens, aLinha)

		EndIf

	Next _x


	lMsErroAuto := .F.
	lMsHelpAuto := .T.

	//Begin Transaction - deu problema ao confirmar rotina de devoluvao execauto

	MsgRun( "Aguarde...Incluindo a Nota Fiscal de Devolução/Retorno.", , { ||MSExecAuto( { |w,x,y,z| MATA103( w,x,y,z ) }, _aCab, _aItens, 3, .T. )})

	If	lMsErroAuto

		DisarmTran()
		Mostraerro()
		_lDoc := .F.	

	Else

		//..encerrando processo e fechando tela 
		_lDoc:= .T.
		//MsgInfo("Gerado Documento de Dev/Ret com sucesso!","Documento Gerado" )
		oDlg:End()

	EndIf


	//End Transaction


Return(_lDoc)


/*/{Protheus.doc} ZeraItem
//Zerando o Acols - Problema no item lido da etiqueta
@author Celso Rene
@since 19/11/2018
@version 1.0
@type function
/*/
Static Function ZeraItem()

	Local nD1ITEM  		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEM" })
	Local nD1COD 		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })
	Local nD1TES		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_TES" })
	Local nD1CF			:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CF" })
	Local nD1QUANT		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT" })
	Local nD1VUNIT		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_VUNIT" })
	Local nD1TOTAL		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_TOTAL" })
	Local nD1LOCAL		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_LOCAL" })
	Local nD1UM			:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_UM" })
	Local nD1NFORI		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_NFORI" })
	Local nD1SERIO		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_SERIORI" })
	Local nD1ITEMO		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMORI" })
	Local nD1IDB6		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_IDENTB6" })
	Local nD1LOTE		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_LOTECTL" })
	Local nD1LOTEF		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_LOTEFOR" })
	Local nD1DTVL		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_DTVALID" })
	Local nD1CC			:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CC" })
	Local nD1DATORI		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_DATORI" })
	Local ITEMCTA		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMCTA" })
	Local nD1CONTA		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CONTA" })

	aCols[n][1]			:= "" //Space(TamSx3("D1_XIDETIQ")[1])
	aCols[n][nD1COD]	:= "" //Space(TamSx3("D1_COD")[1])
	aCols[n][nD1TES]	:= "" //Space(TamSx3("D1_TES")[1])
	aCols[n][nD1QUANT]	:= 0 
	aCols[n][nD1VUNIT]	:= 0
	aCols[n][nD1TOTAL]	:= 0	
	aCols[n][nD1LOCAL]	:= "" //Space(TamSx3("D1_LOCAL")[1])
	aCols[n][nD1UM]		:= "" //Space(TamSx3("D1_UM")[1])
	aCols[n][nD1SERIO]	:= "" //Space(TamSx3("D1_SERIORI")[1])		
	aCols[n][nD1NFORI]	:= "" //Space(TamSx3("D1_NFORI")[1])
	aCols[n][nD1ITEMO]	:= "" //Space(TamSx3("D1_ITEMORI")[1])
	//aCols[n][nD1DATOR]	:= StoD(TSD2->D2_EMISSAO)
	aCols[n][nD1IDB6]	:= "" //Space(TamSx3("D1_IDENTB6")99[1])
	aCols[n][nD1LOTE]	:= "" //Space(TamSx3("D1_LOTECTL")[1])
	aCols[n][nD1LOTEF]	:= "" //Posicionar depois no LOTEFOR - SB8
	aCols[n][nD1DTVL]	:= CtoD("")
	aCols[n][nD1CC]		:= ""
	aCols[n][ITEMCTA]	:= ""
	aCols[n][nD1CONTA]	:= ""
	aCols[n][nD1DATORI] := CtoD("")


Return()


/*/{Protheus.doc} XWhenID
//Validando When coluna ID Etiqueta - D1_XIDETIQ - Documento de entrada
@author Celso Rene
@since 12/11/2018
@version 1.0
@type function
/*/
User Function XWhenID()                                                 

	Local _lRetID	:= .F.

	If( "JOMACD06" $ FunName() .and. procname(7) <> "MATA103") //impedindo edicao na rotina documento de entrada - gerar Doc.
		_lRetID	:= .T.
	EndIf

Return(_lRetID)



/*/{Protheus.doc} AtuItem
//atualizando itens conforme selecao do item conta
@author Celso Rene
@since 15/04/2019
@version 1.0
@type function
/*/
Static Function AtuItem()


	If ( TYPE("aHeaderEx") <> "U")
	
		_nItCont	:= aScan(aHeaderEx,{|x| Alltrim(x[2]) == "D1_ITEMCTA" })

		For _x:= 1 to len(aColsEx)
			aColsEx[_x][_nItCont] := cGet8
		Next _x
		
	EndIf
	
	oDlg:Refresh()
	oMSNewGetDados1:ForceRefresh()
	SysRefresh()
	oMSNewGetDados1:obrowse:setfocus()


Return( .T. )
