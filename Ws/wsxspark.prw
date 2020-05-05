#include 'protheus.ch'
#include 'parmtype.ch'
#include "tbiconn.ch"

user function wsproduto()
	Local lRet    := Nil
	Local cMsg    := ""
	Local oWsdl   := Nil
	Local cMsgRet := ""

	MSAGUARDE({|| TransfSB1() },"Transferindo via ManageItemDataWSBean")
Return

/*/{Protheus.doc} TransfSB1
Funcao para enviar os produtos do Protheus para o sistema SPARK WMS
por meio do webservice ManageItemDataWSBean no metodo updateItemData

@param
@return

@author Carlos Galimberti
@since 02/09/2019
@version P12.1.17
/*/

Static Function TransfSB1()
	Local cAliasQry := "QSB1"
	Local cQuery
	Local cRotina   := FunName()
	Local   cURLSpark   := nil
	Local   cLgnSpark   := nil
	Local   cPswSpark   := nil

	cURLSpark   := SuperGetMV("MV_URLSPAR",.F.,"http://100.27.32.87:8080")
	cLgnSpark   := SuperGetMV("MV_LGNSPARK",.F.,"admin")
	cPswSpark   := SuperGetMV("MV_PSWSPARK",.F.,"spk123#")

	cQuery :=  "SELECT * FROM "  + RetSQLName("SB1") + " SB1, " + RetSQLName("SBM") + " SBM WHERE SB1.D_E_L_E_T_ = '' AND SBM.D_E_L_E_T_ = '' "
	cQuery +=  "   AND B1_GRUPO = BM_GRUPO "
	cQuery +=  "   AND B1_MSBLQL <> '1' AND BM_MSBLQL <> '1' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

	DBSelectArea("QSB1")
	DBGotop()

	While !eof()

		oWsdl := TWsdlManager():New()
		oWsdl:nTimeout       := 120
		oWsdl:lverbose       := .t.
		oWsdl:SetAuthentication(cLgnSpark,cPswSpark)
		xRet := oWsdl:ParseURL(cURLSpark+"/webservice/ManageItemDataWSBean?wsdl")

		if xRet == .F.
			conout("Erro ParseURL: " + oWsdl:cError)
			Return
		endif

		// Define a operação
		lRet := oWsdl:SetOperation("updateItemData")
		If lRet == .F.
			conout("Erro SetOperation: " + oWsdl:cError)
			return
		EndIf
		conout( oWsdl:cCurrentOperation )

		// Lista os tipos simples da mensagem de input envolvida na operação
		/* aSimple := oWsdl:SimpleInput()
		varinfo( "", aSimple )
		*/

		cMsg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:man="http://manage_itemdata.ws.inventory.los.linogistix.de/">'
		cMsg += '<soapenv:Header/>'
		cMsg += '<soapenv:Body>'
		cMsg += '  <man:updateItemData>'
		cMsg += '       <!--Optional:-->'
		cMsg += '      <arg0>'
		cMsg += '          <clientNumber>Jomhedica</clientNumber>'
		cMsg += '         <name>'+trim(QSB1->B1_DESC)+'</name>'
		cMsg += '          <number>'+ trim(QSB1->B1_COD)+'</number>'
		cMsg += '         <!--Optional:-->'
		cMsg += '          <description>'+trim(QSB1->B1_DESC)+'</description>'
		cMsg += '          <safetyStock>'+trim(STR(QSB1->B1_ESTSEG))+'</safetyStock>'
		cMsg += '          <lotMandatory>'+ iif(!QSB1->B1_RASTRO $ " /N","true","false")+'</lotMandatory>'
		cMsg += '          <adviceMandatory>true</adviceMandatory>'
		cMsg += '          <!--Optional:-->'
		cMsg += '         <serialNoRecordType>GOODS_OUT_RECORD</serialNoRecordType>'
		cMsg += '         <handlingUnit>'+trim(QSB1->B1_UM)+'</handlingUnit>'
		cMsg += '          <scale>0</scale>'
		cMsg += '          <!--Zero or more repetitions:-->'
		cMsg += '          <eanCodes>'+trim(QSB1->B1_CODBAR)+'</eanCodes>'
		cMsg += '          <!--Optional:-->'
		cMsg += '          <zone>'+trim(QSB1->B1_GRUPO)+ '</zone>'
		cMsg += '          <height>0</height>'
		cMsg += '          <width>0</width>'
		cMsg += '          <depth>0</depth>'
		cMsg += '          <weight>0</weight>'
		cMsg += '          <volume>0</volume>'
		cMsg += '       </arg0>'
		cMsg += '    </man:updateItemData>'
		cMsg += '</soapenv:Body>'
		cMsg += '</soapenv:Envelope>'

		// Envia uma mensagem SOAP personalizada ao servidor
		lRet := oWsdl:SendSoapMsg( cMsg )
		If lRet == .F.
			GravaZX3("SB1","4",oWsdl:cFaultString,xFilial("SB1")+QSB1->B1_COD,cRotina)
			conout( "Erro SendSoapMsg: " + oWsdl:cError )
			conout( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
			//MSgInfo("Erro SendSoapMsg FaultCode: " + oWsdl:cFaultString )
			//Return
		Else

			cMsgRet := oWsdl:GetSoapResponse()
			conout( cMsgRet )

			GravaZX3("SB1","6",cMsgRet,xFilial("SB1")+QSB1->B1_COD,cRotina)
		Endif
		MSProcTXT("Transferindo "+ QSB1->B1_COD)

		DBSelectArea("QSB1")
		DBSkip()

	Enddo
	dbclosearea()

return

/*/{Protheus.doc} wsGetInventory
Funcao para obter o envelope de retorno do webservice SparkStockTackingBean
no metodo getAceptedStocktackingOrder

@param
@return

@author Carlos Galimberti
@since 02/09/2019
@version P12.1.17
/*/

/*  ------- MODELO DO ENVELOPE RECEPCIONADO PELA ROTINA
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
<ns2:getAceptedStocktackingOrderResponse xmlns:ns2="http://spark_stocktaking.ws.inventory.los.linogistix.de/">
<return>
<id>3</id>
<list>
<itemData>00.00.0041.2004</itemData>
<plannedQuantity>0.0</plannedQuantity>
<countedQuantity>20.0</countedQuantity>
<lot/>
<specialStock/>
<client>Jomhedica</client>
<location>Picking</location>
</list>
</return>
<return>
<id>4</id>
<list>
<itemData>00.00.0042.2005</itemData>
<plannedQuantity>0.0</plannedQuantity>
<countedQuantity>25.0</countedQuantity>
<lot>123</lot>
<specialStock/>
<client>Jomhedica</client>
<location>Picking</location>
<lotValidity>2019-09-28</lotValidity>
</list>
</return>
</ns2:getAceptedStocktackingOrderResponse>
</soap:Body>
</soap:Envelope>
*/
user function wsGetInventory()
	Local   cRotina     := "MATA270"
	Local   __aObjXML   := {}
	Local   cURLSpark   := nil
	Local   cLgnSpark   := nil
	Local   cPswSpark   := nil
	Local   oXMLRets    := nil
	Local   nRets       := 0
	Private cErro := ""
	Private lMsErroAuto := .F.// variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
	Private lMsHelpAuto	:= .T.    // força a gravação das informações de erro em array para manipulação da gravação ao invés de gravar direto no arquivo temporário
	Private lAutoErrNoFile := .T.
	Private cErroBlk
	bBlock := ErrorBlock( { |e| GetError(e,"SB7",cRotina,"") } ) //cEntidade,CtIPO,cDet,cKey,cRotina

	RPCSetType(3)
	Prepare Environment Empresa "01" Filial "01" Modulo "EST" FUNNAME cRotina

	cURLSpark   := SuperGetMV("MV_URLSPAR",.F.,"http://100.27.32.87:8080")
	cLgnSpark   := SuperGetMV("MV_USPARK",.F.,"admin")
	cPswSpark   := SuperGetMV("MV_PSPARK",.F.,"spk123#")

	BEGIN SEQUENCE
		for nDias :=  1 to 31  //percorre os dias do mês corrente
			oWsdl := TWsdlManager():New()
			oWsdl:nTimeout       := 2000
			oWsdl:lverbose       := .t.
			oWsdl:SetAuthentication(cLgnSpark,cPswSpark)
			xRet := oWsdl:ParseURL(cURLSpark+"/webservice/SparkStockTackingBean?wsdl")

			if xRet == .F.
				conout("Erro ParseURL: " + oWsdl:cError)
				Return
			endif

			// Define a operação
			lRet := oWsdl:SetOperation("getAceptedStocktackingOrder")
			If lRet == .F.
				conout("Erro SetOperation: " + oWsdl:cError)
				return
			EndIf
			conout( oWsdl:cCurrentOperation )

			// Lista os tipos simples da mensagem de input envolvida na operação
			/* aSimple := oWsdl:SimpleInput()
			varinfo( "", aSimple )
			*/

			// monta o envelope de requisição para o WS de inventário
			cMsg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:spar="http://spark_stocktaking.ws.inventory.los.linogistix.de/">'
			cMsg += '<soapenv:Header/>'
			cMsg += '<soapenv:Body>'
			cMsg += '  <spar:getAceptedStocktackingOrder>'
			cMsg += '     <!--Optional:-->'
			cMsg += '     <date>'+ left(dtos(date()),4)+'-'+substr(dtos(date()),5,2)+'-'+alltrim(strzero(nDias,2))+'</date>'
			//cMsg += '     <date>'+ left(dtos(date()),4)+'-08-'+alltrim(strzero(nDias,2))+'</date>'

			cMsg += '  </spar:getAceptedStocktackingOrder>'
			cMsg += '</soapenv:Body>'
			cMsg += '</soapenv:Envelope>'

			conout(cMsg)
			lRet := oWsdl:SendSoapMsg( cMsg )
			If lRet == .F.
				GravaZX3("SB7","4",oWsdl:cFaultString,,cRotina) //revisar chave
				conout( "Erro SendSoapMsg: " + oWsdl:cError )
				conout( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
				//MSgInfo("Erro SendSoapMsg FaultCode: " + oWsdl:cFaultString )
				Return
			EndIf

			//oxml := xmlParser(oWsdl:GetSoapResponse(),"_",@cError,@cWarn)
			oXML := XmlParser( oWsdl:GetSoapResponse() ,"_",@cErro,"" )
			__aObjXML := ClassDataArr(oXML)
			lTem := .f.
			//varinfo("wsgetinventory",__aObjXML)
			//oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETACEPTEDSTOCKTACKINGORDERRESPONSE:_RETURN
			If Ascan(__aObjXml,{|x| Upper(x[1]) $ "_SOAP_ENVELOPE" }) > 0
				__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE)

				If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_SOAP_BODY" }) > 0
					__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE:_SOAP_BODY)

					If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_NS2_GETACEPTEDSTOCKTACKINGORDERRESPONSE" }) > 0
						__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETACEPTEDSTOCKTACKINGORDERRESPONSE)

						If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_RETURN" }) > 0
							lTem := .t.
						Endif
					Endif
				Endif
			endif

			if !lTem
				loop
			endif
			dEmissao :=  CTOD(alltrim(str(nDias))+"/"+alltrim(str(month(date())))+"/"+alltrim(str(year(date()))) )
			//varinfo("",__aObjXML)

			if valtype(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETACEPTEDSTOCKTACKINGORDERRESPONSE:_RETURN) == "O"
				nMaxRets := 1
				oXMLRets :=  oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETACEPTEDSTOCKTACKINGORDERRESPONSE:_RETURN
			Else
				nMaxRets:= len(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETACEPTEDSTOCKTACKINGORDERRESPONSE:_RETURN)

			Endif

			//conout("gerou erro")
			//RESET ENVIRONMENT

			//ErrorBlock(bBlock)
			aInventario := {}
			nTotItens := 0
			For nRets := 1 to nMaxRets
				oXMLRets :=  iif(oXMLRets == nil,oXMLRets :=  oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETACEPTEDSTOCKTACKINGORDERRESPONSE:_RETURN[nRets],oXMLRets)
				conout("ID SPARK " + oXMLRets:_ID:TEXT)
				conout("ID maxrets " + str(nMaxRets))

				//checa se o elemento _LIST existe no objeto
				aObjList := ClassDataArr(oXmlRets)
				If Ascan(aObjList,{|x| Upper(x[1]) == "_LIST" }) > 0
					if valtype(oXMLRets:_LIST) == "O"
						nMaxList := 1
					else
						nMaxList:= len(oXMLRets:_LIST)
					endif
				Else
					oXMLRets := nil
					loop
				endif

				For nList := 1 to nMaxList
					if nMaxList > 1

						cArmazem := Posicione("SB1",1,xFilial("SB1")+ RetCampo("B7_COD",oXMLRets:_LIST[nList]:_ITEMDATA:TEXT),"B1_LOCPAD")
						cLote    := RetCampo("B7_LOTECTL",oXMLRets:_LIST[nList]:_LOT:TEXT)
						cProduto := RetCampo("B7_COD",oXMLRets:_LIST[nList]:_ITEMDATA:TEXT)
						dEmissao :=  CTOD(alltrim(str(nDias))+"/"+alltrim(str(month(date())))+"/"+alltrim(str(year(date()))) )
						cDoc     := RetCampo("B7_DOC","S"+dtos(dEmissao))

						aadd(aInventario, {"B7_COD", cProduto 											, nil})
						aadd(aInventario, {"B7_LOCAL", cArmazem											, nil}) //RetCampo("B7_LOCAL",oXMLRets:_LIST:_LOCATION:TEXT)
						aadd(aInventario, {"B7_QUANT", val(oXMLRets:_LIST[nList]:_COUNTEDQUANTITY:TEXT)	, nil})
						aadd(aInventario, {"B7_DOC", cDoc     											, nil})
						aadd(aInventario, {"B7_DATA",dEmissao 											, nil})

						if !empty(oXMLRets:_LIST[nList]:_LOT:TEXT)
							aadd(aInventario, {"B7_LOTECTL", RetCampo("B7_LOTECTL",oXMLRets:_LIST[nList]:_LOT:TEXT)	, nil})
							aadd(aInventario, {"B7_DTVALID", Posicione("SB8",3,xFilial("SB8")+ cProduto + cArmazem +cLote,"B8_DTVALID"), nil})
						endif

					else
						cArmazem := Posicione("SB1",1,xFilial("SB1")+ RetCampo("B7_COD",oXMLRets:_LIST:_ITEMDATA:TEXT),"B1_LOCPAD")
						cLote    := RetCampo("B7_LOTECTL",oXMLRets:_LIST:_LOT:TEXT)
						cProduto := RetCampo("B7_COD",oXMLRets:_LIST:_ITEMDATA:TEXT)
						dEmissao :=  CTOD(alltrim(str(nDias))+"/"+alltrim(str(month(date())))+"/"+alltrim(str(year(date()))) )
						cDoc     := RetCampo("B7_DOC","S"+dtos(dEmissao))

						aadd(aInventario, {"B7_COD", cProduto 										, nil})
						aadd(aInventario, {"B7_LOCAL", cArmazem										, nil}) //RetCampo("B7_LOCAL",oXMLRets:_LIST:_LOCATION:TEXT)
						aadd(aInventario, {"B7_QUANT", val(oXMLRets:_LIST:_COUNTEDQUANTITY:TEXT)	, nil})
						aadd(aInventario, {"B7_DOC", cDoc											, nil})
						aadd(aInventario, {"B7_DATA",dEmissao 										, nil})

						if !empty(oXMLRets:_LIST:_LOT:TEXT)
							aadd(aInventario, {"B7_LOTECTL", RetCampo("B7_LOTECTL",oXMLRets:_LIST:_LOT:TEXT)		, nil})
							aadd(aInventario, {"B7_DTVALID",Posicione("SB8",3,xFilial("SB8")+ cProduto + cArmazem +;
							cLote,"B8_DTVALID"), nil})
							/*CTOD(Substr(oXMLRets:_LIST:_LOTVALIDITY:TEXT,9,2)+"/"+;
							Substr(oXMLRets:_LIST:_LOTVALIDITY:TEXT,6,2)+"/"+;
							Left(oXMLRets:_LIST:_LOTVALIDITY:TEXT,4))*/
						endif
					endif

					//varinfo("",aInventario)
					//return
					//varinfo("",aInventario)
					//return
					DBSelectArea("SB7")
					DBSetOrder(4)
					IF DBSeek( xFilial("SB7")+cProduto+cArmazem+cLote+cDoc+DTOS(dEmissao))
						nOperacao := 4 //alterar
					Else
						nOperacao := 3 //incluir
					Endif

					lMsErroAuto :=  .f.
					MSExecAuto({|x,y,z| mata270(x,y,z)},aInventario,.F.,nOperacao)

					if lMsErroAuto
						aLog := GetAutoGRLog()

						cFault := ""
						for n2:= 1 to Len(aLog)
							conout(aLog[n2])
							cFault += aLog[n2]
						Next
						GravaZX3("SB7","4",cFault,xFilial("SB7")+aInventario[1,2]+ aInventario[2,2]+dtos(aInventario[5,2]),cRotina)  // revisar chave

					else
						GravaZX3("SB7","6","Execução Realizada com sucesso.",xFilial("SB7")+aInventario[1,2]+ aInventario[2,2]+dtos(aInventario[5,2]),cRotina)  // revisar chave
						nTotItens++
					endif
					aInventario := {}
					//exit
				Next //nMaxList
				oXmlRets 	:= nil
			Next //nMaxRets
			conout("Itens Importados: " +str(nTotItens))
			oXml 		:= nil

		Next  //nDias - Dias do mês
		RECOVER
		conout("--->recover!!!!!!!!!!!!!!!!!!!!!!")

		//RESET ENVIRONMENT

	END SEQUENCE
	ErrorBlock(bBlock)

	RESET ENVIRONMENT
