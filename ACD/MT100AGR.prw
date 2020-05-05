#Include "Protheus.ch"
#Include "Rwmake.ch"
#INCLUDE "tbiconn.ch"
#Include "topconn.ch"

/*/{Protheus.doc} MT100AGR
//P.E. chamado após a confirmação da NF, porém fora da transação. 
@author Celso Rene
@since 28/10/2018
@version 1.0
@type function
/*/
User Function MT100AGR()

	Local _aArea   	:= GetAreA()
	Local aAreaSF1  := SF1->( GetArea() )
	Local aAreaSD1  := SD1->( GetArea() )
	
	Local _cFilial 	:= SF1->F1_FILIAL
	Local cDoc    	:= SF1->F1_DOC
	Local cSerie  	:= SF1->F1_SERIE
	Local cFornece	:= SF1->F1_FORNECE
	Local cLoja   	:= SF1->F1_LOJA
	Local _cConfFis := ""
	Local _cStatus	:= SF1->F1_STATUS
	
	Private cMens := Space(Len(SF1->F1_MENOTA))

	//somenta para empresa 06 e 01
	If (cEmpAnt == "06" .or. cEmpAnt == "01")


		_cConfFis := Posicione("SA2",1,xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA,"A2_CONFFIS" )

		If ( SF1->F1_TIPO = "N" .and. (Alltrim(_cConfFis) == "2" .or. Alltrim(_cConfFis) == "0" ) .and. !Empty(_cStatus) .and. (Inclui .or. Altera)  ) //conferencia no Documento Fiscal
		//.and. ( (SF1->F1_FORNECE + SF1->F1_LOJA) <> "00001001" .and. (SF1->F1_FORNECE + SF1->F1_LOJA) <> "00087302" ) //nao confere lote quando 

			dBSelectArea("ZZE")
			dBSetOrder(1)
			IF dBSeek(XFILIAL("ZZE")+cDoc+cSerie+cFornece+cLoja) 
				lTipo:= .F.
				u_GRAVAREG(cDoc,cSerie,cFornece,cLoja,lTipo)
			Else                
				lTipo:= .T.
				u_GRAVAREG(cDoc,cSerie,cFornece,cLoja,lTipo)
				//dbSelectArea("SF1")
				//RECLOCK("SF1",.F.)
				//SF1->F1_STATCON := "3"
				//SF1->(MSUNLOCK())
			EndIf      

		ElseIf ( SF1->F1_TIPO == "N" .and. ( Alltrim(_cConfFis) == "2" .or. Alltrim(_cConfFis) == "0" ) .and. ( Empty(_cStatus) .or. (inclui == .F. .and. altera == .F. ) )   ) //estorno vou exlusao Documento

			dBSelectArea("ZZE")
			dBSetOrder(1)
			IF dBSeek(XFILIAL("ZZE")+cDoc+cSerie+cFornece+cLoja) 

				WHILE !EOF() .AND. XFILIAL("ZZE")+ZZE->ZZE_DOC+ZZE->ZZE_SERIE+ZZE->ZZE_FORNEC+ZZE->ZZE_LOJA=;
				_cFilial+CDOC+CSERIE+CFORNECE+CLOJA   

					IF ZZE->(RecLock( 'ZZE', .F. ))
						ZZE->(DBDELETE()) 
						ZZE->( MsUnlock() ) 
					ENDIF
					ZZE->(DBSKIP())
				ENDDO

				//dbSelectArea("SF1")
				//RECLOCK("SF1",.F.)
				//SF1->F1_STATCON := ""
				//SF1->(MSUNLOCK())

			ENDIF


		ElseIf ( SF1->F1_TIPO <> "N" .and. !Empty(_cStatus) .and. (Inclui .or. Altera) ) //diferente de 'N' nao exige conferencia

			dbSelectArea("SF1")
			RECLOCK("SF1",.F.)
			SF1->F1_STATCON := ""
			SF1->(MSUNLOCK())

		EndIf    


		//verificando Devolucao - Ativando novamente as etiquestas - CB0, se informadas nos itens SD1
		If ( SF1->F1_TIPO <> "N" .and. (Inclui .or. Altera) ) //(SF1->F1_TIPO = "R" .or. SF1->F1_TIPO = "D" .or. SF1->F1_TIPO = "B")
	 		_aResCB0 := u_xCB0RESID( cDoc,cSerie,cFornece,cLoja )		
  		EndIf

	
	EndIf	
	
	
	If INCLUI .And. ( !( "JMHA230" $ FunName()) .and. !("JOMACD14" $ FunName())  )
	
		@ 000,000 TO 150,500 DIALOG Tela001 TITLE "Nota Fiscal Entrada"
	
			@ 020,010 SAY "Mensagem"
			@ 020,050 Get cMens
			@ 050,050 BUTTON "_Confirma"   Size 40,15 ACTION (FContinua(),Tela001:End())
			@ 050,100 BUTTON "_Abandona"   Size 40,15 ACTION Tela001:End()
	
		ACTIVATE DIALOG Tela001 CENTERED
	
	EndIf
	
	
	RestArea( aAreaSF1 )
	RestArea( aAreaSD1 )
	RestArea(_aArea)


Return ( .T. )



/*/{Protheus.doc} FContinua
//Gerra informacoes documento - MenNota
@author Celso Rene
@since 17/05/2019
@version 1.0
@type function
/*/
Static Function FContinua()

	If !Empty(cMens)
	
		RecLock("SF1",.F.)
		SF1->F1_MENOTA := CMENS
		SF1->F1_HORA   := Time()
		MsUnlock()
	
	EndIf

Return( .T. )

