#include "protheus.ch"
#include "Fileio.ch"

// Layout CSV
#DEFINE SEPARADOR ";"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ JMHA020  ³ Autor ³ Leandro Marquardt     ³ Data ³ 26/09/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importacao de contagem de produtos em poder de terceiros   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Jomhedica                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/ 
User Function JMHM020()

Private cCadastro := "Importacao de Contagem de Produtos em Poder de Terceiros"
Private aRotina   := MenuDef()

mBrowse(6,1,22,75,"SZD",,,,,,)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef   ºAutor  ³Leandro Marquardt   º Data ³  26/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de Menu do MBrowse                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MenuDef()

Local aRotina := {{ OemToAnsi("Pesquisar")  ,"AxPesqui"       ,0 ,1 },;
					{ OemToAnsi("Visualizar")  ,"AxVisual"       ,0 ,2 },;
					{ OemToAnsi("Importar")    ,"U_Process()"    ,0 ,3 }}

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Process   ºAutor  ³Leandro Marquardt   º Data ³  02/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que gera a barra de progressao                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Process()

Processa( {|| ImportaCont() }, "Aguarde", "Carregando...",.F.)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImportaContºAutor  ³Leandro Marquardt   º Data ³  26/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que faz a importacao das contagens de produtos        º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImportaCont()

Local cString  := "SZD"
Local cPerg    := PadR("JMHM020",Len(SX1->X1_GRUPO),"")
Local cCaminho := ""
Local cLinha   := ""
Local aCampos  := {}
Local aDados   := {}
Local nPos     := 0
Local cLoja    := ""
Local cCli     := ""
Local cCliLoj  := ""
Local aArq     := {}
Local nCont    := 0
Local cAlert   := ""
Local nHandle  := ""
Local lOk      := .F.
Local aHelp    := {"Arquivo que será importado"}
Local aBtn     := {"OK"}
Local cArq     := ""

Private cDestino   := ""
Private cInfo      := ""
Private aLog       := {}
Private aLogPro    := {}
Private aLogCli    := {}
Private aLogLayout := {}
Private aLogQtd    := {}
Private nCnt       := 0

PutSX1(cPerg,;
	       "01",;
	       "Arquivo Origem","Arquivo Origem","Arquivo Origem",;
	       "mv_ch0",;
	       "C",;
	       60,;
	       00,;
	       1,;
	       "G",;
	       "",;
	       "DIR",;
	       "",;
	       "",;
	       "MV_PAR01",;
	       "","","",;
	       "",;
	       "","","",;
	       "","","",;
	       "","","",;
	       "","","",;
	       aHelp,,,;
	       "")

dbSelectArea(cString)
dbSetOrder(1)

