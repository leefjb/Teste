#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³JMHR120   ºAutor  ³Marcelo Tarasconi   º Data ³  26/01/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rel para demonstrar status dos itens do pedido de venda     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP 10                                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JMHR120()


DbSelectArea("SX1")
DBSETORDER(1)
IF !DBSEEK("JMR120")
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := "JMR120"
	SX1->X1_ORDEM    := "01"
	SX1->X1_PERGUNTA := "Do Pedido ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 06
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR01"
	SX1->X1_VARIAVL  := "mv_ch1"
	MsUnlock()
EndIf
IF !DBSEEK("JMR12002")
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := "JMR120"
	SX1->X1_ORDEM    := "02"
	SX1->X1_PERGUNTA := "Ate Pedido ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 06
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR02"
	SX1->X1_VARIAVL  := "mv_ch2"
	MsUnlock()
EndIf
IF !DBSEEK("JMR12003")
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := "JMR120"
	SX1->X1_ORDEM    := "03"
	SX1->X1_PERGUNTA := "De Emissao ?"
	SX1->X1_TIPO     := "D"
	SX1->X1_TAMANHO  := 08
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR03"
	SX1->X1_VARIAVL  := "mv_ch3"
	MsUnlock()
EndIf
IF !DBSEEK("JMR12004")
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := "JMR120"
	SX1->X1_ORDEM    := "04"
	SX1->X1_PERGUNTA := "Ate Emissao ?"
	SX1->X1_TIPO     := "D"
	SX1->X1_TAMANHO  := 08
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR04"
	SX1->X1_VARIAVL  := "mv_ch4"
	MsUnlock()
EndIf
IF !DBSEEK("JMR12005")
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := "JMR120"
	SX1->X1_ORDEM    := "05"
	SX1->X1_PERGUNTA := "Do Cliente ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 06
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR05"
	SX1->X1_VARIAVL  := "mv_ch5"
	SX1->X1_F3       := "SA1"
	MsUnlock()
EndIf
IF !DBSEEK("JMR12006")
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := "JMR120"
	SX1->X1_ORDEM    := "06"
	SX1->X1_PERGUNTA := "Ate Cliente ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 06
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR06"
	SX1->X1_VARIAVL  := "mv_ch6"
	SX1->X1_F3       := "SA1"
	MsUnlock()
EndIf




cString  := "SA1"
cDesc1   := OemToAnsi("Este programa tem como objetivo, Emitir o Status dos itens dos pedido de venda")
cDesc2   := ""
cDesc3   := ""
Private tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
Private nomeprog := "JMHR120"
Private aOrdem := {'Emissao','Num.Pedido'}

wnrel    := "JMHR120"      //Nome Default do relatorio em Disco
cPerg    := "JMR120"
nLastKey := 0
Private titulo   := "Status dos Itens do Pedido de Vendas"
cCancel  := "***** CANCELADO PELO OPERADOR *****"
nLastKey := 0
nLin     := 80

//                0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                          1         2         3         4         5         6         7         8         9         0         1         2
//                99 99 999999 XXXXXXXXXXXXXXXXXXXXXXXXX  999.999,99  999.999,99  xxx  xxxxxxxxxxxxxxxxxxxx  99 99 99
Private Cabec1 :=    'It Sq Prod.  Descricao                        Qtd.        Prc.  TES  Status                Data Fat.'
Private Cabec2 :=    ''
Private m_pag       := 01

Pergunte("JMR120",.F.)

dbSelectArea('SA1')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,,tamanho,,.F.)

If LastKey()==  27 .or. nLastKey ==  27
	Set Filter to
	return
endif

SetDefault(aReturn,cString)

// Se for pressionado Esc aborta o programa.
if LastKey() ==  27 .or. nLastKey ==  27
	Set Filter To
	return
endif

RptStatus({|| Processa(RptDetail()) })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em Disco, chama Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera relatorio para Spool da Rede                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MS_FLUSH()

Return

****************************************************************************************
Static Function RptDetail

Private nLin := 80
Private aList := {}
Private cQuery := ''

cQuery := "SELECT * FROM " + RetSqlName("SC5") + " SC5 "
cQuery += "WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND "
cQuery += "SC5.C5_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "SC5.C5_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+ "' AND "
cQuery += "SC5.C5_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
cQuery += "SC5.D_E_L_E_T_ <> '*' "

If aReturn[ 8 ] == 1 //emissao

	cQuery += " ORDER BY SC5.C5_FILIAL,SC5.C5_EMISSAO, SC5.C5_NUM"
Else
	cQuery += " ORDER BY SC5.C5_FILIAL,SC5.C5_NUM"
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'TRB', .F., .T.)

TRB->(dbGoTop())

While !EOF()
    
	DbSelectArea("SC5")
	DbSetOrder(1)
	dbSeek(xFilial("SC5")+TRB->C5_NUM,.T.)
		
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aList := {}
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,18)
			nLin := 9
			
		Endif
		
		@ nLin  , 000 PSAY 'Pedido N.: ' + SC5->C5_NUM
		@ nLin  , 025 PSAY 'Emissao : ' + dtoc(SC5->C5_EMISSAO)
		@ nLin  , 055 PSAY 'Cliente : ' + '('+Alltrim(SC5->C5_CLIENTE) + '-' + SC5->C5_LOJACLI + ') ' + Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
        If !Empty(SC5->C5_MSGINT)
			nLin++
			@ nLin  , 000 PSAY 'Mensagem Interna: ' + SC5->C5_MSGINT		
			nLin++
			nLin++
		Else
			nLin++
			nLin++
        EndIf
		@ nLin  , 000 PSAY ''
		
		dbSelectArea('SC6')
		dbSetOrder(1)
		If dbSeek(xFilial('SC6')+SC5->C5_NUM,.f.)
			cChave := SC6->C6_FILIAL + SC6->C6_NUM
			While !EOF() .and. cChave == xFilial('SC6') + SC6->C6_NUM
				
				//Chama rotina que irá retornar a linha e o Status, nesse fonte ele pode inclusive abrir várias linhas, de acordo com o SC9
				aRet := u_JmhF050(SC6->C6_NUM, SC6->C6_ITEM)
				
				For i:=1 to Len(aRet)
					
					aAdd( aList, { aRet[i][1], aRet[i][2], aRet[i][3], aRet[i][4], aRet[i][5], aRet[i][6],  aRet[i][7], aRet[i][8], aRet[i][9] } )
					
				Next i
				
				dbSelectArea('SC6')
				dbSkip()
			End
		EndIf
		
		
		If Len(aList) > 0
			For i:=1 to Len(aList)
				@ nLin, 000 PSAY aList[i][1] //item
				@ nLin, 003 PSAY aList[i][2] //sequen
				@ nLin, 006 PSAY Left(aList[i][3],6) //PRODUTO
				@ nLin, 013 PSAY Left(aList[i][4],25) //descri
				@ nLin, 040 PSAY aList[i][5] Picture "@E 999,999.99" //qtd ven
				@ nLin, 052 PSAY aList[i][6] Picture "@E 999,999.99" //preco
				@ nLin, 064 PSAY aList[i][7] //tes
				@ nLin, 069 PSAY aList[i][8] //
				@ nLin, 091 PSAY aList[i][9]
				nLin++
	
	
				If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
					
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,18)
					nLin := 9
					
				Endif
	
			Next
		EndIf
		
		@ nLin,00 Psay __PrtFatLine()
		nLin++
		

dbSelectArea('TRB')
dbSkip()
end

TRB->(dbCloseArea())
	
Return
