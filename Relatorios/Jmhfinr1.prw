#include "JMHFINR1.CH"
#Include "protheus.ch"
#include "sigawin.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ JMHFINR1  ³ Autor ³ Reiner Trennepohl    ³ Data ³ 22.11.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Di rio Sint‚tico em Aberto por Natureza                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ JMHFINR1(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±                                                                         ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function JMHFINR1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1 :=OemToAnsi(STR0001)  //"Emiss„o do Relat¢rio Di rio Sint‚tico por Natureza. Ser  usado a"
LOCAL cDesc2 :=OemToAnsi(STR0002)  //"a data-base do sistema como ponto de partida."
LOCAL cDesc3 :=""
LOCAL cString:="SE7"
LOCAL limite := 80
Local nMoeda, cTexto

PRIVATE Titulo  := ""
PRIVATE cabec1  := ""
PRIVATE cebec2  := ""
PRIVATE tamanho := "G"
PRIVATE aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:= "JMHFINR1"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := PadR("FINJM1",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
PRIVATE nColun   := 0  // Controle de colunas (substitui pCol())
PRIVATE dDtValid1 := dDataBase
PRIVATE dDtValid2 := dDataBase
PRIVATE dUltDia   := ddataBAse

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li       := 80
m_pag    := 1

//AjustaSx1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parƒmetros                        ³
//³ mv_par01               Da Natureza                          ³
//³ mv_par02               At‚ a Natureza                       ³
//³ mv_par03               N£mero de dias                       ³
//³ mv_par04               Moeda                                ³
//³ mv_par05               Cons.Ped.Compra 1=Sim,2=nao FMQ201   ³
//³ mv_par06               Cons.Ped.Vda. 1=Sim,2=Nao   FMQ201   ³
//³ mv_par07               N¡veis de quebra                     ³
//³ mv_par08               Considera Data Base                  ³
//³ mv_par09               Considera Abatimentos                ³
//³ mv_par10               Considera Filiais                    ³
//³ mv_par11               Filial De                            ³
//³ mv_par12               Filial Ate                           ³ 
//³ mv_par13               Tipo do Relatorio 1=Previsto,2=Realizado
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo := OemToAnsi(STR0005)  //"Diario Sintetico por Natureza"
cabec1 := OemToAnsi(STR0006)  //"Diario Sintetico Por Natureza"
cabec2 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "JMHFINR1"            //Nome Default do relat¢rio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif
   
nMoeda	:= mv_par04
If MV_PAR13 == 1
	cTexto	 := " - " + GetMv("MV_MOEDA"+Str(nMoeda,1)) + " - " + "Previsto"
	dDtValid1:= "SE1->E1_VENCREA" 
	dDtValid2:= "SE2->E2_VENCREA"
Else  
    cTexto	  := " - " + GetMv("MV_MOEDA"+Str(nMoeda,1)) + " - " + "Realizado" 
	dDtValid1 := "SE1->E1_BAIXA" 
	dDtValid2 := "SE2->E2_BAIXA" 
EndIf	
Titulo	+= cTexto

#IFDEF WINDOWS
	RptStatus({|lEnd| Fa200Imp(@lEnd,wnRel,cString)},Titulo)
#ELSE
	fa200Imp(.f.,Wnrel,cString)
#ENDIF
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FA200IMP ³ Autor ³ Reiner Trennepohl     ³ Data ³ 22.11.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Di rio Sint‚tico em Aberto por Natureza                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA200Imp(lEnd,wnRel,cString)
LOCAL cbCont:=0,CbTxt:=Space(10)
LOCAL nSaldoTit := 0
LOCAL nValPago  := 0
LOCAL aNiveis  := {}
LOCAL aQuebras := {}
LOCAL nLaco := 0
LOCAL nByte := 0
LOCAL cMapa := ""
LOCAL nLimBreak := 0
LOCAL dData := cTod("")
LOCAL nBancos := 0
LOCAL nCaixas := 0
LOCAL nAplicacao := 0
Local nEmprestimo:= 0
LOCAL lPrimeiraPagina := .T.
LOCAL aVenc,nValor,ni,cNatur,dDataIni
LOCAL nSavRec := 0
LOCAL lHaMovto := .F.
LOCAL lMovNat	:= .F.
LOCAL nOutroLaco := 0
LOCAL aSemana := {OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010),;     //"Domingo"###"Segunda"###"Terca  "###"Quarta "
				  OemToAnsi(STR0011),OemToAnsi(STR0012),OemToAnsi(STR0013) }              //"Quinta "###"Sexta  "###"Sabado "
LOCAL aCalc   := {}
Local aDtCabec := {}		// array das datas do cabecalho de dias
Local nBlocOld := 0		// controla bloco anterior p/imprimir cabecalho de dias
Local dDataCabec := dDataBase
Local dDtMovim := dDataBase
Local cBancoCx
LOCAL lSaldoDia:= .F.
LOCAL lResulDia:= .F.
Local nRegEmp:=SM0->(RecNo())
LOCAL cFilDe ,;
	  cFilAte,;
	  cNatAnt,;
	  bNatureza := { || IF( mv_par10 == 1, .T., SED->ED_FILIAL == xFilial("SED") .AND.;
	  							                       SED->ED_CODIGO <= mv_par02 ) }

cBancoCx := GetMV("MV_CARTEIR")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lˆ a formata‡„o do c¢digo das naturezas   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMascNat := GetMV("MV_MASCNAT")
cMapa    := "123456789"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida limite de quebra.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 >= Len( cMascNat )
	mv_par07 := Len( cMascNat ) - 1
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par10 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par11	// Todas as filiais
	cFilAte:= mv_par12
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arquivo de Trabalho      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos:={	{"NATUR"  , "C" , Len(SED->ED_CODIGO),0},;
			{"DESCR"  , "C" , 30,0},;
			{"DTBAS"  , "D" , 08,0},;
			{"ENTRA"  , "N" , 17,2},;
			{"SAIDA"  , "N" , 17,2} }
			
