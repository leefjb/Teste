#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'APVT100.CH'
#INCLUDE 'TBICONN.CH'
#DEFINE ENTER (CHR(13)+CHR(10))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณJOMH6207  บAutor  ณMarcelo Tarasconi   บ Data ณ  08/08/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณInventario via coletor de dados                             บฑฑ
ฑฑบAdaptado  ณRotinas TELNET diversos                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP 8                                                       บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/            

/* Ajuste Celso Rene para o mesmo funcionar paraa a empresa 06 - configurado novo servico = coletar2 */
**********************************************************************
User Function JOMH6299()
**********************************************************************
VTCLEAR()

VTSetSize(18,32)

Private aSave 		:= 	VTSave()
Private nTamLocal  	:= 	0
Private nTamProd   	:= 	0
Private nTamLote   	:= 	0
Private nTamDoc    	:=	0
	
cQEmp := "06"
cQFil := "01"

RPCSetType(3)  // Nao comer licensa
PREPARE ENVIRONMENT EMPRESA '06' FILIAL '01'  


	nTamLocal  := TamSX3("B7_LOCAL")[01] 
	nTamProd   := TamSX3("B7_COD")[01]
	nTamLote   := TamSX3("B7_LOTECTL")[01]
	nTamDoc    := TamSX3("B7_DOC")[01]

	Do While .T.
		
		cOpcao1 := Space(1)
		
		VTSetSize(18,26)//32)
		
		VTCLEAR()
		VTCLEARBUFFER()
		
		@ 00,00 VTSAY "-------------------------"
		@ 01,00 VTSAY "        JOMHEDICA-06     "
		@ 02,00 VTSAY "-------------------------"
		@ 03,00 VTSAY "  ESCOLHA OPCAO ABAIXO   "
		@ 04,00 VTSAY "-------------------------"

		@ 06,00 VTSAY "( 1 ) INVENTARIO MOD1    "
		@ 07,00 VTSAY "                         "	//	"( 2 ) INVENTARIO MOD2    "
		@ 10,00 VTSAY "(ESC) SAIR               "
		
		@ 11,00 VTSAY "Opcao:" VTGET cOpcao1 Valid cOpcao1 $ "1/2/3/4"
		
		VTREAD
		
		If VTLASTKEY() == 27
			VTCLEAR()
			VTCLEARBUFFER()
			Exit
		EndIf
		
		VTCLEAR()
		
		If cOpcao1 $ "1"
			JMH6207A(cOpcao1) //Inventario via coletor
		EndIF
		
	EndDo

RESET ENVIRONMENT

Return()
**********************************************************************
Static Function JMH6207A(cOpOper)
**********************************************************************
Local cPar01 := ""
Local cPar02 := ""
Local cPar03 := ""

Private cEsc		:= Space(01)
Private cProduto	:= Space(15)
Private cLote		:= Space(10)
Private cLocal		:= '01'
Private dDtInv		:= dDataBase
Private aInvent		:= {}
Private nQuant		:= 1 //padrao sera sempre 1 se for mod1, se for mod2 abrira nova tela pra informar quantidadee
Private aSave		:= VTSave()
Private cDocInv		:= "INV"+SubStr(DtoS(dDataBase),7,2)+SubStr(DtoS(dDataBase),5,2)+SubStr(DtoS(dDataBase),3,2)

Private nQBeepAlert	:=  1
Private nTBeepAlert	:=	250

Private nQBeepErro	:=  2
Private nTBeepErro	:=  3000
Private cParInv := SuperGetMv( "ES_PARINV", .F., " " ) 

// Jean Rehermann - Solutio IT - 27/03/2018 - Tratamento para obter data, documento e local de parametro (ver PE MTA270MNU)
If !Empty( cParInv )
	
	// Local
	cPar01 := SubStr( cParInv, 01, 02 )
	cLocal  := Iif( !Empty( cPar01 ), cPar01, cLocal )
	
	// Data
	cPar02 := SubStr( cParInv, 03, 08 )
	dDtInv  := Iif( !Empty( cPar02 ), StoD( cPar02 ), dDtInv )

	// Documento
	cPar03 := SubStr( cParInv, 11, 09 )
	cDocInv := Iif( !Empty( cPar03 ), cPar03, cDocInv )

EndIf

nLidos := 0

