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
           

/*/{Protheus.doc} PesqXSA1
//Super SA1 - XSA1
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
User Function PesqXSA1(cTitulo, cAlias, nStartOrdem, cCampoDefault, _cFiltro)

	Local cTexto := SPACE(40), nOrdem := 2//
	Local lOk := .F., aCombo, oCombo1, oFiltrar, oRadio
	Local nMarca    := &(cAlias)->(Recno())
	Local nOldOrd   := &(cAlias)->(IndexOrd())
	Local aGrid     := {}
	Local aFiltrar  := {}
	Local aNFiltrar := {}
	Local nFiltrar  := 1
	local i         := 1
	Local nSeq      := 1
	Local oFont
	Private cLocal01
	Private oMLocal01
	Private cVlrProd
	Private oMVlrProd
	Private nRadio := 1
	Private aRadio := {"Pelo Inicio", "Qualquer Posicao"}  


	Private _cQuery:=""

	DbSelectArea("SIX")
	DbSeek(cAlias)
	aCombo := {}   
	Do While SIX->INDICE == cAlias
		AADD(aCombo, SIX->DESCRICAO)
		DbSkip()
	EndDo      

	//Lista de campos do browser da consulta(F3)
	aCposTela := {"A1_COD","A1_LOJA","A1_NOME","A1_CGC","A1_EST","A1_END"}

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
	/*@ 178,005 say "Cadastro de Funcionarios"
	@ 185,005 GET oMLocal01 VAR cLocal01 MEMO SIZE 190,18 FONT oFont OF mkwdlg PIXEL

	//Valor/Custo Standard do Produto + Data de Atualizacao
	@ 178,205 say "Informa??es"
	@ 185,205 GET oMVlrProd VAR cVlrProd MEMO SIZE 215,18 FONT oFont OF mkwdlg PIXEL*//////

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

	//@ 190,305 Button OemToAnsi("Ajuste cadastro Partcip.") Size 75,10 Action ( AlterSa1() ) Object obj04
	//@ 190,385 Button OemToAnsi("Novo Particip.") Size 36,10 Action ( inclSa1()  ) Object obj04


	@ 203,385 Button OemToAnsi("_Fechar")    Size 36,15 Action mkwdlg:End() Object obj03

	oABC:oBrowse:blDblClick := {|| lOk:= .T. , mkwdlg:End() }
	oABC:oBrowse:lColDrag   := .T.

	//Posiciona o Registro 
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
	
	/*
	if Select("TSA1")<>0
		TSA1->(dbCloseArea())
	Endif

	_cQuery:= "SELECT * FROM " + RetSqlName("SA1")+ " WHERE R_E_C_N_O_ = '"+cvaltochar(RECNO())+"' AND D_E_L_E_T_= '' "
	TcQuery _cQuery Alias "TSA1" New
	DbSelectArea("TSA1")  
	
	If (FunName() == "JMHA230") 

		M->ZO_CLIENTE	:= TSA1->A1_COD
		M->ZO_LOJA		:= TSA1->A1_LOJA
		
	Else
		
		M->C5_CLIENTE:= TSA1->A1_COD
		M->C5_LOJACLI:= TSA1->A1_LOJA
		
	EndIf
	

	TSA1->(dbCloseArea())
	
	*/
	

Return (lOk)


