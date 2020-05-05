#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TBICONN.CH" 
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

//{IX} ================================================================================
//{IX} 000058 = User Function JMHR100()
//{IX} 000149 = User Function JHR100B1()
//{IX} 000181 = User Function JHR100Bo( cPrefixo, cTitulo, cTipo, cParcela, lPreview, aMsg, oPrn, cBanTar, cAgenTar, cConTar, cSubCta, aDesc, lImprime )
//{IX} 000614 = Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,aDesc, lImprime)
//{IX} 000985 = Static Function BbMod10() // Banco do Brasil
//{IX} 001010 = Static Function Modulo10(cData)
//{IX} 001058 = Static Function Modulo11(cData,lCaixa) //Modulo 11 com base 7
//{IX} 001115 = Static Function Mod11Citi(cData)
//{IX} 001148 = Static Function Mod11CB(cData) // Modulo 11 com base 9
//{IX} 001179 = Static Function NNumDV(xCampo) //Calculo do Digito Verificador do Nosso Numero
//{IX} 001249 = Static Function BbBarraDv(B_Campo)
//{IX} 001277 = Static Function BbLdDv(cCampo)
//{IX} 001326 = Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)
//{IX} 001605 = Static Function Digitao(cData)
//{IX} 001646 = Static Function Mod10Saf(cData)
//{IX} 001687 = Static Function ModSaf(cData) // NAO USADO
//{IX} ================================================================================
// Leef
#define BANCOSANTANDER    '033'
#define BANCODOBRASIL     '001'
#define BANCOITAU         '341'
#define BANCOREAL         '356'
#define BANCOCITIBANK     '745'
#define BANCOCAIXA        '104' // CRISTIANO OLIVEIRA - 13/04/2016
#define BANCOSAFRA        '422' // MPF 20190606 - BANCO SAFRA

///*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Programa  ³ JMHR100  ³ Autor ³ FABIO BRIDDI          ³ Data ³ 22/06/07 ³±±
//±±³          ³          ³ Ajuste³ Marllon Figueiredo    ³ Data ³ 10/09/07 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descricao ³ Impressao de Boletos Bancarios com Codigo de Barras        ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Uso       ³ Especifico para Jomhedica                                  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³                         Manutencoes                                   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ´±±
//±±³Analista  ³ Motivo                                            ³  Data  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´±±
//±±³ Marllon   ³ Boleto do Banco Brasil                           ³10/09/07³±±
//±±³ Tarasconi ³ Incluido Boleto Banco Real                       ³04/07/08³±±
//±±³ F Briddi  ³ Incluido Boleto Banco Itau                       ³30/06/09³±±
//±±³ Marllon   ³ Incluido Boleto Banco Citibank                   ³20/10/09³±±
//±±³ Marllon   ³ Incluido Boleto Banco Santander                  ³01/10/12³±±
//±±º Cristiano ³ Incluido Boleto Banco Caixa Economica Federal    ³13/04/16³±±
//±±º           ³                                                           º±±
//±±º Marllon   ³ 25-08-10  Migracao para utilizar a tabela de Classe Risco º±±
//±±º           ³           x Banco Cobranca (backup do fonte em 2010-08-25 º±±
//±±º           ³                                                           º±±
//±±º           ³                                                           º±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function JMHR100()

   Private cCadastro := "Reimpressão de Boletos de Cobrança"
   Private aRotina   := {{"Pesquisar",  "AxPesqui",   0, 1 },;
   {"Visualisar", "AxVisual",   0, 8 },;
   {"Boleto",     "u_Jhr100B1", 0, 8 } }
   Private cPerg     := 'JMHR100   '
   dbSelectArea('SX1')
   If !DbSeek(cPerg+'01')
      RecLock("SX1",.T.)
      Replace X1_GRUPO   With cPerg                ,;
      X1_ORDEM   With "01"                    ,;
      X1_PERGUNT With "Instrução para o Boleto?" ,;
      X1_VARIAVL With "mv_ch1"                ,;
      X1_TIPO    With "C"                     ,;
      X1_TAMANHO With 60                      ,;
      X1_VAR01   With "MV_PAR01"              ,;
      X1_GSC     With "G"
      MsUnlock()
      RecLock("SX1",.T.)
      Replace X1_GRUPO   With cPerg                ,;
      X1_ORDEM   With "02"                    ,;
      X1_PERGUNT With "Instrução para o Boleto?" ,;
      X1_VARIAVL With "mv_ch2"                ,;
      X1_TIPO    With "C"                     ,;
      X1_TAMANHO With 60                      ,;
      X1_VAR01   With "MV_PAR02"              ,;
      X1_GSC     With "G"
      MsUnlock()
   Endif

   If !DbSeek(cPerg+'03')
      RecLock("SX1",.T.)
      Replace X1_GRUPO   With cPerg           ,;
      X1_ORDEM   With "03"                    ,;
      X1_PERGUNT With "Enviar para Banco?"    ,;
      X1_VARIAVL With "mv_ch3"                ,;
      X1_TIPO    With "C"                     ,;
      X1_TAMANHO With 3                       ,;
      X1_VAR01   With "MV_PAR03"              ,;
      X1_GSC     With "G"                     ,;
      X1_F3      With "SEE"
      MsUnlock()
   EndIf
   If !DbSeek(cPerg+'04')
      RecLock("SX1",.T.)
      Replace X1_GRUPO   With cPerg           ,;
      X1_ORDEM   With "04"                    ,;
      X1_PERGUNT With "Agencia ?     "        ,;
      X1_VARIAVL With "mv_ch4"                ,;
      X1_TIPO    With "C"                     ,;
      X1_TAMANHO With 5                       ,;
      X1_VAR01   With "MV_PAR04"              ,;
      X1_GSC     With "G"
      MsUnlock()
   EndIf
   If !DbSeek(cPerg+'05')
      RecLock("SX1",.T.)
      Replace X1_GRUPO   With cPerg           ,;
      X1_ORDEM   With "05"                    ,;
      X1_PERGUNT With "Conta ?     "    ,;
      X1_VARIAVL With "mv_ch5"                ,;
      X1_TIPO    With "C"                     ,;
      X1_TAMANHO With 10                       ,;
      X1_VAR01   With "MV_PAR05"              ,;
      X1_GSC     With "G"
      MsUnlock()
   EndIf
   If !DbSeek(cPerg+'06')
      RecLock("SX1",.T.)
      Replace X1_GRUPO   With cPerg           ,;
      X1_ORDEM   With "06"                    ,;
      X1_PERGUNT With "Sub Conta?"    ,;
      X1_VARIAVL With "mv_ch6"                ,;
      X1_TIPO    With "C"                     ,;
      X1_TAMANHO With 03                       ,;
      X1_VAR01   With "MV_PAR06"              ,;
      X1_GSC     With "G"
      MsUnlock()
   EndIf

   dbSelectArea('SE1')                           
     mBrowse( 6, 1,22,75,"SE1")      
//   mBrowse( 6, 1,22,75,"SE1", , , , , , , , ,, , , <lSeeAll>, <lChgAll>, <cExprFilTop>, <nInterval>, <uPar22>, <uPar23> )
//   mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, <cCorFun>, <nClickDef>, <aColors>, <cTopFun>, <cBotFun>, <nPar14>, <bInitBloc>, <lNoMnuFilter>, <lSeeAll>, <lChgAll>, <cExprFilTop>, <nInterval>, <uPar22>, <uPar23> )

Return



// funcao executada somente a partir do mBrowse de reimpressao de boletos
User Function JHR100B1()

   If Empty(SE1->E1_PORTADO)
      If ! Pergunte( cPerg, .t. )
         Return
      EndIf

      cE1_PORTADO := MV_PAR03
      cE1_AGEDEP  := MV_PAR04
      cE1_CONTA   := MV_PAR05
      cE1_SUBCTA  := MV_PAR06
   Else
      cE1_PORTADO := SE1->E1_PORTADO
      cE1_AGEDEP  := SE1->E1_AGEBOL     // campo especifico Jomhedica
      cE1_CONTA   := SE1->E1_CTABOL     // campo especifico Jomhedica
      cE1_SUBCTA  := SE1->E1_SUBBOL     // campo especifico Jomhedica
   EndIf

   cPrefixo := SE1->E1_PREFIXO
   cTitulo  := SE1->E1_NUM
   cTipo    := SE1->E1_TIPO
   cParcela := SE1->E1_PARCELA

   // executa a rotina de impressao do boleto
   u_JHR100Bo(cPrefixo, cTitulo, cTipo, cParcela, .t., {MV_PAR01, MV_PAR02}, , cE1_PORTADO, cE1_AGEDEP, cE1_CONTA, cE1_SUBCTA, {0, 0, SE1->E1_OBSDESC},.T.)
//   u_JHR100Bo(aBoletos[nStart,2], aBoletos[nStart,1], 'NF ',         , lPreview , {cMens1, cMens2},     , _cBancoCobr, _cAgenciaCobr, _cContaCobr, _cSubCtaCobr, {aBoletos[nStart,3][1], aBoletos[nStart,3][2], ''}, lImprime  )  // adicionei o .F. (assis 160819-17:22)


Return


