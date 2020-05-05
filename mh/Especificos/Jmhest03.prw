#Include "protheus.ch"
#include "sigawin.ch"

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡…o    ³ JMHEST03  ³ Autor ³ Reiner Trenepohl     ³ Data ³ 10/03/93 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³Relacao dos Produtos Vendidos                               ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ Generico                                                   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function JMHEST03()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL Tamanho  := "G"
LOCAL titulo   := "Relacao dos Produtos Vendidos"
LOCAL cDesc1   := "Este relatorio apresenta o valor total das vendas de cada produto,"
LOCAL cDesc2   := "calculando sua participacao dentro do total das vendas.Mostra tam-"
LOCAL cDesc3   := "bem o custo de cada venda e o custo de reposicao do produto."
LOCAL cString  := "SD2"
LOCAL nTipo    := 0
LOCAL wnrel    := "JMHEST03"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }        
PRIVATE nLastKey := 0 
PRIVATE cPerg := "MTR310"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01     // Almoxarifado inicial                         ³
//³ MV_PAR02     // Almoxarifado final                           ³
//³ MV_PAR03     // Data de emissao inicial                      ³
//³ MV_PAR04     // Data de emissao final                        ³
//³ MV_PAR05     // tipo inicial                                 ³
//³ MV_PAR06     // tipo final                                   ³
//³ MV_PAR07     // produto inicial                              ³
//³ MV_PAR08     // produto final                                ³
//³ MV_PAR09     // moeda selecionada ( 1 a 5 )                  ³
//³ MV_PAR10     // Considera Valor IPI Sim N„o                  ³
//³ MV_PAR11     // Considera Devolucao NF Orig/NF Devl/Nao Cons.³
//³ MV_PAR12     // Quanto a Estoque Movimenta/Nao Movta/Ambos   ³
//³ MV_PAR13     // Quanto a Duplicata Gera/Nao Gera/Ambos       ³
//³ MV_PAR14     // Considera Valor ICMS Sim N„o                 ³
//³ MV_PAR15     // Abate Impostos Nao Faturados ?               ³
//³ MV_PAR16     // Perc. Abatimento ?                           ³
//³ MV_PAR17     // Inclui Devolucao de Compra?                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
   Set Filter to
   Return
Endif

