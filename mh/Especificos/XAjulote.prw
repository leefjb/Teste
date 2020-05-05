#Include "protheus.ch"
#Include "topconn.ch"
#Include "rwmake.ch"


/*/{Protheus.doc} XAjulote
//Funcionalidade para gerar registros SD3 e SD5 do ausentes - estouro de lote
@author Celso Rene
@since 15/02/2019
@version 1.0
@type function
/*/
User Function XAjulote()

Local 	_cquery	 := ""   
Private _cDocSeq := ""	
Private cDoc	 := ""	

_cquery := " SELECT * FROM SB8060 SB8 WHERE SB8.B8_PRODUTO = 'LF1212A' AND SB8.B8_LOTEUNI <> 'S' AND "
_cquery += " SB8.B8_SALDO > 0 AND SB8.D_E_L_E_T_='' " + chr(13)
_cquery += " AND EXISTS (SELECT SB82.B8_LOTEFOR FROM SB8060 SB82 WHERE SB82.D_E_L_E_T_='' AND SB82.B8_PRODUTO = SB8.B8_PRODUTO AND SB82.B8_LOTEFOR = SB8.B8_LOTECTL AND SB82.B8_LOTEUNI = 'S' ) "

If cEmpant <> "06"
	MsgAlert("A funcao deve ser utilizada somente com acesso a empresa 06!","Logar na empresa 06")
	Return()
EndIf

If( Select( "TMP1" ) <> 0 )
	TMP1->( DbCloseArea() )
EndIf

TcQuery _cquery Alias "TMP1" New
DbSelectArea("TMP1")

Do While ( !TMP1->(EOF()) )
	
	
	dbSelectArea("SX6")
	dbSetOrder(1)
	SX6->( dbSeek("  " + "MV_DOCSEQ" ) )
	_cDocSeq := Left( SX6->X6_CONTEUD, 6 )
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1") + TMP1->B8_PRODUTO )
	
	//dbSelectArea("SD3")
	//dbSetOrder(1)
	//DBGOBOTTOM()
	cDoc := "sol-" + TMP1->B8_LOTECTL
	
	//grava SD3 lote fornecedor
	dbSelectArea("SD3")
	RecLock("SD3", .T.)
	SD3->D3_FILIAL  := xFilial("SD3")
	SD3->D3_TM      := "999" 
	SD3->D3_COD     := TMP1->B8_PRODUTO
	SD3->D3_UM      := SB1->B1_UM
	SD3->D3_QUANT   := TMP1->B8_SALDO
	SD3->D3_CF      := "RE4" 
	SD3->D3_CONTA   := SB1->B1_CONTA
	SD3->D3_LOCAL   := TMP1->B8_LOCAL
	SD3->D3_DOC     := cDoc
	SD3->D3_NUMSEQ  := _cDocSeq
	SD3->D3_EMISSAO := StoD(TMP1->B8_DATA)
	SD3->D3_GRUPO   := SB1->B1_GRUPO
	SD3->D3_CHAVE   := "E0"
	SD3->D3_FORORI  := TMP1->B8_CLIFOR
	SD3->D3_LOJORI  := TMP1->B8_LOJA
	SD3->D3_DOCORI  := TMP1->B8_DOC
	SD3->D3_SERORI  := TMP1->B8_SERIE
	SD3->D3_LOTECTL := TMP1->B8_LOTECTL
	SD3->D3_LTCTORI := TMP1->B8_LOTEFOR
	SD3->D3_LOTEFOR := TMP1->B8_LOTEFOR
	SD3->D3_DTVALID := StoD(TMP1->B8_DTVALID)
	SD3->D3_DTVORI  := StoD(TMP1->B8_DTVALID)
	SD3->D3_LANORI  := "NF"
	SD3->D3_OBSERVA	:= "solutio-lote"
	SD3->D3_NUMLOTE	:= TMP1->B8_NUMLOTE
	//SD3->D3_ESTORNO := "S"
	SD3->(MsUnLock())
	
	
	//grava SD5 lote fornecedor
	RecLock("SD5", .T.)
	SD5->D5_FILIAL	:= xFilial("SD5")
	SD5->D5_LOTEFOR	:= TMP1->B8_LOTEFOR
	SD5->D5_PRODUTO := TMP1->B8_PRODUTO
	SD5->D5_LOCAL	:= TMP1->B8_LOCAL
	SD5->D5_DOC		:= cDoc
	SD5->D5_SERIE	:= ""
	SD5->D5_DATA	:= StoD(TMP1->B8_DATA)
	SD5->D5_ORIGLAN := "999"
	SD5->D5_NUMSEQ	:= _cDocSeq
	//SD5->D5_CLIFOR
	//SD5->D5_LOJA
	SD5->D5_QUANT	:= TMP1->B8_SALDO
	SD5->D5_LOTECTL	:= TMP1->B8_LOTECTL
	SD5->D5_NUMLOTE := TMP1->B8_NUMLOTE
	SD5->D5_DTVALID	:= StoD(TMP1->B8_DTVALID)
	SD5->D5_QTSEGUM	:= 0
	//SD5->D5_ESTORNO
	SD5->D5_POTENCI := 0
	//SD5->D5_LOTEPRD
	//SD5->D5_SLOTEPR
	//SD5->D5_SLDINI
	SD5->D5_PRMAIOR := "N"
	SD5->(MsUnLock())

    
	//chamada funcao para gerar o lote unitario
	xGeraUnit()	     
	
	dbSelectArea("SX6")
	RecLock("SX6", .F.)
	SX6->X6_CONTEUD := Soma1( AllTrim(SX6->X6_CONTEUD) )
	SX6->( MsUnLock() )
	
	TMP1->(dbSkip())
	
