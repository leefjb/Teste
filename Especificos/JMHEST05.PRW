#INCLUDE "protheus.ch"
#include "sigawin.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JMHEST05 ³ Autor ³ Reiner Trennepohl     ³ Data ³ 13/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta Geral ao Produto                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutencao³ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION JMHEST05
LOCAL aAlias:={},cSavRegua
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de baixas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aRotina := { { "Pesquisar","AxPesqui",         0 , 1},;		
                     { "Cons. Geral", "U_JMHEST51", 0 , 2},;
                     { "Cons. Direta","U_JMHEST50", 0 , 3} }	

//-- Defini‡„o de SET CENTURY
Private lCentury := __SetCentury()
Private cPerg := PadR("JEST05",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

cCadastro := OemToAnsi("Consulta Geral ao Produto")	//"Consulta Geral ao Produto"

//JAjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa tecla F12 para acessar os parametros                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey( VK_F12, { || pergunte(cPerg,.T.) } )      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01        // Cons Saldo Em/De 3o.?                     ³
//³ MV_PAR02        // Considerar Parametros Abaixo              ³
//³ MV_PAR03        // Data inicial                              ³
//³ MV_PAR04        // Data final                                ³
//³ MV_PAR05        // Apresenta Movimentos                      ³
//³ MV_PAR06        // Lista as Amarracoes ?                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse( 6, 1,22,75,"SB1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desativa tecla F12                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F12	To

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Ordem Original do arquivo principal               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados e posiciona os arquivos uti-³
//³ lizados na Ordem 1                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAlias:={"SB1","SB5","SA5","SAD","SA7","SC1","SC7","SD4","SC6","SF1","SF2","SC2",;
"SD1","SF4","SD2","SD3","SB6","SB3","SB9","SB2"}

For i:=1 to Len(aAlias)
	dbSelectArea(aAlias[i])
	dbSetOrder(1)
Next i

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JMHEST51 ³ Autor ³ Reiner Trennepohl ³ Data ³  13/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia para funcao que monta o arquivo de trabalho com as   ³±±
±±³          ³ movimentacoes e mostra-o na tela                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST05                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JMHEST51
LOCAL aCampos := {} ,nCusMed := 0 ,cSalIni := "", nPos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"LINHA","C",120,0 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := CriaTrab(aCampos)
USE &cNomArq Alias SB1TRB ExClusive NEW VIA __LocalDriver

//dbUseArea( .T.,, cNomArq, "SB1TRB", if(.F. .OR. .F., !.F., NIL), .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava as movimentacoes no arquivo de trabalho                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !NetErr() //File(cNomArq+".dbf")
	If !JEST05Monta()
		HELP(" ",1,"ERRO")
		Return
	Endif
	
	dbSelectArea("SB1TRB")
	If RecCount() > 0
		JW05Brows("SB1TRB")
	Else
		Help("",1,"MC050NOREC")
	Endif
	
	dbSelectArea("SB1TRB")
	dbCloseArea()
	FERASE(cNomArq+".dbf")
Else
	Help("",1,"MC050NOARQ")
Endif

dbSelectArea("SB1")
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³JC05TRB  ³ Autor ³ Reiner Trennepohl  ³ Data ³  13/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava registro no arquivo de Trabalho                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function JC05TRB(cVar,cAlias)
cVar := StrTran(cVar,Chr(179)," ")
cVar := StrTran(cVar,Chr(191)," ")
cVar := StrTran(cVar,Chr(192)," ")
cVar := StrTran(cVar,Chr(196)," ")
cVar := StrTran(cVar,Chr(217)," ")
cVar := StrTran(cVar,Chr(218)," ")

dbSelectArea("SB1TRB")
RecLock("SB1TRB",.T.)
Replace LINHA with OemToAnsi(cVar)
MsUnLock()

dbSelectArea(cAlias)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³JMC05BUSCA³ Autor ³ Reiner Trennepohl  ³ Data ³  13/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Busca o Titulo de Apresentacao no Dicionario               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ aExpr:=JMC05BUSCA(aExpr,cExpr1)                            ³±±
±±³          ³ aExpr:=array com os campos do arquivo a apresentar         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function JMC05BUSCA(aEstru,cArq)
LOCAL cAlias := Alias(),n

dbSelectArea("SX3")
dbSeek(cArq)
Do While !Eof() .and. X3_ARQUIVO==cArq
	For n:=1 to Len(aEstru)
		If AllTrim(X3_CAMPO) == aEstru[n][1]
			aEstru[n][2] := X3Titulo()
			aEstru[n][3] := X3_TAMANHO+X3_DECIMAL+1
			aEstru[n][4] := X3_PICTURE
			aEstru[n][5] := X3_TIPO
			Exit
		ElseIf aEstru[n][1] == "ESPACO"
			LOOP
		Endif
	Next n
	dbSkip()
EndDo

dbSelectArea(cAlias)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³JEST05Monta³ Autor ³ Reiner Trennepohl  ³ Data ³  13/08/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava arquivo de trabalho                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function JEST05Monta
Local nTamanho:=IF(cPaisLoc == "BRA",72,78)	//Tamanho variavel por causa da NF
Local cString,lTudoOk:=.T.,cFimBloc:=CHR(192)+Repli(CHR(196),(nTamanho-2))+CHR(217),n
Local cBrancBloc:="³"+Repli(" ",(nTamanho-2))+"³",lFirst,nTotLocal,nTotGeral,nSaldoINi
Local dDataFim,aTotGeral := {0,0,0,0,0,0},cTam, nSaldo:= 0, aSaldoTer
Local nString, nTaxa, nMoeda
Local nDecSB2:=TamSX3("B2_QATU")[2]
Local nSpace := If(lCentury,2,0)
Local nFrete := 0
Local nDesp  := 0
Local aTamSXG1:=TamSXG("001"), aTamSXG2:=TamSXG("002"), cCliFor, cLoja, lSXG1Max:=.F., lSXG2Max:=.F.
Local cAliasTop, lQuery  

Private aEstru,aSaldo,aMRP:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar SXG ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aTamSXG1[1] != aTamSXG1[3]
	lSXG1Max := .T.
EndIf
If aTamSXG2[1] != aTamSXG2[3]
	lSXG2Max := .T.
EndIf

//---------- Dados Cadastrais do Produto (SB1)
If MV_PAR02 == 2
	
	cString:=" Dados Produto "
	JC05TRB(CHR(218)+cString+Repli(CHR(196),((nTamanho-2)-Len(cString)))+CHR(191),Alias())
	JC05TRB("³"+Space((nTamanho-2))+"³")
	
	dbSelectArea("SB1")
	aEstru := {}
	AADD(aEstru,{"B1_COD"   ,"",0,"",""})
	AADD(aEstru,{"B1_DESC"  ,"",0,"",""})
	AADD(aEstru,{"B1_PRV1"  ,"",0,"",""})
	
	JMC05BUSCA(aEstru,Alias())
	
	cString:="³"
	For n:=1 to Len(aEstru)
		If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
			cPicture	 := aEstru[n][4]
			cConteudo := aEstru[n][1]
			If aEstru[n][5] $ "ND"
				cConteudo := Transform(&cConteudo,cPicture)
			ElseIf aEstru[n][5]=="C"
				cConteudo := &cConteudo
			Endif
			cString   += Alltrim(aEstru[n][2])+": "+cConteudo+"³"
		Else
			cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
			
			JC05TRB(cString,Alias())
			
			cString:="³"
			cPicture	 := aEstru[n][4]
			cConteudo := aEstru[n][1]
			If aEstru[n][5] $ "ND"
				cConteudo := Transform(&cConteudo,cPicture)
			ElseIf aEstru[n][5]=="C"
				cConteudo := &cConteudo
			Endif
			If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
				cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
			Else
				nString   := Len(cString) + Len(Alltrim(aEstru[n][2])) + 2
				cString   += Alltrim(aEstru[n][2])+": "+Substr(cConteudo,1,(nTamanho-2)-nString)+" ³"
			EndIf
		EndIf
	Next n
	
	If Len(cString) > 1
		cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
		
		JC05TRB(cString,Alias())
		
	EndIf
