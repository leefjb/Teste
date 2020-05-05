#Define CRLF ( Chr(13)+Chr(10) )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � F010ESEP � Autor � Jeferson Dambros      � Data � Abr/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada fonte TRSF010, na funcao F010EnvSep,      ���
���          � responsavel por enviar o pedido selecionado a separacao.   ���
���          � Executado ap�s as validacoes e antes de alterar o status.  ���
���          � Utilizado para permitir ou nao o pedido marcado a ser      ���
���          � enviado a separacao.                                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � u_F010ESEP                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� PARAMIXB                                                   ���
���          � [1] ( Origem do registro ( FAT ou LOJ )                    ���
���          � [2] ( Numero do pedido / orcamento na filial corrente )    ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1                                                      ���
���          � .T. = Permitir enviar a separacao                          ���
���          � .F. = Nao permitir enviar a separacao                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		// Nao ser� permitido enviar a separacao
		If ( aScan( aPedido, {|x| x[1] = .T. } ) ) > 0
			
			lRet := .F.
			
			cMsg += "Para todo kit de produtos cirurgico, � necess�rio estoque."
			cMsg += CRLF
			cMsg += "Pedido n�o ser� enviado a separa��o"
			
		Else
		
			lRet := .T.
			
			cMsg += "Clique no bot�o Ok para enviar a separa��o."
			
		EndIf
	
		Aviso(	"Aten��o", cMsg, {"Ok"}, 3 )
		
	EndIf
	
	RestArea(aArea)

Return( lRet )