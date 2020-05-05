#include 'protheus.ch'


/*/{Protheus.doc}  xValDoc
//Valida��o no campo F1_DOC para preencher somente valores numericos 
@author CelsoT
@since 07/11/2018
@version 1.0
@type function
/*/
User Function xValDoc()

Local _lRet	:= .T.
 
If ("-" $ cNFiscal) 
 	_lRet	:= .F.
 	MsgAlert("Informar somente n�meros para o Documento!","# Somente N�meros")
EndIf
	
Return(_lRet)