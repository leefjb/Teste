#include 'protheus.ch'


/*/{Protheus.doc} MA410COR
//Ponto de entrada do pedido de venda - aCores - filtro legendas
@author Celso Rene
@since 26/05/2019
@version 1.0
@type function
/*/
User Function MA410COR(aCores)

Local _aCores := Paramixb

//legenda verde - pedido em aberto
_aCores[1][1] := "Empty(C5_LIBEROK).And.Empty(C5_NOTA).And.Empty(C5_BLQ).and.Empty(C5_XORDSEP)"

//legenda amarela - pedido liberado
_aCores[3][1]:= "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And.Empty(C5_BLQ).or.(!Empty(C5_XORDSEP).and.!(!Empty(C5_NOTA).or.C5_LIBEROK=='E'))"


Return(_aCores)
