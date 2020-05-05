#Include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³JMHR140   ºAutor  ³Marcelo Tarasconi   º Data ³  20/02/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio Mapa de Lucratividade                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP 8                                                       º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JMHR140()

Local cQuery       := ''
Local cPerg		   := 'JMR140'

Local aDados	   := {{ "Vendedor de:"				   , "", "", "mv_ch1", "C",  6, 0, 0, "G", ""                               , "mv_par01", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","","SA3","" },;
					   { "Vendedor ate:"			   , "", "", "mv_ch2", "C",  6, 0, 0, "G", ""                               , "mv_par02", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","","SA3","" },;
					   { "Produto de:"				   , "", "", "mv_ch3", "C", 15, 0, 0, "G", ""                               , "mv_par03", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","","SB1","" },;
					   { "Produto ate:"	     		   , "", "", "mv_ch4", "C", 15, 0, 0, "G", ""                               , "mv_par04", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","","SB1","" },;
                       { "Emissao de:"                 , "", "", "mv_ch5", "D",  8, 0, 0, "G", ""                               , "mv_par05", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","",""   ,"" },;
					   { "Emissao ate:"                , "", "", "mv_ch6", "D",  8, 0, 0, "G", ""								, "mv_par06", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","",""   ,"" },;
					   { "Estado Cliente de:"		   , "", "", "mv_ch7", "C",  2, 0, 0, "G", "ExistCpo('SX5','12'+MV_PAR07)  ", "mv_par07", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","","12","" },;
					   { "Estado Cliente ate:"		   , "", "", "mv_ch8", "C",  2, 0, 0, "G", "ExistCpo('SX5','12'+MV_PAR06)  ", "mv_par08", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","","12"   ,"" },;
					   { "TES Gera Estoque:"		   , "", "", "mv_ch9", "C",  6, 0, 0, "C", ""                               , "mv_par09", "Sim"            , "", "", "", "", "Nao"                 , "", "", "", "", "Ambos"          , "","","","","","","","","","","","","","","" },;
					   { "TES Gera Financeiro:"		   , "", "", "mv_chA", "C",  2, 0, 0, "C", ""                               , "mv_par10", "Sim"            , "", "", "", "", "Nao"                 , "", "", "", "", "Ambos"          , "","","","","","","","","","","","","",""   ,"" },;
					   { "% Pis/Cofins:"		       , "", "", "mv_chB", "N",  6, 2, 0, "G", ""                               , "mv_par11", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","",""   ,"" },;
					   { "% IR/CSLL:"	         	   , "", "", "mv_chC", "N",  6, 2, 0, "G", ""                               , "mv_par12", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","",""   ,"" },;
					   { "Grupo de:"  				   , "", "", "mv_chd", "C",  4, 0, 0, "G", ""                               , "mv_par13", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","","SBM","" },;
					   { "Grupo ate:"	     		   , "", "", "mv_che", "C",  4, 0, 0, "G", ""                               , "mv_par14", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","","SBM","" },;
					   { "nao Imprimir Tipos:" 		   , "", "", "mv_chf", "C", 60, 0, 0, "G", ""                               , "mv_par15", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","","","" },;
					   { "Imprimir somente os Tipos:"  , "", "", "mv_chg", "C", 60, 0, 0, "G", ""                               , "mv_par16", ""               , "", "", "", "", ""                    , "", "", "", "", ""               , "","","","","","","","","","","","","","","" }}

Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "Mapa Lucratividade"
Private titulo       := "Mapa Lucratividade"


Private aOrdem     := {}
//					   0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9          0         1         2
//					   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567899012345678901234567890
//					   999999999999999 XXXXXXXXXXXXXXXXXXXXXXXXX 999999-XXX-99 999,999.99  999,999.99  9,999,999.99  999,999.99  9,999,999.99  999,999.99  999,999.99  9,999,999.99  99,999.99  999,999.99  999,999.99  9,999,999.99  99,999.99
Private cabec1	   := 'Codigo          Descricao                  NF-Serie-It       Quant   Custo Un    Custo Total    Preço Un       T.Venda  Pis/Cofins        ICMS     Margem Br      %         Desp.OP     IR/CSLL     Lucro Liq      %   '

Private cabec2	   := ''
Private nLin       := 80
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "JmhR140" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private m_pag      := 01
Private wnrel      := "JmhR140" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "SF2"
Private cUltVend   := 'ZZZZZZ'
Private cNomVend   := ''
Private nTVCusto   :=   nTVTotal  :=   nTVLucroL :=   nTVImpost :=   nTVICMS   :=   nTVMaBru := nTVDesp := nTVIR := 0
Private nTVCustoT   :=   nTVTotalT  :=   nTVLucroLi :=   nTVImpostT :=   nTVICMST   :=   nTVMaBruT := nTVDespT := nTVIRT := 0

AjustaSx1( cPerg, aDados )
Pergunte( cPerg, .f. )

dbSelectArea("SF2")
dbSetOrder(1)

wnrel := SetPrint( cString, nomeprog, cPerg, titulo , cDesc1, cDesc2, cDesc3, .f., aOrdem ,     , tamanho,,.F. )

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºUso       ³ Programa principal                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo)



//FACO A QUERY 
cCount  := " SELECT Count(*) as TMP_QTD " 
cSelect := " SELECT F2_VEND1, F2_DOC, F2_SERIE, F2_TIPO, D2_COD, D2_ITEM, D2_CUSTO1, D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_VALIMP6, D2_VALIMP5, D2_VALICM, B1_DESC, B1_CUSTD, A3_NOME, A3_DESPOP " 
cQuery  := " FROM " + RetSqlName( "SF2" ) + " SF2, " +  RetSqlName( "SD2" ) + " SD2, "
cQuery  +=            RetSqlName( "SB1" ) + " SB1, " +  RetSqlName( "SF4" ) + " SF4, "
cQuery  +=            RetSqlName( "SA1" ) + " SA1, " +  RetSqlName( "SA3" ) + " SA3 "
cQuery  += " WHERE SF2.F2_FILIAL = '" + xFilial('SF2') + "'"
cQuery  += " AND SF2.F2_TIPO NOT IN ('D','B') " //TARASCONI - ADICIONADO EM 11.07.2008
cQuery  += " AND SF2.F2_EMISSAO BETWEEN '" + DtoS(Mv_Par05) + "' AND '" + DtoS(Mv_Par06) + "'"    
cQuery  += " AND SF2.F2_VEND1 BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "'"    

cQuery  += " AND SD2.D2_FILIAL = SF2.F2_FILIAL "
cQuery  += " AND SD2.D2_DOC = SF2.F2_DOC "
cQuery  += " AND SD2.D2_SERIE = SF2.F2_SERIE "
cQuery  += " AND SD2.D2_COD BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "'"    

cQuery  += " AND SA1.A1_FILIAL = '"+ xFilial('SA1') +"'"
cQuery  += " AND SA1.A1_COD = SF2.F2_CLIENTE "
cQuery  += " AND SA1.A1_LOJA = SF2.F2_LOJA "
cQuery  += " AND SA1.A1_EST BETWEEN '" + Mv_Par07 + "' AND '" + Mv_Par08 + "'"    

cQuery  += " AND SB1.B1_FILIAL = '"+ xFilial('SB1') +"'"
cQuery  += " AND SB1.B1_COD = SD2.D2_COD "
cQuery  += " AND SB1.B1_GRUPO BETWEEN '" + Mv_Par13 + "' AND '" + Mv_Par14 + "'"    
If ! Empty(MV_PAR15)  // nao imprimir tipos
	cQuery += " AND SB1.B1_TIPO NOT IN " + FormatIn(MV_PAR15, ';')
Else
	cQuery += " AND SB1.B1_TIPO IN " + FormatIn(MV_PAR16, ';')
EndIf

cQuery  += " AND SF4.F4_FILIAL = '"+ xFilial('SF4') +"'"
cQuery  += " AND SF4.F4_CODIGO = SD2.D2_TES "
If Mv_Par09 = 1 //Gera Estoque
   cQuery += " AND SF4.F4_ESTOQUE = 'S'"
ElseIf Mv_Par09 = 2 //Não Gera Estoque
   cQuery += " AND SF4.F4_ESTOQUE = 'N'"
EndIf
If Mv_Par10 = 1 //Gera Financeiro
   cQuery += " AND SF4.F4_DUPLIC = 'S'"
ElseIf Mv_Par10 = 2 //Não Gera Financeiro
   cQuery += " AND SF4.F4_DUPLIC = 'N'"
EndIf
cQuery  += " AND SA3.A3_FILIAL = '"+ xFilial('SA3') +"'"
cQuery  += " AND SA3.A3_COD = SF2.F2_VEND1 "

cQuery  += " AND SF2.D_E_L_E_T_ = '' "
cQuery  += " AND SD2.D_E_L_E_T_ = '' "
cQuery  += " AND SB1.D_E_L_E_T_ = '' "
cQuery  += " AND SF4.D_E_L_E_T_ = '' "
cQuery  += " AND SA1.D_E_L_E_T_ = '' "

cOrder  := " ORDER BY F2_FILIAL, F2_VEND1, D2_COD, F2_EMISSAO "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cCount+cQuery), 'TMPQTD', .F.,.T.)
SetRegua( TMPQTD->TMP_QTD )

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSelect+cQuery+cOrder), 'TMP', .F.,.T.)

TMP->( dbGoTop() )

Do While TMP->( !Eof() )

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
     
   If cUltVend # TMP->F2_VEND1 
      Totaliza()
      @nLin,000 PSay __PrtThinLine()      
      nLin++       
      @nLin,005 PSAY 'Vendedor: ' + TMP->F2_VEND1  +' - '+ TMP->A3_NOME
      nLin++      
      nLin++      
   EndIf

   @nLin,000 PSAY TMP->D2_COD   
   @nLin,016 PSAY Left(TMP->B1_DESC,24)  
   @nLin,042 PSAY TMP->F2_DOC+'-'+TMP->F2_SERIE+'-'+TMP->D2_ITEM
   @nLin,056 PSAY TMP->D2_QUANT  Picture "@E 999,999.99"

   //Se custo no item da nota estiver zerado, entao pego do SB2
   nCusto := If(TMP->D2_CUSTO1==0, Posicione("SB2",1,xFilial("SB2")+TMP->D2_COD,"B2_CM1"),TMP->D2_CUSTO1/TMP->D2_QUANT)   
   lSB2Zero := .f.
   // caso continue zerado, entao vou pegar o Custo Standard do produto
   If nCusto = 0
	   lSB2Zero := .t.
	   nCusto  := TMP->B1_CUSTD
   EndIf
   @nLin,068 PSAY nCusto Picture "@E 999,999.99"
   @nLin,078 PSAY Iif(lSB2Zero, '**', If(TMP->D2_CUSTO1==0,'*',' '))

   @nLin,080 PSAY TMP->D2_QUANT*nCusto Picture "@E 9,999,999.99"//custo total
   @nLin,094 PSAY TMP->D2_PRCVEN Picture "@E 999,999.99"//preco venda unitario
   @nLin,106 PSAY TMP->D2_TOTAL Picture "@E 9,999,999.99"//total item
   @nLin,120 PSAY TMP->D2_TOTAL*(MV_PAR11/100) Picture "@E 999,999.99" //Pis e Cofins -//TMP->D2_VALIMP6+TMP->D2_VALIMP5
   @nLin,132 PSAY TMP->D2_VALICM Picture "@E 999,999.99" //icms
   @nLin,144 PSAY TMP->D2_TOTAL-(TMP->D2_QUANT*nCusto) - TMP->D2_TOTAL*(MV_PAR11/100) - TMP->D2_VALICM Picture "@E 9,999,999.99" //MARGEM BRUTA LUCRO BRUTO - PIS - COFINS - ICMS   
   @nLin,158 PSAY (TMP->D2_TOTAL-(TMP->D2_QUANT*nCusto) - TMP->D2_TOTAL*(MV_PAR11/100) - TMP->D2_VALICM)/TMP->D2_TOTAL*100  Picture "@E 99,999.99" //MARGEM BRUTA LUCRO BRUTO - PIS - COFINS - ICMS   
   @nLin,167 PSAY '%'

   @nLin,169 PSAY TMP->D2_TOTAL*(TMP->A3_DESPOP/100) Picture "@E 999,999.99"//Desp. OP
   @nLin,181 PSAY TMP->D2_TOTAL*(MV_PAR12/100) Picture "@E 999,999.99"//IR/CSLL

   @nLin,193 PSAY TMP->D2_TOTAL-(TMP->D2_QUANT*nCusto)-TMP->D2_VALICM-TMP->D2_TOTAL*(MV_PAR11/100)-TMP->D2_TOTAL*(MV_PAR12/100)-TMP->D2_TOTAL*(TMP->A3_DESPOP/100) Picture "@E 9,999,999.99"//lucro liquido
   @nLin,206 PSAY ( TMP->D2_TOTAL-(TMP->D2_QUANT*nCusto)-TMP->D2_VALICM-TMP->D2_TOTAL*(MV_PAR11/100)-TMP->D2_TOTAL*(MV_PAR12/100)-TMP->D2_TOTAL*(TMP->A3_DESPOP/100))/TMP->D2_TOTAL*100 Picture "@E 99,999.99"//% lucro liquido
   @nLin,215 PSAY '%'
   nLin++

   nTVCusto  += TMP->D2_QUANT*nCusto
   nTVTotal  += TMP->D2_TOTAL
   nTVLucroL += TMP->D2_TOTAL-(TMP->D2_QUANT*nCusto)-TMP->D2_VALICM-TMP->D2_TOTAL*(MV_PAR11/100)-TMP->D2_TOTAL*(MV_PAR12/100)-TMP->D2_TOTAL*(TMP->A3_DESPOP/100)
   nTVImpost += TMP->D2_TOTAL*(MV_PAR11/100)//TMP->D2_VALIMP6+TMP->D2_VALIMP5
   nTVICMS   += TMP->D2_VALICM
   nTVMaBru  += TMP->D2_TOTAL-(TMP->D2_QUANT*nCusto) - TMP->D2_TOTAL*(MV_PAR11/100) - TMP->D2_VALICM 
   nTVDesp   += TMP->D2_TOTAL*(TMP->A3_DESPOP/100)
   nTVIR     += TMP->D2_TOTAL*(MV_PAR12/100)
   
   nTVCustoT  += TMP->D2_QUANT*nCusto
   nTVTotalT  += TMP->D2_TOTAL
   nTVImpostT += TMP->D2_TOTAL*(MV_PAR11/100)//TMP->D2_VALIMP6+TMP->D2_VALIMP5
   nTVICMST   += TMP->D2_VALICM
   nTVMaBruT  += TMP->D2_TOTAL-(TMP->D2_QUANT*nCusto) - TMP->D2_TOTAL*(MV_PAR11/100) - TMP->D2_VALICM 
   nTVLucroLi += TMP->D2_TOTAL-(TMP->D2_QUANT*nCusto)-TMP->D2_VALICM-TMP->D2_TOTAL*(MV_PAR11/100)-TMP->D2_TOTAL*(MV_PAR12/100)-TMP->D2_TOTAL*(TMP->A3_DESPOP/100)
   nTVDespT   += TMP->D2_TOTAL*(TMP->A3_DESPOP/100)
   nTVIRT     += TMP->D2_TOTAL*(MV_PAR12/100)
   
   cUltVend := TMP->F2_VEND1
   cNomVend := TMP->A3_NOME

   IncRegua()
   TMP->(dbSkip()) 

EndDo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Ultimo depis de sair do While                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin++
If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 8
Endif

nLin++
   @nLin,005 PSAY 'Total Vendedor: ' + cUltVend +'-'+ cNomVend
   @nLin,080 PSAY nTVCusto   Picture "@E 9,999,999.99"   //custo total
   @nLin,106 PSAY nTVTotal   Picture "@E 9,999,999.99"   //total item
   @nLin,120 PSAY nTVImpost  Picture "@E 999,999.99"     //Pis e Cofins
   @nLin,132 PSAY nTVICMS    Picture "@E 999,999.99"     //icms
   @nLin,144 PSAY nTVMaBru   Picture "@E 9,999,999.99"   //MARGEM BRUTA LUCRO BRUTO - PIS - COFINS - ICMS
   @nLin,158 PSAY (nTVMaBru/nTVTotal)*100 Picture "@E 99,999.99"   
   @nLin,167 PSAY '%'
   @nLin,169 PSAY nTVDesp    Picture "@E 999,999.99"   //Despesa Operacional
   @nLin,179 PSAY nTVIR      Picture "@E 9,999,999.99"   //IR/CSLL
   @nLin,193 PSAY nTVLucroL  Picture "@E 9,999,999.99"   //lucro bruto
   @nLin,206 PSAY (nTVLucroL/nTVTotal)*100  Picture "@E 99,999.99"//lucro bruto
   @nLin,215 PSAY '%'
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos Totais totais                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin++
nLin++
@nLin,000 PSay __PrtThinLine()
nLin++
nLin++
@nLin,005 PSAY 'Total Geral: ' 

@nLin,079 PSAY nTVCustoT   Picture "@E 99,999,999.99"  //custo total
@nLin,105 PSAY nTVTotalT   Picture "@E 99,999,999.99"//total item
@nLin,120 PSAY nTVImpostT  Picture "@E 999,999.99"   //Pis e Cofins
@nLin,132 PSAY nTVICMST    Picture "@E 999,999.99"   //icms
@nLin,143 PSAY nTVMaBruT   Picture "@E 99,999,999.99"   //MARGEM BRUTA LUCRO BRUTO - PIS - COFINS - ICMS
@nLin,158 PSAY (nTVMaBruT/nTVTotalT)*100 Picture "@E 99,999.99"   
@nLin,167 PSAY '%'
@nLin,169 PSAY nTVDespT    Picture "@E 999,999.99"   //Despesa Operacional
@nLin,179 PSAY nTVIRT      Picture "@E 9,999,999.99"   //IR/CSLL
@nLin,192 PSAY nTVLucroLi  Picture "@E 99,999,999.99"//lucro bruto
@nLin,206 PSAY (nTVLucroLi/nTVTotalT)*100  Picture "@E 99,999.99"//lucro bruto
@nLin,215 PSAY '%'

nLin++	          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

dbSelectArea('TMPQTD')
dbCloseArea()
dbSelectArea('TMP')
dbCloseArea()

Return



********************************************************************************
Static Function Totaliza()

If nTVCusto > 0 
	
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   nLin++
   @nLin,005 PSAY 'Total Vendedor: ' + cUltVend +'-'+ cNomVend
   @nLin,080 PSAY nTVCusto   Picture "@E 9,999,999.99"  //custo total
   @nLin,106 PSAY nTVTotal   Picture "@E 9,999,999.99"//total item
   @nLin,120 PSAY nTVImpost  Picture "@E 999,999.99"   //Pis e Cofins
   @nLin,132 PSAY nTVICMS    Picture "@E 999,999.99"   //icms
   @nLin,144 PSAY nTVMaBru Picture "@E 9,999,999.99"   //MARGEM BRUTA LUCRO BRUTO - PIS - COFINS - ICMS
   @nLin,158 PSAY (nTVMaBru/nTVTotal)*100 Picture "@E 99,999.99"   
   @nLin,167 PSAY '%'
   @nLin,169 PSAY nTVDesp    Picture "@E 999,999.99"   //Despesa Operacional
   @nLin,179 PSAY nTVIR      Picture "@E 9,999,999.99"   //IR/CSLL
   @nLin,192 PSAY nTVLucroL  Picture "@E 99,999,999.99"//lucro bruto
   @nLin,206 PSAY (nTVLucroL/nTVTotal)*100  Picture "@E 99,999.99"//lucro bruto
   @nLin,215 PSAY '%'
   nLin++
   nLin++
      
   nTVCusto   :=   nTVTotal  :=   nTVLucroL :=   nTVImpost :=   nTVICMS   :=   nTVMaBru := nTVDesp := nTVIR := 0
    
EndIf

Return