#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA040ALT   ºAutor  ³Eliane Carvalho     º Data ³  09/12/05  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto entrada pós a valid. TudOk, alteração Contas Receber º±±
±±ºObservações:	Utilizado para a validar a alteração.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±           ³ Eliane Carvalho  Data 24/01/2006                            ±±
±± Alteraçao ³ Valida   campos E1_CLVL                                     ±±
±± Alteraçao ³ Retirada Valida   campos E1_CLVL                            ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA040ALT()

Local aAreaAtu := GetArea()
Local aAreaSED := SED->(getarea())
Local Ok    := .t.

If ALTERA
	DbSelectArea("SED")
	DbSetOrder(1)
	DbSeek(xFilial("SED") + M->E1_NATUREZ )
	
	If  Substr(SED->ED_CONTA,1,1) > "2"
		If Empty(M->E1_CCUSTO)
			MsgBox("Obrigatorio Informar Centro de Custo!")
			Ok 	:= .f.
		EndIf
		
		If Empty(M->E1_ITEMCTB)
			MsgBox("Obrigatorio Informar Item Conta!")
			Ok 	:= .f.
			
		EndIf
		//	IF EMPTY(M->E1_CLVL)
		//		MsgBox("Obrigatorio Informar Classe de Valor!")
		//		Ok 	:= .f.
		//  ENDIF
	EndIf
	
EndIf

RestArea(aAreaSED)
Restarea(aAreaAtu)
Return ok
