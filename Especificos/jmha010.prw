#Define CRLF ( chr(13)+chr(10) )
#include "protheus.ch"
#include "sigawin.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ JMHA010  ณ Autor ณ Andre Luis            ณ Data ณ Jun/2014 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Transferencia interna de lote.                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ u_JMHA010                                                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ NIL                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Jomhedica                                                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ                          ULTIMAS ALTERACOES                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ Motivo da Alteracao                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Andre SIlveira ณ21/08/2014ณGeracao de lote e Estorno de lote          ณฑฑ
ฑฑณ                               por MBrowse, nao pelo PE.               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function JMHA010()

Local   aCores    := {}
Private cCadastro := "Saldo por Lote - SC"
Private aRotina   := MenuDef()

aAdd(aCores,{"B8_LOTEUNI=='S'","BR_AMARELO" })
aAdd(aCores,{"B8_LOTEUNI<>'S'.AND.B8_ORIGLAN$'NF|MI'.AND.B8_SALDO==0","BR_VERMELHO" })
aAdd(aCores,{"B8_LOTEUNI<>'S'.AND.B8_ORIGLAN$'NF|MI'.AND.B8_SALDO<>0","BR_VERDE" })
aAdd(aCores,{"B8_LOTEUNI<>'S'.AND.B8_ORIGLAN=='  '.AND.B8_SALDO==0","BR_PINK"  })
aAdd(aCores,{"B8_LOTEUNI<>'S'.AND.B8_ORIGLAN=='  '.AND.B8_SALDO<>0","BR_AZUL"  })

SB8->( DbSetOrder( 1 ) )

mBrowse(6,1,22,75,"SB8",,,,,,aCores)


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA010Leg   บAutor  ณAndre Luis          บ Data ณ  08/21/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de legenda                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A010Leg(cP_ALIAS,nP_REG,nP_OPC)

Local aLegenda := {}

aAdd(aLegenda,{"BR_AMARELO"  ,"Lote Unitario"      })
aAdd(aLegenda,{"BR_VERDE"    ,"Lote Fornecedor c/ Saldo" })
aAdd(aLegenda,{"BR_VERMELHO" ,"Lote Fornecedor s/ Saldo" })
aAdd(aLegenda,{"BR_AZUL"     ,"Sem Origem c/ Saldo"      })
aAdd(aLegenda,{"BR_PINK"     ,"Sem Origem s/ Saldo"      })

BrwLegenda(cCadastro,"Saldo por Lotes:",alegenda)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef   บAutor  ณAndre Luis          บ Data ณ  08/21/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de Menu do MBrowse                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MenuDef()

Local aRotina := {}

aAdd(aRotina,{"Pesquisar"                   ,"AxPesqui"    ,0 ,1	})
aAdd(aRotina,{"Visualizar"                  ,"AXVISUAL"    ,0 ,2	})
aAdd(aRotina,{"Por Item"                    ,"U_A010Doc"   ,0 ,3	})
aAdd(aRotina,{"Por Documento"               ,"U_A010Ite"   ,0 ,4	})
aAdd(aRotina,{"Por Grupo"                   ,"U_A010Grp"   ,0 ,3	})
aAdd(aRotina,{"Estornar Por Documento"      ,"U_A010Ite"   ,0 ,6	})
aAdd(aRotina,{"Estornar Por Item"           ,"U_A010Doc"   ,0 ,5	})
aAdd(aRotina,{"Legenda"                     ,"U_A010Leg"   ,0 ,9	})


Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA010Ite   บAutor  ณAndre Luis          บ Data ณ  08/21/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Funcao que gera lote p/documento e estorna p/documento    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A010Ite(ALIAS,nP,nOpcx)

Local cPerg	     :=""
Local aArea	     := GetArea()
Local cNumDoc    :=""
Local cSerie     :=""
Local cFornerce  :=""
Local cLoja      :=""
Local aArray     :={}
Local lNormal    :=.T.

Local cDocOrigem :=""
Local cSerieOrig :=""
Local cForneceOr :=""
Local cLojoOrige :=""


// marllon - provisorio
Msginfo('Executar a rotina POR ITEM!')
Return




