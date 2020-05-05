#include "Protheus.CH"
#include "sigawin.ch"
#include 'COLORS.CH'
#include 'FONT.CH'


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJMHEST2c()  บ Autor ณ                                       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Processo para Validacao das Etiquetas qdo COMPRA           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHEST02			                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function JMHEST2c()

Local lPerg
Local nRecZ3  := 0
Local aArea   := GetArea()
Local cAlias  := 'SZ3'
Local cCodEtq := Space(6)
Local lOk     := 0

Private cNFDe, cNFAte, cPrdDe, cPrdAte
Private cPerg := PadR("JEST2C",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
Private lMark := .F.

ValidPerg()

If !Pergunte(cPerg,.T.) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
   Return
EndIf
      
cNFDe   := MV_PAR01    // NFiscal Inicial
cNFAte  := MV_PAR02    // NFiscal Final
cPrdDe  := MV_PAR03    // Produto de
cPrdAte := MV_PAR04    // Produto Ate

Private aListSZ3 := {{lMark,Space(Len(SZ3->Z3_CODETIQ)),; 
	Space(Len(SZ3->Z3_LOTE)),;
	Space(Len(SZ3->Z3_NFENTRA)),;
	Space(Len(DTOC(SZ3->Z3_DATAENT))),;
	Space(Len(SZ3->Z3_FORNECE)),;
	Space(Len(SZ3->Z3_CODPROD)),;
	Space(Len(SZ3->Z3_DESC)),;
	Space(Len(SZ3->Z3_LOJAFOR)),;
	Space(Len(SZ3->Z3_SERIENT))}}

Private oListSZ3
Private oPanSZ3
Private oDlgSZ3

//--------------------------------------------------------------------------------------------------------------------------------------|
// Le na resource os bitmaps utiliZ3dos no Listbox p/ selecao                                   |
//--------------------------------------------------------------------------------------------------------------------------------------|
Private oOk  := Loadbitmap( GetResources(), 'LBOK')
Private oNo  := Loadbitmap( GetResources(), 'LBNO')

// monto uma Dialog com um Browse do SZ3 para selecao
DEFINE MSDIALOG oDlgSZ3 TITLE 'Confirmacao das Etiquetas Compradas' FROM 0,0 TO 20,80 OF oMainWnd

DEFINE SBUTTON oBut4 FROM 135,007 TYPE 11 ENABLE OF oDlgSZ3 PIXEL ACTION (SeleItens(aListSZ3,.T.))
DEFINE SBUTTON oBut3 FROM 135,038 TYPE 20 ENABLE OF oDlgSZ3 PIXEL ACTION (SeleItens(aListSZ3,.F.))
DEFINE SBUTTON oBut1 FROM 135,254 TYPE 01 ENABLE OF oDlgSZ3 PIXEL ACTION (lOk:=VEtqZ3Conf(aListSZ3))
DEFINE SBUTTON oBut2 FROM 135,286 TYPE 02 ENABLE OF oDlgSZ3 PIXEL ACTION oDlgSZ3:End()

oBut1:SetDisable() 
oBut3:SetDisable()
oBut4:SetDisable()     

@ 02,002 MSPANEL oPanSZ3  PROMPT '' OF oDlgSZ3 SIZE 320, 130
@ 02,002  LISTBOX oListSZ3  FIELDS HEADER  '  ','Etiqueta','Lote','Nota Fiscal', 'Data', 'Fornecedor', 'Produto', ;
														'Descricao' SIZE 315,125 PIXEL OF oPanSZ3;
ON dblClick (aListSZ3:=SZTroca(oListSZ3:nAt,aListSZ3),oListSZ3:Refresh())

oListSZ3:SetArray(aListSZ3)
oListSZ3:bLine:={|| {If(aListSZ3[oListSZ3:nAt,01],oOk,oNo),;
	aListSZ3[oListSZ3:nAt,02],;  
	aListSZ3[oListSZ3:nAt,03],;  
	aListSZ3[oListSZ3:nAt,04],;
	aListSZ3[oListSZ3:nAt,05],;
	aListSZ3[oListSZ3:nAt,06],;
	aListSZ3[oListSZ3:nAt,07],;
	aListSZ3[oListSZ3:nAt,08],;
	aListSZ3[oListSZ3:nAt,09],;
	aListSZ3[oListSZ3:nAt,10] }}

// seleciono as Etiquetas dos Produtos

dbSelectArea('SZ3')
dbSetOrder(1)
dbSeek(xFilial("SZ3"))
nRecZ3 := Recno()

// inicializo o vetor
aListSZ3 := Array(0)
Do While !Eof()
   If Z3_SITUACA # "COM"
      dbSkip()
      Loop
   EndIf      
//   REVER ESTA SITUACAO PARA QDO O RELATORIO PARA ETIQUETAS ESTIVER CONCLUIDO
//   VER SE VALE A PENA ESTE TIPO DE CONSISTENCIA   
//   If Z3_SITUACA == "COM" .And. Z3_ETQI == "N"
//      dbSkip()
//      Loop
//   EndIf  
   
   If Z3_NFENTRA < cNFDe .Or. Z3_NFENTRA > cNFAte 
      dbSkip()
      Loop
   EndIf   
   
   If Z3_CODPROD < cPrdDe .Or. Z3_CODPROD > cPrdAte 
      dbSkip()
      Loop
   EndIf   
   // carrego para o listbox os registros
   Aadd(aListSZ3,{lMark,;
        SZ3->Z3_CODETIQ,; 
        SZ3->Z3_LOTE,;  
		SZ3->Z3_NFENTRA,;
		SZ3->Z3_DATAENT,;
		SZ3->Z3_FORNECE,;
		SZ3->Z3_CODPROD,;
		SZ3->Z3_DESC,;
		SZ3->Z3_LOJAFOR,;
		SZ3->Z3_SERIENT } )
		
   dbSkip()
EndDo
If Len(aListSZ3) > 0 

	oBut4:SetEnable()
	
	oListSZ3:SetArray(aListSZ3)
	oListSZ3:bLine:={|| {If(aListSZ3[oListSZ3:nAt,01],oOk,oNo),;
			aListSZ3[oListSZ3:nAt,02],;   
			aListSZ3[oListSZ3:nAt,03],;
			aListSZ3[oListSZ3:nAt,04],;
			aListSZ3[oListSZ3:nAt,05],;
			aListSZ3[oListSZ3:nAt,06],;
			aListSZ3[oListSZ3:nAt,07],;
			aListSZ3[oListSZ3:nAt,08],;
			aListSZ3[oListSZ3:nAt,09],;
			aListSZ3[oListSZ3:nAt,10] }}		

	
	oListSZ3:Refresh()
	oPanSZ3:Show()
Else

   	Alert(Substr(cUsuario,7,13) + ", NAO Existem Etiquetas Geradas, ou NAO Foram Impressas. VERIFIQUE PARAMETROS !")
	
	aListSZ3 := {{lMark,Space(Len(SZ3->Z3_CODETIQ)),;  
	    Space(Len(SZ3->Z3_LOTE)),;
		Space(Len(SZ3->Z3_NFENTRA)),;
		Space(Len(DTOC(SZ3->Z3_DATAENT))),;
		Space(Len(SZ3->Z3_FORNECE)),;
		Space(Len(SZ3->Z3_CODPROD)),;
		Space(Len(SZ3->Z3_DESC)),;
	    Space(Len(SZ3->Z3_LOJAFOR)),;
	    Space(Len(SZ3->Z3_SERIENT)) }}
	
	oPanSZ3:Hide()
Endif

dbSelectArea('SZ3')
DbGoTo(nRecZ3)

ACTIVATE MSDIALOG oDlgSZ3 CENTERED

// retorna area original
RestArea(aArea)

Return(lOk)

/*--------------------------------------------------------------------------|
| Programa | SZTroca | Autor  |                                             |
|---------------------------------------------------------------------------|
| Desc.      | Seleciona no ListBox os itens desejados                   	|
|---------------------------------------------------------------------------|
| Uso         | Em conjunto com o programa JMHEST2A                         |
|---------------------------------------------------------------------------*/
Static Function SZTroca(nIt,aVetor)

Local nVet := 0

aVetor[nIt,1] := !aVetor[nIt,1]
If aVetor[nIt,1]
	oBut1:SetEnable() 
	oBut3:SetEnable()
Else
	oBut1:SetDisable()
	oBut3:SetDisable()
	For nVet := 1 To Len(aVetor)
		If aVetor[nVet,1]
			oBut1:SetEnable()
			oBut3:SetEnable()
			Exit
		Endif
	Next
Endif

Return(aVetor)

/*-------------------------------------------------------------------------------|
| Programa  | VEtqZ3Conf | Autor  | 											 |
|--------------------------------------------------------------------------------|
| Desc.     |  Permite a Confirmacao das Etiquetas                         		 |
|--------------------------------------------------------------------------------*/
Static Function VEtqZ3Conf(aListSZ3)

Local nLista := 0
Local nPos   := 0
Local lOK    := .F.

For nLista  := 1 To Len(aListSZ3)
	If aListSZ3[nLista,1]
	   
	   lOK := .T.
	   
	   dbSelectArea('SZ3')
	   dbSetOrder(1)
	   dbSeek(xFilial("SZ3")+aListSZ3[nLista,2])
	   RecLock("SZ3",.F.)
	        SZ3->Z3_SITUACA := "EST"
	        SZ3->Z3_ETQL    := "S"
       MsUnLock("SZ3")
       
       dbSelectArea('SZ7')
	   dbSetOrder(1)
	   RecLock("SZ7",.T.)  
	        SZ7->Z7_FILIAL  := xFilial("SZ7")
	        SZ7->Z7_TIPO    := "E"    
	        SZ7->Z7_SITUACA := "COM"
	        SZ7->Z7_CODETIQ := aListSZ3[nLista,2]
	        SZ7->Z7_NFISCAL := aListSZ3[nLista,4]  
	        SZ7->Z7_SERIE   := aListSZ3[nLista,10] 
	        SZ7->Z7_DATA    := aListSZ3[nLista,5]
	        SZ7->Z7_CLIFOR  := aListSZ3[nLista,6] 
	        SZ7->Z7_LOJACF  := aListSZ3[nLista,9]
       MsUnLock("SZ7")

	EndIf
Next
                     
For nLista := 1 To Len(aListSZ3)
	If aListSZ3[nLista-nPos,1]
	   ADEL(aListSZ3,nLista-nPos)
	   nPos += 1
	Endif
Next
ASIZE(aListSZ3,Len(aListSZ3)-nPos) 

If Len(aListSZ3) == 0 

	oBut1:SetDisable()
	oPanSZ3:Hide()
	
Else
	oBut1:SetDisable()

	oListSZ3:SetArray(aListSZ3)
	oListSZ3:bLine:={|| {If(aListSZ3[oListSZ3:nAt,01],oOk,oNo),;
			aListSZ3[oListSZ3:nAt,02],;   
			aListSZ3[oListSZ3:nAt,03],;
			aListSZ3[oListSZ3:nAt,04],;
			aListSZ3[oListSZ3:nAt,05],;
			aListSZ3[oListSZ3:nAt,06],;
			aListSZ3[oListSZ3:nAt,07],;
			aListSZ3[oListSZ3:nAt,08],;
			aListSZ3[oListSZ3:nAt,09],;
			aListSZ3[oListSZ3:nAt,10] }}		

	
	oListSZ3:Refresh()
	oPanSZ3:Show()
	
Endif

Return(lOk)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ 										  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)

