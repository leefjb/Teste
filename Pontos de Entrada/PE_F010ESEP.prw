#Define CRLF ( Chr(13)+Chr(10) )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ F010ESEP ³ Autor ³ Jeferson Dambros      ³ Data ³ Abr/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada fonte TRSF010, na funcao F010EnvSep,      ³±±
±±³          ³ responsavel por enviar o pedido selecionado a separacao.   ³±±
±±³          ³ Executado após as validacoes e antes de alterar o status.  ³±±
±±³          ³ Utilizado para permitir ou nao o pedido marcado a ser      ³±±
±±³          ³ enviado a separacao.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ u_F010ESEP                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ PARAMIXB                                                   ³±±
±±³          ³ [1] ( Origem do registro ( FAT ou LOJ )                    ³±±
±±³          ³ [2] ( Numero do pedido / orcamento na filial corrente )    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1                                                      ³±±
±±³          ³ .T. = Permitir enviar a separacao                          ³±±
±±³          ³ .F. = Nao permitir enviar a separacao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F010ESEP()

	Local aArea		:= GetArea()
	Local aPedido		:= {}
	Local lRet		:= .T.
	Local nZ			:= 0
	Local nSaldoSB2	:= 0
	Local cMsg		:= ""
	

	dbSelectArea("SC5")
	dbSetOrder(1)
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	
	For nZ := 1 To Len(PARAMIXB)
	
		If PARAMIXB[nZ,1] = "FAT"
			
			SC5-> ( dbSeek( xFilial("SC5") + PARAMIXB[nZ,2] ) )
			
			SC6-> ( dbSeek( xFilial("SC6") + SC5->C5_NUM ) )			
	
			While SC6->( !Eof() ) .And. SC6->( xFilial("SC6") + C6_NUM ) = SC5->( C5_FILIAL + C5_NUM ) 
			
				// Retorna o saldo em estoque no local
				dbSelectArea("SB2")
				dbSetOrder(1)
	
				If	dbSeek( xFilial("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL )
					nSaldoSB2 := SaldoSB2(,.F.,,,,"SB2")
				Else
					nSaldoSB2 := 0
				EndIf
				
				If nSaldoSB2 <= 0 .Or. nSaldoSB2 < SC6->C6_QTDVEN
					
					aAdd(aPedido, { 	( !Empty( SC5->C5_DTCIRUG ) .Or. !Empty( SC5->C5_PACIENT ) ),; // Se for kit para cirurgia (.T.) 
										SC6->C6_NUM,;
										SC6->C6_PRODUTO,;
										SC6->C6_DESCRI,;
										SC6->C6_LOCAL } )
				
				EndIf
				
				SC6->( dbSkip() )
				
			EndDo
			
		EndIf

	Next nZ
	
	If Len(aPedido) > 0
	
		cMsg := "Produto(s) sem saldo(s) em estoque!" 
		cMsg += CRLF
		
		aEval( aPedido, { |x| cMsg	+= "Kit: "+ IIf( x[1], "Sim", "Nao");
										+" Pedido " + x[2];
										+" Produto: " + AllTrim( x[3] +"-"+ x[4] );
										+" Local: " + x[5];
										+ CRLF } ) 
		
		cMsg += CRLF
		
		// Se o Saldo for zero e for um kit para cirurgia.
		// Nao será permitido enviar a separacao
		If ( aScan( aPedido, {|x| x[1] = .T. } ) ) > 0
			
			lRet := .F.
			
			cMsg += "Para todo kit de produtos cirurgico, é necessário estoque."
			cMsg += CRLF
			cMsg += "Pedido não será enviado a separação"
			
		Else
		
			lRet := .T.
			
			cMsg += "Clique no botão Ok para enviar a separação."
			
		EndIf
	
		Aviso(	"Atenção", cMsg, {"Ok"}, 3 )
		
	EndIf
	
	RestArea(aArea)

Return( lRet )