#include 'protheus.ch'

/*/{Protheus.doc} ACDA100I
//Filtra Itens na geracao de Ordens de Separacao
@author Celso Rene
@since 10/12/2018
@version 1.0
@type function
/*/
User Function ACDA100I()

	Local _lRet 	:= .F.
	Local _aArea	:= GetArea()		


	If (nOrigExp == 1) //origem ordem de separacao do pedido de venda

		dbSelectArea("SC6")
		dbSetOrder(1) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO                                                                                                                             
		dbSeek(xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO )
		If ( Found() .and. SC6->C6_ENVSEP == "1" ) //separar = sim
			_lRet 	:= .T.
		EndIf  

	EndIf 	


	RestArea(_aArea)


Return(_lRet)
