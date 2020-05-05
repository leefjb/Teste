#Include "Protheus.ch"
#Include "Rwmake.ch"
#INCLUDE "tbiconn.ch"
#Include "topconn.ch"

/*/{Protheus.doc} ACD166FI
//Ponto de entrada apos a separacao
@author Celso Rene
@since 29/11/2018
@version 1.0
@type function
/*/
User Function ACD166FI()


	Local   _aArea 		:= GetArea()
	Local   _cQuery		:= ""

	Private _lSepTot	:= .T.
	Private _cSeq 		:= "01"      
	

	//erro variavel nao existe em algumas separacoes
	//If Type("cOrdSep")=="U"
		///Private cOrdSep :=  CB7->CB7_ORDSEP //Space(6)
	//EndIf


	//verificando se o status da Ord sep esta em aberto
	If ( CB7->CB7_STATUS <> "0"  ) //CB7->CB7_STATUS <> "9" 
		RestArea(_aArea)
		Return()
	EndIf


	//grando os dados de separacao na liberacao do pedido de vendas
	dbSelectArea("CB8")
	dbSetOrder(2) //CB8_FILIAL+CB8_PEDIDO+CB8_ITEM+CB8_SEQUEN+CB8_PROD
	dbSeek( xFilial("CB8") + CB7->CB7_PEDIDO )
	If ( Found() ) 

		///*
		dbSelectArea("SC9")
		dbSetOrder(1) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
		dbSeek(xFilial("SC9")+ CB8->CB8_PEDIDO ) //+ CB8->CB8_ITEM + CB8->CB8_SEQUEN + CB8->CB8_PROD 
		If ( Found() )
			While ( !SC9->(EOF()) .AND. SC9->C9_PEDIDO == CB8->CB8_PEDIDO  ) //.and. SC9->C9_ITEM == CB8->CB8_ITEM .and. SC9->C9_SEQUEN == CB8->CB8_SEQUEN .and. SC9->C9_PRODUTO == CB8->CB8_PROD
			

				//atualizando reserva - bloqueio lote sugerido - problema funcao padrao Separacao x SC9
				/*dbSelectArea("SB2")
				dbSetOrder(1) //B2_FILIAL+B2_COD+B2_LOCAL                                                                                                                                       
				dbSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL )					
				If ( Found() .and. SB2->B2_RESERVA >= SC9->C9_QTDLIB )
					dbSelectArea("SB2")
					RECLOCK("SB2",.F.)
					SB2->B2_RESERVA := SB2->B2_RESERVA - SC9->C9_QTDLIB
					SB2->(MsUnlock())
				EndIf */


				dbselectARea("SB8")
				dbSetOrder(5) //B8_FILIAL+B8_PRODUTO+B8_LOTECTL
				dbSeek(xFilial("SB8") + SC9->C9_PRODUTO + SC9->C9_LOTECTL)
				If ( Found() .and. SB8->B8_EMPENHO >= SC9->C9_QTDLIB .AND. SC9->C9_ORDSEP == CB8->CB8_ORDSEP  )

					dbSelectArea("SB8")
					RECLOCK("SB8",.F.)
					SB8->B8_EMPENHO := SB8->B8_EMPENHO - SC9->C9_QTDLIB
					SB8->(MsUnlock())

				EndIf

				//dbSelectArea("SC9")
				//RECLOCK("SC9",.F.)
				//dbDelete()
				//SC9->(MsUnlock())

				SC9->(dBSkip())  

			EndDo

		EndIf
//*/
		TCSqlExec(" DELETE " + RetSqlName("SC9" ) + " WHERE C9_PEDIDO = '" + CB8->CB8_PEDIDO + "' AND C9_ORDSEP = '" + CB8->CB8_ORDSEP + "' ")		
		//TCSqlExec("UPDATE " + RetSqlName("SC9" ) + " SET D_E_L_E_T_ = '*' WHERE C9_PEDIDO = '" + CB8->CB8_PEDIDO + "' AND D_E_L_E_T_= '' ")


		While ( ! CB8->(EOF()) .AND. CB8->CB8_PEDIDO == CB7->CB7_PEDIDO )

			PedidoConf(CB8->CB8_PEDIDO + CB8->CB8_ITEM)

			//xVerSC9()

			dbSelectArea("CB8")
			CB8->(dBSkip())    

		EndDo  

	EndIf


	xVerSC9() //gera SC9 problema na geracao no padrao


	If (_lSepTot == .T.) 
		dbSelectArea("SC5")
		dbSetOrder(1)
		If ( dbSeek(xFilial("SC5") + CB7->CB7_PEDIDO ) )
			RECLOCK("SC5",.F.)
			SC5->C5_PVSTAT := "059"
			SC5->(MsUnlock())
		EndIf
	Else
		dbSelectArea("SC5")
		dbSetOrder(1)
		If ( dbSeek(xFilial("SC5") + CB7->CB7_PEDIDO ) )
			RECLOCK("SC5",.F.)
			SC5->C5_PVSTAT := "010"
			SC5->(MsUnlock())
		EndIf
	EndIf


	RestArea(_aArea)


