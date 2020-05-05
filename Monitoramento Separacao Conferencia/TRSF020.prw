#Include "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � TRSF020  � Autor � Jeferson Dambros      � Data � Jun/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Controla o fluxo do Processo de Separacao de Pedido        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � u_TRSF020                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                        ���
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

// CRISTIANO OLIVEIRA - VERSAO MAIS ATUAL PASSADA PELO MARLLON DA TOTVS RS - APENAS REVISAR PARA FUNCIONAR COMPLETAMENTE

User Function TRSF020( cParam )
	
	Local oDlg, oFont, oUser, oPass
	Local aTables			:= {"SM0,SC5,SC6,SC9,SB8"}
	Local aParamRpc		:= {}
	Local lOK				:= .F.
	
	Private l020Coletor	:= .T.
	
	
	If Empty(cParam)
	
		cMsg := "Configurar o atalho"
		cMsg += CRLF
		cMsg += "com informa��es"
		cMsg += CRLF
		cMsg += "referente a filial"
		cMsg += CRLF
		cMsg += "corrente."
		cMsg += CRLF
		cMsg += "Ex: -A=01;01"
		cMsg += CRLF
		
		MsgInfo(cMsg)
		
	Else
	
		//aParamRpc[1] = Empresa 
		//aParamRpc[2] = Filial
		//aParamRpc[3] = Usuario
		//aParamRpc[4] = Senha		
		//aParamRpc[5] = Modulo		

		aParamRpc := StrTokArr( cParam , ";" )

		//Se usuario, senha e modulo nao estiverem preenchidos no atalho do smartclient,
		//adiciono as posicioes 3, 4 e 5, referente ao ( Usuario, senha e modulo ).
		If Len( aParamRpc ) = 2
			aAdd( aParamRpc, Space(25) )	// 3 = Usuario
			aAdd( aParamRpc, Space(25) )	// 4 = Senha
			aAdd( aParamRpc, "EST" )			// 5 = Modulo
		EndIf
	
		RpcClearEnv()
		
		RpcSetEnv( aParamRpc[1], aParamRpc[2], aParamRpc[3], aParamRpc[4],  aParamRpc[5], "TRSF020", aTables, , , ,  )

		// Se o usuario e senha forem preenchidos no atalho
		If ! ( lOk := F020Login( aParamRpc[3], aParamRpc[4] ) )
		
			aParamRpc[3] := Space(25) 
			aParamRpc[4] := Space(25) 
		
			DEFINE MSDIALOG oDlg FROM 100,083 TO 230,315  TITLE "Separa��o (Login)" PIXEL OF oMainWnd
			
			   oDlg:lEscClose := .F.
			
				DEFINE FONT oFont NAME "Arial" SIZE 8,18 BOLD
				
				@ 005,005 SAY  "Usuario:" SIZE 080,008 FONT oFont OF oDlg COLOR CLR_BLUE PIXEL
				@ 005,045 MSGET oUser VAR aParamRpc[3] SIZE 060,010 OF oDlg PIXEL         
				
				@ 020,005 SAY  "Senha:"   SIZE 070,008 FONT oFont OF oDlg COLOR CLR_BLUE PIXEL
				@ 020,045 MSGET oPass VAR aParamRpc[4] PASSWORD SIZE 060,010 OF oDlg PIXEL
						
				DEFINE SBUTTON FROM 040,020 TYPE 1 PIXEL ACTION (  IIf( 	Empty(aParamRpc[3]),;
																					( MsgAlert("Usuario ou senha"+CRLF+"em branco"), oUser:SetFocus() ),;
																					IIf( F020Login( aParamRpc[3], aParamRpc[4] ), ( lOk := .T., oDlg:End() ), ( MsgAlert( "Login inv�lido" ), oUser:SetFocus() ) ) ) );
																 ENABLE OF oDlg
				DEFINE SBUTTON FROM 040,065 TYPE 2 PIXEL ACTION ( lOk := .F., oDlg:End() ) ENABLE OF oDlg
	
			ACTIVATE MSDIALOG oDlg CENTERED
		
		EndIf
		
		RpcClearEnv()
	
		If lOk
		
			Sleep(4000)
			
			RPCSetType(3)
			
			If	RpcSetEnv( aParamRpc[1], aParamRpc[2], aParamRpc[3], aParamRpc[4], aParamRpc[5], "TRSF020", aTables, , , ,  )
			
				u_TRSF024()
				
				RpcClearEnv()
				
			EndIf
			
		EndIf
		
	EndIf
		
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �F020Login � Autor � Jeferson Dambros      � Data � Jul/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Valida o login e senha no cadastro de senhas do Protheus   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � F020Login( cExp1,cExp2 )                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cExp1 - Usuario de Login do Protheus                       ���
���          � cExp2 - Senha do Login do Protheus                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � TRSF020                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function F020Login( cUser, cPass )

	Local lOK := .T. 
	
	
	PswOrder( 2 )//Indice de procura (Pelo nome)
	
	If	PswSeek( cUser )//Verifique se o nome do usuario existe
		
		If	!PswName( cPass )//Valida se a senha do respectivo usuario esta correta
	
			lOk := .F.
		
		EndIf
	
	Else

		lOk := .F.
	
	EndIf

Return( .T. )