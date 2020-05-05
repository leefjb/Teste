#include 'Totvs.ch'

#DEFINE SEPARADOR ";"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ JMHM010  ³ Autor ³ Giovanni              ³ Data ³24/09/2014³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exportacao do Cadastro de Produtos (SB1)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_JMHM010()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico JOMHEDICA                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JMHM010()

	Local oProcess
	Local cPerg         := PadR( "JMHM010", Len(SX1->X1_GRUPO) )
	Local cCadastro     := OemToAnsi("Exportação Cadastro de Produto")
	Local cDescRot      := ""
	Local cDir          := ""
	Local bProcess      := {||}
	Local aInfoCustom   := {}

	CriaSx1(cPerg)

	Pergunte(cPerg,.F.)
	
	cDescRot := " Esta rotina tem o objetivo de exportar o cadastro de produtos,"
	cDescRot += " a partir de um arquivo no formato texto (*.txt)."

	aAdd( aInfoCustom, { "Cancelar", { |oPanelCenter| oPanelCenter:oWnd:End() }, "CANCEL" })
	
	bProcess := {|oProcess| Executa(oProcess, AllTrim(MV_PAR02)) }
	
	oProcess := tNewProcess():New("JMHM010",cCadastro,bProcess,cDescRot,cPerg,aInfoCustom, .T.,5, "", .T. )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Executa   ³ Autor ³Giovanni Melo          ³ Data ³ 24/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Executa a validacao dos campos, antes do processamento        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³JMHM010                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Executa(oProcess, cDir)

	Local cMsg      := ""
	Local lOk       := .T.
	Local aButtons  := {"OK"}
	Local cTipoProd := Upper( AllTrim(MV_PAR01) )
	Local cCliIni   := Upper( MV_PAR03 )
	Local cLojaIni  := Upper( MV_PAR04 )
	Local cCliFin   := Upper( AllTrim(MV_PAR05) )
	Local cLojaFin  := Upper( AllTrim(MV_PAR06) )
	Local cNomeCli  := Upper( AllTrim(MV_PAR07) )
	Local cCidade   := Upper( AllTrim(MV_PAR08) )

	oProcess:SaveLog("Inicio da Execucao")

 	If Substr(cDir, Len(cDir),1)  !=  "\"

 	   	cMsg := "O diretorio informado está incorreto. " + CRLF
 	   	cMsg += "Utilizar '\' no final do diretorio." + CRLF + cDir
		lOk  := .F.
		Aviso( "Jmhm010|Executa", cMsg, aButtons, 1 )

		oProcess:SaveLog( cMsg )
    EndIf

	If lOk

		If ! File(cDir+".")

	 		cMsg := "O diretorio informado nao existe. " + CRLF + cDir
			lOk  := .F.
			Aviso( "Jmhm010|Executa", cMsg, aButtons, 1 )
			
			oProcess:SaveLog( cMsg )

	 	EndIf

 	EndIf

 	If lOk

		ListaCli(oProcess, cDir, cTipoProd, cCliIni, cLojaIni, cCliFin, cLojaFin, cNomeCli, cCidade)

	EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ListaCli  ³ Autor ³Giovanni Melo          ³ Data ³ 24/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Abre um ListBox contendo uma lista de clientes                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³JMHM010                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ListaCli(oProcess, cDir, cTipoProd, cCliIni, cLojaIni, cCliFin, cLojaFin, cNomeCli, cCidade)

	Local oListBox
	Local oDlg 
	Local oOk        := LoadBitmap( GetResources(), "LBOK" )
	Local oNo        := LoadBitmap( GetResources(), "LBNO" )	
	Local nAt        := 0
	Local nI         := 0
	Local nCol       := 0
	Local nColLst    := 0 	
	Local aListBox   := {}
	Local aClientes  := {}      
	Local bLinha     := {||} 	
	Local lMark      := .T.	
	Local lOk        := .F.

	DEFINE MSDIALOG oDlg TITLE "Exportar Produtos" FROM 000, 000 TO 500, 900 PIXEL
			 
		@ 003,005 BUTTON "Marc./Desm. Todos"	SIZE 060,010 ACTION ( MarcaTodos(@lMark, @aListBox), oListBox:Refresh() ) OF oDlg PIXEL		
		@ 003,065 BUTTON "Exportar Produtos"	SIZE 060,010 ACTION ( IIF( TudoOk(@aListBox),IIF( Iw_MSGBox("Confirma a exportação?","ATENCAO","YESNO"),(lOk:=.T.,oDlg:End()),Nil ), Alert("Nenhum cliente selecionado.") ) ) OF oDlg PIXEL
		@ 003,125 BUTTON "Cancelar"				SIZE 035,010 ACTION ( lOk:=.F.,oDlg:End()) OF oDlg PIXEL
				
		@ 015,000	LISTBOX oListBox;
					FIELDS HEADER "", "Cód. Cliente","Loja Cliente","Nome do Cliente", "CNPJ";
					SIZE 450,235 OF oDlg;       
					FIELDSIZES 010,060,040,150,040;
					PIXEL ON DbLCLICK ( lMark := Inverte( oListBox:nAt, @aListBox ), oListBox:Refresh() )                       
		
		aListBox := PesqCli(cCliIni, cLojaIni, cCliFin, cLojaFin, cNomeCli, cCidade)
		
		oListBox:SetArray( aListBox )
				
		
		bLinha := {|| { Iif( aListBox[oListBox:nAt,1], oOk, oNo ),;	//1	.T.
		                     aListBox[oListBox:nAt,2],;				//2	Cod. Cliente
		                     aListBox[oListBox:nAt,3],;				//3	Loja. Cliente
	                         aListBox[oListBox:nAt,4],;				//3	Nome Cliente 
	                         aListBox[oListBox:nAt,5] } }			//4	CNPJ		
		
		oListBox:bLine := @bLinha
								
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If lOk
			
		For nI := 1 To Len( aListBox )
			
			If aListBox[nI,1]// Marcado
				
				nColLst := 1
				aAdd(aClientes,{"","","",""})
				         
				For nCol := 1 To 4
					nColLst++  
					aClientes[Len(aClientes),nCol] := aListBox[nI,nColLst] 
				Next nCol
						
			EndIf
					
		Next nI
							
		Exporta(oProcess,aClientes,cTipoProd,cDir)
			
	EndIf	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³PesqCli   ³ Autor ³Giovanni Melo          ³ Data ³ 24/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna uma lista de clientes                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ListaCli                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PesqCli(cCliIni, cLojaIni, cCliFin, cLojaFin, cNomeCli, cCidade)

	Local cQuery    := ""
	Local aList     := {}
	Local cAliasTmp := GetNextAlias()
	
	cQuery := "SELECT A1_COD,"
	cQuery += "       A1_LOJA,"
	cQuery += "       A1_NOME,"
	cQuery += "       A1_CGC"
	cQuery += " FROM " + RetSqlName("SA1")
	cQuery += " WHERE A1_COD 	  >=  '" + cCliIni        + "' "
	cQuery += "   AND A1_COD 	  <=  '" + cCliFin        + "' "
	cQuery += "   AND A1_LOJA 	  >=  '" + cLojaIni       + "' "
	cQuery += "   AND A1_LOJA 	  <=  '" + cLojaFin       + "' "
	cQuery += "   AND A1_NOME 	LIKE '%" + cNomeCli       + "%' "
	cQuery += "   AND A1_MUN 	LIKE '%" + cCidade        + "%' "
	cQuery += "   AND A1_FILIAL   =  '"  + xFilial("SA1") + "' " 
	cQuery += "   AND A1_MSBLQL   <> '1'"		
	cQuery += "   AND D_E_L_E_T_  <> '*' "
	cQuery += " ORDER BY A1_COD ASC"
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T.,"TOPCONN",TcGenQry(,,cQuery), cAliasTmp,.F.,.T. )	
	
	While (cAliasTmp)->(! EoF())
			
		aAdd(aList, { .T.,;
					  (cAliasTmp)->A1_COD,;
					  (cAliasTmp)->A1_LOJA,;
					  AllTrim((cAliasTmp)->A1_NOME),;
					  AllTrim((cAliasTmp)->A1_CGC);
					  })
		
		dbSelectArea(cAliasTmp)
		(cAliasTmp)->(dbSkip())
		
	EndDo
	
	(cAliasTmp)->(dbCloseArea())

	If Len(aList) = 0 
		aAdd( aList, { .T.,"","","",""})								
	EndIf	
	
