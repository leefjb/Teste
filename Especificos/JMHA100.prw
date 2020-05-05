#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ JMHA100  ³       ³ Marllon Figueiredo    ³ Data ³ 24/09/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inclusao de contagem 0 (zero) pada produtos / lotes no SB7 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Jomhedica                                  ³±±
±±³          ³ Esta rotina sera executada apos a digitacao do inventario e³±±
±±³          ³ com a finalidade de popular o SB7 - Inventario com os pro- ³±±
±±³          ³ dutos que nao existem em estoque más que consta como saldo ³±±
±±³          ³ maior que 0 (zero) com isto evita-se a obrigatoriedade de  ³±±
±±³          ³ digitar manualmente estes codigos com quantidade zero.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutencao³ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function JMHA100()

//Local cPerg := 'JMA100'
Local cPerg := PadR("JMA100",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

ValidPerg(cPerg)

dbSelectArea('SB7')
dbSetOrder(1)

If Pergunte(cPerg, .t.)
	// verifica parametro de fechamento de estoque
	If MV_PAR01 > GetMV('MV_ULMES')
		// verifica se existe inventario na data informada
		If dbSeek(xFilial('SB7')+Dtos(MV_PAR01))
			Processa( {|| RunProc() },"Processando produtos com saldo 0 (zero)","Aguarde.." )
		Else
			MsgInfo('Não existe inventario para esta data!')
		EndIf
	Else
		MsgInfo('A Data informada deve ser maior que a data de ultimo fechamento de estoque!')
	EndIf
Endif

Return

Static Function RunProc()

Local nQtdReg 

// contagem de registros
BeginSql alias 'SB8QTD'
	SELECT Count(*) as QTDREG 
	FROM %table:SB8% SB8, %table:SB1% SB1
	WHERE     SB8.B8_FILIAL = %xfilial:SB8%
	      and SB8.B8_LOCAL >= %exp:MV_PAR03%
	      and SB8.B8_LOCAL <= %exp:MV_PAR04%
	      and SB8.B8_SALDO > 0
	      and SB8.%notDel%
	      and SB1.B1_FILIAL = %xfilial:SB1%
	      and SB1.B1_COD = SB8.B8_PRODUTO
	      and SB1.B1_GRUPO >= %exp:MV_PAR05%
	      and SB1.B1_GRUPO <= %exp:MV_PAR06%
	      and SB1.B1_COD >= %exp:MV_PAR07%
	      and SB1.B1_COD <= %exp:MV_PAR08%
	      and SB1.%notDel%
EndSql
nQtdReg := SB8QTD->QTDREG
dbSelectArea('SB8QTD')
dbCloseArea()

ProcRegua(nQtdReg)

// recupera dados dos produtos
BeginSql alias 'SB8TMP'
	column B8_DTVALID as Date

	SELECT B8_PRODUTO, B8_LOCAL, B8_LOTECTL, B8_DTVALID, B1_TIPO 
	FROM %table:SB8% SB8, %table:SB1% SB1
	WHERE     SB8.B8_FILIAL = %xfilial:SB8%
	      and SB8.B8_LOCAL >= %exp:MV_PAR03%
	      and SB8.B8_LOCAL <= %exp:MV_PAR04%
	      and SB8.B8_SALDO > 0
	      and SB8.%notDel%
	      and SB1.B1_FILIAL = %xfilial:SB1%
	      and SB1.B1_COD = SB8.B8_PRODUTO
	      and SB1.B1_GRUPO >= %exp:MV_PAR05%
	      and SB1.B1_GRUPO <= %exp:MV_PAR06%
	      and SB1.B1_COD >= %exp:MV_PAR07%
	      and SB1.B1_COD <= %exp:MV_PAR08%
	      and SB1.%notDel%
EndSql

Do While ! Eof()
	dbSelectArea('SB7')
	// se nao encontrar, entao devo incluir
	If ! dbSeek(xFilial('SB7')+Dtos(MV_PAR01)+SB8TMP->B8_PRODUTO+SB8TMP->B8_LOCAL+Space(Len(SB7->B7_LOCALIZ))+Space(Len(SB7->B7_NUMSERI))+SB8TMP->B8_LOTECTL)
		If RecLock('SB7', .t.)
			SB7->B7_FILIAL    := xFilial('SB7')
			SB7->B7_COD       := SB8TMP->B8_PRODUTO
			SB7->B7_LOCAL     := SB8TMP->B8_LOCAL
			SB7->B7_TIPO      := SB1->B1_TIPO
			SB7->B7_DOC       := Alltrim(MV_PAR02)
			SB7->B7_QUANT     := 0
			SB7->B7_DATA      := MV_PAR01
			SB7->B7_LOTECTL   := SB8TMP->B8_LOTECTL
			SB7->B7_DTVALID   := SB8TMP->B8_DTVALID
		EndIf
		MsUnLock()
	EndIf

    IncProc()
	dbSelectArea('SB8TMP')
	dbSkip()
EndDo

dbSelectArea('SB8TMP')
dbCloseArea()

Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidPerg( cPerg )
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)

//          Grupo/Ordem/Pergunta/                   Variavel/Tipo/Tam/Dec/Pres/GSC/Valid/             Var01/     Def01______/Cnt01/  Var02 /Def02_____/Cnt02/ Var03/Def03___/Cnt03/ Var04/Def04___/Cnt04/ Var05/Def05___/Cnt05/ F3
aAdd(aRegs,{cPerg,"01","Data Inventario  ","","",    "mv_ch1","D",  8,  0, 0,  "G", "",               "MV_PAR01", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"02","Documento:       ","","",    "mv_ch2","C",  6,  0, 0,  "G", "",               "MV_PAR02", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"03","Local de:        ","","",    "mv_ch3","C",  2,  0, 0,  "G", "",               "MV_PAR03", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"04","Local ate:       ","","",    "mv_ch4","C",  2,  0, 0,  "G", "",               "MV_PAR04", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"05","Grupo Produto de ","","",    "mv_ch5","C",  4,  0, 0,  "G", "",               "MV_PAR05", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"06","Grupo Produto ate","","",    "mv_ch6","C",  4,  0, 0,  "G", "",               "MV_PAR06", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"07","Produto de       ","","",    "mv_ch7","C", 15,  0, 0,  "G", "",               "MV_PAR07", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"08","Produto ate      ","","",    "mv_ch8","C", 15,  0, 0,  "G", "",               "MV_PAR08", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})

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
