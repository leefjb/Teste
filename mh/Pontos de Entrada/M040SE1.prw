#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M040SE1   ºAutor  ³Microsiga           º Data ³  12/21/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ // Eliane Carvalho - Sigasul Informatica 
±±ºOBS.: alterado para gravar a area atual, antes da pesquisa, nas        º±±
±±º      variaveis carea,aAreaSA1,aAreaSc5                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Ponto de entrada Modificado outubro/2004 
// Ponto de entrada para gravar dados do sacado no ctas a receber
// Data: 24/08/01 

User function M040SE1()

Local aArea    := GetArea()
Local aAreaSA1 := SA1->(GetArea())
Local aAreaSC5 := SC5->(GetArea())
Local aAreaSC6 := SC6->(GetArea())

DbselectArea("SC5")             
DbsetOrder(1)
Dbseek(xFilial("SC5") + SE1->E1_PEDIDO)

SC6->( DbsetOrder(1) )
SC6->( Dbseek(xFilial("SC6") + SE1->E1_PEDIDO) )

DbselectArea("SA1")
DbsetOrder(1)
Dbseek(xFilial("SA1") + SC5->C5_SACADO)

DbselectArea("SE1")

RecLock("SE1",.F.)

//SE1->E1_CCUSTO  := SC6->C6_CCUSTO
//SE1->E1_ITEMCTB := SC6->C6_ITEMCTB
SE1->E1_SACADO  := SC5->C5_SACADO
SE1->E1_PACIENT := SC5->C5_PACIENT
SE1->E1_SACNOM  := SA1->A1_NOME


////ajuste desconto - boleto...
If !Empty(SC5->C5_TPDESC)
	If SC5->C5_TPDESC == "1" 		//percentual
		SE1->E1_DESCONT	:= SC5->C5_DESCOM		
	ElseIf SC5->C5_TPDESC == "2"	//valor //////tratamento rateios parcelas
		aParcs := Condicao( 1000, SC5->C5_CONDPAG )
		nParcs := Iif( ValType( aParcs ) == "A", Len( aParcs ), 1 )
		nParcVal := Round( SC5->C5_DESCOM / nParcs, TAMSX3("E1_DECRESC")[2] )
		SE1->E1_DECRESC := nParcVal
 	EndIf                                       	
EndIf                                                                


MsUnlock()

Restarea(aAreaSA1)
Restarea(aAreaSC5)
Restarea(aAreaSC6)
Restarea(aArea)

Return()
	