//          Grupo/Ordem/Pergunta/                     Variavel/Tipo/Tam               /Dec/Pres/GSC/Valid/  Var01/    Def01___/Cnt01/  Var02/Def02___/Cnt02/ Var03/Def03___/Cnt03/ Var04/Def04___/Cnt04/ Var05/Def05___/Cnt05/F3
aAdd(aRegs,{cPerg,"01","N.Fiscal Inicial .:","","",   "mv_ch1","C",TamSx3("F1_DOC")[1],  0, 0,  "G", "",   "MV_PAR01", "","","","",     "",   "","","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",   "SF1"})
aAdd(aRegs,{cPerg,"02","N.Fiscal Final ...:","","",   "mv_ch2","C",TamSx3("F1_DOC")[1],  0, 0,  "G", "",   "MV_PAR02", "","","","",     "",   "","","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",   "SF1"})
aAdd(aRegs,{cPerg,"03","Produto Inicial ..:","","",   "mv_ch3","C",TamSx3("B1_COD")[1],  0, 0,  "G", "",   "MV_PAR03", "","","","",     "",   "","","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",   "SB1"})
aAdd(aRegs,{cPerg,"04","Produto Final ....:","","",   "mv_ch4","C",TamSx3("B1_COD")[1],  0, 0,  "G", "",   "MV_PAR04", "","","","",     "",   "","","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",   "SB1"})

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

