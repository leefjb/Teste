#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSD2460   บAutor  ณMicrosiga           บ Data ณ Outubro/2001บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para Atualizacao do Cadastro Faturamento  บฑฑ
ฑฑ             Especial, qdo SC6->C6_FATESP == "S"                        บฑฑ
ฑฑ             Ponto de entrada para atualizacao dos produtos com etiquetaบฑฑ
ฑฑ             ,qdo.C6_ETQPROD # "S".                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ-----------------------------------------------------------------------บฑฑ
ฑฑบAutor         |   Data   | Alteracao                                   บฑฑ
ฑฑบ--------------|----------|---------------------------------------------บฑฑ
ฑฑEliane Carvalho 14/10/2005 Grava   campos D2_CCUSTO,D2_CONTA e D2_ITEMCC ฑฑ
ฑฑEliane Carvalho 24/01/2006 Grava   campos D2_CLVL                        ฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSD2460()

	Local aArea    := GetArea()
	Local nQuant   := 0
	Local nAchou   := 0
	Local cSituacao:= Space(3)
	Local nRecZ3   := 0
	Local lUsaSpark:= SuperGETMV("MV_SPARK",.F.)

	If cEmpAnt <> "10" // WorldMedical
		If SC6->C6_FATESP == "S"

			DbSelectArea("SZ2")
			DbSetOrder(2)
			DbSeek(xFilial("SZ2")+SD2->D2_DOC+SD2->D2_SERIE+DTOS(SD2->D2_EMISSAO))
			If EOF()
				RecLock("SZ2",.T.)
				SZ2->Z2_FILIAL  := xFilial("SZ2")
				SZ2->Z2_NFISCAL := SD2->D2_DOC
				SZ2->Z2_SERIE   := SD2->D2_SERIE
				SZ2->Z2_TOTAL   := SD2->D2_TOTAL
				SZ2->Z2_DTEMIS  := SD2->D2_EMISSAO
				SZ2->Z2_CRM     := SC5->C5_CRM
				MsUnlock()
			Else
				RecLock("SZ2",.F.)
				SZ2->Z2_TOTAL += SD2->D2_TOTAL
				MsUnlock()
			EndIf
		EndIf

		If SC6->C6_ETQPROD # "S" .AND. SC6->C6_ETQPROD # " "

			nQuant   := SC6->C6_QTDENT
			nAchou   := 0
			cSituacao:= Space(3)
			nRecZ3   := 0

			DbSelectArea("SZ3")
			DbSetOrder(11) // FILIAL + PEDIDO + ITEM
			DbSeek(xFilial("SZ3")+SC6->C6_NUM+SC6->C6_ITEM)
			Do While Z3_PEDIDOV + Z3_ITEMPV  == SC6->C6_NUM+SC6->C6_ITEM .And. !EOF()
				If Z3_SITUACA == "RES"
					If SC5->C5_TIPO == "D"   // Devolucao de Compra
						cSituacao := "DVC"
						nAchou += 1
					Else
						If SD2->D2_serie == "CON"   // Consignacao
							cSituacao :="CON"
							nAchou += 1
						Else
							If SC6->C6_ETQPROD == "R"  // Reposicao
								If Empty(Z3_NFSAIDA)
									nAchou += 1
									cSituacao := "CON"
								Else
									cSituacao := "FAT"
								EndIf
							Else
								nAchou += 1
								cSituacao := Iif(SC6->C6_ETQPROD == "V","CON","FAT")
							EndIf
						EndIf
					EndIf
					RecLock("SZ3",.F.)
					SZ3->Z3_SITUACA := cSituacao
					SZ3->Z3_NFSAIDA := SD2->D2_DOC
					SZ3->Z3_ITEMNFS := SD2->D2_ITEM
					SZ3->Z3_SERISAI := SD2->D2_SERIE
					SZ3->Z3_DATASAI := SD2->D2_EMISSAO
					SZ3->Z3_CLIENTE := IIF(cSituacao=="FAT", SC5->C5_CLIENTE, SC5->C5_CLIVALE)
					SZ3->Z3_LOJACLI := IIF(cSituacao=="FAT", SC5->C5_LOJACLI, SC5->C5_LJCVALE)
					If cSituacao=="CON" .and. SC6->C6_ETQPROD # "R"
						SZ3->Z3_NFSVAL := SD2->D2_DOC
						SZ3->Z3_SERVAL := SD2->D2_SERIE
						SZ3->Z3_DATVAL := SD2->D2_EMISSAO
						SZ3->Z3_CLIVAL := SC5->C5_CLIVALE
						SZ3->Z3_LOJVAL := SC5->C5_LJCVALE
					EndIf
					MsUnLock("SZ3")

					nRecZ3 := RecNo()

					dbSelectArea('SZ7')
					dbSetOrder(1)
					RecLock("SZ7",.T.)
					SZ7->Z7_FILIAL  := xFilial("SZ7")
					SZ7->Z7_TIPO    := "S"
					SZ7->Z7_SITUACA := cSituacao
					SZ7->Z7_CODETIQ := SZ3->Z3_CODETIQ
					SZ7->Z7_NFISCAL := SD2->D2_DOC
					SZ7->Z7_SERIE   := SD2->D2_SERIE
					SZ7->Z7_DATA    := SD2->D2_EMISSAO
					SZ7->Z7_CLIFOR  := SZ3->Z3_CLIENTE
					SZ7->Z7_LOJACF  := SZ3->Z3_LOJACLI
					SZ7->Z7_PEDIDO  := SZ3->Z3_PEDIDOV
					SZ7->Z7_ITEMPV  := SZ3->Z3_ITEMPV
					SZ7->Z7_ETQREP  := SZ3->Z3_ETQREP
					MsUnLock("SZ7")

					DbSelectarea("SZ3")
					DbGoTo(nRecZ3)
				EndIf
				dbSkip()
			EndDo
			If nAchou # nQuant
				Alert("Verifique o que Houve, pois a Quantidade Indicada do Produto "+AllTrim(SD2->D2_COD)+", na Nota Fiscal ้ Maior que a Quantidade Selecionada!")
			EndIf
		EndIf

		If SC5->C5_CLIENTE == "CRM001"

			RecLock("SD2",.F.)
			SD2->D2_CRM := SC5->C5_CRM
			MsUnLock("SD2")

		EndIf

	EndIf

	RecLock("SD2",.F.)
	SD2->D2_CONTA  := SC6->C6_CONTA
	SD2->D2_ITEMCC := SC6->C6_ITEMCTB
	SD2->D2_CCUSTO := SC6->C6_CCUSTO
	SD2->D2_KITPAI := SC6->C6_KITPAI
	If !EMPTY(SC6->C6_XETIQ)
		SD2->D2_SPKSER := SC6->C6_XETIQ
	Else
		SD2->D2_SPKSER := SC9->C9_SPKSER
	Endif
	MsUnlock()

	if !lUsaSpark
		//rotina para atualizar as informacoes de saida - etiqueta - CB0
		u_xAtuCB0(SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA,SD2->D2_ITEM,SD2->D2_COD,SD2->D2_PEDIDO,SD2->D2_ITEMPV,SD2->D2_ORDSEP,SC6->C6_XETIQ)
	elseif !empty(SD2->D2_SPKSER)
		//rotina para atualizar as informacoes de saida - etiqueta - CB0
		SparkCB0Inc(SD2->D2_LOTECTL)
		//u_xAtuCB0(SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA,SD2->D2_ITEM,SD2->D2_COD,SD2->D2_PEDIDO,SD2->D2_ITEMPV,SD2->D2_ORDSEP,SD2->D2_SPKSER)

	endif

	//Baixa saldo da etiqueta
	IF !Empty(SC5->C5_AF)
		DBSelectArea("ZZJ")
		DBSetorder(1)
		IF DBSeek(xFilial("ZZJ")+ SD2->D2_SPKSER+SD2->D2_LOTECTL+SD2->D2_COD)
			RecLock("ZZJ",.F.)
			ZZJ->ZZJ_QTDE := ZZJ_QTDE - SD2->D2_QUANT
			MsUnlock()
		Endif
	Else
		DBSelectArea("ZZJ")
		DBSetorder(1)
		IF !DBSeek(xFilial("ZZJ")+ SD2->D2_SPKSER+SD2->D2_LOTECTL+SD2->D2_COD)
			RecLock("ZZJ",.T.)
			ZZJ->ZZJ_FILIAL := xFilial("ZZJ")
			ZZJ->ZZJ_PRODUT := SD2->D2_COD
			ZZJ->ZZJ_LOTE   := SD2->D2_LOTECTL
			ZZJ->ZZJ_SERIAL := SD2->D2_SPKSER
			ZZJ->ZZJ_QTDE   := SD2->D2_QUANT
			MsUnlock()
		Endif
	Endif

	// retorna area original
	RestArea(aArea)

