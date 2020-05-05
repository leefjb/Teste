#include 'protheus.ch'

//retirado

/*/{Protheus.doc} ACDVCB8
//Expedição de Dados Atualizada - validando a separacao - Lote de validade
@author Celso Rene
@since 06/11/2018
@version 1.0
@return ${return}
@type function
/*/
User Function ACDVCB8()

Local _lRet	     := .T.
//Local _aArea	 := GetArea()

Local _nQtde     :=Paramixb[1]
Local _cArm      :=Paramixb[2]
Local _cEnd      :=Paramixb[3]
Local _cProd     :=Paramixb[4]
Local _cLote     :=Paramixb[5]
Local _cSLote    :=Paramixb[6]
Local _cLoteNew  :=Paramixb[7]
Local _cSLoteNew :=Paramixb[8]
Local cNumSer    :=Paramixb[9]
Local cCodCB0    :=Paramixb[10]

//Verificando lote se o mesmo esta vencido
/*
dbSelectArea("CB0")
dbSetOrder(1) // Filial + Id Etiqueta
dbSeek(xFilial("CB0") + cCodCB0 )
If ( Found() ) 
	If (CB0->CB0_DTVLD < dDataBase)
		_lRet := .F. 
		Alert("Lote Vencido: "+ DtoC(CB0->CB0_DTVLD) + " ID Etiq: "+ cCodCB0 + " - Produto: "+ _cProd + " - Lote: "+ _cLoteNew ;
		,"#Validade - Lote Expirado!" )
	EndIf 
EndIf

RestArea(_aArea)

*/


Return (_lRet)