VTClearBuffer()

// Jean Rehermann - Solutio IT - 27/03/2018 - Campo cDocInv aberto para digitacao
VTClear()

DLVTCabec("",.F.,.F.,.T.)
@ 01,00 VTSay "---------------------------"
@ 02,00 VTSay "INFORME DADOS INVENTARIO   "
@ 03,00 VTSAY "---------------------------"
@ 05,00 VTSAY "Data : "
@ 05,08 VTSAY dDtInv
@ 07,00 VTSAY "Doc. : "
@ 07,08 VTSAY cDocInv
@ 09,00 VTSAY "Local: "
@ 09,08 VTSAY cLocal
@ 11,00 VTSAY "---------------------------"
@ 12,00 VTSAY "(ESC) VOLTA                "
@ 13,00 VTSAY "---------------------------"
DLVTRodaPe(,.T.)

If VTLASTKEY() == 27
	VTCLEAR()
	VTCLEARBUFFER()
	Return()
ElseIf Empty(cLocal) .Or. !ChkNNR(cLocal)
	VTBeep(nQBeepErro)
	VTAlert(Space(03)+"LOCAL INVALIDO !","Alerta",.T., /*nTBeepErro*/)
	Return()
EndIf


Do While .T.
	
	nLidos := nLidos + 1
	VTClearBuffer()
	VTClear()
	
	cCodBar  := Space(100) // Space(TamSX3("B1_CODBAR")[1])
	cProduto := Space(TamSX3("B1_COD")[1])
	cLote    := Space(10)
	aInvent  := {}
	
	@ 0,0 VTSay "---------------------------"
	@ 1,0 VTSay "CAPTURA PRODUTO            "
	@ 2,0 VTSAY "---------------------------"
	@ 4,0 VTGet cCodBar //VALID ExistCpo("SB1",cProduto)
	@ 6,0 VTSAY "(ESC) VOLTA                "
	
	VTRead
	
	If VTLASTKEY() == 27
		VTCLEAR()
		VTCLEARBUFFER()
		Exit
	EndIf


	aErro	  := {}
	cProduto  := SubStr(cCodBar, 01, 15)
	cLote 	  := SubStr(cCodBar, 16, 10)
	dDtValid  := SubStr(cCodBar, 26, 08)
	
	DbSelectArea("SB1");DbSetOrder(1)	//	B1_FILIAL+B1_COD
	If !Dbseek(xFilial("SB1") + AllTrim(cProduto), .F.)
		Aadd(aErro, "PRODUTO: "+cProduto+"  INVมLIDO.")
	EndIf
	DbSelectArea("SB2");DbSetOrder(1)	//	B2_FILIAL+B2_COD+B2_LOCAL
	If !DbSeek(xFilial("SB2")+Padr(cProduto,nTamProd)+Padr(cLocal,nTamLocal))
		Aadd(aErro, "ARMAZษM : "+cLocal+"  INVมLIDO.")
	EndIf
	DbSelectArea("SB8"); DbSetOrder(3) //	B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
	If !DbSeek(xFilial("SB8")+Padr(cProduto,nTamProd)+Padr(cLocal,nTamLocal)+Padr(cLote,nTamLote))
		Aadd(aErro, "LOTE : "+cLote+"  INVมLIDO.")
	EndIf

	If Len(aErro) == 0

		cDatValid 	:=	SubStr(dDtValid, 7,2) + "/" + SubStr(dDtValid, 5,2) + "/" + SubStr(dDtValid, 1,4)
		cDesProd 	:= 	SB1->B1_DESC
		cLocPadrao 	:= 	SB1->B1_LOCPAD
		cLote 		:= 	cLote 

		
		//ABRIR UM PROMPT COM Q SE FOR MOD2
		/*
		If cOpOper == '2' //Se for Mod2, ou seja, o inventariante informou produto e lote e agora ele diz quantas pe็as tem no estoque....
			VTClear()
			@ 00,00 VTSay "---------------------------"
			@ 01,00 VTSay "INFORME QUANTIDADE PRODUTO:"
			@ 03,00 VTSAY Left(SB1->B1_DESC,40)
			@ 04,00 VTSay "LOTE: " + cLote
			@ 05,00 VTSAY "---------------------------"
			@ 06,00 VTGet nQuant
			@ 09,00 VTSAY "(Esc) Volta                "
			
			VTRead
			If VTLASTKEY() == 27
				VTCLEAR()
				//VTCLEARBUFFER()
				Exit
			EndIf
		Endif
		*/
		
		//TESTO SE JA NAO BIPEI ELE ANTES, SE SIM, VOU NO B7 E ADICIONO 1....
		cLote		:= If(SB1->B1_RASTRO $ 'L/S',cLote,Space(TamSX3("B7_LOTECTL")[1]))
		cLote		:= PadR(cLote    ,TamSX3("B7_LOTECTL")[1])
		cProduto	:= PadR(cProduto ,TamSX3("B7_COD")[1])
		cDocInv		:= PadR(cDocInv  ,TamSX3("B7_DOC")[1])


		aRetSB7 := ConsSB7( Padr(cDocInv,nTamDoc), Padr(cProduto,nTamProd), Padr(cLocal,nTamLocal), Padr(cLote,nTamLote), dDtInv )

		If aRetSB7[1]
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ  ALTERA O REGISTRO NO SB7  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			nQtd := aRetSB7[2]+1
			GravarSB7( 4, aRetSB7[3], Padr(cDocInv,nTamDoc), Padr(cProduto,nTamProd), Padr(cLocal,nTamLocal), Padr(cLote,nTamLote), dDtInv )

		Else
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ  INCLUI O REGISTRO NO SB7  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			nQtd := 1
			GravarSB7( 3, aRetSB7[3], Padr(cDocInv,nTamDoc), Padr(cProduto,nTamProd), Padr(cLocal,nTamLocal), Padr(cLote,nTamLote), dDtInv )

		EndIf

	
		If VTLastKey() == 27
			Exit
		EndIf
	
	Else
	
		cMsgErro := ''
		For nE := 1 To Len(aErro)
			cMsgErro += aErro[nE]
		Next                     
		
		VTBeep(nQBeepErro)
		VTAlert(cMsgErro,"Alerta",.T., /*nTBeepErro*/)

	EndIf
	
