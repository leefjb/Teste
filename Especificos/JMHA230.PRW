#Include "Totvs.Ch"

#Define P_MARK      001 //-- Flag de Marcacao da ListBox
#Define P_PRODUTO   002 //-- C๓digo do Produto
#Define P_SERORIG   003 //-- Serie da Nota Fiscal Original
#Define P_NFORIG    004 //-- Numero da Nota Fiscal Original
#Define P_ITEORIG   005 //-- Item da Nota Fiscal Original
#Define P_LOCORIG   006 //-- Local de Estoque da Nota Fiscal Original
#Define P_UMORIG    007 //-- Unidade de Medida da Nota Fiscal Original
#Define P_EMIORIG   008 //-- Data de Emissao da Nota Fiscal Original
#Define P_TESORIG   009 //-- TES da Nota Fiscal Original
#Define P_TESDV     010 //-- TES para uso na Nota de Entrada
#Define P_QTDORIG   011 //-- Quantidade Total Vendida da Nota Fiscal Original
#Define P_SALDOB6   012 //-- Saldo disponivel para acerto da Nota Fiscal Original
#Define P_QTDACER   013 //-- Quantidade a Acertar
#Define P_PRCUNIT   014 //-- Preco de Tabela do Produto da Nota Fiscal Original
#Define P_PRCVEND   015 //-- Venda do Produto da Nota Fiscal Original
#Define P_DESCONT   016 //-- Desconto concedido na Nota Fiscal Original
#Define P_B6IDENT   017 //-- Identificacao do Movimento
#Define P_RASTRO    018 //-- Se Item Controla Rastro por Lote (B1_RASTRO = L)
#Define P_LOTEUNI   019 //-- Se Item faz parte de um Lote Unico (B8_LOTEUNI = S)
#Define P_LOTECTL   020 //-- Lote do Produto
#Define P_LOTEFOR   021 //-- Lote do Fornecedor
#Define P_DTVALID   022 //-- Data de Validade do Lote do Produto
#Define P_SALDOB8   023 //-- Coluna do Saldo disponivel do Lote

#Define TAM_LISTBOX 023 //-- Tamanho do Array da ListBox

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ JMHA230  ณ Autor ณ Fabio Briddi          ณ Data ณ Maio/2015ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ TOTVS-RS         ณContato ณ fbriddi@tovs.com.br            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Manutencao cadastro de                                     ณฑฑ
ฑฑณ          ณ Autorizacoes de Faturmamento / Devolucoes                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณ Para Controle na digitacao da NF do Centro de Custo        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Estoque/Compras                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ Manutencao Efetuada                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function JMHA230()

	Local   aCores    := {}

	Private cCadastro := "Autoriza็ใo de Faturamento/Devolu็ใo"
	Private aRotina   := MenuDef()
	Private lEndereca := (AllTrim(GetMv("MV_LOCALIZ")) = "S")
	
	If (cEmpAnt == "06" .or. cEmpAnt == "01")
		MsgAlert("Fun็ใo indisponํvel para a empresa!","Rotina nใo disponํvel")
		Return()
	EndIf
	

	aAdd(aCores,{ "ZO_TIPO=='1'.AND.ZO_STATUS=='1'", "BR_LARANJA" })	//-- AF Digitada
	aAdd(aCores,{ "ZO_TIPO=='1'.AND.ZO_STATUS=='9'", "DISABLE"    })	//-- AF Encerrada
	aAdd(aCores,{ "ZO_TIPO=='2'.AND.ZO_STATUS=='1'", "BR_PINK"    })	//-- AD Consignacao Digitada
	aAdd(aCores,{ "ZO_TIPO=='2'.AND.ZO_STATUS=='9'", "DISABLE"    })	//-- AD Consignacao Encerrada
	aAdd(aCores,{ "ZO_TIPO=='3'.AND.ZO_STATUS=='1'", "BR_CINZA"   })	//-- AD Venda Digitada
	aAdd(aCores,{ "ZO_TIPO=='3'.AND.ZO_STATUS=='9'", "DISABLE"    })	//-- AD Venda Encerrada

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSZO -- Cabecalho das Autorizacoes de Faturamento / Devolucao de consignadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SZO")
	SZO->( dbSetOrder( 1 ) )

	mBrowse(6,1,22,75,"SZO",,,,,,aCores)

	RetIndex("SZO")

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ MenuDef  บAutor  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem Menu Especifico da Rotina JMHA230.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MenuDef()

	Local aRotina := {}

	aAdd( aRotina,{ "Pesquisar"       , "AxPesqui"       ,0 ,1 } )
	aAdd( aRotina,{ "Visualizar"      , "U_A230Mnt"      ,0 ,2 } )
	aAdd( aRotina,{ "Inclui"          , "U_A230Mnt"      ,0 ,3 } )
	aAdd( aRotina,{ "Alterar"         , "U_A230Mnt"      ,0 ,4 } )
	aAdd( aRotina,{ "Excluir"         , "U_A230Mnt"      ,0 ,5 } )
	aAdd( aRotina,{ "Efetivar"        , "U_A230Efetivar" ,0 ,6 } )

	aAdd( aRotina,{ "Vis. NF.Entrada" , "U_A230VisNFEnt" ,0 ,2 } )
	aAdd( aRotina,{ "Vis. Ped.Venda"  , "U_A230VisPv"    ,0 ,2 } )
	aAdd( aRotina,{ "Doc. Saํda"      , "U_A230DocSai"   ,0 ,2 } )
	aAdd( aRotina,{ "Imp.Pre-Nota"    , "U_JMHR730"      ,0 ,2 } )
	aAdd( aRotina,{ "Legenda"         , "U_A230Leg"      ,0 ,8 } )

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ MenuDef  บAutor  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A230VisNfent()

	Local lOk      := .T.
	Local cTipoDoc := IIf(SZO->ZO_TIPO="3","D","B")

	If SZO->ZO_STATUS = "1"
		Iw_MsgBox("Op็ใo Invแlida para Status do Documento","INFO")
		lOk := .F.
	EndIf

	If	lOk
		If	Empty(SZO->ZO_NFENTRA)
			Iw_MsgBox("AF/AD sem Documento de Entrada Relacionado","INFO")
			lOk := .F.
		Else

			dbSelectArea("SF1")
			dbSetOrder(1)	//-- F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO

			If	dbSeek( xFilial("SF1") + SZO->(ZO_NFENTRA+ZO_SERENTR+ZO_CLIENTE+ZO_LOJA) + cTipoDoc )
				A103NFiscal( "SF1", SF1->(RecNo()), 2 )

			EndIf

		EndIf
	EndIf

Return( lOk )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ MenuDef  บAutor  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A230VisPv()

	Local lOk      := .T.

	If	SZO->ZO_STATUS = "1" .Or. SZO->ZO_TIPO <> "1"
		Iw_MsgBox("Op็ใo Invแlida para Status do Documento","INFO")
		lOk := .F.
	EndIf

	If	lOk
		If	Empty(SZO->ZO_PEDIDO)
			Iw_MsgBox("AF/AD sem Pedido de Venda Relacionado","INFO")
			lOk := .F.
		Else

			dbSelectArea("SC5")
			dbSetOrder(1)	//-- C5_FILIAL+C5_NUM
			If	dbSeek( xFilial("SC5") + SZO->ZO_PEDIDO )
				If	Empty(SC5->C5_NOTA)
					A410Visual( "SC5", SC5->(RecNo()), 2 )

				EndIf

			EndIf

		EndIf
	EndIf

Return( lOk )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณA230DocSaiบAutor  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A230DocSai()

	Local lOk      := .T.

	If	SZO->ZO_STATUS = "1" .Or. SZO->ZO_TIPO <> "1"
		Iw_MsgBox("Op็ใo Invแlida para Documento","INFO")
		lOk := .F.

	EndIf

	If	lOk
		If	Empty(SZO->ZO_PEDIDO)
			Iw_MsgBox("AF/AD sem Pedido de Venda Relacionado","INFO")
			lOk := .F.
		Else

			dbSelectArea("SC5")
			dbSetOrder(1)	//-- C5_FILIAL+C5_NUM
			If	dbSeek( xFilial("SC5") + SZO->ZO_PEDIDO )
				Ma410PvNfs("SC5",SC5->(RecNo()),3)

			EndIf

		EndIf
	EndIf

Return( lOk )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ MenuDef  บAutor  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A230Mnt( cAlias, nReg, nOpcx )

	//-- Genericas
	Local nCntFor		:= 0

	//-- Enchoice
	Local aEnchFields	:= {}
	Local aNoEnchFields	:= {}

	Local aButtons		:= {}
	Local nOpca			:= 0

	//-- Dialog
	Local oDlgEsp

	//-- Controle de dimensoes de objetos
	Local aObjects		:= {}
	Local aInfo			:= {}

	//-- GetDados
	Private aNoGetFields	    := {}

	//-- Enchoice
	Private oEnch
	Private aTela[0][0]
	Private aGets[0]
	Private oPanel
	Private oPanel1

	//-- GetDados
	Private oGetD
	Private aHeader      := {}
	Private aCols        := {}
	Private aPosObj      := {}
	Private nUsado       := 0
	Private nPosDeletado := 0

	//-- Cabecalho
	Private cNumAf      := Space(TamSX3("ZO_NUM")[1])
	Private cAfCli      := Space(TamSX3("ZO_AFCLI")[1])

//	Private cTipoDoc    := Space(TamSX3("ZO_TIPO")[1])
	Private cTipoDocAnt := CriaVar("ZO_TIPO")

//	Private cCodCli     := Space(TamSX3("A1_COD")[1])
//	Private cLojCli	    := Space(TamSX3("A1_LOJA")[1])

	Private cCodCliAnt  := Space(TamSX3("A1_COD")[1])
	Private cLojCliAnt  := Space(TamSX3("A1_LOJA")[1])

	//-- RodaPe
	Private oPanel2
	Private oSay1, oSay2, oSay3, oQtdItem
	Private nQtdItem		:= 0
	Private nTotDifItens	:= 0
	Private nTotQtdItens	:= 0
	Private nTotVlrAf		:= 0
	Private cProdAnt		:= ""

	INCLUI := (nOpcx = 3)
	ALTERA := (nOpcx = 4)

	//-- Configura variaveis da Enchoice
	RegToMemory( cAlias, nOpcx==3 ) // pega todos os dados que estแ nesse registro.

	// Campos que irao aparecer na GetDados
	// aAdd( aVisual, 'XXX_XXXX')

	//-- Campos que nao irao aparecer na Enchoice
	aAdd( aNoEnchFields, "ZO_STATUS" )
