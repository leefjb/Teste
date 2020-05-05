#Include "Protheus.ch"
#Include "Trsf010.ch"    

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � TRSF012  � Autor � Jeferson Dambros      � Data � Dez/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Responsavel por controlar o status do pedido, em todos os  ���
���          � pontos de entradas utilizados nas rotinas de monitoramento.���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � u_TRSF012                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nil                                                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpX1 ( variavel conforme ponto de entrada )               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TRSF012()

	Local aArea		:= GetArea()
	Local cMsg		:= ""
	Local cPE			:= ProcName(1)// 1 Nivel acima
	Local xRet		:= Nil
	Local cMvParam	:= "TRS_MON001"
	Local cMvFluxo	:= AllTrim( SuperGetMV( cMvParam, .F., "" ) )
	
	
	//�������������������������������������������������������������������������������������Ŀ
	//� Fluxo operacional                                                                   �
	//�                                                                                     �
	//� 1 = Pedido -> Separacao c/ Liberacao Estoque -> Faturamento -> Conferencia p/ DANFE �
	//� 2 = Pedido -> Liberacoes -> Separacao -> Conferencia -> Faturamento                 �
	//���������������������������������������������������������������������������������������
	
	If Empty(cMvFluxo) .Or. !(cMvFluxo $ "12")
	
		cMsg := "Preencher o parametro:" 
		cMsg += CRLF
		cMsg += cMvParam
		cMsg += CRLF
		cMsg += "Conforme o fluxo operacional ( '1' ou '2' ):"
		cMsg += CRLF
		cMsg += "1 = Pedido -> Separacao c/ Liberacao Estoque -> Faturamento -> Conferencia p/ DANFE"
		cMsg += CRLF
		cMsg += "2 = Pedido -> Liberacoes -> Separacao -> Conferencia -> Faturamento"
		cMsg += CRLF
				 
		Aviso("TRSF012|Aten��o!",cMsg,{"Ok"})
	
	Else
	
		If cMvFluxo = "1"
			
			If cPE = "U_M410STTS"
				xRet := M410STTS()
			ElseIf cPE = "U_M460FIM"
				xRet := M460FIM()
			ElseIf cPE = "U_MT410ACE"
				xRet := MT410ACE()
			ElseIf cPE = "U_MS520VLD"
				xRet := MS520VLD()
			ElseIf cPE = "U_M440STTS"
				xRet := M440STTS()
			ElseIf cPE = "U_M410PVNF"
				xRet := M410PVNF()
			ElseIf cPE = "U_LJ7047"
				xRet := LJ7047()
			EndIf	
			
		ElseIf cMvFluxo = "2"
		
			If cPE = "U_M410STTS"
				xRet := M410STTS()
			ElseIf cPE = "U_M460FIM"
				xRet := M460FIM()
			ElseIf cPE = "U_M460MARK"
				xRet := M460MARK()
			ElseIf cPE = "U_MT410ACE"
				xRet := MT410ACE()
			ElseIf cPE = "U_MT450FIM"
				xRet := MT450FIM()
			ElseIf cPE = "U_MTA455P"
				xRet := MTA455P()
			ElseIf cPE = "U_MTA456L"
				xRet := MTA456L()
			ElseIf cPE = "U_MS520VLD"
				xRet := MS520VLD()
			ElseIf cPE = "U_M440STTS"
				xRet := M440STTS()
			ElseIf cPE = "U_M410PVNF"
				xRet := M410PVNF()
			ElseIf cPE = "U_LJ7047"
				xRet := LJ7047()
			EndIf	
		
		EndIf
	
	EndIf
	
	RestArea(aArea)

