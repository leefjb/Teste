#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} updComments
Ponto de entrada para executar chamada da integração do PROTHEUS X SPARK WMS

@return nulo.

@author Carlos Galimberti
@since 09/10/2019
@version P12.1.17
/*/

user function SD1100I()

Local aArea    := GetArea()
Local aSD1area :=  SD1->(GetArea())
Local lUsaSpark := SuperGETMV("MV_SPARK",.F.)

	//alert("passou")
	if lUsaSpark .and. alltrim(Posicione("SF4",1, xFilial("SF4")+ SD1->D1_TES,"F4_ESTOQUE")) == "S" .AND. alltrim(Posicione("SF4",1, xFilial("SF4")+ SD1->D1_TES,"F4_DUPLIC")) == "S" 
		 FwMsgRun(,{|| u_IncluiZX4("SD1",SD1->D1_FILIAL+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_ITEM,sd1->(Recno())) },"Integração SPARK","Agendando integração WMS.")
	endif

RestArea(aSD1area)	
RestArea(aArea)	
return