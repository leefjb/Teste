#include "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"


/*/{Protheus.doc} JomACD01
//user function chamada via gatilho na quantidade do pedido de venda.
@author Celso Rene
@since 31/10/2018
@version 1.0
@type function
/*/
User Function JomACD01()

	Local _nSaldo := 0
	Local _nProd  := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO" })
	Local _nLocal := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_LOCAL"   })
	Local _nQtd   := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDVEN"  })
	Local _nTes   := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_TES" 	  })
	Local _cTesEst:= "N"
	Local _aArea  := GetArea()


	_cTesEst := Posicione("SF4",1,xFilial("SF4") + aCols[n][_nTes],"F4_ESTOQUE" ) 
	dbSelectArea("SB2")
	dbSeek(xFilial("SB2") + aCols[n][_nProd] + aCols[n][_nLocal] )
	If ( Found() ) //.and. _cTesEst == "S"  
		_nSaldo := SaldoSb2()
		If ( M->C6_QTDVEN > _nSaldo ) 
			MsgAlert("Saldo: "+ cValtoChar(_nSaldo) + " é insuficiente para atender o item do pedido de venda !","# Saldo  ")
		EndIf
	EndIf


	RestArea(_aArea)

Return(M->C6_QTDVEN)


/*/{Protheus.doc} JomVLote
//Validando data validade lote
@author Celso Rene
@since 06/11/2018
@version 1.0
@type function
/*/
User Function JomVLote() 

	Local _lRet	:= .T.


Return(_lRet)



/*/{Protheus.doc} ZZGLOTE
//Rotina para controle  = Bloqueio de Lote x Documento de Entrada x Conf. Liberacao
@author Celso Rene
@since 09/11/2018
@version 1.0
@type function
/*/
User Function ZZGLOTE(_lBloq, _cZZGNUM,_aSDD)

	Local _cNUM	:= ""
	Local _lZZG	:= .F.

	If (_lBloq == .T.) //bloqueio lote - criando SDD

		DbSelectArea("SX6")
		DbSetOrder(1)
		If ( !dBseek("  "+"MV_ACDZZG") )
			RecLock("SX6", .T.)
			SX6->X6_FIL    := "  "
			SX6->X6_VAR    := "MV_ACDZZG"
			SX6->X6_TIPO   := "C"
			SX6->X6_DESCRIC:= "Controle Numercao Doc - ZZG"
			SX6->X6_CONTEUD:= "00000006"
			MsUnLock()
		EndIf     

		//_cNUM	:= GetSXENum("ZZG","ZZG_NUM")
		_cNUM := Alltrim(GetMv("MV_ACDZZG"))


		For _x:= 1 to _aSDD[4] //quantidade do item

			_cExecSDD := ""
			_cExecSDD := u_JomACD04( .T. , "" ,{ _aSDD[1],_aSDD[2],_aSDD[3], 1 } )

			If (_cExecSDD <> "") 

				dbSelectArea("ZZG")

				RECLOCK("ZZG",.T.)
				ZZG->ZZG_FILIAL := xFilial("ZZG")
				ZZG->ZZG_NUM	:= _cNUM
				ZZG->ZZG_DOCSDD := Padr(_cExecSDD,  TamSx3("DD_DOC")[1] ) 
				ZZG->ZZG_DATA   := dDataBase
				ZZG->ZZG_PRODUT := _aSDD[1]	
				ZZG->ZZG_QUANT	:= 1
				ZZG->ZZG_LOTE	:= _aSDD[3]
				ZZG->ZZG_ITEM   := _aSDD[5]
				ZZG->ZZG_DOCENT	:= _aSDD[6]
				ZZG->ZZG_SERENT	:= _aSDD[7]
				ZZG->ZZG_FORNEC := _aSDD[8]
				ZZG->ZZG_LOJA	:= _aSDD[9]
				ZZG->ZZG_BLOQ	:= "S"
				ZZG->(MSUNLOCK())

				_lZZG := .T.

			EndIf

		Next _x

		//gravou registros ZZG
		If ( _lZZG == .T. )
			//CONFIRMSX8()
			PUTMV("MV_ACDZZG", Soma1(_cNUM))			
		EndIf


	Else

		For _x:= 1 to _aSDD[4] //quantidade do item

			dbSelectArea("ZZG")
			dbSetOrder(4) //ZZG_FILIAL+ZZG_DOCENT+ZZG_SERENT+ZZG_FORNEC+ZZG_LOJA+ZZG_NUM+ZZG_ITEM+ZZG_BLOQ
			dbSeek(xFilial("ZZG") + _aSDD[6] + _aSDD[7] + _aSDD[8] + _aSDD[9] + Padr( _cZZGNUM , TamSx3("ZZG_NUM")[1] )   + _aSDD[5] + "S" )
			_cRet := ""
			If ( Found () )
				_cRet := u_JomACD04( .F. , ZZG->ZZG_DOCSDD , { } )
				If !( _cRet == "")
					dbSelectArea("ZZG")
					RECLOCK("ZZG",.F.)
					ZZG->ZZG_BLOQ := "N"
					ZZG->(MSUNLOCK())
					_cNUM := ZZG->ZZG_NUM
				EndIf 
			EndIf
		Next _x

	EndIf


