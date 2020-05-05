#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "Topconn.ch"
#include "common.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TBICONN.CH"   
#INCLUDE "TBICODE.CH"
#Include "RPTDEF.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "COLORS.CH"


/*/{Protheus.doc} xDanfe
//Impressao Danfe
@author Celso Rene
@since 19/03/2019
@version 1.0
@type function
/*/
User Function xAutoDanfe( _cDoc, _cSerie  , _cImpres)

	Local _cQuery	:= ""
	Local _lRet		:= .F.
	Local _cIdent	:= ""

	Local _nMens	:= 0

	Default _cDoc	:= "000146" // "000647791"
	Default _cSerie	:= "99" 
	Default _cImpres:= "estoque"

	Private _xImp	:= _cImpres 
	Private _aAreaDan := GetArea()

	Do Case
		Case (cEmpAnt == "01") 
		_cIdent := "000002" //IDENTIDADE EMPRESA 01
		Case (cEmpAnt == "06")
		_cIdent := "000007"	//IDENTIDADE EMPRESA 06
	EndCase

	//se diferente de empresa 01 e 06 sai da rotina
	If Empty(_cIdent)
		Return()
	EndIf
	
	_cQuery := " SELECT TOP 1 * FROM " + RetSqlName("SF2")+ " SF2 " + chr(13)
	_cQuery += " INNER JOIN DBTSS..SPED050 SPED ON SPED.D_E_L_E_T_= '' AND SPED.ID_ENT = '" + _cIdent +"' AND SPED.STATUS = '6' AND SPED.DATE_NFE >= '20190501' " + chr(13)
	_cQuery += " WHERE SPED.NFE_ID = SF2.F2_SERIE + LEFT(SF2.F2_DOC,9) AND SF2.D_E_L_E_T_='' " + chr(13) 
	_cQuery += "  AND SF2.F2_DOC = '" + _cDoc + "' AND SF2.F2_SERIE = '"  + _cSerie + "' "  

	If (Select("TMP") <> 0)
		TMP->(dbCloseArea())
	Endif

	TcQuery _cQuery Alias "TMP" New

	DbSelectArea("TMP")	
	If (!TMP->(Eof()) )

		Do While ( !TMP->(EOF()) )

			dbSelectArea("SF2")
			dbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO                                                                                                  
			dbSeek(xFilial("SF2") + TMP->F2_DOC + TMP->F2_SERIE + TMP->F2_CLIENTE + TMP->F2_LOJA + TMP->F2_FORMUL)  

			//preparando as variaveis para impressao do Danfe
			xSpedDanfe()

			dbSelectArea("TMP")
			TMP->(dBSkip())

		EndDo

	EndIf

	dbCloseArea("TMP") 
	RestArea(_aAreaDan)

Return()


/*/{Protheus.doc} xSpedDanfe
//Funcao adaptada padrao para preparacao dos objetos para
//impressao do danfe.
@author Celso Rene
@since 19/03/2019
@version 1.0
@type function
/*/

