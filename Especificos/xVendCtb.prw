#include 'protheus.ch'


/*/{Protheus.doc} xVendCtb
//Gatilho C5_VEND1 para pegar a conta no campo A3_ITEMCTB e alimentar o campo C6_ITEMCTB
@author CelsoT
@since 07/11/2018
@version 1.0
@type function
/*/
User Function xVendCtb(_cVend)

Local _nItemCtb  := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEMCTB" })
Local _cItemCtb  := Space( TamSx3("A3_ITEMCTB")[1] )

_cItemCtb := posicione("SA3",1,xFilial("SA3") + _cVend, "A3_ITEMCTB")
	
	For _x:= 1 to Len(aCols)
		aCols[_x][_nItemCtb] := _cItemCtb
	Next _x
	
	GetdRefresh()
	
Return(M->C5_VEND1)