Return(_cNUM)



/*/{Protheus.doc} xCB0RESID
//Retornando etiquetas conforme itens do documento de devolucao
//usado no ponto de entrada: MT100AGR
@author Celso Rene
@since 20/11/2018
@version 1.0
@type function
/*/
User Function xCB0RESID(_cDoc , _cSerie , _cFornece , _cLoja )

	Local _lRetCB0  := .F.
	Local _aRet		:= {}
	Local _cEtiq	:= "" 
	Local _cEstoque := ""


	DbSelectArea("SD1")
	DbSetOrder(1)           

	If ( DbSeek(xFilial("SD1") + _cDoc + _cSerie + _cFornece + _cLoja ) )

		While !EOF() .AND. _cDoc + _cSerie + _cFornece + _cLoja == ;
		SD1->D1_DOC+SD1->D1_SERIE+D1_FORNECE+D1_LOJA

			_cEstoque	:= Posicione("SF4",1,xFilial("SF4") + SD1->D1_TES , "F4_ESTOQUE" )

			If ( (!Empty(SD1->D1_XIDETIQ)) .and. _cEstoque == "S" )

				dbSelectArea("CB9")
				dbSetOrder(3) //CB9_FILIAL+CB9_PROD+CB9_CODETI
				If ( dbSeek(xFilial("CB9") + SD1->D1_COD + SD1->D1_XIDETIQ ) )

					dbSelectArea("ZZH") //tabela historico CB9 - sera deletado para reativar etiqueta - CB0

					Begin Transaction

						RecLock("ZZH", .T. )

						ZZH->ZZH_FILIAL	:= CB9->CB9_FILIAL
						ZZH->ZZH_ORDSEP	:= CB9->CB9_ORDSEP
						ZZH->ZZH_CODETI := CB9->CB9_CODETI
						ZZH->ZZH_PROD	:= CB9->CB9_PROD
						ZZH->ZZH_ITEM	:= CB9->CB9_ITEM	
						ZZH->ZZH_SEQUEN	:= CB9->CB9_SEQUEN
						ZZH->ZZH_QTESEP	:= CB9->CB9_QTESEP
						ZZH->ZZH_ITSEP  := CB9->CB9_ITESEP
						ZZH->ZZH_CODSEP	:= CB9->CB9_CODSEP
						ZZH->ZZH_STATUS := CB9->CB9_STATUS
						ZZH->ZZH_LOTECT := CB9->CB9_LOTECT
						ZZH->ZZH_NUMLOT := CB9->CB9_NUMLOT
						ZZH->ZZH_LOCAL  := CB9->CB9_LOCAL 
						ZZH->ZZH_PEDIDO := CB9->CB9_PEDIDO
						ZZH->ZZH_DOC	:= CB9->CB9_DOC
						ZZH->ZZH_CB9REC	:= CB9->(Recno())

						ZZH->(MsUnlock())

						_cEtiq 	 += If(Empty(_cEtiq), CB9->CB9_CODETI, "-" + CB9->CB9_CODETI)
						_lRetCB0 := .T. 

						dbSelectArea("CB0")
						dbSetOrder(1) //CB0_FILIAL + CB0_ID 
						If ( dbSeek(xFilial("CB0") + CB9->CB9_CODETI ) )

							RecLock("CB0", .F.)
							CB0->CB0_NFSAI	:= ""
							CB0->CB0_SERIES := ""
							CB0->CB0_ITNFE  := ""
							CB0->CB0_CLI 	:= ""
							CB0->CB0_LOJACL := ""
							CB0->CB0_PEDVEN := ""
							CB0->(MsUnLock())

						EndIf

						dbSelectArea("CB9")
						RecLock("CB9", .F.)
						CB9->(dbDelete())
						CB9->(MsUnLock())

					End Transaction

				EndIf


			EndIf

			dbSelectArea("SD1")
			SD1->(dBSkip())    

		EndDo

	EndIf


	If (! Empty(_cEtiq) ) //fechando tabelas usadas na rotina	
		dbCloseArea("CB9")
		dbCloseArea("CB0")
		dbCloseArea("ZZH")

		If ( _lRetCB0 == .T. ) //restaurou etiquetas 
			MsgInfo("Restauradas as etiquetas: " + _cEtiq  ,"# Etiquetas restauradas !"  )
		EndIf

	EndIf


	//restaurou etiquetas , listadas
	_aRet := { _lRetCB0 , _cEtiq } 


	Return(_aRet)


	/*/{Protheus.doc} xNumZZI()
	//Controle de numeracao tabela CB0 - ZZI
	@author Celso Rene
	@since 03/01/2019
	@version 1.0
	@type function
	/*/
