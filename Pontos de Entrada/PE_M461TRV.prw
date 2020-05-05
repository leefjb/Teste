#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} M461TRV
A finalidade do ponto de entrada M461TRV � desativar o LOCK de registros da tabela "SB2 - Saldos F�sico e Financeiro"
no momento da gera��o do Documento de Sa�da.
Problema causado geralmente pela fun��o JMHA230 - Tarefa #19416

@type function
@author Rafael Scheibler
@since 28/03/2018
@version P12.1.17

@return l�gico
/*/

user function M461TRV()

Local lret := .f. //.T. - Trava os registros    .F. - Desativa a trava dos registros

return(lret)