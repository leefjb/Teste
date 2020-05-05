#Include 'Protheus.ch'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � JMHA200  � Autor � Jeferson Dambros      � Data �Ago/2013  ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Cadastro de faixa                                          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � u_JMHA200                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Jomhedica                                                  ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
User Function JMHA200()

	Local aArea := GetArea()
	Local aCores:= {}
	
	Private cCadastro:= "Cadastro de Faixa"
	Private aRotina	:= MenuDef()
	
	aAdd( aCores, { "DtoS(ZB_VIGEFIM) >= DToS(DDATABASE)"	,"BR_VERDE"} )
	aAdd( aCores, { "DtoS(ZB_VIGEFIM) <  DToS(DDATABASE)"	,"BR_VERMELHO"} )
	
	dbSelectArea("SZB")
	dbSetOrder(1)
    
    mBrowse( 6,1,22,75,"SZB",,,,,,aCores)
	
	RestArea(aArea)
Return                      


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �HA200GET  � Autor � Jeferson Dambros      � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta a GETDADOS Modelo 2                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/                                            
User Function HA200GET(cAlias,nReg,nOpc)

	//-- Genericas 
	Local nX			:= 0
	//-- Enchoice
	Local aVisual		:= {}
	Local oEnch
	//-- EnchoiceBar
	Local nOpca		:= 0
	//-- GetDados  
	Local aNoFields	:= {} 
	//-- Controle de dimensoes de objetos
	Local aObjects	:= {}
	Local aInfo		:= {}
	//-- Dialog                                        
	Private oDlg
	//-- Enchoice
	Private aTela[0][0]
	Private aGets[0]
	//-- GetDados
	Private oGetD
	Private aHeader	:= {}
	Private aCols		:= {}
	Private N			:= 0

    
	//-- Campos da enchoice (Cabecalho)
	aAdd( aVisual, 'ZB_FAIXA  '	)
	aAdd( aVisual, 'ZB_DATA   '	)
	aAdd( aVisual, 'ZB_GRUPO  '	)
	aAdd( aVisual, 'ZB_VEND   '	)
	aAdd( aVisual, 'ZB_TIPO   '	)
	aAdd( aVisual, 'ZB_VIGENC '	)
	aAdd( aVisual, 'ZB_VIGEFIM'	)
	aAdd( aVisual, 'ZB_PAGABON'	)
	aAdd( aVisual, 'ZB_TABPRC '	)
	aAdd( aVisual, 'NOUSER    '	)
                                     

	//-- Campos que nao aparecerao na GetDados (Itens)
	aAdd( aNoFields, 'ZB_FILIAL'	)
	aAdd( aNoFields, 'ZB_FAIXA'		)
	aAdd( aNoFields, 'ZB_DATA'		)
	aAdd( aNoFields, 'ZB_GRUPO'		)
	aAdd( aNoFields, 'ZB_VEND'		)
	aAdd( aNoFields, 'ZB_TIPO'		)
	aAdd( aNoFields, 'ZB_VIGENC'	)
	aAdd( aNoFields, 'ZB_VIGEFIM'	)
	aAdd( aNoFields, 'ZB_TABPRC'	)
	aAdd( aNoFields, 'ZB_PAGABON'	)

	// -- Carrego a tabela na memoria ( M-> )
	// --- Se for 3=INCLUIR os campos ser�o brancos
	RegToMemory( "SZB",(nOpc == 3) )
	            
	//-- Configura variaveis da GetDados
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZB")
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SZB" )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			If ( aScan( aNoFields, {|x| x == AllTrim(SX3->X3_CAMPO)} ) ) == 0

				aAdd(aHeader,{ 	Trim(X3Titulo()),;	//1
								Trim(SX3->X3_CAMPO),;	//2
								SX3->X3_PICTURE,;     	//3
								SX3->X3_TAMANHO,;      	//4
								SX3->X3_DECIMAL,;      	//5
								SX3->X3_VALID,;        	//6
								SX3->X3_USADO,;        	//7
								SX3->X3_TIPO,;         	//8
								SX3->X3_ARQUIVO,;      	//9
								SX3->X3_CONTEXT } )    	//10
			EndIf
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	//-- Carrega os dados para o aCols
	n:=0
	
    dbSelectArea("SZB")
	dbSetOrder(1) 
	dbSeek(xFilial("SZB") + M->ZB_FAIXA )

	While !Eof()	.And. SZB->ZB_FILIAL == xFilial("SZB")	.And. SZB->ZB_FAIXA == M->ZB_FAIXA

		n++
		aAdd(aCols,Array(Len(aHeader)+1))			//-- Carrego a posicao do aCols como NIL
		For nX := 1 To Len(aHeader)
			If ( aHeader[nX][10] != "V" )			// -- Pego campo somente que e REAL
				aCols[Len(aCols)][nX] := FieldGet(FieldPos(aHeader[nX][2]))
			Else										// -- Se for campo virtual inicializa com conteudo do campo
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
			EndIf
		Next nX
		aCols[Len(aCols)][Len(aHeader)+1] := .F.	// -- Marco a linha como NAO deletada
		dbSkip()
	EndDo
     
	//-- Inicializa a getdados se a linha estiver em branco.
	If Len(aCols) == 0

		aAdd(aCols,Array(Len(aHeader)+1)) 		//-- Carrego a posicao do aCols como NIL
		For nX := 1 To Len(aHeader)
			If ( aHeader[nX][10] != "V" )			// -- Pego campo somente que e REAL
				aCols[Len(aCols)][nX] := FieldGet(FieldPos(aHeader[nX][2]))
			Else										// -- Se for campo virtual inicializa com conteudo do campo
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
			EndIf
		Next nX
		aCols[Len(aCols)][Len(aHeader)+1] := .F. // -- Marco a linha como NAO deletada
		
		//Inicializo o item		
		GDFieldPut( 'ZB_ITEM', StrZero(1,Len(SZB->ZB_ITEM)),1)
		
	EndIf
	
	//-- Item 1 selecionado
	n:=1 
	
	//-- Dimensoes padroes
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 040, .T., .T. } )
	AAdd( aObjects, { 100, 090, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
		
	//-- Inicializa a MsDialog
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] PIXEL 
	
		//-- Monta a enchoice.
		oEnch := MsMGet():New( cAlias, nReg, nOpc,,,, aVisual, aPosObj[1],,3,,,,,,.T. )

		//-- Parametros MsGetDados( nT, nL, nB, nR,                                                   nOpc ,    cLinhaOk,    cTudoOk,  cIniCpos,  lDeleta					 			,aAlter,nFreeze,lEmpty,nMax,cFieldOk,cSuperDel,aTeclas, cDelOk,oWnd)	
		oGetD := MSGetDados():New( aPosObj[ 2, 1 ],aPosObj[ 2, 2 ],aPosObj[ 2, 3 ],aPosObj[ 2, 4 ], nOpc,"U_HA200LOK","U_HA200TOK","+ZB_ITEM", Iif(nOpc == 3 .Or. nOpc == 4 ,.T.,.F.),      ,       ,      ,    ,        ,""       ,       , )
		
		oGetD:nMax := 999
		
	//-- Parametros                 EnchoiceBar(1-Objeto da Janela Principal, 2-Sera executado se pressionado Ok,    3-Botao Cancela,,5-Para acrescentar botoes na barra
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg ,{|| If( oGetD:TudoOk(), ( nOpca:=1, oDlg:End() ), nOpca:=0 ) }, {||oDlg:End(), nOpca:=0 },,)
	
	//-- Botao OK 
	If nOpc != 2
		If nOpca == 1
			GravarSZB(nOpc)		
			If __lSX8
				ConfirmSX8()
			EndIf	
		Else
			If __lSX8
				RollbackSX8()
			EndIf		
		EndIf
	EndIf
	