If Empty(SB8->B8_ORIGLAN)

	cMsg := "Registro de Saldo por Lote com Origem Desconhecida."                 + CRLF
	cMsg += "Para esse tipo de saldo, utilize a rotina padrใo em:"                + CRLF
	cMsg += "Estoque/Custos > Atualiza็๕es > Movmtos. Internos > Transf. (mod.2)" + CRLF
	cMsg += "No browse clique em: Incluir"                                        + CRLF
	cMsg += "Em A็๕es relacionadas > Gerar lote unitario"                         + CRLF 
	cMsg += CRLF
	cMsg += "Anote os dados para a Gera็ใo:"                                      + CRLF
	cMsg += "Documento: "         + SB8->B8_DOC                                   + CRLF
	cMsg += "S้rie: "             + SB8->B8_SERIE                                 + CRLF
	cMsg += "C๓digo Fornecedor: " + SB8->B8_CLIFOR                                + CRLF
	cMsg += "Loja Fornecedor: "   + SB8->B8_LOJA                                  + CRLF
	cMsg += "Produto: "           + SB8->B8_PRODUTO                               + CRLF
	cMsg += "Lote: "              + SB8->B8_LOTECTL                               + CRLF
    
// Cristiano Oliveira - Copiar informacoes do AVISO - 20/12/2016
    
	DEFINE MSDIALOG oVCan FROM 05,10 TO 400,650 TITLE "LOTE UNITARIO" PIXEL
	@ 12,08 GET oObs VAR cMsg OF oVCan MEMO SIZE 300,150 PIXEL
	DEFINE SBUTTON FROM 180,250 TYPE 1 ACTION (nOpca := 1,oVCan:End()) ENABLE OF oVCan
	ACTIVATE MSDIALOG oVCan CENTER

//	Aviso("Aten็ใo",cMsg,{"Ok"},1)

