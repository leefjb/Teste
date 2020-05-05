#INCLUDE "totvs.ch"
//#INCLUDE "prtopdef.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JMHC6CLV ºAutor  ³ Cristiano Oliveira º Data ³  22/01/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a CLASSE DE VALOR no item do pedido de venda com o  º±±
±±º          ³ VENDEDOR informado no cabecalho do pedido de venda.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ JOMHEDICA                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function JMHC6CLV()

	Local lRet    := .T.
	Local cMsg    := ""
    Local cPVClVl := ""
    Local cVdClVl := ""
                                                                                       
    // PEGA A CLASSE DE VALOR INFORMADA NO ITEM DO PEDIDO DE VENDA
	cPVClVl := ALLTRIM(aCols[n, aScan(aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_CLVL" })])
        
	// PEGA A CLASSE DE VALOR CADASTRADA NO VENDEDOR INFORMADO NO CABECALHO DO PEDIDO DE VENDA
	cVdClVl := ALLTRIM(POSICIONE("SA3", 1, xFilial('SA3') + M->C5_VEND1, "A3_CCUSTO"))
	                                                                                          
	// VERIFICA SE A CLASSE DE VALOR INFORMADA NO ITEM DO PEDIDO NAO ESTA CONTIDA NO CADASTRO DO VENDEDOR
	If !(cPVClVl $ cVdClVl)

        // MONTA A MENSAGEM INFORMANDO O BLOQUEIO                                                        
		cMsg := ""
	    cMsg += cUserName + ", " + CRLF + CRLF
	    cMsg += "O classe de valor " + cPVClVl + " é inválida para o representante " + M->C5_VEND1 + "."+ CRLF + CRLF
	    cMsg += "As classes válidas são: " + cVdClVl                                                         
	        
   		// EXIBE MSG E BLOQUEIA O PREENCHIMENTO DO CAMPO C6_CLVL
		//MsgAlert(cMsg,"Centro de custo inválido!")
		Aviso("Classe de valor inválida!",cMsg)
		lRet := .F.                                   
		
		// GRAVA LOG DO BLOQUEIO - 05/02/2018
		MemoWrite("\_log_bloqueio_pv\" + DtoS(dDataBase) + "_" + SUBSTR(TIME(), 1, 2) + SUBSTR(TIME(), 4, 2) + SUBSTR(TIME(), 7, 2) + "_JMHC6CLV.txt", cMsg)
			
	EndIf       
        
Return(lRet)                        
