#INCLUDE "PROTHEUS.CH"

// Variável utilizada no retorno da consulta
Static cSA3REP := Space( Len( SA1->A1_REPAUTO ) )

/*
Jean Rehermann - Solutio IT - 15/02/2017
Consulta padrão específica para o campo A1_REPAUTO
Permite a seleção de múltiplos representantes que podem ser utilizados no pedido de vendas
de acordo com o cliente selecionado.
*/

User Function RetRepCli()

	Local cTitulo	:= "Representantes"
	Local cQuery	:= ""
	Local cAlias	:= "SA3"
	Local cCpoChave	:= SubStr( Readvar(), 4 )
	Local cTitCampo	:= RetTitle(cCpoChave)
	Local cMascara	:= PesqPict(cAlias,cCpoChave)
	Local nTamCpo	:= TamSx3(cCpoChave)[1]		
	Local cRetCpo	:= Readvar()
	Local nColuna	:= 3
	Local cCodigo	:= &(cRetCpo)
 	Private bRet 	:= .F.

   	cQuery := " SELECT A3_COD, A3_NOME "
	cQuery += " FROM "+ RetSQLName("SA3") + " AS SA3 "
	cQuery += " WHERE A3_FILIAL  = '" + xFilial("SA3") + "' "
	cQuery += " AND A3_MSBLQL <> '1' "
	cQuery += " AND A3_COD <> '"+ M->A1_VEND +"' "
	cQuery += " AND SA3.D_E_L_E_T_= ' ' "
	cQuery += " ORDER BY A3_NOME "

 	bRet := U_FiltroF3(cTitulo,cQuery,nTamCpo,cAlias,cCodigo,cCpoChave,cTitCampo,cMascara,cRetCpo,nColuna)

Return(bRet)

