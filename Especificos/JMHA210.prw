#INCLUDE 'PROTHEUS.CH'

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � JMHA210  � Autor � Jeferson Dambros      � Data �Ago/2013   ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Calculo de comissao                                         ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   � u_JMHA210                                                   ���
��������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                            ���
��������������������������������������������������������������������������Ĵ��
���Programador    � Data       � Motivo da Alteracao                       ���
��������������������������������������������������������������������������Ĵ��
���Jean Rehermann � 30/08/2016 � Padroniza��o de fonte e tabela de auditoria��
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
/*/
User Function JMHA210()                                                                   

	Local aSays		:= {}
	Local aButtons	:= {}
	Local cCadastro	:= OemToAnsi("Calculo de Comissao Jomhedica ")
	Local nOpca		:= 0
	Local cPerg		:= ""
	Private oProcess
	
	cPerg := CriaSx1()

	aAdd(aSays,OemToAnsi('Este programa tem o objetivo Gerar Comiss�es relativas as Vendas ') )
	aAdd(aSays,OemToAnsi('conforme os parametros informados.') )
	aAdd(aSays,OemToAnsi('') )
	aAdd(aSays,OemToAnsi('Especifico Jomhedica.' ) )  
	
	aAdd(aButtons, {  5,.T.,{ || Pergunte("AFI440",.T.) } } )
	aAdd(aButtons, {  1,.T.,{ |o| nOpca := 1,IF( gpconfOK(), FechaBatch(), nOpca := 0 ) } } )
	aAdd(aButtons, {  2,.T.,{ |o| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpca == 1
	    
		oProcess := MsNewProcess():New({|| GeraComis() }, "Calculo de Comissao ", "Calculando...",.F.)
		oProcess:Activate()
	
	Endif

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �GeraComis � Autor �  Jeferson Dambros     � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gerar Comissao de Venda.                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GeraComis()                                                ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function GeraComis()

	Local cQuery	:= ""
	Local cDelete	:= ""
	Local nRegistros:= 0
	Local nPComis	:= 0
	Local nValComis	:= 0
	Local nComissa	:= 0
	Local nTotNota	:= 0
	Local nValBase	:= 0
	Local nQtdParc	:= 0
	Local nPercent	:= 0
	Local nValBsItem:= 0
	Local nComisIt  := 0
	Local nValDesc	:= 0
	Local nPerDesc	:= 0
	Local cTitulo	:= ""
	Local cVendedor	:= ""
	Local cGrupo	:= ""
	Local aVend		:= {}
	Local aNF		:= {}
	Local aBaseFaixa:= {}
	Local cTipoCalc := ""
	Local nJ        := 0
	Local _jX       := 0
	Local nI        := 0
	Local nX        := 0
	/*  
	Parametros:
	mv_par01 = Data Inicial
	mv_par02 = Data Final
	mv_par03 = Do Vendedor
	mv_par04 = At� o Vendedor
	*/
	
	//Grupo de perguntas padr�o da rotina de recalculo de comissao
	Pergunte("AFI440",.F.)
			
	SF2->( dbSetOrder(1) )
	SE4->( dbSetOrder(1) )


	cQuery  :=	cQuery1  := cQuery2  :=	cQuery3  :=	cQuery4  := ""
	
   	// Excluir as comiss�es geradas anteriormente pelo programa JMHA210, n�o baixadas, do vendedor e per�odo informados
   	cDelete := " DELETE "
   	cDelete += " FROM " + RetSqlName("SE3") 
	cDelete += " WHERE   E3_FILIAL     = '" + xFilial('SE3') + "'"
	cDelete += "   AND   E3_DATA       = ''"
	cDelete += "   AND   E3_EMISSAO    >= '" + DtoS(MV_PAR01)	+ "'"
	cDelete += "   AND   E3_EMISSAO    <= '" + DtoS(MV_PAR02)	+ "'"
	cDelete += "   AND   E3_VEND       >= '" + MV_PAR03       	+ "'"
	cDelete += "   AND   E3_VEND       <= '" + MV_PAR04        	+ "'"
	cDelete += "   AND   E3_ORIPROG     = 'JMHA210'"  //Campo Especifico
	
	TcSqlExec( cDelete )

	// *****  TITULOS NORMAIS
	cQuery1  += "SELECT A1_NOME, B1_GRUPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_VENCREA, "
	cQuery1  +=        "E3_CODCLI, E3_LOJA, E3_BASE, E3_SERIE, E3_EMISSAO, E3_SEQ, E3_VEND, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO," 
	cQuery1  +=        "D2_DOC, D2_SERIE, D2_TOTAL, D2_DESC, D2_PEDIDO, D2_COD , D2_PRCVEN, D2_CUSTO1, D2_VALICM, D2_VALIPI "
	
	cQuery1  += "FROM " + RetSqlName("SE3") +" SE3 (NOLOCK), " 
	cQuery1  += "     " + RetSqlName("SD2") +" SD2 (NOLOCK), " 
	cQuery1  += "     " + RetSqlName("SB1") +" SB1 (NOLOCK), " 
	cQuery1  += "     " + RetSqlName("SF4") +" SF4 (NOLOCK), " 
	cQuery1  += "     " + RetSqlName("SA1") +" SA1 (NOLOCK), " 
	cQuery1  += "     " + RetSqlName("SE1") +" SE1 (NOLOCK) " 

	cQuery1  += "WHERE E3_FILIAL       = '" + xFilial('SE3') + "' "
	cQuery1  += "AND   E3_DATA         = '' "
	cQuery1  += "AND   E3_EMISSAO     >= '" + DtoS(MV_PAR01) + "' "
	cQuery1  += "AND   E3_EMISSAO     <= '" + DtoS(MV_PAR02) + "' "
	cQuery1  += "AND   E3_VEND        >= '" + MV_PAR03        + "' "
	cQuery1  += "AND   E3_VEND        <= '" + MV_PAR04        + "' "  
	
	cQuery1  += "AND   D2_FILIAL       = '" + xFilial('SD2') + "' "
	cQuery1  += "AND   D2_DOC          = E3_NUM "
	cQuery1  += "AND   D2_SERIE        = E3_SERIE "
	cQuery1  += "AND   D2_CLIENTE      = E3_CODCLI "
	cQuery1  += "AND   D2_LOJA         = E3_LOJA "
	
	cQuery1  += "AND   B1_FILIAL       = '" + xFilial('SB1') + "' "
	cQuery1  += "AND   B1_COD          = D2_COD "
	
	cQuery1  += "AND   F4_FILIAL       = '" + xFilial('SF4') + "' "
	cQuery1  += "AND   F4_CODIGO       = D2_TES "
	cQuery1  += "AND   F4_DUPLIC       = 'S' "
	
	cQuery1  += "AND   A1_FILIAL       = '" + xFilial('SA1') + "' "
	cQuery1  += "AND   A1_COD          = D2_CLIENTE "
	cQuery1  += "AND   A1_LOJA         = D2_LOJA "
	
	cQuery1  += "AND   E1_FILIAL       = '" + xFilial('SE1') + "' "
	cQuery1  += "AND   E1_NUM          = E3_NUM "
	cQuery1  += "AND   E1_PREFIXO      = E3_PREFIXO "
	cQuery1  += "AND   E1_PARCELA      = E3_PARCELA "
	cQuery1  += "AND   E1_TIPO         = E3_TIPO "
	cQuery1  += "AND   E1_VEND1 	      = E3_VEND "
	      
	cQuery1  += "AND   SE3.D_E_L_E_T_  <> '*' "
	cQuery1  += "AND   SD2.D_E_L_E_T_  <> '*' "
	cQuery1  += "AND   SB1.D_E_L_E_T_  <> '*' "
	cQuery1  += "AND   SF4.D_E_L_E_T_  <> '*' "
	cQuery1  += "AND   SA1.D_E_L_E_T_  <> '*' "
	cQuery1  += "AND   SE1.D_E_L_E_T_  <> '*' "
	     
	// ***** LIQUIDACOES DE TITULOS NORMAIS
	cQuery2  += "SELECT A1_NOME, B1_GRUPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_VENCREA, "
	cQuery2  +=        "E3_CODCLI, E3_LOJA, E3_BASE, E3_SERIE, E3_EMISSAO, E3_SEQ, E3_VEND, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO," 
	cQuery2  +=        "D2_DOC, D2_SERIE, D2_TOTAL, D2_DESC, D2_PEDIDO, D2_COD , D2_PRCVEN, D2_CUSTO1, D2_VALICM, D2_VALIPI "

	cQuery2  += "FROM " + RetSqlName("SE3") +" SE3 (NOLOCK) , "
	cQuery2  += "     " + RetSqlName("SE5") +" SE5 (NOLOCK) , "	 
	cQuery2  += "     " + RetSqlName("SD2") +" SD2 (NOLOCK) , " 
	cQuery2  += "     " + RetSqlName("SB1") +" SB1 (NOLOCK) , " 
	cQuery2  += "     " + RetSqlName("SF4") +" SF4 (NOLOCK) , " 
	cQuery2  += "     " + RetSqlName("SA1") +" SA1 (NOLOCK) , " 
	cQuery2  += "     " + RetSqlName("SE1") +" SE1 (NOLOCK) " 

	cQuery2  += "WHERE E3_FILIAL       = '" + xFilial('SE3') + "' "
	cQuery2  += "AND   E3_DATA         = '' "
	cQuery2  += "AND   E3_EMISSAO     >= '" + DtoS(MV_PAR01) + "' "
	cQuery2  += "AND   E3_EMISSAO     <= '" + DtoS(MV_PAR02) + "' "
	cQuery2  += "AND   E3_VEND        >= '" + MV_PAR03        + "' "
	cQuery2  += "AND   E3_VEND        <= '" + MV_PAR04        + "' "
	      
	cQuery2  += "AND   E5_FILIAL       = '" + xFilial('SE5') + "' "
	cQuery2  += "AND   E5_DOCUMEN      IN ( SELECT DISTINCT E1_NUMLIQ "
	cQuery2  +=                          " FROM " + RetSqlName("SE1") + " SSE1 (NOLOCK) "
	cQuery2  +=                          " WHERE SSE1.E1_FILIAL   = '" + xFilial('SE1') + "' "
	cQuery2  +=                          "   AND SSE1.E1_PREFIXO  = E3_PREFIXO "
	cQuery2  +=                          "   AND SSE1.E1_NUM      = E3_NUM "
	cQuery2  +=                          "   AND SSE1.E1_PARCELA  = E3_PARCELA "
	cQuery2  +=                          "   AND SSE1.E1_TIPO     = E3_TIPO "
	cQuery2  +=                          "   AND SSE1.E1_CLIENTE  = E3_CODCLI "
	cQuery2  +=                          "   AND SSE1.E1_LOJA     = E3_LOJA "
	cQuery2  +=                          "   AND SSE1.E1_NUMLIQ  <> '' "
	cQuery2  +=                          "   AND SSE1.D_E_L_E_T_  = '') "
	cQuery2  += "AND   E5_CLIFOR      = E3_CODCLI "
	cQuery2  += "AND   E5_LOJA        = E3_LOJA "
	cQuery2  += "AND   E5_RECPAG      = 'R' "
	
	cQuery2  += "AND   E1_FILIAL       = '" + xFilial('SE1') + "' "
	cQuery2  += "AND   E1_PREFIXO      = E5_PREFIXO "
	cQuery2  += "AND   E1_NUM          = E5_NUMERO "
	cQuery2  += "AND   E1_PARCELA      = E5_PARCELA "
	cQuery2  += "AND   E1_TIPO         = E5_TIPO "
	cQuery2  += "AND   E1_CLIENTE      = E5_CLIFOR "
	cQuery2  += "AND   E1_LOJA         = E5_LOJA "
	cQuery2  += "AND   E1_VEND1 	      = E3_VEND "
		
	cQuery2  += "AND   D2_FILIAL       = '" + xFilial('SD2') + "' "
	cQuery2  += "AND   D2_DOC          = E1_NUM "
	cQuery2  += "AND   D2_SERIE        = E1_SERIE "
	cQuery2  += "AND   D2_CLIENTE      = E1_CLIENTE "
	cQuery2  += "AND   D2_LOJA         = E1_LOJA "
	
	cQuery2  += "AND   B1_FILIAL       = '" + xFilial('SB1') + "' "
	cQuery2  += "AND   B1_COD          = D2_COD "
	
	cQuery2  += "AND   F4_FILIAL       = '" + xFilial('SF4') + "' "
	cQuery2  += "AND   F4_CODIGO       = D2_TES "
	cQuery2  += "AND   F4_DUPLIC       = 'S' "
	
	cQuery2  += "AND   A1_FILIAL       = '" + xFilial('SA1') + "' "
	cQuery2  += "AND   A1_COD          = D2_CLIENTE "
	cQuery2  += "AND   A1_LOJA         = D2_LOJA "
	
	cQuery2  += "AND   SE3.D_E_L_E_T_  <> '*' "
	cQuery2  += "AND   SE5.D_E_L_E_T_  <> '*' "
	cQuery2  += "AND   SE1.D_E_L_E_T_  <> '*' "
	cQuery2  += "AND   SD2.D_E_L_E_T_  <> '*' "
	cQuery2  += "AND   SB1.D_E_L_E_T_  <> '*' "
	cQuery2  += "AND   SF4.D_E_L_E_T_  <> '*' "
	cQuery2  += "AND   SA1.D_E_L_E_T_  <> '*' "

	cQuery2  += "GROUP BY A1_NOME, B1_GRUPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_VENCREA, "
	cQuery2  +=          "E3_CODCLI, E3_LOJA, E3_BASE, E3_SERIE, E3_EMISSAO, E3_SEQ, E3_VEND, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO," 
	cQuery2  +=          "D2_DOC, D2_SERIE, D2_TOTAL, D2_DESC, D2_PEDIDO, D2_COD , D2_PRCVEN, D2_CUSTO1, D2_VALICM, D2_VALIPI, D2_ITEM "

	// ***** FATURAS
	cQuery3  += "SELECT A1_NOME, B1_GRUPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_VENCREA, "
	cQuery3  +=        "E3_CODCLI, E3_LOJA, E3_BASE, E3_SERIE, E3_EMISSAO, E3_SEQ, E3_VEND, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO," 
	cQuery3  +=        "D2_DOC, D2_SERIE, D2_TOTAL, D2_DESC, D2_PEDIDO, D2_COD , D2_PRCVEN, D2_CUSTO1, D2_VALICM, D2_VALIPI "

	cQuery3  += "FROM " + RetSqlName("SE3") +" SE3 (NOLOCK) , "
	cQuery3  += "     " + RetSqlName("SE5") +" SE5 (NOLOCK) , "	 
	cQuery3  += "     " + RetSqlName("SD2") +" SD2 (NOLOCK) , " 
	cQuery3  += "     " + RetSqlName("SB1") +" SB1 (NOLOCK) , " 
	cQuery3  += "     " + RetSqlName("SF4") +" SF4 (NOLOCK) , " 
	cQuery3  += "     " + RetSqlName("SA1") +" SA1 (NOLOCK) , " 
	cQuery3  += "     " + RetSqlName("SE1") +" SE1 (NOLOCK) " 

	cQuery3  += "WHERE E3_FILIAL       = '" + xFilial('SE3') + "' "
	cQuery3  += "AND   E3_DATA         = '' "
	cQuery3  += "AND   E3_EMISSAO     >= '" + DtoS(MV_PAR01) + "' "
	cQuery3  += "AND   E3_EMISSAO     <= '" + DtoS(MV_PAR02) + "' "
	cQuery3  += "AND   E3_VEND        >= '" + MV_PAR03        + "' "
	cQuery3  += "AND   E3_VEND        <= '" + MV_PAR04        + "' "
	
	cQuery3  += "AND   E5_FILIAL       = '" + xFilial('SE5') + "' "
	cQuery3  += "AND   E5_FATURA       = E3_NUM "
	cQuery3  += "AND   E5_FATPREF      = E3_PREFIXO "
	cQuery3  += "AND   E5_MOTBX        = 'FAT' "
	cQuery3  += "AND   E5_CLIFOR       = E3_CODCLI "
	cQuery3  += "AND   E5_LOJA         = E3_LOJA "
	cQuery3  += "AND   E5_RECPAG       = 'R' "
	
	cQuery3  += "AND   E1_FILIAL       = '" + xFilial('SE1') + "' "
	cQuery3  += "AND   E1_PREFIXO      = E5_PREFIXO "
	cQuery3  += "AND   E1_NUM          = E5_NUMERO "
	cQuery3  += "AND   E1_PARCELA      = E5_PARCELA "
	cQuery3  += "AND   E1_TIPO         = E5_TIPO "
	cQuery3  += "AND   E1_CLIENTE      = E5_CLIFOR "
	cQuery3  += "AND   E1_LOJA         = E5_LOJA "
	cQuery3  += "AND   E1_VEND1 	      = E3_VEND "
		
	cQuery3  += "AND   D2_FILIAL       = '" + xFilial('SD2') + "' "
	cQuery3  += "AND   D2_DOC          = E1_NUM "
	cQuery3  += "AND   D2_SERIE        = E1_SERIE "
	cQuery3  += "AND   D2_CLIENTE      = E1_CLIENTE "
	cQuery3  += "AND   D2_LOJA         = E1_LOJA "
	
	cQuery3  += "AND   B1_FILIAL       = '" + xFilial('SB1') + "' "
	cQuery3  += "AND   B1_COD          = D2_COD "
	
	cQuery3  += "AND   F4_FILIAL       = '" + xFilial('SF4') + "' "
	cQuery3  += "AND   F4_CODIGO       = D2_TES "
	cQuery3  += "AND   F4_DUPLIC       = 'S' "
	
	cQuery3  += "AND   A1_FILIAL       = '" + xFilial('SA1') + "' "
	cQuery3  += "AND   A1_COD          = D2_CLIENTE "
	cQuery3  += "AND   A1_LOJA         = D2_LOJA "
	
	cQuery3  += "AND   SE3.D_E_L_E_T_  <> '*' "
	cQuery3  += "AND   SE5.D_E_L_E_T_  <> '*' "
	cQuery3  += "AND   SE1.D_E_L_E_T_  <> '*' "
	cQuery3  += "AND   SD2.D_E_L_E_T_  <> '*' "
	cQuery3  += "AND   SB1.D_E_L_E_T_  <> '*' "
	cQuery3  += "AND   SF4.D_E_L_E_T_  <> '*' "
	cQuery3  += "AND   SA1.D_E_L_E_T_  <> '*' "

	cQuery3  += "GROUP BY A1_NOME, B1_GRUPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_VENCREA, "
	cQuery3  +=          "E3_CODCLI, E3_LOJA, E3_BASE, E3_SERIE, E3_EMISSAO, E3_SEQ, E3_VEND, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO," 
	cQuery3  +=          "D2_DOC, D2_SERIE, D2_TOTAL, D2_DESC, D2_PEDIDO, D2_COD , D2_PRCVEN, D2_CUSTO1, D2_VALICM, D2_VALIPI, D2_ITEM "

	// ***** LIQUIDACOES DE FATURAS(FT)
	cQuery4  += "SELECT A1_NOME, B1_GRUPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_VENCREA, "
	cQuery4  +=        "E3_CODCLI, E3_LOJA, E3_BASE, E3_SERIE, E3_EMISSAO, E3_SEQ, E3_VEND, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO," 
	cQuery4  +=        "D2_DOC, D2_SERIE, D2_TOTAL, D2_DESC, D2_PEDIDO, D2_COD , D2_PRCVEN, D2_CUSTO1, D2_VALICM, D2_VALIPI "

	cQuery4  += "FROM " + RetSqlName("SE3") +" SE3 (NOLOCK), "
	cQuery4  += "     " + RetSqlName("SE5") +" SE5 (NOLOCK), "	 
	cQuery4  += "     " + RetSqlName("SD2") +" SD2 (NOLOCK), " 
	cQuery4  += "     " + RetSqlName("SB1") +" SB1 (NOLOCK), " 
	cQuery4  += "     " + RetSqlName("SF4") +" SF4 (NOLOCK), " 
	cQuery4  += "     " + RetSqlName("SA1") +" SA1 (NOLOCK), " 
	cQuery4  += "     " + RetSqlName("SE1") +" SE1 (NOLOCK) " 

	cQuery4  += "WHERE E3_FILIAL       = '" + xFilial('SE3') + "' "
	cQuery4  += "AND   E3_DATA         = '' "
	cQuery4  += "AND   E3_EMISSAO     >= '" + DtoS(MV_PAR01) + "' "
	cQuery4  += "AND   E3_EMISSAO     <= '" + DtoS(MV_PAR02) + "' "
	cQuery4  += "AND   E3_VEND        >= '" + MV_PAR03        + "' "
	cQuery4  += "AND   E3_VEND        <= '" + MV_PAR04        + "' "
	
	cQuery4  += "AND   E5_FILIAL       = '" + xFilial('SE5') + "' "
	cQuery4  += "AND   E5_FATURA       IN ( SELECT DISTINCT E5_NUMERO FROM " + RetSqlName("SE5")+" SSE5 (NOLOCK) "
	cQuery4  += "			               WHERE SSE5.E5_DOCUMEN  IN ( SELECT DISTINCT E1_NUMLIQ   "
	cQuery4  += "		                                              FROM " + RetSqlName("SE1")+" SSE1 (NOLOCK) "
	cQuery4  += "	                          		                  WHERE SSE1.E1_FILIAL   = '01'      "
	cQuery4  += "                          			                   AND SSE1.E1_PREFIXO  = E3_PREFIXO "
	cQuery4  += "                         		 	                   AND SSE1.E1_NUM      = E3_NUM     "
	cQuery4  += "                          			                   AND SSE1.E1_PARCELA  = E3_PARCELA "
	cQuery4  += "                          			                   AND SSE1.E1_TIPO     = E3_TIPO    "
	cQuery4  += "                          			                   AND SSE1.E1_CLIENTE  = E3_CODCLI  "
	cQuery4  += "	                          			               AND SSE1.E1_LOJA     = E3_LOJA    "
	cQuery4  += "                          			                   AND SSE1.E1_NUMLIQ  <> ''         "
	cQuery4  += " 		                        	                   AND SSE1.D_E_L_E_T_  = '' )       "
	cQuery4  += "			                 AND SSE5.E5_TIPODOC = 'BA'  "
	cQuery4  += "                       	     AND SSE5.E5_MOTBX = 'LIQ'   "
	cQuery4  += "                       	     AND SSE5.D_E_L_E_T_  = '' ) "
	cQuery4  += "AND   E5_MOTBX        = 'FAT' "
	cQuery4  += "AND   E5_TIPODOC      = 'BA'  "
	cQuery4  += "AND   E5_CLIFOR       = E3_CODCLI "
	cQuery4  += "AND   E5_LOJA         = E3_LOJA "
	cQuery4  += "AND   E5_RECPAG       = 'R' "
	
	cQuery4  += "AND   E1_FILIAL       = '" + xFilial('SE1') + "' "
	cQuery4  += "AND   E1_PREFIXO      = E5_PREFIXO "
	cQuery4  += "AND   E1_NUM          = E5_NUMERO "
	cQuery4  += "AND   E1_PARCELA      = E5_PARCELA "
	cQuery4  += "AND   E1_TIPO         = E5_TIPO "
	cQuery4  += "AND   E1_CLIENTE      = E5_CLIFOR "
	cQuery4  += "AND   E1_LOJA         = E5_LOJA "
	cQuery4  += "AND   E1_VEND1 	      = E3_VEND "
		
	cQuery4  += "AND   D2_FILIAL       = '" + xFilial('SD2') + "' "
	cQuery4  += "AND   D2_DOC          = E1_NUM "
	cQuery4  += "AND   D2_SERIE        = E1_SERIE "
	cQuery4  += "AND   D2_CLIENTE      = E1_CLIENTE "
	cQuery4  += "AND   D2_LOJA         = E1_LOJA "
	
	cQuery4  += "AND   B1_FILIAL       = '" + xFilial('SB1') + "' "
	cQuery4  += "AND   B1_COD          = D2_COD "
	
	cQuery4  += "AND   F4_FILIAL       = '" + xFilial('SF4') + "' "
	cQuery4  += "AND   F4_CODIGO       = D2_TES "
	cQuery4  += "AND   F4_DUPLIC       = 'S' "
	
	cQuery4  += "AND   A1_FILIAL       = '" + xFilial('SA1') + "' "
	cQuery4  += "AND   A1_COD          = D2_CLIENTE "
	cQuery4  += "AND   A1_LOJA         = D2_LOJA "
	
	cQuery4  += "AND   SE3.D_E_L_E_T_  <> '*' "
	cQuery4  += "AND   SE5.D_E_L_E_T_  <> '*' "
	cQuery4  += "AND   SE1.D_E_L_E_T_  <> '*' "
	cQuery4  += "AND   SD2.D_E_L_E_T_  <> '*' "
	cQuery4  += "AND   SB1.D_E_L_E_T_  <> '*' "
	cQuery4  += "AND   SF4.D_E_L_E_T_  <> '*' "
	cQuery4  += "AND   SA1.D_E_L_E_T_  <> '*' "
	                                             
	cQuery4  += "GROUP BY A1_NOME, B1_GRUPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_VENCREA, "
	cQuery4  +=          "E3_CODCLI, E3_LOJA, E3_BASE, E3_SERIE, E3_EMISSAO, E3_SEQ, E3_VEND, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO," 
	cQuery4  +=          "D2_DOC, D2_SERIE, D2_TOTAL, D2_DESC, D2_PEDIDO, D2_COD , D2_PRCVEN, D2_CUSTO1, D2_VALICM, D2_VALIPI, D2_ITEM "

	For nJ := 1 To 4 // Executar� cada umas das quatro queries acima
		       
		cQuery  := &( "cQuery"+Trim( cValToChar(nJ)) )

		cQuery  += " ORDER BY E3_VEND, B1_GRUPO, E3_PREFIXO, E3_NUM, E3_PARCELA, E3_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E3_SEQ "
		
		cQuery  := ChangeQuery(cQuery)
		
		MemoWrite("\cprova\JMHA210_"+ Trim( cValToChar(nJ))+".sql",cQuery)
		                           
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "COMISSAO", .F., .T.)
		
		// converte campos DATA/NUMERICO
		TCSetField("COMISSAO", "E1_EMISSAO", "D", 8, 0)
		TCSetField("COMISSAO", "E3_EMISSAO", "D", 8, 0)
		TCSetField("COMISSAO", "E3_BASE",    "N", 14,2)
		TCSetField("COMISSAO", "D2_TOTAL",   "N", 14,2)
		TCSetField("COMISSAO", "E1_VALOR",   "N", 14,2)
		TCSetField("COMISSAO", "E1_VENCREA", "D", 8, 0)
			
		Count To nRegistros
		
		oProcess:SetRegua2(nRegistros)
	
		COMISSAO->( dbGoTop() )
		While COMISSAO->( !Eof() )
		
			cVendedor	:= COMISSAO->E3_VEND
			cGrupo		:= COMISSAO->B1_GRUPO
		
			aAdd(aVend, {	cVendedor	,;
						   	cGrupo		,;
						   	0		  	,;// 3 ( descontinuado 'o calculo e feito por NF' ) --> Valor Total do grupo de produto
						   	0			,;// 4 ( descontinuado 'o calculo e feito por ITEM DA NF' ) --> % Total de desconto do grupo de produto  
						   	0			,;// 5 ( descontinuado 'o calculo e feito por NF' ) --> % FAIXA aplicada ao grupo de produto ( com base no Valor total)
							{}			})// 6 Array com as NFs do VENDEDOR + GRUPO
							
			cTipoCalc	:= ""
			nTotNota	:= 0
			aNf  		:= {}
			
			While COMISSAO->( !Eof() )  .And. cVendedor	== COMISSAO->E3_VEND;
										.And. cGrupo	== COMISSAO->B1_GRUPO
											
				// Posiciono na nota 
				SF2->( dbSeek(xFilial("SF2")+COMISSAO->(E1_NUM+E1_PREFIXO+E3_CODCLI+E3_LOJA) ) )
				
				// Condicao de pagamento
				SE4->( dbSeek(xFilial("SE4")+SF2->F2_COND) )
	
				// Quantidade de parcelas
				nQtdParc := RetQtdParc(SE4->E4_COND, COMISSAO->E1_PREFIXO, COMISSAO->E1_NUM, COMISSAO->E1_TIPO)
				
				nPerDesc := 0
				// T�tulo de liquida��o ou fatura
				If  COMISSAO->E1_PREFIXO <> COMISSAO->E3_PREFIXO .Or. COMISSAO->E1_NUM <> COMISSAO->E3_NUM .Or. ;
				    COMISSAO->E1_PARCELA <> COMISSAO->E3_PARCELA .Or. COMISSAO->E1_TIPO <> COMISSAO->E3_TIPO 
	
					nPercPag := 1	
					nPercPag := RetPerLiq( COMISSAO->E3_PREFIXO, COMISSAO->E3_NUM, COMISSAO->E3_PARCELA, COMISSAO->E3_TIPO, COMISSAO->E3_BASE, COMISSAO->E3_VEND )
					
	                nPerDesc := 1 - nPercPag
				Else
					// Desconto Financeiro
					nValDesc := ( COMISSAO->E1_VALOR - COMISSAO->E3_BASE ) // Valor
					nPerDesc := ( nValDesc / COMISSAO->E1_VALOR )          // Percentual
				EndIf
				
				aAdd(aNF, { COMISSAO->E1_PREFIXO	,; // 01
							COMISSAO->E1_NUM		,; // 02
							COMISSAO->E1_PARCELA	,; // 03
							COMISSAO->E1_TIPO		,; // 04
							0						,; // 05 Valor BASE
							0						,; // 06 Valor da COMISSAO
							0						,; // 07 Percentual de COMISSAO
							COMISSAO->E3_CODCLI		,; // 08
							COMISSAO->E3_LOJA		,; // 09
							COMISSAO->E3_SEQ		,; // 10
							COMISSAO->E3_EMISSAO	,; // 11
							COMISSAO->D2_PEDIDO	    ,; // 12
							COMISSAO->E1_EMISSAO    ,; // 13
							nPerDesc * 100			,; // 14 Percentual de desconto
							COMISSAO->E3_PREFIXO    ,; // 15
							COMISSAO->E3_NUM        ,; // 16
							COMISSAO->E3_PARCELA    ,; // 17
							COMISSAO->E3_TIPO		,; // 18
							""                      ,; // 19 Codigo da faixa
							""                      ,; // 20 Tipo de faixa
							0						,; // 21 Total acumulado nesta faixa
							{}                      ,; // 22 Itens da NF
							COMISSAO->E1_VENCREA    ,; // 23 Vencimento do t�tulo
							COMISSAO->E1_VALOR      }) // 24 Valor do t�tulo
							 
				cTitulo  := COMISSAO->( E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E3_SEQ )
				cTitSE3  := COMISSAO->( E3_PREFIXO + E3_NUM + E3_PARCELA + E3_TIPO + E3_SEQ )
	
				// busco o Tipo de Faixa, onde determina a forma de calculo 
				aRet := TipoFaixa( cVendedor, cGrupo, COMISSAO->E1_EMISSAO ) 
				
		  		cTipoCalc := aRet[1] // Tipo de c�lculo
		  		cCodFaixa := aRet[2] // C�digo da Faixa
		  		cTabPrec  := aRet[3] // Tabela de Pre�o
		        
		 		nComissa  := 0 // Valor de comiss�o
				nValBase  := 0 // Base de c�lculo
				
				// Enquanto for o mesmo vendedor e grupo de produto, para um mesmo t�tulo e comiss�o
				While COMISSAO->( !Eof() ) 	.And. cVendedor == COMISSAO->E3_VEND;
											.And. cGrupo	== COMISSAO->B1_GRUPO;
											.And. cTitSE3   == COMISSAO->( E3_PREFIXO + E3_NUM + E3_PARCELA + E3_TIPO + E3_SEQ )  ;
		    								.And. cTitulo 	== COMISSAO->( E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E3_SEQ )
				
					cInf := "Proc Tit. "+ Iif( nJ == 1, "Normais", Iif( nJ == 2, "Faturas", Iif( nJ == 3, "Liquidacoes", "Liq. Faturas" ) ) ) 
					oProcess:IncRegua2( cInf +"-Vend: "+ COMISSAO->E3_VEND )
					
					// Calcula o valor da base de c�lculo para este item            
					nValBsItem := ( COMISSAO->D2_TOTAL / nQtdParc ) // Divide o valor do item pela quantidade de parcelas da condi��o
					nValBsItem -= Round( nValBsItem * nPerDesc, 2 ) // Aplica o % desconto que foi calculado para este t�tulo
					
					// Se o tipo de c�lculo for por Percentual de Desconto, o calculo � feito a cada item da NF
					// Caso contr�rio, � aplicado a faixa sobre o total vendido por grupo de produto
					If cTipoCalc == "1" // 1=Percentual de desconto
					   
						//Retorna o Percentual de Desconto concedido
						nPercent  := FaixaDesc( COMISSAO->D2_COD, COMISSAO->D2_PRCVEN, cTabPrec )
						// Retorna o percentual de comiss�o de acordo com a faixa de desconto
						aRet      := Faixa( 0, nPercent, cVendedor, cGrupo, COMISSAO->E1_EMISSAO )
						// Percentual de comiss�o
						nPComis   := aRet[1]
					
						nComisIt := ( nValBsItem * ( nPComis / 100 ) ) // Valor de comiss�o do item
						nComissa  += nComisIt // Acumula o valor de comiss�o
						
					EndIf 
					
					// Total acumulado do valor base da Nota Fiscal
					nValBase += nValBsItem
					
					aItem := { COMISSAO->D2_COD   ,; // 01-Produto
					           COMISSAO->D2_TOTAL ,; // 02-Valor total do item
					           COMISSAO->D2_PEDIDO,; // 03-Pedido do item
					           cTipoCalc          ,; // 04-Tipo de c�lculo (1=% de desconto/2=Valor Acumulado grupo)
					           nPercent           ,; // 05-% de desconto comercial concedido
					           nValBsItem         ,; // 06-Valor de base de c�lculo de comiss�o para este item
					           nPComis            ,; // 07-% Comiss�o de acordo com a faixa
					           nComisIt           ,; // 08-Valor de comiss�o do item
					           cGrupo             ,; // 09-Grupo de Produto
					           cCodFaixa          ,; // 10-C�digo da faixa
					           nQtdParc           ,; // 11-Quantidade de Parcelas
					           COMISSAO->D2_CUSTO1,; // 12-Custo unit�rio do item
					           COMISSAO->D2_VALICM,; // 13-Valor de ICMS do item
					           COMISSAO->D2_VALIPI ; // 14-Valor de IPI do item
					           }

					aAdd( aNf[ Len( aNF ), 22 ], aItem )
					
					dbSelectArea("COMISSAO")
					dbSkip()
				
				EndDo
				
				// Atualiza o Valor Base da Nota Fiscal
				aNf[ Len( aNF ), 5 ] := nValBase
				
				// ** Somatorio das baixas por faixa **
				
				// Pesquiso se a faixa j� est� no array e retorno a posi��o da mesma
				nPos := aScan( aBaseFaixa, { |x| x[ 1 ] ==  cCodFaixa } )	
				
				If nPos <= 0                                  
				    aAdd( aBaseFaixa, {  cCodFaixa ,  0 } ) // Caso n�o esteja, adiciono a mesma ao final do array
					nPos := Len( aBaseFaixa ) // A posi��o atual � a �ltima posi��o do array
	            EndIf
	            // Acumulo o valor na posi��o da faixa                                      
	            aBaseFaixa[nPos][2] += nValBase
				
				// Se o tipo de c�lculo for por Percentual de Desconto, o calculo � feito a cada item da NF
				// Neste caso j� defino o valor da comiss�o e o percentual correspondente
				// Quando o tipo de c�lculo for 2, estas posi��es permanecem com ZERO at� o final do acumulado, quando ser� calculado pela faixa
				If cTipoCalc == "1" //1=Percentual de Desconto
								
					aNf[ Len( aNF ), 6 ] := nComissa						// Valor da Comissao
					aNf[ Len( aNF ), 7 ] := ( nComissa / nValBase ) * 100 	// % de comissao
					
				EndIf 
				    
				// Atribuo o c�digo e o tipo de c�lculo da faixa utilizada neste grupo
				aNf[ Len( aNF ), 19 ] := cCodFaixa										
				aNf[ Len( aNF ), 20 ] := cTipoCalc										
					
			EndDo
			
			//Adiciono as NF ao vendedor
			aVend[ Len( aVend ), 6 ] := aNF 	
			
		EndDo
		
		dbSelectArea("COMISSAO")
		dbCloseArea()
	 
	Next // Executa a pr�xima query e processa seu resultado

	// Neste ponto todos os dados foram processados, dentro dos par�metros definidos pelo usu�rio, e os valores baixados j� est�o acumulados por faixa
	// As comissoes de tipo de faixa igual a 2 (VALOR) ser�o definidas de acordo com o total acumulado em cada faixa
	For nI := 1 To Len( aVend ) // Percorro todo o array de vendedores
		
		For nX := 1 To Len( aVend[ nI ][ 6 ] ) // A posi��o 6 do array de vendedores cont�m um array com todas as notas, vamos percorrer uma a uma
			
			If aVend[ nI ][ 6 ][ nX ][ 20 ] == '2' // Tipo de c�lculo definido � por faixa de valor
		        
		     	cCodFaixa := aVend[ nI ][ 6 ][ nX ][ 19 ] // Verifico o c�digo da faixa deste t�tulo / nf
		     
				nBaseTit := aBaseFaixa[ aScan( aBaseFaixa,{ |y| y[ 1 ] == cCodFaixa } ) ][ 2 ] // Busco do array de acumulados por faixas
				
				aRet      := Faixa( nBaseTit, 0, aVend[nI][1], aVend[nI][2], aVend[nI][6][nX][13] ) // Busco o percentual de acordo com a faixa
				nPComis   := aRet[1] // Percentual de comiss�o definido pela faixa do valor 
	 
				nValComis := aVend[nI][6][nX][5]  * ( nPComis / 100 ) // Calculo a comiss�o (posi��o 5 do array de notas � a base)
							
				aVend[nI][6][nX][06] := nValComis // Valor da Comiss�o
				aVend[nI][6][nX][07] := nPComis   // Percentual da Comiss�o
				aVend[nI][6][nX][21] := nBaseTit  // Total acumulado nesta faixa
				
				_aIteNf := aVend[nI][6][nX][22]
				
				For _jX := 1 To Len( _aIteNf )
					aVend[nI][6][nX][22][_jX][07] := nPComis
					aVend[nI][6][nX][22][_jX][08] := aVend[nI][6][nX][22][_jX][06] * ( nPComis / 100 )
				Next
				
			EndIf
			
        Next
    Next                                                                                              ?

	If Len(aVend) > 0
		GravaSZE( aVend )   // Gravar as informa��es detalhadas na tabela de auditoria SZE
		GravaComis( aVend ) // Grava��o das comiss�es calculadas no SE3
		Aviso( "Finalizado!" ,"Processo de Comissao 2(especifico) concluido!", { "OK" } )	
	Else
		Aviso( "Atencao!"    ,"Para o per�odo informado, n�o h� faturamento. Verifique os parametros!", { "OK" } )	
	EndIf
	
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �GravaComis  � Autor � Jeferson Dambros    � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Funcao para gravar comissao                                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GravaComis()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA01 - Array com as comissoes a serem gravadas           ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function GravaComis( aVend )

	Local nZ		:= 0
	Local nY		:= 0
	Local cQuery	:= ""

	SA3->( dbSetOrder(1) )
	SE3->( dbSetOrder(3) )
	
	oProcess:SetRegua1( Len( aVend ) )
		
	For nZ := 1 To Len( aVend ) // Percorre o array de vendedores
		
		// Posiciona no cadastro do Vendedor
		SA3->( dbSeek(xFilial("SA3") + aVend[nZ,1] ))
		
		oProcess:IncRegua1("Gravando Vendedor " + Left( SA3->A3_NOME,15) )

		_nTotNf := Len( aVend[ nZ, 6 ] )
		
		If _nTotNf > 0  // Se tiverem notas fiscais associadas a este vendedor
		
			oProcess:SetRegua2( _nTotNf )
		
			For nY := 1 To _nTotNf // Para cada uma das notas
			
				oProcess:IncRegua2("NF " + aVend[ nZ, 6 ][ nY, 1 ] + aVend[ nZ, 6 ][ nY, 2 ] + aVend[ nZ, 6 ][ nY, 3 ] )
				
				If aVend[ nZ, 6 ][ nY, 6 ] > 0 // Posi��o 6 da nota � o valor da comiss�o
				
					cQuery := " SELECT *"
					cQuery += " FROM " + RetSqlName("SE3")+ " (NOLOCK) "
					cQuery += " WHERE E3_FILIAL  = '"+ xFilial("SE3") +"'"
					cQuery += "	  AND E3_VEND    = '"+ aVend[ nZ, 1 ] +"'"
					cQuery += "	  AND E3_CODCLI  = '"+ aVend[ nZ, 6 ][ nY, 08 ] +"'"
					cQuery += "	  AND E3_LOJA    = '"+ aVend[ nZ, 6 ][ nY, 09 ] +"'" 
					cQuery += "	  AND E3_PREFIXO = '"+ aVend[ nZ, 6 ][ nY, 01 ] +"'"
					cQuery += "	  AND E3_NUM     = '"+ aVend[ nZ, 6 ][ nY, 02 ] +"'"
					cQuery += "	  AND E3_PARCELA = '"+ aVend[ nZ, 6 ][ nY, 03 ] +"'"
					cQuery += "	  AND E3_TIPO    = '"+ aVend[ nZ, 6 ][ nY, 04 ] +"'"
					cQuery += "	  AND E3_SEQ     = '"+ aVend[ nZ, 6 ][ nY, 10 ] +"'"
					cQuery += "	  AND E3_EMISSAO = '"+ DTOS( aVend[ nZ, 6 ][ nY, 11 ] ) +"'"
					cQuery += "	  AND E3_DATA   = ''"
					cQuery += "	  AND E3_GRUPO  = '"+ aVend[ nZ, 2 ] +"'"
					cQuery += "	  AND E3_ORIPROG= 'JMHA210'"
					
					cQuery += "	  AND D_E_L_E_T_ <> '*' "
			
					cQuery := ChangeQuery(cQuery)                           
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "TMPVE", .F., .T.)
					
					TMPVE->( dbGoTop() )
					
					If TMPVE->( !Eof() ) // Verifica se j� existe t�tulo de comiss�o gerado para esta nota
						
						dbSelectArea("SE3")
						dbGoto( TMPVE->R_E_C_N_O_ )
						
						RecLock("SE3",.F.) // Atualiza os valores
							SE3->E3_BASE	:= aVend[ nZ, 6 ][ nY, 05 ]
							SE3->E3_COMIS	:= aVend[ nZ, 6 ][ nY, 06 ]
							SE3->E3_PORC	:= aVend[ nZ, 6 ][ nY, 07 ]
							SE3->E3_DESCFIN	:= aVend[ nZ, 6 ][ nY, 14 ]
							SE3->E3_GRUPO	:= aVend[ nZ, 2 ]  
							SE3->E3_ORIPROG	:= "JMHA210"
						MsUnLock()
					
					Else
					
						// Se n�o existir, cria o t�tulo de comiss�o
						dbSelectArea("SE3")
						RecLock("SE3", .T. )
							SE3->E3_FILIAL	:= xFilial("SE3")
							SE3->E3_VEND	:= aVend[ nZ, 1 ]
							SE3->E3_GRUPO	:= aVend[ nZ, 2 ]
							SE3->E3_NUM		:= aVend[ nZ, 6 ][ nY, 02 ]
							SE3->E3_EMISSAO	:= aVend[ nZ, 6 ][ nY, 11 ]
							SE3->E3_SERIE	:= aVend[ nZ, 6 ][ nY, 01 ]
							SE3->E3_CODCLI	:= aVend[ nZ, 6 ][ nY, 08 ]
							SE3->E3_LOJA	:= aVend[ nZ, 6 ][ nY, 09 ]
							SE3->E3_BASE	:= aVend[ nZ, 6 ][ nY, 05 ]
							SE3->E3_PORC	:= aVend[ nZ, 6 ][ nY, 07 ]
							SE3->E3_COMIS	:= aVend[ nZ, 6 ][ nY, 06 ]
							SE3->E3_PREFIXO	:= aVend[ nZ, 6 ][ nY, 01 ]
							SE3->E3_PARCELA	:= aVend[ nZ, 6 ][ nY, 03 ]
							SE3->E3_TIPO	:= aVend[ nZ, 6 ][ nY, 04 ]
							SE3->E3_PEDIDO	:= aVend[ nZ, 6 ][ nY, 12 ]
							SE3->E3_SEQ		:= aVend[ nZ, 6 ][ nY, 10 ]
							SE3->E3_DESCFIN	:= aVend[ nZ, 6 ][ nY, 14 ]
							SE3->E3_BAIEMI	:= "B"
							SE3->E3_ORIGEM	:= "F"
							SE3->E3_MOEDA	:= "01"
							SE3->E3_ORIPROG	:= "JMHA210"
							SE3->E3_VENCTO	:= StoD( Strzero( Year( dDataBase ), 4 ) + Strzero( Month( dDataBase ), 2 ) + Strzero( SA3->A3_DIA, 2 ) )
							If SE3->E3_VENCTO < dDataBase
								SE3->E3_VENCTO := dDataBase
							EndIf
						MsUnLock()
						
					EndIf

					TMPVE->( dbcloseArea() )
				
				EndIf
									
			Next nY	
			
		EndIf
	
	Next nZ
	
	oProcess:SetRegua1( Len( aVend ) )
		
	// Agora procura pelas comiss�es geradas pelo padr�o, inclusive as oriundas de fatura e/ou liquida��o, para exclu�-las
	For nZ := 1 To Len( aVend ) // Percorre o array de vendedores
		
		// Posiciona no cadastro do Vendedor
		SA3->( dbSeek(xFilial("SA3") + aVend[nZ,1] ))
		
		oProcess:IncRegua1("Ajustando base... " + Left( SA3->A3_NOME, 15 ) )

		_nTotNf := Len( aVend[ nZ, 6 ] )
		
		If _nTotNf > 0 // Se tiverem notas fiscais associadas a este vendedor
		
			oProcess:SetRegua2( _nTotNf )
		
			For nY := 1 To _nTotNf // Para cada uma das notas
			
				oProcess:IncRegua2("Nf "+ aVend[ nZ, 6 ][ nY, 1 ] + aVend[ nZ, 6 ][ nY, 2 ] + aVend[ nZ, 6 ][ nY, 3 ] )
				
				If aVend[ nZ, 6 ][ nY, 6 ] > 0 // Se houver comiss�o
				
					//PROCURA PELA CHAVE NORMAL - TITULO SEM LIQUIDACAO/FATURA
					cQuery := " SELECT *"
					cQuery += " FROM " + RetSqlName("SE3") + " (NOLOCK) "
					cQuery += " WHERE E3_FILIAL = '"+ xFilial("SE3") +"'"
					cQuery += "	  AND E3_VEND   = '"+ aVend[ nZ, 1 ] +"'"
					cQuery += "	  AND E3_CODCLI = '"+ aVend[ nZ, 6 ][ nY, 08 ] +"'"
					cQuery += "	  AND E3_LOJA   = '"+ aVend[ nZ, 6 ][ nY, 09 ] +"'" 
					cQuery += "	  AND E3_PREFIXO= '"+ aVend[ nZ, 6 ][ nY, 01 ] +"'"
					cQuery += "	  AND E3_NUM    = '"+ aVend[ nZ, 6 ][ nY, 02 ] +"'"
					cQuery += "	  AND E3_PARCELA= '"+ aVend[ nZ, 6 ][ nY, 03 ] +"'"
					cQuery += "	  AND E3_TIPO   = '"+ aVend[ nZ, 6 ][ nY, 04 ] +"'"
					cQuery += "	  AND E3_SEQ    = '"+ aVend[ nZ, 6 ][ nY, 10 ] +"'"
					cQuery += "	  AND E3_DATA   = ''"
					cQuery += "	  AND E3_GRUPO  = ''"
					cQuery += "	  AND E3_ORIPROG= ''" // Este campo se vazio, n�o foi gerado pela customiza��o
					cQuery += "	  AND D_E_L_E_T_ <> '*' "
			
					cQuery := ChangeQuery(cQuery)                           
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "TMPVE", .F., .T.)
					
					TMPVE->( dbGoTop() )
					
					If TMPVE->( !Eof() ) // Se existir, posicione e exclui o registro
						
						dbSelectArea("SE3")
						dbGoto(TMPVE->R_E_C_N_O_)
						
						RecLock("SE3",.F.)
							dbDelete()
						MsUnLock()
						
					EndIf
					
					TMPVE->( dbcloseArea() )
					
					
					//PROCURA PELA CHAVE DE TITULO LIQUIDACAO/FATURA
					If aVend[nZ,6][nY,15] <> aVend[nZ,6][nY,1] .Or. aVend[nZ,6][nY,16] <> aVend[nZ,6][nY,2] .Or. ;
					   aVend[nZ,6][nY,17] <> aVend[nZ,6][nY,3] .Or. aVend[nZ,6][nY,18] <> aVend[nZ,6][nY,4]
					
						cQuery := " SELECT *"
						cQuery += " FROM " + RetSqlName("SE3") + " (NOLOCK) "
						cQuery += " WHERE E3_FILIAL = '"+ xFilial("SE3") +"'"
						cQuery += "	  AND E3_VEND   = '"+ aVend[ nZ, 1 ] +"'"
						cQuery += "	  AND E3_CODCLI = '"+ aVend[ nZ, 6 ][ nY, 08 ] + "'"
						cQuery += "	  AND E3_LOJA   = '"+ aVend[ nZ, 6 ][ nY, 09 ] + "'" 
						cQuery += "	  AND E3_PREFIXO= '"+ aVend[ nZ, 6 ][ nY, 15 ] + "'"
						cQuery += "	  AND E3_NUM    = '"+ aVend[ nZ, 6 ][ nY, 16 ] + "'"
						cQuery += "	  AND E3_PARCELA= '"+ aVend[ nZ, 6 ][ nY, 17 ] + "'"
						cQuery += "	  AND E3_TIPO   = '"+ aVend[ nZ, 6 ][ nY, 18 ] + "'"
						cQuery += "	  AND E3_DATA   = ''"
						cQuery += "	  AND E3_GRUPO  = ''"
						cQuery += "	  AND E3_ORIPROG= ''" // Este campo se vazio, n�o foi gerado pela customiza��o
						cQuery += "	  AND D_E_L_E_T_ <> '*' "
				
						cQuery := ChangeQuery(cQuery)                           
						dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "TMPVE", .F., .T.)
						
						TMPVE->( dbGoTop() )
						
						If TMPVE->( !Eof() ) // Se existir, posicione e exclui o registro
							
							dbSelectArea("SE3")
							dbGoto( TMPVE->R_E_C_N_O_ )
							
							RecLock("SE3",.F.)
								dbDelete()
							MsUnLock()
							
						EndIf
						
						TMPVE->( dbcloseArea() )
						
				    EndIf
				EndIf
			Next nY	
		EndIf
	Next nZ 

Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Faixa     � Autor � Jeferson Dambros      � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o percentual de comissao                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/               
Static Function Faixa(nVenda, nDesc, cVend, cGrupo, dDtEmis)
	
	Local cQuery  := ""
	Local nPComis := 0
	Local cFaixa  := ""                                        
	
	DbSelectArea("SBM")
	DbSetOrder(1)
	DbSeek( xFilial("SBM") + cGrupo )
	
   	If !Empty( SBM->BM_GRPCOMI ) //Grupo de comissao
		cGrupo := SBM->BM_GRPCOMI	
	EndIf	
	   
	If nVenda > 0  .And. nDesc == 0  	// faixa por valor (ZB_TIPO = 2)
	
		// Tabela especifica ( Regras de COMISSAO )
		// Procuro a faixa do VENDEDOR + GRUPO + VENDA
		cQuery := " SELECT ZB_COMIS, ZB_FAIXA "
		cQuery += " FROM " + RetSqlName("SZB") + " (NOLOCK) "
		cQuery += " WHERE ZB_FILIAL  = '" + xFilial("SZB") + "'"
		cQuery += "	AND ZB_VEND    = '"+ cVend	+"'"
		cQuery += "	AND ZB_GRUPO   = '"+ cGrupo +"'"
		cQuery += "	AND ZB_FAXDE   <= "+ cValToChar(nVenda) 
		cQuery += "	AND ZB_FAXATE  >= "+ cValToChar(nVenda)
		cQuery += "	AND ZB_VIGENC  <= '"+ DToS(dDtEmis) + "'"
		cQuery += "	AND ZB_VIGEFIM >= '"+ DToS(dDtEmis) + "'"
		cQuery += "	AND D_E_L_E_T_ <> '*' "
		
		cQuery := ChangeQuery(cQuery)                           
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "FAIXA", .F., .T.)
	    
		TcSetField("FAIXA","ZB_COMIS","N",6,2)
		
		FAIXA->(dbGoTop())
		If FAIXA->(!Eof())
					  
			nPComis := FAIXA->ZB_COMIS
			cFaixa  := FAIXA->ZB_FAIXA 
			
		Else // Se nao existir, procuro a faixa do GRUPO + VENDA 
		
			FAIXA->(dbCloseArea())
		
			cQuery := " SELECT ZB_COMIS, ZB_FAIXA "
			cQuery += " FROM " + RetSqlName("SZB") + " (NOLOCK) "
			cQuery += " WHERE ZB_FILIAL  = '" + xFilial("SZB") + "'"
			cQuery += "	AND ZB_VEND    = ''"
			cQuery += "	AND ZB_GRUPO   = '"+ cGrupo +"'"
			cQuery += "	AND ZB_FAXDE   <= "+ cValToChar(nVenda) 
			cQuery += "	AND ZB_FAXATE  >= "+ cValToChar(nVenda)
			cQuery += "	AND ZB_VIGENC  <= '"+ DToS(dDtEmis) + "'"
			cQuery += "	AND ZB_VIGEFIM >= '"+ DToS(dDtEmis) + "'"
			cQuery += "	AND D_E_L_E_T_ <> '*' "
			
			cQuery := ChangeQuery(cQuery)                           
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "FAIXA", .F., .T.)
		
			TcSetField("FAIXA","ZB_COMIS","N",6,2)
	
			FAIXA->(dbGoTop())
			If FAIXA->(!Eof())
					  
				nPComis := FAIXA->ZB_COMIS
				cFaixa  := FAIXA->ZB_FAIXA 
			
			EndIf
			
		EndIf
		
		FAIXA->(dbCloseArea())
	
	EndIf	
	// Se n�o encontrar a faixa pelo valor, 
	// busco pelo VENDEDOR + GRUPO + DESCONTO
	If nVenda == 0 .And. nDesc >= 0
		
		cQuery := " SELECT ZB_COMIS, ZB_FAIXA "
		cQuery += " FROM " + RetSqlName("SZB") + " (NOLOCK) "
		cQuery += " WHERE ZB_FILIAL  = '" + xFilial("SZB") + "'"
		cQuery += "	AND ZB_VEND    = '"+ cVend	+"'"
		cQuery += "	AND ZB_GRUPO   = '"+ cGrupo	+"'"
		cQuery += "	AND ZB_FAXDE   <= "+ cValToChar(nDesc) 
		cQuery += "	AND ZB_FAXATE  >= "+ cValToChar(nDesc)
		cQuery += "	AND ZB_VIGENC  <= '"+ DToS(dDtEmis) + "'"
		cQuery += "	AND ZB_VIGEFIM >= '"+ DToS(dDtEmis) + "'"
		cQuery += "	AND D_E_L_E_T_ <> '*' "
		
		cQuery := ChangeQuery(cQuery)                           
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "FAIXA", .F., .T.)
	
		TcSetField("FAIXA","ZB_COMIS","N",6,2)

		FAIXA->(dbGoTop())
		If FAIXA->(!Eof())
			
			nPComis := FAIXA->ZB_COMIS
			cFaixa  := FAIXA->ZB_FAIXA 
		
		Else // Se nao existir, procuro a faixa do GRUPO + DESCONTO
			
			FAIXA->(dbCloseArea())
			
			cQuery := " SELECT ZB_COMIS, ZB_FAIXA "
			cQuery += " FROM " + RetSqlName("SZB") + " (NOLOCK) " 
			cQuery += " WHERE ZB_FILIAL  = '" + xFilial("SZB") + "'"
			cQuery += "	AND ZB_VEND    = ''"
			cQuery += "	AND ZB_GRUPO   = '"+ cGrupo + "'"
			cQuery += "	AND ZB_FAXDE   <= "+ cValToChar(nDesc) 
			cQuery += "	AND ZB_FAXATE  >= "+ cValToChar(nDesc)
			cQuery += "	AND ZB_VIGENC  <= '"+ DToS(dDtEmis) + "'"
			cQuery += "	AND ZB_VIGEFIM >= '"+ DToS(dDtEmis) + "'"
			cQuery += "	AND D_E_L_E_T_ <> '*' "
			
			cQuery := ChangeQuery(cQuery)                           
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "FAIXA", .F., .T.)
		
			TcSetField("FAIXA","ZB_COMIS","N",6,2)

			FAIXA->(dbGoTop())
			If FAIXA->(!Eof())
					  
				nPComis := FAIXA->ZB_COMIS
				cFaixa  := FAIXA->ZB_FAIXA 
		
			EndIf
		EndIf
		
		FAIXA->(dbCloseArea())
		
	EndIf	
	