return

/*/{Protheus.doc} wsGetInventory
Funcao para enviar o envelope  do webservice ManageAdviceWSBean
no metodo updateAdvice para trasmitir as NF de compra e devolução de compra
do Protheus para o WMS SPark

@param
@return

@author Carlos Galimberti
@since 04/09/2019
@version P12.1.17
/*/
User Function wsAvisoReceb //(cOperacao)

	Local cAliasQry := "QNFE"
	Local cQuery
	Local cRotina   := "MATA103"
	Local   cURLSpark   := nil
	Local   cLgnSpark   := nil
	Local   cPswSpark   := nil
	Local cOperacao   := "I"

	cOperacao := iif(cOperacao == Nil,"I",cOperacao)
	RPCSetType(3)
	Prepare Environment Empresa "01" Filial "01" Modulo "EST" FUNNAME cRotina

	cURLSpark   := SuperGetMV("MV_URLSPAR",.F.,"http://100.27.32.87:8080")
	cLgnSpark   := SuperGetMV("MV_LGNSPARK",.F.,"admin")
	cPswSpark   := SuperGetMV("MV_PSWSPARK",.F.,"spk123#")

	/*cQuery :=  "SELECT F1_FILIAL,F1_CHVNFE,D1_COD,D1_QUANT,D1_LOTECTL,D1_DTVALID,D1_DTDIGIT, F1_TIPO, F1_FORNECE,F1_LOJA, F1_SERIE,F1_DOC, D1_ITEM FROM "  + RetSQLName("SF1") + " SF1, " + RetSQLName("SD1") + " SD1 WHERE SF1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = '' "
	cQuery +=  "   AND F1_FILIAL = D1_FILIAL "
	cQuery +=  "   AND F1_DOC = D1_DOC "
	cQuery +=  "   AND F1_SERIE = D1_SERIE "
	cQuery +=  "   AND F1_FORNECE = D1_FORNECE "
	cQuery +=  "   AND F1_LOJA = D1_LOJA "
	cQuery +=  "   AND SF1.F1_DTDIGIT = '20190715' "
	cQuery +=  "   AND SF1.F1_ESPECIE = 'SPED' "
	cQuery +=  "   AND SF1.D_E_L_E_T_ = '' "
	cQuery +=  "   AND SD1.D_E_L_E_T_ = '' "*/

	cQuery :=  "SELECT F1_FILIAL,F1_CHVNFE,D1_COD,D1_QUANT,D1_LOTECTL,D1_DTVALID,D1_DTDIGIT,D1_QTSEGUM, F1_TIPO, F1_FORNECE,F1_LOJA, F1_SERIE,F1_DOC,F1_TIPO, D1_ITEM, ZX4.R_E_C_N_O_ RECZX4,SD1.R_E_C_N_O_ RECSD1 FROM "
	cQuery +=  RetSQLName("SF1") + " SF1, " + RetSQLName("SD1") + " SD1, " + RetSQLName("ZX4") + " ZX4 WHERE SF1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = '' AND ZX4.D_E_L_E_T_ = '' "
	cQuery +=  "   AND F1_FILIAL = D1_FILIAL "
	cQuery +=  "   AND F1_DOC = D1_DOC "
	cQuery +=  "   AND F1_SERIE = D1_SERIE "
	cQuery +=  "   AND F1_FORNECE = D1_FORNECE "
	cQuery +=  "   AND F1_LOJA = D1_LOJA "
	cQuery +=  "   AND ZX4_ENT = 'SD1' "
	cQuery +=  "   AND ZX4_STATUS IN (' ','2') "
	cQuery +=  "   AND ZX4_CHVRET = '' "
	cQuery +=  "   AND F1_CHVNFE <> '' "
	cQuery +=  "   AND D1_FILIAL = SUBSTRING(ZX4_CHAVE,1,2) "
	cQuery +=  "   AND D1_FORNECE = SUBSTRING(ZX4_CHAVE,3,6) "
	cQuery +=  "   AND D1_LOJA = SUBSTRING(ZX4_CHAVE,9,2) "
	cQuery +=  "   AND D1_SERIE = SUBSTRING(ZX4_CHAVE,11,3) "
	cQuery +=  "   AND D1_DOC = SUBSTRING(ZX4_CHAVE,14,9) "
	cQuery +=  "   AND D1_ITEM = SUBSTRING(ZX4_CHAVE,23,4) "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

	TCSetField("QNFE","D1_DTDIGIT","D",8,0)
	TCSetField("QNFE","RECSD1","N",9,0)
	TCSetField("QNFE","RECSD1","N",9,0)
	TCSetField("QNFE","D1_DTVALID","D",8,0)
	TCSetField("QNFE","D1_QUANT","N",TamSX3("D1_QUANT")[1],TamSX3("D1_QUANT")[2])
	TCSetField("QNFE","D1_QTSEGUM","N",TamSX3("D1_QTSEGUM")[1],TamSX3("D1_QTSEGUM")[2])

	DBSelectArea("QNFE")
	DBGotop()

	While !eof()

		oWsdl := TWsdlManager():New()
		oWsdl:nTimeout       := 500
		oWsdl:lverbose       := .t.
		oWsdl:SetAuthentication(cLgnSpark,cPswSpark)

		xRet := oWsdl:ParseURL(cURLSpark+"/webservice/ManageAdviceWSBean?wsdl")

		if xRet == .F.
			conout("Erro ParseURL: " + oWsdl:cError)
			Return
		endif

		if cOperacao <> "E"
			// Define a operação
			lRet := oWsdl:SetOperation("updateAdvice")
			If lRet == .F.
				conout("Erro SetOperation: " + oWsdl:cError)
				return
			EndIf
			conout( oWsdl:cCurrentOperation )

			// Lista os tipos simples da mensagem de input envolvida na operação
			/* aSimple := oWsdl:SimpleInput()
			varinfo( "", aSimple )
			*/

			cMsg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:man="http://manage_advice.ws.inventory.los.linogistix.de/">'
			cMsg += '   <soapenv:Header/>'
			cMsg += '   <soapenv:Body>'
			cMsg += '      <man:updateAdvice>'
			cMsg += '         <!--Optional:-->'
			cMsg += '         <arg0>'
			cMsg += '            <!--Optional:-->'
			cMsg += '            <additionalContent>'+iif(QNFE->F1_TIPO == 'D','D','N')+'</additionalContent>'
			cMsg += '            <!--Optional:-->'
			cMsg += '            <adviceNumber></adviceNumber>'   // Revisar com a spark quando houver necessidade excluir a NF
			cMsg += '            <!--Optional:-->'
			cMsg += '            <bestBeforeEnd>'+ dtosxml(QNFE->D1_DTVALID)+'</bestBeforeEnd>' //colocar a data de validade
			cMsg += '            <clientNumber>Jomhedica</clientNumber>'
			cMsg += '            <!--Optional:-->'
			cMsg += '            <expectedDelivery>'+dtosxml(QNFE->D1_DTDIGIT)+'</expectedDelivery>'
			cMsg += '            <!--Optional:-->'
			cMsg += '            <externalAdviceNumber>'+QNFE->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC+D1_ITEM)+'</externalAdviceNumber>'
			cMsg += '            <!--Optional:-->'
			cMsg += '            <externalId>'+ QNFE->F1_CHVNFE+'</externalId>'
			cMsg += '            <itemNumber>'+Alltrim(QNFE->D1_COD)+'</itemNumber>'
			cMsg += '            <lockType>-1</lockType>'
			cMsg += '            <!--Optional:-->'
			cMsg += '            <lotNumber>'+alltrim(QNFE->D1_LOTECTL)+'</lotNumber>'
			cMsg += '            <!--Optional:-->'
			cMsg += '            <madeToOrder></madeToOrder>'
			if QNFE->D1_QTSEGUM > 0
				cMsg += '            <notifiedAmount>'+ Alltrim(STR(QNFE->D1_QTSEGUM))+'</notifiedAmount>'
			else
				cMsg += '            <notifiedAmount>'+ Alltrim(STR(QNFE->D1_QUANT))+'</notifiedAmount>'
			endif
			cMsg += '			 <additionalContent>'+GetTagInfo(QNFE->F1_FORNECE,QNFE->F1_LOJA,QNFE->D1_COD,QNFE->F1_TIPO)+'</additionalContent>'
			cMsg += '         </arg0>'
			cMsg += '      </man:updateAdvice>'
			cMsg += '   </soapenv:Body>'
			cMsg += '</soapenv:Envelope>'
		else  // envelope de exclusao

			// Define a operação
			lRet := oWsdl:SetOperation("deleteAdvice")
			If lRet == .F.
				conout("Erro SetOperation: " + oWsdl:cError)
				return
			EndIf

			conout( oWsdl:cCurrentOperation )
			// chamar o metodo deleadvise
			cMsg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:man="http://manage_advice.ws.inventory.los.linogistix.de/">'
			cMsg += '	   <soapenv:Header/>'
			cMsg += '	   <soapenv:Body>'
			cMsg += '	      <man:deleteAdvice>'
			cMsg += '	         <!--Optional:-->'
			cMsg += '	         <arg0>'
			cMsg += '	            <!--Optional:-->'
			cMsg += '	            <adviceNumber></adviceNumber>'
			cMsg += '	            <clientNumber>jomhedica</clientNumber>'
			cMsg += '	            <!--Optional:-->'
			cMsg += '	            <externalAdviceNumber></externalAdviceNumber>'
			cMsg += '	            <!--Optional:-->'
			cMsg += '	            <externalId>1111111111111111111111</externalId>'
			cMsg += '	         </arg0>'
			cMsg += '	      </man:deleteAdvice>'
			cMsg += '	   </soapenv:Body>'
			cMsg += '	</soapenv:Envelope>'
		endif

		// Envia uma mensagem SOAP personalizada ao servidor
		lRet := oWsdl:SendSoapMsg( cMsg )
		conout( cMsg )
		If lRet == .F.
			GravaZX3("SD1","4",oWsdl:cFaultString,xFilial("SD1")+QNFE->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC+D1_ITEM),cRotina)

			// 1 - Transmitido
			// 2 - Rejeitado
			RecLock("ZX4",.F.)
			ZX4->ZX4_STATUS := "2" //Rejeitado
			MSUnlock()

			conout( "Erro SendSoapMsg: " + oWsdl:cError )
			conout( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
			//MSgInfo("Erro SendSoapMsg FaultCode: " + oWsdl:cFaultString )
		Else
			cMsgRet := oWsdl:GetSoapResponse()
			conout( cMsgRet )
			cChvRet := GetSimples(cMsgRet,"return","/return")

			// 1 - Transmitido
			// 2 - Rejeitado
			ZX4->(DBGoto(QNFE->RECZX4))
			RecLock("ZX4",.F.)
			ZX4->ZX4_STATUS := "1" // Tramisitido
			ZX4->ZX4_CHVRET := cChvRet
			MSUnlock()

			GravaZX3("SD1","6",cMsgRet,xFilial("SD1")+QNFE->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC+D1_ITEM),cRotina)
		Endif

		Conout("NF Compra: "+ DTOC(QNFE->D1_DTDIGIT)+"-"+ QNFE->F1_CHVNFE)
		DBSelectArea("QNFE")
		dbskip()
	enddo
	RESET ENVIRONMENT
	DBCloseArea()
