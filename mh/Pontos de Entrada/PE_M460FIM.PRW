
#define CRLF   Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M460FIM   บAutor  ณEliane-Microsiga  บ Data ณ  10/14/05    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para  Gravar o                            บฑฑ
ฑฑบ            no ctas a receber                                          บฑฑ
ฑฑบ          ณ Regra todos Itens devem ter centro de custo e ItemCC iguaisบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ-----------------------------------------------------------------------บฑฑ
ฑฑบAutor         |   Data   | Alteracao                                   บฑฑ
ฑฑบ--------------|----------|---------------------------------------------บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function  M460FIM()

Local aArea     := GetArea()
Local aAreaSD2  := SD2->(getarea())
Local aAreaSE1  := SE1->(getarea())
Local cMensagem := Space(0)
Local cTitulo   := 'Avisar o Financeiro para compensar estas Notas (TES 519)'+CRLF+CRLF+CRLF
Local cQuery    := ""
Local cAliasTmp := GetNextAlias()

dbselectArea("SA1")
dbSetOrder(1)
dbseek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)

DbselectArea("SD2")
DbsetOrder(3)
dbseek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
Do While xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE .and. !Eof()
	If SD2->D2_TES = '519'
		cMensagem += 'Nota Num: ' + SF2->F2_DOC + '/' + SF2->F2_SERIE + '   - Cliente: ' + Substr(SA1->A1_NOME,1,20) + CRLF + CRLF
		Exit
	Endif
	dbSkip()
EndDo

DbselectArea("SD2")
DbsetOrder(3)
dbseek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
DbselectArea("SE1")
DbsetOrder(1)
dbseek(xFilial("SE1") + SF2->F2_SERIE + SF2->F2_DOC)
Do While xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM == SF2->F2_FILIAL+SF2->F2_SERIE + SF2->F2_DOC .And. !Eof()
	If RecLock("SE1",.F.)
		SE1->E1_ITEMCTB := SD2->D2_ITEMCC
		SE1->E1_CCUSTO  := SD2->D2_CCUSTO
		MsUnlock()
	Endif
	dbSkip()
EndDo

If ! Empty( cMensagem )
	cTitulo += cMensagem
	MsgInfo( cTitulo )
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Rotinas Monitoramento                            ณ
//ณ                                                  ณ
//ณ Faz alteracao do status do pedido.               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If cEmpAnt <> '10'
	If	u_UseTrsf010() .And. !Empty( SC5->C5_PVSTAT )
		
		U_Trsf012()
		
	EndIf
EndIf

RestArea(aAreaSE1)
RestArea(aAreaSD2)
RestArea(aArea)

Return()
