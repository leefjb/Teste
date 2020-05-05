#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ JMHORC   ³ Autor ³ Reiner                ³ Data ³01/05/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emissao do Orcamento Tecnico (Field Service)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³10/06/2005³ Marllon       ³Ajuste de layout                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function JMHORC()
Private oFont, oFont2, oFont3, oFont4, oFont5, oFont5b, oFont6, oFont7, oPrn
Private nLin, nCol, nIncr, nIncrA, nFolha, cPerg, nPos, cValidOrc
Private cTitulo, cTamanho, cDesc1, cDesc2, cDesc3, aReturn, lBold, lUnderline
Private nLastkey, NomeProg, cString, wNRel, nHeight10, nHeight12, nHeight15
Private aOrca, aAponta, aCliOrc, cNomeCli, cCodCli, cLojaCli, cFoneCli
Private cFilAB3, nRecAB3, cFilAB4, nRecAB4, cFilAB5, nRecAB5, li, nPosCli
Private cDescAB31, cDescAB32, cDescAB33, cDescAB34, dDatGar, cNumOS
Private cNumOrc, dEmissa, cNumSer, cCodPro, cDescPro, cItemOrc, cTipo
Private cContrt, nAB4, nAB5, nValTotAB5, nValTotAB4, lSaiAB5, cPrzEnt
Private cSubItem, cSICodPro, cSIDesPro, cSICodSer, nSIQuant, nSIVUnit
Private cAtenden, cNumOS, cCodPrb, cNomePrb, cCondPag, cDescPag, nSITotal