Return( { nPComis , cFaixa } )


/*���������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �TipoFaixa � Autor � Jeferson Dambros      � Data � Set/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o tipo de faixa.                                   ���
��������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������*/               
Static Function TipoFaixa(cVend, cGrupo, dEmissao )
	
	Local cQuery    := ""
	Local cTipoCalc := ""
	Local cFaixa    := ""
	Local cTabela   := ""

	DbSelectArea("SBM")
	DbSetOrder(1)
	DbSeek( xFilial("SBM") + cGrupo )
	
	If !Empty( SBM->BM_GRPCOMI ) //Grupo de comissao
		cGrupo := SBM->BM_GRPCOMI
	EndIf	
	
	cQuery := " SELECT ZB_TIPO, ZB_FAIXA, ZB_TABPRC "
	cQuery += " FROM " + RetSqlName("SZB") + " (NOLOCK) "
	cQuery += " WHERE ZB_FILIAL	= '"+ xFilial("SZB") +"'"
	cQuery += "	AND ZB_VEND	    = '"+ cVend 		 +"'"
	cQuery += "	AND ZB_GRUPO	= '"+ cGrupo 		 +"'"
	cQuery += "	AND ZB_VIGENC  <= '"+ DToS(dEmissao) +"'"
	cQuery += "	AND ZB_VIGEFIM >= '"+ DToS(dEmissao) +"'"
	cQuery += "	AND D_E_L_E_T_ <> '*' "
	
	cQuery := ChangeQuery(cQuery)                           
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "TPFAIXA", .F., .T.)
	
	TPFAIXA->( dbGoTop() )
	
	If TPFAIXA->( !Eof() )
		cTipoCalc := TPFAIXA->ZB_TIPO
		cFaixa    := TPFAIXA->ZB_FAIXA
		cTabela   := TPFAIXA->ZB_TABPRC
	EndIf
	
	TPFAIXA->( dbCloseArea() )