/*/{Protheus.doc} Filtra
//Filtra registros - usada PesqXSA1
@author Celso Rene
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

		dbSelectArea("SA1")
		SA1->(DBClearFilter())
		SA1->(DBGoTop())

		oABC:oBrowse:GoTop()
		oABC:oBrowse:Refresh()
		oABC:oBrowse:SetFocus()
		&(xAlias)->(DbGoTop()) 

	EndIf
	
Return (.T.)


/*/{Protheus.doc} AlterSa1
//Altera registros - usada PesqXSA1
@author Celso Rene
@since 11/10/2018
@version 1.0
@type function
/*/         
Static Function AlterSa1() 

	Local nOpA:=0
	Local _saArea:=GetArea()

	Private cCadastro:="SA1"   
	Private aCho1 := {"A1_COD","A1_LOJA","A1_NOME","A1_PESSOA","A1_DTNASC", "A1_NOMMAE","A1_APELIDO","A1_END","A1_BAIRRO","A1_CEP","A1_TIPO","A1_EST","A1_COD_MUN","A1_MUN","A1_EMAIL","A1_DDD","A1_TEL","A1_CGC","A1_INSCR" ,"A1_KMIPI","A1_TPSANG","A1_REGCBA","A1_ANOCBA","A1_CONTA","A1_PRF_OBS","A1_PAIS","A1_COD_PAIS"}
	Private aCpos1:= {"A1_COD","A1_LOJA","A1_NOME","A1_PESSOA","A1_DTNASC", "A1_NOMMAE","A1_APELIDO","A1_END","A1_BAIRRO","A1_CEP","A1_TIPO","A1_EST","A1_COD_MUN","A1_MUN","A1_EMAIL","A1_DDD","A1_TEL","A1_CGC" ,"A1_INSCR","A1_KMIPI","A1_TPSANG","A1_REGCBA","A1_ANOCBA","A1_CONTA","A1_PRF_OBS","A1_PAIS","A1_COD_PAIS"}

	//Local _nRecno:=  0//Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE,"R_E_C_N_O_")    

	If (Select("TSA1") <> 0)
		TSA1->(dbCloseArea())
	Endif

	_cQuery:= "SELECT A1_COD, A1_LOJA, R_E_C_N_O_ FROM " + RetSqlName("SA1") + " WHERE R_E_C_N_O_ = '"+cvaltochar(RECNO())+"' AND D_E_L_E_T_= '' "
	TcQuery _cQuery Alias "TSA1" New
	DbSelectArea("TSA1")  

	//M->C5_CLIENTE:= TSA1->A1_COD
    //M->C5_LOJA   := TSA1->A1_LOJA

	nOpA:=AXALTERA("SA1",TSA1->R_E_C_N_O_,4,aCho1,aCpos1,,,,,,)                          

	TSA1->(dbCloseArea())  

	If (nOpA == 1)                       
		MSGInfo("Salvou Alteracao do cadastro!","Alteracao Cadastro")  
	Else //(nOpA == 2)
		MSGAlert("Cancelou Alteracao cadastro!","Cancel Cadastro")  
	EndIf


	RestArea(_saArea)

Return() 

/*/{Protheus.doc} inclSa1
//Inclui registros - usada PesqXSA1
@author solutio
@since 11/10/2018
@version 1.0
@type function
/*/    
Static Function inclSa1()   

	Local _sArea := GetArea()
	Local nOpca  := 0   

	//Private aCho := {"Z6_COD","Z6_LOJA","Z6_NOME","Z6_PESSOA","Z6_DTNASC", "Z6_NOMMAE","Z6_APELIDO","Z6_END","Z6_EST","Z6_MUN","Z6_EMAIL","Z6_TELEF","Z6_CPF","Z6_NROCARR","Z6_PAPEL" ,"Z6_KMIPI","Z6_TPSANG","Z6_REGCBA","Z6_ANOCBA","Z6_ANTECIP","Z6_CONTA"}
	//Private aCpos :=  {"Z6_COD","Z6_LOJA","Z6_NOME","Z6_PESSOA","Z6_DTNASC", "Z6_NOMMAE","Z6_APELIDO","Z6_END","Z6_EST","Z6_MUN","Z6_EMAIL","Z6_TELEF","Z6_CPF","Z6_NROCARR","Z6_PAPEL" ,"Z6_KMIPI","Z6_TPSANG","Z6_REGCBA","Z6_ANOCBA","Z6_ANTECIP","Z6_CONTA"}

	Private aCho := {"A1_COD","A1_LOJA","A1_NOME","A1_PESSOA","A1_DTNASC", "A1_NOMMAE","A1_APELIDO","A1_END","A1_BAIRRO","A1_CEP","A1_TIPO","A1_EST","A1_COD_MUN","A1_MUN","A1_EMAIL","A1_DDD","A1_TEL","A1_CGC" ,"A1_INSCR","A1_KMIPI","A1_TPSANG","A1_REGCBA","A1_ANOCBA","A1_CONTA","A1_PRF_OBS","A1_PAIS",,"A1_COD_PAIS"}
	Private aCpos:= {"A1_COD","A1_LOJA","A1_NOME","A1_PESSOA","A1_DTNASC", "A1_NOMMAE","A1_APELIDO","A1_END","A1_BAIRRO","A1_CEP","A1_TIPO","A1_EST","A1_COD_MUN","A1_MUN","A1_EMAIL","A1_DDD","A1_TEL","A1_CGC" ,"A1_INSCR","A1_KMIPI","A1_TPSANG","A1_REGCBA","A1_ANOCBA","A1_CONTA","A1_PRF_OBS","A1_PAIS",,"A1_COD_PAIS"}


	//Private cCadastro:="SZ6"
	Private cCadastro:="SA1"   

	nOpca:= Axinclui("SA1", ,3, acho, , aCpos, ,.T. ,;   
	, , , , , .T.)   

	//1=OK - nOpca
	//2=CANCELA - nOpca  //Funciona quase como pe depois da gravacao


	If (nOpca == 1)

	Else //(nOpca == 2)
		MSGAlert("Cancelou Inclusao cadastro!","Cancel Cadastro")  
	EndIf

	RestArea(_sArea)


Return()	  