cPerg     := PadR("JMHORC",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
ValidPerg(cPerg)
lPerg     := Pergunte(cPerg,.T.)
cValidOrc := StrZero(MV_PAR02,3)

//MSGINFO('ENTREI')

If lPerg
	
	cTitulo  := ""
	ctamanho := "M"
	cDesc1   := OemToAnsi("")
	cDesc2   := OemToAnsi("")
	cDesc3   := OemToAnsi("")
	aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1 }
	aOFCorte := {}
	aMsgPCP  := {}
	nLASTKEY := 0
	nomeprog := "JMHORC"
	cString  := "AB3"
	wnrel    := "JMHORC"
	
	nHeight10  := 10
	nHeight12  := 12
	nHeight15  := 15
	lBold	   := .F.
	lUnderLine := .F.
	
	oFont	:= TFont():New( "Arial",,nheight15   ,,lBold ,,,,,lUnderLine )
	oFont2  := TFont():New( "Arial",,nheight15+12,,!lBold,,,,,lUnderLine )
	oFont3  := TFont():New( "Arial",,nheight15+10,,!lBold,,,,,lUnderLine )
	oFont4  := TFont():New( "Arial",,nheight15   ,,!lBold,,,,,lUnderLine )
	oFont5b := TFont():New( "Arial",,nheight12   ,,!lBold,,,,,lUnderLine )
	oFont5  := TFont():New( "Arial",,nheight12   ,,lBold,,,,,lUnderLine )
	oFont6  := TFont():New( "Arial",,nheight10   ,,!lBold,,,,,lUnderLine )
	oFont7  := TFont():New( "Arial",,nheight10-2 ,,lBold ,,,,,lUnderLine )
	
	DBSELECTAREA("SB1")		// Cadastro de Produtos
	DBSETORDER(1)
	
	DBSELECTAREA("AB4")		// Cadastro dos Itens do Orcamento Tecnico
	DBSETORDER(1)
	
	DBSELECTAREA("AAG")		// Cadastro de Ocorrencias
	DBSETORDER(1)
	
	DBSELECTAREA("AA3")		// Cadastro da Base Instalada
	DBSETORDER(1)
	
	DBSELECTAREA("AB5")     // Cadastro de Subitens do Orc. Tecnico (Apontamentos)
	DBSETORDER(1)
	
	DBSELECTAREA("SA1")		// Cadastro de Clientes
	DBSETORDER(1)
	
	DBSELECTAREA("SE4")		// Cadastro de Condicao de Pagamento
	DBSETORDER(1)
	
	DBSELECTAREA(cString)	// AB3 --> Cadastro de Orcamentos Tecnicos
	DBSETORDER(1)
	DbSeek(xfilial("AB3") + MV_PAR01, .T.)
	cFilAB3 := AB3_FILIAL
	nFolha := 1
	aOrca   := {}
	aAponta := {}
	aCliOrc := {}
	Do While xfilial("AB3") == cFilAB3 .And. MV_PAR01 == AB3->AB3_NUMORC .And. !EOF()
		
		nRecAB3  := RecNo()
		cNumOrc  := AB3_NUMORC
		cCodCli  := AB3_CODCLI
		cLojaCli := AB3_LOJA
		dEmissa  := AB3_EMISSA
		cCondPag := AB3_CONPAG
		cAtende  := AB3_ATEND
		cObs     := AB3->AB3_OBS
		cPrzEnt  := StrZero(AB3->AB3_PRZENT,3)
		cAc      := AB3->AB3_CONTAT
		
		DBSELECTAREA("SA1")
		DBSEEK(xFilial("SA1")+cCodCli+cLojaCli)
		cNomeCli := SA1->A1_NOME
		cFoneCli := '('+Alltrim(SA1->A1_DDD)+') '+SA1->A1_TEL
		cEnd     := AllTrim(SA1->A1_END)+' - '+AllTrim(SA1->A1_MUN)+' - '+SA1->A1_EST+' - '+SA1->A1_CEP
		
		DBSELECTAREA("SE4")
		DBSEEK(xFilial("SE4")+cCondPag)
		cDescPag := E4_DESCRI
		
		Aadd(aCliOrc,{cNumOrc, cCodCli, cLojaCli, cNomeCli, cFoneCli, cCondPag, cDescPag, dEmissa, cAtende, cPrzEnt, cObs, cAc, cEnd, SA1->A1_CGC, SA1->A1_INSCR, AB3->AB3_TPFRE})
		
		DBSELECTAREA("AB4")
		DBSEEK(xFilial("AB4")+cNumOrc)
		cFilAB4 := AB4_FILIAL
		
		Do While xfilial("AB4") == cFilAB4 .And. AB4_NUMORC == cNumOrc .And. !EOF()
			
			nRecAB4 := RecNo()
			cCodPrb := AB4_CODPRB
			cNumSer := AB4_NUMSER
			cQuant  := Str(AB4->AB4_QUANT,10)
			cCodPro := AB4_CODPRO
			cItemOrc:= AB4_ITEM
			cTipo   := X3Combo("AB4_TIPO",AB4->AB4_TIPO)
			cNumOS  := AB4_NUMOS
			
			dbSelectArea("SB1")		// Cadastro de Clientes
			DBSEEK(xFilial("SB1")+cCodPro)
			cDescPro := SubStr(B1_DESC,1,55)
			
			DBSELECTAREA("AA3")	  // Base Instalada
			DBSEEK(xFilial("AA3")+cCodCli+cLojaCli+cCodPro+cNumSer)
			dDatGar := AA3_DTGAR
			cContrt := AA3_CONTRT
			cChapa  := AA3_CHAPA
			
			dbSelectArea("AAG")
			dbSeek(xFilial("AAG")+cCodPrb)
			cNomePrb := AAG_DESCRI
			
			// dados do orcamento
			AADD(aOrca,{cNumOrc, cItemOrc, cTipo, AllTrim(cCodPro)+"-"+cDescPro, cQuant, cCodPrb+"-"+cNomePrb, cContrt, dDatGar, cNumOS, cNumSer, cChapa})
			
			dbSelectArea("AB5")
			dbSeek(xFilial("AB5")+cNumOrc+cItemOrc)
			cFilAB5 := AB5_FILIAL
			Do While xfilial("AB5") == cFilAB5 .And. AB5_NUMORC == cNumOrc .And. AB5_ITEM == cItemOrc .And. !EOF()
				cSubItem := AB5_SUBITE
				cSICodPro:= AB5_CODPRO
				cSIDesPro:= AB5_DESPRO
				cSICodSer:= AB5_CODSER
				nSIQuant := AB5_QUANT
				If cSICodSer = '000007'     // fixado para o caso de equipamentos sem conserto e que nao
					nSIVUnit := 0		 	// pode ter valor. O padrao do sistema nao permite apontamento sem
					nSITotal := 0			// valor informado. Marllon - 26/08/2005
				Else
					nSIVUnit := AB5_VUNIT
					nSITotal := AB5_TOTAL
				EndIf

				// dados do apontamento				
				Aadd(aAponta,{cNumOrc+cItemOrc, cSubItem, cSICodPro, cSIDesPro, cSICodSer, nSIQuant, nSIVUnit, nSITotal})
				dbSkip()
			EndDo
			
			dbSelectArea("AB4")
			dbGoTo(nRecAB4)
			dbSkip()
		EndDo
		
		dbSelectArea("AB3")
		dbGoTo(nRecAB3)
		dbSkip()
	EndDo
	
	If Len(aOrca) > 0
		Processa( {|| IMP_Orc() },"Imprimindo o Orcamento ...","Aguarde....." )
	EndIf
	
	dbSelectArea(cString)
	
