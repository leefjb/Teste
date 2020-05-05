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

MsUnlock()

// retorna area original
RestArea(aArea)

Return