//	aAdd( aNoEnchFields, "ZO_NFENTRA" )
//	aAdd( aNoEnchFields, "ZO_SERENTR" )
	aAdd( aNoEnchFields, "ZO_PEDIDO" )
	aAdd( aNoEnchFields, "ZO_MENNOTA" )

	aAdd( aEnchFields, "NOUSER" )

	//-- Campos que nao irao aparecer na GetDados
	aAdd( aNoGetFields, "ZP_FILIAL" )
	aAdd( aNoGetFields, "ZP_NUM" )
	aAdd( aNoGetFields, "ZP_CLIENTE" )
	aAdd( aNoGetFields, "ZP_LOJA" )
	aAdd( aNoGetFields, "ZP_AFCLI" )
	aAdd( aNoGetFields, "ZP_TIPO" )
	aAdd( aNoGetFields, "ZP_STATUS" )
	aAdd( aNoGetFields, "ZP_COND" )
	aAdd( aNoGetFields, "ZP_NFENTRA" )
	aAdd( aNoGetFields, "ZP_SERENTR" )

	//-- Configura variaveis do aHeader
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZO")
	While !SX3->(Eof()) .and. SX3->X3_ARQUIVO = "SZO"
		If X3USO(x3_usado) .AND. cNivel >= x3_nivel
			If aScan( aNoEnchFields, AllTrim(SX3->X3_CAMPO) ) = 0
				aAdd( aEnchFields, SX3->X3_CAMPO )
			EndIf
		EndIf
		dbSkip()
	EndDo

	//-- Configura variaveis do aCols
	dbSeek("SZP")
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SZP" )
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			If aScan( aNoGetFields, AllTrim(SX3->X3_CAMPO)) = 0
				nUsado++
				aAdd( aHeader,{	TRIM(X3Titulo())		,;
								TRIM(SX3->X3_CAMPO)		,;
									 SX3->X3_PICTURE	,;
									 SX3->X3_TAMANHO	,;
									 SX3->X3_DECIMAL	,;
									 SX3->X3_VALID		,;
									 SX3->X3_USADO		,;
									 SX3->X3_TIPO		,;
									 SX3->X3_ARQUIVO	,;
									 SX3->X3_CONTEXT } )
				cVarCampo := "nPos" + SubStr(AllTrim(SX3->X3_CAMPO),4)
				Private	&(cVarCampo) := Len(aHeader)

			EndIf
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo

	nPosDeletado := nUsado+1

	// carrega os dados para o aCols
	n := 0

	If	!INCLUI
		If	SZO->ZO_STATUS	<> "2" .Or. nOpcx = 2
			dbSelectArea("SZO")
			dbSetOrder(1) // Filial + Num AF + Item
			If dbSeek(xFilial("SZO")+SZO->ZO_NUM,.F.)
				dbSelectArea("SZP")
				dbSetOrder(1) // Filial + Num AF + Item
				If dbSeek(xFilial("SZP")+SZO->ZO_NUM,.F.)

					Do While !Eof() .And. SZP->ZP_FILIAL + SZP->ZP_NUM == SZO->ZO_FILIAL + SZO->ZO_NUM
						n++
						aAdd(aCols,Array(nUsado+1)) // Carrego a posicao do aCols como NIL
						For nCntFor := 1 To nUsado
							If ( aHeader[nCntFor][10] != "V" ) // Pego campo somente que eh REAL
								aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
							Else // Se for campo virtual inicializa com conteudo do campo
								aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
							EndIf
						Next
						aCols[Len(aCols)][Len(aHeader)+1] := .F. // Marco a linha como NAO deletado
						dbSkip()
					EndDo

				EndIf

			EndIf

			nTotDifItens	:= 0
			nTotQtdItens	:= 0
			nTotVlrAf		:= 0
			cProdAnt		:= ""
			For nY := 1 To Len(aCols)
				If	cProdAnt <> aCols[nY,nPosProduto] .And. !Empty(aCols[nY,nPosProduto])
					nTotDifItens++
					cProdAnt := aCols[nY,nPosProduto]
				EndIf
				nTotQtdItens	+= aCols[nY,nPosQtde]
				nTotVlrAf		+= aCols[nY,nPosTotal]
			Next
		Else
			Return(nOpca)
		EndIf
	EndIf
	n := 1
	//-- Inicializa o item da getdados se a linha estiver em branco.
	If Len( aCols ) == 1 .And. Empty( GDFieldGet( "ZP_NUM", 1 ) ) // Retorna o conteudo do campo
		GdFieldPut( "ZP_ITEM"  , StrZero(1,Len(SZP->ZP_ITEM)), 1 ) // Coloca no campo o seu conteudo
	EndIf

	If nOpcx = 3 .Or. nOpcx = 4
		//-- Acrescenta Botoes na EnchoiceBar
		aAdd( aButtons, { "RECALC"	, { || U_P3JMHA230()  } , "Itens Documento Original p/ Faturamento/Devolucao de Consigna็ใo - <F7>" } )

		//-- Ativa a Tecla de Funcao F7
		SetKey( VK_F7 , { || U_P3JMHA230() } )

	EndIf

	//-- Dimensoes padroes
	aSize := MsAdvSize()
	aAdd( aObjects, { 100, 035, .T., .T. } ) // -- Coordenadas do Caecalho (enchoice)
	aAdd( aObjects, { 100, 055, .T., .T. } ) // -- Coordenadas do GetDados
	aAdd( aObjects, { 100, 010, .T., .T. } ) // -- Coordenadas do RodaPe
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)

	nOpcMenu := If(nOpcx=6,2,nOpcx)

	// -- Monta a Janela maior onde montara o Enchoice e o GetDados
	Define MsDialog oDlgEsp Title cCadastro From aSize[7],00 To aSize[6],aSize[5] Pixel

		//-- Dados do Cabecalho
		//-- Monta a enchoice.
		oEnch     := 	MsMGet():New( "SZO"  , nReg  , nOpcMenu,      ,      ,      , aEnchFields, aPosObj[1],            ,       3,       ,       ,      ,     ,    , .T. )
	    //-- Parametros MsMGet():New( cAlias , uPar2 , nOpc    , uPar4, uPar5, uPar6,       aAcho,       aPos, aCpos      , nModelo, uPar11, uPar12,uPar13, oWnd, lF3, lMemoria, lColumn, caTela, lNoFolder, lProperty, aField, aFolder, lCreate, lNoMDIStretch, uPar25 )

		//-- Monta a GetDados
		oGetD := MSGetDados():New(aPosObj[ 2, 1 ], aPosObj[ 2, 2 ],aPosObj[ 2, 3 ], aPosObj[ 2, 4 ], nOpcMenu,'U_JMH230LinOk','U_JMH230TudOk','+ZP_ITEM',    .T.,      ,       ,      ,9999,        ,         ,       ,      ,    )
		//-- Parametros MsGetDados(            nT,              nL,             nB,              nR,     nOpc,       cLinhaOk,        cTudoOk,  cIniCpos,lDeleta,aAlter,nFreeze,lEmpty,nMax,cFieldOk,cSuperDel,aTeclas,cDelOk,oWnd)

		//-- Dados do RodaPe
		@ aPosObj[3,1] , aPosObj[3,2] To aPosObj[3,3],aPosObj[3,4] Label ' Totais ' Pixel Of oPanel2

		@ aPosObj[3,1]+010,010	Say	"Itens: "		Of	oPanel2	Pixel
		@ aPosObj[3,1]+010,210	Say	"Quantidade: "	Of	oPanel2	Pixel
		@ aPosObj[3,1]+010,410	Say	"Valor: "		Of	oPanel2	Pixel

		@ aPosObj[3,1]+010,050	Say	oSay1	PROMPT	Transform(nTotDifItens,"@E 99999.99")		Of oPanel2	Pixel
		@ aPosObj[3,1]+010,250	Say	oSay2	PROMPT	Transform(nTotQtdItens,"@E 99999.99")		Of oPanel2	Pixel
		@ aPosObj[3,1]+010,450	Say	oSay3	PROMPT	Transform(nTotVlrAf   ,"@E 999,999,999.99")	Of oPanel2	Pixel

	Activate MsDialog	oDlgEsp On Init;
						EnchoiceBar(oDlgEsp,{||nOpca:=1,If(oGetD:TudoOk(),oDlgEsp:End(),nOpca:=0)},{||oDlgEsp:End()},,aButtons)
		//-- Parametros EnchoiceBar(1-Objeto da Janela Principal,2-Sera executado se pressionado Ok,3-Botao Cancela,,5-Para acrescentar botoes na barra

	If nOpcx != 2
		If nOpcA == 1
			JMH230Grv( nOpcx )
			If __lSX8  // RETORNA .T. SE ALGUM CAMPO TEM NUMERACAO AUTOMATICA
				ConfirmSX8() // CONFIRMA O INCREMENTO +1 NO NUMERADOR AUTOMATICO
			EndIf
		Else
			If __lSX8
				RollbackSX8() // CANCELA O INCREMENTO +1 NO NUMERADOR AUTOMATICO
			EndIf
		Endif
	EndIf

	SetKey(VK_F7,Nil)

Return(nOpca)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณJMH2300Linณ Autor ณ FABIO BRIDDI          ณ Data ณ19/02/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Validacoes da linha da GetDados                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ JMH230LINOK()                                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

User Function JMH230LinOk()

	Local lRet := .T.

	//-- Nao avalia linhas deletadas.
	If	!GDDeleted( n ) // Retorna se a Linha esta deletada, (n) Linha da posicao do GetDados
		//-- Analisa se ha itens duplicados na GetDados.
//		lRet := GDCheckKey( { 'ZF6_CERTIF' }, 4 ) // Vereifica se nao ha chave duplicada, 4 -> Mensagem padrao
	EndIf

	//-- Analisa se os campos obrigatorios da Enchoice foram informados.
	lRet := Obrigatorio( aGets, aTela )

	TotRodaPe()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณJMH230TudOkณ Autor ณ FABIO BRIDDI         ณ Data ณ19/02/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Validacao Geral                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ JMH230TUDOK()                                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

User Function JMH230TudOk()

	Local lRet		:= .T.

	//-- Analisa se os campos obrigatorios da Enchoice foram informados.
	lRet := Obrigatorio( aGets, aTela )

	If	lRet

		If	M->ZO_TIPO = "1"

			If	Empty(M->ZO_CLIFAT)  .Or.;
				Empty(M->ZO_LOJFAT)  .Or.;
				Empty(M->ZO_VEND1)   .Or.;
				Empty(M->ZO_COND)    .Or.;
				Empty(M->ZO_CC)      .Or.;
				Empty(M->ZO_ITEMCTB) .Or.;
				Empty(M->ZO_OPERFAT)

				cMsgAviso := "Campos Aba Faturamento em Branco:" + CRLF

				cMsgAviso += IIf( Empty(M->ZO_CLIFAT).Or.Empty(M->ZO_LOJFAT),"Cliente/Loja p/ Faturamento" + CRLF, "")
				cMsgAviso += IIf( Empty(M->ZO_VEND1)   , "Vendedor"     + CRLF, "")
				cMsgAviso += IIf( Empty(M->ZO_COND)    , "Cond Pgto"    + CRLF, "")
				cMsgAviso += IIf( Empty(M->ZO_CC)      , "C.C. P.Venda" + CRLF, "")
				cMsgAviso += IIf( Empty(M->ZO_ITEMCTB) , "Item Contab." + CRLF, "")
				cMsgAviso += IIf( Empty(M->ZO_OPERFAT) , "Tp. Operacao" + CRLF, "")

				Aviso( "Inconsist๊ncia Dados:", cMsgAviso, {"Ok"}, 3 )

				lRet := .F.

