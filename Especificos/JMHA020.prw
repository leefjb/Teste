#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJMHA020    บAutor  ณAna Carolina        บ Data ณAug 22, 2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inventario por Coletor.                                     บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function JMHA020()

	Local aTables		:= {"SM0, SB1, SB7, SB8"}
	Local lLoop		    := .T.
	Local _lLogOk		:= .F.
	
	Private cUsu	 	:= "estoque" //Space(20)
	Private cSenhaUsu	:= "estoque" //Space(20)  
	Private oUsuario, oSenha

/*
	If	RpcSetEnv( "01" , "01" , , , "EST", , aTables , , , ,  )

		DbSelectArea("SM0")
		DbSetOrder(1)

		Do While (lLoop)
	
			DEFINE MSDIALOG oDlg1 TITLE "LOGIN - Inventario" FROM 000,000 TO 130,215 PIXEL 
			
				@ 005,005 SAY   "Usuario:" SIZE 080,008 of oDlg1 PIXEL  
				@ 012,005 MSGET oUsuario VAR cUsu  SIZE 060,010 of oDlg1 PIXEL VALID !Vazio()        
				
				@ 027,005 SAY   "Senha:"   SIZE 070,008 of oDlg1 PIXEL
				@ 034,005 MSGET oSenha VAR cSenhaUsu PASSWORD SIZE 060,010 of oDlg1 PIXEL VALID !Vazio()
						
				DEFINE SBUTTON FROM 052,050 TYPE 1 PIXEL ACTION (lLoop := .F., IIF(ValUsrPwd(cUsu, cSenhaUsu) , (A020Dados(),oDlg1:End()) , ) ) ENABLE OF oDlg1
				DEFINE SBUTTON FROM 052,080 TYPE 2 PIXEL ACTION ((lLoop := .F., oDlg1:End() )) ENABLE OF oDlg1
			
				//-- Desabilita a tecla ESC
			    oDlg1:lEscClose := .F.

			ACTIVATE MSDIALOG oDlg1 CENTERED
	
		EndDo
		RpcClearEnv()
		Sleep(8000)

		If	_lLogOk
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Com o Login confirmado Abro Novo Ambiente passando os Parametros de   ณ
			//ณ Usuario e Senha                                                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSeta o ambiente com a Empresa, Filial, Usuario, Senha, Modulo, Rotina, Tabelas                                    ณ
			//ณRpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect) --> lRet ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If	RpcSetEnv( "01" , "01" , cUsu , cSenhaUsu , "EST", , aTables , .F. , , ,  )
			
				DbSelectArea("SM0")
				DbSetOrder(1)
	
				A020Dados()
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณLimpa o ambiente, liberando a licenca e fechando as conexoesณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				RpcClearEnv()
			
			Else
				cMsg := "Falha na Conexใo!" + CRLF
				cMsg += "Empresa: 01" + CRLF
				cMsg += "Filial: 01" + CRLF
				cMsg += "Usuario: " + _cUsuario + CRLF
				Iw_MsgBox(cMsg,"JMHA020 | Falha na Conexใo!","ALERT")
			EndIf
	
		EndIf
		
	Else
		cMsg := "Falha na Conexใo!" + CRLF
		cMsg += "Empresa: 01" + CRLF
		cMsg += "Filial: 01" + CRLF
		Iw_MsgBox(cMsg,"JMHA020 | Falha na Conexใo!","ALERT")
	EndIf
*/  

//		If	_lLogOk
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Com o Login confirmado Abro Novo Ambiente passando os Parametros de   ณ
			//ณ Usuario e Senha                                                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSeta o ambiente com a Empresa, Filial, Usuario, Senha, Modulo, Rotina, Tabelas                                    ณ
			//ณRpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect) --> lRet ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If	RpcSetEnv( "01" , "01" , cUsu , cSenhaUsu , "EST", , aTables , .F. , , ,  )
			
				DbSelectArea("SM0")
				DbSetOrder(1)
	
				A020Dados()
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณLimpa o ambiente, liberando a licenca e fechando as conexoesณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				RpcClearEnv()
			
			Else
				cMsg := "Falha na Conexใo!" + CRLF
				cMsg += "Empresa: 01" + CRLF
				cMsg += "Filial: 01" + CRLF
				cMsg += "Usuario: " + _cUsuario + CRLF
				Iw_MsgBox(cMsg,"JMHA020 | Falha na Conexใo!","ALERT")
			EndIf
	
