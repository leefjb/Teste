/*  ATENCAO PARA PARA A ATUALIZACAO DA NFESEFAZ / DANFE
1- ativar o parametro MV_LOGOD = S     (para usar o padrao do Protheus) nome do logo = "DANFE" + empresa + filial ".BMP"
2- ativar o parametro MV_IMPADIC = .T. (Define se sera impresso as informacoes adicionais do paroduto)

*/


#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PE01NFESEFAZ                                               ³±±
±±³          ³ Marllon Figueiredo                       ³ Data ³ 10/09/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada para tratamentos especificos de cliente   ³±±
±±³          ³ na geracao do XML da nota fiscal eletronica                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                         Manutencoes                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Motivo                                            ³  Data  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´±±
±±º           ³                                                           º±±
±±º           ³                                                           º±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PE01NFESEFAZ()
Local aArea     := GetArea()
Local aAreaSF2  := SF2->( GetArea() )
Local aAreaSD2  := SD2->( GetArea() )
Local aAreaSF1  := SF1->( GetArea() )
Local aAreaSD1  := SD1->( GetArea() )
Local aAreaSF4  := SF4->( GetArea() )
Local aAreaSB8  := SB8->( GetArea() )
Local aProduto	 := Array(0)
Local aInfoProd  := Array(0)
Local aProdInfAd := Array(0)

// recupera os dados
Local aProd		:= aParam[1]
Local cMensCli	:= aParam[2]
Local cMensFis	:= aParam[3]
Local aDest 	:= aParam[4]
Local aNota 	:= aParam[5]
Local aInfoItem	:= aParam[6]
Local aDupl		:= aParam[7]
Local aTransp	:= aParam[8]
Local aEntrega	:= aParam[9]
Local aRetirada	:= aParam[10]
Local aVeiculo	:= aParam[11]
Local aReboque	:= aParam[12]

Local nI
Local nPos
Local cTipo         := ''
Local aMsgTES       := {}
Local aMsgFormulas  := {}
Local nValorII      := 0
Local aPedVen       := {}
Local aNFOri        := {}
Local cNum          := ""
Local cEmailCV		:= ""

// uso o CFOP para identificar o tipo da nota fiscal (entrada ou saida)
If aProd[1,7] >= '5000'
	cTipo := '1'    // saida
Else
	cTipo := '0'    // entrada
EndIf

If cTipo = '1'    // SAIDA
	// ===========================================================================
	// informacao de mensagens das TES
	DbSelectArea("SD2") // * Tipos de Entrada e Saida
	dbSetOrder(3)       // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	DbSelectArea("SM4") // * Formulas
	dbSetOrder(1)
	DbSelectArea("SF4") // * Tipos de Entrada e Saida
	dbSetOrder(1)            
	DbSelectArea("SB8") // * Saldos por Lote
	dbSetOrder(2)

	// processamento do array aProd para acerta-lo com as regras do cliente
	
	//estrutura de aInfoItem: 1 - D2_PEDIDO
	//                        2 - D2_ITEMPV
	//                        3 - D2_TES
	//                        4 - D2_ITEM
	For nP := 1 To Len(aInfoItem)

		// especifico - tratamento do tipo de produto a ser impresso na DANFe
		/* Regras
			1 = quando o produto (item) for um KIT ou Produto normal de Venda (imprime como item normal da nota)
			2 = quando o produto (item) for um componente do Kit              (relaciona em dados adicionais do produto)
			3 = quando for troca de produto (vende um => entrega outro        (não imprime na nota)
		*/

		// posiciona no SC5 / SC6 / SD2 / SB1 
		SC5->( dbSeek(xFilial('SC5')+aInfoItem[nP,1]) )
		SC6->( dbSeek(xFilial('SC6')+aInfoItem[nP,1]+aInfoItem[nP,2]) )
		SD2->( dbSeek(xFilial('SD2')+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+aProd[nP,2]+aInfoItem[nP,4]) )
		SB1->( dbSeek(xFilial('SB1')+aProd[nP,2]) )
		SB8->( dbSeek(xFilial('SB8') + SD2->D2_NUMLOTE + SD2->D2_LOTECTL + aProd[nP,2] + SD2->D2_LOCAL))

		// especifico Jomhedica
		cSacado := SC5->C5_SACADO + SC5->C5_LSACADO

		If SC6->C6_IMPNF == '1'   // todos os produtos que nao forem COMPONENTES

			// tratamento de CODIGO e DESCRICAO para Jomhedica
			// obeservar documento no servidor:
			//    C:\TOTVS\TotvsDocs\documentos\jomhedica\documentos\procedimentos\DEFINICAO_AMARRACAO_PRODUTO_CONVENIO.DOC
			
			lConvenio := .f.
			__cCodPro := SD2->D2_COD
			__cDescri := Alltrim(Iif(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI))
			dbSelectArea("SA7")
			dbSetOrder(1)
			If SA7->( dbSeek(xFilial('SA7')+'CONVEN'+SC5->C5_CONVENI+SD2->D2_COD) ) .and. ! Empty(SA7->A7_PRODUTO)
				lConvenio := .t.
				__cCodPro := SA7->A7_CODCLI
				If ! Empty(SA7->A7_DESCCLI)
					__cDescri := Alltrim(SA7->A7_DESCCLI)
				EndIf
			Endif
			
			SF4->( dbSeek(xFilial('SF4') + aInfoItem[nP,3]) )
			
			aMsgTES := {SF4->F4_MENS1,SF4->F4_MENS2,SF4->F4_MENS3, SF4->F4_MENS4, SF4->F4_MENS5}
			For nI := 1 to Len(aMsgTES)
				If ! Empty(aMsgTES[nI])
					nPos := aScan( aMsgFormulas , aMsgTES[nI] )
					If nPos == 0
						aAdd( aMsgFormulas , aMsgTES[nI] )
