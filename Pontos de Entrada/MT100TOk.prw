#include 'protheus.ch'

/* ALTERAR O CONTEUDO DE F1_ESPECIE PARA SPED QUANDO SE TRATAR DE FORMULARIO PROPRIO */
User Function MT100TOk()
	Local lRet     := .T.
	Local lNotaCon := .F.
	Local cTESVale := GetMV('ES_TESVALE')
	Local nPTES    := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_TES" } )
	Local nPORI    := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_SERIORI" } )

	Local _nDocOri := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_NFORI" } )
	Local _nCod	   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_COD" } )
	Local _nQuant  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_QUANT" } )
	Local _nVunit  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_VUNIT" } )
	Local _nTotal  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_TOTAL" } )
	Local _aFin	   := {}
	Local _cFatura := ""
	Local _aArea   := GetArea()
	
	Local _cCF	   := ""
	Local nCF      := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "D1_CF" } )
	Local _cCF	   := ""


	// verificar se a nota origem eh um vale (serie CON)
	//For nx := 1 To Len(aCols)
	//	If aCols[nx, nPORI] $ 'CON/PER'
	//		lNotaCon  := .t.
	//	EndIf

	// verificar se as TES utilizadas sao de retorno de vale
	//	If aCols[nx, nPORI] $ 'CON/PER' .AND. ! (aCols[nx, nPTES] $ cTESVale)
	//		lRet  := .F.
	//	EndIf
	//Next

	// valida se foi utilizado uma TES que nao eh de retorno do vale
	If ! lRet
		MsgInfo('Foi utilizada uma TES que não é de retorno de Vale! Corrija antes de confirmar.')
		Return( .F. )
	EndIf

	// verificar a especie da nota
	If M->CFORMUL == 'S' .and. lNotaCon
		CESPECIE := '   '
	ElseIf M->CFORMUL == 'S' .and. ! lNotaCon
		CESPECIE := 'SPED'
	EndIf


	//verificar CFOPs - item do documento de entrada - divergentes
	If( lRet == .T. .and. ( Type("oGetDados:oBrowse") <> "U" .or. "JOMACD14" $ FunName() ) )
		For _x:= 1 to Len(aCols)
			If ( (! Alltrim(aCols[_x][nCF]) $ _cCF ) .and. acols[_x][Len(acols[_x])] == .F.) 
				If (Empty(_cCF))
					_cCF := Alltrim(aCols[_x][nCF])
				Else	 
					lRet := .F. 
					Aviso("CFOP(s) divergentes!","Itens do documento com CFOP(s) divergentes, por favor revisar.", {"OK"} )
					//MsgAlert("Itens do documento com CFOP(s) divergentes, por favor revisar.","CFOP(s) divergentes!")
					_x:= Len(aCols) + 1
				EndIf
			EndIf
		Next _x
	EndIf
	


	//Validando devolucao - aviso quando existir baixa do titulo do documento original
	If ( lRet == .T. .and. CTIPO == "D" .and. Type("oGetDados:oBrowse") <> "U"   ) //.and. CFORMUL == "S"

		_aTitBx	:= {}

		For _x:= 1 to Len(aCols)

			_aFin := u_xProcTit( aCols[_x][_nDocOri], aCols[_x][nPORI] ) //verifica se exzistem baixas para o titulo doc. original
			_cFatura:= Posicione("SF4",1,xFilial("SF4") +  aCols[_x][nPTES],"F4_DUPLIC")
			If ( _aFin[1] == .F. .and. _cFatura == "S" ) //Existem baixas do titulo doc. original e Tes de Devolução gera duplicata
				//NFORIGINAL - SERIEORIGINAL - PRODUTO - QUANTIDADE - VUNITARIO - VTOTAL - NOMECLIENTE - EMISSAO
				AADD( _aTitBx, { aCols[_x][nPORI], aCols[_x][_nDocOri] , aCols[_x][_nCod], aCols[_x][_nQuant], aCols[_x][_nVUnit] , aCols[_x][_nTotal],_aFin[2],_aFin[3] })
			EndIf

		Next _x

		If ( Len(_aTitBx) > 0)
			If (MSGYESNO("Existem baixas para o(s) Documento(s) Original(s), Gerar devolução ?", "# Movimento vai gerar Título NCC !" ))
				U_xWFDevNCC(_aTitBx)
			Else
				lRet := .F.
			EndIf
		EndIf

	EndIf


	RestArea(_aArea)


Return(lRet)