//		EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValUsrPwd บAutor  ณJeferson Dambros    บ Data ณ  Jul/2012   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o codigo do usuario e a senha de acordo              บฑฑ
ฑฑบ          ณcom o cadastro de senhas do Configurador.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/               
Static Function ValUsrPwd(_cUsuario,_cSenha) 

	Local _lOK := .T.
	
  	PswOrder(2)//Indice de procura
  	
  	If PswSeek( _cUsuario, .T. )//Verifique se o nome do usuario existe
		_lOK := .T.
	Else                                           
  		Iw_MsgBox("Usuario Invalido!","Usuario Invalido!","ALERT")
  		_lOK := .F.
	EndIf
		  
    If _lOk 
	   	If PswName(_cSenha)//Valida se a senha do respectivo usuario esta correta
    		_lOK := .T.
	    Else
    		Iw_MsgBox("Senha incorreta!","Senha incorreta!","ALERT")
	    	_lOK := .F.
		EndIf
	EndIf	
	
	//Informacoes do usuario logado
	aInfoUser := PswRet()

Return(_lOK) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA020Dados  บAutor  ณAna Carolina        บ Data ณAug 22, 2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de Informacoes de contagem.                            บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function A020Dados()

	Local oData, oDocumento, oLocal
	Local lLoop        := .T.
	Local lParam       := .T.
	Local cParam       := GetNewPar("ES_DOCINV", "I")

	Private nTamLocal  := TamSX3("B7_LOCAL")[01] 
	Private nTamProd   := TamSX3("B7_COD")[01]
	Private nTamLote   := TamSX3("B7_LOTECTL")[01]
	Private nTamDoc    := TamSX3("B7_DOC")[01]

	Private dData      := DATE()
	Private cDocumento := Space(TamSX3("B7_DOC")[01])
	Private cLocal     := Space(nTamLocal)

	cDocumento := PadR( VerifNro(), nTamDoc )

	If cParam = "S"
		lParam := .F.
	EndIf
	          
    

	Do While (lLoop)
		DEFINE MSDIALOG oDlg2 TITLE "DADOS - Inventario" FROM 000,000 TO 175,215 PIXEL
			
			@ 005,005 SAY   "Data Inventแrio:" SIZE 080,008 of oDlg2 COLOR CLR_BLUE PIXEL
			@ 012,005 MSGET oData VAR dData SIZE 040,010 of oDlg2 PIXEL VALID !Vazio()        
			
			@ 027,005 SAY   "Documento Inventแrio:"   SIZE 070,008 of oDlg2 COLOR CLR_BLUE PIXEL
			@ 034,005 MSGET oDocumento VAR cDocumento SIZE 050,010 of oDlg2 PIXEL WHEN lParam VALID !Vazio()
					
			@ 049,005 SAY   "Local:"   SIZE 070,008 of oDlg2 COLOR CLR_BLUE PIXEL
			@ 056,005 MSGET oLocal VAR cLocal SIZE 040,010 of oDlg2 PIXEL VALID !Vazio()
			
			DEFINE SBUTTON FROM 074,050 TYPE 1 PIXEL ACTION (lLoop := .F., A020Leitura(), oDlg2:End()) ENABLE OF oDlg2
			DEFINE SBUTTON FROM 074,080 TYPE 2 PIXEL ACTION ((lLoop := .F.,oDlg2:End()))   ENABLE OF oDlg2
		
			//-- Desabilita a tecla ESC
		    oDlg2:lEscClose := .F.
			oDocumento:SetFocus()
			
		ACTIVATE MSDIALOG oDlg2 CENTERED
	EndDo
    

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA020LeituraบAutor  ณAna Carolina        บ Data ณAug 22, 2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de Leitura do Coletor.                                 บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function A020Leitura()

	Local lLoop := .T.
	
	Private oCodBar, oCodProd, oDesProd, oLocPadrao, oLote, oDatValid, oQtd
	
	Private nTamCodBar 	:= 100//55
	Private cCodBar		:= Space(nTamCodBar)
	Private cCodProd		:= ""//Space(TamSX3("B7_COD")[01])
	Private cDesProd		:= ""//Space(TamSX3("B1_DESC")[01])
	Private cLocPadrao	:= ""//
	Private cLote			:= ""//Space(TamSX3("B7_LOTECTL")[01])
	Private cDatValid		:= ""//Space(TamSX3("B7_DTVALID")[01])
	Private nQtd			:= 0
	Private oDlg3
	
	Private lErro        := .F.
	
	Do While (lLoop)
		DEFINE MSDIALOG oDlg3 TITLE "LEITURA - Inventario" FROM 000,000 TO 300,215 PIXEL 
			
			@ 005,005 SAY   "C๓digo Barras:" SIZE 080,008 of oDlg3 COLOR CLR_BLUE PIXEL
			//@ 012,005 MSGET oCodBar VAR cCodBar VALID (MostraDados(), MDados2()) SIZE 090,010 of oDlg3 PIXEL 
			@ 012,005 MSGET oCodBar VAR cCodBar VALID (MostraDados()) SIZE 090,010 of oDlg3 PIXEL
			
			@ 030,005 SAY   "C๓d. Produto:"   SIZE 070,008 of oDlg3 PIXEL
			@ 037,005 MSGET oCodProd VAR cCodProd SIZE 080,010 of oDlg3 PIXEL WHEN .F.
						
			@ 050,005 SAY   "Descricao:"   SIZE 070,008 of oDlg3 PIXEL
			@ 057,005 MSGET oDesProd VAR cDesProd SIZE 100,010 of oDlg3 PIXEL WHEN .F.
				
			@ 070,005 SAY   "Local Padrใo:"   SIZE 070,008 of oDlg3 PIXEL
			@ 077,005 MSGET oLocPadrao VAR cLocPadrao SIZE 040,010 of oDlg3 PIXEL WHEN .F.
				
			@ 090,005 SAY   "Lote:"   SIZE 070,008 of oDlg3 PIXEL
			@ 097,005 MSGET oLote VAR cLote SIZE 100,010 of oDlg3 PIXEL WHEN .F.
				
			@ 110,005 SAY   "Validade:"   SIZE 070,008 of oDlg3 PIXEL 
			@ 117,005 MSGET oDatValid VAR cDatValid SIZE 035,010 of oDlg3 PIXEL WHEN .F.

			@ 110,050 SAY   "Quantidade:"   SIZE 070,008 of oDlg3 PIXEL
			@ 117,050 MSGET oQtd VAR nQtd SIZE 030,010 of oDlg3 PIXEL WHEN .F.
			
			//@ 135 , 080 BUTTON oBtnOK PROMPT "Ok" SIZE 30,12 ACTION (IIF(MSGYESNO( "Finalizar leitura?", "LEITURA"), (lLoop:=.F., oDlg3:End()), lLoop:=.T.))OF oDlg3 PIXEL
			DEFINE SBUTTON FROM 135,080 TYPE 1 PIXEL ACTION (IIF(!lErro .and. MSGYESNO( "Finalizar leitura?", "LEITURA"), (lLoop:=.F., oDlg3:End()), lLoop:=.T.)) ENABLE OF oDlg3
			
			//-- Desabilita a tecla ESC
		    oDlg3:lEscClose := .F.

		ACTIVATE MSDIALOG oDlg3 CENTERED
	EndDo
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERIFNRO   บAutor  ณAna Carolina        บ Data ณAug 22, 2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para verificacao do parametro ES_DOCINV onde I - Infoบฑฑ
ฑฑบ          ณrmado e S - Sequencial.                                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VerifNro()
	
	Local cParam     := GetNewPar("ES_DOCINV", "I")
	
	dbSelectArea("SB7")
	dbSetOrder(4)      

	If cParam = "S"
		cParam := GETSX8NUM("SB7", "B7_DOC")
	ElseIf cParam = "I" .or. cParam = ""
		cParam := Space(nTamDoc)
	Else
		//Erro
		Iw_MsgBox("Parametro Invแlido!","Parametro com erro","ALERT")
	Endif 

