#include 'protheus.ch'


/*/{Protheus.doc} JomACD03
//Cadastro customizado CB0 - Etiquetas
@author Celso Rene
@since 02/11/2018
@version 1.0
@type function
/*/
user function JomACD03()

	Private _aRetun := {}
	Private oBrw
	Private aHead		:= {}
	Private cCadastro	:= "CB0"
	Private aRotina     := { }

	Private cFiltro   := ""
	Private aCores  := {;
	{ "CB0->CB0_TIPO == '01' .AND. Empty(CB0->CB0_NFSAI) " , "ENABLE" 		 },;
	{ "CB0->CB0_TIPO == '01' .AND. !Empty(CB0->CB0_NFSAI)" , "DISABLE" 		 },; 
	{ "CB0->CB0_TIPO == '02' " , "BR_LARANJA"    },;
	{ "CB0->CB0_TIPO == '03' " , "BR_PRETO" 	 },;
	{ "CB0->CB0_TIPO == '04' " , "BR_BRANCO"     },;
	{ "CB0->CB0_TIPO == '05' " , "BR_AZUL"  	 } } 					  

	//01=Produto;02=Endereco;03=Unitizador;04=Usuario;05=Volume


	AADD(aRotina, { "Pesquisar"	, "AxPesqui"  	    , 0, 1 })
	AADD(aRotina, { "Visualizar", "AxVisual"  	 	, 0, 2 })
	AADD(aRotina, { "Re-Impressão", "u_R1ImpCB0()" 	, 1, 0, 6 })
	AADD(aRotina, { "Re-Imp. Par.", "u_R2ImpCB0()" 	, 1, 0, 7 })
	AADD(aRotina, { "Legenda",	    "u__LegenCB0()"	, 1, 0, 8 })
	//AADD(aRotina, { "Incluir"   , "AxInclui"     , 0, 3 }) 
	//AADD(aRotina, { "Alterar"   , "AxAltera"     , 0, 4 }) 
	//AADD(aRotina, { "Excluir"   , "AxDeleta"     , 0, 5 })

	oBrw := FWMBrowse():New()

	oBrw:AddLegend( "CB0->CB0_TIPO == '01' .AND. Empty(CB0->CB0_NFSAI)"   , "ENABLE" , "Produto" )
	oBrw:AddLegend( "CB0->CB0_TIPO == '01' .AND. !Empty(CB0->CB0_NFSAI)" , "DISABLE" , "Produto" )
	oBrw:AddLegend( "CB0->CB0_TIPO == '02' " , "BR_LARANJA" , "Endereço" )
	oBrw:AddLegend( "CB0->CB0_TIPO == '03' " , "BR_PRETO" , "Unitilizador" )
	oBrw:AddLegend( "CB0->CB0_TIPO == '04' " , "BR_BRANCO" , "Usuário" )
	oBrw:AddLegend( "CB0->CB0_TIPO == '05' " , "BR_AZUL" , "Embalagem" )

	DbSelectArea("SX3")
	dbsetorder(1)
	DbSeek("CB0")
	While SX3->(!Eof()).And.(SX3->X3_ARQUIVO == cCadastro)

		If X3USO(X3_USADO)
			Aadd(aHead,{ AllTrim(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
		Endif

		SX3->(dbSkip())

	EndDo

	dbSelectArea("CB0")
	dbgotop()

	oBrw:SetAlias("CB0")
	oBrw:SetFields(aHead)
	oBrw:SetDescription("# Cadastros Etiquetas - ACD: Consulta e re-impressão")
	oBrw:Activate()

Return()

/*/{Protheus.doc} _LegenCB0
//Funcao para tela de legenda CB0
@author Celso Rene
@since 02/10/2018
@version 1.0
@type function
/*/

User Function _LegenCB0()

	//01=Produto;02=Endereco;03=Unitizador;04=Usuario;05=Volume

	BrwLegenda(cCadastro,"Legenda"				,{;
	{"ENABLE"    	,"01-Etiqueta"  			},;
	{"DISABLE"   ,	 "01-Etiqueta: usada" 		},;	
	{"BR_LARANJA"   ,"02-Endereço" 				},;
	{"BR_PRETO"     ,"03-Unitilizador" 			},;
	{"BR_BRANCO"    ,"04-Usuario"	 			},;
	{"BR_AZUL"   	,"05-Volume"	 			}} )


Return()  


/*/{Protheus.doc} R1ImpCB0
//re-impressao etiquetas - por item - posicionado CB0
@author Celso Rene
@since 21/11/2018
@version 1.0
@type function
/*/
User Function R1ImpCB0()

	Local _aPrdCB0	:= {}

	//carregando dados do produto para a impressao da etiqueta
	aAdd(_aPrdCB0, {;
	CB0->CB0_CODPRO,; //produto
	CB0->CB0_DTVLD,;  //validade lote
	If(Alltrim(CB0->CB0_LOTEFO)== "",CB0->CB0_LOTE,CB0->CB0_LOTEFO),;//lote fornecedor
	CB0->CB0_CODETI,; //etiqueta
	1,;				  //quantidade a imprimir
	CtoD(""),;		  //data esterilizacao
	CB0->CB0_LOTE;	  //lote original
	})


	//impressao etiqueta - CB0
	u_ImpEtqCB0( _aPrdCB0 )


Return()



/*/{Protheus.doc} R2ImpCB0
//re-impressao etiquetas - filtros conforme parametros
pelo usuario
@author Celso Rene
@since 21/11/2018
@version 1.0
@type function
/*/
User Function R2ImpCB0()

	Local _aPrdCB0	:= {}
	Local _aAreaCB0 := GetArea()

	Local _cPerg		:= "JOMACD03"
	Local cDesc1    	:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2    	:= "de Ordens de Producao conforme parametros Informados"
	Local cDesc3        := "pelo usuário."
	Local cPict         := ""
	Local Cabec1        := ""   
	Local _tamanho      := "p"
	Local _aOrd	   		:= {}

	Private	aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nomeprog    := "Re-Impressão etiquetas - CB0"

	Private _Titulo     := "Re-Impressão etiquetas - CB0"
	Private wnrel       := "JOMACD03" 
	Private cString		:= "CB0"

	Private _nCount		:= 0

	
	GeraPerg(_cPerg)

	pergunte(_cPerg,.F.)

	wnrel := SetPrint(cString,NomeProg,_cPerg,@_titulo,cDesc1,cDesc2,cDesc3,.T.,_aOrd,.T.,_Tamanho,,.T.)    


	If aReturn[5] <> 1 // OPCAO <> OK - SetPrint
		Return()
	EndIf


	Processa( {|| Process() }, "Aguarde...", "# Imprimindo Etiquetas",.F.)


	RestArea(_aAreaCB0)


Return()



/*/{Protheus.doc} Process
//Processo relatorio - chamado na funcao: R2ImpCB0
@author Celso Rene
@since 21/11/2018
@version 1.0
@type function
/*/
Static Function Process()

	Local _lRet 	:= .T.
	Local _cQuery	:= ""
	Local _aPrdCB0	:= {}

	_cQuery := " SELECT  CB0.* " + chr(13)
	_cQuery += " FROM " + Retsqlname("CB0") + " CB0 " + chr(13)
	_cQuery += " INNER JOIN " + Retsqlname("SB8") + " SB8 ON SB8.B8_FILIAL = '" + xFilial("SB8") +  "' AND SB8.D_E_L_E_T_ = '' AND SB8.B8_PRODUTO = CB0.CB0_CODPRO AND SB8.B8_LOTECTL = CB0.CB0_LOTE AND SB8.B8_DTVALID = CB0.CB0_DTVLD " + chr(13) 
	_cQuery += " WHERE CB0.CB0_FILIAL = '" + xFilial("CB0") +  "' AND CB0.D_E_L_E_T_ = '' " + chr(13)
	_cQuery += " AND CB0.CB0_NFENT BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND CB0.CB0_SERIEE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + chr(13)
	_cQuery += " AND CB0.CB0_FORNEC BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + chr(13)  //AND CB0.CB0_LOJAFO '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' " + chr(13)
	_cQuery += " AND CB0.CB0_LOTE BETWEEN '" + MV_PAR07 +  "' AND '" + MV_PAR08 +  "' "+ chr(13)
	_cQuery += " AND CB0.CB0_CODETI BETWEEN '" + MV_PAR09 +  "' AND '" + MV_PAR10 +  "' "+ chr(13)

	Do Case
		Case MV_PAR11 == 1 //utilizadas 
		_cQuery += " AND CB0.CB0_NFSAI <> '' " + chr(13)

		Case MV_PAR11 == 2 //nao utilizadas
		_cQuery += " AND CB0.CB0_NFSAI = '' " + chr(13)
	EndCase


	_cQuery := ChangeQuery(_cQuery)

	If Select("TCB0") <> 0
		TCB0->(DbCloseArea())
	EndIf

	//TcQuery _cQuery New Alias "TCB0" 
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TCB0', .T., .T.)

	DBSelectArea("TCB0")
	Count To _nCount
	ProcRegua(_nCount)
	TCB0->(DBGotop())
	Do While ! TCB0->(EOF())

		//carregando dados do produto para a impressao da etiqueta
		aAdd(_aPrdCB0, {;
		TCB0->CB0_CODPRO,; //produto
		StoD(TCB0->CB0_DTVLD),;  //validade lote
		If(Alltrim(TCB0->CB0_LOTEFO) == "",TCB0->CB0_LOTE,TCB0->CB0_LOTEFO),;	  //lote fornecedor
		TCB0->CB0_CODETI,; //etiqueta
		1,;				  //quantidade a imprimir
		CtoD(""),;		  //data esterilizacao
		TCB0->CB0_LOTE;	  //lote original
		})

		IncProc()
		TCB0->(dbSkip())
	EndDo

	dbCloseArea("TCB0")


	If ( Len(_aPrdCB0) > 0 )

		//impressao etiqueta - CB0
		u_ImpEtqCB0( _aPrdCB0 )
		
		/* For _z:= 1 to Len(_aPrdCB0)
			u_ImpEtqCB0( _aPrdCB0[_z] )
		Next _z */
	
	Else
	
		MsgAlert("Conforme parâmetros informados, não foi encontrado nenhuma etiqueta!", "# Rel. Etiquetas - CB0")
		
	EndIf


Return(_lRet)



/*/{Protheus.doc} GeraPerg
//Gravando SX1
@author Celso Rene
@since 21/11/2018
@version 1.0
@type function
/*/
Static Function GeraPerg(_cPerg)

	Local _aCab	 := {}
	Local _aPerg := {}
	
	_aCab := 	{ "X1_GRUPO"	,; 
                  "X1_ORDEM"	,; 
                  "X1_PERGUNT"	,;	
                  "X1_VARIAVL"	,;
                  "X1_TIPO"		,;   
                  "X1_TAMANHO"	,;
                  "X1_DECIMAL"	,;
                  "X1_PRESEL"	,; 
                  "X1_GSC"		,; 
                  "X1_F3"		,;   
                  "X1_VAR01"	,;
                  "X1_DEF01"	,;
                  "X1_DEF02"	,;
                  "X1_DEF03"	,;
                  "X1_PRESEL"	 }	      
	

	//gerando perguntas para o relatorio caso nao exista na SX1
	aAdd( _aPerg , {_cPerg, "01",'Documento De ?'	,"mv_ch1"	,"C"	,9   ,0	,0	,"G"  ,"SF1"	,"mv_par01"	,""		,		,		,   0})
	aAdd( _aPerg , {_cPerg, "02",'Documento Ate ?'	,"mv_ch2"	,"C"	,9   ,0	,0	,"G"  ,"SF1"	,"mv_par02"	,""		,		,		,   0})
	aAdd( _aPerg , {_cPerg, "03",'Serie De ?'		,"mv_ch3"	,"C"	,9   ,0	,0	,"G"  ,""		,"mv_par03"	,""		,		,		,   0})
	aAdd( _aPerg , {_cPerg, "04",'Serie Ate ?'		,"mv_ch4"	,"C"	,9   ,0	,0	,"G"  ,""		,"mv_par04"	,""		,		,		,   0})
	aAdd( _aPerg , {_cPerg, "05",'Fornecedor De ?'	,"mv_ch5"	,"C"	,10  ,0	,0	,"G"  ,"SA2"	,"mv_par05"	,""		,		,		,   0})
	aAdd( _aPerg , {_cPerg, "06",'Fornecedor Ate ?'	,"mv_ch6"	,"C"	,10  ,0	,0	,"G"  ,"SA2"	,"mv_par06"	,""		,		,		,   0})  
	aAdd( _aPerg , {_cPerg, "07",'Lote De ?'		,"mv_ch7"	,"C"	,10  ,0	,0	,"G"  ,""		,"mv_par07"	,""		,		,		,   0})
	aAdd( _aPerg , {_cPerg, "08",'Lote Ate ?'		,"mv_ch8"	,"C"	,10  ,0	,0	,"G"  ,""		,"mv_par08"	,""		,		,		,   0})
	aAdd( _aPerg , {_cPerg, "09","Utilizadas ?"		,"mv_ch9"	,"N"	,1   ,0	,0	,"C"  ,"" 		,"mv_par09"	,"Sim"	,"Não"	,"Ambos",   3})

	u_xPutSX1( _aCab , _aPerg ,  .F. )


	/*	For i:=1 to Len(_aPerg)
	If !dbSeek(padr(_cPerg,10)+_aPerg[i,2])
	RecLock("SX1",.T.)
	For j:=1 to FCount()
	If j <= Len(_aPerg)
	FieldPut(j,_aPerg[i,j])
	Endif
	Next
	MsUnlock()
	Endif
	Next i
	*/	


Return()
