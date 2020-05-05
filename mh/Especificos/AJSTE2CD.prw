#Include 'Protheus.ch'
#INCLUDE "Topconn.ch"
#include "prtopdef.ch"

/*/{Protheus.doc} AJSTE2CD
#21622 Ajusta campo E2_CONTAD vazios, com o conteúdo do campo
A2_CONTA do cadastro de fornecedor.
@type function
@author Mauro - Solutio
@since 26/12/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/	

User Function AJSTE2CD()
		
	Local cQuery := ""	
		
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbGoTop()
		
	Do While !EOF()
		If !Empty(Alltrim(SA2->A2_CONTA))
			// Faz update no SE2. Atualiza o campo E2_CONTAD.
			cQuery := ""
			cQuery += " UPDATE "+ RETSQLNAME("SE2") +" "
			cQuery += " SET E2_CONTAD = '"+ SA2->A2_CONTA +"' "
			cQuery += " WHERE E2_FORNECE = '"+ SA2->A2_COD +"' "
			cQuery += " AND E2_LOJA = '"+ SA2->A2_LOJA +"' AND E2_EMISSAO >= '20170101' "
			cQuery += " AND E2_FILIAL = '" + xFilial("SE2") + "' AND E2_TIPO IN ('BOL','PA ','TF ', 'NF ') " //AND E2_CONTAD = ''
			cQuery += " AND D_E_L_E_T_ <> '*' "
			TcSqlExec(cQuery)
		EndIf
		DbSelectArea("SA2")
		DbSkip()
	EndDo
	
	
Return()