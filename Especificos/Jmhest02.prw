//--------------------------------------------------------------------------------------------------------|
//| Funcao   | JMHEST02 | 																			      |  
//|-------------------------------------------------------------------------------------------------------|
//| Descricao| Funcao customizada para Controle e Visualizacao do Produtos com Etiqueta                   |
//|-------------------------------------------------------------------------------------------------------|
//|-------------------------------------------------------------------------------------------------------|
#include "protheus.CH"
#include "sigawin.ch"

User Function JMHEST02()
Local aArea := GetArea()
Local aCor  := { {"U_A002BtCz()", "BR_CINZA"},;    // DEV TERCEIROS
			     {"U_A002BtVd()", "BR_VERDE"},;    // ESTOQUE 
                 {"U_A002BtAm()", "BR_AMARELO"},;  // TERCEIROS 
                 {"U_A002BtVe()", "BR_VERMELHO"},; // FATURADO  
                 {"U_A002BtAz()", "BR_AZUL"},;     // DEV FATURADO
                 {"U_A002BtPt()", "BR_PRETO"},;    // COMPRA NAO CONFIRMADO
                 {"U_A002BtMr()", "BR_MARRON"},;   // DEV COMPRA	
                 {"U_A002BtRx()", "BR_PINK"} }     // ETIQUETA RESERVADA
                       
PRIVATE cCadastro := OemToAnsi("Atualizacao das Etiquetas X Produto") 


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Define Array contendo as Rotinas a executar do programa      
| ----------- Elementos contidos por dimensao ---------------------------------------------------------------------------------------------------------
| 1. Nome a aparecer no cabecalho                              
| 2. Nome da Rotina associada                                  
| 3. Usado pela rotina                                         
| 4. Tipo de Transacao a ser efetuada                          
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 1 - Pesquisa e Posiciona em um Banco de Dados             
| 2 - Simplesmente Mostra os Campos                         
| 3 - Apenas Referencia de Menu           
| 4 - Atualizacao das Etiquetas
| 5 - Relatorios
| 6 - Informativo, Legenda
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

Private aRotina := { { 'Pesquisar'     ,"AxPesqui"   , 0 , 1 },;   //"Pesquisar"
					 { 'Visualizar'    ,"U_JMHEST2v" , 0 , 2 },;   //"Visualizar" 
					 { 'Incluir'       ,"U_JMHEST2i" , 0 , 3 },;   //"Incluir"
					 { 'Alterar'       ,"U_JMHEST2a" , 0 , 4 },;   //"Alterar"
				   	 { 'Confirmar'     ,"U_JMHEST2c" , 0 , 6 },;   //"Confirmacao e Etiquetagem do Produto na Compra"
	              	 { 'Imp.Historico' ,"U_JMHEST2d" , 0 , 8 },;   //"Localizacao"
	              	 { 'Imp.Etiqueta'  ,"U_CODBAR01" , 0 , 9 },;   //"Imp. Etiquetas"
	              	 { 'Legenda'       ,"U_JMH02Leg" , 0 ,10 } }   //"Legenda das Cores"
	              	 
dbSelectArea("SZ3")
dbSetOrder(9)   // Situacao + Cod Etiqueta
                // Passar p/indice (14) --> novo ==> Situacao + Cod Etiqueta
dbSeek(xFilial("SZ3"))

mBrowse( 6, 1,22,75,"SZ3",,,,,,aCor)   

RestArea(aArea)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³JMHEST02V³ Autor ³ Reiner Trennepohl    ³ Data ³   25/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa para visualizacao das Etiquetas/Produtos e suas   ³±±
±±³          ³ movimentacoes											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void JMHEST02V(ExpC1,ExpN1,,)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function JMHEST2V(cAlias,nReg,nOpc)

Local nRecAlias:= 0
Local nOpcA    := 0
Local bCampo   := { |nCPO| Field(nCPO) }
Local aCpos1   := {}
Local aCpos2   := {}
Local lContinua:= .T.
Local nUsado   := 0
Local nCntFor  := 0
Local aBackRot := aClone(aRotina)
Local cArqMov  := ""
Local oGetd
//Local oSAY1
//Local oSAY2
//Local oSAY3
//Local oSAY4
Local oDlg
Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local nGetLin  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a Variaveis Privates.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTELA[0][0],aGETS[0]
PRIVATE 	cSavScrVT,;
  			cSavScrVP,;
  			cSavScrHT,;
  			cSavScrHP,;
  			CurLen,;
  			nPosAtu:=0,;
  			nPosAnt:=9999,;
  			nColAnt:=9999
PRIVATE aCols		:= {}
PRIVATE aHeader	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a Variaveis da Enchoice.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
nRecAlias := RecNo()
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa desta forma para criar uma nova instancia de variaveis private ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "SZ3", .F., .F. )
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZ7")
Do While ( !Eof() .And. (SX3->X3_ARQUIVO == "SZ7") )
 	If ( X3USO(SX3->X3_USADO) .And. !(	Trim(SX3->X3_CAMPO) == "Z7_CODETIQ" ) .AND.;
 		cNivel >= SX3->X3_NIVEL )
  		nUsado++
  		Aadd(aHeader,{ TRIM(X3Titulo()),;
  							SX3->X3_CAMPO,;
  							SX3->X3_PICTURE,;
                            SX3->X3_TAMANHO,;
  							SX3->X3_DECIMAL,;
  							SX3->X3_VALID,;
  							SX3->X3_USADO,;
  							SX3->X3_TIPO,;
  							SX3->X3_ARQUIVO,;
  							SX3->X3_CONTEXT } )
 	EndIf
 	
  	dbSelectArea("SX3")
  	dbSkip()
EndDo

  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aCols                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ7")
dbSetOrder(1)   // filial + etiqueta + data + situacao
dbSeek(xFilial("SZ7")+SZ3->Z3_CODETIQ)
Do While ( !Eof() .And. SZ3->Z3_FILIAL == xFilial("SZ7") .And.;
    SZ7->Z7_CODETIQ	== SZ3->Z3_CODETIQ )
	AADD(aCols,Array(Len(aHeader)))
    For nCntFor:=1 To Len(aHeader)
	    If ( aHeader[nCntFor,10] !=  "V" )
			aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
		Else
			aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
		EndIf
	Next nCntFor

  	dbSelectArea("SZ7")
  	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso nao ache nenhum item , abandona rotina.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Len(aCols) == 0 )
 	Alert(Substr(cUsuario,7,13) + ", näo encontrei os históricos das movimentaçöes desta Etiquetas! Verifique o que houve.")
  	lContinua := .F.
EndIf
If ( lContinua )
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Faz o calculo automatico de dimensoes de objetos     ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	aSize := MsAdvSize()
  
  	aObjects := {}
 	AAdd( aObjects, { 100, 100, .t., .t. } )
  	AAdd( aObjects, { 100, 100, .t., .t. } )
 	AAdd( aObjects, { 100, 015, .t., .f. } )
  
  	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
  	aPosObj := MsObjSize( aInfo, aObjects )
  
  	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
  			{{003,033,160,200,240,260}} )
  
 	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
  	EnChoice( cAlias, nReg, nOpc, , , , , aPosObj[1],aCpos2, 3 )
