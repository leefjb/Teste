#Include "Protheus.ch"
#Include "Rwmake.ch"
#INCLUDE "tbiconn.ch"
#Include "topconn.ch"

//FONTE PADRAO: ACDV121 - conferencia de mercadoria conforme documento de entrada

/*/{Protheus.doc} ENTZZE
//Tela customizada para conferencia e recebimento
@author Celso Rene
@since 28/10/2018
@version 1.0
@type function
/*/
User Function ENTZZE()
	// Variaveis Locais da Funcao
	Private aLoteVal	 := {"Lote do Produto 1  -  Validade do Lote","Lote do Produto 2 -   Validade do Lote","Lote do Produto 3 -   Validade do Lote"}
	Private cCodBar	 := Space(30)
	Private cFornecedo	 := Space(06)
	Private cLoja	 := Space(02)
	Private cnfiscal := Space(09)
	Private cqtd	 := 1.00
	Private cserie	 := Space(03)
	Private NomeFor	 := ""
	Private oCodBar
	Private oCodBar2
	Private cCodBar2 := Space(30)
	Private oFornecedo
	Private oLoja
	Private onfiscal
	Private oqtd
	Private oserie
	Private oLoteVal
	Private cLoteVal  := "Lote do Produto  -  Validade do Lote"
	Private oLabel1   := NIL
	Private cLABEL1   :=''
	Private oButMan	
	////Private CFILIAL   :=''

	Private oLabel2   := NIL
	Private cLABEL2   :=''

	Private oLabel3   := NIL
	Private cLABEL3   := ''

	// Variaveis Private da Funcao
	Private _oDlg				// Dialog Principal
	// Variaveis que definem a Acao do Formulario
	Private VISUAL := .F.                        
	Private INCLUI := .F.                        
	Private ALTERA := .F.                        
	Private DELETA := .F.                        

	Private Icodigo := ''
	Private IDESCRI := ''
	Private Iqtd := ''
	Private ILote := ''
	Private Ivalidade := ''
	Private IDESCRICAO := ''
	Private LQTD := .T.

	Private _oButton 

	Private _aPrdCB0 := {}



	DEFINE MSDIALOG _oDlg TITLE "Processo de Conferências de Entrada de Materiais" FROM C(177),C(184) TO C(470),C(900) PIXEL

	// Cria Componentes Padroes do Sistema
	@ C(004),C(037) MsGet onfiscal Var cnfiscal F3 "SF1" VALID(PEGANF(cNfiscal)) Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(004),C(122) MsGet oserie Var cserie Size C(032),C(009) READONLY COLOR CLR_BLACK  PIXEL OF _oDlg
	@ C(004),C(162) Say "Fornecedor:" Size C(030),C(008)  COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(004),C(195) MsGet oFornecedo Var cFornecedo Size C(060),C(009)  READONLY COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(004),C(264) Say "Loja:" Size C(013),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(004),C(285) MsGet oLoja Var cLoja Size C(060),C(009)  READONLY COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(004),C(010) Say "N.Fiscal:" Size C(022),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(004),C(105) Say "Serie:" Size C(015),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(019),C(011) Say oLabel1 VAR CLABEL1 Size C(338),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

	@ C(070),C(010) Say oLABEL2 var CLABEL2 Size C(117),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

	//@ C(067),C(164) Say "Complemento vem aqui......" Size C(066),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(070),C(164) Say oLABEL3 var CLABEL3 Size C(066),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(130),C(310) Button "Sair" Size C(040),C(012) PIXEL OF _oDlg  	Action(_oDlg:End())

	/////////@ C(130),C(020) Button "Grava Leitura" Size C(040),C(012) PIXEL OF _oDlg ;
	//////Action(impetq(CNFISCAL,CSERIE,CFORNECEDO,CLOJA) )
	@ C(130),C(015) Button "Monitor Receb." Size C(040),C(012) PIXEL OF _oDlg Action(Monitor() )

	@ C(130),C(065) Button "Gera Comparação" Size C(040),C(012) PIXEL OF _oDlg Action(GeraComp(CNFISCAL,CSERIE,CFORNECEDO,CLOJA))


	ACTIVATE MSDIALOG _oDlg CENTERED 

Return(.T.)

//Funcao responsavel por manter o Layout independente da resolucao horizontal do Monitor do Usuario. 
Static Function C(nTam)         

	Private nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         

	//Tratamento para tema "FlaT"                                                                                            
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)                                                                



/*/{Protheus.doc} PEGANF
//Valida o documento selecionado e posiciona em outros registros referente ao documento.
@author solutio
@since 28/10/2018
@version 1.0
@return ${return}, ${return_description}
@param cNF, characters, descricao
@type function
/*/
STATIC FUNCTION PEGANF(cNF)

	Local aArea 	:= getarea()
	Local _lRetNF	:= .T.

	cSerie		:= "" //SF1->F1_SERIE        //POSICIONE("SF1",1,XFILIAL("SF1")+ALLTRIM(CNF),"F1_SERIE")
	cFornecedo	:= "" //SF1->F1_FORNECE 		//POSICIONE("SF1",1,XFILIAL("SF1")+ALLTRIM(CNF),"F1_FORNECE")
	cLoja		:= "" //SF1->F1_LOJA         	//POSICIONE("SF1",1,XFILIAL("SF1")+ALLTRIM(CNF),"F1_LOJA")
	If !( Empty(cNF) .and. Empty(cLoja) .and. Empty(cSerie) .and. Empty(cFornecedo) )
		NomeFor		:= POSICIONE("SA2",1,XFILIAL("SA2")+cFornecedo,"A2_NOME")
		cSerie		:= SF1->F1_SERIE       
		cFornecedo	:= SF1->F1_FORNECE 		
		cLoja		:= SF1->F1_LOJA
		oLABEL1:SetText("Fornecido por: "+NomeFor)
		oLABEL1:Refresh()
	EndIf

	//Verificando se existe registros de controle conferencia - gerados no PE: MT100AGR
	dbSelectArea("ZZE")
	dbSetOrder(1)
	dbSeek(xFilial("ZZE") + cNF + cSerie + cFornecedo + cLoja  )
	If (! Found())

		MsgAlert("Não encontrados registros de controle recebimentos!","# Conferência ZZE")
		cFornecedo	:= Space(06)
		cLoja	 	:= Space(02)
		cnfiscal 	:= Space(09)
		cserie	 	:= Space(03)
		NomeFor		:= ""
		onfiscal:Refresh()
		oSerie:Refresh()
		oFornecedo:Refresh()
		oLoja:Refresh()
		oLABEL1:SetText("Fornecido por: " + NomeFor)
		oLABEL1:Refresh()
		onfiscal:SetFocus()
		_oDlg:Refresh()
		RestArea(aArea)
		Return( .T. )

	EndIf

	//If ( Empty(cNF) .or. Empty(cLoja) .or. Empty(cSerie) .or. Empty(cFornecedo) )
	//MsgAlert("Documento de entrada, não encontrado !", "# Seleção Documento")
	//_lRetNF := .F.
	///_oDlg:Refresh()
	//oCodBar:SetFocus()
	//onfiscal:SetFocus()
	//Else	

	_cConfere := POSICIONE("SA2",1,XFILIAL("SA2")+cFornecedo,"A2_CONFFIS")
	If !(_cConfere == "2" .or. _cConfere == "0" )
		MsgAlert("Documento não encontrado ou fornecedor não configurado - conferência física !","# Conferência DOC - A2_CONFFIS")
		cFornecedo	:= Space(06)
		cLoja	 	:= Space(02)
		cnfiscal 	:= Space(09)
		cserie	 	:= Space(03)
		NomeFor		:= ""	
		oLABEL1:SetText("Fornecido por: " + NomeFor)
		oLABEL1:Refresh()
		onfiscal:Refresh()
		oSerie:Refresh()
		oFornecedo:Refresh()
		oLoja:Refresh()
		onfiscal:SetFocus()
		_oDlg:Refresh()
		RestArea(aArea)
		Return( .T. )
	EndIf


	/////////le layout fornecedor
	_LayoutFor(cFornecedo, cLoja)

	//@ C(039),C(009) Say "Cod:" Size C(013),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	//@ C(038),C(027) MsGet oCodBar Var cCodBar  VALID(PEGACOD2(CCODBAR))  /*VALID(PEGACOD(CCODBAR))*/ Size C(123),C(009) COLOR CLR_BLACK PIXEL OF _oDlg



	/*If LQTD  //tratamento validacao quantidade                         
	//@ C(038),C(155) Say "Qtd:" Size C(012),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(038),C(155) Say "Qtd:" Size C(012),C(008)  COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(038),C(168) MsGet oqtd Var cqtd PICTURE "@E 9,999.99" VALID(VEQTD(CQTD)) Size C(035),C(009) COLOR CLR_BLACK PIXEL OF _oDlg 
	ElseIf !LQTD //.AND. SB1->B1_IMPCOD=='S'
	@ C(038),C(155) Say "Qtd:" Size C(012),C(008)  COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(038),C(168) MsGet oqtd Var cqtd PICTURE "@E 9,999.99" VALID(VEQTD(CQTD)) Size C(035),C(009)  COLOR CLR_BLACK PIXEL OF _oDlg
	EndIf*/

	//////... aqui busca e monta o ,layout para leitura da etiqueta no recebimento

	_oDlg:Refresh()
	/////////////////oCodBar:SetFocus()
	//EndIf


	RestArea(aArea)