Else

	cPerg:= PadR("A010Doc010",Len(SX1->X1_GRUPO))
	
	A010Pergun(cPerg)
	
	If Pergunte(cPerg,.T.)
	
		cNumDoc    :=MV_PAR01   //Numero do documento de entrada
		cSerie     :=MV_PAR02   //serie
		cFornerce  :=MV_PAR03   //codigo de fornecedor
		cLoja      :=MV_PAR04   //loja do fornecedor
		
		IF nOpcx==4
			SF1->(DbSetOrder(1)) //Documento de entrada
			DbSeek(xFilial("SF1")+cNumDoc+cSerie)
			
			If SF1->F1_TIPO<>"N"
				lNormal:=.F.
			EndIF
		EndIF
		
		cMensa:=IIF(nOpcx==6,"Estornando p/documento","Gerando Lote p/documento")    // Marllon: justar msg. 'p/ Item'
		lEstor:=IIF(nOpcx==6,.T.,.F.)  //Verdadeiro -Estorna lote, falso Transfere lote
		nLinha:=2
		
		IF nOpcx==6     // estorno 
			//Funcao que verifica na hora de estorna lote, se tem registro consumido
			If! A010Verica({cNumDoc,cSerie,cFornerce,cLoja})
				
				lNormal:=.F.
				
			EndIf
		EndIF
		
		If(lNormal==.T.)
			IF nOpcx==4  //Gera lote p/documento
				cQuery := " SELECT B8_PRODUTO, B8_DTVALID,  B8_DATA, B8_DOC, B8_SERIE, B8_CLIFOR, B8_LOJA, R_E_C_N_O_ "
			Else
				cQuery := " SELECT DISTINCT B8_FILIAL,B8_DOC, MIN(R_E_C_N_O_) R_E_C_N_O_ "
			EndIf
			
			cQuery += " FROM 	" + RetSQLName("SB8")
			cQuery += " WHERE	B8_FILIAL	= '" + xFilial("SB8")	+ "'"
			
			IF nOpcx==4  //Gera lote p/documento
				cQuery += "     AND	B8_SALDO	> 0"
				cQuery += "     AND B8_LOTEUNI <> 'S'"
				cQuery += " 	AND	B8_DOC		= '"  + cNumDoc		+"'"
				cQuery += " 	AND	B8_SERIE	= '"  + cSerie		+"'"
				cQuery += " 	AND	B8_CLIFOR	= '"  + cFornerce   +"'"
				cQuery += " 	AND	B8_LOJA		= '"  + cLoja		+"'"
				cQuery += "     AND B8_ORIGLAN = 'NF'"
				cQuery += "     AND	D_E_L_E_T_ <> '*'"
			Else  //Estorna lote  p/documento
				cQuery += "    AND B8_DOCORI = '"    + cNumDoc		+"'"
				cQuery += "    AND B8_SERORI = '"    + cSerie		+"'"
				cQuery += "    AND B8_FORORI = '"    + cFornerce    +"'"
				cQuery += "    AND B8_LOJORI  = '"    + cLoja		+"'"
				cQuery += "    AND B8_LANORI = 'NF'"
				cQuery += "    AND B8_SALDO   > 0"
				cQuery += "    AND B8_LOTEUNI = 'S'"
				cQuery += "    AND D_E_L_E_T_ <> '*'"
				cQuery += " GROUP BY B8_FILIAL,B8_DOC "
				
			EndIf
			
			cQuery += "     ORDER BY B8_FILIAL,B8_DOC "
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TEMPSB8", .F., .T.)
			
			TEMPSB8->( dbGoTop() )
			IF!EOF()
				
				While!EOF()
					
					DbSelectArea("SB8")
					DbGoto( TEMPSB8->R_E_C_N_O_ )
					
					
					//Estorna por/documento
					If nOpcx==6
						
						cDocOrigem :=SB8->B8_DOCORI //documento origem
						cSerieOrig :=SB8->B8_SERORI //serie origem
						cForneceOr :=SB8->B8_FORORI //fornecedor origem
						cLojoOrige :=SB8->B8_LOJORI //loja origem
						cLancOrige :=SB8->B8_LANORI
					Else  //gera lote por documento
						cDocOrigem:=SB8->B8_DOC		//Documento(NF)
						cSerieOrig:=SB8->B8_SERIE	//Serie(NF)
						cForneceOr:=SB8->B8_CLIFOR	//Fornecedor(NF)
						cLojoOrige:=SB8->B8_LOJA	//Loja(NF)
						cLancOrige:=SB8->B8_ORIGLAN
						
					EndIf
					
					aAdd(aArray,{SB8->B8_PRODUTO,;	//Produto
								SB8->B8_LOCAL,;		//Local
								SB8->B8_SALDO,;		//Quantidade
								SB8->B8_DTVALID,;	//Data Validade
								SB8->B8_LOTECTL,;	//LoteCTL
								SB8->B8_DATA,;		//Emissao
								cDocOrigem,;		//Documento(NF)
								cSerieOrig,;		//Serie(NF)
								cForneceOr,;		//Fornecedor(NF)
								cLojoOrige,;		//Loja(NF)
								cLancOrige;			//ORIGLAN
								})
					
					
					A010GerEst(aArray,cMensa,lEstor,nLinha)
					
					aArray:={}
					DbSelectArea("TEMPSB8")
					DbSkip()
				EndDo
				TEMPSB8->(DbCloSeArea())
			Else
				cMsg := "Geracao de Lote p/documento, nao foi gerado."
				Help("",1,"JMHA010",,cMsg,1,0)
				TEMPSB8->(DbCloSeArea())
			EndIF
			
		Else
			IF nOpcx==6
				cMsg := "Impossivel Estornar p/ documento!" + CRLF
				//cMsg += "Lote nao foi consomido."
			Else
				cMsg := "Este documento de entrada nao e Normal"
			EndIf
			Help("",1,"JMHA010",,cMsg,1,0)
		EndIF
	EndIf
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA010Grp   บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Funcao que gera lote p/ Grupo de Produto                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A010Grp( ALIAS, nP, nOpcx)

	Local cPerg	     := PadR("A010Grp010",Len(SX1->X1_GRUPO))
	Local aArea	     := GetArea()
	Local cGrupo     := ""
	Local cLoteCtl   := ""
	Local aArray     := {}
	Local lNormal    := .T.
	Local cDocOrigem := ""
	Local cSerieOrig := ""
	Local cForneceOr := ""
	Local cLojoOrige := ""

	A010GrpPergun( cPerg )
	
	If Pergunte(cPerg,.T.)
		
		cGrupo     := MV_PAR01   //-- Grupo
		cLoteCtl   := MV_PAR02   //-- Lote
		
		cQuery := " SELECT B8_PRODUTO, B8_DTVALID,  B8_DATA, B8_DOC, B8_SERIE, B8_CLIFOR, B8_LOJA, SB8.R_E_C_N_O_ "
		cQuery += " FROM 	" + RetSQLName("SB1") + " SB1, "
		cQuery +=               RetSQLName("SB8") + " SB8 "
		cQuery += " WHERE SB1.B1_FILIAL   	  =  '" + xFilial("SB1")	+"'"
		cQuery += " 	AND   SB1.B1_GRUPO    =  '"  + cGrupo			+"'"
		cQuery += " 	AND   SB1.B1_COD      =  SB8.B8_PRODUTO"
		cQuery += " 	AND   SB1.D_E_L_E_T_  <> '*'"

		cQuery += " 	AND   SB8.B8_FILIAL   =  '" + xFilial("SB8")	+ "'"
		If	!Empty(cLoteCtl)
			cQuery += " AND   SB8.B8_LOTECTL  =  '" + cLoteCtl         + "'"
		EndIf
		
		cQuery += " 	AND   SB8.B8_SALDO    >  0"
		cQuery += " 	AND   SB8.B8_LOTEUNI  <> 'S'"
		cQuery += " 	AND   SB8.B8_ORIGLAN  =  'NF'"
		cQuery += " 	AND   SB8.D_E_L_E_T_  <> '*'"
		cQuery += " 	ORDER BY B8_FILIAL,B8_DOC "
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TEMPSB8", .F., .T.)
		
		TEMPSB8->( dbGoTop() )
		If	TEMPSB8->( !EOF() )

			While TEMPSB8->( !EOF() )

				DbSelectArea("SB8")
				DbGoto( TEMPSB8->R_E_C_N_O_ )

				cDocOrigem := SB8->B8_DOC		//Documento(NF)
				cSerieOrig := SB8->B8_SERIE		//Serie(NF)
				cForneceOr := SB8->B8_CLIFOR	//Fornecedor(NF)
				cLojoOrige := SB8->B8_LOJA		//Loja(NF)
				cLancOrige := SB8->B8_ORIGLAN
				
				aAdd(aArray,{	SB8->B8_PRODUTO,;	//Produto
								SB8->B8_LOCAL,;		//Local
								SB8->B8_SALDO,;		//Quantidade
								SB8->B8_DTVALID,;	//Data Validade
								SB8->B8_LOTECTL,;	//LoteCTL
								SB8->B8_DATA,;		//Emissao
								cDocOrigem,;		//Documento(NF)
								cSerieOrig,;		//Serie(NF)
								cForneceOr,;		//Fornecedor(NF)
								cLojoOrige,;		//Loja(NF)
								cLancOrige;			//ORIGLAN
								})
				
				DbSelectArea("TEMPSB8")
				DbSkip()
			EndDo
			TEMPSB8->(dbCloseArea())

			cMensa:="Gerando Lote p/ Grupo"
			
			If	Len( aArray ) > 0
				A010GerEst( aArray, cMensa, .F., 1 )
			EndIf
			
			aArray:={}

		Else

			cMsg := "Lote p/ Grupo, nao gerado."
			Help("",1,"JMHA010",,cMsg,1,0)
			TEMPSB8->(DbCloSeArea())

		EndIf
		
	Else

		cMsg := "Este documento de entrada nao e Normal"
		Help("",1,"JMHA010",,cMsg,1,0)

	EndIf

	RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA010VericaบAutor  ณAndre Luis          บ Data ณ  08/21/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Funcao que verifica no estorno se nao tem lote consumido  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A010Verica(aLote)