Return()

Static Function SparkCB0Inc(cSPKSer)
	Local aSB8Area := SB8->( GetArea() )

	dbSelectArea("CB0")
	dbSetOrder(1)
	If ( ! dbSeek(xFilial("CB0") +  cSPKSer)  )

		dbSelectArea("CB0")
		RecLock("CB0",.T.)

		CB0->CB0_FILIAL		:= xFilial("CB0")
		CB0->CB0_CODETI		:= cSPKSer
		CB0->CB0_DTNASC		:= Posicione("SB8",1, xfilial("SB8")+SD2->D2_LOTECTL,"B8_DATA")
		CB0->CB0_TIPO		:= "01"
		CB0->CB0_CODPRO		:= SD2->D2_COD
		CB0->CB0_QTDE		:= 1 //TSB8->B8_QTDORI
		CB0->CB0_USUARI		:= ""  //RetCodUsr()
		//CB0->CB0_DISPID		:=
		CB0->CB0_LOCAL		:= SD2->D2_LOCAL
		//CB0->CB0_LOCALI		:= ""
		CB0->CB0_LOTE		:= SD2->D2_LOTECTL
		//CB0->CB0_SLOTE		:= TSB8->B8_NUMLOTE
		CB0->CB0_DTVLD		:= SD2->D2_DTVALID
		//CB0->CB0_OP			:= ""
		//CB0->CB0_NUMSEQ		:=
		//CB0->CB0_CODET2		:=
		//CB0->CB0_ENDSUG		:=
		//CB0->CB0_FORNEC		:= TSB8->B8_FORORI
		//CB0->CB0_LOJAFO		:= TSB8->B8_LOJORI
		//CB0->CB0_PEDCOM		:=
		//CB0->CB0_NFENT		:= TSB8->B8_DOCORI
		//CB0->CB0_SERIEE		:= TSB8->B8_SERORI

		////_nTamDoc			:= TamSx3("F2_DOC")[1]
		////_nTamSer			:= TamSx3("F2_SERIE")[1]
		////_nTamCli			:= TamSx3("F2_CLIENTE")[1]
		////_nTamLoj			:= TamSx3("F2_LOJA")[1]
		////_nTamPed			:= TamSx3("C5_NUM")[1]

		////_cDoc				:= SubStr(TSB8->DOCUM,1,_nTamDoc)
		////_cSerie				:= SubStr(TSB8->DOCUM,1 + _nTamDoc ,_nTamSer)
		////_cliente			:= SubStr(TSB8->DOCUM,1 +_nTamDoc + _nTamSer,_nTamCli)
		////_cLoja				:= SubStr(TSB8->DOCUM,1 +_nTamDoc + _nTamSer + _nTamCli,_nTamLoj)
		////_cPedido			:= SubStr(TSB8->DOCUM,1 +_nTamDoc + _nTamSer + _nTamCli + _nTamLoj , _nTamPed)

		////CB0->CB0_NFSAI		:= _cDoc
		////CB0->CB0_SERIES		:= _cSerie
		////CB0->CB0_CLI		:= _cliente
		////CB0->CB0_LOJACL		:= _cLoja
		////CB0->CB0_PEDVEN		:= _cPedido

		//CB0->CB0_VOLUME		:=
		//CB0->CB0_TRANSP		:=
		//CB0->CB0_STATUS		:=
		//CB0->CB0_LOCORI		:=
		//CB0->CB0_CC			:= "" //TSB8->D1_CC
		//CB0->CB0_PALLET		:=
		//CB0->CB0_OPREQ		:=
		//CB0->CB0_NUMSER		:=
		CB0->CB0_ORIGEM			:=  "WSXSPARK"
		//CB0->CB0_ITNFE		:=
		//CB0->CB0_SDOCS		:=
		//CB0->CB0_SDOCE		:=

		CB0->CB0_XIMP			:= "S"
		//CB0->CB0_LOTEFO		:= TSB8->B8_LOTEFOR
		CB0->CB0_NFSAI 			:= SD2->D2_DOC
		CB0->CB0_SERIES			:= SD2->D2_SERIE
		CB0->CB0_CLI 			:= SD2->D2_CLIENTE
		CB0->CB0_LOJACL 		:= SD2->D2_LOJA
		CB0->CB0_PEDVEN			:= SD2->D2_PEDIDO

		CB0->(MsUnLock())
	Endif

	RestArea(aSB8Area)
Return