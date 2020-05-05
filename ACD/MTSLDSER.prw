#include "protheus.ch"


/*/{Protheus.doc} MTSLDSER
//Ponto de entrada que valida saldo SB2 e reserva
@author Celso Rene
@since 21/02/2019
@version 1.0
@type function
/*/
User Function MTSLDSER()

//Logico, sendo verdadeiro para subtrair o acumulado de reservas e falso para nao subtrair o acumulado de reservas.
Local _lRet := .T.	


//ACD - ACDV166 serparacao: (XACVD180 - tarefas) ignora reserva (SB2)
If ( "XACDV180" $ FunName() .or. "JOMACD14" $ FunName() )
	_lRet := .F.
EndIf

//somenta para empresa 06
/*If (cEmpAnt == "06")
	_lRet := .F.
EndIf*/

	
Return(_lRet)
