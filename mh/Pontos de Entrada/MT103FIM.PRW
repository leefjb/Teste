#Include 'Protheus.ch'

/*/{Protheus.doc} MT103FIM

Apos o destravamento de todas as tabelas envolvidas na gravacao 
do documento de entrada, depois de fechar a operacao realizada 
neste, e utilizado para realizar alguma operacao apos a 
gravacao da NFE.
#21622 - Para atualizar o campo E2_CONTAD, com o conteudo do campo A2_CONTA.

@type function
@author Mauro - Solutio
@since 28/11/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function MT103FIM()

	Local nOpcao	:= PARAMIXB[1]   // Opcao escolhida pelo usuario no aRotina.
	Local nConfirma	:= PARAMIXB[2]   // Se o usuario confirmou a operação de gravacao.
	Local cQuery	:= ""
	
	If (nOpcao == 3 .Or. nOpcao == 4 ) .And. nConfirma == 1
		// Faz update no SE2. Atualiza o campo E2_CONTAD.
		cQuery := ""
		cQuery += " UPDATE "+ RETSQLNAME("SE2") +" "
		cQuery += " SET E2_CONTAD = '"+ SA2->A2_CONTA +"' "
		cQuery += " WHERE E2_PREFIXO = '"+ SF1->F1_SERIE +"' "
		cQuery += " AND E2_NUM = '"+ SF1->F1_DOC +"' "
		cQuery += " AND D_E_L_E_T_ <> '*' "
		TcSqlExec(cQuery)
	EndIf

Return()
