#include 'protheus.ch'


/*/{Protheus.doc} SX5NOTA
//Ponto de entrada filtro documento de saida
@author Celso Rene
@since 23/10/2018
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
User Function SX5NOTA()
	
	Local _lret 	:= .T. 
	Local _aArea 	:= GetArea() 
	
	If ( Alltrim(FunName()) == "JMHA230" .and. SZO->ZO_TIPO == "1")
		dbSelectArea("SZP")
		dbSetOrder(1)
		If DBSeek(xFilial("SZP") + SZO->ZO_NUM )
			Do Case
				Case ( Alltrim(SZP->ZP_SERORIG) == "CON" ) 
					If ( Alltrim(SX5->X5_CHAVE) == "VAL" )
						_lret:= .T.
					Else 
						_lret:= .F.
					EndIf

				Case ( Alltrim(SZP->ZP_SERORIG) == "1" )  
					If ( Alltrim(SX5->X5_CHAVE) == "1" )
						_lret:= .T.
					Else 
						_lret:= .F.
					EndIf	
			EndCase
		Else
			_lret:= .T.
		EndIf
	Else
		_lret:= .T.
	EndIf
	
	
	RestArea(_aArea)

Return(_lret)