Return                     


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �HA200LOK  � Autor � Jeferson Dambros      � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao Linha do aCols                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/                                            
User Function HA200LOK()

	Local lRet := .T.
	
	//-- Valida se existe chave duplicada
	If !GDDeleted( n ) // Retorna se a Linha esta deletada, (n) Linha da posicao do GetDados
		//-- Analisa se ha itens duplicados na GetDados. 
	  	lRet := GDCheckKey(  { "ZB_FAXDE", "ZB_FAXATE" }, 4 ) // Verifica se nao ha chave duplicada, 4 -> Mensagem padrao
	EndIf			

Return( lRet )
          

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �HA200TOK  � Autor � Jeferson Dambros      � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao Geral ( aHeader + aCols )		                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/                        
User Function HA200TOK(nOpc)

	Local lRet	:= .T.                                          
	Local nPosFde	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZB_FAXDE"})
	
	//-- Analisa se os campos obrigatorios da Enchoice foram informados.
	lRet := Obrigatorio( aGets, aTela)
	
	// Jean Rehermann - 06/05/2017 - Valida se ao selecionar o tipo de c�lculo por percentual de desconto tamb�m foi informada a tabela de pre�o
	If lRet
		If M->ZB_TIPO == "1" .And. Empty( M->ZB_TABPRC )
			MsgAlert("Tabela de pre�o obrigat�ria quando tipo de c�lculo for Percentual!")
			lRet := .F.
		EndIf
	EndIf
	
	//-- Analisa se os campos obrigatorios da GetDados foram informados.
	If lRet
		lRet := oGetD:ChkObrigat( n )
	EndIf                                                                                     
	
	//-- Analisa se a Linha da GetDados esta Ok
	If lRet
		lRet := U_HA200LOK()
	EndIf
	
	//-- Analisa se todos os itens da GetDados estao deletados.
	If lRet .And. aScan( aCols, { |x| x[ Len( x ) ] == .F. } ) == 0
		Help( ' ', 1, 'OBRIGAT2')
		lRet := .F.
	EndIf
	
	//-- Verifica se todas as linhas estao em branco
	//If lRet .And. aScan( aCols, { |x| !Empty(x[nPosFde]) } ) == 0
	//	Help( ' ', 1, 'OBRIGAT2')
	//	lRet := .F.
	//EndIf
	
	//-- Na inclusao 
	/*
	If lRet .And. Inclui
	
		If ValidVig()[1]
			Aviso( "Atencao!","Datas de vig�ncia inv�lidas!."+ CRLF +;
								"A vigencia, precisa ser maior que, a data, "+DtoC( ValidVig()[2] ), { "OK" } )
			lRet := .F.
		EndIf
	
		If lRet .And. ExistCad()
			Alert("Inclus�o n�o permitida!"+ CRLF +;
					"Grupo, ou grupo + vendedor j� possui faixa cadastrada.")
			lRet := .F.
		EndIf 	
	EndIf
	*/
	
