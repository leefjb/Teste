/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MA261CPO � Autor � Fabio Briddi          � Data � Jun/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Adiciona Campos de usuario na Rotina MATA261               ���
�������������������������������������������������������������������������Ĵ��
���Localiz.  � Nas Funcoes A261Visual(), A261Inclui() e A261Estorn()      ���
���          �                                                            ���
���          � Logo apos a criacao do array aHeader que controla quais    ���
���          � campos aparecerao no browse das transferencias.            ���
���          � Pode ser utilizado para inclusao de campos no array aHeader���
���          � permitindo ao usuario incluir mais campos para digitacao.  ���
//�������������������������������������������������������������������������Ŀ
//�Sequencia exata que e utilzada em rotinas automaticas nas importacoes    �
//�Nao alterar essa sequencia sem alterar as rotinas que Executam a MATA261 �
//���������������������������������������������������������������������������
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MA261CPO()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Jomhedica                                                  ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA261CPO( )

	Local aArea		:= GetArea()
	Local aCposUsr	:= {}
	Local nCont		:= 0	
	
	aAdd( aCposUsr, "D3_LTCTORI")
	aAdd( aCposUsr, "D3_DTVORI" )
	aAdd( aCposUsr, "D3_DOCORI" )
	aAdd( aCposUsr, "D3_SERORI" )
	aAdd( aCposUsr, "D3_FORORI" )
	aAdd( aCposUsr, "D3_LOJORI" )
	aAdd( aCposUsr, "D3_LANORI" ) 

	dbSelectArea("SX3")
	dbSetOrder(2)

	For	 nCont := 1 To Len( aCposUsr )
			
		dbSeek( PadR(aCposUsr[nCont],Len(SX3->X3_CAMPO)))
		                      								// -- TESTE CRISTIANO
		aAdd(aHeader,{	Trim(X3Titulo()),;
						 	Trim(SX3->X3_CAMPO),;
						 	SX3->X3_PICTURE,;
						 	SX3->X3_TAMANHO,;
						 	SX3->X3_DECIMAL,;
						 	SX3->X3_VALID,;
						 	SX3->X3_USADO,;
						 	SX3->X3_TIPO,;
						 	SX3->X3_ARQUIVO,;
						 	SX3->X3_CONTEXT } )
	Next nCont

	RestArea(aArea)
	
Return( Nil )