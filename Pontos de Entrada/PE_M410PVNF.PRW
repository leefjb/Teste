#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#DEFINE  ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M410PVNF  º Autor ³ Cristiano Oliveira º Data ³ 04/07/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CASO O PEDIDO ESTEJA SEM LOTE E VALIDADE, BUSCA DO SB8     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ JOMHÉDICA                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410PVNF()

	Local lRet     := .T.
	Local cQuery   := ""
	Local cProdTmp := "" 
	Local cPedTmp  := ""

	Local cAno := SubStr(DtoS(dDataBase),1,4)
	Local cMes := SubStr(DtoS(dDataBase),5,2)
	Local cDia := SubStr(DtoS(dDataBase),7,2)
	Local cHor := SubStr(Time(),1,2)
	Local cMin := SubStr(Time(),4,2)

	Local _cMensag := "" //mensagem bloqueio
	Local lUsaSpark := SuperGETMV("MV_SPARK",.F.)

	Private aPVxLote  := {}


	IIF(!ExisteSX6('MV_CHKPVLT'),CriarSX6('MV_CHKPVLT', 'L', 'Verifica se analisa Lote SC6 x SC9 - M410PVNF', ".T."), )
	lCheck := GetMv('MV_CHKPVLT')

	IIF(!ExisteSX6('MV_CHKTPPV'),CriarSX6('MV_CHKTPPV', 'C', 'Tipo do PV para verifica Lote X PV  - MTA410', "N"), )
	cParTpPV := AllTrim(GetMv('MV_CHKTPPV'))

	
	//If lCheck .And. SC5->C5_TIPO $ cParTpPV            
	
	If ( lCheck .And. SC5->C5_TIPO $ cParTpPV .and. !lUsaSpark .and. !(!Empty(SC5->C5_NOTA) .Or. SC5->C5_LIBEROK=='E' .And. Empty(SC5->C5_BLQ))  )    

		// RECEBE O NUMERO DE PEDIDO QUE ESTÁ EM MEMÓRIA               
		cPedTmp := SC5->C5_NUM

		cQuery += " SELECT                                  " + CRLF
		cQuery += "   SC9.R_E_C_N_O_ AS SC9_RECNO,          " + CRLF
		cQuery += "   C9_FILIAL,                            " + CRLF
		cQuery += "   C9_PEDIDO,                            " + CRLF
		cQuery += "   C9_ITEM,                              " + CRLF
		cQuery += "   C9_SEQUEN,                            " + CRLF
		cQuery += "   C9_PRODUTO,                           " + CRLF
		cQuery += "   C9_LOTECTL, 				            " + CRLF
 
		cQuery += "   C9_BLEST,								"+ CRLF
		cQuery += "   C9_ORDSEP,							"+ CRLF
		
		cQuery += "   ISNULL(SC6.C6_XETIQ,'') AS 'C6_XETIQ',"+ CRLF
		cQuery += "   ISNULL(SC6.C6_ENVSEP,'') AS 'C6_ENVSEP',"+ CRLF

		cQuery += "   ISNULL(SC6.C6_LOTECTL,'') AS 'C6_LOTECTL',	"+ CRLF
		cQuery += "   ISNULL(SC6.C6_DTVALID,'') AS 'C6_DTVALID'		"+ CRLF

		cQuery += " FROM "+RetSqlName("SC9")+"  SC9        " + CRLF

		cQuery += "					LEFT JOIN "+RetSqlName("SC6")+" SC6		"+CRLF
		cQuery += "					ON	SC6.C6_FILIAL	 =	SC9.C9_FILIAL	"+CRLF
		cQuery += "					AND SC6.C6_NUM		 =	SC9.C9_PEDIDO	"+CRLF
		cQuery += "					AND	SC6.C6_CLI		 =	SC9.C9_CLIENTE	"+CRLF
		cQuery += "					AND	SC6.C6_LOJA		 =	SC9.C9_LOJA		"+CRLF
		cQuery += "					AND	SC6.C6_ITEM		 =	SC9.C9_ITEM		"+CRLF
		cQuery += "					AND	SC6.C6_PRODUTO	 =	SC9.C9_PRODUTO	"+CRLF
		cQuery += "					AND	SC6.D_E_L_E_T_  != '*'				"+CRLF

		cQuery += " WHERE                                   " + CRLF
		cQuery += "   SC9.C9_PEDIDO = '" + cPedTmp + "' AND " + CRLF     
		//cQuery += "   SC9.C9_LOTECTL = '' AND               " + CRLF     
		//cQuery += "   SC9.C9_DTVALID = '' AND               " + CRLF     
		cQuery += "   SC9.D_E_L_E_T_ <> '*'                 " + CRLF

		MemoWrit(GetTempPath()+'M410PVNF__'+cDia+cMes+cAno+'_'+cHor+cMin+'.TXT', cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSC9",.F.,.T. )

		While TMPSC9->( !EOF() )
		
			//validacao para nao faturar item que nao foi separado - ordem de separacao - sem lotectl...
			If ( Empty(TMPSC9->C9_LOTECTL) .and. TMPSC9->C6_ENVSEP == "1" .and. Empty(TMPSC9->C9_BLEST)  ) //.and. Empty(TMPSC9->C9_ORDSEP) )
			 	MsgAlert("Liberação do produto: " + Alltrim(TMPSC9->C9_PRODUTO) + " - item " + TMPSC9->C9_ITEM  + " sem lote informado ";
			 	+ "Status enviado separação.","# Lote não informado!")
			 	TMPSC9->(DbCloseArea())
			 	Return( .F. )
			EndIf
			
			lLoteOK := IIF(TMPSC9->C6_LOTECTL == TMPSC9->C9_LOTECTL, .T., .F.)
			If !Empty(TMPSC9->C6_LOTECTL) .And. Empty(TMPSC9->C9_LOTECTL)
				DbSelectArea("SC9")
				DbGoTo(TMPSC9->SC9_RECNO)

				dbSelectArea("SB8")
				dbSetOrder(3) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
				dbSeek(xFilial("SB8") + SC9->C9_PRODUTO + SC9->C9_LOCAL + SC9->C9_LOTECTL + SC9->C9_NUMLOTE + DTOS(SC9->C9_DTVALID) )
				If ( Found() .and. SB8->B8_SALDO  >=  SC9->C9_QTDLIB )  //(SB8->B8_SALDO - SB8->B8_EMPENHO) 
					If SC9->(Recno()) == TMPSC9->SC9_RECNO
						RecLock("SC9", .F.)
						SC9->C9_LOTECTL := TMPSC9->C6_LOTECTL
						SC9->C9_DTVALID := STOD(TMPSC9->C6_DTVALID)
						SC9->C9_BLEST   := ""
						MsUnlock()
						lLoteOK := .T.
					EndIf
					
					/*
					///////////// # LIBERAR AUTOMATICAMENTE A A.F. - MESMO QUANDO NAO HOUVER SALDO #
					ElseIf (!Empty(SC5->C5_AF))
					RecLock("SC9", .F.)
					SC9->C9_LOTECTL := TMPSC9->C6_LOTECTL
					SC9->C9_DTVALID := STOD(TMPSC9->C6_DTVALID)
					SC9->C9_BLEST   := ""
					MsUnlock()
					lLoteOK := .T.
					 */
					 
				EndIf

			EndIf

			If ( !Empty(TMPSC9->C6_XETIQ) )  .and. !lUsaSpark //.and. ( cEmpAnt == "06" .or. cEmpAnt == "01" ) )  //TMPSC9->C6_LOTECTL <> TMPSC9->C9_LOTECTL 

				dbSelectArea("CB0")
				dbSetOrder(1)
				dbSeek(xFilial("CB0") + Alltrim(TMPSC9->C6_XETIQ) )
				If ( Found() .and. TMPSC9->C9_LOTECTL <> CB0->CB0_LOTE .and. SC9->C9_BLEST == ""  )
					DbSelectArea("SC9")
					DbGoTo(TMPSC9->SC9_RECNO)
					If SC9->(Recno()) == TMPSC9->SC9_RECNO
						RecLock("SC9", .F.)
						SC9->C9_BLEST   := "02"'
						SC9->C9_LOTECTL := ""
						MsUnlock()
					EndIf
					lRet := .F. //nao libera o documento
					MsgAlert("Bloqueio liberação produto: " + Alltrim(SC9->C9_PRODUTO) + " - bloqueado item " + SC9->C9_ITEM + " lote " + Alltrim(SC9->C9_LOTECTL) +  "." ; 
					+ chr(10) +"O campo lote no Pedido esta diferente na etiqueta " + Alltrim(TMPSC9->C6_XETIQ) +" que possui lote "+ Alltrim(CB0->CB0_LOTE) +".";
						,"Verificar item no pedido - lote diferente na etiqueta!")
				EndIf

			EndIf


			//verificando se existe bloqueio em algum item - retorna .F. geracao do documento
			DbSelectArea("SC9")
			DbGoTo(TMPSC9->SC9_RECNO)
			If ! Empty(SC9->C9_BLEST)  
				lRet := .F. //nao gera documento de saida
				_cMensag += "Bloqueio liberação produto: " + Alltrim(SC9->C9_PRODUTO) + " - item " + SC9->C9_ITEM + "." + chr(10)
				exit
			EndIf


			If !lLoteOK
				cDescri	:=	AllTrim(Posicione('SB1', 1, xFilial('SB1') + TMPSC9->C9_PRODUTO, 'B1_DESC'))
				Aadd(aPVxLote, {'', TMPSC9->C9_PEDIDO, TMPSC9->C9_ITEM, AllTrim(TMPSC9->C9_PRODUTO)+' - '+cDescri, TMPSC9->C6_LOTECTL, TMPSC9->C9_LOTECTL})
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ *** RETIRADO TRECHO QUE PREENCHE O LOTE DO PV COM DADOS DO SB8		³
			//³ NA DANFE Eh IMPRESSO UM LOTE (GRAVADO NO SC9\SD2) E NO PV OUTRO		³
			//³                                                            			³
			//³ REALIAZDO AJUSTE PARA BUSCAR LOTE DO PV                  			³
			//³ FABIANO PEREIRA 29/11/2017                                			³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			/*                                                                                                                                       
			DESCONTINUADA - BrwPvRastro - Cristiano Oliveira - 23/02/2018
			Em analise conjunta com a Andreia, identificamos que essa tela solicitando o lote estava gerando inconsistencia na AF - Autorizacao de Faturamento
			Andreia informou que essa tela de validacao nao estava tendo efeito corretivo no pedido de venda tambem. Simplesmente nao fazia nada.
			*/

			cProdTmp := TMPSC9->C9_PRODUTO

			/*cQuery := ""	
			cQuery += " SELECT TOP 1                                     " + CRLF
			cQuery += "   B8_LOTEFOR,                                    " + CRLF
			cQuery += "   B8_DTVALID                                     " + CRLF
			cQuery += " FROM                                             " + CRLF
			cQuery += "    "+RetSqlName("SB8")+" SB8                     " + CRLF
			cQuery += " WHERE                                            " + CRLF
			cQuery += "   SB8.B8_PRODUTO = '" + cProdTmp + "'            " + CRLF
			//			cQuery += "   AND SB8.D_E_L_E_T_ <> '*'                      " + CRLF
			cQuery += " ORDER BY                                         " + CRLF
			cQuery += "   SB8.B8_DATA DESC                               " + CRLF

			dbUseArea( .T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSB8",.F.,.T. ) 
			TcSetField( "TMPSB8","B8_DTVALID","D",08,00 )
			While TMPSB8->( !EOF() )

			DbSelectArea("SC9")
			DbSetOrder(1)
			If DbSeek(TMPSC9->C9_FILIAL + TMPSC9->C9_PEDIDO + TMPSC9->C9_ITEM + TMPSC9->C9_SEQUEN + TMPSC9->C9_PRODUTO)
			RecLock("SC9", .F.)
			SC9->C9_LOTECTL := TMPSB8->B8_LOTEFOR
			SC9->C9_DTVALID := TMPSB8->B8_DTVALID
			SC9->C9_BLEST   := ""
			MsUnlock()
			EndIf

			TMPSB8->(DbSkip())
			EndDo

			TMPSB8->(DbCloseArea())

			*/

			TMPSC9->(DbSkip())
		EndDo

		TMPSC9->(DbCloseArea())

		//lRet := .T.

		If (lRet == .F.)

			MsgAlert( _cMensag ;
			+ "Por favor, na rotina Doc. Saída, checar os pedidos não faturados";
			+ chr(10) + "que estão com reserva(s) de saldo(s).";
			,"Bloqueio estoque Pedido: " + SC5->C5_NUM +"!")
		EndIf

		/*
		If Len(aPVxLote) > 0
		lRet := BrwPvRastro()
		EndIf
		*/

	EndIf

	If Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ)
		MsgAlert("O pedido de vendas: " + SC5->C5_NUM + " esta sem liberacao para prosseguir com a preparaçäo das NFs de saida. Efetue a liberaçäo em pedido de vendas.")
		lRet := .f.
	Endif	

	IF lUsaSpark .and. lRet
		 //FWMsgRun( "Obtendo Lotes e Seriais do WMS" ,, {||lRet :=  U_WMSWsFinishOrder(SC5->C5_NUM) } )  //Chamada para atribuir o lote e serial do SPARK
		 FwMsgRun(,{|| lRet :=  U_WMSWsFinishOrder(SC5->C5_NUM,.f.) },"Integração SPARK","Obtendo Lotes e Seriais do WMS")
		 //lRet := U_WMSWsFinishOrder(SC5->C5_NUM,.f.)
	Endif
	
	Return(lRet)

	/*                                                                                                                                       
	DESCONTINUADA - BrwPvRastro - Cristiano Oliveira - 23/02/2018
	Em analise conjunta com a Andreia, identificamos que essa tela solicitando o lote estava gerando inconsistencia na AF - Autorizacao de Faturamento
	Andreia informou que essa tela de validacao nao estava tendo efeito corretivo no pedido de venda tambem. Simplesmente nao fazia nada.
	*/

	**********************************************************************