Return( lRet )
                       
                      
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �GravarSZB � Autor � Jeferson Dambros      � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotinas Incluir, alterar e excluir ( cabecalho e itens )   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/                                            
Static Function GravarSZB(nOpc)  
               
	Local nZ		:= 0 
	Local nY		:= 0
	Local nPItem	:= 0

	
	If nOpc == 5 //5=Excluir
	
		dbSelectArea("SZB")
		dbSetOrder(1)

        If dbSeek( xFilial("SZB") + M->ZB_FAIXA)
        
   			While SZB->(!Eof())	.And. SZB->ZB_FILIAL == xFilial("SZB")	.And. SZB->ZB_FAIXA == M->ZB_FAIXA
                                                             
	        	RecLock("SZB", .F.)
					SZB->(dbDelete())
	        	MsUnLock()
	        	
	        	dbSelectArea("SZB")
	        	dbSkip()
	        	
	        EndDo
	        	
        EndIf 

	EndIf
	
	If nOpc == 3 //3=Incluir 

		dbSelectArea("SZB")
		dbSetOrder(1)

		For nZ := 1 To Len( aCols )
	
			If !GDDeleted( nZ )
			
				If !MsSeek(xFilial("SZB")+M->ZB_FAIXA+GDFieldGet("ZB_ITEM",nZ),.F.) //MsSeek(xFilial("SZB")+M->ZB_VEND+M->ZB_GRUPO+GDFieldGet("ZB_ITEM",nZ),.F.) 

					RecLock("SZB",.T.)               
		
						SZB->ZB_FILIAL	:= xFilial("SZB")		
						SZB->ZB_FAIXA		:= M->ZB_FAIXA	
						SZB->ZB_DATA		:= M->ZB_DATA
						SZB->ZB_GRUPO		:= M->ZB_GRUPO
						SZB->ZB_VEND		:= M->ZB_VEND
						SZB->ZB_TIPO		:= M->ZB_TIPO
						SZB->ZB_VIGENC	    := M->ZB_VIGENC
						SZB->ZB_VIGEFIM	    := M->ZB_VIGEFIM
						SZB->ZB_PAGABON  	:= M->ZB_PAGABON
						SZB->ZB_TABPRC  	:= M->ZB_TABPRC
					
						For nY := 1 To Len(aHeader)
							If aHeader[nY,10] != 'V'
				         		FieldPut(FieldPos(aHeader[nY,2]), aCols[nZ,nY])
			    			EndIf
						Next nY
						
					MsUnLock()
					
				EndIf
			EndIf
			
		Next nZ
	
	ElseIf nOpc == 4 //4=Alterar                                      
	
		dbSelectArea("SZB")
		dbSetOrder(1)

		For nZ := 1 To Len( aCols )
	
			If !GDDeleted( nZ )
			
				If MsSeek(xFilial("SZB")+M->ZB_FAIXA+GDFieldGet("ZB_ITEM",nZ),.F.) 
					RecLock("SZB",.F.) 
				Else
					RecLock("SZB",.T.)               
				EndIf
				
				SZB->ZB_FILIAL	:= xFilial("SZB")		
				SZB->ZB_FAIXA		:= M->ZB_FAIXA	
				SZB->ZB_DATA		:= M->ZB_DATA
				SZB->ZB_GRUPO		:= M->ZB_GRUPO
				SZB->ZB_VEND		:= M->ZB_VEND
				SZB->ZB_TIPO		:= M->ZB_TIPO
				SZB->ZB_VIGENC	    := M->ZB_VIGENC
				SZB->ZB_VIGEFIM	    := M->ZB_VIGEFIM            
				SZB->ZB_PAGABON  	:= M->ZB_PAGABON
				SZB->ZB_TABPRC  	:= M->ZB_TABPRC
				
				For nY := 1 To Len(aHeader)
					If aHeader[nY,10] != 'V'
		         		FieldPut(FieldPos(aHeader[nY,2]), aCols[nZ,nY])
	    			EndIf
				Next nY
				MsUnLock()
				
			Else                                                                               
				If MsSeek(xFilial("SZB")+M->ZB_FAIXA+GDFieldGet("ZB_ITEM",nZ),.F.)  
					RecLock("SZB",.F.)
						SZB->(dbDelete())
					MsUnLock()
				EndIf	
			EndIf
			
		Next nZ
	EndIf	
	
