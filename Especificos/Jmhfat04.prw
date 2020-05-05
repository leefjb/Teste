#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO5     � Autor � AP5 IDE            � Data �  29/04/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP5 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 IDE                                                    ���
�������������������������������������������������������������������������͹��
���Manutencao� Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function JMHFAT04()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := "Posicao do Faturamento por Convenio"
Local cPict   := ""
Local titulo  := "Faturamento Convenio"
Local nLin    := 80
//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                               1         2         3         4         5         6         7         8
//                         	 999999    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    999.999.999,99
Local Cabec1  := "      	Convenio   Nome                                        Total Convenio"
Local Cabec2  := ""
Local imprime := .T.

Private cString     := "SD2"
Private CbTxt       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "JMHFAT04" 
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := PadR("FFAT04",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
Private m_pag := 01
Private wnrel := "JMHFAT04" 

ValidPerg()

pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

titulo += " de "+DTOC(MV_PAR01) + " at� " + DTOC(MV_PAR02) 

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
���Fun��o    �RUNREPORT � Autor � AP5 IDE            � Data �  29/04/02   ���
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

DbSelectArea("SX5"); DbSetOrder(1) 
DbSelectArea("SC5"); DbSetOrder(1)   
DbSelectArea("SC6"); DbSetOrder(1)
DbSelectArea("SF2"); DbSetOrder(1)
dbSelectArea("SD2"); DbSetOrder(5)

//Local

cEst     := Space(2)
cVend1   := Space(6)
cConvz   := Space(2)
cNomeConv:= Space(40)
nn       := 0
nTotal   := 0
aConvx   := {} 
aConvy   := {}

dbSelectArea(cString)     
SetRegua(RecCount())
dbSeek(xFilial("SD2")+DTOS(MV_PAR01),.T.)
Do While !EOF() .And. SD2->D2_EMISSAO <= MV_PAR02

   If SD2->D2_SERIE # "UNI"
	  DbSkip()
	  Loop
   EndIf
   
   SC6->( DbSeek(xFilial("SC6")+ SD2->D2_Pedido + SD2->d2_ItemPv ) )
		
   If SC6->C6_IMPNF <> "1"
  	  DbSkip()
	  Loop
   EndIf
  
   SF2->( DbSeek(xfilial("SF2")+ SD2->D2_Doc + SD2->D2_Serie) )
   
   If SF2->F2_EST == Space(2)
      DbSkip()
   	  Loop
   EndIf

   If MV_PAR04 # Space(2) .And. MV_PAR04 # SF2->F2_EST  // UF
      DbSkip()
   	  Loop
   EndIf
   cEst := SF2->F2_EST 
   
   SC5->( DbSeek(XFILIAL("SC5") + SD2->D2_Pedido) )     
   
   If SC5->C5_Vend1 == Space(6) .Or. SC5->C5_CONVENI == Space(2)  
      DbSkip()
      Loop              
   EndIf  	  
       
   If MV_PAR05 # Space(6) .And. MV_PAR05 # SC5->C5_Vend1 // Vendedor
   	  DbSkip()
   	  Loop  
   EndIf
   cVend1 := SC5->C5_Vend1
   
   If MV_PAR03 # Space(2) .And. MV_PAR03 # SC5->C5_CONVENI   // Convenio
      DbSkip()
      Loop              
   EndIf   
   cConvz := SC5->C5_CONVENI                                
   
   SX5->( DbSeek(XFILIAL("SX5") + "Z1"+cConvz) )     
   cNomeConv := AllTrim(SX5->X5_DESCRI)
   
   nn := Ascan(aConvx,cConvz)
		
   If nn == 0                   
   	  aAdd(aConvx,cConvz)
   	  aAdd(aConvy , { cConvz, cNomeConv , SD2->D2_TOTAL } )
   Else
      aConvy[nn,3] += SD2->D2_TOTAL
   EndIf			

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo                                           

aSort(aConvy,,,{|x,y| x[3] > y[3]} )
   
nTotal := 0

If Len(aConvy) > 0

   For nn := 1 To Len(aConvy)
   
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

	   @ nLin, 06 PSAY aConvy[nn,1]
	   @ nLin, 16 PSAY aConvy[nn,2]
	   @ nLin, 60 PSAY aConvy[nn,3] Picture "@E 999,999,999.99"
	   nTotal += aConvy[nn,3]
	   nLin += 1 // Avanca a linha de impressao

   Next
Else
   Alert(Substr(cUsuario,7,13) + ", Nao Foi Selecionado Nenhuma Nota, Verifique Parametros!")
   Return 
EndIf   

nLin += 1 // Avanca a linha de impressao

@ nLin, 16 PSAY "Total Geral .: " 
@ nLin, 60 PSAY nTotal Picture "@E 999,999,999.99"

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

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  29/04/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

//          Grupo/Ordem/Pergunta/                    Variavel/Tipo/Tam/Dec/Pres/GSC/Valid/                          Var01/     Def01/   Cnt01/Var02/Def02/    Cnt02/Var03/Def03/     Cnt03/Var04/Def04/     Cnt04/Var05/Def05/     Cnt05/F3
aAdd(aRegs,{cPerg,"01","Data Inicio .:","","",       "mv_ch1","D",  8,  0, 0,  "G", "",                             "MV_PAR01", "","","", "",   "",   "","","", "",   "",   "","","",  "",   "",   "","","",  "",   "",   "","","",  "",  ""})
aAdd(aRegs,{cPerg,"02","Data Fim .:","","",          "mv_ch2","D",  8,  0, 0,  "G", "",                             "MV_PAR02", "","","", "",   "",   "","","", "",   "",   "","","",  "",   "",   "","","",  "",   "",   "","","",  "",  ""})
aAdd(aRegs,{cPerg,"03","Informe o Convenio .:","","","mv_ch3","C",  2,  0, 0,  "G", "IF(!EMPTY(MV_PAR03), ExistCpo('SX5','Z1'+MV_PAR03),.T.)","MV_PAR03", "","","", "",   "",   "","","", "",   "",   "","","",  "",   "",   "","","",  "",   "",   "","","",  "",  "Z1"})
aAdd(aRegs,{cPerg,"04","Estado .:","","",            "mv_ch4","C",  2,  0, 0,  "G", "",                             "MV_PAR04", "","","", "",   "",   "","","", "",   "",   "","","",  "",   "",   "","","",  "",   "",   "","","",  "",  ""})
aAdd(aRegs,{cPerg,"05","Vendedor .:","","",          "mv_ch5","C",  6,  0, 0,  "G", "",                             "MV_PAR05", "","","", "",   "",   "","","", "",   "",   "","","",  "",   "",   "","","",  "",   "",   "","","",  "",  "SA3"})

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
