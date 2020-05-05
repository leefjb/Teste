#INCLUDE "MATR460.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MATR460  ³ Autor ³ Juan Jose Pereira     ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio do Inventario, Registro Modelo P7                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutencao³ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#define TT	Chr(254)+Chr(254)			// Substituido p/ "TT"
User Function JMHR460()

Local	wnrel
Local	titulo:=STR0001,;	//"Registro de Invent rio - Modelo P7"
		cDesc1:=STR0002,;	//"Emiss„o do Registro de Invent rio.Os Valores Totais serao impressos conforme Modelo Legal"
		cDesc2:=STR0003,;	//"Nota:  Saldo em Poder de Terceiros somente em posi‡„o atual,"
		cDesc3:=STR0004		//"       Saldo em Processo somente em requisi‡”es manuais."
Local cString:="SB1",;
NomeProg:="JMHR460"
Local aSave:={Alias(),IndexOrd(),Recno()}
Local Tamanho:="M"

Private aReturn:={STR0005,1,STR0006,2,2,1,"",1}	//"Zebrado"###"Administra‡„o"
Private nLastKey:=0
Private cPerg:= PadR("JMHR460",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
Private nTipo:=0
Private nDecVal := 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey==27
	Return .T.
Endif
SetDefault(aReturn,cString)
If nLastKey==27
	Return .T.
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Saldo em Processo (Sim) (Nao)                ³
//³ mv_par02     // Saldo em Poder 3§ (Sim) (Nao)                ³
//³ mv_par03     // Almox. de                                    ³
//³ mv_par04     // Almox. ate                                   ³
//³ mv_par05     // Produto de                                   ³
//³ mv_par06     // Produto ate                                  ³
//³ mv_par07     // Lista Produtos sem Movimentacao   (Sim)(Nao) ³
//³ mv_par08     // Lista Produtos com Saldo Negativo (Sim)(Nao) ³
//³ mv_par09     // Lista Produtos com Saldo Zerado   (Sim)(Nao) ³
//³ mv_par10     // Pagina Inicial                               ³
//³ mv_par11     // Quantidade de Paginas                        ³
//³ mv_par12     // Numero do Livro                              ³
//³ mv_par13     // Livro/Termos                                 ³
//³ mv_par14     // Data de Fechamento do Relatorio              ³
//³ mv_par15     // Quanto a Descricao (Normal) (Inclui Codigo)  ³
//³ mv_par16     // Lista Produtos com Custo Zero ?   (Sim)(Nao) ³
//³ mv_par17     // Lista Custo Medio / Fifo                     ³
//³ mv_par18     // Verifica Sld Processo Dt Emissao Seq Calculo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe paramentros das perguntas                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lSaldProcess:=(mv_par01==1)
lSaldTerceir:=(mv_par02==1)
cAlmoxIni	:=mv_par03
cAlmoxFim	:=mv_par04
cProdIni	:=mv_par05
cProdFim	:=mv_par06
lListProdMov:=(mv_par07==1)
lListProdNeg:=(mv_par08==1)
lListProdZer:=(mv_par09==1)
nPagIni		:=mv_par10
nQtdPag		:=mv_par11
cNrLivro	:=mv_par12
lLivro		:=(mv_par13!=2)
dDtFech		:=mv_par14
lDescrNormal:=(mv_par15==1)
lListCustZer:=(mv_par16==1)
lListCustMed:=(mv_par17==1)
lCalcProcDt:=(mv_par18==1)

If lLivro
	RptStatus({|lEnd| R460Imp(@lEnd,wnRel,cString,Tamanho)},titulo)
Else
	RptStatus({|lEnd| R460Term(@lEnd,wnRel,cString,Tamanho)},titulo)
Endif

If aReturn[5]==1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura ambiente                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(aSave[1])
dbSetOrder(aSave[2])
dbGoto(aSave[3])

Return (NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460LayOut³ Autor ³ Juan Jose Pereira     ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Lay-Out do Modelo P7                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460LayOut()

Local aL:=Array(16)

aL[01]:=				  "+----------------------------------------------------------------------------------------------------------------------------------+"
aL[02]:=STR0007	//"|                                                     REGISTRO DE INVENTARIO                                                       |"
aL[03]:=				  "|                                                                                                                                  |"
aL[04]:=STR0008	//"| FIRMA:#########################################                                                                                  |"
aL[05]:=				  "|                                                                                                                                  |"
If cPaisLoc == "CHI"
	aL[06]:=STR0029	//"| INSC.EST.: ################   C.G.C.(MF): ################################                                                       |"
Else
	aL[06]:=STR0009	//"| INSC.EST.: ################   C.G.C.(MF): ################################                                                       |"
Endif
aL[07]:=				  "|                                                                                                                                  |"
aL[08]:=STR0010	//"| FOLHA: #######                ESTOQUES EXISTENTES EM: ##########                                                                 |"
aL[09]:=				  "|                                                                                                                                  |"
aL[10]:=				  "|----------------------------------------------------------------------------------------------------------------------------------|"
If ( cPaisLoc=="BRA" )
	aL[11]:=STR0025	//"|             |                                      |    |              |                        VALORES                          |"
	aL[12]:=STR0011	//"|CLASSIFICACAO|                                      |    |              |-------------------------------------+-------------------|"
	aL[13]:=STR0012	//"|    FISCAL   |     D I S C R I M I N A C A O        |UNID|  QUANTIDADE  |     UNITARIO     |     PARCIAL      |      TOTAL        |"
	aL[14]:=				  "|-------------+--------------------------------------+----+--------------+------------------+------------------+-------------------|"
	aL[15]:=				  "|#############| #####################################| ## |##############|##################|##################|###################|"
Else
	aL[11]:=STR0028//"|                                                    |    |              |                        VALORES                          |"
	aL[12]:=STR0026//"|                                                    |    |              |-------------------------------------+-------------------|"
	aL[13]:=STR0027//"|                   DESCRICAO                        |UNID|  QUANTIDADE  |     UNITARIO     |     PARCIAL      |      TOTAL        |"
	aL[14]:=			  "|----------------------------------------------------+----+--------------+------------------+------------------+-------------------|"
	aL[15]:=			  "| # ################################################ | ## |##############|##################|##################|###################|"
EndIf
aL[16]:=				  "+----------------------------------------------------------------------------------------------------------------------------------+"

//		 			      123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123
//    	            1         2         3         4         5         6         7         8         9         10        11        12        13
Return (aL)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R460Imp  ³ Autor ³ Juan Jose Pereira     ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Modelo P7                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Imp(lEnd,wnRel,cString,Tamanho)
STATIC lCalcUni := NIL
Local cArqTemp,cIndTemp1,cIndTemp2,aArqTemp:={},aL:=R460LayOut()
Local nLin:=80,nPagina:=nPagIni,aTotal:={},lEmBranco:=.F.
Local nPos, lImpSit, lImpTipo, lImpResumo:=.F.
Local cPosIpi:="",aImp:={},nTotIpi:=0
Local cQuery := ''
Local cChave := ''
Private cIndSB6,nIndSB6

lCalcUni := If(lCalcUni == NIL, ExistBlock("A460UNIT"),lCalcUni)

If lSaldTerceir
	#IFNDEF TOP
		dbSelectArea("SB6")
		cIndSB6:=Substr(CriaTrab(NIL,.F.),1,7)+"T"
	 	cChave := "B6_FILIAL+B6_PRODUTO+B6_TIPO+DTOS(B6_DTDIGIT)"
		cQuery := 'DtoS(B6_DTDIGIT)<="'+DtoS(mv_par14)+'".And.B6_PRODUTO>="'+mv_par05+'".And.B6_PRODUTO<="'+mv_par06+'".And.B6_LOCAL>="'+ mv_par03+'".And.B6_LOCAL<="'+mv_par04+'"'
		IndRegua("SB6",cIndSB6,cChave,,cQuery,STR0013)		//"Selecionando Poder Terceiros..."
		nIndSB6:=RetIndex("SB6")
		dbSetIndex(cIndSB6+OrdBagExt())
		dbSetOrder(nIndSB6 + 1)
		dbGoTop()
	#ENDIF
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo Temporario                                                    ³
//³ SITUACAO:1=ESTOQUE,2=PROCESSO,3=SEM SALDO,4=DE TERCEIROS,5=EM TERCEIROS    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aArqTemp,{"SITUACAO"	,"C",1,0})
AADD(aArqTemp,{"TIPO"		,"C",2,0})
AADD(aArqTemp,{"POSIPI"		,"C",10,0})
AADD(aArqTemp,{"PRODUTO"	,"C",15,0})
AADD(aArqTemp,{"DESCRICAO"	,"C",35,0})
AADD(aArqTemp,{"UM"			,"C",2,0})
// Pega o numero de decimais usado no SX3
aTam:=TamSX3("B2_QFIM")
AADD(aArqTemp,{"QUANTIDADE","N",14,aTam[2]})
aTam:=TamSX3("B2_CM1")
nDecVal := aTam[2]
AADD(aArqTemp,{"VALOR_UNIT","N",21,aTam[2]})
AADD(aArqTemp,{"TOTAL"		,"N",21,2})
cArqTemp:=CriaTrab(aArqTemp)
cIndTemp1:=Substr(CriaTrab(NIL,.F.),1,7)+"1"
cIndTemp2:=Substr(CriaTrab(NIL,.F.),1,7)+"2"
dbUseArea(.T.,,cArqTemp,cArqTemp,.T.,.F.)
IndRegua(cArqTemp,cIndTemp1,"SITUACAO+TIPO+POSIPI+PRODUTO",,,STR0014)		//"Indice Tempor rio..."
IndRegua(cArqTemp,cIndTemp2,"PRODUTO+SITUACAO",,,STR0014)			//"Indice Tempor rio..."
Set Cursor Off
DbClearIndex()
DbSetIndex(cIndTemp1+OrdBagExt())
DbSetIndex(cIndTemp2+OrdBagExt())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta Arquivo de Trabalho                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSeek(xFilial() + mv_par05, .T.)
SetRegua(LastRec())

While !lEnd .and. !eof()
	IncRegua()
	If ! Empty(mv_par06) .And. SB1->B1_COD > mv_par06
		Exit
	Endif
	If Interrupcao(@lEnd)
		Exit
	Endif
	If !R460AvalProd(SB1->B1_COD)
		dbSkip()
		Loop
	Endif
	R460EmEstoque(@lEnd,cArqTemp)	    // Saldos em Estoque
	R460Terceiros(@lEnd,cArqTemp,"4")   // Saldos de Terceiros
	R460Terceiros(@lEnd,cArqTemp,"5")   // Saldos em Terceiros
	If lEnd
		Exit
	Endif
	dbSelectArea("SB1")
	dbSkip()
End

R460EmProcesso(@lEnd,cArqTemp)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Modelo P7                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cArqTemp)
dbSetOrder(1)
dbGotop()
SetRegua(LastRec())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Flags de Impressao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSitAnt	:="X"
aSituacao:={STR0015,STR0016,STR0017,STR0018,STR0019}		//" EM ESTOQUE "###" EM PROCESSO "###" SEM MOVIMENTACAO "###" DE TERCEIROS "###" EM TERCEIROS "
cTipoAnt:="XX"

While !Eof()
	
	nLin := 80
	cSitAnt := SITUACAO
	lImpSit := .T.
	
	While !Eof() .And. cSitAnt == SITUACAO
		
		cTipoAnt := TIPO
		lImpTipo := .T.
		
		While !Eof() .And. cSitAnt+cTipoAnt == SITUACAO+TIPO
			
			cPosIpi:=POSIPI
			nTotIpi:=0
			
			While !Eof() .And. cSitAnt+cTipoAnt+cPosIpi==SITUACAO+TIPO+POSIPI
				IncRegua()
				If Interrupcao(@lEnd)
					Exit
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Controla impressao de Produtos com saldo negativo ou zerado  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (!lListProdNeg.and.QUANTIDADE<0).or.(!lListProdZer.and.QUANTIDADE==0).Or.(!lListCustZer.And.TOTAL==0)
					dbSkip()
					Loop
				Else
					nTotIpi+=TOTAL
					R460Acumula(aTotal)
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa array com itens de impressao de acordo com MV_PAR15  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				If lDescrNormal
					aImp:={Alltrim(POSIPI),;
					DESCRICAO,;
					UM,;
					Transform(QUANTIDADE,PesqPict("SB2", "B2_QFIM",14)),;
					Transform(NoRound(TOTAL/QUANTIDADE,nDecVal),PesqPict("SB2", "B2_CM1",18)),;
					Transform(TOTAL,"@E 999,999,999,999.99" ),;
					Nil}
				Else
					aImp:={Alltrim(POSIPI),;
					Padr(Alltrim(PRODUTO)+" - "+DESCRICAO,35),;
					UM,;
					Transform(QUANTIDADE,PesqPict("SB2", "B2_QFIM",14)),;
	                Transform(NoRound(TOTAL/QUANTIDADE,nDecVal),PesqPict("SB2", "B2_CM1",18)),;
					Transform(TOTAL,"@E 999,999,999,999.99"),;
					Nil}
				Endif
				dbSelectArea(cArqTemp)
				dbSkip()
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Salta registros Zerados ou Negativos Conforme Parametros        ³
				//³ Necessario Ajustar Posicao p/ Totalizacao de Grupos (POSIPI)    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				While !Eof() .And. ((!lListProdNeg.and.QUANTIDADE<0).or.(!lListProdZer.and.QUANTIDADE==0).Or.(!lListCustZer.And.TOTAL==0))
					dbSkip()
				EndDo
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se imprime total por POSIPI.                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !(cSitAnt+cTipoAnt+cPosIpi==SITUACAO+TIPO+POSIPI)
					aImp[07] := Transform(nTotIPI,"@E 999,999,999,999.99")
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime cabecalho                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nLin>55
					R460Cabec(@nLin,@nPagina)
				Endif
				
				If lImpSit
					FmtLin({"",Padc(aSituacao[Val(cSitAnt)],35,"*"),"","","","",""},aL[15],,,@nLin)
					lImpSit := .F.
				Endif
				
				If lImpTipo
					SX5->(dbSeek(xFilial()+"02"+cTipoAnt))
					FmtLin(Array(7),aL[15],,,@nLin)
					FmtLin({"",Padc(" "+Trim(X5Descri())+" ",35,"*"),"","","","",""},aL[15],,,@nLin)
					FmtLin(Array(7),aL[15],,,@nLin)
					lImpTipo := .F.
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime linhas de detalhe de acordo com parametro (mv_par15) ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FmtLin(aImp,aL[15],,,@nLin)
				
				If nLin>=55
					R460EmBranco(@nLin)
				Endif
			End
		End
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao de Totais                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := Ascan(aTotal,{|x|x[1]==cSitAnt.and.x[2]==cTipoAnt})
		If nPos # 0
			R460Total(@nLin,aTotal,cSitAnt,cTipoAnt,aSituacao,@nPagina)
		Endif
	End
	nPos := Ascan(aTotal,{|x|x[1]==cSitAnt.and.x[2]==TT})			// Eh um #define
	If nPos # 0
		R460Total(@nLin,aTotal,cSitAnt,TT,aSituacao,@nPagina)
		R460EmBranco(@nLin)
		lImpResumo:=.T.
	Endif
End

If lImpResumo
	R460Cabec(@nLin,@nPagina)
	R460Total(@nLin,aTotal,"T",TT,aSituacao,@nPagina)
	R460EmBranco(@nLin)
Else
	R460Cabec(@nLin,@nPagina)
	R460SemEst(@nLin,@nPagina)
	R460EmBranco(@nLin)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga Arquivos Temporarios                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cArqTemp)