Return ( _lRetNF )


/*/{Protheus.doc} PEGACOD
//Valida o codigo de barras e chama rotina de impressao da etiqueta e grava os registros conforme ACD.
@author Celso Rene
@since 28/10/2018
@version 1.0
@type function
/*/
STATIC FUNCTION PEGACOD(CCODBAR , CCODBAR2 )

	Local cArea		:= getArea()                         
	Local cCODIX	:= ''

	Private _cTipo1	:= ""
	Private _cProd1	:= ""
	Private _cLote1	:= ""
	Private _cvLote1:= ""

	Private _cTipo2	:= ""
	Private _cProd2	:= ""
	Private _cLote2	:= ""
	Private _cvLote2:= ""

	Private _nlayF1	:= 0
	Private _nlayF2	:= 0


	cProduto		:= CCODBAR

	//nao informado codigo
	If ( Empty(CCODBAR) )
		cProduto   	:= ""
		CCODBAR		:=  Space(15)
		cCodApre   	:= ""
		cDesApre	:= ""
		oLABEL2:SetText(cPRODUTO)
		oLABEL2:Refresh()       
		oLABEL3:SetText(cDESAPRE)
		Idescri		:=cProduto
		cLoteVal	:= "Lote do Produto  -  Validade do Lote"
		//oLoteVal:Refresh()
		oCodBar:Refresh()
		_oDlg:Refresh()
		RestArea(cArea)
		Return( .T. )
	EndIf

	//////LAYOUT FORNECEDOR LENDO

	_cProd	:= ""
	_cLote	:= ""
	_cVLote := ""

	dbSelectArea("ZZF")
	dbSetOrder(1) //ZZF_FILIAL + ZZF_FORNEC + ZZF_LOJA
	dbSeek(xFilial("ZZF") + CFORNECEDO + CLOJA)
	If ( Found() )

		If ( Empty(CCODBAR2) )

			_cProd := SUBSTR(CCODBAR,ZZF->ZZF_P1DE,ZZF->ZZF_P1ATE)
			_cLote := SUBSTR(CCODBAR,ZZF->ZZF_L1DE,ZZF->ZZF_L1ATE)
			_cVLote:= SUBSTR(CCODBAR,ZZF->ZZF_V1DE,ZZF->ZZF_V1ATE)

			If ZZF_TIPO1 == "1"
				_aProd :=  {"1",_cProd,_cLote}
			Else
				_aProd :=  {"2",_cProd,_cLote} 
			EndIf

		Else

			//produto
			If ( ( ZZF->ZZF_P1DE + ZZF->ZZF_P1ATE) > 0 ) 
				_cProd := SUBSTR(CCODBAR,ZZF->ZZF_P1DE,ZZF->ZZF_P1ATE)
			ElseIf (ZZF->ZZF_P2DE + ZZF->ZZF_P2ATE) > 0
				_cProd := SUBSTR(CCODBAR2,ZZF->ZZF_P2DE,ZZF->ZZF_P2ATE)
			EndIf

			//lote
			If ( (ZZF->ZZF_L1DE+ZZF->ZZF_L1ATE) > 0 ) 
				_cLote := SUBSTR(CCODBAR,ZZF->ZZF_L1DE,ZZF->ZZF_L1ATE)
			ElseIf ( (ZZF->ZZF_L2DE+ZZF->ZZF_L2ATE) > 0 )
				_cLote := SUBSTR(CCODBAR2,ZZF->ZZF_L2DE,ZZF->ZZF_L2ATE)
			EndIf

			//valid lote
			/*
			If ( (ZZF->ZZF_V1DE+ZZF->ZZF_V1ATE) > 0 ) 
			_cVLote := SUBSTR(CCODBAR2,ZZF->ZZF_V1DE,ZZF->ZZF_V1ATE)
			ElseIf ( (ZZF->ZZF_V2DE+ZZF->ZZF_V2ATE) > 0 ) 
			_cVLote := SUBSTR(CCODBAR2,ZZF->ZZF_V2DE,ZZF->ZZF_V2ATE)
			EndIf
			*/

			//tipo
			If ( (ZZF->ZZF_TIPO1 == "1" .or. ZZF->ZZF_TIPO2 == "1" ) .or. (ZZF->ZZF_TIPO1 == "" .and. ZZF->ZZF_TIPO2 == "") )  
				_aProd :=  {"1",_cProd,_cLote}
			Else
				_aProd :=  {"2",_cProd,_cLote} 
			EndIf


		EndIf

	EndIf

	_cProduto := BusCodFor( CFORNECEDO,CLOJA,_aProd[2],_aProd[1])

	//recebimento - informando valores manuais do item
	If Empty(_cProduto)
		_cProduto := "xxxxxx"
	EndIf 

	//DBSelectArea("SB8")
	//DBSetOrder(3) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)                                                                                            
	//dbSeek(xFilial("SB8") +  )

	LQTD   := .T. //verifica se vai ler etiqueta
	cCodiX := _cProduto //CCODBAR


	////chama a funcao T

	dBSelectArea("ZZE")
	dBSetOrder(2)

	ALOTEVAL:={}

	If ( DBSEEK(XFILIAL("ZZE")+Padr( CNFISCAL , TamSx3("F1_DOC")[1] )+CSERIE+CFORNECEDO+CLOJA+CCODIX) )

		DO WHILE !EOF() .AND. CNFISCAL+CSERIE+CFORNECEDO+CLOJA+CCODIX==;
		ZZE->ZZE_DOC+ZZE->ZZE_SERIE+ZZE->ZZE_FORNEC+ZZE->ZZE_LOJA+ZZE->ZZE_COD

			If ( ALLTRIM(ZZE->ZZE_COD) == ALLTRIM(CCODIX) )                     
				CLOTE    := ZZE->ZZE_LOTECT
				CVALID   := ZZE->ZZE_DTVALI
				cLoteVal := CLOTE+" - "+DTOC(CVALID)
				AADD(aLoteVal,CLOTE+" - "+DTOC(CVALID))
			EndIf

			ZZE->(DBSKIP())

		ENDDO     


	Else

		MsgAlert("O Item:  "+CCODBAR+"  no Documento: " + CNFISCAL +" não encontrado !","# Recebimento")		
		cProduto   	:= ""
		cCODIX		:= ""
		cCodBar		:=  Space(30)
		cCodApre   	:= ""
		cDesApre	:= ""
		//oLABEL1:SetText()
		oLABEL2:SetText(cPRODUTO)      
		oLABEL3:SetText(cDESAPRE)
		Idescri		:= cProduto
		cLoteVal	:= "Lote do Produto  -  Validade do Lote"
		//oLoteVal:Refresh()
		//oLABEL1:Refresh()
		oLABEL2:Refresh() 
		oLABEL3:Refresh()
		oCodBar:Refresh()
		If ( ! Empty(CCODBAR2) )
			cCodBar2 := Space(30)	
			oCodBar2:Refresh()
		EndIf

		//recebimento - informando valores manuais do item
		InfManual() 

		RestArea(cArea)

		_oDlg:Refresh()
		oCodBar:SetFocus() 

		///chamando tela informacao dos dados manuais no recebimento


		Return( .T. )

	EndIf 

	/////mostra produto e complemento ////////////////////////////////////
	cProduto   := POSICIONE("SB1",1,XFILIAL("SB1")+CCODIX,"B1_DESC")

	Idescri := cProduto

	///PEGANDO DESCRICAO DA APRESENTACAO//////////////////////////////////
	cCodApre   := CCODIX //POSICIONE("SB1",1,XFILIAL("SB1")+CCODIX,"B1_CODAPRE")
	//cDesApre   := POSICIONE("SB1",1,XFILIAL("SB1")+CCODIX,"B1_TIPO")  //POSICIONE("LEL",1,XFILIAL("LEL")+cCODAPRE,"LEL_APRESE") 

	Icodigo	:= CCODIX                        

	//realizando processo de recebimento
	//If ( ! ( Empty(cNfiscal) .and. Empty(cSerie) .and. Empty(cFornecedo) .and. Empt(cLoja) .and. Empty(NomeFor)  ) ) //(PEGANF(cNF))
	MsgRun("Gerando Recebimento...","# Conferência",{|| CursorWait(), impetq(CNFISCAL,CSERIE,CFORNECEDO,CLOJA,_cProduto,_cLote,_cVLote,.F.), CursorArrow()})
	//Else
	//////////////MsgAlert("Documento de entrada, não encontrado !", "# Seleção Documento")
	//EndIf


	_oDlg:Refresh()
	RESTAREA(CAREA)