//			Else
// CRISTIANO OLIVEIRA - 03/11/2017 - LIBERADO VALIDAR CC
//				SA3->( dbSetOrder(1) )
//				SA3->( dbSeek(xFilial('SA3')+M->ZO_VEND1) )
//				If !( AllTrim(M->ZO_CC) $ AllTrim(SA3->A3_CCUSTO) ) -- DESCONTINUADO, CC agora ้ CLVL
//				If !( AllTrim(POSICIONE("SB1", 1, "  " + SZP->ZP_NUM, "B1_CLVL")) $ AllTrim(SA3->A3_CCUSTO) )
//					cMsgAviso := "Classe de valor invแlida para este representante!" + CRLF
//					cMsgAviso += "Classe de valor vแlida: " + Alltrim(SA3->A3_CCUSTO) + CRLF
//					Aviso( "Inconsist๊ncia Dados:", cMsgAviso, {"Ok"}, 3 )
//					lRet := .F.
//					lRet := .T.
//				EndIf

			EndIf

		EndIf

	EndIf

	//-- Analisa se os campos obrigatorios da GetDados foram informados.
	If	lRet
		lRet := oGetD:ChkObrigat( n )
	EndIf

	//-- Analisa o linha ok.
	If lRet
		lRet := U_JMH230LinOk()
	EndIf
	//-- Analisa se todas os itens da GetDados estao deletados.
	If lRet .And.;
		aScan( aCols, { |x| x[ Len( x ) ] == .F. } ) == 0 // ASCAN: LOCALIZA UM CONTEUDO DNTRO DE UM ARRAY, RETORNA A POSICAO DA LOCALIZACAO
		Help( " ", 1, "OBRIGAT2")
		lRet := .F.
	EndIf

Return( lRet )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ JMH230Grv ณ Autor ณ FABIO BRIDDI         ณ Data ณ19/02/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Gravar dados                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ OPCAO                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function JMH230Grv( nOpcx )

	Local bCampo  := { |nCpo| Field(nCpo) }
	Local nCntFor := 0
	Local lInclui := .T.

	cNumAf := M->ZO_NUM

	If	nOpcx == 5				//-- Excluir
		Begin Transaction

	        dbSelectArea("SZO")
			dbSetOrder( 1 ) //-- AD2_FILIAL+AD2_COD+AD2_ITEM
			dbSeek( xFilial( "SZO" ) + cNumAf, .F. ) // dbSEEK(FILIAL,CHAVE,.F.->EXATAMENTE)

			RecLock("SZO",.F.) // .F. ALTERANDO, .T. INCLUINDO UM REGISTRO
				SZO->(dbDelete())
			MsUnLock()

			dbSelectArea("SZP")
			dbSetOrder( 1 ) //-- AD2_FILIAL+AD2_COD+AD2_ITEM
			dbSeek( xFilial( "SZP" ) + cNumAf, .F. ) // dbSEEK(FILIAL,CHAVE,.F.->EXATAMENTE)

			Do While SZP->ZP_FILIAL + SZP->ZP_NUM == xFilial( "SZP" ) + cNumAf .AND. !EOF()

				RecLock("SZP",.F.) // .F. ALTERANDO, .T. INCLUINDO UM REGISTRO
					SZP->(dbDelete())
				MsUnLock()

				dbSkip()
			EndDo

		End Transaction

	EndIf

	If	nOpcx == 3 .Or. nOpcx == 4			//-- Incluir ou Alterar
		Begin Transaction
			//-- Grava o cabecalho
	        dbSelectArea("SZO")
			dbSetOrder( 1 )

			If	SZP->( dbSeek( xFilial("SZO") + cNumAf, .F. ) )
				lInclui := .F.
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o Cabecalho da AF/AD                                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

			RecLock("SZO", lInclui)

				For nCntFor := 1 TO FCount()
					If	( "FILIAL" $ FieldName(nCntFor) )
						FieldPut( nCntFor, xFilial("SZO" ))
					Else
						FieldPut( nCntFor, M->&(EVAL(bCampo,nCntFor) ))
					EndIf
				Next nCntFor

				SZO->ZO_STATUS	:=	"1"
				SZO->ZO_PEDIDO  :=	""

			MsUnLock()

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza os Itens da AF/AD                                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	        dbSelectArea("SZP")
			dbSetOrder( 1 )

			For nCntFor := 1 To Len( aCols )

				If	!GDDeleted( nCntFor )		// SE LINHA NAO ESTA DELETADA PODE SER GRAVADA

					If	SZP->( dbSeek( xFilial("SZP") + cNumAf + GDFieldGet( "ZP_ITEM", nCntFor ), .F. ) )
						lInclui := .F.
					Else
						lInclui := .T.
					EndIf

					RecLock("SZP", lInclui)

						For nCntHead := 1 to Len(aHeader)

							If aScan( aNoGetFields, AllTrim(SX3->X3_CAMPO) ) = 0

								If	aHeader[nCntHead][10] <> "V"
									SZP->( FieldPut( FieldPos( aHeader[nCntHead][2]), aCols[nCntFor][nCntHead] ) )
								EndIf

							EndIf

						Next nY

						SZP->ZP_FILIAL	:=	xFilial("SZP")
						SZP->ZP_NUM		:=	M->ZO_NUM
						SZP->ZP_CLIENTE	:=	M->ZO_CLIENTE
						SZP->ZP_LOJA	:=	M->ZO_LOJA
						SZP->ZP_AFCLI	:=	M->ZO_AFCLI
						SZP->ZP_TIPO	:=	M->ZO_TIPO
						SZP->ZP_STATUS	:=	"1"
						SZP->ZP_NFENTRA	:=	""
						SZP->ZP_SERENTR	:=	""

					MsUnLock()

				Else

					If	SZP->( MsSeek( xFilial("SZP") + cNumAf + GDFieldGet( "ZP_ITEM", nCntFor ), .F. ) )

						RecLock("SZP",.F.)
							SZP->(dbDelete())
						MsUnLock()

					EndIf

				EndIf

			Next

		End Transaction

	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ A230Leg ณ Autor ณ FABIO BRIDDI         ณ Data ณ19/02/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Legenda                                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ OPCAO                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
User Function A230Leg( cAlias, nRecno, nOpc)

	Local aLegenda := {}

	aAdd(aLegenda,{"BR_LARANJA","A.F. Digitada"            })
	aAdd(aLegenda,{"BR_PINK"   ,"A.D. Consigna็ใo Digitada"})
	aAdd(aLegenda,{"BR_CINZA"  ,"A.D. Venda Digitada"      })
	aAdd(aLegenda,{"DISABLE"   ,"Autoriza็ใo Acertada"     })

	BrwLegenda(cCadastro,"Status Documetos:",alegenda)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValCliente()

	Local	lRet := .T.
	dbSelectArea("SA1")
	dbSetOrder(1)
	If	dbSeek(xFilial("SA1")+cCodCli)
		cNomCli := SA1->A1_NOME
		cLojCli	:= SA1->A1_LOJA
	Else
		Iw_MsgBox("Cliente Nใo Cadstrado","Chave Nใo Encontrada","INFO")
		lRet := .F.
	EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValLoja()

	Local	lRet := .T.

	dbSelectArea("SA1")
	dbSetOrder(1)

	If dbSeek(xFilial("SA1")+cCodCli+cLojCli)
		cNomCli  :=	SA1->A1_NOME
	Else
		Iw_MsgBox("Cliente Nใo Cadstrado","Chave Nใo Encontrada","INFO")
		lRet := .F.
	EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A230TpDoc( cTipoDoc )

	Local	lRet := .T.

	If		Empty(cTipoDocAnt) .Or. cTipoDoc == cTipoDocAnt

			cTipoDocAnt := cTipoDoc

	ElseIf	!Empty(cTipoDocAnt) .And. (cTipoDoc <> cTipoDocAnt)

			If	Iw_MsgBox(	"Alterando o Tipo de Documento," + CRLF +;
							"Todos os Itens Digitados Serใo Excluํdos." + CRLF +;
							"" + CRLF +;
							"Confirma Altera็ใo Tipo de Documento ?",;
							"Inclusใo AD/AF","YESNO")

				A230ZItens()
				cTipoDocAnt := cTipoDoc

			Else

				M->ZO_TIPO := cTipoDocAnt
				lRet       := .F.

			EndIf

	EndIf

	oEnch:Refresh()

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A230TrCli( cCodCli, cLojCli)

Local	lRet := .T.

	If		(Empty(cCodCliAnt) .Or. Empty(cLojCliAnt)) // .Or. (cCodCli+cLojCli == cCodCliAnt+cLojCliAnt)
			cCodCliAnt  := cCodCli
			cLojCliAnt  := cLojCli

	ElseIf	(!Empty(cCodCliAnt+cLojCliAnt)) .And. (cCodCli+cLojCli <> cCodCliAnt+cLojCliAnt)
			If	Iw_MsgBox(	"Alterando o Cliente/Loja," + CRLF +;
							"Todos os Itens Digitados Serใo Excluํdos." + CRLF +;
							"" + CRLF +;
							"Confirma Altera็ใo Cliente ?",;
							"Inclusใo AD/AF","YESNO")

				A230ZItens()
				cCodCliAnt  := cCodCli
				cLojCliAnt  := cLojCli

			Else
//				cCodCli     := cCodCliAnt
//				cLojCli     := cLojCliAnt
				M->ZO_CLIENTE := cCodCliAnt
				M->ZO_LOJA    := cLojCliAnt
				lRet          := .F.

			EndIf

	EndIf

	oEnch:Refresh()

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A230ZItens()

	aCols	:= {}
	n := 1
	aAdd(aCols,Array(nUsado+1)) // Carrego a posicao do aCols como NIL
	For nCntFor := 1 To nUsado
		If ( aHeader[nCntFor][10] != "V" ) // Pego campo somente que eh REAL
			aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
		Else // Se for campo virtual inicializa com conteudo do campo
			aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
		EndIf
	Next
	aCols[Len(aCols)][Len(aHeader)+1] := .F. // Marco a linha como NAO deletado

	//-- Inicializa o item da getdados se a linha estiver em branco.
	If Len( aCols ) == 1 .And. Empty( GDFieldGet( "ZP_NUM", 1 ) ) // Retorna o conteudo do campo
		GdFieldPut( "ZP_ITEM"  , StrZero(1,Len(SZP->ZP_ITEM)), 1 ) // Coloca no campo o seu conteudo
	EndIf

	TotRodaPe()

	oGetD:oBrowse:Refresh(.T.)

Return( )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AbreLinhas( lTotal )

	Local aColsAux := {}

	For nX := 1 To Len(aListP3)
		If aListP3[nX,P_MARK] .And. aListP3[nX,P_QTDACER] > 0
			aAdd(aColsAux,Array(nPosDeletado))
			If	lTotal