User Function xNumZZI()

	//MV_CODCB0 parametro padrao de controle de numeracao etiquetas - CB0
	Local _cNum 	:= ""

	dbSelectArea("ZZI")
	dbSetOrder(1)
	dbSeek( xFilial("ZZI") + "CB0" )
	If ( Found() )

		_cNum := Soma1(ZZI->ZZI_NUM)

		RecLock("ZZI", .F.)
		ZZI->ZZI_NUM	:= _cNum
		ZZI->(MsUnLock())

	EndIf

	dbCloseArea("ZZI")


Return(_cNum)



/*/{Protheus.doc} EtiqNF
//Busca etiquetas separadas para o documento de saida
//impressao danfe.
@author Celso Rene
@since 01/02/2019
@version 1.0
@type function
/*/
User Function EtiqNF(_cDoc,_cSerie,_cCliente,_cLoja,_cProd,_cItemdoc)

	Local _cRet		:= ""
	Local _cQuery	:= ""
	Local _aArea	:= GetARea()

	//_aETIQ

	dbSelectArea("SD2")
	dbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM                                                                                                     
	dbSeek(xFilial("SD2") + Padr( _cDoc , TamSx3("F2_DOC")[1] ) + Padr( _cSerie , TamSx3("F2_SERIE")[1] ) + Padr( _cCliente , TamSx3("F2_CLIENTE")[1] ) + Padr( _cLoja , TamSx3("F2_LOJA")[1] ) ;
	+ Padr( _cProd , TamSx3("D2_COD")[1] ) + Padr( _cItemdoc , TamSx3("D2_ITEM")[1] ))
	If ( Found() )
		_cQuery := " SELECT TOP " + cValtoChar(Int(SD2->D2_QUANT)) + " CB9_CODETI AS ETIQUETA, 'CB9' AS ORIGEM FROM " + RetSqlName("CB9") + " " + chr(13)
		_cQuery += " WHERE CB9_ORDSEP = '"  + SD2->D2_ORDSEP + "' AND CB9_PROD = '" + SD2->D2_COD +"' AND CB9_PEDIDO = '" + SD2->D2_PEDIDO +"' AND CB9_ITESEP = '" + SD2->D2_ITEMPV + "' AND CB9_LOTECT = '" + SD2->D2_LOTECTL + "' AND D_E_L_E_T_='' " + chr(13)
		_cQuery += " AND CB9_CODETI NOT IN ('"+Alltrim(STRTRAN(_cETIQ,",","','"))+"')"
		_cQuery += " UNION ALL " + chr(13)
		_cQuery += " SELECT TOP " + cValtoChar(Int(SD2->D2_QUANT)) + " ZZH_CODETI AS ETIQUETA, 'ZZH' AS ORIGEM FROM " + RetSqlName("ZZH") + " " + chr(13) 
		_cQuery += " WHERE ZZH_ORDSEP = '"  + SD2->D2_ORDSEP + "' AND ZZH_PROD = '" + SD2->D2_COD + "' AND ZZH_PEDIDO = '" + SD2->D2_PEDIDO +"' AND ZZH_ITSEP = '" + SD2->D2_ITEMPV + "' AND ZZH_LOTECT = '" + SD2->D2_LOTECTL + "' AND D_E_L_E_T_='' " + chr(13)
		_cQuery += " AND ZZH_CODETI NOT IN ('" + Alltrim(STRTRAN(_cETIQ,",","','")) + "')"

		_cQuery := ChangeQuery(_cQuery)

		If( Select( "TMP" ) <> 0 )
			TMP->( DbCloseArea() )
		EndIf

		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TMP", .T., .T.)

		While !TMP->( Eof() )

			If (_cRet == "")
				_cRet += "SERIE: " + TMP->ETIQUETA

				//guardando etiquetas lidas do documento
				If ( Empty(_cETIQ) )
					_cETIQ := TMP->ETIQUETA
				Else
					_cETIQ += ","+TMP->ETIQUETA
				EndIf 

			Else
				_cRet += ","+TMP->ETIQUETA

				//guardando etiquetas lidas do documento
				If ( Empty(_cETIQ) )
					_cETIQ := TMP->ETIQUETA
				Else
					_cETIQ += ","+TMP->ETIQUETA
				EndIf 

			EndIf

			TMP->( dbSkip() )

		EndDo


		dbCloseArea("TMP")

	EndIf


	RestArea(_aArea)