//						cMensCli += Iif(Empty(AllTrim(FORMULA(aMsgTES[nI]))), '', AllTrim(FORMULA(aMsgTES[nI]))+'/p/') Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016
						cMensCli += Iif(Empty(AllTrim(FORMULA(aMsgTES[nI]))), '', AllTrim(FORMULA(aMsgTES[nI])))
					Endif
				Endif
			Next
			If ! (Alltrim(SF4->F4_MENS) $ cMensCli)
//				cMensCli += Alltrim(SF4->F4_MENS)+"/p/" Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016
				cMensCli += Alltrim(SF4->F4_MENS)
			EndIf
			
			If ! Empty(SD2->D2_NFORI)
				nPos := aScan( aNFOri, SD2->D2_NFORI )
				If nPos == 0
					Aadd( aNFOri, SD2->D2_NFORI )
				EndIf
			EndIf
	
			// informacao do numero do Pedido de Vendas
			If aScan( aPedVen, {|x| x == SD2->D2_PEDIDO} ) <= 0
				aadd(aPedVen, SD2->D2_PEDIDO)
			EndIf
	
			// adiciona os dados de informacao adicional do produto				
			Aadd(aProduto, aClone(aProd[nP]))
			aProduto[Len(aProduto),2] := __cCodPro
			aProduto[Len(aProduto),4] := Substr(__cDescri,1,120)
			Aadd(aInfoProd, aClone(aInfoItem[nP]))

			// Informacoes adicionais do produto
			__cInfoProd := ''
			
			// numero de serie
			If ! Empty(SD2->D2_NUMSERI)
//				__cInfoProd += " Num.Serie: "+Alltrim(SD2->D2_NUMSERI)+"/p/" Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016
				__cInfoProd += " Num.Serie: "+Alltrim(SD2->D2_NUMSERI)
			EndIf          
			
			// numero do lote e validade
			If Empty(SD2->D2_NUMSERI) .and. ! Empty(SD2->D2_LOTECTL)
//				__cInfoProd += 'SÉRIE: '+SD2->D2_LOTECTL+' VALIDADE: '+SUBSTR(DTOC(SD2->D2_DTVALID), 4)+'/p/' Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016
				__cInfoProd += 'SÉRIE: '+SD2->D2_LOTECTL+' VALIDADE: '+SUBSTR(DTOC(SD2->D2_DTVALID), 4)
			EndIf                                                                                 
			
			// lote do fornecedor 
			// Alteração O para buscar o lote do fornecedor correto 28/06/2016 Eliane 
		   //	SB8->( dbSeek(xFilial('SB8') + SD2->D2_NUMLOTE + SD2->D2_LOTECTL + SD2->D2_COD + SD2->D2_LOCAL))
			If ! Empty(SB8->B8_LOTEFOR)
//				__cInfoProd += 'LOTE FORNECEDOR: '+SB8->B8_LOTEFOR+'/p/' Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016
				__cInfoProd += 'LOTE FORNECEDOR: '+SB8->B8_LOTEFOR
			EndIf
			
			// registro do ministerio da saude
			If ! Empty(SB1->B1_RMS)