/*  
  	nGetLin := aPosObj[3,1]
  	nGetCol := aPosObj[3,2]
  
	@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(M->Z3_TIPO$"DB","Fornec.:","Cliente: ")) SIZE 020,09 PIXEL	//"Fornec.:"###"Cliente: "
	@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!" OF oDlg PIXEL
	@ nGetLin,aPosGet[1,3]  SAY OemToAnsi("Total :")						SIZE 020,09 OF oDlg PIXEL	//"Total :"
	@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,2)		SIZE 040,09 OF oDlg  PIXEL
	@ nGetLin,aPosGet[1,5]  SAY OemToAnsi("Desc. :")						SIZE 020,09 OF oDlg PIXEL	//"Desc. :"
	@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,2)		SIZE 040,09 OF oDlg PIXEL
	@ nGetLin+10,aPosGet[1,5]  SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
	@ nGetLin+10,aPosGet[1,6]  SAY oSAY4 VAR 0								SIZE 040,09 PICTURE TM(0,16,2) OF oDlg PIXEL
	oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
								  oSay2:SetText(n2),;
								  oSay3:SetText(n3),;
								  oSay4:SetText(n4) }
*/									
  	oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,"",,aCpos1,1,,"")
   
// 	JMHEst2Rodap(oGetd)
 
	ACTIVATE MSDIALOG oDlg ON INIT JEst2Bar(oDlg,{||nOpcA:=1,if(oGetd:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},nOpc,cAlias,nReg)

EndIf

aRotina := aClone(aBackRot)

dbSelectArea(cAlias) 
dbGoTo(nRecAlias)

Return( nOpcA )


/////////////////////////////////////

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³JMHEST2i³ Autor ³ Reiner Trennepohl   ³ Data ³  27/02/04    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa exclusivo para inclusao no JMHEST02               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void JMHEST2i(ExpC1,ExpN1,,)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function JMHEST2i(cAlias,nReg,nOpc)

Local nRecAlias:= 0
Local nOpcA    := 0
Local lGravaOk := .T.
Local nCntFor  := 0
Local aCodigos := ""
Local oCodBarra  
Local bCampo	:= { |nCPO| Field(nCPO) }
Local cCampo   :=	""
//Local cCadastro := OemToAnsi("Atualizacao das Etiquetas X Produto") 
Local nUsado	:= 0
Local lContinua := .T.
Local oDlg
Local oGetD
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aPosGet   := {}
Local nGetLin   := 0
Local bBloco
//Local oSAY1
//Local oSAY2
//Local oSAY3
//Local oSAY4
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTela[0][0]
PRIVATE aGets[0]
PRIVATE cSavScrVT
PRIVATE cSavScrVP
PRIVATE cSavScrHT
PRIVATE cSavScrHP
PRIVATE CurLen   
PRIVATE nPosAtu	:=0
PRIVATE nPosAnt	:=9999
PRIVATE nColAnt	:=9999
PRIVATE bArqF3
PRIVATE bCpoF3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a integridade dos campos de Bancos de Dados    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
nRecAlias := RecNo()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa desta forma para criar uma nova instancia de variaveis private ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "SZ3", .T., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a integridade dos campos de Bancos de Dados    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aHeader[0]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aHeader                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZ7")
Do While ( !Eof() .And. (SX3->X3_ARQUIVO == "SZ7") )
 	If ( X3USO(SX3->X3_USADO) .And. !(	Trim(SX3->X3_CAMPO) == "Z7_CODETIQ" ) .AND.;
 		cNivel >= SX3->X3_NIVEL )
  		nUsado++
  		Aadd(aHeader,{ TRIM(X3Titulo()),;
  							SX3->X3_CAMPO,;
  							SX3->X3_PICTURE,;
                            SX3->X3_TAMANHO,;
  							SX3->X3_DECIMAL,;
  							SX3->X3_VALID,;
  							SX3->X3_USADO,;
  							SX3->X3_TIPO,;
  							SX3->X3_ARQUIVO,;
  							SX3->X3_CONTEXT } )
 	EndIf
 	
  	dbSelectArea("SX3")
  	dbSkip()
EndDo         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aCols                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aColsX := {}
PRIVATE aCols[1][nUsado+1]
For nCntFor	:= 1 To nUsado
	aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
Next nCntFor
aCols[1][Len(aHeader)+1] := .F. 
aadd(aColsX, 0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize    := MsAdvSize()
aObjects := {}

aAdd( aObjects, { 100, 100, .t., .t. } )
aAdd( aObjects, { 100, 100, .t., .t. } )
aAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1], 315, {{003,033,160,200,240,260}} )

nGetLin := aPosObj[3,1]

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

EnChoice( "SZ3", nReg, nOpc, , , , , aPosObj[1], , 3 )

/*
  		@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(ALLTRIM(M->Z3_SERIENT)=="U",STR0008,STR0009)) SIZE 020,09 PIXEL	//"Fornec.:"###"Cliente: "
  		@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!"	OF oDlg PIXEL
  		@ nGetLin,aPosGet[1,3]  SAY OemToAnsi(STR0011)						SIZE 020,09 OF oDlg	PIXEL //"Total :"
 		@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,2)		SIZE 040,09 OF oDlg PIXEL
  		@ nGetLin,aPosGet[1,5]  SAY OemToAnsi(STR0012)						SIZE 020,09 OF oDlg PIXEL	//"Desc. :"
	    @ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,2)		SIZE 040,09 OF oDlg PIXEL
  		@ nGetLin+10,aPosGet[1,5]  SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
 	    @ nGetLin+10,aPosGet[1,6]  SAY oSAY4 VAR 0								SIZE 040,09 PICTURE TM(0,16,2) OF oDlg PIXEL
  		oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
									oSay2:SetText(n2),;
									oSay3:SetText(n3),;
									oSay4:SetText(n4) }
*/  		

oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_JEST2LINOK","U_JEst2TudOk","",.T.,,1,,)    

Private oGetDad:=oGetd

// JMHEst2Rodap(oGetd)
  
ACTIVATE MSDIALOG oDlg ON INIT JEst2Bar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()},nOpc,cAlias,nReg)
//ACTIVATE MSDIALOG oDlg ON INIT JEst2Bar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),If(!obrigatorio(aGets,aTela),nOpcA:=0,oDlg:End()),nOpcA:=0)},{||oDlg:End()},nOpc,cAlias,nReg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a Gravacao do Pedido de Venda                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nOpcA == 1 )
   U_JEST2Grava(cAlias,bCampo,nOpc)  
   If ( __lSX8 )
	  ConfirmSX8()
   EndIf
   EvalTrigger()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Integridade da Tela de Entrada                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbGoto(nRecAlias)
  
Return( nOpcA )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³JMHEST2a³ Autor ³ Reiner Trennepohl   ³ Data ³  01/03/04    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa exclusivo ao JMHEST02 para alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void JMHEST2a(ExpC1,ExpN1)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ JMHEST02                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JMHEST2a(cAlias,nReg,nOpc)

Local nRecAlias := 0
Local bCampo	:= { |nCPO| Field(nCPO) }
Local nOpcA		:= 0
Local lPasw
Local lGravaOk	:=.T.
Local cCampo	:=""
Local lContinua:= .T.
Local nEl		:= 0
Local nUsado   := 0
Local nCntFor  := 0
Local oDlg
Local oGetd
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aPosGet   := {}
Local nGetLin   := 0
Local bBloco       

// lPsw := U_JEst2Psw()