RETURN( .T. )


/*/{Protheus.doc} VEQTD
//Valida quantidade das etiquetas.
@author Celso Rene
@since 28/10/2018
@version 1.0
@type function
/*/
Static Function VEQTD(CQTD)

	//verificar regra para quantidadde de etiquetas e conferencia de recebimentos
	/*IF CQTD <> 1 
	MsgAlert("Não é permitida quantidade para separar diferente que 1 !","# Recebimento")
	CQTD := 1
	oqtd:Refresh()
	_oDlg:Refresh()
	RETURN .F.
	ENDIF*/

Return( .T. )


/*/{Protheus.doc} GRAVAREG
//Grava registros da tabela customizada - conferencia de recebimento
@author Celso Rene
@since 28/10/2018
@version 1.0
@return ${return}, ${return_description}
@param KDoc, , descricao
@param KSerie, , descricao
@param KFornece, , descricao
@param KLoja, , descricao
@param KlTipo, , descricao
@type function
/*/
User Function GRAVAREG(KDoc,KSerie,KFornece,KLoja,KlTipo)

Local _lXConf	:= .F.

	DbSelectArea("SD1")
	DbSetOrder(1)           

	If DbSeek(XFILIAL("SD1")+KDoc+KSerie+KFornece+KLoja)
		////SE JA EXISTIR ESTA NOTA NO ZZE
		////ESTA TEM DE SER ELIMINADA...

		While !EOF() .AND. KDoc+KSerie+KFornece+KLoja == ;
		SD1->D1_DOC+SD1->D1_SERIE+D1_FORNECE+D1_LOJA


			//carregando dados para a impressao da etiqueta
			dbSelectArea("SB5")	
			dbSetOrder(1)
			dbSeek(xFilial("SB5") + SD1->D1_COD ) 

			//controle impressao etiquetas + quantidades a imprimir no recebimento
			If ( Found() .and. SB5->B5_XIMPETQ == "S" .and. SB5->B5_XQTDIMP > 0 ) 

				DbSelectArea("SF4")
				DbSetOrder(1)
				DbSeek(xFilial("SF4") +SD1->D1_TES) //.and. SD1->D1_ETQPROD == "S"
				If SF4->F4_ESTOQUE == "S"

					RECLOCK("ZZE",lTipo)

					ZZE->ZZE_FILIAL		:= SD1->D1_FILIAL
					ZZE->ZZE_DOC		:= SD1->D1_DOC
					ZZE->ZZE_SERIE		:= SD1->D1_SERIE
					ZZE->ZZE_FORNEC  	:= SD1->D1_FORNECE
					ZZE->ZZE_LOJA		:= SD1->D1_LOJA
					ZZE->ZZE_QTDNF    	:= SD1->D1_QUANT
					//ZZE0>ZE_QTDLID                        
					ZZE->ZZE_ITEM		:= SD1->D1_ITEM
					ZZE->ZZE_COD		:= SD1->D1_COD
					ZZE->ZZE_NUNLOT		:= SD1->D1_NUMLOTE
					ZZE->ZZE_LOTECT  	:= SD1->D1_LOTECTL
					ZZE->ZZE_DTVALI		:= SD1->D1_DTVALID
					ZZE->ZZE_DATA		:= dDataBase
					ZZE->ZZE_USER		:= cUserName
					ZZE->ZZE_PEDIDO		:= SD1->D1_PEDIDO
					ZZE->ZZE_LOCAL		:= SD1->D1_LOCAL
					ZZE->ZZE_NUMSEQ		:= SD1->D1_NUMSEQ
					
					_lXConf 			:= .T.

					MSUNLOCK()


					//_cRasto := Posicione("SB1",1,xFilial("SB1") + ZZE->ZZE_COD )
					If ( Alltrim(ZZE->ZZE_LOTECT) <> "" )

						_aItens:= {ZZE->ZZE_COD,ZZE->ZZE_LOCAL,ZZE->ZZE_LOTECT,ZZE->ZZE_QTDNF,ZZE->ZZE_ITEM,;
						ZZE->ZZE_DOC,ZZE->ZZE_SERIE,ZZE->ZZE_FORNEC,ZZE->ZZE_LOJA}

						//Bloqueando lote
						//_cDodSDD	:= u_ACD004( .T. , "" ,_aItens)
						_cNumZZG	:= u_ZZGLOTE( .T. , "" ,_aItens)

						If (_cNumZZG <> "")
							dbSelectArea("ZZE")
							RECLOCK("ZZE",.F.)
							ZZE->ZZE_XDOCL  := _cNumZZG
							ZZE->(MSUNLOCK())
						EndIf

					EndIf

				EndIf

			EndIf

			dbSelectArea("SD1")
			SD1->(dBSkip())    

		EndDo                         

	EndIf
	
	If (_lXConf == .F. ) //nao gerou ZZE
		dbSelectArea("SF1")
		RECLOCK("SF1",.F.)
		SF1->F1_STATCON := ""
		SF1->(MSUNLOCK())
	EndIf


Return Nil