//				cCodProd := aListP3[nX,P_PRODUTO]
			EndIf
			aColsAux[Len(aColsAux),nPosDeletado] := .F.
			aColsAux[Len(aColsAux),nPosItem]     := StrZero(Len(aColsAux),4)
			aColsAux[Len(aColsAux),nPosProduto]  := aListP3[nX,P_PRODUTO]
			aColsAux[Len(aColsAux),nPosUmOrig]   := aListP3[nX,P_UMORIG]
			aColsAux[Len(aColsAux),nPosNfOrig]   := aListP3[nX,P_NFORIG]
			aColsAux[Len(aColsAux),nPosSerOrig]  := aListP3[nX,P_SERORIG]
			aColsAux[Len(aColsAux),nPosIteOrig]  := aListP3[nX,P_ITEORIG]
			aColsAux[Len(aColsAux),nPosLocOrig]  := aListP3[nX,P_LOCORIG]
			aColsAux[Len(aColsAux),nPosTesOrig]  := aListP3[nX,P_TESORIG]
			aColsAux[Len(aColsAux),nPosTesDv]    := aListP3[nX,P_TESDV]
			aColsAux[Len(aColsAux),nPosQtde]     := aListP3[nX,P_QTDACER]
			aColsAux[Len(aColsAux),nPosPrUnit]   := aListP3[nX,P_PRCUNIT]
			aColsAux[Len(aColsAux),nPosPrcVen]   := aListP3[nX,P_PRCVEND]
			aColsAux[Len(aColsAux),nPosDescont]  := aListP3[nX,P_DESCONT]
			aColsAux[Len(aColsAux),nPosTotal]    := (aListP3[nX,P_PRCVEND] * aListP3[nX,P_QTDACER])
			aColsAux[Len(aColsAux),nPosB6Ident]  := aListP3[nX,P_B6IDENT]
			aColsAux[Len(aColsAux),nPosRastro]   := aListP3[nX,P_RASTRO]
			aColsAux[Len(aColsAux),nPosLoteUni]  := aListP3[nX,P_LOTEUNI]
			aColsAux[Len(aColsAux),nPosLoteCtl]  := aListP3[nX,P_LOTECTL]
			aColsAux[Len(aColsAux),nPosLoteFor]  := aListP3[nX,P_LOTEFOR]
			aColsAux[Len(aColsAux),nPosDtValid]  := aListP3[nX,P_DTVALID]

		EndIf
	Next

	If Len(aColsAux) > 0
		_aCols2 := AClone(aCols)
		aCols	:= {}
		For nY := 1 To Len(_aCols2)
			If !_aCols2[nY,nPosDeletado]
				If nY = n
					For nZ := 1 To Len(aColsAux)
						aAdd(aCols,aColsAux[nZ])
						aCols[Len(aCols),nPosItem] := StrZero(Len(aCols),4)
					Next
				Else
					aAdd(aCols,_aCols2[nY])
					aCols[Len(aCols),nPosItem] := StrZero(Len(aCols),4)
				EndIf
			EndIf
		Next

		TotRodaPe()

	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MarcaLinha( nIt, lAbre )

	Local nQtdeAce := 0
	nQtdItem := 0

	If	lAbre
		If	!(aListP3[nIt,P_MARK])
			If	(aListP3[nIt,P_LOTEUNI] = "S") .Or. (aListP3[nIt,P_SALDOB6] = 1)
				nQtdeAce := 1
			Else
				nQtdeAce := GetQtde(nIt)
			EndIf

			If	nQtdeAce > 0
				aListP3[nIt,P_MARK] := .T.
				aListP3[nIt,P_QTDACER] := nQtdeAce
			EndIf
		Else
			aListP3[nIt,P_MARK] := .F.
			aListP3[nIt,P_QTDACER] := 0
		EndIf
	Else
		If	!aListP3[nIt,P_MARK]
			aListP3[nIt,P_MARK] := .T.
			aListP3[nIt,P_QTDACER] := aListP3[nIt,P_SALDOB6]
		Else
			aListP3[nIt,P_MARK] := .F.
			aListP3[nIt,P_QTDACER] := 0
		EndIf
	EndIf

	For	_x := 1 To Len(aListP3)
		If aListP3[_x,P_MARK] .And. (aListP3[nIt,P_PRODUTO] = aListP3[_X,P_PRODUTO])
			nQtdItem += aListP3[_x,P_QTDACER]
		EndIf
	Next

	oQtdItem:SetText(Transform(nQtdItem,"@E 999.99"))

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GetQtde(nLi)

	Local oDlgVal
	Local nSaldo   := aListP3[nLi,P_SALDOB6]
	Local nQtdeOri := aListP3[nLi,P_QTDORIG]
	Local nQtdeAce := aListP3[nLi,P_QTDACER]

	Define MsDialog oDlgVal Title "Quantidade a Acertar" From 000,000 To 150,300 Of oMainWnd Pixel

		@  015, 005 Say  "Qtde Original" Pixel
		@  015, 065 MsGet oGetA var nQtdeOri Size 75,08 Of oDlgVal Picture "@E 999,999,999.99" Pixel When .F.

		@  030, 005 Say  "Sld Cliente - AF" Pixel
		@  030, 065 MsGet oGetB var nSaldo Size 75,08 Of oDlgVal Picture "@E 999,999,999.99" Pixel When .F.


		@  045, 005 Say  "Qtde a Acertar" Pixel
		@  045, 065 MsGet oGetC var nQtdeAce Size 75,08 Of oDlgVal Picture "@E 999,999,999.99" Pixel Valid (nQtdeAce <= nSaldo)

		Define SButton oDtn1 From 125/2,090/2 Type 1 Of oDlgVal Action (oDlgVal:End()) Pixel Enable
		Define SButton oDtn2 From 125/2,155/2 Type 2 Of oDlgVal Action (nQtdeAce:=0,oDlgVal:End()) Pixel Enable

	Activate Dialog oDlgVal center

Return(nQtdeAce)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function JMH230Rpt( cAlias, nReg, nOpcx )

	U_ARTR230(SZP->ZP_NUM)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TotRodaPe()

	nTotDifItens	:= 0
	nTotQtdItens	:= 0
	nTotVlrAf		:= 0
	cProdAnt		:= ""
	For nY := 1 To Len(aCols)
		If !aCols[nY,nPosDeletado]
			If	cProdAnt <> aCols[nY,nPosProduto] .And. !Empty(aCols[nY,nPosProduto])
				nTotDifItens++
				cProdAnt := aCols[nY,nPosProduto]
			EndIf
		EndIf
		nTotQtdItens	+= aCols[nY,nPosQtde]
		nTotVlrAf		+= aCols[nY,nPosTotal]
	Next

	oSay1:SetText(Transform(nTotDifItens,"@E 99999.99"))
	oSay2:SetText(Transform(nTotQtdItens,"@E 99999.99"))
	oSay3:SetText(Transform(nTotVlrAf   ,"@E 999,999,999.99"))

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JMHA230 - Jomhedica - Estoque/Custos                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function P3JMHA230()

	Local bSavKeyF7 := SetKey(VK_F7,Nil)
	Local nLbOpc	:= 0
	Local lRet		:= .T.
	Local lOk		:= .T.

	Local cCodCli   := M->ZO_CLIENTE
	Local cLojCli   := M->ZO_LOJA
	Local cTipoDoc  := M->ZO_TIPO
	Local cNomCli   := M->ZO_NOMCLI

	Private oListP3
	Private oDlgP3
	Private aListP3  := {}

	Private oOk   := Loadbitmap(GetResources(), "CHECKED")
	Private oNo   := Loadbitmap(GetResources(), "UNCHECKED")
//	Private oOk   := Loadbitmap(GetResources(), "LBOK")
//	Private oNo   := Loadbitmap(GetResources(), "LBNO")

	cCodProd := aCols[n,nPosProduto]

	nQtdItem := 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida Dados Cabecalho                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lOk := A230VCabec()