//If !lPsw
//   Return
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na LinhaOk                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aColsX  := {}
PRIVATE aCols   := {}
PRIVATE aHeader := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTELA[0][0],aGETS[0]
PRIVATE cSavScrVT,;
		cSavScrVP,;
		cSavScrHT,;
		cSavScrHP,;
		CurLen,;
		nPosAtu:=0,;
		nPosAnt:=9999,;
		nColAnt:=9999

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a integridade dos campos de Bancos de Dados    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
If !SoftLock(cAlias)
 	lContinua := .F.
EndIf                                                     
nRecAlias := RecNo()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a Variaveis da Enchoice.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa desta forma para criar uma nova instancia de variaveis private ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "SZ3", .F., .F. )
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aHeader                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZ7")
Do While ( !Eof() .And. (SX3->X3_ARQUIVO == "SZ7") )
 	If ( X3USO(SX3->X3_USADO) .And. !(	Trim(SX3->X3_CAMPO) == "Z7_CODETIQ" ) .AND.;
 		cNivel >= SX3->X3_NIVEL )
  		nUsado++
  		Aadd(aHeader,{ TRIM(X3Titulo()),;
  							SX3->X3_CAMPO,;
  							SX3->X3_PICTURE,;
                            SX3->X3_TAMANHO,;
  							SX3->X3_DECIMAL,;
  							SX3->X3_VALID,;
  							SX3->X3_USADO,;
  							SX3->X3_TIPO,;
  							SX3->X3_ARQUIVO,;
  							SX3->X3_CONTEXT } )
 	EndIf
 	
  	dbSelectArea("SX3")
  	dbSkip()
EndDo         

If ( lContinua )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aCols                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SZ7")
	dbSetOrder(1)
	dbSeek(xFilial("SZ7")+SZ3->Z3_CODETIQ)
	Do While (!Eof().And.SZ3->Z3_FILIAL==xFilial("SZ7").And.SZ7->Z7_CODETIQ==SZ3->Z3_CODETIQ)
	    AADD(aCols,Array(Len(aHeader)+1)) 
	    AADD(aColsX, RecNo())
	    For nCntFor:=1 To Len(aHeader)
		    If ( aHeader[nCntFor,10] !=  "V" )
				aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
			Else
				aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
			EndIf
		Next nCntFor 
      	aCols[Len(aCols)][Len(aHeader)+1] := .F. 
      	
	  	dbSelectArea("SZ7")
	  	dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso nao ache nenhum item , abandona rotina.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lContinua )
   If ( Len(aCols) == 0 )
  		lContinua := .F.
 		Alert(Substr(cUsuario,7,13) + ", näo encontrei os históricos das movimentaçöes desta Etiquetas! Verifique o que houve.")
   Endif
EndIf
If ( lContinua )

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Faz o calculo automatico de dimensoes de objetos     ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,260}} )
	nGetLin := aPosObj[3,1]
	
 	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
 		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  		//³ Armazenar dados do Pedido anterior.                  ³
  		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  		EnChoice( "SZ3", nReg, nOpc, , , , , aPosObj[1], , 3 )
/* 		
       // SAO OS DADOS DO RODAPE DA ENCHOICE
  		@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(M->C5_TIPO$"DB",STR0008,STR0009)) SIZE 020,09 PIXEL	//"Fornec.:"###"Cliente: "
  		@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!"	OF oDlg PIXEL
  		@ nGetLin,aPosGet[1,3]  SAY OemToAnsi(STR0011)						SIZE 020,09 OF oDlg PIXEL	//"Total :"
	    @ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,2)		SIZE 040,09 OF oDlg PIXEL
  		@ nGetLin,aPosGet[1,5]  SAY OemToAnsi(STR0012)						SIZE 020,09 OF oDlg PIXEL 	//"Desc. :"
	    @ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,2)		SIZE 040,09 OF oDlg PIXEL
  		@ nGetLin+10,aPosGet[1,5]  SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
	    @ nGetLin+10,aPosGet[1,6]  SAY oSAY4 VAR 0								SIZE 040,09 PICTURE TM(0,16,2) OF oDlg PIXEL
	    
  		oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
									oSay2:SetText(n2),;
									oSay3:SetText(n3),;
									oSay4:SetText(n4) }                                                                                                                                                       
*/									
 		oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_JEst2LinOk","U_JEst2TudOk","",.T.,,1,,)

  		Private oGetDad:=oGetd

       // 	JMHEst2Rodap(oGetd)
    ACTIVATE MSDIALOG oDlg ON INIT JEst2Bar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},nOpc,cAlias,nReg)   
       
EndIf

If ( nOpcA == 1 )
    U_JEST2Grava(cAlias,bCampo,nOpc)  
    EvalTrigger()
EndIf

dbSelectArea(cAlias)
dbGoTo(nRecAlias)
     
Return( nOpcA )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³JEST2Grava³ Autor ³ Reiner Trennepohl ³ Data ³  01/03/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa exclusivo ao JMHEST02 para alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void JEST2Grava(ExpC1,ExpN1)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ JMHEST02                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function JEST2Grava(cAlias,bCampo,nOpc) 

Local nMaxArray := Len(aCols)  
Local nQuant    := M->Z3_QTDPROD 
Local cCodEtq   := M->Z3_CODETIQ 
Local cLote     := M->Z3_LOTE
Local cCodPrd   := M->Z3_CODPROD
Local cDesc     := M->Z3_DESC
Local cNFEnt    := M->Z3_NFENTRA
Local cSerEnt   := M->Z3_SERIENT
Local dDatEnt   := M->Z3_DATAENT
Local cFornec   := M->Z3_FORNECE
Local cLojaF    := M->Z3_LOJAFOR
Local cNFSai    := M->Z3_NFSAIDA
Local cIteNFS   := M->Z3_ITEMNFS
Local cSerSai   := M->Z3_SERISAI
Local dDatSai   := M->Z3_DATASAI
Local cClient   := M->Z3_CLIENTE
Local cLojaC    := M->Z3_LOJACLI
Local cSituac   := M->Z3_SITUACA
Local cPedVen   := M->Z3_PEDIDOV
Local cIteVen   := M->Z3_ITEMPV
Local cEtqRep   := M->Z3_ETQREP 
Local cEtqI     := M->Z3_ETQI

Begin Transaction
	lAppEnd := If (nOpc == 3,.t.,.f.)
	RecLock(cAlias,lAppEnd)
	For i := 1 TO FCount()
		If "_FILIAL"$Field(i)
			FieldPut(i,xFilial(cAlias))
		ElseIf "__QTDPROD"$Field(i)
			FieldPut(i,1)
	    Else
	       	FieldPut(i,M->&(Eval(bCampo,i)))
		EndIf
	Next i