cArqTmp := CriaTrab(aCampos)
dbUseArea( .T.,, cArqTmp, "cArqTmp", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua ( "cArqTmp",cArqTmp,"DTOS(DTBAS)+NATUR",,,OemToAnsi(STR0014))  //"Selecionando Registros..."
SM0->(dbSeek(cEmpAnt+cFilDe,.T.))
nCaixas := nBancos := 0
// Verifica a última data do relatório
dUltData := dDataBase
dUltDia  := dUltDia + MV_PAR03
FOR nBlocos := 1 TO mv_par03 STEP 8
   For nOutroLaco := 1 TO 8
      // No Primeiro bloco, considera apenas 7 dias, pois a primeira coluna
		// refere-se aos atrasos.
      IF nBlocos == 1 .AND. nOutroLaco == 7
         EXIT
      ENDIF
      dUltData++
      While Dow(dUltData) == 1 .or. Dow(dUltData) == 7
	      dUltData++
	   Enddo
   Next   
NEXT
DO WHILE SM0->(!Eof())             .AND.;
	     SM0->M0_CODIGO == cEmpAnt .AND.;
 	     SM0->M0_CODFIL <= cFilAte 

   cFilAnt := SM0->M0_CODFIL
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³Verifica se existe Operacao Financeira a ser resgatada no dia ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   
   dbSelectArea("SEH")
   dbSetOrder(2)
   dbSeek(xFilial("SEH")+"A",.T.)
   While ( !Eof() .And. SEH->EH_FILIAL == xFilial("SEH") .And. SEH->EH_STATUS == "A" )
      aCalc := Fa171Calc(dDataBase+MV_PAR03)
      If ( SEH->EH_APLEMP == "EMP" )
         nEmprestimo += xMoeda(aCalc[2,1],1,mv_par04)
      Else
         nAplicacao += xMoeda(aCalc[1],1,mv_par04)
      EndIf
      
      dbSelectArea("SEH")
      dbSkip()
   EndDo
   
   dbSelectArea("SEH")
   dbSetOrder(1)
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica disponibilidade banc ria                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   
   dbSelectArea("SA6")
   dbSeek(cFilial)
   While ! Eof() .and. SA6->A6_FILIAL == cFilial
      IF SA6->A6_FLUXCAI == "N"
         dbSkip()
         Loop
      Endif
      IF SubStr(SA6->A6_COD,1,2) = "CX" .or. SA6->A6_COD $ cBancoCx
         nCaixas += RecSalBco(SA6->A6_COD,SA6->A6_AGENCIA,SA6->A6_NUMCON,dDataBase)
      Else
         nBancos += RecSalBco(SA6->A6_COD,SA6->A6_AGENCIA,SA6->A6_NUMCON,dDataBase)
      EndIf
      dbSelectArea("SA6")
      dbSkip()
   Enddo
   nBancos := xMoeda(nBancos,1,mv_par04)
   nCaixas := xMoeda(nCaixas,1,mv_par04)

   SE1->(dbSetOrder(3)) // Ordem por natureza
   SE2->(dbSetOrder(2)) // Ordem por natureza

   dbSelectArea("SED") 
   SetRegua(RecCount())
   dbSeek( xFilial("SED") + mv_par01 , .T. )
 

   While !Eof() .and. SED->ED_FILIAL==xFilial("SED") .and. SED->ED_CODIGO <= mv_par02

      IncRegua()
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Analiza as entradas daquela natureza ³
      //³ A Realizar !!!                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      nEntr     := nSaid     := 0
      nRealEntr := nRealSaid := 0
      
	   dbSelectArea("SE1")
	   dbSeek(xFilial("SE1")+SED->ED_CODIGO)
	   While !Eof() .and. SE1->E1_FILIAL==xFilial("SE1") .and. SE1->E1_NATUREZ==SED->ED_CODIGO
			#IFNDEF WINDOWS
				Inkey()
				If LastKey() == K_ALT_A
					lEnd := .t.
				EndIf
			#ENDIF
            If MV_PAR13 == 1
		   		If  SE1->E1_EMISSAO > dDataBase .or. Subs(SE1->E1_TIPO,3,1)  == "-" .OR. SE1->E1_SITUACA $ "27"
			 		dbSkip()
			   		Loop
		  		Endif
            Else 
            	If Empty(SE1->E1_BAIXA) .or. SE1->E1_BAIXA >= dUltDia .Or. Subs(SE1->E1_TIPO,3,1)  == "-" .OR. SE1->E1_SITUACA $ "27"
			  		dbSkip()
			 		Loop
		   		Endif
            EndIF
			If SE1->E1_FLUXO == "N"
				dbSkip()
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se considera ou nÆo adiantamentos		  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par09 == 2 .and. SE1->E1_TIPO $ "RA #NCC"
				dbSkip()
				Loop
			Endif
			If &dDtValid1 < dDataBase   // dDtValid1 = E1_VENCREA / E1_BAIXA
			   dDataTrab := dDataBase - 1	
			Else
			   dDataTrab := DataValida(&dDtValid1,.T.)  
			Endif
			IF dDataTrab > dUltData
				DBSKIP()
				LOOP
			Endif 
			If MV_PAR13 == 1
				If mv_par08 == 1
				   nSaldoTit := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,;
				    	                  SE1->E1_TIPO,SE1->E1_NATUREZA,"R",SE1->E1_CLIENTE,1,,,SE1->E1_LOJA)
				Else
				   nSaldoTit := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,mv_par04)
				Endif                                                        
				IF nSaldoTit > 0
				   nSaldoTit -=SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1)
				ENDIF	      
			Else                
			   If SE1->E1_VALOR # SE1->E1_SALDO 
			      // nSaldoTit == Valor Pago qdo relatorio Tipo Realizado 
			      nSaldoTit := xMoeda(SE1->E1_VALLIQ + SE1->E1_CORREC + SE1->E1_MULTA + SE1->E1_JUROS,SE1->E1_MOEDA,mv_par04)
			   Else
			      nSaldoTit := 0.00
			   EndIf      
			EndIf	
			If Abs(nSaldoTit) > 0.0001
			
				dbSelectArea( "cArqTmp" )
				If !(dbSeek(dTos(dDataTrab)+SED->ED_CODIGO))
					RecLock("cArqTmp",.T.)
					cArqTmp->NATUR := SED->ED_CODIGO
					cArqTmp->DESCR := SED->ED_DESCRIC
					cArqTmp->DTBAS := dDataTrab
				Else
					RecLock("cArqTmp")
				Endif

				If Substr(SE1->E1_TIPO,3,1) == "-" .OR. SE1->E1_TIPO $ "RA /"+MV_CRNEG
					cArqTmp->ENTRA -= nSaldoTit
				Else
					cArqTmp->ENTRA += nSaldoTit
				Endif
			Endif
			
			dbSelectArea("SE1")
			dbSkip()
		Enddo
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Analiza as Saidas daquela natureza ³
      //³ A Realizar !!!                     ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE2")
		dbSeek(xFilial("SE2")+SED->ED_CODIGO)
		While !Eof() .and. SE2->E2_FILIAL==xFilial("SE2") .and. SE2->E2_NATUREZ==SED->ED_CODIGO

			#IFNDEF WINDOWS
				Inkey()
				If LastKey() = K_ALT_A
					lEnd := .t.
				EndIf
			#ENDIF
            If MV_PAR13 == 1
				If SE2->E2_EMISSAO > dDataBase .or. Subs(SE2->E2_TIPO,3,1) == "-"
	   				dbSkip()
	   				Loop
				Endif
  			Else 
            	If Empty(SE2->E2_BAIXA) .or. SE2->E2_BAIXA >= dUltDia .Or. Subs(SE1->E1_TIPO,3,1)  == "-" .OR. SE1->E1_SITUACA $ "27"
			  		dbSkip()
			 		Loop
		   		Endif
            EndIF
			If SE2->E2_FLUXO == "N"
				dbSkip()
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se considera ou nÆo adiantamentos		  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par09 == 2 .and. SE2->E2_TIPO $ "PA #NDF"
				dbSkip()
				Loop
			Endif 
			If &dDtValid2 < dDataBase   // dDtValid2 = E2_VENCREA / E2_BAIXA
				dDataTrab := dDataBase - 1
			Else
				dDataTrab := DataValida(&dDtValid2,.T.)
			Endif
			IF dDataTrab > dUltData
				DBSKIP()
				LOOP
			Endif  
			If MV_PAR13 == 1
				If mv_par08 == 1
					nSaldoTit := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
						SE2->E2_TIPO,SE2->E2_NATUREZA,"P",SE2->E2_FORNECE,1,,,SE2->E2_LOJA)
				Else
					nSaldoTit := xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,mv_par04)
				Endif
    	        IF nSaldoTit > 0
				   nSaldoTit -= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1)
				ENDIF	
			Else                
			   If SE2->E2_VALOR # SE2->E2_SALDO 
			      // nSaldoTit == Valor Pago qdo relatorio Tipo Realizado 
			      nSaldoTit := xMoeda(SE2->E2_VALLIQ + SE2->E2_CORREC + SE2->E2_MULTA + SE2->E2_JUROS,SE2->E2_MOEDA,mv_par04)
			   Else
			      nSaldoTit := 0.00
			   EndIf      
			EndIf		
			If Abs(nSaldoTit) > 0.0001
				dbSelectArea( "cArqTmp" )
				If !(dbSeek(dTos(dDataTrab)+SED->ED_CODIGO))
					RecLock("cArqTmp",.T.)
					cArqTmp->NATUR := SED->ED_CODIGO
					cArqTmp->DESCR := SED->ED_DESCRIC
					cArqTmp->DTBAS := dDataTrab
				Else
					RecLock("cArqTmp")
				Endif

				If Substr(SE2->E2_TIPO,3,1) == "-" .OR. SE2->E2_TIPO $ "PA /"+MV_CPNEG
					cArqTmp->SAIDA -= nSaldoTit
				Else
					cArqTmp->SAIDA += nSaldoTit
				Endif
			Endif
			dbSelectArea("SE2")
			dbSkip()
		Enddo
      dbSelectArea("SED")
      dbSkip()
   Enddo
   If mv_par05 == 1
      dbSelectArea("SC7")
      dbSeek(cFilial)
      While !Eof() .and. cFilial == C7_FILIAL

         If !Empty(C7_RESIDUO)
            dbSkip()
            Loop
         Endif

         If ( SC7->C7_FLUXO != "N" )
            nValor := C7_PRECO * (C7_QUANT-C7_QUJE) * (1+C7_IPI/100)
            dbSelectArea("SA2")
            dbSeek(cFilial+SC7->C7_FORNECE)
            cNatur := SA2->A2_NATUREZ
            If cNatur >= mv_par01 .and. cNatur <= mv_par02
               dbSelectArea("SED")
               dbSetOrder(1)
               If (dbSeek(cFilial+cNatur))
                  If nValor > 0
                     dDataIni := IIF(SC7->C7_DATPRF < dDataBase,dDataBase,SC7->C7_DATPRF)
                     aVenc := Condicao ( nValor,SC7->C7_COND,0,dDataIni)
                     nValor := nValor / len(aVenc)
                     For ni := 1 to Len(aVenc)
                        IF DataValida(aVenc[ni][1],.T.) <= dUltData 
                           dbSelectArea("cArqTmp")
                           IF dbSeek(dTos(DataValida(aVenc[ni][1],.T.))+SED->ED_CODIGO)
                              RecLock("cArqTmp")
                           Else
                              RecLock("cArqTmp",.T.)
                              cArqTmp->NATUR := cNatur
                              cArqTmp->DTBAS := DataValida(aVenc[ni][1],.T.)
                              cArqTmp->DESCR := SED->ED_DESCRIC
                           Endif
                           cArqTmp->SAIDA += nValor
                           msUnlock()
                        Endif
                     Next
                  Endif
               Endif
            EndIf
         Endif   
         dbSelectArea("SC7")
         dbSkip()
      Enddo
   Endif
   If mv_par06 == 1
      dbSelectArea("SC6")
      dbSeek(cFilial)
      While !Eof() .and. cFilial == C6_FILIAL
         // Se for residuo ou se o TES nao gera duplicata, despreza o registro		
         If Alltrim(C6_BLQ) == "R" .OR.;
			   (SF4->(DBSEEK(xFilial()+SC6->C6_TES)) .AND.;
				 SF4->F4_DUPLIC == "N")
            dbSkip()
            Loop
         Endif
         nValor := C6_PRCVEN * (C6_QTDVEN-C6_QTDENT)
         dbSelectArea("SA1")
         dbSeek(cFilial+SC6->C6_CLI)
         cNatur := SA1->A1_NATUREZ
         IF cNatur >= mv_par01 .and. cNatur <= mv_par02
            dbSelectArea("SED")
            dbSetOrder(1)
            If (dbSeek(xFilial()+cNatur))
               SC5->(dbSeek(xFilial("SC5")+SC6->C6_NUM))
               If nValor > 0 .and. SC5->C5_TIPO == "N"
                  dbSelectArea("SB1")
                  dbSeek(cFilial + SC6->C6_PRODUTO)
                  nValor *= (1+SB1->B1_IPI/100)
                  dDataIni := IIF(SC6->C6_ENTREG < dDataBase,dDataBase,SC6->C6_ENTREG)
                  aVenc := Condicao ( nValor,SC5->C5_CONDPAG,0,dDataIni)
                  nValor := nValor / len(aVenc)
                  For ni := 1 to Len(aVenc)
                     If DataValida(aVenc[ni][1],.T.) <= dUltData
                        dbSelectArea("cArqTmp")
                        IF dbSeek(DtoS(DataValida(aVenc[ni][1],.T.))+SED->ED_CODIGO)
                           RecLock("cArqTmp")
                        Else
                           RecLock("cArqTmp",.T.)
                           cArqTmp->NATUR := cNatur
                           cArqTmp->DESCR := SED->ED_DESCRIC
                           cArqTmp->DTBAS := DataValida(aVenc[ni][1],.T.)
                        Endif
                        cArqTmp->ENTRA += nValor
                        msUnlock()
                     Endif
                  Next
               Endif
            Endif
         Endif   
         dbSelectArea("SC6")
         dbSkip()
      Enddo
   Endif
   SM0->( DBSKIP() )