/*
	If Empty(cCodCli) .Or. Empty(cLojCli)
		Iw_MsgBox("Informe: C๓digo Cliente + Loja","Dados Incorretos","INFO")
		lOk := .F.
	EndIf
*/

	If !(Left(cTipoDoc,1) $ "12")
		Iw_MsgBox("Op็ใo Invแlida para Documento","INFO")
		lOk := .F.
	EndIf

	If Empty(cCodProd)
		Iw_MsgBox("Informe: C๓digo Produto","Dados Incorretos","INFO")
		lOk := .F.
	EndIf

	If n < Len(aCols)
		Iw_MsgBox("Linha Invแlida","Dados Incorretos","INFO")
		lOk := .F.
	EndIf

	If	!lOk
		SetKey(VK_F7,bSavKeyF7)
		Return(lRet)
	EndIf

	cQuery := "SELECT  B6_DOC, B6_SERIE, B6_PRODUTO, B6_TES, B6_QUANT, B6_SALDO, B6_IDENT, "
	cQuery +=        " D2_ITEM, D2_UM, D2_LOCAL, D2_EMISSAO, D2_PRUNIT, D2_PRCVEN, D2_DESC, D2_LOTECTL, D2_DTVALID, "
	cQuery +=        " B1_RASTRO, "
	cQuery +=        " F4_TESDV, "
	cQuery +=        " COALESCE(B8_LOTEUNI,'N') AS B8_LOTEUNI, COALESCE(B8_LOTECTL,'') AS B8_LOTECTL, COALESCE(B8_LOTEFOR,'') AS B8_LOTEFOR, COALESCE(B8_DTVALID,'') AS B8_DTVALID " + CRLF

	//-- SB6 -> Controle Poder de Terceiros - Tabela Principal
	// Jorge Alberto - Solutio - 22/05/2018 - Alteracoes:
	// 1. Incluido o comando ao lado do alias SB6 para que o sistema use o indice SB60102 e nao o WC_IDX_19
	// 2. Alterado os   D_E_L_E_T_ <> '*'   para   D_E_L_E_T_  = ' '
	cQuery += "FROM	" + RetSqlName("SB6") + " SB6 WITH ( INDEX( " + AllTrim( RetSqlName("SB6") ) + "2 ) ) " + CRLF

	//-- SB1 -> Cadastro de Produtos
	cQuery += "INNER   JOIN " + RetSqlName("SB1") + " SB1 " + CRLF
	cQuery += "ON      SB1.B1_FILIAL   =  '" + xFilial("SB1") + "' " + CRLF
	cQuery += "AND     SB1.B1_COD      =  SB6.B6_PRODUTO " + CRLF
	cQuery += "AND     SB1.D_E_L_E_T_  =  ' ' " + CRLF

	//-- SD2 -> Itens Nota Fiscal - Dados do Envio P3
	cQuery += "INNER   JOIN " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery += "ON      SD2.D2_FILIAL   =  SB6.B6_FILIAL " + CRLF
	cQuery += "AND     SD2.D2_IDENTB6  =  SB6.B6_IDENT " + CRLF
	cQuery += "AND     SD2.D2_COD      =  SB6.B6_PRODUTO " + CRLF
	cQuery += "AND     SD2.D2_DOC      =  SB6.B6_DOC " + CRLF
	cQuery += "AND     SD2.D2_SERIE    =  SB6.B6_SERIE " + CRLF
	cQuery += "AND     SD2.D_E_L_E_T_  =  ' ' " + CRLF

	//-- SF4 -> Cadastro de TES
	cQuery += "INNER   JOIN " + RetSqlName("SF4") + " SF4 " + CRLF
	cQuery += "ON      SF4.F4_FILIAL   =  '" + xFilial("SF4") + "' " + CRLF
	cQuery += "AND     SF4.F4_CODIGO   =  SD2.D2_TES " + CRLF
	cQuery += "AND     SF4.D_E_L_E_T_  =  ' ' " + CRLF

	//-- SB8 -> Controle de Lotes
	cQuery += "LEFT    JOIN " + RetSqlName("SB8") + " SB8 " + CRLF
	cQuery += "ON      SB8.B8_FILIAL   =  SB6.B6_FILIAL " + CRLF
	cQuery += "AND     SB8.B8_PRODUTO  =  SB6.B6_PRODUTO " + CRLF
	cQuery += "AND     SB8.B8_LOTECTL  =  SD2.D2_LOTECTL" + CRLF
	cQuery += "AND     SB8.B8_DTVALID  =  SD2.D2_DTVALID" + CRLF
	cQuery += "AND     SB8.D_E_L_E_T_  =  ' ' " + CRLF

	//-- SB6 -> Controle Poder de Terceiros - Tabela Principal
	cQuery += "WHERE   SB6.B6_FILIAL   =  '" + xFilial("SB6") + "' " + CRLF
	cQuery += "AND     SB6.B6_CLIFOR   =  '" + cCodCli        + "' " + CRLF
	cQuery += "AND     SB6.B6_LOJA     =  '" + cLojCli        + "' " + CRLF
	cQuery += "AND     SB6.B6_PRODUTO  =  '" + cCodProd       + "' " + CRLF
	cQuery += "AND     SB6.B6_SALDO    >  0 " + CRLF
	cQuery += "AND     SB6.B6_PODER3   =  'R' " + CRLF
	cQuery += "AND     SB6.B6_ATEND   <>  'S' " + CRLF
	cQuery += "AND     SB6.D_E_L_E_T_  =  ' ' " + CRLF

	cQuery += "ORDER BY B6_FILIAL, B8_LOTECTL, D2_SERIE , D2_DOC, D2_EMISSAO , ( REPLICATE( '0', 9 - LEN( B6_DOC ) ) + B6_DOC ) "
	//cQuery += "ORDER BY B6_FILIAL, B6_PRODUTO, B8_DTVALID, B8_LOTECTL, ( REPLICATE( '0', 9 - LEN( B6_DOC ) ) + B6_DOC ) "

	MemoWrite("\_QUERIES\JMHA230P3.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB01",.T.,.T.)
	TcSetField("TRB01", "D2_EMISSAO", "D", 8, 0)
	TcSetField("TRB01", "D2_DTVALID", "D", 8, 0)
	dbSelectArea("TRB01")
	dbGoTop()
	If !EOF()
		Do While !EOF()

			//-- Pego na SZP os Totais
			cQuery1 := "SELECT	ISNULL(SUM(ZP_QTDE),0) AS TOTZP " + CRLF
			cQuery1 += "FROM	" + RetSqlName("SZP") + " SZP " + CRLF
			cQuery1 += "WHERE   SZP.ZP_CLIENTE   =  '" + cCodCli           + "' " + CRLF
			cQuery1 += "AND     SZP.ZP_LOJA      =  '" + cLojCli           + "' " + CRLF
			cQuery1 += "AND     SZP.ZP_PRODUTO   =  '" + TRB01->B6_PRODUTO + "' " + CRLF
			cQuery1 += "AND     SZP.ZP_B6IDENT   =  '" + TRB01->B6_IDENT   + "' " + CRLF
			cQuery1 += "AND     SZP.ZP_NFORIG    =  '" + TRB01->B6_DOC     + "' " + CRLF
			cQuery1 += "AND     SZP.ZP_SERORIG   =  '" + TRB01->B6_SERIE   + "' " + CRLF
			cQuery1 += "AND     SZP.ZP_ITEORIG   =  '" + TRB01->D2_ITEM    + "' " + CRLF
			cQuery1 += "AND     SZP.ZP_TIPO      IN ('1','2') " + CRLF
			cQuery1 += "AND     SZP.ZP_STATUS    =  '1' " + CRLF
			cQuery1 += "AND     SZP.ZP_NUM       <> '" + cNumAf            + "' " + CRLF
			cQuery1 += "AND     SZP.D_E_L_E_T_   <> '*' " + CRLF
			MemoWrite("\_Queries\JMHA230P3SZPB.SQL",cQuery1)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TRB02",.T.,.T.)
			dbSelectArea("TRB02")
			dbGoTop()
			nTotSZP:=TRB02->TOTZP
			TRB02->(dbCloseArea())

			dbSelectArea("TRB01")

			nQtdeAcols := 0
			For	nInd := 1 To Len(aCols)
				If	!aCols[nInd , Len(aHeader)+1]
					If	aCols[nInd,nPosProduto] = TRB01->B6_PRODUTO .And.;
						aCols[nInd,nPosNfOrig]  = TRB01->B6_DOC     .And.;
						aCols[nInd,nPosSerOrig] = TRB01->B6_SERIE   .And.;
						aCols[nInd,nPosB6Ident] = TRB01->B6_IDENT
						nQtdeAcols += aCols[nInd,nPosQtde]
					EndIf
				EndIf
			Next
			nSaldo := TRB01->B6_SALDO - NTOTSZP - nQtdeAcols

			If nSaldo > 0

				aAdd( aListP3 , Array(TAM_LISTBOX) )
				aListP3[Len(aListP3),P_MARK]    := .F.
				aListP3[Len(aListP3),P_PRODUTO] := TRB01->B6_PRODUTO
				aListP3[Len(aListP3),P_SERORIG] := TRB01->B6_SERIE
				aListP3[Len(aListP3),P_NFORIG]  := TRB01->B6_DOC
				aListP3[Len(aListP3),P_ITEORIG] := TRB01->D2_ITEM
				aListP3[Len(aListP3),P_UMORIG]  := TRB01->D2_UM
				aListP3[Len(aListP3),P_LOCORIG] := TRB01->D2_LOCAL
				aListP3[Len(aListP3),P_EMIORIG] := TRB01->D2_EMISSAO
				aListP3[Len(aListP3),P_TESORIG] := TRB01->B6_TES
				aListP3[Len(aListP3),P_TESDV]   := TRB01->F4_TESDV
				aListP3[Len(aListP3),P_QTDORIG] := TRB01->B6_QUANT
				aListP3[Len(aListP3),P_SALDOB6] := nSaldo
				aListP3[Len(aListP3),P_QTDACER] := nSaldo	// nSaldo ou 0 (Zero) ??
				aListP3[Len(aListP3),P_PRCUNIT] := TRB01->D2_PRUNIT
				aListP3[Len(aListP3),P_PRCVEND] := TRB01->D2_PRCVEN
				aListP3[Len(aListP3),P_DESCONT] := TRB01->D2_DESC
				aListP3[Len(aListP3),P_B6IDENT] := TRB01->B6_IDENT
				aListP3[Len(aListP3),P_RASTRO]  := TRB01->B1_RASTRO		//-- Se Item Controla Rastro por Lote (B1_RASTRO = L)
				aListP3[Len(aListP3),P_LOTEUNI] := TRB01->B8_LOTEUNI	//-- Se Item faz parte de um Lote Unico (B8_LOTEUNI = S)
				aListP3[Len(aListP3),P_LOTECTL] := TRB01->D2_LOTECTL
				aListP3[Len(aListP3),P_LOTEFOR] := TRB01->B8_LOTEFOR
				aListP3[Len(aListP3),P_DTVALID] := TRB01->D2_DTVALID

			EndIf

			dbSkip()

		EndDo

	EndIf

	TRB01->(dbCloseArea())

	If	Len(aListP3) > 0

		oDlgP3 := MSDialog():New( 0000, 0000, 0500, 1000, OemToAnsi("Documentos de Origem") ,,,,,,,,,.T.,,, )

			oFntTxt := TFont():New("Arial",,-16,.T.)

			oPanel1 := TPanel():Create( oDlgP3, 005, 005, "", , , , , , 490, 030 )
			oGroup1 := TGroup():New( 000, 000, 030, 490, "", oPanel1,,,.T.)

			cTexto1 := "Cliente/Loja: " + cCodCli + "/" + cLojCli + " - " + cNomCli
			cTexto2 := "Produto: " + Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC")

			oTexto1 := TSay():New(	007, 005, {|| cTexto1 }, oGroup1, , oFntTxt, , , , .T., CLR_BLUE, CLR_WHITE, 340, 010 )
			oTexto2 := TSay():New(	017, 005, {|| cTexto2 }, oGroup1, , oFntTxt, , , , .T., CLR_BLUE, CLR_WHITE, 340, 010 )

			oListP3 := TWBrowse():New( 040, 005, 490, 180, , , , oDlgP3, , , , , {||}, , , , , , , .F., , .T., , .F., , , )

			oListP3:SetArray(aListP3)
			oListP3:aHeaders  := {	"", "Emissใo", "Serie", "Nota", "Item", "TES Ren", "TES Dev", "Qtde Orig", "Saldo", "Qtde a Acertar", "Lote", "Validade", "L. Forn.", "Pre็o Tabela", "Pre็o Unit", "Desconto", "" }
			oListP3:bLine:={ || {	If( aListP3[oListP3:nAt,P_MARK],oOk,oNo),;
									TransForm(aListP3[oListP3:nAt,P_EMIORIG] ,"@E"),;
									aListP3[oListP3:nAt,P_SERORIG],;
									aListP3[oListP3:nAt,P_NFORIG],;
									aListP3[oListP3:nAt,P_ITEORIG],;
									aListP3[oListP3:nAt,P_TESORIG],;
									aListP3[oListP3:nAt,P_TESDV],;
									TransForm(aListP3[oListP3:nAt,P_QTDORIG] ,"@E 999,999.99"),;
									TransForm(aListP3[oListP3:nAt,P_SALDOB6]   ,"@E 999,999.99"),;
									TransForm(aListP3[oListP3:nAt,P_QTDACER] ,"@E 999,999.99"),;
									aListP3[oListP3:nAt,P_LOTECTL],;
									TransForm(aListP3[oListP3:nAt,P_DTVALID] ,"@E"),;
									aListP3[oListP3:nAt,P_LOTEFOR],;
									TransForm(aListP3[oListP3:nAt,P_PRCUNIT] ,"@E 999,999.99"),;
									TransForm(aListP3[oListP3:nAt,P_PRCVEND] ,"@E 999,999.99"),;
									TransForm(aListP3[oListP3:nAt,P_DESCONT] ,"@E 999,999.99"),;
									"" } }
			oListP3:bLDblClick := {|| MarcaLinha( oListP3:nAt,.T.), (oListP3:Refresh()) }

			oListP3:Refresh()

			@ 230, 005 Say "Selecionados: " Of oDlgP3 Pixel
			@ 230, 100 Say oQtdItem PROMPT Transform(nQtdItem,"@E 999.99") Of oDlgP3 Pixel

			bCancel    := { || (nLbOpc := 0,oDlgP3:End()) }
			bOk        := { || (nLbOpc := 1,oDlgP3:End()) }
			oTBtCancel := TButton():New( 230, 450,      "&Sair", oDlgP3, bCancel ,40, 15, , ,.F., .T., .F., , .F., , ,.F. )
			oTBtOk     := TButton():New( 230, 400, "&Confirmar", oDlgP3, bOk     ,40, 15, , ,.F., .T., .F., , .F., , ,.F. )

		oDlgP3:Activate( {||.T.} , , ,.T., , , )

		If nLbOpc = 1
			AbreLinhas( .F. )
		EndIf

	Else

		Iw_MsgBox("Nใo hแ Notas Fiscais referente este Cliente e Produto para serem acertadas.","Aten็ใo !","INFO")

	EndIf

	SetKey(VK_F7,bSavKeyF7)

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ                  ณFabio Briddi        บ Data ณ  Maio/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre a tela da nota fiscal de entrada de acordo com a      บฑฑ
ฑฑบ          ณ AD/AF escolhida no browse                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ ExpC1 = Alias do arquivo                                   บฑฑ
ฑฑบ          ณ ExpN1 = Numero do registro                                 บฑฑ
ฑฑบ          ณ ExpN2 = Numero da opcao selecionada                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A230Efetivar(cAlias,nReg,nOpcx)

	Local aArea        := GetArea()
	Local aAreaSF2     := SF2->(GetArea())
	Local aCab         := {}
	Local aLinha       := {}
	Local aItens       := {}
	Local cAliasSD2    := "SD2"
	Local cAliasSF4    := "SF4"
	Local cQuery       := ""
	Local cTipoDoc     := SZO->ZO_TIPO
	Local cNumAf       := SZO->ZO_NUM
	Local cCliFat      := SZO->ZO_CLIFAT
	Local clojFat      := SZO->ZO_LOJFAT
	Local lNfEntOk	   := .F.
	Local aRetPV       := { .F., "Nใo Executado", "" }
	Local lForm        := Empty(SZO->ZO_NFENTRA) //-- Abre Nota de Entrada para Confirma็ใo

	Private cTipo      := ""
	Private cFormul    := ""
	Private cNFiscal   := ""
	Private cSerie     := ""
	Private cA100For   := ""
	Private cLoja      := ""
	Private cEspecie   := ""
	Private cCondicao  := ""
	Private cForAntNFE := ""
	Private dDEmissao  := dDataBase
	Private l103Inclui := .T.

	If SZP->ZP_STATUS = "2"
		Iw_MsgBox("Op็ใo Invแlida para Documento","INFO")
		lOk := .F.
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Configura variaveis da Enchoice                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	RegToMemory( cAlias, nOpcx==3 ) // pega todos os dados que estแ nesse registro.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida Dados Cabecalho                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lOk := A230VCabec()

	If	lOk

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Inicializa as variaveis                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cTipo		:= IIf( cTipoDoc = "3", "D", "B" )
		cFormul		:= IIf( lForm, "S", "N" )
		cNFiscal	:= SZO->ZO_NFENTRA
		cSerie		:= SZO->ZO_SERENTR
		dDEmissao	:= dDataBase
		cA100For	:= SZO->ZO_CLIENTE
		cLoja		:= SZO->ZO_LOJA
		cEspecie	:= IIf( !lForm, "SPED ", CriaVar("F1_ESPECIE") )
		cCondicao	:= Posicione( "SA1", 1, xFilial("SA1")+SZO->ZO_CLIENTE+SZO->ZO_LOJA, "A1_COND" )
		cUfOrig		:= Posicione( "SA1", 1, xFilial("SA1")+SZO->ZO_CLIENTE+SZO->ZO_LOJA, "A1_EST" )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Mensagens de Confirmacao da Efetivacao                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If		cTipoDoc = "1"
				cTipo	:= "B"
				cMsgTxt := "Ao Efetivar a AF: " + SZO->ZO_NUM + ", serแ gerado: " + CRLF
				cMsgTxt += "Documento de Entrada para Devolu็ใo de Beneficiamento: " + CRLF
				If	!lForm
					cMsgTxt += "  N๚mero: " + SZO->ZO_NFENTRA + " S้rie: " + SZO->ZO_SERENTR + CRLF
				Else
					cMsgTxt += "  Formulแrio Pr๓prio " + CRLF
				EndIf
				cMsgTxt += "  Cliente: " + SZO->ZO_CLIENTE + " Loja: " + SZO->ZO_LOJA + " - " + Posicione("SA1",1,xFilial("SA1")+SZO->ZO_CLIENTE+SZO->ZO_LOJA,"A1_NOME") + CRLF + CRLF
				cMsgTxt += "Pedido de Venda para Faturamento: " + CRLF
				cMsgTxt += "  Cliente: " + SZO->ZO_CLIFAT + " Loja: " + SZO->ZO_LOJFAT + " - " + Posicione("SA1",1,xFilial("SA1")+SZO->ZO_CLIFAT+SZO->ZO_LOJFAT,"A1_NOME") + CRLF + CRLF

		ElseIf	cTipoDoc = "2"
				cTipo	:= "B"
				cMsgTxt := "Ao Efetivar a AD Consigna็ใo: " + SZO->ZO_NUM + ", serแ gerado: " + CRLF
				cMsgTxt += "Documento de Entrada para Devolu็ใo de Beneficiamento: " + CRLF
				If	!lForm
					cMsgTxt += "  N๚mero: " + SZO->ZO_NFENTRA + " S้rie: " + SZO->ZO_SERENTR + CRLF
				Else
					cMsgTxt += "  Formulแrio Pr๓prio " + CRLF
				EndIf
				cMsgTxt += "  Cliente: " + SZO->ZO_CLIENTE + " Loja: " + SZO->ZO_LOJA + " - " + Posicione("SA1",1,xFilial("SA1")+SZO->ZO_CLIENTE+SZO->ZO_LOJA,"A1_NOME") + CRLF + CRLF

		ElseIf	cTipoDoc = "3"
				cTipo	:= "D"
				cMsgTxt := "Ao Efetivar a AD Vendas: " + SZO->ZO_NUM + ", serแ gerado: " + CRLF
				cMsgTxt += "Documento de Entrada para Devolu็ใo de Venda: " + CRLF
				If	!lForm
					cMsgTxt += "  N๚mero: " + SZO->ZO_NFENTRA + " S้rie: " + SZO->ZO_SERENTR + CRLF
				Else
					cMsgTxt += "  Formulแrio Pr๓prio " + CRLF
				EndIf
				cMsgTxt += "  Cliente: " + SZO->ZO_CLIENTE + " Loja: " + SZO->ZO_LOJA + " - " + Posicione("SA1",1,xFilial("SA1")+SZO->ZO_CLIENTE+SZO->ZO_LOJA,"A1_NOME") + CRLF + CRLF

		EndIf

		cMsgTxt += "Confirma ? " + CRLF

		If	Aviso(	"Efetiva็ใo AF/AD", cMsgTxt, {"Confirma","Cancela"}, 3 ) = 2
			lOk := .F.
		EndIf

	EndIf

	If	lOk	.And. lForm

		lOk := A230NfeNextDoc( @cNFiscal, @cSerie, l103Inclui )

		cEspecie	:= IIf( cSerie = "1  ", "SPED ", "NFE  " )

	EndIf

	If	lOk

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Montagem dos itens da Nota Fiscal de Devolucao/Retorno          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		cQuery := "SELECT SZP.* "
		cQuery += "FROM	" +	RetSqlName("SZP")  + " SZP "
		cQuery += "WHERE  SZP.ZP_FILIAL  =  '" + cFilAnt     + "' "
		cQuery += "AND    SZP.ZP_NUM     =  '" + SZO->ZO_NUM + "' "
		cQuery += "AND    SZP.ZP_STATUS  =  '1' "
		cQuery += "AND    SZP.D_E_L_E_T_ <> '*' "
		cQuery += "ORDER  BY ZP_FILIAL, ZP_NUM, ZP_ITEM "
		cQuery    := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB01",.T.,.T.)
		TcSetField("TRB01", "ZP_DTVALID", "D", 8, 0)

		If	!Eof()

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Montagem do Cabecalho da Nota fiscal de Devolucao/Retorno       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

			aAdd( aCab, { "F1_TIPO"     , cTipo                   , Nil } ) //-- Tipo da NF   : Obrigatorio
			aAdd( aCab, { "F1_FORMUL"   , IIf( lForm, "S", "N" )  , Nil } ) //-- Formulario
			aAdd( aCab, { "F1_DOC"      , cNFiscal                , Nil } ) //-- Numero da NF : Obrigatorio
			aAdd( aCab, { "F1_SERIE"    , cSerie                  , Nil } ) //-- Serie da NF  : Obrigatorio
			aAdd( aCab, { "F1_EMISSAO"  , dDataBase               , Nil } ) //-- Emissao da NF        : Obrigatorio
			aAdd( aCab, { "F1_FORNECE"  , cA100For                , Nil } ) //-- Codigo do Fornecedor : Obrigatorio
			aAdd( aCab, { "F1_LOJA"     , cLoja                   , Nil } ) //-- Loja do Fornecedor   : Obrigatorio
			aAdd( aCab, { "F1_ESPECIE"  , cEspecie                , Nil } ) //-- Especie
			aAdd( aCab, { "F1_CHVNFE"   , SZO->ZO_CHVNFE          , Nil } ) //-- Chave da NFE
			aAdd( aCab, { "F1_AF"       , cNumAf                  , Nil } ) //-- Numero da AF/AD Geradora

			Do While !Eof()

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Efetua a montagem da Linha                                      ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

				nValDesc := ((TRB01->ZP_PRUNIT * TRB01->ZP_QTDE)-TRB01->ZP_TOTAL)
				SB1->( dbSeek( xFilial( "SB1" )+TRB01->ZP_PRODUTO ) )
				cCtaProd := SB1->B1_CONTA

				aLinha := {}
				aAdd( aLinha, { "D1_COD"     , TRB01->ZP_PRODUTO , Nil } )
				aAdd( aLinha, { "D1_TES"     , TRB01->ZP_TESDV   , Nil } )
				aAdd( aLinha, { "D1_QUANT"   , TRB01->ZP_QTDE    , Nil } )
				aAdd( aLinha, { "D1_VUNIT"   , TRB01->ZP_PRCVEN  , Nil } )
				aAdd( aLinha, { "D1_LOCAL"   , TRB01->ZP_LOCORIG , Nil } )
				aAdd( aLinha, { "D1_UM"      , TRB01->ZP_UMORIG  , Nil } )
				aAdd( aLinha, { "D1_NFORI"   , TRB01->ZP_NFORIG  , Nil } )
				aAdd( aLinha, { "D1_SERIORI" , TRB01->ZP_SERORIG , Nil } )
				aAdd( aLinha, { "D1_ITEMORI" , TRB01->ZP_ITEORIG , Nil } )
				aAdd( aLinha, { "D1_IDENTB6" , TRB01->ZP_B6IDENT , Nil } )
				aAdd( aLinha, { "D1_AF"      , TRB01->ZP_NUM     , Nil } )
				aAdd( aLinha, { "D1_ITEMAF"  , TRB01->ZP_ITEM    , Nil } )
				aAdd( aLinha, { "D1_CONTA"   , cCtaProd          , Nil } )
				aAdd( aLinha, { "D1_LOTECTL" , TRB01->ZP_LOTECTL , Nil } )
				aAdd( aLinha, { "D1_LOTEFOR" , TRB01->ZP_LOTEFOR , Nil } )
				aAdd( aLinha, { "D1_DTVALID" , TRB01->ZP_DTVALID , Nil } )
				aAdd( aLinha, { "D1_CC"      , SZO->ZO_CC        , Nil } )
				aAdd( aLinha, { "D1_ITEMCTA" , SZO->ZO_ITEMCTB   , Nil } )

				aAdd( aItens, aLinha)

				dbSelectArea("TRB01")
				dbSkip()
			EndDo

			TRB01->(dbCloseArea())

			lMsErroAuto := .f.
			lMsHelpAuto := .t.
			lNfEntOk	:= .F.

			MsgRun( "Aguarde...Incluindo a Nota Fiscal de Devolu็ใo.", , { ||MSExecAuto( { |w,x,y,z| MATA103( w,x,y,z ) }, aCab, aItens, 3, .f. )})

			If	lMsErroAuto

				Mostraerro()

			Else

				lPedVenOk := .F.
				cNFEntra  := SF1->F1_DOC
				cSerie    := SF1->F1_SERIE
				cCliFor   := SF1->F1_FORNECE
				cLoja     := SF1->F1_LOJA

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Marca Status da Autorizacao de Faturamento como Acertada        ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

				cUpDate := " UPDATE " + RetSqlName("SZO")
				cUpDate += " SET    ZO_STATUS  = '9' "
				cUpDate += "       ,ZO_NFENTRA = '" + cNFiscal + "' "
				cUpDate += "       ,ZO_SERENTR = '" + cSerie   + "' "
				cUpDate += " WHERE  ZO_FILIAL  = '" + xFilial("SZO") + "' "
				cUpDate += " AND    ZO_NUM     = '" + cNumAf       + "' "
				cUpDate += " AND    D_E_L_E_T_ = '' "
				TcSqlExec(cUpDate)

				cUpDate := " UPDATE " + RetSqlName("SZP")
				cUpDate += " SET    ZP_STATUS  = '9' "
				cUpDate += "       ,ZP_NFENTRA = '" + cNFEntra + "' "
				cUpDate += "       ,ZP_SERENTR = '" + cSerie   + "' "
				cUpDate += " WHERE  ZP_FILIAL  = '" + xFilial("SZP") + "' "
				cUpDate += " AND    ZP_NUM     = '" + cNumAf       + "' "
				cUpDate += " AND    D_E_L_E_T_ = '' "
				TcSqlExec(cUpDate)

				If	cTipoDoc = '1'

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Gera Pedido de Vendas para Cobranca do Acerto                ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

					aRetPV := A230GeraPV( cNumAf )

					If	aRetPV[1]

						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Grava o Numero do Pedido Gerado no Cabecalho da AF/AD           ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

						cUpDate := " UPDATE " + RetSqlName("SZO")
						cUpDate += " SET    ZO_PEDIDO  = '" + aRetPV[3]      + "' "
						cUpDate += " WHERE  ZO_FILIAL  = '" + xFilial("SZO") + "' "
						cUpDate += " AND    ZO_NUM     = '" + cNumAf        + "' "
						cUpDate += " AND    D_E_L_E_T_ = '' "
						TcSqlExec(cUpDate)

						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Grava o Numero do Pedido Gerado no Cabecalho da AF/AD           ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

						cMsgNfEntra := "PEDIDO FATURAMENTO: " + aRetPV[3] + " - A.F.: " + cNumAf
						cUpDate := " UPDATE " + RetSqlName("SF1")
						cUpDate += " SET    F1_MENOTA  = '" + cMsgNfEntra    + "' "
						cUpDate += " WHERE  F1_FILIAL  = '" + xFilial("SF1") + "' "
						cUpDate += " AND    F1_DOC     = '" + cNFiscal       + "' "
						cUpDate += " AND    F1_SERIE   = '" + cSerie         + "' "
						cUpDate += " AND    F1_FORNECE = '" + cA100For       + "' "
						cUpDate += " AND    F1_LOJA    = '" + cLoja          + "' "
						cUpDate += " AND    D_E_L_E_T_ = '' "
						TcSqlExec(cUpDate)

						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Edita Altera็ใo do Pedido Incluido                           ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

						dbSelectArea("SC5")
						dbSetOrder(1)
						dbSeek( xFilial("SC5") + aRetPV[3] )

						A410Altera( "SC5", SC5->(Recno()), 4 )

					Else

						cMsgTxt := "Falha na Gera็ใo do Pedido de Venda" + CRLF
						cMsgTxt += "O Pedido de Venda deverแ ser incluํdo Manualmente" + CRLF
						cMsgTxt += aRetPV[3] + CRLF

						//Aviso(	"Aten็ใo", cMsgTxt, {"Ok"}, 3 )
						ALERT(cMsgTxt)

					EndIf

				EndIf

			EndIf

		Else

			TRB01->(dbCloseArea())

		EndIf

		MsUnLockAll()

	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Restaura a entrada da rotina                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	RestArea(aAreaSF2)
	RestArea(aArea)

