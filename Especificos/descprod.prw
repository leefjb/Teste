#define CRLF ( chr(13)+chr(10) )
#include "protheus.ch"
#include "sigawin.ch"

User Function DescProd()
Private cCadastro := "Descrição Técnica"
Private aRotina := {{"Pesquisar",  "AxPesqui",   0, 1 },;
					{"Visualizar", "AxVisual", 0, 2 },;
					{"Tecnica",    "U_DescTec", 0, 8 } }


dbSelectArea('SB1')

mBrowse( 6, 1,22,75,"SB1")

Return



User Function DescTec()
Local nOpca   := 0

DEFINE MSDIALOG oVCan FROM 05,10 TO 400,650 TITLE "Descrição Técnica" PIXEL
cObs := MSMM(SB1->B1_DESC_P, TamSx3("B1_VM_P")[1])

@ 12,08 GET oObs VAR cObs OF oVCan MEMO SIZE 300,150 PIXEL

DEFINE SBUTTON FROM 180,250 TYPE 1 ACTION (nOpca := 1,oVCan:End()) ENABLE OF oVCan

ACTIVATE MSDIALOG oVCan CENTER

If nOpca = 1
	// posiciona o SUA
	DbSelectArea("SB1")
	RecLock("SB1",.F.)
	MSMM(,TamSx3("B1_VM_P")[1],,cObs,1,,,"SB1","B1_DESC_P")
	MsUnlock()
EndIf

Return
