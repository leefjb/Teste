#include 'protheus.ch'


/*/{Protheus.doc} A100CABE
//No momento da gera��o do cabe�alho da ordem de separa��o, permite 
//gravar campos espec�ficos no cabe�alho da ordem de separa��o
@author Celso Rene
@since 07/11/2018
@version 1.0
@type function
/*/
User Function A100CABE()

	If nOrigExp == 1 // Pedido de Venda liberado                 
		CB7->CB7_PRIORI	:= Posicione("SC5",1,xFilial("SC5") + CB7->CB7_PEDIDO ,"C5_XPRIORI")
		CB7->CB7_TIPEXP := "00*03*" //somente podera ser gerado o documento pela rotina de separacao e conferencia de separacao                         
	Endif	   

Return()	