Return(.T.)

/*
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
*/

Static Function A230GeraPV( cNumAf )

	Local aCabPv   := Array(0)
	Local aItemPv  := Array(0)
	Local aItensPv := Array(0)
	Local cItem    := StrZero(0,Len(SC6->C6_ITEM))
	Local aArea    := GetArea()
	Local cMsg     := "Pedido Nใo Gerado:" + CRLF + CRLF
	Local aRet     := { .F., cMsg , "" }
	Local aSCJ     := {}
	Local aSCK     := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem dos itens da Nota Fiscal de Devolucao/Retorno          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := "SELECT SZO.ZO_CLIENTE, SZO.ZO_LOJA, SZO.ZO_CLIFAT, SZO.ZO_LOJFAT, SZO.ZO_AFCLI, ZO_ORCAMEN "
	cQuery +=       " ,SZO.ZO_COND, SZO.ZO_VEND1, SZO.ZO_TABELA, ZO_OPERFAT, SZO.ZO_MENNOTA, SZO.ZO_CC, SZO.ZO_ITEMCTB "
	cQuery +=       " ,SZP.* "
	cQuery +=       " ,COALESCE( DA1.DA1_PRCVEN, SZP.ZP_PRCVEN ) AS DA1_PRCVEN "
	cQuery += "FROM   "	+ RetSqlName("SZO") + " SZO "
	cQuery += "INNER  JOIN " +  RetSqlName("SZP") + " SZP "
	cQuery += "ON     SZP.ZP_FILIAL  = SZO.ZO_FILIAL "
	cQuery += "AND    SZP.ZP_NUM     = SZO.ZO_NUM "
	cQuery += "AND    SZP.D_E_L_E_T_ = '' "
	cQuery += "LEFT   JOIN " +  RetSqlName("DA1") + " DA1 "
	cQuery += "ON     DA1.DA1_FILIAL = '" + xFilial("DA1") + "' "
	cQuery += "AND    DA1.DA1_CODTAB = SZO.ZO_TABELA "
	cQuery += "AND    DA1.DA1_CODPRO = SZP.ZP_PRODUTO "
	cQuery += "AND    DA1.D_E_L_E_T_ = '' "
	cQuery += "WHERE  SZO.ZO_FILIAL  = '" + xFilial("SZP") + "' "
	cQuery += "AND    SZO.ZO_NUM     = '" + cNumAf         + "' "
	cQuery += "AND    SZO.D_E_L_E_T_ = '' "
	cQuery += "ORDER  BY ZP_FILIAL, ZP_NUM, ZP_ITEM, ZP_PRODUTO "
	MemoWrite( "\_queries\jmha230_pv.sql", cQuery )
	cQuery    := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB01",.T.,.T.)

	If	!Eof()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Efetua a montagem do Cabecalho do Pedido de Venda               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		aCabPv := { }
		cMsgNota := IIf( !Empty( SZO->ZO_AFCLI ), "REF AF: " + SZO->ZO_AFCLI, "")

		aAdd(aCabPv,{ "C5_TIPO"     , "N"                , Nil })
		aAdd(aCabPv,{ "C5_CLIENTE"  , TRB01->ZO_CLIFAT   , Nil })
		aAdd(aCabPv,{ "C5_LOJACLI"  , TRB01->ZO_LOJFAT   , Nil })
		aAdd(aCabPv,{ "C5_CONDPAG"  , POSICIONE( "SA1", 1, xFilial("SA1") + TRB01->ZO_CLIFAT + TRB01->ZO_LOJFAT, "A1_COND" ) , Nil })
		aAdd(aCabPv,{ "C5_VEND1"    , TRB01->ZO_VEND1    , Nil })
		aAdd(aCabPv,{ "C5_TABELA"   , TRB01->ZO_TABELA   , Nil })
		aAdd(aCabPv,{ "C5_MENNOTA"  , cMsgNota           , Nil })
		aAdd(aCabPv,{ "C5_TPFRETE"  , "S"                , Nil })
		aAdd(aCabPv,{ "C5_CLIVALE"  , TRB01->ZO_CLIENTE  , Nil })
		aAdd(aCabPv,{ "C5_LJCVALE"  , TRB01->ZO_LOJA     , Nil })
		aAdd(aCabPv,{ "C5_AF"       , cNumAf             , Nil })
		aAdd(aCabPv,{ "C5_NATUREZ"  , '1101101'  , Nil })		

		//		aAdd(aCabPv,{ "C5_CONDPAG"  , TRB01->ZO_COND     , Nil })
        // aAdd(aCabPv,{ "C5_ORCRES"   , TRB01->ZO_ORCAMEN  , Nil })

        // CODIGO DO ORCAMENTO (SZO)
		cOrcamen := TRB01->ZO_ORCAMEN

		Do While !Eof()
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Efetua a montagem da Linha                                      ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cItem := Soma1(cItem,2)

			aItemPv := {}

			nValorItem := (TRB01->ZP_QTDE * TRB01->DA1_PRCVEN)
			aAdd(aItemPv, { "C6_ITEM"     ,cItem                    , Nil })
			aAdd(aItemPv, { "C6_ENVSEP"   ,"2"                      , Nil })
			aAdd(aItemPv, { "C6_PRODUTO"  ,TRB01->ZP_PRODUTO        , Nil })
			aAdd(aItemPv, { "C6_OPER"     ,TRB01->ZO_OPERFAT        , Nil })
			aAdd(aItemPv, { "C6_OPERFAT"  ,TRB01->ZO_OPERFAT        , Nil })
			aAdd(aItemPv, { "C6_QTDVEN"   ,TRB01->ZP_QTDE           , Nil })
			aAdd(aItemPv, { "C6_PRCVEN"   ,TRB01->DA1_PRCVEN        , Nil })
			aAdd(aItemPv, { "C6_PRUNIT"   ,TRB01->DA1_PRCVEN        , Nil })
			aAdd(aItemPv, { "C6_VALOR"    ,nValorItem               , Nil })
			aAdd(aItemPv, { "C6_QTDLIB"   ,TRB01->ZP_QTDE           , Nil })
			aAdd(aItemPv, { "C6_LOCAL"    ,TRB01->ZP_LOCORIG        , Nil })	//-- Almoxarifado
			aAdd(aItemPv, { "C6_CCUSTO"   ,TRB01->ZO_CC             , Nil })	//-- Centro Custos
			aAdd(aItemPv, { "C6_CC"   	  ,TRB01->ZO_CC             , Nil })	//-- Centro Custos
			aAdd(aItemPv, { "C6_ITEMCTB"  ,TRB01->ZO_ITEMCTB        , Nil })	//-- Item COntabil
			aAdd(aItemPv, { "C6_LOTECTL"  ,TRB01->ZP_LOTECTL        , Nil })	//-- Rastreabilidade / Controle de Lote
			aAdd(aItemPv, { "C6_LOTE"     ,TRB01->ZP_LOTEFOR        , Nil })	//-- Rastreabilidade / Lote do Fornecedor
			aAdd(aItemPv, { "C6_DTVALID"  ,STOD(TRB01->ZP_DTVALID)  , Nil })	//-- Rastreabilidade / Data Validade Lote

			aAdd( aItensPv, AClone(aItemPv) )

			dbSelectArea("TRB01")
			dbSkip()
		EndDo

		TRB01->(dbCloseArea())

		If Len(aItensPv) > 0

			lAutoErrNoFile := .T.
			lMsErroAuto    := .F. // necessario a criacao, pois sera atualizado quando houver inconsistencia

			MsgRun( "Aguarde...Incluindo o Pedido de Venda.", , { || MSExecAuto( { |x,y,z| Mata410( x,y,z ) }, aCabPv, aItensPv, 3 )})

			If lMsErroAuto
				aMsg := GetAutoGRLog()
				aEval(aMsg,{|x| cMsg += x + CRLF})
				aRet := {.F., cMsg, "" }
			Else
				aRet := {.T., "", SC5->C5_NUM }
				cSC5 := SC5->C5_NUM
			EndIf

			// -------------------------------------------------------
			// -------------------------------------------------------
		    // Cristiano Oliveira - Vincula Orcamento x PV - 15/03/16
			// -------------------------------------------------------
			// -------------------------------------------------------
			/*
			DbSelectArea("SCJ")
			DbSetOrder(1)
			If DbSeek(xFilial("SCJ") + cOrcamen)

				aCabec := {}
				aLinha := {}

		        aadd(aCabec,{"CJ_NUM"    , SCJ->CJ_NUM         ,Nil})
				aadd(aCabec,{"CJ_CLIENTE", SCJ->CJ_CLIENTE     ,Nil})
				aadd(aCabec,{"CJ_LOJA", SCJ->CJ_LOJA     ,Nil})
				aadd(aCabec,{"CJ_CLIENT" , SCJ->CJ_CLIENT      ,Nil})
				aadd(aCabec,{"CJ_LOJAENT", SCJ->CJ_LOJAENT     ,Nil})
				aadd(aCabec,{"CJ_CONDPAG", SCJ->CJ_CONDPAG     ,Nil})

				DbSelectArea("SCK")
				DbSetOrder(1)
				DbSeek(xFilial("SCK") + cOrcamen)

				While !Eof("SCK") .AND. SCJ->CJ_NUM == SCK->CK_NUM
                	aadd(aLinha,{"CK_ITEM"   , SCK->CK_ITEM    , Nil})
					aadd(aLinha,{"CK_PRODUTO", SCK->CK_PRODUTO , Nil})
					aadd(aLinha,{"CK_QTDVEN" , SCK->CK_QTDVEN  , Nil})
					aadd(aLinha,{"CK_PRCVEN" , SCK->CK_PRCVEN  , Nil})
					aadd(aLinha,{"CK_PRUNIT" , SCK->CK_PRUNIT  , Nil})
					aadd(aLinha,{"CK_VALOR"  , SCK->CK_VALOR   , Nil})
					aadd(aLinha,{"CK_TES"    , SCK->CK_TES     , Nil})

			    	SCK->(DbSkip())
				EndDo

				MATA416(aCabec, aLinha)

				If !lMsErroAuto
				    ConOut("Baixa de orcamento: " + cOrcamen)
				Else
				    //MostraErro()
				    ConOut("Erro na baixa!")
				EndIf
			EndIf
			*/

			If !Empty(cOrcamen)
				DbSelectArea("SCJ")
				DbSetOrder(1)
				If DbSeek(xFilial("SCJ") + cOrcamen)
					RecLock("SCJ", .F.)
					SCJ->CJ_STATUS := "B"
					MsUnlock()

					DbSelectArea("SCK")
					DbSetOrder(1)
					DbSeek(xFilial("SCK") + cOrcamen)

					While !Eof("SCK") .AND. SCJ->CJ_NUM == SCK->CK_NUM

	       				RecLock("SCK", .F.)
						SCK->CK_NUMPV := cSC5
						MsUnlock()

				    	SCK->(DbSkip())
					EndDo
					// MsgInfo("Baixa do orcamento " + cOrcamen + " realizada com sucesso!")
				EndIf
			EndIf

			// -------------------------------------------------------
			// -------------------------------------------------------

		EndIf
	Else

		TRB01->(dbCloseArea())

	EndIf

	RestArea( aArea )