End Transaction

  
/*
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ atualiza os dados da Etiqueta - Cabecalho 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      
dbSelectArea(cAlias)  // cabecalho das Etiquetas
DbGoTop()            // Para prevenir um problema de Lock 
dbSetOrder(1)    
If nOpc == 3   //  inclusao
   RecLock("SZ3",.T.)
   SZ3->Z3_FILIAL  := xFilial("SZ3")
   SZ3->Z3_CODETIQ := cCodEtq
   SZ3->Z3_QTDPROD := 1
   SZ3->Z3_ETQL    := "S"   
Else 
   RecLock("SZ3",.F.) // Alteracao
EndIf   
SZ3->Z3_LOTE    := cLote
SZ3->Z3_CODPROD := cCodPrd
SZ3->Z3_DESC    := cDesc  
SZ3->Z3_NFENTRA := cNFEnt 
SZ3->Z3_SERIENT := cSerEnt 
SZ3->Z3_DATAENT := dDatEnt 
SZ3->Z3_FORNECE := cFornec 
SZ3->Z3_LOJAFOR := cLojaF
SZ3->Z3_NFSAIDA := cNFSai 
SZ3->Z3_ITEMNFS := cIteNFS 
SZ3->Z3_SERISAI := cSerSai 
SZ3->Z3_DATASAI := dDatSai 
SZ3->Z3_CLIENTE := cClient 
SZ3->Z3_LOJACLI := cLojaC 
SZ3->Z3_SITUACA := cSituac 
SZ3->Z3_PEDIDOV := cPedVen
SZ3->Z3_ITEMPV  := cIteVen 
SZ3->Z3_ETQI    := "S"
SZ3->Z3_ETQREP  := cEtqRep    
MsUnLock("SZ3")   

*/

dbSelectArea("SZ7")  // Historico das Etiquetas
DbGoTop()            // Para prevenir um problema de Lock 
dbSetOrder(1)  

For nx := 1 to nMaxArray 

	If ValType(aCols[nx][Len(aCols[nx])]) == "L"
		If aCols[nx][Len(aCols[nx])] // se Linha deletada
		   If nOpc == 4 .And. nx <= Len(aColsX) // Alteracao
              dbGoTo(aColsX[nx]) 
		      RecLock("SZ7",.F.) // Deletar
		         dbDelete()
		      MsUnLock("SZ7")
		   EndIf   
		   Loop
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ verifica se deve adicionar ou regravar                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nOpc == 3   // Inclusao
       RecLock("SZ7",.T.) // Inclusao
       SZ7->Z7_FILIAL  := xFilial("SZ7")
	   SZ7->Z7_CODETIQ := cCodEtq
    Else  // Alteracao  
       If nx <= Len(aColsX)
          dbGoTo(aColsX[nx])
          RecLock("SZ7",.F.) 
       Else // Inclusao de uma linha no acols 
          RecLock("SZ7",.T.) 
          SZ7->Z7_FILIAL  := xFilial("SZ7")
	      SZ7->Z7_CODETIQ := cCodEtq
       EndIf
    EndIf   
    SZ7->Z7_TIPO    := aCols[nx][1]
    SZ7->Z7_NFISCAL := aCols[nx][2]
    SZ7->Z7_SERIE   := aCols[nx][3]
    SZ7->Z7_DATA    := aCols[nx][4]  
    SZ7->Z7_SITUACA := aCols[nx][5]
    SZ7->Z7_ETQREP  := aCols[nx][6]
    SZ7->Z7_PEDIDO  := aCols[nx][7]
    SZ7->Z7_ITEMPV  := aCols[nx][8]
    SZ7->Z7_CLIFOR  := aCols[nx][9]
    SZ7->Z7_LOJACF  := aCols[nx][10]
    MsUnLock("SZ7") 	        	
Next
            
If nQuant > 1  // So pode ter qtd maior que 1 qdo for inclusao de um etiqueta 
   nQuant -= 1 // na alteracao o campo qtd nao esta disponivel

   For xy := 1 To nQuant
          
       cCodEtq := Soma1(cCodEtq,Len(SZ3->Z3_CODETIQ))
             
       RecLock("SZ3",.T.)
            SZ3->Z3_FILIAL  := xFilial("SZ3")
	        SZ3->Z3_CODETIQ := cCodEtq
	        SZ3->Z3_CODPROD := cCodPrd  
	        SZ3->Z3_LOTE    := cLote
	        SZ3->Z3_DESC    := cDesc  
	        SZ3->Z3_NFENTRA := cNFEnt 
	        SZ3->Z3_SERIENT := cSerEnt 
	        SZ3->Z3_DATAENT := dDatEnt 
	        SZ3->Z3_FORNECE := cFornec 
	        SZ3->Z3_LOJAFOR := cLojaF
	        SZ3->Z3_NFSAIDA := cNFSai 
	        SZ3->Z3_ITEMNFS := cIteNFS 
	        SZ3->Z3_SERISAI := cSerSai 
	        SZ3->Z3_DATASAI := dDatSai 
	        SZ3->Z3_CLIENTE := cClient 
	        SZ3->Z3_LOJACLI := cLojaC 
	        SZ3->Z3_SITUACA := cSituac 
	        SZ3->Z3_PEDIDOV := cPedVen
	        SZ3->Z3_ITEMPV  := cIteVen 
	        SZ3->Z3_ETQI    := "S"
	        SZ3->Z3_ETQL    := "S"  
	        SZ3->Z3_ETQREP  := cEtqRep  
	        SZ3->Z3_QTDPROD := 1   
       MsUnLock("SZ3")    
       
       dbSelectArea("SZ7")  // Historico das Etiquetas
	   DbGoTop()            // Para prevenir um problema de Lock 
       dbSetOrder(1)  

       For nx := 1 to nMaxArray 
    
	       If ValType(aCols[nx][Len(aCols[nx])]) == "L"
		      If !aCols[nx][Len(aCols[nx])] 

                 RecLock("SZ7",.T.) // Inclusao
                    SZ7->Z7_FILIAL  := xFilial("SZ7")
	                SZ7->Z7_CODETIQ := cCodEtq
   					SZ7->Z7_TIPO    := aCols[nx][1]
				    SZ7->Z7_NFISCAL := aCols[nx][2]
				    SZ7->Z7_SERIE   := aCols[nx][3]
				    SZ7->Z7_DATA    := aCols[nx][4]  
				    SZ7->Z7_SITUACA := aCols[nx][5]
				    SZ7->Z7_ETQREP  := aCols[nx][6]
				    SZ7->Z7_PEDIDO  := aCols[nx][7]
				    SZ7->Z7_ITEMPV  := aCols[nx][8]
				    SZ7->Z7_CLIFOR  := aCols[nx][9]
				    SZ7->Z7_LOJACF  := aCols[nx][10]
				 MsUnLock("SZ7") 	        	
				 
			  EndIf	 
		   EndIf  
       Next
   Next
EndIf                     

If nOpc == 3   // Inclusao   
   dbSelectArea("SX6")  
   dbSeek("  MV_SEQETIQ")
   RecLock("SX6",.F.)
	 SX6->X6_Conteud := SZ3->Z3_CODETIQ
   MsUnLock("SX6") 
EndIf
    
Return                  


/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A002Bt?? ³ Autor ³                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Que Determina o Status dos Titulos                  ³±±
±±³          ³ A002BtCz - Cinza       - Devolucao em Terceiro             ³±±
±±³          ³ A002BtVd - Verde       - Etiqueta em Estoque                ³±±
±±³          ³ A002BtAm - Amarelo     - Etiqueta em Terceiro               ³±±
±±³          ³ A002BtAz - Azul        - Devolucao Faturado                ³±±
±±³          ³ A002BtVe - Vermelho    - Etiqueta Faturada                  ³±±
±±³          ³ A002BtMr - Marrom      - Devolucao Compra                  ³±±
±±³          ³ A002BtPt - Preto       - Etiqueta em Estoque, NAO Comfirmado³±±
±±³          ³ A002BtRx - Roxo        - Etiqueta Reservada                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A002Bt??()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso Original ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function A002BtVd()    // Verde  