Static Function xSpedDanfe()

	Local aArea := getArea()

	Local cIdEnt 	:= ""
	Local aIndArq	:= {}
	Local nHRes  	:= 0
	Local nVRes  	:= 0
	Local nDevice
	Local cFilePrint:= ""

	Local aDevice  := {}
	Local cSession     := GetPrinterSession()
	Local nRet := 0
	Local lUsaColab	:= UsaColaboracao("1") 
	Local _cPrint	:= ""

	Private oDanfe
	Private oSetup

	If findfunction("U_DANFE_V")
		nRet := U_Danfe_v()
	Elseif findfunction("U_DANFE_VI") // Incluido esta validação pois o cliente informou que não utiliza o DANFEII
		nRet := U_Danfe_vi() // no danfeIII
	EndIf

	AADD(aDevice,"DISCO") // 1
	AADD(aDevice,"SPOOL") // 2
	AADD(aDevice,"EMAIL") // 3
	AADD(aDevice,"EXCEL") // 4
	AADD(aDevice,"HTML" ) // 5
	AADD(aDevice,"PDF"  ) // 6

	cIdEnt := GetIdEnt(lUsaColab) 

	cFilePrint := "DANFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")

	nLocal       	:= 2 //If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
	nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
	cDevice     	:= "PDF" //"SPOOL" //If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL", ) )
	nPrintType      := aScan(aDevice,{|x| x == cDevice })

	dbSelectArea("SF2")

	lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter	

	dbSelectArea("SX6")
	DbSetOrder(1)
	If ( !dBseek("  "+"MV_XDANFIE") )
		RecLock("SX6", .T.)
		SX6->X6_FIL    	:= "  "
		SX6->X6_VAR    	:= "MV_XDANFIE"
		SX6->X6_TIPO   	:= "C"
		SX6->X6_DESCRIC	:= "Impressora XAUTO DANFE ESTOQUE"
		If (cEmpant == "01")
			SX6->X6_CONTEUD	:= "\\192.168.0.5\IMP-Recepcao"
		ElseIf(cEmpant == "06")
			SX6->X6_CONTEUD	:= "\\192.168.2.2\IMP-Estoque"
		EndIf
		MsUnLock()
	EndIf

	dbSelectArea("SX6")
	DbSetOrder(1)
	If ( !dBseek("  "+"MV_XDANFIF") )
		RecLock("SX6", .T.)
		SX6->X6_FIL    	:= "  "
		SX6->X6_VAR    	:= "MV_XDANFIF"
		SX6->X6_TIPO   	:= "C"
		SX6->X6_DESCRIC	:= "Impressora XAUTO DANFE FATURAMENTO"
		If (cEmpant == "01")
			SX6->X6_CONTEUD	:= "\\192.168.0.5\IMP-EricoOffices_Faturamento"
		ElseIf(cEmpant == "06")
			SX6->X6_CONTEUD	:= "\\192.168.2.2\IMP-Faturamento"
		EndIf
		MsUnLock()
	EndIf

	//buscando a impressora selecionada
	_cImp := ""
	If (_xImp == "estoque")
		_cImp := Alltrim(GetMV("MV_XDANFIE"))	
	ElseIf (_xImp == "faturam")
		_cImp := Alltrim(GetMV("MV_XDANFIF"))
	EndIf

	_cTLocal := GetTempPath()

	oDanfe := FWMSPrinter():New(cFilePrint,IMP_PDF,lAdjustToLegacy,/*cPathInServer*/, ;
	.T.,/*lTReport*/,/*oPrintSetup*/,/*cPrinter*/,.F.,/*lPDFAsPNG*/,.F.,.T.)
	oDanfe:cPathPDF := _cTLocal

	// ----------------------------------------------
	// Cria e exibe tela de Setup Customizavel
	// OBS: Utilizar include "FWPrintSetup.ch"
	// ----------------------------------------------
	nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN

	If nOrientation == 1 //oSetup:GetProperty(PD_ORIENTATION) == 1 //retrato
		Conout("#Leef-console# Entradando no danfe - retrato  - xAutoDanfe")
		u_PrtNfeSef(cIdEnt , , ,oDanfe ,oSetup ,cFilePrint ,.F.  )
	Else
		Conout("#Leef-console# Entradando no danfe - Paisagem  - xAutoDanfe")
		u_DANFE_P1(cIdEnt ,, ,oDanfe ,oSetup , ,.F.  )
	EndIf

	restArea(aArea)

Return .T.

/*/{Protheus.doc} IsReady
//Funcionalidade padrao para preparo dos objetos danfe
chamada na funcao xSpedDanfe.
@author Celso Rene
@since 19/03/2019
@version 1.0
@type function
/*/
Static Function IsReady(cURL,nTipo,lHelp,lUsaColab)

	Local nX       := 0
	Local cHelp    := ""
	local cError	:= ""
	Local oWS
	Local lRetorno := .F.
	DEFAULT nTipo := 1
	DEFAULT lHelp := .F.
	DEFAULT lUsaColab := .F.
	
	If !lUsaColab
		If FunName() <> "LOJA701"
			If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
				RecLock("SX6",.T.)
				SX6->X6_FIL     := xFilial( "SX6" )
				SX6->X6_VAR     := "MV_SPEDURL"
				SX6->X6_TIPO    := "C"
				SX6->X6_DESCRIC := "URL SPED NFe"
				MsUnLock()
				PutMV("MV_SPEDURL",cURL)
			EndIf
			SuperGetMv() //Limpa o cache de parametros - nao retirar
			DEFAULT cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
		Else
			If !Empty(cURL) .And. !PutMV("MV_NFCEURL",cURL)
				RecLock("SX6",.T.)
				SX6->X6_FIL     := xFilial( "SX6" )
				SX6->X6_VAR     := "MV_NFCEURL"
				SX6->X6_TIPO    := "C"
				SX6->X6_DESCRIC := "URL de comunicação com TSS"
				MsUnLock()
				PutMV("MV_NFCEURL",cURL)
			EndIf
			SuperGetMv() //Limpa o cache de parametros - nao retirar
			DEFAULT cURL      := PadR(GetNewPar("MV_NFCEURL","http://"),250)	
		EndIf	
		//Verifica se o servidor da Totvs esta no ar	
		if(isConnTSS(@cError))	
			lRetorno := .T.
		Else
			If lHelp
				Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"STR0114"},3)
			EndIf
			lRetorno := .F.
		EndIf
		
		//Verifica se Há Certificado configurado	
		If nTipo <> 1 .And. lRetorno		

			If( isCfgReady(, @cError) )
				lRetorno := .T.
			Else	
				If nTipo == 3
					cHelp := cError

					If lHelp .And. !"003" $ cHelp
						Aviso("SPED",cHelp,{"STR0114"},3)
						lRetorno := .F.

					EndIf		

				Else
					lRetorno := .F.
				EndIf
				
			Endif

		EndIf

		//Verifica Validade do Certificado	
		If nTipo == 2 .And. lRetorno
			isValidCert(, @cError)
		EndIf
	Else
		lRetorno := ColCheckUpd()
		If lHelp .And. !lRetorno .And. !lAuto
			MsgInfo("UPDATE do TOTVS Colaboração 2.0 não aplicado. Desativado o uso do TOTVS Colaboração 2.0")		
		Endif	
	Endif

