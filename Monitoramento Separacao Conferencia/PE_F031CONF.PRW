/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � F031CONF � Autor � Jeferson Dambros      � Data � Ago/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada antes da confirmacao de conferencia.      ���
���          � Executa somente se, existir diferen�a entre a quantidade   ���
���          � conferida x quantidade vendida.                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � u_F031CONF                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� PARAMIXB ( Array com os produtos listados na tela )        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1                                                      ���
���          � .T. = Permitir confirmar conferencia mesmo com diferenca   ���
���          � .F. = Nao permitir confirmar a conferencia                 ���
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
User Function F031CONF()

	Local aBrowse	:= PARAMIXB 
	Local lRet		:= .F.
	
	
	Aviso(	"F031CONF|Aten��o",;
			"A Conferencia n�o pode ser confirmada. Existe diferen�a entre a "+;
			"quantidade vendida e a separada. Veja os itens, com status diferentes de "+;
			"verde ( Conferido ).",;
			{"Ok"}, 3 )

Return( lRet )