//---------------------------------------------------------------------------------------------------------------------------------------
// Funcao executada a partir da impressao da nota fiscal e DANFe
// Definicao de aDESC:  [1]=PERCENTUAL, [2]=VALOR, [3]=MENSAGEM DE DESCONTO
User Function JHR100Bo( cPrefixo, cTitulo, cTipo, cParcela, lPreview, aMsg, oPrn, cBanTar, cAgenTar, cConTar, cSubCta, aDesc, lImprime )

   LOCAL   lPrimVez   := .T.
   LOCAL  aDadosEmp  := {}
   Local   lPrn       := .f.
   PRIVATE oPrint
   PRIVATE lGravaNn   := .F.
   PRIVATE lPrint     := lPreview
   PRIVATE nTaxaDia   := 0
   PRIVATE nVlAtraso  := 0
   PRIVATE xBanco
   PRIVATE xNumBanco  := ""
   PRIVATE xNomeBanco := ""
   PRIVATE xAgencia
   PRIVATE xConta
   PRIVATE ySubCta
   PRIVATE xDvConta   := ""
   PRIVATE xCartCob   := ""
   PRIVATE xCodCedente:= ""
   PRIVATE yNumBanco  := ""
   PRIVATE yAgencia   := ""
   PRIVATE yConta     := ""
   PRIVATE xNossoNum  := ""
   PRIVATE yNossoNum  := ""
   PRIVATE xDvNossoNum:= ""
   PRIVATE xMsg1      := ""
   PRIVATE xMsg2      := ""
   PRIVATE cCartNnDvDv:= ""
   PRIVATE cFaixaAtu  := ""
   PRIVATE nTxPer     := GetMv("MV_TXPER")
   PRIVATE cBcoCli
   Private cDigitaoC  := Space(1)
   Private lConferencia := .F.

   // valores default
   Default lPrint   := .f.
   Default lImprime := .f.  // para impedir/permitir impressao

   // testa se o objeto oPrint veio por passagem de parametro
   If oPrn <> nil
      oPrint := oPrn
      lPrn   := .t.
   EndIf
   SM0->(DbSeek(cEmpAnt+cFilAnt))
   aDadosEmp  := { SM0->M0_NOMECOM,;           //[1]Nome da Empresa
   SM0->M0_ENDCOB,;           //[2]Endereço
   AllTrim(SM0->M0_BAIRCOB) + ", " + ;
   AllTrim(SM0->M0_CIDCOB)  + ", " + ;
   SM0->M0_ESTCOB,;         //[3]Complemento
   "CEP: " + Transform(SM0->M0_CEPCOB,"@R 99.999-999"),;  //[4]CEP
   "PABX/FAX: " + SM0->M0_TEL,;        //[5]Telefones
   Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),;    //[6]CNPJ
   "I.E.: " + Transform(SM0->M0_INSC,"@R 999/99999999999")}//[7]Insc Estadual

   cQuery := "SELECT E1_TIPO, E1_VALOR, E1_SALDO, E1_PREFIXO, E1_NUM, E1_CLIENTE, E1_LOJA, E1_PARCELA,  "
   cQuery +=       " E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_NUMBCO, E1_PORTADO, "
   cQuery +=       " E1_IRRF, E1_ISS, E1_INSS, E1_PIS, E1_COFINS, E1_CSLL, E1_PORTADO, E1_AGEDEP, E1_CONTA, "
   cQuery +=       " A1_BCO1, A1_NOME, A1_COD, A1_END, A1_MUN, A1_EST, A1_CEP, A1_CGC, "
   cQuery +=       " A1_ENDCOB, A1_MUNC, A1_ESTC, A1_CEPC, A1_BAIRRO, A1_LOJA, A1_BCOCOB, A1_AGECOB, A1_CTACOB, E1_OBSDESC "
   cQuery += "FROM " + RetSqlName("SE1") + " SE1 (NOLOCK), "
   cQuery +=           RetSqlName("SA1") + " SA1 (NOLOCK) "
   //cQuery += "WHERE E1_FILIAL  = '" + xFilial("SE1") + "' "
   cQuery += "WHERE E1_FILIAL <> ' ' "
   cQuery += "AND   E1_PREFIXO = '" + cPrefixo       + "' "
   cQuery += "AND   E1_NUM     = '" + cTitulo        + "' "
   cQuery += "AND   E1_TIPO    = '" + cTipo          + "' "
   If cParcela <> nil
      cQuery += "AND   E1_PARCELA = '" + cParcela       + "' "
   EndIf
   cQuery += "AND   SE1.D_E_L_E_T_ = ' '  "
   cQuery += "AND   A1_COD     = E1_CLIENTE "
   cQuery += "AND   A1_LOJA    = E1_LOJA "
   cQuery += "AND   SA1.D_E_L_E_T_ = ' '  "
   cQuery += "ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO "

   //MemoWrite("JMHR100",cQuery)
   cQuery := ChangeQuery(cQuery)

   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"T_SE1",.T.,.T.)
   TCSetField("T_SE1","E1_EMISSAO","D",8,0)
   TCSetField("T_SE1","E1_VENCTO" ,"D",8,0)
   TCSetField("T_SE1","E1_VENCREA","D",8,0)

   DbSelectArea("T_SE1")
   Count to nReg
   DbGoTop()

   Do While !EOF()
      If !Empty(T_SE1->A1_ENDCOB)
         aDatSacado :=  {AllTrim(T_SE1->A1_NOME),;                          // [1]Razão Social
         AllTrim(T_SE1->A1_COD )+"-"+T_SE1->A1_LOJA,;                  // [2]Código
         AllTrim(T_SE1->A1_ENDCOB )+" - "+AllTrim(T_SE1->A1_BAIRRO),;  // [3]Endereço
         AllTrim(T_SE1->A1_MUNC ),;                                  // [4]Cidade
         T_SE1->A1_ESTC,;                                            // [5]Estado
         T_SE1->A1_CEPC,;                                            // [6]CEP
         T_SE1->A1_CGC}                      // [7]CGC
      Else
         aDatSacado :=  {AllTrim(T_SE1->A1_NOME),;                       // [1]Razão Social
         AllTrim(T_SE1->A1_COD )+"-"+T_SE1->A1_LOJA,;               // [2]Código
         AllTrim(T_SE1->A1_END )+" - "+AllTrim(T_SE1->A1_BAIRRO),;  // [3]Endereço
         AllTrim(T_SE1->A1_MUN ),;                                // [4]Cidade
         T_SE1->A1_EST,;                                          // [5]Estado
         T_SE1->A1_CEP,;                                          // [6]CEP
         T_SE1->A1_CGC}                   // [7]CGC
      EndIf

      // atualiza variaveis de tratamento
      xBanco   := cBanTar
      xAgencia := cAgenTar
      yAgencia := cAgenTar
      xConta   := cConTar
      yConta   := cConTar
      ySubCta  := cSubCta

      If ! SA6->( dbSeek(xFilial('SA6')+xBanco+yAgencia+yConta) )
         DbSelectArea("T_SE1")
         T_SE1->(DBSKIP())
         Loop
      EndIf

      yNumBanco  := SA6->A6_COD
      xNomeBanco := AllTrim(Substr(SA6->A6_NOME,1,20))

      If ! Empty(T_SE1->E1_PORTADO) .And. T_SE1->E1_PORTADO <> xBanco
         Alert("Pelo cadastro do Cliente/Risco Titulo: " + T_SE1->E1_NUM + " Não Pertence ao Banco: " + xBanco + " !")
         Set Century Off
         dbSelectArea("T_SE1")
         dbCloseArea()
         Return
      EndIf

      If  xBanco == BANCODOBRASIL
         xAgencia   := SubStr(AllTrim(SA6->A6_AGENCIA),1,Len(AllTrim(SA6->A6_AGENCIA))-1)
         xDVAgencia := Right(AllTrim(SA6->A6_AGENCIA),1)
         xConta     := Substr(AllTrim(SA6->A6_NUMCON),1,Len(AllTrim(SA6->A6_NUMCON))-1)
         xDvConta   := Right(AllTrim(SA6->A6_NUMCON),1)
      ElseIf xBanco = BANCOSANTANDER
         xAgencia   := Substr(AllTrim(SA6->A6_AGENCIA),1,Len(AllTrim(SA6->A6_AGENCIA))-1)
         xDVAgencia := Right(AllTrim(SA6->A6_AGENCIA),1)
         xConta     := Substr(AllTrim(SA6->A6_NUMCON),1,Len(AllTrim(SA6->A6_NUMCON))-1)
         xDvConta   := Right(AllTrim(SA6->A6_NUMCON),1)
      ElseIf xBanco = "041"
      ElseIf xBanco = "237"
      ElseIf xBanco = BANCOITAU
         xAgencia   := AllTrim(SA6->A6_AGENCIA)
         xDVAgencia := ""
         xConta     := Substr(AllTrim(SA6->A6_NUMCON),1,Len(AllTrim(SA6->A6_NUMCON))-1)
         xDvConta   := Right(AllTrim(SA6->A6_NUMCON),1)
      ElseIf xBanco = BANCOREAL
         xAgencia   := Alltrim(SA6->A6_AGENCIA)
         xDVAgencia := ''
         xConta     := Substr(AllTrim(SA6->A6_NUMCON),1,Len(AllTrim(SA6->A6_NUMCON))-1)
         xDvConta   := Right(AllTrim(SA6->A6_NUMCON),1)

      ElseIf xBanco = BANCOSAFRA
         xAgencia   := Alltrim(SA6->A6_AGENCIA)
         xDVAgencia := ''
         xConta     := StrZero(Val(SA6->A6_NUMCON),8)
         xDvConta   := SA6->A6_DVCTA

      ElseIf xBanco = BANCOCITIBANK
         xAgencia   := Alltrim(SA6->A6_AGENCIA)
         xDVAgencia := ''
         xConta     := Substr(AllTrim(SA6->A6_NUMCON),1,Len(AllTrim(SA6->A6_NUMCON))-1)
         xDvConta   := Right(AllTrim(SA6->A6_NUMCON),1)
      ElseIf xBanco = BANCOCAIXA
         xAgencia   := AllTrim(SA6->A6_AGENCIA)
         xDVAgencia := "0"
         xConta     := Substr(AllTrim(SA6->A6_NUMCON),1,Len(AllTrim(SA6->A6_NUMCON))-1)
         xDvConta   := Right(AllTrim(SA6->A6_NUMCON),1)
      EndIf

      DbSelectArea("T_SE1")
      xCodCedente:= ""

      If xBanco = BANCOSAFRA
         xMsg1      := "Ate o vencimento pagavel em qualquer banco. apos o vencimento apenas nas agencias do banco SAFRA"
         xMsg2      := ""

      Else
         xMsg1      := "PREFERENCIALMENTE NAS CASAS LOTERICAS ATÉ O VALOR LIMITE" // "PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO"
         xMsg2      := ""
      EndIf
      xMensg1    := ""
      xMensg2    := ""
      xMensg3    := ""
      If aMsg <> nil
         xMensg1 := aMsg[1]
         xMensg2 := aMsg[2]
      EndIf
      If aDesc <> nil
         If ! Empty(aDesc[3])
            xMensg3 := aDesc[3]
         Else
            If aDesc[1]>0 .or. aDesc[2]>0
               If aDesc[1]>0
                  xMensg3 := 'DESCONTO DE '+Alltrim(Transform(aDesc[1],'@E 99.99'))+' % ATE O VENCIMENTO.'
               ElseIf aDesc[2]>0
                  xMensg3 := 'DESCONTO DE R$ '+Alltrim(Transform(aDesc[2],'@E 9,999,999.99'))+' ATE O VENCIMENTO.'
               EndIf
            Endif
         EndIf
      EndIf

      // localiza SEE
      DbSelectArea("SEE")
      DbSetOrder(1)
      If !DbSeek(xFilial("SEE") + xBanco + yAgencia + yConta + ySubCta)
         Alert("Conta Cobrança Sem Parâmetros !")
         Set Century Off
         dbSelectArea("T_SE1")
         dbCloseArea()
         Return
      Else
         RecLock("SEE",.F.)  // Jean Rehermann - Solutio IT - Trava para garantir numeracao unica
      EndIf

      If  xBanco = BANCODOBRASIL
         xNumBanco   :=  '0019'
         xCartCob    :=  StrZero(Val(SEE->EE_CARTEIR),2)
      ElseIf xBanco = BANCOSANTANDER
         xNumBanco   :=  "0337"
         xCartCob    :=  StrZero(Val(SEE->EE_CARTEIR),3)
      ElseIf xBanco = "041"
      ElseIf xBanco = "237"
      ElseIf xBanco = BANCOITAU
         xNumBanco   :=  "3417"
         xCartCob    :=  StrZero(Val(SEE->EE_CARTEIR),3)  //"109"
      ElseIf xBanco = BANCOREAL
         xNumBanco   :=  "3565"
         xCartCob    :=  StrZero(Val(SEE->EE_CARTEIR),2)  //"42"

      ElseIf xBanco = BANCOSAFRA
         xNumBanco   :=  "4227"
         xCartCob    :=  StrZero(Val(SEE->EE_CARTEIR),2)  //"02"

      ElseIf xBanco = BANCOCITIBANK
         xNumBanco   :=  '7455'
         // para o Citi a carteira é diferente no arquivo remessa e no boleto
         // 9   = carteira para informacao no arquivo de remessa sera o EE_CARTEIR
         // 999 = carteira para informacao no campo 12 do boleto de cobranca sera o EE_VARIAC
         xCartCob    :=  Alltrim(SEE->EE_VARIAC)
      ElseIf xBanco = BANCOCAIXA
         xNumBanco   :=  "1040"
         xCartCob    :=  StrZero(Val(SEE->EE_CARTEIR), 3)
      EndIf

      If xBanco = BANCODOBRASIL
         xCodCedente := AllTrim(SEE->EE_CODEMP)
         cFaixaAtu   := AllTrim(SEE->EE_FAXATU)
      ElseIf xBanco = BANCOSANTANDER
         xCodCedente := AllTrim(SEE->EE_CODEMP)
         cFaixaAtu   := AllTrim(SEE->EE_FAXATU)
      ElseIf xBanco = BANCOITAU
         xCodCedente := AllTrim(SEE->EE_CODEMP)
         cFaixaAtu   := AllTrim(SEE->EE_FAXATU)
      ElseIf xBanco = BANCOREAL
         xCodCedente := AllTrim(SEE->EE_CODEMP)
         cFaixaAtu   := AllTrim(SEE->EE_FAXATU)

      ElseIf  xBanco = BANCOSAFRA
         xCodCedente := AllTrim(SEE->EE_CODEMP)
         cFaixaAtu   := AllTrim(SEE->EE_FAXATU)

      ElseIf xBanco = BANCOCITIBANK
         xCodCedente := AllTrim(SEE->EE_CODEMP)
         cFaixaAtu   := AllTrim(SEE->EE_FAXATU)
      ElseIf xBanco = BANCOCAIXA
         xCodCedente := AllTrim(SEE->EE_CODEMP)
         cFaixaAtu   := AllTrim(SEE->EE_FAXATU)
      EndIf

      aDadosBanco  := { xNumBanco,;   // [1]Numero do Banco
      xNomeBanco,;  // [2]Nome do Banco
      xAgencia,;    // [3]Agência
      xConta,;      // [4]Conta Corrente
      xDvConta,;    // [5]Dígito da conta corrente
      xCartCob,;    // [6]Codigo da Carteira
      xCodCedente } // [7]Codigo Cedente

      lGravaNn := .F.

      // - Verifica se e reimpressao carrega o mesmo conteudo para o Nosso Numero
      _cNossoNum := ''
      If  Empty(T_SE1->E1_NUMBCO)
         lGravaNn := .T.
         If   xBanco = BANCODOBRASIL
            xNossoNum := xCodCedente + cFaixaAtu
            yNossoNum := _cNossoNum := xNossoNum
         ElseIf  xBanco = BANCOSANTANDER
            //7 posicoes para cobranca com registro e 13 posicoes para cobranca sem registro
            xNossoNum := StrZero(Val(cFaixaAtu),12) + xDvNossoNum
            yNossoNum := _cNossoNum := xNossoNum
         ElseIf  xBanco = "041"
         ElseIf  xBanco = "237"
         ElseIf  xBanco = BANCOITAU
            yNossoNum := _cNossoNum := xNossoNum := cFaixaAtu
         ElseIf  xBanco = BANCOREAL
            //7 posicoes para cobranca com registro e 13 posicoes para cobranca sem registro
            xNossoNum := StrZero(Val(cFaixaAtu),7)
            yNossoNum := _cNossoNum := xNossoNum

         ElseIf  xBanco = BANCOSAFRA
            //9 posicoes para cobranca
            xNossoNum := StrZero(Val(cFaixaAtu),9)
            yNossoNum := _cNossoNum := xNossoNum

         ElseIf  xBanco = BANCOCITIBANK
            xNossoNum := cFaixaAtu
            yNossoNum := _cNossoNum := xNossoNum
         ElseIf  xBanco = BANCOCAIXA
            xNossoNum := StrZero(Val(cFaixaAtu),15) // Jean Rehermann - Solutio IT - 27/03/2018 - Ajuste numeracao para 15 digitos
            yNossoNum := _cNossoNum := xNossoNum
         EndIf
      Else
         If   xBanco = BANCODOBRASIL
            xNossoNum := xCodCedente + T_SE1->E1_NUMBCO  // xCodCedente + cFaixaAtu
            yNossoNum := _cNossoNum := xNossoNum
         ElseIF  xBanco = BANCOSANTANDER
            xNossoNum := Substr(T_SE1->E1_NUMBCO,1,12)
            yNossoNum := _cNossoNum := xNossoNum
         ElseIf  xBanco = "041"
         ElseIf  xBanco = "237"
         ElseIf  xBanco = BANCOITAU
            xNossoNum := Left(T_SE1->E1_NUMBCO,8)
            yNossoNum := _cNossoNum := xNossoNum
         ElseIF  xBanco = BANCOREAL
            xNossoNum := T_SE1->E1_NUMBCO
            yNossoNum := _cNossoNum := xNossoNum

         ElseIF  xBanco = BANCOSAFRA
            xNossoNum := Substr(T_SE1->E1_NUMBCO,1,9)   // 8 posicoes sem o DV
            yNossoNum := _cNossoNum := xNossoNum

         ElseIF  xBanco = BANCOCITIBANK
            xNossoNum := Substr(T_SE1->E1_NUMBCO,1,11)
            yNossoNum := _cNossoNum := Substr(xNossoNum,1,11)
         ElseIf  xBanco = BANCOCAIXA
            xNossoNum := Right(T_SE1->E1_NUMBCO,15) // Jean Rehermann - Solutio IT - 27/03/2018 - Ajuste numeracao para 15 digitos
            yNossoNum := _cNossoNum := xNossoNum
         EndIf
      EndIf
      If lPrimVez .and. ! lPrn .and. lImprime
         lPrimVez := .F.
         oPrint := TMSPrinter():New( "Boleto Bancario" )
         oPrint:SetPortrait()
      EndIf
      DbSelectArea("T_SE1")
      _nTotEnc :=  T_SE1->E1_IRRF+T_SE1->E1_INSS+T_SE1->E1_PIS+T_SE1->E1_COFINS+T_SE1->E1_CSLL
      _nVlrAbat   :=  _nTotEnc

      //         Codigo Banco         Agencia C.Corrente     Digito C/C    Carteira
      CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],aDadosBanco[6],_cNossoNum,T_SE1->E1_SALDO)
      aDadosTit   := { " " + AllTrim(T_SE1->E1_NUM) + "" + AllTrim(T_SE1->E1_PARCELA),;  // [1] Numero do titulo
      T_SE1->E1_EMISSAO                               ,;  // [2] Data da emissão do título
      Date()                                    ,;  // [3] Data da emissão do boleto
      T_SE1->E1_VENCREA        ,;  // [4] Data do vencimento
      T_SE1->E1_SALDO         ,;  // [5] Valor do título
      CB_RN_NN[3]          ,;  // [6] Nosso número (Ver fórmula para calculo)
      T_SE1->E1_PREFIXO                               ,;  // [7] Prefixo da NF
      T_SE1->E1_TIPO                                 ,;  // [8] Tipo do Titulo
      T_SE1->E1_IRRF                              ,;  // [9] IRRF
      T_SE1->E1_ISS                               ,;  // [10] ISS
      T_SE1->E1_INSS                                  ,;  // [11] INSS
      T_SE1->E1_PIS                                   ,;  // [12] PIS
      T_SE1->E1_COFINS                                ,;  // [13] COFINS
      T_SE1->E1_CSLL                                ,;  // [14] CSLL
      _nVlrAbat }           // [15] Abatimentos
      nTaxPer := GetMV('MV_TXPER')
      nVlAtraso := ((aDadosTit[5] * nTaxPer)/100)

      IF  xBanco = BANCOSAFRA
         aBolText  := { "PROTESTAR APOS 10 DIAS DE VENCIDO." ,;      //[1]
         "COBRAR JUROS DE MORA DE 1,5% AO MêS APóS O VENCIMENTO.",; //[2]
         xMensg1,;     //[3]
         xMensg2,;             //[4]
         xMensg3,;           //[5]
         "",;             //[6]
         "ESTE BOLETO REPRESENTA DUPLICATA CEDIDA FIDUCIARIAMENTE AO BANCO SAFRA S/A,",;     //[7]
         "FICANDO VEDADO O PAGAMENTO DE QUALQUER OUTRA FORMA QUE NÃO ATRAVÉS DO PRESENTE BOLETO.",;   //[8]
         "" }            //[9]
      Else
         aBolText  := { "NÃO RECEBER APÓS 7 DIAS DO VENCIMENTO." ,;      //[1]
         "COBRAR JUROS DE MORA DE 1,5% AO MêS APóS O VENCIMENTO.",; //[2]
         "COBRAR MULTA DE 1,5% APóS O VENCIMENTO",;     //[3]
         xMensg3,;           //[4]
         xMensg1,;            //[5]
         xMensg2,;            //[6]
         "",;             //[7]
         "",;             //[8]
         "" }            //[9]
      EndIf

      aBMP := {}
      // o impress é quem de fato grava o SE1, então chamo ele repassando o lImprime
      Impress(oPrint,aBMP,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,aDesc, lImprime)
      DbSelectArea("T_SE1")
      T_SE1->(dbSkip())
   EndDo

   DbSelectArea("T_SE1")
   DbCloseArea()

   If ! lPrn .and. lImprime
      If oPrint <> nil
         If lPrint
            // visualiza antes de imprimir
            oPrint:Preview()
            //oPrint:Print()
         Else
            // envia direto para a impressora sem preview
            oPrint:Print()
         EndIf
      EndIf
   EndIf

