#INCLUDE "TOTvS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A103LinOk  ºAutor ³ Cristiano Oliveira º Data ³ 11/07/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Validacao nas Linhas de Itens no Documento de Entrada º±±
±±º          ³ Evitar que sejam utilizados os CENTROS DE CUSTOS antigos.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico JOMHEDICA                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VLDSD1CC()

	Local lRet   := .T.
/*
	Local nLin   := n // Linha do aCols posicionada na tela da nota de entrada
	Local nPos   := 0     
	Local cMemCC := ""       
	Local cOldCC := GetMV("ES_OLDCC") // "2011,2021,2031,2041,2051,2012,2022,2042,2023"
	                                          
	nPos := AScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_CC" } )	
	
	If nLin > 0
		If !Empty(aCols[nLin,nPos]) .OR. !Empty(M->D1_CC)
			
			If !Empty(aCols[nLin,nPos])
				cMemCC := SUBSTR(aCols[nLin, nPos], 1, 4)
			Else
				cMemCC := SUBSTR(M->D1_CC, 1, 4)
			EndIf                
		
			If cMemCC$(cOldCC)
		    	lRet := .F.
		    	MsgAlert("O centro de custo informado não está mais disponível. Por favor, verifique o novo centro de custo a ser utilizado com a contabilidade.")		
		 	EndIf
		 	
	    EndIf
	EndIf    
*/
Return(lRet)