Return 


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �ValidVig  � Autor � Jeferson Dambros      � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna .T. para as datas de vigencia invalidas.           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function ValidVig()

	Local cQuery 	:= ""
	Local aRet	:= {.F., CtoD("//")}
	
	cQuery := " SELECT MAX(ZB_VIGEFIM) AS ULTDATA" 
	cQuery += " FROM" + RetSQLName("SZB")
	cQuery += " WHERE ZB_FILIAL   = '" + xFilial("SZB")	+"'"
	cQuery += "   AND ZB_VEND     = '" + M->ZB_VEND    	+"'"		
	cQuery += "   AND ZB_GRUPO    = '" + M->ZB_GRUPO   	+"'"
	cQuery += "   AND D_E_L_E_T_ <> '*' "
		
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "VIG", .F., .T.)
	
	TCSetField("VIG", "ULTDATA", "D", 8, 0)
	
	VIG->(dbGoTop())
	If VIG->(!Eof())
	
		If M->ZB_VIGENC <= VIG->ULTDATA .Or. M->ZB_VIGEFIM <= VIG->ULTDATA 	
		
			aRet[1] := .T.
			aRet[2] := VIG->ULTDATA
		
		EndIf
	EndIf
	VIG->(dbCloseArea())
		
Return(aRet)                                                                


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �ExistCad  � Autor � Jeferson Dambros      � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna .T. = para o grupo + vendedor cadastrado           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/                        
Static Function ExistCad()

	Local cQuery := ""
	Local lExist := .F.

	cQuery := " SELECT ZB_GRUPO" 
	cQuery += " FROM" + RetSQLName("SZB")
	cQuery += " WHERE ZB_FILIAL  = '" + xFilial("SZB") 		+"' "
	cQuery += "   AND ZB_VEND    = '" + M->ZB_VEND    		+"' "		
	cQuery += "   AND ZB_GRUPO   = '" + M->ZB_GRUPO 		+"' "
	cQuery += "   AND ZB_VIGENC  = '" + DtoS(M->ZB_VIGENC)	+"' "
	cQuery += "   AND ZB_VIGEFIM = '" + DtoS(M->ZB_VIGEFIM)	+"' "
	cQuery += "   AND D_E_L_E_T_ <> '*' "
		
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "TMP01", .F., .T.) 
	
	TMP01->(dbGoTop())

	lExist := !Empty(TMP01->ZB_GRUPO)    

	TMP01->(dbCloseArea())              
	
Return(lExist)


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �HA200LEG  � Autor � Jeferson Dambros      � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Botao Legenda                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function HA200LEG()

	Local aLegenda := {}
	
	aAdd(aLegenda, 	{"BR_VERDE" 	,	'Dentro do prazo de vigncia' } )
	aAdd(aLegenda, 	{"BR_VERMELHO",	'Fora do prazo de vig�ncia' } )

	BrwLegenda(cCadastro, 'Situa��o', aLegenda)
	
Return 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Jeferson Dambros      � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �    1 - Pesquisa e Posiciona em um Banco de Dados     	    ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function MenuDef()

	Local aRotina := {} 
	
	aAdd( aRotina,	{ OemToAnsi("Pesquisar") 	, "AxPesqui"  	, 0 , 1	} )	//Pesquisar
	aAdd( aRotina,	{ OemToAnsi("Visualizar")	, "U_HA200GET" 	, 0 , 2	} )	//Visualizar
	aAdd( aRotina,	{ OemToAnsi("Incluir")		, "U_HA200GET" 	, 0 , 3	} )	//Incluir
	aAdd( aRotina,	{ OemToAnsi("Alterar")		, "U_HA200GET" 	, 0 , 4	} )	//Alterar
	aAdd( aRotina,	{ OemToAnsi("Excluir")		, "U_HA200GET" 	, 0 , 5	} )	//Excluir
	aAdd( aRotina,	{ OemToAnsi("Legenda")		, "U_HA200LEG" 	, 0 , 7	} )	//Legenda

Return(aRotina)