Return(_cRet)



/*/{Protheus.doc} xGeraCBF
//Gera tarefa CBF - conforme Ordem de Sepracao
@author Celso Rene
@since 14/02/2019
@version 1.0
@type function
/*/
User Function xGeraCBF()

	//CB7->CB7_STATUS $ '12345678'"	,"BR_AMARELO" = em andamento
	//CB7->CB7_STATUS == '0'"		,"BR_AZUL"   = nao iniciado

	If ( CB7->CB7_STATUS $ " 012" ) 

		dbSelectAre("CBF")
		RecLock("CBF", .T.)
		CBF->CBF_FILIAL	:= xFilial("CBF")
		CBF->CBF_DE		:= RetCodUsr() //AllTrim(UsrFullName(RetCodUsr()))
		CBF->CBF_PARA	:= CB7->CB7_CODOPE //CB1 - OPERADORES 
		CBF->CBF_MSG	:= "Separar PV:" + CB7->CB7_PEDIDO 
		CBF->CBF_DATA	:= dDataBase
		CBF->CBF_HORA	:= Time()
		CBF->CBF_DATAI	:= INVERTE(DDATABASE)                                                                                                              
		CBF->CBF_HORAI	:= INVERTE(Time()) 
		CBF->CBF_ROTINA	:= "ACDV166B()"
		CBF->CBF_KEYB	:= CB7->CB7_PEDIDO 
		CBF->CBF_XPED	:= CB7->CB7_PEDIDO
		CBF->CBF_XCLI	:= CB7->CB7_CLIENT
		CBF->CBF_XROTIN := "1"   
		CBF->CBF_STATUS	:= "1"    
		CBF->CBF_RESPON	:= "0"                                                                                                                                      
		CBF->(MsUnLock())

		MsgInfo("Gerada tarefa referente a Ord. separação " + CB7->CB7_ORDSEP + " do P.V.: " + CB7->CB7_PEDIDO + "." ,"# Gerada Ord. Sep. !")

	Else
		MsgAlert("Para a Ordem de separação " + CB7->CB7_ORDSEP + " não será gerada a tarefa.","# Status Ord. Sep. !")
	EndIf


Return()