Local aArea	  := GetArea()
Local lRet 	  := .T.
Local cQuery  := ""

cQuery := " SELECT COUNT(*) Quant "
cQuery += " FROM 	" + RetSQLName("SB8")
cQuery += " WHERE	B8_FILIAL	= '" + xFilial("SB8")	+ "'"
cQuery += "    AND B8_DOCORI = '"    + aLote[1]		    +"'"
cQuery += "    AND B8_SERORI = '"    + aLote[2]		    +"'"
cQuery += "    AND B8_FORORI = '"    + aLote[3]         +"'"
cQuery += "    AND B8_LOJORI = '"    + aLote[4]	 		+"'"
cQuery += "    AND B8_SALDO  = 0"
cQuery += "    AND B8_LANORI = 'NF'"
cQuery += "    ANDD_E_L_E_T_ <> '*'"
cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRAB1", .F., .T.)

TRAB1->( dbGoTop() )

lRet := ( TRAB1->QUANT = 0 )

TRAB1->( dbCloseArea() )
IF (lRet== .T.)
	
	cQuery := " SELECT D3_DOC, D3_EMISSAO "
	cQuery += " FROM 	" + RetSQLName("SD3")
	cQuery += " WHERE	D3_FILIAL	= '" + xFilial("SD3")	+ "'"
	cQuery += " 	AND	D3_DOCORI	= '" + aLote[1]     	+ "'"
	cQuery += " 	AND	D3_SERORI	= '" + aLote[2]     	+ "'"
	cQuery += " 	AND	D3_FORORI	= '" + aLote[3]     	+ "'"
	cQuery += " 	AND	D3_LOJORI	= '" + aLote[4]     	+ "'"
	cQuery += " 	AND	D3_LANORI	= 'NF'"
	cQuery += " 	AND	D3_TM		= '999'" // Transferencia ( ORIGEM )
	cQuery += " 	AND	D3_ESTORNO	<> 'S'"
	cQuery += " 	AND	D_E_L_E_T_ <> '*'"
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPD3", .F., .T.)
	IF!EOF()
		
		lRet 	  := .T.
	Else
		lRet 	  := .F.
	EndIF
	TMPD3->( dbCloseArea() )