Return(aList)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Exporta   ³ Autor ³Giovanni Melo          ³ Data ³ 24/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Realiza o processo de exportacao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ListaCli                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Exporta(oProcess,aCli,cTipoProd, cDir)

	Local aGerar    := {}
	Local aButtons  := {"OK"}
	Local nReg      := 0
	Local nI        := 0
	Local cAliasTmp := GetNextAlias()
	Local cQuery    := ""
	Local cTxt      := ""
	Local cCodProd  := ""
	Local cDescProd := ""
	Local cCodCli   := ""
	Local cLojaCli  := ""
	Local cNomeCli  := ""
	Local cCnpj     := ""
	Local cTpFormat := FormatIn(cTipoProd,"/")	// formata para o 'IN' do SQL

	aGerar := GeraArq(oProcess, cDir)// Funcao para gerar o arquivo

	If aGerar[1]//Se arquivo foi gerado
		
		cQuery := " SELECT B1_COD, "
		cQuery += "        B1_DESC "
		cQuery += " FROM " + RetSqlName("SB1")
		cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
		cQuery += " 	AND B1_MSBLQL <> '1'"		
		If cTipoProd != ""
			cQuery += " AND B1_TIPO IN " + cTpFormat
		EndIf 	 
		
		cQuery += "     AND D_E_L_E_T_ <> '*' "
		cQuery += " ORDER BY B1_COD ASC "
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cAliasTmp, .F., .T. )

		Count to nReg
		
		oProcess:SetRegua1( Len(aCli) )

		For nI := 1 To Len(aCli)   
		
			oProcess:IncRegua1( "Cliente: " + Left(aCli[nI,3],35) ) 
		
			oProcess:SetRegua2( nReg )
		
			dbSelectArea(cAliasTmp)
			dbGoTop()
	
			While (cAliasTmp)->(!EoF())
			
				cCodProd  := AllTrim( (cAliasTmp)->B1_COD )
				cDescProd := AllTrim( (cAliasTmp)->B1_DESC )
				
				cCodCli  := aCli[nI,1]
				cLojaCli := aCli[nI,2]
				cNomeCli := aCli[nI,3]
				cCnpj    := aCli[nI,4]	
			
				cTxt := cCodProd  + SEPARADOR
				cTxt += cDescProd + SEPARADOR
				cTxt += cCodCli   + cLojaCli + SEPARADOR
				cTxt += cNomeCli  + SEPARADOR
				cTxt += cCnpj     + SEPARADOR
				cTxt += CRLF
			
				oProcess:IncRegua2( "Gravando... " + cCodProd )						

				FWrite( aGerar[3] , cTxt )
	
				dbSelectArea(cAliasTmp)		
				dbSkip()
			
			EndDo
		
		Next nI
					
		(cAliasTmp)->(dbCloseArea())

	EndIf

	If aGerar[1]
	
		FClose( aGerar[3] )// Fecha o arquivo texto

		If Empty( cTxt )
		
			cMsg := "Não há registros a serem gerados para o arquivo "+aGerar[2]
			Aviso( "Jmhm010|Exporta", cMsg, aButtons, 1 )
			
		Else
		
			cMsg := "Exportação realizada com sucesso para o destino "+aGerar[2]
			Aviso( "Jmhm010|Exporta", cMsg, aButtons, 1 )
			
		EndIf
		
	Else
		
		If ! File(cDir+".")
		
			cMsg := "Erro no Processamento da rotina."+CRLF
			cMsg += "Verificar Logs."
			Aviso( "Jmhm010|Exporta", cMsg, aButtons, 1 )
			
		EndIf
		
	EndIf

	oProcess:SaveLog( "Fim da Execucao" )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³GeraArq   ³ Autor ³Giovanni Melo          ³ Data ³ 24/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Executa a geracao do arquivo                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Exporta                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraArq(oProcess, cDir)

	Local cArqTxt := ""
	Local cMsg    := ""
	Local aRet    := {"","",0}
	Local aButtons:= {"OK"}
	Local nHandle := 0

	cArqTxt := AllTrim(cDir) + "produtos.txt"

	If File( cArqTxt )
		cMsg := "Arquivo já existe no diretório " + cArqTxt	
		Aviso( "Jmhm010|GeraArq", cMsg, aButtons, 1 )
		aRet[1] := .F.
		
		oProcess:SaveLog( cMsg )			
		Return(aRet)	
	Else
		aRet[1] := .T.	
	EndIf

	nHandle := FCreate( cArqTxt , 0 )
	If nHandle > 0
		aRet[1] := .T.
		aRet[2] := AllTrim( cArqTxt )
		aRet[3] := nHandle
	EndIf