return
/*Case cType == "FIM" // Final do Processamento
cMsg := STR0045+cMsg  //"Processamento encerrado. "
cType := "2"
Case cType == "ALERTA" // Alerta
cMsg := STR0046+cMsg  //"Alerta! "
cType := "3"
Case cType == "ERRO" // Erro
cMsg := STR0047+cMsg  //"Erro de Processamento. "
cType := "4"
Case cType == "CANCEL" // Cancelado pelo usuario
cMsg := STR0048+cMsg  //"Processamento cancelado pelo usuario. "
cType := "5"
Case cType == "MENSAGEM" // Mensagem
cMsg := STR0049+cMsg  //"Mensagem : "
cType := "6"
EndCase*/

Static function GravaZX3(cEntidade,CtIPO,cDet,cKey,cRotina)
	Local aArea := GetArea()
	Local aEnt  := &(cEntidade +"->( GetArea())")
	if cEntidade == "QSC6"
		&(cEntidade +"->( DBGoto(" +alltrim(str(QSC6->ZX4_RECORI)) +"))")
	Elseif cEntidade = "QNFE"
		&(cEntidade +"->( DBGoto(" +alltrim(str(QNFE->RECSD1)) +"))")
	Endif
	Reclock("ZX3",.T.)

	ZX3->ZX3_FILIAL := xFilial("ZX3")
	ZX3->ZX3_ENT    := cEntidade
	ZX3->ZX3_ROTINA := cRotina
	ZX3->ZX3_KEY    := cKey
	ZX3->ZX3_TIPO   := cTipo
	ZX3->ZX3_DATA   := Date()
	ZX3->ZX3_HORA   := Time()
	ZX3->ZX3_DET    := cDet
	ZX3->zx3_RECNO  := &(cEntidade+"->(recno())")
	MsUnlock()

	RestArea(aEnt)
	RestArea(aArea)

Return

/*/{Protheus.doc} GetSimples
Função para pegar um valor simples contido entre uma
tag inicial e uma tag final

@param cXmlRet, XML de resposta do WebService
@param cTagIni, Tag inicial para pegar o valor
@param cTagFim, Tag final para pegar o valor
@return cRet, Valor contido entre a tag inicial e a tag final

@author Pedro Alencar
@since 23/02/2015
@version P12.1.4
/*/
Static Function GetSimples( cXmlRet, cTagIni, cTagFim )
	Local cRet    := ""
	Local nAtIni  := 0
	Local nAtFim  := 0
	Local nTamTag := 0

	//Localização das tags na string do XML
	nAtIni := At( cTagIni, cXmlRet )+1
	nAtFim := At( cTagFim, cXmlRet )-1

	//Pega o valor entre a tag inicial e final
	If nAtIni > 0 .AND. nAtFim > 0
		nTamTag := Len( cTagIni )
		cRet := SubStr( cXmlRet, nAtIni + nTamTag, nAtFim - nAtIni - nTamTag )
	Endif
Return cRet

/*/{Protheus.doc} GetError
//TODO Rotina para gerar log na tabela ZX3 quando ocorre uma excessao no código.
@author Carlos Galimberti
@since 30/08/2019
@version 1.0
@return ${return}, ${return_description}
@param e, , descricao
@param cAlias, characters, descricao
@param cRotina, characters, descricao
@param cKey, characters, descricao
@type function
/*/
Static Function GetError( e, cAlias,cRotina, cKey )

	Local lRet		:= .F.  //Variael de retorno da funcao

	DEFAULT e		:= NIL
	DEFAULT cErro	:= ""

	If e:Gencode > 0
		cErro :=  e:description +chr(13)+chr(10)+ e:errorStack
		//exibe a mensagem de erro no console
		conout('------>'+cErro)
		conout('------>'+e:errorStack)
		if select("SB7") <= 0
			DBUseArea( .T., "TOPCONN", RetSQLName("SB7"), "SB7", .T., .F. )
		endif
		if select("ZX3") <= 0
			DBUseArea( .T., "TOPCONN", RetSQLName("ZX3"), "ZX3", .T., .F. )
		endif
		GravaZX3(cAlias,"4",cErro ,cKey,cRotina)
		//executa o bloco RECOVER do BEGIN/END SEQUENCE
		BREAK

	EndIf

Return lRet

/*/{Protheus.doc} DtosXML
Função para obter a data no formato AAAA-MM-DD

@param dData: informa a data para realizar a conversao
@return Retorno o conteúdo esperado.

@author Carlos Galimberti
@since 25/08/2019
@version P12.1.17
/*/
static function dtosxml(dData)
return LEFT(dtos(dData),4)+'-'+Substr(dtos(dData),5,2)+'-'+substr(dtos(dData),7,2)

/*/{Protheus.doc} RetCampo
Função para ajustar o tamanho exato contido nos dicionarios de dados (SX3)

@param cCampo: nome do campo no dicionário de dados.
@param cConteudo: conteudo do campo para ser formatado.
@return Retorno o conteúdo esperado.

@author Carlos Galimberti
@since 25/08/2019
@version P12.1.17
/*/
Static Function RetCampo(cCampo,cConteudo)
	Local nTam := TamSX3(cCampo)[1]
