#Include "protheus.ch"
#include "sigawin.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JOMRFIN  º Autor ³ FABIO BRIDDI       º Data ³  05/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELATORIO DO MOVIMENTO FINANCEIRO / DISPONIBILIDADE DIARIA º±±
±±º          ³ E FLUXO DE CAIXA SINTETICO E ANALITICO                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EXCLUSIVO JOMHEDICA                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function JOMRFIN()
Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
Local   cDesc3      := "MOVIMENTO FINANCEIRO / DISPONIBILIDADES DIARIAS"
Local   cPict       := ""
Local   titulo      := "MOVIMENTO FINANCEIRO / DISPONIBILIDADES DO DIA "+ DtoC(ddatabase-1)
Local   nLin        := 80
//Local   Cabec1      := "Agenc Conta      Banco                Lim Credito Saldo Inicial      Entradas        Saidas    Disponivel   C.Garantida   Aplicações"
Local   Cabec1      := "Agenc Conta      Banco  Lim Credito Saldo Inicial      Entradas        Saidas         Saldo   C.Garantida    Disponivel   Aplicações""
//                      99999 1234567890 123456789012345678  9.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 9.999.999,99
//                      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567901234567890123456789012
//                                1         2         3         4         5         6         7         8         9        10       11        12        13
Local   Cabec2      := ""
Local   imprime     := .T.
Local   aOrd        := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "JOMRFIN"
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "JOMRFIN"
Private cString     := "SE5"
Private aRecbtos := {}
Private aPagtos  := {}

DbSelectArea("SE8")
DbSetOrder(1)
DbSelectArea("SE5")
DbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd,.f.,Tamanho,,.f.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  11/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa JOMRFIN                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local nQtdSE5 := 0
Local cQuery  := ""
Local lFound  := .F.

dRef := (dDataBase -1)

DbSelectArea("SE5")
DbSetOrder(1)

Do While .T.
	If DbSeek(xFilial("SE5") + DtoS(dRef))
		Exit
    EndIf
	dRef := (dRef - 1)
EndDo

DbSelectArea("SA6")
DbSetOrder(1)
SetRegua(RecCount())
dbGoTop()

aBancos   := {}

Do While !EOF() .and. SA6->A6_FILIAL == xFilial('SA6')
	// nao pego bancos bloqueados
	If SA6->A6_BLOCKED = '1'
		dbSkip()
		Loop
	EndIf
	// somente banco para fluxo de caixa
	If SA6->A6_FLUXCAI = 'N'
		dbSkip()
		Loop
	EndIf

	IncRegua()
	DbSelectArea("SE5")
	DbSetOrder(1)
	lFound := DbSeek(xFilial("SE5") + DtoS(dRef) + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON )
	
	cBcoAnt   := SE5->E5_BANCO
	cAgeAnt   := SE5->E5_AGENCIA
	cCtaAnt   := SE5->E5_CONTA

	If lFound
		nDespesas := 0
		nEntradas := 0
		nSaidas   := 0
		Do While !EOF() .And. SE5->E5_DATA    = dRef;
						.And. SE5->E5_BANCO   = SA6->A6_COD;
						.And. SE5->E5_AGENCIA = SA6->A6_AGENCIA;
						.And. SE5->E5_CONTA   = SA6->A6_NUMCON
		
        	// nao pego adiantamentos
			If SE5->E5_TIPO = "RA"
				DbSkip()
				Loop
			EndIf
			// nao pego descontos
			If SE5->E5_TIPODOC = "DC"
				DbSkip()
				Loop
			EndIf
			
			// recupera despesas bancarias em substituicao a coluna "a Compensar"
			If SE5->E5_MOEDA = 'DS'
				nDespesas += SE5->E5_VALOR
            EndIf
            
			If SE5->E5_RECPAG = "R"
				cNomeCli := POSICIONE("SA1",1,xFilial("SA1")+SE5->E5_CLIENTE,"A1_NOME")
				AAdd(aRecbtos,{	SE5->E5_DATA,;
								SE5->E5_PREFIXO,;
								SE5->E5_NUMERO,;
								SE5->E5_PARCELA,;
								SE5->E5_TIPO,;
                    	    	SE5->E5_CLIFOR,;
								SUBSTR(cNomeCli,1,24),;
								SE5->E5_DTDIGIT,;
								SE5->E5_VALOR,;
								SUBSTR(SE5->E5_HISTOR,1,24),;
								SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA})
				If SE5->E5_MOEDA <> 'DS'
					nEntradas += SE5->E5_VALOR
				EndIf
			Else
				cNomeFor := POSICIONE("SA2",1,xFilial("SA2")+SE5->E5_CLIFOR,"A2_NOME")
				AAdd(aPagtos,{	SE5->E5_DATA,;                   //01
								SE5->E5_PREFIXO,;                //02
								SE5->E5_NUMERO,;                 //03
								SE5->E5_PARCELA,;                //04
								SE5->E5_TIPO,;                   //05
								SE5->E5_CLIFOR,;                 //06
								SUBSTR(cNomeFor,1,24),;          //07
								SE5->E5_DTDIGIT,;                //08
								SE5->E5_VALOR,;                  //09
								SUBSTR(SE5->E5_HISTOR,1,24),;    //10
								SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA})
				If SE5->E5_MOEDA <> 'DS'
					nSaidas += SE5->E5_VALOR
				EndIf
			EndIf
			DbSkip()
		EndDo
