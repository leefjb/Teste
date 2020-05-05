#INCLUDE 'protheus.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/{Protheus.doc} xConsPar
//Consulta parametros fechamentos
@author Celso Rene
@since 29/11/2018
@version 1.0
@type function
/*/
User Function xConsPar()

	Private _dDataFIN := GetMV("MV_DATAFIN")
	Private _dDataEST := GetMV("MV_ULMES") 
	Private _cDataGPE := GetMV("MV_FOLMES") 
	Private _dDataATF := GetMV("MV_ULTDEPR")      
	//Private _dDataPRV := GetMV("MV_XDTPROV")
	Private _dDataBlq := GetMV("MV_DBLQMOV")
	Private _dDataDE  := GetMV("MV_DATADE")
	Private _dDataATE  := GetMV("MV_DATAATE")

	Private _dDataFIS := GetMV("MV_DATAFIS")
	Private _dDtCtb	  := U_DtContabil() 

	Private _cUsesAc  := ""
	Private _lAcess	  := .F.


	// Parametro com usuarios ateracao parametros
	dbSelectArea("SX6")
	DbSetOrder(1)
	If !dBseek("  "+"MV_XCONPAR")
		RecLock("SX6", .T.)
		SX6->X6_FIL    := "  "
		SX6->X6_VAR    := "MV_XCONPAR"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Id usuarios com acessos de alteracao param. fechamentos"
		SX6->X6_CONTEUD:= ""
		MsUnLock()
	EndIf

	_cUsesAc	:= Alltrim(GetMv("MV_XCONPAR"))

	If ( Alltrim(RetCodUsr()) $ _cUsesAc )
		_lAcess := .T.
	EndIf


	//Exibo na tela a data que esta aberto o módulo e não a data de fechamento
	//_dDataFIN += 1
	//_dDataPRV += 1
	//_dDataFIS += 1

	DatasCTB()


Return()



/*/{Protheus.doc} DatasCTB
//Prepara Objetos e Gets conforme datas do parametro
@author Celso Rene
@since 30/11/2018
@version 1.0
@type function
/*/
Static Function DatasCTB()    


	Private oDlg_1,oSay1,oGet2,oSBtn3,oSay4,oGrp5,oGet6,oGet7,oSay9,oGet10,oSay11,oGet12,oSay13,oGet14,oSBtn15,oSay15,oGet16,oSay17,oGet18
	oDlg_1 := MSDIALOG():Create()
	oDlg_1:cName := "oDlg_1"
	oDlg_1:cCaption := "Datas de Fechamentos do sistema Protheus"
	oDlg_1:nLeft := 0
	oDlg_1:nTop := 0
	oDlg_1:nWidth := 457
	oDlg_1:nHeight := 335 + 30
	oDlg_1:lShowHint := .F.
	oDlg_1:lCentered := .T.

	oSay1 := TSAY():Create(oDlg_1)
	oSay1:cName := "oSay1"
	oSay1:cCaption  := "MV_DATAFIN - Bloq. movimentos financeiros até"
	oSay1:nLeft := 22
	oSay1:nTop := 42
	oSay1:nWidth := 230
	oSay1:nHeight := 17
	oSay1:lShowHint := .F.
	oSay1:lReadOnly := .F.
	oSay1:Align := 0
	oSay1:lVisibleControl := .T.
	oSay1:lWordWrap := .F.
	oSay1:lTransparent := .F.

	oGet2 := TGET():Create(oDlg_1)
	oGet2:cName := "oGet2"
	oGet2:cToolTip := "Parâmetro MV_DATAFIN - acessível via SigaCFG-módulo Configurador do sistema"
	oGet2:nLeft := 290
	oGet2:nTop := 39
	oGet2:nWidth := 121
	oGet2:nHeight := 21
	oGet2:lShowHint := .F.
	oGet2:lReadOnly := .F.
	oGet2:Align := 0
	oGet2:cVariable := "_dDataFIN"
	oGet2:bSetGet := {|u| If(PCount()>0,_dDataFIN:=u,_dDataFIN) }
	oGet2:lVisibleControl := .T.
	oGet2:lPassword := .F.
	oGet2:lHasButton := .F.
	oGet2:bValid := {|| .T.  } //iif(_dDtCtb<=_dDataFin,.T.,(msgstop('A contabilidade esta fechada nessa data.'),.F.))
	If (_lAcess == .T.) 
		oGet2:Enable()
	Else
		oGet2:bWhen := {|| .F.  }
		oGet2:Disable()
	EndIf


	oSBtn3 := SBUTTON():Create(oDlg_1)
	oSBtn3:cName := "oSBtn3"
	oSBtn3:cCaption := "Sair"
	oSBtn3:nLeft := 383 - 20
	oSBtn3:nTop := 258 + 35
	oSBtn3:nWidth := 52
	oSBtn3:nHeight := 22
	oSBtn3:lShowHint := .F.
	oSBtn3:lReadOnly := .F.
	oSBtn3:Align := 0
	oSBtn3:lVisibleControl := .T.
	oSBtn3:nType := 1
	oSBtn3:bLClicked := {|| Close(oDlg_1) }

	oSay4 := TSAY():Create(oDlg_1)
	oSay4:cName := "oSay4"
	oSay4:cCaption  := "MV_ULMES - Último fechamento estoque"
	oSay4:nLeft := 22
	oSay4:nTop := 142
	oSay4:nWidth := 230
	oSay4:nHeight := 17
	oSay4:lShowHint := .F.
	oSay4:lReadOnly := .F.
	oSay4:Align := 0
	oSay4:lVisibleControl := .T.
	oSay4:lWordWrap := .F.
	oSay4:lTransparent := .F.

	oGrp5 := TGROUP():Create(oDlg_1)
	oGrp5:cName := "oGrp5"
	oGrp5:cCaption := "Parâmretros"
	oGrp5:nLeft := 5
	oGrp5:nTop := 4
	oGrp5:nWidth := 439
	oGrp5:nHeight := 293 + 30
	oGrp5:lShowHint := .F.
	oGrp5:lReadOnly := .F.
	oGrp5:Align := 0
	oGrp5:lVisibleControl := .T.

	oGet6 := TGET():Create(oDlg_1)
	oGet6:cName := "oGet6"
	oGet6:cToolTip := "Parâmetro MV_ULMES - Gravado automaticamente no processo de Virada Mensal (área de Compras/Estoque)"
	oGet6:nLeft := 290
	oGet6:nTop := 139
	oGet6:nWidth := 121
	oGet6:nHeight := 21
	oGet6:lShowHint := .F.
	oGet6:lReadOnly := .F.
	oGet6:Align := 0
	oGet6:cVariable := "_dDataEST"
	oGet6:bSetGet := {|u| If(PCount()>0,_dDataEST:=u,_dDataEST) }
	oGet6:lVisibleControl := .T.
	oGet6:lPassword := .F.
	oGet6:lHasButton := .F.
	oGet6:bWhen  := {|| .F. }
	oGet6:bValid := {|| .T. }
	If (_lAcess == .T.) 
		oGet6:Enable()
	Else
		oGet6:bWhen := {|| .F.  }
		oGet6:Disable()
	EndIf

	oSay9 := TSAY():Create(oDlg_1)
	oSay9:cName := "oSay9"
	oSay9:cCaption  := "MV_ULTDEPR - Último cálculo depreciação ativo fixo"
	oSay9:nLeft := 22
	oSay9:nTop := 117
	oSay9:nWidth := 230
	oSay9:nHeight := 17
	oSay9:lShowHint := .F.
	oSay9:lReadOnly := .F.
	oSay9:Align := 0
	oSay9:lVisibleControl := .T.
	oSay9:lWordWrap := .F.
	oSay9:lTransparent := .F.


	oGet10 := TGET():Create(oDlg_1)
	oGet10:cName := "oGet10"
	oGet10:cToolTip := "Parâmetro MV_ULTDEPR - Atualizado no Cálculo Mensal da Deprec. Ativo Fixo"
	oGet10:nLeft := 290
	oGet10:nTop := 114
	oGet10:nWidth := 121
	oGet10:nHeight := 21
	oGet10:lShowHint := .F.
	oGet10:lReadOnly := .F.
	oGet10:Align := 0
	oGet10:cVariable := "_dDataATF"
	oGet10:bSetGet := {|u| If(PCount()>0,_dDataATF:=u,_dDataATF) }
	oGet10:lVisibleControl := .T.
	oGet10:lPassword := .F.
	oGet10:lHasButton := .F.
	oGet10:bWhen := {|| .F. }
	oGet10:bValid := {|| .T. }
	If (_lAcess == .T.) 
		oGet10:Enable()
	Else
		oGet10:bWhen := {|| .F.  }
		oGet10:Disable()
	EndIf


	oSay11 := TSAY():Create(oDlg_1)
	oSay11:cName := "oSay11"
	oSay11:cCaption := "MV_DBLQMOV - Bloq. movimentos até"
	oSay11:nLeft := 22
	oSay11:nTop := 92
	oSay11:nWidth := 230
	oSay11:nHeight := 17
	oSay11:lShowHint := .F.
	oSay11:lReadOnly := .F.
	oSay11:Align := 0
	oSay11:lVisibleControl := .T.
	oSay11:lWordWrap := .F.
	oSay11:lTransparent := .F.


	oGet12 := TGET():Create(oDlg_1)
	oGet12:cName := "oGet12"
	oGet12:cToolTip := "Parâmetro MV_DBLQMOV - Data bloq. de movimentos"
	oGet12:nLeft := 290
	oGet12:nTop := 89
	oGet12:nWidth := 121
	oGet12:nHeight := 21
	oGet12:lShowHint := .F.
	oGet12:lReadOnly := .F.
	oGet12:Align := 0
	oGet12:cVariable := "_dDataBlq"
	oGet12:bSetGet := {|u| If(PCount()>0,_dDataBlq:=u,_dDataBlq) }
	oGet12:lVisibleControl := .T.
	oGet12:lPassword := .F.
	oGet12:lHasButton := .F.
	oGet12:bValid := {|| .T. }
	If (_lAcess == .T.) 
		oGet12:Enable()
	Else
		oGet12:bWhen := {|| .F.  }
		oGet12:Disable()
	EndIf


	oSay13 := TSAY():Create(oDlg_1)
	oSay13:cName := "oSay13"
	oSay13:cCaption := "MV_DATAFIS - Bloq. docs. fiscais até"
	oSay13:nLeft := 22
	oSay13:nTop := 67
	oSay13:nWidth := 230
	oSay13:nHeight := 17
	oSay13:lShowHint := .F.
	oSay13:lReadOnly := .F.
	oSay13:Align := 0
	oSay13:lVisibleControl := .T.
	oSay13:lWordWrap := .F.
	oSay13:lTransparent := .F.

	oGet14 := TGET():Create(oDlg_1)
	oGet14:cName := "oGet14"
	oGet14:cToolTip := "Data permissao para inclusao de notas"
	oGet14:nLeft := 290
	oGet14:nTop := 64
	oGet14:nWidth := 121
	oGet14:nHeight := 21
	oGet14:lShowHint := .F.
	oGet14:lReadOnly := .F.
	oGet14:Align := 0
	oGet14:cVariable := "_dDataFIS"
	oGet14:bSetGet := {|u| If(PCount()>0,_dDataFIS:=u,_dDataFIS) }
	oGet14:lVisibleControl := .T.
	oGet14:lPassword := .F.
	oGet14:lHasButton := .F.
	oGet14:bValid := {|| .T. }
	If (_lAcess == .T.) 
		oGet14:Enable()
	Else
		oGet14:bWhen := {|| .F.  }
		oGet14:Disable()
	EndIf


	oSBtn15 := SBUTTON():Create(oDlg_1)
	oSBtn15:cName := "oSBtn15"
	oSBtn15:cCaption := "Gravar"
	oSBtn15:cToolTip := "Gravar as informações"
	oSBtn15:nLeft := 15 + 20
	oSBtn15:nTop := 258 + 35
	oSBtn15:nWidth := 52
	oSBtn15:nHeight := 22
	oSBtn15:lShowHint := .F.
	oSBtn15:lReadOnly := .F.
	oSBtn15:Align := 0
	oSBtn15:lVisibleControl := .T.
	oSBtn15:nType := 1
	oSBtn15:bLClicked := {|| U_GrvData() }
	If (_lAcess == .T.) 
		oSBtn15:Enable()
	Else
		oSBtn15:Disable()
	EndIf

	oSay15 := TSAY():Create(oDlg_1)
	oSay15:cName := "oSay15"
	oSay15:cCaption := "CTG - Data calend. contábil aberto de"
	oSay15:nLeft := 22
	oSay15:nTop := 167
	oSay15:nWidth := 230
	oSay15:nHeight := 17
	oSay15:lShowHint := .F.
	oSay15:lReadOnly := .F.
	oSay15:Align := 0
	oSay15:lVisibleControl := .T.
	oSay15:lWordWrap := .F.
	oSay15:lTransparent := .F.

	oGet16 := TGET():Create(oDlg_1)
	oGet16:cName := "oGet16"
	oGet16:cToolTip := "Data calendario contabil - CTG"
	oGet16:nLeft := 290
	oGet16:nTop := 164
	oGet16:nWidth := 121
	oGet16:nHeight := 21
	oGet16:lShowHint := .F.
	oGet16:lReadOnly := .F.
	oGet16:Align := 0
	oGet16:cVariable := "_dDtCTB"
	oGet16:bSetGet := {|u| If(PCount()>0,_dDtCTB:=u,_dDtCTB) }
	oGet16:lVisibleControl := .T.
	oGet16:lPassword := .F.
	oGet16:lHasButton := .F.
	oGet16:bWhen := {|| .F. }
	If (_lAcess == .T.) 
		oGet16:Enable()
	Else
		oGet16:bWhen := {|| .F.  }
		oGet16:Disable()
	EndIf

	oSay17 := TSAY():Create(oDlg_1)
	oSay17:cName := "oSay17"
	oSay17:cCaption := "MV_FOLMES - Data último fechamento folha"
	oSay17:nLeft := 22
	oSay17:nTop := 192
	oSay17:nWidth := 230
	oSay17:nHeight := 17
	oSay17:lShowHint := .F.
	oSay17:lReadOnly := .F.
	oSay17:Align := 0
	oSay17:lVisibleControl := .T.
	oSay17:lWordWrap := .F.
	oSay17:lTransparent := .F.

	oGet18 := TGET():Create(oDlg_1)
	oGet18:cName := "oGet18"
	oGet18:cToolTip := "MV_FOLMES"
	oGet18:nLeft := 290
	oGet18:nTop := 189
	oGet18:nWidth := 121
	oGet18:nHeight := 21
	oGet18:lShowHint := .F.
	oGet18:lReadOnly := .F.
	oGet18:Align := 0
	oGet18:cVariable := "_cDataGPE"
	oGet18:bSetGet := {|u| If(PCount()>0,_cDataGPE:=u,_cDataGPE) }
	oGet18:lVisibleControl := .T.
	oGet18:lPassword := .F.
	oGet18:Picture := "999999"
	oGet18:lHasButton := .F.
	oGet18:bWhen := {|| .F.  }

	If (_lAcess == .T.) 
		oGet18:Enable()
	Else
		oGet18:bWhen := {|| .F.  }
		oGet18:Disable()
	EndIf

	/*
	oSay18 := TSAY():Create(oDlg_1)
	oSay18:cName := "oSay17"
	oSay18:cCaption := "MV_DATADE - Inicio compet. digit. lancamentos"
	oSay18:nLeft := 22  
	oSay18:nTop := 192 + 25
	oSay18:nWidth := 230
	oSay18:nHeight := 17
	oSay18:lShowHint := .F.
	oSay18:lReadOnly := .F.
	oSay18:Align := 0
	oSay18:lVisibleControl := .T.
	oSay18:lWordWrap := .F.
	oSay18:lTransparent := .F.
	
	oGet19 := TGET():Create(oDlg_1)
	oGet19:cName := "oGet19"
	oGet19:cToolTip := "MV_DATADE"
	oGet19:nLeft := 290
	oGet19:nTop := 189 + 25
	oGet19:nWidth := 121
	oGet19:nHeight := 21
	oGet19:lShowHint := .F.
	oGet19:lReadOnly := .F.
	oGet19:Align := 0
	oGet19:cVariable := "_dDataDE"
	oGet19:bSetGet := {|u| If(PCount()>0,_dDataDE:=u,_dDataDE) }
	oGet19:lVisibleControl := .T.
	oGet19:lPassword := .F.
	oGet19:lHasButton := .F.
	If (_lAcess == .T.) 
		oGet19:Enable()
	Else
		oGet19:bWhen := {|| .F.  }
		oGet19:Disable()
	EndIf


	oSay19 := TSAY():Create(oDlg_1)
	oSay19:cName := "oSay17"
	oSay19:cCaption := "MV_DATAATE - Fim compet. digit. lancamentos" 
	oSay19:nLeft := 22  
	oSay19:nTop := 192 + 50
	oSay19:nWidth := 230
	oSay19:nHeight := 17
	oSay19:lShowHint := .F.
	oSay19:lReadOnly := .F.
	oSay19:Align := 0
	oSay19:lVisibleControl := .T.
	oSay19:lWordWrap := .F.
	oSay19:lTransparent := .F.

	oGet20 := TGET():Create(oDlg_1)
	oGet20:cName := "oGet19"
	oGet20:cToolTip := "MV_DATAATE"
	oGet20:nLeft := 290
	oGet20:nTop := 189 + 50
	oGet20:nWidth := 121
	oGet20:nHeight := 21
	oGet20:lShowHint := .F.
	oGet20:lReadOnly := .F.
	oGet20:Align := 0
	oGet20:cVariable := "_dDataATE"
	oGet20:bSetGet := {|u| If(PCount()>0,_dDataATE:=u,_dDataATE) }
	oGet20:lVisibleControl := .T.
	oGet20:lPassword := .F.
	oGet20:lHasButton := .F.
	If (_lAcess == .T.) 
		oGet20:Enable()
	Else
		oGet20:bWhen := {|| .F.  }
		oGet20:Disable()
	EndIf
	*/


	oDlg_1:Activate()


