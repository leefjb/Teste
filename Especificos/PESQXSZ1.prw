#Include "PROTHEUS.CH"
#Include "rwmake.ch"
#Include "topconn.ch"

Static cUTexto
Static cCodProAnt

/*______________________________________________________________________________________________________________*/
//Funcao para Pesquiza generica do F3
//#Include "FILEIO.CH"
#xcommand @ <nRow>, <nCol> BITMAP [ <oBmp> ] ;
[ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
[ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
[ <NoBorder:NOBORDER, NO BORDER> ] ;
[ SIZE <nWidth>, <nHeight> ] ;
[ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
[ <lClick: ON CLICK, ON LEFT CLICK> <uLClick> ] ;
[ <rClick: ON RIGHT CLICK> <uRClick> ] ;
[ <scroll: SCROLL> ] ;
[ <adjust: ADJUST> ] ;
[ CURSOR <oCursor> ] ;
[ <pixel: PIXEL>   ] ;
[ MESSAGE <cMsg>   ] ;
[ <update: UPDATE> ] ;
[ WHEN <uWhen> ] ;
[ VALID <uValid> ] ;
[ <lDesign: DESIGN> ] ;
=> ;
[ <oBmp> := ] TBitmap():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
<cResName>, <cBmpFile>, <.NoBorder.>, <oWnd>,;
[\{ |nRow,nCol,nKeyFlags| <uLClick> \} ],;
[\{ |nRow,nCol,nKeyFlags| <uRClick> \} ], <.scroll.>,;
<.adjust.>, <oCursor>, <cMsg>, <.update.>,;
<{uWhen}>, <.pixel.>, <{uValid}>, <.lDesign.> )

#xtranslate bSETGET(<uVar>) => ;
{ | u | If( PCount() == 0, <uVar>, <uVar> := u ) }

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
[ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
[ <memo: MULTILINE, MEMO, TEXT> ] ;
[ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
[ SIZE <nWidth>, <nHeight> ] ;
[ FONT <oFont> ] ;
[ <hscroll: HSCROLL> ] ;
[ CURSOR <oCursor> ] ;
[ <pixel: PIXEL> ] ;
[ MESSAGE <cMsg> ] ;
[ <update: UPDATE> ] ;
[ WHEN <uWhen> ] ;
[ <lCenter: CENTER, CENTERED> ] ;
[ <lRight: RIGHT> ] ;
[ <readonly: READONLY, NO MODIFY> ] ;
[ VALID <uValid> ] ;
[ ON CHANGE <uChange> ] ;
[ <lDesign: DESIGN> ] ;
[ <lNoBorder: NO BORDER, NOBORDER> ] ;
[ <lNoVScroll: NO VSCROLL> ] ;
=> ;
[ <oGet> := ] TMultiGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
[<oWnd>], <nWidth>, <nHeight>, <oFont>, <.hscroll.>,;
<nClrFore>, <nClrBack>, <oCursor>, <.pixel.>,;
<cMsg>, <.update.>, <{uWhen}>, <.lCenter.>,;
<.lRight.>, <.readonly.>, <{uValid}>,;
[\{|nKey, nFlags, Self| <uChange>\}], <.lDesign.>,;
[<.lNoBorder.>], [<.lNoVScroll.>] )

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
[ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
[ PICTURE <cPict> ] ;
[ VALID <ValidFunc> ] ;
[ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
[ SIZE <nWidth>, <nHeight> ]  ;
[ FONT <oFont> ] ;
[ <design: DESIGN> ] ;
[ CURSOR <oCursor> ] ;
[ <pixel: PIXEL> ] ;
[ MESSAGE <cMsg> ] ;
[ <update: UPDATE> ] ;
[ WHEN <uWhen> ] ;
[ <lCenter: CENTER, CENTERED> ] ;
[ <lRight: RIGHT> ] ;
[ ON CHANGE <uChange> ] ;
[ <readonly: READONLY, NO MODIFY> ] ;
[ <pass: PASSWORD> ] ;
[ <lNoBorder: NO BORDER, NOBORDER> ] ;
[ <help:HELPID, HELP ID> <nHelpId> ] ;
=> ;
[ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
[<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
<nClrFore>, <nClrBack>, <oFont>, <.design.>,;
<oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
<.lCenter.>, <.lRight.>,;
[\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
<.pass.>, [<.lNoBorder.>], <nHelpId> )

/*/{Protheus.doc} PesqXSZ1
//Super SZ1 - XSA1
@author Celso Rene
@since 10/10/2018
@version 1.0
@return ${return}, ${return_description}
@param cTitulo, characters, descricao
@param cAlias, characters, descricao
@param nStartOrdem, numeric, descricao
@param cCampoDefault, characters, descricao
@param _cFiltro, , descricao
@type function
/*/
User Function PesqXSZ1(cTitulo, cAlias, nStartOrdem, cCampoDefault, _cFiltro)

	Local cTexto := SPACE(40), nOrdem := 2 //1
	Local lOk := .F., aCombo, oCombo1, oFiltrar, aRadio, oRadio
	Local nMarca    := &(cAlias)->(Recno())
	Local nOldOrd   := &(cAlias)->(IndexOrd())
	Local aGrid     := {}
	Local aFiltrar  := {}
	Local aNFiltrar := {}
	Local nFiltrar  := 1
	Local nSeq      := 1
	Local oFont
	
	//Local _aArea	:= GetArea()	
	
	Private cLocal01
	Private oMLocal01
	Private cVlrProd
	Private oMVlrProd
	Private nRadio := 2 //1
	Private aRadio := {"Pesquisa Normal", "Contem Expressao"}  
	Private _cQuery:=""

	DbSelectArea("SIX")
	DbSeek(cAlias)
	aCombo := {}   
	Do While SIX->INDICE == cAlias
		AADD(aCombo, SIX->DESCRICAO)
		DbSkip()
	EndDo      

	//Lista de campos do browser da consulta(F3)
	aCposTela := {"Z1_CODIGO","Z1_NOME","Z1_MUN","Z1_UF","Z1_OBS"}

	DbSelectArea("SX3")
	DbSetOrder(2)
	DbSeek(cAlias, .T.)
	For i:=1 To Len(aCposTela)
		dbSeek(aCposTela[i])
		AADD(aGrid, {aCposTela[i], X3_DESCRIC, X3_PICTURE})
		AADD(aFiltrar, aCposTela[i])
		AADD(aNFiltrar, X3_DESCRIC)
		If AllTrim(aCposTela[i]) == cCampoDefault
			nFiltrar := nSeq
		EndIf
		nSeq++
	Next

	DEFINE MSDIALOG mkwdlg FROM 066,000 To 520,850 TITLE OemToAnsi(cTitulo) PIXEL OF oMainWnd

	//Local + Saldo Atual + Custo Unitario Atual

	@ 183,005 say "Buscar "

	@ 190,005 GET cTexto Picture "@!" Valid Filtra(cAlias, cTexto, aFiltrar[nFiltrar], nRadio, _cFiltro) Size 85,18 Object oTexto

	@ 201,005 RADIO aRadio VAR nRadio Object oRadio

	@ 183,105 Say "Campo"
	@ 192,105 LISTBOX nFiltrar Items aNFiltrar Size 90,26 Object oFiltrar

	@ 183,205 Say "Ordem"
	@ 190,205 LISTBOX nOrdem Items aCombo Size 90,26 Object oCombo1
	oCombo1:bChange := {|| oCombo1:Refresh(), &(cAlias)->(DbSetOrder(nOrdem)), &(cAlias)->(DbGoTop()), ;
	oABC:oBrowse:GoTop(), oABC:oBrowse:Refresh() }
	DbSelectArea(cAlias)    

	@ 000,000 To 175,427 BROWSE cAlias FIELDS aGrid Object oABC

	@ 203,305 Button OemToAnsi("_Filtrar")   Size 36,15 Action Filtra(cAlias,cTexto,aFiltrar[nFiltrar],nRadio,_cFiltro) Object obj01
	@ 203,345 Button OemToAnsi("_Confirmar") Size 36,15 Action Eval( {|| lOk := .T. , mkwdlg:End()} ) Object obj02

	//@ 190,305 Button OemToAnsi("Ajuste cliente") Size 75,10 Action ( AlterSa1() ) Object obj04
	//@ 190,385 Button OemToAnsi("Inclui cliente") Size 36,10 Action ( inclSa1()  ) Object obj04

	@ 203,385 Button OemToAnsi("_Fechar")    Size 36,15 Action mkwdlg:End() Object obj03

	oABC:oBrowse:blDblClick := {|| lOk:= .T. , mkwdlg:End() }
	oABC:oBrowse:lColDrag   := .T.

	//Posiciona o Registro]
	&(cAlias)->(dbSetOrder(nStartOrdem))
	&(cAlias)->(DbSetOrder(nOrdem))

	//Recupera ultimo texto usado no filtro se for inclusao de novo aCols    
	/*nPosProd := aScan(aHeader, {|x|Substr(x[2], 4, 7) == "_PRODUT"})
	if nPosProd <> 0
	If !Empty(Alltrim(cUTexto)) .and. Empty(aCols[N][aScan(aHeader, {|x|Substr(x[2], 4, 7) == "_PRODUT"})])
	oTexto:cText := cUTexto
	EndIf
	Endif*/

	oTexto:SetFocus()

	//oABC:oBrowse:bChange := {|| U_PMS02AUX() }

	Activate Dialog mkwdlg CENTERED


	nPosicionar := Recno()

	DbSetOrder(nOldOrd)
	If lOk
		DbGoTo(nPosicionar)
	Else
		DbGoTo(nMarca)
	EndIf


	DbSelectArea(cAlias)
	&(cAlias)->(DbClearFilter())
	
	//RestArea(_aArea)

Return (lOk)


/*/{Protheus.doc} Filtra
//Filtra registros - usada PesqXSA1
@author solutio
@since 11/10/2018
@version 1.0
@type function
/*/
Static Function Filtra(xAlias,cTexto,cCampo, nTipo, cExtraFilter)

	Local cFiltro := ""

	If !Empty(Alltrim(cTexto))

		If nTipo == 2	//Filtra texto em qualquer posicao da descricao
			cFiltro := '"' + AllTrim(cTexto) + '"' + "$" + cCampo
		Else			//Filtra texto pelo inicio da descricao
			cFiltro := cCampo + '>="' + AllTrim(cTexto) + '"'
		EndIf

		&(xAlias)->(DbSetFilter( {|| &cFiltro }, cFiltro ))

		oABC:oBrowse:GoTop()
		oABC:oBrowse:Refresh()
		oABC:oBrowse:SetFocus()
		&(xAlias)->(DbGoTop())                       

	Else

		dbSelectArea(xAlias)
		&(xAlias)->(DBClearFilter()) 
		&(xAlias)->(DBGoTop())

		oABC:oBrowse:GoTop()
		oABC:oBrowse:Refresh()
		oABC:oBrowse:SetFocus()
		&(xAlias)->(DbGoTop()) 

	EndIf


Return ( .T. )