EndDo
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERIFNRO   บAutor  ณAna Carolina        บ Data ณAug 22, 2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para verificacao do parametro ES_DOCINV onde I - Infoบฑฑ
ฑฑบ          ณrmado e S - Sequencial.                                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
**********************************************************************
Static Function VerifNro()
**********************************************************************	
	Local cParam     := GetNewPar("ES_DOCINV", "I")
	
	dbSelectArea("SB7")
	dbSetOrder(4)      

	If cParam = "S"
		cParam := GETSX8NUM("SB7", "B7_DOC")
	ElseIf cParam = "I" .or. cParam = ""
		cParam := Space(nTamDoc)
	Else
		VTBeep(nQBeepErro)
		VTBeep(nQBeepErro)
		VTAlert("PARยMETRO INVมLIDO","Parโmetro com Erro",.T., /*nTBeepErro*/)
	Endif 

Return(cParam)
************************************************************************************
Static Function ConsSB7( cDoc, cProd, cLocal, cLoteCtl, dData )
************************************************************************************
Local aRet := { .F., 0, 0 }

//Verifico se o documento no inventario ja existe
cQuery := " SELECT B7_QUANT, R_E_C_N_O_ AS B7_RECNO "
cQuery += " FROM   " + RetSQLName("SB7")
cQuery += " WHERE  B7_FILIAL  =  '" + xFilial("SB7") + "' "
cQuery += "   AND  B7_DATA    =  '" + DTOS(dData)    + "' "
cQuery += "   AND  B7_COD     =  '" + cProd          + "' "
cQuery += "   AND  B7_LOCAL   =  '" + cLocal         + "' "
cQuery += "   AND  B7_LOCALIZ =  '' "
cQuery += "   AND  B7_NUMSERI =  '' "
cQuery += "   AND  B7_LOTECTL =  '" + cLoteCtl       + "' "
cQuery += "   AND  B7_NUMLOTE =  '' "
cQuery += "   AND  B7_CONTAGE =  '' "
cQuery += "   AND  B7_DOC     =  '" + cDoc           + "' "
cQuery += "   AND  D_E_L_E_T_ <> '*' "

//MemoWrite("\_Aux\jmha020sb7.sql",cQuery)
cQuery := ChangeQuery(cQuery)
DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "TB1", .F., .T.)