Return()


/*/{Protheus.doc} GrvData
//Funcao para gravar as informacoes nos parametros
@author Celso Rene
@since 29/11/2018
@version 1.0
@type function
/*/
User Function GrvData()

	If ( _lAcess == .T.) 	

		PutMv("MV_DATAFIN"	, DtoS(_dDataFIN) )
		PutMv("MV_DATAFIS"	, DtoS(_dDataFIS) )     
		PutMV("MV_DBLQMOV"	, DtoS(_dDataBlq) )
		//PutMV("MV_ULMES"	, DtoS(_dDataEST) )
		//PutMV("MV_FOLMES"	, _cDataGPE		  )
		//PutMV("MV_DATADE"	, DtoS(_dDataDE)  )
		//PutMV("MV_DATAATE", DtoS(_dDataATE) )


		MsgInfo("Informações salvas para os parâmetros de Fechamentos.","Parâmetros Salvos!" )

	EndIf


Return()


/*/{Protheus.doc} DtContabil
//Busca a primeira data contabil em aberto no calendario contabil - CTG
@author Celso Rene
@since 29/11/2018
@version 1.0
@type function
/*/
User Function DtContabil()

	Local aArea		:= GetArea()
	Local aAreaCTG  := CTG->(GetArea())
	Local _dDataCTG := CtoD("")

	DbSelectArea("CTG")
	set filter to CTG_STATUS == "1"
	DbGoTop()
	_dDataCTG	:= CTG_DTINI
	set filter to

	RestArea(aAreaCTG)
	RestArea(aArea)


Return(_dDataCTG)
