#include 'protheus.ch'

/*___________________________________________________________________________
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||-------------------------------------------------------------------------||
|| Função: FA060QRY     || Marllon Figueiredo           || Data: 14/08/2012||
||-------------------------------------------------------------------------||
|| Descrição: PE para tratamento de adicao no filtro de selecao dos titulos||
||          : para a montagem do bordero de recebimentos                   ||
||          :                                                              ||
||          : *** A T E N C A O  *** A T E N C A O  *** A T E N C A O  *** ||
||          : Esta sendo utilizado a variavel interna do Protheus CPROT060 ||
||          : para identificar o codigo do banco que esta sendo gerado o   ||
||          : bordero. O E1_PORTADO tem que estar preenchido com o banco   ||
||-------------------------------------------------------------------------||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FA060QRY()

// variavel cPort060 eh interna do Protheus e contem o codigo do banco seleciondo 
// na tela de parametros do BORDERO
cFiltro := " E1_PORTADO = '"+cPort060+"' "

Return( cFiltro )
