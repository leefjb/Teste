#include 'protheus.ch'


// ###################################################################################################
// integracao com AGING - EXCEL 
User Function RetCelXls( a )

Local cFormatedString := 'Erro na formula'
Local aString         := Array(0)
Local cString         := a  //PARAMIXB

If ! Empty( cString )
	aString         := u_PVScan( cString, Len(cString) )
	If Len( aString ) >= 2
		cFormatedString := aString[1] + ' a ' + aString[2]
	EndIf
EndIf

Return( cFormatedString )


// retorno dados financeiros do cliente (vencidos)
User Function RetSldFin( a, b, c, d )

Local cFormatedString := 'Erro na formula'
Local aString         := Array(0)
Local cString         := c // PARAMIXB
Local dDtIni
Local dDtFim

// se recalcula = S
If d $ 'Ss'
	
	If ! Empty( cString )
		// formato de cString: CLIENTE;LOJA;FAIXA_INI;FAIXA_FIM
		aString         := u_PVScan( cString, Len(cString) )
		If Len( aString ) >= 2
			dDtIni := dDataBase - Val(aString[1])
			dDtFim := dDataBase - Val(aString[2])
	
			// para efeito de depuracao
			/*
			CONOUT('Data Base: '+dtos(dDataBase)+'  String[3]: '+aString[3]+'  string[4]: '+aString[4])
			conout(dtos(dDtIni))
			conout(dtos(dDtFim))
			*/
	
	//			SE1.E1_CLIENTE = %exp:aString[1]% AND
	//			SE1.E1_LOJA = %exp:aString[2]% AND
	
			
			BeginSql Alias 'TMP'
				SELECT Sum(E1_SALDO) as TMP_SALDO
				FROM %Table:SE1% SE1
				WHERE
				SE1.E1_FILIAL = %xFilial:SE1% AND
				SE1.E1_TIPO = 'NF ' AND
				SE1.E1_CLIENTE = %exp:a% AND
				SE1.E1_LOJA = %exp:b% AND
				SE1.E1_VENCREA >= %exp:Dtos(dDtIni)% AND
				SE1.E1_VENCREA <= %exp:Dtos(dDtFim)% AND
				SE1.E1_SALDO > 0 AND 
				SE1.%NotDel%
			EndSql
			
			nSaldo := TMP->TMP_SALDO
			dbSelectArea('TMP')
	        dbCloseArea()
			
		EndIf
	EndIf

EndIf

Return( nSaldo )


// retorno dados financeiros do cliente (a vencer)
User Function SldFinAv( a, b, c, d )

Local cFormatedString := 'Erro na formula'
Local aString         := Array(0)
Local cString         := c  //PARAMIXB
Local dDtIni
Local dDtFim

// se recalcula = S
If d $ 'Ss'

	If ! Empty( cString )
		// formato de cString: CLIENTE;LOJA;FAIXA_INI;FAIXA_FIM
		aString         := u_PVScan( cString, Len(cString) )
		If Len( aString ) >= 2
			dDtIni := dDataBase + Val(aString[1])
			dDtFim := dDataBase + Val(aString[2])
	
			// para efeito de depuracao
			/*
			CONOUT('Data Base: '+dtos(dDataBase)+'  String[3]: '+aString[3]+'  string[4]: '+aString[4])
			conout(dtos(dDtIni))
			conout(dtos(dDtFim))
			*/
			
			BeginSql Alias 'TMP'
				SELECT Sum(E1_SALDO) as TMP_SALDO
				FROM %Table:SE1% SE1
				WHERE
				SE1.E1_FILIAL = %xFilial:SE1% AND
				SE1.E1_TIPO = 'NF ' AND
				SE1.E1_CLIENTE = %exp:a% AND
				SE1.E1_LOJA = %exp:b% AND
				SE1.E1_VENCREA >= %exp:Dtos(dDtIni)% AND
				SE1.E1_VENCREA <= %exp:Dtos(dDtFim)% AND
				SE1.E1_SALDO > 0 AND 
				SE1.%NotDel%
			EndSql
			
			nSaldo := TMP->TMP_SALDO
			dbSelectArea('TMP')
	        dbCloseArea()
			
		EndIf
	EndIf
	
EndIf	

Return( nSaldo )


User Function __RetCpoSA1( a )
Local aString         := Array(0)
Local cString         := a  // PARAMIXB
Local cFormatedString := 'Erro na formula'

If ! Empty( cString )
	// formato de cString: CLIENTE;LOJA;FAIXA_INI;FAIXA_FIM
	aString         := u_PVScan( cString, Len(cString) )
	If Len( aString ) >= 1
		SA1->( dbSeek(xFilial('SA1')+Padr(aString[1],6)+Padr(aString[2],2)) )
		If ! Empty(SA1->A1_NREDUZ)
			cFormatedString := SA1->A1_NREDUZ
		Else
			cFormatedString := SA1->A1_NOME
		EndIf
	EndIf
EndIf

Return( cFormatedString )


User Function RetClie( a, b, c, d, e, f, g, h )
Local aSa1    := Array(0)

If Len(Alltrim(f)) > 1
	cClasse := (StrTran(f, ",", "','"))
Else
	cClasse := f
EndIf

If a $ 'Ss'
	BeginSql Alias 'TMP'
		SELECT A1_COD, 
		       A1_LOJA, 
		       A1_NREDUZ, 
		       A1_VEND, 
		       A1_CLASSE, 
		       A1_COND, 
		       A1_LC, 
		       A1_MATR, 
		       A1_METR, 
		       SUM(D2_TOTAL) as TMP_TOTAL
		FROM SA1010 SA1, SD2010 SD2, SF4010 SF4
		WHERE
		SD2.D2_FILIAL = %xfilial:SD2% AND
	    SD2.D2_EMISSAO >= %exp:Dtos(d)% AND
	    SD2.D2_EMISSAO <= %exp:Dtos(e)% AND
		SD2.D2_CLIENTE = SA1.A1_COD AND 
		SD2.D2_LOJA = SA1.A1_LOJA AND
		SD2.D_E_L_E_T_ <> '*' AND 
		SA1.A1_FILIAL = %xfilial:SA1% AND
		SA1.A1_COD >= %exp:b% AND 
		SA1.A1_COD <= %exp:c% AND 
		SA1.A1_LOJA >= %exp:g% AND
		SA1.A1_LOJA <= %exp:h% AND 
		SA1.A1_MSBLQL <> '1' AND
		SA1.A1_CLASSE in (%exp:cClasse%) AND
		SA1.D_E_L_E_T_ <> '*' AND 
		SF4.F4_FILIAL = %xfilial:SF4% AND
		SF4.F4_CODIGO = SD2.D2_TES AND
		SF4.F4_DUPLIC = 'S' AND
		SF4.D_E_L_E_T_ <> '*'
		GROUP BY A1_COD, A1_LOJA, A1_NREDUZ, A1_VEND, A1_CLASSE, A1_COND, A1_LC, A1_MATR, A1_METR
		ORDER BY A1_COD, A1_LOJA
	EndSql
	
	Do While !Eof()
		aadd(aSa1, {TMP->A1_COD, TMP->A1_LOJA, TMP->A1_NREDUZ, TMP->A1_VEND, TMP->A1_CLASSE, TMP->A1_COND, TMP->A1_LC, TMP->A1_MATR, TMP->A1_METR, TMP->TMP_TOTAL })
		dbSkip()
	EndDo
	
	dbSelectArea('TMP')
	dbCloseArea()

EndIf

Return( aSa1 )
