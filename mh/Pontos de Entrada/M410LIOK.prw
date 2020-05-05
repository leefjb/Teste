#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410LIOK()     ºAutor  ³Eliane Carvalhoº Data ³  30/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. Após o posicionamento dos registros do SC6                        ±±º
±±º*Observações:	Permite validar a linha do Pedido de Venda.            ±±º
±±ºDesc.  Valida Retorno esperado:	    .T. ou .F.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±           ³ Eliane Carvalho  Data 24/01/2006                            ±±
±± Alteraçao ³ Valida   campos C6_CLVL acols pedido                        ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410LIOK()    

	Local aArea      := GetArea()
	Local cContaD1   := ""
	Local lReturn    := .T.
	Local nPosCc     := aScan( aHeader, { |x| Upper( AllTrim( x[ 2 ] ) ) == "C6_CCUSTO"  } )
	Local nPosICtb   := aScan( aHeader, { |x| Upper( AllTrim( x[ 2 ] ) ) == "C6_ITEMCTB" } )
	Local nPosConta  := aScan( aHeader, { |x| Upper( AllTrim( x[ 2 ] ) ) == "C6_CONTA"   } )
	Local nPosClvl   := aScan( aHeader, { |x| Upper( AllTrim( x[ 2 ] ) ) == "C6_CLVL"    } )
	Local nPDeleted	 := Len( aHeader ) + 1
	
	cContaD1 := aCols[ n, nPosConta ]
	
	IF INCLUI .Or. ALTERA

		If !aCols[ n, nPDeleted ] // desconsidera as linhas deletadas...

			If Empty( aCols[ n, nPosICtb ] )
				MsgBox("Obrigatorio Informar Item Conta!")
				lReturn	:= .f.
			EndIf

			// Jean Rehermann - Utiliza o mesmo campo porém agora valida a classe de valor com o representante
			If !Empty( aCols[ n, nPosClvl ] )
				
				SA3->( dbSeek( xFilial('SA3') + M->C5_VEND1 ) )
				
				If !Empty( SA3->A3_CCUSTO ) .And. !Alltrim( aCols[ n, nPosClvl ] ) $ SA3->A3_CCUSTO
					MsgBox("Classe de valor inválida para este Representante! As Classes válidas são: " + Alltrim( SA3->A3_CCUSTO ) )
					lReturn := .F.
				EndIf
			
			EndIf

		EndIf

	EndIf

	RestArea(aArea)
    
Return( lReturn )
