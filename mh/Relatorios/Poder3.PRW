#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Poder3       Autor�  Eliane Carvalho     Data �  15/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado para verificar quantidade do produto em poder���
���          � de terceiro                                                ���
�������������������������������������������������������������������������͹��
���                                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Poder3()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relacao de Materiais Nosso em Poder Terceiro"
Local cPict          := ""
Local titulo         := "Relacao de Materiais Nosso em Poder Terceiro"
Local nLin           := 80
Local Cabec1         := "Produto         Arm.  Grupo  Descricao                                                  Quantidade  Saldo        Custo Medio "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "JMHPD3" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PODER3" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SB6"

dbSelectArea("SB6")
dbSetOrder(1)

cPerg := PadR("PODER3",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

If ! SX1->( dbseek(cPerg) )
	PutSx1( cPerg,"01","Emissao ?            ", "","","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"02","Ate Emissao ?        ", "","","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"03","Armazem ?            ", "","","mv_ch3","C",02,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"04","Ate Armazem ?        ", "","","mv_ch4","C",02,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"05","Cliente ?            ", "","","mv_ch5","C",06,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"06","Ate Cliente ?        ", "","","mv_ch6","C",06,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"07","Loja ?               ", "","","mv_ch7","C",02,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"08","Ate Loja ?           ", "","","mv_ch8","C",02,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"09","Um por Pagina ?      ", "","","mv_ch9","N",01,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","","","",,,)
EndIf

Pergunte(cPerg,.f.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  15/07/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery,cQuery1
Local cCLIFOR, cNome
LOCAL nTCLIFOR,nTSALDO
dbSelectArea(cString)
dbSetOrder(1)

cQuery :="SELECT SB6.B6_CLIFOR CLIFOR, SB6.B6_LOJA LOJA, SB6.B6_TPCF TPCF, SB6.B6_PRODUTO PRODUTO, SB6.B6_LOCAL ARM,  SB1.B1_GRUPO GRUPO,  SB1.B1_DESC  DESCRICAO,SB1.B1_UM  Unidade, SUM(SB6.B6_SALDO) SALDO,SUM(SB6.B6_QUANT) QUANT, SUM(SB6.B6_CUSTO1) CUSTO "
cQuery +="FROM SB6010 SB6, SB1010 SB1 WHERE  AND SB6.B6_PRODUTO = SB1.B1_COD "
cQuery +="AND SB6.B6_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
cQuery +="AND SB6.B6_LOCAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQuery +="AND SB6.B6_CLIFOR BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQuery +="AND SB6.B6_LOJA BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
cQuery +="AND SB6.B6_SALDO > 0 "
cQuery +="AND SB6.B6_TIPO='E' "
cQuery +="AND SB6.B6_TPCF='C' "
cQuery +="AND SB6.B6_PODER3='R' "
cQuery +="AND SB6.D_E_L_E_T_ <> '*' "
cQuery +="AND SB1.D_E_L_E_T_ <> '*' "
cQuery +="GROUP BY B6_CLIFOR, B6_LOJA,B6_TPCF, B6_PRODUTO, B6_LOCAL,  B1_GRUPO, B1_DESC "
cQuery +="ORDER BY B6_CLIFOR, B6_LOJA, B6_PRODUTO "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.T.,.T.)



//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

dbGoTop()       // TRB

nTGERAL:=0
nTCLIFOR:=0 
nTSALDO:=0
While !EOF()
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	IF MV_PAR09 = 1         // UM CLIENTE POR PAGINA
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	ENDIF
	
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	cCLIFOR:= TRB->CLIFOR + TRB->LOJA
	If TRB->TPCF=="C"
		dbSelectArea("SA1")
		dbSeek(xFilial()+TRB->CLIFOR + TRB->LOJA)
		cNome := SA1->A1_NOME
	ELSE
		dbSelectArea("SA2")
		dbSeek(xFilial()+TRB->CLIFOR + TRB->LOJA)
		cNome := SA2->A2_NOME
	ENDIF
	
	dbSelectArea("TRB")
	If TRB->TPCF=="C"
		@nLin,000 PSAY "Cliente - Loja "
	else
		@nLin,000 PSAY "Fornecedor - Loja "
	endif
	@nLin,pcol() PSAY cCLIFOR +" "+cNome
	nLin := nLin + 2
	nTCLIFOR:=0
	nTSALDO:=0
	While !EOF().AND. TRB->CLIFOR + TRB->LOJA==cCLIFOR
		//���������������������������������������������������������������������Ŀ
		//� Verifica o cancelamento pelo usuario...                             �
		//�����������������������������������������������������������������������
		
		If lAbortPrint
			
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//���������������������������������������������������������������������Ŀ
		//� Impressao do cabecalho do relatorio. . .                            �
		//�����������������������������������������������������������������������
		
		If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
		
		@nLin,000 PSAY TRB->PRODUTO
		@nLin,017 PSAY TRB->ARM
		@nLin,022 PSAY TRB->GRUPO
		@nLin,029 PSAY SUBSTR(TRB->DESCRICAO,1,55) 
		@nLin,088 PSAY TRB->QUANT  Picture "@E 9999.99"
		VCUSTO:=(CUSTO/QUANT)
		@nLin,0103 PSAY TRB->SALDO  Picture "@E 9999.99"
		VALOR:=SALDO*VCUSTO
		//@nLin,103 PSAY TRB->CUSTO  Picture "@E 9,999,999.99"
	    @nLin,115 PSAY VALOR  Picture "@E 9,999,999.99"
		
		nLin := nLin + 1 // Avanca a linha de impressao 
		nTSALDO:= nTSALDO + TRB->SALDO
		nTCLIFOR:=nTCLIFOR +TRB->CUSTO
		dbSkip()    // Avanca o ponteiro do registro no arquivo
		
	ENDDO
	nLin := nLin + 3  
	@nLin,70 PSAY " TOTAIS "
	//@nLin,70 PSAY " TOTAL  ------> R$ "  
	@nLin,088 PSAY nTSALDO   Picture "@E 999999"
	@nLin,103 PSAY nTCLIFOR  Picture "@E 999,999,999.99"
	nLin := nLin + 1
	nTGERAL:=nTGERAL +nTCLIFOR
	dbSkip()    // Avanca o ponteiro do registro no arquivo       PRIMEIRO LACO
EndDo
IF MV_PAR09 = 2
	nLin := nLin + 3
	@nLin,70 PSAY " TOTAL GERAL  ------> R$ "
	@nLin,103 PSAY nTGERAL  Picture "@E 999,999,999.99"
	nLin := nLin + 1
Endif
//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

dbSelectArea('TRB')
dbCloseArea()

Return
