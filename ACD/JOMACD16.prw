#INCLUDE "PROTHEUS.CH"
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} JOMACD16
//Rotina para excluir Ordem de separacao pelo pedido de venda
//estornando todas as tabelas envolvidas.
@author Márcio Borges
@since 14/05/2019
@version 1.0
@return ${return}, ${return_description}
@param _cFilPed, , descricao
@param _cNumPed, , descricao
@param _cItemPed, , descricao
@type function
/*/
User Function JOMACD16(_cFilPed,_cNumPed)
	/*
	Condição: Nenhum item do pedido pode ter sido faturado para poder fazer a operação.
	Avisar o usuário se tiver e não efetuar procedimento. 	C6_DOC
	*/
	Local cAliasQry := GetNextAlias()
	//Local cQryB8 	:= GetNextAlias()
	Local aSB8		:= {} // Registros a serem alterados SB8
	Local cSql := ""
	Local aRegDel := {} // Alias, Número recno do registro a ser deletado
	Local aTamSX3 := 0 // Variavel para buscar tamanho do campo vigente
	Private lAlterou := .F. //flag para informar se fez alguma alteração em base de dados.

	If !MsgYesNo(" Deseja realmente excluir a Ordem de Separação do Pedido "+ _cNumPed +" ?",OemToAnsi("Excluir Separação"))
		Return()
	Endif


	//Verifica se Pedido Já foi Faturado

	cSql := "SELECT 'S' FOUND  FROM " + RetSqlName("SC6") +  " WHERE C6_FILIAL = '"+ _cFilPed +"' AND C6_NUM = '"+ _cNumPed +"' AND C6_NOTA <> '"+ SPACE(TamSX3("C6_NOTA")[1]) + "' AND D_E_L_E_T_ = ' '"
	MyQuery(cSql,cAliasQry)

	If  (cAliasQry)->( !EoF()) .Or. !Empty((cAliasQry)->FOUND)
		MsgInfo("Não pode ser Feito a Exclusão de Separação de Pedidos já faturados!","Pedido Faturado")
		Return()
	Endif	
	(cAliasQry)->( dbCloseArea() )

	//Busca Registros do CB7
	cSql := " SELECT R_E_C_N_O_ AS NREG FROM " + RetSqlName("CB7") + " WHERE CB7_FILIAL = '"+ _cFilPed +"' AND CB7_PEDIDO = '"+ _cNumPed +"' AND D_E_L_E_T_ = ' '"
	MyQuery(cSql,cAliasQry)
	While (cAliasQry)->( !EoF() )
		AADD(aRegDel,{"CB7",(cAliasQry)->NREG } ) 
		(cAliasQry)->( DBSkip() )
	EndDo

	(cAliasQry)->( dbCloseArea() )

	//Busca Registros do CB8
	cSql := " SELECT R_E_C_N_O_ AS NREG FROM " + RetSqlName("CB8") + " WHERE CB8_FILIAL = '"+ _cFilPed +"' AND CB8_PEDIDO = '"+ _cNumPed +"' AND D_E_L_E_T_ = ' '"
	MyQuery(cSql,cAliasQry)
	While (cAliasQry)->( !EoF() )
		AADD(aRegDel,{"CB8",(cAliasQry)->NREG } ) 
		(cAliasQry)->( DBSkip() )
	EndDo

	(cAliasQry)->( dbCloseArea() )

	//Busca Registros do CB9
	cSql := " SELECT R_E_C_N_O_ AS NREG, CB9_PROD,CB9_QTESEP,CB9_LOTECT FROM " + RetSqlName("CB9") + " WHERE CB9_FILIAL = '"+ _cFilPed +"' AND CB9_PEDIDO = '"+ _cNumPed +"' AND D_E_L_E_T_ = ' '"
	MyQuery(cSql,cAliasQry)
	aTamSx3 := TamSX3("CB9_QTESEP") 
	TCSetField(cAliasQry,"CB9_QTESEP",aTamSX3[3],aTamSX3[1],aTamSX3[2])
	While (cAliasQry)->( !EoF() )
		AADD(aRegDel,{"CB9",(cAliasQry)->NREG } ) 
		//SQL alteração SB8
		AADD(aSB8,"UPDATE " + RetSqlName("SB8") + " SET B8_EMPENHO = IIF( B8_EMPENHO - " + AllTrim(STR( (cAliasQry)->CB9_QTESEP)) + " > 0, B8_EMPENHO - " + AllTrim(STR( (cAliasQry)->CB9_QTESEP)) + " , 0) WHERE B8_PRODUTO = '"+ (cAliasQry)->CB9_PROD  +"' AND B8_LOTECTL = '"+ (cAliasQry)->CB9_LOTECT  +"'  AND D_E_L_E_T_ = ' '")
		
		(cAliasQry)->( DBSkip() )
	EndDo

	//Busca Registros do CBF
	cSql := " SELECT R_E_C_N_O_ AS NREG FROM " + RetSqlName("CBF") + " WHERE CBF_FILIAL = '"+ _cFilPed +"' AND CBF_XPED = '"+ _cNumPed +"' AND D_E_L_E_T_ = ' '"
	MyQuery(cSql,cAliasQry)
	While (cAliasQry)->( !EoF() )
		AADD(aRegDel,{"CBF",(cAliasQry)->NREG } ) 
		(cAliasQry)->( DBSkip() )
	EndDo


	//Busca Registros do SC9
	cSql := " SELECT R_E_C_N_O_ AS NREG FROM " + RetSqlName("SC9") + " WHERE C9_FILIAL = '"+ _cFilPed +"' AND C9_PEDIDO = '"+ _cNumPed +"' AND D_E_L_E_T_ = ' '"
	MyQuery(cSql,cAliasQry)
	While (cAliasQry)->( !EoF() )
		AADD(aRegDel,{"SC9",(cAliasQry)->NREG } ) 
		(cAliasQry)->( DBSkip() )
	EndDo

	If Len(aSB8) == 0 .And. Len(aRegDel) == 0
		MsgInfo("Não foi localizado Separações deste pedido a serem Excluídas!","Pedido Sem Separação")
		Return()

	Endif 
	// Inicia Transação de alterações no Banco de Dados
	Begin Transaction

		AbateReservas(aSB8)
		ApagaRegistros(aRegDel)
		RefazEmpenho(_cFilPed,_cNumPed) //SB2


		MsgInfo("Operação Realizada com Sucesso!","Sucesso!")
	End Transaction

	