Local lRet:=.F.
If SZ3->Z3_SITUACA == "EST"   // em ESToque
	lRet := .T.
EndIf
Return lRet

User Function A002BtCz()    // Cinza
Local lRet:=.F.
If SZ3->Z3_SITUACA == "DVT"   // Devolucao de terceiros - CONsignado
	lRet := .T.
EndIf
Return lRet

User Function A002BtAm()    // amarelo
Local lRet:=.F.
If SZ3->Z3_SITUACA == "CON"   // em Terceiros 
   lRet := .t.
EndIf
Return lRet

User Function A002BtAz()    // Azul
Local lRet
If SZ3->Z3_SITUACA == "DVF"  // Devolucao FATurado
   lRet := .t.
EndIf
Return lRet                         

User Function A002BtVe()    // Vermelho
Local lRet:=.F.
If SZ3->Z3_SITUACA == "FAT"   // Faturado 
	lRet := .T.
EndIf
Return lRet

User Function A002BtPt()    // preto
Local lRet:=.F.
If SZ3->Z3_SITUACA == "COM"  // COMpra p/estoque s/confirmacao da etiqueta
	lRet := .T.
EndIf
Return lRet

User Function A002BtMr()    // Marrom
Local lRet:=.F.
If SZ3->Z3_SITUACA == "DVC"   // DeVolucao Compra -- Nota de Saida
	lRet := .T.
EndIf
Return lRet   

User Function A002BtRx()    // Roxo
Local lRet:=.F.
If SZ3->Z3_SITUACA == "RES"   // Etiqueta REServada em Pedido
	lRet := .T.
EndIf
Return lRet

/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JMH02Leg ³ Autor ³                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que mostra a legenda de cores do browse com suas    ³±±
±±³          ³ descricoes.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function JMH02LEG()

aCores2 := { { 'BR_VERDE',    "Etiqueta em Estoque - EST" },;
			 { 'BR_AMARELO',  "Etiqueta em Terceiros - CON" },;
		 	 { 'BR_CINZA',    "Devolucao Etiqueta em Terceiros - DVT" },;
			 { 'BR_VERMELHO', "Etiqueta Faturada - FAT" },;
			 { 'BR_AZUL',     "Devolucao Etiqueta Faturada - DVF" },;
			 { 'BR_PRETO',    "Compra - Confirmar Etiqueta - COM"},;
			 { 'BR_MARRON',   "Devolucao Etiqueta Comprada - DVC" },;
			 { 'BR_PINK',     "Etiqueta Reservada -  RES"}  }

BrwLegenda(cCadastro,"Legenda do Browse",aCores2)

Return 

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³JEST2LINOK ³ Autor ³ Reiner Trennepohl   ³ Data ³27/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consistencia para mudanca/inclusao de linhas de pedidos    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ExpN1 = JEST2LINOK                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Valor devolvido pela fun‡„o                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function JEST2LINOK(o)

Local nCntFor  := 0
Local lRetorno := .T.
Local nUsado   := Len(aHeader)
Local cSituaca := aCols[n][5] 
Local oDlg

oDlg := o:oWnd

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se linha do acols foi preenchida            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( !CheckCols(n,aCols) )
  	lRetorno := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Caso o item nao esteja deletado                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( !aCols[n][Len(aCols[n])] .And. lRetorno )
  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³Verifica se os campos obrigatorios nao estao em branco                  ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	For nCntFor := 1 To nUsado
  	
  		If ( Empty(aCols[n][nCntFor]) )
  			If ( lRetorno .And. cSituaca$"FAT/CON/DVC" )
  				If ( AllTrim(aHeader[nCntFor][2]) == "Z7_NFISCAL" .Or.;
  					 AllTrim(aHeader[nCntFor][2]) == "Z7_SERIE"   .Or.;
  					 AllTrim(aHeader[nCntFor][2]) == "Z7_DATA"    .Or.;
  					 AllTrim(aHeader[nCntFor][2]) == "Z7_CLIFOR"  .oR.;
  					 AllTrim(aHeader[nCntFor][2]) == "Z7_LOJACF"    .Or.;
  					 AllTrim(aHeader[nCntFor][2]) == "Z7_PEDIDO"  .Or.;
  					 AllTrim(aHeader[nCntFor][2]) == "Z7_ITEMPV" )
  					 Alert(Substr(cUsuario,7,13) + ", o campo "+AllTrim(aHeader[nCntFor][2])+" nao foi preenchido.")
  					 lRetorno := .F.
  				EndIf
  			EndIf 
  			
  			If ( lRetorno .And. cSituaca$"COM/EST/DVT" )
  				If ( AllTrim(aHeader[nCntFor][2]) == "Z7_NFISCAL" .Or.;
  					 AllTrim(aHeader[nCntFor][2]) == "Z7_SERIE"   .Or.;
  					 AllTrim(aHeader[nCntFor][2]) == "Z7_DATA"    .Or.;
  					 AllTrim(aHeader[nCntFor][2]) == "Z7_CLIFOR"  .oR.;
  					 AllTrim(aHeader[nCntFor][2]) == "Z7_LOJACF"   )
  					 Alert(Substr(cUsuario,7,13) + ", o campo "+AllTrim(aHeader[nCntFor][2])+" nao foi preenchido.")
  					 lRetorno := .F.
 				EndIf
  			EndIf
  		EndIf	
  		
  		If ( !lRetorno ) 
  			nCntFor := nUsado + 1
    	EndIf
    	
  	Next nCntFor
  	
EndIf   

If n == 1   
   If !aCols[n][1]=="E"
//      lRetorno := .F.
      Alert(Substr(cUsuario,7,13) + ", o primeiro item do historico tem de ser obrigatoriamente uma entrada, FAVOR FAZER OS ACERTOS.")
   Else
	  If ALLTRIM(M->Z3_SERIENT) == "U" .Or. ALLTRIM(M->Z3_SERORI) == "U" 
	     If !aCols[n][5]=="COM"
//	         lRetorno := .F.
	         Alert(Substr(cUsuario,7,13) + ", a Serie da Nota de Entrada é do Tipo ( U ), portanto a Situacao do primeiro item do historico tem de ser obrigatoriamente (COM)PRA, FAVOR FAZER OS ACERTOS.")
	     EndIf
	  EndIf
   EndIf        
EndIf

Return lRetorno


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³JEst2TudOk ³ Autor ³ Reiner Trennepohl   ³ Data ³ 27/02/04³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consistencia geral dos itens de Pedidos de Venda           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ExpN1 = JEst2TudOk                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Valor devolvido pela fun‡„o                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function JEst2TudOk(o)

Local nMaxArray	    := 0
Local nCntFor		:= 0
Local lRetorna		:= .T.
Local nX	        := 0 
Local nItensDel     := 0                          

nMaxArray := Len(aCols)
         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao existir itens, nao gravar o cabecalho da nota.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nItensDel:=0
For ny:=1 to nMaxArray
	If aCols[ny][Len(aCols[ny])]
		nItensDel++
	Endif