EndIf

Return(.t.)

////////////////
/////////////////////////
////////////////

Static Function IMP_Orc()

oPrn    := TMSPrinter():New()

nLin    := 2670
nIncr   := 0
nFolha  := 0
cNumOrc := Space(6)
//   oPrn:SetPortrait()
For nAB4 := 1 To Len(aOrca)
	
	If cNumOrc # aOrca[nAB4,1]
		If cNumOrc # Space(6)
			
			Do While (nLin+nIncr) <= 2620
				
				oPrn:Line( nLin+nIncr, nCol+ 120, nLin+nIncr+70, nCol+ 120 )  // Coluna
				oPrn:Line( nLin+nIncr, nCol+1400, nLin+nIncr+70, nCol+1400 )  // Coluna
				oPrn:Line( nLin+nIncr, nCol+1600, nLin+nIncr+70, nCol+1600 )  // Coluna
				oPrn:Line( nLin+nIncr, nCol+2000, nLin+nIncr+70, nCol+2000 )  // Coluna
				
				nIncr += 70
				
				oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )        // Linha
				
			EndDo
			
			nLin := 2670
			
			oPrn:Say( nLin, nCol+1980, Str(nValTotAB4,12,2), oFont6, 100 )
			
			oPrn:EndPage()    // fechamento da pagina
			
		EndIf
		cNumOrc    := aOrca[nAB4,1]
		nValTotAB4 := 0
	EndIf
	
	lSaiAB5 := .F.
	
	If nLin+nIncr > 2620
		fDoCabec()
		
		oPrn:Line( nLin+nIncr, nCol+ 120, nLin+nIncr+70, nCol+ 120 )       // Coluna
		oPrn:Line( nLin+nIncr, nCol+1400, nLin+nIncr+70, nCol+1400 )       // Coluna
		oPrn:Line( nLin+nIncr, nCol+1600, nLin+nIncr+70, nCol+1600 )       // Coluna
		oPrn:Line( nLin+nIncr, nCol+2000, nLin+nIncr+70, nCol+2000 )       // Coluna
		
		// DADOS DO PRODUTO ORCADO
		nIncr += 30
		oPrn:Say( nLin + nIncr, nCol +  60, "It",                  oFont6, 100 )
		oPrn:Say( nLin + nIncr, nCol + 150, "Produto-Descricao",   oFont6, 100 )
		oPrn:Say( nLin + nIncr, nCol +1427, "Quant.",              oFont6, 100 )
		oPrn:Say( nLin + nIncr, nCol +1630, "Patrimonio",          oFont6, 100 )
		oPrn:Say( nLin + nIncr, nCol +2030, "Num. Serie",          oFont6, 100 )
		
		nIncr += 40
		
		oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
		
		nLin += nIncr   // 460 (nLin=50 + nIncr=410)    ??????
		nIncr := 0
	EndIf
	
	// Coluna para dados do AB4 - Itens do Orcamento Tecnico
	oPrn:Line( nLin+nIncr, nCol+ 120, nLin+nIncr+70, nCol+ 120 )       // Coluna
	oPrn:Line( nLin+nIncr, nCol+1400, nLin+nIncr+70, nCol+1400 )       // Coluna
	oPrn:Line( nLin+nIncr, nCol+1600, nLin+nIncr+70, nCol+1600 )       // Coluna
	oPrn:Line( nLin+nIncr, nCol+2000, nLin+nIncr+70, nCol+2000 )       // Coluna
	
	nIncr += 30