Return( { cTipoCalc , cFaixa, cTabela } )
    


/*���������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �RetPerLiq � Autor � Fernando Mazzarolo    � Data � Set/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o % pago na liquid/fat em relacao a nf principal   ���
��������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������*/               
Static Function RetPerLiq( cPref , cNum , cParc , cTipo , nVlrbase , cVend )
    
	Local nRet    := 100
	Local nValTot := 0
	Local nValLiq := nVlrbase

	DbSelectArea("SE1")
	DbSetOrder(1)
	If DbSeek( xFilial("SE1") + cPref + cNum + cParc + cTipo )   //NR DO SE3 ( TITULO BAIXADO )

		If !Empty( SE1->E1_NUMLIQ )
	 
			cQuery := " SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_VALOR,E5_TIPODOC "
			cQuery += " FROM " + RetSqlName("SE5") + " (NOLOCK) "
			cQuery += " WHERE E5_FILIAL	 = '"+ xFilial("SE5")	+"'"
			cQuery += "   AND E5_DOCUMEN = '"+ SE1->E1_NUMLIQ 	+"'"
			cQuery += "	  AND E5_MOTBX	 = 'LIQ' "
			cQuery += "	  AND E5_TIPODOC = 'BA' "
			cQuery += "	  AND D_E_L_E_T_ <> '*' "
			cQuery := ChangeQuery(cQuery)                           
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "SUMLIQ", .F., .T.)
		   	
		   	SUMLIQ->( dbGoTop() )
			
			While !Eof()
			
				DbSelectArea("SE1")
				DbSetOrder(1)
				DbSeek( xFilial("SE1") + SUMLIQ->E5_PREFIXO + SUMLIQ->E5_NUMERO + SUMLIQ->E5_PARCELA + SUMLIQ->E5_TIPO )
		
				///VERIFICA SE EH LIQ DE FATURA
				If AllTrim( SE1->E1_FATURA ) == "NOTFAT"
		            
		            //EH FATURA                              
					cQuery := " SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_VALOR,E5_TIPODOC,E5_VLACRES ,E5_VLDECRE "
					cQuery += " FROM " + RetSqlName("SE5") + " (NOLOCK) "
					cQuery += " WHERE E5_FILIAL	 = '"+ xFilial("SE5")       +"'"
					cQuery += "   AND E5_FATURA  = '"+ SUMLIQ->E5_NUMERO    +"'"   
					cQuery += "   AND E5_FATPREF = '"+ SUMLIQ->E5_PREFIXO   +"'"   
					cQuery += "	  AND E5_MOTBX	 = 'FAT' "
					cQuery += "	  AND E5_TIPODOC = 'BA'  "				
					cQuery += "	  AND D_E_L_E_T_ <> '*' "
					cQuery := ChangeQuery(cQuery)                           
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "SUMFAT", .F., .T.)
				   	
				   	SUMFAT->( dbGoTop() )
					While !Eof()
                         
						DbSelectArea("SE1")
						DbSetOrder(1)
						If DbSeek( xFilial("SE1") + SUMFAT->E5_PREFIXO + SUMFAT->E5_NUMERO + SUMFAT->E5_PARCELA + SUMFAT->E5_TIPO )

							If SE1->E1_VEND1 == cVend                                             
								nValTot += ( ( SUMFAT->E5_VALOR + SUMFAT->E5_VLDECRE ) - SUMFAT->E5_VLACRES )
							EndIf
						EndIf	
	
						DbSelectArea('SUMFAT')
						DbSkip()						
					EndDO
					SUMFAT->(dbCloseArea())

				Else
					//TITULO NORMAL
					If SE1->E1_VEND1 == cVend
						nValTot += SUMLIQ->E5_VALOR
					EndIf
			    EndIf				
				
				SUMLIQ->( dbSkip() )
			EndDo
			
			SUMLIQ->( dbCloseArea() )

		ElseIf AllTrim(SE1->E1_FATURA) == "NOTFAT"

			cQuery := " SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_VALOR,E5_TIPODOC,E5_VLDECRE,E5_VLACRES "
			cQuery += " FROM " + RetSqlName("SE5") + " (NOLOCK) "
			cQuery += " WHERE E5_FILIAL	 = '"+ xFilial("SE5")	+"'"
			cQuery += "   AND E5_FATURA  = '"+ cNum          	+"'"   
			cQuery += "   AND E5_FATPREF = '"+ cPref          	+"'"   
			cQuery += "	  AND E5_MOTBX	 = 'FAT' "
			cQuery += "	  AND E5_TIPODOC = 'BA'  "
			cQuery += "	  AND D_E_L_E_T_ <> '*'  "

			cQuery := ChangeQuery(cQuery)                           
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "SUMLIQ", .F., .T.)

			While !Eof()
                         
				DbSelectArea("SE1")
				DbSetOrder(1)
				If DbSeek( xFilial("SE1") + SUMLIQ->E5_PREFIXO + SUMLIQ->E5_NUMERO + SUMLIQ->E5_PARCELA + SUMLIQ->E5_TIPO )
					
					If SE1->E1_VEND1 == cVend
						nValTot += ( ( SUMLIQ->E5_VALOR + SUMLIQ->E5_VLDECRE ) - SUMLIQ->E5_VLACRES )
					EndIf
					
				EndIf	
	
				SUMLIQ->( DbSkip() )
			EndDO
			
			SUMLIQ->( dbCloseArea() )

	    EndIf

	   	If nValTot > 0
			nRet := Round( ( nValLiq / nValTot ) , 6 )
		EndIf
			    
    EndIf
	nRet := Iif( nRet == 100, 1, nRet )
