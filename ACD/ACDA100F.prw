#include "protheus.ch"


/*/{Protheus.doc} ACDA100F
Valida itens considerados na geracao das ordens de sepacao
@author Celso Rene
@since 14/02/2019
@version 1.0
@type function
/*/
User Function ACDA100F()


Local _aArea := GetArea()


//Gerar tarefa - no momento da geracao da Ord. de sepracao
If ( MSGYESNO("Deseja gerar tarefa de separação para essa ordem de separação: " + CB7->CB7_ORDSEP + " - P.V.: "+ CB7->CB7_PEDIDO + ".","# Tarefa Ord. Separação ?" ) )
	u_xGeraCBF()
EndIf


//guardando informacao de ordem de separacao no pedido de venda
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5") + CB7->CB7_PEDIDO)
If ( Found() )
	RECLOCK("SC5",.F.)
	SC5->C5_XORDSEP := CB7->CB7_ORDSEP
	SC5->(MsUnlock())
EndIf


RestArea(_aArea)

	
Return()