//               1        2         3         4                          5       6                     7        8         9       10       11	
//	AADD(aOrca,{cNumOrc, cItemOrc, cTipo, AllTrim(cCodPro)+"-"+cDescPro, cQuant, cCodPrb+"-"+cNomePrb, cContrt, dDatGar, cNumOS, cNumSer, cChapa})

	// DADOS SOBRE O PRODUTO ORCADO - AB4
	oPrn:Say( nLin+nIncr, nCol +  60, aOrca[nAB4,2],       oFont6, 100 ) // Item orcamento
	oPrn:Say( nLin+nIncr, nCol + 130, aOrca[nAB4,4],       oFont6, 100 ) // Produto
	oPrn:Say( nLin+nIncr, nCol +1427, aOrca[nAB4,5],       oFont6, 100 ) // Quantidade
	oPrn:Say( nLin+nIncr, nCol +1630, aOrca[nAB4,11],      oFont6, 100 ) // Patrimonio
	oPrn:Say( nLin+nIncr, nCol +2020, aOrca[nAB4,10],      oFont6, 100 ) // Num. Serie
	
	nIncr += 40
	
	oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
	
	nIncr += 30
	
	oPrn:Say( nLin+nIncr, nCol+130, "Problema .: "+aOrca[nAB4,6],    oFont6, 100 )
	
	nIncr += 40
	
	oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
	
	// Verifica se existem apontamentos para o Produto/Orcamento apontado
	nPos := Ascan(aAponta, {|x| x[1] == aOrca[nAB4,1]+aOrca[nAB4,2]})
	
	If nPos > 0
		
		// Coluna para dados do AB5 - Sub Itens do Orcamento Tecnico - ( Apontamentos )
		If MV_PAR03 = 1
			oPrn:Line( nLin+nIncr, nCol+1400, nLin+nIncr+70, nCol+1400 )       // Coluna
			oPrn:Line( nLin+nIncr, nCol+1650, nLin+nIncr+70, nCol+1650 )       // Coluna
			oPrn:Line( nLin+nIncr, nCol+2000, nLin+nIncr+70, nCol+2000 )       // Coluna
		EndIf
		
		nIncr += 30
		
		// DADOS SOBRE OS SUBITENS DO PRODUTO ORCADO - AB5
		oPrn:Say( nLin + nIncr, nCol + 200, "Peças e/ou Serviços",   oFont6, 100 )
		If MV_PAR03 = 1
			oPrn:Say( nLin + nIncr, nCol +1425, "Quantidade",  oFont6, 100 )
			oPrn:Say( nLin + nIncr, nCol +1720, "Vl Unitario", oFont6, 100 )
			oPrn:Say( nLin + nIncr, nCol +2020, "Vl Total",    oFont6, 100 )
		EndIf
		
		nIncr += 40
		
		oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
		
		nValTotAB5 := 0
		
		For nAB5 := nPos To Len(aAponta)
			If nLin+nIncr >= 3000  // 2620
				fDoCabec()      // inicia nova pagina
				nLin += nIncr   // 460 (nLin=50 + nIncr=410)
				nIncr := 0
				
				// Coluna para dados do AB5 - Sub Itens do Orcamento Tecnico - ( Apontamentos )
				If MV_PAR03 = 1
					oPrn:Line( nLin+nIncr, nCol+1400, nLin+nIncr+70, nCol+1400 )       // Coluna
					oPrn:Line( nLin+nIncr, nCol+1650, nLin+nIncr+70, nCol+1650 )       // Coluna
					oPrn:Line( nLin+nIncr, nCol+2000, nLin+nIncr+70, nCol+2000 )       // Coluna
				EndIf
				
				nIncr += 30
				
				// DADOS SOBRE OS SUBITENS DO PRODUTO ORCADO - AB5
				oPrn:Say( nLin + nIncr, nCol + 200, "Peças e/ou Serviços",    oFont6, 100 )
				If MV_PAR03 = 1
					oPrn:Say( nLin + nIncr, nCol +1425, "Quantidade",   oFont6, 100 )
					oPrn:Say( nLin + nIncr, nCol +1720, "Vl Unitario",  oFont6, 100 )
					oPrn:Say( nLin + nIncr, nCol +2020, "Vl Total",     oFont6, 100 )
				EndIf
				
				nIncr += 40
				
				oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
				
			EndIf
			//                      1             2          3           4         5          6        7          8
			// AADD(aAponta,{cNumOrc+cItemOrc, cSubItem, cSICodPro, cSIDesPro, cSICodSer, nSIQuant, nSIVUnit, nSITotal})
			
			oPrn:Line( nLin+nIncr, nCol+ 120, nLin+nIncr+55, nCol+ 120 )       // Coluna
			If MV_PAR03 = 1
				oPrn:Line( nLin+nIncr, nCol+1400, nLin+nIncr+55, nCol+1400 )       // Coluna
				oPrn:Line( nLin+nIncr, nCol+1650, nLin+nIncr+55, nCol+1650 )       // Coluna
				oPrn:Line( nLin+nIncr, nCol+2000, nLin+nIncr+55, nCol+2000 )       // Coluna
			EndIf
			
			nIncr += 20
			
			oPrn:Say( nLin + nIncr, nCol + 190, Substr(aAponta[nAB5][4],1,50),   oFont6, 100 )      // descricao
			If MV_PAR03 = 1
				oPrn:Say( nLin + nIncr, nCol +1450, Str(aAponta[nAB5][6],9,2),   oFont6, 100 )  // quantidade
				oPrn:Say( nLin + nIncr, nCol +1710, Str(aAponta[nAB5][7],12,2),  oFont6, 100 )  // unitario
				oPrn:Say( nLin + nIncr, nCol +1980, Str(aAponta[nAB5][8],12,2),  oFont6, 100 )  // total
			EndIf
			nIncr += 35

			// debra das outras linhas de descricao
			_cDescri := AllTrim(Substr(aAponta[nAB5][4],51))
			Do While ! Empty(_cDescri)
				oPrn:Line( nLin+nIncr, nCol+ 120, nLin+nIncr+35, nCol+ 120 )       // Coluna
				If MV_PAR03 = 1
					oPrn:Line( nLin+nIncr, nCol+1400, nLin+nIncr+35, nCol+1400 )       // Coluna
					oPrn:Line( nLin+nIncr, nCol+1650, nLin+nIncr+35, nCol+1650 )       // Coluna
					oPrn:Line( nLin+nIncr, nCol+2000, nLin+nIncr+35, nCol+2000 )       // Coluna
				EndIf
				oPrn:Say( nLin + nIncr, nCol + 190, Substr(_cDescri,1,50),   oFont6, 100 )      // descricao
				nIncr += 35
				_cDescri := AllTrim(Substr(_cDescri,51))
			Enddo
			
			//nIncr += 35
			
			nValTotAB5 += aAponta[nAB5][8]
			nValTotAB4 += aAponta[nAB5][8]
			
			If nAB5 <> Len(aAponta)
				If aAponta[nAB5+1][1] # aOrca[nAB4,1]+aOrca[nAB4,2]
					
					oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
					
					nIncr += 18
					
					oPrn:Say( nLin+nIncr, nCol+1710, "SUB-TOTAL",           oFont6, 100 )
					oPrn:Say( nLin+nIncr, nCol+1980, Str(nValTotAB5,12,2),  oFont6, 100 )
					
					nIncr += 50 //39
					oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
					nIncr += 1
					oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
					nIncr += 1
					oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
					
					lSaiAB5 := .T.
					
					Exit
					
				EndIf
				
			EndIf
			
		Next
		
		If !lSaiAB5
			
			oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
			
			nIncr += 20
			
			oPrn:Say( nLin+nIncr, nCol+1710, "SUB-TOTAL",          oFont6, 100 )
			oPrn:Say( nLin+nIncr, nCol+1980, Str(nValTotAB5,12,2),  oFont6, 100 )
			
			nIncr += 35
			
			oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
			
		EndIf
		
	EndIf
	
