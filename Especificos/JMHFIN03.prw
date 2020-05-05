#include "Protheus.ch"

//--------------------------------------------------------------------------------------------------------|
//| Funcao   | JMHFIN03 | Autor | Reiner Trennepohl                                  | Data | 05/12/2000  |  
//|-------------------------------------------------------------------------------------------------------|
//| Descricao| Funcao customizada para Controle do Faturamento Especial. Dados Gerados pela Nota Fiscal   |
//|-------------------------------------------------------------------------------------------------------|
//|19/10/2001| Reiner                                                                                     |                                                         
//|-------------------------------------------------------------------------------------------------------|

User Function JMHFIN03()

Private cCadastro := 'Faturamento Especial'  
Private cPerg     := PadR("FFIN3A",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
pRIVATE lPerg     := .F.     
Private dDataI 
Private dDataF 
Private cCRM   
Private oBut0
Private oBut1  
Private oBut2  
Private oBut3  
Private oBut4  
Private oBut5  
Private oBut6  
Private oBut9

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Define Array contendo as Rotinas a executar do programa      
| ----------- Elementos contidos por dimensao ---------------------------------------------------------------------------------------------------------
| 1. Nome a aparecer no cabecalho                              
| 2. Nome da Rotina associada                                  
| 3. Usado pela rotina                                         
| 4. Tipo de Transacao a ser efetuada                          
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 1 - Pesquisa e Posiciona em um Banco de Dados             
| 2 - Simplesmente Mostra os Campos                         
| 3 - Inclui Dados no           
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

Private aRotina := { { 'Pesquisar'  ,"AxPesqui"   , 0 , 1 },;   //"Pesquisar"
					 { 'Visualizar' ,"AxVisual"   , 0 , 2 },;   //"Visualizar" 
	              	 { 'Incluir'    ,"AxInclui"   , 0 , 3 } ,;  //"Incluir"   
	              	 { 'Parametros' ,"U_JMHFIN3X" , 0 , 4 },;   //"Parametros"  
	              	 { 'Relatorio' ,"U_JMHFIN3R"  , 0 , 5 },;   //"Relatorio"
	              	 { 'Gerar Pgto' ,"U_JMHFIN3A" , 0 , 6 } }   //"Gerar Contas a Pagar CRM"
	              				                                                                                     
dbSelectArea("SZ2")                                                              
dbSeek(xFilial())

mBrowse( 6, 1,22,75,"SZ2",,"SZ2->Z2_NOTACRM#SPACE(6)")

Return(.T.)