If TB1->(!Eof())
	aRet := {.T., TB1->B7_QUANT, TB1->B7_RECNO}
EndIf

TB1->(DbCloseArea())
Return(aRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravarSB7  บAutor  ณAna Carolina        บ Data ณAug 22, 2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para gravar os dados recebidos via coletor na tabela บฑฑ
ฑฑบ          ณSB7 via MSEXECAUTO do MATA270.                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
**************************************************************************
Static Function GravarSB7( nOpc, nRecSB7, cDoc, cProd, cLocal, cLoteCtl, dData )
**************************************************************************	
Local aCampos 	:= {}
Local cUsu	 	:= "estoque" //Space(20)

Private lMsErroAuto := .F.

DbSelectArea("SB7")

If nOpc == 3
	
	aAdd(aCampos, 	{"B7_COD",		cProd   ,NIL})
	aAdd(aCampos, 	{"B7_LOCAL",	cLocal  ,NIL})
	aAdd(aCampos, 	{"B7_DOC",		cDoc    ,NIL})
	aAdd(aCampos, 	{"B7_QUANT",	1       ,NIL})
	aAdd(aCampos, 	{"B7_DATA",	 	dData   ,NIL})
	aAdd(aCampos, 	{"B7_LOTECTL", 	cLoteCtl,NIL})
	aAdd(aCampos, 	{"B7_DTVALID", 	dData   ,NIL})
	aAdd(aCampos, 	{"B7_USUARIO", 	cUsu    ,NIL})
	
	MSExecAuto({|x,y,z| mata270(x,y,z)},aCampos,.F.,nOpc)
	
	If lMsErroAuto
		cErroAuto 	:=	MemoRead(NomeAutoLog())

		VTClear()
		VTClearBuffer()
		VTBeep(nQBeepErro)
		VTAlert("ERRO NA ROTINA AUTOMATICA\SB7"+Space(10) +cErroAuto,"Alerta",.T., /*nTBeepErro*/)
		MostraErro()
	Else
		VTClear()
		VTClearBuffer()
		VTBeep(nQBeepAlert)
		VTAlert(Space(03)+"Leitura efetuado com sucesso...", "Atencao", .T., nTBeepAlert)
	EndIf	
Else
	
	//Faco o update do registro quando encontrado
	cQuery := " UPDATE " + RetSQLName("SB7")
	cQuery += " SET    B7_QUANT   =  '" + Str(nQtd)      + "' "
	cQuery += " WHERE  B7_FILIAL  =  '" + xFilial("SB7") + "' "
	cQuery += "   AND  B7_DATA    =  '" + DTOS(dData)    + "' "
	cQuery += "   AND  B7_COD     =  '" + cProd          + "' "
	cQuery += "   AND  B7_LOCAL   =  '" + cLocal         + "' "
	cQuery += "   AND  B7_LOCALIZ =  '' "
	cQuery += "   AND  B7_NUMSERI =  '' "
	cQuery += "   AND  B7_LOTECTL =  '" + cLoteCtl       + "' "
	cQuery += "   AND  B7_NUMLOTE =  '' "
	cQuery += "   AND  B7_CONTAGE =  '' "
	cQuery += "   AND  B7_DOC     =  '" + cDoc           + "' "
	cQuery += "   AND  D_E_L_E_T_ <> '*' "
	
	//MemoWrite("\_Aux\jmha020sb7.sql",cQuery)
	If TcSqlExec(cQuery) < 0
		cErroAuto 	:=	TcSqlError()
		VTClear()
		VTClearBuffer()
		VTBeep(nQBeepErro)
		VTAlert("ERRO NA UPDATE SB7"+Space(10) +cErroAuto,"Alerta",.T., /*nTBeepErro*/)
				
	Else
		VTClear()
		VTClearBuffer()
		VTBeep(nQBeepAlert)
		VTAlert(Space(03)+"Leitura efetuado com sucesso...", "Atencao", .T., nTBeepAlert)	
	EndIf
	
EndIf

Return(.T.)
**************************************************************************
Static Function ChkNNR(cLocal)
**************************************************************************	
Local lValida := .F.

DbSelectArea('NNR');DbSetOrder(1);DbGoTop()
If DbSeek(xFilial('NNR')+cLocal, .F.)
	lValida := .T.
EndIf

Return(lValida)