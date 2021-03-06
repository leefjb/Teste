/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � MTSLDLOT � Autor � Fabio Briddi          � Data � Ago/2014 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� P.E. Avalia se Utiliza ou Registro                         ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � ExpA1 := Estrut(ExpC1, ExpN1, ExpL1, ExpL2)                ���
�������������������������������������������������������������������������Ĵ��
���Localiz.  � Utilizado para manipulacao do Registro de movimenta��o     ���
���          � interna de transfer�ncia (RE4) gerado pela rotina MATA261  ���
���          �                                                            ���
���          � Chamado apos a gravacao dos movimentos do registro de      ���
���          � de Saida RE4.                                              ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ParamIxb[01] - Caracter - Codigo do Produto                ���
���          � ParamIxb[02] - Caracter - Local (Almoxarifado)             ���
���          � ParamIxb[03] - Caracter - Lote                             ���
���          � ParamIxb[04] - Caracter - Lote Fornecedor                  ���
���          � ParamIxb[05] - Caracter - Localizacao                      ���
���          � ParamIxb[06] - Caracter - Numero de Serie                  ���
���          � ParamIxb[07] - Numerico - Quantidade Empenho               ���
���          � ParamIxb[08] - Logico   - Consulta                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno:  � lRet - .T. = Utiliza Registro / .F. - Nao Utiliza Registro ���
�������������������������������������������������������������������������Ĵ��
���Observa��o� Utilizado para Descartar uso indevido de Lotes que nao     ���
���          � tenham sido gerados pela rotina de Lote Unico              ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Jomhedica / Faturamento                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function _MTSLDLOT()

	Local cProduto := AllTrim(ParamIxb[01])
	Local cLocal   := AllTrim(ParamIxb[02])
	Local cLoteCtl := AllTrim(ParamIxb[03])
	Local cNumLote := AllTrim(ParamIxb[04])
	Local lRet     := .T.
	Local aAreaSB8 := SB8->(GetArea())
	
	
	//-- Somente Libera o Lote para Liberacao se for gerado pela rotina Lote Unico
	
	If	( "MATA410" $ AllTrim(FunName()) ) .Or.;
		( "MATA440" $ AllTrim(FunName()) ) .Or.;
		( "MATA45"  $ AllTrim(FunName()) )		//-- Para Executar somente nas Liberacoes e Pedidos de Vendas
	
		cChvSeek := xFilial("SB8")
		cChvSeek += PadR(cProduto , TamSX3("B8_PRODUTO")[1])
		cChvSeek += PadR(cLocal   , TamSX3("B8_LOCAL")[1])
		cChvSeek += PadR(cLoteCtl , TamSX3("B8_LOTECTL")[1])
		cChvSeek += PadR(cNumLote , TamSX3("B8_NUMLOTE")[1])
	
		SB8->( dbSetOrder(3) ) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
	
		If	SB8->( dbSeek( cChvSeek ) )
	
			If	SB8->B8_LOTEUNI <> "S"
	
				lRet := .F.
			EndIf
	
		Else
	
			lRet := .F.
		EndIf
	
	EndIf
	
	RestArea(aAreaSB8)

Return( lRet )

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/