Return( nRet )


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FaixaDesc � Autor � Jeferson Dambros      � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o percentual de desconto                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function FaixaDesc(cProduto, nValor, cTabPrc )

	Local nPerDesc := 0

	DA1->( dbSetOrder(1) )
	
	If DA1->( dbSeek(xFilial("DA1") + cTabPrc + cProduto) ) 
	
		If DA1->DA1_PRCVEN > 0  .And. DA1->DA1_PRCVEN > nValor
	
			nPerDesc := 100 - Round( ( nValor / DA1->DA1_PRCVEN ) * 100 , 2 )
			
			If nPerDesc >= 100
				nPerDesc := 0
			EndIf
		
		EndIf
	EndIf

Return(nPerDesc)


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �RetQtdParc� Autor � Jeferson Dambros      � Data � Set/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a quantidade de parcela por NF                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/               
Static Function RetQtdParc(_cCondPgto, _cPrefixo, _cNum, _cTipo)
	
	Local nQtd   := 0
	Local nPos
	
	SE1->( dbSetOrder(1) )		
	SE1->( dbSeek( xFilial("SE1") + _cPrefixo + _cNum ) )
	
	While !SE1->( Eof() ) .And. SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM == xFilial("SE1") + _cPrefixo + _cNum
		
		If _cTipo == SE1->E1_TIPO
			nQtd++
		EndIf
		
		SE1->( dbSkip() )
		
	EndDo
		