Next
If nMaxArray == nItensDel
	Return .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se o array esta em branco, se estiver nao grava cabecalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ( nMaxArray == 1  )
 	If	(  Empty(aCols[nMaxArray][2]) )  // No da Nota Fiscal
  	    Alert(Substr(cUsuario,7,13) + ", voce confirmou a Etiqueta sem cadastrar um Historico.")
  	    Return .T.
  	EndIf
EndIf  

////// REVER OS OUTROS PROCEDIMENTOS E CONTROLES PARA FINALIZACAO DA INCLUSAO
////// OU ALTERACAO DO CADASTRO

Return( lRetorna )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³JMHEst2Rodap³ Autor ³ Reiner Trennepohl   ³ Data ³27.02.44  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para preenchimento do Rodape.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Sempre .T.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto da Getdados                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function JMHEst2Rodap(oGetDad)

Local oDlg
Local nX		:= 0
Local nY		:= 0
Local nUsado    := Len(aHeader)
Local lTestaDel := nUsado != Len(aCols[1])
Local cFornece  := Space(30)
Local cCliente	:= Space(30)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o Cliente                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( M->C5_TIPO $ "DB" )
	dbSelectArea("SA2")
	dbSetOrder(1)
	If ( dbSeek(xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI) )
	   cCliente	:= SA2->A2_NOME
	EndIf
Else
	dbSelectArea("SA1")
	dbSetOrder(1)
	If ( dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI) )
	   cCliente	:= SA1->A1_NOME
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso nao seja passado o objeto da getdados deve-se pegar a janela default³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( oGetDad == Nil )
	oDlg := GetWndDefault()
	If ( ValType(oDlg:Cargo)!="B" )
	   oDlg := oDlg:oWnd
	EndIf
Else
	oDlg 		:= oGetDad:oWnd
EndIf
If ( ValType(oDlg:Cargo)=="B" )
	Eval(oDlg:Cargo,SubStr(cCliente,1,40),nTotPed+nTotDes,nTotDes,nTotPed)
EndIf

Return(.T.)   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Jest2Bar  ³ Autor ³ Reiner Trennepohl     ³ Data ³ 15.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EnchoiceBar especifica do JMHEst02                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oDlg: 	Objeto Dialog                                     ³±±
±±³          ³ bOk:  	Code Block para o Evento Ok                       ³±±
±±³          ³ bCancel: Code Block para o Evento Cancel                   ³±±
±±³          ³ nOpc:		nOpc transmitido pela mbrowse                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function JEst2Bar(oDlg,bOk,bCancel,nOpc,cAlias,nReg)
Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

If ( nOpc == 2 .Or. nOpc == 3 .Or. nOpc == 4 ) 

	aButtons := { {"PRODUTO",    {|| JEst2Con1(cAlias,nReg,nOpc) }, OemToAnsi("Historico Produto") } }	
	AAdd(aButtons, {"EDIT",      {|| Iif(!Empty(M->Z3_NFSVAL).And.ALLTRIM(M->Z3_SERVAL)=="CON", JEst2Con2(),Alert(Substr(cUsuario,7,13) + ", Nota Fiscal do Vale nao Cadastrada.")) }, OemToAnsi("Ver N.Fiscal do Vale") } )
	AAdd(aButtons, {"AUTOM",     {|| Iif(!Empty(M->Z3_NFSAIDA).And.ALLTRIM(M->Z3_SERISAI)=="UNI", JEst2Con3(),Alert(Substr(cUsuario,7,13) + ", Nota Fiscal do Faturamento nao Cadastrada.")) }, OemToAnsi("Ver N.Viscal do Faturamento") } ) 	
	AAdd(aButtons, {"VENDEDOR",  {|| Iif(!Empty(M->Z3_NFEORI).And.ALLTRIM(M->Z3_SERORI)=="U", JEst2Con4(),Alert(Substr(cUsuario,7,13) + ", Nota Fiscal da Compra nao Cadastrada.")) }, OemToAnsi("Ver N.Fiscal do Fornecedor") } ) 	
	/*
	// BOTOES PADRAO SIGA
	AAdd(aButtons, {"S4WB004N"    , {||JEst2Con()}  , OemToAnsi("Limpa a tela") }) 	//"Limpa a tela"
	AAdd(aButtons, {"EXCLUIR"     , {||JEst2Con()}  , OemToAnsi("Cancela") }) 	//"Cancela"
	AAdd(aButtons, {"SALARIOS"    , {||JEst2Con()} 	, OemToAnsi("Dados Complementares do Pedido") }) 	//"Dados Complementares do Pedido"
	AAdd(aButtons, {"PRECO"       , {||JEst2Con()}  , OemToAnsi("Promo‡„o_1") }) 	//"Promo‡„o"
	AAdd(aButtons, {"DISCAGEM"    , {||JEst2Con()}  , OemToAnsi("Discagem automatica") }) 	//"Discagem automatica"
	AAdd(aButtons, {"AFASTAMENTO" , {||JEst2Con()} 	, OemtoAnsi("Consulta do motivo de Cancelamento") }) 	//"Consulta do motivo de Cancelamento"
	AAdd(aButtons, {"DBG07"       , {||JEst2Con2()  , OemToAnsi("Ver N.Fiscal do Vale") } )
	AAdd(aButtons, {"EDIT"        , {||JEst2Con()}  , OemtoAnsi("Gera‡„o Automatica") }) 	//"Gera‡„o Automatica"
	AAdd(aButtons, {"CHAVE2"      , {||JEst2Con()}  , OemtoAnsi("Pendˆncias") }) 	//"Pendˆncias"
	AAdd(aButtons, {"PRODUTO"	  , {||JEst2Con()}  , OemtoAnsi("Script da Campanha") }) 	//"Script da Campanha"
	AAdd(aButtons, {"FOLDER6"     , {||JEst2Con()}  , OemToAnsi("Altera‡„o de dados do cliente") }) 	//"Altera‡„o de dados do cliente" "S4WB011N"
	AAdd(aButtons, {"DBG06"       , {||JEst2Con()}  , OemtoAnsi("Historico") }) 	//"Historico"
	AAdd(aButtons, {"SIMULACAO"   , {||JEst2Con()} 	, OemToAnsi("Consulta situa‡„o financeira") }) 	//"Consulta situa‡„o financeira"
	AAdd(aButtons, {"VENDEDOR"    , {||JEst2Con()}  , OemToAnsi("Cadastro de contatos") }) 	//"Cadastro de contatos"
	AAdd(aButtons, {"PRECO"       , {||JEst2Con()}  , OemToAnsi("Promo‡„o_2") }) 	//"Promo‡„o"
	AAdd(aButtons, {"DBG09"       , {||JEst2Con()}  , OemToAnsi("Caracteristica do Produto") }) 	//"Caracteristica do Produto"
	AAdd(aButtons, {"AUTOM"       , {||JEst2Con()}  , OemToAnsi("Consulta dos Concorrentes") }) 	//"Consulta dos Concorrentes"
	AAdd(aButtons, {"DBG07"       , {||JEst2Con()} 	, OemToAnsi("Acessorios") }) 	//"Acessorios"
	AAdd(aButtons, {"PRECO"       , {||JEst2Con()} 	, OemToAnsi("Promo‡„o_3") }) 	//"Promo‡„o"
*/   
EndIf       

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))   

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡…o    ³JEst2Con1 ³ Autor ³ Reiner Trennepohl     ³ Data ³ 15.03.04 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ Mostra em tela todas os dados da etiqueta                  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ JEst2Con1()                                                ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ JMHEST02                                                   ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function JEst2Con1()

