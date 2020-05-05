//----------------------------------------------------------------------------------------|
//| Programa  | JMHFIN3A | Autor  | Reiner Trennepohl   | Data |  05/12/2000              |
//|---------------------------------------------------------------------------------------|
//| Desc.        | Funcao customizada para Geracao do Faturamento Especial                |
//|---------------------------------------------------------------------------------------|
#include "Protheus.CH"
#include "sigawin.ch"

//#Include "RwMake.Ch"
//#include 'COLORS.CH'
//#include 'FONT.CH'

User Function JMHFIN3A()

Local nRec   := 0
Local aArea  := GetArea()
Local cAlias := 'SE2'
Local lOk    := 0
Local lSai   := .F.

cPerg := PadR("FFIN3A",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
 
DBSELECTAREA("SX1")
DBSETORDER(1)
IF !DBSEEK(cPerg)
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "01"
	SX1->X1_PERGUNTA := "Data Inicio   ?"
	SX1->X1_TIPO     := "D"
	SX1->X1_TAMANHO  := 8
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR01"
	SX1->X1_VARIAVL  := "mv_ch1"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "02"
	SX1->X1_PERGUNTA := "Data Fim      ?"
	SX1->X1_TIPO     := "D"
	SX1->X1_TAMANHO  := 8
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR02"
	SX1->X1_VARIAVL  := "mv_ch2"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "03"
	SX1->X1_PERGUNTA := "Informe o CRM ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 6
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR03"
	SX1->X1_VARIAVL  := "mv_ch3"  
	SX1->X1_VALID    := "U_JMHFINX3()"
	MsUnlock()

ENDIF
//If !lPerg
//   Alert("Favor Atualizar os Parametros.")
//   U_JMHFIN3X()
//EndIf

Pergunte(cPerg,.F.)
dDataI := MV_PAR01    // Data Inicial
dDataF := MV_PAR02    // Data Final
cCRM   := MV_PAR03    // Codigo do CRM

DbSelectArea("SZ1")
DbSetOrder(1)
DbSeek( xFilial("SZ1")+cCRM )
Private cCRMZ1   := SZ1->Z1_FORNECE
Private cLjCRMZ1 := SZ1->Z1_LOJAFOR
Private cNomeCRM := SZ1->Z1_NOME
Private nRecZ1   := RecNo()
                              
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek( xFilial("SA1")+cCRMZ1+cLjCRMZ1 )
Private cNomeFor := SA1->A1_NOME

Private nRecF2, nRecZ2, nRecD2
Private nValorNF := 0         // Somatorio do Valor dos itens Selecionados
Private cPrefixo := "CRM"
Private cNatura  := "CP0301"     // Rever mais tarde com a Paola
Private dDtEmis  := dDataBase
Private dDtVcto  := dDataBase  
Private dDtVcRea := dDataBase
Private dDtEmis1 := dDataBase
          
Private aListSE2 := { { Space(Len(SE2->E2_NUM)),; 
Space(Len(SE2->E2_FORNECE)),;  
Space(Len(SE2->E2_NOMFOR)),; 
Space(Len(DTOC(SE2->E2_EMISSAO))),; 
Space(Len(DTOC(SE2->E2_VENCREA))),; 
0.00,;
Space(Len(SE2->E2_PREFIXO)),;
Space(Len(SE2->E2_TIPO)),;  
Space(Len(SE2->E2_NATUREZA)),; 
Space(Len(SE2->E2_LOJA)),;  
Space(Len(DTOC(SE2->E2_VENCTO))),; 
Space(Len(DTOC(SE2->E2_EMIS1))),;
Space(Len(SE2->E2_HIST)),;  
0.00,;
0,;    
Space(Len(SE2->E2_ORIGEM)),;  
0.00,;
0 } }

Private oListSE2
Private oPanSE2
Private oDlgSE2

Private lMark    := .F.
Private aListSZ2 := {{lMark, Space(Len(SZ2->Z2_NFISCAL)),;
Space(Len(SZ2->Z2_SERIE)),;  
0.00,;
Space(Len(DTOC(SZ2->Z2_DTEMIS))),;
Space(Len(SZ2->Z2_CRM)),;  
0 } }

Private oListSZ2
Private oPanSZ2

//----------------------------------------------------------------------------------------------|
// Le na resource os bitmaps utilizados no Listbox p/ selecao                                   |
//----------------------------------------------------------------------------------------------|

Private oOk  := Loadbitmap( GetResources(), 'LBOK')
Private oNo  := Loadbitmap( GetResources(), 'LBNO')

// monto uma Dialog com um Browse do SE2 para selecao
DEFINE MSDIALOG oDlgSE2 TITLE 'Titulos CRM ja Gerados'+space(45)+'Titulos a Gerar do CRM.: '+cNomeCRM FROM 0,0 TO 20,80 OF oMainWnd
                                                                                                                                   
DEFINE SBUTTON oBut7 FROM 120,008 TYPE 03 ENABLE OF oDlgSE2 PIXEL ACTION (ExcTitulo(.T.,aListSE2[oListSE2:nAt,1],aListSE2[oListSE2:nAt,7],aListSE2[oListSE2:nAt,2],aListSE2[oListSE2:nAt,4] ) )
DEFINE SBUTTON oBut4 FROM 120,159 TYPE 11 ENABLE OF oDlgSE2 PIXEL ACTION (SeleItens(cCRM,cCRMZ1,dDataI,dDataF,.T.))
DEFINE SBUTTON oBut3 FROM 120,190 TYPE 20 ENABLE OF oDlgSE2 PIXEL ACTION (SeleItens(cCRM,cCRMZ1,dDataI,dDataF,.F.))
DEFINE SBUTTON oBut2 FROM 120,222 TYPE 15 ENABLE OF oDlgSE2 PIXEL ACTION (TotPgto(.T.))
DEFINE SBUTTON oBut5 FROM 120,254 TYPE 01 ENABLE OF oDlgSE2 PIXEL ACTION (lOk:=VCRME2Conf(aListSZ2))
DEFINE SBUTTON oBut6 FROM 120,286 TYPE 02 ENABLE OF oDlgSE2 PIXEL ACTION oDlgSE2:End()

oBut2:SetDisable()
oBut3:SetDisable()
oBut4:SetDisable()
oBut5:SetDisable()
oBut7:SetDisable()

@ 02,002 MSPANEL oPanSE2  PROMPT '' OF oDlgSE2 SIZE 155, 110
@ 02,002  LISTBOX oListSE2  FIELDS HEADER	'Titulo', 'Medico', 'Nome', 'Emissao', 'Vencimento', 'Valor' SIZE 150,105 PIXEL OF oPanSE2 //;
//ON dblClick (aListSE2:=U_a12Visual(cAlias,oListSE2:nAt,2,aListSE2),oListSE2:Refresh())
@ 02,155 MSPANEL oPanSZ2  PROMPT '' OF oDlgSE2 SIZE 160, 110
@ 02,002 LISTBOX oListSZ2 FIELDS HEADER  '  ','NFiscal', 'Serie', 'Valor', 'Emissao', 'CRM' SIZE 155,105 PIXEL OF oPanSZ2;
ON dblClick (aListSZ2:=SFTroca(oListSZ2:nAt,aListSZ2),oListSZ2:Refresh())

oListSE2:SetArray(aListSE2)
oListSE2:bLine:={|| { aListSE2[oListSE2:nAt,01],;
	aListSE2[oListSE2:nAt,02],;
	aListSE2[oListSE2:nAt,03],;
	aListSE2[oListSE2:nAt,04],;
	aListSE2[oListSE2:nAt,05],;
	aListSE2[oListSE2:nAt,06],;
	aListSE2[oListSE2:nAt,07],;
	aListSE2[oListSE2:nAt,08],;
	aListSE2[oListSE2:nAt,09],;
	aListSE2[oListSE2:nAt,10],;
	aListSE2[oListSE2:nAt,11],;
	aListSE2[oListSE2:nAt,12],;
	aListSE2[oListSE2:nAt,13],;
	aListSE2[oListSE2:nAt,14],;
	aListSE2[oListSE2:nAt,15],;
	aListSE2[oListSE2:nAt,16],;
	aListSE2[oListSE2:nAt,17],;
	aListSE2[oListSE2:nAt,18] } }

oListSZ2:SetArray(aListSZ2)
oListSZ2:bLine:={|| {If(aListSZ2[oListSZ2:nAt,01],oOk,oNo),;
	aListSZ2[oListSZ2:nAt,02],;
	aListSZ2[oListSZ2:nAt,03],;
	aListSZ2[oListSZ2:nAt,04],;
	aListSZ2[oListSZ2:nAt,05],;
	aListSZ2[oListSZ2:nAt,06],;
	aListSZ2[oListSZ2:nAt,07] } }

// seleciono os Titulos do CRM
dbSelectArea('SE2')
dbSetOrder(6)
dbSeek(xFilial("SE2")+cCRMZ1+cLjCRMZ1)
If !EOF()
	// inicializo o vetor
	aListSE2 := Array(0)
	Do While SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA == xFilial("SE2")+cCRMZ1+cLjCRMZ1 .AND. !Eof()
	   If Day(SE2->E2_BAIXA)>0 .OR. SE2->E2_SALDO == 0
	      DbSkip()
	      Loop
	   EndIf   
	   // carrego para o listbox os registros
	   Aadd(aListSE2,{SE2->E2_NUM,;
			SE2->E2_FORNECE,;
			SE2->E2_NOMFOR,;
			SE2->E2_EMISSAO,;
			SE2->E2_VENCREA,;
			SE2->E2_VALOR,; 
			SE2->E2_PREFIXO,;   
			SE2->E2_TIPO,;
			SE2->E2_NATUREZ,;
			SE2->E2_LOJA,;
			SE2->E2_VENCTO,;
			SE2->E2_EMIS1,;
			SE2->E2_HIST,;
			SE2->E2_SALDO,;
			SE2->E2_MOEDA,;
			SE2->E2_ORIGEM,;
			SE2->E2_VLCRUZ,;
			RECNO()})
			dbSkip()
	EndDo
	If Len(aListSE2) > 0 
		
		oBut7:SetEnable()
				
		oListSE2:SetArray(aListSE2)
        oListSE2:bLine:={|| { aListSE2[oListSE2:nAt,01],;
			aListSE2[oListSE2:nAt,02],;
			aListSE2[oListSE2:nAt,03],;
			aListSE2[oListSE2:nAt,04],;
			aListSE2[oListSE2:nAt,05],;
			aListSE2[oListSE2:nAt,06],;
			aListSE2[oListSE2:nAt,07],;
			aListSE2[oListSE2:nAt,08],;
			aListSE2[oListSE2:nAt,09],;
			aListSE2[oListSE2:nAt,10],;
			aListSE2[oListSE2:nAt,11],;
			aListSE2[oListSE2:nAt,12],;
			aListSE2[oListSE2:nAt,13],;
			aListSE2[oListSE2:nAt,14],;
			aListSE2[oListSE2:nAt,15],;
			aListSE2[oListSE2:nAt,16],;
			aListSE2[oListSE2:nAt,17],;
			aListSE2[oListSE2:nAt,18] } }
		
		oListSE2:Refresh()
		oPanSE2:Show()
	Else
		
		aListSE2 := { { Space(Len(SE2->E2_NUM)),; 
			Space(Len(SE2->E2_FORNECE)),;  
			Space(Len(SE2->E2_NOMFOR)),; 
			Space(Len(DTOC(SE2->E2_EMISSAO))),; 
			Space(Len(DTOC(SE2->E2_VENCREA))),; 
			0.00,;
			Space(Len(SE2->E2_PREFIXO)),;
			Space(Len(SE2->E2_TIPO)),;  
			Space(Len(SE2->E2_NATUREZA)),; 
			Space(Len(SE2->E2_LOJA)),;  
			Space(Len(DTOC(SE2->E2_VENCTO))),; 
			Space(Len(DTOC(SE2->E2_EMIS1))),;
			Space(Len(SE2->E2_HIST)),;  
			0.00,;
			0,;    
			Space(Len(SE2->E2_ORIGEM)),;  
			0.00,;
			0 } }
			
		oPanSE2:Hide()
	Endif
Else
	oPanSE2:Hide()
Endif

dbSelectArea('SZ2')
dbSetOrder(1)   // DbOrderNickName("SZ2CRMEMIS") - FILIAL + CODIGO CRM + DATA EMISSAO
nRecZ2 := RecNo()
dbSeek(xFilial('SZ2')+cCRM+DTOS(dDataI),.T.)
If !EOF()
	// inicializo o vetor
	aListSZ2 := Array(0)
	nRecZ2   := RecNo()
	Do While SZ2->Z2_FILIAL == xFilial("SZ2") .And. SZ2->Z2_CRM == cCRM .And. !EOF()
		If SZ2->Z2_DTEMIS > dDataF .Or. Day(SZ2->Z2_DTPGTO) > 0 .Or. SZ2->Z2_NOTACRM # Space(6)
			dbSkip()
			Loop
		Endif
    	
		Aadd(aListSZ2,{lMark,;
			SZ2->Z2_NFISCAL,;
			SZ2->Z2_SERIE,;
			SZ2->Z2_TOTAL,;
			SZ2->Z2_DTEMIS,;
			SZ2->Z2_CRM,;
			RECNO() } )
		
		dbSkip()
	EndDo
	
	dbSelectArea('SZ2')
	DbGoTo(nRecZ2)
	If Len(aListSZ2) > 0
		
		If lMark
			oBut2:SetEnable()
			oBut3:SetEnable()
			oBut4:SetEnable()
			oBut5:SetEnable()
		Else
			oBut4:SetEnable()
			oBut2:SetDisable()
			oBut3:SetDisable()
			oBut5:SetDisable()
		Endif
		
		
		oListSZ2:SetArray(aListSZ2)
		oListSZ2:bLine:={|| {If(aListSZ2[oListSZ2:nAt,01],oOk,oNo),;
			aListSZ2[oListSZ2:nAt,02],;
			aListSZ2[oListSZ2:nAt,03],;
			aListSZ2[oListSZ2:nAt,04],;
			aListSZ2[oListSZ2:nAt,05],;
			aListSZ2[oListSZ2:nAt,06],;
			aListSZ2[oListSZ2:nAt,07] } }
			
		oListSZ2:Refresh()
		oPanSZ2:Show()
	Else
		Alert("Nao Foram Encontrados Titulos do CRM "+cNomeCRM+", a serem pagos nesse Periodo, Verifique os Parametros.")
		
		aListSZ2 := {{lMark, Space(Len(SZ2->Z2_NOTA)),;
					  Space(Len(SZ2->Z2_SERIE)),;  
		   			  0.00,;
					  Space(Len(DTOC(SZ2->Z2_DTEMIS))),;
					  Space(Len(SZ2->Z2_CRM)),;  
		  			  0 } }
		
		oPanSZ2:Hide()
	Endif
Else
	Alert("Nao Foram Encontrados Titulos para o CRM "+cNomeCRM+", no Cadastro de Faturamento Especial, Verifique os Parametros.")
	
	oPanSZ2:Hide()
Endif

dbSelectArea('SZ2')
DbGoTo(nRecZ2)

ACTIVATE MSDIALOG oDlgSE2 CENTERED

// retorna area original
RestArea(aArea)

Return(lOk)

/*-----------------------------------------------------------------------------------------------------------------------------------------|
| Programa  | SeleItens | Autor | Reiner Trennepohl                                      | Data |  05/12/2000 |
|------------------------------------------------------------------------------------------------------------------------------------------|
| Desc.        | Permite a selecao das Etiquetas para Faturamento                                             |
|------------------------------------------------------------------------------------------------------------------------------------------|
| Uso           | Em conjunto com o programa JMHFIN3A.PRW - Selecao de Titulos do CRM                     |
|-----------------------------------------------------------------------------------------------------------------------------------------|*/
Static Function SeleItens(cCRM,cCRMZ1,dDataI,dDataF,lMark)

Local aArea      := GetArea()
Local nRecE2     := 0

oBut2:SetDisable()
oBut3:SetDisable()
oBut4:SetDisable()
oBut5:SetDisable()

dbSelectArea('SZ2')
dbSetOrder(1)   // DbOrderNickName("SZ2CRM") - FILIAL + CODIGO CRM + DATA EMISSAO 
nRecZ2 := RecNo()
dbSeek(xFilial('SZ2')+cCRM+DTOS(dDataI),.T.)
If !EOF()
	// inicializo o vetor
	aListSZ2 := Array(0)
	nRecZ2   := RecNo()
	Do While SZ2->Z2_FILIAL == xFilial("SZ2") .And. SZ2->Z2_CRM == cCRM .And. !EOF()
		If SZ2->Z2_DTEMIS > dDataF .Or. Day(SZ2->Z2_DTPGTO) > 0 .Or. SZ2->Z2_NOTACRM # Space(6)
			dbSkip()
			Loop
		Endif
    	
		Aadd(aListSZ2,{lMark,;
			SZ2->Z2_NFISCAL,;
			SZ2->Z2_SERIE,;
			SZ2->Z2_TOTAL,;
			SZ2->Z2_DTEMIS,;
			SZ2->Z2_CRM,;
			RECNO() } )
		
		dbSkip()
	EndDo
	
	dbSelectArea('SZ2')
	DbGoTo(nRecZ2)
	If Len(aListSZ2) > 0
		
		If lMark
			oBut2:SetEnable()
			oBut3:SetEnable()
			oBut4:SetEnable()
			oBut5:SetEnable()
		Else
			oBut4:SetEnable()
			oBut2:SetDisable()
			oBut3:SetDisable()
			oBut5:SetDisable()
		Endif
		
		
		oListSZ2:SetArray(aListSZ2)
		oListSZ2:bLine:={|| {If(aListSZ2[oListSZ2:nAt,01],oOk,oNo),;
			aListSZ2[oListSZ2:nAt,02],;
			aListSZ2[oListSZ2:nAt,03],;
			aListSZ2[oListSZ2:nAt,04],;
			aListSZ2[oListSZ2:nAt,05],;
			aListSZ2[oListSZ2:nAt,06],;
			aListSZ2[oListSZ2:nAt,07] } }
			
		oListSZ2:Refresh()
		oPanSZ2:Show()
	Else
	   Alert("Nao Foram Encontrados Titulos do CRM "+cNomeCRM+", em Aberto nesse Periodo, Verifique os Parametros.")
	   aListSZ2 := {{lMark, Space(Len(SZ2->Z2_NOTA)),;
					  Space(Len(SZ2->Z2_SERIE)),;  
		   			  0.00,;
					  Space(Len(DTOC(SZ2->Z2_DTEMIS))),;
					  Space(Len(SZ2->Z2_CRM)),;  
		  			  0 } }
		
		oPanSZ2:Hide()
	Endif
Else
	Alert("Nao Foram Encontrados Titulos para o CRM "+cNomeCRM+", no Cadastro de Faturamento Especial, Verifique os Parametros.")
	oPanSZ2:Hide()
Endif

dbSelectArea('SZ2')
DbGoTo(nRecZ2)

Return

/*-----------------------------------------------------------------------------------------------------------------------------------------|
| Programa | SFTroca | Autor  | Reiner Trennepohl                                      | Data |   31/08/2000 |
|------------------------------------------------------------------------------------------------------------------------------------------|
| Desc.      | Seleciona no ListBox os itens desejados                   													    |
|------------------------------------------------------------------------------------------------------------------------------------------|
| Uso         | Em conjunto com o programa JMHFIN3A.PRW -                    |
|-----------------------------------------------------------------------------------------------------------------------------------------*/

Static Function SFTroca(nIt,aVetor)

Local nVet := 0

aVetor[nIt,1] := !aVetor[nIt,1]
If aVetor[nIt,1]
	oBut2:SetEnable()
	oBut3:SetEnable()
	oBut5:SetEnable()
Else
	oBut2:SetDisable()
	oBut3:SetDisable()
	oBut5:SetDisable()
	For nVet := 1 To Len(aVetor)
		If aVetor[nVet,1]
			oBut2:SetEnable()
			oBut3:SetEnable()
			oBut5:SetEnable()
			Exit
		Endif
	Next
Endif

Return(aVetor)

/*----------------------------------------------------------------------------------------------------|
| Programa  | VCRME2Conf | Autor  | Reiner Trennepohl                            | Data |  22/10/2001 |
|-----------------------------------------------------------------------------------------------------|
| Desc.     |  Permite a Geracao do Contas a Pagar conforme Titulos Selecionados					  |
|-----------------------------------------------------------------------------------------------------|*/
Static Function VCRME2Conf(aListSZ2)

Local nPos       := 0
Local nOpt  	 := 0
Local lNovo      := .F.
Local lOk        := 0
Local nLstSE2    := 0
Local nValTitulo := 0
Local nValPagto  := 0
Local cNoTitulo  := Space(6)
Local cTitulos   := Space(50)

Private  oFNT

// Pega o Codigo do Titulo se ja Existir soma1
dbSelectArea("SX6")
cNoTitulo := GetMv("MV_FATESP")

DbSelectArea("SE2")
DbSetOrder(1)
Do While dbSeek(xFilial("SE2")+cPrefixo+cNoTitulo)
   cNoTitulo := Soma1(cNoTitulo,Len(SE2->E2_NUM))
EndDo
			
DbSelectArea("SX6")
RecLock("SX6",.F.)
   SX6->X6_CONTEUD :=  Soma1(cNoTitulo,Len(SE2->E2_NUM))
MsUnLock()                                           

// Gera os Titulos no Contas a Pagar
For nLista := 1 To Len(aListSZ2)
	If aListSZ2[nLista,1]
				
		DbSelectArea("SZ2")
		DbGoTo(aListSZ2[nLista,7])
		RecLock('SZ2',.F.)
		SZ2->Z2_DTPGTO  := dDataBase
		SZ2->Z2_NOTACRM := cNoTitulo
	    MsUnLock()
		
		nValTitulo := nValTitulo + aListSZ2[nLista,4]
		If Len(cTitulos) > 0
			cTitulos := cTitulos + "," + aListSZ2[nLista,2]
		Else 
			cTitulos := AllTrim(cNomeCRM)+"-"+aListSZ2[nLista,2]
		Endif	
	EndIf
Next                    

nValPagto := ( nValTitulo * 70 ) / 100 
nValPagto := Round((nValPagto / 2),2)

DbSelectArea("SE2")
RecLock('SE2',.T.)
	SE2->E2_FILIAL   := xFilial("SE2")
	SE2->E2_NUM      := cNoTitulo
	SE2->E2_PREFIXO  := cPrefixo
	SE2->E2_TIPO     := "DP"
	SE2->E2_NATUREZA := cNatura
	SE2->E2_FORNECE  := cCRMZ1
	SE2->E2_LOJA     := cLjCRMZ1
	SE2->E2_NOMFOR   := cNomeFor
	SE2->E2_EMISSAO  := dDataBase
	SE2->E2_VENCTO   := dDataBase
	SE2->E2_VENCREA  := dDataBase
	SE2->E2_VALOR    := nValPagto
	SE2->E2_EMIS1    := dDataBase
	SE2->E2_HIST     := cTitulos
	SE2->E2_SALDO    := nValPagto
	SE2->E2_MOEDA    := 1
	SE2->E2_ORIGEM   := "LMHFIN3A"
	SE2->E2_VLCRUZ   := nValPagto
MsUnLock()  

// GERAR MOVIMENTO BANCARIO QDO DO PGTO
		
lOk := 1

oListSE2:SetArray(aListSE2)
oListSE2:bLine:={|| { aListSE2[oListSE2:nAt,01],;
	aListSE2[oListSE2:nAt,02],;
	aListSE2[oListSE2:nAt,03],;
	aListSE2[oListSE2:nAt,04],;
	aListSE2[oListSE2:nAt,05],;
	aListSE2[oListSE2:nAt,06],;
	aListSE2[oListSE2:nAt,07],;
	aListSE2[oListSE2:nAt,08],;
	aListSE2[oListSE2:nAt,09],;
	aListSE2[oListSE2:nAt,10],;
	aListSE2[oListSE2:nAt,11],;
	aListSE2[oListSE2:nAt,12],;
	aListSE2[oListSE2:nAt,13],;
	aListSE2[oListSE2:nAt,14],;
	aListSE2[oListSE2:nAt,15],;
	aListSE2[oListSE2:nAt,16],;
	aListSE2[oListSE2:nAt,17],;
	aListSE2[oListSE2:nAt,18] } }
	
If Len(aListSE2) == 0 .Or. Len(aListSE2) == 1 
	lNovo := .T.
		
	// inicializo o vetor
	aListSE2 := Array(0)
	
	// carrego para o listbox os registros
	Aadd(aListSE2,{SE2->E2_NUM,;
			SE2->E2_FORNECE,;
			SE2->E2_NOMFOR,;
			SE2->E2_EMISSAO,;
			SE2->E2_VENCREA,;
			SE2->E2_VALOR,; 
			SE2->E2_PREFIXO,;   
			SE2->E2_TIPO,;
			SE2->E2_NATUREZ,;
			SE2->E2_LOJA,;
			SE2->E2_VENCTO,;
			SE2->E2_EMIS1,;
			SE2->E2_HIST,;
			SE2->E2_SALDO,;
			SE2->E2_MOEDA,;
			SE2->E2_ORIGEM,;
			SE2->E2_VLCRUZ,;
			RECNO()})
Else
	// carrego para o listbox os registros
	Aadd(aListSE2,{SE2->E2_NUM,;
			SE2->E2_FORNECE,;
			SE2->E2_NOMFOR,;
			SE2->E2_EMISSAO,;
			SE2->E2_VENCREA,;
			SE2->E2_VALOR,; 
			SE2->E2_PREFIXO,;   
			SE2->E2_TIPO,;
			SE2->E2_NATUREZ,;
			SE2->E2_LOJA,;
			SE2->E2_VENCTO,;
			SE2->E2_EMIS1,;
			SE2->E2_HIST,;
			SE2->E2_SALDO,;
			SE2->E2_MOEDA,;
			SE2->E2_ORIGEM,;
			SE2->E2_VLCRUZ,;
			RECNO()})			
Endif

If Len(aListSE2) > 0
	
	oListSE2:SetArray(aListSE2)
    oListSE2:bLine:={|| { aListSE2[oListSE2:nAt,01],;
	aListSE2[oListSE2:nAt,02],;
	aListSE2[oListSE2:nAt,03],;
	aListSE2[oListSE2:nAt,04],;
	aListSE2[oListSE2:nAt,05],;
	aListSE2[oListSE2:nAt,06],;
	aListSE2[oListSE2:nAt,07],;
	aListSE2[oListSE2:nAt,08],;
	aListSE2[oListSE2:nAt,09],;
	aListSE2[oListSE2:nAt,10],;
	aListSE2[oListSE2:nAt,11],;
	aListSE2[oListSE2:nAt,12],;
	aListSE2[oListSE2:nAt,13],;
	aListSE2[oListSE2:nAt,14],;
	aListSE2[oListSE2:nAt,15],;
	aListSE2[oListSE2:nAt,16],;
	aListSE2[oListSE2:nAt,17],;
	aListSE2[oListSE2:nAt,18] } }
	
	oListSE2:Refresh()
	If lNovo
		
		oBut7:SetEnable()
		
		oPanSE2:Show()
	Endif
Endif

nPos := 0

For nLista := 1 To Len(aListSZ2) 
	If aListSZ2[nLista-nPos,1]
		ADEL(aListSZ2,nLista-nPos)
		nPos += 1
	Endif
Next                          
ASIZE(aListSZ2,Len(aListSZ2)-nPos)

If Len(aListSZ2) == 0
	
	oBut2:SetDisable()
	oBut3:SetDisable()
	oBut4:SetDisable()
	oBut5:SetDisable()
	
	oPanSZ2:Hide()
	
Else
	oBut2:SetDisable()
	oBut3:SetDisable()
	oBut5:SetDisable()
	
	oListSZ2:SetArray(aListSZ2)
	oListSZ2:bLine:={|| {If(aListSZ2[oListSZ2:nAt,01],oOk,oNo),;
	aListSZ2[oListSZ2:nAt,02],;
	aListSZ2[oListSZ2:nAt,03],;
	aListSZ2[oListSZ2:nAt,04],;
	aListSZ2[oListSZ2:nAt,05],;
	aListSZ2[oListSZ2:nAt,06],;
	aListSZ2[oListSZ2:nAt,07] } }
	
	oListSZ2:Refresh()
	//oPanSZ2:Show()
	
Endif

Return(lOk)

/*----------------------------------------------------------------------------------------------------------|
| Programa  | TotPgto | Autor  | Reiner Trennepohl                                     | Data |  31/08/2000 |
|-----------------------------------------------------------------------------------------------------------|
| Desc.        | Permite Vizualizar os Totalizadores do itulo												|
|-----------------------------------------------------------------------------------------------------------|*/
Static Function TotPgto(l_OK)

Local nQtdTitulo := 0
Local nValTitulo := 0
Local nValPagto  :=0
Local aArea      := GetArea()

Private  oFNT
               
dbSelectArea("SX6")
cNoTitulo := GetMv("MV_FATESP")

DbSelectArea("SE2")
DbSetOrder(1)
Do While dbSeek(xFilial("SE2")+cPrefixo+cNoTitulo)
   cNoTitulo := Soma1(cNoTitulo,Len(SE2->E2_NUM))
EndDo

For nLista := 1 To Len(aListSZ2)
	If aListSZ2[nLista,1]
					
		nValTitulo := nValTitulo + aListSZ2[nLista,4]
		nQtdTitulo := nQtdTitulo + 1
		
	EndIf
Next

nValPagto := ( nValTitulo * 70 ) / 100 
nValPagto := Round((nValPagto / 2),2)

If  l_Ok
	
	DEFINE FONT oFNT NAME "Ms Sans Serif" SIZE 10,08 Bold
	DEFINE MSDIALOG Dial001 TITLE 'Totais dos Itens Selecionados para o Titulo, '+cNoTitulo FROM 000,000 TO 016,060 OF oMainWnd
	
	@ 001, 001 Say "Qtde de Titulos Selecionados .....: "+Transform( nQtdTitulo, "999")
		
	@ 003, 001 Say "Medico .............: " + cCRM+" - "+cNomeCRM
	@ 004, 001 Say "Emissao  ...........: " + DToC(dDataBase)
	@ 005,001  Say "Vlr dos Titulos ....: " + Transform( nValTitulo, "@e 999,999,999.99")
	@ 006,001  Say "Vlr a Pagar .. .....: " + Transform( nValPagto, "@e 999,999,999.99")
	
	DEFINE SBUTTON oBut0 FROM 100,200 TYPE 1  ENABLE OF Dial001 PIXEL ACTION Dial001:End()
	
	ACTIVATE MSDIALOG Dial001 CENTERED
	
Endif

RestArea(aArea)

Return(l_Ok)

/*-----------------------------------------------------------------------------------------------------------------------------------------|
| Programa  | Exctitulo | Autor  | Reiner Trennepohl                                     | Data |  02/03/2001                    |
|-------------------------------------------------------------------------------------------------------------------------------------------|
| Desc.        | Permite a Exclusao do Titulo Gerado																								                   |
|------------------------------------------------------------------------------------------------------------------------------------------*/
Static Function ExcTitulo(l_OK,cTitulo,cPrefixo,cFornece,dDatEmi)

Local nOpt      := 0
Local nRecZ1    := 0
Local nRecE2    := 0
Local xi        := 0
Local nLista    := 0
Local nPos      := 0
Local lNovo     := .F.
Local aTitulos := {}      
Local cTitulos  := Space(50)
Local aArea     := GetArea()


If MsgYesNo(Substr(cUsuario,7,13) + "!  Voce Confirma a Exclusao desse Titulo, " +cTitulo+ ", para o Medico "+cNomeCRM+"?")
	nOpt := 1
Endif
If nOpt == 1

    lMark := .F.
	
	oListSZ2:SetArray(aListSZ2)
	oListSZ2:bLine:={|| {If(aListSZ2[oListSZ2:nAt,01],oOk,oNo),;
	aListSZ2[oListSZ2:nAt,02],;
	aListSZ2[oListSZ2:nAt,03],;
	aListSZ2[oListSZ2:nAt,04],;
	aListSZ2[oListSZ2:nAt,05],;
	aListSZ2[oListSZ2:nAt,06],;
	aListSZ2[oListSZ2:nAt,07] } }
	
	// Posiciona no Titulo Gerado para Exclusao
	dbSelectArea('SE2')
	dbSetOrder(1)
	dbSeek(xFilial("SE2")+cTitulo+cPrefixo+cFornece)
	If !EOF()
	    cTitulos := AllTrim(SE2->E2_HIST)
	    
    	DbSelectArea('SE2')
		DbGoTo(nRecZA)
		RecLock("SE2",.f.)
    		Dbdelete()
		MsUnLock()
	EndIf	
	                             
	Do While Len(cTitulos) > 5
	
  	   Aadd(aTitulos,Left(cTitulos,6))
  	   cTitulos := Substr(cTitulos,8)
	EndDo
	
	dbSelectArea('SZ2')
	dbSetOrder(1)             
	For xi := 1 To Len(aTitulos)
	
   	    dbSeek(xFilial('SZ2')+aTitulos[xi])
   	    If !EOF()
   		   RecLock('SZ2',.F.)
		     SZ2->Z2_DTPGTO  := CtoD("  /  /  ")
   		     SZ2->Z2_NOTACRM :=	Space(6)
		   MsUnLock()
		EndIf

	Next
	
	dbSelectArea('SZ2')
	dbSetOrder(1)   // DbOrderNickName("SZ2CRM") - FILIAL + CODIGO CRM + DATA EMISSAO
	If dbSeek(xFilial('SZ2')+cCRM+DTOS(dDataI),.T.)
		
		// inicializo o vetor
		aListSZ2 := Array(0)
		nRecZ2   := RecNo()
		Do While SZ2->Z2_FILIAL == xFilial("SZ2") .And. SZ2->Z2_CRM == cCRM .And. !EOF()
			If SZ2->Z2_DTEMIS > dDataF .Or. Day(SZ2->Z2_DTPGTO) > 0 .Or. SZ2->Z2_NOTACRM # Space(6)
				dbSkip()
				Loop
			Endif
	    	
			Aadd(aListSZ2,{lMark,;
				SZ2->Z2_NFISCAL,;
				SZ2->Z2_SERIE,;
				SZ2->Z2_TOTAL,;
				SZ2->Z2_DTEMIS,;
				SZ2->Z2_CRM,;
				RECNO() } )
			
			dbSkip()
		EndDo
		
		dbSelectArea('SZ2')
		DbGoTo(nRecZ2)
		If Len(aListSZ2) > 0
			
			If lMark
				oBut2:SetEnable()
				oBut3:SetEnable()
				oBut4:SetEnable()
				oBut5:SetEnable()
			Else
				oBut4:SetEnable()
				oBut2:SetDisable()
				oBut3:SetDisable()
				oBut5:SetDisable()
			Endif
			
		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³ Ordenar Array ..............                                       ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		    aSort(aListSZ2,,,{|x,y| x[4] < y[4]} )
			
			oListSZ2:SetArray(aListSZ2)
			oListSZ2:bLine:={|| {If(aListSZ2[oListSZ2:nAt,01],oOk,oNo),;
				aListSZ2[oListSZ2:nAt,02],;
				aListSZ2[oListSZ2:nAt,03],;
				aListSZ2[oListSZ2:nAt,04],;
				aListSZ2[oListSZ2:nAt,05],;
				aListSZ2[oListSZ2:nAt,06],;
				aListSZ2[oListSZ2:nAt,07] } }
				
			oListSZ2:Refresh()
			oPanSZ2:Show()
		Else
			Alert("Nao Foram Encontrados Titulos do CRM "+cNomeCRM+", em Aberto nesse Periodo, Verifique os Parametros.")
			
			aListSZ2 := {{lMark, Space(Len(SZ2->Z2_NOTA)),;
						  Space(Len(SZ2->Z2_SERIE)),;  
			   			  0.00,;
						  Space(Len(DTOC(SZ2->Z2_DTEMIS))),;
						  Space(Len(SZ2->Z2_CRM)),;  
			  			  0 } }
			
			oPanSZ2:Hide()
		Endif
	Else
		Alert("Nao Foram Encontrados Titulos para o CRM "+cNomeCRM+", no Cadastro de Faturamento Especial, Verifique os Parametros.")
		oPanSZ2:Hide()
	Endif

	For nLista := 1 To Len(aListSE2)
	    If aListSE2[nLista-nPos,1]+aListSE2[nLista-nPos,7]+aListSE2[nLista-nPos,2]+DToC(aListSE2[nLista-nPos,4]) == cTitulo+cPrefixo+cFornece+DToC(dDatEmi)
			ADEL(aListSE2,nLista-nPos)
			nPos += 1
		Endif
	Next
	ASIZE(aListSE2,Len(aListSE2)-nPos)
	
	If Len(aListSE2) == 0
		oBut7:SetDisable()
		//		oBut8:SetDisable()
		oPanSE2:Hide()
	Else
		
    	oListSE2:SetArray(aListSE2)
    	oListSE2:bLine:={|| { aListSE2[oListSE2:nAt,01],;
		aListSE2[oListSE2:nAt,02],;
		aListSE2[oListSE2:nAt,03],;
		aListSE2[oListSE2:nAt,04],;
		aListSE2[oListSE2:nAt,05],;
		aListSE2[oListSE2:nAt,06],;
		aListSE2[oListSE2:nAt,07],;
		aListSE2[oListSE2:nAt,08],;
		aListSE2[oListSE2:nAt,09],;
		aListSE2[oListSE2:nAt,10],;
		aListSE2[oListSE2:nAt,11],;
		aListSE2[oListSE2:nAt,12],;
		aListSE2[oListSE2:nAt,13],;
		aListSE2[oListSE2:nAt,14],;
		aListSE2[oListSE2:nAt,15],;
		aListSE2[oListSE2:nAt,16],;
		aListSE2[oListSE2:nAt,17],;
		aListSE2[oListSE2:nAt,18] } }
				
		oListSE2:Refresh()
		
	Endif
Endif

RestArea(aArea)

Return(l_Ok)
                    