//						      1       2       3 4         5       6 7 8         9   10
		//AAdd(aBancos,{cBcoAnt,cAgeAnt,cCtaAnt,0,nEntradas,nSaidas,0,0,nDespesas,dRef})
		AAdd(aBancos,{cBcoAnt,cAgeAnt,cCtaAnt,0,nEntradas,nSaidas,0,0,0,dRef})
    Else

		DbSelectArea("SE5")
		DbSetOrder(3)
		dbGoTop()
		
		dXRef := (dRef - 1)
		
		If DbSeek(xFilial("SE5") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON)
		
			cQuery := "SELECT COUNT(*) TOTAL "
			cQuery += " FROM "+ RetSqlName("SE5")
			cQuery += " WHERE D_E_L_E_T_ = ' '"
			cQuery += "  AND E5_FILIAL   = '"+ xFilial("SE5")  +"'"
			cQuery += "  AND E5_BANCO    = '"+ SA6->A6_COD     +"'"
			cQuery += "  AND E5_AGENCIA  = '"+ SA6->A6_AGENCIA +"'"
			cQuery += "  AND E5_CONTA    = '"+ SA6->A6_NUMCON  +"'"
			cQuery += "  AND E5_DATA    <= '"+ DtoS( dXRef )   +"'"
			
			cQuery := ChangeQuery(cQuery)                           
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "QTDSE5", .F., .T.)
			nQtdSE5 := QTDSE5->TOTAL
			QTDSE5->( dbCloseArea() )
			
			If nQtdSE5 > 0

				DbSelectArea("SE5")
				DbSetOrder(1)
				dbGoTop()
				Do While .T.
					If DbSeek(xFilial("SE5") + DtoS(dXRef) + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON)
						AAdd(aBancos,{SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,0,0,0,0,0,0,dRef})  //dXRef})
	 					Exit
				    Else
				    EndIf
					dXRef := (dXRef - 1)
				EndDo
			
			Else
				AAdd(aBancos,{cBcoAnt,cAgeAnt,cCtaAnt,0,0,0,0,0,0,CtoD("  /  /  ")})
			EndIF
		Else
			AAdd(aBancos,{cBcoAnt,cAgeAnt,cCtaAnt,0,0,0,0,0,0,CtoD("  /  /  ")})
		EndIF

    EndIf
	
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSkip()
EndDo

// ordena o pagamentos e recebimentos por banco
aRecbtos := aSort(aRecbtos,,, {|x,y| x[11] >= y[11]})
aPagtos  := aSort(aPagtos,,, {|x,y| x[11] >= y[11]})

SetRegua(Len(aBancos))

For nCont := 1 To Len(aBancos)
	IncRegua()
	If !Empty(aBancos[nCont,10])
		DbSelectArea("SE8")
		DbSetOrder(1)
		cBcoAnt := aBancos[nCont,1]
		cAgeAnt := aBancos[nCont,2]
		cCtaAnt := aBancos[nCont,3]
		DbSeek(xFilial("SE8") + cBcoAnt + cAgeAnt + cCtaAnt + DtoS(aBancos[nCont,10]), .t.)
		If xFilial("SE8") + cBcoAnt + cAgeAnt + cCtaAnt == SE8->E8_FILIAL+SE8->E8_BANCO+SE8->E8_AGENCIA+SE8->E8_CONTA
			If SE8->E8_DTSALAT > aBancos[nCont,10]
				DbSkip(-1)
				If xFilial("SE8") + cBcoAnt + cAgeAnt + cCtaAnt == SE8->E8_FILIAL+SE8->E8_BANCO+SE8->E8_AGENCIA+SE8->E8_CONTA
					// pega saldo inicial
					aBancos[nCont,4] := SE8->E8_SALATUA
					// pega saldo disponivel no dia do relatorio
					aBancos[nCont,7] := SE8->E8_SALATUA
				Else
					// pega saldo inicial
					aBancos[nCont,4] := 0
					// pega saldo disponivel no dia do relatorio
					aBancos[nCont,7] := 0
				EndIf
			Else
				// pega saldo disponivel no dia do relatorio
				aBancos[nCont,7] := SE8->E8_SALATUA
				If (SE8->E8_DTSALAT - aBancos[nCont,10]) > 1
					// pega saldo inicial
					aBancos[nCont,4] := SE8->E8_SALATUA
				Else
					DbSkip(-1)
					// pega saldo inicial
					aBancos[nCont,4] := SE8->E8_SALATUA
				EndIf
			EndIf
	    Else
			dbSkip(-1)
			If xFilial("SE8") + cBcoAnt + cAgeAnt + cCtaAnt == SE8->E8_FILIAL+SE8->E8_BANCO+SE8->E8_AGENCIA+SE8->E8_CONTA
				aBancos[nCont,7] := SE8->E8_SALATUA
				aBancos[nCont,4] := SE8->E8_SALATUA
			EndIf
	    EndIf
		DbSelectArea("SEH")
		DbOrderNickName("JOM001")
		nAplicacoes := 0
		nEmprestimo := 0
		If DbSeek(xFilial("SEH")+ cBcoAnt + cAgeAnt + cCtaAnt)
			Do While !Eof() .And. SEH->EH_BANCO   = cBcoAnt;
							.And. SEH->EH_AGENCIA = cAgeAnt;
							.And. SEH->EH_CONTA   = cCtaAnt
				If SEH->EH_APLEMP = 'APL'
					nAplicacoes += SEH->EH_SALDO
				Else
					nEmprestimo += SEH->EH_SALDO
				EndIf
				DbSkip()
			EndDo
			aBancos[nCont,8] := nAplicacoes
			aBancos[nCont,9] := nEmprestimo
		EndIf
	EndIf
Next

nTotLim := 0
nTotIni := 0
nTotEnt := 0
nTotSai := 0
nTotFin := 0
nTotApl := 0
nTotCom := 0
nTotDis := 0
titulo  := "MOVIMENTO FINANCEIRO / DISPONIBILIDADES DO DIA: " + DtoC(dRef)