Return cConteudo + space( nTam - len(cConteudo))

/*/{Protheus.doc} WSWMSStartTask
Função para iniciar a tarefa de coleta do WMS

@param cPedido: Numero do pedido do protheus e referencia no WMS
@param cCliente: Codido cliente
@param aCols: Array contendo os detalhes do pedido de vendas
@param aHeader: Array contendo os labels dos detalhes do pedido de venda
@return nil.

@author Carlos Galimberti
@since 09/10/2019
@version P12.1.17
/*/

User Function WSWMSStartTask(cPedido,cCliente,cLoja,dEmissao,cTpTransp,aItens,aHeader,cTransp,cMensagem,cErro)

	Local cAliasQry := "QSC6"
	Local cQuery
	Local cRotina   := PROCNAME()

	Local nPItem   	:= aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == 'C6_ITEM' } )
	Local nPProduto	:= aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == 'C6_PRODUTO' } )
	Local nPLocal   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_LOCAL" } )
	Local nPUM      := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_UM" } )
	Local nPLocal   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_LOCAL" } )
	Local nPDescri  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_DESCRI" } )
	Local nPSegUM   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_SEGUM" } )
	Local nPConta   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_CONTA" } )
	Local nPCCusto  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_CCUSTO" } )
	Local nPItemCTB := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_ITEMCTB" } )
	Local nPQtdVen  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_QTDVEN" } )
	Local nPIdentB6 := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_IDENTB6" } )
	Local nPTipFat  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_TIPFAT" } )
	Local nPQtdRep  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_QTDREP" } )
	Local nPTesRep  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_TESREP" } )
	Local nPNfOri   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_NFORI" } )
	Local nPSerOri  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_SERIORI" } )
	Local nPItemOri := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_ITEMORI" } )
	Local nPPrcVen  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_PRCVEN" } )
	Local nPosClvl  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_CLVL" } )

	Local nPosItem  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_ITEM" } )
	Local nPosLCLT  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_LOTECTL" } )
	Local nPosLote  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_LOTE" } )
	Local nPEnvSep  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_ENVSEP"} )
	Local cC9Seq

	//Local nPDeleted	:= Len( aHeader ) + 1

	Local cURLSpark   := SuperGetMV("MV_URLSPAR",.F.,"http://100.27.32.87:8080")
	Local cLgnSpark   := SuperGetMV("MV_LGNSPARK",.F.,"admin")
	Local cPswSpark   := SuperGetMV("MV_PSWSPARK",.F.,"spk123#")

	//if CheckOrderStatus(cPedido) .and. SPKCancelOrder(cPedido)

	oWsdl := TWsdlManager():New()
	oWsdl:nTimeout       := 120
	oWsdl:lverbose       := .t.
	oWsdl:SetAuthentication(cLgnSpark,cPswSpark)

	xRet := oWsdl:ParseURL(cURLSpark+"/webservice/SparkOrderkBean?wsdl")

	if xRet == .F.
		conout("Erro ParseURL: " + oWsdl:cError)
		Return
	endif

	// Define a operação
	lRet := oWsdl:SetOperation("orderSt")
	If lRet == .F.
		conout("Erro SetOperation: " + oWsdl:cError)
		return
	EndIf
	conout( oWsdl:cCurrentOperation )

	// Lista os tipos simples da mensagem de input envolvida na operação
	/* aSimple := oWsdl:SimpleInput()
	varinfo( "", aSimple )
	*/
	lProcess := .f.
	varinfo( "", aItens )
	if len(aItens) > 0
		cMsg := ' <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:spar="http://spark_createorderfull.ws.inventory.los.linogistix.de/"> '
		cMsg += '	   <soapenv:Header/> '
		cMsg += '		   <soapenv:Body>'
		cMsg += '		      <spar:orderSt>'
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <username>'+cLgnSpark+'</username>'
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <password>'+cPswSpark+'</password>'
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <clientRef>Jomhedica</clientRef>'
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <orderRef>'+cPedido+'</orderRef>'
		cMsg += '		         <!--Zero or more repetitions:-->'
		varinfo("MT410STTS", aItens)
		For nIdxCols := 1 to Len(aItens)
			if !aItens[nIdxCols,len(aHeader)+1]
				if aItens[nIdxCols,nPEnvSep] == "1" //Apenas solicita coleta quando "Separar" = sim
					cMsg += '		         <positions>'
					cMsg += '		            <!--Optional:-->'
					cMsg += '		            <clientRef>Jomhedica</clientRef>'
					cMsg += '		            <!--Optional:-->'
					cMsg += '		            <batchRef></batchRef>'
					cMsg += '		            <!--Optional:-->'
					cMsg += '		            <articleRef>'+alltrim(aItens[nIdxCols,nPProduto])+'</articleRef>'
					cMsg += '		            <!--Optional:-->'
					cMsg += '		            <additionalContent></additionalContent>'
					cMsg += '		            <!--Optional:-->'
					cMsg += '		            <amount>'+alltrim(str(aItens[nIdxCols,nPQtdVen]))+'</amount>'
					cMsg += '		            <!--Optional:-->'
					cMsg += '		            <madeToOrder></madeToOrder>'
					cMsg += '		         </positions>'
					lProcess := .t.
				Endif
			Endif
		Next
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <documentUrl></documentUrl>'
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <labelUrl></labelUrl>'
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <destination></destination>'
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <orderStrategyName>'+iif(cTpTransp=="1","Transportadora",iif(cTpTransp=="2","Motoboy","CQ"))+'</orderStrategyName>'
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <deliveryDate>'+dtosxml(dEmissao+1)+'</deliveryDate>'  //solicitado pelo Leonardo para somar 30 dias devido as regras priorizacao
		cMsg += '		         <prio>50</prio>'
		cMsg += '		         <startPicking>true</startPicking>'
		cMsg += '		         <completeOnly>true</completeOnly>'
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <comment>'+ UpdComments(cTransp,cCliente,cLoja,cMensagem)+'</comment>'
		cMsg += '		         <separatedByCluster>false</separatedByCluster>'
		cMsg += '		         <isVAS>false</isVAS>'
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <shipment></shipment>'
		cMsg += '		         <!--Optional:-->'
		cMsg += '		         <printStrategy></printStrategy>'
		cMsg += '		      </spar:orderSt>'
		cMsg += '		   </soapenv:Body>'
		cMsg += '		   </soapenv:Envelope>'

		// Envia uma mensagem SOAP personalizada ao servidor
		if lProcess
			conout(cMsg)
			lRet := oWsdl:SendSoapMsg( cMsg )
			If lRet == .F.
				GravaZX3("SC6","4",oWsdl:cFaultString,xFilial("SC6")+ cPedido , cRotina)

				// 1 - Transmitido
				// 2 - Rejeitado
				/*RecLock("ZX4",.F.)
				ZX4->ZX4_STATUS := "2" //Rejeitado
				MSUnlock()*/

				conout( "Erro SendSoapMsg: " + oWsdl:cError )
				conout( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
				cErro := oWsdl:cFaultString
				//MSgInfo("Erro SendSoapMsg FaultCode: " + oWsdl:cFaultString )
			Else
				cMsgRet := oWsdl:GetSoapResponse()
				conout( cMsgRet )
				cChvRet := GetSimples(cMsgRet,"return","/return")

				// 1 - Transmitido
				// 2 - Rejeitado
				/*ZX4->(DBGoto(QNFE->RECZX4))
				RecLock("ZX4",.F.)
				ZX4->ZX4_STATUS := "1" // Tramisitido
				ZX4->ZX4_CHVRET := cChvRet
				MSUnlock()*/

				GravaZX3("SC6","6",oWsdl:cFaultString,xFilial("SC6")+ cPedido , cRotina)
			Endif
		Endif
	Endif
	//Endif  //checkorderstatus
Return lret

/*/{Protheus.doc} wmsWsFinishOrder
Função para obter as informações de coleta do WMS iniciado pela funcao WSWMSStartTask

@param cPedido: Numero do pedido do protheus e referencia no WMS
@param lPrepare: quando verdadeiro inicializa tabelas do protheus rodado por job
@return lógico.

@author Carlos Galimberti
@since 09/10/2019
@version P12.1.17
/*/

User function wmsWsFinishOrder(cPedido, lprepare)

	Local cAliasQry := "QSC6"
	Local oXMLrets  := nil
	Local aSC6area
	Local cQuery
	Local cRotina   := "MATA460"
	Local cURLSpark := nil
	Local cLgnSpark := nil
	Local cPswSpark := nil
	Local cC9Seq
	Local lRet      :=  .t.
	Local oXMLPosRets := nil
	Private cErro   := ""

	Default lPrepare := .t.
	//MSGALERT("PASSOU")
	if lprepare
		RPCSetType(3)
		Prepare Environment Empresa "01" Filial "01" Modulo "FAT" FUNNAME cRotina
	endif

	Default cPedido  := ""
	cPedido := iif( cPedido == Nil,SPACE(6),cPedido)
	lPrepare := iif( lPrepare == Nil,.t.,lprepare)

	aSC6area  := SC6->(GetArea())
	cURLSpark   := SuperGetMV("MV_URLSPAR",.F.,"http://100.27.32.87:8080")
	cLgnSpark   := SuperGetMV("MV_LGNSPARK",.F.,"admin")
	cPswSpark   := SuperGetMV("MV_PSWSPARK",.F.,"spk123#")

	/*cQuery :=  "SELECT F1_FILIAL,F1_CHVNFE,D1_COD,D1_QUANT,D1_LOTECTL,D1_DTVALID,D1_DTDIGIT, F1_TIPO, F1_FORNECE,F1_LOJA, F1_SERIE,F1_DOC, D1_ITEM FROM "  + RetSQLName("SF1") + " SF1, " + RetSQLName("SD1") + " SD1 WHERE SF1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = '' "
	cQuery +=  "   AND F1_FILIAL = D1_FILIAL "
	cQuery +=  "   AND F1_DOC = D1_DOC "
	cQuery +=  "   AND F1_SERIE = D1_SERIE "
	cQuery +=  "   AND F1_FORNECE = D1_FORNECE "
	cQuery +=  "   AND F1_LOJA = D1_LOJA "
	cQuery +=  "   AND SF1.F1_DTDIGIT = '20190715' "
	cQuery +=  "   AND SF1.F1_ESPECIE = 'SPED' "
	cQuery +=  "   AND SF1.D_E_L_E_T_ = '' "
	cQuery +=  "   AND SD1.D_E_L_E_T_ = '' "*/

	//C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_PRODUTO
	cQuery :=  "SELECT SUBSTRING(ZX4_CHAVE,1,2) C6_FILIAL, SUBSTRING(ZX4_CHAVE,3,6) C6_NUM, SUBSTRING(ZX4_CHAVE,9,2) C6_ITEM, SUBSTRING(ZX4_CHAVE,11,15) C6_PRODUTO, "
	cQuery +=  " C6_ENVSEP,C6_LOCAL, C6_QTDVEN, ZX4_RECORI,ZX4_ENT,ZX4_CHAVE, ZX4.R_E_C_N_O_ RECZX4 FROM "
	cQuery +=  RetSQLName("SC6") + " SC6, " + RetSQLName("ZX4") + " ZX4 WHERE SC6.D_E_L_E_T_ = '' AND ZX4.D_E_L_E_T_ = '' "
	cQuery +=  "   AND C6_FILIAL = ZX4_FILIAL "
	cQuery +=  "   AND ZX4_ENT = 'SC6' "
	if !empty(alltrim(cPedido))
		cQuery +=  "   AND SUBSTRING(ZX4_CHAVE,1,2) LIKE '%" + xFilial("SC6") + "%' "
		cQuery +=  "   AND SUBSTRING(ZX4_CHAVE,3,6) LIKE '%" + cPedido + "%' "
	endif
	cQuery +=  "   AND ZX4_STATUS IN (' ','2') "
	cQuery +=  "   AND C6_FILIAL = SUBSTRING(ZX4_CHAVE,1,2) "
	cQuery +=  "   AND C6_NUM = SUBSTRING(ZX4_CHAVE,3,6) "
	cQuery +=  "   AND C6_ITEM = SUBSTRING(ZX4_CHAVE,9,2) "
	cQuery +=  "   AND C6_PRODUTO = SUBSTRING(ZX4_CHAVE,11,15) "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	IF EOF()
		cQuery :=  "SELECT SUBSTRING(ZX4_CHAVE,1,2) C6_FILIAL, SUBSTRING(ZX4_CHAVE,3,6) C6_NUM, SUBSTRING(ZX4_CHAVE,9,2) C6_ITEM, SUBSTRING(ZX4_CHAVE,11,15) C6_PRODUTO, "
		cQuery +=  " C6_ENVSEP,C6_LOCAL,  ZX4_RECORI,ZX4_ENT,ZX4_CHAVE, ZX4.R_E_C_N_O_ RECZX4 FROM "
		cQuery +=  RetSQLName("SC6") + " SC6, " + RetSQLName("ZX4") + " ZX4 WHERE SC6.D_E_L_E_T_ = '' AND ZX4.D_E_L_E_T_ = '' "
		cQuery +=  "   AND C6_FILIAL = ZX4_FILIAL "
		cQuery +=  "   AND ZX4_ENT = 'SC6' "
		if !empty(alltrim(cPedido))
			cQuery +=  "   AND SUBSTRING(ZX4_CHAVE,1,2) LIKE '%" + xFilial("SC6") + "%' "
			cQuery +=  "   AND SUBSTRING(ZX4_CHAVE,3,6) LIKE '%" + cPedido + "%' "
		endif
		cQuery +=  "   AND ZX4_STATUS IN ('1') "
		cQuery +=  "   AND C6_FILIAL = SUBSTRING(ZX4_CHAVE,1,2) "
		cQuery +=  "   AND C6_NUM = SUBSTRING(ZX4_CHAVE,3,6) "
		cQuery +=  "   AND C6_ITEM = SUBSTRING(ZX4_CHAVE,9,2) "
		cQuery +=  "   AND C6_PRODUTO = SUBSTRING(ZX4_CHAVE,11,15) "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"C6PROC",.T.,.T.)
		IF eof()
			lret := .f.
			if !lprepare
				MsgAlert("É necessario  liberar novamente o pedido.")
			endif
		endif
		C6PROC->( DBClosearea())
	Endif
	/*TCSetField("QNFE","D1_DTDIGIT","D",8,0)
	TCSetField("QNFE","D1_DTVALID","D",8,0)
	TCSetField("QNFE","D1_QUANT","N",TamSX3("D1_QUANT")[1],TamSX3("D1_QUANT")[2])*/
	cC9seq := "01"
	aFila := {}

	DBSelectArea("QSC6")
	DBGotop()
	While !eof()

		oWsdl := TWsdlManager():New()
		oWsdl:nTimeout       := 120
		oWsdl:lverbose       := .t.
		oWsdl:SetAuthentication(cLgnSpark,cPswSpark)
		xRet := oWsdl:ParseURL(cURLSpark+"/webservice/SparkManagerOrderBean?wsdl")

		if xRet == .F.
			conout("Erro ParseURL: " + oWsdl:cError)
			Return
		endif

		// Define a operação
		lRet := oWsdl:SetOperation("getFinishOrderInformation")
		If lRet == .F.
			conout("Erro SetOperation: " + oWsdl:cError)
			return
		EndIf
		conout( oWsdl:cCurrentOperation )

		// Lista os tipos simples da mensagem de input envolvida na operação
		/* aSimple := oWsdl:SimpleInput()
		varinfo( "", aSimple )
		*/

		cMsg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:spar="http://spark_managerorder.ws.inventory.los.linogistix.de/">'
		cMsg += '   <soapenv:Header/>'
		cMsg += '   <soapenv:Body>'
		cMsg += '      <spar:getFinishOrderInformation>'
		cMsg += '         <!--Optional:-->'
		cMsg += '         <clientRef>Jomhedica</clientRef>'
		cMsg += '         <!--Optional:-->'
		cMsg += '         <externalNumber>'+alltrim(QSC6->C6_NUM)+'</externalNumber>'
		cMsg += '      </spar:getFinishOrderInformation>'
		cMsg += '   </soapenv:Body>'
		cMsg += '</soapenv:Envelope>'

		cPedido :=  QSC6->C6_NUM
		conout(cMsg)
		lRet := oWsdl:SendSoapMsg( cMsg )
		If lRet == .F.
			GravaZX3("SC6","4",oWsdl:cFaultString,,cRotina) //revisar chave
			conout( "Erro SendSoapMsg: " + oWsdl:cError )
			conout( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
			//MSgInfo("Erro SendSoapMsg FaultCode: " + oWsdl:cFaultString )
			Return
		EndIf

		//oxml := xmlParser(oWsdl:GetSoapResponse(),"_",@cError,@cWarn)
		oXML := XmlParser( oWsdl:GetSoapResponse() ,"_",@cErro,"" )

		__aObjXML := ClassDataArr(oXML)
		lTem := .f.
		//varinfo("",aObjXML)
		//oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETACEPTEDSTOCKTACKINGORDERRESPONSE:_RETURN
		If Ascan(__aObjXml,{|x| Upper(x[1]) $ "_SOAP_ENVELOPE" }) > 0
			__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE)

			If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_SOAP_BODY" }) > 0
				__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE:_SOAP_BODY)

				If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_NS2_GETFINISHORDERINFORMATIONRESPONSE" }) > 0
					__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETFINISHORDERINFORMATIONRESPONSE)

					If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_RETURN" }) > 0
						lTem := .t.
					Endif
				Endif
			Endif
		endif

		if QSC6->C6_ENVSEP == "2" // se nao houver separacao trata o padrao do lote sem integracao com o WMS

			if !CheckSC9SPK(QSC6->C6_NUM,QSC6->C6_ITEM)
				if !lprepare
					MsgAlert("Há inconsistencias no Lote e/ou Número de Serie")
				endif
				lret :=  .f.
			endif
			if lret
				//Flega como processado
				ZX4->(DBGoto(QSC6->RECZX4))
				RecLock("ZX4",.F.)
				ZX4->ZX4_STATUS := "1" // Tramisitido
				MSUnlock()
			endif
			DBSelectArea("QSC6")
			DBSkip()
			loop

		elseif !lTem
			// Comentado bloco que possibilitava trabar sem o SPARK.
			/*if !Posicione("SB1",1, xFilial("SB1")+ QSC6->C6_PRODUTO,"B1_RASTRO") $ "N/ "
			cQry := "SELECT TOP 1 ZZJ_LOTE,ZZJ_SERIAL FROM " + RetSQLName("ZZJ") + " ZZJ, "+RetSQLName('SB8') +" SB8 "
			cQry += " WHERE ZZJ_FILIAL = B8_FILIAL AND ZZJ_PRODUT = '"+ QSC6->C6_PRODUTO
			cQry += "  AND SB8.B8_PRODUTO = ZZJ.ZZJ_PRODUT "
			cQry += "  AND SB8.B8_LOTECTL = ZZJ.ZZJ_LOTE "
			cQry += "' AND SB8.D_E_L_E_T_ = '' AND ZZJ.D_E_L_E_T_ = ''"
			cQry += "  AND ZZJ_QTDE > 0 AND B8_SALDO > 0 "
			cQry += " ORDER BY  B8_DTVALID "

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"QZZJ",.T.,.T.)
			DbGotop()
			if !eof()
			cC9seq := GravaSC9Lote(QSC6->ZX4_RECORI,QZZJ->ZZJ_LOTE,QZZJ->ZZJ_SERIAL,cC9Seq)
			lRet := .t.
			Else

			if !lprepare
			MsgAlert("Lote não entregue pelo WMS até o momento, portanto impossibilita a preparação NFs de saída. Favor checar o item : "+;
			QSC6->C6_ITEM + " Produto: " +QSC6->C6_PRODUTO + " Local: " + QSC6->C6_LOCAL + " Separa?: " + if(QSC6->C6_ENVSEP== "1","Sim","Nao"))
			endif
			lret := .f.
			Endif
			dbSelectArea("QZZJ")
			dbCloseArea()
			endif*/
			if !lprepare
				MsgAlert("Lote não entregue pelo WMS até o momento, portanto impossibilita a preparação NFs de saída. Favor checar o item : "+;
				QSC6->C6_ITEM + " Produto: " +QSC6->C6_PRODUTO + " Local: " + QSC6->C6_LOCAL + " Separa?: " + if(QSC6->C6_ENVSEP== "1","Sim","Nao"))
			endif
			lret := .f.
			DBSelectArea("QSC6")
			DBSkip()
			loop
		endif

		if valtype(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETFINISHORDERINFORMATIONRESPONSE:_RETURN) == "O"
			nMaxRets := 1
			oXMLRets :=  oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETFINISHORDERINFORMATIONRESPONSE:_RETURN
		Else
			nMaxRets:= len(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETFINISHORDERINFORMATIONRESPONSE:_RETURN)

		Endif

		//conout("gerou erro")
		//RESET ENVIRONMENT

		//ErrorBlock(bBlock)
		BEGIN TRANSACTION

			lSC9First := .t.
			For nRets := 1 to nMaxRets

				oXMLRets :=  iif(oXMLRets == nil,oXMLRets :=  oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETFINISHORDERINFORMATIONRESPONSE:_RETURN[nRets],oXMLRets)

				if oXMLRets:_STATE:TEXT < "600"
					oXMLRets := nil
					lRet := .f.
					if !lprepare
						MsgAlert("O status da ordem de coleta no SPARK está com "+ oXMLRets:_STATE:TEXT + " impossibilitando  continuidade do processo.")
					endif
					loop
				endif

				if valtype(oXMLRets:_POSITIONS) == "O"
					nMaxPosRets	:= 1
					oXMLPosRets :=  oXMLRets:_POSITIONS
				Else
					nMaxPosRets:= len(oXMLRets:_POSITIONS)
				Endif

				nQtdeItem := QSC6->C6_QTDVEN
				for nRetPos :=  1 to nMaxPosRets //tag _POSITIONS

					oXMLPosRets :=  iif(oXMLPosRets == nil,oXMLPosRets :=  oXMLRets:_POSITIONS[nRetPos],oXMLPosRets)

					__aXMLRets := ClassDataArr(oXMLPosRets)
					if nMaxPosRets > 1
						cLoteCTL := Iif(Ascan(__aXMLRets,{|x| Upper(x[1]) $ "_LOT" }) > 0, oXMLPosRets:_LOT:TEXT,"")
						cProduto := oXMLPosRets:_ITEMDATA:TEXT
						nQtdLib  := Val(oXMLPosRets:_AMOUNTPICKED:TEXT)
					else
						cLoteCTL :=  Iif(Ascan(__aXMLRets,{|x| Upper(x[1]) $ "_LOT" }) > 0,oXMLPosRets:_LOT:TEXT,"")
						cProduto := oXMLPosRets:_ITEMDATA:TEXT
						nQtdLib  := Val(oXMLPosRets:_AMOUNTPICKED:TEXT)
					endif

					DBSelectArea("SC6")
					DBGoto(QSC6->ZX4_RECORI)
					If QSC6->C6_PRODUTO <> RetCampo("C6_PRODUTO",cProduto)
						oXMLPosRets := nil
						Loop
					Endif

					// checa se há saldo no lote sugerido
					DBSelectArea("SB8")
					DBSetOrder(3)
					IF DBSeek( xFilial("SB8")+ SC6->C6_PRODUTO +SC6->C6_LOCAL + RetCampo("B8_LOTECTL",cLoteCtl))
						if nQtdLib > (B8_SALDO - B8_EMPENHO)
							if !ascan( aFila,{|x| alltrim(x[1]) == alltrim(cPedido+cProduto+cLoteCTL)})

								if !lprepare
									MsgAlert("O lote " + cLoteCtl + " tem saldo insuficente para o produto " + sc6->c6_produto)
								endif
								lret := .f.
								DisarmTransaction()
								//conout("exit")
								exit
							else
								oXMLPosRets := nil
								Loop

							endif
						Endif
					Else
						if !lprepare
							MsgAlert("O lote '" + cLoteCtl + "' não existe para o produto " + sc6->c6_produto)
						endif
						lret := .f.
						DisarmTransaction()
						conout("exit")
						exit
					Endif

					lSemSerial := .f.
					aObjList   := ClassDataArr(oXmlPosRets:_SERIALRESPONSE)
					//VARINFO("_SERIALRESPONSE",aObjList)
					If Ascan(aObjList,{|x| Upper(x[1]) == "_SERIAL" }) > 0

						if valtype(oXMLPosRets:_SERIALRESPONSE:_SERIAL) == "O"
							nMaxSerials := 1
						else
							nMaxSerials := len(oXMLPosRets:_SERIALRESPONSE:_SERIAL)
						endif
					Else
						lSemSerial := .t.
						nMaxSerials := 1
					Endif
					DBSelectArea("SC9")
					DBSetOrder(11)
					cBLCred := ""
					cBLEst  := ""

					IF DBSeek( QSC6->C6_FILIAL+QSC6->C6_NUM + QSC6->C6_ITEM + QSC6->C6_PRODUTO) .and. lSC9First
						lSC9First := .f.
						While !eof() .and. SC9->C9_FILIAL + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO == QSC6->C6_FILIAL+QSC6->C6_NUM + QSC6->C6_ITEM + QSC6->C6_PRODUTO

							AtuB8Emp(SC9->C9_PRODUTO,SC9->C9_LOCAL,SC9->C9_LOTECTL,SC9->C9_QTDLIB,"-")

							DBSelectArea("SC9")
							Reclock("SC9",.F.)
							DBDelete()
							MsUnlock()

							dbskip()
						end
					Endif

					For nSerials := 1 to nMaxSerials

						if nMaxSerials > 1
							cSerial := oXMLPosRets:_SERIALRESPONSE:_SERIAL[nSerials]:TEXT
						elseif Ascan(aObjList,{|x| Upper(x[1]) == "_SERIAL" }) > 0
							cSerial := oXMLPosRets:_SERIALRESPONSE:_SERIAL:TEXT
						else
							cSerial := ""
							lSemSerial := .t.
						endif

						//checa se não foi utilizado o mesmo serial para itens diferentes do pedido de venda.
						if ascan( aFila,{|x| alltrim(x[2]) == alltrim(cPedido+cProduto+cLoteCTL+cSerial)})
							conout("Pedido: "+cPedido+" Produto: "+cProduto+" LoteCTL: "+cLoteCTL+" Serial: "+cSerial)
							loop
						elseif nQtdeItem <= 0
							exit
						else
							aadd(aFila, {cPedido+cProduto+cLoteCTL,;
										cPedido+cProduto+cLoteCTL+cSerial})
							nQtdeItem--
						endif
						/*cStmt := "UPDATE " + RetSQLName("SC9") + " SET D_E_L_E_T_ = '*' WHERE C9_FILIAL = '" + QSC6->C6_FILIAL
						cStmt += "' AND C9_PEDIDO = '" + QSC6->C6_NUM + "' AND C9_ITEM = '" + QSC6->C6_ITEM
						cStmt += "' AND C9_PRODUTO = '" + QSC6->C6_PRODUTO + "' AND D_E_L_E_T_ = '' "
						TCSQLEXEC(cStmt)*/

						// tratamento da SC9 de acordo com picking do WMS

						RecLock("SC9",.T.)
						SC9->C9_FILIAL  := xFilial("SC9")
						SC9->C9_PEDIDO  := SC6->C6_NUM
						SC9->C9_ITEM    := SC6->C6_ITEM
						SC9->C9_SEQUEN  := cC9Seq
						SC9->C9_PRODUTO := SC6->C6_PRODUTO
						SC9->C9_CLIENTE := SC6->C6_CLI
						SC9->C9_LOJA    := SC6->C6_LOJA
						SC9->C9_PRCVEN  := SC6->C6_PRCVEN
						SC9->C9_DATALIB := dDataBase
						SC9->C9_LOTECTL := cLoteCTL
						SC9->C9_SPKSER  := cSerial
						SC9->C9_QTDLIB  := iif(!empty(cSerial),1,nQtdLib)
						SC9->C9_QTDLIB2 := iif(!empty(cSerial),1,nQtdLib)
						SC9->C9_DTVALID := Posicione("SB8",3, xFilial("SB8")+ SC6->C6_PRODUTO+SC6->C6_LOCAL+RetCampo("B8_LOTECTL",cLoteCTL),"B8_DTVALID")
						SC9->C9_BLCRED  := cBlCred
						SC9->C9_BLEST   := cBlEst
						SC9->C9_AGREG  := &(SuperGetMv("MV_AGREG"))
						SC9->C9_GRUPO  := &(SuperGetMv("MV_GRUPFAT"))
						//SC9->C9_IDENTB6:= cIdentB6
						SC9->C9_LOCAL  := SC6->C6_LOCAL
						SC9->C9_SERVIC := SC6->C6_SERVIC
						SC9->C9_PROJPMS:= SC6->C6_PROJPMS
						SC9->C9_TASKPMS:= SC6->C6_TASKPMS
						SC9->C9_LICITA := SC6->C6_LICITA
						SC9->C9_TPCARGA:= SC5->C5_TPCARGA
						SC9->C9_ENDPAD := SC6->C6_ENDPAD
						MSUnlock()

						AtuB8Emp(SC9->C9_PRODUTO,SC9->C9_LOCAL,RetCampo("B8_LOTECTL",cLoteCTL),SC9->C9_QTDLIB,"+")

						cC9Seq := Soma1(cC9Seq)

						If (!lSemSerial .and. empty(cSerial)).or. empty(cLoteCTL)
							lret := .f.

							conout("---------------------------------- INCONSISTENCIA----------------")
							conout(cMsg)
							conout("-----------------RESPOSTA DO WEBSERVICE -------------------------")
							VarInfo("XML-RESPONSE",oxml)
							if !lprepare
								MsgAlert("O processo de Preparação NF de saída foi abortado por inconsistencias no lote/serial.")
							endif
						endif
						// 1 - Transmitido
						// 2 - Rejeitado
						//conout("fim da transacao")
					Next //nMaxSerials
					oXMLPosRets := nil
				Next //nMaxPos
				oXMLRets := nil
			Next //nMaxRets
			if !CheckSC9SPK(QSC6->C6_NUM,QSC6->C6_ITEM)
				if !lprepare
					MsgAlert("Há inconsistencias no Lote e/ou Número de Serie")
				endif
				lret :=  .f.
			endif
			if lRet
				ZX4->(DBGoto(QSC6->RECZX4))
				RecLock("ZX4",.F.)
				ZX4->ZX4_STATUS := "1" // Tramisitido
				//ZX4->ZX4_CHVRET := cChvRet
				MSUnlock()
			else
				disarmtransaction()
				if !lPrepare
					DBSelectArea("QSC6")
					DBCloseArea()
					RestArea(aSC6area)
					return lret
				endif
			end
		END TRANSACTION
		//conout("dentro do laco")
		DBSelectArea("QSC6")
		DBSkip()
	End //While

	if !CheckZX4SPK(cPedido)
		if !lprepare
			MsgInfo("É necessario processar a preparação de NF novamente.")
		endif
		lret :=  .f.
	endif

	IF lPrepare
		conout(time() + "  JOB " + procname() + " foi executado com sucesso.")

		RESET ENVIRONMENT
	endif

	If Select("QSC6") <> 0
		DBSelectArea("QSC6")
		DBCloseArea()
	Endif
	RestArea(aSC6area)