Return( nQtd )


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �CriaSx1   � Autor � Jeferson Dambros      � Data � Ago/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Criar o grupo de perguntas                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/               
Static Function CriaSx1()

	Local aP 	:= {}
	Local nI 	:= 0
	Local cSeq  := ""
	Local cMvCh := ""
	Local cMvPar:= ""
	Local aHelp := {}
	Local cPerg := PadR("JMHA210",Len(SX1->X1_GRUPO)) 
	
	
	aAdd(aP,{"Periodo de"		,"D",8,0,"G",""                    	,""   	,""   ,""   ,"","",""})
	aAdd(aP,{"Periodo ate"		,"D",8,0,"G","(MV_PAR02>=MV_PAR01)",""   	,""   ,""   ,"","",""})
	aAdd(aP,{"Vendedor de"		,"C",6,0,"G",""                    	,"SA3"	,""   ,""   ,"","",""})
	aAdd(aP,{"Vendedor ate"		,"C",6,0,"G",""                    	,"SA3"	,""   ,""   ,"","",""})

    //           0123456789123456789012345678901234567890
    //                    1         2         3         4     
	aAdd(aHelp,{"Informe o periodo inicial, para o","calculo de comissao."})
	aAdd(aHelp,{"Informe o periodo final, para o","calculo de comissao."})
	aAdd(aHelp,{"Codigo do vendedor inicial."})
	aAdd(aHelp,{"Codigo do vendedor final."})
	
	For nI:=1 To Len(aP)
	
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
		0,;
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
      