Next  // aOrca

oPrn:Say( nLin+nIncr+10, nCol+1980, Str(nValTotAB4,12,2),  oFont6, 100 )
oPrn:Say( nLin+nIncr, nCol+1710, "TOTAL GERAL",       oFont5, 100 )

If nLin+nIncr >= 2600  // 2620
	fDoCabec()         // inicia nova pagina
	nLin += nIncr      // 460 (nLin=50 + nIncr=410)
	nIncr := 0
	
	Do While (nLin+nIncr) <= 2620
		// Coluna para dados do AB4 - Itens do Orcamento Tecnico
		oPrn:Line( nLin+nIncr, nCol+ 120, nLin+nIncr+70, nCol+ 120 )  // Coluna
		oPrn:Line( nLin+nIncr, nCol+1650, nLin+nIncr+70, nCol+1650 )  // Coluna
		oPrn:Line( nLin+nIncr, nCol+2000, nLin+nIncr+70, nCol+2000 )  // Coluna
		
		nIncr += 70
		
		oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
	EndDo
EndIf

fDoRodape()

oPrn:EndPage()  // FECHAMENTO DA PAGINA
oPrn:Preview()
//oPrn:Print()

Return



Static Function fDoCabec()

// Localiza os dados do Cliente pelo numero do orcamento
nPosCli := Ascan(aCliOrc, {|x| x[1] == aOrca[Min(nAB4, Len(aOrca)),1]})