/*/{Protheus.doc} impetq
//TImprime as etiquetas e grava os registros das transacoes do ACD
@author Celo Rene
@since 28/10/2018
@version 1.0
@return ${return}, ${return_description}
@param CNFISCAL, , descricao
@param CSERIE, , descricao
@param CFORNECEDO, , descricao
@param CLOJA, , descricao
@type function
/*/
Static Function impetq(CNFISCAL,CSERIE,CFORNECEDO,CLOJA,_cRecPrd,_cRecLote,_cRecVLote,_lMan)

	Local aArea		:= Getarea()
	Local _lEtiq 	:= .F.
	Local _nEmb		:= 0	

	codigo   := _cRecPrd //Icodigo
	descricao:= Idescri
	qtd      := cqtd
	lote     := _cRecLote //SUBSTR(cloteval,1,10)
	valid1   := _cRecVLote //SUBSTR(CLOTEVAL,22,10)


	///AGORA VAMOS ALIMENTAR O ZZE
	//DBSelectArea("ZZE")
	//DBSetOrder(3) //doc+serie+fornecedor+loja+codigo+lotectl+dtavalid                

	If ( BuscaZZE() )
		///////If ( DBSEEK(XFILIAL("ZZE")+ Padr( CNFISCAL , TamSx3("F1_DOC")[1] ) + CSERIE + CFORNECEDO + CLOJA + Padr( CODIGO , TamSx3("B1_COD")[1] ) + Padr( LOTE , TamSx3("ZZE_LOTECTL")[1] )+ VALID1) )
		//////itens com produto e lotes iguais 

		/*If (QTD> 1 )
		MsgAlert("Somente podera ser lido o recebimento de 1 item de cada vez - Controle de Lote x Etiqueta !","# Recebimento")
		QTD		:= 1
		cqtd	:= 1 
		Restarea(aArea)
		oCodBar:SetFocus()
		oqtd:Refresh()
		Return( .T. )
		EndIf */

		//gravando dados para serem usados na impressao da etiqueta CB0
		cCodSep		:= ""
		cNFEnt  	:= ZZE->ZZE_DOC
		cSeriee		:= ZZE->ZZE_SERIE
		cFornec		:= ZZE->ZZE_FORNEC
		cLojafo		:= ZZE->ZZE_LOJA
		cPedido		:= ZZE->ZZE_PEDIDO
		cEndereco	:= ""
		cArmazem	:= ZZE->ZZE_LOCAL
		cOp			:= ""
		cNumSeq		:= ZZE->ZZE_NUMSEQ
		cLote		:= ZZE->ZZE_LOTECT
		cSLote		:= ZZE->ZZE_NUNLOT
		dValid		:= ZZE->ZZE_DTVALI
		cCC			:= "" 
		cLocOri		:= ""
		cOPReq		:= ""
		cNumserie	:= ""
		cOrigem		:= ""
		cItNFE		:= ZZE->ZZE_ITEM
		
		
		dbSelectArea("SB5")
		dbSetOrder(1)
		dbSeek(xFilial("SB5") + ZZE->ZZE_COD )
		If ( Found() .and. SB5->B5_XEMB > 1 )
			If (QTD < SB5->B5_XEMB .or. Mod(QTD,SB5->B5_XEMB ) <> 0)
			 	MsgAlert("Quantidade menor que a embalagem para o produto: " + Alltrim(ZZE->ZZE_COD) + " ou não compatível - Embalagem: " +  cValtoChar(SB5->B5_XEMB) +" .", "# Qtd. Embalagem"  )
			 	QTD:= 0
			 Else 
			 	_nEmb	:= SB5->B5_XEMB
			 EndIf 
		ElseIf ( !Found() )
			MsgAlert("Não informado informações complemento Produto ACD - configuração recebimento!","# Revise cadastro")
			QTD:= 0
		EndIf 
		

		If ( (ZZE->ZZE_QTDLID+QTD) <= ZZE->ZZE_QTDNF ) .and. QTD > 0
		
		
			Begin Transaction 

				RECLOCK("ZZE",.F.)

				ZZE->ZZE_QTDLID  := ZZE->ZZE_QTDLID + QTD

				DBSelectArea("ZZE")
				ZZE->(MSUNLOCK())
					
				
				For _z:= 1 to QTD
					

					//gerando etiqueta CB0 1 a 1
					_cEtiq := CBGrvEti('01',{ZZE->ZZE_COD, If(_nEmb>0,_nEmb,1) ,cCodSep,cNFEnt,cSeriee,cFornec,cLojafo,cPedido,cEndereco,cArmazem,cOp,cNumSeq,NIL,NIL,NIL,;
					cLote,cSLote,dValid,cCC,cLocOri,NIL,cOPReq,cNumserie,cOrigem,cItNFE})
					
					//dbSelectArea("CB0")
					//RecLock("CB0", .F.)
					//CB0->CB0_CODETI	:= U_xNumZZI()
					//CB0->(MsUnLock())
					
					//_cEtiq 	:= CB0->CB0_CODETI 

					For _w:= 1 to SB5->B5_XQTDIMP

						aAdd(_aPrdCB0, {;
						ZZE->ZZE_COD,; 			//produto
						dValid,;				//validade lote
						cLote,;					//lote fornecedor
						_cEtiq,;				//etiqueta
						If(_nEmb>0,_nEmb,1),;	//quantidade
						CtoD(""),;				//data esterilizacao
						cLote;					//lote original
						})

					Next _w


					GravaCBE(ZZE->ZZE_COD,_cEtiq,cItNFE,cNFEnt,cSeriee,cFornec,cLojafo,cArmazem,cLote,cSLote,dValid,If(_nEmb>0,_nEmb,1),ZZE->ZZE_QTDLID , ZZE->ZZE_XDOCL )
					
					_z:= _z + _nEmb

				Next _z


				//impressao etiqueta - CB0
				If ( Len(_aPrdCB0) ) > 0
					//If (MSGYESNO( "Imprimir etiqueta(s) conforme conferência de recebimento ?", "# Impressão etiqueta(s) - Recebimento" ))
						u_ImpEtqCB0( _aPrdCB0 )////////////////
					//EndIf
				EndIf

				//inicializando variavel - dados para impressao etiqueta
				_aPrdCB0	:= {}


			End Transaction		

			//pensando em agilidade no processo, mensagem de sucesso
			//////Sleep( 1200 ) // Para o processamento por mais de 1 segundo 	
			MsgInfo("Gravado Recebimento: "+ CNFISCAL+CSERIE+CFORNECEDO+CLOJA+CODIGO+LOTE+ DTOS(CTOD(VALID1)) ;
			+ chr(13) + Chr(10) + "ID última Etiqueta gerada: "+ _cEtiq ,"# Recebimento")	

		Else

			If ( (ZZE->ZZE_QTDLID+QTD) >= ZZE->ZZE_QTDNF .and. QTD > 0 )
				MsgAlert("A quantidade ultrapassa o Documento, faltam " + cValtoChar(ZZE->ZZE_QTDNF - ZZE->ZZE_QTDLID) + " itens para recebimento do Produto !","# Qtd. Recebimento")

				If (QTD == 1 )//item do documento docunento conferido e recebido, imprimir etiquetas excedentes...  
					If (MSGYESNO( "Produto com separação completa, deseja Imprimir nova etiqueta ?", "# Impressão nova etiqueta" ))
						_cEtiq := CBGrvEti('01',{ZZE->ZZE_COD, 1 ,cCodSep,cNFEnt,cSeriee,cFornec,cLojafo,cPedido,cEndereco,cArmazem,cOp,cNumSeq,NIL,NIL,NIL,;
						cLote,cSLote,dValid,cCC,cLocOri,NIL,cOPReq,cNumserie,cOrigem,cItNFE})

						MsgInfo("Gerada etiqueta Excedida :"+ CNFISCAL+CSERIE+CFORNECEDO+CLOJA+CODIGO+LOTE+ DTOS(CTOD(VALID1)) ;
						+ chr(13)+ "ID Etiqueta: "+ _cEtiq ,"Recebimento")	

						//etiquetas excedidas - geradas apos a total separacao do item
						dbSelectArea("ZZE")
						RECLOCK("ZZE",.F.)
						ZZE->ZZE_ETIQEX  := ZZE->ZZE_ETIQEX + 1
						ZZE->(MSUNLOCK())

					EndIf					
				EndIf

			EndIf

		EndIf


	EndIf	


	//Chamada pelo rotina diferente de Inf. Manuais
	If !(_lMan)

		cProduto   	:= ""
		CCODBAR		:= Space(15)
		cCodApre   	:= ""
		cDesApre	:= ""
		oLABEL2:SetText(cPRODUTO)
		oLABEL2:Refresh()       
		oLABEL3:SetText(cDESAPRE)
		Idescri		:=cProduto
		//oLABEL1:SetText()
		oLABEL1:Refresh()
		//cLoteVal	:= "Lote do Produto  -  Validade do Lote"
		//oLoteVal:Refresh()
		oCodBar:Refresh()
		If ( ! Empty(CCODBAR2) )
			cCodBar2 := Space(30)	
			oCodBar2:Refresh()
		EndIf
		_oDlg:Refresh()

		oCodBar:SetFocus() 



	Else 	//Chamada pelo rotina de Inf. Manuais

		cGet4 := Space(TamSx3("B1_DESC")[1])
		cGet1 := Space(TamSx3("D1_COD")[1])
		cGet2 := Space(TamSx3("D1_LOTECTL")[1])
		dGet3 := dDataBase
		cGet5 := Space(20)
		aGet5 := {}
		@ 032, 106 ComboBox cGet5 Items aGet5 SIZE 110, 010 OF oDManual COLORS 0, 16777215 PIXEL
		cqtd:= 1
		oGet1:Refresh()		
		oGet2:Refresh()		
		oGet3:Refresh()
		oGet4:Refresh()
		oGet6:Refresh()
		oDManual:Refresh()
		oGet1:SetFocus()

		Icodigo	:= Space(TamSx3("D1_COD")[1])

	EndIf


	Restarea(aArea)     


Return( .T. )    


