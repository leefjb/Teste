#Include "protheus.ch"
#include "sigawin.ch"


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � JMHEST01  � Autor � Reiner Trennepohl  � Data � 02.05.02   ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Relatorio de Controle de Materiais nossos em poder de 3os  .���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � JMHEST01(void)                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Eliane    �  27.04.07         Inclusao de parametro Local Estoque e Tes���
�������������������������������������������������������������������������Ĵ��
���Manutencao� Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function JMHEST01()
LOCAL wnrel
LOCAL Tamanho  := "G"
LOCAL cDesc1   := "Este programa ira emitir o Relatorio de Materiais"
LOCAL cDesc2   := " nossos em poder de Terceiros."
LOCAL cDesc3   := ""
LOCAL cString  := "SB6"
PRIVATE cCondCli
PRIVATE aReturn  := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
PRIVATE nomeprog := "JMHEST01"
PRIVATE aLinha   := { }, nLastKey := 0
PRIVATE Titulo   := "Relacao de materiais em Terceiros"
PRIVATE cabec1, cabec2, nTipo, CbTxt, CbCont
PRIVATE cPerg    := PadR("JEST01",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

//�����������������������������������������������������������������������������Ŀ
//� Utiliza variaveis static p/ Grupo de Fornec/Clientes(001) e de Loja(002)    �
//�������������������������������������������������������������������������������
//Private aTamSXG, aTamSXG2

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
CbTxt   := SPACE(10)
CbCont  := 00
li	    := 80
m_pag   := 01

//�������������������������������������������������������������������������������Ŀ
//� Verifica conteudo da variavel p/ Grupo de Clientes/Forneced.(001) e Loja(002) �
//���������������������������������������������������������������������������������
//aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
//aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
AjustaSX1()
pergunte(cPerg,.F.)
//�����������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                  �
//� mv_par01   	     // Cliente Inicial                		              �
//� mv_par02         // Cliente Final                       	          �
//� mv_par03         // Produto Inicial                              	  �
//� mv_par04         // Produto Final                         		      �
//� mv_par05         // Data Inicial                              	      �
//� mv_par06         // Data Final                                   	  �
//� mv_par07         // Situacao   (Todos / Em aberto)                    �  
//� mv_par08         //                                                   �
//� mv_par09         //                                                   �
//� mv_par10         //                                                   �
//� mv_par11         //                                                   �
//� mv_par12         // Salta Pagina                                      �
//� mv_par13         // Loja Inicial                                      �
//� mv_par14         // Loja Final                                        �
//� mv_par15         // Local Inicial                                 	  �
//� mv_par16         // Local Final                                       �
//� mv_par17         // Tes Inicial                                  	  �
//� mv_par18         // Tes Final                                         �
//�������������������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Define variaveis p/ filtrar arquivo.                         �
//����������������������������������������������������������������
cCondCli := " B6_CLIFOR <= mv_par02 .And. B6_CLIFOR >= mv_par01 .And. "+;
" B6_PRODUTO <= mv_par04 .And. B6_PRODUTO >= mv_par03 .And. "+;
" B6_DTDIGIT <= mv_par06 .And. B6_DTDIGIT >= mv_par05 .And. "+;
" B6_LOCAL <= mv_par09 .And. B6_LOCAL >= mv_par08 .and. B6_LOJA >= mv_par13 .and. "+;
" B6_LOJA <= mv_par14 .and. B6_LOCAL>= mv_par15 .and. B6_LOCAL <= mv_par16 .and.  "+;
" B6_TES >= mv_par17 .and. B6_TES <= mv_par18"
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SetPrint                        �
//����������������������������������������������������������������
wnrel := "JMHEST01"

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho)

If nLastKey == 27
	Return .T.
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return .T.
Endif

