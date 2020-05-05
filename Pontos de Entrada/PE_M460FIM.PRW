#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TBICONN.CH" 
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M460FIM   บAutor  ณEliane-Microsiga  บ Data ณ  10/14/05    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para  Gravar o                            บฑฑ
ฑฑบ            no ctas a receber                                          บฑฑ
ฑฑบ          ณ Regra todos Itens devem ter centro de custo e ItemCC iguaisบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ-----------------------------------------------------------------------บฑฑ
ฑฑบAutor         |   Data   | Alteracao                                   บฑฑ
ฑฑบ--------------|----------|---------------------------------------------บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function M460FIM()
#define CRLF   Chr(13)+Chr(10)

Local aArea     := GetArea()
Local aAreaSD2  := SD2->(getarea())
Local aAreaSE1  := SE1->(getarea())
Local cMensagem := Space(0)
Local lSaidaLeef:= .F.   // Leef - Assis(160819)- Variavel para definir se tem registro na SE1(C.R.)
Local cTitulo   := 'Avisar o Financeiro para compensar estas Notas (TES 519)'+CRLF+CRLF+CRLF
dbselectArea("SA1")
dbSetOrder(1)
dbseek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)

DbselectArea("SD2")
DbsetOrder(3)
dbseek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
Do While xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE .and. !Eof()
	If SD2->D2_TES = '519'
		cMensagem += 'Nota Num: ' + SF2->F2_DOC + '/' + SF2->F2_SERIE + '   - Cliente: ' + Substr(SA1->A1_NOME,1,20) + CRLF + CRLF
		Exit
	Endif
	dbSkip()
EndDo

DbselectArea("SD2")
DbsetOrder(3)
dbseek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
DbselectArea("SE1")
DbsetOrder(1)
dbseek(xFilial("SE1") + SF2->F2_SERIE + SF2->F2_DOC)
Do While xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM == SF2->F2_FILIAL+SF2->F2_SERIE + SF2->F2_DOC .And. !Eof()
	If RecLock("SE1",.F.)
		SE1->E1_ITEMCTB := SD2->D2_ITEMCC
		SE1->E1_CCUSTO  := SD2->D2_CCUSTO
		MsUnlock()
	Endif
	ConOut("#Leef-console# M460FIM - Gerou SE1 - "+ SE1->E1_NUM)
	lSaidaLeef:= .T.  // Leef - Assis(160819) - Tem Registro na SE1.
	dbSkip()
EndDo
If ! Empty( cMensagem )
	cTitulo += cMensagem
	MsgInfo( cTitulo )
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Rotinas Monitoramento                            ณ
//ณ                                                  ณ
//ณ Faz alteracao do status do pedido.               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If cEmpAnt <> '10'
	If	u_UseTrsf010() .And. !Empty( SC5->C5_PVSTAT )
	
		U_Trsf012()
		
	EndIf
EndIf
RestArea(aAreaSE1)
RestArea(aAreaSD2)

if lSaidaLeef
   ConOut("#Leef-console# M460FIM - Entrando na Fun็ใo u_LfGrvNN(lSaidaLeef)")
   u_LfGrvNN(lSaidaLeef,.F.,.F.)
endif


//////transmissao documento e impressao
If ( (cEmpAnt == "01" .or. cEmpAnt == "06") .and. (SF2->F2_SERIE == "1  " .or. SF2->F2_SERIE == "2  " ) ) 
	
	_nMens:= AVISO("Transmissใo Doc e Impres. Danfe", "Selecione a op็ใo abaixo para o documento de saํda: " + Alltrim(SF2->F2_DOC) + "? " ;
	;//+ chr(10) + chr(10) + "" ;
	, {"Cancelar","Transmitir","Trans. + Danfe"}, 2)  
	   
	Do Case
		
		Case (_nMens == 1)
			ConOut("#Leef-console# Apertou Bt Cancelar PE M460FIM ")

		Case (_nMens == 2)
			//transmissao automatica
			ConOut("#Leef-console# Apertou Bt Transmitir PE M460FIM (antes do AutoEnv) "+SF2->F2_SERIE+"/"+SF2->F2_DOC)
			AutoNfeEnv(cEmpAnt,SF2->F2_FILIAL,"0","1",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)
		
		Case (_nMens == 3)	
			ConOut("#Leef-console# Apertou Bt Trans. + Danfe  PE M460FIM (antes do AutoEnv) "+SF2->F2_SERIE+"/"+SF2->F2_DOC)
			AutoNfeEnv(cEmpAnt,SF2->F2_FILIAL,"0","1",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)
			Sleep( 3500 ) //1 segundos espera - transmissใo do documento
			u_xAutoDanfe( SF2->F2_DOC, SF2->F2_SERIE , "estoque" )
            if lSaidaLeef
               u_LfGrvNN(lSaidaLeef,.T.,.T.)
            endif
	
	EndCase