Return()


/*/{Protheus.doc} RefazEmpenho
//Query para refazer reservas na SB2
@author Marcio
@since 15/05/2019
@version 1.0
@type function
/*/
Static Function RefazEmpenho(_cFilPed,_cNumPed)
	Local cSql := ""

	//Empenho SB2
	cSQl +=   " UPDATE " + RetSqlName("SB2") + " SET B2_RESERVA = ISNULL(( "
	cSQl +=   "			SELECT SUM(SC9.C9_QTDLIB) FROM " + RetSqlName("SC9") + " SC9 " 
	cSQl +=   "				WHERE  SC9.C9_FILIAL = B2_FILIAL    
	cSQl +=   "		             AND  SC9.C9_PRODUTO = B2_COD  "
	cSQl +=   "				     AND  SC9.C9_LOCAL = B2_LOCAL "
	cSQl +=   "					 AND  SC9.D_E_L_E_T_ = ' ' " 
	cSQl +=   "					 AND  SC9.C9_NFISCAL = ' ' "
	cSQl +=   "					 AND  EXISTS (SELECT SC6.C6_NUM FROM " + RetSqlName("SC6") + " SC6 WHERE SC6.C6_FILIAL = SC9.C9_FILIAL AND SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC6.C6_ITEM AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.D_E_L_E_T_=' ') "
	cSQl +=   "			),0) "
	cSQl +=   "		WHERE D_E_L_E_T_ = '' AND (B2_FILIAL+ B2_COD + B2_LOCAL ) IN (SELECT C6_FILIAL + C6_PRODUTO + C6_LOCAL FROM " + RetSqlName("SC6") + " WHERE C6_FILIAL = '"+ _cFilPed +"' AND C6_NUM = '"+ _cNumPed +"'  AND D_E_L_E_T_=' ') "

	nStat := TCSQLExec(cSql)
	if (nStat < 0)
		Alert("JOMACD16- Erro na Alteração via Banco - Recuperando estado anterior: TCSQLError() " + TCSQLError() )
		DisarmTransaction()
		Break

	Endif
	
	//Apaga Empenho do SC6
	cSql := "UPDATE " + RetSqlName("SC6") + " SET C6_QTDEMP = 0, C6_QTDSEP = 0, C6_QTDCONF = 0  WHERE C6_FILIAL = '"+ _cFilPed +"' AND C6_NUM = '"+ _cNumPed +"'  AND D_E_L_E_T_=' '"
	nStat := TCSQLExec(cSql)
	if (nStat < 0)
		Alert("JOMACD16- Erro na Alteração via Banco - Recuperando estado anterior: TCSQLError() " + TCSQLError() )
		DisarmTransaction()
		Break

	Endif
	
	
	//Apaga informacao ordem de separacao do SC5
	cSql := "UPDATE " + RetSqlName("SC5") + " SET C5_XORDSEP = ''  WHERE C5_FILIAL = '"+ _cFilPed +"' AND C5_NUM = '"+ _cNumPed +"'  AND D_E_L_E_T_=' '"
	nStat := TCSQLExec(cSql)
	if (nStat < 0)
		Alert("JOMACD16- Erro na Alteração via Banco - Recuperando estado anterior: TCSQLError() " + TCSQLError() )
		DisarmTransaction()
		Break
	Endif	
	
	
Return()


/*/{Protheus.doc} AbateReservas
/Abate reservas
@author Marcio
@since 15/05/2019
@type function
/*/
Static Function AbateReservas(aSB8)

	For x:=1 to Len(aSB8)
		nStat := TCSQLExec(aSB8[x])
		if (nStat < 0)
			Alert("JOMACD16- Erro na Alteração via Banco - Recuperando estado anterior: TCSQLError() " + TCSQLError() )
			DisarmTransaction()
			Break
		Endif
	Next x

Return()


//Armazenar registros a serem deletados em um array
//Apaga Registros
Static Function ApagaRegistros(aRegDel)
	Local aArea := GetArea()
	Local X_ALIAS	:= 1
	Local X_NRECDEL := 2

	For x:= 1 to Len(aRegDel)
		_cAlias  := aRegDel[x][X_ALIAS]
		_nRecDel := aRegDel[x][X_NRECDEL]
		
		DbSelectArea(_cAlias)
		(_cAlias)->(dbGoto(_nRecDel))
		If (_cAlias)->(Recno()) == _nRecDel
			(_cAlias)->( recLock( _cAlias ,.f.) )
			(_cAlias)->(dbDelete())
			(_cAlias)->( msUnLock() )
		Endif
	Next x					

	RestArea(aArea)					

Return()


//####################################
//## Consulta SQL ao banco de dados ##
//####################################
Static Function MyQuery( cQuery , cursor )

	IF SELECT( cursor ) <> 0
		dbSelectArea(cursor)
		DbCloseArea(cursor)
	Endif

	TCQUERY cQuery NEW ALIAS (cursor)

Return()
