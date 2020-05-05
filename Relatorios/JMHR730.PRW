#INCLUDE "JMHR730.CH"
#Include "protheus.ch"
#include "sigawin.ch"

#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR730  ³ Autor ³ Eduardo José Zanardo  ³ Data ³ 26.12.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±               
±±³Descricao ³Emissao da Pre-Nota                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Palavras Chave                                                         ³±±
±±³Pre-Nota - prenota - pre nota                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³22/09/2006³ Marllon       ³Imprime numero do Lote/Validade             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user Function JMHR730()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea   := GetArea()
Local Titulo  := OemToAnsi(STR0001) //"Emissao da Confirmacao do Pedido"
Local cDesc1  := OemToAnsi(STR0002) //"Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
Local cDesc2  := OemToAnsi(STR0003) //"intervalo informado na op‡„o Parƒmetros."
Local cDesc3  := " "
Local cString := "SC5"  // Alias utilizado na Filtragem
Local lDic    := .F. // Habilita/Desabilita Dicionario
Local lComp   := .F. // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .F. // Habilita/Desabilita o Filtro
Local wnrel   := "JMHR730" // Nome do Arquivo utilizado no Spool
Local nomeprog:= "JMHR730"
Local cPerg   := PadR("JHR730",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

Private Tamanho := "G" // P/M/G
Private Limite  := 220 // 80/132/220
Private aOrdem  := {}  // Ordem do Relatorio
Private aReturn := { STR0004, 1,STR0005, 2, 2, 1, "",0 } //"Zebrado"###"Administracao"
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Incluido as perguntas no dicionario do advanced              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX1")
DbSetOrder(1)
IF !DbSeek(cPerg)
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg                ,;
	X1_ORDEM   With "01"                    ,;
	X1_PERGUNT With "Do Pedido ?"           ,;
	X1_VARIAVL With "mv_ch1"                ,;
	X1_TIPO    With "C"                     ,;
	X1_TAMANHO With 6                       ,;
	X1_VAR01   With "MV_PAR01"              ,;
	X1_GSC     With "G"
	MsUnlock()
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg                ,;
	X1_ORDEM   With "02"                    ,;
	X1_PERGUNT With "Ate o Pedido ?"        ,;
	X1_VARIAVL With "mv_ch2"                ,;
	X1_TIPO    With "C"                     ,;
	X1_TAMANHO With 6                       ,;
	X1_VAR01   With "MV_PAR02"              ,;
	X1_GSC     With "G"
	MsUnlock()
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg                ,;
	X1_ORDEM   With "03"                    ,;
	X1_PERGUNT With "Imprime na Nota? "     ,;
	X1_VARIAVL With "mv_ch3"                ,;
	X1_TIPO    With "N"                     ,;
	X1_TAMANHO With 1                       ,;
	X1_VAR01   With "MV_PAR03"              ,;
	X1_GSC     With "C"                     ,;
	X1_Def01   With "Sim"                   ,;
	X1_Def02   With "Não"                   ,;
	X1_Def03   With "Ambos"
	MsUnlock()
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg                ,;
	X1_ORDEM   With "04"                    ,;
	X1_PERGUNT With "Somente Liberados ?"   ,;
	X1_VARIAVL With "mv_ch4"                ,;
	X1_TIPO    With "N"                     ,;
	X1_TAMANHO With 1                       ,;
	X1_VAR01   With "MV_PAR04"              ,;
	X1_GSC     With "C"                     ,;
	X1_Def01   With "Sim"                   ,;
	X1_Def02   With "Não"
	MsUnlock()
	RecLock("SX1",.T.)
EndIf
IF !DbSeek(cPerg+'05')
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg                ,;
	X1_ORDEM   With "05"                    ,;
	X1_PERGUNT With "Loja de ?"             ,;
	X1_VARIAVL With "mv_ch5"                ,;
	X1_TIPO    With "C"                     ,;
	X1_TAMANHO With 2                       ,;
	X1_VAR01   With "MV_PAR05"              ,;
	X1_GSC     With "G"
	MsUnlock()
	RecLock("SX1",.T.)
	Replace X1_GRUPO   With cPerg                ,;
	X1_ORDEM   With "06"                    ,;
	X1_PERGUNT With "Loja ate ?"            ,;
	X1_VARIAVL With "mv_ch6"                ,;
	X1_TIPO    With "C"                     ,;
	X1_TAMANHO With 2                       ,;
	X1_VAR01   With "MV_PAR06"              ,;
	X1_GSC     With "G"
	MsUnlock()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	lFiltro := .F.
#ENDIF	

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	RestArea(aArea)
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	RestArea(aArea)
	Return
Endif

RptStatus({|lEnd| C730Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

RestArea(aArea)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ C730Imp   ³ Autor ³ Eduardo J. Zanardo   ³ Data ³26.12.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle de Fluxo do Relatorio.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C730Imp(lEnd,wnrel,cString,nomeprog,Titulo)

Local aPedCli    := {}    
Local aStruSC5   := {}
Local aStruSC6   := {}
Local aC5Rodape  := {}                          
Local aRelImp    := MaFisRelImp("MT100",{"SF2","SD2"})

Local li         := 100 // Contador de Linhas
Local lImp       := .F. // Indica se algo foi impresso
Local lRodape    := .F.

Local cbCont     := 0   // Numero de Registros Processados
Local cbText     := ""  // Mensagem do Rodape
Local cKey 	     := ""
Local cFilter    := ""
Local cAliasSC5  := "SC5"
Local cAliasSC6  := "SC6"
Local cIndex     := CriaTrab(nil,.f.) 
Local cQuery     := ""
Local cQryAd     := ""     
Local cName      := ""
Local cPedido    := ""
Local cCliEnt	 := ""
Local cNfOri     := Nil
Local cSeriOri   := Nil

Local nItem      := 0 
Local nTotQtd    := 0
Local nTotVal    := 0
Local nDesconto  := 0
Local nPesLiq    := 0
Local nSC5       := 0
Local nSC6       := 0 
Local nX         := 0
Local nRecnoSD1  := Nil

#IFDEF TOP
	If TcSrvType() <> "AS/400"
	    cAliasSC5:= "C730Imp"
	    cAliasSC6:= "C730Imp"
		lQuery    := .T.
		aStruSC5  := SC5->(dbStruct())		
		aStruSC6  := SC6->(dbStruct())		
		cQuery := "SELECT SC5.R_E_C_N_O_ SC5REC,SC6.R_E_C_N_O_ SC6REC,"
		cQuery += "SC5.C5_FILIAL,SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_TIPO,"
		cQuery += "SC5.C5_TIPOCLI,SC5.C5_TRANSP,SC5.C5_PBRUTO,SC5.C5_PESOL,SC5.C5_DESC1,"
		cQuery += "SC5.C5_DESC2,SC5.C5_DESC3,SC5.C5_DESC4,SC5.C5_MENNOTA,SC5.C5_ANOTA,SC5.C5_EMISSAO,"
		cQuery += "SC5.C5_CONDPAG,SC5.C5_FRETE,SC5.C5_DESPESA,SC5.C5_FRETAUT,SC5.C5_TPFRETE,SC5.C5_SEGURO,SC5.C5_TABELA,"
		cQuery += "SC5.C5_VOLUME1,SC5.C5_ESPECI1,SC5.C5_MOEDA,SC5.C5_REAJUST,SC5.C5_BANCO,"
		cQuery += "SC5.C5_ACRSFIN,SC5.C5_VEND1,SC5.C5_VEND2,SC5.C5_VEND3,SC5.C5_VEND4,SC5.C5_VEND5,"
		cQuery += "SC5.C5_COMIS1,SC5.C5_COMIS2,SC5.C5_COMIS3,SC5.C5_COMIS4,SC5.C5_COMIS5,SC5.C5_CLIVALE,SC5.C5_PACIENT,SC5.C5_CRM,SC5.C5_CRMNOM,"
		cQuery += "SC5.C5_CONVENI, SC5.C5_DESCCON, SC5.C5_HORA, SC5.C5_TPDESC, SC5.C5_DESCOM, SC5.C5_DTCIRUG, "
		If SC5->(FieldPos("C5_CLIENT"))>0
			cQuery += "SC5.C5_CLIENT,"			
		Endif

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Esta rotina foi escrita para adicionar no select os campos         ³
        //³usados no filtro do usuario quando houver, a rotina acrecenta      ³
        //³somente os campos que forem adicionados ao filtro testando         ³
        //³se os mesmo já existem no select ou se forem definidos novamente   ³
        //³pelo o usuario no filtro                                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   	
        If !Empty(aReturn[7])
		   For nX := 1 To SC5->(FCount())
		 	  cName := SC5->(FieldName(nX))
		 	  If AllTrim( cName ) $ aReturn[7]
	      		  If aStruSC5[nX,2] <> "M"  
	      		    If !cName $ cQuery .And. !cName $ cQryAd
		        	  cQryAd += cName +","
		            Endif 	
		       	  EndIf
			  EndIf 			       	
		   Next nX
        Endif    
        cQuery += cQryAd		
		cQuery += "SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_PEDCLI,SC6.C6_PRODUTO,"
		cQuery += "SC6.C6_TES,SC6.C6_QTDVEN,SC6.C6_PRUNIT,SC6.C6_VALDESC,"
		cQuery += "SC6.C6_VALOR,SC6.C6_ITEM,SC6.C6_DESCRI,SC6.C6_UM, "
		cQuery += "SC6.C6_PRCVEN,SC6.C6_NOTA,SC6.C6_SERIE,SC6.C6_CLI,"
		cQuery += "SC6.C6_LOJA,SC6.C6_ENTREG,SC6.C6_DESCONT,SC6.C6_LOCAL,"
//		If	FieldPos("C6_ENVSEP") > 0
			cQuery += "SC6.C6_QTDEMP,SC6.C6_QTDLIB,SC6.C6_QTDENT,SC6.C6_NFORI,SC6.C6_SERIORI,SC6.C6_ITEMORI, SC6.C6_LOTECTL, SC6.C6_DTVALID, SC6.C6_ENVSEP, SC6.C6_TIPFAT "
//		Else
//			cQuery += "SC6.C6_QTDEMP,SC6.C6_QTDLIB,SC6.C6_QTDENT,SC6.C6_NFORI,SC6.C6_SERIORI,SC6.C6_ITEMORI, SC6.C6_LOTECTL, SC6.C6_DTVALID, SC6.C6_TIPFAT "
//		EndIf
		cQuery += "FROM "
		cQuery += RetSqlName("SC5") + " SC5 ,"
		cQuery += RetSqlName("SC6") + " SC6 "		
		cQuery += "WHERE "
		cQuery += "SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND "		
		cQuery += "SC5.C5_NUM >= '"+mv_par01+"' AND " 
		cQuery += "SC5.C5_NUM <= '"+mv_par02+"' AND " 
		cQuery += "SC5.C5_LOJACLI >= '"+mv_par05+"' AND " 
		cQuery += "SC5.C5_LOJACLI <= '"+mv_par06+"' AND " 
		cQuery += "SC5.D_E_L_E_T_ = ' ' AND "
		cQuery += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "		 
		cQuery += "SC6.C6_NUM   = SC5.C5_NUM AND "
		// testa campo C6_IMPNF
		If MV_PAR03 = 1
			cQuery += "SC6.C6_IMPNF = '1' AND "
		EndIf
		// separo somente os itens com liberacao
		If MV_PAR04 = 1
			cQuery += "SC6.C6_QTDEMP > 0 AND "
		EndIf
		cQuery += "SC6.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY SC5.C5_NUM"

		cQuery := ChangeQuery(cQuery)
    	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC5,.T.,.T.)

		For nSC5 := 1 To Len(aStruSC5)
			If aStruSC5[nSC5][2] <> "C" .and.  FieldPos(aStruSC5[nSC5][1]) > 0
				TcSetField(cAliasSC5,aStruSC5[nSC5][1],aStruSC5[nSC5][2],aStruSC5[nSC5][3],aStruSC5[nSC5][4])
			EndIf
		Next nSC5
	    For nSC6 := 1 To Len(aStruSC6) 
			If aStruSC6[nSC6][2] <> "C" .and. FieldPos(aStruSC6[nSC6][1]) > 0
		    	TcSetField(cAliasSC6,aStruSC6[nSC6][1],aStruSC6[nSC6][2],aStruSC6[nSC6][3],aStruSC6[nSC6][4])
			EndIf
		Next nSC6		    	
	Else
#ENDIF	 
		cAliasSC5 := cString
		dbSelectArea(cAliasSC5)
		cKey := IndexKey()	
		cFilter := dbFilter()
		cFilter += If( Empty( cFilter ),""," .And. " )
		cFilter += 'C5_FILIAL == "'+xFilial("SC5")+'" .And. (C5_NUM >= "'+mv_par01+'" .And. C5_NUM <= "'+mv_par02+'")'
		IndRegua(cAliasSC5,cIndex,cKey,,cFilter,STR0006)		//"Selecionando Registros..."
		#IFNDEF TOP
			DbSetIndex(cIndex+OrdBagExt())
		#ENDIF                           
		SetRegua(RecCount())		// Total de Elementos da regua
		DbGoTop()
#IFDEF TOP
	Endif
#ENDIF	

While !((cAliasSC5)->(Eof())) .and. xFilial("SC5")==(cAliasSC5)->C5_FILIAL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a validacao dos filtros do usuario           	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasSC5)
lFiltro := IIf((!Empty(aReturn[7]).And.!&(aReturn[7])),.F.,.T.)

If lFiltro
	
	cCliEnt   := IIf(!Empty((cAliasSC5)->(FieldGet(FieldPos("C5_CLIENT")))),(cAliasSC5)->C5_CLIENT,(cAliasSC5)->C5_CLIENTE)
	
	MaFisIni(cCliEnt,;							// 1-Codigo Cliente/Fornecedor
	(cAliasSC5)->C5_LOJACLI,;			// 2-Loja do Cliente/Fornecedor
	If(SC5->C5_TIPO$'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
		(cAliasSC5)->C5_TIPO,;				// 4-Tipo da NF
		(cAliasSC5)->C5_TIPOCLI,;			// 5-Tipo do Cliente/Fornecedor
		aRelImp,;							// 6-Relacao de Impostos que suportados no arquivo
		,;						   			// 7-Tipo de complemento
		,;									// 8-Permite Incluir Impostos no Rodape .T./.F.
		"SB1",;							// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
		"MATA461")							// 10-Nome da rotina que esta utilizando a funcao
		
		nTotQtd:=0
		nTotVal:=0
		nPesBru:=0
		nPesLiq:=0
		aPedCli:= {}
		If !lQuery
			dbSelectArea(cAliasSC6)
			dbSetOrder(1)
			dbSeek(xFilial("SC6")+(cAliasSC5)->C5_NUM)
		EndIf
		cPedido    := (cAliasSC5)->C5_NUM
		aC5Rodape  := {}
		aadd(aC5Rodape,{(cAliasSC5)->C5_PBRUTO,(cAliasSC5)->C5_PESOL,(cAliasSC5)->C5_DESC1,(cAliasSC5)->C5_DESC2,;
		(cAliasSC5)->C5_DESC3,(cAliasSC5)->C5_DESC4,(cAliasSC5)->C5_MENNOTA,(cAliasSC5)->C5_ANOTA})
		
		aPedCli := Mtr730Cli(cPedido)
		
		While !((cAliasSC6)->(Eof())) .And. xFilial("SC6")==(cAliasSC6)->C6_FILIAL .And.;
			(cAliasSC6)->C6_NUM == cPedido
			
			cNfOri     := Nil
			cSeriOri   := Nil
			nRecnoSD1  := Nil
			nDesconto  := 0
			
			If !Empty((cAliasSC6)->C6_NFORI)
				dbSelectArea("SD1")
				dbSetOrder(1)
				dbSeek(xFilial("SC6")+(cAliasSC6)->C6_NFORI+(cAliasSC6)->C6_SERIORI+(cAliasSC6)->C6_CLI+(cAliasSC6)->C6_LOJA+;
				(cAliasSC6)->C6_PRODUTO+(cAliasSC6)->C6_ITEMORI)
				cNfOri     := (cAliasSC6)->C6_NFORI
				cSeriOri   := (cAliasSC6)->C6_SERIORI
				nRecnoSD1  := SD1->(RECNO())
			EndIf
			
			dbSelectArea(cAliasSC6)
			
			If lEnd
				@ Prow()+1,001 PSAY STR0007 //"CANCELADO PELO OPERADOR"
				Exit
			EndIf   

			If ((cAliasSC6)->C6_PRCVEN <> (cAliasSC6)->C6_PRUNIT .And. (cAliasSC6)->C6_PRUNIT<> 0 ) .Or. (cAliasSC6)->C6_VALDESC > 0
				nDesconto := (a410Arred((cAliasSC6)->C6_PRUNIT*(cAliasSC6)->C6_QTDVEN,"D2_DESCON")-(cAliasSC6)->C6_VALOR)
				nDesconto := If(nDesconto==0,(cAliasSC6)->C6_VALDESC,nDesconto)				
			Endif	
			
			MaFisAdd((cAliasSC6)->C6_PRODUTO,; 	  // 1-Codigo do Produto ( Obrigatorio )
					(cAliasSC6)->C6_TES,;			  // 2-Codigo do TES ( Opcional )
					1 ,; //(cAliasSC6)->C6_QTDVEN,;		  // 3-Quantidade ( Obrigatorio )
					(cAliasSC6)->C6_PRUNIT,;		  // 4-Preco Unitario ( Obrigatorio )
					nDesconto,;       // 5-Valor do Desconto ( Opcional )
					cNfOri,;		                  // 6-Numero da NF Original ( Devolucao/Benef )
					cSeriOri,;		                  // 7-Serie da NF Original ( Devolucao/Benef )
					nRecnoSD1,;			          // 8-RecNo da NF Original no arq SD1/SD2
					0,;							  // 9-Valor do Frete do Item ( Opcional )
					0,;							  // 10-Valor da Despesa do item ( Opcional )
					0,;            				  // 11-Valor do Seguro do item ( Opcional )
					0,;							  // 12-Valor do Frete Autonomo ( Opcional )
					((cAliasSC6)->C6_VALOR+nDesconto),;// 13-Valor da Mercadoria ( Obrigatorio )
					0,;							  // 14-Valor da Embalagem ( Opiconal )
					0,;		     				  // 15-RecNo do SB1
					0) 							  // 16-RecNo do SF4
					  
			nItem += 1
			IF li > 45
				IF lRodape
					ImpRodape(nPesLiq,nTotQtd,nTotVal,@li,nPesBru,aC5Rodape,cAliasSC5,,cAliasSC6)
				Endif
				li := 0
				lRodape := ImpCabec(@li,aPedCli,cAliasSC5)
			Endif
			ImpItem(nItem,@nPesLiq,@li,@nTotQtd,@nTotVal,@nPesBru,cAliasSC6,cAliasSC5)
			If !lQuery
				dbSelectArea(cAliasSC6)
			EndIf
			
			MaFisAlt("NF_FRETE"   ,(cAliasSC5)->C5_FRETE)
			MaFisAlt("NF_SEGURO"  ,(cAliasSC5)->C5_SEGURO)
			MaFisAlt("NF_AUTONOMO",(cAliasSC5)->C5_FRETAUT)
			MaFisAlt("NF_DESPESA" ,(cAliasSC5)->C5_DESPESA)
					
			(cAliasSC6)->(dbSkip())
			li++
		EndDo

		nItem := 0
		IF lRodape
			ImpRodape(nPesLiq,nTotQtd,nTotVal,@li,nPesBru,aC5Rodape,cAliasSC5,.T.,cAliasSC6)
			lRodape:=.F.
		Endif
		
		MaFisEnd()
		
		If !lQuery
			IncRegua()
			dbSelectArea(cAliasSC5)
			dbSkip()
		Endif
		
	Else
		dbSelectArea(cAliasSC5)
		dbSkip()
	EndIf

EndDo 

If lQuery   
    dbSelectArea(cAliasSC5)
	dbCloseArea()
Endif	

Set Device To Screen
Set Printer To

RetIndex("SC5")   
dbSelectArea("SC5")
dbClearFilter()

Ferase(cIndex+OrdBagExt())

dbSelectArea("SC6")
dbClearFilter()
dbSetOrder(1)
dbGotop()

If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpItem  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpItem(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpItem(nItem,nPesLiq,li,nTotQtd,nTotVal,nPesBru,cAliasSC6,cAliasSC5)

Local aTipFat  := u_RetX3Box( 'C6_TIPFAT' )
//Local aEnvSep  := IIf(FieldPos('C6_ENVSEP') > 0,u_RetX3Box( 'C6_ENVSEP' ),'')
Local aEnvSep  := u_RetX3Box( 'C6_ENVSEP' )
Local nUltLib  := 0
Local cChaveD2 := ""
Local nDecs	:=	MsDecimais(Max(1,(cAliasSC5)->C5_MOEDA))
Local nValImp	:=0
dbSelectArea("SB1")
dbSeek(xFilial("SB1")+(cAliasSC6)->C6_PRODUTO)
 
	//cHeader:="It Tp. Faturam.                       Codigo          Desc. do Material             TES UM   Quant.  Valor Unit.   IPI   ICM   ISS   Vl.Tot.C/IPI     Entrega   "
	// 			99 9 - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxXXXXXXXXXXXX 999 XX 99999.99 9,999,999.99 99,99 99,99 99,99   999,999,999.99 99/99/9999 9.9  999999999.999999999.999999999,99
	// 			0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15
	//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

@li,000 psay (cAliasSC6)->C6_ITEM
//@li,003 psay (cAliasSC6)->C6_TIPFAT
//If	FieldPos("C6_ENVSEP") > 0
	@li,003 psay (cAliasSC6)->C6_ENVSEP
	@li,005 psay '-'
//	@li,007 psay SubStr(u_X3CBoxDes( (cAliasSC6)->C6_TIPFAT, aTipFat ),1,30)
	@li,007 psay SubStr(u_X3CBoxDes( (cAliasSC6)->C6_ENVSEP, aEnvSep ),1,03)
//EndIf
@li,038 psay (cAliasSC6)->C6_PRODUTO
@li,054 psay SUBS(IIF(Empty((cAliasSC6)->C6_DESCRI),SB1->B1_DESC,(cAliasSC6)->C6_DESCRI),1,30)
@li,084 psay (cAliasSC6)->C6_TES
@li,088 psay (cAliasSC6)->C6_UM
@li,091 psay (cAliasSC6)->C6_QTDVEN	Picture "@e 99999.99" //PesqPict("SC6","C6_QTDVEN",10)
@li,100 psay (cAliasSC6)->C6_PRCVEN	Picture "@e 9,999,999.99" //PesqPict("SC6","C6_PRCVEN",12)
If cPaisLoc == "BRA"
	nValImp	:=	MaFisRet(nItem,"IT_VALIPI")
	@li,113 psay MaFisRet(nItem,"IT_ALIQIPI") Picture "@e 99.99"
Else             
	nValImp	:=	MaRetIncIV(nItem,"2")
	@li,113 psay  nValImp	Picture Tm(nValImp,10,nDecs)
Endif

If ( cPaisLoc=="BRA" )
	@li,119 psay MaFisRet(nItem,"IT_ALIQICM") Picture "@e 99.99" //Aliq de ICMS
	@li,125 psay SB1->B1_ALIQISS	Picture "@e 99.99"    //Aliq de ISS
EndIf

cChaveD2 := xFilial("SD2")+(cAliasSC6)->C6_NOTA+(cAliasSC6)->C6_SERIE+(cAliasSC6)->C6_CLI+(cAliasSC6)->C6_LOJA+(cAliasSC6)->C6_PRODUTO
dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(cChaveD2)
While !Eof() .and. cChaveD2 = xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
	nUltLib := D2_QUANT
	dbSkip()
EndDo

@li,133   psay (cAliasSC6)->C6_VALOR+nValImp Picture PesqPict("SC6","C6_VALOR",14,nDecs)
@li,148   psay (cAliasSC6)->C6_ENTREG

//@li,122   psay (cAliasSC6)->C6_DESCONT    Picture "99.9"
//@li,128   psay (cAliasSC6)->C6_LOCAL
//@li,130   psay (cAliasSC6)->C6_QTDEMP Picture PesqPict("SC6","C6_QTDLIB",10)
//@li,140   psay (cAliasSC6)->C6_QTDVEN - (cAliasSC6)->C6_QTDEMP + (cAliasSC6)->C6_QTDLIB - (cAliasSC6)->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)
//@li,150   psay nUltLib Picture PesqPict("SD2","D2_QUANT",10)


nTotQtd += (cAliasSC6)->C6_QTDVEN                           
nTotVal += (cAliasSC6)->C6_VALOR+nValImp
nPesLiq	+= SB1->B1_PESO * (cAliasSC6)->C6_QTDVEN
nPesBru += SB1->B1_PESBRU * (cAliasSC6)->C6_QTDVEN
//li++
//@li,019 psay 'Lote: ' + SubStr((cAliasSC6)->(C6_LOTECTL),5,6) + '  Validade: ' + Dtoc((cAliasSC6)->(C6_DTVALID))

cChaveC9 := xFilial("SC9")+(cAliasSC6)->(C6_NUM)+(cAliasSC6)->(C6_ITEM)
dbSelectArea("SC9")
dbSetOrder(1)
dbSeek(cChaveC9)
Do While !Eof() .and. cChaveC9 == SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM
	If Empty(SC9->C9_NFISCAL)
		SB8->( dbSeek(xFilial('SB8')+SC9->C9_PRODUTO+SC9->C9_LOCAL+Dtos(SC9->C9_DTVALID)+SC9->C9_LOTECTL) )
		li++
		@li,019 psay 'Lote: ' + SC9->C9_LOTECTL  +'Forn: ' + SB8->B8_LOTEFOR  +'  Validade: ' + Dtoc(SC9->C9_DTVALID) + ' Quant: ' + Str(SC9->C9_QTDLIB, 12,2)
	EndIf
	dbSkip()
EndDo
Return (Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpRoadpe(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape(nPesLiq,nTotQtd,nTotVal,li,nPesBru,aC5Rodape,cAliasSC5,lFinal,cAliasSC6)
Local aImps	:=	{} 
Local cMens := ""
DEFAULT lFinal := .F.

@ li,000 psay Replicate("-",limite-60)
li++
@ li,000 psay STR0029	//" T O T A I S "
@ li,056 psay nTotQtd    Picture PesqPict("SC6","C6_QTDVEN",10)
If ( cPaisLoc=="BRA" )
	@ li,094 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
Else
	@ li,088 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
EndIf

If lFinal
	li++                                                                            
	@ li,000 psay Replicate("-",limite-60)                                         
	If cPaisLoc == 'BRA'
		li++                                                                            
		@ li,000 psay STR0038
		@ li,026 PSay STR0039
		@ li,046 PSay STR0040
		@ li,067 PSay STR0041
		@ li,087 PSay STR0042
		@ li,107 PSay STR0043
		@ li,128 PSay STR0044
		@ li,149 PSay STR0045	
		li++
		@ li,022 PSay Transform(MaFisRet(,"NF_BASEICM"),"@E 99,999,999.99")
		@ li,042 PSay Transform(MaFisRet(,"NF_VALICM"),"@E 99,999,999.99")
	    @ li,062 PSay Transform(MaFisRet(,"NF_BASEIPI"),"@E 99,999,999.99")
	    @ li,083 PSay Transform(MaFisRet(,"NF_VALIPI"),"@E 99,999,999.99") 
		@ li,105 PSay Transform(MaFisRet(,"NF_BASESOL"),"@E 99,999,999.99")
		@ li,127 PSay Transform(MaFisRet(,"NF_VALSOL"),"@E 99,999,999.99")
		@ li,147 PSay Transform(MaFisRet(,"NF_TOTAL"),"@E 99,999,999.99")              	
		li++                                                                            	
		@ li,026 psay STR0046
		@ li,046 PSay STR0047
		li++                                                                            		
		@ li,022 PSay Transform(MaFisRet(,"NF_BASEISS"),"@E 99,999,999.99")
		@ li,042 PSay Transform(MaFisRet(,"NF_VALISS"),"@E 99,999,999.99")
	Else 
		aCodImps := MaFisRet(,"NF_IMPOSTOS") //Descricao / /Aliquota / Valor / Base
		li++
		@ li,000 psay STR0038
		@ li,025 PSay STR0049 //"Imposto                                 Base      Aliquota         Valor"
		li++         			
		@ li,025 PSay           "------------------------------ ------------- ------------- -------------"
		li++
		For I:=1 To Len(aCodImps)// Vetor com os impostos
		   	@ li,25 PSay aCodImps[I][2] 
			@ li,57 PSay aCodImps[I][3] Picture TM(aCodImps[I][4],12,MsDecimais(1))
			@ li,71 PSay aCodImps[I][4] Picture TM(aCodImps[I][4],12,MsDecimais(1))
			@ li,85 PSay aCodImps[I][5] Picture TM(aCodImps[I][4],12,MsDecimais(1))
            li++
		Next
		
	Endif                     
Endif	

@ 51,005 psay STR0030+STR(If(aC5Rodape[1][1] > 0,aC5Rodape[1][1],nPesBru))	//"PESO BRUTO ------>"
@ 52,005 psay STR0031+STR(If(aC5Rodape[1][2] > 0,aC5Rodape[1][2] ,nPesLiq))	//"PESO LIQUIDO ---->"
@ 53,005 psay STR0032	//"VOLUMES --------->"
@ 54,005 psay STR0033	//"SEPARADO POR ---->"
@ 55,005 psay STR0034	//"CONFERIDO POR --->"
@ 56,005 psay STR0035	//"D A T A --------->"

@ 58,000 psay STR0036	//"DESCONTOS: "
@ 58,011 psay aC5Rodape[1][3] Picture "99.99"
@ 58,019 psay aC5Rodape[1][4] picture "99.99"
@ 58,027 psay aC5Rodape[1][5] picture "99.99"
@ 58,035 psay aC5Rodape[1][6] picture "99.99"

@ 60,000 psay STR0037+AllTrim(aC5Rodape[1][7])			//"MENSAGEM PARA NOTA FISCAL: "
cmens:=aC5Rodape[1][8]
// ALTERAÇAO pendente falta testar Eliane 18/01/05.
@ 62,000 psay Replicate("-",160)
@ 63,000 psay "MENSAGEM DO PEDIDO: " 
@ 63,PCOL() psay SUBSTR(cmens,1,123)
@ 64,020 psay SUBSTR(cmens,101,123)
//@ 64,020 psay SUBSTR(cmens,201,100)
@ 65,000 psay "" 

li := 80

Return( NIL )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec(li,aPedCli,cAliasSC5)

Local cHeader	:= ""
Local nPed		:= 0
Local i         := 0 
Local cMoeda	:= ""
Local cCampo    := ""
Local cComis    := ""
Local cPedCli   := ""
Local cPictCgc  := ""
If cPaisLoc == "BRA"
	//cHeader := STR0008	//"It Codigo          Desc. do Material TES UM   Quant.  Valor Unit. IPI   ICM   ISS   Vl.Tot.C/IPI Entrega   Desc Loc.Qtd.a Fat     Saldo  Ult.Fat."
//	cHeader := "It Tp. Faturam.                       Codigo          Desc. do Material             TES UM   Quant.  Valor Unit.   IPI   ICM   ISS     Vl.Tot.C/IPI  Entrega   "
	cHeader := "It Separa ?                           Codigo          Desc. do Material             TES UM   Quant.  Valor Unit.   IPI   ICM   ISS     Vl.Tot.C/IPI  Entrega   "
	// 			99 9 - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999 XX99999.99999,999,999.9999,99 99,9999,99 999,999,999.99 99/99/9999 9.9  999999999.999999999.999999999,99
	// 			0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
	//          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
Else
	cHeader := STR0048	//"It Codigo          Desc. do Material TES UM   Quant.  Valor Unit. IPI   ICM   ISS   Vl.Tot.C/IPI Entrega   Desc Loc.Qtd.a Fat     Saldo  Ult.Fat."
	//          				99 xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxx 999 XX99999.99999,999,999.9999,99 99,9999,99 999,999,999.99 99/99/9999 9.9  999999999.999999999.999999999,99
	//          				0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
	//                      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registro no cliente do pedido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF !((cAliasSC5)->C5_TIPO$"DB")
	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+(cAliasSC5)->C5_CLIENTE+(cAliasSC5)->C5_LOJACLI)
    cPictCgc := PesqPict("SA1","A1_CGC")	
Else
	dbSelectArea("SA2")
	dbSeek(xFilial("SA2")+(cAliasSC5)->C5_CLIENTE+(cAliasSC5)->C5_LOJACLI)
    cPictCgc := PesqPict("SA2","A2_CGC")	
Endif

dbSelectArea("SA4")
dbSetOrder(1)
dbSeek(xFilial("SA4")+(cAliasSC5)->C5_TRANSP)
dbSelectArea("SE4") 
dbSetOrder(1)
dbSeek(xFilial("SE4")+(cAliasSC5)->C5_CONDPAG)

aSort(aPedCli)
@ 00,000 psay AvalImp(limite)
@ 01,000 psay Replicate("-",limite-60)
@ 02,000 psay SM0->M0_NOME
IF !((cAliasSC5)->C5_TIPO$"DB")
	@ 02,041 psay "| "+Left(SA1->A1_COD+"/"+SA1->A1_LOJA+" "+SA1->A1_NOME, 56)
	@ 02,110 psay STR0009		//"| CONFIRMACAO DO PEDIDO "
	@ 03,000 psay Substr(SM0->M0_ENDCOB,1,40)
	@ 03,041 psay "| "+IF( !Empty(SA1->A1_ENDENT) .And. SA1->A1_ENDENT # SA1->A1_END,SA1->A1_ENDENT, SA1->A1_END )
	@ 03,110 psay "|" 
	@ 03,112 psay "HORA: "
	@ 03,121 psay (cAliasSC5)->C5_HORA   //TIME()
	@ 04,000 psay STR0010+SM0->M0_TEL			//"TEL: "
	@ 04,041 psay "| "
	@ 04,043 psay IF( !Empty(SA1->A1_CEPE) .And. SA1->A1_CEPE # SA1->A1_CEP, SA1->A1_CEPE, SA1->A1_CEP )
	@ 04,053 psay IF( !Empty(SA1->A1_MUNE) .And. SA1->A1_MUNE # SA1->A1_MUN, Alltrim(SA1->A1_MUNE), Alltrim(SA1->A1_MUN) )
	@ 04,077 psay IF( !Empty(SA1->A1_ESTE) .And. SA1->A1_ESTE # SA1->A1_EST, Alltrim(SA1->A1_ESTE), Alltrim(SA1->A1_EST) )
	@ 04,110 psay STR0011		//"| EMISSAO: "
	@ 04,121 psay (cAliasSC5)->C5_EMISSAO
	@ 05,000 psay Iif(cPaisLoc=="BRA",STR0012,Alltrim(Posicione('SX3',2,'A1_CGC','SX3->X3_TITULO'))+":")		//"CGC: "
	@ 05,006 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 psay "|"
    @ 05,043 psay 'CGC: '+Transform(SA1->A1_CGC, '@ER 99.999.999/9999-99')+'  -  IE: '+SA1->A1_INSCR
	@ 05,110 psay STR0014+(cAliasSC5)->C5_NUM			//"| PEDIDO N. "
	@ 06,041 psay "|"
    @ 06,043 psay 'TEL: ('+SA1->A1_DDD+') '+SA1->A1_TEL
	@ 07,041 psay "|"
    @ 07,043 psay 'e-mail: '+SA1->A1_EMAIL
Else
	@ 02,041 psay "| "+SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME
	@ 02,110 psay STR0009	//"| CONFIRMACAO DO PEDIDO "
	@ 03,000 psay SM0->M0_ENDCOB
	@ 03,041 psay "| "+ SA2->A2_END
	@ 03,110 psay "|"
	@ 04,000 psay STR0010+SM0->M0_TEL			//"TEL: "
	@ 04,041 psay "| "+SA2->A2_CEP
	@ 04,053 psay Alltrim(SA2->A2_MUN)
	@ 04,077 psay SA2->A2_EST
	@ 04,110 psay STR0011		//"| EMISSAO: "
	@ 04,121 psay (cAliasSC5)->C5_EMISSAO
	@ 05,000 psay Iif(cPaisLoc=="BRA",STR0012,Alltrim(Posicione('SX3',2,'A1_CGC','SX3->X3_TITULO'))+":")		//"CGC: "
	@ 05,006 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 psay "|"
    @ 05,043 psay SA2->A2_EMAIL
	@ 05,100 psay STR0014+(cAliasSC5)->C5_NUM			//"| PEDIDO N. "
Endif
li := 8
If Len(aPedCli) > 0
	@ li,000 psay Replicate("-",limite-60)
	li++
	@ li,000 psay "PEDIDO(S) DO CLIENTE:"
	cPedCli:=""
	For nPed := 1 To Len(aPedCli)
		cPedCli += aPedCli[nPed]+Space(02)
		If Len(cPedCli) > 100 .or. nPed == Len(aPedCli)
			@ li,23 psay cPedCli
			cPedCli:=""
			li++
		Endif
	Next
Endif
@ li,000 psay Replicate("-",limite-60)
li++
@ li,000 psay STR0016+(cAliasSC5)->C5_TRANSP+" - "+SA4->A4_NOME			//"TRANSP...: "
@ li,065 psay "PACIENTE: " +Substr((cAliasSC5)->C5_PACIENT,1,24)
@ li,100 psay "CLIENTE VALE: " +(cAliasSC5)->C5_CLIVALE
li++

For i := 1 to 5
	cCampo := "C5_VEND" + Str(i,1,0)
	cComis := "C5_COMIS" + Str(i,1,0)
	
	dbSelectArea("SA3")
	dbSetOrder(1)
	If dbSeek(xFilial("SA3")+(cAliasSC5)->(FieldGet(FieldPos(cCampo))))
		If i == 1
			@ li,000 psay STR0017		//"VENDEDOR.: "
		EndIf
		@ li,013 psay (cAliasSC5)->(FieldGet(FieldPos(cCampo))) + " - "+SA3->A3_NOME
		If i == 1
			@ li,065 psay STR0018		//"COMISSAO: "
		EndIf
		@ li,075 psay (cAliasSC5)->(FieldGet(FieldPos(cComis))) Picture "99.99" 
		li++
	EndIf	
Next
                               
@ li,000 psay STR0019+(cAliasSC5)->C5_CONDPAG+" - "+SE4->E4_DESCRI			//"COND.PGTO: "
@ li,065 psay STR0020		//"FRETE...: "
@ li,075 psay (cAliasSC5)->C5_FRETE  Picture "@EZ 999,999,999.99"
If (cAliasSC5)->C5_FRETE > 0
	@ li,090 psay IIF((cAliasSC5)->C5_TPFRETE="C","(CIF)","(FOB)")
Endif
//@ li,100 psay STR0021		//"SEGURO: "
//@ li,108 psay (cAliasSC5)->C5_SEGURO Picture "@EZ 999,999,999.99"
@ li,100 psay "CIRURGIA:"
@ li,110 psay (cAliasSC5)->C5_DTCIRUG Picture "@EZ 999,999,999.99"
li++
@ li,000 psay STR0022+(cAliasSC5)->C5_TABELA		//"TABELA...: "
@ li,065 psay STR0023		//"VOLUMES.: "
@ li,075 psay (cAliasSC5)->C5_VOLUME1    Picture "@EZ 999,999"
@ li,100 psay STR0024+(cAliasSC5)->C5_ESPECI1		//"ESPECIE: "
li++
cMoeda:=Strzero((cAliasSC5)->C5_MOEDA,1,0)
@ li,000 psay STR0025+(cAliasSC5)->C5_REAJUST+STR0026 +IIF(cMoeda < "2","1",cMoeda)		//"REAJUSTE.: "###"   Moeda : "
@ li,065 psay STR0027 + (cAliasSC5)->C5_BANCO					//"BANCO: "
@ li,100 psay STR0028+Str((cAliasSC5)->C5_ACRSFIN,6,2)		//"ACRES.FIN.: "
li++
@ li,000 psay "CRM " +(cAliasSC5)->C5_CRM  +" - "+(cAliasSC5)->C5_CRMNOM
@ li,065 psay "CONVENIO:" +(cAliasSC5)->C5_CONVENI + " - " + (cAliasSC5)->C5_DESCCON
If (cAliasSC5)->C5_TPDESC=='1'   //%
	@ li,100 psay "DESC.COMER:" + Str((cAliasSC5)->C5_DESCOM,5,2) + ' %'
Else
	@ li,100 psay "DESC.COMER:" + ' R$ ' + Str((cAliasSC5)->C5_DESCOM,10,2)
EndIf
li++
@ li,000 psay Replicate("-",limite-60)
li++
@ li,000 psay cHeader
li++
@ li,000 psay Replicate("-",limite-60)
li++

Return( .T. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Mtr730Cli ³ Autor ³ Henry Fila            ³ Data ³ 26.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Função que retorna os pedidos do cliente                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Mtr730Cli(cPedido)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Numero do pedido                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Mtr730Cli(cPedido)

Local aPedidos := {}
Local aArea    := GetArea()
Local aAreaSC6 := SC6->(GetArea())

SC6->(dbSetOrder(1))
SC6->(MsSeek(xFilial("SC6")+cPedido))

While !(SC6->(Eof())) .And. xFilial("SC6")==SC6->C6_FILIAL .And.;
	SC6->C6_NUM == cPedido                                                    
	
	If !Empty(SC6->C6_PEDCLI) .and. Ascan(aPedidos,SC6->C6_PEDCLI) = 0
		Aadd(aPedidos, SC6->C6_PEDCLI )
	Endif		

	SC6->(dbSkip())                                   
Enddo              

RestArea(aAreaSC6)
RestArea(aArea)

Return(aPedidos)


/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Original  ³RetX3Box  ³ Autor ³ Eduardo Motta         ³ Data ³ 12.12.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³RetX3Box  ³ Autor ³ Expedito Mendonca Jr  ³ Data ³ 27.07.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna array da ComboBox                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cCampo - Nome do Campo                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User FUNCTION RetX3Box(cCampo)

LOCAL aRET:={},nCONT
LOCAL cCBox,cTmp
LOCAL aSvArea := SX3->(GetArea())
  
SX3->(DbSetOrder(2))
SX3->(DbSeek(cCampo))
cCBox := SX3->(X3Cbox())
     
BEGIN SEQUENCE 
    While !Empty(cCBOX)
       nCONT:=AT(";",cCBOX)
        IF nCont == 0
	       cTmp := SubStr(AllTrim(cCBOX),1)
           AADD(aRET,{Left(cTmp,1),Substr(cTmp,3)})
           Exit
        Else
           cTmp := SubStr(AllTrim(SUBSTR(cCBOX,1,nCONT-1)),1)
           AADD(aRET,{Left(cTmp,1),Substr(cTmp,3)})
        Endif 
        cCBOX:=SUBSTR(cCBOX,nCONT+1)
     Enddo
ENDSEQUENCE
     
RestArea(aSvArea)
 
RETURN aRET

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RetX3Box  ³ Autor ³ Expedito Mendonca Jr  ³ Data ³ 27.07.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna Descricao do ComboBox                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function X3CBOXDES(cConteudo,aOpcoes)
Local cRet:="",nPos := aScan(aOpcoes, {|x| x[1]==cConteudo})
If nPos > 0
	cRet := aOpcoes[nPos,2]
Endif
Return cRet