/*/{Protheus.doc} xGerSC9
//SC9 - conforme itens separados
@author Celso Rene
@since 19/02/2019
@version 1.0
@type function
/*/
User Function xGerSC9(_cPV)

	Local _cQryCB9  := ""
	Local _nSeq  	:= "01"
	Local _aAGerSC9	:= GetArea()

	Private _lSepTot	:= .T.


	dbSelectArea("CB7")
	dbSetOrder(2)
	dbSeek(xFilial("CB7") + _cPV)

	If ( Found() .and. Alltrim(CB7->CB7_NOTA) == "" )

		If ( FunName() $ "MATA410") 
			If !(MsgYesNo("Deseja atualizar separações do pedido "+ _cPV +" - envia conferência ?",OemToAnsi("Atualizar Separação!")))
				Return()
			EndIf
		EndIf

		TCSqlExec("DELETE " + RetSqlName("SC9") + " WHERE C9_PEDIDO = '" + CB7->CB7_PEDIDO + "' AND C9_ORDSEP = '" + CB7->CB7_ORDSEP +"' AND C9_NFISCAL = '' ") 

		_cQryCB9 := " SELECT CB9_ORDSEP,CB9_PEDIDO, CB9_QTESEP ,CB9_PROD, CB9_ITESEP, CB9_LOTECT , CB9_LOCAL "
		_cQryCB9 += " FROM " + RetSqlName("CB9") + " WHERE D_E_L_E_T_ = '' AND CB9_ORDSEP = '" + CB7->CB7_ORDSEP + "' AND CB9_PEDIDO = '" + CB7->CB7_PEDIDO + "' " + chr(13)
		//_cQryCB9 += " GROUP BY CB9_ORDSEP,CB9_PEDIDO, CB9_ITESEP, CB9_PROD ,CB9_LOTECT,CB9_LOCAL "
		_cQryCB9 += " ORDER BY CB9_ORDSEP,CB9_PEDIDO, CB9_ITESEP, CB9_PROD ,CB9_LOTECT,CB9_LOCAL "

		If (Select("TMP2") <> 0)
			TMP2->(dbCloseArea())
		Endif

		_nSeq := "01"

		TcQuery _cQryCB9 Alias "TMP2" New

		DbSelectArea("TMP2")	
		If (!TMP2->(Eof()) )


			//_cSeq := "00"//CB8->CB8_SEQUEN
			While ( !TMP2->(EOF()) ) 


				_cQrySc9 := " SELECT ISNULL(MAX(C9_SEQUEN),'00') AS SEQ  FROM " + RetSqlName("SC9") + " WITH (NOLOCK) WHERE C9_PEDIDO = '" + TMP2->CB9_PEDIDO + "' AND C9_ITEM = '"  + TMP2->CB9_ITESEP + "' AND C9_PRODUTO = '" + TMP2->CB9_PROD + "' "
				If (Select("TMP3") <> 0)
					TMP3->(dbCloseArea())
				Endif

				TcQuery _cQrySc9 Alias "TMP3" New

				DbSelectArea("TMP3")	
				If (!TMP3->(Eof()) )
					_nSeq := Soma1(TMP3->SEQ)
				ENdIf

				dbCloseArea("TMP3")

				dbSelectArea("SC6")
				dbSetOrder(1) 
				dbGoTop()                                                                                                                                                                                                                     
				dbSeek( xFilial("SC6") + TMP2->CB9_PEDIDO + TMP2->CB9_ITESEP  )


				/*dbSelectArea("SC9")
				dbSetOrder(1)  //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
				dbSeek(xFilial("SC9") + CB8->CB8_PEDIDO + CB8->CB8_ITEM + CB8->CB8_SEQUEN + CB8->CB8_PROD )
				If ( Found() )
				For _x:= 1 to 50
				_nSeq := _nSeq + 1 
				dbSelectArea("SC9")
				dbSetOrder(1)  //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
				dbSeek(xFilial("SC9") + CB8->CB8_PEDIDO + CB8->CB8_ITEM + _nSeq + TMP2->CB9_PROD )
				If ( ! Found() )
				_x:= 51
				EndIf
				Next _x
				EndIf */
				

				dbSelectArea("SC9")
				RECLOCK("SC9",.T.)

				SC9->C9_FILIAL	:= xFilial("SC9")
				SC9->C9_PEDIDO 	:= CB7->CB7_PEDIDO
				SC9->C9_ITEM	:= TMP2->CB9_ITESEP	
				SC9->C9_CLIENTE	:= CB7->CB7_CLIENT
				SC9->C9_LOJA	:= CB7->CB7_LOJA
				SC9->C9_PRODUTO	:= TMP2->CB9_PROD
				SC9->C9_QTDLIB	:= TMP2->CB9_QTESEP
				SC9->C9_DATALIB	:= CB7->CB7_DTFIMS //dDataBase                                                                                                                                                                                           

				SC9->C9_SEQUEN	:= _nSeq //TMP2->CB9_SEQUEN

				SC9->C9_GRUPO	:= "0001"
				SC9->C9_PRCVEN	:= SC6->C6_PRCVEN
				SC9->C9_LOTECTL	:= TMP2->CB9_LOTECT
				SC9->C9_DTVALID	:= Posicione("SB8",5,xFilial("SB8") + TMP2->CB9_PROD + TMP2->CB9_LOTECT  ,"B8_DTVALID")
				SC9->C9_LOCAL	:= TMP2->CB9_LOCAL
				SC9->C9_TPCARGA := "2"
				SC9->C9_RETOPER := "2"
				SC9->C9_ORDSEP 	:= CB7->CB7_ORDSEP
				SC9->C9_TPOP 	:= "1"
				SC9->C9_DATENT	:= SC6->C6_ENTREG

				SC9->(MsUnlock())

				///empenhando os lotes conforme SC9 criado
				/*dbselectARea("SB8")
				dbSetOrder(5) //B8_FILIAL+B8_PRODUTO+B8_LOTECTL
				dbSeek(xFilial("SB8") + SC9->C9_PRODUTO + SC9->C9_LOTECTL)
				If ( Found() .and. (SB8->B8_EMPENHO + SC9->C9_QTDLIB) <= SB8->B8_SALDO )

				dbSelectArea("SB8")
				RECLOCK("SB8",.F.)
				SB8->B8_EMPENHO := SB8->B8_EMPENHO + SC9->C9_QTDLIB
				SB8->(MsUnlock())

				EndIf
				*/	

				//_cSeq	:= Soma1(_cSeq) 

				dbSelectArea("TMP2")
				TMP2->(dBSkip())
			End

			dbCloseArea("TMP2")

		EndIf


		//atualizando quantidade separada pedido de venda
		If ( FunName() $ "MATA410") 

			dbSelectArea("CB8")
			dbSetOrder(2) //CB8_FILIAL+CB8_PEDIDO+CB8_ITEM+CB8_SEQUEN+CB8_PROD
			dbSeek( xFilial("CB8") + CB7->CB7_PEDIDO )
			If ( Found() ) 
				While ( ! CB8->(EOF()) .AND. CB8->CB8_PEDIDO == CB7->CB7_PEDIDO )

					PedCnf(CB8->CB8_PEDIDO + CB8->CB8_ITEM)

					dbSelectArea("CB8")
					CB8->(dBSkip())    

				EndDo  
			EndIf	


			//atualizando status pedido de venda
			If (_lSepTot == .T.) 
				dbSelectArea("SC5")
				dbSetOrder(1)
				If ( dbSeek(xFilial("SC5") + CB7->CB7_PEDIDO ) )
					RECLOCK("SC5",.F.)
					SC5->C5_PVSTAT := "059"
					SC5->(MsUnlock())
				EndIf
			Else
				dbSelectArea("SC5")
				dbSetOrder(1)
				If ( dbSeek(xFilial("SC5") + CB7->CB7_PEDIDO ) )
					RECLOCK("SC5",.F.)
					SC5->C5_PVSTAT := "010"
					SC5->(MsUnlock())
				EndIf
			EndIf

		EndIf

	EndIf


	RestArea(_aAGerSC9)