/*/{Protheus.doc} GravaCBE
//grava CBE - Etiquetas lidas no recebimento
@author Celso Rene
@since 24/10/2018
@version 1.0
@type function
/*/
Static Function GravaCBE(_cProd, _cEti, _cItem ,_cDoc, _cSerie, _cforn, _cLoja, _cArmz, _cLote, _cSlote, _dValid, _nQtd, _nQtdRec , _cSSDZZE)

	Local _lOpCB6	:= .T.
	Local _aARea    := GetArea()
	Local _cQuery	:= ""	

	dbSelectArea("SD1")
	dbSetOrder(1)//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     
	dbSeek(xFilial("SD1") +  Padr( _cDoc , TamSx3("D1_DOC")[1] ) + _cSerie + _cforn + _cLoja + Padr( _cProd , TamSx3("D1_COD")[1] ) + _cItem )

	//gerando recebimentos etiquetas para cada item conferido
	If ( Found() ) //.and. ZZE->ZE_QTDLIDA == ZZE->ZE_QTDNF )

		///VERIFICANDO SE ATUALIZA OU CRIA REGISTRO
		dbSelectArea("CBE")
		//dbSetOrder(3) //CBE_FILIAL+CBE_CODETI+CBE_NOTA+CBE_SDOC+CBE_FORNEC+CBE_LOJA+CBE_CODPRO +  CBE_LOTECT+DTOS(CBE_DTVLD)       
		//dbSeek(xFilial("CBE") +  _cEti + Padr( _cDoc , TamSx3("D1_DOC")[1] ) + _cSerie + _cforn + _cLoja + Padr( _cProd , TamSx3("D1_COD")[1])  )

		/*If ( Found() )
		_lOpCB6	:= .F. 
		Else
		_lOpCB6	:= .T. 
		EndIf */

		RECLOCK("CBE",_lOpCB6)

		CBE->CBE_FILIAL	:= xFilial("CBE") 
		CBE->CBE_CODETI	:= _cEti
		CBE->CBE_NOTA	:= SD1->D1_DOC
		CBE->CBE_SERIE	:= SD1->D1_SERIE
		CBE->CBE_FORNEC := SD1->D1_FORNECE
		CBE->CBE_LOJA	:= SD1->D1_LOJA
		CBE->CBE_CODPRO := SD1->D1_COD
		CBE->CBE_CODUSR := __cUserId
		CBE->CBE_DATA   := dDataBase
		CBE->CBE_HORA	:= Left(Time(),5)

		/*If !( _lOpCB6 )
		CBE->CBE_QTDE	:= _nQtd  
		Else
		CBE->CBE_QTDE	+= _nQtdRec
		EndIf*/

		CBE->CBE_QTDE	:= _nQtd 

		CBE->CBE_LOTECT := SD1->D1_LOTECTL 
		CBE->CBE_DTVLD 	:= _dValid
		//CBE->CBE_SDOC	:= 

		CBE->(MSUNLOCK())

		dbCloseArea("CBE")

		///AJUSTANDO ITEM DOCUMENTO - CONFERENCIA
		dbSelectArea("SD1")
		RECLOCK("SD1",.F.)
		SD1->D1_QTDCONF := SD1->D1_QTDCONF + _nQtd   //_nQtdRec 
		SD1->(MSUNLOCK())


		//desbloqueio Lote - depois de conferido todo item documento 
		//////If (SD1->D1_QTDCONF == SD1->D1_QUANT)   
		_aZZE := {ZZE->ZZE_COD,ZZE->ZZE_LOCAL,ZZE->ZZE_LOTECT,_nQtd,ZZE->ZZE_ITEM,;		
		ZZE->ZZE_DOC,ZZE->ZZE_SERIE,ZZE->ZZE_FORNEC,ZZE->ZZE_LOJA }
		_cDodSDD	:= u_ZZGLOTE( .F. , _cSSDZZE , _aZZE )
		//////EndIf



		//F1_STATCON = STATUS CONFERENCIA  1 = CONFERIDO | 3 = EM CONFERENCIA
		/*
		_cQuery	:= " SELECT SD1.D1_DOC,SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA " + chr(13)
		_cQuery	+= " FROM "+RetSqlName("SD1")+" SD1  WITH (NOLOCK) " + chr(13)
		_cQuery	+= " WHERE SD1.D1_DOC = '" + SD1->D1_DOC + "' AND SD1.D1_SERIE = '" + SD1->D1_SERIE + "' AND SD1.D1_FORNECE = '" + SD1->D1_FORNECE + "' " + chr(13)
		_cQuery	+= " AND SD1.D1_LOJA = '" + SD1->D1_LOJA + "' AND SD1.D1_QTDCONF < SD1.D1_QUANT AND SD1.D_E_L_E_T_ = '' "+ chr(13)  //SD1.D1_ETQPROD = 'S'
		*/ 

		_cQuery	:= " SELECT ZZE.ZZE_DOC,ZZE.ZZE_SERIE, ZZE.ZZE_FORNEC, ZZE.ZZE_LOJA " + chr(13)
		_cQuery	+= " FROM "+RetSqlName("ZZE")+" ZZE WITH (NOLOCK) " + chr(13)
		_cQuery	+= " WHERE ZZE.ZZE_DOC = '" + SD1->D1_DOC + "' AND ZZE.ZZE_SERIE = '" + SD1->D1_SERIE + "' AND ZZE.ZZE_FORNEC = '" + SD1->D1_FORNECE + "' " + chr(13)
		_cQuery	+= " AND ZZE.ZZE_LOJA = '" + SD1->D1_LOJA + "' AND ZZE.ZZE_QTDLID < ZZE.ZZE_QTDNF AND ZZE.D_E_L_E_T_ = '' "+ chr(13)

		If (Select("TZZE") <> 0)
			TZZE->(dbCloseArea())
		Endif

		TcQuery _cQuery Alias "TZZE" New

		_cConf := "1"
		DbSelectArea("TZZE")	
		If (!TZZE->(Eof()) ) 
			_cConf := "3"
		Else
			_cConf := "1"
		EndIf

		dbSelectArea("SF1")
		dbSetOrder(1)
		dbSeek(xFilial("SF1") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA )
		If (Found() .and. SF1->F1_STATCON <> _cConf )
			RECLOCK("SF1",.F.)
			SF1->F1_STATCON := _cConf 
			//SF1->F1_QTDCONF += _nQtd 
			SF1->(MSUNLOCK())
		EndIf

		dbCloseArea("TZZE")
		dbCloseArea("SD1")

	EndIf

	RestArea(_aARea)


Return()


/*/{Protheus.doc} Monitor
//Monitor do recebimento
@author solutio
@since 25/10/2018
@version 1.0
@type function
/*/
Static Function Monitor()

	Local aArea			:= GetArea()

	If ( ! ( Empty(cNfiscal) .and. Empty(cSerie) .and. Empty(cFornecedo) .and. Empty(cLoja) .and. Empty(NomeFor)  ) ) //(PEGANF(cNF))
		//Chama a rotina filtrada com os logs
		LjMsgRun(OemToAnsi("Aguarde, montando telas de Monitoramento..."),,{|| DesenhaTela(),CLR_HRED})
	Else
		MsgAlert("Documento não selecionado !","# Documento")
	EndIf


	RestArea(aArea)

Return()


/*/{Protheus.doc} DesenhaTela
//Montando a tela de monitoramento
@author Celso Rene
@since 25/10/2018
@version 1.0
@type function
/*/
Static Function DesenhaTela()

	Local aArea		:= GetArea()
	Local nLoop		:= 0
	Local nPosPadrao	:= 1
	Local aSize		:= MsAdvSize()
	Local cTitDialog	:= "Recimentos Documento: " + cnfiscal
	Local nOpcA		:= 0
	Local _aBotao		:= {}
	Local oDlgVis, oFldDados

	//botoes de legenda
	Local oBtnLZZE		:= Nil

	//botoes de pesquisa nos itens das getdados
	Local oPesqZZE		:= Nil

	//variaveis da aba ordens de servico
	Private aColsZZE 	:= {}
	Private oGDZZE		:= Nil
	Private aHeadZZE	:= {}
	Private _aBotao		:= {} //botoes EnchoiceBar

	//cria aHeader e preencha aCols
	DadosZZE()

	//SetKey( VK_F11, { || MsgAlert("teste") } )

	//monta tela principal
	oDlgVis 	:= 	MSDIALOG():New(aSize[2],aSize[1],aSize[6]-50,aSize[5]-50,cTitDialog,,,,,,,,,.T.)

	oDlgVis:lEscClose := .T.

	Aadd( _aBotao, {"Legenda", {|| LegenZZE()}, "Legenda...", "Lgenda" , {|| .T.}} )  

	oFldDados 	:= 	TFolder():New(030,005,{"Conf. Recebimento"},,oDlgVis,,,,.T.,.T.,(oDlgVis:NCLIENTWIDTH/2)-10,(oDlgVis:NCLIENTHEIGHT/2)-30)

	//getdados com imagens
	oGDZZE 		:= MsNewGetDados():New(000,000,(oFldDados:aDialogs[1]:nClientHeight/2)-20,oFldDados:aDialogs[1]:nClientWidth/2,/*GD_INSERT+GD_UPDATE+GD_DELETE*/0,,,,,,9999,,,,oFldDados:aDialogs[1],@aHeadZZE,@aColsZZE)

	ACTIVATE MSDIALOG oDlgVis CENTERED ON INIT EnchoiceBar(oDlgVis,{||nOpcA:=1,oDlgVis:End()},{||nOpcA:=0,oDlgVis:End()},,_aBotao)
	//ACTIVATE MSDIALOG oDlgVis CENTERED 

	//SetKey( VK_F11, Nil )

	//caso o usuario clique no OK
	If nOpcA==1

		//processamento posterior a confirmacao da tela

	Endif


	RestArea(aArea)

Return( .T. )


/*/{Protheus.doc} LegenZZE
Legendas - Tela # Recebimento
@author Celso Rene
@since 30/10/2018
@version 1.0
@type function
/*/
Static Function LegenZZE()

	BrwLegenda("Legendas - # Recebimentos","Legenda",{{"BR_VERDE"    ,"Recebido"},;
	{"BR_PRETO"    ,"Não Recebido"},;
	{"BR_AMARELO"  ,"Parcialmente Recebido"}})
	//criar nova legendas, etiquetas exedidas...