ENDDO
SM0->(dbGoTo(nRegEmp))
cFilAnt := SM0->M0_CODFIL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura os arquivos de contas a receber / pagar para auxiliar ³
//³ an lise do se5 caso seja escolhido regime de caixa             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SE1")
Set Filter To
RetIndex("SE2")
Set Filter To

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Esta matriz informa em que posi‡”es ser„o feitas as quebras.   ³
//³ 1-Byte inicial da quebra, 2-Quantidade de caracteres.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aNiveis  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Esta matriz ANIVEIS estrutura os ponteiros usados na      ³
//³ verifica‡Æo de quebras de naturezas.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLaco := 1 to len( cMascNat )
	nByte := Val( Substr( cMascNat,nLaco,1 ) )
	If nByte > 0
		AAdd( aNiveis  , { Val(Left(cMapa,1)) , nByte} )
		cMapa := Subst(cMapa,nByte+1,Len(cMapa)-nByte)
	Endif
Next
nLimBreak := IIf(Len(aNiveis) > 1, Len(aNiveis)-1, 1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ nLimite armazena o n¡vel de quebra m ximo. Caso o Usu rio   ³
//³ parametrize um limite menor, ‚ respeitado o parƒmetro do    ³
//³ usu rio.                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 > 0 .and. mv_par07 < nLimBreak
	nLimBreak := mv_par07
Endif

If mv_par07 == 0
	nLimBreak := 1
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Cria a principal matriz para verificar      ³
//³  quebras e imprimir valores.                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMultpl8 :=  IIf(mv_par03 > 8, Int ( mv_par03 / 8 ) + 1, 1)
nMultpl8 *= 8
nMultpl8 += 2
aQuebras := Array( Len(aNiveis), nMultpl8 )
For nLaco := 1 to Len( aQuebras )
	aQuebras[nLaco,1] := ""
	For nDias := 2 to nMultpl8
		aQuebras[nLaco,nDias] := 0
	Next
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o relat¢rio a partir do arquivo tempor rio  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nBlocos   := 0
nHeader   := 0
nDias     := 0
nDays		 := 2  // dias para controle da coluna de atraso e database
dDataTrab := dDataBase
nValor    := 0
aTotDia   := { 0,0,0,0,0,0,0 }
cLinha    := "|" + Replicate("-",47) + "|" + Replicate("-----------------|",9)
nTotLinha := 0
nSaldoDoDia := 0

IF mv_Par10 == 1
   cIndex := CriaTrab(nil,.f.)
   dbSelectArea("SED")
   IndRegua("SED",cIndex,"ED_CODIGO",,,OemToAnsi(STR0014))  //"Selecionando Registros..."
   nIndex := RetIndex("SED")
   dbSelectArea("SED")
   #IFNDEF TOP
      SED->(dbSetIndex(cIndex+OrdBagExt()))
   #ENDIF
   SED->(dbSetOrder(nIndex+1))
   SED->(dbGoTop())
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o relat¢rio a partir do arquivo tempor rio  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lPrimeiraPagina := .T.
dData := cTod("")
aTotais := {0,0}
dbSelectArea("cArqTmp")
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Avan‡a blocos de 8 em 8 dias. Caso o n£mero de dias for menor      ³
//³ que sete ou nÆo for m£ltiplo de 8, nÆo h  problema, pois o         ³
//³ arquivo tempor rio nÆo armazenar  datas fora do n£mero de dias     ³
//³ selecionados.                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nBlocos := 1 to mv_par03 Step 8

	#IFNDEF WINDOWS
		Inkey()
		If LastKey() == K_ALT_A
			lEnd := .t.
		Endif
	#ENDIF

	If li > 58
		cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")) )
		If lPrimeiraPagina
			lPrimeiraPagina := .F.
			Li++
			@LI++,00 PSAY OemToAnsi(STR0015)  //"SALDO EM CAIXA      : "
			@Prow(),23 PSAY nCaixas    Picture tm(nCaixas,14) //"@E 999,999,999.99"
			@LI++,00 PSAY OemToAnsi(STR0016)  //"SALDO EM BANCOS     : "
			@Prow(),23 PSAY nBancos    Picture tm(nBancos,14) //"@E 999,999,999.99"
			@LI++,00 PSAY OemToAnsi(STR0017)  //"SALDO EM APLICACOES : "
			@Prow(),23 PSAY nAplicacao Picture tm( nAplicacao,14) //"@E 999,999,999.99"
			@LI++,00 PSAY OemToAnsi(STR0018)  //"SALDO EM EMPRESTIMOS: "
			@Prow(),23 PSAY nEmprestimo Picture tm(nEmprestimo,14) //"@E 999,999,999.99"

			nSaldoDoDia += nBancos
			nSaldoDoDia += nCaixas
			nSaldoDoDia += nAplicacao
			nSaldoDoDia -= nEmprestimo

			@LI++,00 PSAY OemToAnsi(STR0019)  //"TOTAL DO DISPONIVEL : "
			@Prow(),23 PSAY nSaldoDoDia Picture tm(nSaldoDoDia,14) //"@E 999,999,999.99"
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Desenha sempre os cabe‡alhos de data pois o la‡o s¢ passar       ³
	//³  por aqui quando quebrar a data.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nBlocos > 1
		++li
	Endif
	Fin200Cabec(nBlocos,nHeader,aSemana,@aDtCabec,@nBlocOld,@dDataCabec)

	aTotDia := { 0,0,0,0,0,0,0,0 }
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura as naturezas nos dias abrangidos     ³
	//³ Por nBlocos (Acima) e nDias (Abaixo)         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   DBSELECTAREA("SED")
	if mv_par10 == 1
	   SED->(dbSetOrder(nIndex+1))
	   If !Empty(mv_par01)
	      SED->(dbSeek( mv_par01 ))
	   Else
	      SED->(dbGoTop())
	   Endif
	else
	   SED->(dbSetOrder(1))
	   If !Empty(mv_par01)
	      SED->(dbSeek( xFilial("SED")+mv_par01 ))
	   Else
	      SED->(dbseek( xFilial("SED") ))
	   Endif
	endif   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o aspecto VERTICAL do relat¢rio, sempre em blocos de 8 dias   ³
	//³ definidos pelo la‡o nBlocos acima definido.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While SED->(!Eof()) .AND. EVAL( bNatureza )

      cNatAnt := SED->ED_CODIGO

 	   If li > 58
			If !lSaldoDia .or. !lResulDia
				@++li,00 PSAY cLinha
			Endif
			Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")) )
			Fin200Cabec(nBlocos,nHeader,aSemana,@aDtCabec,@nBlocOld,@dDataCabec)
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se houve movimenta‡Æo d'aquela natureza para imprimir ou   ³
		//³ nÆo a linha contendo aquela natureza.                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("cArqTmp")
		lHaMovto := .F.
		dDtMovim := dDataBase - 1
		For nOutroLaco := 0 to mv_par03
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a data que se busca movimentacao nao ‚ a data  ³
			//³ referente aos atrasos ou DataBase. Caso seja, nao verifica ³
			//³ se a mesma ‚ Sabado ou Domingo pois ser  impresso na coluna³
			//³ de atrasos ou database.												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If dDtMovim > dDataBase
				While Dow(dDtMovim) == 1 .or. Dow(dDtMovim) == 7
					dDtMovim++
				Enddo
			Endif
			If dbSeek(dTos(dDtMovim)+SED->ED_CODIGO )
				If cArqTmp->ENTRA !=0 .or. cArqTmp->SAIDA !=0
					lHaMovto := .T.
					lMovNat	:= .T.
					Exit
				Endif
			Endif
			dDtMovim++
		Next
		If !lHaMovto
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  Inicia a matriz acumuladora de quebras  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nLaco := 1 to Len( aQuebras )
				aQuebras[nLaco,1] := Subst( SED->ED_CODIGO,aNiveis[nLaco,1],aNiveis[nLaco,2] )
			Next
			dbSelectArea("SED")
         	DO WHILE SED->ED_CODIGO == cNatAnt
            	dbSkip()
	        ENDDO
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  Verifica se houve quebra em algum n¡vel ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			f200totnat(nLimBreak,aQuebras,aNiveis,@lMovNat)
			Loop
		Endif

		// Se for n¡vel 0 o relat¢rio ser  sint‚tico.
		If mv_par07 > 0
			lSaldoDia := .F.
			lResulDia := .F.
			@++li,00 PSAY  "|" + Trim(Mascnat(SED->ED_CODIGO) + ' ' + Left(SED->ED_DESCRIC,30) )
			@li,48   PSAY  "|"
		Endif
		dbSelectArea("cArqTmp")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta o aspecto HORIZONTAL do Relat¢rio.               ³
		//³ Caso nÆo encontre a data, imprime espa‡os em branco    ³
		//³ para manter o alinhamento.                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotLinha := 0 
		nDays := 2
		For nDias := 1 to 8
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso seja primeiro bloco, procura pelos atrasos e valo-³
			//³ res referentes a data base, Qdo Relatorio for Previsto.³
			// Qdo For Relatorio Realizado, os Valores referem-se aos 
			// pagamentos ja efetuados, nao fazendo parte do saldo dos 
			// dias selecionados
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nBlocos == 1 .and. nDias < 3
				If dbSeek( dTos(dDaTaBase+1-nDays) + SED->ED_CODIGO )
					nValor := xMoeda( cArqTmp->ENTRA - cArqTmp->SAIDA,1,mv_par04 )
					aTotDia[ nDias ] += xMoeda(cArqTmp->ENTRA,1,mv_par04) - xMoeda(cArqTmp->SAIDA,1,mv_par04)
					If MV_PAR13 == 1 .Or. nDias == 2 
					   nTotLinha += nValor
					EndIf   
					For nLaco := 1 to Len(aQuebras)
						aQuebras[nLaco,( nBlocos+nDias ) ] += nValor
					Next

					// Se for n¡vel 0 o relat¢rio ser  sint‚tico.
					If mv_par07 > 0 .and. nValor != 0
						@Prow(),33+(nDias*18) PSAY nValor Picture tm(nValor,13)//"@E 99,999,999.99"
					Endif
				Endif
				nDays --
			Else
				If dbSeek( dTos(aDtCabec[nDias]) + SED->ED_CODIGO )
					nValor := xMoeda( cArqTmp->ENTRA - cArqTmp->SAIDA,1,mv_par04 )
					aTotDia[ nDias ] += xMoeda(cArqTmp->ENTRA,1,mv_par04) - xMoeda(cArqTmp->SAIDA,1,mv_par04)
					nTotLinha += nValor
					For nLaco := 1 to Len(aQuebras)
						aQuebras[nLaco,( nBlocos+nDias ) ] += nValor
					Next
					// Se for n¡vel 0 o relat¢rio ser  sint‚tico.
					If mv_par07 > 0 .and. nValor != 0
						@Prow(),33+(nDias*18) PSAY nValor Picture tm(nValor,13) // "@E 99,999,999.99"
					Endif
				Endif
			Endif
			// Se for n¡vel 0 o relat¢rio ser  sint‚tico.
			If mv_par07 > 0
				@Prow(),48 + ((nDias*18))   PSAY "|"
			Endif
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Imprime o total daquela linha daquela p gina     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 > 0
			@Prow(),194  PSAY nTotLinha Picture tm(nTotLinha,15) //"@E 9999,999,999.99"
			@Prow(),210	 PSAY "|"
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Inicia a matriz acumuladora de quebras  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nLaco := 1 to Len( aQuebras )
			aQuebras[nLaco,1] := Subst( SED->ED_CODIGO,aNiveis[nLaco,1],aNiveis[nLaco,2] )
		Next
		dbSelectArea("SED")
        DO WHILE SED->ED_CODIGO == cNatAnt
           dbSkip()
        ENDDO
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Verifica se houve quebra em algum n¡vel ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		f200totnat(nLimBreak,aQuebras,aNiveis,@lMovNat)
	Enddo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  ImpressÆo dos TOTAIS quando houver quebras por dia ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@++li,00 PSAY OemToAnsi(STR0021)   //"| RESULTADO DO DIA"
	@li,48   PSAY "|"
	lResulDia := .T.
	nTotLinha := 0
	For nDias := 1 to 8
		dDataTrab := dDataBase + nBlocos + nDias - 3
		nTotLinha += aTotDia[ nDias ]
		@Prow(),32 + ((nDias*18)) PSAY aTotDia[ nDias ] Picture tm(aTotDia[ nDias ],14) // "@E 99,999,999.99"
		@Prow(),48 + ((nDias*18)) PSAY "|"
	Next
	@Prow(),194      PSAY nTotLinha Picture tm(nTotLinha,15) //"@E 9999,999,999.99"
	@Prow(),210      PSAY "|"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  ImpressÆo dos SALDOS quando houver quebras por dia ³
	//³  Observe que o array aTotDia somente ‚ limpo neste  ³
	//³  ponto do programa                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@++li,00 PSAY cLinha
	@++li,00 PSAY OemToAnsi(STR0022)  //"| SALDO DO DIA"
	@li,48   PSAY "|"
	lSaldoDia := .T.
	nTotLinha := 0
	For nDias := 1 to 8
		nSaldoDoDia += aTotDia[nDias]
		@Prow(),33 + ((nDias*18)) PSAY nSaldoDoDia Picture tm(nSaldoDoDia,14) //"@E 99,999,999.99"
		@Prow(),48 + ((nDias*18)) PSAY "|"
		nTotLinha := nSaldoDoDia
		aTotDia[ nDias ] := 0
	Next
	@Prow(),194      PSAY nTotLinha Picture tm(nTotLinha,15) //"@E 9999,999,999.99"
	@Prow(),210      PSAY "|"
	@++li,00         PSAY  cLinha
Next

roda(cbcont,cbtxt,"G")

Set Device To Screen
Set Filter To
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga arquivos tempor rios  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectarea("cArqTmp")
cArqTmp->( dbCloseArea() )

dbSelectArea("SE1")
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Fin200Cabec³ Autor ³ Reiner Trennepohl     ³ Data ³ 22.11.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Printa o cabe‡alho dos dias da semana                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fin200Cabec(nBlocos,nHeader,aSemana,aDtCabec,nBlocOld,		³±±
±±³          ³             dDataCabec)												   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nBlocos  - N£mero de dias em m£ltiplos de 8 (uma semana).   ³±±
±±³          ³ nHeader  - Dia do mes/da semana do bloco em questao.        ³±±
±±³          ³ aSemana  - Array com os dias da semana por extenso.         ³±±
±±³          ³ aDtCabec - Array com as datas do bloco.                     ³±±
±±³          ³ nBlocOld - Guarda o bloco anterior p/recalcular datas ou nao³±±
±±³          ³ dDataCabec - Ultima data calculada no cabecalho.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro - JMHFINR1.PRW                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fin200Cabec(nBlocos,nHeader,aSemana,aDtCabec,nBlocOld,dDataCabec)

LOCAL aMeses := { OemToAnsi(STR0023),OemToAnsi(STR0024),OemToAnsi(STR0025),;   //"Janeiro"###"Fevereiro"###"Marco"
	OemToAnsi(STR0026),OemToAnsi(STR0027),OemToAnsi(STR0028),;   //"Abril"###"Maio"###"Junho"
	OemToAnsi(STR0029),OemToAnsi(STR0030),OemToAnsi(STR0031),;   //"Julho"###"Agosto"###"Setembro"
	OemToAnsi(STR0032),OemToAnsi(STR0033),OemToAnsi(STR0034) }   //"Outubro"###"Novembro"###"Dezembro"

Local nCount := 8
Local nTamSpc := IIF(Len(Dtoc(dDataBase)) > 8 , 4 , 6)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica, pelo numero de linhas se podera imprimir o cabecalho	³
//³ nesta pagina, evitando que imprima cabecalho sem linha de dados  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If li < 55
	@++li,00 PSAY cLinha
	@++li,00 PSAY OemToAnsi(STR0035)  //"| HISTORICO/DIAS"
	@li,48   PSAY "|"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica mudanca de bloco para atualizar o array de datas. Caso³
	//³o Array esteja vazio, alimenta o Array.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF nBlocOld <> nBlocos
		aDtCabec := {}
		nBlocOld := nBlocos
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se for 1§ bloco, imprime coluna de Atrasos e da DataBase      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nBlocos == 1
			AADD (aDtCabec,dDataBase-1)
			dDataCabec:= dDataBase
			AADD (aDtCabec,dDataCabec)
			nCount := 6
		Endif
		For nHeader := 1 to nCount
			dDataCabec++
			While Dow(dDataCabec) == 1 .or. Dow(dDataCabec) == 7
				dDataCabec++
			Enddo
			AADD (aDtCabec,dDataCabec)
		Next
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime datas.                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nColun := 48
	For nHeader :=1 to 8
		If nHeader ==1 .and. nBlocos == 1
			nColun += 18
			If MV_PAR13 == 1
		   	   @Prow(),54       PSAY "Atrasos"   // OemToAnsi(STR0036) 
		   	Else 
		   	   @Prow(),54       PSAY "Baixados" 
		   	EndIf   
			@Prow(),nColun   PSAY "|"
		Else
			nColun+=4
			@Prow(),nColun       PSAY aDtCabec[nHeader]
			nColun+=14
			@Prow(),nColun PSAY "|"
		Endif
	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime Coluna de Subtotal no cabecalho.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@Prow(),195 PSAY OemToAnsi(STR0037)  //"SUBTOTAL DA"
	@Prow(),210 PSAY "|"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime dias da semana ref as datas do bloco.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@++li,00 PSAY "| " + aMeses[Month( dDataCabec )]
	@li,48   PSAY "|"
	nColun := 48
	For nHeader := 1 to 8
		If nHeader ==1 .and. nBlocos == 1
			nColun += 18
			@Prow(),nColun PSAY "|"
		Else
			nColun+=5
			@Prow(),nColun PSAY aSemana[ Dow(aDtCabec[nHeader]) ]
			nColun += 13
			@Prow(),nColun PSAY "|"
		Endif

	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime coluna de complemento do Subtotal no cabecalho.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nColun += 6
	@Prow(),nColun PSAY OemToAnsi(STR0038)  //"NATUREZA"
	@Prow(),210 PSAY "|"
	@++li,00 PSAY  cLinha
Else
	li := 80
Endif
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F200TotNatc³ Autor ³ Reiner Trennepohl     ³ Data ³ 22.11.01±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime total da natureza, na quebra de natureza	         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ f200totnat(nLimBreak,aQuebras,aNiveis,lMovNat)  	         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro - JMHFINR1.PRW                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function f200totnat(nLimBreak,aQuebras,aNiveis,lMovNat)
Local nSavRec2
Local cSeekSED
Local cCodSED
Local nCtrl
Local nToCtrl
LOCAL nSetOrder := SED->(INDEXORD())
LOCAL nLaco, nQuebras, nDias, nTotLinha
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Verifica se houve quebra em algum n¡vel ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SED->( DBSETORDER(1) )
For nLaco := 1 to nLimBreak
	If aQuebras[nLaco,1] # Subst( SED->ED_CODIGO, aNiveis[nLaco,1], aNiveis[nLaco,2] )
		For nQuebras := nLimBreak to nLaco Step -1
			nSavRec := SED->( Recno() )
			dbSeek( xFilial("SED") + aQuebras[nQuebras,1] )
			nTotLinha := 0
			For nDias := 1 to 8
				If aQuebras[nQuebras, nBlocos+nDias ] # 0
					nTotLinha += aQuebras[nQuebras, nBlocos+nDias ]
				Endif
			Next
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime totais de natureza que tenham Movimento  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nTotLinha > 0 .or. lMovNat
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica a Descricao da Natureza Totalizada ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nSavRec2 := SED->( Recno() )
				cCodSED  := aQuebras[nQuebras,1]
				cSeekSED := ""
				If lMovNat
					nToCtrl  := IIF(mv_par07 > 0, mv_par07, 1)
					For nCtrl := 1 to nToCtrl
						cSeekSED += aQuebras[nCtrl,1]
					Next
					dbSeek( xFilial("SED") + cSeekSED )
					cCodSED := MascNat(SED->ED_CODIGO)
				EndIf

				li++

				@li,00 PSAY "|"
				@li,07 PSAY OemToAnsi(STR0020) + cCodSED + " " + Left( SED->ED_DESCRIC , 20 )  //"TOTAL - "
				@li,48 PSAY "|"

				SED->( dbGoTo( nSavRec2 ) )

				lMovNat := .F.

				For nDias := 1 to 8
					If aQuebras[nQuebras, nBlocos+nDias ] # 0
						@Prow(),32 + ((nDias*18)) PSAY aQuebras[nQuebras, nBlocos+nDias ] Picture Tm( aQuebras[nQuebras, nBlocos+nDias ], 14 ) // "@E 9999,999,999.99"
					Endif
					aQuebras[nQuebras, nBlocos+nDias ] := 0
					@Prow(),48 + ((nDias*18))   PSAY "|"
				Next
				@Prow(),194 PSAY nTotLinha Picture Tm( nTotLinha, 15 ) // "@E 99,999,999,999.99"
				@Prow(),210 PSAY "|"
				@++li,00 PSAY cLinha
			Endif
			SED->( dbGoTo( nSavRec ) )
		Next
	Endif
Next
SED->(DBSETORDER(nSetOrder))
Return



// Compatibiliza o SX1
STATIC FUNCTION AjustaSx1()
Local cAlias:=Alias(),aPerg:={}
//Local cPerg := "FINJM1"
Aadd(aPerg,{"Considera Adiantam.?","N",1})
Aadd(aPerg,{"Considera Filiais  ?","N",1})
Aadd(aPerg,{"Filial De          ?","C",2})
Aadd(aPerg,{"Filial Ate         ?","C",2})
Aadd(aPerg,{"Tipo do Relatorio  ?","N",1})

dbSelectArea("SX1")
If dbSeek(cPerg+"09")
	If X1_PERGUNT != aPerg[1][1]
		RecLock("SX1",.f.)
		SX1->( DbDelete())
		SX1->( MsUnlock())
	Endif
Endif

If dbSeek(cPerg+"10")
   If X1_PERGUNT != aPerg[2][1]
      RecLock("SX1",.f.)
  	   SX1->( DbDelete())
	   SX1->( MsUnlock())
   Endif
Endif

If dbSeek(cPerg+"11")
   If X1_PERGUNT != aPerg[3][1]
	   RecLock("SX1",.f.)
	   SX1->( DbDelete())
	   SX1->( MsUnlock())
   Endif
Endif

If dbSeek(cPerg+"12")
   If X1_PERGUNT != aPerg[4][1]
	   RecLock("SX1",.f.)
	   SX1->( DbDelete())
	   SX1->( MsUnlock())
   Endif
Endif

If dbSeek(cPerg+"13")
   If X1_PERGUNT != aPerg[5][1]
	   RecLock("SX1",.f.)
	   SX1->( DbDelete())
	   SX1->( MsUnlock())
   Endif
Endif

If !dbSeek(cPerg+"09")
	RecLock("SX1",.T.)
	Replace X1_GRUPO   	with cPerg
	Replace X1_ORDEM   	with "09"
	Replace X1_PERGUNT 	with aPerg[1][1]
	Replace X1_VARIAVL 	with "mv_ch9"
	Replace X1_TIPO	 	with aPerg[1][2]
	Replace X1_TAMANHO 	with aPerg[1][3]
	Replace X1_PRESEL  	with 1
	Replace X1_GSC	   	with "C"
	Replace X1_VAR01   	with "mv_par09"
	Replace X1_DEF01   	with "Sim"
	Replace X1_DEF02   	with "N„o"
	MsUnlock()
EndIf
If !dbSeek(cPerg+"10")
	RecLock("SX1",.T.)
	Replace X1_GRUPO   	with cPerg
	Replace X1_ORDEM   	with "10"
	Replace X1_PERGUNT 	with aPerg[2][1]
	Replace X1_VARIAVL 	with "mv_cha"
	Replace X1_TIPO	 	with aPerg[2][2]
	Replace X1_TAMANHO 	with aPerg[2][3]
	Replace X1_PRESEL  	with 1
	Replace X1_GSC	   	with "C"
	Replace X1_VAR01   	with "mv_par10"
	Replace X1_DEF01   	with "Sim"
	Replace X1_DEF02   	with "Nao"
	MsUnlock()
EndIf
If !dbSeek(cPerg+"11")
	RecLock("SX1",.T.)
	Replace X1_GRUPO   	with cPerg
	Replace X1_ORDEM   	with "11"
	Replace X1_PERGUNT 	with aPerg[3][1]
	Replace X1_VARIAVL 	with "mv_chb"
	Replace X1_TIPO	 	with aPerg[3][2]
	Replace X1_TAMANHO 	with aPerg[3][3]
	Replace X1_PRESEL  	with 0
	Replace X1_GSC	   	with "G"
	Replace X1_VAR01   	with "mv_par11"
   Replace X1_CNT01     with "01"
	MsUnlock()
EndIf
If !dbSeek(cPerg+"12")
	RecLock("SX1",.T.)
	Replace X1_GRUPO   	with cPerg
	Replace X1_ORDEM   	with "12"
	Replace X1_PERGUNT 	with aPerg[4][1]
	Replace X1_VARIAVL 	with "mv_chc"
	Replace X1_TIPO	 	with aPerg[4][2]
	Replace X1_TAMANHO 	with aPerg[4][3]
	Replace X1_PRESEL  	with 0
	Replace X1_GSC	   	with "G"
	Replace X1_VAR01   	with "mv_par12"
   Replace X1_CNT01     with "ZZ"
	MsUnlock()
EndIf 

If !dbSeek(cPerg+"13")
	RecLock("SX1",.T.)
	Replace X1_GRUPO   	with cPerg
	Replace X1_ORDEM   	with "13"
	Replace X1_PERGUNT 	with aPerg[5][1]
	Replace X1_VARIAVL 	with "mv_chd"
	Replace X1_TIPO	 	with aPerg[5][2]
	Replace X1_TAMANHO 	with aPerg[5][3]
	Replace X1_PRESEL  	with 1     
	Replace X1_GSC	   	with "C"
	Replace X1_VAR01   	with "mv_par13"
	Replace X1_DEF01   	with "Previsto"
	Replace X1_DEF02   	with "Realizado"
	MsUnlock()
EndIf

dbSelectArea(cAlias)
Return
