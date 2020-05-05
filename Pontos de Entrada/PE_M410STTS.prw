//#Include "Totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ M410STTS ³ Autor ³ Marcelo Tarasconi     ³ Data ³22/08/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada pertence a rotina de pedidos de venda,    ³±±
±±³          ³ MATA410().                                                 ³±±
±±³          ³ Esta em todas as rotinas de Alteracao, Inclusao, Exclusao  ³±±
±±³          ³ Copia e Devolucao de Compras.                              ³±±
±±³          ³ Executado apos todas as alteracoes no arquivo de pedidos   ³±±
±±³          ³ terem sido feitas.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M410STTS()

	Local lReturn	:= .t.
	Local aArea 	:= GetArea()
	Local aSC6area  := SC6->( GetArea() )
	Local lUsaSpark := SuperGETMV("MV_SPARK",.F.)
	Private cErro   
	If lUsaSpark
		
		if  !Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ) //.and. Empty(SC5->C5_AF) // entra se o PV estiver liberado e nao for originado de AF
			//MsgRun( "Obtendo Lotes e Seriais do WMS" ,, {||lRet :=  U_WMSWsFinishOrder(SC5->C5_NUM) } )  //Chamada para atribuir o lote e serial do SPARK
			FWMsgRun( , {|| U_WSWMSStartTask(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_EMISSAO,SC5->C5_TPTRANS,aCols,aHeader,SC5->C5_TRANSP,SC5->C5_ANOTA,@cErro)},"Integração SPARK","Solicitando coleta ao WMS"  )
		endif

		dbSelectArea("SC6")
		dbSetOrder(1)
		dbseek( xFilial("SC6") + SC5->C5_NUM)
		While !eof() .and. SC5->C5_FILIAL + SC5->C5_NUM == SC6->C6_FILIAL + SC6->C6_NUM
			if inclui .or. altera
				cStmt := "UPDATE " + RetSQLName("ZX4")
				cStmt += " SET D_E_L_E_T_ = '*' "
				cStmt += " WHERE ZX4_FILIAL = '"+ xFilial("ZX4") + "' "
				cStmt += "   AND ZX4_ENT = 'SC6' "
				cStmt += "   AND ZX4_CHAVE = '"+ SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM + SC6->C6_PRODUTO + "' AND D_E_L_E_T_ = ''"
				TCSqlExec(cStmt)

				u_IncluiZX4("SC6",SC6->C6_FILIAL +SC6->C6_NUM +SC6->C6_ITEM + SC6->C6_PRODUTO,sc6->(Recno()))
			endif

			DBSelectArea("SC6")
			DBSkip()
		end

		if !empty(cErro)
			MsgAlert("Inclusao do Pedido de Vendas no SPARK falhou: " +cErro)
		endif
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Rotinas Monitoramento                            ³
	//³                                                  ³
	//³ Faz alteracao do status do pedido.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	u_UseTrsf010() .and. !lUsaSpark

		U_Trsf012()

	EndIf
	RestArea(aSC6area)
	RestArea(aArea)

Return lReturn