Else
	
	cString:=" Dados Gerais do Produto "
	JC05TRB(CHR(218)+cString+Repli(CHR(196),((nTamanho-2)-Len(cString)))+CHR(191),Alias())
	JC05TRB("³"+Space((nTamanho-2))+"³")
	dbSelectArea("SB1")
	aEstru := {}
	AADD(aEstru,{"B1_COD"   ,"",0,"",""})
	AADD(aEstru,{"B1_TIPO"  ,"",0,"",""})
	AADD(aEstru,{"B1_DESC"  ,"",0,"",""})
	AADD(aEstru,{"B1_UM"    ,"",0,"",""})
	AADD(aEstru,{"B1_GRUPO" ,"",0,"",""})
	AADD(aEstru,{"B1_LOCPAD","",0,"",""})
	AADD(aEstru,{"B1_PRV1"  ,"",0,"",""})
	
	JMC05BUSCA(aEstru,Alias())
	
	cString:="³"
	For n:=1 to Len(aEstru)
		If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
			cPicture	 := aEstru[n][4]
			cConteudo := aEstru[n][1]
			If aEstru[n][5] $ "ND"
				cConteudo := Transform(&cConteudo,cPicture)
			ElseIf aEstru[n][5]=="C"
				cConteudo := &cConteudo
			Endif
			cString   += Alltrim(aEstru[n][2])+": "+cConteudo+"³"
		Else
			cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
			
			JC05TRB(cString,Alias())
			
			cString:="³"
			cPicture	 := aEstru[n][4]
			cConteudo := aEstru[n][1]
			If aEstru[n][5] $ "ND"
				cConteudo := Transform(&cConteudo,cPicture)
			ElseIf aEstru[n][5]=="C"
				cConteudo := &cConteudo
			Endif
			If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
				cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
			Else
				nString   := Len(cString) + Len(Alltrim(aEstru[n][2])) + 2
				cString   += Alltrim(aEstru[n][2])+": "+Substr(cConteudo,1,(nTamanho-2)-nString)+" ³"
			EndIf
		EndIf
	Next n
	If Len(cString) > 1
		cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
		JC05TRB(cString,Alias())
	Endif
	
	cString:=""
	
	//----------- Dados Adicionais do Produto (SB5)
	
	dbSelectArea("SB5")
	dbSetOrder(1)
	dbSeek(xFilial("SB5")+SB1->B1_COD)
	If Found()
		aEstru := {}
		AADD(aEstru,{"B5_CEME"   ,"",0,"",""})
		JMC05BUSCA(aEstru,Alias())
		cString:="³"
		For n:=1 to Len(aEstru)
			cConteudo := aEstru[n][1]
			cConteudo := &cConteudo
			cString   += Alltrim(aEstru[n][2])+": "+Subs(Alltrim(cConteudo),1,50)+" "
			cString   += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
			JC05TRB(cString,Alias())
		Next n
	Endif
	JC05TRB(cFimBloc,Alias())
	
	//----------- Amarracao Produto X Fornecedor (SA5)
	dbSelectArea("SA5")
	dbSetOrder(2)
	dbSeek(cFilial+SB1->B1_COD)
	If Found() .And. MV_PAR06 == 1
		cString:=" Amarracao Produto X Fornecedor " 	//" Amarracao Produto X Fornecedor "
		JC05TRB(CHR(218)+cString+Repli(CHR(196),((nTamanho-2)-Len(cString)))+CHR(191),Alias())
		cString:=""
		aEstru := {}
		AADD(aEstru,{"A5_FORNECE"   ,"",0,"",""})
		AADD(aEstru,{"A5_LOJA"      ,"",0,"",""})
		AADD(aEstru,{"A5_NOMEFOR"   ,"",0,"",""})
		AADD(aEstru,{"A5_NOMPROD"   ,"",0,"",""})
		AADD(aEstru,{"A5_CODPRF"    ,"",0,"",""})
		JMC05BUSCA(aEstru,Alias())
		
		While !Eof() .and. A5_FILIAL+A5_PRODUTO == cFilial+SB1->B1_COD
			cString:="³"
			For n:=1 to Len(aEstru)
				If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
					cPicture	 := aEstru[n][4]
					cConteudo := aEstru[n][1]
					If aEstru[n][5] $ "ND"
						cConteudo := Transform(&cConteudo,cPicture)
					ElseIf aEstru[n][5]=="C"
						cConteudo := &cConteudo
					Endif
					cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
				Else
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					JC05TRB(cString,Alias())
					cString:="³"
					cPicture	 := aEstru[n][4]
					cConteudo := aEstru[n][1]
					If aEstru[n][5] $ "ND"
						cConteudo := Transform(&cConteudo,cPicture)
					ElseIf aEstru[n][5]=="C"
						cConteudo := &cConteudo
					Endif
					If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
						cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
					Else
						nString   := Len(cString) + Len(Alltrim(aEstru[n][2])) + 2
						cString   += Alltrim(aEstru[n][2])+": "+Substr(cConteudo,1,(nTamanho-2)-nString)+" ³"
					EndIf
				EndIf
			Next n
			If Len(cString) > 1
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				JC05TRB(cString,Alias())
			Endif
			JC05TRB(cBrancBloc,Alias())
			dbSkip()
		EndDo
		JC05TRB(cFimBloc,Alias())
	EndIf
	
	//--------------- Amarracao Grupo X Fornecedor (SAD)
	dbSelectArea("SAD")
	dbSetOrder(2)
	dbSeek(cFilial+SB1->B1_GRUPO)
	If Found() .And. MV_PAR06 == 1
		cString:=  " Amarracao Grupo X Fornecedor " 	//" Amarracao Grupo X Fornecedor "
		JC05TRB(CHR(218)+cString+Repli(CHR(196),((nTamanho-2)-Len(cString)))+CHR(191),Alias())
		cString:=""
		aEstru := {}
		AADD(aEstru,{"AD_FORNECE"   ,"",0,"",""})
		AADD(aEstru,{"AD_LOJA"      ,"",0,"",""})
		AADD(aEstru,{"AD_NOMEFOR"   ,"",0,"",""})
		AADD(aEstru,{"AD_NOMGRUP"   ,"",0,"",""})
		JMC05BUSCA(aEstru,Alias())
		While !Eof() .and. AD_FILIAL+AD_GRUPO == cFilial+SB1->B1_GRUPO
			cString:="³"
			For n:=1 to Len(aEstru)
				If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
					cPicture	 := aEstru[n][4]
					cConteudo := aEstru[n][1]
					If aEstru[n][5] $ "ND"
						cConteudo := Transform(&cConteudo,cPicture)
					ElseIf aEstru[n][5]=="C"
						cConteudo := &cConteudo
					Endif
					cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
				Else
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					JC05TRB(cString,Alias())
					cString:="³"
					cPicture	 := aEstru[n][4]
					cConteudo := aEstru[n][1]
					If aEstru[n][5] $ "ND"
						cConteudo := Transform(&cConteudo,cPicture)
					ElseIf aEstru[n][5]=="C"
						cConteudo := &cConteudo
					Endif
					If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
						cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
					Else
						nString   := Len(cString) + Len(Alltrim(aEstru[n][2])) + 2
						cString   += Alltrim(aEstru[n][2])+": "+Substr(cConteudo,1,(nTamanho-2)-nString)+" ³"
					EndIf
				Endif
			Next n
			If Len(cString) > 1
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				JC05TRB(cString,Alias())
			Endif
			JC05TRB(cBrancBloc,Alias())
			dbSkip()
		EndDo
		JC05TRB(cFimBloc,Alias())
	EndIf
	
	//--------------Dados Amarracao Produto X Cliente (SA7)
	dbSelectArea("SA7")
	dbSetOrder(2)
	dbSeek(cFilial+SB1->B1_COD)
	If Found() .And. MV_PAR06 == 1
		cString:=" Amarracao Produto X Cliente "		//" Amarracao Produto X Cliente "
		JC05TRB(CHR(218)+cString+Repli(CHR(196),((nTamanho-2)-Len(cString)))+CHR(191),Alias())
		cString:=""
		aEstru := {}
		AADD(aEstru,{"A7_CLIENTE"   ,"",0,"",""})
		AADD(aEstru,{"A7_LOJA"      ,"",0,"",""})
		AADD(aEstru,{"A7_CODCLI"    ,"",0,"",""})
		AADD(aEstru,{"A7_DESCCLI"   ,"",0,"",""})
		JMC05BUSCA(aEstru,Alias())
		
		While !Eof() .and. A7_FILIAL+A7_PRODUTO == cFilial+SB1->B1_COD
			cString:="³"
			For n:=1 to Len(aEstru)
				If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
					cPicture	 := aEstru[n][4]
					cConteudo := aEstru[n][1]
					If aEstru[n][5] $ "ND"
						cConteudo := Transform(&cConteudo,cPicture)
					ElseIf aEstru[n][5]=="C"
						cConteudo := &cConteudo
					Endif
					cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
				Else
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					JC05TRB(cString,Alias())
					cString:="³"
					cPicture	 := aEstru[n][4]
					cConteudo := aEstru[n][1]
					If aEstru[n][5] $ "ND"
						cConteudo := Transform(&cConteudo,cPicture)
					ElseIf aEstru[n][5]=="C"
						cConteudo := &cConteudo
					Endif
					If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
						cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
					Else
						nString   := Len(cString) + Len(Alltrim(aEstru[n][2])) + 2
						cString   += Alltrim(aEstru[n][2])+": "+Substr(cConteudo,1,(nTamanho-2)-nString)+" ³"
					EndIf
				Endif
			Next n
			If Len(cString) > 1
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				JC05TRB(cString,Alias())
			Endif
			JC05TRB(cBrancBloc,Alias())
			dbSkip()
		End
		JC05TRB(cFimBloc,Alias())
	EndIf
	
	
	//--------------------- Dados Movimentos em Aberto
	
	If MV_PAR05 == 1
		cString:=  " Movimentos em Aberto "	//" Movimentos em Aberto "
		JC05TRB(CHR(218)+cString+Repli(CHR(196),((nTamanho-2)-Len(cString)))+CHR(191),Alias())
		
		// ------------------- Solicitacoes de Compra (SC1)
		
		cAliasTop := "SC1"
		lQuery    := .F.
		#IFDEF TOP
			If TcSrvType()<>"AS/400"
				lQuery := .T.
				cAliasTop := "AliasSC1"
				cQuery := "SELECT * "
				cQuery += "FROM "+RetSqlName("SC1")+" SC1, "
				cQuery += "WHERE SC1.C1_FILIAL='"+xFilial("SC1")+"' AND "
				cQuery += "SC1.C1_PRODUTO='" + SB1->B1_COD + "' AND "
				cQuery += "SC1.C1_QUJE < SC1.C1_QUANT AND "
				cQuery += "SC1.C1_EMISSAO >= '" + DTOS(MV_PAR03) + "' AND "
				cQuery += "SC1.C1_EMISSAO <= '" + DTOS(MV_PAR04) + "' AND "
				cQuery += "SC1.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY "+SqlOrder(SC1->(IndexKey(2)))
				cQuery := ChangeQuery(cQuery)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
				
				aEval(SC1->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
			Endif
		#ENDIF
		
		dbSelectArea(cAliasTop)
		If ! lQuery
			dbSetOrder(2)
			dbSeek(cFilial+SB1->B1_COD)
		Endif
		If lQuery .Or. Found()
			/*
			³Solicit.  Dt.Entr.   Cotac.    Quant.Inf.   Quant.Entr.         Saldo ³
			³000001 01 DD/MM/AAAA 000001 9999999999.99 9999999999.99 99999999999.99³
			*/
			lFirst:=.T.
			nTotQtd:=0.00
			nTotEnt:=0.00
			nTotSal:=0.00
			Do While !Eof()
				If ! lQuery
					If ! (C1_FILIAL+C1_PRODUTO == cFilial+SB1->B1_COD)
						Exit
					Endif
					IF C1_QUJE >= C1_QUANT .or. C1_EMISSAO < MV_PAR03 .or. C1_EMISSAO > MV_PAR04
						dbSkip()
						Loop
					Endif
				Endif
				If lFirst
					JC05TRB(cBrancBloc,Alias())
					cString:= "³ Solicitacoes de Compra                                               ³" 	//"³ Solicitacoes de Compra                                               ³"
					JC05TRB(cString,Alias())
					cString:= " Solicit.  Dt.Entr.   Cotac.    Quant.Inf.   Quant.Entr.         Saldo ³"	//" Solicit.  Dt.Entr.   Cotac.    Quant.Inf.   Quant.Entr.         Saldo ³"
					JC05TRB(cString,Alias())
					lFirst := .F.
				Endif
				
				dDataFim := C1_DATPRF
				
				cString := "³"+C1_NUM+" "+C1_ITEM+" "+dtoc(dDataFim)+C1_COTACAO+" "+;
				Transform(C1_QUANT,"@E 9999999999.99")+" "+;
				Transform(C1_QUJE,"@E 9999999999.99")+" "+;
				Transform(C1_QUANT-C1_QUJE,"@E 99999999999.99")
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				JC05TRB(cString,Alias())
				
				nTotQtd+= C1_QUANT
				nTotEnt+= C1_QUJE
				nTotSal+= ( C1_QUANT - C1_QUJE )
				
				aJ05MRP(dDataFim,(C1_QUANT - C1_QUJE),"E")
				
				dbSkip()
			EndDo
			
			If !lFirst
				JC05TRB(cBrancBloc,Alias())
				cString:= "³Qtd.Tot.: "+Transform(nTotQtd,"@E 9999999999.99")+" Qtd.Entr.: "+Transform(nTotEnt,"@E 9999999999.99")+" Sld.: "+Transform(nTotSal,"@E 99999999999.99")		//"³Qtd.Tot.: "###" Qtd.Entr.: "###" Sld.: "
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				JC05TRB(cString,Alias())
			Endif
		Endif
		If lQuery
			dbSelectArea(cAliasTop)
			dbCloseArea()
			dbSelectArea("SC1")
		EndIf
		
		// --------------------- Pedido de Compra (SC7)
		
		cAliasTop := "SC7"
		lQuery    := .F.
		#IFDEF TOP
			If TcSrvType()<>"AS/400"
				lQuery := .T.
				cAliasTop := "AliasSC7"
				cQuery := "SELECT * "
				cQuery += "FROM "+RetSqlName("SC7")+" SC7, "
				cQuery += "WHERE SC7.C7_FILIAL='"+xFilial("SC7")+"' AND "
				cQuery += "SC7.C7_PRODUTO='" + SB1->B1_COD + "' AND "
				cQuery += "SC7.C7_QUJE < SC7.C7_QUANT AND "
				cQuery += "SC7.C7_EMISSAO >= '" + DTOS(MV_PAR03) + "' AND "
				cQuery += "SC7.C7_EMISSAO <= '" + DTOS(MV_PAR04) + "' AND "
				cQuery += "SC7.C7_RESIDUO  = '" + CriaVar("C7_RESIDUO", .F.) + "' AND "
				cQuery += "SC7.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY "+SqlOrder(SC7->(IndexKey(2)))
				cQuery := ChangeQuery(cQuery)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
				
				aEval(SC7->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
			Endif
		#ENDIF
		
		dbSelectArea(cAliasTop)
		If ! lQuery
			dbSetOrder(2)
			dbSeek(cFilial+SB1->B1_COD)
		Endif
		If lQuery .Or. Found()
			/*
			³Pedido Dt.Entr.   Forneced.   Quant.Inf.         Saldo Saldo em Valor ³
			³000001 DD/MM/AAAA 000000/00 999999999.99 999.999.999,99 999.999.999,99³
			³                  000000xxxxxxxxxxxxxx/00xx                           ³
			*/
			lFirst:=.T.
			nTotQtd:=0.00
			nTotEnt:=0.00
			nTotSal:=0.00
			Do While !Eof()
				If ! lQuery
					If ! (C7_FILIAL+C7_PRODUTO == cFilial+SB1->B1_COD)
						Exit
					Endif
					IF C7_QUJE >= C7_QUANT .or. C7_EMISSAO < MV_PAR03 .or. C7_EMISSAO > MV_PAR04 .or. !Empty(C7_RESIDUO)
						dbSkip()
						Loop
					Endif
				Endif
				If lFirst
					JC05TRB(cBrancBloc,Alias())
					cString:= "³ Pedidos de Compra                                                    ³"	//"³ Pedidos de Compra                                                    ³"
					JC05TRB(cString,Alias())
					cString:= "³Pedido Dt.Entr.   Forneced.   Quant.Inf.         Saldo Saldo em Valor ³"	//"³Pedido Dt.Entr.   Forneced.   Quant.Inf.         Saldo Saldo em Valor ³"
					JC05TRB(cString,Alias())
					lFirst:=.F.
				Endif
				
				dDataFim := C7_DATPRF
				
				cCliFor := If(lSXG1Max .Or. lSXG2Max, Space(aTamSXG1[1]), C7_FORNECE)
				cLoja   := If(lSXG1Max .Or. lSXG2Max, Space(aTamSXG2[1]), C7_LOJA)
				cString := "³"+C7_NUM+" "+dtoc(dDataFim)+" "+cCliFor+If(Empty(cCliFor)," ","/")+cLoja+" "+;
				Transform(C7_QUANT,"@E 999999999.99")+" "+;
				Transform((C7_QUANT-C7_QUJE),"@E 999,999,999.99")+" "+;
				Transform((C7_QUANT-C7_QUJE)*C7_PRECO,"@E 999,999,999.99")
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				
				JC05TRB(cString,Alias())
				
				If lSXG1Max .Or. lSXG2Max
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Quebro em Duas Linhas³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cString := "³"+PadR(Space(18)+C7_FORNECE+"/"+C7_LOJA,nTamanho-2)+"³"
					
					JC05TRB(cString,Alias())
					
				EndIf
				
				nTotQtd+= C7_QUANT
				nTotEnt+= C7_QUJE
				nTotSal+= ( C7_QUANT - C7_QUJE ) * C7_PRECO
				
				aJ05MRP(dDataFim,(C7_QUANT-C7_QUJE),"E")
				
				dbSkip()
			EndDo
			
			If !lFirst
				
				JC05TRB(cBrancBloc,Alias())
				
				cString:= "Qtd.Tot.:"+Transform(nTotQtd,"@E 999999999.99")+" Qtd.Entr.:"+Transform(nTotEnt,"@E 999,999,999.99")+" Sld.Vl.:"+Transform(nTotSal,"@E 999,999,999.99") //"³Qtd.Tot.:"###" Qtd.Entr.:"###" Sld.Vl.:"
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				
				JC05TRB(cString,Alias())
				
			Endif
		Endif
		If lQuery
			
			dbSelectArea(cAliasTop)
			dbCloseArea()
			
			dbSelectArea("SC7")
		EndIf
		
		// ------------------------ Pedido de Venda (SC6)
		
		cAliasTop := "SC6"
		lQuery    := .F.
		#IFDEF TOP
			If TcSrvType()<>"AS/400"
				lQuery := .T.
				cAliasTop := "AliasSC6"
				cQuery := "SELECT * "
				cQuery += "FROM "+RetSqlName("SC6")+" SC6, "
				cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
				cQuery += "SC6.C6_PRODUTO='" + SB1->B1_COD + "' AND "
				cQuery += "SC6.C6_QTDENT < SC6.C6_QTDVEN AND "
				cQuery += "SC6.C6_BLQ <> 'R ' AND "
				//    		cQuery += "SC6.C6_ENTREG>='" + Dtos(MV_PAR03) + "' AND "
				//			cQuery += "SC6.C6_ENTREG<='" + Dtos(MV_PAR04) + "' AND "
				cQuery += "SC6.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey(2)))
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
				aEval(SC6->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
			Endif
		#ENDIF
		
		dbSelectArea(cAliasTop)
		If ! lQuery
			dbSetOrder(2)
			dbSeek(cFilial+SB1->B1_COD)
		Endif
		If lQuery .Or. Found()
			/*
			³Pedido/It Cliente    Quant.Inf.      Vlr.Total Reserva        Saldo³
			³000001 01 00000/00 999999999.99 999.999.999,99 000000  999999999.99³
			*/
			lFirst  := .T.
			nTotQtd := 0.00
			nTotEnt := 0.00
			Do While !Eof()
				If !lQuery
					If !(C6_FILIAL+C6_PRODUTO == cFilial+SB1->B1_COD)
						Exit
					Endif
					If C6_QTDENT >= C6_QTDVEN .or. Alltrim((cAliasTop)->C6_BLQ) == "R"
						dbSkip()
						Loop
					Endif
				Endif
				SF4->(dbSeek(cFilial+(cAliasTop)->C6_TES))
				If SF4->F4_ESTOQUE # "S"
					dbSkip()
				Endif
				
				dbSelectArea("SC5")
				dbSetOrder(1)
				dbSeek(xFilial()+(cAliasTop)->C6_NUM)
				nTaxa := 1
				
				dbSelectArea(cAliasTop)
				If lFirst
					
					JC05TRB(cBrancBloc,Alias())
					
					cString:="³ Pedidos de Venda                                                     ³"
					
					JC05TRB(cString,Alias())
					
					cString:="³Pedido/It Cliente    Quant.Inf.      Vlr.Total Reserva       Saldo    ³"
					
					JC05TRB(cString,Alias())
					
					lFirst:=.F.
				Endif
				
				cCliFor := If(lSXG1Max .Or. lSXG2Max, Space(aTamSXG1[1]), C6_CLI)
				cLoja   := If(lSXG1Max .Or. lSXG2Max, Space(aTamSXG2[1]), C6_LOJA)
				cString := "³"+C6_NUM+" "+C6_ITEM+" "+cCliFor+If(Empty(cCliFor)," ","/")+cLoja+;
				Transform(C6_QTDVEN,"@E 999999999.99")+" "+;
				STR(SC5->C5_MOEDA)+"      "+;
				Transform((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN,"@E 999,999,999.99")+" "+;
				Transform(((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN)*If(nTaxa<=0,1,nTaxa),"@E 999,999,999.99")+" "+;
				C6_RESERVA+" "+Transform(C6_QTDVEN-C6_QTDENT,"@E 999999999.99")
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				
				JC05TRB(cString,Alias())
				
				If lSXG1Max .Or. lSXG2Max
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Quebro em Duas Linhas³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cString := "³"+PadR(Space(11)+C6_CLI+"/"+C6_LOJA,nTamanho-2)+"³"
					
					JC05TRB(cString,Alias())
				EndIf
				
				nTotQtd += C6_QTDVEN
				nTotEnt += (C6_QTDVEN - C6_QTDENT)
				
				If C6_ENTREG < dDataBasE
					dDataFim := dDataBase
				Else
					dDataFim := C6_ENTREG
				Endif
				
				aJ05MRP(dDataFim,(C6_QTDVEN - C6_QTDENT ),"S")
				
				dbSkip()
			EndDo
			If !lFirst
				JC05TRB(cBrancBloc,Alias())
				
				cString:="³Qtd.Total: "+Transform(nTotQtd,"@E 999999999.99")+" Saldo Total  : "+Transform(nTotEnt,"@E 999999999.99")		//"³Qtd.Total: "###" Saldo Total  : "
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				
				JC05TRB(cString,Alias())
			endif
		Endif
		If lQuery
			dbSelectArea(cAliasTop)
			dbCloseArea()
			dbSelectArea("SC6")
		EndIf
		
		//--------- Define Dados Historicos de Movimentacoes
		cString:=" Historicos de Movimentacoes "
		
		JC05TRB(CHR(218)+cString+Repli(CHR(196),((nTamanho-2)-Len(cString)))+CHR(191),Alias())
		
		
		
		// --------- Movimentos de Entrada (SD1)
		
		cAliasTop := "SD1"
		lQuery    := .F.
		#IFDEF TOP
			If TcSrvType()<>"AS/400"
				lQuery := .T.
				cAliasTop := "AliasSD1"
				cQuery := "SELECT * "
				cQuery += "FROM "+RetSqlName("SD1")+" SD1, "
				cQuery += "WHERE SD1.D1_FILIAL='"+xFilial("SD1")+"' AND "
				cQuery += "SD1.D1_COD='" + SB1->B1_COD + "' AND "
				cQuery += "SD1.D1_TES<>'" + Space(Len(SD1->D1_TES)) + "' AND "
				cQuery += "SD1.D1_DTDIGIT>='" + Dtos(MV_PAR03) + "' AND "
				cQuery += "SD1.D1_DTDIGIT<='" + Dtos(MV_PAR04) + "' AND "
				cQuery += "SD1.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY "+SqlOrder(SD1->(IndexKey(7)))
				cQuery := ChangeQuery(cQuery)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
				
				aEval(SD1->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
			Endif
		#ENDIF
		
		dbSelectArea(cAliasTop)
		If !lQuery
			
			dbSetOrder(7)
			dbSeek(cFilial+SB1->B1_COD)
		Endif
		If lQuery .Or. Found()
			/*
			Brasil
			³TP  Nota Fiscal  Emissao    Entrada   Fornecedor Atu.Estoque?         ³"
			³X    999999/XXX DD/MM/AAAA DD/MM/AAAA  999999/99      X               ³
			³ Frete:99,999.99 Desp:99,999.99 Qtd:99999999.99 Vl.Tot:999,999,999.99 ³
			*/
			
			lFirst:=.T.
			nTotEnt:=0.00
			nTotQtd:=0.00
			nTotCom:=0
			nFrete := 0
			nDesp  := 0
			Do While !Eof()
				If !lQuery
					If !(D1_FILIAL+D1_COD == cFilial+SB1->B1_COD)
						Exit
					Endif
				Endif
				
				dbSelectArea("SF4")
				dbSeek(cFilial+(cAliasTop)->D1_TES)
				
				dbSelectArea("SF1")
				dbSeek(cFilial+(cAliasTop)->D1_DOC+(cAliasTop)->D1_SERIE)
				
				dbSelectArea(cAliasTop)
				
				If !lQuery
					If Empty(D1_TES) .or. D1_DTDIGIT < MV_PAR03 .or. D1_DTDIGIT > MV_PAR04
						dbSkip()
						Loop
					Endif
				Endif
				
				//-- Calcula Despesas e Frete Proporcionais ao Produto (NF Entrada)
				If SF1->F1_FRETE > 0
					nFrete := ((cAliasTop)->D1_TOTAL/SF1->F1_VALMERC) * SF1->F1_FRETE
				Else
					nFrete := 0
				EndIf
				If SF1->F1_DESPESA > 0
					nDesp := ((cAliasTop)->D1_TOTAL/SF1->F1_VALMERC) * SF1->F1_DESPESA
				Else
					nDesp := 0
				EndIf
				
				If lFirst
					
					JC05TRB(cBrancBloc,Alias())
					
					cString:="³ Lancamentos de Entrada                                               ³"	// "³ Lancamentos de Entrada                                               ³"
					
					JC05TRB(cString,Alias())
					
					If MV_PAR05==1
						//-- Variavel por causa do no. da Nota Fiscal
						cString := "³TP " // "³TP "
						cString += If(cPaisLoc=="BRA"," ","  ")
						cString += "Nota Fiscal" // "Nota Fiscal"
						cString += If(cPaisLoc=="BRA","","   ")
						cString += "  Emissao    Entrada   Fornecedor Atu.Estoque?" // "  Emissao    Entrada   Fornecedor Atu.Estoque?"
						cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
						
						JC05TRB(cString,Alias())
						
					Endif
					
					lFirst:=.F.
				Endif
				If MV_PAR05== 1
					cCliFor := If(lSXG1Max .Or. lSXG2Max, Space(aTamSXG1[1]), D1_FORNECE)
					cLoja   := If(lSXG1Max .Or. lSXG2Max, Space(aTamSXG2[1]), D1_LOJA)
					cString := "³"+D1_TIPO+"  "+If(cPaisLoc=="BRA","  "+D1_DOC,PadR(D1_DOC,12))+"/"+D1_SERIE+" "+DtoC(D1_EMISSAO)+" "
					cString += DtoC(D1_DTDIGIT)+"  "+cCliFor+If(Empty(cCliFor)," ","/")+cLoja+"      "+SF4->F4_ESTOQUE
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					
					JC05TRB(cString,Alias())
					
					If lSXG1Max .Or. lSXG2Max
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Quebro em Duas Linhas³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cString := "³"+PadR(Space(If(cPaisLoc=="BRA",40,44))+D1_FORNECE+"/"+D1_LOJA,nTamanho-2)+"³"
						
						JC05TRB(cString,Alias())
						
					EndIf
					
					cString := "³ "
					cString += "Frete:" + Transform(nFrete,"@E 99,999.99")+" " // "Frete:"
					cString += "Desp:" + Transform(nDesp,"@E 99,999.99")+" " // "Desp:"
					cString += "Qtd:" + Transform(D1_QUANT,"@E 99999999.99")+" " // "Qtd:"
					cString += "Vl.Tot:" + Transform(D1_TOTAL,"@E 999,999,999.99") // "Vl.Tot:"
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					
					JC05TRB(cString,Alias())
					
				Endif
				
				nTotQtd+=D1_QUANT
				nTotEnt+=D1_TOTAL
				nTotCom++
				dbSkip()
			EndDo
			
			If nTotQtd > 0
				
				JC05TRB(cBrancBloc,Alias())
				
				cString:="³Qtd.Total: "+Transform(nTotQtd,"@E 999999999.99")+" Vlr.Total: "+Transform(nTotEnt,"@E 999,999,999.99")+" Num.Movim. "+Transform(nTotCom,"9999")		//"³Qtd.Total: "###" Vlr.Total: "###" Num.Movim. "
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				JC05TRB(cString,Alias())
			Endif
			
		Endif
		
		If lQuery
			
			dbSelectArea(cAliasTop)
			dbCloseArea()
			
			dbSelectArea("SD1")
		EndIf
		
		// ------------------- Movimentos de Saida (SD2)
		
		cAliasTop := "SD2"
		lQuery    := .F.
		#IFDEF TOP
			If TcSrvType()<>"AS/400"
				lQuery := .T.
				cAliasTop := "AliasSD2"
				cQuery := "SELECT * "
				cQuery += "FROM "+RetSqlName("SD2")+" SD2, "
				cQuery += "WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
				cQuery += "SD2.D2_COD='"  + SB1->B1_COD + "' AND "
				cQuery += "SD2.D2_TES<>'" + Space(Len(SD2->D2_TES)) + "' AND "
				cQuery += "SD2.D2_EMISSAO>='" + Dtos(MV_PAR03) + "' AND "
				cQuery += "SD2.D2_EMISSAO<='" + Dtos(MV_PAR04) + "' AND "
				cQuery += "SD2.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY "+SqlOrder(SD2->(IndexKey(6)))
				cQuery := ChangeQuery(cQuery)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
				
				aEval(SD2->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
			Endif
		#ENDIF
		
		dbSelectArea(cAliasTop)
		If ! lQuery
			
			dbSetOrder(6)
			dbSeek(cFilial+SB1->B1_COD)
		Endif
		If lQuery .Or. Found()
			/*
			Brasil
			³TP Nota Fiscal Pedido  Emissao    Cliente  Atu.Estoque?               ³"
			³X   999999/XXX 999999 DD/MM/AAAA 999999/99      X                     ³
			³ Frete:99,999.99 Desp:99,999.99 Qtd:99999999.99 Vl.Tot:999,999,999.99 ³
			*/
			
			lFirst:=.T.
			nTotQtd:=0.00
			nTotEnt:=0.00
			nTotSai:=0
			nFrete := 0
			nDesp  := 0
			DO While !Eof()
				If ! lQuery
					If ! (D2_FILIAL+D2_COD == cFilial+SB1->B1_COD)
						Exit
					Endif
				Endif
				
				dbSelectArea("SF4")
				dbSeek(cFilial+(cAliasTop)->D2_TES)
				
				dbSelectArea("SF2")
				dbSeek(cFilial+(cAliasTop)->D2_DOC+(cAliasTop)->D2_SERIE)
				
				dbSelectArea(cAliasTop)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ IFDEF p/ Notas Canceladas SHELL               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				#IFDEF SHELL
					IF D2_CANCEL == "S"
						dbSkip()
						Loop
					EndIf
				#ENDIF
				
				If ! lQuery
					If Empty(D2_TES) .or. D2_EMISSAO < MV_PAR03 .or. D2_EMISSAO > MV_PAR04
						dbSkip()
						Loop
					Endif
				Endif
				
				//-- Calcula Despesas e Frete Proporcionais ao Produto (NF Saida)
				If SF2->F2_FRETE > 0
					nFrete := ((cAliasTop)->D2_TOTAL/SF2->F2_VALMERC) * SF2->F2_FRETE
				Else
					nFrete := 0
				EndIf
				If SF2->F2_DESPESA > 0
					nDesp := ((cAliasTop)->D2_TOTAL/SF2->F2_VALMERC) * SF2->F2_DESPESA
				Else
					nDesp := 0
				EndIf
				
				If lFirst
					
					JC05TRB(cBrancBloc,Alias())
					
					cString:="³ Lancamentos de Saida                                                 ³"	//"³ Lancamentos de Saida                                                 ³"
					
					JC05TRB(cString,Alias())
					
					If MV_PAR05 == 1
						//-- Variavel por causa do no. da Nota Fiscal
						cString := "³TP " // "³TP "
						cString += If(cPaisLoc=="BRA","",Space(2))
						cString += "Nota Fiscal" // "Nota Fiscal"
						cString += If(cPaisLoc=="BRA","",Space(3))
						cString += " Pedido  Emissao    Cliente  Atu.Estoque?" // " Pedido  Emissao    Cliente  Atu.Estoque?"
						cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
						
						JC05TRB(cString,Alias())
						
					Endif
					lFirst:=.F.
				Endif
				If MV_PAR05 == 1
					cCliFor := If(lSXG1Max .Or. lSXG2Max, Space(aTamSXG1[1]), D2_CLIENTE)
					cLoja   := If(lSXG1Max .Or. lSXG2Max, Space(aTamSXG2[1]), D2_LOJA)
					cString := "³"+D2_TIPO+"  "+If(cPaisLoc=="BRA"," "+D2_DOC,Padr(D2_DOC,12))+"/"+D2_SERIE+" "+D2_PEDIDO+" "
					cString += DtoC(D2_EMISSAO)+" "+cCliFor+If(Empty(cCliFor)," ","/")+cLoja+"      "+SF4->F4_ESTOQUE
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					
					JC05TRB(cString,Alias())
					
					If lSXG1Max .Or. lSXG2Max
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Quebro em Duas Linhas³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cString := "³"+PadR(Space(If(cPaisLoc=="BRA",34,39))+D2_CLIENTE+"/"+D2_LOJA,nTamanho-2)+"³"
						
						JC05TRB(cString,Alias())
						
					EndIf
					
					cString := "³ "
					cString += "Frete:" + Transform(nFrete,"@E 99,999.99")+" " // "Frete:"
					cString += "Desp:" + Transform(nDesp,"@E 99,999.99")+" " // "Desp:"
					cString += "Qtd:" + Transform(D2_QUANT,"@E 99999999.99")+" " // "Qtd:"
					cString += "Vl.Tot:" + Transform(D2_TOTAL,"@E 999,999,999.99") // "Vl.Tot:"
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					
					JC05TRB(cString,Alias())
					
				Endif
				nTotQtd+=D2_QUANT
				nTotEnt+=D2_TOTAL
				nTotSai++
				dbSkip()
			EndDo
			
			If nTotQtd > 0
				
				JC05TRB(cBrancBloc,Alias())
				
				cString:="³Qtd.Total: "+Transform(nTotQtd,"@E 999999999.99")+" Vlr.Total: "+Transform(nTotEnt,"@E 999,999,999.99")+" Num.Movim. "+Transform(nTotSai,"9999")		//"³Qtd.Total: "###" Vlr.Total: "
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				
				JC05TRB(cString,Alias())
			Endif
		Endif
		If lQuery
			
			dbSelectArea(cAliasTop)
			dbCloseArea()
			
			dbSelectArea("SD2")
		EndIf
		
		// --------------------- Movimentos Internos (SD3)
		
		cAliasTop := "SD3"
		lQuery    := .F.
		#IFDEF TOP
			If TcSrvType()<>"AS/400"
				lQuery := .T.
				cAliasTop := "AliasSD3"
				cQuery := "SELECT * "
				cQuery += "FROM "+RetSqlName("SD3")+" SD3, "
				cQuery += "WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' AND "
				cQuery += "SD3.D3_COD='"  + SB1->B1_COD + "' AND "
				cQuery += "SD3.D3_EMISSAO>='" + Dtos(MV_PAR03) + "' AND "
				cQuery += "SD3.D3_EMISSAO<='" + Dtos(MV_PAR04) + "' AND "
				cQuery += "SD3.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY "+SqlOrder(SD3->(IndexKey(7)))
				cQuery := ChangeQuery(cQuery)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
				
				aEval(SD3->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
				
			Endif
		#ENDIF
		
		dbSelectArea(cAliasTop)
		If ! lQuery
			dbSetOrder(7)
			dbSeek(cFilial+SB1->B1_COD)
		Endif
		If lQuery .Or. Found()
			/*
			Brasil
			³TP   Documento   Emissao    Quantidade  RE/DE Local OP/Documento      ³
			³XX     999999   DD/MM/AAAA 999999999.99  999   99    99999999999      ³
			*/
			lFirst:=.T.
			nTotQtd:=0.00
			nTotEnt:=0.00
			nTotInt:=0
			Do While !Eof()
				If ! lQuery
					If ! (D3_FILIAL+D3_COD == cFilial+SB1->B1_COD)
						Exit
					Endif
					If D3_EMISSAO < MV_PAR03 .or. D3_EMISSAO > MV_PAR04
						dbSkip()
						Loop
					Endif
				Endif
				
				If lFirst
					
					JC05TRB(cBrancBloc,Alias())
					
					cString:="³ Lancamentos Internos                                                 ³"
					
					JC05TRB(cString,Alias())
					
					If MV_PAR05 == 1
						cString := "³TP   Documento   Emissao    Quantidade  RE/DE Local OP/Documento      ³" // "³TP   Documento   Emissao    Quantidade  RE/DE Local OP/Documento      ³"
						
						JC05TRB(cString,Alias())
						
					Endif
					lFirst:=.F.
				Endif
				If MV_PAR05 == 1
					cString := "³"+D3_TIPO+" "+If(cPaisLoc=="BRA","    "+D3_DOC+"  ",Padr(D3_DOC,12))+" "+ DtoC(D3_EMISSAO)+" "
					cString += Transform(D3_QUANT,"@E 999999999.99")+"  "+D3_CF+"   "+D3_LOCAL+"    "+D3_OP
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					
					JC05TRB(cString,Alias())
					
				Endif
				nTotQtd+=D3_QUANT
				nTotInt++
				dbSkip()
			EndDo
			
			If nTotQtd > 0
				
				JC05TRB(cBrancBloc,Alias())
				
				cString:="³Qtd.Total: "+Transform(nTotQtd,"@E 999999999.99")+" Num.Lanctos "+Transform(nTotInt,"9999")		//"³Qtd.Total: "###" Num.Lanctos "
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				
				JC05TRB(cString,Alias())
				
			Endif
		Endif
		If lQuery
			
			dbSelectArea(cAliasTop)
			dbCloseArea()
			
			dbSelectArea("SD3")
		EndIf
		
		// -------------- Movimentos controle Poder Terceiros (SB6)
		
		If MV_PAR01 == 1
			
			dbSelectArea("SB6")
			dbSetOrder(1)
			dbSeek(cFilial+SB1->B1_COD)
			If Found()
				
				/*
				
				³TP Nota Fiscal  Emissao   Cli./Forn. Loc Ultima Entrada             ³
				³X   999999/XXX DD/MM/AAAA 999999/99  99    DD/MM/AAAA               ³
				³    Quantidade: 999999999.99 Valor Unitario: 999,999,999.99         ³
				*/
				lFirst:=.T.
				nTotQtd:=0.00
				nTotEnt:=0.00
				nTotInt:=0
				nQtdGer:=0.00
				nEntGer:=0.00
				nIntGer:=0.00
				cIdentB6 := B6_IDENT
				Do While !Eof() .and. B6_FILIAL+B6_PRODUTO == cFilial+SB1->B1_COD
					
					If B6_DTDIGIT < MV_PAR03 .or. B6_DTDIGIT > MV_PAR04
						dbSkip()
						Loop
					Endif
					
					If lFirst
						
						JC05TRB(cBrancBloc,Alias())
						
						cString:="³ Lancamentos Controle Poder Terceiros                                 ³" //"³ Lancamentos Controle Poder Terceiros                                 ³"
						
						JC05TRB(cString,Alias())
						
						If MV_PAR05 == 1
							cString := "³TP "
							cString += If(cPaisLoc == "BRA",""," ")
							cString += "Nota Fiscal"
							cString += If(cPaisLoc == "BRA","","   ")
							cString += "  Emissao   Cli./Forn. Loc Ultima Entrada"
							cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
							
							JC05TRB(cString,Alias())
							
						Endif
						lFirst:=.F.
					Endif
					
					nRegSB6 := Recno()
					
					If MV_PAR05 == 1
						If SB6->B6_IDENT <> cIdentB6
							If nTotQtd > 0
								
								JC05TRB(cBrancBloc,Alias())
								
								cString:="³    Qtd : "+Transform(nTotQtd,"@E 9999999.99")+" Qtd.Entr.: "+Transform(nTotEnt,"@E 999999.99")+" Num.Lanctos "+Transform(nTotInt,"9999")		//"³    Qtd : "###" Qtd.Entr.: "###" Num.Lanctos "
								cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
								
								JC05TRB(cString,Alias())
								
							Endif
							cIdentB6 := SB6->B6_IDENT
							nTotQtd:=0.00
							nTotEnt:=0.00
							nTotInt:=0
						Endif
						cCliFor := If(lSXG1Max .Or. lSXG2Max, Space(aTamSXG1[1]), SB6->B6_CLIFOR)
						cLoja   := If(lSXG1Max .Or. lSXG2Max, Space(aTamSXG2[1]), SB6->B6_LOJA)
						cString := "³"+SB6->B6_TIPO+" "+If(cPaisLoc=="BRA","  "+SB6->B6_DOC,Padr(SB6->B6_DOC,12))+"/"+SB6->B6_SERIE+" "+DtoC(SB6->B6_DTDIGIT)+" "
						cString += cCliFor+If(Empty(cCliFor)," ","/")+cLoja+"  "+SB6->B6_LOCAL+"    "+DtoC(SB6->B6_UENT)
						cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
						
						JC05TRB(cString,Alias())
						
						If lSXG1Max .Or. lSXG2Max
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Quebro em Duas Linhas³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cString := "³"+PadR(Space(If(cPaisLoc=="BRA",27,31))+B6_CLIFOR+"/"+B6_LOJA,nTamanho-2)+"³"
							
							JC05TRB(cString,Alias())
							
						EndIf
						
						cString := "³  " + If(cPaisLoc == "BRA","  ","")
						cString += "Qtd:" + " " + Transform(SB6->B6_QUANT,"@E 999999999.99")+" " // "Qtd:"
						cString += "Valor Unitario: " + Transform(SB6->B6_PRUNIT,"@E 999,999,999.99") // "Valor Unitario: "
						cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
						
						JC05TRB(cString,Alias())
						
					EndIf
					
					
					
					dbSelectArea("SF4")
					dbSeek(cFilial+SB6->B6_TES)
					If SF4->F4_PODER3 == "R"
						nQuant   := SB6->B6_QUANT
						aSaldoTer:= CalcTerc(SB6->B6_PRODUTO, SB6->B6_CLIFOR, SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES)
						nSaldo   := nQuant - aSaldoTer[1]
					Else
						nQuant  := 0
						nSaldo  := 0
					Endif
					
					nTotQtd+=nQuant
					nTotEnt+=nSaldo
					nTotInt++
					
					nQtdGer+=nQuant
					nEntGer+=nSaldo
					nIntGer++
					
					dbSelectArea("SB6")
					dbSetOrder(1)
					dbGoto(nRegSB6)
					dbSkip()
				EndDo
				
				If MV_PAR05 == 1
					If nTotQtd > 0
						JC05TRB(cBrancBloc,Alias())
						cString:="³    Qtd : "+Transform(nTotQtd,"@E 9999999.99")+" Qtd.Entr.: "+Transform(nTotEnt,"@E 999999.99")+" Num.Lanctos "+Transform(nTotInt,"9999")	//"³    Qtd : "###" Qtd.Entr.: "###" Num.Lanctos "
						cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
						JC05TRB(cString,Alias())
					Endif
				Endif
				
				If nQtdGer > 0
					JC05TRB(cBrancBloc,Alias())
					cString:="³Qtd.Total: "+Transform(nQtdGer,"@E 9999999.99")+" Qtd.Entr.: "+Transform(nEntGer,"@E 999999.99")+" Num.Lanctos "+Transform(nIntGer,"9999")		//"³Qtd.Total: "###" Qtd.Entr.: "###" Num.Lanctos "
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					JC05TRB(cString,Alias())
				Endif
			Endif
			
			JC05TRB(cFimBloc,Alias())
		EndIf
		
		// -----------------------Saldos
		
		cString:=" Saldos " //" Saldos "
		
		JC05TRB(CHR(218)+cString+Repli(CHR(196),((nTamanho-2)-Len(cString)))+CHR(191),Alias())
		
		
		// ------------------ Saldos Iniciais (SB9)
		
		dbSelectArea("SB9")
		dbSetOrder(1)
		dbSeek(cFilial+SB1->B1_COD)
		If Found()
			aEstru := {}
			AADD(aEstru,{"B9_LOCAL"			,"",0,"",""})
			AADD(aEstru,{"B9_QINI"			,"",0,"",""})
			AADD(aEstru,{"B9_VINI1"			,"",0,"",""})
			AADD(aEstru,{"B9_DATA"			,"",0,"",""})
			
			JMC05BUSCA(aEstru,Alias())
			
			lFirst:=.T.
			Do While !Eof() .and. B9_FILIAL+B9_COD == cFilial+SB1->B1_COD
				cLocal := B9_LOCAL
				Do While !Eof() .and. B9_FILIAL+B9_COD+B9_LOCAL == cFilial+SB1->B1_COD+cLocal
					dbSkip()
				EndDo
				dbSkip(-1)
				
				JC05TRB(cBrancBloc,Alias())
				
				cString:="³ Saldo Ultimo Fechamento (por Almx.)                                  ³"
				
				JC05TRB(cString,Alias())
				
				cString:="³"
				For n:=1 to Len(aEstru)
					If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
						cPicture	 := Alltrim(aEstru[n][4])
						cConteudo := aEstru[n][1]
						If aEstru[n][5] $ "ND"
							cConteudo := Transform(&cConteudo,cPicture)
						ElseIf aEstru[n][5]=="C"
							cConteudo := &cConteudo
						Endif
						cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
					Else
						cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
						
						JC05TRB(cString,Alias())
						
						cString:="³"
						cPicture	 := aEstru[n][4]
						cConteudo := aEstru[n][1]
						If aEstru[n][5] $ "ND"
							cConteudo := Transform(&cConteudo,cPicture)
						ElseIf aEstru[n][5]=="C"
							cConteudo := &cConteudo
						Endif
						If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
							cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
						Else
							nString   := Len(cString) + Len(Alltrim(aEstru[n][2])) + 2
							cString   += Alltrim(aEstru[n][2])+": "+Substr(cConteudo,1,(nTamanho-2)-nString)+" ³"
						EndIf
					Endif
				Next n
				If Len(cString) > 1
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					
					JC05TRB(cString,Alias())
					
				Endif
				
				JC05TRB(cBrancBloc,Alias())
				
				dbSkip()
			EndDo
		Endif
	EndIf
EndIf

// ------------------- Saldos Fisicos e Financeiros

dbSelectArea("SB2")
dbSetOrder(1)
dbSeek(cFilial+SB1->B1_COD)
If MV_PAR02 == 2
	If Found()
		aEstru := {}
		AADD(aEstru,{"B2_QATU"      ,"",0,"",""})
		AADD(aEstru,{"ESPACO"       ,SPACE(12),60,"@","C"})
		AADD(aEstru,{"B2_CM1"       ,"",0,"",""})
		AADD(aEstru,{"ESPACO"       ,SPACE(12),60,"@","C"})
		AADD(aEstru,{"B2_VATU1"     ,"",0,"",""})
		AADD(aEstru,{"ESPACO"       ,SPACE(12),60,"@","C"})
		AADD(aEstru,{"B2_QPEDVEN"   ,"",0,"",""})
		AADD(aEstru,{"ESPACO"       ,SPACE(12),60,"@","C"})
		AADD(aEstru,{"B2_QTNP"      ,"",0,"",""})
		AADD(aEstru,{"ESPACO"       ,SPACE(12),60,"@","C"})
		AADD(aEstru,{"B2_QNPT"      ,"",0,"",""})
		AADD(aEstru,{"ESPACO"       ,SPACE(12),60,"@","C"})
		AADD(aEstru,{"B2_QDISP"     ,"",0,"",""})
		
		JMC05BUSCA(aEstru,Alias())
		
		nPos := aScan(aEstru, {|x| x[1] = "B2_QDISP"})
		If Empty(aEstru[nPos, 2])
			aEstru[nPos, 2] := "Saldo Disponivel"
			aEstru[nPos, 3] := TamSX3("B2_QATU")[1]
			aEstru[nPos, 4] := PesqPict("SB2", "B2_QATU")
		Endif
		
		Do While !Eof() .and. B2_FILIAL+B2_COD == cFilial+SB1->B1_COD
			aSaldo := CalcEst(SB1->B1_COD,SB2->B2_LOCAL,CTOD("31/12/49","ddmmyy"))
			If ( SB2->B2_QATU != Round(aSaldo[1],nDecSB2))
				Help(" ",1,"MATC050SLD")
			EndIf
			If MV_PAR01 == 1	// Considera Qtde De/Em Terceiros
				aSaldo[1] += SB2->B2_QNPT - SB2->B2_QTNP
			EndIf
			
			cString:="³"
			
			For n:=1 to Len(aEstru)
				
				If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
					cPicture  := aEstru[n][4]
					cConteudo := aEstru[n][1]
					If cConteudo == "B2_QDISP"
						cConteudo := Transform(SaldoSB2(.f., .t.), AllTrim(cPicture))
					Else
						If aEstru[n][5] $ "ND"
							cConteudo := Transform(&cConteudo,AllTrim(cPicture))
						ElseIf aEstru[n][5]=="C"
							cConteudo := &cConteudo
						Endif
					Endif
					cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
				Else
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					
					JC05TRB(cString,Alias())
					
					cString   :="³"
					
					If aEstru[n][1] == "ESPACO"
						LOOP
					EndIf
					
					cPicture  := aEstru[n][4]
					cConteudo := aEstru[n][1]
					If cConteudo == "B2_QDISP"
						cConteudo := Transform(SaldoSB2(.f., .t.), AllTrim(cPicture))
					Else
						If aEstru[n][5] $ "ND"
							If MV_PAR01 == 1 .And. cConteudo == "B2_QATU"
								cConteudo := Transform(aSaldo[1],AllTrim(cPicture))
							Else
								cConteudo := Transform(&cConteudo,cPicture)
							EndIf
						ElseIf aEstru[n][5]=="C"
							cConteudo := &cConteudo
						Endif
					Endif
					If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
						cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
					Else
						nString   := Len(cString) + Len(Alltrim(aEstru[n][2])) + 2
						cString   += Alltrim(aEstru[n][2])+": "+Substr(cConteudo,1,(nTamanho-2)-nString)+" ³"
					EndIf
				EndIf
			Next n
			
			If Len(cString) > 1
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				JC05TRB(cString,Alias())
			Endif
			
			// 	    JC05TRB(cBrancBloc,Alias())
			
			// Caso tenha B2 e nao tenha nada, poe a database como referencia
			If dDataFim == NIL
				dDataFim:=dDataBase
			EndIf
			
			dbSkip()
		EndDo
	EndIf
	
	// ------------------------------ Projecao de Saldos (mrp)
	/*
	³  Data      Saldo Inic.  Qtd.Entrada    Qtd.Saida  Saldo Atual      ³
	³dd/mm/aaaa 999999999.99 999999999.99 999999999.99 999999999.99      ³
	*/
	lFirst:=.T.
	nSaldoIni:=aTotGeral[1]
	// Montar a linha com saldo inicial
	aMRP := aSort( aMRP,,, { |x,y| x[1] < y[1] } )
	For k:=1 to Len(aMRP)
		If lFirst
			JC05TRB(cBrancBloc,Alias())
			
			cString:="³ Projecao de Saldos                                                   ³"	//"³ Projecao de Saldos                                                   ³"
			
			JC05TRB(cString,Alias())
			
			cString:="³  Data      Saldo Inic.  Qtd.Entrada    Qtd.Saida  Saldo Final        ³"	//"³  Data      Saldo Inic.  Qtd.Entrada    Qtd.Saida  Saldo Final        ³"
			
			JC05TRB(cString,Alias())
			
			lFirst:=.F.
		Endif
		cString :=  "³"+DtoC(aMRP[k][1])+" "+;
		Transform(nSaldoIni ,"@E 999999999.99")+" "+;
		Transform(aMRP[k][2],"@E 999999999.99")+" "+;
		Transform(aMRP[k][3],"@E 999999999.99")+" "+;
		Transform((nSaldoIni+aMRP[k][2])-aMRP[k][3],"@E 999999999.99")
		cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
		nSaldoIni := (nSaldoIni+aMRP[k][2])-aMRP[k][3]
		
		JC05TRB(cString,Alias())
		
	Next
	
	JC05TRB(cFimBloc,Alias())
	
	dbCommit()
Else
	If Found()
		aEstru := {}
		AADD(aEstru,{"B2_LOCAL"     ,"",0,"",""})
		AADD(aEstru,{"B2_CM1"       ,"",0,"",""})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ #IFDEF p/ a Shell do Brasil. Mostra na Tela a Quantidade Dis-³
		//³ ponivel em Estoque.                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		#IFDEF SHELL
			RecLock("SB2", .F.)
			SB2->B2_QDISP := SldDispVen(SB2->B2_COD,SB2->B2_LOCAL)
			MsUnLock()
			Aadd(aEstru, { "B2_QDISP", "", 0, "", "" })
		#ENDIF
		AADD(aEstru,{"B2_QATU"      ,"",0,"",""})
		AADD(aEstru,{"B2_VATU1"     ,"",0,"",""})
		AADD(aEstru,{"B2_SALPEDI"   ,"",0,"",""})
		AADD(aEstru,{"B2_RESERVA"   ,"",0,"",""})
		AADD(aEstru,{"B2_QPEDVEN"   ,"",0,"",""})
		AADD(aEstru,{"B2_QTNP"      ,"",0,"",""})
		AADD(aEstru,{"B2_QNPT"      ,"",0,"",""})
		AADD(aEstru,{"B2_QDISP"     ,"",0,"",""})
		
		JMC05BUSCA(aEstru,Alias())
		
		nPos := aScan(aEstru, {|x| x[1] = "B2_QDISP"})
		If Empty(aEstru[nPos, 2])
			aEstru[nPos, 2] := "Saldo Disponível"
			aEstru[nPos, 3] := TamSX3("B2_QATU")[1]
			aEstru[nPos, 4] := PesqPict("SB2", "B2_QATU")
		Endif
		
		lFirst:=.T.
		aTotGeral := {0,0,0,0,0,0}
		Do While !Eof() .and. B2_FILIAL+B2_COD == cFilial+SB1->B1_COD
			aSaldo := CalcEst(SB1->B1_COD,SB2->B2_LOCAL,CTOD("31/12/49","ddmmyy"))
			If ( SB2->B2_QATU != Round(aSaldo[1],nDecSB2))
				Help(" ",1,"MATC050SLD")
			EndIf
			If MV_PAR01 == 1	// Considera Qtde De/Em Terceiros
				aSaldo[1] += SB2->B2_QNPT - SB2->B2_QTNP
			EndIf
			
			JC05TRB(cBrancBloc,Alias())
			
			cString:="³ Saldos por Almoxarifado                                             ³"
			
			JC05TRB(cString,Alias())
			
			cString:="³"
			For n:=1 to Len(aEstru)
				If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
					cPicture  := aEstru[n][4]
					cConteudo := aEstru[n][1]
					If cConteudo == "B2_QDISP"
						cConteudo := Transform(SaldoSB2(.f., .t.), AllTrim(cPicture))
					Else
						If aEstru[n][5] $ "ND"
							cConteudo := Transform(&cConteudo,AllTrim(cPicture))
						ElseIf aEstru[n][5]=="C"
							cConteudo := &cConteudo
						Endif
					Endif
					cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
				Else
					cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
					
					JC05TRB(cString,Alias())
					
					cString:="³"
					cPicture  := aEstru[n][4]
					cConteudo := aEstru[n][1]
					If cConteudo == "B2_QDISP"
						cConteudo := Transform(SaldoSB2(.f., .t.), AllTrim(cPicture))
					Else
						If aEstru[n][5] $ "ND"
							If MV_PAR01 == 1 .And. cConteudo == "B2_QATU"
								cConteudo := Transform(aSaldo[1],AllTrim(cPicture))
							Else
								cConteudo := Transform(&cConteudo,cPicture)
							EndIf
						ElseIf aEstru[n][5]=="C"
							cConteudo := &cConteudo
						Endif
					Endif
					If Len(cString)+Len(Alltrim(aEstru[n][2]))+aEstru[n][3]+3 < nTamanho
						cString   += Alltrim(aEstru[n][2])+": "+cConteudo+" "
					Else
						nString   := Len(cString) + Len(Alltrim(aEstru[n][2])) + 2
						cString   += Alltrim(aEstru[n][2])+": "+Substr(cConteudo,1,(nTamanho-2)-nString)+" ³"
					EndIf
				Endif
			Next n
			
			If Len(cString) > 1
				cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
				
				JC05TRB(cString,Alias())
				
			Endif
			
			JC05TRB(cBrancBloc,Alias())
			
			aTotGeral[1] += aSaldo[1]
			aTotGeral[2] += aSaldo[2]
			aTotGeral[3] += aSaldo[3]
			aTotGeral[4] += aSaldo[4]
			aTotGeral[5] += aSaldo[5]
			aTotGeral[6] += aSaldo[6]
			// Caso tenha B2 e nao tenha nada, poe a database como referencia
			If dDataFim == NIL
				dDataFim:=dDataBase
			EndIf
			dbSkip()
		EndDo
		
		JC05TRB(cBrancBloc,Alias())
		
		cString := "³Total Geral: "
		cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
		
		JC05TRB(cString,Alias())
		
		cString := "³  Total Qtd. : "+Transform(aTotGeral[1],"@E 999999999.99") // "³  Total Qtd. : "
		cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
		
		JC05TRB(cString,Alias())
		
		cString := "³  Total Vlr.1: " + Transform(aTotGeral[2],"@E 999999999.99")  //  "³  Total Vlr.1: "
		cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
		
		JC05TRB(cString,Alias())
		
	Endif
	
	// ------------------------------ Projecao de Saldos (mrp)
	/*
	³  Data      Saldo Inic.  Qtd.Entrada    Qtd.Saida  Saldo Atual      ³
	³dd/mm/aaaa 999999999.99 999999999.99 999999999.99 999999999.99      ³
	*/
	lFirst:=.T.
	nSaldoIni:=aTotGeral[1]
	// Montar a linha com saldo inicial
	aMRP := aSort( aMRP,,, { |x,y| x[1] < y[1] } )
	For k:=1 to Len(aMRP)
		If lFirst
			
			JC05TRB(cBrancBloc,Alias())
			
			cString:="³ Projecao de Saldos                                                   ³"	//"³ Projecao de Saldos                                                   ³"
			
			JC05TRB(cString,Alias())
			
			cString:="³  Data      Saldo Inic.  Qtd.Entrada    Qtd.Saida  Saldo Final        ³"	//"³  Data      Saldo Inic.  Qtd.Entrada    Qtd.Saida  Saldo Final        ³"
			
			JC05TRB(cString,Alias())
			
			lFirst:=.F.
		Endif
		
		cString :=  "³"+DtoC(aMRP[k][1])+" "+;
		Transform(nSaldoIni ,"@E 999999999.99")+" "+;
		Transform(aMRP[k][2],"@E 999999999.99")+" "+;
		Transform(aMRP[k][3],"@E 999999999.99")+" "+;
		Transform((nSaldoIni+aMRP[k][2])-aMRP[k][3],"@E 999999999.99")
		cString += Space( ( ( nTamanho-Len(cString) ) - 1 ) )+"³"
		nSaldoIni := (nSaldoIni+aMRP[k][2])-aMRP[k][3]
		
		JC05TRB(cString,Alias())
		
	Next
	
	JC05TRB(cFimBloc,Alias())
	
	dbCommit()
	
EndIf

Return(lTudoOK)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ aJ05MRP  ³ Autor ³ Reiner Trennepohl ³ Data ³  13/08/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia para funcao que monta o arquivo de trabalho com as   ³±±
±±³          ³ movimentacoes e mostra-o na tela                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST05                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function aJ05MRP(dData,nQtd,cTipo)
Local nPos:=0

nPos := Ascan(aMRP, { |x|x[1] == dData} )

If nPos == 0
	aADD(aMRP,{dData,0,0})
	nPos := Len(aMRP)
Endif

If cTipo=="E"
	aMRP[nPos][2] += nQtd
Else
	aMRP[nPos][3] += nQtd
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ aJ05Imp  ³ Autor ³ Reiner Trennepohl ³ Data ³  13/08/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia para funcao que faz a impressao da consulta.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST05                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function aJ05Imp()
LOCAL cTitulo := "POSICAO ATUAL DE PRODUTO"
LOCAL cDesc1 	:= "Este programa ira imprimir a Consulta do Produto selecionado,"
LOCAL cDesc2 	:= "informando os dados cadastrais, Movimentacoes em Aberto,"
LOCAL cDesc3 	:= "Historico de Movimentacoes, Saldos e Consumos."
LOCAL cString := "SB1"
LOCAL wnrel   := "JMHEST05"

PRIVATE cPerg   :="      "
PRIVATE aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nLastKey:=0
nOpc:=2
nOpcA:=2
wnRel:= SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",,,,.F.)

If nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| JC050Imp(@lEnd,ctitulo,wnRel)},ctitulo)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JC050Imp ³ Autor ³ Reiner Trennepohl    ³ Data ³  13/08/03  ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia para funcao que faz a impressao da consulta.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST05                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function JC050Imp(lEnd,ctitulo,wnRel)
Local cCabec1  :="Consulta Geral ao Produto"	//"Consulta Geral ao Produto"
Local cCabec2  :=""
Local cTamanho :="M"
Local cNomeProg:="JMHEST05"
Local cbtxt    := SPACE(10)
Local cbcont   := 0

li    := 80
m_pag := 1

cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
li++

dbSelectArea("SB1TRB")
dbGoTop()
SetRegua(RecCount())            // Total de Elementos da Regua

Do While !EOF()
	
	IncRegua()
	
	IF li > 62
		@ ++li,65 PSay "Continua......."	//"Continua......."
		cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
	EndIF
	
	// Substituir os caracteres graficos antes da impressao. //
	cCampo:=""
	For x:=1 to Len(LINHA)
		If Subs(LINHA,x,1) $ "Ú¿ÀÙ"
			cCampo += "+"
		ElseIf Subs(LINHA,x,1) == "Ä"
			cCampo += "-"
		ElseIf Subs(LINHA,x,1) == "„"
			cCampo += "a"
		ElseIf Subs(LINHA,x,1) == "‡"
			cCampo += "c"
		ElseIf Subs(LINHA,x,1) == "³"
			cCampo += "|"
		Else
			cCampo += Subs(LINHA,x,1)
		Endif
	Next
	
	@ li++,00 PSay cCampo
	dbSkip()
	
EndDO

IF li != 80
	li++
	roda(cbcont,cbtxt,"P")
EndIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

Return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³JW05Brows³ Autor ³ Reiner Trennepohl   ³ Data ³  13/08/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra o Arquivo de Consulta para o Windows                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST05                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function JW05Brows(cAlias)
Local oDlg, oQual
Local cCadastro := OemToAnsi("Analise do Produto")		//"Analise do Produto"
Local oFont:=TFont():New( "Mono AS", 6, 15 )

dbSelectArea(cAlias)
dbGotop()

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,10 To 33,100 OF oMainWnd
@ 5,10 LISTBOX oQual FIELDS &(cAlias+"->LINHA") HEADER "" SIZE 340,160  FONT oFont PIXEL
DEFINE SBUTTON FROM 170,270  TYPE 1 ACTION (oDlg:End()) 				ENABLE OF oDlg
DEFINE SBUTTON FROM 170,300  TYPE 6 ACTION (aJ05Imp(),oDlg:End())	ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED
oFont:End()

Return(.T.)
  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JMHEST50 ³ Autor ³ Reiner Trennepohl   ³ Data ³  13/08/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra o Arquivo de Consulta para o Windows                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST05                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JMHEST50
Local oDlg50
Local cCada50 := OemToAnsi("Analise Generica do Produto")
Local cCod    := Space(15)

DEFINE MSDIALOG oDlg50 TITLE cCada50 From 05,05 To 10, 40 OF oMainWnd
//    @ 06, 006 TO 09, 100 LABEL ""      OF oDlg50 PIXEL
	@ 07, 007 SAY "Codigo .:" SIZE 50, 07 OF oDlg50 PIXEL        
	@ 07, 040 MSGET cCod      SIZE 40, 10 OF oDlg50 PIXEL
DEFINE SBUTTON FROM 25,080 TYPE 1 ACTION (JMHEST5A(cCod)) ENABLE OF oDlg50
DEFINE SBUTTON FROM 25,110 TYPE 2 ACTION (oDlg50:End())	  ENABLE OF oDlg50
ACTIVATE MSDIALOG oDlg50 CENTERED

Return(.T.)

Static Function JMHEST5A(cProd)

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+cProd)
   U_JMHEST51()
Else
   MsgBox( substr(cUsuario,7,13) + ", Nao Localizei o Produto no Cadastro!")
EndIf   

Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ JAjustaSX1   ³Autor ³ Reienr Trennepohl    ³Data³ 13/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function JAjustaSX1()

Local nX,nY      := 0
Local aAreaAnt   := GetArea()
Local aAreaSX1   := SX1->(GetArea())
Local aRegSX1    := {}                                            

AADD(aRegSX1,{cPerg,"01","Cons Saldo Em/De 3o. ?",        ".",".","mv_ch1","N",1,0,2,"C","","MV_PAR01","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""})
AADD(aRegSX1,{cPerg,"02","Considerar Parametros Abaixo ?",".",".","mv_ch2","N",1,0,2,"C","","MV_PAR02","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""})
AADD(aRegSX1,{cPerg,"03","Data Inicial",                  ".",".","mv_ch3","D",8,0,0,"G","","MV_PAR03","",   "",  "",   "","","",   "",  "",  "","","","","","","","","","","","","","","","","","",""})
AADD(aRegSX1,{cPerg,"04","Data Final",                    ".",".","mv_ch4","D",8,0,0,"G","","MV_PAR04","",   "",  "",   "","","",   "",  "",  "","","","","","","","","","","","","","","","","","",""})
AADD(aRegSX1,{cPerg,"05","Apresenta Movimentos ?",        ".",".","mv_ch5","N",1,0,2,"C","","MV_PAR05","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""})
AADD(aRegSX1,{cPerg,"06","Lista as Amarracoes ?",         ".",".","mv_ch6","N",1,0,2,"C","","MV_PAR06","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""})

dbSelectArea('SX1')
For nY:=1 to Len(aRegSX1)
	If !dbSeek(aRegSX1[nY,1]+aRegSX1[nY,2], .F.)
		RecLock('SX1',.T.)
		For nX:=1 to FCount()
			FieldPut(nX,aRegSX1[nY,nX])
		Next nX
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)

RestArea(aAreaAnt)

Return Nil