return lret

/*/{Protheus.doc} incluiZX4
Função Inclui registro para processar as funções correspodentes do JOB.

@param cEntidade: nome da entidade de processamento.
@param cChave: composicao da chave do registro
@param nRecOri: numero do recno de origem vinculado a entidade.
@return lógico.

@author Carlos Galimberti
@since 09/10/2019
@version P12.1.17
/*/

User function IncluiZX4(cEntidade,cChave,nRecOri)

	Reclock("ZX4",.T.)
	ZX4->ZX4_FILIAL := xFilial("ZX4")
	ZX4->ZX4_ENT    := cEntidade
	ZX4->ZX4_CHAVE  := cChave
	ZX4->ZX4_RECORI := nRecOri
	MSUnlock()

return

/*/{Protheus.doc} wmsWsFinishOrder
Função gerar as liberações do pedido de acordo com o lote obtido pelo SPARK WMS

@param cSc6REC: Recno de referencia para gerar a liberação no SC9
@param cLoteCTL: Numero do lote obtido pelo SPARK.
@param cSerial: Numero de serie obtido pelo SPARK.
@param cC9Seq: Sequencial do item do pedido+item na tabela SC9.
@return lógico.

@author Carlos Galimberti
@since 09/10/2019
@version P12.1.17
/*/
Static function GravaSC9Lote(nSC6rec,cLoteCTL,cSerial,cC9Seq)
	DBSelectArea("SC6")
	DBGoto( nSC6rec )

	// tratamento da SC9 de acordo com picking do WMS
	DBSelectArea("SC9")
	DBSetOrder(1)
	IF DBSeek(SC6->C6_FILIAL+SC6->C6_NUM + SC6->C6_ITEM +cC9Seq + SC6->C6_PRODUTO)

		AtuB8Emp(SC9->C9_PRODUTO,SC9->C9_LOCAL,SC9->C9_LOTECTL,SC9->C9_QTDLIB,"-")
		RecLock("SC9",.F.)
	Else
		RecLock("SC9",.T.)
	Endif

	SC9->C9_FILIAL := xFilial("SC9")
	SC9->C9_PEDIDO := SC6->C6_NUM
	SC9->C9_ITEM    := SC6->C6_ITEM
	SC9->C9_SEQUEN  := cC9Seq
	SC9->C9_PRODUTO := SC6->C6_PRODUTO
	SC9->C9_CLIENTE := SC6->C6_CLI
	SC9->C9_LOJA    := SC6->C6_LOJA
	SC9->C9_PRCVEN  := SC6->C6_PRCVEN
	SC9->C9_DATALIB := dDataBase
	SC9->C9_LOTECTL := cLoteCTL
	SC9->C9_SPKSER  := cSerial
	SC9->C9_QTDLIB  := 1
	SC9->C9_QTDLIB2 := 1
	SC9->C9_DTVALID := Posicione("SB8",3, xFilial("SB8")+ SC6->C6_PRODUTO+SC6->C6_LOCAL+RetCampo("B8_LOTECTL",cLoteCTL),"B8_DTVALID")
	//SC9->C9_BLCRED  := ""
	//SC9->C9_BLEST   := ""
	SC9->C9_AGREG  := &(SuperGetMv("MV_AGREG"))
	SC9->C9_GRUPO  := &(SuperGetMv("MV_GRUPFAT"))
	//SC9->C9_IDENTB6:= cIdentB6
	SC9->C9_LOCAL  := SC6->C6_LOCAL
	SC9->C9_SERVIC := SC6->C6_SERVIC
	SC9->C9_PROJPMS:= SC6->C6_PROJPMS
	SC9->C9_TASKPMS:= SC6->C6_TASKPMS
	SC9->C9_LICITA := SC6->C6_LICITA
	SC9->C9_TPCARGA:= SC5->C5_TPCARGA
	SC9->C9_ENDPAD := SC6->C6_ENDPAD
	MSUnlock()
	AtuB8Emp(SC9->C9_PRODUTO,SC9->C9_LOCAL,SC9->C9_LOTECTL,SC9->C9_QTDLIB,"+")

	cC9Seq := Soma1(cC9Seq)

