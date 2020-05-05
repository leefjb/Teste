#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � JMHR010  � Autor � AP6 IDE            � Data �  03/01/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Relacao de faturamento por representante e linha de pro-   ���
���          � duto                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function JMHR010()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Faturamento Repres/Linha"
Local cPict          := ""
Local titulo       := "Fat. Vend/Linha "
Local nLin         := 80
Local cPerg        := 'JMR010'
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "JMHR010" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "JMHR010" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SF2"

dbSelectArea("SF2")
dbSetOrder(1)

// ValidPerg(cPerg)
Pergunte(cPerg, .f.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  03/01/06   ���
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
Local nTotReg    := 0
Local nOrdem
Local nTotVend   := 0
Local nTotal     := 0 


// Recupera os dados da base
cQuery := " SELECT F2_VEND1, D2_GRUPO, sum(D2_TOTAL) TOTAL "
cQuery += " FROM " + RetSqlName("SF2") + " SF2, " + RetSqlName("SD2") + " SD2, " + RetSqlName("SF4") + " SF4 "
cQuery += " WHERE F2_FILIAL = '" + xFilial("SF2") + "' "
cQuery += "   AND D2_FILIAL = '" + xFilial("SD2") + "' "
cQuery += "   AND F2_CLIENTE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery += "   AND F2_VEND1   BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += "   AND F2_EMISSAO BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQuery += "   AND SF2.F2_SERIE = SD2.D2_SERIE "
cQuery += "   AND SF2.F2_DOC = SD2.D2_DOC "
cQuery += "   AND SF4.F4_CODIGO = SD2.D2_TES "
cQuery += "   AND SF4.F4_DUPLIC = 'S' "
cQuery += "   AND SF2.D_E_L_E_T_ = ' ' "
cQuery += "   AND SD2.D_E_L_E_T_ = ' ' "
cQuery += "   AND SF4.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY F2_VEND1, D2_GRUPO
cQuery += " ORDER BY F2_VEND1, D2_GRUPO

cQuery := ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

TCSetField('TRB', "TOTAL", "N", 14, 2)

dbSelectArea('TRB')

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
SetRegua(SF2->( RecCount() ))

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������
dbSelectArea('TRB')
dbGoTop()
nTotal := 0 
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
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8

		@ nLin,00 PSAY titulo + " de " + Dtoc(MV_PAR01) + " ate " + Dtoc(MV_PAR02)
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
	Endif
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSAY para saida na impressora. Por exemplo:

	SA3->( dbSeek(xFilial("SA3")+TRB->F2_VEND1) )
	
	@ nLin,00 PSAY TRB->F2_VEND1 + " - " + SA3->A3_NOME
	nLin := nLin + 1 // Avanca a linha de impressao

	cCodRep := TRB->F2_VEND1
	nTotVend   := 0
	
	While ! Eof() .and. cCodRep == TRB->F2_VEND1
		SBM->( dbSeek(xFilial("SBM")+TRB->D2_GRUPO) )
		
		@ nLin,05 PSAY TRB->D2_GRUPO + " - " + SBM->BM_DESC
		
		@ nLin,35 PSAY TRB->TOTAL PICTURE "@ER 999,999,999,999.99"
		nTotal   += TRB->TOTAL
		nTotVend += TRB->TOTAL

		nLin := nLin + 1 // Avanca a linha de impressao
		
		dbSkip()
	EndDo
	nLin := nLin + 1 // Avanca a linha de impressao
	@ nLin,35 PSAY nTotVend PICTURE "@ER 999,999,999,999.99"
	nTotVend := 0
	
	nLin := nLin + 1 // Avanca a linha de impressao
	nLin := nLin + 1 // Avanca a linha de impressao
	
	//dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

nLin := nLin + 1 // Avanca a linha de impressao
@ nLin,35 PSAY nTotal PICTURE "@ER 999,999,999,999.99"
nTotal := 0

dbSelectArea("TRB")
dbCloseArea()

//���������������������������������������������������������������������Ŀ    // 50299
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

Return



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  29/10/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg( cPerg )
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)


//          Grupo/Ordem/Pergunta/                   Variavel/Tipo/Tam/Dec/Pres/GSC/Valid/             Var01/     Def01______/Cnt01/  Var02 /Def02_____/Cnt02/ Var03/Def03___/Cnt03/ Var04/Def04___/Cnt04/ Var05/Def05___/Cnt05/ F3
aAdd(aRegs,{cPerg,"01","da Emissao?  ",    "","",    "mv_ch1","D",  8,  0, 0,  "G", "",               "MV_PAR01", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"02","ate a Emissao?   ","","",    "mv_ch2","D",  8,  0, 0,  "G", "",               "MV_PAR02", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    ""})
aAdd(aRegs,{cPerg,"03","do Cliente?     ", "","",    "mv_ch3","C",  6,  0, 0,  "G", "",               "MV_PAR03", "","","","",     "",   "","","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    "SA1"})
aAdd(aRegs,{cPerg,"04","ate o Cliente?   ","","",    "mv_ch4","C",  6,  0, 0,  "G", "",               "MV_PAR04", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    "SA1"})
aAdd(aRegs,{cPerg,"05","do Vendedor?     ","","",    "mv_ch5","C",  6,  0, 0,  "G", "",               "MV_PAR05", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    "SA3"})
aAdd(aRegs,{cPerg,"06","ate o Vendedor?  ","","",    "mv_ch6","C",  6,  0, 0,  "G", "",               "MV_PAR06", "",   "","","",     "",   "",   "","","",    "",   "","","","",    "",   "","","","",    "",   "","","","",    "SA3"})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
