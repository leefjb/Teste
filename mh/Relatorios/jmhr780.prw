#INCLUDE "MATR780.CH"
#Include "protheus.ch"
#include "sigawin.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MATR780  � Autor � Gilson do Nascimento  � Data � 01.09.93 ���
���          �          � Ajuste� Marllon Figueiredo    � Data �14/11/2005���
�������������������������������������������������������������������������Ĵ��
���Descricao � Relacao de Vendas por Cliente, quantidade de cada Produto  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR780(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Bruno        �05.04.00�Melhor�Acertar as colunas para 12 posicoes.    ���
��� Marcello     �29/08/00�oooooo�Impressao de casas decimais de acordo   ���
���              �        �      �com a moeda selecionada e conversao     ���
���              �        �      �(xmoeda)baseada na moeda gravada na nota���
��� Rubens Pante �04/07/01�Melhor�Utilizacao de SELECT nas versoes TOP    ���
���              �        �      �                                        ���
��� Marllon      �14/11/05�      �Ajustado para demonstrar o custo da nota���
���              �        �      �de saida                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Jmhr780()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL wnrel
LOCAL tamanho:= "G"
LOCAL titulo := OemToAnsi(STR0001)	//"Estatisticas de Vendas (Cliente x Produto)"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"totalizando por produto e escolhendo a moeda forte para os Valores."
LOCAL cDesc3 := ""
LOCAL cString:= "SD2"

PRIVATE aReturn := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="JMHR780"
PRIVATE nLastKey := 0
PRIVATE cPerg   := "JMR780    "  //PadR("MR780A",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // De Cliente                           �
//� mv_par02             // Ate Cliente                          �
//� mv_par03             // De Data                              �
//� mv_par04             // Ate a Data                           �
//� mv_par05             // De Produto                           �
//� mv_par06             // Ate o Produto                        �
//� mv_par07             // Do Vendedor                          �
//� mv_par08             // Ate Vendedor                         �
//� mv_par09             // Moeda                                �
//� mv_par10             // Inclui Devolu��o                     �
//� mv_par11             // Mascara do Produto                   �
//� mv_par12             // Aglutina Grade                       �
//� mv_par13	// Quanto a Estoque Movimenta/Nao Movta/Ambos    �
//� mv_par14	// Quanto a Duplicata Gera/Nao Gera/Ambos        �
//� mv_par15   // Quanto a Devolucao NF Original/NF Devolucao    �
//� mv_par16   // Quanto a Descricao  Produto  Prod x Cli.       �
//� mv_par17   // converte moeda da devolucao                    �
//����������������������������������������������������������������
PutSx1(cPerg,"18","Cliente Vale de?     ","","","mv_chi","C",06,0,0,"G","","SA1","","S","mv_par18","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"19","Cliente Vale ate?    ","","","mv_chj","C",06,0,0,"G","","SA1","","S","mv_par19","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"20","CRM de ?             ","","","mv_chk","C",06,0,0,"G","","SZ1","","S","mv_par20","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"21","CRM ate ?            ","","","mv_chl","C",06,0,0,"G","","SZ1","","S","mv_par21","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"22","Convenio de ?        ","","","mv_chm","C",02,0,0,"G","","Z1","","S","mv_par22","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"23","Convenio ate ?       ","","","mv_chn","C",02,0,0,"G","","Z1","","S","mv_par23","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"24","Rel. p/Representante?","","","mv_cho","N",01,0,0,"C","",""  ,""," ","mv_par24","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","")
PutSx1(cPerg,"25","Formato do Relatorio?","","","mv_chp","N",01,0,0,"C","",""  ,""," ","mv_par25","Analitico","","","","Sint�tico","","","","","","","","","","","","","","")

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
titulo := "ESTATISTICAS DE VENDAS (Cliente X Produto)"
wnrel:="JMHR780"
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.T.)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C780Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C780IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR780                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C780Imp(lEnd,WnRel,cString)

LOCAL CbTxt
LOCAL CbCont,cabec1,cabec2,cabec3
LOCAL nOrdem
LOCAL tamanho:= "G"
LOCAL limite := 132
LOCAL titulo := OemToAnsi(STR0006)	//"ESTATISTICAS DE VENDAS (Cliente X Produto)"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"totalizando por produto e escolhendo a moeda forte para os Valores."
LOCAL cDesc3 := ""
LOCAL cMoeda
LOCAL nAcN1  := 0, nAcN2 := 0, nV := 0
LOCAL cClieAnt := "", cProdAnt := "", cLojaAnt := ""
LOCAL lContinua := .T. , lProcessou := .F. , lNewProd := .T.
LOCAL cMascara :=GetMv("MV_MASCGRD")
LOCAL nTamRef  :=Val(Substr(cMascara,1,2))
LOCAL nTamLin  :=Val(Substr(cMascara,4,2))
LOCAL nTamCol  :=Val(Substr(cMascara,7,2))
LOCAL cProdRef :=""
Local cUM      :=""
LOCAL nTotQuant:=0
LOCAL nReg     :=0
LOCAL cFiltro  := ""
Local cEstoq   := If( (mv_par13 == 1),"S",If( (mv_par13 == 2),"N","SN" ))
Local cDupli   := If( (mv_par14 == 1),"S",If( (mv_par14 == 2),"N","SN" ))
Local cArqTrab1, cArqTrab2, cCondicao1
Local aDevImpr := {}
Local cVends   := ""
Local nVend    := FA440CntVend()
Local nDevQtd  :=0
Local nDevVal 	:=0
Local nVlrTot   := 0
Local aDev		:={}
Local nIndD2    :=0
Local cQuery, aStru
Local lNfD2Ori   := .F. 
#IFDEF TOP
	Local nj := 0
	Local cAliasSA1 := "SA1"