Return( xRet )


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � M410STTS � Autor � Jeferson Dambros      � Data � Dez/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada pertence a rotina de pedidos de venda,    ���
���          � MATA410().                                                 ���
���          � Esta em todas as rotinas de Alteracao, Inclusao, Exclusao  ���
���          � Copia e Devolucao de Compras.                              ���
���          � Executado apos todas as alteracoes no arquivo de pedidos   ���
���          � terem sido feitas.                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function M410STTS()

	Local aAreaSC6	:= SC6->( GetArea() )
	Local cArea		:= ""
	Local cQuery		:= ""
	Local cStatus		:= ""
	Local cOrdSep		:= ""
	Local cUpdate		:= ""
	Local cMvFluxo	:= AllTrim( SuperGetMV( "TRS_MON001", .F., "" ) )
	Local nTamOrdem	:= TamSX3("C5_ORDSEP")[1]
	Local lAglutina	:= SuperGetMV( "TRS_MON010", .F., .F. )
	Local lMvSepLib 	:= IIf( cMvFluxo = "2", SuperGetMV( "TRS_MON007", .F., .F. ), .T. ) // Se separa com ou sem liberacao de estoque
	
	// Campos utilizados no cliente / loja de entrega
	Local aMvCpoEnt	:= Eval( {||	aMvCpoEnt := StrToKArr( Upper( SuperGetMv( "TRS_MON006", .F., "C5_CLIENT|C5_LOJAENT", ) ), "|" ),;
								 		IIf( Len(aMvCpoEnt) = 0, {"C5_CLIENT", "C5_LOJAENT"}, aMvCpoEnt ) } )
	
	
	If INCLUI .And. SC5->C5_TIPO = "N"

		//-- Para copia de pedido, limpo sempre os campos especificos.
		dbSelectArea("SC5")
		dbSetOrder(1)
		
		Reclock("SC5",.F.)
			SC5->C5_PVSTAT := ""
			SC5->C5_ORDSEP := ""
			SC5->C5_PVVALE := ""
			SC5->C5_USRSEP := ""
			SC5->C5_DTASEP := CToD("//")
			SC5->C5_HRASEP := ""
			SC5->C5_USRCON := ""
		MsUnlock()
		
		//-- Para copia de pedido, limpo sempre os campos especificos.
		dbSelectArea("SC6")
		dbSetOrder(1)
		
		If dbSeek(xFilial("SC6")+SC5->C5_NUM)
		
			While SC6->( !Eof() ) .And. SC5->C5_NUM = SC6->C6_NUM
			
				Reclock("SC6",.F.)
					SC6->C6_QTDSEP	:= 0
					SC6->C6_USRSEP	:= ""
					SC6->C6_QTDCONF	:= 0
					SC6->C6_BOXSEP	:= ""
				MsUnlock()
				
				SC6->( dbSkip() )
			
			EndDo
		
		EndIf
		
		/*
		If Empty(SC5->C5_BLQ)
			cStatus := PEDIDO_INCLUIDO
		Else
			cStatus := LIB_COMERCIAL
		EndIf
		*/
	
		If lMvSepLib
		
			cStatus := PEDIDO_INCLUIDO
			
		Else
			
			cQuery := " SELECT	C9_BLEST, C9_BLCRED" 		
			cQuery += " FROM	" + RetSQLName("SC9") 
			cQuery += " WHERE		C9_FILIAL	= '" + xFilial("SC9") + "'"		 
			cQuery += "		AND	C9_PEDIDO	= '" + SC5->C5_NUM + "'" 		
			cQuery += "  		AND	C9_QTDLIB	> 0" 	
			cQuery += "		AND	D_E_L_E_T_ <> '*'"
			
			cQuery := ChangeQuery( cQuery )
		
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), ( cArea := GetNextAlias() ), .F., .T. )
			
			(cArea)->( dbGoTop() )
		
			If (cArea)-> ( Eof() )
			
				cStatus := LIB_COMERCIAL
				
			Else
			
				cStatus := PEDIDO_INCLUIDO
				
				While (cArea)-> ( !Eof() )
				
					If !Empty( (cArea)->C9_BLCRED )
					
						cStatus := LIB_CREDITO
						
						Exit
						
					ElseIf !Empty( (cArea)->C9_BLEST )
					
						cStatus := LIB_ESTOQUE
						
						Exit					
					
					EndIf
					
					(cArea)->( dbSkip() )
				
				EndDo				
			
			EndIf
			
			(cArea)->( dbCloseArea() )	
			
		EndIf
		
		cOrdSep := Soma1( U_F010OrdSep() )
	
		dbSelectArea("SC5")
		dbSetOrder(1)
		
		Reclock("SC5",.F.)
			SC5->C5_PVSTAT := cStatus
			SC5->C5_ORDSEP := cOrdSep
			SC5->C5_PVVALE := "N" //-- S=Sim ou N=Nao 
		MsUnlock()                
		
		//-- Quando for o mesmo Cliente de entrega
		//-- a ordem de separacao eh repetida
		
		If	lAglutina		

			cQuery := " SELECT COUNT( C5_NUM ) NUM "		
			cQuery += " FROM		" + RetSQLName("SC5")	
			cQuery += " WHERE		C5_FILIAL	= '" + xFilial("SC5") + "'"		 
			cQuery += " 		AND	" + aMvCpoEnt[1] + " = '" + SC5->&(aMvCpoEnt[1]) + "'"	
			cQuery += " 		AND	" + aMvCpoEnt[2] + " = '" + SC5->&(aMvCpoEnt[2]) + "'"
			cQuery += " 		AND	C5_PVSTAT	= '" + cStatus + "'"	
			cQuery += " 		AND	D_E_L_E_T_	<> '*'"
			
			cQuery := ChangeQuery(cQuery)
		
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),( cArea := GetNextAlias() ),.F.,.T.)
		
			If (cArea)->NUM > 1 
	
				cUpdate := " UPDATE " + RetSQLName("SC5")		
				cUpdate += " 	SET C5_PVVALE 	= 'S', "//S=Sim
				cUpdate += "        C5_ORDSEP	= '" + cOrdSep + "'""
				cUpdate += " 	WHERE	C5_FILIAL	= '" + xFilial("SC5") + "'"		
				cUpdate += " 		AND	" + aMvCpoEnt[1] + " = '" + SC5->&(aMvCpoEnt[1]) + "'"	
				cUpdate += " 		AND	" + aMvCpoEnt[2] + " = '" + SC5->&(aMvCpoEnt[2]) + "'"
				cUpdate += " 		AND	C5_PVSTAT	= '" + cStatus + "'"	
		//		cUpdate += " 		AND	C5_PVVALE	<> 'S'"//S=Sim	
				cUpdate += " 		AND	D_E_L_E_T_	<> '*'"	
			
				TCSqlExec(cUpdate)	
			
			EndIf
	
			(cArea)->( dbCloseArea() )
		
		EndIf

		
	EndIf
	
	RestArea(aAreaSC6)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � M460MARK � Autor � Jeferson Dambros      � Data � Dez/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada 'M460MARK' eh utilizado para validar os   ���
���          � pedidos marcados  e esta localizado no inicio da funcao    ���
���          � a460Nota (endere�a rotinas para a geracao dos arq SD2/SF2).���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � u_M460MARK                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� PARAMIXB                                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. = Continuar ou .F. = Nao continuar                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function M460MARK()

	Local aAreaSC5	:= SC5->(GetArea())
	Local aPedido		:= {}
	Local cArea		:= GetNextAlias()
	Local cQuery		:= ""
	Local cMsg		:= ""
	Local cMarca		:= PARAMIXB[1]
	Local lInverte	:= PARAMIXB[2]
	Local lRet		:= .T.
	
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	
	cQuery := " SELECT 	C9_PEDIDO "		
	cQuery += " FROM		" + RetSQLName("SC9")	
	cQuery += " WHERE		C9_FILIAL	= '" + xFilial("SC9") + "'"		 
	cQuery += "   	AND	C9_OK	 	= '" + cMarca + "'"  
	cQuery += "		AND	D_E_L_E_T_	<> '*'" 	  
	cQuery += " GROUP BY C9_PEDIDO " 	  

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArea,.F.,.T.)
	
	(cArea)->( dbGoTop() )
	
	While (cArea)->( !Eof() )
	
		If SC5->( dbSeek( xFilial("SC5") + (cArea)->C9_PEDIDO ) )
		
			If SC5->C5_PVSTAT < CONFERIDO
			
				aAdd(aPedido, (cArea)->C9_PEDIDO )
			
			EndIf
		
		EndIf
		
		dbSelectArea(cArea)
		dbSkip()
		
	EndDo
	
	(cArea)->( dbCloseArea() )
	
	If Len(aPedido) > 0
	
		lRet := .F.
	
		cMsg := "Impossivel preparar o(s) documento(s)!" 
		cMsg += CRLF
		cMsg += "Motivo: O(s) pedido(s) abaixo n�o foi(ram) conferido(s)." 
		cMsg += CRLF
		
		aEval(aPedido, {|x| cMsg += x + CRLF})
		
		cMsg += CRLF
		cMsg += "Solu��o: Selecione apenas o(s) pedido(s) com status conferido(s)." 
		cMsg += CRLF
	
		Aviso( "TRSF012|Aten��o", cMsg, {"OK"}, 3 )
	
	EndIf
	
	RestArea(aAreaSC5)

