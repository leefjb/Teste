//*============================================================================
// Programa.......: JMHFinX3.PRW
// Objetivo.......: Pesquisar o Codigo do CRM Digitado
// Autor..........: 
// Data...........: 
//------------------------------------------------------------------------------
// Autor      |   Data     | Alteracao
//------------|------------|----------------------------------------------------
//            |            |
//============================================================================*/

#Include "RwMake.Ch"

User Function JMHFinX3()

Local cCRMMV

cCRMMV := M->MV_PAR03

DbSelectArea("SZ1")   
DbSetOrder(1)
DbSeek(xFilial("SZ1")+cCRMMV)
If EOF()  
	Alert("Codigo de CRM NAO Encontrado.")
	cCRMMV := Space(6)
	M->MV_PAR03 := Space(6)
EndIf

Return()