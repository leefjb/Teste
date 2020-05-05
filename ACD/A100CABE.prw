#include 'protheus.ch'


/*/{Protheus.doc} A100CABE
//No momento da geração do cabeçalho da ordem de separação, permite 
//gravar campos específicos no cabeçalho da ordem de separação
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