EndIf

RestArea(aAreaSE1)
RestArea(aAreaSD2)
RestArea(aArea)

Return()

User Function LfGrvNN(lSaidaLeef,lPreview,lImprime,lNaoRespeita)
Private aBoletos   := Array(0)  	// especifico - impressao de boletos
Default lNaoRespeita := .T.
if lSaidaLeef
    // ConOut("#Leef-console# M460FIM->LfGrvNN - Pergunte do NFISGW")
    if ! Pergunte("NFSIGW",.F.)
        MV_PAR01 := SF2->F2_DOC
        MV_PAR02 := SF2->F2_DOC
        MV_PAR03 := SF2->F2_SERIE
        MV_PAR04 := 2	//[Operacao] NF de Saida
        MV_PAR05 := 2	//[Frente e Verso] Nao
        MV_PAR06 := 2	//[DANFE simplificado] Nao
        lPrevBol := (MV_PAR11 = 1)
        cMens1   := MV_PAR12
        cMens2   := MV_PAR13
	    SA1->( dbSeek(xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA) )
	    SD2->( dbSetOrder(3) )
	    SD2->( dbSeek(xFilial('SD2')+SF2->F2_DOC+SF2->F2_SERIE) )
	    SD2->( dbSetOrder(1) )
	    SC5->( dbSeek(xFilial('SC5')+SD2->D2_PEDIDO) )
	    //   Assis 160819-1710 - Duvida, caso tenha item da NF de outros pedidos.
	    If SA1->A1_BOLCLI == '1'
		    If SC5->C5_TPDESC == '1'
		    	aDesc := {SC5->C5_DESCOM, 0, ''}
		    Else
		    	aDesc := {0, SC5->C5_DESCOM, ''}
		    EndIf
		    if lNaoRespeita
		    	If SZC->( dbSeek(xFilial('SZC')+SA1->A1_CLASSE) )
		    		If SZC->ZC_PRNBOL == '1'
		    			ConOut("#Leef-console# M460FIM->LfGrvNN - Lendo SZC - aBoletos")
		    			Aadd(aBoletos, {SF2->F2_DOC, SF2->F2_SERIE, aDesc, {SZC->ZC_CODIGO, SZC->ZC_AGENCIA, SZC->ZC_CONTA, SZC->ZC_SUBCTA}})
		    		EndIf
		    	EndIf
		    else
		    	SE1->(DbsetOrder(1))
		    	SE1->(dbseek(xFilial("SE1") + SF2->F2_SERIE + SF2->F2_DOC))
		    	Do While xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM == SF2->F2_FILIAL+SF2->F2_SERIE + SF2->F2_DOC .And. !(SE1->(Eof()))
		    		cE1_PORTADO := SE1->E1_PORTADO
		    		cE1_AGEDEP  := SE1->E1_AGEBOL     // campo especifico Jomhedica
		    		cE1_CONTA   := SE1->E1_CTABOL     // campo especifico Jomhedica
		    		cE1_SUBCTA  := SE1->E1_SUBBOL     
		    		Aadd(aBoletos, {SF2->F2_DOC, SF2->F2_SERIE, aDesc, {cE1_PORTADO, cE1_AGEDEP, cE1_CONTA, cE1_SUBCTA,}})
		    		SE1->(dbSkip())
		    	EndDo
    	    endif
		EndIf
		// estrutura de aBoletos
		/*
		[1]    - DOCUMENTO
		[2]    - SERIE
		[3][1] - PERCENTUAL DE DESCONTO
		[3][2] - VALOR DE DESCONTO
		[3][3] - INSTRUCAO DE DESCONTO (vem em branco da nota)
		[4][1] - BANCO
		[4][2] - AGENCIA
		[4][3] - CONTA CORRENTE
		[4][4] - SUB CONTA
		*/
		// impressao do boleto
		For nStart := 1 to Len(aBoletos)
			_cBancoCobr   := aBoletos[nStart,4][1]
			_cAgenciaCobr := aBoletos[nStart,4][2]
			_cContaCobr   := aBoletos[nStart,4][3]
			_cSubCtaCobr  := aBoletos[nStart,4][4]
			u_JHR100Bo(aBoletos[nStart,2], aBoletos[nStart,1], 'NF ',         , lPreview , {cMens1, cMens2},     , _cBancoCobr, _cAgenciaCobr, _cContaCobr, _cSubCtaCobr, {aBoletos[nStart,3][1], aBoletos[nStart,3][2], ''}, lImprime  )  // adicionei o .F. (assis 160819-17:22)
		// JHR100Bo( cPrefixo         , cTitulo           , cTipo, cParcela, lPreview, aMsg            , oPrn, cBanTar    , cAgenTar     , cConTar    , cSubCta     , aDesc                                            , lImprime )		
		Next
	EndIf
Endif
return

