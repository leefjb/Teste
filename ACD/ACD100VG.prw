#include 'protheus.ch'


/*/{Protheus.doc} ACD100VG
//Validando geracao da Ordem de separacao
@author Celso Rene
@since 24/05/2019
@version 1.0
@type function
/*/
User Function ACD100VG()

	Local _lRet	 	:= .T.	
	Local _aArea 	:= GetArea()
	Local _cPedido	:= SC9->C9_PEDIDO

	dbSelectArea("SC9")
	SC9->(dbSetOrder(1))
	SC9->(dbGoTop())
	dbSeek(xFilial("SC9") + SC9->C9_PEDIDO )

	Do While ( ! SC9->(EOF()) .and. SC9->C9_PEDIDO == _cPedido )

		dbSelectArea("SC6")
		SC6->(dbSetOrder(1))
		SC6->(dbGoTop())
		dbSeek(xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM )
		If ( Found() .and. SC6->C6_ENVSEP == "1" )
			If ! (SC9->(IsMark("C9_OK",ThisMark(),ThisInv())) ) .or. !Empty(SC9->C9_BLEST)   //(Alltrim(SC9->C9_OK) == "") //
				_lRet := .F.
				Aviso("Itens não selecionados!","Itens liberados (separa = 'SIM') no pedido de venda não foram selecionados para gerar a Ordem de Separação."+chr(13);
				+"Por favor, revisar.",{"OK"},2)
				Exit
			EndIf
		EndIf


		SC9->(dBSkip())

	EndDo



	RestArea(_aArea)

Return(_lRet)