EndDo

dbCloseArea("TMP1")


Return()


/*/{Protheus.doc} xGeraUnit
//Funcionalidade para gerar registros SD3 e SD5 do ausentes - estouro de lote  
//registros referente ao lotes unitarios
@author Celso Rene
@since 15/02/2019
@version 1.0
@type function
/*/ 
Static Function xGeraUnit()

Local _cquery2 := ""

_cquery2 := " SELECT * FROM SB8060 SB8 WHERE SB8.B8_PRODUTO = '" + TMP1->B8_PRODUTO + "' AND SB8.B8_LOTEUNI = 'S' AND SB8.D_E_L_E_T_='' AND SB8.CB8_LOTEFOR  = '" + TMP1->B8_LOTECTL + "' " + chr(13)
_cquery2 += " AND EXISTS (SELECT SB82.B8_LOTEFOR FROM SB8060 SB82 WHERE SB82.D_E_L_E_T_='' AND SB82.B8_PRODUTO = SB8.B8_PRODUTO AND SB82.B8_LOTECTL = SB8.B8_LOTEFOR AND SB82.B8_LOTEUNI <> 'S' AND SB82.B8_SALDO >0) " + chr(13)
_cquery2 += " AND NOT EXISTS (SELECT SD3.D3_LOTECTL FROM SD3060 SD3 WHERE SD3.D3_COD = SB8.B8_PRODUTO AND SD3.D3_LOTECTL = SB8.B8_LOTECTL AND SD3.D3_OBSERVA LIKE '%solutio%' AND SD3.D3_CF = 'DE4') "

If( Select( "TMP2" ) <> 0 )
	TMP2->( DbCloseArea() )
EndIf

TcQuery _cquery Alias "TMP2" New
DbSelectArea("TMP2")

Do While ( !TMP2->(EOF()) )
	
	
	dbSelectArea("SX6")
	dbSetOrder(1)
	SX6->( dbSeek("  " + "MV_DOCSEQ" ) )
	_cDocSeq := Left( SX6->X6_CONTEUD, 6 )
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1") + TMP2->B8_PRODUTO )
	
	//dbSelectArea("SD3")
	//dbSetOrder(1)
	//DBGOBOTTOM()
	cDoc := "sol-" + TMP2->B8_LOTECTL
	
	//grava SD3 lote unitario
	dbSelectArea("SD3")
	RecLock("SD3", .T.)
	SD3->D3_FILIAL  := xFilial("SD3")
	SD3->D3_TM      := "499"
	SD3->D3_COD     := TMP2->B8_PRODUTO
	SD3->D3_UM      := SB1->B1_UM
	SD3->D3_QUANT   := 1
	SD3->D3_CF      := "DE4"
	SD3->D3_CONTA   := SB1->B1_CONTA
	SD3->D3_LOCAL   := TMP2->B8_LOCAL
	SD3->D3_DOC     := cDoc
	SD3->D3_NUMSEQ  := _cDocSeq
	SD3->D3_EMISSAO := StoD(TMP2->B8_DATA)
	SD3->D3_GRUPO   := SB1->B1_GRUPO
	SD3->D3_CHAVE   := "E0"
	SD3->D3_FORORI  := TMP2->B8_CLIFOR
	SD3->D3_LOJORI  := TMP2->B8_LOJA
	SD3->D3_DOCORI  := TMP2->B8_DOC
	SD3->D3_SERORI  := TMP2->B8_SERIE
	SD3->D3_LOTECTL := TMP2->B8_LOTECTL
	SD3->D3_LTCTORI := TMP2->B8_LOTEFOR
	SD3->D3_LOTEFOR := TMP2->B8_LOTEFOR
	SD3->D3_DTVALID := StoD(TMP2->B8_DTVALID)
	SD3->D3_DTVORI  := StoD(TMP2->B8_DTVALID)
	SD3->D3_LANORI  := "NF"
	SD3->D3_OBSERVA	:= "solutio-slote" 
	SD3->D3_NUMLOTE	:= TMP2->B8_NUMLOTE
	//SD3->D3_ESTORNO := "S"
	SD3->(MsUnLock())
	
	
	//grava SD5 lote unitario
	RecLock("SD5", .T.)
	SD5->D5_FILIAL	:= xFilial("SD5")
	SD5->D5_LOTEFOR	:= TMP2->B8_LOTEFOR
	SD5->D5_PRODUTO := TMP2->B8_PRODUTO
	SD5->D5_LOCAL	:= TMP2->B8_LOCAL
	SD5->D5_DOC		:= cDoc
	SD5->D5_SERIE	:= ""
	SD5->D5_DATA	:= StoD(TMP2->B8_DATA)
	SD5->D5_ORIGLAN := "499"
	SD5->D5_NUMSEQ	:= _cDocSeq
	//SD5->D5_CLIFOR
	//SD5->D5_LOJA
	SD5->D5_QUANT	:= 1
	SD5->D5_LOTECTL	:= TMP2->B8_LOTECTL
	SD5->D5_NUMLOTE := TMP2->B8_NUMLOTE
	SD5->D5_DTVALID	:= StoD(TMP2->B8_DTVALID)
	SD5->D5_QTSEGUM	:= 0
	//SD5->D5_ESTORNO
	SD5->D5_POTENCI := 0
	//SD5->D5_LOTEPRD
	//SD5->D5_SLOTEPR
	//SD5->D5_SLDINI
	SD5->D5_PRMAIOR := "N"
	SD5->(MsUnLock())
	
	
	TMP2->(dbSkip())
	
EndDo

dbCloseArea("TMP2")      


Return()
