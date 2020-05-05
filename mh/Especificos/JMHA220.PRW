
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Constantes Codigos de Status de Pedidos de Vendas  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

#Define PEDIDO_INCLUIDO      "010"
#Define LIB_COMERCIAL        "020"
#Define LIB_CREDITO          "030"
#Define LIB_ESTOQUE          "040"
#Define ENVIADO_SEPARACAO    "050"
#Define EM_SEPARACAO         "055"
#Define SEPARADO             "059"
#Define ENVIADO_CONFERENCIA  "060"
#Define EM_CONFERENCIA       "065"
#Define CONFERIDO            "070"
#Define FATURADO             "080"
#Define FATURAMENTO_EXCLUIDO "089"
#Define PEDIDO_EXCLUIDO      "999"

/*
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
*/

User Function A220AtuStat( cPedido , cCliente , cLojaCli, cTipoPv, cPvStatus )

	Local aAreaSC5 := SC5->(GetArea())


	If		(cPvStatus = PEDIDO_INCLUIDO) .Or. (cPvStatus = ENVIADO_SEPARACAO)

			DbSelectArea("SC5")
			DbSetOrder(1)
			If	DbSeek(xFilial("SC5")+cPedido)
		
				RecLock("SC5",.F.)
			
					SC5->C5_PVSTAT := cPvStatus
					SC5->C5_DTASEP := CToD("")
					SC5->C5_HRASEP := ""
					SC5->C5_USRSEP := ""
					SC5->C5_PVVALE := "N"//N=Nao
		
				MsUnLock()                   
		
				dbSelectArea("SC6")
				dbSetOrder(1)
				dbSeek( xFilial("SC6") + cPedido )
				
				While !Eof() .And. SC6->C6_NUM = cPedido
				
					RecLock("SC6", .F.)
						SC6->C6_QTDSEP	:= 0
						SC6->C6_USRSEP	:= ""
						SC6->C6_QTDCONF	:= 0
					MsUnLock()
				
					dbSkip()
					
				EndDo
		
			EndIf

	Else

			DbSelectArea("SC5")
			DbSetOrder(1)
			If	DbSeek(xFilial("SC5")+cPedido)
		
				RecLock("SC5",.F.)
			
					SC5->C5_PVSTAT := cPvStatus
		
				MsUnLock()                   

			EndIf

	EndIf

	RestArea(aAreaSC5)

Return()

/*
----------------------------------------------------------------------------------------------------------------------------------
Retorna se ha Liberacao para o Pedido
----------------------------------------------------------------------------------------------------------------------------------
*/

User Function TemLiberPv(cNumPed)

	Local lRet := .T.

	cQuery := " SELECT COUNT(C9_PEDIDO) AS TB_PEDIDO "
	cQuery += " FROM " + RetSqlName("SC9") + " SC9 "
	cQuery += " WHERE SC9.C9_FILIAL  =  '" + xfilial("SC9") + "'"
	cQUERY += " AND   SC9.C9_PEDIDO  =  '" + cNumPed        + "'"
	cQuery += " AND   SC9.D_E_L_E_T_ =  ' ' "
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,ChangeQuery(cQuery)),"TRB01",.F.,.T.)
	nPedido := TRB01->TB_PEDIDO
	TRB01->(DbCloseArea())

	lRet := (nPedido > 0)

Return(lRet)

/*
----------------------------------------------------------------------------------------------------------------------------------
Retorna se ha Bloqueio de Credito para o Pedido
----------------------------------------------------------------------------------------------------------------------------------
*/

User Function TemBlCredPv(cNumPed)

	Local lRet := .T.

	cQuery := " SELECT COUNT(C9_BLCRED) AS TB_BLCRED "
	cQuery += " FROM " + RetSqlName("SC9") + " SC9 "
	cQuery += " WHERE SC9.C9_FILIAL  =  '" + xfilial("SC9") + "'"
	cQUERY += " AND   SC9.C9_PEDIDO  =  '" + cNumPed        + "'"
	cQuery += " AND   SC9.C9_BLCRED  <> '' "
	cQuery += " AND   SC9.D_E_L_E_T_ =  ' ' "
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,ChangeQuery(cQuery)),"TRB01",.F.,.T.)
	nBlCred := TRB01->TB_BLCRED
	TRB01->(DbCloseArea())

	lRet := (nBlCred > 0)

Return(lRet)

/*
----------------------------------------------------------------------------------------------------------------------------------
Retorna se ha Bloqueio de Estoque para o Pedido
----------------------------------------------------------------------------------------------------------------------------------
*/

User Function TemBlEstPv(cNumPed)

	Local lRet := .T.

	cQuery := " SELECT COUNT(C9_BLEST) AS TB_BLEST "
	cQuery += " FROM " + RetSqlName("SC9") + " SC9 "
	cQuery += " WHERE SC9.C9_FILIAL  =  '" + xfilial("SC9") + "'"
	cQUERY += " AND   SC9.C9_PEDIDO  =  '" + SC5->C5_NUM + "'"
//	cQuery += " AND   SC9.C9_BLCRED  <> '' "
	cQuery += " AND   SC9.C9_BLEST   <> '' "
	cQuery += " AND   SC9.D_E_L_E_T_ =  ' ' "
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,ChangeQuery(cQuery)),"TRB01",.F.,.T.)
	nBlEst  := TRB01->TB_BLEST
	TRB01->(DbCloseArea())

	lRet := (nBlEst > 0)

Return(lRet)

/*
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
*/
