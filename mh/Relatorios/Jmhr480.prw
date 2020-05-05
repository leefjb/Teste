// Criar par�metro "JM_PASTATX" --> Local onde ser� salvo o arquivo CSV gerado pelo programa.
// este parametro foi descontinuado. Em substituicao foi criado uma pergunta no SX1

#INCLUDE "Jmhr480.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Jmhr480  � Autor � Cl�udio Viana da Silva� Data � 16.06.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio de Controle de Materiais de Terceiros em nosso po-���
���          �der e nosso Material em poder de Terceiros.                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � Jmhr480(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Jmhr480()

	Local oReport

	Jmhr480R3()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Jmhr480R3 � Autor � Waldemiro L. Lustosa  � Data � 12.05.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio de Controle de Materiais de Terceiros em nosso po-���
���          �der e nosso Material em poder de Terceiros. (Antigo)        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � Jmhr480(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Rodrigo     �23/06/98�XXXXXX�Acerto no tamanho do documento para 12    ���
���            �        �      �posicoes                                  ���
���Fernando J. �08.12.98�3781A �Substituir PesqPictQt por PescPict        ���
���CesarValadao�30/03/99�XXXXXX�Manutencao na SetPrint()                  ���
���CesarValadao�04/05/99�21554A�Manutencao Lay-Out P Imprimir Quant c/ 17 ���
���CesarValadao�12/08/99�21421A�Manutencao Lay-Out P Imprimir NF Retorno  ���
���            �        �      �Alinhada a NF de Origem                   ���
���Patricia Sal�13/12/99�14655A�Validacao p/Data Digitacao nas Devolucoes ���
���            �        �      �Incl. Param Dt.Inicial/Final na CalcTerc()���
���Patricia Sal�20/12/99�XXXXXX�Conversao dos Campos Fornec./Cliente p/   ���
���            �        �      �(20 posicoes) e Loja p/ 4 posicoes.       ���
���Iuspa       �06/12/00�      �Data de/ate para devolucoes               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Jmhr480R3()

	LOCAL wnrel, nOrdem
	LOCAL Tamanho := "G"
	LOCAL cDesc1  := STR0001	//"Este programa ira emitir o Relatorio de Materiais"
	LOCAL cDesc2  := STR0002	//"de Terceiros em nosso poder e/ou nosso Material em"
	LOCAL cDesc3  := STR0003	//"poder de Terceiros."
	LOCAL cString := "SB6"
	LOCAL aOrd    := {}  // {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006)}	//" Produto/Local "###" Cliente/Fornecedor "###" Dt. Mov/Produto "
	Local cQuery  := ""
	
	PRIVATE cCondCli, cCondFor
	PRIVATE aReturn := {OemToAnsi(STR0007), 1,OemToAnsi(STR0008), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
	PRIVATE nomeprog:= "Jmhr480"
	PRIVATE aLinha  := { },nLastKey := 0
	PRIVATE cPerg   := "JMHR480"    // COPIA DE MTR480 ATE A SEQ. 14
	PRIVATE Titulo  := OemToAnsi(STR0009)	//"Relacao de materiais de Terceiros e em Terceiros"
	PRIVATE cabec1, cabec2, nTipo, CbTxt, CbCont
	PRIVATE lListCustM := .T.
	PRIVATE lCusFIFO   := GetMV('MV_CUSFIFO')
	
	//�����������������������������������������������������������������������������Ŀ
	//� Utiliza variaveis static p/ Grupo de Fornec/Clientes(001) e de Loja(002)    �
	//�������������������������������������������������������������������������������
	
	Static aTamSXG, aTamSXG2
	
	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
	//����������������������������������������������������������������
	CbTxt := SPACE(10)
	CbCont:= 00
	li	  := 80
	m_pag := 01
	
	//��������������������������������������������������������������Ŀ
	//� Cria a Pergunta Nova no Sx1                                  �
	//����������������������������������������������������������������
	PutSx1 (cPerg,"15","QTDE. na 2a. U.M. ?","CTD. EN 2a. U.M. ?","QTTY. in 2a. U.M. ?","mv_chf","N",1,0,2,"C","","","","","mv_par15","Sim","Si","Yes","","Nao","No","No","","","","","","","","","","","","","")
	PutSX1Help("P.MTR48015.",{'Imprime as Quantidades na 2a UM?        ', 'Sim=Utiliza a 2aUM na impressao         ', 'Nao=Utiliza a 1aUM na impressao(padrao) '}, {'Print the quantities at 2nd MU?         ', 'Yes=Uses 2nd MU at the print            ',  'No=Uses 1st MU at the print (defaut)    '}, {'�Imprime las cantidades en la 2a UM?    ', 'Si=Utiliza la 2aUM en la impresion      ', 'No=Utiliza la 1aUM en la impresion(est.)'})
	
	PutSx1(cPerg,'16','Lista Custo        ?','�Lista Costo       ?','List Cost          ?','mv_chg','N',01,0,1,'C','','','','','mv_par16','Medio','Promedio','Average','','FIFO/PEPS','FIFO/PEPS','FIFO','','','','','','','','','', {'Informe o tipo de custo a ser listado:  ', '1. Custo Medio                          ', '2. Custo FIFO/PEPS(p/"MV_CUSFIFO" ativo)'}, {'Inform the kind of cost to be listed:   ', '1. Average Cost                         ', '2. FIFO Cost (with "MV_CUSFIFO" active) '}, {'Informe el tipo de costo a ser listado: ', '1. Costo Promedio                       ', '2. Costo FIFO/PEPS(p/"MV_CUSFIFO"activo)'})
	PutSx1(cPerg,'17','Arquivo Excel      ?','                    ','                    ','mv_chh','C',50,0,1,'G','','','','','mv_par17',"","","","","","","","","","","","","","","","",,,)

	PutSx1(cPerg,'18','Grupo Produto de   ?','                    ','                    ','mv_chi','C',04,0,1,'G','','SBM','','','mv_par18',"","","","","","","","","","","","","","","","",,,)
	PutSx1(cPerg,'19','Grupo Produto ate  ?','                    ','                    ','mv_chj','C',04,0,1,'G','','SBM','','','mv_par19',"","","","","","","","","","","","","","","","",,,)

	//�������������������������������������������������������������������������������Ŀ
	//� Verifica conteudo da variavel p/ Grupo de Clientes/Forneced.(001) e Loja(002) �
	//���������������������������������������������������������������������������������
	aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
	aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)
	
	//��������������������������������������������������������������Ŀ
	//� Verifica as perguntas selecionadas                           �
	//����������������������������������������������������������������
	pergunte(cPerg,.F.)
	//�����������������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para parametros                                  �
	//� mv_par01   		// Cliente Inicial                		              �
	//� mv_par02        // Cliente Final                       	              �
	//� mv_par03        // Fornecedor Inicial                     	          �
	//� mv_par04        // Fornecedor Final                          	      �
	//� mv_par05        // Produto Inicial                              	  �
	//� mv_par06        // Produto Final                         		      �
	//� mv_par07        // Data Inicial                              	      �
	//� mv_par08        // Data Final                                   	  �
	//� mv_par09        // Situacao   (Todos / Em aberto)                     �
	//� mv_par10        // Tipo   (De Terceiros / Em Terceiros / Ambos)		  �
	//� mv_par11        // Custo em Qual Moeda  (1/2/3/4/5)             	  �
	//� mv_par12        // Lista NF Devolucao  (Sim) (Nao)              	  �
	//� mv_par13        // Devolucao data de                            	  �
	//� mv_par14        // Devolucao data ate                           	  �
	//� mv_par15        // QTDE. na 2a. U.M.? Sim / Nao                       �
	//� mv_par16        // Lista Custo? Medio / Fifo                          �
	//�������������������������������������������������������������������������

	//�������������������������������������������������������������������������
	// novos parametros em 2012-03-15 - Marllon                               �
	//� mv_par17        // Grupo Produto de                                   �
	//� mv_par18        // Grupo Produto Ate                                  �
	//�������������������������������������������������������������������������
	
	//��������������������������������������������������������������Ŀ
	//� Define variaveis p/ filtrar arquivo.                         �
	//����������������������������������������������������������������
	cCondCli := "B6_CLIFOR   <= mv_par02 .And. B6_CLIFOR  >= mv_par01 .And."+;
				" B6_PRODUTO <= mv_par06 .And. B6_PRODUTO >= mv_par05 .And."+;
				" B6_DTDIGIT <= mv_par08 .And. B6_DTDIGIT >= mv_par07 .And."+;
				" B6_QUANT   <> 0 "
				
	cCondFor := "B6_CLIFOR   <= mv_par04 .And. B6_CLIFOR  >= mv_par03 .And."+;
				" B6_PRODUTO <= mv_par06 .And. B6_PRODUTO >= mv_par05 .And."+;
				" B6_DTDIGIT <= mv_par08 .And. B6_DTDIGIT >= mv_par07 .And."+;
				" B6_QUANT   <> 0 "
				
	//��������������������������������������������������������������Ŀ
	//� Envia controle para a funcao SetPrint                        �
	//����������������������������������������������������������������
	wnrel := "Jmhr480"
	
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho)
	
	If nLastKey == 27
		Return .T.
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return .T.
	Endif
	
	RptStatus({|lEnd| R480Imp(@lEnd,wnRel,cString,Tamanho)},titulo)
	
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R480IMP  � Autor � Rodrigo de A. Sartorio� Data � 16.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Jmhr480			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R480Imp(lEnd,WnRel,cString,Tamanho)

	nTipo:=IIF(aReturn[4]==1,15,18)
	
	nOrdem := aReturn[8]
	
	lListCustM := (mv_par16==1)
	
	dbSelectArea("SB6")
	
	R480Prod(lEnd,Tamanho)
	
	dbSelectArea("SB6")
	Set Filter To
	dbSetOrder(1)
	
	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		ourspool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return .t.
	
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R480Prod � Autor � Waldemiro L. Lustosa  � Data � 12/04/94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime Por Ordem de Produto / LOCAL.                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Jmhr480                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R480Prod(lEnd,Tamanho)

	LOCAL cCliFor, cProdLOCAL := ""
	LOCAL cQuebra,aSaldo:={}
	LOCAL nCusTot := nQuant := nQuJe := nTotal := nTotDev := nTotQuant := nTotQuJe := nTotSaldo := 0
	LOCAL nGerTot := nGerTotDev:=nGerCusTot:=0
	LOCAL nIncCol := If(cPaisLoc == "MEX",7,0)
	LOCAL nSaldo  := 0
	Local nCusto  := 0
	Local nPrUnit := 0
	LOCAL cSeek   := ""
	LOCAL aAreaSB6:= {}
	
	Local cAnoMesDia := SubStr(dtos(date()),3,2) + SubStr(dtos(date()),5,2) + SubStr(dtos(date()),7,2)
	Local cHoraMinu  := SubStr(time(),1,2) + SubStr(time(),4,2)
	Local cPasta     //:= iif   (Right(Trim(GetMV("JM_PASTATX") ), 1 ) <> "\", Trim(GetMV("JM_PASTATX") ) + "\", Trim(GetMV("JM_PASTATX")) )  // Define a pasta onde sera gravado o arquivo texto
	Local cArquivo   := MV_PAR17  //Trim  (cPasta) + "Jmhr480_" + cAnoMesDia + "_" + cHoraMinu + ".csv"
	Local cTexto     := ""
	local cTextoaux  := ''
	local larquivo   := .F. // CRISTIANO OLIVEIRA - Nao escrever em arquivo texto .CSV
	Local nHdl

	//��������������������������������������������������������������������������������Ŀ
	//� Cria arquivo Texto                                                             �
	//����������������������������������������������������������������������������������
	If larquivo
		If ! Empty(cArquivo)
			nHdl := fCreate( cArquivo )
			If FERROR() != 0
				Aviso( "Aten��o!","Erro ao criar o arquivo " + cArquivo +". C�digo do erro: "+Str(FERROR()), { "OK" } )
				larquivo := .f.
			else
				larquivo := .t.
			Endif	
		Else
			larquivo := .f.
		EndIf      
	EndIf
			
	//��������������������������������������������������������������Ŀ
	//� Monta o Cabecalho de acordo com o tipo de emissao            �
	//����������������������������������������������������������������
	If mv_par10 == 1
		titulo := STR0010		//"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - PRODUTO / LOCAL"
	ElseIf mv_par10 == 2
		titulo := STR0011		//"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - PRODUTO / LOCAL"
	Else
		titulo := STR0012		//"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - PRODUTO / LOCAL"
	EndIf
	                        
//         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//            Cliente /        Loja  -  Documento  - Data de  Unid.de -------------------- Quantidade --------- -------------------- ------------------------------ ------------------------------ -------------			
//            Fornecedor              Numero  Serie  Emissao   Medida             Original                Saldo Lote                 Paciente                       M�dico                         Data Cirurgia
	
	cabec1 := '            Cliente /        Loja  -  Documento  - Data de  Unid.de -------------------- Quantidade --------- -------------------- ------------------------------ ------------------------------ -------------'
	cabec2 := '            Fornecedor              Numero  Serie  Emissao   Medida             Original                Saldo Lote                 Paciente                       M�dico                         Data Cirurgia'
	
	dbSelectArea("SB6")
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par05,.T.)
	
	SetRegua(LastRec())
	
	While !Eof() .And. B6_FILIAL == xFilial()
		
		IncRegua()
		
		If lEnd
			@Prow()+1,001 PSay STR0016		//"CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		If !Empty(aReturn[7])
			If !&(aReturn[7])
				dbSkip()
				Loop
			EndIf
		EndIf	
	
		dbSelectArea("SF4")
		dbSeek(cFilial+SB6->B6_TES)
		If SF4->F4_PODER3 == "D"
			dbselectArea("SB6")
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("SB6")
		
		IF	IIf(B6_TPCF == "C" , &cCondCli , &cCondFor )
			aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par07,mv_par08)
			dbSelectArea("SB6")
			nSaldo  := aSaldo[1]
			nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])
		Else
			dbSkip()
			Loop
		Endif
		
		If mv_par09 == 2 .And. nSaldo <= 0
			dbSkip()
			Loop
		EndIf
		If mv_par10 == 1 .And. B6_TIPO != "D"
			dbSkip()
			Loop
		ElseIf mv_par10 == 2 .And. B6_TIPO != "E"
			dbSkip()
			Loop
		EndIf
		
		nCusTot:=0
		nQuant :=0
		nQuJe  :=0
		nTotal :=0
		nTotDev:=0
		nSaldo :=0
		aSaldo :={}
		nCusto :=0
		cQuebra:= B6_PRODUTO+B6_LOCAL
		
		While !Eof() .And. xFilial() == B6_FILIAL .And. cQuebra == B6_PRODUTO+B6_LOCAL
			
			IncRegua()
			
			SB1->( dbSeek(cFilial+SB6->B6_PRODUTO) )
			If SB1->B1_GRUPO < MV_PAR18 .or. SB1->B1_GRUPO > MV_PAR19
				dbSkip()
				Loop
			EndIf			
	
			If li > 55
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
			EndIf
			
			If !Empty(aReturn[7])
				If !&(aReturn[7])
					dbSkip()
					Loop
				EndIf
			EndIf	
	
			dbSelectArea("SF4")
			dbSeek(cFilial+SB6->B6_TES)
			If SF4->F4_PODER3 == "D"
				dbselectArea("SB6")
				dbSkip()
				loop
			Endif
			
			dbSelectArea("SB6")
			
			IF	IIf(B6_TPCF == "C" , &cCondCli , &cCondFor )
				aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par07,mv_par08)
				dbSelectArea("SB6")
				nSaldo  := aSaldo[1]
				nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])
				If mv_par09 == 2 .And. nSaldo <= 0
					dbSkip()
					Loop
				EndIf
				If mv_par10 == 1 .And. B6_TIPO != "D"
					dbSkip()
					Loop
				ElseIf mv_par10 == 2 .And. B6_TIPO != "E"
					dbSkip()
					Loop
				EndIf
				
				cTexto := ''
				
				If cProdLOCAL != B6_PRODUTO+B6_LOCAL
					dbSelectArea("SB1")
					If dbSeek(cFilial+SB6->B6_PRODUTO)
						If !Empty(cProdLOCAL)
							li += 2
						EndIf
						If li > 55
							Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
						EndIf
						@ li,000 PSay STR0017+B1_COD+" - "+Trim(Substr(B1_DESC,1,30))+" / "+SB6->B6_LOCAL		//"PRODUTO / LOCAL: "
						cTexto += STR0017;
						       + ' ; ';
						       + "'"+B1_COD;
						       + ' ; ';
						       + B1_DESC;
						       + ' ; ';
						       + SB6->B6_LOCAL;
						       + ' ; '
						       
						cTextoaux := cTexto
						       
						cProdLOCAL := SB6->B6_PRODUTO+SB6->B6_LOCAL
					Else
						Help(" ",1,"R480PRODUT")
						dbSelectArea("SB6")
						dbSetOrder(1)
						Return .F.
					EndIf
				EndIf
				dbSelectArea("SB6")
				
				If li > 55
					Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
				EndIf
				
				If !Empty(cProdLocal)
					
					li++
					@ li,000 PSay IIf(B6_TPCF == "C",STR0018,STR0019)		//"Clie:"###"Forn:"
					@ li,008 PSay (Substr(B6_CLIFOR,1,15))
					@ li,025 PSay B6_LOJA
					@ li,030 PSay B6_DOC
					@ li,045+nIncCol PSay B6_SERIE
					@ li,050+nIncCol PSay Dtoc(B6_EMISSAO)
					@ li,062+nIncCol PSay If(mv_par15==1,B6_SEGUM,B6_UM)
					          
					if  cTexto == ''
					    cTexto := cTextoaux
					endif
					
					cTexto += IIf(B6_TPCF == "C",STR0018,STR0019);
					       + ' ; ';
					       + B6_CLIFOR;
					       + ' ; ';
					       + B6_LOJA;
					       + ' ; ';
					       + B6_DOC;
					       + ' ; ';
					       + B6_SERIE;
					       + ' ; ';
					       + Dtoc(B6_EMISSAO);
					       + ' ; ' ;
					       + If(mv_par15==1,B6_SEGUM,B6_UM);
					       + ' ; '
					
					// Quantidade Original
				    @ li,071+nIncCol PSay If(mv_par15==1,ConvUM(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT) Picture PesqPict("SB6","B6_QUANT",17)
					nQuant += If(mv_par15==1,ConvUM(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT)
					nQuJe  += If(mv_par15==1,ConvUM(B6_PRODUTO,(B6_QUANT - nSaldo),0,2),(B6_QUANT - nSaldo))
					
					cTexto += 'Qt Ori ; ';
					       + If(mv_par15==1,cValtoChar(ConvUM(B6_PRODUTO,B6_QUANT,0,2)),cValtoChar(B6_QUANT))
					
					// Saldo
					@ li,092+nIncCol PSay If(mv_par15==1,ConvUm(B6_PRODUTO,nSaldo,0,2),nSaldo) Picture PesqPict("SB6", "B6_QUANT",17)
					
					cTexto += ' ; Qt Saldo ; ';
					       + If(mv_par15==1,cValtoChar(ConvUm(B6_PRODUTO,nSaldo,0,2)),cValtoChar(nSaldo));
					       + ' ; '
                                
					cQuery := " SELECT * "
					cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
					cQuery += " WHERE D2_FILIAL  = '" + cFilial         + "' "
					cQuery += "   AND D2_DOC     = '" + SB6->B6_DOC     + "' "
					cQuery += "   AND D2_SERIE   = '" + SB6->B6_SERIE   + "' "
					cQuery += "   AND D2_CLIENTE = '" + SB6->B6_CLIFOR  + "' "
					cQuery += "   AND D2_LOJA    = '" + SB6->B6_LOJA    + "' "
					cQuery += "   AND D2_COD     = '" + SB6->B6_PRODUTO + "' "
					cQuery += "   AND D2_IDENTB6 = '" + SB6->B6_IDENT   + "' "
					cQuery += "   AND D_E_L_E_T_ = ' ' "

					//�����������������
					//� Executa query.�
					//�����������������
					cQuery := ChangeQuery( cQuery )
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"ITEMNF")
					DbGoTop()
					While !Eof()
						@ li,111+nIncCol PSay substr(ITEMNF->D2_LOTECTL,1,20)
						
						cTexto += ITEMNF->D2_LOTECTL;
						       + ' ; ';
						
						dbselectArea('SC5')
						dbSetOrder(1)
						if  dbSeek(xFilial('SC5')+ITEMNF->D2_PEDIDO)
							@ li,132+nIncCol PSay substr(SC5->C5_PACIENT,1,30)
							@ li,163+nIncCol PSay substr(SC5->C5_CRMNOM,1,30)
							@ li,194+nIncCol PSay dtoc(SC5->C5_DTCIRUG)
							
							cTexto += SC5->C5_PACIENT;
							       + ' ; ';
							       + SC5->C5_CRMNOM;
							       + ' ; ';
							       + dtoc(SC5->C5_DTCIRUG);
							       + ' ; '
						else 
						 	cTexto += ' ; ; ; '
						endif
						
						exit       
						DbSelectArea("ITEMNF")
						DbSkip()
//						if  !eof()
//						    li ++
//						endif
					enddo
					DbSelectArea("ITEMNF")
					DbCloseArea()

					dbSelectArea("SB6")
				    
				    /*            
				 	if larquivo 
				 		fWrite( nHdl , cTexto + CRLF)
				 	endif     
				 	*/
				 	
					cTexto := ''
						
					// Lista as devolucoes da remessa
					If mv_par12 == 1 .And. ((B6_QUANT - nSaldo) > 0)
						aAreaSB6 := SB6->(GetArea())
						dbSetOrder(3)
						cSeek:=xFilial()+B6_IDENT+B6_PRODUTO+"D"
						If dbSeek(cSeek)
							li++
							@ li,000 PSay STR0041	//"Notas Fiscais de Retorno"
							cTexto += STR0041;
							       + ' ; '
							Do While !Eof() .And. B6_FILIAL+B6_IDENT+B6_PRODUTO+B6_PODER3 == cSeek
								If SB6->B6_DTDIGIT < mv_par13 .Or. SB6->B6_DTDIGIT > mv_par14
									DbSelectArea("SB6")
									DbSkip()
									Loop
								Endif
								If li > 55
									Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
								EndIf									
								li++
								@ li,000 PSay IIf(B6_TPCF == "C",STR0018,STR0019)		//"Clie:"###"Forn:"
								@ li,008 PSay (Substr(B6_CLIFOR,1,15))
								@ li,025 PSay B6_LOJA
								@ li,030 PSay B6_DOC
								@ li,045+nIncCol PSay B6_SERIE
								@ li,050+nIncCol PSay Dtoc(B6_EMISSAO)
								@ li,062+nIncCol PSay If(mv_par15==1,B6_SEGUM,B6_UM)
								
								cTexto += IIf(B6_TPCF == "C",STR0018,STR0019);
								       + ' ; ';
								       + B6_CLIFOR;
								       + ' ; ';
								       + B6_LOJA;
								       + ' ; ';
								       + B6_DOC;
								       + ' ; ';
								       + B6_SERIE;
								       + ' ; ';
								       + Dtoc(B6_EMISSAO);
								       + If(mv_par15==1,B6_SEGUM,B6_UM);
								       + ' ; '
								
								// Quantidade Original
								@ li,071+nIncCol PSay If(mv_par15==1,ConvUm(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT) Picture PesqPict("SB6", "B6_QUANT",17)
								
								cTexto += 'Qt Ori ; ';
								       + If(mv_par15==1,cValtoChar(ConvUm(B6_PRODUTO,B6_QUANT,0,2)),cValtoChar(B6_QUANT));
								       + ' ; ; ; '
								
								cQuery := " SELECT * "
								cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
								cQuery += " WHERE D2_FILIAL  = '" + cFilial         + "' "
								cQuery += "   AND D2_DOC     = '" + SB6->B6_DOC     + "' "
								cQuery += "   AND D2_SERIE   = '" + SB6->B6_SERIE   + "' "
								cQuery += "   AND D2_CLIENTE = '" + SB6->B6_CLIFOR  + "' "
								cQuery += "   AND D2_LOJA    = '" + SB6->B6_LOJA    + "' "
								cQuery += "   AND D2_COD     = '" + SB6->B6_PRODUTO + "' "
								cQuery += "   AND D_E_L_E_T_ = ' ' "
			
								//�����������������
								//� Executa query.�
								//�����������������
								cQuery := ChangeQuery( cQuery )
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"ITEMNF")
								DbGoTop()
								While !Eof() 
									@ li,111 PSay substr(ITEMNF->D2_LOTECTL,1,20)
									cTexto += ITEMNF->D2_LOTECTL;
									       + ' ; '
									
									dbselectArea('SC5')
									dbSetOrder(1)
									if  dbSeek(xFilial('SC5')+ITEMNF->D2_PEDIDO)
										@ li,132+nIncCol PSay substr(SC5->C5_PACIENT,1,30)
										@ li,163+nIncCol PSay substr(SC5->C5_CRMNOM,1,30)
										@ li,194+nIncCol PSay dtoc(SC5->C5_DTCIRUG)
										
										cTexto += SC5->C5_PACIENT;
											   + ' ; ' ;
											   + SC5->C5_CRMNOM;
											   + ' ; ';
											   + dtoc(SC5->C5_DTCIRUG);
											   + ' ; '
									else
										cTexto += ';;;'
									endif
									           
									/*									            
									if larquivo
										fWrite( nHdl , cTexto + CRLF)
									endif
									*/
									
									cTexto := ''
									
									exit
									//DbSelectArea("ITEMNF")
									//DbSkip()
								enddo
								DbSelectArea("ITEMNF")
								DbCloseArea()
			
								dbSelectArea("SB6")
											
								dbSkip()
							EndDo
							li++
							
						EndIf
						RestArea(aAreaSB6)
						dbSetOrder(1)
					EndIf
				EndIf
			EndIf
			
			dbSelectArea("SB6")
			dbSkip()
		EndDo
		If nQuant > 0
			li++
			@ li,000 PSay STR0020		//"TOTAL DESTE PRODUTO / LOCAL ------ >"
			@ li,071+nIncCol PSay nQuant        		Picture PesqPict("SB6", "B6_QUANT",17)
			@ li,092+nIncCol PSay (nQuant - nQuJe)  	Picture PesqPict("SB6", "B6_QUANT",17)
		    nTotQuant += nQuant
	    	nTotSaldo += (nQuant - nQuJe)
		Endif
	End
	
	If nQuant > 0 .Or. nTotal > 0
		li++;li++
		@ li,000 PSay STR0021			//"T O T A L    G E R A L  ---------- >"
	    @ li,071+nIncCol PSay nTotQuant Picture PesqPict("SB6","B6_QUANT",17)
	    @ li,092+nIncCol PSay nTotSaldo Picture PesqPict("SB6","B6_QUANT",17)
		Roda(CbCont,CbTxt,Tamanho)
	EndIf
	
	// FECHA TEXTO
	/*
	if larquivo
		fClose(nHdl)
	endif
	*/
		
Return .T.
	
