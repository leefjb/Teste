#include 'protheus.ch'

/* ALTERAR O CONTEUDO DE F1_ESPECIE PARA SPED QUANDO SE TRATAR DE FORMULARIO PROPRIO */
User Function MT100TOk()
Local lRet     := .t.
Local lNotaCon := .f.
Local cTESVale := GetMV('ES_TESVALE')
Local nPTES    := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_TES" } )
Local nPORI    := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_SERIORI" } )


// verificar se a nota origem eh um vale (serie CON)
For nx := 1 To Len(aCols)
	If aCols[nx, nPORI] $ 'CON/PER'
		lNotaCon  := .t.
	EndIf

	// verificar se as TES utilizadas sao de retorno de vale
	If aCols[nx, nPORI] $ 'CON/PER' .AND. ! (aCols[nx, nPTES] $ cTESVale)
		lRet  := .F.
	EndIf
Next

// valida se foi utilizado uma TES que nao eh de retorno do vale
If ! lRet
	MsgInfo('Foi utilizada uma TES que não é de retorno de Vale! Corrija antes de confirmar.')
	Return(.f.)
EndIf

// verificar a especie da nota
If M->CFORMUL == 'S' .and. lNotaCon
	CESPECIE := '   '
ElseIf M->CFORMUL == 'S' .and. ! lNotaCon
	CESPECIE := 'SPED'
EndIf

Return(lRet)