RptStatus({|lEnd| R480Imp(@lEnd,wnRel,cString,Tamanho)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R480IMP  � Autor � Reiner Trennepohl     � Data � 02.05.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � JMHEST01			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R480Imp(lEnd,WnRel,cString,Tamanho)
LOCAL limite := 220
nTipo:=IIF(aReturn[4]==1,15,18)

dbSelectArea("SB6")

R480CliFor(lEnd,Tamanho)

dbSelectArea("SB6")
Set Filter To
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .t.

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � R480CliFor� Autor � Reiner Trennepohl  � Data � 05.05.02    ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Imprime Por Ordem de Cliente / Fornecedor.                  ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � JMHEST01                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function R480CliFor(lEnd,Tamanho)
LOCAL cQuebra,aCliPrd:={}
LOCAL cIndex, cKey, nIndex, cCodCliFor := "", cDescCliFor := ""
LOCAL cVar,cFilter
LOCAL nPrcStd:=nPrcVnd:=nSaldo:=nX:=0
LOCAL nGerTotV:=nGerTotS:=nValPrcVd:=nValPrcVd:=0
LOCAL nRecSB6:=nQuant:=nQuJe:=0
LOCAL dDtUlEnt

dbSelectArea("SB1")
dbSetOrder(1)

//��������������������������������������������������������������Ŀ
//� Cria arquivo de trabalho usando indice condicional.          �
//����������������������������������������������������������������
dbSelectArea("SB6")
cIndex  := CriaTrab(NIL,.F.)
cKey    := 'B6_FILIAL+B6_TPCF+B6_CLIFOR+B6_LOJA+B6_PRODUTO'
cFilter := SB6->(DbFilter())
If Empty( cFilter )
	cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'"'
Else
	cFilter := cFilter+' .And. (B6_FILIAL == "'+xFilial('SB6')+'")'
EndIf
IndRegua("SB6",cIndex,cKey,,cFilter," Criando Indice ...    ")
nIndex := RetIndex("SB6")
#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
dbSeek(xFilial("SB6")+"C")

titulo := "RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - CLIENTE / PRODUTO"

cabec1 := "--------------------- Produto ----------------------------------------------------    Unid. de   ------------------- Quantidade --------------------    --------------- Valores ------------------      Data da Ultima"
cabec2 := "Codigo                Descricao                                                        Medida          Enviada        Devolvida                Saldo            Custo Medio         Preco de Venda          Entrega"
//         XXXXXXXXXXXXXXX       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       XX       99.999.999,99     99.999.999,99      99.999.999,99      99.999.999.999,99      99.999.999.999,99         99/99/99
//           1         2         3         4         5         6         7         8         9         C         1         2         3         4         5         6         7         8         9         D       & 1         2
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

SetRegua(LastRec())

Do While !Eof()
	
	IncRegua()
	
	If lEnd
		@Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IF	!&cCondCli
		dbSkip()   // ;IncRegua()
		Loop
	Endif
	
	If B6_TPCF != "C" .Or. B6_TIPO == "D"
		dbSkip()  // ;IncRegua()
		Loop
	EndIf
	
	dbSelectArea("SB6")
	
	cQuebra	 := B6_CLIFOR+B6_LOJA
	nTCliVnd := 0
	nTCliStd := 0
	
	Do While B6_CLIFOR+B6_LOJA == cQuebra
		
		IF !&cCondCli
			dbSkip()
			IncRegua()
			Loop
		EndIf
		
		nRecSB6  := RecNo()
		dData    := CToD("  /  /  ")
		nSaldo   := 0
		nQuant	:= 0
		nQuJe	:= 0
		dDtUlEnt := B6_UENT
		cCodPrd  := B6_PRODUTO
		cQuebra1 := B6_CLIFOR+B6_LOJA+B6_PRODUTO
		
		nPos := aScan(aCliPrd,{|x| x[1] == cQuebra1})
		
		If nPos == 0
			aAdd(aCliPrd, { cQuebra1, nQuant, nQuJe,  nSaldo, dData, .F. } )
			nPos := Len(aCliPrd)
		EndIf
		
		Do While B6_CLIFOR+B6_LOJA+B6_PRODUTO == cQuebra1
			
			IF !&cCondCli
				dbSkip()
				IncRegua()
				Loop
			EndIf
			
			If B6_PODER3 == "D"
				// Quantidade Ja Entregue
				nQuJe += B6_QUANT
			Else
				nQuant += B6_QUANT
			EndIf
			
			If B6_SALDO > 0
				nSaldo += B6_SALDO
			EndIf
			
			IF B6_UENT > dDtUlEnt
				dDtUlEnt := B6_UENT
			ENDIF
			
			dbSkip();IncRegua()
			nRecSB6 := RecNo()
		EndDo
		
		aCliPrd[nPos, 2] += nQuant
		aCliPrd[nPos, 3] += nQuje
		aCliPrd[nPos, 4] += nSaldo
		aCliPrd[nPos, 5] := dDtUlEnt
		
		If nSaldo > 0
			nPos := aScan( aCliPrd, { |x| SubStr(x[1],1,8) == cQuebra } )
			If !aCliPrd[nPos, 6]
				aCliPrd[nPos, 6] := .T.
			EndIf
		EndIf
	EndDo
EndDo

If Len(aCliPrd) > 0
	
	aCliPrd := aSort( aCliPrd,,,{ |x, y| x[1] < y[1] } )
	
	For nX := 1 To Len(aCliPrd)
		
		If li > 55
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
		EndIf
		
		If cCodCliFor != SubStr(aCliPrd[nX,1],1,8)
			
			If nTCliVnd > 0   // Total Cliente
				li++
				If li > 55
					Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
				EndIf
				@ li,000 PSay "Total do Cliente "
				If MV_PAR10 = 1
					@ li,154 PSay Transform(nTCliStd,'@E 99,999,999,999.99')
				EndIf
				If MV_PAR11 = 1
					@ li,177 PSay Transform(nTCliVnd,'@E 99,999,999,999.99')
				EndIf
				li++
				nTCliVnd := 0
				nTCliStd := 0
			Endif
			
			/*
			If !aCliPrd[nX,6] .And. mv_par07 == 2   // Se nao Verdadeiro(!.T.), cliente s/saldo
													// e (mv_par07 == 2), so os em aberto
				cCodCliFor := SubStr(aCliPrd[nX,1],1,8)
				Do While nX <= Len(aCliPrd) .And. cCodCliFor == SubStr(aCliPrd[nX,1],1,8)
					nX += 1
				EndDo
				Loop
			EndIf
			*/
			
			// quebra pagina por cliente
			If MV_PAR12 = 1
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
			EndIf
          
			dbSelectArea("SA1")
			dbSeek(cFilial+SubStr(aCliPrd[nX,1],1,8))
			If Found()
				If !Empty(cDescCliFor)
					li++
				EndIf  
				
				cDescCliFor := "CLIENTE / LOJA: "
				@ li,000 PSay cDescCliFor+A1_COD+" - "+TRIM(A1_NOME)+" / "+A1_LOJA
				cCodCliFor := SubStr(aCliPrd[nX,1],1,8)
			Else
				cDescCliFor := "CLIENTE / LOJA: "
				@ li,000 PSay cDescCliFor+SubStr(aCliPrd[nX,1],1,6)+" - Nao Localizado no Cadastro / "+SubStr(aCliPrd[nX,1],7,2)
				cCodCliFor := SubStr(aCliPrd[nX,1],1,8)
			EndIf
		  
		EndIf
		// verificar os controles de linha <li>
		If mv_par07 == 2  .And. aCliPrd[nX,4] > 0  // So em aberto e Saldo > 0
			
			dbSelectArea("SB1")
			dbSeek(cFilial+SubStr(aCliPrd[nX,1],9))
			
			dbSelectArea("SB2")
			dbSeek(cFilial+SubStr(aCliPrd[nX,1],9)+SB1->B1_LOCPAD)
			
			// Valores em Preco Standard e Preco Venda
			If aCliPrd[nX,4] >  0
				nTCliVnd += (aCliPrd[nX,4] * SB1->B1_PRV1)
				nTCliStd += (aCliPrd[nX,4] * SB2->B2_CM1)
				nGerTotV += (aCliPrd[nX,4] * SB1->B1_PRV1)
				nGerTotS += (aCliPrd[nX,4] * SB2->B2_CM1)
			EndIf
			
			li++
			@ li,000 PSay SubStr(aCliPrd[nX,1],9)
			@ li,022 PSay Substr(SB1->B1_DESC,1,60)
			@ li,089 PSay SB1->B1_UM
			@ li,098 PSay aCliPrd[nX,2] Picture PesqPict("SB6", "B6_QUANT",11)
			@ li,116 PSay aCliPrd[nX,3] Picture PesqPict("SB6", "B6_QUANT",11)
			//@ li,135 PSay aCliPrd[nX,2]-aCliPrd[nX,3] Picture PesqPict("SB6", "B6_QUANT",11)
			@ li,135 PSay aCliPrd[nX,4] Picture PesqPict("SB6", "B6_QUANT",11)
			If MV_PAR10 = 1
				@ li,154 PSay Transform(aCliPrd[nX,4] * SB2->B2_CM1, '@E 99,999,999,999.99')
			EndIf
			If MV_PAR11 = 1
				@ li,177 PSay Transform(aCliPrd[nX,4] * SB1->B1_PRV1, '@E 99,999,999,999.99')
			EndIf
			@ li,203 PSay aCliPrd[nX,5]
		EndIf
		
	Next
	
EndIf

If nGerTotV > 0
	li++
	@ li,000 PSay "T O T A L    G E R A L  ---------- >"
	If MV_PAR10 = 1
		@ li,154 PSay Transform(nGerTotS,'@E 99,999,999,999.99')
	EndIf
	If MV_PAR11 = 1
		@ li,177 PSay Transform(nGerTotV,'@E 99,999,999,999.99')
	EndIf
	Roda(CbCont,CbTxt,Tamanho)
Endif

//��������������������������������������������������������������Ŀ
//� Devolve condicao original ao SB6 e apaga arquivo de trabalho.�
//����������������������������������������������������������������
RetIndex("SB6")
dbSelectArea("SB6")
dbSetOrder(1)
cIndex += OrdBagExt()
Ferase(cIndex)

Return .T.



/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AjustaSX1 � Autor �Reiner Trennepohl      � Data � 02.05.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta Grupo de Perguntas                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function AjustaSX1()
Local aArea:=GetArea()
Local i:=0,j:=0
Local aRegistros:={}


Aadd(aRegistros, {cPerg, "01", "Cliente Inicial   ?", ".", ".", "mv_ch1", "C", 6, 0, 0, "G", "", "mv_par01", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1", ""})
Aadd(aRegistros, {cPerg, "02", "Cliente Final     ?", ".", ".", "mv_ch2", "C", 6, 0, 0, "G", "", "mv_par02", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1", ""})
Aadd(aRegistros, {cPerg, "03", "Produto Inicial   ?", ".", ".", "mv_ch3", "C",15, 0, 0, "G", "", "mv_par03", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", ""})
Aadd(aRegistros, {cPerg, "04", "Produto Final     ?", ".", ".", "mv_ch4", "C",15, 0, 0, "G", "", "mv_par04", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", ""})
Aadd(aRegistros, {cPerg, "05", "Data Inicial      ?", ".", ".", "mv_ch5", "D", 8, 0, 0, "G", "", "mv_par05", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",    ""})
Aadd(aRegistros, {cPerg, "06", "Data Final        ?", ".", ".", "mv_ch6", "D", 8, 0, 0, "G", "", "mv_par06", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 	  ""})
Aadd(aRegistros, {cPerg, "07", "Situacao          ?", ".", ".", "mv_ch7", "N", 1, 0, 1, "C", "", "mv_par07", "Todos", "", "", "",            "", "Em aberto",   "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",    ""})
Aadd(aRegistros, {cPerg, "08", "Local Inicial     ?", ".", ".", "mv_ch8", "C", 2, 0, 0, "G", "", "mv_par08", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",    ""})
Aadd(aRegistros, {cPerg, "09", "Local Final       ?", ".", ".", "mv_ch9", "C", 2, 0, 0, "G", "", "mv_par09", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",    ""})
Aadd(aRegistros, {cPerg, "10", "Com Valor de Custo?", ".", ".", "mv_cha", "N", 1, 0, 1, "C", "", "mv_par10", "Sim",   "", "", "",            "", "Nao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",    ""})
Aadd(aRegistros, {cPerg, "11", "Com Valor de Venda?", ".", ".", "mv_chb", "N", 1, 0, 1, "C", "", "mv_par11", "Sim",   "", "", "",            "", "Nao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",    ""})
Aadd(aRegistros, {cPerg, "12", "Salta Pagina Cliente?", ".", ".", "mv_chc", "N", 1, 0, 1, "C", "", "mv_par12", "Sim",   "", "", "",            "", "Nao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",    ""})
Aadd(aRegistros, {cPerg, "13", "Loja Cliente de   ?", ".", ".", "mv_chd", "C", 2, 0, 0, "G", "", "mv_par13", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
Aadd(aRegistros, {cPerg, "14", "Loja Cliente ate  ?", ".", ".", "mv_che", "C", 2, 0, 0, "G", "", "mv_par14", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
Aadd(aRegistros, {cPerg, "15", "Local de          ?", ".", ".", "mv_chf", "C", 2, 0, 0, "G", "", "mv_par15", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
Aadd(aRegistros, {cPerg, "16", "Local Ate         ?", ".", ".", "mv_chg", "C", 2, 0, 0, "G", "", "mv_par16", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
Aadd(aRegistros, {cPerg, "17", "Tes de            ?", ".", ".", "mv_chh", "C", 3, 0, 0, "G", "", "mv_par17", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
Aadd(aRegistros, {cPerg, "18", "Tes Ate           ?", ".", ".", "mv_chi", "C", 3, 0, 0, "G", "", "mv_par18", "",      "", "", "", 			"", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

dbSelectArea("SX1")
For i:=1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aRegistros[i])
			FieldPut(j,aRegistros[i,j])
		Next j
		MsUnlock()
	EndIf
Next i
RestArea(aArea)

Return(nil)
