#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} M461TRV
A finalidade do ponto de entrada M461TRV é desativar o LOCK de registros da tabela "SB2 - Saldos Físico e Financeiro"
no momento da geração do Documento de Saída.
Problema causado geralmente pela função JMHA230 - Tarefa #19416

@type function
@author Rafael Scheibler
@since 28/03/2018
@version P12.1.17

@return lógico
/*/

user function M461TRV()

Local lret := .f. //.T. - Trava os registros    .F. - Desativa a trava dos registros

return(lret)