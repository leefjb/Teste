#INCLUDE "TOTVS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � JMHZPPRO �Autor  � Cristiano Oliveira � Data �  22/01/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida a CLASSE DE VALOR no item da autorizacao de fatura- ���
���          � mento com o VENDEDOR informado no cabecalho da AF (JMHA230)���
�������������������������������������������������������������������������͹��
���Uso       � JOMHEDICA                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function JMHZPPRO()

	Local lRet    := .T.
	Local cMsg    := ""
    Local cPVClVl := ""
    Local cVdClVl := ""
                                                                                       
    // PEGA A CLASSE DE VALOR INFORMADA NO ITEM DO PEDIDO DE VENDA
	// cPVClVl := ALLTRIM(aCols[n, aScan(aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_CLVL" })])
 	cPVClVl := ALLTRIM(POSICIONE("SB1", 1, xFilial('SB1') + M->ZP_PRODUTO, "B1_CLVL"))
        
	// PEGA A CLASSE DE VALOR CADASTRADA NO VENDEDOR INFORMADO NO CABECALHO DO PEDIDO DE VENDA
	cVdClVl := ALLTRIM(POSICIONE("SA3", 1, xFilial('SA3') + M->ZO_VEND1, "A3_CCUSTO"))
	                                                                                          
	// VERIFICA SE A CLASSE DE VALOR INFORMADA NO ITEM DO PEDIDO NAO ESTA CONTIDA NO CADASTRO DO VENDEDOR
	If !(cPVClVl $ cVdClVl)

        // MONTA A MENSAGEM INFORMANDO O BLOQUEIO                                                        
		cMsg := ""
	    cMsg += cUserName + ", " + CRLF + CRLF
	    cMsg += "A classe de valor " + cPVClVl + " do produto " + M->ZP_PRODUTO + "� inv�lida para o representante " + M->ZO_VEND1 + CRLF + CRLF
	    cMsg += "As classes v�lidas para esse representante s�o: " + cVdClVl                                                         
	        
   		// EXIBE MSG E BLOQUEIA O PREENCHIMENTO DO CAMPO C6_CLVL
		MSGALERT(cMsg)
		lRet := .F.

		// GRAVA LOG DO BLOQUEIO - 05/02/2018
		MemoWrite("\_log_bloqueio_pv\" + DtoS(dDataBase) + "_" + SUBSTR(TIME(), 1, 2) + SUBSTR(TIME(), 4, 2) + SUBSTR(TIME(), 7, 2) + "_JMHZPPRO.txt", cMsg)
				
	EndIf       
        
Return(lRet)