//				__cInfoProd += 'RMS: '+SB1->B1_RMS+'/p/' Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016
				__cInfoProd += 'RMS: '+SB1->B1_RMS
			EndIf
			
			// tratamento do hospital Conceicao
			If SA1->A1_COD $ '00036 /00037 /00038 /'  // codigo do cliente Hospital Conceição
				cFabricante := SB1->B1_CODFAB
				cDadoConcei := ''
				if SB1->B1_CLASSE == "1"
					cDadoConcei += " CLASSE: BAIXO RISCO"
				else
					if SB1->B1_CLASSE == "2"
						cDadoConcei += " CLASSE: MEDIO RISCO"
					else
						cDadoConcei += " CLASSE: ALTO RISCO"
					endif
				endif
				If SA2->( DbSeek(xFilial("SA2")+ cFabricante) )
				 //	cDadoConcei += " - FABRICANTE: "  + Alltrim(SA2->A2_NOME) + "/p/" Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016
		   		    cDadoConcei += " - FABRICANTE: "  + Alltrim(SA2->A2_NOME)
					cDadoConcei += " - ENDERECO: "  + Alltrim(SA2->A2_END)
				//  cDadoConcei += " - MUNICIPIO: " + Alltrim(SA2->A2_MUN) + "/p/" Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016
					cDadoConcei += " - MUNICIPIO: " + Alltrim(SA2->A2_MUN)
					cDadoConcei += " - CEP: " + SA2->A2_CEP
				//	cDadoConcei += " - CNPJ: " + SA2->A2_CGC + "/p/" Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016
					cDadoConcei += " - CNPJ: " + SA2->A2_CGC
				EndIf
				
				// adiciona os dados de informacao adicional do produto	especifico para o hospital Conceiçao  (pe01)
				Aadd(aProdInfAd,{aProd[nP,1], __cCodPro,,,,__cInfoProd+cDadoConcei})
				
			Else
				
				Aadd(aProdInfAd,{aProd[nP,1], __cCodPro,,,,__cInfoProd})
				
			EndIf
			
		ElseIf SC6->C6_IMPNF == '2'   // venda com componente

			// adiciona os dados de informacao adicional do produto				
			Aadd(aProdInfAd,{aProd[nP,1],;
							 SD2->D2_KITPAI,;
							 SD2->D2_COD,;
							 Iif(!empty(SD2->D2_LOTECTL), SD2->D2_LOTECTL, ""),;
							 SD2->D2_QUANT})
        
		EndIf
		
	Next
	
	// dados adicionais da nota de devolucao
	If Len( aNFOri ) > 0
		cMensCli += 'Devolucao / Retorno ref. Nota(s) Num. '
		cNum := Space(0)
		For nI := 1 to Len( aNFOri )
			cNum += AllTrim(aNFOri[nI])+'/'
		Next
//		cMensCli += cNum+'/p/' Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 
		cMensCli += cNum
	Endif
				
	// informa pedidos de venda
	//If Len(aPedVen) > 0
//		cMensCli += 'Pedido(s): ' + SC5->C5_NUM + ' - ' + 'Vendedor: '+Alltrim(SC5->C5_VEND1) + '/p/' Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 
		cMensCli += 'Pedido(s): ' + SC5->C5_NUM + ' - ' + 'Vendedor: '+Alltrim(SC5->C5_VEND1)
	//	For nI := 1 To Len(aPedVen)
	//		cMensCli += aPedVen[nI]+'/'
	//	Next
		//cMensCli += 'p/'
	//EndIf
	//cMensCli += 'Vendedor: '+Alltrim(SC5->C5_VEND1) + '/p/'
	
	// tratamento da mensagem de deposito (pe01 - ok)
	If SC5->C5_MSGDEP == '1'
		If Len(aDupl) > 0
			If ! SF2->F2_TIPO $ "DB"
				//cMensCli += 'FAVOR EFETUAR DEPOSITO NO BANCO DO BRASIL AG: 3415-0 CONTA: 1704-3 CODIGO IDENTIFICADOR: ' + SA1->A1_CGC + '/p/' Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 
				cMensCli += 'FAVOR EFETUAR DEPOSITO NO BANCO DO BRASIL AG: 3415-0 CONTA: 1704-3 CODIGO IDENTIFICADOR: ' + SA1->A1_CGC
			EndIf
		EndIf
	EndIf

	// bloco especifico para grupo Jomhedica
	// Inicio do bloco -------------------------------------------------------
	// somente empresas do grupo que vendem para atender uma cirurgia
	If ! (cEmpAnt $ '10/')
		
		dbSelectArea("SZ1")
		dbSetOrder(1)
		
		SX5->( dbSeek(xFilial("SX5")+"Z1"+SC5->C5_CONVENI) )
		cConvenio := SC5->C5_DESCCON
		SZ1->( dbSeek(xFilial("SZ1")+SC5->C5_CRM) )
		
		If cEmpAnt <> '05'
		
			aArea    := GetArea()
			aAreaSA1 := SA1->( GetArea() )
			
			dbSelectArea("SA1")
			If dbSeek(xFilial("SA1") + cSacado)
				cMensCli += 'Sacado: '+Alltrim(SA1->A1_NOME)+" - "+ SA1->A1_COD 
				cMensCli += 'Endereco: '+Alltrim(SA1->A1_END)+'   CEP: '+SA1->A1_CEP 
				cMensCli += 'Municipio: '+Alltrim(SA1->A1_MUN)+'   UF: '+SA1->A1_EST 
				cMensCli += 'Insc.CNPJ: '+Alltrim(SA1->A1_CGC)+'   Insc.Estadual: '+SA1->A1_INSCR 
/* Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 				
				cMensCli += 'Sacado: '+Alltrim(SA1->A1_NOME)+" - "+ SA1->A1_COD + '/p/'  
				cMensCli += 'Endereco: '+Alltrim(SA1->A1_END)+'   CEP: '+SA1->A1_CEP + '/p/'
				cMensCli += 'Municipio: '+Alltrim(SA1->A1_MUN)+'   UF: '+SA1->A1_EST + '/p/'
				cMensCli += 'Insc.CNPJ: '+Alltrim(SA1->A1_CGC)+'   Insc.Estadual: '+SA1->A1_INSCR + '/p/'
*/
			EndIf                                                                                 
			
/* Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 				
			If ! Empty(SC5->C5_PACIENT)
				cMensCli += 'Paciente: '+Alltrim(SC5->C5_PACIENT)+'   Convenio: '+cConvenio + '/p/'
			EndIf
			If ! Empty(SC5->C5_DTCIRUG)
				cMensCli += 'No. A.I.H.: '+Alltrim(SC5->C5_IH)+'   Data Cirurgia: '+Dtoc(SC5->C5_DTCIRUG) + '/p/'
			EndIf
			If ! Empty(SZ1->Z1_NOME)
				cMensCli += 'Cirurgiao: '+Alltrim(SZ1->Z1_NOME)+'   CRM: '+SC5->C5_CRM + '/p/'
			EndIf
*/		

			If ! Empty(SC5->C5_PACIENT)
				cMensCli += 'Paciente: '+Alltrim(SC5->C5_PACIENT)+'   Convenio: '+cConvenio 
			EndIf
			If ! Empty(SC5->C5_DTCIRUG)
				cMensCli += 'No. A.I.H.: '+Alltrim(SC5->C5_IH)+'   Data Cirurgia: '+Dtoc(SC5->C5_DTCIRUG) 
			EndIf
			If ! Empty(SZ1->Z1_NOME)
				cMensCli += 'Cirurgiao: '+Alltrim(SZ1->Z1_NOME)+'   CRM: '+SC5->C5_CRM 
			EndIf
			RestArea( aAreaSA1 )
			RestArea( aArea )
		
		EndIf
		
	EndIf
	
	// Enviar e-mail para C5_CLIVALE, quando este for diferente de C5_CLIENTE
	// Leandro Marquardt Solutio - 17/07/2017
	If SC5->C5_CLIENTE + SC5->C5_LOJACLI <> SC5->C5_CLIVALE + SC5->C5_LJCVALE
	    
		// verifica se TES gera duplicata
		SC6->(dbSeek(xFilial('SC6') + SC5->C5_NUM))
		SF4->(dbSeek(xFilial('SF4') + SC6->C6_TES))
		If SF4->F4_DUPLIC == "S"
			cEmailCV := AllTrim(Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIVALE + SC5->C5_LJCVALE,"A1_EMAIL"))
			aDest[16] := AllTrim(aDest[16]) + ";" + cEmailCV
		EndIf
	
	EndIf
		