Return( lRet )


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � M460FIM  � Autor � Jeferson Dambros      � Data � Dez/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Este P.E. eh chamado apos a Gravacao da NF de Saida, e     ���
���          � fora da transacao.                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � u_M460FIM                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nil                                                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function M460FIM()

	Local aAreaSC5	:= SC5->(GetArea())
	Local aAreaSC6	:= SC6->(GetArea())
	Local aNfPedido 	:= {}
	Local aNfItemPv	:= {}
	Local aNovoPedi	:= {}
	Local cQuery		:= ""
	Local cArea		:= GetNextAlias()
	Local lElimResid	:= .F.
	Local nScan		:= 0
	Local nY			:= 0
	Local nZ			:= 0
	

	cQuery := " SELECT DISTINCT D2_PEDIDO" 
	cQuery += " FROM "+RetSQLName("SD2")
	cQuery += " WHERE D2_FILIAL  =  '"+ xFilial("SD2") +"'"
  	cQuery += "   AND D2_DOC     =  '"+ SF2->F2_DOC +"'"
  	cQuery += "   AND D2_SERIE   =  '"+ SF2->F2_SERIE +"'" 
  	cQuery += "   AND D2_CLIENTE =  '"+ SF2->F2_CLIENTE +"'"
  	cQuery += "   AND D2_LOJA    =  '"+ SF2->F2_LOJA +"'"
  	cQuery += "   AND D_E_L_E_T_ <> '*'"
  	
  	cQuery := ChangeQuery( cQuery )
  	
  	dbUseArea( .T.,"TOPCONN",TcGenQry(,,cQuery),cArea,.F.,.T. )
  
  	If (cArea)->( !Eof() )
  		
  		While (cArea)->( !Eof() )
  		
  			aAdd( aNfPedido, { (cArea)->D2_PEDIDO, {} } )
  			
  			dbSelectArea("SC6")
			dbSetOrder(1)
  		
			If	SC6->( dbSeek(xFilial("SC6")+(cArea)->D2_PEDIDO) )
			
				aNfItemPv := {}
  			
				While SC6->( !Eof() ) .And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM = (cArea)->D2_PEDIDO 
					
					aAdd( aNfItemPv, { 	SC6->C6_ITEM,; 
										 	SC6->C6_PRODUTO,;
										 	(SC6->C6_QTDVEN - SC6->C6_QTDENT);
										})
					
					SC6->( dbSkip() )
					
				EndDo
				
				aNfPedido[Len(aNfPedido),2] := aNfItemPv
			
			EndIf
			
			(cArea)->( dbSkip() )
			
  		EndDo
  		
  		(cArea)->( dbCloseArea() )
  		  	
  		lElimResid := ( aScan( aNfPedido, { |x| aScan( x[2], { |y| y[3] > 0 } ) > 0 } ) > 0 )		
  			
  		If lElimResid
  		
  			//�������������������������������������Ŀ
			//�Verifico se existe ponto de entrada, �
			//�se sim sera exibida a mensagem.      �
			//���������������������������������������
			lElimResid := ExistBlock("F012LRES")
  		
			If lElimResid
 			 		
  				lElimResid := ( Aviso(	"TRSF012|Aten��o",;
  											"Existe(m) quantidade(s) n�o faturada." + CRLF +;
  											CRLF+;
  											"Deseja incluir pedido novo, com a(s) " + CRLF +;
  											"quantidade(s) n�o faturada ?",;
  											{"Sim", "N�o"},;
  											3 ) ) = 1
  			EndIf
  		
  		EndIf
  	
		//�������������������������������������������Ŀ
		//� Alterando o status do pedido              �
		//���������������������������������������������
		
		For nZ := 1 To Len(aNfPedido)
		
			dbSelectArea("SC5")
			dbSetOrder(1)
			
			MsSeek( xFilial("SC5") + aNfPedido[nZ,1] ) 

			RecLock("SC5",.F.)
				SC5->C5_PVSTAT := FATURADO
			MsUnLock()
			
			//�������������������������������������������Ŀ
			//� Eliminar Residuo                          �
			//���������������������������������������������
			
			If lElimResid
			
				For nY := 1 To Len( aNfPedido[nZ,2] )
				
					If 	aNfPedido[nZ,2][nY,3] > 0
					
						// Eliminar residuo do item
						
						dbSelectArea("SC6")
						dbSetOrder(1)
						
						MsSeek( xFilial("SC6") + aNfPedido[nZ,1] + aNfPedido[nZ,2][nY,1] )
				
						If MaResDoFat( SC6->( Recno() ), .T., .T. )
					
							If ( nScan := aScan(aNovoPedi, { |x| x[3] = aNfPedido[nZ,2][nY,2] } ) ) = 0
							
								aAdd(aNovoPedi, { aNfPedido[nZ,1],;		// 1 Pedido
													 aNfPedido[nZ,2][nY,1],;	// 2 Item pedido 
													 aNfPedido[nZ,2][nY,2],;	// 3 Produto
													 aNfPedido[nZ,2][nY,3];	// 4 Quantidade (residuo)
													 } )
							
							Else
								
								aNovoPedi[nScan,1] := aNfPedido[nZ,1]
								aNovoPedi[nScan,4] += aNfPedido[nZ,2][nY,3]
							
							EndIf		
						EndIf
					EndIf
				Next nY
			EndIf
		Next nZ
		
		//Incluir pedido ( NOVO )
				
		If Len(aNovoPedi) = 0
		
			If lElimResid

				MsgAlert( "Pedido novo n�o gerado!" + CRLF +;
							CRLF+;
							"Existe(m) quantidade(s) empenhada no(s) pedido(s).",;
							"Aten��o" )
			
			EndIf
		
		Else
		
		  	//�������������������������������������Ŀ
			//�Ponto de Entrada na Rotina           �
			//���������������������������������������
			
			ExecBlock( "F012LRES", .F., .F., aClone(aNovoPedi) )
			
		EndIf

	EndIf// cArea

	RestArea(aAreaSC5)
	RestArea(aAreaSC6)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MT410ACE � Autor � Jeferson Dambros      � Data � Dez/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada 'MT410ACE' criado para verificar o acesso ���
