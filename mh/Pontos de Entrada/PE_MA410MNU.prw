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

aAdd( aRotina, { OemToAnsi("Status Itens")  ,"u_JmhF049()" 	,0,3,0 ,NIL}	)	//

Return()