Return( cPerg )

// Fun��o criada para gravar as informa��es detalhadas por item, do c�lculo de comiss�es
Static Function GravaSZE( _aVend )
	
	Local _nV  := 0
	Local _nC  := 0
	Local _nI  := 0
	Local cDel := ""
	Local aVen := _aVend
	Local aNfs := {}
	Local aIte := {}
	
   	cDel := " DELETE FROM " + RetSqlName("SZE") 
	cDel += "  WHERE ZE_FILIAL  = '" + xFilial('SZE') + "'"
	cDel += "    AND ZE_DEMISE3 >= '" + DtoS(MV_PAR01)	+ "'"
	cDel += "    AND ZE_DEMISE3 <= '" + DtoS(MV_PAR02)	+ "'"
	cDel += "    AND ZE_VEND    >= '" + MV_PAR03       	+ "'"
	cDel += "    AND ZE_VEND    <= '" + MV_PAR04        + "'"
	
	TcSqlExec( cDel )

	dbSelectArea("SZE")

	For _nV := 1 To Len( aVen )
	
		aNfs := aVen[ _nV, 6 ]
		
		For _nC := 1 To Len( aNfs )
		
			aIte := aNfs[ _nC, 22 ]
			
			For _nI := 1 To Len( aIte )
		
				RecLock("SZE",.T.)
					SZE->ZE_FILIAL  := xFilial("SZE")  // Filial
					SZE->ZE_VEND    := aVen[ _nV, 01 ] // Vendedor
					SZE->ZE_GRUPO   := aIte[ _nI, 09 ] // Grupo de Produto
					SZE->ZE_CODFAIX := aIte[ _nI, 10 ] // C�digo da Faixa
					SZE->ZE_TPFAIXA := aIte[ _nI, 04 ] // Tipo de C�lculo (Faixa de Desconto ou Faixa de Faturamento)
					
					If aNfs[ _nC, 14 ] > -99
						SZE->ZE_DESCF   := aNfs[ _nC, 14 ] // Desconto Financeiro
					Else
						SZE->ZE_DESCF   := 0
					EndIf              
					
					SZE->ZE_QTDPARC := aIte[ _nI, 11 ] // Quantidade de parcelas da condi��o
					SZE->ZE_CLIENTE := aNfs[ _nC, 08 ] // Cliente
					SZE->ZE_LOJA    := aNfs[ _nC, 09 ] // Loja
					SZE->ZE_E3PREFI := aNfs[ _nC, 15 ] // Prefixo do SE3
					SZE->ZE_E3NUM   := aNfs[ _nC, 16 ] // N�mero do SE3
					SZE->ZE_E3PARC  := aNfs[ _nC, 17 ] // Parcela do SE3
					SZE->ZE_E3TIPO  := aNfs[ _nC, 18 ] // Tipo do SE3
					SZE->ZE_E3SEQ   := aNfs[ _nC, 10 ] // Sequencia do SE3
					SZE->ZE_E1PREFI := aNfs[ _nC, 01 ] // Prefixo do SE1
					SZE->ZE_E1NUM   := aNfs[ _nC, 02 ] // N�mero do SE1
					SZE->ZE_E1PARC  := aNfs[ _nC, 03 ] // Parcela do SE1
					SZE->ZE_E1TIPO  := aNfs[ _nC, 04 ] // Tipo do SE1
					SZE->ZE_BASENF  := aNfs[ _nC, 05 ] // Base da faixa nesta nota
					SZE->ZE_COMISNF := aNfs[ _nC, 06 ] // Comiss�o da faixa nesta nota
					SZE->ZE_PERCNF  := aNfs[ _nC, 07 ] // Percentual de comiss�o da faixa nesta nota
					SZE->ZE_BASEITE := aIte[ _nI, 06 ] // Base do item
					SZE->ZE_PERCITE := aIte[ _nI, 07 ] // Percentual de comiss�o do item
					SZE->ZE_COMIITE := aIte[ _nI, 08 ] // Comiss�o do item
					SZE->ZE_DEMISE1 := aNfs[ _nC, 13 ] // Data de Emiss�o do SE1 (mesma da nota fiscal)
					SZE->ZE_DEMISE3 := aNfs[ _nC, 11 ] // Data de emiss�o do SE3 (mesma da baixa do t�tulo no SE1)
					SZE->ZE_TOTALD2 := aIte[ _nI, 02 ] // Total do item na venda
					SZE->ZE_PRODD2  := aIte[ _nI, 01 ] // Produto do item da nota
					SZE->ZE_PVD2    := aIte[ _nI, 03 ] // Pedido de venda
					SZE->ZE_DESCCOM := aIte[ _nI, 05 ] // Percentual de desconto comercial do item (quando c�lculo for por faixa de desconto)
					SZE->ZE_E1VENCR := aNfs[ _nC, 23 ] // Vencimento Real do t�tulo
					SZE->ZE_E1VALOR := aNfs[ _nC, 24 ] // Valor original do t�tulo
					SZE->ZE_D2CUST1 := aIte[ _nI, 12 ] // Custo unit�rio do item
					SZE->ZE_D2ICMS  := aIte[ _nI, 12 ] // Icms do item
					SZE->ZE_D2IPI   := aIte[ _nI, 12 ] // Ipi do item
		        SZE->( MsUnLock() )
			Next
		Next
	Next
	
Return