Return()



/*/{Protheus.doc} PedidoConf
@author Celso Rene
@since 19/02/2019
@version 1.0
@type function
/*/
Static Function PedidoConf(_cPV)

	//Local _aAreaSC6 := GetArea()

	//Atualizando pedido de venda
	dbSelectArea("SC6")
	dbSetOrder(1) 
	dbGoTop()                                                                                                                                                                                                                     
	dbSeek( xFilial("SC6") + _cPV )
	If ( Found() )

		While ( ! SC6->(EOF()) .AND. SC6->C6_NUM + SC6->C6_ITEM = _cPV )


			//_cQuery := " SELECT ISNULL(SUM(C9_QTDSEP),0) QTDSEP FROM " + RetSqlName("SC9") + " WHERE D_E_L_E_T_ = '' " + chr(13)
			//_cQuery += " AND C9_PEDIDO = '" + SC6->C6_NUM + "' AND C9_ITEM = '" + SC6->C6_ITEM + "' AND C9_PRODUTO = '" + SC6->C6_PRODUTO + "' AND C9_FILIAL = '" + xFilial("SC9") + "' "

			_cQuery := " SELECT ISNULL(SUM(CB9_QTESEP),0) QTESEP FROM " + RetSqlName("CB9") + " " + chr(13)
			_cQuery += " WHERE CB9_PEDIDO = '" + SC6->C6_NUM + "' AND CB9_PROD = '" + SC6->C6_PRODUTO + "' " + chr(13)
			_cQuery += " AND CB9_ITESEP = '" + SC6->C6_ITEM + "' AND D_E_L_E_T_ = '' "

			If (Select("TMP") <> 0)
				TMP->(dbCloseArea())
			Endif

			TcQuery _cQuery Alias "TMP" New

			DbSelectArea("TMP")	
			If (!TMP->(Eof()) ) 

				RECLOCK("SC6",.F.)
				SC6->C6_QTDSEP 	:= TMP->QTESEP
				//SC6->C6_QTDLIB := TMP->QTESEP
				SC6->C6_QTDCONF := 0 
				SC6->C6_QTDEMP 	:= TMP->QTESEP 
				SC6->(MsUnlock())

				If (SC6->C6_QTDSEP < SC6->C6_QTDVEN) 
					_lSepTot := .F.
				EndIf

			EndIf

			TMP->(dbCloseArea())

			dbSelectArea("SC6")
			SC6->(dBSkip()) 

		EndDo


	EndIf


	//RestArea(_aAreaSC6)


Return() 


