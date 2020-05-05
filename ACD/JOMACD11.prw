#Include "Protheus.ch"
#Include "Rwmake.ch"
#INCLUDE "tbiconn.ch"
#Include "topconn.ch"


/*/{Protheus.doc} JOMACD11
//Rotina para gerar o documento de saida automaticamente
@author Celso Rene
@since 03/01/2019
@version 1.0
@type function
/*/
User Function JOMACD11(_cPedido)   

	Local _lRet		:= .F.
	Local _aPvlNfs	:= {}
	Local _cNota	:= ""
	Local _cSerie	:= ""
	Local _aArea	:= GetArea()


	//If (MSGYESNO( "Separação finalizada, deseja gerar o documento de saída automáticamente ?", "# Documento de saída automático" ))

	///////forcando novamente a geracao da SC9 conforme CB9
	//U_xGerSC9(_cPedido) //gerando novamente SC9 //////////


	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5") + _cPedido )

	_cSerie := SC5->C5_XSERIE //serie N.F. informado no pedido de venda


	dbSelectArea("SC9")
	dbSetOrder(1)
	If (dbSeek( xFilial("SC9") + _cPedido ))

		Do While !SC9->(EOF()) .and. SC9->C9_PEDIDO == _cPedido

			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO )

			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") + SC6->C6_TES)

			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1") + SC9->C9_PRODUTO)

			dbSelectArea("SB2")
			dbSetOrder(1)
			dbSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL )


			Aadd(_aPvlNfs,{ SC9->C9_PEDIDO,;
			SC9->C9_ITEM,;
			SC9->C9_SEQUEN,;
			SC9->C9_QTDLIB,;
			SC6->C6_PRCVEN,;
			SC9->C9_PRODUTO,;
			SF4->F4_ISS=="S",;
			SC9->(RecNo()),;
			SC5->(RecNo()),;
			SC6->(RecNo()),;
			SE4->(RecNo()),;
			SB1->(RecNo()),;
			SB2->(RecNo()),;
			SF4->(RecNo()),;
			SB2->B2_LOCAL,;
			SC9->C9_QTDLIB2})


			SC9->(dbSkip())

		EndDo

		dbCloseArea("SC5")
		dbCloseArea("SC6")
		dbCloseArea("SC9")
		dbCloseArea("SF4")
		dbCloseArea("SB1")
		dbCloseArea("SB2")

	EndIf

	_cNota := MaPvlNfs(_aPvlNfs,_cSerie, .F., .F., .F., .F., .F., 0, 0, .T., .F.)

	If _cNota <> ""
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek(xFilial("SF2") + Padr( _cNota , TamSx3("F2_DOC")[1] ) + Padr( _cSerie , TamSx3("F2_SERIE")[1] )  )
		If ( Found() )	
			//u_JOMACD12(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA )//WORKFLOW E-mail	
			MsgInfo("Gerado documento de saída: " + _cNota + " - Série: " + _cSerie + " - Pedido: " + _cPedido + " ","# Documento de saída automático!" )
			_lRet := .T.
		EndIf

		dbCloseArea("SF2")

	EndIf

	//EndIf


	RestArea(_aArea)


Return(_lRet)