Return(lRetorno)


/*/{Protheus.doc} GetIdEnt
//Funcionalidade padrao para preparo dos objetos danfe
chamada na funcao xSpedDanfe.
@author Celso Rene
@since 19/03/2019
@version 1.0
@type function
/*/
Static Function GetIdEnt(lUsaColab)

	local cIdEnt := ""
	local cError := ""

	Default lUsaColab := .F.

	If !lUsaColab

		cIdEnt := getCfgEntidade(@cError)

		If(empty(cIdEnt))
			Aviso("SPED", cError, {"STR0114"}, 3)

		Endif	

	Else
		If !( ColCheckUpd() )
			//Aviso("SPED","UPDATE do TOTVS Colaboração 2.0 não aplicado. Desativado o uso do TOTVS Colaboração 2.0",{|"STR0114},3)
		Else
			cIdEnt := "000000"
		Endif	 
	EndIf	

Return(cIdEnt)



/*/{Protheus.doc} xImpress
//Impreesao Danfe gerado automaticamente
@author Celso Rene
@since 14/03/2019
@version 1.0
@type function
/*/
User Function xImpress(_cLocal,_cDoc)

	//u_xImpress("c:\rel\danfe_00000220190314155220.pdf","")

	Local _nRet		:= 0

	_cArquivo := _cLocal + If (Right(_cDoc,3) == "pdf" , _cDoc ,_cDoc + ".pdf"  )

	If File(_cArquivo)	
		//_nRet:= shellExecute("printto", _cArquivo , " /k dir", "C:\", 0 )
		//FERASE(_cArquivo )   //Deletando o arquivo
	EndIf

Return()


	/////outros testes..
	*---------------------------------*
User Function PrintNF(cNF,cSer)
	*---------------------------------*
	Local nFlags 		:= 0
	Local cFilePrint 	:= "0_NFS"+cNF

	nFlags := PD_DISABLEPREVIEW + PD_DISABLEMARGIN//+PD_ISTOTVSPRINTER+PD_DISABLEPAPERSIZE

	DBSelectArea("SM0")
	SM0->(DBGoTop())
	SM0->(DBSeek(cEmpAnt + cFilAnt))
	cIdEnt := StaticCall(SPEDNFE,GetIdEnt) 

	cPerg := "NFSIGW"
	cPerg :=  PADR(cPerg,Len(SX1->X1_GRUPO))

	Private mv_par01 := "000121" //de nf 
	Private mv_par02 := "000121" //ate nf
	Private mv_par03 := "99" //serie
	Private mv_par04 := 2 //tipo: 2-saida/1-entrada
	Private mv_par05 := 2 //imprime no verso

	oSetup:=FWPrintSetup():New(nFlags, "DANFE")
	oSetup:SetPropert(PD_PRINTTYPE , 6)//ou 1 verificar
	oSetup:SetPropert(PD_ORIENTATION , 1)
	oSetup:SetPropert(PD_DESTINATION , 1)
	oSetup:SetPropert(PD_MARGIN , {60,60,60,60})
	oSetup:SetPropert(PD_PAPERSIZE , 2)
	oSetup:aOptions[PD_VALUETYPE] := "c:\temp\"

	oDanfe := FWMSPrinter():New(cFilePrint,IMP_PDF,.F.,"c:\temp\",.T., ,oSetup, , , .F., ,.T. ,1)

	U_PrtNfeSef(cIdEnt,,,oDanfe,oSetup,cFilePrint,.F.)

Return()