Local aArea     := GetArea() 
Local ooFNT
Local oBut00  
Local l_Ok      := .F. 
Local nMaxArray := 0
LocaL nCont     := 0         
Local nX        := 0
Local cPaciente := Space(30)  // SC5
Local cCodiCRM  := Space(6)   // SC5
Local cNomeCRM  := Space(20)  // SC5
Local cCodiFor  := Space(6)   // SA2
Local cNomeFor  := Space(40)  // SA2 
Local cNFisFor  := Space(6)
Local cSeriFor  := Space(3) 
Local dDataFor  := CToD("  /  /  ")
Local cCodiCli  := Space(6)   // SA1
Local cNomeCli  := Space(40)  // SA1
Local cNFisCli  := Space(6)
Local cSeriCli  := Space(3) 
Local dDataCli  := CToD("  /  /  ")  
Local cCodiVal  := Space(6)   // SA1
Local cNomeVal  := Space(40)  // SA1
Local cNFisVal  := Space(6)
Local cSeriVal  := Space(3) 
Local dDataVal  := CToD("  /  /  ")
Local cCodEtq   := M->Z3_CODETIQ 
Local cLote     := M->Z3_LOTE
Local cCodPrd   := M->Z3_CODPROD
Local cDesc     := M->Z3_DESC 
Local cNFOri    := M->Z3_NFEORI
Local cSrOri    := M->Z3_SERORI
Local dDtOri    := M->Z3_DATORI
Local cForOri   := M->Z3_FORORI
Local cLjFOri   := M->Z3_LOJORI 
Local cNFEVal   := M->Z3_NFSVAL
Local cSrVal    := M->Z3_SERVAL
Local dDtVal    := M->Z3_DATVAL
Local cCliVal   := M->Z3_CLIVAL
Local cLjCVal   := M->Z3_LOJVAL
Local cNFEnt    := M->Z3_NFENTRA
Local cSerEnt   := M->Z3_SERIENT
Local dDatEnt   := M->Z3_DATAENT
Local cFornec   := M->Z3_FORNECE
Local cLojaF    := M->Z3_LOJAFOR
Local cNFSai    := M->Z3_NFSAIDA
Local cIteNFS   := M->Z3_ITEMNFS
Local cSerSai   := M->Z3_SERISAI
Local dDatSai   := M->Z3_DATASAI
Local cClient   := M->Z3_CLIENTE
Local cLojaC    := M->Z3_LOJACLI
Local cSituac   := M->Z3_SITUACA
Local cPedVen   := M->Z3_PEDIDOV
Local cIteVen   := M->Z3_ITEMPV
Local cEtqRep   := M->Z3_ETQREP 

DO CASE
   CASE cSituac == "DVC"
        cPosicao := "DEVOLVIDA / FORNECEDOR "
   CASE cSituac == "RES"  
        cPosicao := "R E S E R V A D A"
   CASE cSituac == "DVT"  
        cPosicao := "DEVOLVIDA / VALE"     
   CASE cSituac == "EST" .Or. cSituac == "COM"
        cPosicao := "E S T O Q U E" 
   CASE cSituac == "FAT"
        cPosicao := "F A T U R A D A"
   CASE cSituac == "CON"
        cPosicao := "C O N S I G N A D A"                
ENDCASE           

nMaxArray := Len(aCols)
   
L_OK := .T.  

For nx := 1 to nMaxArray 
    Do Case
       Case aCols[nx][5]$"EST/COM"
            If AllTrim(aCols[nx][3])=="U".And.!Empty(aCols[nx][9]).And.aCols[nx][9]#"999999"  
               cCodiFor := aCols[nx][9]
               cNFisFor := aCols[nx][2]
               cSeriFor := aCols[nx][3] 
               dDataFor := aCols[nx][4] 
               
               dbSelectArea("SA2")
               dbSetOrder(1)
               If dbSeek(xFilial("SA2")+aCols[nx][9]+aCols[nx][10])
                  cNomeFor := SA2->A2_NOME 
               EndIf
            EndIf
       Case aCols[nx][5]=="FAT"
            If AllTrim(aCols[nx][3])=="UNI".And.!Empty(aCols[nx][9]).And.aCols[nx][9]#"999999"  
               cCodiCli := aCols[nx][9]
               cNFisCli := aCols[nx][2]
               cSeriCli := aCols[nx][3] 
               dDataCli := aCols[nx][4]
               
               dbSelectArea("SA1")
               dbSetOrder(1)
               dbSeek(xFilial("SA1")+aCols[nx][9]+aCols[nx][10])
               cNomeCli := SA1->A1_NOME 
               
               If !Empty(aCols[nx][7]) // Pedido                
               
                  dbSelectArea("SC5")
                  dbSetOrder(1)
                  If dbSeek(xFilial("SC5")+aCols[nx][7])
                     cPaciente := SC5->C5_PACIENT
                     cCodiCRM  := SC5->C5_CRM
					 cNomeCRM  := SC5->C5_CRMNOM
				  EndIf	 
               EndIf  
               
            EndIf
       Case aCols[nx][5]$"CON"
            If AllTrim(aCols[nx][3])=="CON".And.!Empty(aCols[nx][9]).And.aCols[nx][9]#"999999"  
               cCodiVal := aCols[nx][9]
               cNFisVal := aCols[nx][2]
               cSeriVal := aCols[nx][3] 
               dDataVal := aCols[nx][4]
               
               dbSelectArea("SA1")
               dbSetOrder(1)
               dbSeek(xFilial("SA1")+aCols[nx][9]+aCols[nx][10])
               cNomeVal := SA1->A1_NOME 
            EndIf          
    EndCase
Next    