RptStatus({|lEnd| C02Imp(@lEnd,wnRel,cString,titulo,Tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C02IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 12.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST03                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C02Imp(lEnd,WnRel,cString,titulo,Tamanho)
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cRodaTxt := "REGISTRO(S)"
LOCAL nCntImpr := 0
LOCAL lDevolucao := .F.
LOCAL nAp1,nAp2,nAp3,nAp4,nAp5
LOCAL nAt1,nAt2,nAt3,nAt4,nAt5
LOCAL nAg1,nAg2,nAg3,nAg4,nAg5
LOCAL cCodAnt := "",cTipant := "",nTotFat:=0,nTotLuc:=0
LOCAL cMoeda ,lPassou
LOCAL cArqSD1:=cArqSD2:=cArqTrab:=cArqTrb2:=cKeySD2:=sKeySD1:=cFilSD1:=cFilSD2:=""
Local cEstoq := If( (mv_par12 == 1),"S",If( (mv_par12 == 2),"N","SN" ) )
Local cDupli := If( (mv_par13 == 1),"S",If( (mv_par13 == 2),"N","SN" ) )
Local nValCus := 0
Local aTam:={}
LOCAL nIndSd1:= 0
Local aStruct := {}
Local nCpo
Private aCampos := {}

If mv_par15 == 1
   cRodaTxt += "=> (( B - A ) / B ) * 100"
Else                                                             
  cRodaTxt += "=>  C = B - "+Str(mv_par16,5,2)+"%  => (( C - A ) / C ) * 100"
EndIf                                          
Private cCampImp
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas especificas deste relatorio               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lContinua := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMoeda := Ltrim(Str(mv_par09))
titulo += " - "+GetMv("MV_SIMB"+cMoeda)
cabec1 := "TP CODIGO          D E S C R I C A O                              QUANTIDADE  UM         CUSTO       CUSTO POR      VALOR FAT.       V A L O R   IMPOSTOS NAO    VAL FATURADO -     MAR    MIX    MIX       CUSTO DE   VARIA"
cabec2 := "-----------------------------------------------------------------------------------------TOTAL        UNIDADE            BRUTO        FATURADO      FATURADOS    IMP. NAO FAT.      GEM   *MAR              REPOSICAO    CAO"
//          123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22        23        24

If (mv_par11 # 3)

   dbSelectArea( "SD1" )
   cArqSD1 := CriaTrab( NIL,.F. )
   cKeySD1 := "D1_FILIAL+D1_COD+D1_SERIORI+D1_NFORI+D1_ITEMORI"
   cFilSD1 := "D1_FILIAL = '"+xFilial( "SD1" )+"' .And. D1_TIPO = 'D' .And. "+;
              "D1_COD >= '"+MV_PAR07+"' .And. D1_COD <= '"+MV_PAR08+"' .And. "+; 
              "D1_LOCAL >= '"+MV_PAR01+"' .And. D1_LOCAL <= '"+MV_PAR02+"'"
   If (mv_par11 # 1)
      cFilSD1 += " .And. DTOS(D1_DTDIGIT) >= '"+DTOS(MV_PAR03)+"' .And. DTOS(D1_DTDIGIT) <= '"+DTOS(MV_PAR04)+"'"
   EndIf

   IndRegua("SD1",cArqSD1,cKeySD1,,cFilSD1,"Selecionando Registros...")

   nIndSd1:=RetIndex("SD1")
   #IFNDEF TOP
   		dbSetIndex(cArqSd1+OrdBagExt())
   #ENDIF
   dbSetOrder(nIndSd1 + 1)
   dbGoTop()

EndIf

dbSelectArea( "SD2" )
dbSetOrder( 2 )

cKeySD2 := IndexKey()

aTam := TamSx3("D2_FILIAL")
Aadd(aCampos,{"D2_FILIAL","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_COD")
Aadd(aCampos,{"D2_COD","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_LOCAL")
Aadd(aCampos,{"D2_LOCAL","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_SERIE")
Aadd(aCampos,{"D2_SERIE","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_TES")
Aadd(aCampos,{"D2_TES","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_TP")
Aadd(aCampos,{"D2_TP","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_EMISSAO")
Aadd(aCampos,{"D2_EMISSAO","D",aTam[1],aTam[2]})
aTam := TamSx3("D2_TIPO")
Aadd(aCampos,{"D2_TIPO","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_DOC")
Aadd(aCampos,{"D2_DOC","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_QUANT")
Aadd(aCampos,{"D2_QUANT","N",aTam[1],aTam[2]})
aTam := TamSx3("D2_TOTAL")
Aadd(aCampos,{"D2_TOTAL","N",aTam[1],aTam[2]})
aTam := TamSx3("D2_CUSTO"+Str(mv_par09,1))
Aadd(aCampos,{"D2_CUSTO","N",aTam[1],aTam[2]})
aTam := TamSx3("D2_VALIPI")
Aadd(aCampos,{"D2_VALIPI","N",aTam[1],aTam[2]})
aTam := TamSx3("D2_VALICM")
Aadd(aCampos,{"D2_VALICM","N",aTam[1],aTam[2]})
aTam := TamSx3("D2_ITEM")
Aadd(aCampos,{"D2_ITEM","C",aTam[1],aTam[2]})
aTam := TamSx3("D2_ORIGLAN")
Aadd(aCampos,{"D2_ORIGLAN","C",aTam[1],aTam[2]})
If cPaisLoc<>"BRA"  
   aStruct:=SD2->(dbStruct())
   For nCpo := 1 to Len(aStruct)
       If Substr(aStruct[nCpo][1],1,9)=="D2_VALIMP" .or. Substr(aStruct[nCpo][1],1,9)=="D2_BASIMP"
          aTam := TamSx3(aStruct[nCpo][1])
          Aadd(aCampos,{aStruct[nCpo][1],"N",aTam[1],aTam[2]})
       EndIf
   Next
EndIf

cArqTrab := CriaTrab(aCampos)

Use &cArqTrab Alias TRB New Exclusive
cArqTrb2 := CriaTrab( NIL,.F. )
IndRegua("TRB",cArqTrb2,"D2_FILIAL+D2_TP+D2_COD+D2_DOC+D2_SERIE",,cFilSD2,"Selecionando Registros...") 

cFilSD2 := "D2_FILIAL == '"+xFilial( "SD2" )+"' .And. D2_TP >= '"+MV_PAR05+;
           "' .And. D2_TP <= '"+MV_PAR06+"' .And. D2_COD >= '"+MV_PAR07+;
		   "' .And. D2_COD <= '"+MV_PAR08+"' .And. D2_LOCAL >= '"+MV_PAR01+;
           "' .And. D2_LOCAL <= '"+MV_PAR02+"'"
cFilSD2 += " .And. DTOS(D2_EMISSAO) >= '"+DTOS(MV_PAR03)+"' .And. DTOS(D2_EMISSAO) <= '"+DTOS(MV_PAR04)+"'"
If mv_par17 == 2      
   cFilSD2 += " .And. D2_TIPO # 'D'"
//   cFilSD2 += ' .And. D2_TIPO # "D"'"
Endif

cArqSD2 := CriaTrab( NIL,.F. )
IndRegua("SD2",cArqSD2,cKeySD2,,cFilSD2,"Selecionando Registros...") 
GeraTrab("SD2")
If mv_par11 != 3

   dbSelectArea("SD1")
   dbGoTop()
   GeraTrab("SD1")
EndIf

dbSelectArea("TRB")
dbGoTop()

SetRegua(RecCount())              // Total de Elementos da regua

Do While lContinua .And. !TRB->(Eof())
   If lEnd
      @Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
      lContinua := .F.
      Exit
   Endif

   IncRegua()

   If !(cCodAnt == TRB->D2_COD)
      cCodAnt    := TRB->D2_COD
      lDevolucao := .T.
   EndIf

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal    ³
   //³ Despreza Itens em que a TES NAO Se Ajusta a Selecao do Usuario ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If !(TRB->D2_ORIGLAN == "LF") .And. AvalTes(TRB->D2_TES,cEstoq,cDupli)
	   If TRB->D2_TIPO != "D"
	      If (mv_par09 > 1)
	         nValCus := TRB->D2_CUSTO
	         if nValCus > 0
	            nTotLuc += nValCus
	         else
	            nTotLuc += ConvMoeda( TRB->D2_EMISSAO,,TRB->D2_CUSTO,cMoeda )
	         endif
	      Else
	         nTotLuc += TRB->D2_CUSTO
	      EndIf
          If (mv_par09 > 1)
             nTotFat += ConvMoeda( TRB->D2_EMISSAO,,ValSD2(),cMoeda )
          Else
             nTotFat += ValSD2()
          EndIf
       EndIf
       Do Case
          Case (mv_par11 == 1)
               DbSelectArea( "SD1" )
               If DbSeek( xFilial( "SD1" )+TRB->D2_COD+TRB->D2_SERIE+TRB->D2_DOC+TRB->D2_ITEM,.F. )
                  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                  //³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal    ³
                  //³ Despreza Itens em que a TES NAO Se Ajusta a Selecao do Usuario ³
                  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                  If !(D1_ORIGLAN == "LF") .And. AvalTes(D1_TES,cEstoq,cDupli)

			         If (mv_par09 > 1)
            			nValCus :=  &("D1_CUSTO"+If((mv_par09==1),"",Str(mv_par09,1)) )
                        if nValCus > 0
                           nTotLuc -= nValCus
                        else
                           nTotLuc -= ConvMoeda( D1_DTDIGIT,,D1_CUSTO,cMoeda )
                        endif
                     Else
                        nTotLuc -=  &("D1_CUSTO"+If((mv_par09==1),"",Str(mv_par09,1)) )
                     EndIf
                                        
                     If (mv_par09 > 1)
                        nTotFat -= ConvMoeda( D1_DTDIGIT,,ValSD1(),cMoeda )
                     Else
                        nTotFat -= ValSD1()
                     EndIf
                  EndIf
               EndIf
          Case (mv_par11 == 2) .And. lDevolucao
               DbSelectArea( "SD1" )
               If DbSeek( xFilial( "SD1" )+TRB->D2_COD,.F. )
               	  Do While !SD1->(Eof()) .And. (SD1->D1_COD == TRB->D2_COD)
                     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                     //³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal    ³
                     //³ Despreza Itens em que a TES NAO Se Ajusta a Selecao do Usuario ³
                     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                     If !(D1_ORIGLAN == "LF") .And. AvalTes(D1_TES,cEstoq,cDupli)
                                                    
                        If (mv_par09 > 1)
                           nValCus :=  &("D1_CUSTO"+If((mv_par09==1),"",Str(mv_par09,1)) )
                           if nValCus > 0
                              nTotLuc -= nValCus
                           else
                              nTotLuc -= ConvMoeda( D1_DTDIGIT,,D1_CUSTO,cMoeda )
                           endif
                        Else
                           nTotLuc -=  &("D1_CUSTO"+If((mv_par09==1),"",Str(mv_par09,1)) )
                        EndIf
                                                 
                        If (mv_par09 > 1)
                           nTotFat -= ConvMoeda( D1_DTDIGIT,,ValSD1(),cMoeda )
                        Else
                           nTotFat -= ValSD1()
                        EndIf
                     EndIf
                     dbSelectArea('SD1')
                     DbSkip( 1 )
                  EndDo
               EndIf
               lDevolucao := .F.
       EndCase
   EndIf

   DbSelectArea( "TRB" )
   DbSkip( 1 )
EndDo

nTotLuc := c02AbaVal(nTotFat)-nTotLuc

TRB->(DbGoTop())

nAg1  := 0
nAg2  := 0
nAg3  := 0
nAg4  := 0
nAg5  := 0
cCodAnt := ""

dbSelectArea("TRB")
Do While lContinua .And. !TRB->(Eof())

   If lEnd
      @Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
      Exit
   Endif
   nAt1 := 0
   nAt2 := 0
   nAt3 := 0
   nAt4 := 0
   nAt5 := 0

   lPassou := .F.
   cTipant := TRB->D2_TP

   Do While lContinua .And. !TRB->(Eof()) .And. (TRB->D2_TP == cTipant)

         IF lEnd
            @Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
            lContinua := .F.
            Exit
         Else

            SB1->(DbSeek( xFilial( "SB1" )+TRB->D2_COD,.F. ))
            nAp1 := 0
            nAp2 := 0
            nAp3 := 0
            nAp4 := 0
            nAp5 := 0

            If !(cCodAnt == TRB->D2_COD)
               cCodAnt    := TRB->D2_COD
               lDevolucao := .T.
            EndIf
                   
            Do While lContinua .And. !TRB->(Eof()) .And. TRB->D2_TP+TRB->D2_COD == cTipant+cCodAnt

               IF lEnd
                  @Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
                  lContinua := .F.
                  Exit
               Else

                  IncRegua()

                  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                  //³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal    ³
                  //³ Despreza Itens em que a TES NAO Se Ajusta a Selecao do Usuario ³
                  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                  If !(TRB->D2_ORIGLAN == "LF") .And. AvalTes(TRB->D2_TES,cEstoq,cDupli)
                     If TRB->D2_TIPO != "D"
                        nAp1 += TRB->D2_QUANT
                        If (mv_par09 > 1)
                           nValCus := TRB->D2_CUSTO
                           if nValCus > 0
                              nAp2 += nValCus
                           else
                              nAp2 += ConvMoeda(TRB->D2_EMISSAO,,TRB->D2_CUSTO,cMoeda )
                           endif
                        Else
                           nAp2 += TRB->D2_CUSTO
                        EndIf

                        If (mv_par09 > 1)
                           nAp3 += ConvMoeda(TRB->D2_EMISSAO,,ValSD2(),cMoeda )
                           If cPaisLoc=="BRA"
                              nAp5 += ConvMoeda(TRB->D2_EMISSAO,,TRB->D2_TOTAL+IF(mv_par10 == 1,TRB->D2_VALIPI,0),cMoeda )
                           Else
                              nAp5 += ConvMoeda(TRB->D2_EMISSAO,,SumTaxSD2(.F.),cMoeda)
                           EndIf
                        Else
                           nAp3 += ValSD2()
                           If cPaisLoc=="BRA"
                              nAp5 += TRB->D2_TOTAL+IF(mv_par10 == 1,TRB->D2_VALIPI,0)
                           Else
                              nAp5 += SumTaxSD2(.F.)
                           EndIf
                        EndIF

                        If mv_par09 > 1
                           nAp4 += (TRB->D2_QUANT*ConvMoeda(SB1->B1_DATREF,,SB1->B1_CUSTD,cMoeda))
                        Else
                           nAp4 += (TRB->D2_QUANT*SB1->B1_CUSTD)
                        EndIF
                     EndIf
                     Do Case
                        Case (mv_par11 == 1)
                             DbSelectArea( "SD1" )
                             If DbSeek( xFilial( "SD1" )+TRB->D2_COD+TRB->D2_SERIE+TRB->D2_DOC+TRB->D2_ITEM,.F. )
                                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                                //³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal    ³
                                //³ Despreza Itens em que a TES NAO Se Ajusta a Selecao do Usuario ³
                                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                If !(SD1->D1_ORIGLAN == "LF") .And. AvalTes(SD1->D1_TES,cEstoq,cDupli)

                                   nAp1 -= SD1->D1_QUANT
                                   If (mv_par09 > 1)
                                      nValCus :=  &("D1_CUSTO"+If((mv_par09==1),"",Str(mv_par09,1)) )
                                      if nValCus > 0
                                         nAP2 -= nValCus
                                      else
                                         nAp2 -= ConvMoeda(SD1->D1_DTDIGIT,,SD1->D1_CUSTO,cMoeda )
                                      endif
                                   Else
                                      nAp2 -=  &("D1_CUSTO"+If((mv_par09==1),"",Str(mv_par09,1)) )
                                   EndIf
                                   If (mv_par09 > 1)
                                      nAp3 -= ConvMoeda(SD1->D1_DTDIGIT,,ValSD1(),cMoeda )
                                      If cPaisLoc = "BRA"
                                         nAp5 -= ConvMoeda(SD1->D1_DTDIGIT,,SD1->D1_TOTAL-SD1->D1_VALDESC+IF(mv_par10 == 1,SD1->D1_VALIPI,0),cMoeda )
                                      Else
                                         nAp5 -= ConvMoeda(SD1->D1_DTDIGIT,,SumTaxSD1(.F.),cMoeda)
                                      EndIf
                                   Else
                                      nAp3 -= ValSD1()
                                      If cPaisLoc="BRA"
                                         nAp5 -= SD1->D1_TOTAL-SD1->D1_VALDESC+IF(mv_par10 == 1,SD1->D1_VALIPI,0)
                                      Else
                                         nAp5-= SumTaxSD1(.F.)
                                      EndIf
                                   EndIF
                                   If mv_par09 > 1
                                      nAp4 -= (SD1->D1_QUANT*ConvMoeda(SB1->B1_DATREF,,SB1->B1_CUSTD,cMoeda))
                                   Else
                                      nAp4 -= (SD1->D1_QUANT*SB1->B1_CUSTD)
                                   EndIF
                                EndIf
                             EndIf
                        Case (mv_par11 == 2) .And. lDevolucao
                             DbSelectArea( "SD1" )
                             If DbSeek( xFilial( "SD1" )+TRB->D2_COD,.F. )
                                Do While !SD1->(Eof()) .And. (D1_COD == cCodAnt)
                                   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                                   //³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal    ³
                                   //³ Despreza Itens em que a TES NAO Se Ajusta a Selecao do Usuario ³
                                   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                   If !(D1_ORIGLAN == "LF") .And. AvalTes(D1_TES,cEstoq,cDupli)
                                      nAp1 -= D1_QUANT
                                      If (mv_par09 > 1)
                                         nValCus :=  &("D1_CUSTO"+If((mv_par09==1),"",Str(mv_par09,1)) )
                                         if nValCus > 0
                                            nAp2 -= nValCus
                                         else
                                            nAp2 -= ConvMoeda( D1_DTDIGIT,,D1_CUSTO,cMoeda )
                                         endif
                                      Else
                                         nAp2 -=  &("D1_CUSTO"+If((mv_par09==1),"",Str(mv_par09,1)) )
                                      EndIf
                                                                                    
                                      If (mv_par09 > 1)
                                         nAp3 -= ConvMoeda( D1_DTDIGIT,,ValSD1(),cMoeda )
                                         If cPaisLoc = "BRA"
                                            nAp5 -= ConvMoeda( D1_DTDIGIT,,SD1->D1_TOTAL-SD1->D1_VALDESC+IF(mv_par10 == 1,SD1->D1_VALIPI,0),cMoeda )
                                         Else
                                            nAp5 -= ConvMoeda( D1_DTDIGIT,,SumTaxSD1(.F.),cMoeda)
                                         EndIf
                                      Else
                                         nAp3 -= ValSD1()
										 If cPaisLoc = "BRA"
                                            nAp5 -= SD1->D1_TOTAL-SD1->D1_VALDESC+IF(mv_par10 == 1,SD1->D1_VALIPI,0)
                                         Else
                                            nAp5 -= SumTaxSD1(.F.)
                                         EndIf
                                      EndIF
                                      If mv_par09 > 1
                                         nAp4 -= (D1_QUANT*ConvMoeda(SB1->B1_DATREF,,SB1->B1_CUSTD,cMoeda))
                                      Else
                                         nAp4 -= (D1_QUANT*SB1->B1_CUSTD)
                                      EndIF
                                   EndIf
                                   dbSelectArea('SD1')
                                   DbSkip( 1 )
                                EndDo
                             EndIf
                             lDevolucao := .F.
                     EndCase
                                        
                     DbSelectArea( "TRB" )
                  EndIf
               EndIF
               DbSelectArea( "TRB" )
               dbSkip()
            EndDo

            If nAp1 != 0 .Or. nAp2 != 0 .Or. nAp3 != 0 .Or. nAp4 != 0
                         
               If li > 55
                  Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
               EndIf
                            
               lPassou := .T.
               nCntImpr++
               @ li,000 PSay cTipant
               @ li,003 PSay cCodAnt
               @ li,019 PSay Substr(SB1->B1_DESC,1,40)
               @ li,060 PSay nAp1 Picture PesqPictQt("D2_QUANT",16)
               @ li,078 PSay SB1->B1_UM
               @ li,081 PSay nAp2 PicTure TM(nAp2,14)
               @ li,097 PSay (nAp2/nAp1) Picture TM(nAp2,14)
               @ li,113 PSay nAp5 PicTure TM(nAp5,14)  // Valor Fat. Bruto
               @ li,128 PSay nAp3 PicTure TM(nAp3,14)
                         
               If nAp3 != 0
                  @ li,144 PSay nAp5-(c02AbaVal(nAp5)) PicTure TM(nAp5,12) //Impostos nao faturados
                  @ li,160 PSay nAp3-(nAp5-(c02AbaVal(nAp5))) PicTure TM(nAp3,14) // Valor Faturado - impostos nao faturados
                  @ li,176 PSay 100*(c02AbaVal(nAp3)-nAp2)/c02AbaVal(nAp3) PicTure "9999.9"  //margem
               EndIf
               If nTotFat != 0
                  @ li,183 PSay 100*c02AbaVal(nAp3)/c02AbaVal(nTotFat) PicTure "9999.9"
               EndIf
               If nTotLuc != 0
                  @ li,190 PSay IIF(nAp3-nAp2>0,"+","-")
                  @ li,191 PSay 100*(c02AbaVal(nAp3)-nAp2)/nTotLuc PicTure "9999.9"
               EndIf
               @ li,199 PSay nAp4 PicTure TM(nAp4,14)
               If nAp2 != 0
                  @ li,214 PSay (100*nAp4/nAp2)-100 PicTure "9999.9"
               EndIf
                            
               li++
               nAt1 += nAp1
               nAt2 += nAp2
               nAt3 += nAp3
               nAt4 += nAp4
               nAt5 += nAp5
            EndIf
         EndIF
         DbSelectArea( "TRB" )
   EndDo
   If lPassou

      @ li,000 PSay "Sub Total : " + cTipant       
      @ li,060 PSay nAt1 Picture PesqPictQt("D2_QUANT",16)
      @ li,081 PSay nAt2 PicTure TM(nAt2,14)
      @ li,097 PSay (nAt2/nAT1) Picture TM(nAt2,14)
      @ li,113 PSay nAt5 PicTure TM(nAt5,14)
      @ li,128 PSay nAt3 PicTure TM(nAt3,14)
      If nAt3#0
         @ li,144 PSay nAt5-(c02AbaVal(nAt5)) PicTure TM(nAp3,12)
         @ li,160 PSay nAt3-(nAt5-(c02AbaVal(nAt5))) PicTure TM(nAp3,14)
         @ li,176 PSay 100*(c02AbaVal(nAt3)-nAt2)/c02AbaVal(nAt3) PicTure "9999.9"
      EndIf
      @ li,183 PSay 100*(c02AbaVal(nAt3))/c02AbaVal(nTotfat) PicTure "9999.9"
      If nTotLuc != 0
         @ li,190 PSay IIF(nAt3-nAt2>0,"+","-")
         @ li,191 PSay 100*(c02AbaVal(nAt3)-nAt2)/nTotLuc PicTure "9999.9"
      EndIF
      @ li,199 PSay nAt4 PicTure tm(nAt4,14)
      If nAt2 != 0
         @ li,214 PSay (100*nAt4/nAt2)-100 PicTure "9999.9"
      EndIF
     
      li += 2
      nAg1 += nAt1
      nAg2 += nAt2
      nAg3 += nAt3
      nAg4 += nAt4
      nAg5 += nAt5
   EndIf
   DbSelectArea( "TRB" )
EndDo
  
If li != 80
   
   @ li,000 PSay "T O T A L ---> "
   @ li,060 PSay nAg1 Picture PesqPictQt("D2_QUANT",16)
   @ li,081 PSay nAg2 PicTure TM(nAg2,14)
   @ li,097 PSay (nAg2/nAg1) Picture TM(nAg2,14)
   @ li,113 PSay nAg5 PicTure TM(nAg5,14)
   @ li,128        PSay nAg3 PicTure TM(nAg3,14)
   If nAg3 != 0
      @ li,144 PSay nAg5-(c02AbaVal(nAg5)) PicTure TM(nAp3,12)
      @ li,160 PSay nAg3-(nAg5-(c02AbaVal(nAg5))) PicTure TM(nAp3,14)
      @ li,176 PSay 100*(c02AbaVal(nAg3)-nAg2)/c02AbaVal(nAg3) PicTure "9999.9"
   EndIF
   If nTotFat != 0
      @ li,183 PSay 100*c02AbaVal(nAg3)/c02AbaVal(nTotFat) PicTure "9999.9"
   EndIF
   If nTotluc != 0
      @ li,190 PSay IIF(nAg3-nAg2>0,"+","-")
      @ li,191 PSay 100*(c02AbaVal(nAg3)-nAg2)/nTotLuc PicTure "9999.9"
   EndIF
   @ li,199 PSay nAg4 PicTure tm(nAg4,14)
   If nAg2#0
      @ li,214 PSay (100*nAg4/nAg2)-100 PicTure "9999.9"
   EndIF
EndIf
  
If li != 80
   Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cString)
Set Filter To
Set Order To 1
If aReturn[5] = 1
 Set Printer To
 dbCommitAll()
 OurSpool(wnrel)
Endif

MS_FLUSH()

DbSelectArea( "SD1" )
RetIndex( "SD1" )

DbSelectArea( "SD2" )
RetIndex( "SD2" )

If mv_par11 <> 3
	dbSelectArea("SD1")
	IF File(cArqSD1+OrdBagExt())
	   Ferase(cArqSD1+OrdBagExt())
	Endif
	dbSetOrder(1)
Endif

If File(cArqSD2+OrdBagExt())
   FErase(cArqSD2+OrdBagExt())
Endif

dbSelectArea("TRB")
dbCloseArea()
If File(cArqTrab+".DBF")
   FErase(cArqTrab+".DBF")    //arquivo de trabalho
Endif
If File(cArqTrb2+OrdBagExt())
  FErase(cArqTrb2+OrdBagExt())
Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  ValSD1  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 20/05/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Soma os valores de acordo com os parametros no arquivo SD1 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST03                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValSD1()
Local nValRet :=0, nImpInc:=0,nImpNoInc:=0
Local aImpostos:={}
If ( cPaisLoc=="BRA" )
  nValRet:=D1_TOTAL-SD1->D1_VALDESC+IF(mv_par10 == 1,D1_VALIPI,0)-IF(mv_par14 == 1,0,D1_VALICM)
ElseIf (mv_par10==1.Or.mv_par14<>1)
  aImpostos:=TesImpInf(SD1->D1_TES)
  For nY:=1 to Len(aImpostos)
     cCampImp:="SD1->"+(aImpostos[nY][2])
     If ( aImpostos[nY][3]=="1" )
         nImpInc  += &cCampImp
     Else
        nImpNoInc+= &cCampImp
     EndIf
  Next
  nValRet:=D1_TOTAL-D1_VALDESC+IF(mv_par10 == 1,nImpInc,0)-IF(mv_par14 == 1,0,nImpNoInc)
Else
  nValRet:=D1_TOTAL-D1_VALDESC
EndIf

RETURN nValRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  ValSD2  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 20/05/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Soma os valores de acordo com os parametros no arquivo SD2 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST03                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValSD2()
Local nValRet :=0, nImpInc:=0,nImpNoInc:=0
Local aImpostos:={}
 
If ( cPaisLoc=="BRA" )
  nValRet:=TRB->D2_TOTAL+IF(mv_par10 == 1,TRB->D2_VALIPI,0)-IF(mv_par14 == 1,0,TRB->D2_VALICM)
ElseIf (mv_par10==1.Or.mv_par14<>1)
  aImpostos:=TesImpInf(TRB->D2_TES)
  For nY:=1 to Len(aImpostos)
     cCampImp:="TRB->"+(aImpostos[nY][2])
     If ( aImpostos[nY][3]=="1" )
        nImpInc  += &cCampImp
      Else
         nImpNoInc+= &cCampImp
     EndIf
  Next
  nValRet:=TRB->D2_TOTAL+IF(mv_par10 == 1,nImpInc,0)-IF(mv_par14 == 1,0,nImpNoInc)
Else
   nValRet:=TRB->D2_TOTAL
EndIf
 
RETURN nValRet
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o   ³c02AbaVal³Autor³Patricia A. Salomao       ³ Data ³17.11.00  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o³Abate % dos Impostos nao Faturados do Valor da Venda         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro³ExpN1        : Valor Base p/ Abatimento                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso     ³JMHEST03                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function c02AbaVal(nValor)
LOCAL perc := mv_par16
If mv_par15 == 2
   nValor := nValor - (nValor * perc /100)
EndIf
Return(nValor)
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GeraTrab  ³ Autor ³Patricia A. Salomao    ³ Data ³ 11/01/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Arquivo de Trabalho                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraTrab(cAlias)
  
Local nPosFirst, nCpos
  
dbSelectArea(cAlias)
dbGoTop()
Do While !Eof() .And. &(Subs(cAlias,2,2)+"_FILIAL") == xFilial()
   If cAlias == "SD2" 
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Executa a validacao do filtro do usuario                    ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If !Empty(aReturn[7]) .And. !&(aReturn[7])
         dbSkip()
         Loop
      EndIf   
   EndIf
    //  So' deverao entrar no "Arquivo de Trabalho", as NF's de Devolucao, que nao tenham suas NF's Originais emitidas no mesmo periodo.
	If cAlias == "SD1" .AND. TRB->(dbSeek(SD1->D1_FILIAL+SD1->D1_TP+SD1->D1_COD+SD1->D1_NFORI+SD1->D1_SERIORI)) .And. TRB->D2_TIPO == "N"
	   dbSkip()
	   loop
	EndIf     
	Reclock("TRB",.T.)
	Replace TRB->D2_FILIAL  With &(cAlias+"->"+Subs(cAlias,2,2)+"_FILIAL")
	Replace TRB->D2_COD     With &(cAlias+"->"+Subs(cAlias,2,2)+"_COD")
	Replace TRB->D2_LOCAL   With &(cAlias+"->"+Subs(cAlias,2,2)+"_LOCAL")
	Replace TRB->D2_SERIE   With &(cAlias+"->"+Subs(cAlias,2,2)+"_SERIE")
	Replace TRB->D2_TES     With &(cAlias+"->"+Subs(cAlias,2,2)+"_TES")
	Replace TRB->D2_TP      With &(cAlias+"->"+Subs(cAlias,2,2)+"_TP")
	Replace TRB->D2_EMISSAO With &(cAlias+"->"+Subs(cAlias,2,2)+"_EMISSAO")
	Replace TRB->D2_TIPO    With &(cAlias+"->"+Subs(cAlias,2,2)+"_TIPO")
	Replace TRB->D2_DOC     With &(cAlias+"->"+Subs(cAlias,2,2)+"_DOC")
	Replace TRB->D2_QUANT   With &(cAlias+"->"+Subs(cAlias,2,2)+"_QUANT")
	Replace TRB->D2_TOTAL   With &(cAlias+"->"+Subs(cAlias,2,2)+"_TOTAL")
	Replace TRB->D2_VALIPI  With &(cAlias+"->"+Subs(cAlias,2,2)+"_VALIPI")
	Replace TRB->D2_VALICM  With &(cAlias+"->"+Subs(cAlias,2,2)+"_VALICM")
	Replace TRB->D2_ITEM    With &(cAlias+"->"+Subs(cAlias,2,2)+"_ITEM")
	Replace TRB->D2_ORIGLAN With &(cAlias+"->"+Subs(cAlias,2,2)+"_ORIGLAN")
	If cAlias == "SD2"
	   Replace TRB->D2_CUSTO With &(cAlias+"->"+Subs(cAlias,2,2)+"_CUSTO"+Str(mv_par09,1))
	Else
	   Replace TRB->D2_CUSTO With &(cAlias+"->"+Subs(cAlias,2,2)+"_CUSTO"+If((mv_par09==1),"",Str(mv_par09,1)))
	EndIf
	If cPaisLoc<>"BRA"  
	   nPosFirst := AScan(aCampos,{|x| "D2_VALIMP"$Alltrim(x[1]) .or. "D2_BASIMP"$AllTrim(x[1])})
	   For nCpo := nPosFirst to Len(aCampos)
	       If "D2_VALIMP"$aCampos[nCpo][1] .or. "D2_BASIMP"$aCampos[nCpo][1]
    	      Replace TRB->&(aCampos[nCpo][1]) With &(cAlias+"->"+Substr(cAlias,2,2)+Substr(aCampos[nCpo][1],3,8))
	       EndIf
	   Next
	EndIf
	MsUnlock()
	dbSelectArea(cAlias)
	DbSkip()
EndDo
TRB->(dbGoTop())
Return
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SumTaxSD2 ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 20/05/97 ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Soma os valores de acordo com os parametros no arquivo SD2 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST03                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SumTaxSD2(lNoInc)
Local nValRet     :=0, nImpInc:=0,nImpNoInc:=0
Local aImpostos:={}
 
If ( cPaisLoc=="BRA" )
   If lNoInc
      nValRet:=TRB->D2_TOTAL+IF(mv_par10 == 1,TRB->D2_VALIPI,0)-IF(mv_par14 == 1,0,TRB->D2_VALICM)
   Else
      nValRet:=TRB->D2_TOTAL+IF(mv_par10 == 1,TRB->D2_VALIPI,0)
   EndIf
Else
   aImpostos:=TesImpInf(TRB->D2_TES)
   For nY:=1 to Len(aImpostos)
       cCampImp:="TRB->"+(aImpostos[nY][2])
       If ( aImpostos[nY][3]=="1" )
          nImpInc  += &cCampImp
       Else
          nImpNoInc+= &cCampImp
       EndIf
   Next
   If lNoInc
      nValRet:=TRB->D2_TOTAL+IF(mv_par10 == 1,nImpInc,0)-IF(mv_par14 == 1,0,nImpNoInc)
   Else
      nValRet:=TRB->D2_TOTAL+IF(mv_par10 == 1,nImpInc,0)      
   EndIf
EndIf
RETURN nValRet
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SumTaxSD1 ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 20/05/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Soma os valores de acordo com os parametros no arquivo SD1 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ JMHEST03                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SumTaxSD1(lNoInc)
Local nValRet     :=0, nImpInc:=0,nImpNoInc:=0
Local aImpostos:={}
If ( cPaisLoc=="BRA" )
   If lNoInc
      nValRet:=D1_TOTAL+IF(mv_par10 == 1,D1_VALIPI,0)-IF(mv_par14 == 1,0,D1_VALICM)
   Else
      nValRet:=D1_TOTAL+IF(mv_par10 == 1,D1_VALIPI,0)
   EndIf
Else
   aImpostos:=TesImpInf(SD1->D1_TES)
   For nY:=1 to Len(aImpostos)
       cCampImp:="SD1->"+(aImpostos[nY][2])
       If ( aImpostos[nY][3]=="1" )
           nImpInc  += &cCampImp
       Else
          nImpNoInc+= &cCampImp
       EndIf
   Next
   If lNoInc
      nValRet:=D1_TOTAL+IF(mv_par10 == 1,nImpInc,0)-IF(mv_par14 == 1,0,nImpNoInc)
   Else
      nValRet:=D1_TOTAL+IF(mv_par10 == 1,nImpInc,0)
   EndIf
EndIf
  
RETURN nValRet