EndIF

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA010Doc   บAutor  ณAndre Luis          บ Data ณ  08/21/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Funcao que gera lote unitario e estorna p/documento       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A010Doc(ALIAS,nP,nOpcx)


Local cMsg	:= ""	
Local lTrans :=.F.
Local cMensa :=""
Local aArray :={}
Local aArea	:= GetArea()


If Empty(SB8->B8_ORIGLAN)

	cMsg := "Registro de Saldo por Lote com Origem Desconhecida."                 + CRLF
	cMsg += "Para esse tipo de saldo, utilize a rotina padrใo em:"                + CRLF
	cMsg += "Estoque/Custos > Atualiza็๕es > Movmtos. Internos > Transf. (mod.2)" + CRLF
	cMsg += "No browse clique em: Incluir"                                        + CRLF
	cMsg += "Em A็๕es relacionadas > Gerar lote unitario"                         + CRLF 
	cMsg += CRLF
	cMsg += "Anote os dados para a Gera็ใo:"                                      + CRLF
	cMsg += "Documento: "         + SB8->B8_DOC                                   + CRLF
	cMsg += "S้rie: "             + SB8->B8_SERIE                                 + CRLF
	cMsg += "C๓digo Fornecedor: " + SB8->B8_CLIFOR                                + CRLF
	cMsg += "Loja Fornecedor: "   + SB8->B8_LOJA                                  + CRLF
	cMsg += "Produto: "           + SB8->B8_PRODUTO                               + CRLF
	cMsg += "Lote: "              + SB8->B8_LOTECTL                               + CRLF

// Cristiano Oliveira - Copiar informacoes do AVISO - 20/12/2016
  
	DEFINE MSDIALOG oVCan FROM 05,10 TO 400,650 TITLE "LOTE UNITARIO" PIXEL
	@ 12,08 GET oObs VAR cMsg OF oVCan MEMO SIZE 300,150 PIXEL
	DEFINE SBUTTON FROM 180,250 TYPE 1 ACTION (nOpca := 1,oVCan:End()) ENABLE OF oVCan
	ACTIVATE MSDIALOG oVCan CENTER

//	Aviso("Aten็ใo",cMsg,{"Ok"},1)