Return()



/*/{Protheus.doc} PedCnf
@author Celso Rene
@since 19/02/2019
@version 1.0
@type function
/*/
Static Function PedCnf(_cPV)

	//Local _aAreaSC6 := GetArea()
	Local _cqueryPV

	//Atualizando pedido de venda
	dbSelectArea("SC6")
	dbSetOrder(1) 
	dbGoTop()                                                                                                                                                                                                                     
	dbSeek( xFilial("SC6") + _cPV )
	If ( Found() )

		While ( ! SC6->(EOF()) .AND. SC6->C6_NUM + SC6->C6_ITEM = _cPV )


			_cqueryPV := " SELECT ISNULL(SUM(CB9_QTESEP),0) QTESEP FROM " + RetSqlName("CB9") + " " + chr(13)
			_cqueryPV += " WHERE CB9_PEDIDO = '" + SC6->C6_NUM + "' AND CB9_PROD = '" + SC6->C6_PRODUTO + "' " + chr(13)
			_cqueryPV += " AND CB9_ITESEP = '" + SC6->C6_ITEM + "' AND D_E_L_E_T_ = '' "

			If (Select("TMPPV") <> 0)
				TMPPV->(dbCloseArea())
			Endif

			TcQuery _cqueryPV Alias "TMPPV" New

			DbSelectArea("TMPPV")	
			If (!TMPPV->(Eof()) ) 

				RECLOCK("SC6",.F.)
				SC6->C6_QTDSEP := TMPPV->QTESEP
				//SC6->C6_QTDLIB := TMPPV->QTESEP
				SC6->C6_QTDCONF := 0 
				SC6->C6_QTDEMP := TMPPV->QTESEP 
				SC6->(MsUnlock())

				If (SC6->C6_QTDSEP < SC6->C6_QTDVEN) 
					_lSepTot := .F.
				EndIf

			EndIf

			dbCloseArea("TMPPV")

			dbSelectArea("SC6")
			SC6->(dBSkip()) 

		EndDo

	EndIf


	//RestArea(_aAreaSC6)



/*/{Protheus.doc} EtiqAF
//Busca etiquetas separadas para o documento de saida - A.F. C6_XETIQ
//impressao danfe.
@author Celso Rene
@since 02/04/2019
@version 1.0
@type function
/*/
User Function EtiqAF(_cDoc,_cSerie,_cCliente,_cLoja,_cProd,_cItemdoc,_cPv,_cItemPV)

	Local _cRetAF	:= ""
	Local _aAreaAF	:= GetARea()


	dbSelectArea("SC6")
	dbSetOrder(1)  //C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO  
	dbSeek(xFilial("SC6") + _cPv + _cItemPV + _cProd )                                                                                                                           

	If ( Found() .and. !Empty(SC6->C6_XETIQ) )

		If (_cRetAF == ""  )
			_cRetAF += "SERIE: " + SC6->C6_XETIQ
		Else
			_cRetAF += "," + SC6->C6_XETIQ
		EndIf		

	EndIf


	RestArea(_aAreaAF)


