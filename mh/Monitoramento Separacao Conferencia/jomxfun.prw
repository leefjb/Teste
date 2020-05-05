#include 'protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao   ³ PVScan     ³ Autor ³ Marllon Figueiredo   ³ Data ³16/09/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o³ Funcao utilizada para separar strings delimitadas por um    ³±±
±±³         ³ marcador e retornar as mesmas em um array simples           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Paramentr³ cString      -  String passada para ser processada          ³±±
±±³         ³                                                             ³±±
±±³         ³ nTamax       -  Tamanho maximo da string                    ³±±
±±³         ³                                                             ³±±
±±³         ³ cQuebra      -  marcador para quebra de linha               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno  ³ Retorna um array simples com as strings separadas           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PVScan( cString, nTamax, cCarLinha )
Local aString   := Array(0)
Local cParte    := Space(0)
Local nPos      := 0


DEFAULT cCarLinha := ';'

// processa a separacao da string
Do While Len(cString) > 0
	// posicao da marca delimitadora dentro da string
	nPos := At(cCarLinha, cString)
	If nPos > 0
		// pega a parte da string
		cParte := SubStr(cString, 1, nPos-1)
		// limpo a string
		cString := SubStr(cString, At(cCarLinha, cString)+Len(cCarLinha))
		// adiciono no array de retorno
		Aadd(aString, cParte)
	Else
		If Len(cString) > 0
			Aadd(aString, cString)
			Exit
		EndIf
    EndIf
EndDo

Return(aString)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rotinas Monitoramento                            ³
//³                                                  ³
//³ Verifica se a filial utiliza o processo de       ³
//³ Monitor / Separacao / Conferencia                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function UseTrsf010()

	Local lUseTrsf010 := ( AllTrim( SuperGetMV( "TRS_MON001", .F., "" ) ) $ "12" )
	
Return( lUseTrsf010 )
