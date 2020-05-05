#Include "Protheus.ch"
#Include "Rwmake.ch"
#INCLUDE "tbiconn.ch"
#Include "topconn.ch"

/*/{Protheus.doc} ACD166FM
//Esta localizado na funcao FimProcesso com o Objetivo de finalizar o processo de separacao (para itens separa).
//Finalidade: Este Ponto de Entrada permite executar rotinas complementares no momento de 
//finalizar o processo de separacao, se os itens forem separados.
@author Celso Rene
@since 06/11/2018
@version 1.0
@type function
/*/
User Function ACD166FM()

	Local _aArea 	:= GetArea()
	Local _cQuery	:= ""       
	
	
	//erro variavel nao existe em algumas separacoes
	//If Type("cOrdSep")=="U"
		//Private cOrdSep :=  CB7->CB7_ORDSEP //Space(6)
	//EndIf



	//grando os dados de separacao na liberacao do pedido de vendas
	dbSelectArea("CB8")
	dbSetOrder(2) //CB8_FILIAL+CB8_PEDIDO+CB8_ITEM+CB8_SEQUEN+CB8_PROD
	dbSeek( xFilial("CB8") + CB7->CB7_PEDIDO )
	If ( Found() )

		While ( ! CB8->(EOF()) .AND. CB8->CB8_PEDIDO == CB7->CB7_PEDIDO )

			//_nSaldo := AjuSCB8() //ajuste saldo CB8 - aguardando solucao chamado: 4769603
			
			//dbSelectArea("CB8")
			//RECLOCK("CB8",.F.)
			//CB8->CB8_SALDOS := CB8->CB8_QTDORI - _nSaldo
			//CB8->(MsUnlock())


			//dbSelectArea("SC9")
			//dbSetOrder(1) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO+C9_BLEST+C9_BLCRED                                                                                                                                                                                                                     
			//dbSeek( xFilial("SC9") + CB8->CB8_PEDIDO + CB8->CB8_ITEM + CB8->CB8_SEQUEN + CB8->CB8_PROD )

			//If ( Found() ) 
			//	RECLOCK("SC9",.F.)
			//	SC9->C9_QTDSEP := CB8->CB8_QTDORI - CB8->CB8_SALDOS
			//	SC9->(MsUnlock())
			//EndIf

			//dbCloseArea("SC9")
			
			PedidoConf(CB8->CB8_PEDIDO + CB8->CB8_ITEM) //atualiza conferencia pedido - conforme itens separados

			//dbSelectArea("CB8")
			//CB8->(dBSkip())    

		EndDo  

	EndIf


	//atualizando status PV - leitura pedido conferencia de separacao
	/*
	dbSelectArea("SC5")
	dbSetOrder(1)
	If ( dbSeek(xFilial("SC5") + CB7->CB7_PEDIDO ) )
		RECLOCK("SC5",.F.)
		SC5->C5_PVSTAT := "059"
		SC5->(MsUnlock())
	EndIf
	*/


	RestArea(_aArea)

Return()



/*/{Protheus.doc} AjuSCB8
//Ajusta saldo CB8 - CB8_SALDOS - Problema retorno saldo no estorno da separacao
@author Celso Rene
@since 04/01/2019
@version 1.0
@type function
/*/
Static Function AjuSCB8()

	Local _cqryCB9 := ""
	Local _nSaldo  := 0

	_cqryCB9 := " SELECT ISNULL(SUM(CB9_QTESEP),0) QTESEP FROM " + RetSqlName("CB9") + " " + chr(13)
	_cqryCB9 += " WHERE CB9_ORDSEP = '" + CB8->CB8_ORDSEP + "' AND CB9_PEDIDO = '" + CB8->CB8_PEDIDO + "' AND CB9_PROD = '" + CB8->CB8_PROD + "' " + chr(13)
	_cqryCB9 += " AND CB9_ITESEP = '" + CB8->CB8_ITEM + "' AND D_E_L_E_T_ = '' "

	If (Select("TMP2") <> 0)
		TMP2->(dbCloseArea())
	Endif

	TcQuery _cqryCB9 Alias "TMP2" New

	DbSelectArea("TMP2")	
	If (!TMP2->(Eof()) ) 

		/*dbSelectArea("CB8")
		RECLOCK("CB8",.F.)
		CB8->CB8_SALDOS := CB8->CB8_QTDORI - TMP2->QTESEP
		CB8->(MsUnlock())*/ 
		
		_nSaldo := TMP2->QTESEP
		
	EndIf

	dbCloseArea("TMP2")


Return(_nSaldo)


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
				SC6->C6_QTDSEP := TMP->QTESEP
				SC6->C6_QTDLIB := TMP->QTESEP
				SC6->C6_QTDEMP := TMP->QTESEP 
				SC6->(MsUnlock())

			EndIf

			dbCloseArea("TMP")

			dbSelectArea("SC6")
			SC6->(dBSkip()) 

		EndDo


	EndIf


//RestArea(_aAreaSC6)


Return() 
