#Include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณMA410MNU  บAutor  ณMarcelo Tarasconi   บ Data ณ  19/01/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPE para adicionar consulta itens do pedido de venda         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP 8                                                       บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA410MNU()

	Local _aGrupo := {}

	/*
	Local aRotina2  := {{"Incluir","A410Barra",0,3},;							// 
	{"Alterar","A410Barra",0,4}}								// 
	Local aRotina3  := {{ OemToAnsi("Excluir"),"A410Deleta"	,0,5,21,NIL},;
	{ OemToAnsi("Residuo"),"Ma410Resid",0,2,0,NIL}}			//

	aRotina := {	{ OemToAnsi("Pesquisar")     ,"AxPesqui"	,0,1,0 ,.F.},;		//
	{ OemToAnsi("Visual")        ,"A410Visual"	,0,2,0 ,NIL},;		//
	{ OemToAnsi("Incluir")       ,"A410Inclui"	,0,3,0 ,NIL},;		//
	{ OemToAnsi("Alterar")       ,"A410Altera"	,0,4,20,NIL},;		//
	{ OemToAnsi("Excluir")       ,IIf((Type("l410Auto") <> "U" .And. l410Auto),"A410Deleta",aRotina3),0,5,0,NIL},; // 
	{ OemToAnsi("Cod.barra")     ,aRotina2 		,0,3,0 ,NIL},;		//
	{ OemToAnsi("Copia")         ,"A410PCopia"	,0,6,0 ,NIL},;		//
	{ OemToAnsi("Retornar")      ,"A410Devol"	,0,3,0 ,NIL},;		//"Dev. Compras"
	{ OemToAnsi("Prep.Doc.Saํda"),"Ma410PvNfs"	,0,2,0 ,NIL},;		//
	{ OemToAnsi("Legenda")       ,"A410Legend"	,0,3,0 ,.F.},;		//
	{ "Conhecimento"             ,"MsDocument"	,0,4,0 ,NIL},;		//
	*/

	aAdd( aRotina, { OemToAnsi("Status Itens")  ,"u_JmhF049()" 	,0,3,0 ,NIL}	)	
	aAdd( aRotina, { OemToAnsi("Excluir Ord. Sep.")  ,"u_JOMACD16(SC5->C5_FILIAL,SC5->C5_NUM)" 	,0,6,0 ,NIL}	)


	If !("JOMACD14" $ FunName())
		_aGrupo := UsrRetGrp(RetCodUsr())
		For _x:= 1 to Len(_aGrupo)
			If (_aGrupo[1] $ "000007-000019-000000") 
				//rotina para gerar as CB0 dos lotes unitarios estourados
				aAdd( aRotina, { OemToAnsi("Gera Etiq. L. Estourados")  ,"u_xLoteAju()" 	    ,0,6,0 ,NIL}	)
				aAdd( aRotina, { OemToAnsi("# Atualiza Separacao")  ,"u_xGerSC9(SC5->C5_NUM)" 	,0,6,0 ,NIL}	)
				_x:= Len(_aGrupo) + 1
			EndIf
		Next _x
	EndIf


Return()
