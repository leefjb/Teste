#include 'protheus.ch'

/*/{Protheus.doc} xVendCtb
//Gatilho C5_VEND1 para pegar a conta no campo A3_ITEMCTB e alimentar o campo C6_ITEMCTB
@author Celso Rene e Ubirajara Tiengo
@since 07/11/2018
@version 1.0
@type function
/*/
User Function xVendCtb(_cVend)

Local _nItemCtb  := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEMCTB" })
Local _nCC	     := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_CC" })
Local _cItemCtb  := ""


_cItemCtb := posicione("SA3",1,xFilial("SA3") + _cVend, "A3_ITEMCTB")
	
	For _x:= 1 to Len(aCols)
		
		aCols[_x][_nItemCtb] := _cItemCtb
		If ( Altera .and. SC5->C5_VEND1 <> _cVend ) 
			aCols[_x][_nCC]   := Padr( "" , TamSx3("C6_CC")[1] )
		ElseIf ( Inclui )
			aCols[_x][_nCC]   := Padr( "" , TamSx3("C6_CC")[1] )
		EndIf
		
	Next _x
	
	
	GetdRefresh()
	
Return(M->C5_VEND1)