Return()


/*/{Protheus.doc} DadosZZE
//Listando dados para a tela de monitoramento
@author Celso Rene
@since 25/10/2018
@version 1.0
@type function
/*/
Static Function DadosZZE()

	Local aArea		:= GetArea()

	//Leds utilizados para as legendas das rotinas
	Local oGreen   	:= LoadBitmap( GetResources(), "BR_VERDE")
	Local oRed    	:= LoadBitmap( GetResources(), "BR_VERMELHO")
	Local oYellow	:= LoadBitmap( GetResources(), "BR_AMARELO")
	Local oBlack	:= LoadBitmap( GetResources(), "BR_PRETO")


	//Monta o aHeader
	Aadd(aHeadZZE,{"OK",;
	"COR",;
	"@BMP",;
	1,;
	0,;
	.T.,;
	"",;
	"",;
	"",;
	"R",;
	"",;
	"",;
	.F.,;
	"V",;
	"",;
	"",;
	"",;
	""})

	dbSelectArea("SX3")
	SX3->( dbSetOrder(1) )
	SX3->( dbSeek("ZZE") )
	While SX3->( !Eof()) .And. SX3->X3_ARQUIVO $ "ZZE"
		If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL
			Aadd(aHeadZZE,{	AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_F3,;
			SX3->X3_CONTEXT,;
			SX3->X3_CBOX,;
			SX3->X3_RELACAO,;
			SX3->X3_WHEN,;
			"V",;
			SX3->X3_VLDUSER,;
			SX3->X3_PICTVAR,;
			SX3->X3_OBRIGAT})
		Endif
		SX3->(dbSkip())
	EndDo

	dbSelectArea("ZZE")
	dbSetOrder(1)
	dbGoTop()
	DBSEEK(XFILIAL("ZZE")+Padr( CNFISCAL , TamSx3("ZZE_DOC")[1] )+CSERIE+CFORNECEDO+CLOJA)	
	If ( Found() ) //!ZZE->(EOF())//Verifica se a consulta retornou algum resultado

		//limpa aCols
		aColsZZE	:= {}

		Do While !EOF() .and. (ZZE->ZZE_DOC == Padr( CNFISCAL , TamSx3("ZZE_DOC")[1] ) .and. ZZE->ZZE_SERIE == CSERIE .and. ZZE->ZZE_FORNEC == CFORNECEDO .and. ZZE->ZZE_LOJA == CLOJA  ) 

			//Cria nova posicao no aCols
			aAdd(aColsZZE,Array(Len(aHeadZZE)+1))

			//Começamos o nLoop a partir do dois por causa da coluna de legenda        
			For nLoop	:= 2 to Len(aHeadZZE)

				If aHeadZZE[nLoop][10] <> "V"//X3_CONTEXT
					aColsZZE[Len(aColsZZE)][nLoop]	:= ZZE->&(aHeadZZE[nLoop][2])
				EndIf

			Next nLoop

			//Marca a Legenda
			If (ZZE->ZZE_QTDLID == ZZE->ZZE_QTDNF )
				aColsZZE[Len(aColsZZE)][1]	:= oGreen
			ElseIf (ZZE->ZZE_QTDLID < ZZE->ZZE_QTDNF .and. ZZE->ZZE_QTDLID > 0  )
				aColsZZE[Len(aColsZZE)][1]	:= oYellow
			ElseIf (ZZE->ZZE_QTDLID == 0)
				aColsZZE[Len(aColsZZE)][1]	:= oBlack
			EndIf

			aColsZZE[Len(aColsZZE)][Len(aHeadZZE)+1]:=.F.

			dbSelectArea("ZZE")
			ZZE->(dbSkip())

		EndDo

	Else

		aColsZZE	:= {}

		aAdd(aColsZZE,Array(Len(aHeadZZE)+1))
		aColsZZE[Len(aColsZZE)][Len(aHeadZZE)+1] := .F.

	Endif


	RestArea(aArea)


Return( .T. )


/*/{Protheus.doc} GeraComp
//Relatorio em tela para apresentar divergencias na conferencia - recebimento
@author Celso Rene
@since 28/10/2018
@version 1.0
@return ${return}, ${return_description}
@param CNFISCAL, , descricao
@param CSERIE, , descricao
@param CFORNECEDO, , descricao
@param CLOJA, , descricao
@type function
/*/
STATIC FUNCTION GeraComp(CNFISCAL,CSERIE,CFORNECEDO,CLOJA)

	Local cQuery:=''
	Local aText:={}
	Local cMemo1	 := ""
	Local oMemo1

	// Variaveis Private da Funcao
	Private _oDlg				// Dialog Principal
	// Variaveis que definem a Acao do Formulario
	Private VISUAL := .F.                        
	Private INCLUI := .F.                        
	Private ALTERA := .F.                        
	Private DELETA := .F.  


	If ( ! ( Empty(cNfiscal) .and. Empty(cSerie) .and. Empty(cFornecedo) .and. Empty(cLoja) .and. Empty(NomeFor)  ) )  //(PEGANF(cNF))                      

		CQUERY := " SELECT * FROM "+RetSqlName("ZZE")+" " + chr(13)
		CQUERY += "  WHERE ZZE_FILIAL='"+XFILIAL("ZZE")+"' AND ZZE_DOC ='"+CNFISCAL+"' "  + chr(13)
		CQUERY += "  AND ZZE_SERIE = '"+CSERIE+"' AND ZZE_FORNEC = '" + CFORNECEDO + "' AND ZZE_LOJA = '" + CLOJA + "' "  + chr(13)
		CQUERY += "  AND ZZE_QTDNF <> ZZE_QTDLID AND D_E_L_E_T_ = '' "  + chr(13)
		CQUERY += "  ORDER BY ZZE_FILIAL + ZZE_DOC + ZZE_SERIE + ZZE_FORNEC + ZZE_LOJA + ZZE_ITEM "

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'GCP', .T., .T.)

		DBSelectArea("GCP")
		DBGotop()

		DO WHILE !EOF()

			cDescPro := POSICIONE("SB1",1,XFILIAL("SB1")+GCP->ZZE_COD,"B1_DESC")
			///PEGANDO DESCRICAO DA APRESENTACAO//////////////////////////////////
			cCodApre   := GCP->ZZE_COD // POSICIONE("SB1",1,XFILIAL("SB1")+GCP->ZE_COD,"B1_CODAPRE")
			cDesApre   := "" //POSICIONE("LEL",1,XFILIAL("LEL")+cCODAPRE,"LEL_APRESE") 
			/////////////////////////////////////////////////////////////////////

			aaDD(aText,{"Item: "+GCP->ZZE_ITEM + ;
			" - Cod: "+ GCP->ZZE_COD+" - " + Left(CDESCPRO,40) + ;
			" "+CDESAPRE+" - Lote: " +GCP->ZZE_LOTECT+"      - Validade: "+ DtoC(StoD(GCP->ZZE_DTVALI)) + ;
			"      - Qtd NF: " + TRANSFORM(GCP->ZZE_QTDNF, "@R 999,99")   +"      - Recebido: " + TRANSFORM(GCP->ZZE_QTDLID, "@R 999,99")  + "      - SALDO: " + TRANSFORM(GCP->ZZE_QTDNF - GCP->ZZE_QTDLID, "@R 999,99");
			+ CHR(13)+CHR(10)})

			GCP->(DBSKIP())
		ENDDO         


		FOR X:=1 TO LEN(ATEXT)
			cMemo1+=atext[x][1]
		NEXT 

		IF ALLTRIM(CMEMO1)==''
			CMEMO1 := (CHR(13)+CHR(10)+"              Conferência Efetuada com Sucesso!")
		ENDIF


		DBSelectArea("GCP")
		DBCloseArea("GCP")


		DEFINE MSDIALOG _oDlg TITLE "Entrada de Materiais - Diferenças" FROM C(178),C(181) TO C(600),C(954) PIXEL
		// Cria Componentes Padroes do Sistema

		@ C(000),C(000) GET oMemo1 Var cMemo1 MEMO Size C(383),C(220) PIXEL OF _oDlg
		@ C(190),C(169) Button "Sair" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())

		ACTIVATE MSDIALOG _oDlg CENTERED 

	EndIf

RETURN( .T. )                   