���          � dos usuarios nas rotinas: Excluir, Visualizar,             ���
���          � Residuo, Copiar e Alterar.                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � u_MT410ACE                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� PARAMIXB                                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. = Continuar ou .F. = Nao continuar                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MT410ACE()

	Local lRet	:= .T.
	Local nOpc	:= PARAMIXB[1] // 1 - Excluir, 2 - Visualizar / Residuo, 3 - Copiar, 4 - Alterar
	Local cMsg	:= ""
	

	If nOpc = 1
	
		// Verificando status do pedido
		If !Empty(SC5->C5_PVSTAT)
			
			lRet := ( SC5->C5_PVSTAT = PEDIDO_INCLUIDO )
			
			If !lRet
			
				cMsg := "Verifique o status atual do pedido."
				cMsg += CRLF 
				cMsg += "Pedido n�o pode ser excluido!"
				cMsg += CRLF
				cMsg += "Status: " + SC5->C5_PVSTAT + " - " + PV_STATUS[aScan(PV_STATUS, {|x| x[1] = SC5->C5_PVSTAT})][2]  
			
				Aviso("TRSF012|Aten��o", cMsg, {"Ok"})
				
			EndIf
		EndIf	
		
	ElseIf nOpc = 4
	
		If !Empty(SC5->C5_PVSTAT)
		
			// Verificando status do pedido
			lRet := ( SC5->C5_PVSTAT = PEDIDO_INCLUIDO )
			
			If !lRet

				cMsg := "Verifique o status atual do pedido."
				cMsg += CRLF 
				cMsg += "Pedido n�o pode ser alterado!"
				cMsg += CRLF
				cMsg += "Status: " + SC5->C5_PVSTAT + " - " + PV_STATUS[aScan(PV_STATUS, {|x| x[1] = SC5->C5_PVSTAT})][2]  
			
				Aviso("TRSF012|Aten��o", cMsg, {"Ok"})
				
			EndIf
		EndIf
		
	EndIf
	