#ENDIF

// totalizadores
LOCAL nTotCli1   := 0
Local nTotCli2   := 0
Local nTotCli3   := 0
Local nTotGer1   := 0
Local nTotGer2   := 0
Local nTotCusto  := 0
Local nTotVenda  := 0
Local aMediaMarg := {0,0}
Local aMediaLuc  := {0,0}
Local aMediaMPro := {0,0}
Local aMediaLPro := {0,0}
Local aMediaMCli := {0,0}
Local aMediaLCli := {0,0}
Local nTotPro1   := 0    // quantidade
Local nTotPro2   := 0    // custo
Local nTotPro3   := 0    // venda
Local nICMSPro   := 0
Local nICMSCli   := 0
Local nICMSGer   := 0
Local nImpPro    := 0
Local nImpCli    := 0
Local nImpGer    := 0
Local aMargLPro  := {0,0}
Local aMargLCli  := {0,0}
Local aMargLGer  := {0,0}
Local aLucrLPro  := {0,0}
Local aLucrLCli  := {0,0}
Local aLucrLGer  := {0,0}
Local nImpFed    := 0
Private cSD1, cSD2
Private nIndD1   := 0
Private nDecs    := msdecimais(mv_par09)


nImpFed := GetMV('JO_IMPFED') // os impostos federais (CSLL=1,02%   PIS=3%  COFINS=0,65%  Imp.Renda=1,08%)

//��������������������������������������������������������������Ŀ
//� Seleciona ordem dos arquivos consultados no processamento    �
//����������������������������������������������������������������
SF1->(dbsetorder(1))
SF2->(dbsetorder(1))
SB1->(dbSetOrder(1))
SA7->(dbSetOrder(2))

//��������������������������������������������������������������Ŀ
//� Monta o Cabecalho de acordo com o tipo de emissao            �
//����������������������������������������������������������������
titulo := "ESTATISTICAS DE VENDAS (Cliente X Produto)"
Cabec1 := "CLIENTE   RAZAO SOCIAL                                                                     CUSTO         PRC VENDA  MARGEM(%) LUCRO(%)                                           ICMS   Imp.Fed.  MARGEM(%)   LUCRO(%)"
Cabec2 := "PRODUTO         DESCRICAO                  NOTA FISCAL      EMISSAO  UN      QUANT         UNITARIO       UNITARIO  **** B R U T O *** CONV   CRM     NOME DO CRM            UNITARIO   UNITARIO  *** L I Q U I D O **"
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                                                                                                                                                                                     999999.99  999999.99  999999.99  999999.99

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

cMoeda := STR0010+GetMV("MV_SIMB"+Str(mv_par09,1))		//"Valores em "
titulo := titulo+" "+cMoeda