/*/{Protheus.doc} xVerSC9
//SC9 - conforme itens separados
@author Celso Rene
@since 19/02/2019
@version 1.0
@type function
/*/
Static Function xVerSC9()


	//_cQryCB9 := " SELECT CB9_ORDSEP,CB9_PEDIDO, SUM(CB9_QTESEP) AS CB9_QTESEP ,CB9_PROD, CB9_ITESEP,CB9_SEQUEN , CB9_LOTECT , CB9_LOCAL "
	//_cQryCB9 += " FROM " + RetSqlName("CB9") + " WHERE CB9_PEDIDO = '" + CB7->CB7_PEDIDO + "' AND CB9_PROD = '" + CB7->CB_PROD + "' AND D_E_L_E_T_='' AND CB9_ITESEP = '" + CB8->CB8_ITEM + "' AND CB9_SEQUEN = '" + CB8->CB8_SEQUEN + "' " + chr(13)
	//_cQryCB9 += " GROUP BY CB9_ORDSEP,CB9_PEDIDO, CB9_PROD, CB9_ITESEP,CB9_SEQUEN,CB9_LOTECT,CB9_LOCAL "
	//_cQryCB9 += " ORDER BY CB9_ITESEP, CB9_SEQUEN , CB9_LOTECT"

	_cQryCB9 := " SELECT CB9_ORDSEP,CB9_PEDIDO, CB9_QTESEP ,CB9_PROD, CB9_ITESEP , CB9_LOTECT , CB9_LOCAL "
	_cQryCB9 += " FROM " + RetSqlName("CB9") + " WHERE CB9_ORDSEP = '" + CB7->CB7_ORDSEP + "' AND CB9_PEDIDO = '" + CB7->CB7_PEDIDO + "' AND D_E_L_E_T_ = '' " + chr(13)
	//_cQryCB9 += " GROUP BY CB9_ORDSEP,CB9_PEDIDO, CB9_ITESEP, CB9_PROD ,CB9_LOTECT,CB9_LOCAL "
	_cQryCB9 += " ORDER BY CB9_ORDSEP,CB9_PEDIDO, CB9_ITESEP, CB9_PROD ,CB9_LOTECT,CB9_LOCAL "

	If (Select("TMP2") <> 0)
		TMP2->(dbCloseArea())
	Endif

	_nSeq := "01"

	TcQuery _cQryCB9 Alias "TMP2" New

	DbSelectArea("TMP2")	
	If (!TMP2->(Eof()) )


		//_cSeq := "00"//CB8->CB8_SEQUEN
		While ( !TMP2->(EOF()) ) 


			_cQrySc9 := " SELECT ISNULL(MAX(C9_SEQUEN),'00') AS SEQ  FROM " + RetSqlName("SC9") + " WITH (NOLOCK) WHERE C9_PEDIDO = '" + CB7->CB7_PEDIDO + "' AND C9_ITEM = '"  + TMP2->CB9_ITESEP + "' AND C9_PRODUTO = '" + TMP2->CB9_PROD + "' "
			If (Select("TMP3") <> 0)
				TMP3->(dbCloseArea())
			Endif

			TcQuery _cQrySc9 Alias "TMP3" New

			DbSelectArea("TMP3")	
			If (!TMP3->(Eof()) )
				_nSeq := Soma1(TMP3->SEQ)
			ENdIf

			TMP3->(dbCloseArea())

			dbSelectArea("SC6")
			dbSetOrder(1) 
			dbGoTop()                                                                                                                                                                                                                     
			dbSeek( xFilial("SC6") + CB7->CB7_PEDIDO + TMP2->CB9_ITESEP  )


			/*dbSelectArea("SC9")
			dbSetOrder(1)  //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
			dbSeek(xFilial("SC9") + CB8->CB8_PEDIDO + CB8->CB8_ITEM + CB8->CB8_SEQUEN + CB8->CB8_PROD )
			If ( Found() )
			For _x:= 1 to 50
			_nSeq := _nSeq + 1 
			dbSelectArea("SC9")
			dbSetOrder(1)  //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
			dbSeek(xFilial("SC9") + CB8->CB8_PEDIDO + CB8->CB8_ITEM + _nSeq + TMP2->CB9_PROD )
			If ( ! Found() )
			_x:= 51
			EndIf
			Next _x
			EndIf */


			dbSelectArea("SC9")
			RECLOCK("SC9",.T.)

			SC9->C9_FILIAL	:= xFilial("SC9")
			SC9->C9_PEDIDO 	:= CB7->CB7_PEDIDO
			SC9->C9_ITEM	:= TMP2->CB9_ITESEP	
			SC9->C9_CLIENTE	:= CB7->CB7_CLIENT
			SC9->C9_LOJA	:= CB7->CB7_LOJA	
			SC9->C9_PRODUTO	:= TMP2->CB9_PROD
			SC9->C9_QTDLIB	:= TMP2->CB9_QTESEP
			SC9->C9_DATALIB	:= CB7->CB7_DTFIMS //dDataBase                                                                                                                                                                                           

			SC9->C9_SEQUEN	:= _nSeq //TMP2->CB9_SEQUEN

			SC9->C9_GRUPO	:= "0001"
			SC9->C9_PRCVEN	:= SC6->C6_PRCVEN
			SC9->C9_LOTECTL	:= TMP2->CB9_LOTECT
			SC9->C9_DTVALID	:= Posicione("SB8",5,xFilial("SB8") + TMP2->CB9_PROD + TMP2->CB9_LOTECT  ,"B8_DTVALID")
			SC9->C9_LOCAL	:= TMP2->CB9_LOCAL
			SC9->C9_TPCARGA := "2"
			SC9->C9_RETOPER := "2"
			SC9->C9_ORDSEP 	:= CB7->CB7_ORDSEP
			SC9->C9_TPOP 	:= "1"
			SC9->C9_DATENT	:= SC6->C6_ENTREG

			SC9->(MsUnlock())

			///empenhando os lotes conforme SC9 criado
			dbselectARea("SB8")
			dbSetOrder(5) //B8_FILIAL+B8_PRODUTO+B8_LOTECTL
			dbSeek(xFilial("SB8") + SC9->C9_PRODUTO + SC9->C9_LOTECTL)
			If ( Found() .and. (SB8->B8_EMPENHO + SC9->C9_QTDLIB) <= SB8->B8_SALDO )

				dbSelectArea("SB8")
				RECLOCK("SB8",.F.)
				SB8->B8_EMPENHO := SB8->B8_EMPENHO + SC9->C9_QTDLIB
				SB8->(MsUnlock())

			EndIf


			//_cSeq	:= Soma1(_cSeq) 

			dbSelectArea("TMP2")
			TMP2->(dBSkip())
		End

		TMP2->(dbCloseArea())



	EndIf


	/*Else

	dbSelectArea("SC6")
	dbSetOrder(1) 
	dbGoTop()                                                                                                                                                                                                                     
	dbSeek( xFilial("SC6") + CB8->CB8_PEDIDO + CB8->CB8_ITEM  )


	_nSeq := CB8->CB8_SEQUEN
	_cQrySc9 := " SELECT ISNULL(MAX(C9_SEQUEN),'00') AS SEQ FROM " + RetSqlName("SC9") + " WITH (NOLOCK) WHERE C9_PEDIDO = '" + CB8->CB8_PEDIDO + "' AND C9_ITEM = '"  + CB8->CB8_ITEM + "' AND C9_PRODUTO = '" + CB8->CB8_PROD + "' "
	If (Select("TMP3") <> 0)
	TMP3->(dbCloseArea())
	Endif

	TcQuery _cQrySc9 Alias "TMP3" New

	DbSelectArea("TMP3")	
	If (!TMP3->(Eof()) )
	_nSeq := Soma1(TMP3->SEQ)
	ENdIf

	dbCloseArea("TMP3")


	//dbSelectArea("SC9")
	//dbSetOrder(1)  //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	//dbSeek(xFilial("SC9") + CB8->CB8_PEDIDO + CB8->CB8_ITEM + CB8->CB8_SEQUEN + CB8->CB8_PROD )
	//If ( Found() )
	//For _x:= 1 to 50
	//_nSeq := _nSeq + 1
	//dbSelectArea("SC9")
	//dbSetOrder(1)  //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	//dbSeek(xFilial("SC9") + CB8->CB8_PEDIDO + CB8->CB8_ITEM + _nSeq + CB8->CB8_PROD )
	//If !(Found())
	//_x:= 51
	//EndIf
	//Next _x
	//EndIf 


	dbSelectArea("SC9")
	RECLOCK("SC9",.T.)

	SC9->C9_FILIAL	:= xFilial("SC9")
	SC9->C9_PEDIDO 	:= CB8->CB8_PEDIDO
	SC9->C9_ITEM	:= CB8->CB8_ITEM	
	SC9->C9_CLIENTE	:= CB7->CB7_CLIENT
	SC9->C9_LOJA	:= CB7->CB7_LOJA	
	SC9->C9_PRODUTO	:= CB8->CB8_PROD
	SC9->C9_QTDLIB	:= CB8->CB8_QTDORI
	SC9->C9_DATALIB	:= CB7->CB7_DTFIMS //dDataBase
	SC9->C9_SEQUEN	:= _nSeq /////CB8->CB8_SEQUEN
	SC9->C9_GRUPO	:= "0001"
	SC9->C9_PRCVEN	:= SC6->C6_PRCVEN
	SC9->C9_LOTECTL	:= CB8->CB8_LOTECT
	SC9->C9_DTVALID	:= Posicione("SB8",5,xFilial("SB8") + CB8->CB8_PROD + CB8->CB8_LOTECT  ,"B8_DTVALID")
	SC9->C9_LOCAL	:= CB8->CB8_LOCAL
	SC9->C9_TPCARGA := "2"
	SC9->C9_RETOPER := "2"
	SC9->C9_ORDSEP 	:= CB8->CB8_ORDSEP
	SC9->C9_TPOP 	:= "1"
	SC9->C9_DATENT	:= SC6->C6_ENTREG

	SC9->(MsUnlock())

	dbCloseArea("TMP2")

	EndIf
	*/


Return()
