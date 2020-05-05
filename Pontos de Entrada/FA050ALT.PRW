#include "rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050INC()ºAutor  ³Eliane Carvalho     º Data ³  11/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.       ³ Ponto Entrada Após a validação do TudoOk, na             º±±
±±º            ³ inclusão do contas a pagar.                              º±±
±±ºObservações:	Utilizado para validar a alteração do contas a pagar.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±           ³ Eliane Carvalho  Data 24/01/2006                            ±±
±± Alteraçao ³ Incluida Valida   campos E1_CLVL                            ±±
±± Alteraçao ³ Retirada a Valida   campos E1_CLVL                          ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/
User Function FA050ALT()

Local aAreaAtu := GetArea()
Local aAreaSED := SED->(getarea())
Local Ok    := .t.      


If ALTERA
	DbSelectArea("SED")
	DbSetOrder(1)
	DbSeek(xFilial("SED") + M->E2_NATUREZ )  
	
	If  SUBSTR(SED->ED_CONTA,1,1) > "2"
		If Empty(M->E2_CCUSTO)
			MsgBox("Obrigatorio Informar Centro de Custo!")
			Ok 	:= .f.
			
	EndIf
		If Empty(M->E2_ITEMCTB)
			MsgBox("Obrigatorio Informar Item Conta!")
		EndIf 	:= .f.
			
	EndIf
	  	// 	IF EMPTY(M->E2_CLVL)
		//	MsgBox("Obrigatorio Informar Classe de Valor!")
		//	Ok 	:= .f.
		//	ENDIF 
EndIf
	

RestArea(aAreaSED)
Restarea(aAreaAtu)

Return Ok