oPrn:EndPage()      // FECHAMENTO DA PAGINA
oPrn:StartPage()	// INICIO DE PAGINA

nFolha += 1
nLin   := 50
nCol   := 50

//oPrn:Box( nLin+50, nCol+50, nLin+3000,nCol+2250 )
cBitMap := u_JMHF060()
oPrn:SayBitmap( nLin+60,nCol+100,cBitMap,590,190 )

oPrn:Say( nLin+100, nCol+0900, "ORCAMENTO TECNICO",      oFont4, 100 )
oPrn:Say( nLin+200, nCol+1700, "Numero",                 oFont5, 100 )
oPrn:Say( nLin+195, nCol+2050, cNumOrc,                  oFont4, 100 )
oPrn:Say( nLin+255, nCol+1700, "Folha",                  oFont5, 100 )
oPrn:Say( nLin+250, nCol+2090, Strzero(nFolha,2),        oFont4, 100 )
oPrn:Say( nLin+345, nCol+1700, "Emissão",                oFont5, 100 )
oPrn:Say( nLin+340, nCol+2040, Dtoc(aCliOrc[nPosCli,8]), oFont4, 100 )

// dados da empresa
nP := 80
//oPrn:Say( nLin+125+NP, nCol+100,  SM0->M0_NOMECOM, oFont6, 200 )
oPrn:Say( nLin+125+NP, nCol+100,  SM0->M0_NOMECOM, oFont6, 200 )
oPrn:Say( nLin+170+NP, nCol+100,  "C.N.P.J. "+Transform(SM0->M0_CGC, '@R 99.999.999/9999-99')+"  -  Insc.Est. "+SM0->M0_INSC,  oFont6, 200 )
oPrn:Say( nLin+215+NP, nCol+100,  SM0->M0_ENDCOB,  oFont6, 200 )
oPrn:Say( nLin+260+NP, nCol+100,  AllTrim(SM0->M0_CIDCOB)+'  -  '+AllTrim(SM0->M0_ESTCOB)+'  -  '+SM0->M0_CEPCOB,  oFont6, 300 )
oPrn:Say( nLin+305+NP, nCol+100,  AllTrim(SM0->M0_TEL)+'  -  Fax: '+AllTrim(SM0->M0_FAX),  oFont6, 300 )

nIncr := 450

oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha

nIncr += 20

//               1        2         3         4          5         6         7          8      9       10      11    12   13     14           15
//Aadd(aCliOrc,{cNumOrc, cCodCli, cLojaCli, cNomeCli, cFoneCli, cCondPag, cDescPag, dEmissa, cAtende, cPrzEnt, cObs, cAc, cEnd, SA1->A1_CGC, SA1->A1_INSCR})