Else         // ENTRADA

	// ===========================================================================
	// informacao de mensagens das TES
	DbSelectArea("SD1")
	dbSetOrder(1)       // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	DbSelectArea("SM4") // * Formulas
	dbSetOrder(1)
	DbSelectArea("SF4") // * Tipos de Entrada e Saida
	dbSetOrder(1)

	// processamento do array aProd para acerta-lo com as regras do cliente
	
	//estrutura de aInfoItem: 1 - D1_PEDIDO
	//                        2 - D1_ITEMPV
	//                        3 - D1_TES
	//                        4 - D1_ITEM
	For nP := 1 To Len(aInfoItem)
		
		// especifico - tratamento do tipo de produto a ser impresso na DANFe
		/* Regras
			1 = quando o produto (item) for um KIT ou Produto normal de Venda (imprime como item normal da nota)
			2 = quando o produto (item) for um componente do Kit              (relaciona em dados adicionais do produto)
			3 = quando for troca de produto (vende um => entrega outro        (não imprime na nota)
		*/

		// posiciona no SC5 / SC6 / SD2 / SB1 
		SD1->( dbSeek(xFilial('SD1')+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+aProd[nP,2]+aInfoItem[nP,4]) )
		SB1->( dbSeek(xFilial('SB1')+aProd[nP,2]) )
		SD2->( dbSetOrder(3) )
		SD2->( dbSeek(xFilial('SD2')+SD1->D1_NFORI+SD1->D1_SERIORI) )
		SC5->( dbseek(xFilial('SC5')+SD2->D2_PEDIDO) )
		SF4->( dbSeek(xFilial('SF4')+SD1->D1_TES) )

		If SD1->D1_NFIMP $ ' 1'

			// obeservar documento: \\server\microsiga\documentos\Jomhedica\Documentos\procedimentos\DEFINICAO_AMARRACAO_PRODUTO_CONVENIO.DOC
			lConvenio := .f.
			__cCodPro := SD1->D1_COD
			__cDescri := ALLTRIM(SB1->B1_DESC)
			cCodConv  := SC5->C5_CONVENI                                                  
			
			dbSelectArea("SA7")                                                          
			dbSetOrder(1)
			If SA7->( dbSeek(xFilial('SA7')+'CONVEN'+cCodConv+SD1->D1_COD) ) .and. ! Empty(SA7->A7_PRODUTO)
				lConvenio := .t.
				__cCodPro := SA7->A7_CODCLI
				If ! Empty(SA7->A7_DESCCLI)
					__cDescri := Alltrim(SA7->A7_DESCCLI)
				EndIf
			Endif

			// numero do lote e validade
			__cInfoProd := ''
			If ! Empty(SD1->D1_LOTECTL)
				//__cInfoProd += 'SÉRIE: '+SD2->D2_LOTECTL+' VALIDADE: '+SUBSTR(DTOC(SD2->D2_DTVALID), 4)+'/p/'
				// Jean Rehermann - SOLUTIO IT - 26/08/2016 - Estava imprimindo o registro do SD2 e não do SD1
//				__cInfoProd += 'SÉRIE: '+SD1->D1_LOTECTL+' VALIDADE: '+SUBSTR(DTOC(SD1->D1_DTVALID), 4)+'/p/' Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 				
				__cInfoProd += 'SÉRIE: '+SD1->D1_LOTECTL+' VALIDADE: '+SUBSTR(DTOC(SD1->D1_DTVALID), 4)
			EndIf
			
			// lote do fornecedor
			If ! Empty(SB8->B8_LOTEFOR)
//				__cInfoProd += 'LOTE FORNECEDOR: '+SB8->B8_LOTEFOR+'/p/' Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 				
				__cInfoProd += 'LOTE FORNECEDOR: '+SB8->B8_LOTEFOR
			EndIf
			
			// registro do ministerio da saude
			If ! Empty(SB1->B1_RMS)
//				__cInfoProd += 'RMS: '+SB1->B1_RMS+'/p/' Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 	  
				__cInfoProd += 'RMS: '+SB1->B1_RMS			
			EndIf

			aMsgTES := {SF4->F4_MENS1,SF4->F4_MENS2,SF4->F4_MENS3, SF4->F4_MENS4, SF4->F4_MENS5}
			For nI := 1 to Len(aMsgTES)
				If ! Empty(aMsgTES[nI])
					nPos := aScan( aMsgFormulas , aMsgTES[nI] )
					If nPos == 0
						aAdd( aMsgFormulas , aMsgTES[nI] )