Return( lRet )


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MT450FIM � Autor � Jeferson Dambros      � Data � Dez/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Este ponto pertence a rotina de liberacao de credito,      ���
���          � MATA450(). Esta localizado na liberacao manual do credito  ���
���          � por pedido A450LIBMAN(). Eh executado ao final da          ���
���          � liberacao de um pedido.                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MT450FIM()

	If !Empty(SC5->C5_LIBEROK) .And. Empty(SC5->C5_BLQ)

		//Verifico a liberacao no SC9
		If F012VerLib( SC5->C5_NUM ) 
			
			dbSelectArea("SC5")
			dbSetOrder(1)
			
			Reclock("SC5",.F.)
				SC5->C5_PVSTAT := PEDIDO_INCLUIDO
			MsUnlock()
		EndIf
				
	EndIf

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MTA455P  � Autor � Jeferson Dambros      � Data � Dez/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada para Validar Liberacao de Estoque         ���
���          � Executado apos liberacao do estoque, e impede a liberacao  ���
���          � dependendo do retorno.                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MTA455P()
	
	
	If !Empty(SC5->C5_LIBEROK) .And. Empty(SC5->C5_BLQ)
	
		//Verifico a liberacao no SC9
		If F012VerLib( SC5->C5_NUM ) 
			
			dbSelectArea("SC5")
			dbSetOrder(1)
			
			Reclock("SC5",.F.)
				SC5->C5_PVSTAT := PEDIDO_INCLUIDO
			MsUnlock()
			
		EndIf
	EndIf