return cC9Seq

/*/{Protheus.doc} AtuB8Emp
Função para atualizar o saldo do campo B8_EMPENHO

@param cProduto: Código do Produto
@param cLocal: Armezem do Produto
@param cLoteCTL: Numero do Lote do Produto.
@param nQtd: Quantidade para movimentação.
@param cOper: Informa se a operação é soma ou substracao.
@return lógico.

@author Carlos Galimberti
@since 09/10/2019
@version P12.1.17
/*/

Static Function AtuB8Emp(cProduto,cLocal,cLotectl,nQtd,cOper)
	Local lRet := .f.
	Local aArea := GetArea()

	DBSelectArea("SB8")
	DBSetOrder(3)
	IF DBSeek( xFilial("SB8")+ cProduto + cLocal + cLoteCTL)
		Reclock("SB8",.F.)
		IF cOper == "-"
			SB8->B8_EMPENHO := iif(SB8->B8_EMPENHO <= 0, 0,SB8->B8_EMPENHO - nQtd)
		ELSE
			SB8->B8_EMPENHO := iif(SB8->B8_EMPENHO < 0, 0,SB8->B8_EMPENHO + nQtd)
		ENDIF
		MsUnlock()
	Endif

	RestArea(aArea)
return lRet

/*/{Protheus.doc} updComments
Função para atribuir na tag Comment em wswmsstarttask as informações dos dados do cliente, transportadora e origem do cliente

@param cTransp: Código da transportadora
@param cCliente: Código do Cliente
@param cLoja: Loja do cliente.
@return string.

@author Carlos Galimberti
@since 09/10/2019
@version P12.1.17
/*/

