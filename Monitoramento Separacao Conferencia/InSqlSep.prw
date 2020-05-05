/*/ Jean Rehermann - 27/11/2007 - Função para adequar uma string ao comando IN do SQL /*/
User Function InSqlSep( StrIn, Separa, SepUni )

	Local _cInSql := ""
	Local _nCont
	Local _nChar := ''
	Local Separa := Iif( SepUni == Nil, Separa, SepUni )
	Separa := Iif( !ValType( Separa ) == "C", "/", Separa )
	
	If( !Empty( StrIn ) )
		_cInSql := "('"
		For _nCont := 1 To Len( LTrim( StrIn ) )
			_nChar := SubStr( StrIn, _nCont, 1 )
			If !( _nChar $ Separa )
				_cInSql += _nChar
				If( Separa == "" .And. _nCont < Len( LTrim( StrIn ) ) )
					_cInSql += "','"
				EndIf
			Else
				If( _nCont > 1 .And. _nCont < Len( AllTrim( StrIn ) ) )
					_cInSql += "','"
				EndIf
			EndIf
		Next _nCont
		_cInSql += "')"
	EndIf

Return( _cInSql )