Return(.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MTA456L  � Autor � Jeferson Dambros      � Data � Dez/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada executado apos a gravacao de todas as     ���
���          � liberacoes do pedido de vendas (Liberacao Manual)          ���
���          � tabela SC9.                                                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MTA456L()

	If !Empty(SC5->C5_LIBEROK) .And. Empty(SC5->C5_BLQ)
	
		//Verifico a liberacao no SC9
		If F012VerLib( SC5->C5_NUM ) 
	
			dbSelectArea("SC5")
			dbSetOrder(1)
		
			Reclock("SC5",.F.)
				SC5->C5_PVSTAT := PEDIDO_INCLUIDO
			MsUnlock()
			
		EndIf
	EndIf

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MS520VLD � Autor � Jeferson Dambros      � Data � Dez/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Esse ponto de entrada e chamado para validar ou nao a      ���
���          � exclusao da nota na rotina MATA521.                        ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MS520VLD()

	Local aAreaSC5	:= SC5->( GetArea() )
	Local cQuery		:= ""
	Local cAliasTmp	:= GetNextAlias()
	
	
	dbSelectArea("SC5")
	dbSetOrder(1)
		
	cQuery := " SELECT DISTINCT D2_PEDIDO" 
	cQuery += " FROM " + RetSQLName("SD2")
	cQuery += " WHERE D2_FILIAL  =  '"+ xFilial("SD2") +"'"
  	cQuery += "   AND D2_DOC     =  '"+ SF2->F2_DOC +"'"
  	cQuery += "   AND D2_SERIE   =  '"+ SF2->F2_SERIE +"'" 
  	cQuery += "   AND D2_CLIENTE =  '"+ SF2->F2_CLIENTE +"'"
  	cQuery += "   AND D2_LOJA    =  '"+ SF2->F2_LOJA +"'"
  	cQuery += "   AND D_E_L_E_T_ <> '*'"
  	
  	cQuery := ChangeQuery( cQuery )
  	
  	dbUseArea( .T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.F.,.T. )
  
	While (cAliasTmp)->( !Eof() )
		
		If	SC5->( dbSeek(xFilial("SC5")+(cAliasTmp)->D2_PEDIDO) )
		
			RecLock("SC5",.F.)
				SC5->C5_PVSTAT := FATURAMENTO_EXCLUIDO
			MsUnLock()
			
		EndIf
	
		(cAliasTmp)->( dbSkip() )
		
	EndDo
	
	(cAliasTmp)->( dbCloseArea() )
	
	RestArea( aAreaSC5 )

Return(.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � M440STTS � Autor � Jeferson Dambros      � Data � Ago/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Este ponto de entrada e executado apos o fechamento da     ���
���          � transacao de liberacao do pedido de venda.                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function M440STTS()

	Local aArea	:= GetArea()
	Local cQuery := ""
	Local cArea	:= ""
	Local lOk		:= .T. 
	 

	//Se a liberacao de REGRA estiver ok
	If !Empty(SC5->C5_LIBEROK) .And. Empty(SC5->C5_BLQ)
	
		//Verifico a liberacao de CREDITO / ESTOQUE

		cQuery := " SELECT	C9_BLEST, C9_BLCRED" 		
		cQuery += " FROM	" + RetSQLName("SC9") 
		cQuery += " WHERE		C9_FILIAL	= '" + xFilial("SC9") + "'"		 
		cQuery += "		AND	C9_PEDIDO	= '" + SC5->C5_NUM + "'" 		
		cQuery += "  		AND	C9_QTDLIB	> 0" 	
		cQuery += "		AND	D_E_L_E_T_ <> '*'"
		
		cQuery := ChangeQuery( cQuery )
	
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), ( cArea := GetNextAlias() ), .F., .T. )
		
		(cArea)->( dbGoTop() )
		
		While (cArea)-> ( !Eof() )
		
			If !Empty( (cArea)->C9_BLCRED ) .Or. !Empty( (cArea)->C9_BLEST )
			
				lOk := .F.
				
				Exit
			
			EndIf
			
			(cArea)->( dbSkip() )
		
		EndDo				
		
		(cArea)->( dbCloseArea() )	
		
		// Se estiver tudo liberado
		If lOk

			dbSelectArea("SC5")
			dbSetOrder(1)
		
			Reclock("SC5",.F.)
				SC5->C5_PVSTAT := PEDIDO_INCLUIDO
			MsUnlock()

		EndIf

	EndIf

	RestArea(aArea)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � M410PVNF � Autor � Jeferson Dambros      � Data � Ago/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada para validacao.                           ���
���          � Executado antes da rotina de geracao de NF's (MA410PVNFS())���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function M410PVNF()

	Local aArea		:= GetArea()
	Local aAreaSC5	:= SC5->( GetArea() ) 
	Local lRet		:= .T.
	Local cMvFluxo	:= AllTrim( SuperGetMV( "TRS_MON001", .F., "" ) )
	Local cMsg		:= ""
	Local nReg		:= PARAMIXB


	dbSelectArea("SC5")
	dbGoTo( nReg )
	
	If cMvFluxo = "1"
	
		If SC5->C5_PVSTAT < SEPARADO
			lRet := .F.
		EndIf
	
	Else
	
		If SC5->C5_PVSTAT < CONFERIDO
			lRet := .F.
		EndIf
	
	EndIf
	
	If !lRet
	
		cMsg := "Impossivel preparar o(s) documento(s)!" 
		cMsg += CRLF
		cMsg += "Motivo: Verifique o status atual do pedido." 
		
		Aviso( "TRSF012|Aten��o", cMsg, {"OK"}, 3 )
	
	EndIf

	RestArea(aAreaSC5)
	RestArea(aArea)

Return( lRet )


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � LJ7047   � Autor � Jeferson Dambros      � Data � Dez/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Este ponto de entrada e chamado na saida da Venda          ���
���          � Assistida. Tem a funcao de avaliar de acordo com os        ���
���          � parametros recebidos se usuario pode, ou nao sair da venda.���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function LJ7047()

	Local aAreaSL1	:= SL1->( GetArea() )
	Local lRet		:= .T.
	Local cStatus		:= ""
	Local cOrdSep		:= ""
		
	
	// Se estiver vazio foi gravacao de orcamento senao venda
	If Empty(SL1->L1_DOC)

	 	//Orcamento
	
		cStatus := PEDIDO_INCLUIDO
	
	Else
		
		//Venda
	
		cStatus := FATURADO
		
		If Empty(SL1->L1_PVSTAT) .Or. SL1->L1_PVSTAT = PEDIDO_INCLUIDO  
		
			Aviso("TRSF012|Aten��o", "Or�amento n�o enviado a separacao.", {"Ok"}, 1)
			
		EndIf
	
	EndIf
	
	If !Empty(cStatus)
	
		cOrdSep := Soma1( U_F010OrdSep() )
	
		dbSelectArea("SL1")
		dbSetOrder(1)
		
		Reclock("SL1",.F.)
			SL1->L1_PVSTAT := cStatus
			SL1->L1_ORDSEP := cOrdSep
		MsUnlock()
	
	EndIf
			
	RestArea(aAreaSL1)

Return( lRet )


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �F012VerLib� Autor � Jeferson Dambros      � Data � Ago/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Verifica a liberacao do credito / estoque de todo pedido   ���
���          � incluido.                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function F012VerLib( cPedido )

	Local cQuery	:= ""
	Local cArea 	:= ""
	Local lRet	:= .F.


	// Verifico a liberacao de credito estoque
	cQuery := " SELECT	C9_BLEST, C9_BLCRED" 		
	cQuery += " FROM	" + RetSQLName("SC9") 
	cQuery += " WHERE		C9_FILIAL	= '" + xFilial("SC9") + "'"		 
	cQuery += "		AND	C9_PEDIDO	= '" + cPedido + "'" 		
	cQuery += "  		AND	C9_QTDLIB	> 0" 	
	cQuery += "		AND	D_E_L_E_T_ <> '*'"
	
	cQuery := ChangeQuery( cQuery )

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), ( cArea := GetNextAlias() ), .F., .T. )
	
	(cArea)->( dbGoTop() )

	While (cArea)-> ( !Eof() )
	
		If Empty( (cArea)->C9_BLCRED ) .And. Empty( (cArea)->C9_BLEST )
		
			lRet := .T. 
		
			Exit
			
		EndIf
		
		(cArea)->( dbSkip() )
	
	EndDo				
	
	(cArea)->( dbCloseArea() )	

Return( lRet )