Static Function BrwPvRastro()
	**********************************************************************
	Local lRetorno := .T.

	Define Dialog oDlgBlq Title "Liberação Pedido de Venda X Lote." From 120,120 To 380,943 Pixel 

	oFont1	:= TFont():New( "Arial",0,18,,.F.,0,,700,.F.,.F.,,,,,, )
	oSay1   := TSay():New( 004,011,{|| 'LIBERAÇÃO DO PEDIDO DE VENDA SEM LOTE INFORMADO'},,,oFont1,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,300,020 )

	oBrowse := TcBrowse():New(015, 005, 405, 093,,{'','Pedido','Item','Produto', 'Lote PV', 'Lote Liber.'},{/*50,50,50*/},oDlgBlq,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	oBrowse:SetArray(aPVxLote)

	oBrowse:AddColumn(TcColumn():New(''				,{|| aPVxLote[oBrowse:nAt][01] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
	oBrowse:AddColumn(TcColumn():New('Pedido'		,{|| aPVxLote[oBrowse:nAt][02] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
	oBrowse:AddColumn(TcColumn():New('Item'			,{|| aPVxLote[oBrowse:nAt][03] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
	oBrowse:AddColumn(TcColumn():New('Produto'		,{|| aPVxLote[oBrowse:nAt][04] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
	oBrowse:AddColumn(TcColumn():New('Lote PV'		,{|| aPVxLote[oBrowse:nAt][05] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
	oBrowse:AddColumn(TcColumn():New('Lote Liber'	,{|| aPVxLote[oBrowse:nAt][06] },,,,"LEFT",,.F.,.T.,,,,.F.,) )

	@ 113, 005  Say oSay1 PROMPT "Para Continuar é necessário informar o nº do Lote." Size 225, 020 Of oDlgBlq COLORS CLR_HRED,CLR_WHITE/*0, 16777215*/ Pixel
	//TButton():New( 113, 380, '&Sair',  oDlgBlq,{|| oDlgBlq:End() },30,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 113, 290, '&Retornar',   oDlgBlq, {|| lRetorno:= .F.,oDlgBlq:End() },35,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 113, 370, '&Confirmar',  oDlgBlq, {|| oDlgBlq:End() },35,012,,,.F.,.T.,.F.,,.F.,,,.F. )

	Activate Dialog oDlgBlq Centered

Return(lRetorno)