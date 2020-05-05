#include "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} xProcTit
//Procura Titulo baixado ou parcialmente baixado
@author Celso Rene
@since 16/11/2018
@version 1.0
@return ${return}
@param _cNum - string 
@param _cPref - string
@param _cForn - string
@param _cLoja - string
@type function
/*/
User Function xProcTit(_cNum, _cPref)

	Local _lRet		:= .T. 
	Local _cQuery	:= ""
	Local _cCliente	:= ""
	Local _cEmissao	:= ""

	_cQuery := " SELECT * " + chr(13)
	_cQuery += " FROM " + RetSqlName("SE1") + " " + chr(13)
	_cQuery += " WHERE E1_NUM = '" + _cNum + "' AND E1_PREFIXO = '" + _cPref + "' AND E1_TIPO = 'NF' AND E1_FILIAL = '" + xFilial("SE1") + "' " + chr(13)
	_cQuery += " AND (E1_BAIXA <> '' OR E1_VALOR > E1_SALDO) "

	//_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TSE1', .T., .T.)

	DBSelectArea("TSE1")
	TSE1->(DBGotop())

	If (! TSE1->(EOF()) )	
		_lRet:= .F.
		_cCliente := TSE1->E1_NOMCLI
		_cEmissao := TSE1->E1_EMISSAO
	EndIf   

	TSE1->(dbCloseArea())


Return( {_lRet,_cCliente,_cEmissao} )



/*/{Protheus.doc} xWFDevNCC
//Workflow informando que o titulo baixado sera devolvido item
@author Celso Rene
@since 16/11/2018
@version 1.0
@param _aArra
@type function
/*/
User Function xWFDevNCC(_aArray)

	Local _lPrimeiro 	:= .T.		//Flag para primeiro registro
	Local oProcess
	Local oHtml
	Local _cPara		:= ""
	
	
	// Parametro com contatos para envio Workflows - Titulo DEV - NCC - aviso
	dbSelectArea("SX6")
	DbSetOrder(1)
	If !dBseek("  "+"MV_XDEVNCC")
		RecLock("SX6", .T.)
		SX6->X6_FIL    := "  "
		SX6->X6_VAR    := "MV_XDEVNCC"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Contatos disparo Workflow - Dev. Titulos com Baixas-NCC"
		SX6->X6_CONTEUD:= "financeiro@jomhedica.com.br"
		MsUnLock()
	EndIf

	_cPara	:= Alltrim(GetMv("MV_XDEVNCC"))
	

	For _x:= 1 to Len(_aArray) 

		If ( _lPrimeiro == .T. ) 

			_lPrimeiro := .F.
			oProcess:= TWFProcess():New( "xWFDevNCC", "DEV. TITULOS COM BAIXAS - NCC" )
			oProcess:NewVersion(.T.)
			oProcess:NewTask( "DEV. TITULOS COM BAIXAS - NCC", "\workflow\HTML\Jom001.htm" )
			oProcess:cTo      	:= _cPara 
			oProcess:NewVersion( .T. )

			oProcess:cSubject 	:= SM0->M0_CODIGO + " - " + Alltrim(SM0->M0_NOME) + ": " + "DEVOLUÇÕES - TÍTULOS COM BAIXAS - NCC"

			oHtml   			:= oProcess:oHTML
			oHtml:ValByName( "DTREF"  	, dDataBase)
			oHtml:ValByName( "INFOHTML" , SM0->M0_CODIGO + " - " + Alltrim(SM0->M0_NOME) + ": " +"VERIFICAR SITUAÇÃO DE LIQUIDAÇÃO NA COBRANÇA/FINANCEIRO")

		EndIf
		
		
		//NFORIGINAL - SERIEORIGINAL - PRODUTO - QUANTIDADE - VUNITARIO - VTOTAL - NOMECLIENTE - EMISSAO
		
		aAdd( (oHtml:ValByName( "IT.SER"  ))	, _aArray[_x][1] 										)
		aAdd( (oHtml:ValByName( "IT.DOC"  ))	, _aArray[_x][2]										) 
		aAdd( (oHtml:ValByName( "IT.CLI"  ))	, _aArray[_x][7]										)
		aAdd( (oHtml:ValByName( "IT.EMISS"  ))	, DtoC(StoD(_aArray[_x][8]))							)
		aAdd( (oHtml:ValByName( "IT.COD"  ))	, _aArray[_x][3]										)
		aAdd( (oHtml:ValByName( "IT.QTD"  ))	, Transform(_aArray[_x][4],PesqPict("SD1","D1_QUANT"))	)
		aAdd( (oHtml:ValByName( "IT.VUNIT"  ))	, Transform(_aArray[_x][5],PesqPict("SD1","D1_VUNIT"))	)
		aAdd( (oHtml:ValByName( "IT.VTOTAL"  ))	, Transform(_aArray[_x][6],PesqPict("SD1","D1_TOTAL"))	)				

	Next _x
	
	
	oProcess:Start()


Return()
