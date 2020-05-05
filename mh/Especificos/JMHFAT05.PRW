
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO5     บ Autor ณ AP5 IDE            บ Data ณ  15/05/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP5 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5 IDE                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function JMHFAT05()
    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := "Posicao do Faturamento por Vendedor e Grupo de Produtos."
Local cPict   := ""
//                01234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                          1         2         3         4         5         6         7         8
//                  999999      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX      999.999.999,99
//                    9999      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                999.999.999,99
Local Cabec1  := "  VENDEDOR      NOME DO VENDEDOR                                    TOTAL VENDEDOR"
Local Cabec2  := "     GRUPO         DESCRICAO                                              TOTAL GRUPO"
Local titulo  := "Faturamento Vendedor X Grupo Produto"
Local nLin    := 80   
Local imprime := .T.

Private cString     := "SF2"
Private CbTxt       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "JMHFAT05" 
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := PadR("FFAT05",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
Private m_pag := 01
Private wnrel := "JMHFAT05" 

ValidPerg()

pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

titulo += " de "+DTOC(MV_PAR01) + " at้ " + DTOC(MV_PAR02) 

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP5 IDE            บ Data ณ  15/05/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

DbSelectArea("SF4"); DbSetOrder(1) 
DbSelectArea("SA3"); DbSetOrder(1) 
DbSelectArea("SBM"); DbSetOrder(1)   
DbSelectArea("SB1"); DbSetOrder(1)
dbSelectArea("SD2"); DbSetOrder(3)
DbSelectArea("SF2"); DbSetOrder(4)  // FILIAL + SERIE + EMISSAO

// Local
cEst     := Space(2)
cSerNF   := "UNI" 
cVend1   := Space(6)
cGrupo   := Space(4)
nn       := 0
nTotVend := 0
nTotVGru := 0
nTotGru  := 0
nTotGer  := 0
aVendeX  := {}  
aVendeY  := {} 
aVGrupoX := {} 
aVGrupoY := {}
aGrupoX  := {} 
aGrupoY  := {}

dbSelectArea(cString)     
SetRegua(RecCount())
dbSeek(xFilial("SF2")+cSerNF+DTOS(MV_PAR01),.T.)
Do While !EOF() .And. F2_SERIE == cSerNF .And. SF2->F2_EMISSAO <= MV_PAR02 

   IncRegua("Aguarde..., Selecionando Vendedores")
   
   If F2_TIPO # "N"
      dbSkip()
      Loop
   EndIf   
   
   nRecF2 := RecNo()
   
   nn := Ascan(aVendeX,SF2->F2_VEND1)
   
   If nn == 0                   
   	  aAdd(aVendeX,SF2->F2_VEND1)
   	  aAdd(aVendeY, { SF2->F2_VEND1, SF2->F2_VALFAT} )
   Else
      aVendeY[nn,2] += SF2->F2_VALFAT
   EndIf			
  
   dbSelectArea("SD2")
   DbSeek(xfilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA) 
   Do While SF2->F2_DOC + SF2->F2_SERIE == SD2->D2_DOC + SD2->D2_SERIE .And. !EOF()
      nRecD2 := RecNo()
      
      SF4->( DbSeek(xfilial("SF4") + SD2->D2_TES ))

      If SF4->F4_DUPLIC == "N"      
         dbSkip()
         Loop
      EndIf   
      
      SB1->( DbSeek(xfilial("SB1") + SD2->D2_COD ))
   
      nn := aScan(aVGrupoX,SF2->F2_VEND1+SB1->B1_GRUPO)
      nm := aScan(aGrupoX,SB1->B1_GRUPO )
		
      If nn == 0                   
   	     aAdd(aVGrupoX,SF2->F2_VEND1+SB1->B1_GRUPO)
   	     aAdd(aVGrupoY, { SF2->F2_VEND1+SB1->B1_GRUPO, SD2->D2_TOTAL } )
      Else
         aVGrupoY[nn,2] += SD2->D2_TOTAL
      EndIf			
    
      If nm == 0                   
   	     aAdd(aGrupoX, SB1->B1_GRUPO)
   	     aAdd(aGrupoY, { SB1->B1_GRUPO, SD2->D2_TOTAL } )
      Else
         aGrupoY[nm,2] += SD2->D2_TOTAL
      EndIf 
      dbSkip()
   EndDo
   			
   dbSelectArea("SF2")
   dbGoTo(nRecF2)
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo                                           

aSort(aVendeY,,,{|x,y| x[2] > y[2]} ) 
aSort(aVGrupoY,,,{|x,y| x[2] > y[2]} )
aSort(aGrupoY,,,{|x,y| x[2] > y[2]} ) 
   
nTotal := 0

If Len(aVendeY) > 0      

   SetRegua(Len(aVendeY))
   
   For nn := 1 To Len(aVendey)
    
       IncRegua("Aguarde..., Imprimindo Faturamento p/Vendedores")
   
       If lAbortPrint
          @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
          Exit
       Endif
       
        //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	   //ณ Impressao do cabecalho do relatorio. . .                            ณ
	   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	   If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 60 linhas... 
	
    	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 10
   
	   Endif  

	   @ nLin, 02 PSAY aVendeY[nn,1]  
	   
	   SA3->( DbSeek(xfilial("SA3") + aVendeY[nn,1] ))
	   
	   @ nLin, 14 PSAY SA3->A3_NOME
	   @ nLin, 66 PSAY aVendey[nn,2] Picture "@E 999,999,999.99"
	   
	   nLin += 1 // Avanca a linha de impressao
	   
	   For mm := 1 To Len(aVGrupoY)  
	   
	       If substr(aVGrupoY[mm,1],1,6) # aVendeY[nn,1]
	          Loop
	       EndIf
	   
	       If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 60 linhas... 
	
    	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	          nLin := 10
   
	       Endif  

	       @ nLin, 04 PSAY SubStr(aVGrupoY[mm,1],7,4)
	   
	       SBM->( DbSeek(xfilial("SBM") + SubStr(aVGrupoY[mm,1],7,4) ))
	   	   
	       @ nLin, 14 PSAY SBM->BM_DESC
	       @ nLin, 66 PSAY aVGrupoY[mm,2] Picture "@E 999,999,999.99"
	       
	       nLin += 1 // Avanca a linha de impressao
	       
	   Next
	   
	   nTotal += aVendey[nn,2]
	   nLin += 1 // Avanca a linha de impressao

   Next
Else
   Alert(Substr(cUsuario,7,13) + ", Nao Foi Selecionado Nenhum Vendedor, Verifique Parametros!")
   Return 
EndIf   

nLin += 1 // Avanca a linha de impressao

@ nLin, 16 PSAY "Total Geral .: " 
@ nLin, 66 PSAY nTotal Picture "@E 999,999,999.99"

nTotal := 0

Titulo := "Resumo por Grupo de Produtos"  

Cabec1  := "     GRUPO         DESCRICAO                                              TOTAL GRUPO"
Cabec2  := ""

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 10

For mm := 1 To Len(aGrupoY)  

    If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 60 linhas... 

       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin := 10
       
    Endif  

    @ nLin, 01 PSAY aGrupoY[mm,1]
   
    SBM->( DbSeek(xfilial("SBM") + aGrupoY[mm,1] ))
   	   
    @ nLin, 14 PSAY SBM->BM_DESC
    @ nLin, 66 PSAY aGrupoY[mm,2] Picture "@E 999,999,999.99"
       
    nLin += 1 // Avanca a linha de impressao

    nTotal += aGrupoY[mm,2]  
    
Next

nLin += 1 // Avanca a linha de impressao

@ nLin, 16 PSAY "Total Geral .: "  
@ nLin, 66 PSAY nTotal Picture "@E 999,999,999.99"


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  29/04/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

//          Grupo/Ordem/Pergunta/                Variavel/Tipo/Tam/Dec/Pres/GSC/Valid/  Var01/     Def01/   Cnt01/Var02/Def02/    Cnt02/Var03/Def03/     Cnt03/Var04/Def04/     Cnt04/Var05/Def05/     Cnt05/F3
aAdd(aRegs,{cPerg,"01","Data Inicial .:","","",       "mv_ch1","D",  8,  0, 0,  "G", "",     "MV_PAR01", "","","", "",   "",   "","","", "",   "",   "","","",  "",   "",   "","","",  "",   "",   "","","",  "",  ""})
aAdd(aRegs,{cPerg,"02","Data Final .:","","",          "mv_ch2","D",  8,  0, 0,  "G", "",     "MV_PAR02", "","","", "",   "",   "","","", "",   "",   "","","",  "",   "",   "","","",  "",   "",   "","","",  "",  ""})

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
