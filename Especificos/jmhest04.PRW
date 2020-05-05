#Include "protheus.ch"
#include "sigawin.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JMHEST04  ³ Autor ³ Reiner Trennepohl  ³ Data ³ 02.05.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de Controle de Etiquetas                        .³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ JMHEST04(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutencao³ Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JMHEST04()
LOCAL wnrel
LOCAL Tamanho:="M"
LOCAL cDesc1 := "Este programa ira emitir o Relatorio de Posicao"
LOCAL cDesc2 := "das Etiquetas. Caso o Tipo for selecionado Analitico,"
LOCAL cDesc3 := "sera impresso tambem, a Relacao de Etiquetas"
LOCAL cString :="SZ3"                                         
LOCAL nLin    := 80

PRIVATE cCondCli, cSituaca
PRIVATE aReturn := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
PRIVATE nomeprog :="JMHEST04"
PRIVATE aLinha := { },nLastKey := 0
PRIVATE cPerg := PadR("JEST04",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
PRIVATE Titulo := "Posicao Etiquetas - Estoque / Terceiros"
PRIVATE cabec1, cabec2, nTipo, CbTxt, CbCont

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza variaveis static p/ Grupo de Fornec/Clientes(001) e de Loja(002)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Private aTamSXG, aTamSXG2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt := SPACE(10)
CbCont:= 00
li	  := 80
m_pag := 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica conteudo da variavel p/ Grupo de Clientes/Forneced.(001) e Loja(002) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
//aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                  ³
//³ mv_par01   		// Cliente Inicial                		              ³
//³ mv_par02         // Cliente Final                       	          ³
//³ mv_par03         // Produto Inicial                              	  ³
//³ mv_par04         // Produto Final                         		      ³
//³ mv_par05         // Situacao   (Estoque   / Em Terceiros)             ³
//³ mv_par06         // Tipo       (Analitico / Sintetico)                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis p/ filtrar arquivo.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR05 == 1 // Estoque   
   cSituaca := "EST"
   cCondCli := "Z3_SITUACA == 'EST' .And. Z3_CODPROD >= mv_par03 .And. Z3_CODPROD <= mv_par04"
   nOrder   := 13 // FILIAL + SITUACAO + PRODUTO + ETIQUETA
Else   // Em Terceiros 
   cSituaca := "CON"
   cCondCli := "Z3_SITUACA == 'CON' .And. Z3_CLIENTE >= mv_par01 .And. Z3_CLIENTE <= mv_par02 .And."+;
               " Z3_CODPROD >= mv_par03 .And. Z3_CODPROD <= mv_par04"
   nOrder   := 12  // FILIAL + SITUACAO + CLIENTE + LOJA + PRODUTO + ETIQUETA
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SetPrint                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "JMHEST04"

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho)

If nLastKey == 27
	Return .T.
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return .T.
Endif