/*/{Protheus.doc} InfManual
//Informação manual da etiqueta do fornecedor - Recebimento
@author C|elso Rene
@since 02/11/2018
@version 1.0
@type function
/*/
Static Function InfManual()

	Private oDManual
	Private oButton1
	Private oButton2
	Private oGet1
	Private cGet1 := Space(TamSx3("D1_COD")[1])
	Private oGet2
	Private cGet2 := Space(TamSx3("D1_LOTECTL")[1])
	Private oGet3
	Private oGet4
	Private cGet4 := Space(TamSx3("B1_DESC")[1])
	Private oGet5
	Private cGet5 := Space(TamSx3("D1_LOTECTL")[1])
	Private aGet5 := {}
	Private oGet6
	//Private cGet6 := "Define variable value"
	Private dGet3 := dDataBase
	Private oSay1
	Private oSay2
	Private oSay3


	DEFINE MSDIALOG oDManual TITLE "Dados manuais do item - recebimento" FROM 000, 000  TO 200, 450 COLORS 0, 16777215 PIXEL

	@ 015, 005 SAY oSay1 PROMPT "Produto: " SIZE 025, 007 OF oDManual COLORS 0, 16777215 PIXEL
	@ 011, 040 MSGET oGet1 VAR cGet1 VALID(manprd(cGet1))  SIZE 050, 010 OF oDManual COLORS 0, 16777215 F3 "SB1" PIXEL
	@ 037, 005 SAY oSay2 PROMPT "Lote: " SIZE 025, 007 OF oDManual COLORS 0, 16777215 PIXEL
	@ 032, 040 MSGET oGet2 VAR cGet2 SIZE 050, 010 OF oDManual COLORS 0, 16777215 PIXEL
	@ 056, 005 SAY oSay3 PROMPT "Vald. Lote:" SIZE 031, 007 OF oDManual COLORS 0, 16777215 PIXEL
	@ 052, 040 MSGET oGet3 VAR dGet3 SIZE 050, 010 OF oDManual COLORS 0, 16777215 PIXEL

	@ 011, 106 MSGET oGet4 VAR cGet4 SIZE 110, 010 OF oDManual COLORS 0, 16777215 READONLY PIXEL

	//@ 032, 106 MSGET oGet5 VAR cGet5 SIZE 050, 010 OF oDManual COLORS 0, 16777215 PIXEL
	@ 032, 106 ComboBox cGet5 Items aGet5 SIZE 110, 010 OF oDManual COLORS 0, 16777215 PIXEL

	@ 056, 106 SAY oSay4 PROMPT "Qtd:" SIZE 013, 007 OF oDManual COLORS 0, 16777215 PIXEL
	@ 052, 127 MSGET oGet6 VAR cqtd PICTURE "@E 9,999.99" VALID(VEQTD(cqtd))  SIZE 035, 010 OF oDManual COLORS 0, 16777215 PIXEL 


	@ 082, 060 BUTTON oButton1 PROMPT "Gerar" SIZE 037, 012 OF oDManual  ACTION( VldInfMan(cGet1,cGet2,dGet3,cqtd) )   PIXEL
	@ 082, 140 BUTTON oButton2 PROMPT "Sair" SIZE 037, 012 OF oDManual ACTION( oDManual:End() ) PIXEL

	ACTIVATE MSDIALOG oDManual CENTERED


Return()


/*/{Protheus.doc} ManPrd
//Gatilho Produto
@author Celso Rene
@since 06/11/2018
@version 1.0
@return ${return}, ${return_description}
@param _cProd, , descricao
@type function
/*/
Static Function ManPrd(_cProd)

	Local _aGetMan	:= GetArea()

	///nao valida caso informacao do produto não seja informada!
	If Empty(_cProd)
		Return()
	EndIf

	Icodigo	:= _cProd

	dBSelectArea("ZZE")
	dBSetOrder(2)

	aGet5 :={}

	If ( DBSEEK(XFILIAL("ZZE")+Padr( CNFISCAL , TamSx3("F1_DOC")[1] )+CSERIE+CFORNECEDO+CLOJA+_cProd) )
	
		DO WHILE !EOF() .AND. CNFISCAL+CSERIE+CFORNECEDO+CLOJA+_cProd==;
		ZZE->ZZE_DOC+ZZE->ZZE_SERIE+ZZE->ZZE_FORNEC+ZZE->ZZE_LOJA+ZZE->ZZE_COD

			If ( ALLTRIM(ZZE->ZZE_COD) == ALLTRIM(_cProd) )                     
				CLOTE    := ZZE->ZZE_LOTECT
				CVALID   := ZZE->ZZE_DTVALI
				cLoteVal := CLOTE+" - " + DTOC(CVALID)
				AADD(aGet5,CLOTE+" - " + DTOC(CVALID))
			EndIf

			ZZE->(DBSKIP())

		ENDDO  

		cGet4 := Posicione("SB1",1,xFilial("SB1") + _cProd , "B1_DESC")   
		oGet4:Refresh()
		@ 032, 106 ComboBox cGet5 Items aGet5 SIZE 110, 010 OF oDManual COLORS 0, 16777215 PIXEL
		oDManual:Refresh()
		oGet2:SetFocus()

	Else

		//MsgAlert("O Item:  "+_cProd+"  no Documento: " + CNFISCAL +" não encontrado !","# Recebimento")
		MsgAlert("O Item:  "+_cProd+ " não encontrado no Documento: " + CNFISCAL + " !","# Recebimento")
		cGet4 := Space(TamSx3("B1_DESC")[1])
		cGet1 := Space(TamSx3("D1_COD")[1])
		//		cGet1:Refresh()
		oGet4:Refresh()
		//@ 011, 040 MSGET oGet1 VAR cGet1 VALID(manprd(cGet1))  SIZE 050, 010 OF oDManual COLORS 0, 16777215 F3 "SB1" PIXEL
		//@ 011, 106 MSGET oGet4 VAR cGet4 SIZE 110, 010 OF oDManual COLORS 0, 16777215 READONLY PIXEL
		oDManual:Refresh()
		oGet1:SetFocus()

		Icodigo	:= Space(TamSx3("D1_COD")[1])

	EndIf


	RestArea(_aGetMan)

Return()


/*/{Protheus.doc} _LayoutFor
/Busca e monta tela para leitura etiqueta -layout fornecedor - ZZF
@author solutio
@since 06/11/2018
@version 1.0
@type function
/*/
Static Function _LayoutFor(_cLayFor, _cLayLoja)

	Local _lRetForn := .F.	


	dbSelectArea("ZZF")
	dbSetOrder(1) //ZZF_FILIAL + ZZF_FORNEC + ZZF_LOJA
	dbSeek(xFilial("ZZF") + _cLayFor + _cLayLoja)
	If ( Found() )

		_lRetForn := .T.

		_nlayF1 := ZZF->ZZF_P1DE + ZZF->ZZF_P1ATE + ZZF->ZZF_L1DE + ZZF->ZZF_L1ATE + ZZF->ZZF_V1DE + ZZF->ZZF_V1ATE
		_nlayF2 := ZZF->ZZF_P2DE + ZZF->ZZF_P2ATE + ZZF->ZZF_L2DE + ZZF->ZZF_L2ATE + ZZF->ZZF_V2DE + ZZF->ZZF_V2ATE   			

		//layout fornecedor 2 codigos de barras para leitura
		If (_nlayF2 > 0 ) 

			@ C(039),C(009) Say "Cod:" Size C(013),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
			@ C(038),C(027) MsGet oCodBar Var cCodBar  Size C(123),C(009) COLOR CLR_BLACK PIXEL OF _oDlg

			//quantidade a ser selecionada para o recebimento
			@ C(039),C(160) Say "Qtd:" Size C(012),C(008)  COLOR CLR_BLACK PIXEL OF _oDlg
			@ C(038),C(180) MsGet oqtd Var cqtd PICTURE "@E 9,999.99" VALID(VEQTD(CQTD)) Size C(035),C(009) COLOR CLR_BLACK PIXEL OF _oDlg

			@ C(060),C(009) Say "Cod 2:" Size C(013),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
			@ C(061),C(027) MsGet oCodBar2 Var cCodBar2  /*VALID(PEGACOD2(CCODBAR))*/  VALID(PEGACOD(cCodBar,cCodBar2)) Size C(123),C(009) COLOR CLR_BLACK PIXEL OF _oDlg

			//desabilitando botao - Inf. Manuais
			//If !(Empty(oButMan))
			//@ C(130),C(115) Button oButMan Prompt "Inform. Manual" Size C(040),C(012) PIXEL OF _oDlg
			//oButMan:Disable()
			//EndIf 

			//Recebimneto informando valores manuais
			//Habilita botao - InfManual()
			@ C(130),C(115) Button oButMan Prompt "Inform. Manual" Size C(040),C(012) PIXEL OF _oDlg Action(InfManual() )
			oButMan:Enable()

			oCodBar:Enable()
			oCodBar:Refresh()
			oCodBar2:Enable()
			oCodBar2:Refresh()
			oqtd:Enable()
			oqtd:Refresh()


		Else

			//@ C(060),C(009) Say "" Size C(013),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
			If !(Empty(oCodBar2))
				oCodBar2:Disable()
				oCodBar2:Refresh()
			EndIf

			@ C(039),C(009) Say "Cod:" Size C(013),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
			@ C(038),C(027) MsGet oCodBar Var cCodBar  VALID(PEGACOD(CCODBAR)) Size C(123),C(009) COLOR CLR_BLACK PIXEL OF _oDlg

			//quantidade a ser selecionada para o recebimento
			@ C(039),C(160) Say "Qtd:" Size C(012),C(008)  COLOR CLR_BLACK PIXEL OF _oDlg
			@ C(038),C(180) MsGet oqtd Var cqtd PICTURE "@E 9,999.99" VALID(VEQTD(CQTD)) Size C(035),C(009) COLOR CLR_BLACK PIXEL OF _oDlg

			//desabilitando botao - Inf. Manuais
			//If !(Empty(oButMan))
			//@ C(130),C(115) Button oButMan Prompt "Inform. Manual" Size C(040),C(012) PIXEL OF _oDlg
			//oButMan:Disable()
			//EndIf 

			//Recebimneto informando valores manuais
			//Habilita botao - InfManual()
			@ C(130),C(115) Button oButMan Prompt "Inform. Manual" Size C(040),C(012) PIXEL OF _oDlg Action(InfManual() )
			oButMan:Enable()

			oCodBar:Enable()
			oCodBar:Refresh()
			oqtd:Enable()
			oqtd:Refresh()

		EndIf

		oCodBar:SetFocus() 
		_oDlg:Refresh()

	Else	

		//desabilitando gets para informacao etiquetas
		If !(Empty(oCodBar))
			oCodBar:Disable()
			oCodBar:Refresh()
		EndIf
		If !(Empty(oCodBar2))
			oCodBar2:Disable()
			oCodBar2:Refresh()
		EndIf
		If !(Empty(oqtd))
			oqtd:Disable()
			oqtd:Refresh()
		EndIf


		//Recebimneto informando valores manuais
		//Habilita botao - InfManual()
		@ C(130),C(115) Button oButMan Prompt "Inform. Manual" Size C(040),C(012) PIXEL OF _oDlg Action(InfManual() )
		oButMan:Enable()


	EndIf


	dbCloseArea("ZZF")


