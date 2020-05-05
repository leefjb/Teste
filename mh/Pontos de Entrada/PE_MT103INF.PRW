/*
Jean Rehermann | SOLUTIO IT - 05/08/2016 - Ponto de entrada MT103INF

Localização : Function NfeNfs2Acols() [MATA103X.PRX] - Esta rotina tem como objetivo atualizar a funcao fiscal com base no item
 do documento de saida e atualizar o acols também.

Em que ponto : Na nota de entrada, no momento de importacao dos itens da nota fiscal original. Ex: nf de devolucao
O item da nota original encontra-se posicionado:  SD2
*/

User Function MT103INF()

	Local nLinCols := ParamIxb[ 1 ] // Linha do aCols posicionada na tela da nota de entrada
	Local nPosCCus := 0
	Local nPosItCC := 0
	Local nPosClvl := 0
	
	nPosCCus := AScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_CC" } )
	nPosItCC := AScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_ITEMCTA" } )
	nPosClvl := AScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_CLVL" } )
	
	If nPosCCus > 0
		aCols[ nLinCols, nPosCCus ] := SD2->D2_CCUSTO
	EndIf

	If nPosItCC > 0
		aCols[ nLinCols, nPosItCC ] := SD2->D2_ITEMCC
	EndIf

	If nPosClvl > 0
		aCols[ nLinCols, nPosClvl ] := SD2->D2_CLVL
	EndIf

Return NIL