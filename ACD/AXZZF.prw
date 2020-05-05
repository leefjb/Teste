#Include "Protheus.ch"
#Include "Rwmake.ch"
#INCLUDE "tbiconn.ch"
#Include "topconn.ch"

/*/{Protheus.doc} AXZZF
//Cadastro customizado - Layout etiquetas fornecedores
@author Celso Rene
@since 02/11/2018
@version 1.0
@type function
/*/
User Function AXZZF()

	Private _aRetun := {}
	Private oBrw
	Private aHead		:= {}
	Private cCadastro	:= "ZZF"
	Private aRotina     := { }
	
	AADD(aRotina, { "Pesquisar"	, "AxPesqui"  	 , 0, 1 })
	AADD(aRotina, { "Visualizar", "AxVisual"  	 , 0, 2 })
	AADD(aRotina, { "Incluir"   , "u_axIZZF()"   , 0, 3 })  
	AADD(aRotina, { "Alterar"   , "u_axAZZF()"   , 0, 4 }) 
	AADD(aRotina, { "Excluir"   , "AxDeleta"   	 , 0, 5 })
	
	oBrw := FWMBrowse():New()

	DbSelectArea("SX3")
	dbsetorder(1)
	DbSeek("ZZF")
	While SX3->(!Eof()).And.(SX3->X3_ARQUIVO == cCadastro)

		If X3USO(X3_USADO)
			Aadd(aHead,{ AllTrim(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
		Endif

		SX3->(dbSkip())

	EndDo

	dbSelectArea("ZZF")
	dbgotop()

	oBrw:SetAlias("ZZF")
	oBrw:SetFields(aHead)
	oBrw:SetDescription("# Cadastro layouts etiquetas, leituras códigos de barras fornecedores - Recebimentos")
	oBrw:Activate()

	
Return()



/*/{Protheus.doc} axIZZF
//Ax Inclui com validacao no OK
@author solutio
@since 08/11/2018
@version 1.0
@type function
/*/
User Function axIZZF()


_nOpcI := AxInclui( "ZZF", , 3, , , , "U_ValdZZf()" ,,, {}  ,,,.T.)


Return()


/*/{Protheus.doc} axAZZF
//Ax Inclui com validacao no OK
@author solutio
@since 08/11/2018
@version 1.0
@type function
/*/
User Function axAZZF()

Local nReg    := ( "ZZF" )->( Recno() )

_nOpcA :=  AxAltera("ZZF",nReg,4,,,,,"U_ValdZZf()")


Return()


/*/{Protheus.doc} ValdZZF
//Validando TOK do cadastro ZZF
@author Celso Rene
@since 08/11/2018
@version 1.0
@type function
/*/
User Function ValdZZF()

Local _lRet	:= .T.

Do Case
//validando informacao Produto - nao permite configuracao para os 2 codigos de barras
Case ( (M->ZZF_P1DE + M->ZZF_P1ATE) > 0 .and. (M->ZZF_P2DE + M->ZZF_P2ATE) > 0 )
	MsgAlert("Informado 2 vezes a leitura do Produto !","# Produto")
	_lRet	:= .F.

//validando informacao Lote - nao permite configuracao para os 2 codigos de barras
Case ( (M->ZZF_L1DE + M->ZZF_L1ATE) > 0 .and. (M->ZZF_L2DE + M->ZZF_L2ATE) > 0 )
	MsgAlert("Informado 2 vezes a leitura do Lote !","# Lote")
	_lRet	:= .F.

//validando informacao Validade do Lote - nao permite configuracao para os 2 codigos de barras
Case ( (M->ZZF_V1DE + M->ZZF_V1ATE) > 0 .and. (M->ZZF_V2DE + M->ZZF_V2ATE) > 0 )
	MsgAlert("Informado 2 vezes a leitura da Validade do Lote !","# Valid. Lote")
	_lRet	:= .F.
EndCase


Return(_lRet)