Else

	lTrans:=.T.
	//cMensa:=IIF(nOpcx==5,"Estornando Lote unitario","Gerando Lote unitario")            // Marllon: sera necessario alterar a opcao para 7
	//lEstor:=IIF(nOpcx==5,.T.,.F.)//Verdadeiro -Estorna lote, falso Transfere lote
	cMensa:=IIF(nOpcx==7,"Estornando Lote unitario","Gerando Lote unitario")            // Marllon: sera necessario alterar a opcao para 7
	lEstor:=IIF(nOpcx==7,.T.,.F.)//Verdadeiro -Estorna lote, falso Transfere lote
	
	nLinha:=1
	
	IF SB8->B8_LOTEUNI <> "S"
		
		IF SB8->B8_SALDO==0
			lTrans:=.F.
			
			cMsg := "Saldo indisponivel!" + CRLF
			
			Help("",1,"JMHA010",,cMsg,1,0)
		EndIf
		IF lTrans
			IF nOpcx==7
				//Funcao que verifica na hora de estorna lote, se tem registro consumido
				If! A010Verica({SB8->B8_DOC,SB8->B8_SERIE,SB8->B8_CLIFOR,SB8->B8_LOJA})
					
					cMsg := "Impossivel Estornar o documento!" + CRLF
					lTrans:=.F.
					Help("",1,"JMHA010",,cMsg,1,0)
				EndIf
			EndIF
		EndIF
	Else
		cMsg   := "Nao e lote de fornecedor." + CRLF
		Help("",1,"JMHA010",,cMsg,1,0)
		lTrans :=.F.
	EndIF
	
	
	//IF (lTrans==.T.)
	IF lTrans .or. lEstor    // Marllon
		  
		  //estorna por lote unitario
		//If nOpcx==5   // Marllon: tem que trocar para 7
		If nOpcx==7   
			
			cDocOrigem := SB8->B8_DOC        // SB8->B8_DOCORI //documento origem
			cSerieOrig := SB8->B8_SERIE      // SB8->B8_SERORI //serie origem
			cForneceOr := SB8->B8_CLIFOR     // SB8->B8_FORORI //fornecedor origem
			cLojoOrige := SB8->B8_LOJA       // SB8->B8_LOJORI //loja origem
			cLancOrige := SB8->B8_ORIGLAN    // SB8->B8_LANORI
		Else //gera lote
			cDocOrigem := SB8->B8_DOC		//Documento(NF)
			cSerieOrig := SB8->B8_SERIE	    //Serie(NF)
			cForneceOr := SB8->B8_CLIFOR	//Fornecedor(NF)
			cLojoOrige := SB8->B8_LOJA	    //Loja(NF)
			cLancOrige := SB8->B8_ORIGLAN
			
		EndIf
		
		
		aAdd(aArray,{SB8->B8_PRODUTO,;	//Produto
					SB8->B8_LOCAL,;		//Local
					SB8->B8_SALDO,;		//Quantidade
					SB8->B8_DTVALID,;	//Data Validade
					SB8->B8_LOTECTL,;	//LoteCTL
					SB8->B8_DATA,;		//Emissao
					cDocOrigem,;		//Documento(NF)
					cSerieOrig,;		//Serie(NF)
					cForneceOr,;	    //Fornecedor(NF)
					cLojoOrige,;		//Loja(NF)
					cLancOrige;			//ORIGLAN
					})
		
	EnDIF
	
	
	//funcao que transfere lote ou estorna lote
	//IF (lTrans==.T.)
	IF lTrans .or. lEstor    // Marllon
		
		A010GerEst(aArray,cMensa,lEstor,nLinha)
	EndIf
	
	RestArea(aArea)
	
EndIf
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA010PergunบAutor  ณAndre Luis          บ Data ณ  08/21/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Funcao de perguntas que e chamada na hora                 บฑฑ
ฑฑบ          ณ  Lote p/documento ou Estorna p/documento                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010Pergun(cPerg)

Local aP	 := {}
Local aHelp	 := {}
Local nI	 := 0
Local cSeq	 := ""
Local cMvCh	 := ""
Local cMvPar := ""

//			Texto Pergunta	 Tipo 	Tam 	  						Dec   	G=get ou C=Choice  	Val  F3		Def01 	  Def02 	 Def03   Def04   Def05
aAdd(aP,{	"Documento ?",	"C",	TamSX3("F1_DOC")[1],			0,		"G",					"",	 "",		   "",		"",		"",		"",		""})
aAdd(aP,{	"Serie ?",			"C",	TamSX3("F1_SERIE")[1],		0,		"G",					"",	 "",		   "",		"",		"",		"",		""})
aAdd(aP,{	"Fornecedor ?",	"C",	TamSX3("F1_FORNECE")[1],		0,		"G",					"",	 "",		   "",		"",		"",		"",		""})
aAdd(aP,{	"Loja ?",			"C",	TamSX3("F1_LOJA")[1],		0,		"G",					"",	 "",		   "",		"",		"",		"",		""})

