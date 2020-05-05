#include 'protheus.ch'


/*/{Protheus.doc} M440SC9I
//Antes de gravar o numero da Autorizacao de Entrega. Este P.E. e utilizado para 
//permitir gravar cpos de usuarios em itens de SC9 
@author Celso Rene
@since 04/01/2019
@version 1.0
@type function
/*/
User Function M440SC9I()

	Local _aArea   := GetArea()
	Local _nSaldo  := 0
	Local _cTesEst := "N"


	If (cEmpAnt == "06" .or. cEmpAnt == "01") //somenta pra empresa 06 - liberar itens para gerar a ordem de separacao

		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO )

		_cTesEst := Posicione("SF4",1,xFilial("SF4") + SC6->C6_TES,"F4_ESTOQUE" ) 
		dbSelectArea("SB2")
		dbSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL )
		If ( Found() .and. _cTesEst == "S" .and. SC6->C6_ENVSEP == "1" .and. Empty(SC6->C6_LOTECTL) .and. FunName() = "MATA410" )
			_nSaldo := SaldoSb2()
			If ( SC9->C9_QTDLIB <= _nSaldo .and. Empty(SC9->C9_ORDSEP) ) //.and. SC9->C9_BLEST == "02"		

				/*dbSelectArea("SB8")
				dbSetOrder(3) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
				dbSeek(xFilial("SB8") + SC9->C9_PRODUTO + SC9->C9_LOCAL + SC9->C9_LOTECTL + SC9->C9_NUMLOTE + DTOS(SC9->C9_DTVALID) )
				If (Found())
				RecLock("SB8",.F.)
				SB8->B8_EMPENHO := SB8->B8_EMPENHO - SC9->C9_QTDLIB
				MsUnlock("SB8")
				EndIf*/ 

				//liberando o bloqueio (validacao saldo (SB2) condicao acima e zerando campo LOTECTL para nao empenhar lotes (SB8)
				RecLock("SC9",.F.)
				SC9->C9_BLEST 	:= ""
				SC9->C9_LOTECTL := ""
				SC9->C9_DTVALID := CtoD("")
				MsUnlock("SC9")

			EndIf

		EndIf

		/*If ( ( "ACDV166" == FunName() .or. "ACDV180" == FunName() ) .and. SC9->C9_BLEST == "02" )
		RecLock("SC9",.F.)
		dbDelete()
		MsUnlock("SC9")
		EndIf*/

	EndIf

	//validando etiqueta - A.F.
	If (cEmpAnt == "06" .or. cEmpAnt == "01") .and. !Empty(SC6->C6_XETIQ)

		dbSelectArea("CB0")
		dbSetOrder(1)
		dbSeek(xFilial("CB0") + Alltrim(SC6->C6_XETIQ) )
		If ( Found() .and. SC9->C9_LOTECTL <> CB0->CB0_LOTE )

			DbSelectArea("SC9")
			RecLock("SC9", .F.)
			SC9->C9_BLEST   := "02"
			MsUnlock()

			MsgAlert("Bloqueio liberação produto: " + Alltrim(SC9->C9_PRODUTO) + " - bloqueado item " + SC9->C9_ITEM + " lote " + Alltrim(SC9->C9_LOTECTL) +  "." ;
			+ chr(10) +"Lote da liberação diferente da etiqueta " + Alltrim(SC6->C6_XETIQ) +" com lote "+ Alltrim(CB0->CB0_LOTE) +".";
			,"Verificar item pedido - etiqueta diferente da liberação")

		EndIf

	EndIf


	RestArea(_aArea)


Return()