RptStatus({|lEnd| RJMH04Imp(@lEnd,wnRel,cString,Tamanho,nLin)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RJMH04Imp  ³ Autor ³ Reiner Trennepohl     ³ Data ³ 02.05.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST04			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RJMH04Imp(lEnd,WnRel,cString,Tamanho,nLin)
LOCAL limite := 220
nTipo:=IIF(aReturn[4]==1,15,18)

RJMH04Etq(lEnd,Tamanho,nLin)

dbSelectArea("SZ3")
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RJMH04Etq³ Autor ³ Reiner Trennepohl  ³ Data ³ 05.05.03    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Por Ordem de Cliente / Fornecedor.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST04                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RJMH04Etq(lEnd,Tamanho,nLin) 

dbSelectArea("SB1")
dbSetOrder(1)

aCli   := {}
aProdX := {}  
aProdY := {}
aEtq   := {}

titulo := "RELACAO DOS PRODUTOS X ETIQUETAS "+IIF(MV_PAR05 == 1,"EM ESTOQUE","EM TERCEIROS")

If MV_PAR06 == 1  // Analitico
   cabec1 := "- Cod Produto ---- Descrica Produto ---------------------------------------------- UnM --- Quantidade -- Prc. Standard --- Prc. Venda"
   cabec2 := "--- Etiqueta       N Fiscal    Data "
   //           XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     XX      99.999,99    99.999.999,99  99.999.999,99
   //             XXXXXX         XXXXXX     XX/XX/XX                                                                   
           //           1         2         3         4         5         6         7         8         9         C         1         2         3  
           // 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Else // Sintetico
   cabec1 := "- Codigo ---------- Produto ------------------------------------------------------ Unid -- Quantidade ------------- Valores ----------"
   cabec2 := "------------------- Descricao                                                     Medida                 Prc. Standard     Prc. Venda"
   //           XXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    XX      99.999,99    99.999.999,99  99.999.999,99
           //           1         2         3         4         5         6         7         8         9         C         1         2         3  
           // 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
EndIf           

dbSelectArea("SZ3")
dbSetOrder(nOrder) // FIIAL + SITUCAO + CLIENTE + LOJA + PRODUTO + CODETIQ (12)
                   // FIIAL + SITUCAO + PRODUTO + CODETIQ (13)
SetRegua(LastRec())
dbSeek(cFilial+cSituaca)
Do While !Eof()

   IncRegua()

   If lEnd
	  @Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
	  Exit
   Endif

   IF !&cCondCli 
       dbSkip()
   	   Loop
   Endif
                   
   If mv_par05 == 1   //  Estoque
      cCli     := "ESTOQUE"      
      cLoja    := "01"
      cNFiscal := SZ3->Z3_NFENTRA
      cSerNF   := SZ3->Z3_SERIENT
      dData    := SZ3->Z3_DATAENT 
   Else
      cCli     := SZ3->Z3_CLIENTE 
      cLoja    := SZ3->Z3_LOJACLI
      cNFiscal := SZ3->Z3_NFSAIDA
      cSerNF   := SZ3->Z3_SERISAI
      dData    := SZ3->Z3_DATASAI 
   EndIf
                                     
   nn := Ascan(aCli,cCli)
   
   If nn == 0                   
   	  aAdd(aCli, cCli)
   EndIf
    
   nn := Ascan(aProdX, cCli+SZ3->Z3_CODPROD)
   
   If nn == 0                   
   	  aAdd(aProdX, cCli+SZ3->Z3_CODPROD)
   	  aAdd(aProdY, { cCli, SZ3->Z3_CODPROD, 1 } )
   Else
   	  aProdY[nn,3] += 1
   EndIf 
   
   If mv_par06 == 1 // Qdo Analitico, todos os dados da EtiquetaxProduto

      aAdd(aEtq, { cCli, cLoja, SZ3->Z3_CODPROD, SZ3->Z3_CODETIQ, cNFiscal, cSerNF, dData } ) // Cod Cli/Estoque, Loja, Cod Prod, Etiqueta, N Fiscal Entrada, Data Nota
                                      
   EndIf       

   dbSkip()
   
EndDo                                      
                                           
aSort(aCli)
aSort(aProdY,,,{|x,y| x[1]+x[2] > y[1]+y[2] } )
aSort(aEtq,,,{|x,y| x[1]+x[2]+x[3]+x[4] > y[1]+y[2]+y[3]+y[4] } )

nTotal := 0

If Len(aCli) > 0      

   SetRegua(Len(aCli))
   
   For nn := 1 To Len(aCli)
    
       IncRegua("Aguarde..., Imprimindo Psicao de Etiquetas")
   
       If lAbortPrint
          @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
          Exit
       Endif
       
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Impressao do cabecalho do relatorio. . .                            ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	   If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas... 
	
    	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 10
   
	   Endif  

	   If MV_PAR05 == 1   
	   
	      @ nLin, 02 PSAY "ETIQUETAS EM ESTOQUE"
	      
	   Else 
	   
	      SA1->( DbSeek(xfilial("SA1") + aCli[nn] ))
	      
	      @ nLin, 02 PSAY aCli[nn]
   	      @ nLin, 10 PSAY SA1->A1_NOME
	      
	   EndIf     
	   
	   nLin += 2 // Avanca a linha de impressao
	   
	   For mn := 1 To Len(aProdY)  
	   
	       If aProdY[mn,1] # aCli[nn]   
	          Loop
	       EndIf
	   
	       If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas... 
	
    	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    	      
	          nLin := 10
	          
	          If MV_PAR05 == 1   
	      		@ nLin, 02 PSAY "ETIQUETAS EM ESTOQUE"
		      Else 
	             SA1->( DbSeek(xfilial("SA1") + aCli[nn] ))
	             @ nLin, 02 PSAY aCli[nn]
   	             @ nLin, 10 PSAY SA1->A1_NOME
	          EndIf  
	          nLin += 2 // Avanca a linha de impressao 
	       Endif  

	       @ nLin, 02 PSAY aProdY[mn,2]
	   
	       SB1->( DbSeek(xfilial("SB1") + aProdY[mn,2] ))
	   	   
	       @ nLin, 19 PSAY SUBSTR(SB1->B1_DESC,1,60)
	       @ nLin, 84 PSAY SB1->B1_UM 
	       @ nLin, 92 PSAY aProdY[mn,3]  Picture "@E 999,999" 
	       @ nLin,105 PSAY SB1->B1_CUSTD Picture "@E 99,999,999.99"
	       @ nLin,120 PSAY SB1->B1_PRV1  Picture "@E 99,999,999.99"
	       
	       nLin += 1 // Avanca a linha de impressao
	       
	       If MV_PAR06 == 1  // Analitico 
	   
			   For mm := 1 To Len(aEtq)  
			   
			       If aProdY[mn,1]+aProdY[mn,2] # aEtq[mm,1]+aEtq[mm,3]   
			          Loop
			       EndIf
			   
			       If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas... 
			
		    	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			          nLin := 10

		              If MV_PAR05 == 1   
	      		         @ nLin, 02 PSAY "ETIQUETAS EM ESTOQUE"
		              Else 
	                     SA1->( DbSeek(xfilial("SA1") + aCli[nn] ))
	                     
	                     @ nLin, 02 PSAY aCli[nn]
   	                     @ nLin, 10 PSAY SA1->A1_NOME
	                  EndIf                           
	                  
	                  nLin += 2 // Avanca a linha de impressao
	                                   
	                  @ nLin, 02 PSAY aProdY[mn,2]
	   
	                  SB1->( DbSeek(xfilial("SB1") + aProdY[mn,2] ))
	   	   
	                  @ nLin, 19 PSAY SUBSTR(SB1->B1_DESC,1,60)
	                  @ nLin, 84 PSAY SB1->B1_UM 
	                  @ nLin, 92 PSAY aProdY[mn,3]  Picture "@E 999,999" 
	                  @ nLin,105 PSAY SB1->B1_CUSTD Picture "@E 99,999,999.99"
	                  @ nLin,120 PSAY SB1->B1_PRV1  Picture "@E 99,999,999.99"
	                  
	                  nLin += 1 // Avanca a linha de impressao
			       Endif  
		
			       @ nLin, 04 PSAY aEtq[mm,4]
			       @ nLin, 19 PSAY aEtq[mm,5] 
			       
			       If Day(aEtq[mm,7]) > 0 
			          @ nLin, 30 PSAY aEtq[mm,7] 
			       EndIf   
			       
			       nLin += 1 // Avanca a linha de impressao
			       
			   Next  
			   
		       nLin += 1
		       
	       EndIf
	       
	   Next

	   nLin += 1 // Avanca a linha de impressao

   Next
Else
   Alert(Substr(cUsuario,7,13) + ", Nao Foi Selecionado Nenhum Produto X Etiqueta, Verifique Parametros!")
   Return 
EndIf   

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaSX1 ³ Autor ³Reiner Trennepohl      ³ Data ³ 02.05.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta Grupo de Perguntas                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION AjustaSX1()
Local aArea:=GetArea()
Local i:=0,j:=0
Local aRegistros:={}
Aadd(aRegistros, {cPerg, "01", "Cliente Inicial  ?", ".", ".", "mv_ch1", "C", 6, 0, 0, "G", "", "mv_par01", "",          "", "", "", "", "",            "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1", ""})
Aadd(aRegistros, {cPerg, "02", "Cliente Final    ?", ".", ".", "mv_ch2", "C", 6, 0, 0, "G", "", "mv_par02", "",          "", "", "",	"", "",            "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1", ""})
Aadd(aRegistros, {cPerg, "03", "Produto Inicial  ?", ".", ".", "mv_ch3", "C",15, 0, 0, "G", "", "mv_par03", "",          "", "", "", "", "",            "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", ""})
Aadd(aRegistros, {cPerg, "04", "Produto Final    ?", ".", ".", "mv_ch4", "C",15, 0, 0, "G", "", "mv_par04", "",          "", "", "",	"", "",            "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", ""})
Aadd(aRegistros, {cPerg, "05", "Situacao         ?", ".", ".", "mv_ch5", "N", 1, 0, 1, "C", "", "mv_par05", "Estoque",   "", "", "", "", "Consignacao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 	  ""})
Aadd(aRegistros, {cPerg, "06", "Tipo             ?", ".", ".", "mv_ch6", "N", 1, 0, 1, "C", "", "mv_par06", "Analitico", "", "", "", "", "Sintetico",   "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 	  ""})

dbSelectArea("SX1")
For i:=1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next j
		MsUnlock()
	EndIf
Next i
RestArea(aArea)
Return(NIL)
