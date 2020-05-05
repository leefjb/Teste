#include "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} JOMACD12
//Envio workflow - aviso - documento de saida gerado automicamente 
@author Celso Rene
@since 09/01/2019
@version 1.0
@type function
/*/
User Function JOMACD12(_cPDoc) //u_JOMACD12("01000002   99 00001 01")

	//Flag para primeiro registro
	Local oProcess
	Local oHtml
	Local _cPara		:= ""
	Local _lPrimeiro	:= .T.
	Local _cCliente		:= ""


	// Parametro com contatos para envio Workflows - aviso
	dbSelectArea("SX6")
	DbSetOrder(1)
	If !dBseek("  "+"MV_XDOCAUT")
		RecLock("SX6", .T.)
		SX6->X6_FIL    := "  "
		SX6->X6_VAR    := "MV_XDOCAUT"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Contatos e-mails - Workflow Doc. saida automatico"
		SX6->X6_CONTEUD:= "celso.junior@solutio.inf.br"
		MsUnLock()
	EndIf

	_cPara	:= Alltrim(GetMv("MV_XDOCAUT"))


	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(_cPDoc)
	If ( Found() )
		While ( ! SD2->(Eof()) .and. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA ==  _cPDoc )


			If ( _lPrimeiro == .T. ) 

				_lPrimeiro := .F.
				oProcess:= TWFProcess():New( "xWFDOCAUT", "DOCUMENTO DE SAIDA AUTOMATICO" )
				oProcess:NewVersion(.T.)
				oProcess:NewTask( "DOCUMENTO DE SAIDA AUTOMATICO", "\workflow\html\Jom002.htm" )
				oProcess:cTo      	:= _cPara //"celso.junior@solutio.inf.br"
				oProcess:NewVersion( .T. )

				_cCliente := Alltrim(Posicione("SA1",1,xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA, "A1_NOME"))
				
				oProcess:cSubject 	:= SM0->M0_CODIGO + " - " + Alltrim(SM0->M0_NOME) + ": DOCUMENTO DE SAIDA AUTOMÁTICO: " + SD2->D2_DOC + SD2->D2_SERIE + " - Pedido: " + SD2->D2_PEDIDO + " - Cliente: "+ _cCliente   

				oHtml := oProcess:oHTML
				oHtml:ValByName( "DTREF"  	, dDataBase)
				oHtml:ValByName( "INFOHTML" , SM0->M0_CODIGO + " - " + Alltrim(SM0->M0_NOME) + ": Documento de saída automático, gerado na conferência de separação, pedido de venda: " + SD2->D2_PEDIDO + ".")

			EndIf


			//NFORIGINAL - SERIEORIGINAL - PRODUTO - QUANTIDADE - VUNITARIO - VTOTAL - NOMECLIENTE - EMISSAO

			aAdd( (oHtml:ValByName( "IT.SER"    ))	, SD2->D2_SERIE												)
			aAdd( (oHtml:ValByName( "IT.DOC"    ))	, SD2->D2_DOC										        ) 
			aAdd( (oHtml:ValByName( "IT.CLI"    ))	, SD2->D2_CLIENTE + " - " + SD2->D2_LOJA + " - " + _cCliente )
			aAdd( (oHtml:ValByName( "IT.EMISS"  ))	, DtoC(SD2->D2_EMISSAO)							            )
			aAdd( (oHtml:ValByName( "IT.COD"    ))	, SD2->D2_COD									        	)
			aAdd( (oHtml:ValByName( "IT.QTD"    ))	, Transform(SD2->D2_QUANT  ,PesqPict("SD2","D2_QUANT"))	    )
			aAdd( (oHtml:ValByName( "IT.VUNIT"  ))	, Transform(SD2->D2_PRCVEN ,PesqPict("SD2","D2_PRCVEN"))	)
			aAdd( (oHtml:ValByName( "IT.VTOTAL" ))	, Transform(SD2->D2_TOTAL  ,PesqPict("SD2","D2_TOTAL"))	    )				


			SD2->(dBSkip())

		EndDo

	EndIf


	oProcess:Start()


Return()
