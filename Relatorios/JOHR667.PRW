#include "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JOHR667  º Autor ³ Marllon Figueiredo º Data ³  18/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³ Comissao por linha de produto                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function JohR667()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Comissoes por Linha de Produto"
Local cPict          := ""
Local titulo         := "Comissoes por Linha de Produto"
Local nLin           := 80
Local Cabec1         := "Codigo  Nome do Cliente        Prf Numero  P  Emissao   Venc.Real Desconto    Valor Titulo    Base Comissao   Grupo   Valor Item"
Local Cabec2         := ""
Local imprime        := .T.
Local cPerg          := PadR("JOR667",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "G"
Private nomeprog     := "JOHR667" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "JOHR667" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SE3"


dbSelectArea("SE3")
dbSetOrder(1)

ValidPerg(cPerg)
Pergunte(cPerg, .f.)

If ! MsgYesNo('Atenção! Não esqueça de executar o Recalculo de Comissões para o período selecionado'+;
              ' antes de emitir o relatório final de Comissões! Continua?')
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  18/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem
Local cQuery
//Local cCount
//Local cSelect
Local aLinhas   := Array(0)
Local aTotLinha := Array(0)
Local aItens    := Array(0)
Private nImpFed


nImpFed := GetMV('JO_IMPFED')    // CSLL=1,02%   PIS=3%  COFINS=0,65%  Imp.Renda=1,08%

If MV_PAR11 = 1
	Cabec1 := Cabec1 + "   Custo p/Parcel     Margem"
EndIf

// constroi a consulta aos dados do banco
//cCount  := "SELECT Count(*) as QTD_QTDREG "
cQuery  := "SELECT A1_NOME, B1_GRUPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, "
cQuery  +=        "E3_CODCLI, E3_LOJA, E3_BASE, E3_SERIE, E3_EMISSAO, E3_SEQ, E3_VEND, " 
cQuery  +=        "E1_EMISSAO, E1_VENCREA, E1_VALOR, "
cQuery  +=        "D2_DOC, D2_SERIE, D2_TOTAL, D2_CUSTO1, D2_VALIPI, D2_VALICM "
cQuery  += "FROM "+RetSqlName('SE3')+" SE3, "+;
                   RetSqlName('SD2')+" SD2, "+;
                   RetSqlName('SB1')+" SB1, "+;
                   RetSqlName('SF4')+" SF4, "+;
                   RetSqlName('SA1')+" SA1, "+;
                   RetSqlName('SE1')+" SE1 "
cQuery  += "WHERE E3_FILIAL       = '" + xFilial('SE3') + "' "
cQuery  += "AND   E3_DATA         = '' "
cQuery  += "AND   E3_EMISSAO     >= '" + Dtos(MV_PAR01) + "' "
cQuery  += "AND   E3_EMISSAO     <= '" + Dtos(MV_PAR02) + "' "
cQuery  += "AND   E3_VEND        >= '" + MV_PAR07       + "' "
cQuery  += "AND   E3_VEND        <= '" + MV_PAR08       + "' "
cQuery  += "AND   E3_CODCLI      >= '" + MV_PAR03       + "' "
cQuery  += "AND   E3_LOJA        >= '" + MV_PAR04       + "' "
cQuery  += "AND   E3_CODCLI      <= '" + MV_PAR05       + "' "
cQuery  += "AND   E3_LOJA        <= '" + MV_PAR06       + "' "

cQuery  += "AND   D2_FILIAL       = '" + xFilial('SD2') + "' "
cQuery  += "AND   D2_DOC          = E3_NUM "
cQuery  += "AND   D2_SERIE        = E3_SERIE "
cQuery  += "AND   D2_CLIENTE      = E3_CODCLI "
cQuery  += "AND   D2_LOJA         = E3_LOJA "

cQuery  += "AND   B1_FILIAL       = '" + xFilial('SB1') + "' "
cQuery  += "AND   B1_COD          = D2_COD "

cQuery  += "AND   F4_FILIAL       = '" + xFilial('SF4') + "' "
cQuery  += "AND   F4_CODIGO       = D2_TES "
cQuery  += "AND   F4_DUPLIC       = 'S' "

cQuery  += "AND   A1_FILIAL       = '" + xFilial('SA1') + "' "
cQuery  += "AND   A1_COD          = D2_CLIENTE "
cQuery  += "AND   A1_LOJA         = D2_LOJA "

cQuery  += "AND   E1_FILIAL       = '" + xFilial('SE1') + "' "
cQuery  += "AND   E1_NUM          = E3_NUM "
cQuery  += "AND   E1_PREFIXO      = E3_PREFIXO "
cQuery  += "AND   E1_PARCELA      = E3_PARCELA "
cQuery  += "AND   E1_TIPO         = E3_TIPO "

cQuery  += "AND   SE3.D_E_L_E_T_  = '' "
cQuery  += "AND   SD2.D_E_L_E_T_  = '' "
cQuery  += "AND   SB1.D_E_L_E_T_  = '' "
cQuery  += "AND   SF4.D_E_L_E_T_  = '' "
cQuery  += "AND   SA1.D_E_L_E_T_  = '' "
cQuery  += "AND   SE1.D_E_L_E_T_  = '' "

cQuery  += "UNION ALL "

cQuery  += "SELECT A1_NOME, B1_GRUPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, "
cQuery  +=        "E3_CODCLI, E3_LOJA, E3_BASE, E3_SERIE, E3_EMISSAO, E3_SEQ, E3_VEND, " 
cQuery  +=        "E1_EMISSAO, E1_VENCREA, E1_VALOR, "
cQuery  +=        "D2_DOC, D2_SERIE, D2_TOTAL, D2_CUSTO1, D2_VALIPI, D2_VALICM "
cQuery  += "FROM "+RetSqlName('SE3')+" SE3, "+;
                   RetSqlName('SD2')+" SD2, "+;
                   RetSqlName('SB1')+" SB1, "+;
                   RetSqlName('SF4')+" SF4, "+;
                   RetSqlName('SA1')+" SA1, "+;
                   RetSqlName('SE1')+" SE1, "+;
                   RetSqlName('SE5')+" SE5 "
cQuery  += "WHERE E3_FILIAL       = '" + xFilial('SE3') + "' "
cQuery  += "AND   E3_DATA         = '' "
cQuery  += "AND   E3_EMISSAO     >= '" + Dtos(MV_PAR01) + "' "
cQuery  += "AND   E3_EMISSAO     <= '" + Dtos(MV_PAR02) + "' "
cQuery  += "AND   E3_VEND        >= '" + MV_PAR07       + "' "
cQuery  += "AND   E3_VEND        <= '" + MV_PAR08       + "' "
cQuery  += "AND   E3_CODCLI      >= '" + MV_PAR03       + "' "
cQuery  += "AND   E3_LOJA        >= '" + MV_PAR04       + "' "
cQuery  += "AND   E3_CODCLI      <= '" + MV_PAR05       + "' "
cQuery  += "AND   E3_LOJA        <= '" + MV_PAR06       + "' "
cQuery  += "AND   E3_SERIE       <> 'UNI' "

cQuery  += "AND   E5_FILIAL       = '" + xFilial('SE5') + "' "
cQuery  += "AND   E5_DOCUMEN      = (SELECT E1_NUMLIQ "
cQuery  +=                          "FROM "+RetSqlName('SE1')+" SSE1 "
cQuery  +=                          "WHERE SSE1.E1_FILIAL   = '" + xFilial('SE1') + "' "
cQuery  +=                          "AND   SSE1.E1_PREFIXO  = E3_PREFIXO "
cQuery  +=                          "AND   SSE1.E1_NUM      = E3_NUM "
cQuery  +=                          "AND   SSE1.E1_PARCELA  = E3_PARCELA "
cQuery  +=                          "AND   SSE1.E1_TIPO     = E3_TIPO "
cQuery  +=                          "AND   SSE1.E1_CLIENTE  = E3_CODCLI "
cQuery  +=                          "AND   SSE1.E1_LOJA     = E3_LOJA "
cQuery  +=                          "AND   SSE1.E1_NUMLIQ  <> '' "
cQuery  +=                          "AND   SSE1.D_E_L_E_T_  = '') "
cQuery  += "AND   E5_CLIFOR      = E3_CODCLI "
cQuery  += "AND   E5_LOJA        = E3_LOJA "
cQuery  += "AND   E5_RECPAG      = 'R' "

cQuery  += "AND   E1_FILIAL       = '" + xFilial('SE1') + "' "
cQuery  += "AND   E1_PREFIXO      = E5_PREFIXO "
cQuery  += "AND   E1_NUM          = E5_NUMERO "
cQuery  += "AND   E1_PARCELA      = E5_PARCELA "
cQuery  += "AND   E1_TIPO         = E5_TIPO "
cQuery  += "AND   E1_CLIENTE      = E5_CLIFOR "
cQuery  += "AND   E1_LOJA         = E5_LOJA "

cQuery  += "AND   D2_FILIAL       = '01' "
cQuery  += "AND   D2_DOC          = E1_NUM "
cQuery  += "AND   D2_SERIE        = E1_SERIE "
cQuery  += "AND   D2_CLIENTE      = E1_CLIENTE "
cQuery  += "AND   D2_LOJA         = E1_LOJA "

cQuery  += "AND   B1_FILIAL       = '" + xFilial('SB1') + "' "
cQuery  += "AND   B1_COD          = D2_COD "

cQuery  += "AND   F4_FILIAL       = '" + xFilial('SF4') + "' "
cQuery  += "AND   F4_CODIGO       = D2_TES "
cQuery  += "AND   F4_DUPLIC       = 'S' "

cQuery  += "AND   A1_FILIAL       = '" + xFilial('SA1') + "' "
cQuery  += "AND   A1_COD          = D2_CLIENTE "
cQuery  += "AND   A1_LOJA         = D2_LOJA "

cQuery  += "AND   SE3.D_E_L_E_T_  = '' "
cQuery  += "AND   SE5.D_E_L_E_T_  = '' "
cQuery  += "AND   SD2.D_E_L_E_T_  = '' "
cQuery  += "AND   SB1.D_E_L_E_T_  = '' "
cQuery  += "AND   SF4.D_E_L_E_T_  = '' "
cQuery  += "AND   SA1.D_E_L_E_T_  = '' "
cQuery  += "AND   SE1.D_E_L_E_T_  = '' "

cOrder  := "ORDER BY E3_VEND, E1_NUM, E1_PARCELA, E1_TIPO, E3_SEQ, B1_GRUPO "

// salvo a consulta
MemoWrit("JOHR667.sql", cQuery+cOrder)

//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSelect+cQuery+cOrder),'SE3TMP',.T.,.T.)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery+cOrder),'SE3TMP',.T.,.T.)

// converte campos DATA/NUMERICO
TCSetField('SE3TMP', "E1_EMISSAO", "D", 8, 0)
TCSetField('SE3TMP', "E3_EMISSAO", "D", 8, 0)
TCSetField('SE3TMP', "E3_BASE",    "N", 14,2)
TCSetField('SE3TMP', "D2_TOTAL",   "N", 14,2)
TCSetField('SE3TMP', "E1_VENCREA", "D", 8,0)
TCSetField('SE3TMP', "E1_VALOR",   "N", 14,2)
TCSetField('SE3TMP', "D2_CUSTO1",  "N", 14,2)

dbSelectArea('SE3TMP')
Count To nQtdReg
DbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ProcRegua(nQtdReg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTitulo   := 'xxxx'
nTotVend  := 0
nTotGeral := 0
cVend     := 'xxxxxx'
dbSelectArea('SE3TMP')
dbGoTop()
While !Eof()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSAY para saida na impressora. Por exemplo:
	If cVend <> SE3TMP->E3_VEND
		nLin++
		nLin++
		SA3->( dbSeek(xFilial('SA3')+SE3TMP->E3_VEND) )
		@ nLin,00 PSAY 'NOME DO VENDEDOR: ' + SE3TMP->E3_VEND + ' - ' + SA3->A3_NOME
		nLin++
		nLin++
		cVend    := SE3TMP->E3_VEND
		aLinhas  := Array(0)
	EndIf

    // vou recuperar todos os itens da nota com seus respectivos grupos (Linha)
	If cTitulo <> SE3TMP->E1_PREFIXO+SE3TMP->E1_NUM+SE3TMP->E1_PARCELA+SE3TMP->E1_TIPO+SE3TMP->E3_SEQ

		// totalizacao geral do vendedor
//		nTotVend  += SE3TMP->E3_BASE
//		nTotGeral += SE3TMP->E3_BASE
		nTotNota  := 0

		cTitulo := SE3TMP->E1_PREFIXO+SE3TMP->E1_NUM+SE3TMP->E1_PARCELA+SE3TMP->E1_TIPO+SE3TMP->E3_SEQ
		// posiciono na nota 
		SF2->( dbSeek(xFilial('SF2')+SE3TMP->E1_NUM+SE3TMP->E1_PREFIXO) )
		// condicao de pagamento
		SE4->( dbSeek(xFilial('SE4')+SF2->F2_COND) )
		nQtdParc := RetQtdParc()
		
	    aItens  := Array(0)
	    Do While !Eof() .and. cTitulo == SE3TMP->E1_PREFIXO+SE3TMP->E1_NUM+SE3TMP->E1_PARCELA+SE3TMP->E1_TIPO+SE3TMP->E3_SEQ
			// linhas que vao compor o relatorio
			Aadd( aItens, {SubStr(SE3TMP->A1_NOME,1,20) ,;
			               SE3TMP->E1_PREFIXO ,;
			               SE3TMP->E1_NUM ,;
			               SE3TMP->E1_PARCELA ,;
			               SE3TMP->E1_EMISSAO ,;
			               SE3TMP->E1_VENCREA ,;
			               0 ,;
			               SE3TMP->E1_VALOR ,;
			               SE3TMP->E3_BASE ,;
			               SE3TMP->B1_GRUPO ,;
			               SE3TMP->D2_TOTAL,;
			               SE3TMP->E3_CODCLI,;
			               SE3TMP->D2_CUSTO1/nQtdParc,;     // a Jomhedica quer pegar proporcional aa quantidade de parcelas da nota
			               SE3TMP->D2_TOTAL/nQtdParc,;
			               SE3TMP->D2_VALICM/nQtdParc,;
			               SE3TMP->D2_VALIPI/nQtdParc} )    // a Jomhedica quer pegar proporcional aa quantidade de parcelas da nota

			// totaliza a nota para fazer o rateio das linhas
			nTotNota += SE3TMP->D2_TOTAL
			
			IncProc()
			
			dbSelectArea('SE3TMP')
	    	dbSkip()
	    EndDo
	EndIf
	
//  Cliente
//  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//            1         2         3         4         5         6         7         8         9        10        11        12        13        14
//  Codigo  Nome do Cliente        Prf Numero  P  Emissao   Venc.Real Desconto    Valor Titulo    Base Comissao   Grupo   Valor Item
	
	For nStart := 1 To Len(aItens)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
	
		If MV_PAR09 = 1     // analitico
			If nStart = 1
			    // verifico se teve desconto na baixa do titulo
			    //SE5->( dbSetOrder(2) )
			    //SE5->( dbSeek(xFilial('SE5')+'VL'+aItens[nStart, 2]+aItens[nStart, 3]+aItens[nStart, 4]+SE3TMP->E3_TIPO+DtoS(SE3TMP->E3_EMISSAO)+SE3TMP->E3_CODCLI+SE3TMP->E3_LOJA+SE3TMP->E3_SEQ) )
				
				@ nLin,00 PSAY aItens[nStart, 12]    // SE3TMP->E3_CODCLI
				@ nLin,08 PSAY aItens[nStart, 1]     // SubStr(SE3TMP->A1_NOME,1,20)
				@ nLin,31 PSAY aItens[nStart, 2]     // SE3TMP->E1_PREFIXO
				@ nLin,35 PSAY aItens[nStart, 3]     // SE3TMP->E1_NUM
				@ nLin,43 PSAY aItens[nStart, 4]     // SE3TMP->E1_PARCELA
				@ nLin,46 PSAY aItens[nStart, 5]     // SE3TMP->E1_EMISSAO
				@ nLin,56 PSAY aItens[nStart, 6]     // SE3TMP->E1_VENCREA
				//@ nLin,66 PSAY SE5->E5_VALOR        PICTURE "@ER 999,999.99"
				@ nLin,76 PSAY aItens[nStart, 8]    PICTURE "@ER 999,999,999.99"   // SE3TMP->E1_VALOR  PICTURE "@ER 999,999,999.99" 
				@ nLin,94 PSAY aItens[nStart, 9]    PICTURE "@ER 999,999,999.99"   // SE3TMP->E3_BASE   PICTURE "@ER 999,999,999.99" 

				// totalizacao geral do vendedor
				//nTotVend  += SE3TMP->E3_BASE
				//nTotGeral += SE3TMP->E3_BASE
			EndIf
			@ nLin,112 PSAY aItens[nStart, 10]    // SE3TMP->B1_GRUPO          
			@ nLin,116 PSAY aItens[nStart, 11]    PICTURE "@ER 999,999,999.99"   // SE3TMP->D2_TOTAL  PICTURE "@ER 999,999,999.99" 

			If MV_PAR11 = 1
				@ nLin,130 PSAY aItens[nStart, 13]    PICTURE "@ER 999,999,999.99"   // custo por parcela
				@ nLin,145 PSAY ((aItens[nStart,14]-aItens[nStart,13])/aItens[nStart,13])*100   PICTURE "@ER 999,999.99 %"    // margem
			EndIf
			
			nLin := nLin + 1 // Avanca a linha de impressao
		EndIf
		
		// totalizacao por linha de produtos
		nParticip := (aItens[nStart, 11] / nTotNota) * 100
		nPos := aScan( aLinhas, {|x| x[1] == aItens[nStart, 10]} )
		If nPos > 0
			aLinhas[nPos,2] :=  aLinhas[nPos,2] + (aItens[nStart, 9] * nParticip)/100
			// pos 13 - Custo  -  pos 14 - Venda
			aLinhas[nPos,3] :=  aLinhas[nPos,3] + aItens[nStart, 14]
			aLinhas[nPos,4] :=  aLinhas[nPos,4] + aItens[nStart, 13]
			// ICMS ed IPI
			aLinhas[nPos,5] :=  aLinhas[nPos,5] + aItens[nStart, 15]
			aLinhas[nPos,6] :=  aLinhas[nPos,6] + aItens[nStart, 16]
		Else             // linha             ------  valor base da linha ------
			//                                                                             pos 13 - Custo  -  pos 14 - Venda
			Aadd( aLinhas, { aItens[nStart, 10],;
			                 (aItens[nStart, 9] * nParticip)/100,;
			                 aItens[nStart, 14],;
			                 aItens[nStart, 13],;
			                 aItens[nStart, 15],;
			                 aItens[nStart, 16],;
			                 cVend } )
		EndIf
	Next

	If MV_PAR09 = 1       // analitico
		nLin := nLin + 1  // avanca a linha de impressao
	EndIf
	
	// Totaliza o vendedor
	If cVend <> SE3TMP->E3_VEND

		If nLin + 7 + Len(aLinhas) > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		EndIf
		
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao

		// participacao por linha de produto
		@ nLin,10 PSAY "Participacao por Linha de Produto:"
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
						
		// ordena por linha
		aLinhas := aSort(aLinhas,,, {|x,y| x[1] <= y[1]})
		If MV_PAR11 = 1
			//                                                                                                                            999,999.99 %    999,999.99   999,999.99   999,999.99   999,999.99   999,999.99   999,999.99
			@ nLin,10 PSAY "Linha de Produto                                   Base de Calculo         Custo Total        Resultado R$          Margem  Imp.Federais         ICMS          IPI      % Comis     Comissao"
                         // 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
                         // 1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
                         // Linha de Produto                                   Base de Calculo         Custo Total        Resultado R$          Margem"
		Else
			//                                                                                         999,999.99   999,999.99   999,999.99   999,999.99   999,999.99   999,999.99
			@ nLin,10 PSAY "Linha de Produto                                   Base de Calculo       Imp.Federais         ICMS          IPI      % COMIS     Comissao"
		EndIf
		
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
		
		nTotCust := 0
		nTotDif  := 0
		nMedia   := 0
		nTImpFed := 0
		nTIcms   := 0
		nTIpi    := 0
		nTComis  := 0
		For nStart := 1 To Len(aLinhas)        
			SBM->( dbSeek(xFilial('SBM')+aLinhas[nStart,1]) )
			@ nLin,10 PSAY Substr(aLinhas[nStart,1] + ' - ' + SBM->BM_DESC, 1, 45)
			@ nLin,60 PSAY aLinhas[nStart,2]   PICTURE "@ER 9,999,999,999.99"           // base de calculo

			nTotVend  += aLinhas[nStart,2]   //SE3TMP->E3_BASE
			nTotGeral += aLinhas[nStart,2]   //SE3TMP->E3_BASE

			// custos
			If MV_PAR11 = 1
				@ nLin,080 PSAY aLinhas[nStart,4]                     PICTURE "@ER 9,999,999,999.99"      // custo total
				@ nLin,100 PSAY aLinhas[nStart,2]-aLinhas[nStart,4]   PICTURE "@ER 9,999,999,999.99"      // resultado R$
				@ nLin,120 PSAY ((aLinhas[nStart,3]-aLinhas[nStart,4])/aLinhas[nStart,4])*100   PICTURE "@ER 999,999.99 %"   // Margem

				@ nLin,136 PSAY aLinhas[nStart,2]*(nImpFed/100)   PICTURE "@ER 999,999.99"      // imp. federais
				@ nLin,149 PSAY aLinhas[nStart,5]    PICTURE "@ER 999,999.99"      // ICMS
				@ nLin,162 PSAY aLinhas[nStart,6]    PICTURE "@ER 999,999.99"      // IPI

				//aComissao := RetComissao(aLinhas[nStart])
				//@ nLin,175 PSAY aComissao[1]    PICTURE "@ER 999,999.99"      // % Comissao
				//@ nLin,188 PSAY aComissao[2]    PICTURE "@ER 999,999.99"      // Valor Comissao
				
				nTotCust += aLinhas[nStart,4]
				nTotDif  += (aLinhas[nStart,2]-aLinhas[nStart,4])
				nMedia   += (((aLinhas[nStart,3]-aLinhas[nStart,4])/aLinhas[nStart,4])*100)
				nTImpFed += aLinhas[nStart,2]*(nImpFed/100)
				nTIcms   += aLinhas[nStart,5]
				nTIpi    += aLinhas[nStart,6]
				//nTComis  += aComissao[2]
			Else
				@ nLin,085 PSAY aLinhas[nStart,2]*(nImpFed/100)   PICTURE "@ER 999,999.99"      // IMP. FEDERAIS
				@ nLin,098 PSAY aLinhas[nStart,5]    PICTURE "@ER 999,999.99"      // ICMS
				@ nLin,111 PSAY aLinhas[nStart,6]    PICTURE "@ER 999,999.99"      // IPI

				//aComissao := RetComissao(aLinhas[nStart])
				//@ nLin,124 PSAY aComissao[1]    PICTURE "@ER 999,999.99"      // % Comissao
				//@ nLin,137 PSAY aComissao[2]    PICTURE "@ER 999,999.99"      // Valor Comissao
				
				nTImpFed += aLinhas[nStart,2]*(nImpFed/100)
				nTIcms   += aLinhas[nStart,5]
				nTIpi    += aLinhas[nStart,6]
				//nTComis  += aComissao[2]
            EndIf
            
			nLin := nLin + 1
		Next

		nLin := nLin + 1 // Avanca a linha de impressao
		@ nLin,10 PSAY "Total para o Vendedor:"
		@ nLin,60 PSAY nTotVend   PICTURE "@ER 9,999,999,999.99" 
		If MV_PAR11 = 1
			@ nLin,080 PSAY nTotCust     PICTURE "@ER 9,999,999,999.99"
			@ nLin,100 PSAY nTotDif      PICTURE "@ER 9,999,999,999.99"
			//@ nLin,120 PSAY nMedia/Len(aLinhas)    PICTURE "@ER 999,999.99 %"
			@ nLin,136 PSAY nTImpFed     PICTURE "@ER 999,999.99"      // IMP. FEDERAIS
			@ nLin,149 PSAY nTIcms       PICTURE "@ER 999,999.99"      // ICMS
			@ nLin,162 PSAY nTIpi        PICTURE "@ER 999,999.99"      // IPI
			//@ nLin,188 PSAY nTComis      PICTURE "@ER 999,999.99"      // COMISSAO
		Else
			@ nLin,085 PSAY nTImpFed     PICTURE "@ER 999,999.99"      // IMP. FEDERAIS
			@ nLin,098 PSAY nTIcms       PICTURE "@ER 999,999.99"      // ICMS
			@ nLin,111 PSAY nTIpi        PICTURE "@ER 999,999.99"      // IPI
			//@ nLin,137 PSAY nTComis      PICTURE "@ER 999,999.99"      // COMISSAO
		EndIf

		aLinhas := Array(0)
		nTotVend := 0
				
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao

		If MV_PAR10 = 1   // quebra pag. por vendedor
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		EndIf
	EndIf
	
EndDo

// totalizacao geral de comissoes
nLin := nLin + 1 // Avanca a linha de impressao
nLin := nLin + 1 // Avanca a linha de impressao
@ nLin,00 PSAY Replicate('*', 220)
nLin := nLin + 1 // Avanca a linha de impressao
@ nLin,10 PSAY "Total Geral:"
@ nLin,60 PSAY nTotGeral   PICTURE "@ER 9,999,999,999.99" 
nLin := nLin + 1 // Avanca a linha de impressao
@ nLin,00 PSAY Replicate('*', 220)

// fecha o alias temporario
dbSelectArea('SE3TMP')
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return



Static Function ValidPerg( cPerg )

DbSelectArea("SX1")
DbSetOrder(1)
IF !DbSeek( cPerg )
	
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg        ,;
	X1_ORDEM   With "01"                    ,;
	X1_PERGUNT With "Baixa de ..........?"  ,;
	X1_VARIAVL With "mv_ch1"                ,;
	X1_TIPO    With "D"                     ,;
	X1_TAMANHO With 8                       ,;
	X1_VAR01   With "MV_PAR01"              ,;
	X1_GSC     With "G"
	MsUnlock()
	
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg        ,;
	X1_ORDEM   With "02"                    ,;
	X1_PERGUNT With "Baixa ate..........?"  ,;
	X1_VARIAVL With "mv_ch2"                ,;
	X1_TIPO    With "D"                     ,;
	X1_TAMANHO With 8                       ,;
	X1_VAR01   With "MV_PAR02"              ,;
	X1_GSC     With "G"
	MsUnlock()
	
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg        ,;
	X1_ORDEM   With "03"                    ,;
	X1_PERGUNT With "Cliente de.........?"  ,;
	X1_VARIAVL With "mv_ch3"                ,;
	X1_TIPO    With "C"                     ,;
	X1_TAMANHO With 6                       ,;
	X1_VAR01   With "MV_PAR03"              ,;
	X1_GSC     With "G"                     ,;
	X1_F3      With "SA1"
	MsUnlock()
	
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg        ,;
	X1_ORDEM   With "04"                    ,;
	X1_PERGUNT With "Loja de............?"  ,;
	X1_VARIAVL With "mv_ch4"                ,;
	X1_TIPO    With "C"                     ,;
	X1_TAMANHO With 2                       ,;
	X1_VAR01   With "MV_PAR04"              ,;
	X1_GSC     With "G"
	MsUnlock()
	
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg        ,;
	X1_ORDEM   With "05"                    ,;
	X1_PERGUNT With "Cliente ate........?"  ,;
	X1_VARIAVL With "mv_ch5"                ,;
	X1_TIPO    With "C"                     ,;
	X1_TAMANHO With 6                       ,;
	X1_VAR01   With "MV_PAR05"              ,;
	X1_GSC     With "G"                     ,;
	X1_F3      With "SA1"
	MsUnlock()
	
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg        ,;
	X1_ORDEM   With "06"                    ,;
	X1_PERGUNT With "Loja ate...........?"  ,;
	X1_VARIAVL With "mv_ch6"                ,;
	X1_TIPO    With "C"                     ,;
	X1_TAMANHO With 2                      ,;
	X1_VAR01   With "MV_PAR06"              ,;
	X1_GSC     With "G"
	MsUnlock()
	
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg        ,;
	X1_ORDEM   With "07"                    ,;
	X1_PERGUNT With "Vendedor de........?"  ,;
	X1_VARIAVL With "mv_ch7"                ,;
	X1_TIPO    With "C"                     ,;
	X1_TAMANHO With 6                       ,;
	X1_VAR01   With "MV_PAR07"              ,;
	X1_GSC     With "G"                     ,;
	X1_F3      With "SA3"
	MsUnlock()
	
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg        ,;
	X1_ORDEM   With "08"                    ,;
	X1_PERGUNT With "Vendedor ate.......?"  ,;
	X1_VARIAVL With "mv_ch8"                ,;
	X1_TIPO    With "C"                     ,;
	X1_TAMANHO With 6                       ,;
	X1_VAR01   With "MV_PAR08"              ,;
	X1_GSC     With "G"                     ,;
	X1_F3      With "SA3"
	MsUnlock()
	
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg        ,;
	X1_ORDEM   With "11"                    ,;
	X1_PERGUNT With "Analitico/Sintetico"   ,;
	X1_VARIAVL With "mv_chB"                ,;
	X1_TIPO    With "N"                     ,;
	X1_TAMANHO With 1                       ,;
	X1_VAR01   With "MV_PAR09"              ,;
	X1_GSC     With "C"                     ,;
	X1_DEF01   WITH "Analitico"             ,;
	X1_DEF02   WITH "Sintetico"
	MsUnlock()
	
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg        ,;
	X1_ORDEM   With "12"                    ,;
	X1_PERGUNT With "Salta pag. Vendedor"   ,;
	X1_VARIAVL With "mv_chC"                ,;
	X1_TIPO    With "N"                     ,;
	X1_TAMANHO With 1                       ,;
	X1_VAR01   With "MV_PAR10"              ,;
	X1_GSC     With "C"                     ,;
	X1_DEF01   WITH "Sim"                   ,;
	X1_DEF02   WITH "Nao"
	MsUnlock()

EndIF

IF !DbSeek( cPerg + '13' )
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg        ,;
	X1_ORDEM   With "13"                    ,;
	X1_PERGUNT With "Demonstra Margem ? "   ,;
	X1_VARIAVL With "mv_chd"                ,;
	X1_TIPO    With "N"                     ,;
	X1_TAMANHO With 1                       ,;
	X1_VAR01   With "MV_PAR11"              ,;
	X1_GSC     With "C"                     ,;
	X1_DEF01   WITH "Sim"                   ,;
	X1_DEF02   WITH "Nao"
	MsUnlock()
EndIf

Return



Static Function RetQtdParc()
Local nQtd   := 1
Local cCond  := Alltrim(SE4->E4_COND)
Local nPos

If SE4->E4_TIPO <> '9'
	Do While Len(cCond) > 0
		nPos := At(',', cCond)
		If nPos > 0
			cCond := SubStr(cCond, nPos+1)
			nQtd++
		Else
			Exit
	    EndIf
	EndDo
Else
	// verifico quantos titulos foram gerados
	nQtd := 0
	SE1->( dbSeek(xFilial('SE1')+SE3TMP->E1_PREFIXO+SE3TMP->E1_NUM) )
	Do While ! SE1->( Eof() ) .and. xFilial('SE1')+SE3TMP->E1_PREFIXO+SE3TMP->E1_NUM == SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM
		If SE3TMP->E1_TIPO == SE1->E1_TIPO
			nQtd++
		EndIf
		SE1->( dbSkip() )
	EndDo
EndIf

Return( nQtd )


/* Retorna o percentual de comissao o valor */
Static Function RetComissao( aDados )
Local aRet := {0,0}

// localiza o percentual de comissao
If SZB->( dbSeek(xFilial('SZB')+aDados[7]+aDados[1]) )
	Do While ! SZB->( Eof() ) .and. xFilial('SZB')+aDados[7]+aDados[1] == SZB->ZB_FILIAL+SZB->ZB_VEND+SZB->ZB_GRUPO
		If aDados[2] >= SZB->ZB_FAXDE .and. aDados[2] <= SZB->ZB_FAXATE
			aRet := {SZB->ZB_COMIS, (aDados[2]*SZB->ZB_COMIS)/100}
			Exit
		EndIf
		SZB->( dbSkip() )
	EndDo
Else
	// caso nao tenha configuracao para a linha, vou procurar a configuracao default (GRUPO em 	BRANCO)
	If SZB->( dbSeek(xFilial('SZB')+aDados[7]+Space(4)) )
		Do While ! SZB->( Eof() ) .and. xFilial('SZB')+aDados[7]+Space(4) == SZB->ZB_FILIAL+SZB->ZB_VEND+SZB->ZB_GRUPO
			If aDados[2] >= SZB->ZB_FAXDE .and. aDados[2] <= SZB->ZB_FAXATE
				aRet := {SZB->ZB_COMIS, (aDados[2]*SZB->ZB_COMIS)/100}
				Exit
			EndIf
			SZB->( dbSkip() )
		EndDo
	EndIf
EndIf

Return( aRet )
