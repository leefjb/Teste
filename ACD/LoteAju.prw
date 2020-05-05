#INCLUDE "RWMAKE.CH"
#INCLUDE "Topconn.ch"
#Include "Protheus.ch"


/*/{Protheus.doc} LoteAju
//Intergacao tabela de Lote SB8 para ID de Etiquetas CB0 - Lote unitario
@author Celso Rene
@since 15/10/2018
@version 1.0
@type function
/*/
User Function xLoteAju()

	Local _cQuery   := ""
	Local _cDoc	    := _cSerie := _cCliente := _cLoja := _cPedido := ""
	Local _nTamDoc  := _nTamSer := _nTamCli := _nTamLoj := _nTamPed := 0
	Local _cLotectl	:= ""


	If (Select("TSB8") <> 0)
		TSB8->(dbCloseArea())
	Endif

	_cquery := " SELECT * FROM (
	_cquery += " SELECT SB8.* ,ISNULL(CB0.CB0_CODETI,'') AS ETIQ " + chr(13)
	_cquery += " FROM " + RetSqlName("SB8") + " SB8 " + chr(13)
	_cquery += " LEFT JOIN " + RetSqlName("CB0") + " CB0 ON CB0.D_E_L_E_T_='' AND CB0.CB0_CODETI = SB8.B8_LOTECTL " + chr(13) 
	_cquery += " WHERE SB8.D_E_L_E_T_ = '' AND SB8.B8_LOCAL = '01' AND SB8.B8_DATA BETWEEN '20160101' AND '20191231' AND SB8.B8_QTDORI = 1 AND (SB8.B8_LOTEUNI = 'S' OR SB8.B8_QTDORI = 1 )" + chr(13)
	_cquery += "   ) AS TAB WHERE ETIQ = '' "
	
	TcQuery _cQuery Alias "TSB8" New	


	///*
	DbSelectArea("TSB8")
	While ( !TSB8->(Eof()) )


		dbSelectArea("CB0")
		dbSetOrder(1)
		If ( ! dbSeek(xFilial("CB0") +  TSB8->B8_LOTECTL)  )
		
			dbSelectArea("CB0")
			RecLock("CB0",.T.)

			CB0->CB0_FILIAL		:= TSB8->B8_FILIAL	 	
			CB0->CB0_CODETI		:= TSB8->B8_LOTECTL
			CB0->CB0_DTNASC		:= StoD(TSB8->B8_DATA)
			CB0->CB0_TIPO		:= "01"
			CB0->CB0_CODPRO		:= TSB8->B8_PRODUTO
			CB0->CB0_QTDE		:= 1 //TSB8->B8_QTDORI
			CB0->CB0_USUARI		:= ""  //RetCodUsr()
			//CB0->CB0_DISPID		:= 
			CB0->CB0_LOCAL		:= TSB8->B8_LOCAL
			//CB0->CB0_LOCALI		:= ""
			CB0->CB0_LOTE		:= TSB8->B8_LOTECTL
			CB0->CB0_SLOTE		:= TSB8->B8_NUMLOTE
			CB0->CB0_DTVLD		:= StoD(TSB8->B8_DTVALID)
			CB0->CB0_OP			:= ""
			//CB0->CB0_NUMSEQ		:= 
			//CB0->CB0_CODET2		:=
			//CB0->CB0_ENDSUG		:=
			CB0->CB0_FORNEC		:= TSB8->B8_FORORI
			CB0->CB0_LOJAFO		:= TSB8->B8_LOJORI
			//CB0->CB0_PEDCOM		:=
			CB0->CB0_NFENT		:= TSB8->B8_DOCORI
			CB0->CB0_SERIEE		:= TSB8->B8_SERORI

			////_nTamDoc			:= TamSx3("F2_DOC")[1]
			////_nTamSer			:= TamSx3("F2_SERIE")[1]
			////_nTamCli			:= TamSx3("F2_CLIENTE")[1]
			////_nTamLoj			:= TamSx3("F2_LOJA")[1]
			////_nTamPed			:= TamSx3("C5_NUM")[1]

			////_cDoc				:= SubStr(TSB8->DOCUM,1,_nTamDoc)		
			////_cSerie				:= SubStr(TSB8->DOCUM,1 + _nTamDoc ,_nTamSer)	
			////_cliente			:= SubStr(TSB8->DOCUM,1 +_nTamDoc + _nTamSer,_nTamCli)
			////_cLoja				:= SubStr(TSB8->DOCUM,1 +_nTamDoc + _nTamSer + _nTamCli,_nTamLoj)
			////_cPedido			:= SubStr(TSB8->DOCUM,1 +_nTamDoc + _nTamSer + _nTamCli + _nTamLoj , _nTamPed)

			////CB0->CB0_NFSAI		:= _cDoc
			////CB0->CB0_SERIES		:= _cSerie
			////CB0->CB0_CLI		:= _cliente
			////CB0->CB0_LOJACL		:= _cLoja
			////CB0->CB0_PEDVEN		:= _cPedido
			
			
			//CB0->CB0_VOLUME		:= 
			//CB0->CB0_TRANSP		:=
			//CB0->CB0_STATUS		:= 
			//CB0->CB0_LOCORI		:=
			//CB0->CB0_CC			:= "" //TSB8->D1_CC
			//CB0->CB0_PALLET		:=
			//CB0->CB0_OPREQ		:=
			//CB0->CB0_NUMSER		:=
			CB0->CB0_ORIGEM		:= TSB8->B8_ORIGLAN
			//CB0->CB0_ITNFE		:=
			//CB0->CB0_SDOCS		:=
			//CB0->CB0_SDOCE		:=

			CB0->CB0_XIMP		:= "S"
			CB0->CB0_LOTEFO		:= TSB8->B8_LOTEFOR

			CB0->(MsUnLock())
			
			_cLotectl 			:= TSB8->B8_LOTECTL


		EndIf



		dbSelectArea("TSB8")	
		TSB8->(dbSkip())

	EndDo 
	
	

	TSB8->(dbCloseArea())


Return()