// DADOS DO CLIENTE NO ORCAMENTO - AB3
oPrn:Say( nLin+nIncr,     nCol+100, "Cliente:",  oFont5, 200 )
oPrn:Say( nLin+nIncr,     nCol+500, aCliOrc[nPosCli,2]+" / "+aCliOrc[nPosCli,3]+" -  "+SubStr(aCliOrc[nPosCli,4],1,60), oFont5b, 200 )
oPrn:Say( nLin+nIncr+050, nCol+100, "Endereco ..: ", oFont5, 200 )
oPrn:Say( nLin+nIncr+050, nCol+500, aCliOrc[nPosCli,13], oFont5b, 200 )
oPrn:Say( nLin+nIncr+100, nCol+100, "C.N.P.J....: ", oFont5, 200 )
oPrn:Say( nLin+nIncr+100, nCol+500, Transform(aCliOrc[nPosCli,14], '@R 99.999.999/9999-99'), oFont5b, 200 )
oPrn:Say( nLin+nIncr+100, nCol+1000,"Insc. Est..: ", oFont5, 200 )
oPrn:Say( nLin+nIncr+100, nCol+1300,aCliOrc[nPosCli,15], oFont5b, 200 )
oPrn:Say( nLin+nIncr+150, nCol+100, "Atendente .: ", oFont5, 100 )
oPrn:Say( nLin+nIncr+150, nCol+500, aCliOrc[nPosCli,9], oFont5b, 100 )
oPrn:Say( nLin+nIncr+150, nCol+1500,"Fone Cliente: ", oFont5, 200 )
oPrn:Say( nLin+nIncr+150, nCol+1800,aCliOrc[nPosCli,5], oFont5b, 200 )
oPrn:Say( nLin+nIncr+200, nCol+100, "Cond.Pag ..: ", oFont5, 100 )
oPrn:Say( nLin+nIncr+200, nCol+500, aCliOrc[nPosCli,6]+" - "+aCliOrc[nPosCli,7], oFont5b, 100 )
oPrn:Say( nLin+nIncr+250, nCol+100, "Observação.: ", oFont5, 100 )
oPrn:Say( nLin+nIncr+250, nCol+500, aCliOrc[nPosCli,11], oFont5b, 100 )
oPrn:Say( nLin+nIncr+300, nCol+100, "A/C.: ", oFont5, 100 )
oPrn:Say( nLin+nIncr+300, nCol+500, aCliOrc[nPosCli,12], oFont5b, 100 )

nIncr += 350
oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha

Return



Static Function fDoRodape()

oPrn:Say( 2710, nCol+ 100, "Prazo Entrega:",  oFont5, 100 )
oPrn:Say( 2710, nCol+ 680, aCliOrc[nPosCli,10]+' dias', oFont5b, 100 )
oPrn:Say( 2810, nCol+ 100, "Validade Orçamento:",  oFont5, 100 )
oPrn:Say( 2810, nCol+ 680, cValidOrc+' dias', oFont5b, 100 )
oPrn:Say( 2910, nCol+ 100, "Dias de Garantia:",  oFont5, 100 )
oPrn:Say( 2910, nCol+ 680, Str(MV_PAR04,6,0)+' dias', oFont5b, 100 )
oPrn:Say( 3010, nCol+ 100, "Tipo do Frete:",  oFont5, 100 )
oPrn:Say( 3010, nCol+ 680, Iif(aCliOrc[nPosCli,16]='1', 'CIF', Iif(aCliOrc[nPosCli,16]='2', 'FOB', '')), oFont5b, 100 )

oPrn:Say( 2660, nCol+1200, "_____________________________________", oFont5, 100 )
oPrn:Say( 2710, nCol+1200, SM0->M0_NOMECOM, oFont5, 100 )
oPrn:Say( 2810, nCol+1200, "Aprovado ..: ________________________", oFont5, 100 )
oPrn:Say( 2910, nCol+1200, "Data/Nome .: ________________________", oFont5, 100 )

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  29/10/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

//          Grupo/Ordem/Pergunta/                   Variavel/Tipo/Tam/Dec/Pres/GSC/Valid/             Var01/     Def01______/Cnt01/  Var02 /Def02_____/Cnt02/ Var03/Def03___/Cnt03/ Var04/Def04___/Cnt04/ Var05/Def05___/Cnt05/ F3
aAdd(aRegs,{cPerg,"01","do Orçamento?",    "","",    "mv_ch1","C",  6,  0, 0,  "G", "",               "MV_PAR01", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"02","Prazo de validade","","",    "mv_ch2","N",  3,  0, 1,  "G", "",               "MV_PAR02", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"03","Imprime Valores?", "","",    "mv_ch3","N",  1,  0, 1,  "C", "",               "MV_PAR03", "Sim","","","",     "",   "Nao","","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"04","Dias de Garantia?","","",    "mv_ch4","N",  5,  0, 1,  "G", "",               "MV_PAR04", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