Return( aRet )


/*
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
*/

User Function A230ValCc( cVend, cCC )

	Local lRet := .T.
// CRISTIANO OLIVEIRA - 03/11/2017 - LIBERADO VALIDAR CC
	SA3->( dbSetOrder(1) )
	If	SA3->( dbSeek(xFilial('SA3')+cVend) )
//		If !( AllTrim( cCC ) $ AllTrim(SA3->A3_CCUSTO) )
//		If !( AllTrim(POSICIONE("SB1", 1, "  " + SZP->ZP_NUM, "B1_CLVL")) $ AllTrim(SA3->A3_CCUSTO) )
//			cMsgAviso := "Classe de valor invแlida para este representante!" + CRLF
//			cMsgAviso += "Classe de valor vแlida: " + Alltrim(SA3->A3_CCUSTO) + CRLF

//			Aviso( "Inconsist๊ncia Dados:", cMsgAviso, {"Ok"}, 3 )
			lRet := .T.

//			lRet := .F.

//		EndIf
	Else

			cMsgAviso := "Representante Invแlido!" + CRLF
			Aviso( "Inconsist๊ncia Dados:", cMsgAviso, {"Ok"}, 3 )
			lRet := .F.

	EndIf

Return( lRet )

/*
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
*/

Static Function A230VCabec()

	Local lRet      := .T.
	Local cMsgAviso := ""

	If	Empty(M->ZO_CLIENTE) .Or.;
		Empty(M->ZO_LOJA)

		cMsgAviso += CRLF + "Campos Aba Doc. Entrada em Branco:" + CRLF
		cMsgAviso += IIf( Empty(M->ZO_CLIENTE).Or.Empty(M->ZO_LOJA),"Cod Cliente/Lj do Cliente " + CRLF, "")

		lRet := .F.

	Else

		If	!Empty(M->ZO_NFENTRA) .And.;
			(Empty(M->ZO_SERENTR) .Or.;
			 Empty(M->ZO_CHVNFE))

			cMsgAviso += "Campos Aba Doc. Entrada em Branco:" + CRLF
			cMsgAviso += IIf( Empty(M->ZO_SERENTR), "Serie Nf Ent" + CRLF, "")
			cMsgAviso += IIf( Empty(M->ZO_CHVNFE), "Chave NF-e" + CRLF, "")

			lRet := .F.

		EndIf

	EndIf

	If	M->ZO_TIPO = "1"

		If	Empty(M->ZO_CLIFAT)  .Or.;
			Empty(M->ZO_LOJFAT)  .Or.;
			Empty(M->ZO_VEND1)   .Or.;
			Empty(M->ZO_COND)    .Or.;
			Empty(M->ZO_CC)      .Or.;
			Empty(M->ZO_ITEMCTB) .Or.;
			Empty(M->ZO_OPERFAT)

			cMsgAviso += CRLF + "Campos Aba Faturamento em Branco:" + CRLF
			cMsgAviso += IIf( Empty(M->ZO_CLIFAT).Or.Empty(M->ZO_LOJFAT),"Cliente/Loja p/ Faturamento" + CRLF, "")
			cMsgAviso += IIf( Empty(M->ZO_VEND1)   , "Vendedor"     + CRLF, "")
			cMsgAviso += IIf( Empty(M->ZO_COND)    , "Cond Pgto"    + CRLF, "")
			cMsgAviso += IIf( Empty(M->ZO_CC)      , "C.Custo P.Venda" + CRLF, "")
			cMsgAviso += IIf( Empty(M->ZO_ITEMCTB) , "Item Contab." + CRLF, "")
			cMsgAviso += IIf( Empty(M->ZO_OPERFAT) , "Tp. Operacao" + CRLF, "")

			lRet := .F.