Return (cParam)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMostraDadosบAutor  ณAna Carolina        บ Data ณAug 22, 2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para que os dados aparecam na tela para confirmacao  บฑฑ
ฑฑบ          ณenquanto se esta fazendo a leitura do codigo de barras.      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MostraDados()
	
	Local cProd     := SubStr(cCodBar, 1, 15)
	Local cNroLote  := SubStr(cCodBar, 16, 10)
	Local cDataVenc := SubStr(cCodBar, 26, 8)
	//Local cLoteForn := SubStr(cCodBar, 34)
	Local cTitulo   := ""
	Local cInfo     := ""
	Local lRet      := .F.

	lErro := .F.
	cLote := ""
		
	If (Empty(cCodBar))
		//Erro
		cTitulo := "C๓digo em Branco."
		cInfo := cTitulo+"!"+CRLF+"Cod.Bar.:"+cCodBar
		Iw_MsgBox(cInfo, cTitulo, "ALERT")
		lRet := .T.
	Else
		DbSelectArea("SB1")
		DbSetOrder(1)
		lSeek := dbSeek(xFilial("SB1")+Padr(cProd,nTamProd))
		If lSeek
			//cDatValid := DTOC(STOD(cDataVenc))
			cDatValid := SubStr(cDataVenc, 7,2) + "/" + SubStr(cDataVenc, 5,2) + "/" + SubStr(cDataVenc, 1,4)
			cCodProd:= cProd
			cDesProd := SB1->B1_DESC
			cLocPadrao := SB1->B1_LOCPAD
			cLote := cNroLote 
		Else
			//Erro
			cTitulo := "Produto invแlido"
			cInfo := cTitulo+"!"+CRLF+"Prod.:"+cProd
			Iw_MsgBox(cInfo, cTitulo, "ALERT")
			lErro := .T.
		EndIf
		SB1->(dbCloseArea())
		
		If (!lErro)
			DbSelectArea("SB2")
			DbSetOrder(1)
			If !(dbSeek(xFilial("SB2")+Padr(cProd,nTamProd)+Padr(cLocal,nTamLocal)))
				//Erro
				cTitulo:= "Armaz้m invแlido"
				cInfo := cTitulo+"!"+CRLF+"Local:"+cLocal
				Iw_MsgBox(cInfo, cTitulo, "ALERT")
				lErro := .T.
			EndIf
			SB2->(dbCloseArea())
		EndIf
		
		If (!lErro)
			nRecSB7 := 0
			DbSelectArea("SB8")
			DbSetOrder(3) //Produto + Local + Lote + SubLote + Data Validade
			If dbSeek(xFilial("SB8")+Padr(cCodProd,nTamProd)+Padr(cLocal,nTamLocal)+Padr(cLote,nTamLote))

				aRetSB7 := ConsSB7( Padr(cDocumento,nTamDoc), Padr(cCodProd,nTamProd), Padr(cLocal,nTamLocal), Padr(cLote,nTamLote), dData )

				If	aRetSB7[1] //Altera o registro

					nQtd := aRetSB7[2]+1
					GravarSB7( 4, aRetSB7[3], Padr(cDocumento,nTamDoc), Padr(cCodProd,nTamProd), Padr(cLocal,nTamLocal), Padr(cLote,nTamLote), dData )

				Else			//Inclui o registro

					nQtd := 1
					GravarSB7( 3, aRetSB7[3], Padr(cDocumento,nTamDoc), Padr(cCodProd,nTamProd), Padr(cLocal,nTamLocal), Padr(cLote,nTamLote), dData )

				EndIf

			Else
				//Erro
				cTitulo:= "Lote invแlido"
				cInfo:= cTitulo+"!"+CRLF+"Lote:"+cNroLote
				Iw_MsgBox(cInfo, cTitulo, "ALERT")
				lErro := .T.
			EndIf
		EndIf
		
		If (lErro)
			cCodProd		:= ""
			cDesProd		:= ""
			cLocPadrao		:= ""
			cLote			:= ""
			cDatValid		:= ""
			nQtd			:= 0
		EndIf
		
		LimpaCampos()
		
	EndIf

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravarSB7  บAutor  ณAna Carolina        บ Data ณAug 22, 2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para gravar os dados recebidos via coletor na tabela บฑฑ
ฑฑบ          ณSB7 via MSEXECAUTO do MATA270.                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GravarSB7( nOpc, nRecSB7, cDoc, cProd, cLocal, cLoteCtl, dData  )
	
	Local aCampos := {}
	Private lMsErroAuto := .F.

	dbSelectArea("SB7")

	If (nOpc == 3)

		aAdd(aCampos, 	{"B7_COD",		 cProd   ,NIL})
	   	aAdd(aCampos, 	{"B7_LOCAL",	 cLocal  ,NIL})
	   	aAdd(aCampos, 	{"B7_DOC",		 cDoc    ,NIL})
	   	aAdd(aCampos, 	{"B7_QUANT",	 1       ,NIL}) 
	   	aAdd(aCampos, 	{"B7_DATA",	 dData   ,NIL})
	   	aAdd(aCampos, 	{"B7_LOTECTL", cLoteCtl,NIL})
	   	aAdd(aCampos, 	{"B7_DTVALID", dData   ,NIL})
	   	aAdd(aCampos, 	{"B7_USUARIO", cUsu    ,NIL})

		MSExecAuto({|x,y,z| mata270(x,y,z)},aCampos,.F.,nOpc)
		
	   	If lMsErroAuto
			MostraErro() 
		EndIf   		

	Else

		//Faco o update do registro quando encontrado 
		cQuery := " UPDATE " + RetSQLName("SB7")
		cQuery += " SET    B7_QUANT   =  '" + Str(nQtd)      + "' " 
		cQuery += " WHERE  B7_FILIAL  =  '" + xFilial("SB7") + "' "
		cQuery += "   AND  B7_DATA    =  '" + DTOS(dData)    + "' "
		cQuery += "   AND  B7_COD     =  '" + cProd          + "' "
		cQuery += "   AND  B7_LOCAL   =  '" + cLocal         + "' "
		cQuery += "   AND  B7_LOCALIZ =  '' "
		cQuery += "   AND  B7_NUMSERI =  '' "
		cQuery += "   AND  B7_LOTECTL =  '" + cLoteCtl       + "' "
		cQuery += "   AND  B7_NUMLOTE =  '' "
		cQuery += "   AND  B7_CONTAGE =  '' "
		cQuery += "   AND  B7_DOC     =  '" + cDoc           + "' "
		cQuery += "   AND  D_E_L_E_T_ <> '*' "
		
		MemoWrite("\_Aux\jmha020sb7.sql",cQuery)
		TcSqlExec (cQuery)
		
	EndIf
	   	