Return Nil



///*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Funcao    ³ Impress  ³ Autor ³ Fabio Briddi          ³ Data ³          ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ IMPRESSAO DO BOLETO C/ CODIGO DE BARRAS                    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Uso       ³ JMHR100                                                    ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//                           1       2         3         4           5          6        7        8
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,aDesc, lImprime)
   LOCAL oFont6
   LOCAL oFont8
   LOCAL oFont10
   LOCAL oFont16
   LOCAL oFont16n
   LOCAL oFont24
   LOCAL i := 0
   LOCAL aCoords1 := {0150,1900,0550,2300}
   LOCAL aCoords2 := {0450,1050,0550,1900}
   LOCAL aCoords3 := {0710,1900,0810,2300}
   LOCAL aCoords4 := {0980,1900,1050,2300}
   LOCAL aCoords5 := {1330,1900,1400,2300}
   LOCAL aCoords6 := {2000,1900,2100,2300}
   LOCAL aCoords7 := {2270,1900,2340,2300}
   LOCAL aCoords8 := {2620,1900,2690,2300}
   LOCAL cCGC     := ""
   Local lHP      := GetMV('JM_PRNHP')
   LOCAL oBrush

//   default lImprime:=.t.

   Set Century On

   if lImprime

      //Parâmetros de TFont.New()
      //1.Nome da Fonte (Windows)
      //3.Tamanho em Pixels
      //5.Bold (T/F)
      oFont6  := TFont():New("Arial"      ,9,6 ,.T.,.F.,5,.T.,5,.T.,.F.)
      oFont8a := TFont():New("Arial"      ,9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
      oFont8c := TFont():New("Courier New",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
      oFont12c:= TFont():New("Courier New",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
      oFont10 := TFont():New("Arial"      ,9,10,.T.,.F.,5,.T.,5,.T.,.F.)
      oFont10N:= TFont():New("Arial"      ,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
      oFont16 := TFont():New("Arial"      ,9,12,.T.,.T.,5,.T.,5,.T.,.F.)
      oFont16n:= TFont():New("Arial"      ,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
      oFont24 := TFont():New("Arial"      ,9,24,.T.,.T.,5,.T.,5,.T.,.F.)
      oFontW  := TFont():New("Wingdings"  ,9,14,.T.,.F.,5,.T.,5,.T.,.F.)

      oBrush := TBrush():New("",4)

      oPrint:StartPage()   // Inicia uma nova página

      nInd   := 0
      nLinha := 100
      //nLinha := 250

      For nInd := 1 To 3
         oPrint:Line (nLinha + 0000,0100,nLinha + 0000,2300)
         oPrint:Line (nLinha + 0000,0550,nLinha - 0070,0550)
         oPrint:Line (nLinha + 0000,0800,nLinha - 0070,0800)
         If aDadosBanco[2] == "CAIXA"                                // IMPRESSAO LOGO
            // oPrint:Say  (nLinha - 0066,0100,aDadosBanco[2],oFont10) // [2]Nome do Banco
            oPrint:SayBitmap(nLinha - 0066,0100,"cef.bmp",180,54) // Logotipo do Banco
         Else
            oPrint:Say  (nLinha - 0066,0100,aDadosBanco[2],oFont10) // [2]Nome do Banco
         EndIf
         oPrint:Say  (nLinha - 0088,0567,Left(aDadosBanco[1],3)+"-"+Right(aDadosBanco[1],1),oFont24) // [1]Numero do Banco
         oPrint:Line (nLinha + 0100,0100,nLinha + 0100,2300)
         oPrint:Line (nLinha + 0200,0100,nLinha + 0200,2300)
         oPrint:Line (nLinha + 0340,0100,nLinha + 0340,2300)

         oPrint:Line (nLinha + 0200,0500,nLinha + 0270,0500)
         oPrint:Line (nLinha + 0200,1000,nLinha + 0270,1000)
         oPrint:Line (nLinha + 0200,1350,nLinha + 0270,1350)
         oPrint:Line (nLinha + 0200,1550,nLinha + 0270,1550)

         oPrint:Say  (nLinha + 0100,0100,"Beneficiário"                                   ,oFont6)
         oPrint:Say  (nLinha + 0100,1910,"Agência/Código Beneficiário"                    ,oFont6)
         oPrint:Say  (nLinha + 0200,0100,"Data do Documento"                              ,oFont6)
         oPrint:Say  (nLinha + 0230,0100,DTOC(aDadosTit[2])                               ,oFont8a) // Emissao do Titulo (E1_EMISSAO)
         oPrint:Say  (nLinha + 0200,0505,"Nro.Documento"                                  ,oFont6)
         If  xBanco = BANCOSANTANDER
            oPrint:Say  (nLinha + 0230,0605,aDadosTit[1]        ,oFont8a) //Numero+Parcela
         Else
            oPrint:Say  (nLinha + 0230,0605,aDadosTit[7]+aDadosTit[1]    ,oFont8a) //Prefixo+Numero+Parcela
         EndIf

         oPrint:Say  (nLinha + 0200,1005,"Espécie Doc."                                   ,oFont6)
         IF  xBanco = BANCOCITIBANK
            oPrint:Say  (nLinha + 0230,1050,"DMI"                                        ,oFont8a) //Tipo do Titulo
         Else
            oPrint:Say  (nLinha + 0230,1050,"DM"                                         ,oFont8a) //Tipo do Titulo
         EndIf
         oPrint:Say  (nLinha + 0200,1355,"Aceite"                                         ,oFont6)
         oPrint:Say  (nLinha + 0230,1455,"N"                                              ,oFont8a)
         oPrint:Say  (nLinha + 0200,1555,"Data do Processamento"                          ,oFont6)
         oPrint:Say  (nLinha + 0230,1655,DTOC(aDadosTit[3])                               ,oFont8a) // Data impressao
         oPrint:Say  (nLinha + 0200,1910,"Nosso Número"                                   ,oFont6)
         If   xBanco = BANCODOBRASIL
            oPrint:Say  (nLinha + 0120,0100,aDadosEmp[1] + " - " + aDadosEmp[6]              ,oFont8a) //Nome + CNPJ
            oPrint:Say  (nLinha + 0140,1890,PadL(xAgencia+"-"+xDvAgencia+" / "+xConta+"-"+xDvConta,20),oFont8c)
            oPrint:Say  (nLinha + 0150,0100,Alltrim(aDadosEmp[2]) + " - " + aDadosEmp[3] + " - " + aDadosEmp[4]  ,oFont8a)
            oPrint:Say  (nLinha + 0230,1990,PadL(xNossoNum,20),oFont8c)
            oPrint:Say  (nLinha + 0820,0505,""                          ,oFont6)
         ElseIf  xBanco = BANCOSANTANDER
            oPrint:Say  (nLinha + 0120,0100,aDadosEmp[1] + " - " + aDadosEmp[6]              ,oFont8a) //Nome + CNPJ
            oPrint:Say  (nLinha + 0140,1990,xAgencia+'-'+xDVAgencia+" / "+aDadosBanco[7], oFont8c)
            oPrint:Say  (nLinha + 0150,0100,Alltrim(aDadosEmp[2]) + " - " + aDadosEmp[3] + " - " + aDadosEmp[4]  ,oFont8a)
            oPrint:Say  (nLinha + 0230,1990,xNossoNum + "." + xDvNossoNum, oFont8c)
            oPrint:Say  (nLinha + 0820,0505,""                          ,oFont6)
         ElseIf  xBanco = "041"
         ElseIf  xBanco = "237"
         ElseIf  xBanco = BANCOITAU
            oPrint:Say  (nLinha + 0120,0100,aDadosEmp[1] + " - " + aDadosEmp[6]              ,oFont8a) //Nome + CNPJ
            oPrint:Say  (nLinha + 0140,1890,PadL(xAgencia+"/"+xConta+"-"+xDvConta,20)        ,oFont8c)
            oPrint:Say  (nLinha + 0150,0100,Alltrim(aDadosEmp[2]) + " - " + aDadosEmp[3] + " - " + aDadosEmp[4]  ,oFont8a)
            oPrint:Say  (nLinha + 0230,1890,PadL(xCartCob + "/" + xNossoNum + "-" + xDvNossoNum,20),oFont8c)
            oPrint:Say  (nLinha + 0820,0505,""                          ,oFont6)
         ElseIf  xBanco = BANCOREAL
            oPrint:Say  (nLinha + 0120,0100,aDadosEmp[1] + " - " + aDadosEmp[6]            ,oFont8a) //Nome + CNPJ
            oPrint:Say  (nLinha + 0140,1890,PadL(xAgencia+"/"+xConta+"/"+cDigitaoC,20)      ,oFont8c)
            oPrint:Say  (nLinha + 0150,0100,Alltrim(aDadosEmp[2]) + " - " + aDadosEmp[3] + " - " + aDadosEmp[4]  ,oFont8a)
            oPrint:Say  (nLinha + 0230,1890,Padl(xNossoNum,20),oFont8c)
            oPrint:Say  (nLinha + 0820,0505,""                          ,oFont6)

         ElseIf  xBanco = BANCOSAFRA
            oPrint:Say  (nLinha + 0120,0100,aDadosEmp[1] + " - " + aDadosEmp[6]            ,oFont8a) //Nome + CNPJ
            oPrint:Say  (nLinha + 0140,1890,PadL(xAgencia+"/"+xConta+"-"+xDvConta,20)      ,oFont8c)
            oPrint:Say  (nLinha + 0150,0100,Alltrim(aDadosEmp[2]) + " - " + aDadosEmp[3] + " - " + aDadosEmp[4]  ,oFont8a)
            oPrint:Say  (nLinha + 0230,1890,Padl(xNossoNum,20),oFont8c)
            oPrint:Say  (nLinha + 0820,0505,""                          ,oFont6)

         ElseIF  xBanco = BANCOCITIBANK
            oPrint:Say  (nLinha + 0120,0100,aDadosEmp[1] + " - " + aDadosEmp[6]              ,oFont8a) //Nome + CNPJ
            oPrint:Say  (nLinha + 0140,1990, xAgencia+"   "+aDadosBanco[7], oFont8c)
            oPrint:Say  (nLinha + 0150,0100,Alltrim(aDadosEmp[2]) + " - " + aDadosEmp[3] + " - " + aDadosEmp[4]  ,oFont8a)
            oPrint:Say  (nLinha + 0230,1990,xNossoNum + "." + xDvNossoNum, oFont8c)
            oPrint:Say  (nLinha + 0820,0505,""                          ,oFont6)
         ElseIf  xBanco = BANCOCAIXA                         // Cristiano
            oPrint:Say  (nLinha + 0120,0100,aDadosEmp[1] + " - " + aDadosEmp[6]              ,oFont8a) //Nome + CNPJ
            oPrint:Say  (nLinha + 0140,1890,PadL(xAgencia+"/"+ "680383" + " - 0 ",20)        ,oFont8c) // +xConta+"-"+xDvConta
            oPrint:Say  (nLinha + 0150,0100,Alltrim(aDadosEmp[2]) + aDadosEmp[3] + aDadosEmp[4] ,oFont8a) // " - " + "680383" + " - 0 "
            oPrint:Say  (nLinha + 0230,1910,ALLTRIM(SUBSTR(xCartCob, 2, 2) + PADL(xNossoNum, 15 ,"0")) + "-" + xDvNossoNum, oFont8c)
            oPrint:Say  (nLinha + 0820,0505,""                          ,oFont6)
         EndIf

         If nInd > 0  //1
            oPrint:Line (nLinha + 0200,0500,nLinha + 0340,0500)
            oPrint:Line (nLinha + 0270,0750,nLinha + 0340,0750)
            oPrint:Line (nLinha + 0200,1000,nLinha + 0340,1000)
            oPrint:Line (nLinha + 0200,1350,nLinha + 0270,1350)
            oPrint:Line (nLinha + 0200,1550,nLinha + 0340,1550)
            oPrint:Say  (nLinha + 0000,0100,"Local de Pagamento"                             ,oFont8a)
            oPrint:Say  (nLinha + 0025,0100,xMsg1                                            ,oFont10)
            oPrint:Say  (nLinha + 0065,0100,xMsg2                                            ,oFont10)
            oPrint:Say  (nLinha + 0000,1910,"Vencimento"                                     ,oFont6)
            oPrint:Say  (nLinha + 0040,1890,PadL(If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",DTOC(aDadosTit[4])),20),oFont8c)
            oPrint:Line (nLinha + 0270,0100,nLinha + 0270,2300)
            oPrint:Say  (nLinha + 0270,0100,"Uso do Banco"                                   ,oFont6)
            oPrint:Say  (nLinha + 0270,0505,"Carteira"                                       ,oFont6)

            If  xBanco = BANCOSAFRA
               oPrint:Say  (nLinha + 0300,0555,aDadosBanco[6]                               ,oFont8a)
            Else
               oPrint:Say  (nLinha + 0300,0555,"RG"                                 ,oFont8a)  // aDadosBanco[6]
            EndIf

            oPrint:Say  (nLinha + 0270,0755,"Espécie"                                        ,oFont6)
            oPrint:Say  (nLinha + 0300,0805,"R$"                                             ,oFont8a)
            oPrint:Say  (nLinha + 0270,1005,"Quantidade"                                     ,oFont6)
            oPrint:Say  (nLinha + 0270,1555,"(x) Valor"                                      ,oFont6)
         EndIf
         oPrint:Say  (nLinha + 0270,1910,"Valor do Documento"                           ,oFont6)
         oPrint:Say  (nLinha + 0300,2010,Padl(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),20),oFont8a)

         If nInd > 0 //1
            oPrint:Say  (nLinha + 0340,0100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário)",oFont6)
            oPrint:Say  (nLinha + 0380,0100,aBolText[1], oFont8a)
            oPrint:Say  (nLinha + 0430-15,0100,aBolText[2], oFont8a)
            oPrint:Say  (nLinha + 0480-30,0100,aBolText[3], oFont8a)
            oPrint:Say  (nLinha + 0530-45,0100,aBolText[4], oFont8a)   // especifico para instrucao de descontos
            oPrint:Say  (nLinha + 0580-60,0100,aBolText[5], oFont8a)
            oPrint:Say  (nLinha + 0630-75,0100,aBolText[6], oFont8a)
            oPrint:Say  (nLinha + 0680-90,0100,aBolText[7], oFont8a)
            oPrint:Say  (nLinha + 0730-105,0100,aBolText[8], oFont8a)
            oPrint:Say  (nLinha + 0780-120,0100,aBolText[9], oFont8a)
            oPrint:Say  (nLinha + 0340,1910,"(-)Desconto/Abatimento", oFont6)
            If aDadosTit[15] > 0
               oPrint:Say  (nLinha + 0270,2010,AllTrim(Transform(aDadosTit[15],"@E 999,999,999.99")),oFont8a)
            Endif
            oPrint:Say  (nLinha + 0410,1910,"(-)Outras Deduções"                             ,oFont6)
            oPrint:Say  (nLinha + 0480,1910,"(+)Mora/Multa"                                  ,oFont6)
            oPrint:Say  (nLinha + 0550,1910,"(+)Outros Acréscimos"                           ,oFont6)
            oPrint:Say  (nLinha + 0620,1910,"(=)Valor Cobrado"                               ,oFont6)
            oPrint:Say  (nLinha + 0690,0100,"Pagador"                                        ,oFont6)
            oPrint:Say  (nLinha + 0700,0300,aDatSacado[1]+" ("+aDatSacado[2]+") - " + TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99") ,oFont8a)
            oPrint:Say  (nLinha + 0735,0300,aDatSacado[3]                                    ,oFont8a)
            oPrint:Say  (nLinha + 0770,0300,Transform(aDatSacado[6],"@R 99.999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8a) // CEP+Cidade+Estado
            oPrint:Say  (nLinha + 0820,0100,"Sacador/Avalista"                             ,oFont6)
            oPrint:Line (nLinha + 0000,1900,nLinha + 0690,1900)
            oPrint:Line (nLinha + 0410,1900,nLinha + 0410,2300)
            oPrint:Line (nLinha + 0480,1900,nLinha + 0480,2300)
            oPrint:Line (nLinha + 0550,1900,nLinha + 0550,2300)
            oPrint:Line (nLinha + 0620,1900,nLinha + 0620,2300)
            oPrint:Line (nLinha + 0690,0100,nLinha + 0690,2300)
            oPrint:Line (nLinha + 0840,0100,nLinha + 0840,2300)
         EndIf

         If nInd = 1
            oPrint:Say  (nLinha - 0070,1990,"Controle do Beneficiário",oFont10)
         ElseIf nInd = 2
            If  xBanco = BANCOSAFRA
               oPrint:Say  (nLinha - 0070,2000,"Recibo do Pagador",oFont10)
               oPrint:Say  (nLinha + 0850,1500,"Autenticação Mecânica",oFont8a)
               oPrint:Say  (nLinha - 0140,0100,"#",oFontW)
               For i := 100 to 2300 step 10
                  oPrint:Line( nLinha - 0100, i, nLinha - 0100, i+5)
               Next i

            Else
               oPrint:Say  (nLinha + 0645,0100,"SAC CAIXA 0800 726 0101, Ouvidoria 0800 725 7474, Para pessoas com deficiência auditiva ou de fala 0800 726 2492 e www.caixa.gov.br" ,oFont6)
               oPrint:Say  (nLinha - 0070,2000,"Recibo do Pagador",oFont10)
               oPrint:Say  (nLinha + 0850,1500,"Autenticação Mecânica",oFont8a)
               oPrint:Say  (nLinha - 0140,0100,"#",oFontW)
               For i := 100 to 2300 step 10
                  oPrint:Line( nLinha - 0100, i, nLinha - 0100, i+5)
               Next i
            Endif
         ElseIf  nInd = 3
            oPrint:Say  (nLinha - 0140,0100,"#",oFontW)
            For i := 100 to 2300 step 10
               oPrint:Line( nLinha - 0100, i, nLinha - 0100, i+5)
            Next i
            oPrint:Say  (nLinha - 0066,0820,CB_RN_NN[2],oFont16n) // Linha Digitavel do Codigo de Barras
            oPrint:Say  (nLinha + 0850,1500,"Autenticação Mecânica   -   Ficha de Compensação",oFont8a)

            //    CODIGO DE BARRAS PARA CONFERENCIA

            If lConferencia
               oPrint:Say  (nLinha + 0490,0100,CB_RN_NN[1],oFont12C)
               oPrint:Say  (nLinha + 0540,0100,"12345678901234567890123456789012345678901234",oFont12C)
               oPrint:Say  (nLinha + 0590,0100,"         1         2         3         4    ",oFont12C)
            EndIf
         EndIf
         nLinha += 1000
      Next

      // este problema de impressao com a HP 1022 foi solucionado com o Protheus 10
      // nao sendo mais necessario esta intervencao no codigo
      //If ! lHp
      // MSBAR3("INT25",25.5,1,CB_RN_NN[1],oPrint,.F.,,,,1.3,,,,.F.)
      MSBAR3("INT25",25.5,1,CB_RN_NN[1],oPrint,.F.,,,,1.3,,,,.F.)

      //Else
      // MSBAR3("INT25",13.5,1,CB_RN_NN[1],oPrint,.F.,,,,1.3,,,,.F.)
      //EndIf

   endif  // lImprime
   ConOut("#Leef-console# No jhr100Bo, chamou o impress e vai entrar no lGravaNn")
   If lGravaNn
      ConOut("#Leef-console# No jhr100Bo, Passou lGravaNh")
      DbSelectArea("SE1")
      DbSetOrder(1)
      If DbSeek(xFilial("SE1") + T_SE1->E1_PREFIXO + T_SE1->E1_NUM + T_SE1->E1_PARCELA + T_SE1->E1_TIPO)

         // atualiza dados do SE1
         RecLock("SE1",.F.)
         SE1->E1_PORTADO := xBanco
         SE1->E1_AGEBOL  := yAgencia
         SE1->E1_CTABOL  := yConta
         SE1->E1_SUBBOL  := ySubCta

         // tratamento do decrescimo
         If ! Empty(aBolText[4])
            nValDesc := 0
            SE1->E1_OBSDESC := aBolText[4]
            If aDesc <> nil
               If aDesc[1]>0 .or. aDesc[2]>0
                  If aDesc[1]>0  // desconto em %
                     // calcula o valor do desconto
                     nValDesc := aDadosTit[5]*aDesc[1]/100
                     // alimenta os campos de decrescimo
                     SE1->E1_DECRESC := nValDesc
                     SE1->E1_SDDECRE := nValDesc
                  ElseIf aDesc[2]>0  // desconto em valor
                     // alimenta os campos de decrescimo
                     SE1->E1_DECRESC := aDesc[2]
                     SE1->E1_SDDECRE := aDesc[2]
                  EndIf
               Endif
            EndIf
         EndIf

         // grava numero bancario no titulo
         If xBanco = BANCODOBRASIL
            SE1->E1_NUMBCO  := Right(xNossoNum,10)
         ElseIf  xBanco = BANCOSANTANDER
            SE1->E1_NUMBCO  := Alltrim(yNossoNum) + xDvNossoNum
         ElseIf  xBanco = "041"
         ElseIf  xBanco = "237"
         ElseIf  xBanco = BANCOITAU
            SE1->E1_NUMBCO  := yNossoNum + xDvNossoNum
         ElseIf  xBanco = BANCOREAL
            SE1->E1_NUMBCO  := Alltrim(yNossoNum)

         ElseIf  xBanco = BANCOSAFRA
            SE1->E1_NUMBCO  := Alltrim(yNossoNum) //+ xDvNossoNum

         ElseIF  xBanco = BANCOCITIBANK
            SE1->E1_NUMBCO  := xNossoNum + xDvNossoNum
         ElseIf  xBanco = BANCOCAIXA
            SE1->E1_NUMBCO  := yNossoNum + xDvNossoNum
         EndIf
         SE1->( MsUnLock() )

         // atualiza os parametros do banco
         DbSelectArea("SEE")
         //  RecLock("SEE",.F.)
         If  xBanco = BANCODOBRASIL
            cFaixaAtu := StrZero((Val(cFaixaAtu) + 1),10)
            SEE->EE_FAXATU := cFaixaAtu
         ElseIf  xBanco = BANCOSANTANDER
            RecLock("SEE",.F.)
            yNossoNum := StrZero((Val(cFaixaAtu) + 1),12)
            cFaixaAtu := yNossoNum
            SEE->EE_FAXATU := cFaixaAtu
         ElseIf  xBanco = "041"
         ElseIf  xBanco = "237"
         ElseIf  xBanco = BANCOITAU
            yNossoNum := SOMA1(yNossoNum)
            cFaixaAtu := yNossoNum   // SOMA1(yNossoNum)
            SEE->EE_FAXATU := cFaixaAtu
         ElseIf  xBanco = BANCOREAL
            RecLock("SEE",.F.)
            yNossoNum := StrZero((Val(cFaixaAtu) + 1),12)
            cFaixaAtu := yNossoNum  //Right(SOMA1(yNossoNum),12)
            SEE->EE_FAXATU := cFaixaAtu

         ElseIf  xBanco = BANCOSAFRA
            RecLock("SEE",.F.)
            yNossoNum := StrZero(Val(cFaixaAtu)+1, 9)
            cFaixaAtu := yNossoNum
            SEE->EE_FAXATU := cFaixaAtu

         ElseIf  xBanco = BANCOCITIBANK
            cFaixaAtu := StrZero((Val(cFaixaAtu) + 1),11)
            SEE->EE_FAXATU := cFaixaAtu
         ElseIf  xBanco = BANCOCAIXA
            yNossoNum := SOMA1(yNossoNum)
            cFaixaAtu := yNossoNum   // SOMA1(yNossoNum)
            SEE->EE_FAXATU := Right(cFaixaAtu,Len(SEE->EE_FAXATU))
         EndIf
         //  SEE->( MsUnLock() )

      else
         ConOut("#Leef-console# No jhr100Bo, Seek na SE1 nao achou")
      EndIf
   else
      ConOut("#Leef-console# No jhr100Bo, ta falso o lGravaNh")
   EndIf

   SEE->( MsUnLock() ) // Jean Rehermann - A liberacao do SEE deve ocorrer fora do (If lGravaNn)

   if lImprime
      oPrint:EndPage() // Finaliza a página
   endif

Return Nil

///*/
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Programa  ³ Modulo10 ³ Autor ³                       ³ Data ³          ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ IMPRESSAO DO BOLETO C/ CODIGO DE BARRAS                    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Uso       ³ JMHR100                                                    ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
///*/

Static Function BbMod10() // Banco do Brasil

   Local i := 0

   M->nCont := 0
   M->cPeso := 9

   For i := 11 To 1 Step -1
      M->nCont := M->nCont + (Val(SUBSTR(M->NumBoleta,i,1))) * M->cPeso
      M->cPeso := M->cPeso - 1
      If M->cPeso == 1
         M->cPeso := 9
      Endif
   Next
   M->Resto := ( M->nCont % 11 )
   If M->Resto < 10
      M->DV_NNUM := Str(Resto,1)
   Else
      M->DV_NNUM := "X"
   EndIf

Return


//------------------------------------------------------------------------------------------------------------------
Static Function Modulo10(cData)

   LOCAL L, D, P, nInt := 0

   L := Len(cdata)
   D := 0
   P := 2
   N := 0

   Do While L > 0
      N := (Val(SubStr(cData, L, 1)) * P)
      If N > 9
         D := D + (N - 9)
      Else
         D := D + N
      Endif
      If P = 2
         P := 1
      Elseif P = 1
         P := 2
      EndIf
      L := L - 1
   EndDo

   D := Mod(D,10)
   D := 10 - D

   If D == 10
      D:=0
   Endif

Return(D)


///*/
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Funcao    ³ Modulo11 ³ Autor ³                       ³ Data ³          ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ IMPRESSAO DO BOLETO C/ CODIGO DE BARRAS                    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Uso       ³ JMHR100                                                    ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
///*/

Static Function Modulo11(cData,lCaixa) //Modulo 11 com base 7

   LOCAL L, D, P := 0

   L := Len(cdata)
   D := 0
   P := 1
   DV:= " "
   nResto := 0

   Do While L > 0

      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 9  //Volta para o inicio, ou seja comeca a multiplicar por 9,8,7...
         P := 1
      End
      L := L - 1
   EndDo

   nResto := mod(D,11)  //Resto da Divisao

   If lCaixa == .T.

      DV := (11 - nResto)

      If DV > 9
         DV := 0
      EndIf
   Else

      If   nResto = 0
         DV := 1
      ElseIf nResto = 1
         DV := 0
      Else
         DV := (11 - nResto)
      EndIf

   EndIf

Return(DV)

///*/
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Funcao    ³ Mod11Citi ³ Autor ³                      ³ Data ³          ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ IMPRESSAO DO BOLETO C/ CODIGO DE BARRAS                    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Uso       ³ JMHR100                                                    ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
///*/

Static Function Mod11Citi(cData)

   LOCAL L, D, P := 0

   L := Len(cdata)
   D := 0
   P := 1
   DV:= " "
   nResto := 0

   Do While L > 0

      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 9  //Volta para o inicio, ou seja comeca a multiplicar por 9,8,7...
         P := 1
      End
      L := L - 1
   EndDo

   nResto := mod(D,11)  //Resto da Divisao

   If nResto = 0 .or. nResto = 1
      DV := 0
   Else
      DV := (11 - nResto)
   EndIf

Return(DV)


//-------------------------------------------------------------------------------
// MODULO 11 BASE 9
Static Function Mod11CB(cData) // Modulo 11 com base 9

   LOCAL CBL, CBD, CBP := 0

   CBL := Len(cdata)
   CBD := 0
   CBP := 1

   Do While CBL > 0
      CBP := CBP + 1
      CBD := CBD + (Val(SubStr(cData, CBL, 1)) * CBP)
      If CBP = 9
         CBP := 1
      End
      CBL := CBL - 1
   EndDo

   _nCBResto := Mod(CBD,11)  //Resto da Divisao
   CBD := 11 - _nCBResto
   If (CBD == 0 .Or. CBD == 1 .Or. CBD == 10 .Or. CBD == 11)
      CBD := 1
   End

Return(CBD)


///*
//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
//*/

Static Function NNumDV(xCampo) //Calculo do Digito Verificador do Nosso Numero

   Local i := 0
   lPeso1  := .F.
   nCont   := 0
   cCampo  := xCampo

   For i := Len( cCampo ) To 1 Step -1
      If lPeso1
         nVal  := Val( SubStr( cCampo, i, 1 ) )
         nCont += nVal
      Else
         nVal  := Val( SubStr( cCampo, i, 1 ) ) * 2
         If nVal > 9
            nCont += ( nVal - 9 )
         Else
            nCont += nVal
         EndIf
      EndIf
      lPeso1 := !lPeso1
   Next
   If nCont < 10
      Resto := nCont
   Else
      Resto := ( nCont % 10 )
   EndIf
   If Resto == 0
      DV_NNUM := "0"
   Else
      Resto := 10 - Resto
      DV_NNUM := Str( Resto, 1 )
   EndIf
   // calcular o segundo digito verificador...
   // calculo atraves do modulo 11
   Do While .t.
      cCampo := xCampo + DV_NNUM
      nCont := 0
      nPeso := 2
      For i := Len( cCampo ) to 1 Step -1
         nCont += Val( SubStr( cCampo, i, 1 ) ) * nPeso
         nPeso ++
         If nPeso == 8
            nPeso := 2
         EndIf
      Next
      If nCont < 11
         Resto := nCont
      Else
         Resto := ( nCont % 11 )
      EndIf
      If Resto == 1
         If DV_NNUM  == "9"
            DV_NNUM := "0"
         Else
            DV_NNUM := Str ( Val( DV_NNUM ) + 1, 1 )
         EndIf
         Loop
      ElseIf Resto == 0
         DV_NNUM += "0"
      Else
         Resto := 11 - Resto
         DV_NNUM += Str( Resto, 1 )
      EndIf
      Exit
   EndDo

Return (DV_NNUM)


//------------------------------------------------------------------------------------------------------------------
Static Function BbBarraDv(B_Campo)

   Local nCont := 0
   Local cPeso := 2
   Local Resto
   Local Result
   Local DV_BARRA
   Local i := 0
   // Banco do Brasil

   For i := 43 To 1 Step -1
      nCont := nCont + ( Val( SUBSTR( B_Campo,i,1 )) * cPeso )
      cPeso := cPeso + 1
      If cPeso >  9
         cPeso := 2
      Endif
   Next
   Resto  := ( nCont % 11 )
   Result := ( 11 - Resto )
   Do Case
      Case Result == 10 .or. Result == 11
         DV_BARRA := "1"
         OtherWise
         DV_BARRA := Str(M->Result,1)
   EndCase

Return(DV_BARRA)

Static Function BbLdDv(cCampo)

   Local i := 0
   // Banco do Brasil
   nCont  := 0
   Peso   := 2

   For i := Len(Pedaco) to 1 Step -1

      If Peso == 3
         Peso := 1
      Endif

      If Val(SUBSTR(Pedaco,i,1))*Peso >= 10
         nVal  := Val(SUBSTR(Pedaco,i,1)) * Peso
         nCont := nCont+(Val(SUBSTR(Str(nVal,2),1,1))+Val(SUBSTR(Str(nVal,2),2,1)))
      Else
         nCont:=nCont+(Val(SUBSTR(Pedaco,i,1))* Peso)
      Endif

      Peso := Peso + 1
   Next

   Dezena  := Substr(Str(nCont,2),1,1)
   Resto   := ( (Val(Dezena)+1) * 10) - nCont
   If Resto   == 10
      nDigito := "0"
   Else
      nDigito := Str(Resto,1)
   Endif

Return(nDigito)

///*/
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Programa  ³Ret_cBarra³ Autor ³ Fabio Briddi          ³ Data ³ 22/06/07 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ Retorna Linha Digitavel, Linha Codigo Barras e Nosso Numero³±±
//±±³          ³ RN = Linha Digitavel                                       ³±±
//±±³          ³ CB = Codigo de Barras                                      ³±±
//±±³          ³ NN = Nosso Numero                                          ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Uso       ³ JMHR100                                                    ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
///*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)

   LOCAL bldocnufinal := AllTrim(_cNossoNum)
   LOCAL blvalorfinal := strzero(nValor*100,10)
   LOCAL dvnn         := 0
   LOCAL dvcb         := 0
   LOCAL dv           := 0
   LOCAL NN           := ''
   LOCAL RN           := ''
   LOCAL CB           := ''
   LOCAL s            := ''
   Local dDtBase    := ctod("07/10/1997")
   Local cFatorVencto := ""
   Local cBloco1 := cBloco2 := cBloco3 := K := cDgK := cBloco4 := ''

   //Calculo do Fator de Vencimento do Titulo
   cFatorVencto := Str(T_SE1->E1_VENCREA - dDtBase,4)

   // - Montagem do Nosso Numero
   If   xBanco = BANCODOBRASIL
      snn  := AllTrim(bldocnufinal)     // Nosso Numero
      NN   := AllTrim(bldocnufinal)
   ElseIf  xBanco = BANCOSANTANDER
      snn  := bldocnufinal
      dvnn := Mod11Citi(snn)
      xDvNossoNum := AllTrim(Str(dvnn))
      NN   := AllTrim(bldocnufinal)
   ElseIf  xBanco = "041"
   ElseIf  xBanco = "237"
   ElseIf xBanco = BANCOITAU
      snn  := xAgencia + SubStr(xConta,1,5) + cCarteira + bldocnufinal     // Agencia + Conta + Carteira + Nosso Numero
      dvnn := modulo10(snn)    // Digito verificador no Nosso Numero
      NN   := cCarteira + BlDocNuFinal + AllTrim(Str(dvnn))
      xDvNossoNum := AllTrim(Str(dvnn))
   ElseIf  xBanco = BANCOREAL
      //7 posicoes para cobranca com registro e 13 posicoes para cobranca sem registro
      cNroDoc := StrZero(Val(cNroDoc),7)

   ElseIf  xBanco = BANCOSAFRA
      snn  := bldocnufinal
      dvnn := Modulo11(snn, .f.)
      xDvNossoNum := AllTrim(Str(dvnn))
      NN   := AllTrim(bldocnufinal)

   ElseIf  xBanco = BANCOCITIBANK
      NN   := Substr(xCodCedente,2)
      snn  := AllTrim(bldocnufinal)     // Nosso Numero
      dvnn := Mod11Citi(snn)    // Digito verificador no Nosso Numero
      xDvNossoNum := AllTrim(Str(dvnn))
   ElseIf xBanco = BANCOCAIXA
      snn  := ALLTRIM(SUBSTR(cCarteira, 2, 2)) + ALLTRIM(PADL(BlDocNuFinal, 15 ,"0"))     // Agencia + Conta + Carteira + Nosso Numero
      dvnn := modulo11(snn,.T.)    // Digito verificador no Nosso Numero
      NN   := ALLTRIM(SUBSTR(cCarteira, 2, 2)) + ALLTRIM(PADL(BlDocNuFinal, 15 ,"0")) + AllTrim(Str(dvnn))
      xDvNossoNum := AllTrim(Str(dvnn))
   EndIf


   // - MONTAGEM DOS DADOS PARA O CODIGO DE BARRAS
   If   xBanco = BANCODOBRASIL
      scb := "001"  + "9" + cFatorVencto + blvalorfinal + "000000" + NN + xCartCob
      //Calculo do Digito do Codigo de Barras
      cDDV := BbBarraDv(scb)
      //Compor a barra com o Digito verificador
      CB := "001"  + "9" + cDDV + cFatorVencto + blvalorfinal + "000000" + NN + xCartCob

   ElseIf  xBanco = BANCOSANTANDER
      scb := "033"  + "9" + cFatorVencto + blvalorfinal + "9" + xCodCedente + NN + xDvNossoNum + "0" + xCartCob
      //Calculo do Digito do Codigo de Barras
      cDDV := Str(Mod11CB(scb),1)
      //Compor a barra com o Digito verificador
      CB := "033"  + "9" + cDDV + cFatorVencto + blvalorfinal + "9" + xCodCedente + NN + xDvNossoNum + "0" + xCartCob

   ElseIf  xBanco = "041" // Banrisul

   ElseIf  xBanco = "237" // Bradesco

   ElseIf  xBanco = BANCOITAU
      scb  := cBanco + "9" + cFatorVencto + blvalorfinal + NN + cAgencia + cConta + cDacCC + "000"
      dvcb := mod11CB(scb) //digito verificador do codigo de barras
      CB   := SubStr(scb,1,4) + AllTrim(Str(dvcb)) + SubStr(scb,5,39)

   ElseIf  xBanco = BANCOREAL
      cInfo   := cNroDoc+Alltrim(cAgencia)+cConta
      cDigitaoC := Alltrim(Str(Digitao(cInfo),1))
      //K = Digitao do codigo de barras
      // para calculo, devo passar o NOSSO NUMERO sempre com 13 posicoes (completados com zeros aa esquerda)
      K    := cBanco + "9" + cFatorVencto + blvalorfinal + Alltrim(cAgencia) + alltrim(cConta) + cDigitaoC + Strzero(Val(cNroDoc),13)
      cDgK := AllTrim(Str(modulo11(K,.F.)))
      CB   := cBanco + "9" + cDgK + cFatorVencto + StrZero((nValor * 100),10) + Alltrim(cAgencia) + cConta + cDigitaoC + Strzero(Val(cNroDoc),13)

   ElseIf  xBanco = BANCOSAFRA // Safra
      scb  := cBanco + "9" + cFatorVencto + blvalorfinal + '7' + cAgencia + cConta + xDvConta + NN + '2'
      dvcb := Mod11CB(scb) //digito verificador do codigo de barras
      CB   := SubStr(scb,1,4) + AllTrim(Str(dvcb)) + cFatorVencto + blvalorfinal + '7' + cAgencia + cConta + xDvConta + NN + '2'

   ElseIf  xBanco = BANCOCITIBANK
      scb := "745" + "9" + cFatorVencto + blvalorfinal + "3" + xCartCob + NN + snn + xDvNossoNum
      //Calculo do Digito do Codigo de Barras
      cDDV := BbBarraDv(scb)
      //Compor a barra com o Digito verificador
      CB := "745" + "9" + cDDV + cFatorVencto + blvalorfinal + "3" + xCartCob + NN + snn + xDvNossoNum

   ElseIf  xBanco = BANCOCAIXA
      scb  := cBanco + "9"
      scb  += cFatorVencto
      scb  += blvalorfinal

      dlv  := "6803830"
      dlv  += SUBSTR(SNN, 3,3)
      dlv  += SUBSTR(SNN, 1,1)
      dlv  += SUBSTR(SNN, 6,3)
      dlv  += SUBSTR(SNN, 2,1)
      dlv  += SUBSTR(SNN, 9,9)

      scb  += dlv
      scb  += alltrim(str(modulo11(dlv,.T.)))

      dvcb := mod11CB(scb) //digito verificador do codigo de barras

      CB   := SubStr(scb,1,4) + AllTrim(Str(dvcb)) + SubStr(scb,5,39)
   EndIf

   // - Montagem da Linha Digitavel
   If   xBanco = BANCODOBRASIL
      cDigito := ""
      Pedaco  := ""
      //Primeiro Campo
      //Codigo do Banco + Moeda + 5 primeiras posições do campo livre do Cod Barras
      Pedaco  := Substr(CB,01,03) + Substr(CB,04,01) + Substr(CB,20,5)
      cDigito := BbLdDv(Pedaco)
      cCampo1 :=  Substr(CB,1,3) + Substr(CB,4,1) + Substr(CB,20,1) + "." +;
      Substr(CB,21,4) + cDigito + Space(2)
      //Segundo Campo
      Pedaco  := Substr(CB,25,10)
      cDigito := BbLdDv(Pedaco)
      cCampo2 := Substr(Pedaco,1,5) + "." + Substr(Pedaco,6,5) + cDigito + Space(2)
      //Terceiro Campo
      Pedaco  := Substr(CB,35,10)
      cDigito := BbLdDv(Pedaco)
      cCampo3 := Substr(Pedaco,1,5) + "." + Substr(Pedaco,6,5) + cDigito + Space(2)
      //Quarto Campo
      cCampo4 := SubStr(CB,5,1) + Space(2)
      //Quinto Campo
      cCampo5  := cFatorVencto + blvalorfinal
      RN := cCampo1 + cCampo2 + cCampo3 + cCampo4 + cCampo5

   ElseIf  xBanco = BANCOSANTANDER
      cDigito := ""
      Pedaco  := ""
      //Primeiro Campo
      //Codigo do Banco + Moeda + 5 primeiras posições do campo livre do Cod Barras
      Pedaco  := Substr(CB,01,03) + Substr(CB,04,01) + Substr(CB,20,5)
      cDigito := Str(modulo10(Pedaco),1)
      cCampo1 :=  Substr(CB,1,3) + Substr(CB,4,1) + Substr(CB,20,1) + "." +;
      Substr(CB,21,4) + cDigito + Space(2)
      //Segundo Campo
      Pedaco  := Substr(CB,25,10)
      cDigito := Str(modulo10(Pedaco),1)
      cCampo2 := Substr(Pedaco,1,5) + "." + Substr(Pedaco,6,5) + cDigito + Space(2)
      //Terceiro Campo
      Pedaco  := Substr(CB,35,10)
      cDigito := Str(modulo10(Pedaco),1)
      cCampo3 := Substr(Pedaco,1,5) + "." + Substr(Pedaco,6,5) + cDigito + Space(2)
      //Quarto Campo
      cCampo4 := SubStr(CB,5,1) + Space(2)
      //Quinto Campo
      cCampo5  := cFatorVencto + blvalorfinal
      RN := cCampo1 + cCampo2 + cCampo3 + cCampo4 + cCampo5
   ElseIf  xBanco = "041" // Banrisul
   ElseIf  xBanco = "237" // Bradesco
   ElseIf  xBanco = BANCOITAU
      srn := cBanco + "9" + cCarteira + SubsTr(BlDocNuFinal,1,2)
      dv := modulo10(srn)
      RN := SubStr(srn, 1, 5) + '.' + SubStr(srn,6,4) + AllTrim(Str(dv)) + ' '
      srn := SubsTr(bldocnuFinal,3) + (AllTrim(Str(DvNN))) + SubsTr(cAgencia,1,3) // posicao 6 a 15 do campo livre
      dv := modulo10(srn)
      RN := RN + SubStr(srn,1,5) + '.' + SubStr(srn,6,5) + AllTrim(Str(dv)) + ' '
      srn := SubsTr(cAgencia,4,1) + cConta + cDacCC + "000" // posicao 16 a 25 do campo livre
      dv := modulo10(srn)
      RN := RN + SubStr(srn,1,5) + '.' + SubStr(srn,6,5)+AllTrim(Str(dv)) + ' '
      RN := RN + AllTrim(Str(dvcb)) + ' '
      RN := RN + cFatorVencto + StrZero((nValor * 100),10)
   ElseIf  xBanco = BANCOREAL
      //BLOCO 1 - CODBANCO + COD.MOEDA + COD.AGENCIA          + A PRIMEIRA POSICAO DO NUM DA CONTA CORRENTE + DIGITO VERIFICADOR DESTE BLOCO
      scb     := xBanco    +    "9"    + Alltrim(cAgencia)    + SubStr(cConta,1,1)
      dvcb    := modulo10(scb) //digito verificador do codigo de barras
      cBloco1 := scb + AllTrim(Str(dvcb))
      cBloco1 := SubStr(cBloco1,1,5) + '.' + SubStr(cBloco1,6,5)

      //BLOCO 2 - 2POS CONTA ATE A 7POS + DIGITAO DA COBRANCA + 3PRIMEIRAS POS DO CAMPO NOSSO NUMERO + DIGITO VERIFICADOR DESTE BLOCO
      cInfo   := cNroDoc+Alltrim(cAgencia)+cConta
      cDigitaoC := Alltrim(Str(Digitao(cInfo),1))
      scb     := SubStr(cConta,2,6) + cDigitaoC + SubStr(cNroDoc,1,3)
      dvcb    := modulo10(scb) //digito verificador do codigo de barras
      cBloco2 := scb + AllTrim(Str(dvcb))
      cBloco2 := SubStr(cBloco2,1,5) + '.' + SubStr(cBloco2,6,6)

      //BLOCO 3- da 4pos. ate a 13pos do nosso numero + digito verificado deste bloco
      // para calculo, o NOSSO NUMERO sempre deve ter 13 posicoes (completados com zeros aa esquerda)
      scb     := Strzero(Val(SubStr(cNroDoc,4)),10)
      dvcb    := modulo10(scb) //digito verificador do codigo de barras
      cBloco3 := scb + AllTrim(Str(dvcb))
      cBloco3 := SubStr(cBloco3,1,5) + '.' + SubStr(cBloco3,6,6)

      //BLOCO 4- clculo do digitao do codigo de barras
      //K = Digitao do codigo de barras
      // para calculo, devo passar o NOSSO NUMERO sempre com 13 posicoes (completados com zeros aa esquerda)
      K       := cBanco + "9" + cFatorVencto + blvalorfinal + Alltrim(cAgencia) + alltrim(cConta) + cDigitaoC + Strzero(Val(cNroDoc),13)
      cDgK := AllTrim(Str(modulo11(K,.f.)))
      // fator de vencimento  + vlr titulo
      cBloco4 := cFatorVencto + blvalorfinal
      RN := cBloco1 + ' ' + cBloco2 + ' ' + cBloco3 + ' ' + cDgK + ' ' +cBloco4

   ElseIf  xBanco = BANCOSAFRA // Safra
      srn := cBanco + "9" + '7' + SubsTr(cAgencia,1,4)
      dv := Mod10Saf(srn)
      RN := SubStr(srn, 1, 5) + '.' + SubStr(srn,6,4) + AllTrim(Str(dv)) + ' '

      srn := SubStr(cAgencia,5,1) + cConta + xDvConta
      dv := Mod10Saf(srn)
      RN := RN + SubStr(srn,1,5) + '.' + SubStr(srn,6,5) + AllTrim(Str(dv)) + ' '

      srn := NN + '2'
      dv := Mod10Saf(srn)
      RN := RN + SubStr(srn,1,5) + '.' + SubStr(srn,6,5)+AllTrim(Str(dv)) + ' '

      RN := RN + AllTrim(Str(dvcb)) + ' '
      RN := RN + cFatorVencto + StrZero((nValor * 100),10)

   ElseIf  xBanco = BANCOCITIBANK
      cDigito := ""
      Pedaco  := ""
      //Primeiro Campo
      //Codigo do Banco + Moeda + 5 primeiras posições do campo livre do Cod Barras
      Pedaco  := Substr(CB,01,03) + Substr(CB,04,01) + Substr(CB,20,5)
      cDigito := BbLdDv(Pedaco)
      cCampo1 :=  Substr(CB,1,3) + Substr(CB,4,1) + Substr(CB,20,1) + "." + Substr(CB,21,4) + cDigito + Space(2)
      //Segundo Campo
      Pedaco  := Substr(CB,25,10)
      cDigito := BbLdDv(Pedaco)
      cCampo2 := Substr(Pedaco,1,5) + "." + Substr(Pedaco,6,5) + cDigito + Space(2)
      //Terceiro Campo
      Pedaco  := Substr(CB,35,10)
      cDigito := BbLdDv(Pedaco)
      cCampo3 := Substr(Pedaco,1,5) + "." + Substr(Pedaco,6,5) + cDigito + Space(2)
      //Quarto Campo
      cCampo4 := SubStr(CB,5,1) + Space(2)
      //Quinto Campo
      cCampo5  := cFatorVencto + blvalorfinal
      RN := cCampo1 + cCampo2 + cCampo3 + cCampo4 + cCampo5
   ElseIf  xBanco = BANCOCAIXA // REVISAR MOD CAIXA

      cLd1 := SUBSTR(CB, 1,4) + SUBSTR(CB, 20,5)
      dLd1 := modulo10(cLd1)

      cLd2 := SUBSTR(CB, 25,10)
      dLd2 := modulo10(cLd2)

      cLd3 := SUBSTR(CB, 35,10)
      dLd3 := modulo10(cLd3)

      dLdG := dvcb

      tLdF := cLd1 + alltrim(str(dLd1)) + cLd2 + alltrim(str(dLd2)) + cLd3 + alltrim(str(dLd3)) + alltrim(str(dLdG)) + cFatorVencto + blvalorfinal

      tLdF := SUBSTR(tLdF,1,5) + "." + SUBSTR(tLdF,6,5) + "  " + SUBSTR(tLdF,11,5) + "." + SUBSTR(tLdF,16,6) + "  " + SUBSTR(tLdF,22,5) + "." + SUBSTR(tLdF,27,6) + "  " + SUBSTR(tLdF,33,1) + "  " + SUBSTR(tLdF,34,14)

      RN   := tLdF

   EndIf

Return({CB,RN,NN})

///*
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//*/

//tarasconi - 04.07.2008
Static Function Digitao(cData)

   Local L, D, P, nInt := 0

   L := Len(cData)
   D := 0
   P := 2
   N := 0

   Do While L > 0
      N := (Val(SubStr(cData, L, 1)) * P)
      If N > 9
         D := D + (N - 9)
      Else
         D := D + N
      Endif
      If P = 2
         P := 1
      Elseif P = 1
         P := 2
      EndIf
      L := L - 1
   EndDo

   D := Mod(D,10)
   D := 10 - D

   If D == 10
      D:=0
   Endif

Return(D)





///*
//-------------------------------------------------------------------------------------------
//*/

Static Function Mod10Saf(cData)

   LOCAL L, D, P, nInt := 0

   L := Len(cdata)
   D := 0
   P := 2
   N := 0

   Do While L > 0
      N := (Val(SubStr(cData, L, 1)) * P)
      If N > 9
         D := D + (N - 9)
      Else
         D := D + N
      Endif

      If   P = 2
         P := 1
      Elseif  P = 1
         P := 2
      EndIf
      L := L - 1
   EndDo

   nResto := Mod(D,10)

   Dv := 10 - nResto

   If Dv = 10
      Dv := 0
   Endif

Return(Dv)


///*
//------------------------------------------------------------------------------------------
//*/


Static Function ModSaf(cData) // NAO USADO

   LOCAL L, D, P := 0

   L := Len(AllTrim(cdata))
   D := 0
   P := 1
   DV:= " "
   nResto := 0

   Do While L > 0

      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 7  //Volta para o inicio, ou seja comeca a multiplicar por 2,3,4...
         P := 1
      End
      L := L - 1
   End

   nResto := mod(D,11)  //Resto da Divisao

   If   nResto = 0
      DV := "0"
   ElseIf nResto = 1
      DV := "P"
   Else
      DV := (11 - nResto)
      DV := AllTrim(Str(DV))
   EndIf

Return(DV)