If Pergunte(cPerg)

	cCaminho := MV_PAR01
	
	If Right(Upper(AllTrim(cCaminho)),3) <> "TXT" .Or. !File(cCaminho)

		cAlert := "Verifique o formato do arquivo, ou arquivo inexistente." + CRLF
		cAlert += "O arquivo precisa ser do tipo TXT!"

		Aviso("Atenção",cAlert,aBtn,1)
    
	Else
	
		cDestino := Substr(AllTrim(cCaminho),1,Len(AllTrim(cCaminho))-4)
		
		aArq := DIRECTORY(cCaminho, "D")
		nPosFin := Len(aArq[1][1]) - 4
		cArq := Substr(aArq[1][1],1,nPosFin) // Retorna o nome do arquivo
		
		FT_FUSE(cCaminho)
			
		ProcRegua(FT_FLASTREC())
		
		FT_FGOTOP()
	
		While !FT_FEOF()
			
			IncProc("Lendo Arquivo...")
			 
			cLinha := AllTrim( FT_FREADLN() ) 
			aCampos := StrToKArr(cLinha,SEPARADOR)			

			If Len(aCampos) != 4 // Verifica se layout esta fora do padrao
				aAdd(aLogLayout,cLinha)				
			Else
				aAdd(aDados,{AllTrim(aCampos[1]),aCampos[2],aCampos[3],aCampos[4]})
			EndIf			
			
			FT_FSKIP()
		EndDo
		
		ProcRegua(Len(aDados))
		
		dbSelectArea(cString)
		dbSetOrder(1)
		
		cDoc := GETSX8NUM("SZD","ZD_DOC")						
		
		For nCont :=1 To Len(aDados)
			
			IncProc("Importando Dados...")
			
			If Len(aDados[nCont,1]) > 8
				aAdd(aLogCli,aDados[nCont])
			Else
				nPos    := Len(aDados[nCont,1]) - 1
				cLoja   := Substr(aDados[nCont,1],nPos) // Retorna apenas a loja
				cCliLoj := PadL(aDados[nCont,1],8,"0")
				cCli    := Substr(cCliLoj,1,6) // Retorna apenas o cliente
				cProd	 := AllTrim(CValToChar(aDados[nCont,2]))
				nQtd    := Val(aDados[nCont,4])
							
				dbSelectArea("SA1")
				dbSetOrder(1)				
				If dbSeek( xFilial("SA1") + cCli + cLoja )										
					If Type(aDados[nCont,4]) != "N" .Or. Val(aDados[nCont,4]) == 0 // Quantidade diferente de numero ou igual a 0
						aAdd(aLogQtd,aDados[nCont])
					Else
						dbSelectArea("SB1")
						dbSetOrder(1)			
						If !DbSeek(xFilial("SB1") + PadR(cProd,TamSX3("B1_COD")[01]))
							aAdd(aLogPro,aDados[nCont]) 
						Else
							lOk := .T.
							aAdd(aLog,aDados[nCont])
							
							Reclock(cString,.T.)
									
							SZD->ZD_FILIAL  := xFilial("SZD") 
							SZD->ZD_DOC  	  := cDoc			
							SZD->ZD_CLIENTE := cCli
							SZD->ZD_LOJA	  := cLoja			
							SZD->ZD_PRODUTO := aDados[nCont,2]
							SZD->ZD_LOTECTL := aDados[nCont,3]
							SZD->ZD_QTDE    := Val(aDados[nCont,4])
							SZD->ZD_DTAIMP  := MsDate()
													
							SZD->(MsUnlock())									
						EndIf // If dbSeek Produto
					EndIf // If Type	
				Else
					aAdd(aLogCli,aDados[nCont])
				EndIf // If dbSeek Cli+Loja								
			EndIf // If Cli+Loja > 8				
			
		Next nCont
		
		If lOk
			ConfirmSX8()
		Else
			RollbackSX8()
		EndIf
		
		FT_FUSE()
	
		GravaLog()
		
		If Empty(nCnt)
			Aviso("Sucesso",cInfo,aBtn,1)			
		Else
			cAlert += "Existem dados inconsistentes, " + CRLF
			cAlert += "Consultar registro de log " + cDestino + ".log"
			Aviso("Atenção",cInfo + CRLF + cAlert,aBtn,1)
		EndIf		
	EndIf //Right
EndIf // If Pergunte

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImportaContºAutor  ³Leandro Marquardt   º Data ³  29/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de gravacao de arquivo de log                         º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GravaLog()
Local nHandle := "" 

nHandle := FCreate(cDestino +".log")
			
If nHandle = -1   
	
	Aviso("Atenção","Erro ao criar arquivo - Erro: " + Str(Ferror()),aBtn,1)
Else
	If Len(aLog) >= 1
		cInfo := "Documento "+ cDoc +" importado com sucesso!" + CRLF
	EndIf		
	
	If Len(aLogLayout) >= 1
		For nCont := 1 to Len(aLogLayout)
			nCnt += 1
			FWrite(nHandle, aLogLayout[nCont] + " - Layout fora do padrão" + CRLF)										 
		Next nCont
				
	EndIf
	If Len(aLogPro) >= 1
		For nCont := 1 To Len(aLogPro)
			nCnt += 1
			FWrite(nHandle, aLogPro[nCont][1]+ SEPARADOR +;
					    	  aLogPro[nCont][2]+ SEPARADOR +;
					    	  aLogPro[nCont][3]+ SEPARADOR +;
					    	  aLogPro[nCont][4] + " - Produto não existe" + CRLF)
		Next nCont		
	EndIf
	If Len(aLogCli) >= 1
		For nCont := 1 to Len(aLogCli)
			nCnt += 1
			FWrite(nHandle, aLogCli[nCont][1]+ SEPARADOR +;
					    	  aLogCli[nCont][2]+ SEPARADOR +;
					    	  aLogCli[nCont][3]+ SEPARADOR +;
					    	  aLogCli[nCont][4] + " - Cliente+Loja não existe" + CRLF) 
		Next nCont		
	EndIf
	If Len(aLogQtd) >= 1	
		For nCont := 1 to Len(aLogQtd)
			nCnt += 1
			If aLogQtd[nCont,4] != "0"
				FWrite(nHandle, aLogQtd[nCont][1]+ SEPARADOR +;
						    	  aLogQtd[nCont][2]+ SEPARADOR +;
						    	  aLogQtd[nCont][3]+ SEPARADOR +;
						    	  aLogQtd[nCont][4] + " - Quantidade inválida" + CRLF)
			EndIf
		Next nCont
	EndIf

FClose(nHandle)

EndIf

If nCnt == 0
	FErase(cDestino +".log")
EndIf

Return