Static Function UpdComments(cTransp,cCliente,cLoja,cMensagem)
	Local cString

	cString := "TRANSP: " + alltrim(Posicione("SA4",1, xFilial("SA4")+ cTransp,"A4_NOME"))
	cString += ";CONSUMIDOR: " + alltrim(Posicione("SA1",1, xFilial("SA1")+ cCliente + cLoja, "A1_NOME"))
	cString += ";END: " + alltrim(Posicione("SA1",1, xFilial("SA1")+ cCliente + cLoja, "A1_END"))
	cString += ";CID: " + alltrim(Posicione("SA1",1, xFilial("SA1")+ cCliente + cLoja, "A1_MUN"))
	cString += ";CEP: " + alltrim(Posicione("SA1",1, xFilial("SA1")+ cCliente + cLoja, "A1_CEP"))
	cString += ";" + alltrim(cMensagem)
	cString += ";"

Return cString

/*/{Protheus.doc} updComments
Função para atribuir na tag Comment em wsavisoreceb as informações dos dados do fornecedor para compor a etiqueta do WMS.

@param cFornece: código do fornecedor
@param cLoja: Loja do Fornecedor.
@param cProduto: Código do Produto
@return string.

@author Carlos Galimberti
@since 09/10/2019
@version P12.1.17
/*/

Static Function GetTagInfo(cFornece,cLoja,cProduto,cTipo)
	Local cString
	If !cTipo $ 'DB'
		cString :=  "FAB:" + alltrim(Posicione("SA2",1, xFilial("SA2")+ alltrim(Posicione("SB1",1, xFilial("SB1")+ cProduto,"B1_PROC")),"A2_NOME"))
		cString +=  ";CNPJ:"+ alltrim(Posicione("SA2",1, xFilial("SA2")+ alltrim(Posicione("SB1",1, xFilial("SB1")+ cProduto,"B1_PROC")),"A2_CGC"))
	else
		cString :=  "FAB:" + alltrim(Posicione("SA2",1, xFilial("SA2")+ alltrim(Posicione("SB1",1, xFilial("SB1")+ cProduto,"B1_PROC")),"A2_NOME"))
		cString +=  ";CNPJ:"+ alltrim(Posicione("SA2",1, xFilial("SA2")+ alltrim(Posicione("SB1",1, xFilial("SB1")+ cProduto,"B1_PROC")),"A2_CGC"))
	endif

	cString +=  ";ANV:" + alltrim(Posicione("SB1",1, xFilial("SB1")+ cProduto,"B1_RMS"))
	cString +=  ";" //"FORNECEDOR PADRAO:" + alltrim(Posicione("SB1",1, xFilial("SB1")+ cProduto,"B1_PROC"))

Return cString

User Function UpdGoodsToSPK(lPrepare)
	//Default lPrepare := .t.
	Local cAliasQry := "QSB1"
	Local cQuery
	Local cRotina   := FunName()
	Local   cURLSpark   := nil
	Local   cLgnSpark   := nil
	Local   cPswSpark   := nil
	conout("VALTYPE LPREPARE:" +valtype(lprepare))

	if valtype(lPrepare) <> "L"
		lPrepare := .t.
	endif
	if lprepare
		RPCSetType(3)
		Prepare Environment Empresa "01" Filial "01" Modulo "FAT" FUNNAME cRotina
	endif

	cURLSpark   := SuperGetMV("MV_URLSPAR",.F.,"http://100.27.32.87:8080")
	cLgnSpark   := SuperGetMV("MV_LGNSPARK",.F.,"admin")
	cPswSpark   := SuperGetMV("MV_PSWSPARK",.F.,"spk123#")

	cQuery :=  "SELECT SUBSTRING(ZX4_CHAVE,1,2) B1_FILIAL, SUBSTRING(ZX4_CHAVE,3,15) B1_COD, B1_DESC,B1_ESTSEG,B1_RASTRO,  "
	cQuery +=  " B1_UM, B1_CODBAR, B1_GRUPO,ZX4_RECORI,ZX4_ENT,ZX4_CHAVE, ZX4.R_E_C_N_O_ RECZX4 FROM "
	cQuery +=  RetSQLName("SB1") + " SB1, " + RetSQLName("ZX4") + " ZX4 WHERE SB1.D_E_L_E_T_ = '' AND ZX4.D_E_L_E_T_ = '' "
	//cQuery +=  "   AND B1_FILIAL = ZX4_FILIAL "
	cQuery +=  "   AND ZX4_ENT = 'SB1' "

	cQuery +=  "   AND ZX4_STATUS IN (' ','2') "
	cQuery +=  "   AND B1_FILIAL = SUBSTRING(ZX4_CHAVE,1,2) "
	cQuery +=  "   AND B1_COD = SUBSTRING(ZX4_CHAVE,3,15) "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

	DBSelectArea("QSB1")
	DBGotop()

	While !eof()

		oWsdl := TWsdlManager():New()
		oWsdl:nTimeout       := 120
		oWsdl:lverbose       := .t.
		oWsdl:SetAuthentication(cLgnSpark,cPswSpark)
		xRet := oWsdl:ParseURL(cURLSpark+"/webservice/ManageItemDataWSBean?wsdl")

		if xRet == .F.
			conout("Erro ParseURL: " + oWsdl:cError)
			Return
		endif

		// Define a operação
		lRet := oWsdl:SetOperation("updateItemData")
		If lRet == .F.
			conout("Erro SetOperation: " + oWsdl:cError)
			return
		EndIf
		conout( oWsdl:cCurrentOperation )

		// Lista os tipos simples da mensagem de input envolvida na operação
		/* aSimple := oWsdl:SimpleInput()
		varinfo( "", aSimple )
		*/

		cMsg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:man="http://manage_itemdata.ws.inventory.los.linogistix.de/">'
		cMsg += '<soapenv:Header/>'
		cMsg += '<soapenv:Body>'
		cMsg += '  <man:updateItemData>'
		cMsg += '       <!--Optional:-->'
		cMsg += '      <arg0>'
		cMsg += '          <clientNumber>Jomhedica</clientNumber>'
		cMsg += '         <name>'+trim(QSB1->B1_DESC)+'</name>'
		cMsg += '          <number>'+ trim(QSB1->B1_COD)+'</number>'
		cMsg += '         <!--Optional:-->'
		cMsg += '          <description>'+trim(QSB1->B1_DESC)+'</description>'
		cMsg += '          <safetyStock>'+trim(STR(QSB1->B1_ESTSEG))+'</safetyStock>'
		cMsg += '          <lotMandatory>'+ iif(!QSB1->B1_RASTRO $ " /N","true","false")+'</lotMandatory>'
		cMsg += '          <adviceMandatory>true</adviceMandatory>'
		cMsg += '          <!--Optional:-->'
		cMsg += '         <serialNoRecordType>GOODS_OUT_RECORD</serialNoRecordType>'
		cMsg += '         <handlingUnit>'+trim(QSB1->B1_UM)+'</handlingUnit>'
		cMsg += '          <scale>0</scale>'
		cMsg += '          <!--Zero or more repetitions:-->'
		cMsg += '          <eanCodes>'+trim(QSB1->B1_CODBAR)+'</eanCodes>'
		cMsg += '          <!--Optional:-->'
		cMsg += '          <zone>'+trim(QSB1->B1_GRUPO)+ '</zone>'
		cMsg += '          <height>0</height>'
		cMsg += '          <width>0</width>'
		cMsg += '          <depth>0</depth>'
		cMsg += '          <weight>0</weight>'
		cMsg += '          <volume>0</volume>'
		cMsg += '       </arg0>'
		cMsg += '    </man:updateItemData>'
		cMsg += '</soapenv:Body>'
		cMsg += '</soapenv:Envelope>'

		// Envia uma mensagem SOAP personalizada ao servidor
		lRet := oWsdl:SendSoapMsg( cMsg )
		If lRet == .F.
			GravaZX3("SB1","4",oWsdl:cFaultString,xFilial("SB1")+QSB1->B1_COD,cRotina)
			conout( "Erro SendSoapMsg: " + oWsdl:cError )
			conout( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
			//MSgInfo("Erro SendSoapMsg FaultCode: " + oWsdl:cFaultString )
			//Return
		Else

			cMsgRet := oWsdl:GetSoapResponse()
			conout( cMsgRet )

			GravaZX3("SB1","6",cMsgRet,xFilial("SB1")+QSB1->B1_COD,cRotina)

			DBSelectArea("ZX4")
			DBGoto(QSB1->RECZX4)
			RecLock("ZX4",.F.)
			ZX4->ZX4_STATUS := "1" // Tramisitido
			//ZX4->ZX4_CHVRET := cChvRet
			MSUnlock()
		Endif

		DBSelectArea("QSB1")
		DBSkip()

	Enddo
	dbclosearea()

	IF lPrepare
		conout(time() + "  JOB " + procname() + " foi executado com sucesso.")

		RESET ENVIRONMENT
	endif

return

Static Function CheckOrderStatus(cPedido)

	Local cURLSpark   := SuperGetMV("MV_URLSPAR",.F.,"http://100.27.32.87:8080")
	Local cLgnSpark   := SuperGetMV("MV_LGNSPARK",.F.,"admin")
	Local cPswSpark   := SuperGetMV("MV_PSWSPARK",.F.,"spk123#")
	Local lTem        := .f.
	Private cErro
	oWsdl := TWsdlManager():New()
	oWsdl:nTimeout       := 120
	oWsdl:lverbose       := .t.
	oWsdl:SetAuthentication(cLgnSpark,cPswSpark)

	xRet := oWsdl:ParseURL(cURLSpark+"/webservice/SparkManagerOrderBean?wsdl")

	if xRet == .F.
		conout("Erro ParseURL: " + oWsdl:cError)
		Return
	endif

	// Define a operação
	lRet := oWsdl:SetOperation("getOrderStatus")
	If lRet == .F.
		conout("Erro SetOperation: " + oWsdl:cError)
		return
	EndIf
	conout( oWsdl:cCurrentOperation )

	// Lista os tipos simples da mensagem de input envolvida na operação
	/* aSimple := oWsdl:SimpleInput()
	varinfo( "", aSimple )
	*/
	cMsg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:spar="http://spark_managerorder.ws.inventory.los.linogistix.de/">> '
	cMsg += '   <soapenv:Header/>'
	cMsg += '   <soapenv:Body>'
	cMsg += '      <spar:getOrderStatus>'
	cMsg += '         <!--Optional:-->'
	cMsg += '         <clientRef>Jomhedica</clientRef>'
	cMsg += '         <!--Optional:-->'
	cMsg += '         <externalNumber>'+cPedido+'</externalNumber>'
	cMsg += '      </spar:getOrderStatus>'
	cMsg += '   </soapenv:Body>'
	cMsg += '</soapenv:Envelope>'
	conout(cMsg)
	lRet := oWsdl:SendSoapMsg( cMsg )
	//if lRet
	//oxml := xmlParser(oWsdl:GetSoapResponse(),"_",@cError,@cWarn)
	oXML := XmlParser( oWsdl:GetSoapResponse() ,"_",@cErro,"" )
	__aObjXML := ClassDataArr(oXML)
	lTem := .f.
	//varinfo("",aObjXML)
	//oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETACEPTEDSTOCKTACKINGORDERRESPONSE:_RETURN
	If Ascan(__aObjXml,{|x| Upper(x[1]) $ "_SOAP_ENVELOPE" }) > 0
		__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE)

		If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_SOAP_BODY" }) > 0
			__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE:_SOAP_BODY)
			//getOrderStatusResponse
			If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_NS2_GETORDERSTATUSRESPONSE" }) > 0
				__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETORDERSTATUSRESPONSE)

				If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_RETURN" }) > 0
					lTem := .t.
				Endif
			Endif
		Endif
	endif
	if valtype(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETORDERSTATUSRESPONSE:_RETURN) == "O"
		nMaxRets := 1
	Else
		nMaxRets:= len(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETORDERSTATUSRESPONSE:_RETURN)

	Endif
	oXMLRets :=  oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETORDERSTATUSRESPONSE:_RETURN

	if lTem
		conout("STATUS: " + oXMLRets:_STATUS:TEXT )
		if oXMLRets:_STATUS:TEXT < "500"
			lret := .t.
		else
			if !lprepare
				MsgAlert("Não é possivel cancelar a ordem existente no SPARK, exclua manualmente e tente realizar a operação no Protheus novamente.")
			endif
		endif
	endif