SetRegua(Len(aBancos))

For nCont := 1 To Len(aBancos)
	nSaldoDisp := 0
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// lista apenas banco com saldo (solicitado em 2013-03-15 para listar todos os bancos sem considerar o saldo (Enio/Aline)
	//If aBancos[nCont,4] # 0
		cNomeBanco   := POSICIONE("SA6",1,xFilial("SA6")+aBancos[nCont,1]+aBancos[nCont,2]+aBancos[nCont,3],"A6_NOME")
		cLimCredito  := POSICIONE("SA6",1,xFilial("SA6")+aBancos[nCont,1]+aBancos[nCont,2]+aBancos[nCont,3],"A6_LIMCRED")

//      Agenc Conta      Banco   Lim Credito Saldo Inicial      Entradas        Saidas         Saldo   C.Garantida    Disponivel   Aplicações"
//      99999 1234567890 12345  9.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 9.999.999,99
//      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                1         2         3         4         5         6         7         8         9        10        11        12        13

		@ nLin , 000 PSay aBancos[nCont,2]                                   // AGENCIA
		@ nLin , 006 PSay aBancos[nCont,3]                                   // CONTA
		@ nLin , 017 PSay SubStr(cNomeBanco,1,5)  //20                       // NOME DO BANCO
// subtrai 15 das colunas

		nSaldoDisp := aBancos[nCont,7] + cLimCredito +  aBancos[nCont,9]

		@ nLin , 024 PSay Transform(cLimCredito     ,"@E 9,999,999.99")     // LIMITE DE CREDITO
		@ nLin , 037 PSay Transform(aBancos[nCont,4],"@E 99,999,999.99")     // SALDO INICIAL
		@ nLin , 051 PSay Transform(aBancos[nCont,5],"@E 99,999,999.99")     // ENTRADAS
		@ nLin , 065 PSay Transform(aBancos[nCont,6],"@E 99,999,999.99")     // SAIDAS
		@ nLin , 079 PSay Transform(aBancos[nCont,7],"@E 99,999,999.99")     // SALDO
		@ nLin , 093 PSay Transform(aBancos[nCont,9],"@E 99,999,999.99")     // C.GARANTIA
		@ nLin , 107 PSay Transform(nSaldoDisp,"@E 99,999,999.99")           // DISPONIVEL
		@ nLin , 121 PSay Transform(aBancos[nCont,8],"@E 9,999,999.99")      // APLICACOES

		nTotLim += cLimCredito
		nTotIni += aBancos[nCont,4]
		nTotEnt += aBancos[nCont,5]
		nTotSai += aBancos[nCont,6]
		nTotFin += aBancos[nCont,7]
		nTotApl += aBancos[nCont,8]
		nTotCom += aBancos[nCont,9]
		nTotDis += nSaldoDisp
		nLin++
	//EndIf
Next

nLin++
nLin++

@ nLin , 000 PSay "T o t a l   G e r a l:"
@ nLin , 023 PSay Transform(nTotLim,"@E 99,999,999.99")
@ nLin , 037 PSay Transform(nTotIni,"@E 99,999,999.99")
@ nLin , 051 PSay Transform(nTotEnt,"@E 99,999,999.99")
@ nLin , 065 PSay Transform(nTotSai,"@E 99,999,999.99")
@ nLin , 079 PSay Transform(nTotFin,"@E 99,999,999.99")
@ nLin , 093 PSay Transform(nTotCom,"@E 99,999,999.99")
@ nLin , 107 PSay Transform(nTotDis,"@E 99,999,999.99")
@ nLin , 121 PSay Transform(nTotApl,"@E 9,999,999.99")
nLin++
nLin++
@ nLin,000 PSAY __PrtThinLine()
nLin++

DbSelectArea("SE1")
DbSetOrder(7)

dRefFin  := dRef + 30
aTitulos := {}