/*-----------------------------------------------------------------------------------------------------------------------------------------|
| Programa  | SeleItens | Autor | Reiner Trennepohl                                      | Data |  23/12/2002 |
|------------------------------------------------------------------------------------------------------------------------------------------|
| Desc.        | Permite a selecao das Etiquetas para o Estoque                                             |
|------------------------------------------------------------------------------------------------------------------------------------------|
| Uso           | Em conjunto com o programa JMHEST02.PRW                   |
|-----------------------------------------------------------------------------------------------------------------------------------------|*/
Static Function SeleItens(aVetor,lMark)

If lMark
   oBut1:SetEnable()
   oBut3:SetEnable() 
   oBut4:SetDisable()
Else
   oBut1:SetDisable() 
   oBut4:SetEnable() 
   oBut3:SetDisable()
EndIf

For nLista := 1 To Len(aVetor)
	aVetor[nLista,1] := lMark
Next   

oListSZ3:SetArray(aListSZ3)
	oListSZ3:bLine:={|| {If(aListSZ3[oListSZ3:nAt,01],oOk,oNo),;
			aListSZ3[oListSZ3:nAt,02],;   
			aListSZ3[oListSZ3:nAt,03],;
			aListSZ3[oListSZ3:nAt,04],;
			aListSZ3[oListSZ3:nAt,05],;
			aListSZ3[oListSZ3:nAt,06],;
			aListSZ3[oListSZ3:nAt,07],;
			aListSZ3[oListSZ3:nAt,08],;  
			aListSZ3[oListSZ3:nAt,09],;
			aListSZ3[oListSZ3:nAt,10] }}		

	
    oListSZ3:Refresh()
	oPanSZ3:Show()

Return