Return(_cRetAF)



/*/{Protheus.doc} xAtuCB0
//Atualiza etiquetas - chamado no PE: MSD2460
@author Celso Rene
@since 23/04/2019
@version 1.0
@type function
/*/
User Function xAtuCB0(_cDoc,_cSerie,_cCli,_cLoja,_cItem,_cProd,_cPedido,_cItPV,_cOrdsep,_cEtiq)

	Local _cQryUPD 	:= ""
	Local _aArea	:= GetArea()	


	If ( !Empty(_cOrdsep ) .and. Empty(_cEtiq) ) //com ordem de separacao

		dbSelectArea("CB9")
		dbSetOrder(11)
		If (dbSeek(xFilial("CB9") + _cOrdsep + _cItPV + _cPedido) ) //CB9_FILIAL+CB9_ORDSEP+CB9_ITESEP+CB9_PEDIDO
			Do While (!CB9->(Eof())) .and.  CB9->CB9_ITESEP == _cItPV .and. CB9->CB9_PEDIDO == _cPedido

				dbSelectARea("CB0")
				dbSetOrder(1)
				dbSeek(xFilial("CB0") + CB9->CB9_CODETI )	
				If Found()
					RecLock("CB0", .F.)
					CB0->CB0_NFSAI 		:= _cDoc
					CB0->CB0_SERIES		:= _cSerie
					CB0->CB0_CLI 		:= _cCli
					CB0->CB0_LOJACL 	:= _cLoja
					CB0->CB0_PEDVEN		:= _cPedido
					CB0->(MsUnlock())	
				EndIf	

				CB9->(DBSKIP())
			EndDo

		EndIf


	ElseIf ( Empty(_cOrdsep ) .and. !Empty(_cEtiq) ) //sem ordem de separaca

		dbSelectARea("CB0")
		dbSetOrder(1)
		dbSeek(xFilial("CB0") + _cEtiq )	
		If Found()

			RecLock("CB0", .F.)
			CB0->CB0_NFSAI 		:= _cDoc
			CB0->CB0_SERIES		:= _cSerie
			CB0->CB0_CLI 		:= _cCli
			CB0->CB0_LOJACL 	:= _cLoja
			CB0->CB0_PEDVEN		:= _cPedido
			CB0->(MsUnlock())			

		EndIf

	EndIf


	RestArea(_aArea)


Return()