//��������������������������������������������������������������Ŀ
//� Cria filtro para impressao das devolucoes                    �
//� *** este filtro possui 208 posicoes  ***                     �
//����������������������������������������������������������������
dbSelectArea("SD1")
cArqTrab1  := CriaTrab( "" , .F. )
#IFDEF TOP
    If (TcSrvType()#'AS/400')
        //��������������������������������Ŀ
        //� Query para SQL                 �
        //����������������������������������
	    cSD1   := "SD1TMP"
	    aStru  := dbStruct()
	    cQuery := "SELECT * FROM " + RetSqlName("SD1") + " SD1 "
	    cQuery += "WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
	    cQuery += "SD1.D1_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	    cQuery += "SD1.D1_DTDIGIT BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+ "' AND "
	    cQuery += "SD1.D1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	    cQuery += "SD1.D1_TIPO = 'D' AND "
    	 cQuery += " NOT ("+IsRemito(3,'SD1.D1_TIPODOC')+ ") AND "
	    cQuery += "SD1.D_E_L_E_T_ <> '*' "
	    cQuery += " ORDER BY SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD"
	    cQuery := ChangeQuery(cQuery)
	    MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD1TRB', .F., .T.)},OemToAnsi(STR0011)) //"Seleccionado registros"
	    For nj := 1 to Len(aStru)
		    If aStru[nj,2] != 'C'
			   TCSetField('SD1TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
		    EndIf	
	    Next nj
	    A780CriaTmp(cArqTrab1, aStru, cSD1, "SD1TRB")
	    IndRegua(cSD1,cArqTrab1,"D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD",,".T.",STR0011)		//"Selecionando Registros..."
	Else    
#ENDIF
	    cSD1	   := "SD1"
	    cCondicao1 := 'D1_FILIAL=="' + xFilial("SD1") + '".And.'
	    cCondicao1 += 'D1_FORNECE>="' + mv_par01 + '".And.'
	    cCondicao1 += 'D1_FORNECE<="' + mv_par02 + '".And.'
	    cCondicao1 += 'DtoS(D1_DTDIGIT)>="' + DtoS(mv_par03) + '".And.'
	    cCondicao1 += 'DtoS(D1_DTDIGIT)<="' + DtoS(mv_par04) + '".And.'
	    cCondicao1 += 'D1_COD>="' + mv_par05 + '".And.'
	    cCondicao1 += 'D1_COD<="' + mv_par06 + '".And.'
	    cCondicao1 += 'D1_TIPO=="D" .And. !('+IsRemito(2,'SD1->D1_TIPODOC')+')'		

	    cArqTrab1  := CriaTrab("",.F.)
	    IndRegua(cSD1,cArqTrab1,"D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD",,cCondicao1,STR0011)		//"Selecionando Registros..."
	    nIndD1 := RetIndex()

        #IFNDEF TOP	    
	       dbSetIndex(cArqTrab1+ordBagExt())
        #ENDIF

	    dbSetOrder(nIndD1+1)
#IFDEF TOP
    Endif  	    
#ENDIF   

dbSeek(xFilial("SD1"))

//��������������������������������������������������������������Ŀ
//� Monta filtro para processar as vendas por cliente            �
//����������������������������������������������������������������
DbSelectArea("SD2")
cFiltro := SD2->(dbFilter())
If Empty(cFiltro)
	bFiltro := { || .T. }
Else
	cFiltro := "{ || " + cFiltro + " }"
	bFiltro := &(cFiltro)
Endif
//��������������������������������������������������������������Ŀ
//� Monta filtro para processar as vendas por cliente            �
//����������������������������������������������������������������
cArqTrab2  := CriaTrab( "" , .F. )
#IFDEF TOP            
    If (TcSrvType()#'AS/400')
        //��������������������������������Ŀ
        //� Query para SQL                 �
        //����������������������������������
	    cSD2   := "SD2TMP"
	    aStru  := dbStruct()
	    Aadd(aStru, {'C5_CLIVALE', 'C', 6, 0})
	    Aadd(aStru, {'C5_LJCVALE', 'C', 2, 0})
	    Aadd(aStru, {'C5_CONVENI', 'C', 2, 0})
	    Aadd(aStru, {'C5_CRM',     'C', 6, 0})
	    Aadd(aStru, {'C5_CRMNOM',  'C', 20, 0})
	    
	    cCampo := Space(0)
	    For nCampo := 1 To fCount()
	    	cCampo += 'SD2.' + AllTrim(FieldName(nCampo)) + ','
	    Next

	    cQuery := "SELECT "+cCampo+" C5_CLIVALE, C5_LJCVALE, C5_CONVENI, C5_CRM, C5_CRMNOM FROM " + RetSqlName("SD2") + " SD2, " + RetSqlName("SC5") + " SC5 "
	    cQuery += "WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND "
	    cQuery += "SD2.D2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	    cQuery += "SD2.D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
	    cQuery += "SD2.D2_COD     BETWEEN '"+ mv_par05+"' AND '"+mv_par06+"' AND "
	    cQuery += "SD2.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND "
        cQuery += " NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ") AND "

		// faz amarracao com o Pedido de Vendas para pegar o cliente vale (Jomhedica) 
		// Marllon - 16/12/2005 - solicitacao Enio/Vivian conforme Chamado AC num. SAFEDZ
	    cQuery += "SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND "
	    cQuery += "SC5.C5_NUM = SD2.D2_PEDIDO AND "
	    cQuery += "SC5.C5_CLIVALE BETWEEN '"+mv_par18+"' AND '"+mv_par19+"' AND "
	    cQuery += "SC5.C5_CRM BETWEEN '"+mv_par20+"' AND '"+mv_par21+"' AND "
	    cQuery += "SC5.C5_CONVENI BETWEEN '"+mv_par22+"' AND '"+mv_par23+"' AND "
	    cQuery += "SC5.D_E_L_E_T_ <> '*' AND "
		// Fim - Marllon 
		
	    cQuery += "SD2.D_E_L_E_T_ <> '*' "
	    cQuery += "ORDER BY SD2.D2_FILIAL,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_COD,SD2.D2_ITEM"
	    cQuery := ChangeQuery(cQuery)
	    MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD2TRB', .F., .T.)},OemToAnsi(STR0011)) //"Seleccionado registros"
	    For nj := 1 to Len(aStru)
		    If aStru[nj,2] != 'C'
			    TCSetField('SD2TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
		    EndIf	
	    Next nj

	    A780CriaTmp(cArqTrab2, aStru, cSD2, "SD2TRB")
	    IndRegua(cSD2,cArqTrab2,"D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_COD+D2_SERIE+D2_DOC+D2_ITEM",,".T.",STR0011)		//"Selecionando Registros..."
    Else
#ENDIF                   
	    cSD2	  := "SD2"
	    cCondicao := 'D2_FILIAL == "' + xFilial("SD2") + '" .And. '
	    cCondicao += 'D2_CLIENTE >= "' + mv_par01 + '" .And. '
	    cCondicao += 'D2_CLIENTE <= "' + mv_par02 + '" .And. '
	    cCondicao += 'DTOS(D2_EMISSAO) >= "' + DTOS(mv_par03) + '" .And. '
	    cCondicao += 'DTOS(D2_EMISSAO) <= "' + DTOS(mv_par04) + '" .And. '
	    cCondicao += 'D2_COD >= "' + mv_par05 + '" .And. '
	    cCondicao += 'D2_COD <= "' + mv_par06 + '" .And. '
	    cCondicao += '!(D2_TIPO $ "BD")'
	    cCondicao += '.And. !('+IsRemito(2,'SD2->D2_TIPODOC')+')'		
 
	    IndRegua(cString,cArqTrab2,"D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_COD+D2_SERIE+D2_DOC+D2_ITEM",,cCondicao,STR0011)		//"Selecionando Registros..."
	    nIndD2 := RetIndex()

        #IFNDEF TOP	    
	       dbSetIndex(cArqTrab2+ordBagExt())
        #ENDIF
        
	    dbSetOrder(nIndD2+1)
#IFDEF TOP	    
	Endif    
#ENDIF


dbSelectArea("SA1")
dbSetOrder(1)
#IFDEF TOP
    cAliasSA1 := GetNextAlias()
    aStru  := dbStruct()
    cQuery := "SELECT A1_FILIAL,A1_COD,A1_LOJA,A1_NOME,A1_OBSERV "    
    cQuery += "FROM " + RetSqlName("SA1") + " SA1 "
    cQuery += "WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
    cQuery += "SA1.A1_COD >= '"        +MV_PAR01+"' AND "
	cQuery += "SA1.A1_COD <= '"        +MV_PAR02+"' AND "
    cQuery += "SA1.D_E_L_E_T_ = ' ' "
    cQuery += " ORDER BY "+SqlOrder(SA1->(IndexKey()))
    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAliasSA1, .F., .T.)
#ELSE
	cAliasSA1 := "SA1"
#ENDIF

//��������������������������������������������������������������Ŀ
//� Verifica se aglutinara produtos de Grade                     �
//����������������������������������������������������������������
SetRegua(RecCount())		// Total de Elementos da regua

If ( (cSD2)->D2_GRADE=="S" .And. MV_PAR12 == 1)
	lGrade := .T.
	bGrade := { || Substr((cSD2)->D2_COD, 1, nTamref) }
Else
	lGrade := .F.
	bGrade := { || (cSD2)->D2_COD }
Endif
//��������������������������������������������������������������Ŀ
//� Procura pelo 1o. cliente valido                              �
//����������������������������������������������������������������
#IFNDEF TOP
	dbSeek(xFilial()+mv_par01, .t.)
#ENDIF

While (cAliasSA1)->( ! EOF() .AND. A1_COD <= MV_PAR02 ) .And. lContinua .And. (cAliasSA1)->A1_FILIAL == xFilial("SA1")
	
	If lEnd
		@Prow()+1,001 Psay STR0012	//"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIf
	
	lNewCli := .T.
	
	//����������������������������������������������������������Ŀ
	//� Procura pelas saidas daquele cliente                     �
	//������������������������������������������������������������
	DbSelectArea(cSD2)
	If DbSeek(xFilial("SD2")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA)
		lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
		
		//����������������������������������������������������������Ŀ
		//� Montagem da quebra do relatorio por  Cliente             �
		//������������������������������������������������������������
		cClieAnt := (cAliasSA1)->A1_COD
		cLojaAnt := (cAliasSA1)->A1_LOJA
		lNewProd := .T.
		lNewCli  := .T.
		nTotCli1 := 0
		nTotCli2 := 0
		nTotCli3 := 0
		While !Eof() .and. ;
			((cSD2)->(D2_FILIAL+D2_CLIENTE+D2_LOJA)) == (xFilial("SD2")+cClieAnt+cLojaAnt)
			
			//����������������������������������������������������������Ŀ
			//� Verifica Se eh uma tipo de nota valida                   �
			//� Verifica intervalo de Codigos de Vendedor                �
			//� Valida o produto conforme a mascara                      �
			//������������������������������������������������������������
			lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
			If	! Eval(bFiltro) .Or. !A780Vend(@cVends,nVend) .Or. !lRet //.or. SD2->D2_TIPO$"BD" ja esta no filtro
				dbSkip()
				Loop
			EndIf
			
			//����������������������������������������������������������Ŀ
			//� Impressao do Cabecalho.                                  �
			//������������������������������������������������������������
			If Li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				lProcessou := .T.
			EndIf
			
			
			//����������������������������������������������������������Ŀ
			//� Impressao da quebra por produto e NF                     �
			//������������������������������������������������������������
			cProdAnt := Eval(bGrade)
			lNewProd := .T.
			
			While ! Eof() .And. ;
				(cSD2)->(D2_FILIAL + D2_CLIENTE + D2_LOJA  + EVAL(bGrade) ) == ;
				( xFilial("SD2") + cClieAnt   + cLojaAnt + cProdAnt )
				IncRegua()
				
				//����������������������������������������������������������Ŀ
				//� Avalia TES                                               �
				//������������������������������������������������������������
				lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
				If !AvalTes((cSD2)->D2_TES,cEstoq,cDupli) .Or. !Eval(bFiltro) .Or. !lRet
					dbSkip()
					Loop
				Endif
				
				If !A780Vend(@cVends,nVend)
					dbskip()
					Loop
				Endif
				
				//����������������������������������������������������������Ŀ
				//� Impressao  dos dados do Cliente                          �
				//������������������������������������������������������������
				If lNewCli
					
					If Li > 51
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
						lProcessou := .T.
					EndIf
					
					@ Li,000 Psay Repli('-',220)
					Li++
					@ Li,000 Psay (cSD2)->D2_CLIENTE+"   "+(cAliasSA1)->A1_NOME + Space(10) + "Cliente Vale: " + (cSD2)->C5_CLIVALE
					If !Empty((cAliasSA1)->A1_OBSERV)
						Li++
						@ Li,000 Psay STR0013+(cAliasSA1)->A1_OBSERV		//"Obs.: "
					EndIf
					Li++
					lNewCli := .F.
				Endif
				
				//����������������������������������������������������������Ŀ
				//� Impressao do Cabecalho.                                  �
				//������������������������������������������������������������
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					@ Li,000 Psay Repli('-',220)
					Li++
					@ Li,000 Psay (cSD2)->D2_CLIENTE+"   "+(cAliasSA1)->A1_NOME
					If !Empty((cAliasSA1)->A1_OBSERV)
						Li++
						@ Li,000 Psay STR0013+(cAliasSA1)->A1_OBSERV		//"Obs.: "
					EndIf
					Li+=2
				EndIf
				
				//����������������������������������������������������������Ŀ
				//� Faz Impressao de Codigo e Descricao Do Produto.          �
				//������������������������������������������������������������
				If lNewProd
					lNewProd := .F.
					Li+=2
					@Li ,  0 Psay Eval(bGrade)
					SB1->(dbSeek(xFilial("SB1")+(cSD2)->D2_COD))
					If mv_par16 = 1
						@li , 16 Psay Substr(SB1->B1_DESC,1,28)
					Else
						If SA7->(dbSeek(xFilial("SA7")+(cSD2)->(D2_COD+D2_CLIENTE+D2_LOJA)))
							@li , 16 Psay Substr(SA7->A7_DESCCLI,1,30)
						Else
							@li , 16 Psay Substr(SB1->B1_DESC,1,28)
						Endif
					EndIf
				EndIf
				
				//����������������������������������������������������������Ŀ
				//� Caso seja grade aglutina todos produtos do mesmo Pedido  �
				//������������������������������������������������������������
				If lGrade  // Aglutina Grade
					cProdRef:= Substr((cSD2)->D2_COD,1,nTamRef)
					cNumPed := (cSD2)->D2_PEDIDO
					nReg    := 0
					nDevQtd :=0
					nDevVal :=0
					
					While !Eof() .And. cProdRef == Eval(bGrade) .And.;
						(cSD2)->D2_GRADE == "S" .And. cNumPed == (cSD2)->D2_PEDIDO .And.;
						(cSD2)->D2_FILIAL == xFilial("SD2")
						
						nReg := Recno()
						//���������������������������������������������Ŀ
						//� Valida o produto conforme a mascara         �
						//�����������������������������������������������
						lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
						If !lRet .Or. !Eval(bFiltro)
							dbSkip()
							Loop
						EndIf
						
						//�����������������������������Ŀ
						//� Tratamento das Devolu�oes   �
						//�������������������������������
						If mv_par10 == 1 //inclui Devolucoes
							SomaDev(@nDevQtd, @nDevVal , @aDev)
						EndIf
						
						nTotQuant += (cSD2)->D2_QUANT
						dbSkip()
						
					EndDo
					
					//���������������������������������������������Ŀ
					//� Verifica se processou algum registro        �
					//�����������������������������������������������
					If nReg > 0
						dbGoto(nReg)
						nReg:=0
					EndIf
					
				Else
					//�����������������������������Ŀ
					//� Tratamento das devolucoes   �
					//�������������������������������
					nDevQtd :=0
					nDevVal :=0
					
					If mv_par10 == 1 //inclui Devolucoes
						SomaDev(@nDevQtd, @nDevVal , @aDev)
					EndIf
					
					nTotQuant := (cSD2)->D2_QUANT
					
				EndIf
				
				//����������������������������������������������������������Ŀ
				//� Imprime os dados da NF                                   �
				//������������������������������������������������������������
				SF2->(dbSeek(xFilial("SF2")+(cSD2)->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
				cUM := (cSD2)->D2_UM
				
				If MV_PAR25 = 1
					@Li , 46 Psay (cSD2)->(D2_DOC+'/'+D2_SERIE)
					@Li , 60 Psay (cSD2)->D2_EMISSAO
					@Li , 70 Psay cUM
					@Li , 73 Psay nTotQuant          PICTURE '@ER 999999.99'
				EndIf

				// Alterado o conceito em 19/05/2010 - para custo atual por solicitacao
				// da Andreia Braun - Marcos Soares
				// custo da venda 
				SB2->( dbSeek(xFilial('SB2')+(cSD2)->D2_COD+(cSD2)->D2_LOCAL) )
				nCustoUni := SB2->B2_CM1
				
				If MV_PAR24 = 2
					If MV_PAR25 = 1
						@Li, 82 Psay nCustoUni  PICTURE PesqPict("SD2","D2_CUSTO1",16,mv_par09)
					EndIf
					nTotCusto += (nTotQuant * nCustoUni)
     			EndIf
				
				//����������������������������������������������������������Ŀ
				//� Faz Verificacao da Moeda Escolhida e Imprime os Valores  �
				//������������������������������������������������������������
				nVlrUnit := xMoeda((cSD2)->D2_PRCVEN,SF2->F2_MOEDA,MV_PAR09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
				If MV_PAR25 = 1
					@Li , 100 Psay nVlrUnit           PICTURE PesqPict("SD2","D2_PRCVEN",14,mv_par09)
				EndIf
				nTotVenda += (nTotQuant * nVlrUnit)
				
				// margem de contribuicao
				nMargem := ((nVlrUnit - nCustoUni)/nVlrUnit) * 100
				If MV_PAR24 = 2
					If MV_PAR25 = 1
						@Li, 117 Psay  nMargem PICTURE '@ER 9999.99'
					EndIf
					// margem bruta
					aMediaMPro[1] += 1
					aMediaMPro[2] += nMargem
					aMediaMCli[1] += 1
					aMediaMCli[2] += nMargem
					aMediaMarg[1] += 1
					aMediaMarg[2] += nMargem
     			EndIf
                
				nLucro  := ((nVlrUnit - nCustoUni)/nCustoUni) * 100
				If MV_PAR24 = 2
					If MV_PAR25 = 1
						@Li, 126 Psay  nLucro PICTURE '@ER 9999.99'
					EndIf
					// lucro bruto
					aMediaLPro[1] += 1
					aMediaLPro[2] += nLucro
					aMediaLCli[1] += 1
					aMediaLCli[2] += nLucro
					aMediaLuc[1] += 1
					aMediaLuc[2] += nLucro
     			EndIf

				// quantidade total do produto
				nAcN1 += nTotQuant

				//����������������������������������������������������������Ŀ
				//� Acumula o total por produto                              �
				//������������������������������������������������������������
				nTotPro1 += nTotQuant
				nTotPro2 += (nTotQuant * nCustoUni)
				nTotPro3 += (nTotQuant * nVlrUnit)
	
				//����������������������������������������������������������Ŀ
				//� Acumula o total por cliente                              �
				//������������������������������������������������������������
				nTotCli1 += nTotQuant
				nTotCli2 += (nTotQuant * nCustoUni)
				nTotCli3 += (nTotQuant * nVlrUnit)
				
				/* Adicao de colunas por solicitacao do Messias - 16/04/2009 */
				If MV_PAR25 = 1
					If MV_PAR24 = 2
						@Li, 136 Psay  (cSD2)->C5_CONVENI 
						@Li, 140 Psay  (cSD2)->C5_CRM 
						@Li, 150 Psay  (cSD2)->C5_CRMNOM 
					EndIf
				EndIf
				
				// informacoes de impostos
				nICMS     := (cSD2)->D2_VALICM / nTotQuant
				nImposto  := (nVlrUnit - nImpFed)/100
				nMargLiq  := (((nVlrUnit - nICMS - nImposto) - nCustoUni) / (nVlrUnit - nICMS - nImposto)) * 100
				nLucrLiq  := (((nVlrUnit - nICMS - nImposto) - nCustoUni) / nCustoUni) * 100

				// totalizadores de impostos 
				nICMSPro  += nICMS * nTotQuant
				nICMSCli  += nICMS * nTotQuant
				nICMSGer  += nICMS * nTotQuant
				nImpPro   += nImposto * nTotQuant
				nImpCli   += nImposto * nTotQuant
				nImpGer   += nImposto * nTotQuant
				
				// margem liquida
				aMargLPro[1] += 1
				aMargLPro[2] += nMargLiq
				aMargLCli[1] += 1
				aMargLCli[2] += nMargLiq
				aMargLGer[1] += 1
				aMargLGer[2] += nMargLiq

				// lucro liquido
				aLucrLPro[1] += 1
				aLucrLPro[2] += nLucrLiq
				aLucrLCli[1] += 1
				aLucrLCli[2] += nLucrLiq
				aLucrLGer[1] += 1
				aLucrLGer[2] += nLucrLiq

				If MV_PAR25 = 1
					If MV_PAR24 = 2
						@Li, 172 Psay  nICMS       PICTURE '@ER 999999.99'
						@Li, 183 Psay  nImposto    PICTURE '@ER 999999.99'
						@Li, 194 Psay  nMargLiq    PICTURE '@ER 999999.99'
						@Li, 205 Psay  nLucrLiq    PICTURE '@ER 999999.99'
					EndIf
				EndIf
				
				//����������������������������������������������������������Ŀ
				//� Imprime as devolucoes do produto selecionado             �
				//������������������������������������������������������������
				If nDevQtd != 0
					Li++
					nVlrTot := nDevVal
					nAcN1 += nDevQtd
					If MV_PAR25 = 1
						@Li,053 Psay STR0017 // "DEV"
						@Li,070 Psay cUM
						@Li,073 Psay nDevQtd          PICTURE "@ER"+PesqPictqt("D2_QUANT",14)
					EndIf
				EndIf
				If MV_PAR25 = 1
					Li++
				EndIf
				nTotQuant := 0
				
				dbSkip()
				
			EndDo
			
			//����������������������������������������������������������Ŀ
			//� Acumula o total geral do relatorio                       �
			//������������������������������������������������������������
			nTotGer1 += nAcN1

			//����������������������������������������������������������Ŀ
			//� Imprime o total do produto selecionado                   �
			//������������������������������������������������������������
			If nAcN1#0 .Or. nAcN2#0	.Or. nDevQtd#0
				Li++
				@Li,  07 Psay STR0014+cProdAnt	//"TOTAL DO PRODUTO - "
				@Li,  52 Psay "---->"
				@Li,  70 Psay cUM
				@Li,  72 Psay nTotPro1 PICTURE '@ER 9999999.99'
				If MV_PAR24 = 2
				    @Li, 084 Psay nTotPro2/nTotPro1 PICTURE "@ER 999,999,999.99"
				EndIf

			    @Li, 100 Psay nTotPro3/nTotPro1 PICTURE "@ER 999,999,999.99"

				If MV_PAR24 = 2
					@Li, 117 Psay aMediaMPro[2]/aMediaMPro[1] PICTURE '@ER 9999.99'
					@Li, 126 Psay aMediaLPro[2]/aMediaLPro[1] PICTURE '@ER 9999.99'
					@Li, 172 Psay  nICMSPro       PICTURE '@ER 999999.99'
					@Li, 183 Psay  nImpPro        PICTURE '@ER 999999.99'
					@Li, 194 Psay  aMargLPro[2]/aMargLPro[1]    PICTURE '@ER 999999.99'
					@Li, 205 Psay  aLucrLPro[2]/aMargLPro[1]    PICTURE '@ER 999999.99'
				EndIf
				nAcN1 := 0
				nAcN2 := 0
				nTotPro1 := 0
				nTotPro2 := 0
				nTotPro3 := 0
				aMediaMPro := {0,0}
				aMediaLPro := {0,0}
				nICMSPro   := 0
				nImpPro    := 0
				aMargLPro  := {0,0}
				aLucrLPro  := {0,0}
				cProdAnt   := (cSD2)->D2_COD
			EndIf
			
		EndDo
		//����������������������������������������������������������Ŀ
		//� Ocorreu quebra por cliente                               �
		//������������������������������������������������������������
		If !(lNewCli)
			LI+=2
			@Li , 07 Psay STR0015+cClieAnt+'/'+cLojaAnt	//"TOTAL DO CLIENTE - "
			@Li , 52 Psay "---->"
			@Li , 72 Psay nTotCli1 PICTURE '@ER 9999999.99'
			If MV_PAR24 = 2
			    @Li, 084 Psay nTotCli2/nTotCli1 PICTURE "@ER 999,999,999.99"
			EndIf

		    @Li, 100 Psay nTotCli3/nTotCli1 PICTURE "@ER 999,999,999.99"

			If MV_PAR24 = 2
				@Li, 117 Psay aMediaMCli[2]/aMediaMCli[1] PICTURE '@ER 9999.99'
				@Li, 126 Psay aMediaLCli[2]/aMediaLCli[1] PICTURE '@ER 9999.99'
				@Li, 172 Psay  nICMSCli       PICTURE '@ER 999999.99'
				@Li, 183 Psay  nImpCli        PICTURE '@ER 999999.99'
				@Li, 194 Psay  aMargLCli[2]/aMargLCli[1]     PICTURE '@ER 999999.99'
				@Li, 205 Psay  aLucrLCli[2]/aLucrLCli[1]     PICTURE '@ER 999999.99'
			EndIf
			LI++
		EndIf

		cClieAnt := ""
		cLojaAnt := ""
		nTotCli1 := 0
		nTotCli2 := 0
		nTotCli3 := 0
		aMediaMCli := {0,0}
		aMediaLCli := {0,0}
		nICMSCli   := 0
		nImpCli    := 0
		aMargLCli  := {0,0}
		aLucrLCli  := {0,0}
	EndIf
	
	DbSelectArea(cAliasSA1)
	DbSkip()
EndDo

If lProcessou  // total geral do relatorio
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	EndIf
	Li+=2
	@Li, 007 Psay STR0016
    @Li, 071 Psay nTotGer1  PICTURE "@ER"+PesqPictqt("D2_QUANT",16)
	If MV_PAR24 = 2
	    @Li, 084 Psay nTotCusto PICTURE "@ER 999,999,999.99"
	EndIf

    @Li, 100 Psay nTotVenda PICTURE "@ER 999,999,999.99"

	If MV_PAR24 = 2
		@Li, 117 Psay aMediaMarg[2]/aMediaMarg[1] PICTURE '@ER 9999.99'
		@Li, 126 Psay aMediaLuc[2]/aMediaLuc[1]   PICTURE '@ER 9999.99'
		@Li, 172 Psay nICMSGer       PICTURE '@ER 999999.99'
		@Li, 183 Psay nImpGer        PICTURE '@ER 999999.99'
		@Li, 194 Psay aMargLGer[2]/aMargLGer[1]     PICTURE '@ER 999999.99'
		@Li, 205 Psay aLucrLGer[2]/aLucrLGer[1]     PICTURE '@ER 999999.99'
	EndIf
	roda(cbcont,cbtxt,tamanho)
Endif

dbSelectArea("SD1")
dbClearFilter()
RetIndex("SD1")

dbSelectArea("SD2")
dbClearFilter()
RetIndex("SD2")

(cSD1)->(DbCloseArea())
(cSD2)->(DbCloseArea())
fErase(cArqTrab1+OrdBagExt())
fErase(cArqTrab2+OrdBagExt())
#IFDEF TOP
    fErase(cArqTrab1+GetDbExtension())
    fErase(cArqTrab2+GetDbExtension())
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
EndIf

MS_FLUSH()

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A780Vend � Autor � Rogerio F. Guimaraes  � Data � 28.10.97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica Intervalo de Vendedores                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR780			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function A780Vend(cVends,nVend)
Local cAlias:=Alias(),sVend,sCampo
Local lVend, cVend, cBusca
Local nx
lVend  := .F.
cVends := ""
// Nao tem Alias na frente dos campos do SD2 para poder trabalhar em DBF e TOP
cBusca := xFilial("SF2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA
dbSelectArea("SF2")
If dbSeek(cBusca)
	cVend := "1"
	For nx := 1 to nVend
		sCampo := "F2_VEND" + cVend
		sVend := FieldGet(FieldPos(sCampo))
		If !Empty(sVend)
			cVends += If(Len(cVends)>0,"/","") + sVend
		EndIf
		If (sVend >= mv_par07 .And. sVend <= mv_par08) .And. (nX == 1 .Or. !Empty(sVend))
			lVend := .T.
		EndIf
		cVend := Soma1(cVend, 1)
	Next
EndIf
dbSelectArea(cAlias)
Return(lVend)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � SomaDev  � Autor � Claudecino C Leao     � Data � 28.09.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Soma devolucoes de Vendas                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR780			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function SomaDev(nDevQtd, nDevVal, aDev )

Local DtMoedaDev  := (cSD2)->D2_EMISSAO

If (cSD1)->(dbSeek(xFilial("SD1")+(cSD2)->(D2_CLIENTE + D2_LOJA + D2_COD )))
	//��������������������������Ŀ
	//� Soma Devolucoes          �
	//����������������������������
	While (cSD1)->(D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD) == (cSD2)->( xFilial("SD2")+D2_CLIENTE+D2_LOJA+D2_COD).AND.!(cSD1)->(Eof())                   
	
        DtMoedaDev  := IIF(MV_PAR17 == 1,(cSD1)->D1_DTDIGIT,(cSD2)->D2_EMISSAO)

		SF1->(dbSeek(xFilial("SF1")+(cSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))

		If (cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) == (cSD2)->(D2_DOC   + D2_SERIE   + D2_ITEM )

			Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
			nDevQtd -= (cSD1)->D1_QUANT
			nDevVal -=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,DtMoedaDev,nDecs+1,SF1->F1_TXMOEDA)

		ElseIf mv_par15 == 2 .And. (cSD1)->D1_DTDIGIT < (cSD2)->D2_EMISSAO .And.;
			   (cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) < ;
			   (cSD2)->(D2_DOC   + D2_SERIE   + D2_ITEM ) .And.;
			   Ascan(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI))) == 0

			Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
			nDevQtd -= (cSD1)->D1_QUANT
			nDevVal -=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,DtMoedaDev,nDecs+1,SF1->F1_TXMOEDA)

		EndIf

        (cSD1)->(dbSkip())

	EndDo

EndIf
Return .t.
/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    �A780CriaTmp� Autor � Rubens Joao Pante     � Data � 04/07/01 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Cria temporario a partir da consulta corrente (TOP)          ���
��������������������������������������������������������������������������Ĵ��
��� Uso      �MATR780 (TOPCONNECT)                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function A780CriaTmp(cArqTmp, aStruTmp, cAliasTmp, cAlias)
	Local nI, nF, nPos
	Local cFieldName := ""
	nF := (cAlias)->(Fcount())
    dbCreate(cArqTmp,aStruTmp)
    DbUseArea(.T.,,cArqTmp,cAliasTmp,.T.,.F.)
	(cAlias)->(DbGoTop())
	While ! (cAlias)->(Eof())
        (cAliasTmp)->(DbAppend())
		For nI := 1 To nF 
			cFieldName := (cAlias)->( FieldName( ni ))
		    If (nPos := (cAliasTmp)->(FieldPos(cFieldName))) > 0
		   		    (cAliasTmp)->(FieldPut(nPos,(cAlias)->(FieldGet((cAlias)->(FieldPos(cFieldName))))))
            EndIf   		
		Next
		(cAlias)->(DbSkip())
	End
	(cAlias)->(dbCloseArea())
    DbSelectArea(cAliasTmp)
Return Nil	

/*
SELECT D2_DOC, D2_SERIE,  C5_CLIVALE, C5_LJCVALE FROM  SD2010  SD2, SC5010  SC5 
WHERE SD2.D2_FILIAL = '01' AND 
SD2.D2_CLIENTE BETWEEN '      ' AND 'ZZZZZZ' AND 
SD2.D2_EMISSAO BETWEEN '20050201' AND '20052801' AND 
SD2.D2_COD     BETWEEN '        ' AND 'ZZZZZZZ' AND 
SD2.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND 
SC5.C5_FILIAL = '01' AND 
SC5.C5_NUM = SD2.D2_PEDIDO AND 
SC5.C5_CLIVALE BETWEEN '      ' AND 'ZZZZZZ' AND 
SC5.D_E_L_E_T_ <> '*' AND 
SD2.D_E_L_E_T_ <> '*' 
ORDER BY SD2.D2_FILIAL,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_COD,SD2.D2_ITEM
*/