// Exibe a tela com o grid de registros
User Function FiltroF3(cTitulo,cQuery,nTamCpo,cAlias,cCodigo,cCpoChave,cTitCampo,cMascara,cRetCpo,nColuna)
	/*
	+------------------+-----------+------------------------------------------------+
	!Campo             ! Tipo	   ! Obrigatorio                                    !
	+------------------+-----------+------------------------------------------------+
	!cTitulo           ! Caracter  !                                                !
	!cQuery            ! Caracter  ! X                                              !
	!nTamCpo           ! Numerico  !                                                !
	!cAlias            ! Caracter  ! X                                              !
	!cCodigo           ! Caracter  !                                                !
	!cCpoChave         ! Caracter  ! X                                              !
	!cTitCampo         ! Caracter  ! X                                              !
	!cMascara          ! Caracter  !                                                !
	!cRetCpo           ! Caracter  ! X                                              !
	!nColuna           ! Numerico  !                                                !
	+------------------+-----------+------------------------------------------------+
	!Parametros:                                                                    !
	!==========		                                                                !
	!          																		!
	!cTitulo = Titulo da janela da consulta                                         !
	!cQuery  = A consulta SQL                                                       !
	!nTamCpo   = Tamanho do campo de pesquisar,se não informado assume 30 caracteres!
	!cAlias    = Alias da tabela, ex: SA1                                           !
	!cCodigo   = Conteudo do campo que chama o filtro                               !
	!cCpoChave = Nome do campo que será utilizado para pesquisa, ex: A1_CODIGO      ! 
	!cTitCampo = Titulo do label do campo                                           !
	!cMascara  = Mascara do campo, ex: "@!"                                         !
	!cRetCpo   = Campo que receberá o retorno do filtro                             !
	!nColuna   = Coluna que será retornada na pesquisa, padrão coluna 1             !
	+--------------------------------------------------------------------------------
	*/
	Local nLista  
	Local cTabela 
	Local cCampos 	:= ""
	Local nCont		:= 0
	Local bCampo	:= {}
	Local bTitulos	:= {}
	Local aCampos 	:= {}
	Local cCSSGet	 := "QLineEdit{ border: 1px solid gray;border-radius: 3px;background-color: #ffffff;selection-background-color: #3366cc;selection-color: #ffffff;padding-left:1px;}"
	Local cCSSButton := "QPushButton{background-repeat: none; margin: 2px;background-color: #ffffff;border-style: outset;border-width: 2px;border: 1px solid #C0C0C0;border-radius: 5px;border-color: #C0C0C0;font: bold 12px Arial;padding: 6px;QPushButton:pressed {background-color: #ffffff;border-style: inset;}"
	Local cCSSButF3	 := "QPushButton {background-color: #ffffff;margin: 2px;border-style: outset;border-width: 2px;border: 1px solid #C0C0C0;border-radius: 3px; border-color: #C0C0C0;font: Normal 10px Arial;padding: 3px;} QPushButton:pressed {background-color: #e6e6f9;border-style: inset;}"
	Local oOk        := LoadBitMap(GetResources(), "LBOK")
	Local oNo        := LoadBitMap(GetResources(), "LBNO")

	Private _oCodigo
	Private _cCodigo	
	Private _oLista	 := Nil
	Private _oDlg 	 := Nil
	Private _aDados  := {}
	Private _nColuna := 0
	
	Default cTitulo  := ""
	Default cCodigo  := ""
	Default nTamCpo  := 30
	Default nColuna := 1
	Default cTitCampo:= RetTitle(cCpoChave)
	Default cMascara := PesqPict('"'+cAlias+'"',cCpoChave)

	_nColuna	:= nColuna

	If Empty(cAlias) .OR. Empty(cCpoChave) .OR. Empty(cRetCpo) .OR. Empty(cQuery)
		MsgStop("Os parametro cQuery, cCpoChave, cRetCpo e cAlias são obrigatórios!","Erro")
		Return
	Endif

	_cCodigo := Space(nTamCpo)
	//_cCodigo := cCodigo
	
	cTabela:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cTabela, .F., .T.)
     
	(cTabela)->(DbGoTop())
	If (cTabela)->(Eof())
		MsgStop("Não há registros para serem exibidos!","Atenção")
		Return
	Endif
   
	Do While (cTabela)->(!Eof())
		/*Cria o array conforme a quantidade de campos existentes na consulta SQL*/
		cCampos	:= ""
		aCampos 	:= {}
		For nX := 1 TO FCount()
			bCampo := {|nX| Field(nX) }
			If ValType((cTabela)->&(EVAL(bCampo,nX))) <> "M" .OR. ValType((cTabela)->&(EVAL(bCampo,nX))) <> "U"
				if ValType((cTabela)->&(EVAL(bCampo,nX)) )=="C"
					cCampos += "'" + (cTabela)->&(EVAL(bCampo,nX)) + "',"
				ElseIf ValType((cTabela)->&(EVAL(bCampo,nX)) )=="D"
					cCampos +=  DTOC((cTabela)->&(EVAL(bCampo,nX))) + ","
				Else
					cCampos +=  (cTabela)->&(EVAL(bCampo,nX)) + ","
				Endif
					
				aadd(aCampos,{EVAL(bCampo,nX),Alltrim(RetTitle(EVAL(bCampo,nX))),"LEFT",30})
			Endif
		Next
     
     	If !Empty(cCampos) 
     		cCampos 	:= Substr(cCampos,1,len(cCampos)-1)
     		aAdd( _aDados,&("{.F.,"+cCampos+"}"))
     	Endif
     	
		(cTabela)->(DbSkip())     
	Enddo
   
	DbCloseArea(cTabela)
	
	If Len(_aDados) == 0
		MsgInfo("Não há dados para exibir!","Aviso")
		Return
	Else
		For _n := 1 To Len( _aDados )
			_aDados[_n,1] := ( _aDados[_n,2] $ cCodigo )
		Next
	Endif
   
	nLista := aScan(_aDados, {|x| alltrim(x[1]) == alltrim(_cCodigo)})
     
	Iif(nLista = 0,nLista := 1,nLista)
     
	Define MsDialog _oDlg Title "Consulta Padrão" + IIF(!Empty(cTitulo)," - " + cTitulo,"") From 0,0 To 280, 500 Of oMainWnd Pixel
	
	oCodigo:= TGet():New( 006, 005,{|u| if(PCount() > 0,_cCodigo:=u,_cCodigo)},_oDlg,205, 010,cMascara,{|| /*Processa({|| FiltroF3P(M->_cCodigo)},"Aguarde...")*/ },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"",_cCodigo,,,,,,,"",1 )
	oCodigo:cPlaceHold := "Digite o nome a ser pesquisado..."
	oCodigo:SetCss(cCSSGet)	
	oButton1 := TButton():New(006, 212," &Pesquisar ",_oDlg,{|| Processa({|| FiltroF3P(M->_cCodigo) },"Aguarde...") },037,013,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton1:SetCss(cCSSButton)	
	    
	_oLista:= TCBrowse():New(26,05,245,90,,,,_oDlg,,,,,{|| _oLista:Refresh()},,,,,,,.F.,,.T.,,.F.,,,.f.)
	nCont := 2
	_oLista:AddColumn(TCColumn():New(" ", {|| If(_aDados[_oLista:nAt,01],oOk,oNo) },,,,,,.T.,.F.,,,,.F., ) )
	//Para ficar dinâmico a criação das colunas, eu uso macro substituição "&"
	For nX := 1 to len(aCampos)
		cColuna := &('_oLista:AddColumn(TCColumn():New("'+aCampos[nX,2]+'", {|| _aDados[_oLista:nAt,'+StrZero(nCont,2)+']},PesqPict("'+cAlias+'","'+aCampos[nX,1]+'"),,,"'+aCampos[nX,3]+'", '+StrZero(aCampos[nX,4],3)+',.F.,.F.,,{|| .F. },,.F., ) )')
		nCont++
	Next
	_oLista:SetArray(_aDados)
	_oLista:bWhen 	   := { || Len(_aDados) > 0 }
//	_oLista:bLDblClick := { || FiltroF3R(_oLista:nAt, _aDados, cRetCpo, nTamCpo)  }
	_oLista:bLDblClick := { || _aDados[_oLista:nAt,01] := !_aDados[_oLista:nAt,01] }
	_oLista:Refresh()

	oButton2 := TButton():New(122, 005," OK "			,_oDlg,{|| Processa({|| FiltroF3R(_oLista:nAt, _aDados, cRetCpo, nTamCpo) },"Aguarde...") },037,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton2:SetCss(cCSSButton)	
	oButton3 := TButton():New(122, 047," Cancelar "	,_oDlg,{|| _oDlg:End() },037,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton3:SetCss(cCSSButton)

	aItems:= {'Código','Nome'}
	cCombo:= aItems[2]
	oCombo := TComboBox():New(123,095,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItems,100,20,_oDlg,,{|| AltPsq() },,,,.T.,,,,,,,,,'cCombo','Ordenar pesquisa por ')

	_oLista:Setfocus()

	Activate MSDialog _oDlg Centered	
	
Return(bRet)

// Altera o índice de pesquisa
Static Function AltPsq()

	_nColuna := oCombo:nAt + 1
	
	aSort(_aDados, , , { | x, y | x[_nColuna] < y[_nColuna] } )
	
	_oLista:SetArray(_aDados)
	_oLista:GoPosition(1)
	_oLista:Refresh()
	
	oCodigo:cPlaceHold := Iif( _nColuna == 2, "Digite o código a ser pesquisado...", "Digite o nome a ser pesquisado..." )
	oCodigo:Refresh()
	
	oCodigo:Setfocus()
	_oLista:Setfocus()
	
Return

// Faz a pesquisa no grid pelo conteúdo desejado
Static Function FiltroF3P(cBusca)

	Local i := 0

	If !Empty(cBusca)
		For i := 1 to len(_aDados)
			If Upper( Alltrim( cBusca ) ) == Left( Upper( Alltrim( _aDados[ i, _nColuna ] ) ), Len( Alltrim( cBusca ) ) )
				_oLista:GoPosition(i)
				_oLista:Setfocus()
				Exit
			Endif
		Next
	Endif

Return

// Monta o conteúdo coretamente para o retorno, avaliando seu resultado
Static Function FiltroF3R(nLinha,aDados,cRetCpo,nTamCpo)

	cCodigo := ""
	cCodExc := ""
	nMaxCod := Int( nTamCpo / 7 ) // Máximo de códigos possível de selecionar em função do tamanho do campo
	nSelect := 0 // Total de códigos selecionados
	
	For _n := 1 To Len( aDados )
		If aDados[_n,1] 
			If nSelect < nMaxCod
				cCodigo += aDados[_n,2] + ";"
			Else
				cCodExc += aDados[_n,2] + ";"
			EndIf
		nSelect++
		EndIf
	Next
	
	If nSelect > nMaxCod
		MsgAlert("Em função do tamanho do campo, os seguintes códigos não foram adicionados: "+ cCodExc )
	EndIf
	
	cCodigo := SubStr( cCodigo, 1, Len( cCodigo ) - 1 )
	cCodigo := PadR( cCodigo, nTamCpo )

	&(cRetCpo) := cCodigo //Uso desta forma para campos como tGet por exemplo.
	cSA3REP    := cCodigo // Alimentar a variável estatica
	//aCpoRet[1] := cCodigo // Obrigatório no P11 e inexistente no P12
	
	bRet := .T.
	
	_oDlg:End()    

Return

// Faz o retorno da consulta padrão, do conteúdo da variável estatica
User Function cSA3REP()
Return(cSA3REP)

// Validação para o campo C5_VEND1
User Function RepAut()

    Local _cRep := ""
	Local _lRet := .F.
	Local _aRep := {}
    Local aAreaAtu := GetArea()
    Local aAreaSA1 := SA1->( GetArea() )
    Local aAreaSA3 := SA3->( GetArea() )
    
	If !Empty( M->C5_CLIENTE + M->C5_LOJACLI )

		If M->C5_CLIENTE + M->C5_LOJACLI != SA1->A1_COD + SA1->A1_LOJA
			_cRep := AllTrim( Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_REPAUTO") )
			_cRep += ";"+ Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_VEND")
		Else
			_cRep := AllTrim( SA1->A1_REPAUTO ) +";"+ SA1->A1_VEND
		EndIf

	EndIf
		
	If !( M->C5_VEND1 $ _cRep )

		If Len( AllTrim( _cRep ) ) > 6
			_aRep := StrTokArr2( _cRep, ";" )
		Else
			aAdd( _aRep, _cRep )
		EndIf
		
		If Len( _aRep ) > 0
			For _nX := 1 To Len( _aRep )
				_cRepSub := Posicione("SA3", 1, xFilial() + _aRep[_nX],"A3_REPSUBS")
				If M->C5_VEND1 $ _cRepSub
					_lRet := .T.
					Exit
				EndIf
			Next
		EndIf
	Else
		_lRet := .T.
	EndIf

	If !_lRet
		MsgAlert("O representante informado não pode ser utilizado para este cliente!")
	EndIf
	
	RestArea( aAreaSA3 )
	RestArea( aAreaSA1 )
	RestArea( aAreaAtu )

Return( _lRet )