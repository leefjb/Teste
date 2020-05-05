#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*/{Protheus.doc} WFRESERV  
//Schedule para atualizar reservas 
@author Celso Rene
@since 15/05/2019
@version 1.0
@type function
/*/

//u_WFRESERVVAS({"01"})
User Function WFRESERV()

Local _cquery  := ""
Local _cquery2 := ""
Local nStat01  := 0
Local nStat06  := 0

WFPrepENV( "01", "01")

_cquery := " UPDATE SB2010 SET B2_RESERVA = ISNULL((SELECT SUM(SC9.C9_QTDLIB) FROM SC9010 SC9 WHERE SC9.C9_PRODUTO = B2_COD AND SC9.C9_LOCAL = B2_LOCAL AND SC9.D_E_L_E_T_ = '' AND SC9.C9_NFISCAL = ''"
_cquery += " AND EXISTS (SELECT SC6.C6_NUM FROM SC6010 SC6 WHERE SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC6.C6_ITEM AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.D_E_L_E_T_='')"
_cquery += " ),0)"
_cquery += " WHERE D_E_L_E_T_ = '' AND B2_LOCAL = '01' " 

nStat01 := TCSQLExec(_cquery)
if (nStat01 < 0)
	DisarmTransaction()
	Break
Else
	_cquery := " UPDATE SB2010 SET B2_QEMP = B2_RESERVA  WHERE D_E_L_E_T_ = '' AND B2_LOCAL = '01' "
	TCSQLExec(_cquery)
	Conout(">>>>>> rodou reservas - 01 <<<<<<< " + Time() )	
Endif
	


RESET ENVIRONMENT


WFPrepENV( "06", "01")

_cquery2 := " UPDATE SB2060 SET B2_RESERVA = ISNULL((SELECT SUM(SC9.C9_QTDLIB) FROM SC9060 SC9 WHERE SC9.C9_PRODUTO = B2_COD AND SC9.C9_LOCAL = B2_LOCAL AND SC9.D_E_L_E_T_ = '' AND SC9.C9_NFISCAL = ''"
_cquery2 += " AND EXISTS (SELECT SC6.C6_NUM FROM SC6060 SC6 WHERE SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC6.C6_ITEM AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.D_E_L_E_T_='')"
_cquery2 += " ),0)"
_cquery2 += " WHERE D_E_L_E_T_ = '' AND B2_LOCAL = '01' "

nStat06 := TCSQLExec(_cquery2)
if (nStat06 < 0)
	DisarmTransaction()
	Break
Else
	_cquery2 := " UPDATE SB2060 SET B2_QEMP = B2_RESERVA  WHERE D_E_L_E_T_ = '' AND B2_LOCAL = '01' "
	TCSQLExec(_cquery2)
	Conout(">>>>>> rodou reservas - 06 <<<<<<< " + Time() )	
Endif


RESET ENVIRONMENT


Return()