//						cMensCli += Iif(Empty(AllTrim(FORMULA(aMsgTES[nI]))), '', AllTrim(FORMULA(aMsgTES[nI]))+'/p/')  Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 
						cMensCli += Iif(Empty(AllTrim(FORMULA(aMsgTES[nI]))), '', AllTrim(FORMULA(aMsgTES[nI])))
					Endif
				Endif
			Next
			If ! (Alltrim(SF4->F4_MENS) $ cMensCli)
//				cMensCli += Alltrim(SF4->F4_MENS)+"/p/"  Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 
				cMensCli += Alltrim(SF4->F4_MENS)
			EndIf
			//If ! Empty(SF1->F1_MENOTA)
			//	cMensCli += AllTrim(SF1->F1_MENOTA)
			//EndIf
			
			If ! Empty(SD1->D1_NFORI)
				nPos := aScan( aNFOri, SD1->D1_NFORI )
				If nPos == 0
					Aadd( aNFOri, SD1->D1_NFORI )
				EndIf
			EndIf

			// adiciona os dados de informacao adicional do produto				
			Aadd(aProduto, aClone(aProd[nP]))
			aProduto[Len(aProduto),2] := __cCodPro
			aProduto[Len(aProduto),4] := Substr(__cDescri,1,120)
			Aadd(aInfoProd, aClone(aInfoItem[nP]))

			// adiciona os dados de informacao adicional do produto				
			Aadd(aProdInfAd,{aProd[nP,1], __cCodPro,,,,__cInfoProd})

		ElseIf	(cAliasSD1)->D1_NFIMP == '2'   // venda com troca de produto
			// adiciona os dados de informacao adicional do produto				
			aadd(aProdInfAd,{aProd[nP,1],;
							 SD1->D1_KITPAI,;
							 SD1->D1_COD,;
							 Iif(!empty(SD1->D1_LOTECTL), SD1->D1_LOTECTL, ""),;
							 SD1->D1_QUANT})
		EndIf

	Next

	// dados adicionais da nota de devolucao
	If Len( aNFOri ) > 0
		cMensCli += 'Devolucao / Retorno ref. Nota(s) Num. '
		cNum := Space(0)
		For nI := 1 to Len( aNFOri )
			cNum += AllTrim(aNFOri[nI])+'/'
		Next
//		cMensCli += cNum+'/p/' Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 
		cMensCli += cNum
	Endif
	// mensagem para a nota
	If ! Empty(SF1->F1_MENOTA)
		cMensCli += AllTrim(SF1->F1_MENOTA)
	EndIf

Endif

// especifico - tratamento dos dados adicionais (Kit / Troca de Produto)  (pe01)
//[1] = Item do array
//[2] = Produto Kit
//[3] = Produto Componente / Troca
//[4] = Numero do Lote
//[5] = Quantidade
//[6] = Informacoes adicionais do produto (tag:infadprod)

For nP := 1 To Len(aProduto)
	cAdProd := ""
	For nI := 1 To Len( aProdInfAd )
		If aProdInfAd[nI,2] == aProduto[nP, 2]   // compara o codigo do Produto Pai / Kit
			If Len(aProdInfAd[nI]) > 5
				If aProduto[nP, 1] == aProdInfAd[nI,1] .and. ! (aProdInfAd[nI,6] $ cAdProd)
					cAdProd += aProdInfAd[nI,6]
				EndIf
			Else
			//	cAdProd += aProdInfAd[nI,3] + "  LOTE: " + aProdInfAd[nI,4] + "  QTD: " + Str(aProdInfAd[nI,5],4,0) + "/p/" Rodrigo Carvalho Solutio, correção para remover a impressão dos caracteres /p/ 13/12/2016 
				cAdProd += aProdInfAd[nI,3] + "  LOTE: " + aProdInfAd[nI,4] + "  QTD: " + Str(aProdInfAd[nI,5],4,0)
			EndIf
		EndIf
	Next
	aProduto[nP, 25] += cAdProd
Next

// atualiza dados para o NFESEFAZ
aParam[1]  := aProduto
aParam[2]  := cMensCli
aParam[3]  := cMensFis
aParam[4]  := aDest
aParam[5]  := aNota 	
aParam[6]  := aInfoProd	
aParam[7]  := aDupl		
aParam[8]  := aTransp
aParam[9]  := aEntrega	
aParam[10] := aRetirada	
aParam[11] := aVeiculo	
aParam[12] := aReboque	

RestArea( aAreaSF2 )
RestArea( aAreaSD2 )
RestArea( aAreaSF1 )
RestArea( aAreaSD1 )
RestArea( aAreaSF4 )
RestArea( aAreaSB8 )
RestArea( aArea )

Return( aParam )
