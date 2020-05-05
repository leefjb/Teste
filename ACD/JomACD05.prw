#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} ACD005
//Gatilho etiqueta: entrada de materiais - Dev. materiais consignado
@author Celso Rene
@since 12/11/2018
@version 1.0
@type function
/*/
User Function JomACD05()

Local _cRetID		:= M->D1_XIDETIQ
Local _cQuery		:= ""
Local _aColsAnt		:= {}

Local nD1ITEM  		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEM" })
Local nD1COD 		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })
Local nD1QUANT		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT" })
Local nD1VUNIT		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_VUNIT" })
Local nD1LOCAL		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_LOCAL" })
Local nD1UM			:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_UM" })
Local nD1NFORI		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_NFORI" })
Local nD1SERIORI	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_SERIORI" })
Local nD1ITEMORI	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMORI" })
Local nD1IDENTB6	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_IDENTB6" })
Local nD1LOTE		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_LOTECTL" })
Local nD1LOTEF		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_LOTEFOR" })
Local nD1DTVALID	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_DTVALID" })
Local nD1CC			:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CC" })
Local ITEMCTA		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMCTA" })


/*
_cQuery:= " SELECT CB9.CB9_FILIAL, CB9.CB9_ORDSEP, CB9.CB9_PROD ,CB9.CB9_CODETI, CB9.CB9_SEQUEN, CB9.CB9_CODSEP, CB9.CB9_LOTECTL, CB9.CB9_NUMLOTE, CB9.CB9_LOCAL, SCB9.CB9_PEDIDO "+ chr(13)
_cQuery+= " , " + chr(13)
_cQuery+= " FROM "+ RETSQLNAME("CB9") + " CB9 "+ chr(13)
_cQuery+= " INNER JOIN  "+ RETSQLNAME("CB7") + " ON SC7.CB7_FILIAL = CB9.CB9_FILIAL AND CB7 ON CB7.D_E_L_E_T_ = '' AND CB7.CB7_ORDSEP = CB9.CB9_ORDSEP AND "+ chr(13)
_cQuery+= " AND CB7.CB7_PEDIDO = CB9.CB9_PEDIDO " + chr(13)

_cQuery+= " WHERE CB9.CB9_D_E_L_E_T_ = '' AND CB9.CB9_CODETI = '" + _cRetID + "'  "
*/

_aColsAnt := aCols


_cQuery	:= " SELECT * SD2010 WHERE D2_LOTECTL = '" + M->D1_LOTECTL + "' "
_cQuery	+= " 	


GetDRefresh()	

	
Return(_cRetID)


/*/{Protheus.doc} ACD005
//Validando When coluna ID Etiqueta - Entrada formaulario proprio
@author Celso Rene
@since 12/11/2018
@version 1.0
@type function
/*/
User Function U_XWhenID()                                                 

Local _lRetID	:= .F.

//c103Tipo
//c103Form
//cNfiscal
//cSerie
//dDemissao
//cA100For
//cLoja
//cEspecie
//cUFOrig


Return(_lRetID)