Return lRet

Static Function SPKCancelOrder(cPedido)

	Local cURLSpark   := SuperGetMV("MV_URLSPAR",.F.,"http://100.27.32.87:8080")
	Local cLgnSpark   := SuperGetMV("MV_LGNSPARK",.F.,"admin")
	Local cPswSpark   := SuperGetMV("MV_PSWSPARK",.F.,"spk123#")
	Local lTem        := .f.

	oWsdl := TWsdlManager():New()
	oWsdl:nTimeout       := 120
	oWsdl:lverbose       := .t.
	oWsdl:SetAuthentication(cLgnSpark,cPswSpark)

	xRet := oWsdl:ParseURL(cURLSpark+"/webservice/SparkManagerOrderBean?wsdl")

	if xRet == .F.
		conout("Erro ParseURL: " + oWsdl:cError)
		Return
	endif

	// Define a operação
	lRet := oWsdl:SetOperation("finishOrder")
	If lRet == .F.
		conout("Erro SetOperation: " + oWsdl:cError)
		return
	EndIf
	conout( oWsdl:cCurrentOperation )

	// Lista os tipos simples da mensagem de input envolvida na operação
	/* aSimple := oWsdl:SimpleInput()
	varinfo( "", aSimple )
	*/
	cMsg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:spar="http://spark_managerorder.ws.inventory.los.linogistix.de/">'
	cMsg += '   <soapenv:Header/>'
	cMsg += '   <soapenv:Body>'
	cMsg += '      <spar:finishOrder>'
	cMsg += '         <!--Optional:-->'
	cMsg += '         <externalNumber>'+cPedido+'</externalNumber>'
	cMsg += '      </spar:finishOrder>'
	cMsg += '   </soapenv:Body>'
	cMsg += '</soapenv:Envelope>'

	conout(cMsg)
	lRet := oWsdl:SendSoapMsg( cMsg )
	if lRet
		//oxml := xmlParser(oWsdl:GetSoapResponse(),"_",@cError,@cWarn)
		oXML := XmlParser( oWsdl:GetSoapResponse() ,"_",@cErro,"" )
		__aObjXML := ClassDataArr(oXML)
		lTem := .f.
		//varinfo("",aObjXML)
		//oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_GETACEPTEDSTOCKTACKINGORDERRESPONSE:_RETURN
		If Ascan(__aObjXml,{|x| Upper(x[1]) $ "_SOAP_ENVELOPE" }) > 0
			__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE)

			If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_SOAP_BODY" }) > 0
				__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE:_SOAP_BODY)
				//finishOrderResponse
				If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_NS2_FINISHORDERRESPONSE" }) > 0
					__aObjXML := ClassDataArr(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_FINISHORDERRESPONSE)

					If Ascan(__aObjXML,{|x| Upper(x[1]) $ "_RETURN" }) > 0
						lTem := .t.
					Endif
				Endif
			Endif
		endif

		oXMLRets :=  oXML:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_FINISHORDERRESPONSE
		lret := .f.
		if lTem
			if Upper(oXMLRets:_RETURN:TEXT) = "TRUE"
				lret := .t.
			else
				lret := .f.
				if !lprepare
					MsgAlert("A tentativa de cancelamento da Ordem no SPARK falhou. Entrar em contato com responsavel para realizar manualmente.")
				endif
			endif
		endif
	endif
Return lRet

Static Function CheckSC9SPK(cPedido,cItem)
	Local aSC9area :=  SC9->(GetArea())
	Local lRet := .t.
	DBSelectArea("SC9")
	DBSetOrder(1)

	DBSeek( xFilial("SC9") + cPedido+cItem)
	SB1->( DBSetOrder(1))
	SB1->( DBSeek( xFilial("SB1") + SC9->C9_PRODUTO))
	SC6->( DBSetOrder(1))
	SC6->( DBSeek( xFilial("SC6") + cPedido + cItem))

	SF4->( DBSetOrder(1))
	SF4->( DBSeek( xFilial("SF4") + SC6->C6_TES ))

	DBSelectArea("SC9")
	While !eof() .and. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9") + cPedido .and. SC9->C9_ITEM = cItem

		SB1->( DBSetOrder(1))
		SB1->( DBSeek( xFilial("SB1") + SC9->C9_PRODUTO))
		SC6->( DBSetOrder(1))
		SC6->( DBSeek( xFilial("SC6") + cPedido + cItem))

		if SC9->C9_BLEST == "02" .or. alltrim(SC9->C9_BLCRED) <> ''
			lret := .f.
		endif
		if empty(SC9->C9_LOTECTL) .and. !SB1->B1_RASTRO $ "N/ " .and. SF4->F4_ESTOQUE == "S" //.and. Empty(SC9->C9_SPKSER)
			lret := .f.
		endif

		DBSelectArea("SC9")
		DBSkip()
	Enddo

	RestArea( aSC9area)
Return lRet

Static Function CheckZX4SPK(cPedido)
	lRet := .t.
	cQuery :=  "SELECT SUBSTRING(ZX4_CHAVE,1,2) C6_FILIAL, SUBSTRING(ZX4_CHAVE,3,6) C6_NUM, SUBSTRING(ZX4_CHAVE,9,2) C6_ITEM, SUBSTRING(ZX4_CHAVE,11,15) C6_PRODUTO, "
	cQuery +=  " C6_ENVSEP,C6_LOCAL,  ZX4_RECORI,ZX4_ENT,ZX4_CHAVE, ZX4.R_E_C_N_O_ RECZX4 FROM "
	cQuery +=  RetSQLName("SC6") + " SC6, " + RetSQLName("ZX4") + " ZX4 WHERE SC6.D_E_L_E_T_ = '' AND ZX4.D_E_L_E_T_ = '' "
	cQuery +=  "   AND C6_FILIAL = ZX4_FILIAL "
	cQuery +=  "   AND ZX4_ENT = 'SC6' "
	if !empty(alltrim(cPedido))
		cQuery +=  "   AND SUBSTRING(ZX4_CHAVE,1,2) LIKE '%" + xFilial("SC6") + "%' "
		cQuery +=  "   AND SUBSTRING(ZX4_CHAVE,3,6) LIKE '%" + cPedido + "%' "
	endif
	cQuery +=  "   AND ZX4_STATUS IN (' ','2') "
	cQuery +=  "   AND C6_FILIAL = SUBSTRING(ZX4_CHAVE,1,2) "
	cQuery +=  "   AND C6_NUM = SUBSTRING(ZX4_CHAVE,3,6) "
	cQuery +=  "   AND C6_ITEM = SUBSTRING(ZX4_CHAVE,9,2) "
	cQuery +=  "   AND C6_PRODUTO = SUBSTRING(ZX4_CHAVE,11,15) "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"zx4check",.T.,.T.)
	dbgotop()
	IF !eof()
		lret := .f.
	endif
	ZX4CHECK->( DBClosearea())

return lRet