/*/{Protheus.doc} xGSC9
//SC9 - conforme itens separados
@author Celso Rene
@since 19/02/2019
@version 1.0
@type function
/*/
User Function xGSC9(_cPV)

	Local _cQryCB9  := ""
	Local _nSeq  	:= "01"
	Local _aAGerSC9	:= GetArea()

	dbSelectArea("CB7")
	dbSetOrder(2)
	dbSeek(xFilial("CB7") + _cPV)

	TCSqlExec("DELETE " + RetSqlName("SC9" ) + " WHERE C9_PEDIDO = '" + CB7->CB7_PEDIDO + "' AND C9_ORDSEP = '" + CB7->CB7_ORDSEP +"' ") //AND C9_ORDSEP = '" + CB8->CB8_ORDSEP + "'

	_cQryCB9 := " SELECT CB9_ORDSEP,CB9_PEDIDO, CB9_QTESEP ,CB9_PROD, CB9_ITESEP, CB9_LOTECT , CB9_LOCAL "
	_cQryCB9 += " FROM " + RetSqlName("CB9") + " WHERE D_E_L_E_T_ = '' CB9_ORDSEP = '" + CB7->CB7_ORDSEP + "' AND CB9_PEDIDO = '" + CB7->CB7_PEDIDO + "' " + chr(13)
	//_cQryCB9 += " GROUP BY CB9_ORDSEP,CB9_PEDIDO, CB9_ITESEP, CB9_PROD ,CB9_LOTECT,CB9_LOCAL "
	_cQryCB9 += " ORDER BY CB9_ORDSEP,CB9_PEDIDO, CB9_ITESEP, CB9_PROD ,CB9_LOTECT,CB9_LOCAL "

	If (Select("TMP2") <> 0)
		TMP2->(dbCloseArea())
	Endif

	_nSeq := "01"

	TcQuery _cQryCB9 Alias "TMP2" New

	DbSelectArea("TMP2")	
	If (!TMP2->(Eof()) )


		//_cSeq := "00"//CB8->CB8_SEQUEN
		While ( !TMP2->(EOF()) ) 


			_cQrySc9 := " SELECT ISNULL(MAX(C9_SEQUEN),'00') AS SEQ  FROM " + RetSqlName("SC9") + " WITH (NOLOCK) WHERE C9_PEDIDO = '" + TMP2->CB9_PEDIDO + "' AND C9_ITEM = '"  + TMP2->CB9_ITESEP + "' AND C9_PRODUTO = '" + TMP2->CB9_PROD + "' "
			If (Select("TMP3") <> 0)
				TMP3->(dbCloseArea())
			Endif

			TcQuery _cQrySc9 Alias "TMP3" New

			DbSelectArea("TMP3")	
			If (!TMP3->(Eof()) )
				_nSeq := Soma1(TMP3->SEQ)
			ENdIf

			dbCloseArea("TMP3")

			dbSelectArea("SC6")
			dbSetOrder(1) 
			dbGoTop()                                                                                                                                                                                                                     
			dbSeek( xFilial("SC6") + TMP2->CB9_PEDIDO + TMP2->CB9_ITESEP  )


			/*dbSelectArea("SC9")
			dbSetOrder(1)  //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
			dbSeek(xFilial("SC9") + CB8->CB8_PEDIDO + CB8->CB8_ITEM + CB8->CB8_SEQUEN + CB8->CB8_PROD )
			If ( Found() )
			For _x:= 1 to 50
			_nSeq := _nSeq + 1 
			dbSelectArea("SC9")
			dbSetOrder(1)  //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
			dbSeek(xFilial("SC9") + CB8->CB8_PEDIDO + CB8->CB8_ITEM + _nSeq + TMP2->CB9_PROD )
			If ( ! Found() )
			_x:= 51
			EndIf
			Next _x
			EndIf */

			dbSelectArea("SC9")
			RECLOCK("SC9",.T.)

			SC9->C9_FILIAL	:= xFilial("SC9")
			SC9->C9_PEDIDO 	:= CB7->CB7_PEDIDO
			SC9->C9_ITEM	:= TMP2->CB9_ITESEP	
			SC9->C9_CLIENTE	:= CB7->CB7_CLIENT
			SC9->C9_LOJA	:= CB7->CB7_LOJA
			SC9->C9_PRODUTO	:= TMP2->CB9_PROD
			SC9->C9_QTDLIB	:= TMP2->CB9_QTESEP
			SC9->C9_DATALIB	:= CB7->CB7_DTFIMS //dDataBase                                                                                                                                                                                           

			SC9->C9_SEQUEN	:= _nSeq //TMP2->CB9_SEQUEN

			SC9->C9_GRUPO	:= "0001"
			SC9->C9_PRCVEN	:= SC6->C6_PRCVEN
			SC9->C9_LOTECTL	:= TMP2->CB9_LOTECT
			SC9->C9_DTVALID	:= Posicione("SB8",5,xFilial("SB8") + TMP2->CB9_PROD + TMP2->CB9_LOTECT  ,"B8_DTVALID")
			SC9->C9_LOCAL	:= TMP2->CB9_LOCAL
			SC9->C9_TPCARGA := "2"
			SC9->C9_RETOPER := "2"
			SC9->C9_ORDSEP 	:= CB7->CB7_ORDSEP
			SC9->C9_TPOP 	:= "1"
			SC9->C9_DATENT	:= SC6->C6_ENTREG

			SC9->(MsUnlock())

			///empenhando os lotes conforme SC9 criado
			/*dbselectARea("SB8")
			dbSetOrder(5) //B8_FILIAL+B8_PRODUTO+B8_LOTECTL
			dbSeek(xFilial("SB8") + SC9->C9_PRODUTO + SC9->C9_LOTECTL)
			If ( Found() .and. (SB8->B8_EMPENHO + SC9->C9_QTDLIB) <= SB8->B8_SALDO )

			dbSelectArea("SB8")
			RECLOCK("SB8",.F.)
			SB8->B8_EMPENHO := SB8->B8_EMPENHO + SC9->C9_QTDLIB
			SB8->(MsUnlock())

			EndIf
			*/	

			//_cSeq	:= Soma1(_cSeq) 

			dbSelectArea("TMP2")
			TMP2->(dBSkip())
		End

		dbCloseArea("TMP2")

	EndIf


	RestArea(_aAGerSC9)


Return()