Return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLimpaCamposบAutor  ณAna Carolina        บ Data ณSep 16, 2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualizar as informacoes da tela e limpar o get de leitura  บฑฑ
ฑฑบ          ณ(oCodBar)                                                    บฑฑ
ฑฑบ          ณ Obs.: Durante testes com o leitor verificou-se que o Leitor บฑฑ 
ฑฑบ          |necessita de 2 espacos alem da leitura (tam. da leitura + 2) บฑฑ 
ฑฑบ          ณpois sem isso ocorrem problemas no valid (foco do campo).    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function LimpaCampos()
	
	ObjectMethod(oCodProd, "Refresh()")
	ObjectMethod(oDesProd, "Refresh()")
	ObjectMethod(oLocPadrao, "Refresh()")
	ObjectMethod(oLote, "Refresh()")
	ObjectMethod(oDatValid, "Refresh()")
	ObjectMethod(oQtd, "Refresh()")
		
	cCodBar := Space(nTamCodBar)

	ObjectMethod(oCodBar, "Refresh()")
	ObjectMethod(oDlg3, "Refresh()")
	oCodBar:SetFocus()

Return 


Static Function ConsSB7( cDoc, cProd, cLocal, cLoteCtl, dData )

	Local aRet := { .F., 0, 0 }

	//Verifico se o documento no inventario ja existe
	cQuery := " SELECT B7_QUANT, R_E_C_N_O_ AS B7_RECNO "
	cQuery += " FROM   " + RetSQLName("SB7")
	cQuery += " WHERE  B7_FILIAL  =  '" + xFilial("SB7") + "' "
	cQuery += "   AND  B7_DATA    =  '" + DTOS(dData)    + "' "
	cQuery += "   AND  B7_COD     =  '" + cProd          + "' "
	cQuery += "   AND  B7_LOCAL   =  '" + cLocal         + "' "
	cQuery += "   AND  B7_LOCALIZ =  '' "
	cQuery += "   AND  B7_NUMSERI =  '' "
	cQuery += "   AND  B7_LOTECTL =  '" + cLoteCtl       + "' "
	cQuery += "   AND  B7_NUMLOTE =  '' "
	cQuery += "   AND  B7_CONTAGE =  '' "
	cQuery += "   AND  B7_DOC     =  '" + cDoc           + "' "
	cQuery += "   AND  D_E_L_E_T_ <> '*' "
	
	MemoWrite("\_Aux\jmha020sb7.sql",cQuery)
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "TB1", .F., .T.)
	
	If	TB1->( !EOF() )

		aRet := { .T., TB1->B7_QUANT, TB1->B7_RECNO }

	EndIf
	
	TB1->(dbCloseArea())

Return( aRet )