dbSeek(xFilial("SE1") + DtoS(dDataBase), .t.)
SetRegua(RecCount())
Do While !Eof() .And. SE1->E1_VENCREA >= dDataBase .And. SE1->E1_VENCREA <= dRefFin
	IncRegua()

	// estrutura de aTitulos
	// 1 - Data
	// 2 - Recebimento Nivel A
	// 3 - Recebimento Nivel B
	// 4 - Cheques
	// 5 - Fornecedor
	// 6 - Banco/Impos
	// 7 - Outros
	// 6 - Saldo

	// posiciona no SA1
	SA1->( dbSeek(xFilial('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA) )

	dDataFin  := SE1->E1_VENCREA
	nNivelA   := 0
	nNivelB   := 0
	nCheques  := 0

	// nao considero PAs/RAs pois os mesmos ja fazem parte do saldo do banco
	If AllTrim(SE1->E1_TIPO) $ "PA/RA"
		dbSkip()
		Loop
	EndIf
	If AllTrim(SE1->E1_TIPO) = "CH"
		nCheques  := SE1->E1_SALDO
	ElseIf SA1->A1_CLASSE = 'A'
		nNivelA   := SE1->E1_SALDO
	Else
		nNivelB   := SE1->E1_SALDO
	EndIf

	// verifica se o dia ja esta no array
	nPos := Ascan(aTitulos, {|X| X[1] == dDataFin})
	If nPos == 0
		Aadd(aTitulos,{dDataFin, nNivelA, nNivelB, nCheques, 0, 0, 0, 0})
	Else
		aTitulos[nPos,2] += nNivelA
		aTitulos[nPos,3] += nNivelB
		aTitulos[nPos,4] += nCheques
	EndIf
	DbSkip()
EndDo

DbSelectArea("SE2")
DbSetOrder(3)

dbSeek(xFilial("SE2") + DtoS(dDataBase), .t.)
SetRegua(RecCount())
Do While !Eof() .And. SE2->E2_VENCREA >= dDataBase .And. SE2->E2_VENCREA <= dRefFin
	IncRegua()

	// posiciona no SA2
	SA2->( dbSeek(xFilial('SA2')+SE2->E2_FORNECE+SE2->E2_LOJA) )

	dDataFin  := SE2->E2_VENCREA
	nFornece  := 0
	nColabor  := 0
	nOutros   := 0

	// nao considero PAs/RAs pois os mesmos ja fazem parte do saldo do banco
	If AllTrim(SE2->E2_TIPO) $ "PA/RA"
		dbSkip()
		Loop
	EndIf
	If AllTrim(SA2->A2_CLASSE) = '1'      // Fornecedor
		nFornece  := SE2->E2_SALDO
	ElseIf AllTrim(SA2->A2_CLASSE) = '2'  // Banco/Impos
		nColabor  := SE2->E2_SALDO
	Else
		nOutros  := SE2->E2_SALDO         // Outros
	EndIf
	
	// verifica se o dia ja esta no array
	nPos := Ascan(aTitulos, {|X| X[1] == dDataFin})
	If nPos == 0
		Aadd(aTitulos,{dDataFin, 0, 0, 0, nFornece, nColabor, nOutros, 0})
	Else
		aTitulos[nPos,5] += nFornece
		aTitulos[nPos,6] += nColabor
		aTitulos[nPos,7] += nOutros
	EndIf
	DbSkip()
EndDo

SetRegua(Len(aTitulos))

// ordena por data
aTitulos := ASort(aTitulos,,, {|x,y| Dtos(x[1]) <= Dtos(y[1])})
nSaldo   := nTotFin                 

For nCont := 1 To Len(aTitulos)
	IncRegua()
	nSaldo            := (nSaldo + aTitulos[nCont,2] + aTitulos[nCont,3]) + aTitulos[nCont,4] - aTitulos[nCont,5] - aTitulos[nCont,6] - aTitulos[nCont,7]
	aTitulos[nCont,8] := nSaldo
Next

SetRegua(Len(aTitulos))

//nLin++
@ nLin , 000 PSay PADC("FLUXO DE CAIXA PROJETADO",132," ")
nLin++
@ nLin,000 PSAY __PrtThinLine()
nLin++
@ nLin , 000 PSay "                  R E C E B I M E N T O S                                              P A G A M E N T O S                       "
nLin++
@ nLin , 000 PSay "-----------------------------------------------------------     -----------------------------------------------------------------"
nLin++
//                "99-99-99    99,999,999.99    99,999,999.99    99,999,999.99     99,999,999.99    99,999,999.99    99,999,999.99    999,999,999.99"
//                 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567901234567890123456789012
//                           1         2         3         4         5         6         7         8         9        10       11        12        13
@ nLin , 000 PSay "Data              Nivel A          Nivel B          Cheques        Fornecedor      Banco/Impost          Outros             Saldo"
nLin++
@ nLin,000 PSAY __PrtThinLine()
nLin++
nLin++
@ nLin , 000 PSay "Saldo Inicial"
@ nLin , 116 PSay Transform(nTotFin,"@E 999,999,999.99")
nLin++

// totalizadores
nNivela    := 0
nNivelb    := 0
nCheques   := 0
nFornece   := 0
nColab     := 0
nOutros    := 0

For nCont := 1 To Len(aTitulos)
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If nLin > 55
		Cabec1 := ""
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	@ nLin , 000 PSay DtoC(aTitulos[nCont,1])                           // Data
	@ nLin , 012 PSay Transform(aTitulos[nCont,2],"@E 99,999,999.99")   // Nivel A
	@ nLin , 029 PSay Transform(aTitulos[nCont,3],"@E 99,999,999.99")   // Nivel B
	@ nLin , 046 PSay Transform(aTitulos[nCont,4],"@E 99,999,999.99")   // Cheques
	@ nLin , 064 PSay Transform(aTitulos[nCont,5],"@E 99,999,999.99")   // Fornecedor
	@ nLin , 081 PSay Transform(aTitulos[nCont,6],"@E 99,999,999.99")   // Banco/Impos
	@ nLin , 098 PSay Transform(aTitulos[nCont,7],"@E 99,999,999.99")   // Outros
	@ nLin , 116 PSay Transform(aTitulos[nCont,8],"@E 999,999,999.99")  // Saldo

	nNivela    += aTitulos[nCont,2]
	nNivelb    += aTitulos[nCont,3]
	nCheques   += aTitulos[nCont,4]
	nFornece   += aTitulos[nCont,5]
	nColab     += aTitulos[nCont,6]
	nOutros    += aTitulos[nCont,7]

	nLin++
Next

// ***********************  demonstra totais dos 30 dias  ******************************* //
nLin++
@ nLin , 000 PSay '30 Dias'
@ nLin , 012 PSay Transform(nNivela, "@E 99,999,999.99")   // Nivel A
@ nLin , 029 PSay Transform(nNivelb, "@E 99,999,999.99")   // Nivel B
@ nLin , 046 PSay Transform(nCheques,"@E 99,999,999.99")   // Cheques
@ nLin , 064 PSay Transform(nFornece,"@E 99,999,999.99")   // Fornecedor
@ nLin , 081 PSay Transform(nColab,  "@E 99,999,999.99")   // Banco/Impos
@ nLin , 098 PSay Transform(nOutros, "@E 99,999,999.99")   // Outros
nLin++
@ nLin,000 PSAY __PrtThinLine()


// ***********************  demonstra totais de 31 a 60 dias  ******************************* //
DbSelectArea("SE1")
DbSetOrder(7)

nTNivelA   := nNivela
nTNivelB   := nNivelb
nTCheques  := nCheques
nTFornece  := nFornece
nTColabor  := nColab
nTOutros   := nOutros
nTSaldo    := nSaldo
dDataIni   := dRefFin + 1
dRefFin    := dRefFin + 30
aTitulos   := {'',0,0,0,0,0,0,0}

dbSeek(xFilial("SE1") + DtoS(dDataIni), .t.)
SetRegua(RecCount())
Do While !Eof() .And. SE1->E1_VENCREA >= dDataIni .And. SE1->E1_VENCREA <= dRefFin
	IncRegua()

	nNivelA   := 0
	nNivelB   := 0
	nCheques  := 0

	// posiciona no SA1
	SA1->( dbSeek(xFilial('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA) )

	// nao considero PAs/RAs pois os mesmos ja fazem parte do saldo do banco
	If AllTrim(SE1->E1_TIPO) $ "PA/RA"
		dbSkip()
		Loop
	EndIf
	If AllTrim(SE1->E1_TIPO) = "CH"
		nCheques  := SE1->E1_SALDO
	ElseIf SA1->A1_CLASSE = 'A'
		nNivelA   := SE1->E1_SALDO
	Else
		nNivelB   := SE1->E1_SALDO
	EndIf

	aTitulos[2] += nNivelA
	aTitulos[3] += nNivelB
	aTitulos[4] += nCheques

	nTNivelA   += nNivelA
	nTNivelB   += nNivelB
	nTCheques  += nCheques

	dbSkip()
EndDo
nTSaldo    += (aTitulos[2] + aTitulos[3] + aTitulos[4])

DbSelectArea("SE2")
DbSetOrder(3)

dbSeek(xFilial("SE2") + DtoS(dDataIni), .t.)
SetRegua(RecCount())
Do While !Eof() .And. SE2->E2_VENCREA >= dDataIni .And. SE2->E2_VENCREA <= dRefFin
	IncRegua()

	nFornece  := 0
	nColabor  := 0
	nOutros   := 0

	SA2->( dbSeek(xFilial('SA2')+SE2->E2_FORNECE+SE2->E2_LOJA) )

	// nao considero PAs/RAs pois os mesmos ja fazem parte do saldo do banco
	If AllTrim(SE1->E1_TIPO) $ "PA/RA"
		dbSkip()
		Loop
	EndIf
	If AllTrim(SA2->A2_CLASSE) = '1'      // Fornecedor
		nFornece  := SE2->E2_SALDO
	ElseIf AllTrim(SA2->A2_CLASSE) = '2'  // Banco/Impos
		nColabor  := SE2->E2_SALDO
	Else
		nOutros  := SE2->E2_SALDO         // Outros
	EndIf
	
	aTitulos[5] += nFornece
	aTitulos[6] += nColabor
	aTitulos[7] += nOutros

	nTFornece   += nFornece
	nTColabor   += nColabor
	nTOutros    += nOutros

	dbSkip()
EndDo
nTSaldo     -= (aTitulos[5] + aTitulos[6] + aTitulos[7])

nLin++
nLin++
@ nLin , 000 PSay 'de 31 a 60'
@ nLin , 012 PSay Transform(aTitulos[2], "@E 99,999,999.99")   // Nivel A
@ nLin , 029 PSay Transform(aTitulos[3], "@E 99,999,999.99")   // Nivel B
@ nLin , 046 PSay Transform(aTitulos[4], "@E 99,999,999.99")   // Cheques
@ nLin , 064 PSay Transform(aTitulos[5], "@E 99,999,999.99")   // Fornecedor
@ nLin , 081 PSay Transform(aTitulos[6], "@E 99,999,999.99")   // Banco/Impos
@ nLin , 098 PSay Transform(aTitulos[7], "@E 99,999,999.99")   // Outros
@ nLin , 116 PSay Transform(nTSaldo,     "@E 999,999,999.99")  // Saldo


// ***********************  demonstra totais de 61 a 90 dias  ******************************* //
DbSelectArea("SE1")
DbSetOrder(7)

dDataIni := dRefFin + 1
dRefFin  := dRefFin + 30
aTitulos := {'',0,0,0,0,0,0,0}

dbSeek(xFilial("SE1") + DtoS(dDataIni), .t.)
SetRegua(RecCount())
Do While !Eof() .And. SE1->E1_VENCREA >= dDataIni .And. SE1->E1_VENCREA <= dRefFin
	IncRegua()

	nNivelA   := 0
	nNivelB   := 0
	nCheques  := 0

	// posiciona no SA1
	SA1->( dbSeek(xFilial('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA) )

	// nao considero PAs/RAs pois os mesmos ja fazem parte do saldo do banco
	If AllTrim(SE1->E1_TIPO) $ "PA/RA"
		dbSkip()
		Loop
	EndIf
	If AllTrim(SE1->E1_TIPO) = "CH"
		nCheques  := SE1->E1_SALDO
	ElseIf SA1->A1_CLASSE = 'A'
		nNivelA   := SE1->E1_SALDO
	Else
		nNivelB   := SE1->E1_SALDO
	EndIf

	aTitulos[2] += nNivelA
	aTitulos[3] += nNivelB
	aTitulos[4] += nCheques

	nTNivelA   += nNivelA
	nTNivelB   += nNivelB
	nTCheques  += nCheques

	dbSkip()
EndDo
nTSaldo    += (aTitulos[2] + aTitulos[3] + aTitulos[4])

DbSelectArea("SE2")
DbSetOrder(3)

dbSeek(xFilial("SE2") + DtoS(dDataIni), .t.)
SetRegua(RecCount())
Do While !Eof() .And. SE2->E2_VENCREA >= dDataIni .And. SE2->E2_VENCREA <= dRefFin
	IncRegua()

	nFornece  := 0
	nColabor  := 0
	nOutros   := 0

	SA2->( dbSeek(xFilial('SA2')+SE2->E2_FORNECE+SE2->E2_LOJA) )

	// nao considero PAs/RAs pois os mesmos ja fazem parte do saldo do banco
	If AllTrim(SE1->E1_TIPO) $ "PA/RA"
		dbSkip()
		Loop
	EndIf
	If AllTrim(SA2->A2_CLASSE) = '1'      // Fornecedor
		nFornece  := SE2->E2_SALDO
	ElseIf AllTrim(SA2->A2_CLASSE) = '2'  // Banco/Impos
		nColabor  := SE2->E2_SALDO
	Else
		nOutros  := SE2->E2_SALDO         // Outros
	EndIf
	
	aTitulos[5] += nFornece
	aTitulos[6] += nColabor
	aTitulos[7] += nOutros

	nTFornece   += nFornece
	nTColabor   += nColabor
	nTOutros    += nOutros

	dbSkip()
EndDo
nTSaldo     -= (aTitulos[5] + aTitulos[6] + aTitulos[7])

nLin++
nLin++
@ nLin , 000 PSay 'de 61 a 90'
@ nLin , 012 PSay Transform(aTitulos[2], "@E 99,999,999.99")   // Nivel A
@ nLin , 029 PSay Transform(aTitulos[3], "@E 99,999,999.99")   // Nivel B
@ nLin , 046 PSay Transform(aTitulos[4], "@E 99,999,999.99")   // Cheques
@ nLin , 064 PSay Transform(aTitulos[5], "@E 99,999,999.99")   // Fornecedor
@ nLin , 081 PSay Transform(aTitulos[6], "@E 99,999,999.99")   // Banco/Impos
@ nLin , 098 PSay Transform(aTitulos[7], "@E 99,999,999.99")   // Outros
@ nLin , 116 PSay Transform(nTSaldo,     "@E 999,999,999.99")  // Saldo


// ***********************  demonstra totais acima de 90 dias  ******************************* //
DbSelectArea("SE1")
DbSetOrder(7)

dDataIni := dRefFin + 1
dRefFin  := dRefFin + 30
aTitulos := {'',0,0,0,0,0,0,0}

dbSeek(xFilial("SE1") + DtoS(dDataIni), .t.)
SetRegua(RecCount())
Do While !Eof() .And. SE1->E1_VENCREA >= dDataIni //.And. SE1->E1_VENCREA <= dRefFin
	IncRegua()

	nNivelA   := 0
	nNivelB   := 0
	nCheques  := 0

	// posiciona no SA1
	SA1->( dbSeek(xFilial('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA) )

	// nao considero PAs/RAs pois os mesmos ja fazem parte do saldo do banco
	If AllTrim(SE1->E1_TIPO) $ "PA/RA"
		dbSkip()
		Loop
	EndIf
	If AllTrim(SE1->E1_TIPO) = "CH"
		nCheques  := SE1->E1_SALDO
	ElseIf SA1->A1_CLASSE = 'A'
		nNivelA   := SE1->E1_SALDO
	Else
		nNivelB   := SE1->E1_SALDO
	EndIf

	aTitulos[2] += nNivelA
	aTitulos[3] += nNivelB
	aTitulos[4] += nCheques

	nTNivelA   += nNivelA
	nTNivelB   += nNivelB
	nTCheques  += nCheques

	dbSkip()
EndDo
nTSaldo    += (aTitulos[2] + aTitulos[3] + aTitulos[4])

DbSelectArea("SE2")
DbSetOrder(3)

dbSeek(xFilial("SE2") + DtoS(dDataIni), .t.)
SetRegua(RecCount())
Do While !Eof() .And. SE2->E2_VENCREA >= dDataIni //.And. SE2->E2_VENCREA <= dRefFin
	IncRegua()

	nFornece  := 0
	nColabor  := 0
	nOutros   := 0

	SA2->( dbSeek(xFilial('SA2')+SE2->E2_FORNECE+SE2->E2_LOJA) )

	// nao considero PAs/RAs pois os mesmos ja fazem parte do saldo do banco
	If AllTrim(SE1->E1_TIPO) $ "PA/RA"
		dbSkip()
		Loop
	EndIf
	If AllTrim(SA2->A2_CLASSE) = '1'      // Fornecedor
		nFornece  := SE2->E2_SALDO
	ElseIf AllTrim(SA2->A2_CLASSE) = '2'  // Banco/Impos
		nColabor  := SE2->E2_SALDO
	Else
		nOutros  := SE2->E2_SALDO         // Outros
	EndIf
	
	aTitulos[5] += nFornece
	aTitulos[6] += nColabor
	aTitulos[7] += nOutros

	nTFornece   += nFornece
	nTColabor   += nColabor
	nTOutros    += nOutros

	dbSkip()
EndDo
nTSaldo     -= (aTitulos[5] + aTitulos[6] + aTitulos[7])

nLin++
nLin++
@ nLin , 000 PSay 'acima de 90'
@ nLin , 012 PSay Transform(aTitulos[2], "@E 99,999,999.99")   // Nivel A
@ nLin , 029 PSay Transform(aTitulos[3], "@E 99,999,999.99")   // Nivel B
@ nLin , 046 PSay Transform(aTitulos[4], "@E 99,999,999.99")   // Cheques
@ nLin , 064 PSay Transform(aTitulos[5], "@E 99,999,999.99")   // Fornecedor
@ nLin , 081 PSay Transform(aTitulos[6], "@E 99,999,999.99")   // Banco/Impos
@ nLin , 098 PSay Transform(aTitulos[7], "@E 99,999,999.99")   // Outros
@ nLin , 116 PSay Transform(nTSaldo,     "@E 999,999,999.99")  // Saldo


// totalizacao final
nLin++
@ nLin,000 PSAY __PrtThinLine()
nLin++
@ nLin , 000 PSay 'Total Geral'
@ nLin , 012 PSay Transform(nTNivelA,  "@E 99,999,999.99")   // Nivel A
@ nLin , 029 PSay Transform(nTNivelB,  "@E 99,999,999.99")   // Nivel B
@ nLin , 046 PSay Transform(nTCheques, "@E 99,999,999.99")   // Cheques
@ nLin , 064 PSay Transform(nTFornece, "@E 99,999,999.99")   // Fornecedor
@ nLin , 081 PSay Transform(nTColabor, "@E 99,999,999.99")   // Banco/Impos
@ nLin , 098 PSay Transform(nTOutros,  "@E 99,999,999.99")   // Outros
nLin++
@ nLin,000 PSAY __PrtThinLine()



// TARASCONI - 19.01.2009 - PEGA TITULOS EM ATRASO NO SE1 E SE2
//como sao muitos registros atualmente, em torno de 3000, o programa ficou muito lento, demandando uma query para totalizar
cQuery := "SELECT * FROM " + RetSqlName("SE1") + " SE1, " + RetSqlName("SA1") + " SA1 "
cQuery += "WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"' AND "
cQuery += "SE1.E1_VENCREA >= '20050101' AND " //POR SOLICITACAO DO SR ENIO
cQuery += "SE1.E1_CLIENTE = SA1.A1_COD AND " 
cQuery += "SE1.E1_LOJA = SA1.A1_LOJA AND " 
cQuery += "SE1.E1_SALDO > 0 AND " 
cQuery += "SE1.E1_VENCREA <= '" + DtoS(dDataBase - 1) +"' AND "
cQuery += "SE1.E1_TIPO NOT IN ('PA','RA','NCC') AND "
cQuery += "SE1.D_E_L_E_T_ <> '*' AND "
cQuery += "SA1.D_E_L_E_T_ <> '*' "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SE1TRB', .F., .T.)

nNivelA   := 0
nNivelB   := 0
nCheques  := 0

dbSelectArea('SE1TRB')

While !Eof()

	If SE1TRB->E1_TIPO = "CH"
		nCheques  += SE1TRB->E1_SALDO
	ElseIf SE1TRB->A1_CLASSE = 'A'
		nNivelA   += SE1TRB->E1_SALDO
	Else
		nNivelB   += SE1TRB->E1_SALDO
	EndIf

	dbSkip()
EndDo

dbCloseArea('SE1TRB')


cQuery := "SELECT * FROM " + RetSqlName("SE2") + " SE2, " + RetSqlName("SA2") + " SA2 "
cQuery += "WHERE SE2.E2_FILIAL = '"+xFilial("SE2")+"' AND "
cQuery += "SE2.E2_FORNECE = SA2.A2_COD AND " 
cQuery += "SE2.E2_LOJA = SA2.A2_LOJA AND " 
cQuery += "SE2.E2_SALDO > 0 AND " 
cQuery += "SE2.E2_VENCREA < '" + DtoS(dDataBase - 1) +"' AND "
cQuery += "SE2.E2_TIPO NOT IN ('PA','RA') AND "
cQuery += "SE2.D_E_L_E_T_ <> '*' AND "
cQuery += "SA2.D_E_L_E_T_ <> '*' "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SE2TRB', .F., .T.)

nFornece  := 0
nColabor  := 0
nOutros   := 0

dbSelectArea('SE2TRB')

While !Eof()

	If SE2TRB->A2_CLASSE = '1'      // Fornecedor
		nFornece  := SE2TRB->E2_SALDO
	ElseIf SE2TRB->A2_CLASSE = '2'  // Banco/Impos
		nColabor  := SE2TRB->E2_SALDO
	Else
		nOutros  := SE2TRB->E2_SALDO         // Outros
	EndIf

	dbSkip()
EndDo

dbCloseArea('SE2TRB')


// totalizacao final
nLin++
@ nLin,000 PSAY __PrtThinLine()
nLin++
@ nLin , 000 PSay 'Atras. '
@ nLin , 012 PSay Transform(nNivelA+nNivelB+nCheques,  "@E 99,999,999.99")   // Nivel A

@ nLin , 032 PSay Transform( ((nNivelA+nNivelB+nCheques) / (nNivelA+nNivelB+nCheques+nTNivelA+nTNivelB+nTCheques)) * 100 ,  "@E 999.999") +  " %"

//@ nLin , 029 PSay Transform(nNivelB,  "@E 99,999,999.99")   // Nivel B
//@ nLin , 046 PSay Transform(nCheques, "@E 99,999,999.99")   // Cheques
@ nLin , 064 PSay Transform(nFornece+nColabor+nOutros, "@E 99,999,999.99")   // Fornecedor
//@ nLin , 081 PSay Transform(nColabor, "@E 99,999,999.99")   // Banco/Impos
//@ nLin , 098 PSay Transform(nOutros,  "@E 99,999,999.99")   // Outros
nLin++
@ nLin,000 PSAY __PrtThinLine()


//                   1         2         3         4         5         6         7         8         9        10       11        12        13
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567901234567890123456789012
//         99/99/9999        999       999999     9        999    999999   12345678901234567890   99/99/9999   999.999.9999,99
Cabec1 := "Data Recto    Prefixo   Num Titulo   Parcela   Tipo   Cliente   Nome/Historico         Dt Digitacao           Valor"
Titulo := "Relação Analítica dos Recebimentos de: " + DtoC(dRef)
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 9

cBanco := ''
If Len(aRecbtos) > 1
	dVectoAnt  := aRecbtos[1,1]
EndIf
nVlrTotDia := 0
nVlrTotRec := 0
nVlrTotBco := 0
For nCont := 1 To Len(aRecbtos)
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If cBanco <> aRecbtos[nCont,11]
		If nCont > 1
			// total do banco
			@ nLin , 040 PSay "Total do Banco ---->"
			@ nLin , 103 PSay Transform(nVlrTotBco,"@E 999,999,999.99")
			nLin++
			nLin++
			nVlrTotBco := 0
		Endif
		cBanco := aRecbtos[nCont,11]
		nLin++
		SA6->( dbSeek(xFilial('SA6')+cBanco) )
		@ nLin, 000 PSay "Banco: " + SA6->A6_NOME
		nLin++
	EndIf

/*
	If aRecbtos[nCont,1] # dVectoAnt
		@ nLin , 010 PSay "Total do Dia ---->"
		@ nLin , 100 PSay Transform(nVlrTotDia,"@E 999,999,999.99")
		nLin++
		nLin++
		nVlrTotDia := 0
		dVectoAnt  := aRecbtos[nCont,1]
	EndIf
*/
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	@ nLin , 000 PSay DtoC(aRecbtos[nCont,1])
	@ nLin , 018 PSay aRecbtos[nCont,2]
	@ nLin , 028 PSay aRecbtos[nCont,3]
	@ nLin , 039 PSay aRecbtos[nCont,4]
	@ nLin , 048 PSay aRecbtos[nCont,5]
	@ nLin , 055 PSay aRecbtos[nCont,6]
	@ nLin , 064 PSay Iif(!Empty(aRecbtos[nCont,7]),aRecbtos[nCont,7],aRecbtos[nCont,10])
	@ nLin , 090 PSay DtoC(aRecbtos[nCont,8])
	@ nLin , 103 PSay Transform(aRecbtos[nCont,9],"@E 999,999,999.99")
	nLin++
	nVlrTotDia += aRecbtos[nCont,9]
	nVlrTotRec += aRecbtos[nCont,9]
	nVlrTotBco += aRecbtos[nCont,9]
Next
// total do banco
@ nLin , 040 PSay "Total do Banco ---->"
@ nLin , 103 PSay Transform(nVlrTotBco,"@E 999,999,999.99")
nLin++
nLin++
nVlrTotBco := 0

/*
@ nLin , 010 PSay "Total do Dia ---->"
@ nLin , 103 PSay Transform(nVlrTotDia,"@E 999,999,999.99")
nLin++
nLin++
*/
@ nLin , 040 PSay "Total dos Recebimentos ---->"
@ nLin , 103 PSay Transform(nVlrTotRec,"@E 999,999,999.99")
nLin++
nLin++

Cabec1 := "Data Pagto    Prefixo   Num Titulo   Parcela   Tipo    Fornec   Nome/Historico         Dt Digitacao           Valor"
Titulo := "Relação Analítica dos Pagamentos de: " + DtoC(dRef)
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 9

cBanco     := ''
If Len(aPagtos) > 0
	dVectoAnt  := aPagtos[1,1]
EndIf
nVlrTotDia := 0
nVlrTotPag := 0
nVlrTotBco := 0
For nCont := 1 To Len(aPagtos)
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If cBanco <> aPagtos[nCont,11]
		If nCont > 1
			// total do banco
			@ nLin , 040 PSay "Total do Banco ---->"
			@ nLin , 103 PSay Transform(nVlrTotBco,"@E 999,999,999.99")
			nLin++
			nLin++
			nVlrTotBco := 0
		Endif
		cBanco := aPagtos[nCont,11]
		nLin++
		SA6->( dbSeek(xFilial('SA6')+cBanco) )
		@ nLin, 000 PSay "Banco: " + SA6->A6_NOME
		nLin++
	EndIf

/*
	If aPagtos[nCont,1] # dVectoAnt
		@ nLin , 010 PSay "Total do Dia ---->"
		@ nLin , 103 PSay Transform(nVlrTotDia,"@E 999,999,999.99")
		nLin++
		nLin++
		nVlrTotDia := 0
		dVectoAnt  := aPagtos[nCont,1]
	EndIf
*/
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	@ nLin , 000 PSay DtoC(aPagtos[nCont,1])
	@ nLin , 018 PSay aPagtos[nCont,2]
	@ nLin , 028 PSay aPagtos[nCont,3]
	@ nLin , 039 PSay aPagtos[nCont,4]
	@ nLin , 048 PSay aPagtos[nCont,5]
	@ nLin , 055 PSay aPagtos[nCont,6]
	@ nLin , 064 PSay If(!Empty(aPagtos[nCont,7]),aPagtos[nCont,7],aPagtos[nCont,10])
	@ nLin , 090 PSay DtoC(aPagtos[nCont,8])
	@ nLin , 103 PSay Transform(aPagtos[nCont,9],"@E 999,999,999.99")
	nLin++
	nVlrTotDia += aPagtos[nCont,9]
	nVlrTotPag += aPagtos[nCont,9]
	nVlrTotBco += aPagtos[nCont,9]
Next
// total do banco
@ nLin , 040 PSay "Total do Banco ---->"
@ nLin , 103 PSay Transform(nVlrTotBco,"@E 999,999,999.99")
nLin++
nLin++
nVlrTotBco := 0

/*
@ nLin , 010 PSay "Total do Dia ---->"
@ nLin , 103 PSay Transform(nVlrTotDia,"@E 999,999,999.99")
nLin++
nLin++
*/
nLin++
nLin++
@ nLin , 040 PSay "Total dos Pagamentos ---->"
@ nLin , 103 PSay Transform(nVlrTotPag,"@E 999,999,999.99")
nLin++
nLin++

SET DEVICE TO SCREEN

If aReturn[5]==1
	DbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return