Return(_lRetForn)


/*/{Protheus.doc} BusCodFor
//Busca produto amarrado ao fornecedor - SA5
@author Celso Rene
@since 06/11/2018
@version 1.0
@type function
/*/
Static Function BusCodFor( _cFor,_cloja,_cCod,_ltipo)

	Local _cReturn := ""

	dbSelectArea("SA5")
	If (_ltipo == "1") //codigo produto fornecedor: A5_CODPRF
		dbSetOrder(14)
	Else
		dbSetOrder(8) //codigo de barras do produto fornecedor: A5_CODBAR
	EndIf

	dbSeek(xFilial("SA5") + _cFor + _cloja +  _cCod )
	If ( Found() )
		_cReturn := SA5->A5_PRODUTO
	EndIf


Return(_cReturn)


////testando
/*/{Protheus.doc} VldInfMan
//Validando informacoes da tala Manual de Inf. conferencias
@author solutio
@since 08/11/2018
@version 1.0
@type function
/*/
Static Function VldInfMan(_cMProd,_cMLote,_dMValid,_nMQtd)

	Local _lMRet 	:= .T.
	Local _aMArea	:= getArea()                         

	cProduto		:= _cMProd
	Icodigo			:= _cMProd

	//posicionando tabela de controle
	DBSelectArea("ZZE")
	DBSetOrder(3) //doc+serie+fornecedor+loja+codigo+lotectl+dtavalid
	/*_cVenc := DtoS(_dMValid) 
	If (Left( _cVenc ,2) == "19")
		_cVenc := "20"+ Right(_cVenc,6) 
	EndIf*/

	_cVenc := DTOS( IF( YEAR( _dMValid ) < 2000, YearSum( _dMValid, 100 ), _dMValid ) ) 
	
	If ( DBSEEK(XFILIAL("ZZE")+ Padr( CNFISCAL , TamSx3("F1_DOC")[1] ) + CSERIE + CFORNECEDO + CLOJA + Padr( _cMProd , TamSx3("B1_COD")[1] ) + Padr( _cMLote , TamSx3("D1_LOTECTL")[1] ) + _cVenc ) )  //DtoS(_dMValid)

		//Gerando conferencia e etiquetas
		MsgRun("Gerando Recebimento...","# Conferência",{|| CursorWait(), impetq(CNFISCAL,CSERIE,CFORNECEDO,CLOJA,_cMProd,_cMLote,DtoS(_dMValid),.T.) , CursorArrow()})

	Else

		MsgAlert("O Item:  "+_cMProd+" e Lote: " + _cMLote + " - Validade: " + DtoC(_dMValid) + " não encontrado no Documento: " + CNFISCAL + " !","# Recebimento")
		cGet4 := Space(TamSx3("B1_DESC")[1])
		cGet1 := Space(TamSx3("D1_COD")[1])
		cGet2 := Space(TamSx3("D1_LOTECTL")[1])
		dGet3 := dDataBase
		cGet5 := Space(20)
		aGet5 := {}
		@ 032, 106 ComboBox cGet5 Items aGet5 SIZE 110, 010 OF oDManual COLORS 0, 16777215 PIXEL
		cqtd:= 1
		oGet1:Refresh()		
		oGet2:Refresh()		
		oGet3:Refresh()
		oGet4:Refresh()
		oGet6:Refresh()
		oDManual:Refresh()
		oGet1:SetFocus()

		Icodigo	:= Space(TamSx3("D1_COD")[1])

	EndIf


	RestArea(_aMArea)	


Return(_lMRet)



/*/{Protheus.doc} BuscaZZE
//Funcao para posicionar ZZE com itens Produto + LoteCTL iguais
@author Celso Rene
@since 10/11/2018
@version 1.0
@type function
/*/
Static Function BuscaZZE()

	Local _lRetZZE := .F.

	DBSelectArea("ZZE")
	DBSetOrder(3) //doc+serie+fornecedor+loja+codigo+lotectl+dtavalid 

	DBSEEK(XFILIAL("ZZE")+ Padr( CNFISCAL , TamSx3("F1_DOC")[1] ) + CSERIE + CFORNECEDO + CLOJA + Padr( CODIGO , TamSx3("B1_COD")[1] ) + Padr( LOTE , TamSx3("D1_LOTECTL")[1] )+ VALID1)
	//DBSEEK(XFILIAL("ZZE")+ Padr( CNFISCAL , TamSx3("F1_DOC")[1] ) + CSERIE + CFORNECEDO + CLOJA + Padr( CODIGO , TamSx3("B1_COD")[1] ) + Padr( LOTE , TamSx3("ZZE_LOTECTL")[1] ) ) //+ VALID1  
	If ( Found() )
		While !EOF() .AND. ZZE->ZZE_FILIAL + ZZE->ZZE_DOC + ZZE->ZZE_SERIE + ZZE->ZZE_FORNEC + ZZE->ZZE_LOJA + ZZE->ZZE_COD + ZZE->ZZE_LOTECT + DTOS(ZZE->ZZE_DTVALI)                                                                             == ;
		xFilial("ZZE") + Padr( CNFISCAL , TamSx3("F1_DOC")[1] ) + CSERIE + CFORNECEDO + CLOJA + Padr( CODIGO , TamSx3("B1_COD")[1] ) + Padr( LOTE , TamSx3("D1_LOTECTL")[1]   ) + VALID1 // + VALID1

			//registro posicionado e com saldo a receber...
			If  ((ZZE->ZZE_QTDLID+QTD) <= ZZE->ZZE_QTDNF )
				_lRetZZE := .T.
				Exit
			EndIf

			ZZE->(dBSkip())    

		EndDo

		If (_lRetZZE == .F.) //se nao encontrou nenhum registro a conferir - posiciona no primeiro da ZZE
			DBSelectArea("ZZE")
			DBSetOrder(3)
			(DBSEEK(XFILIAL("ZZE")+ Padr( CNFISCAL , TamSx3("F1_DOC")[1] ) + CSERIE + CFORNECEDO + CLOJA + Padr( CODIGO , TamSx3("B1_COD")[1] ) + Padr( LOTE , TamSx3("D1_LOTECTL")[1] )) ) //+ VALID1
			If ( Found() )
				_lRetZZE := .T.
			EndIf
		EndIf

	Else
		_lRetZZE := .F.
	EndIf   


Return(_lRetZZE)