dbCloseArea()
Ferase(cArqTemp+GetDBExtension())
Ferase(cIndTemp1+OrdBagExt())
Ferase(cIndTemp2+OrdBagExt())

If lSaldTerceir
	#IFNDEF TOP
		dbSelectArea("SB6")
		RetIndex("SB6")
		dbClearFilter()
		If File(cIndSB6 += OrdBagExt())
			fErase(cIndSB6)
		EndIf
	#ENDIF
Endif
Return (NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R460Term ³ Autor ³ Juan Jose Pereira     ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao dos Termos de Abertura e Encerramento do Modelo P7³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Term(lEnd,wnRel,cString,Tamanho)

Local cArqAbert, cArqEncer,aDriver:=ReadDriver()

cArqAbert:=GetMv("MV_LMOD7AB")
cArqEncer:=GetMv("MV_LMOD7EN")

XFIS_IMPTERM(cArqAbert,cArqEncer,cPerg,aDriver[4])

Return (NIL)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460EmEstoque³Autor³Juan Jose Pereira     ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Busca movimentacoes em Estoque                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460EmEstoque(lEnd,cArqTemp)
Local lCusFIFO := GetMV("MV_CUSFIFO")
Local lFirst:=.t.,aSalAtu                                        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca Saldo em Estoque                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB2")
dbSeek(xFilial()+SB1->B1_COD+If(Empty(cAlmoxIni), "", cAlmoxIni),.T.)

If Eof()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o almoxarifado esta entre os parametros          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SB1->B1_LOCPAD >= mv_par03 .and. SB1->B1_LOCPAD <= mv_par04
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Lista produtos sem movimentacao de estoque                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lListProdMov
			dbSelectArea(cArqTemp)
			RecLock(cArqTemp,.T.)
			Replace SITUACAO  with "3"
			Replace TIPO	   with SB1->B1_TIPO
			Replace PRODUTO	with SB1->B1_COD
			Replace POSIPI	   with SB1->B1_POSIPI
			Replace DESCRICAO with SB1->B1_DESC
			Replace UM		   with SB1->B1_UM
			MsUnLock()
		Endif
	Endif
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lista produtos com movimentacao de estoque                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !lEnd.and.!eof().and.SB2->B2_FILIAL==xFilial().and.;
		SB2->B2_COD==SB1->B1_COD .And. SB2->B2_LOCAL <= cAlmoxFim
		
		If !R460Local(SB2->B2_LOCAL)
			dbSkip()
			Loop
		Endif
		
		If Interrupcao(@lEnd)
			Exit
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Desconsidera almoxarifado de saldo em processo de mat.indiret³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SB2->B2_LOCAL==GetMv("MV_LOCPROC")
			dbSkip()
			Loop
		Endif
		If lListCustMed1 .Or. (!lListCustMed1 .And. !lCusfifo)
			aSalatu:=CalcEst(SB1->B1_COD,SB2->B2_LOCAL,dDtFech+1)		
		Else
			aSalAtu:=CalcEstFF(SB1->B1_COD,SB2->B2_LOCAL,dDtFech+1)		
		EndIf
		dbSelectArea(cArqTemp)
		dbSetOrder(2)
		If dbSeek(SB1->B1_COD+"1")
			RecLock(cArqTemp,.F.)
		Else
			RecLock(cArqTemp,.T.)
			lFirst:=.F.
			Replace SITUACAO	with "1"
			Replace TIPO		with SB1->B1_TIPO
			Replace POSIPI		with SB1->B1_POSIPI
			Replace PRODUTO		with SB1->B1_COD
			Replace DESCRICAO	with SB1->B1_DESC
			Replace UM			with SB1->B1_UM
		Endif
		Replace QUANTIDADE 	With QUANTIDADE+aSalAtu[01]
		Replace TOTAL		With TOTAL+aSalAtu[02]
		If aSalAtu[1]>0
			Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
		If lCalcUni
		   ExecBlock("A460UNIT",.F.,.F.,{SB1->B1_COD,SB2->B2_LOCAL,dDtFech,cArqTemp})
		EndIf          
		MsUnLock()				                 				
		dbSelectArea("SB2")
		dbSkip()
	End
	If lSaldTerceir .And. SB1->B1_FILIAL==xFilial("SB1") .And. SB1->B1_LOCPAD >= cAlmoxIni .And. SB1->B1_LOCPAD <= cAlmoxFim

		aSaldo:=SaldoTerc(SB1->B1_COD,cAlmoxIni,"D",dDtFech,cAlmoxFim)
		dbSelectArea(cArqTemp)
		dbSetOrder(2)
		If dbSeek(SB1->B1_COD+"1")
			RecLock(cArqTemp,.F.)
		Else
			RecLock(cArqTemp,.T.)
			lFirst:=.F.
			Replace SITUACAO	with "1"
			Replace TIPO		with SB1->B1_TIPO
			Replace POSIPI		with SB1->B1_POSIPI

			Replace PRODUTO		with SB1->B1_COD
			Replace DESCRICAO	with SB1->B1_DESC
			Replace UM			with SB1->B1_UM
		Endif
		Replace QUANTIDADE 	With QUANTIDADE-aSaldo[01]
		Replace TOTAL		With TOTAL-aSaldo[02]
		If QUANTIDADE>0 
			Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
		If lCalcUni
		   ExecBlock("A460UNIT",.F.,.F.,{SB1->B1_COD,SB2->B2_LOCAL,dDtFech,cArqTemp})
		EndIf          
		MsUnLock()				                 				
	EndIf
Endif
dbSelectArea("SB1")
Return (lEnd)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460Terceiros  ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Busca Saldo em poder de Terceiros (T) ou de Terceiros (D)   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Terceiros(lEnd,cArqTemp,cEmDeTerc)
Local aSaldo:={}
If lSaldTerceir.and.!lEnd .And. SB1->B1_FILIAL==xFilial("SB1").And. SB1->B1_LOCPAD >= cAlmoxIni .And. SB1->B1_LOCPAD <= cAlmoxFim
	aSaldo:=SaldoTerc(SB1->B1_COD,cAlmoxIni,If(cEmDeTerc=="4","D","T"),dDtFech,cAlmoxFim)
	// nao vou pegar terceiros que estiver negativo
	//If aSaldo[1]+aSaldo[2] # 0
	If aSaldo[1]+aSaldo[2] > 0
		dbSelectArea(cArqTemp)
		dbSetOrder(2)
		// Marllon - 10/06/2005
		//If dbSeek(SB1->B1_COD+cEmDeTerc)
		If cEmDeTerc $ '4/5'
			cEmDeTerc := '1'
		EndIf
		// Fim - Marllon
		
		If dbSeek(SB1->B1_COD+'1')
			RecLock(cArqTemp,.F.)
		Else
			RecLock(cArqTemp,.T.)
			Replace SITUACAO 	with cEmDeTerc
			Replace TIPO		with SB1->B1_TIPO
			Replace POSIPI		with SB1->B1_POSIPI
			Replace PRODUTO		with SB1->B1_COD
			Replace DESCRICAO	with SB1->B1_DESC
			Replace UM			with SB1->B1_UM
		Endif
		Replace QUANTIDADE	with QUANTIDADE+aSaldo[01]
		Replace TOTAL		with TOTAL+aSaldo[02]
		If aSaldo[01]>0
			Replace VALOR_UNIT 	with NoRound(TOTAL/QUANTIDADE,nDecVal)
		Endif
		MsUnLock()
	Endif
Endif
Return (NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460EmProcesso ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Busca saldo em Processo                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460EmProcesso(lEnd,cArqTemp)
Local lCusFIFO := GetMV("MV_CUSFIFO")
Local aCampos:={},cArqTemp2,cArqTemp3,cChave,cFiltro,nIndex,aSalAtu,aTam:={}
Local cAliasTop := "SD3"
#IFDEF TOP
	Local cQuery   := ""
#ENDIF

If lSaldProcess .and. !lEnd
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de Trabalho para armazenar as OPs               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTam := TamSX3("D3_OP")
	AADD(aCampos,{"OP","C",aTam[1],0})
	aTam := TamSX3("D3_SEQCALC")      
	AADD(aCampos,{"SEQCALC","C",aTam[1],0})
	AADD(aCampos,{"DATA1","D",8,0})
	cArqTemp2:=CriaTrab(aCampos)
	dbUseArea(.T.,,cArqTemp2,cArqTemp2,.T.,.F.)
	IndRegua(cArqTemp2,cArqTemp2,"OP+SEQCALC+DTOS(DATA1)",,,STR0020)		//"Criando Indice..."
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena OPs                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC2")
	dbSetOrder(2)
	dbSeek(xFilial()+mv_par05,.T.)	
	While !eof().and.!lEnd

		If ! Empty(mv_par06) .and. C2_PRODUTO > mv_par06
			Exit
		Endif	
		
		If Interrupcao(@lEnd)
			Exit
		Endif
		
		If (!Empty(SC2->C2_DATRF) .And. SC2->C2_DATRF <= dDtFech) .Or. ;
			!R460AvalProd(SC2->C2_PRODUTO)
			dbSkip()
			Loop
		Endif
		
		dbSelectArea(cArqTemp2)
		RecLock(cArqTemp2,.T.)
		Replace OP with SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
		MsUnLock()
		
		dbSelectArea("SC2")
		dbSkip()
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca saldo em processo                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD3")
	cArqTemp3:=CriaTrab(NIL,.F.)
	cChave   :="D3_FILIAL+D3_COD+D3_LOCAL"
	#IFDEF TOP
		cAliasTop := cArqTemp3
		cQuery := "SELECT D3_FILIAL,D3_COD,D3_LOCAL,D3_CF,D3_EMISSAO,D3_SEQCALC,D3_OP FROM "+RetSqlName("SD3")+" SD3, "
		cQuery += "WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' AND "
		cQuery += "SD3.D3_CF='PR0' AND SD3.D3_EMISSAO <= '" + DTOS(dDtFech) + "' AND "
		cQuery += "SD3.D3_OP <> '" + Criavar("D3_OP",.F.)+ "' AND SD3.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY "+SqlOrder(cChave)
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqTemp3,.T.,.T.)
		aEval(SD3->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cArqTemp3,x[1],x[2],x[3],x[4]),Nil)})
	#ELSE
		cFiltro:="D3_FILIAL=='"+xFilial("SD3")+"'.and.D3_CF=='PR0'.and.DTOS(D3_EMISSAO)<='"+DTOS(dDtFech)+"'.And.!Empty(D3_OP)"
		IndRegua("SD3",cArqTemp3,cChave,,cFiltro,STR0020)		//"Criando Indice..."
		nIndex:=RetIndex("SD3")
		dbSetIndex(cArqTemp3+OrdBagExt())
		dbSetOrder(nIndex+1)
		dbSeek(xFilial("SD3") + mv_par05, .T.)
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena OPs e data de emissao                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !eof().and.!lEnd
		If ! Empty(mv_par06) .and. (cAliasTop)->D3_COD > mv_par06
			Exit
		Endif	

		If Interrupcao(@lEnd)
			Exit
		Endif
		If !R460AvalProd((cAliasTop)->D3_COD)
			dbSkip()
			Loop
		Endif
		dbSelectArea(cArqTemp2)
		If dbSeek((cAliasTop)->D3_OP)
			RecLock(cArqTemp2,.F.)
		Else
			RecLock(cArqTemp2,.T.)
			Replace OP with (cAliasTop)->D3_OP
		Endif
		Replace DATA1 with Max((cAliasTop)->D3_EMISSAO,DATA1)
		If !lCalcProcDt .And. ((cAliasTop)->D3_SEQCALC > SEQCALC)
			Replace SEQCALC With (cAliasTop)->D3_SEQCALC
    	EndIf
		MsUnlock()
		dbSelectArea(cAliasTop)
		dbSkip()
	End

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura ambiente e apaga arquivo temporario                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		dbSelectArea(cAliasTop)
		dbCloseArea()
		dbSelectArea("SD3")
	#ELSE
		dbSelectArea("SD3")
		dbClearFilter()
		RetIndex("SD3")
		Ferase(cArqTemp3+OrdBagExt())
	#ENDIF

	dbSelectArea(cArqTemp2)
	dbGotop()
	While !Eof().and.!lEnd
		If Interrupcao(@lEnd)
			Exit
		Endif
		dbSelectArea("SD3")
		dbSetOrder(1)
		If dbSeek(xFilial()+(cArqTemp2)->OP)
			While !Eof().and.!lEnd.and.SD3->D3_OP==(cArqTemp2)->OP
				If Interrupcao(@lEnd)
					Exit
				Endif
				If !R460Local(D3_LOCAL).Or.!R460AvalProd(D3_COD).Or. ;
					D3_ESTORNO == "S" .Or. If(lCalcProcDt,D3_EMISSAO <= (cArqTemp2)->DATA1,D3_SEQCALC <= (cArqTemp2)->SEQCALC) .Or. ;
					D3_EMISSAO > dDtFech
					dbSkip()
					Loop
				EndIf
				If SB1->B1_COD!=SD3->D3_COD
					SB1->(dbSeek(xFilial()+SD3->D3_COD))
				EndIf
				If SB1->B1_COD==SD3->D3_COD
					dbSelectArea(cArqTemp)
					dbSetOrder(2)
					RecLock(cArqTemp,!dbSeek(SB1->B1_COD+"2"))
					Replace SITUACAO 	with "2"
					Replace TIPO		with SB1->B1_TIPO
					Replace POSIPI		with SB1->B1_POSIPI
					Replace PRODUTO		with SB1->B1_COD
					Replace DESCRICAO	with SB1->B1_DESC
					Replace UM			with SB1->B1_UM
					Do Case
						Case Substr(SD3->D3_CF,1,2)=="RE"
							Replace QUANTIDADE 	with QUANTIDADE + SD3->D3_QUANT
							Replace TOTAL		with TOTAL + SD3->D3_CUSTO1
						Case Substr(SD3->D3_CF,1,2)=="DE"
							Replace QUANTIDADE 	with QUANTIDADE - SD3->D3_QUANT
							Replace TOTAL		with TOTAL - SD3->D3_CUSTO1
					EndCase
					If QUANTIDADE>0
						Replace VALOR_UNIT	with NoRound(TOTAL/QUANTIDADE,nDecVal)
					Endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
					If lCalcUni
					   ExecBlock("A460UNIT",.F.,.F.,{SD3->D3_COD,SD3->D3_LOCAL,dDtFech,cArqTemp})
					EndIf          					
					MsUnLock()
				Endif
				dbSelectArea("SD3")
				dbSkip()
			End
		Endif
		dbSelectArea(cArqTemp2)
		dbSkip()
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga arquivos temporarios                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cArqTemp2)
	dbCloseArea()
	Ferase(cArqTemp2+GetDBExtension())
	Ferase(cArqTemp2+OrdBagExt())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca saldo em processo dos materiais de uso indireto        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSeek(xFilial())
	SetRegua(LastRec())
	While !eof().and.!lEnd.And.xFilial()==B1_FILIAL
		IncRegua()
		If Interrupcao(@lEnd)
			Exit
		Endif
		If !R460AvalProd(SB1->B1_COD)
			dbSkip()
			Loop
		Endif
		dbSelectArea("SB2")
		If lListCustMed1 .Or. (!lListCustMed1 .And. !lCusfifo)
			aSalatu:=CalcEst(SB1->B1_COD,GetMv("MV_LOCPROC"),dDtFech+1)
		Else
			aSalatu:=CalcEstFF(SB1->B1_COD,GetMv("MV_LOCPROC"),dDtFech+1)
		EndIf
		dbSelectArea(cArqTemp)
		dbSetOrder(2)
		RecLock(cArqTemp,!dbSeek(SB1->B1_COD+"2"))
		Replace SITUACAO 	with "2"
		Replace TIPO		with SB1->B1_TIPO
		Replace POSIPI		with SB1->B1_POSIPI
		Replace PRODUTO		with SB1->B1_COD
		Replace DESCRICAO	with SB1->B1_DESC
		Replace UM			with SB1->B1_UM
		Replace QUANTIDADE 	with QUANTIDADE + aSalAtu[1]
		Replace TOTAL		with TOTAL + aSalAtu[2]
		If QUANTIDADE>0
			Replace VALOR_UNIT with NoRound(TOTAL/QUANTIDADE,nDecVal)
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
		If lCalcUni
		   ExecBlock("A460UNIT",.F.,.F.,{SB1->B1_COD,GetMv("MV_LOCPROC"),dDtFech,cArqTemp})
		EndIf     
		MsUnlock()			                      					
		dbSelectArea("SB1")
		dbSkip()
	End