Return(aRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Inverte   ³ Autor ³Giovanni Melo          ³ Data ³ 24/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Inverte a marcacao na listbox                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³JMHM010                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Inverte(nMarca, aListBox)

	aListBox[nMarca,1] := !aListBox[nMarca,1]
	
Return( aListBox[nMarca,1] )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MarcaTodos³ Autor ³Giovanni Melo          ³ Data ³ 24/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Marca e desmarca os itens da listbox.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³JMHM010                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MarcaTodos(lMark, aListBox)

	Local nI := 0
	
	For nI := 1 To Len(aListBox)
		aListBox[nI,1] := !lMark
	Next nI                     
	
	lMark := !lMark

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³TudoOk    ³ Autor ³Giovanni Melo          ³ Data ³ 24/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Verifica se foi selecionado pelo menos um item.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³JMHM010                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TudoOk(aListBox)

	Local lRet	:= .F.
	Local nI	:= 0
	
	For nI := 1 To Len(aListBox)
		If aListBox[nI,1]
		   lRet := .T.
		   Exit
		EndIf
	Next nI
	
	If lRet
		If Empty( aListBox[Len(aListBox),2] )
			lRet := .F.
		EndIf
	EndIf
	
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CriaSX1   ³ Autor ³Giovanni Melo          ³ Data ³ 24/09/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Criacao do grupo de perguntas                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³JMHM010                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CriaSX1(cPerg)

	Local aHelp1  := {}
	Local aHelp2  := {}
	Local aHelp3  := {}
	Local aHelp4  := {}
	Local aHelp5  := {}
	Local aHelp6  := {}
	Local aHelp7  := {}
	Local aHelp8  := {}

	AAdd(aHelp1, "Informar lista dos Tipos de Produtos a " )
	AAdd(aHelp1, "serem exportados. Utilizar '/' como sepa" )
	AAdd(aHelp1, "rador entre os tipos. Ex.: PA/ME" )
		                                             	
	AAdd(aHelp2, "Pasta onde será salvo o ")
	AAdd(aHelp2, "arquivo exportado" )
				  
	AAdd(aHelp3, "Cliente inicial" )
	
	AAdd(aHelp4, "Loja do cliente inicial" )

	AAdd(aHelp5, "Cliente final" )
	
	AAdd(aHelp6, "Loja do cliente final" )
	
	AAdd(aHelp7, "Nome do cliente" )
	
	AAdd(aHelp8, "Cidade do cliente" )


	//      Grupo	,cOrdem	,cPergunt         ,cPerSpa         ,cPerEng            ,cVar    	,cTipo	,nTamanho	,nDecimal	,nPresel	,cGSC   ,cValid         ,cF3    ,cGrpSxg    ,cPyme     ,cVar01      ,cDef01     ,cDefSpB1      ,cDefEng1    ,cCnt01	,cDef02     ,cDefSpa2,cDefEng2	,cDef03      ,cDefSpa3	,cDefEng3   ,cDef04 ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
	PutSx1( cPerg	,"01"  	,"Tipo Produtos"  ,"Tipo Produtos" ,"Tipo Produtos"    ,"mv_ch0" 	,"C"  	,60      	,0       	,1      	,"G" 	,""				,""		,""    		,""        ,"MV_PAR01"	,""		    ,""      	   ,""    	 ,""        ,""			,""      ,""      	,""          ,""     	,""    	    ,""     ,""      ,""      ,""    ,""      ,""      ,aHelp1 	,""      ,""      ,""   )
	PutSx1( cPerg	,"02"  	,"Pasta Destino"  ,"Pasta Destino" ,"Pasta Destino"    ,"mv_ch1" 	,"C"  	,60      	,0       	,1      	,"G" 	,"NAOVAZIO()"	,""		,""    		,""        ,"MV_PAR02"	,""		    ,""      	   ,""    	 ,""        ,""			,""      ,""      	,""          ,""     	,""    	    ,""     ,""      ,""      ,""    ,""      ,""      ,aHelp2 	,""      ,""      ,""   )
	PutSx1( cPerg	,"03"  	,"Cliente De"     ,"Cliente De"    ,"Cliente De"       ,"mv_ch2" 	,"C"  	,6      	,0       	,1      	,"G" 	,""   			,"SA1"	,""    		,""        ,"MV_PAR03"	,""		    ,""      	   ,""    	 ,""        ,""			,""      ,""      	,""          ,""     	,""    	    ,""     ,""      ,""      ,""    ,""      ,""      ,aHelp3 	,""      ,""      ,""   )
	PutSx1( cPerg	,"04"  	,"Loja De"        ,"Loja De"       ,"Loja De"          ,"mv_ch3" 	,"C"  	,2      	,0       	,1      	,"G" 	,""   			,""		,""    		,""        ,"MV_PAR04"	,""		    ,""      	   ,""    	 ,""        ,""			,""      ,""      	,""          ,""     	,""    	    ,""     ,""      ,""      ,""    ,""      ,""      ,aHelp4 	,""      ,""      ,""   )
	PutSx1( cPerg	,"05"  	,"Cliente Ate"    ,"Cliente Ate"   ,"Cliente Ate"      ,"mv_ch4" 	,"C"  	,6      	,0       	,1      	,"G" 	,""   			,"SA1"	,""    		,""        ,"MV_PAR05"	,""		    ,""      	   ,""    	 ,""        ,""			,""      ,""      	,""          ,""     	,""    	    ,""     ,""      ,""      ,""    ,""      ,""      ,aHelp5 	,""      ,""      ,""   )
	PutSx1( cPerg	,"06"  	,"Loja Ate"       ,"Loja Ate"      ,"Loja Ate"         ,"mv_ch5" 	,"C"  	,2      	,0       	,1      	,"G" 	,""   			,""		,""    		,""        ,"MV_PAR06"	,""		    ,""      	   ,""    	 ,""        ,""			,""      ,""      	,""          ,""     	,""    	    ,""     ,""      ,""      ,""    ,""      ,""      ,aHelp6	,""      ,""      ,""   )
	PutSx1( cPerg	,"07"  	,"Nome"           ,"Nome"          ,"Nome"             ,"mv_ch6" 	,"C"  	,60      	,0       	,1      	,"G" 	,""   			,""		,""    		,""        ,"MV_PAR07"	,""		    ,""      	   ,""    	 ,""        ,""			,""      ,""      	,""          ,""     	,""    	    ,""     ,""      ,""      ,""    ,""      ,""      ,aHelp7	,""      ,""      ,""   )
	PutSx1( cPerg	,"08"  	,"Cidade"         ,"Cidade"        ,"Cidade"           ,"mv_ch7" 	,"C"  	,40      	,0       	,1      	,"G" 	,""   			,""		,""    		,""        ,"MV_PAR08"	,""		    ,""      	   ,""    	 ,""        ,""			,""      ,""      	,""          ,""     	,""    	    ,""     ,""      ,""      ,""    ,""      ,""      ,aHelp8	,""      ,""      ,""   )
	
Return
