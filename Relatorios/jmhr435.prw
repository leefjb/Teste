#INCLUDE "Protheus.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MATR435	³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 11.05.95 ³±±
±±³Ajuste    ³ JMHR435	³       ³ Marllon Figueiredo    ³ Data ³ 08/10/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Kardex p/ Lote Sobre o SD5                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Jomhedica - Relatorio de Kardex Lote sem Mov. Internas     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutencao³ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JMHR435()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1    := "Este programa emitir  um Kardex com todas as movimenta‡”es"
LOCAL cDesc2    := "do estoque por Lote/Sub-Lote, diariamente. Observa‡„o: o primeiro"
LOCAL cDesc3    := "movimento de cada Lote/Sub-Lote se refere a cria‡„o do mesmo."
LOCAL titulo	:= "Rastreamento de Produto/Lote"
LOCAL wnrel     := "JMHR435"
LOCAL Tamanho   := "G"
LOCAL cString   := "SD5"

PRIVATE aReturn := {"Zebrado",1,"Administracao", 1, 2, 1, "",1 }	//###
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := PadR("MR435A",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     	 ³
//³ mv_par01       	// Do  Produto                         	 	 ³
//³ mv_par02        // Ate Produto                         	 	 ³
//³ mv_par03        // De  Lote                            	 	 ³
//³ mv_par04        // Ate Lote			        			 	 ³
//³ mv_par05        // De  Sub-Lote                          	 ³
//³ mv_par06        // Ate Sub-Lote			        		 	 ³
//³ mv_par07        // De  Local		        			 	 ³
//³ mv_par08        // Ate Local							 	 ³
//³ mv_par09        // De  Data			        			 	 ³
//³ mv_par10        // Ate Data								 	 ³
//³ mv_par11       	// Lotes/Sub S/ Movimentos (Lista/Nao Lista) ³
//³ mv_par12       	// Lote/Sub Saldo Zerado   (Lista/Nao Lista) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel :=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,.f.,Tamanho)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C435Imp(@lEnd,wnRel,tamanho,titulo)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C435IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 14.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR435			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C435Imp(lEnd,WnRel,tamanho,titulo)
LOCAL cCampo   := ""
LOCAL cCompara := ""
LOCAL cLote    := ""
LOCAL cSubLote := ""
LOCAL lOkSublote:=.F.
LOCAL cProduto := ""
LOCAL cIndexD5 := "D5_PRODUTO+D5_LOCAL+D5_LOTECTL+DTOS(D5_DATA)+D5_NUMLOTE+D5_NUMSEQ"
LOCAL cIndexB8 := "B8_PRODUTO+B8_LOTECTL+B8_LOCAL+B8_NUMLOTE"
LOCAL lProd    := .T.					// Flag do Subtitulo Produto
LOCAL lLote    := .T.					// Flag do Subtitulo Lote
LOCAL lTotal   := .F.					// Flag de Impressao do Total do relatorio
LOCAL nEntrada := nSaida :=nSaldo  :=0 	// Totalizadores de Valor por Lote
LOCAL nLentrada:= nLsaida:=nProduto:=0	// Totalizadores de Valor por Produto
LOCAL nIndD5   := 0
LOCAL nIndB8   := 0
LOCAL nTipo    := 0
LOCAL cProdAnt := ""
LOCAL lLoteZera:= .T.                   // Flag para Listar Lote Zerado
LOCAL	cCondD5:= 'D5_FILIAL=="'+xFilial("SD5")+'".And.D5_PRODUTO>="'+mv_par01+'".And.D5_PRODUTO<="'+mv_par02+'".And.'
LOCAL	cCondB8:= 'B8_FILIAL=="'+xFilial("SB8")+'".And.B8_PRODUTO>="'+mv_par01+'".And.B8_PRODUTO<="'+mv_par02+'".And.'

cCondD5 += 'D5_LOTECTL>="'+mv_par03+'".And.D5_LOTECTL<="'+mv_par04+'".And.'
cCondD5 += 'D5_NUMLOTE>="'+mv_par05+'".And.D5_NUMLOTE<="'+mv_par06+'".And.'
cCondD5 += 'D5_LOCAL>="'  +mv_par07+'".And.D5_LOCAL<="'  +mv_par08+'".And.'

cCondD5 += 'D5_ESTORNO <> "S" .And.'
cCondD5 += '.NOT. "X" $ D5_DOC .And.'

cCondD5 += 'DTOS(D5_DATA)>="'+DTOS(mv_par09)+'".And.DTOS(D5_DATA)<="'+DTOS(mv_par10)+'"'

cCondB8 += 'B8_LOTECTL>="'+mv_par03+'".And.B8_LOTECTL<="'+mv_par04+'".And.'
cCondB8 += 'B8_NUMLOTE>="'+mv_par05+'".And.B8_NUMLOTE<="'+mv_par06+'".And.'
cCondB8 += 'B8_LOCAL>="'  +mv_par07+'".And.B8_LOCAL<="'  +mv_par08+'"'

If !Empty(aReturn[7])
	cCondD5 += '.And.' + aReturn[7]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega o nome do arquivo de indice de trabalho      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArqD5 := CriaTrab("",.F.)
cNomArqB8 := CriaTrab("",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o indice de trabalho para o SD5              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD5")
IndRegua("SD5",cNomArqD5,cIndexD5,,cCondD5,"Selecionando Registros...") //
nIndD5 := RetIndex('SD5')
#IFNDEF TOP
	dbSetIndex(cNomArqD5 + OrdBagExt())
#ENDIF
dbSetOrder(nIndD5 + 1)
dbGotop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o indice de trabalho para o SB8              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB8")
IndRegua("SB8",cNomArqB8,cIndexB8,,cCondB8,"Selecionando Registros...") //
nIndB8 := RetIndex('SB8')
#IFNDEF TOP
	dbSetIndex(cNomArqB8 + OrdBagExt())
#ENDIF
dbSetOrder(nIndB8 + 1)
dbGotop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cbtxt := SPACE(10)
PRIVATE cbcont:= 0
PRIVATE li    := 80
PRIVATE m_pag := 01

PRIVATE cabec1  := 'Local   Data Movim.   Valid. Lote    Documento         Origem   Estor         Entrada          Saida     Paciente                         Local do Uso'
PRIVATE cabec2  := ""
dbSelectArea("SB8")
SetRegua(LastRec())
Do While !Eof()
    lProd    := allTrim(cProdAnt)#allTrim(B8_PRODUTO)
	cProduto := B8_PRODUTO
	cLote    := B8_LOTECTL
	cSubLote := B8_NUMLOTE
	cLocal   := B8_LOCAL
	lLote 	 := .T.	
	lTotal   := .T.
	lMovSD5  := .T.
	
	IncRegua()
	
	If lEnd
		@PROW()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	
	If li > 56
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	
	nSldLote:=CalcEstL(cProduto,cLocal,mv_par10+1,B8_LOTECTL,IF(Rastro(cProduto,"S"),B8_NUMLOTE,NIL))[1]
	
	lLoteZera := IF(mv_par12 == 1,.T.,IF(nSldLote == 0,.F.,.T.))
	
	dbSelectArea("SD5")
	If !dbSeek(cProduto+cLocal+cLote,.T.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se Lista Lote/Sub Sem Movimentos   ³
		//³ 1 = Lista          2 = Nao Lista		    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lLote  := If(mv_par11==1,.T.,.F.)
		lMovSD5:= If(mv_par12==1.And.lLote,.T.,.F.)
	ElseIf Rastro(cProduto,"S")
		lOkSublote:=.F.
		While !EOF() .And. D5_PRODUTO+D5_LOCAL+D5_LOTECTL == cProduto+cLocal+cLote
			If D5_NUMLOTE == cSubLote
				lOkSublote:=.T.	
				Exit
			EndIf	
			dbSkip()
		End
		If !lOkSubLote
			lLote  := If(mv_par11==1,.T.,.F.)
			lMovSD5:= If(mv_par12==1.And.lLote,.T.,.F.)
		EndIf
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera no filtro o Lote/Sub com o Saldo Zerado ³
	//³ 1 = Lista          2 = Nao Lista		          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par12 == 2 .And. nSldLote == 0 .And. !lMovSD5
		dbSelectArea("SB8")
		dbSkip()
	EndIf
	
	dbSelectArea("SD5")
	If MsSeek(cProduto+cLocal+cLote, .F.)
		If lProd .And. lLote .And. lLoteZera
			
			If li > 56
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+cProduto))
			@ li,00 PSay "Produto: "+cProduto					//
			@ li,25 PSay "Descr.: "+Substr(SB1->B1_DESC,1,45)	//
			@ li,82 PSay "Tipo: "+SB1->B1_TIPO				//
			@ li,91 PSay "UM: "+SB1->B1_UM					//
			Li += 2
			lProd  := .F.
			lTotal := .T.
			cProdAnt := cProduto
		EndIf
		
		If lLote .And. lLoteZera
			If li > 56
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			
			If SB1->B1_RASTRO == "S"
				@ li,01 PSay "Sub-Lote: "+SB8->B8_NUMLOTE+"    "+"Lote: "+SB8->B8_LOTECTL	//###
			ElseIf SB1->B1_RASTRO == "L"
				@ li,01 PSay "Lote: "+SB8->B8_LOTECTL		//
			EndIf
			nSaldo:=CalcEstL(cProduto,cLocal,mv_par09,SB8->B8_LOTECTL,IF(Rastro(cProduto,"S"),SB8->B8_NUMLOTE,NIL))[1]
			//@ li,51 PSay STR0015							//"Saldo Inicial: "
			//@ Li,84 pSay Transform(nSaldo,PesqPictQt('D5_QUANT',12))
			Li += 2
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Zera os totais de cada Lote/SubLote   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nEntrada := nSaida := 0
		
		cCampo	:= "D5_PRODUTO+D5_LOTECTL"
		cCompara:=	D5_PRODUTO+D5_LOTECTL
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao dos Movimentos do Lote/Sub  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do While !Eof() .And. &(cCampo) == cCompara .And. lLoteZera
			If D5_LOCAL # cLocal .Or. (Rastro(cProduto,"S") .And. D5_NUMLOTE # cSubLote)
				dbSkip()
				Loop
			EndIf
			If li > 56
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf

			// Local   Data Movim.   Valid. Lote    Documento         Origem   Estor         Entrada          Saida     Paciente                         Local do Uso
			// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			//           1         2         3         4         5         6         7         8         9        10        11        12        13
			// 00      00-00-0000    00-00-0000     000000000000/000  999      XXXXX    999999999999   999999999999     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 

			@ Li, 00 pSay Left(SD5->D5_LOCAL, 02)
			@ Li, 09 pSay DtoC(SD5->D5_DATA)
			@ Li, 23 pSay DtoC(SD5->D5_DTVALID)
			@ Li, 37 pSay If(!Empty(SD5->D5_OP), SD5->D5_OP, Left(SD5->D5_DOC, Min(12,Len(SD5->D5_DOC)))+'/'+SD5->D5_SERIE)
			If cPaisLoc != "BRA"
				If AllTrim(SD5->D5_SERIE) == "X"
					@ Li, 54 pSay If(cPaisLoc=="CHI","GUI","REM")
				Else
					@ Li, 54 pSay "FAC"
				EndIf
			EndIf
			@ Li, 55 pSay Left(SD5->D5_ORIGLAN, 03)
			@ Li, 64 pSay SD5->D5_ESTORNO
			If D5_ORIGLAN <= "500" .Or. Substr(D5_ORIGLAN,1,2) $ "DE/PR" .Or. D5_ORIGLAN == "MAN"
				@ Li, 72 pSay Transform(SD5->D5_QUANT, PesqPictQt('D5_QUANT',12))
				nEntrada+=D5_QUANT
				nSaldo  +=D5_QUANT
			Elseif D5_ORIGLAN > "500" .Or. Substr(D5_ORIGLAN,1,2) == "RE"
				@ Li, 88  pSay Transform(SD5->D5_QUANT, PesqPictQt('D5_QUANT',12))
				nSaida  +=D5_QUANT
				nSaldo  -=D5_QUANT
			EndIf

			// dados especificos da Jomhedica
			// Nome do Paciente e Local de uso do produto
			SD2->( dbSetOrder(3) )
			SD2->( dbSeek(xFilial('SD2')+SD5->D5_DOC+SD5->D5_SERIE) )
			// localizo o pedido de venda - Regra da Jomhedica (1 pedido - 1 nota), entao o primeiro que 
			// achar já é o pedido correto
			SC5->( dbSetOrder(1) )
			SC5->( dbSeek(xFilial('SC5')+SD2->D2_PEDIDO+SD2->D2_ITEMPV) )
			// localizo o cliente vale
			SA1->( dbSetOrder(1) )
			If ! Empty(SC5->C5_CLIVALE) .and. ! Empty(SC5->C5_LJCVALE)
				SA1->( dbSeek(xFilial('SA1')+SC5->C5_CLIVALE+SC5->C5_LJCVALE) )
			Else
				SA1->( dbSeek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI) )
			EndIf
			
			@ Li, 105 pSay Substr(SC5->C5_PACIENT, 1, 30)
			@ Li, 138 pSay Substr(SA1->A1_NREDUZ, 1, 30)

			//@ Li, 120 pSay Transform(nSaldo, PesqPictQt('D5_QUANT',12))
			Li++
			dbSkip()
			
			IF li > 59
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIF
			
		EndDo
	
		If lLote .And. lLoteZera
			If nEntrada > 0 .And. nSaida > 0 .Or. nSaldo > 0
				If li > 56
					cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf
				//@ li,00 PSAY cLocal
				If SB1->B1_RASTRO == "S"
					//@ li,03 PSay STR0016	//"Total do Sub-Lote -> "
				ElseIf SB1->B1_RASTRO == "L"
					//@ li,03 PSay STR0017	//"Total do Lote -> "
				EndIf
				If nEntrada > 0
					//@ Li, 84 pSay Transform(nEntrada, PesqPictQt('D5_QUANT',12))
				EndIf
				If nSaida > 0
					//@ Li, 102 pSay Transform(nSaida, PesqPictQt('D5_QUANT',12))
				EndIf
				//@ Li, 120 pSay Transform(nSaldo, PesqPictQt('D5_QUANT',12))
			EndIf
			nLentrada += nEntrada
			nLsaida   += nSaida
			nProduto  += nSaldo
			Li += 2
		Else
			lLote := .T.
		Endif
	EndIf
	
	dbSelectArea("SB8")
	If Rastro(cProduto,"L")
		Do While !Eof() .And. cProduto+cLocal == B8_PRODUTO+B8_LOCAL
			If cLote # B8_LOTECTL
				Exit
			EndIf
			dbSkip()
		EndDo
	Else
		dbSkip()
	EndIf
	
	If cProduto # B8_PRODUTO .And. if(!(mv_par12==1),nProduto > 0,.T.)
		If li > 56
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		If !(nLentrada <= 0 .And. nLsaida <= 0)
			//@ li,00 PSay __PrtThinLine()
			Li++
			//@ li,00 PSay STR0018	//"Total do Produto -> "
			If nLentrada > 0
				//@ Li, 84 pSay Transform(nLentrada, PesqPictQt('D5_QUANT',12))
			EndIf
			If nLsaida > 0
				//@ Li, 102 PSay Transform(nLsaida, PesqPictQt('D5_QUANT',12))
			EndIf
			//@ Li, 120 pSay Transform(nProduto, PesqPictQt('D5_QUANT',12))
			//Li++
			//@ li,00 PSay __PrtThinLine()
			Li++
		EndIf	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Zera os Totais do Produto   	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLentrada := nLsaida := nProduto :=0
		lProd  := .T.
		lTotal := .F.
	EndIf
	
EndDo

If lTotal .And. if(!(mv_par12==1),nProduto > 0,.T.)
	If li > 56
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	@ li,00 PSay __PrtThinLine()
	Li++
	//@ li,00 PSay STR0018	//"Total do Produto -> "
	If nLentrada > 0
		//@ Li, 84 pSay Transform(nLentrada, PesqPictQt('D5_QUANT',12))
	EndIf
	If nLsaida > 0
		//@ Li, 102 PSay Transform(nLsaida, PesqPictQt('D5_QUANT',12))
	EndIf
	//@ Li, 120 pSay Transform(nProduto, PesqPictQt('D5_QUANT',12))
	//Li++
	//@ li,00 PSay __PrtThinLine()
	//Li++
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Zera os Totais do Produto   	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLentrada := nLsaida := nProduto :=0
	IF li != 80
		roda(cbcont,cbtxt,Tamanho)
	EndIF
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve as ordens originais do arquivo                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SD5")
dbClearFilter()
RetIndex("SB8")
dbClearFilter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga indice de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArqD5 += OrdBagExt()
cNomArqB8 += OrdBagExt()
Delete File &(cNomArqD5)
Delete File &(cNomArqB8)

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return