Endif

Return (lEnd)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460Cabec()    ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cabecalho do Modelo P7                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Cabec(nLin,nPagina)

Local aL:=R460LayOut()
Local cPicCgc
If  cPaisLoc=="ARG"
	cPicCgc	:="@R 99-99.999.999-9"
ElseIf cPaisLoc == "CHI"
	cPicCgc	:="@R XX.999.999-X"
ElseIf cPaisLoc $ "POR|EUA"
	cPicCgc	:=PesqPict("SA2","A2_CGC")
Else
	cPicCgc	:="@R 99.999.999/9999-99"
EndIf

nLin:=1
@ 00,00 PSAY AvalImp(132)
FmtLin(,aL[01],,,@nLin)
FmtLin(,aL[02],,,@nLin)
FmtLin(,aL[03],,,@nLin)
FmtLin({SM0->M0_NOMECOM},aL[04],,,@nLin)
FmtLin(,aL[05],,,@nLin)
If cPaisLoc == "CHI"
	FmtLin({,Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@nLin)
Else
FmtLin({InscrEst(),Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@nLin)
Endif

FmtLin(,aL[07],,,@nLin)
FmtLin({Transform(StrZero(nPagina,6),"@R 999.999"),DTOC(dDtFech)},aL[08],,,@nLin)
FmtLin(,aL[09],,,@nLin)
FmtLin(,aL[10],,,@nLin)
FmtLin(,aL[11],,,@nLin)
FmtLin(,aL[12],,,@nLin)
FmtLin(,aL[13],,,@nLin)
FmtLin(,aL[14],,,@nLin)
nPagina:=nPagina+1

Return (NIL)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460EmBranco() ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preenche o resto da pagina em branco                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460EmBranco(nLin)

Local aL:=R460Layout()

While nLin<=55
	FmtLin(Array(7),aL[15],,,@nLin)
End
FmtLin(,aL[16],,,@nLin)

Return (NIL)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460AvalProd() ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Avalia se produto deve ser listrado                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460AvalProd(cProduto)
Return((cProduto>=cProdIni.and.cProduto<=cProdFim) .And. !(Left(cProduto,3) == "MOD") .And. (SB1->B1_LOCPAD >= cAlmoxIni .And. SB1->B1_LOCPAD <= cAlmoxFim))
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460Local()    ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Avalia se Local deve ser listrado                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Local(cLocal)
Return (cLocal>=cAlmoxIni.and.cLocal<=cAlmoxFim)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460Acumula()  ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Acumulador de totais                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Acumula(aTotal)

Local nPos:=0

nPos:=Ascan(aTotal,{|x|x[1]==SITUACAO.and.x[2]==TIPO})
If nPos==0
	AADD(aTotal,{SITUACAO,TIPO,QUANTIDADE,VALOR_UNIT,TOTAL})
Else
	aTotal[nPos,3]+=QUANTIDADE
	aTotal[nPos,4]+=VALOR_UNIT
	aTotal[nPos,5]+=TOTAL
Endif

nPos:=Ascan(aTotal,{|x|x[1]==SITUACAO.and.x[2]==TT})
If nPos==0
	AADD(aTotal,{SITUACAO,TT,QUANTIDADE,VALOR_UNIT,TOTAL})
Else
	aTotal[nPos,3]+=QUANTIDADE
	aTotal[nPos,4]+=VALOR_UNIT
	aTotal[nPos,5]+=TOTAL
Endif

nPos:=Ascan(aTotal,{|x|x[1]=="T".and.x[2]==TT})
If nPos==0
	AADD(aTotal,{"T",TT,QUANTIDADE,VALOR_UNIT,TOTAL})
Else
	aTotal[nPos,3]+=QUANTIDADE
	aTotal[nPos,4]+=VALOR_UNIT
	aTotal[nPos,5]+=TOTAL
Endif

Return (NIL)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460Total()    ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime totais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Total(nLin,aTotal,cSituacao,cTipo,aSituacao,nPagina)

Local aL:=R460LayOut(),nPos:=0,i:=0,cSitAnt:="X",cSubtitulo

FmtLin(Array(7),aL[15],,,@nLin)

If cSituacao!="T"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime totais dos grupos                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTipo!=TT
		nPos:=Ascan(aTotal,{|x|x[1]==cSituacao.and.x[2]==cTipo})
		SX5->(dbSeek(xFilial()+"02"+cTipo))
		FmtLin({,STR0021+TRIM(X5Descri())+" ===>",,,,,Transform(aTotal[nPos,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)			//"TOTAL "
	Else
		nPos:=Ascan(aTotal,{|x|x[1]==cSituacao.and.x[2]==TT})
		FmtLin({,STR0021+aSituacao[Val(cSituacao)]+" ===>",,,,,Transform(aTotal[nPos,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)	//"TOTAL "
	Endif
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime resumo final                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTotal:=Asort(aTotal,,,{|x,y|x[1]+x[2]<y[1]+y[2]})
	FmtLin(Array(7),aL[15],,,@nLin)
	FmtLin({,STR0022,,,,,},aL[15],,,@nLin)		//"R E S U M O"
	FmtLin({,"***********",,,,,},aL[15],,,@nLin)
	For i:=1 to Len(aTotal)
		If nLin>55
			R460Cabec(@nLin,@nPagina)
			FmtLin(Array(7),aL[15],,,@nLin)
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nao imprime produtos sem movimentacao                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aTotal[i,1]=="3"
			Loop
		Endif
		If cSitAnt!=aTotal[i,1]
			cSitAnt:=aTotal[i,1]
			If aTotal[i,1]!="T"
				FmtLin(Array(7),aL[15],,,@nLin)
				cSubTitulo:=Alltrim(aSituacao[Val(aTotal[i,1])])
				FmtLin({,cSubtitulo,,,,,},aL[15],,,@nLin)
				FmtLin({,Replic("*",Len(cSubtitulo)),,,,,},aL[15],,,@nLin)
			Else
				FmtLin(Array(7),aL[15],,,@nLin)
				FmtLin({,STR0023,,,,,Transform(aTotal[i,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)		//"TOTAL GERAL ====>"
			Endif
		Endif
		If aTotal[i,1]!="T"
			If aTotal[i,2]!=TT
				SX5->(dbSeek(xFilial()+"02"+aTotal[i,2]))
				FmtLin({,TRIM(X5Descri()),,,,,Transform(aTotal[i,5],"@E 999,999,999,999.99")},aL[15],,,@nLin)
			Else
				FmtLin({,STR0024,,,,,Transform(aTotal[i,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)			//"TOTAL ====>"
			Endif
		Endif
		If nLin>=55
			R460EmBranco(@nLin)
		Endif
	Next
Endif

Return (NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460SemEst()   ³Autor³Rodrigo A Sartorio  ³ Data ³ 31.10.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime informacao sem estoque                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460SemEst(nLin,nPagina)
Local aL:=R460LayOut()
FmtLin(Array(7),aL[15],,,@nLin)
FmtLin({,STR0030,,,,,},aL[15],,,@nLin) //"ESTOQUE INEXISTENTE"
Return (NIL)