//		Else
// CRISTIANO OLIVEIRA - 03/11/2017 - LIBERADO VALIDAR CC
			//SA3->( dbSetOrder(1) )
			//SA3->( dbSeek(xFilial('SA3')+M->ZO_VEND1) )
//			If !( AllTrim(M->ZO_CC) $ AllTrim(SA3->A3_CCUSTO) )
			//If !( AllTrim(POSICIONE("SB1", 1, "  " + SZP->ZP_NUM, "B1_CLVL")) $ AllTrim(SA3->A3_CCUSTO) )
			 //	cMsgAviso := "Classe de valor invแlida para este representante!" + CRLF
			 //	cMsgAviso += "Classe de valor vแlida: " + Alltrim(SA3->A3_CCUSTO) + CRLF

			 //	lRet := .F.

//				lRet := .T.

			//EndIf

		EndIf

	EndIf

	If	!lRet

		Aviso( "Inconsist๊ncia Dados:", cMsgAviso, {"Ok"}, 3 )

		lRet := .F.

	EndIf

Return( lRet )

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณNfeNextDocณ Autor ณ Edson Maricate        ณ Data ณ04.03.2000 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAdaptado  ณNfeNextDocณ Autor ณ Fabio Briddi          ณ Data ณ Jun/2015  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณEsta rotina controla a numeracao do documento de entrada qdo ณฑฑ
ฑฑณ          ณo formulario for proprio                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณEsta rotina tem como objetivo controlar/atualizar a numeracaoณฑฑ
ฑฑณ          ณdo documento de entrada quando o formulario for proprio.     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                             ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                             ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Materiais                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function A230NfeNextDoc( cNFiscal, cNfSerie, lAtiva )

	Local aArea	   := GetArea()
	Local aAreaSF1 := SF1->(GetArea())
	Local lRetorno := .T.
	Local nItensNf := 0
	Local cTipoNf  := SuperGetMv("MV_TPNRNFS")
	Local cNum103  := ""
	Local cMT103SRI:= ""

	Private cNumero:= ""
	Private cSerie := ""

	lRetorno:= Sx5NumNota(@cSerie,cTipoNf)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Validacao da NF informada pelo usuario                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lRetorno .And. cTipoNF <> "3"
		SF1->(dbSetOrder(1))
		If SF1->(MsSeek(xFilial("SF1")+cNumero+cSerie+cA100For+cLoja,.F.))
			Help(" ",1,"EXISTNF")
			lRetorno := .F.
			cNumero:= ""
			cSerie := ""
		EndIf
	EndIf

	If lRetorno

		If cTipoNf <> "3"
			// Se numeracao for SXE/SXF e usuario alterou numero, respeita numero do usuarop
			If cTipoNf <> "2" .OR. !lMudouNum
				cNumero := NxtSX5Nota(cSerie, NIL, cTipoNf)
			EndIf
		Else
			If !lMudouNum	// Verifica se usuario alterou numero da nota fiscal
				cNumero := Space(TamSx3("F1_DOC")[1])
			EndIf
		EndIf

	EndIf

	If	lRetorno
		cNFiscal:=cNumero
		cNFSerie:=cSerie
	Else
		cNFiscal:= CriaVar("F1_DOC",.F.)
		cNFSerie:= CriaVar("F1_SERIE",.F.)
	EndIf

	RestArea(aAreaSF1)
	RestArea(aArea)

Return(lRetorno)

/*
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
*/