//           012345678912345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                    1         2         3         4         5         6         7         8         9        10        11        12
aAdd(aHelp, {"Numero do Documento de Entrada"})
aAdd(aHelp, {"Serie do Documento de Entrada"})
aAdd(aHelp, {"Codigo do Fornecedor"})
aAdd(aHelp, {"Loja do Fornecedor"})


For nI := 1 To Len(aP)
	
	cSeq	:= StrZero(nI,2,0)
	cMvPar	:= "mv_par"+cSeq
	cMvCh	:= "mv_ch"+IIF(nI<=9,Chr(nI+48),Chr(nI+87))
	
	PutSx1(cPerg,;
	cSeq,;
	aP[nI,1],aP[nI,1],aP[nI,1],;
	cMvCh,;
	aP[nI,2],;
	aP[nI,3],;
	aP[nI,4],;
	1,;
	aP[nI,5],;
	aP[nI,6],;
	aP[nI,7],;
	"",;
	"",;
	cMvPar,;
	aP[nI,8],aP[nI,8],aP[nI,8],;
	"",;
	aP[nI,9],aP[nI,9],aP[nI,9],;
	aP[nI,10],aP[nI,10],aP[nI,10],;
	aP[nI,11],aP[nI,11],aP[nI,11],;
	aP[nI,12],aP[nI,12],aP[nI,12],;
	aHelp[nI],;
	{},;
	{},;
	"")
	
Next nI

Return

Static Function A010GrpPergun( cPerg )

Local aP	 := {}
Local aHelp	 := {}
Local nI	 := 0
Local cSeq	 := ""
Local cMvCh	 := ""
Local cMvPar := ""

//			Texto Pergunta	 Tipo 	Tam 	  						Dec   	G=get ou C=Choice  	Val  F3		Def01 	  Def02 	 Def03   Def04   Def05
aAdd(aP,{	"Grupo ?",	"C",	TamSX3("B1_GRUPO")[1],			0,		"G",					"",	 "SBM",		   "",		"",		"",		"",		""})
aAdd(aP,{	"Lote ?",	"C",	TamSX3("B8_LOTECTL")[1],			0,		"G",					"",	 "",		   "",		"",		"",		"",		""})

//           0123456789123456789012345678901234567890
//                    1         2         3         4
aAdd(aHelp, {"Grupo de Produtos para Gera็ใo Lote ", "ฺnico"})
aAdd(aHelp, {"Lote do Fornecedor para Gera็ใo Lote", "ฺnico"})

For nI := 1 To Len(aP)
	
	cSeq	:= StrZero(nI,2,0)
	cMvPar	:= "mv_par"+cSeq
	cMvCh	:= "mv_ch"+IIF(nI<=9,Chr(nI+48),Chr(nI+87))
	
	PutSx1(cPerg,;
	cSeq,;
	aP[nI,1],aP[nI,1],aP[nI,1],;
	cMvCh,;
	aP[nI,2],;
	aP[nI,3],;
	aP[nI,4],;
	1,;
	aP[nI,5],;
	aP[nI,6],;
	aP[nI,7],;
	"",;
	"",;
	cMvPar,;
	aP[nI,8],aP[nI,8],aP[nI,8],;
	"",;
	aP[nI,9],aP[nI,9],aP[nI,9],;
	aP[nI,10],aP[nI,10],aP[nI,10],;
	aP[nI,11],aP[nI,11],aP[nI,11],;
	aP[nI,12],aP[nI,12],aP[nI,12],;
	aHelp[nI],;
	{},;
	{},;
	"")
	
Next nI

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA010GerEstบAutor  ณAndre Luis          บ Data ณ  08/21/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Funcao que gera lote ou estorna                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A010GerEst(aRegistro,cMensa,lOk,nLinha)

	MsAguarde({||  u_JMHF080(aRegistro, lOk,nLinha)},"Aguarde!",cMensa,.F.)

Return
