#include 'protheus.ch'


/*/{Protheus.doc}  xValDoc
//Validação no campo F1_DOC para preencher somente valores numericos 
@author CelsoT
@since 07/11/2018
@version 1.0
@type function
/*/
User Function xValDoc()

Local _lRet	:= .T.
 
If ("-" $ cNFiscal) 
 	_lRet	:= .F.
 	MsgAlert("Informar somente números para o Documento!","# Somente Números")
EndIf
	
Return(_lRet)