If l_Ok 
      
	DEFINE FONT ooFNT NAME "Ms Sans Serif" SIZE 10,08 Bold
	DEFINE MSDIALOG Dial001 TITLE "  Etiqueta - "+Alltrim(cCodEtq)+" -                    - "+cPosicao+" -                     - Lote - "+Alltrim(cLote) FROM 000,000 TO 020,080 OF oMainWnd

	@ 005, 010 TO 132, 308 OF Dial001 PIXEL   

	@ 010, 020 Say "Produto .......: "               FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 010, 070 Say Alltrim(cCodPrd) + "  -  " + cDesc                                  SIZE 150,008 OF Dial001 PIXEL
 
	@ 020, 100 Say OemToAnsi("DADOS DO FORNECEDOR")  FONT ooFNT COLOR CLR_HRED   SIZE 150,008 OF Dial001 PIXEL
	@ 030, 020 Say "Fornecedor .: "                  FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 030, 070 Say cCodiFor + "  -  " + cNomeFor                                      SIZE 150,008 OF Dial001 PIXEL
	@ 040, 020 Say "N Fiscal .......: "              FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 040, 070 Say cNFisFor                                                      SIZE 030,008 OF Dial001 PIXEL
	@ 040, 140 Say "No Serie ......: "               FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 040, 190 Say cSeriFor                                                      SIZE 030,008 OF Dial001 PIXEL
	@ 040, 220 Say "Data ..........: "               FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 040, 270 Say dDataFor                                                      SIZE 030,008 OF Dial001 PIXEL
	
    @ 050, 118 Say OemToAnsi("DADOS DO VALE")        FONT ooFNT COLOR CLR_HRED   SIZE 150,008 OF Dial001 PIXEL
	@ 060, 020 Say "Cliente .........: "             FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 060, 070 Say cCodiVal + "  -  " + cNomeVal                                    SIZE 150,008 OF Dial001 PIXEL
	@ 070, 020 Say "N Fiscal .......: "              FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 070, 070 Say cNFisVal                                                      SIZE 030,008 OF Dial001 PIXEL
	@ 070, 140 Say "No Serie ......: "               FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 070, 190 Say cSeriVal                                                      SIZE 030,008 OF Dial001 PIXEL
	@ 070, 220 Say "Data ..........: "               FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 070, 270 Say dDataVal                                                      SIZE 030,008 OF Dial001 PIXEL

	
	@ 080, 100 Say OemToAnsi("DADOS DO FATURAMENTO") FONT ooFNT COLOR CLR_HRED   SIZE 150,008 OF Dial001 PIXEL
	@ 090, 020 Say "Cliente .........: "             FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 090, 070 Say cCodiCli + "  -  " + cNomeCli                                      SIZE 150,008 OF Dial001 PIXEL
	@ 100, 020 Say "N Fiscal .......: "              FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 100, 070 Say cNFisCli                                                      SIZE 030,008 OF Dial001 PIXEL
	@ 100, 140 Say "No Serie ......: "               FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 100, 190 Say cSeriCli                                                      SIZE 030,008 OF Dial001 PIXEL
	@ 100, 220 Say "Data ..........: "               FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 100, 270 Say dDataCli                                                      SIZE 030,008 OF Dial001 PIXEL
	@ 110, 020 Say "C R M ...........: "             FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 110, 070 Say cCodiCRM + "  -  " + cNomeCRM                                 SIZE 150,008 OF Dial001 PIXEL
	@ 120, 020 Say "Paciente ......: "               FONT ooFNT COLOR CLR_HBLUE  SIZE 050,008 OF Dial001 PIXEL
	@ 120, 070 Say cPaciente                                                     SIZE 150,008 OF Dial001 PIXEL
    
    DEFINE SBUTTON oBut00 FROM 135,280 TYPE 1  ENABLE OF Dial001 PIXEL ACTION Dial001:End()
 		
	ACTIVATE MSDIALOG Dial001 CENTERED

Endif

Return(l_Ok)

RestArea(aArea)

Return .T.     

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡…o    ³JEst2Con2 ³ Autor ³ Reiner Trennepohl     ³ Data ³ 15.03.04 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ Mostra os dados da Nota do Vale                            ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ JEst2Con2()                                                ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ JMHEST02                                                   ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function JEst2Con2()

Local aArea   := GetArea()     
Local l_Ok    := .F. 
Local cArqSF2 := "SF2"
Local nRecSF2 := 0
Local cNFEVal := M->Z3_NFSVAL
Local cSrVal  := M->Z3_SERVAL

dbSelectArea("SF2")
dbSetOrder(1)
If dbSeek(xFilial("SF2")+cNFEVal+cSrVal) 
   nRecSF2 := RecNo()
   MC090VISUAL(cArqSF2, nRecSF2, 2)
Else
   Alert(Substr(cUsuario,7,13) + ", a Nota Fiscal do Vale que esta cadastrada, nao foi localizada.")   
EndIf

RestArea(aArea)

Return(l_OK)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡…o    ³JEst2Con3 ³ Autor ³ Reiner Trennepohl     ³ Data ³ 15.03.04 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ Mostra os dados da Nota do Faturamento                     ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ JEst2Con3()                                                ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ JMHEST03                                                   ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function JEst2Con3()

Local aArea   := GetArea() 
Local l_Ok    := .F. 
Local cArqSF2 := "SF2"
Local nRecSF2 := 0 

Local cNFSai  := M->Z3_NFSAIDA
Local cSerSai := M->Z3_SERISAI

dbSelectArea("SF2")
dbSetOrder(1)
If dbSeek(xFilial("SF2")+cNFSai+cSerSai) 
   nRecSF2 := RecNo()
   MC090VISUAL(cArqSF2, nRecSF2, 2)
Else
   Alert(Substr(cUsuario,7,13) + ", a Nota Fiscal do Faturamento que esta cadastrada, nao foi localizada.")   
EndIf

RestArea(aArea)

Return .T.

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡…o    ³JEst2Con4 ³ Autor ³ Reiner Trennepohl     ³ Data ³ 15.03.04 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ Mostra os dados da Nota de Compra                          ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ JEst2Con4()                                                ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ JMHEST02                                                   ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function JEst2Con4()

Local aArea   := GetArea() 
Local l_Ok    := .F. 
Local nRecSF1 := 0 
Local cNFEnt  := M->Z3_NFEORI
Local cSerEnt := M->Z3_SERORI

cCadastro := OemToAnsi("Nota Fiscal de Entrada") 

Private lIntegracao := .F.

dbSelectArea("SF1")   
dbSetOrder(1)
If dbSeek(xFilial("SF1")+cNFEnt+cSerEnt) 
   nRecSF1 := RecNo()
   A100VISUAL("SF1", nRecSF1, 2)
Else
   Alert(Substr(cUsuario,7,13) + ", a Nota Fiscal da Compra que esta cadastrada, nao foi localizada.")   
EndIf
          
cAlias := "SZ3"

cCadastro := OemToAnsi("Atualizacao das Etiquetas X Produto") 

RestArea(aArea)

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ JEst2Psw º Autor ³ Reiner Trennepohl  º Data ³     18/03/04º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Para utilizacao da rotina de alteracao sera obrigatorio o  º±±
±±º          ³ uso de senha												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso		 ³ Especifico para clientes Microsiga						  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function JEst2Psw()
PRIVATE cSenha2    := Space(6)
PRIVATE cConteudo := Space(200)
PRIVATE oSenhas

DEFINE MSDIALOG oSenhas FROM 100,004 To 198,230 TITLE OemToAnsi("S E N H A")  PIXEL

@ 001,003 Say OemToAnsi('Informe a sua SENHA')
@ 002,002 Say OemToAnsi("Senha   :") SIZE 50, 7 OF oSenhas //PIXEL
@ 002,022 MSGet cSenha2    Picture "@S40" Valid .T.  PASSWORD //Object oSenha
@ 003,002 Say OemToAnsi("Conteudo:") SIZE 50, 7 OF oSenhas //PIXEL
@ 003,022 MSGet cConteudo Picture "@S40" When .F.            //Object oConteudo

//DEFINE SBUTTON FROM 129, 240 TYPE 1 ACTION (nOpca := 1,IF(ma280OK(dDataFec,cArq1,cArq2,cArq3,cArq4,cArq5,cArq6,!lBat),oDlg:End(),nOpca:=0)) ENABLE OF oDlg
//DEFINE SBUTTON FROM 129, 267 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
DEFINE SBUTTON FROM 79, 150 TYPE 1 ENABLE OF oSenhas PIXEL ACTION oSenhas:End()

//oBut00:SetDisable() 
//oBut00:SetEnable()

//oAtuCont := Iw_Timer(100,{|| cConteudo := cSenha , ObjectMethod(oConteudo,"Refresh()") })
//ObjectMethod(oAtuCont,"Activate()")

ACTIVATE MSDIALOG oSenhas CENTERED

Return	.t.	