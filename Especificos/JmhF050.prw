#Include 'protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³JMHF050   ºAutor  ³Marcelo Tarasconi   º Data ³  19/01/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina para mostrar o Status por item do pedido. Blq Cred, Est±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP 8                                                       º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JmhF050(cNumPed, cItemPed)

Local aRet := {}
Local cChave := ''
Local cStatus := ''

//Primeiro testa se o item em questão existe no SC9, se não existe é porque o item está em aberto e o pedido nem foi liberado comercialmente
dbSelectArea('SC9')
dbSetOrder(1) //Filial +Pedido + Item + Sequen + produto
If dbSeek(xFilial('SC9')+cNumPed+cItemPed,.f.)

	//Se ele encontrou no SC9, então preciso agora testar quais os bloqueios existentes para ele e como venho do C6, caso ele tenha N abertura no C9, preciso mostrar estas aberturas também
    cChave := SC9->C9_FILIAL + SC9->C9_PEDIDO + SC9->C9_ITEM 
    While !EOF() .and. cChave == xFilial('SC9') + SC9->C9_PEDIDO + SC9->C9_ITEM 

    
        //'Item', 'Sequen', 'Produto', 'Descricao', 'Quant.', 'Valor', 'TES', 'Status', 'Data Fat.' ; 
        
        cStatus := ''
        
        If !EMPTY(SC9->C9_BLCRED) .and. SC9->C9_BLCRED == '01'
		   
		   cStatus += 'Créd. Lim. Venc.' 
        
        ElseIf !EMPTY(SC9->C9_BLCRED) .and. SC9->C9_BLCRED == '04'
        
		   cStatus +=  'Créd. Lim. Créd.' 

        ElseIf !EMPTY(SC9->C9_BLCRED) .and. SC9->C9_BLCRED == '09'
        
		   cStatus +=  'Créd. Rejeitado' 

        ElseIf !EMPTY(SC9->C9_BLCRED) .and. SC9->C9_BLCRED <> '10'
		 
		   cStatus +=  'Créd. Blq. NE'       

        EndIf
        
        If !EMPTY(SC9->C9_BLEST) .and. SC9->C9_BLEST == '02'

		   If !Empty(cStatus)
			  cStatus += ' / '
		   EndIf
		   cStatus +=  'Est. Bloq.'

        ElseIf !EMPTY(SC9->C9_BLEST) .and. SC9->C9_BLEST <> '10'
		   
		   If !Empty(cStatus)
			  cStatus += ' / '
		   EndIf

		   cStatus +=  'Est. Blq. NE'
        
        EndIf
        
        If Empty(SC9->C9_BLEST) .and. Empty(SC9->C9_BLCRED)
                
		   If !Empty(cStatus)
			  cStatus += ' / '
		   EndIf

		   cStatus +=  'Apto a Faturar'
		   
        EndIf
        
        If SC9->C9_BLCRED == '10' .and. SC9->C9_BLEST == '10'
        
		   If !Empty(cStatus)
			  cStatus += ' / '
		   EndIf

		   cStatus +=  'Faturado'

        EndIf
        
	    If !Empty(SC9->C9_NFISCAL) //Se ja foi faturado preciso ir no SD2 pegar a data da NF, O SD2_SEQUEN n"ao esta sendo gravado, pode ocorrer inconsistencia devido a falha na chave
           dbSelectArea('SD2')
           dbSetOrder(8) //D2_FILIAL + D2_PEDIDO  D2_ITEMPV
           dbSeek(xFilial('SD2')+ SC9->C9_PEDIDO + SC9->C9_ITEM ,.f.)
	  
	       aAdd( aRet, { SC9->C9_ITEM, SC9->C9_SEQUEN, SC9->C9_PRODUTO, SC6->C6_DESCRI, SC9->C9_QTDLIB, SC9->C9_PRCVEN, SC6->C6_TES, cStatus, SD2->D2_EMISSAO } )                
	    
	    Else
	       aAdd( aRet, { SC9->C9_ITEM, SC9->C9_SEQUEN, SC9->C9_PRODUTO, SC6->C6_DESCRI, SC9->C9_QTDLIB, SC9->C9_PRCVEN, SC6->C6_TES, cStatus, sTOD('') } )                
	    EndIf


	dbSelectArea('SC9')
	dbSkip()
    End

Else //Se nao encontro no SC9, nem passou pela lib comercial gerando o SC9, está em aberto
  
  If !Empty(SC6->C6_NOTA) //Para casos em que é executado a limpeza do SC9 via rotina padrão do Protheus !!!
	  aAdd( aRet, { SC6->C6_ITEM, '  ' ,SC6->C6_PRODUTO, SC6->C6_DESCRI, SC6->C6_QTDVEN, SC6->C6_PRCVEN, SC6->C6_TES, 'Faturado', sTOD('')  } )
  Else
      aAdd( aRet, { SC6->C6_ITEM, '  ' ,SC6->C6_PRODUTO, SC6->C6_DESCRI, SC6->C6_QTDVEN, SC6->C6_PRCVEN, SC6->C6_TES, 'Em aberto', sTOD('') } )
  EndIf

EndIf

Return(aRet)