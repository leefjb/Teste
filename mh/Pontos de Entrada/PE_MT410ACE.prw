/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MT410ACE � Autor � TRS                   � Data � Dez/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada 'MT410ACE' criado para verificar o acesso ���
���          � dos usuarios nas rotinas: Excluir, Visualizar,             ���
���          � Residuo, Copiar e Alterar.                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � u_MT410ACE                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� PARAMIXB                                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. = Continuar ou .F. = Nao continuar                     ���
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
User Function MT410ACE()

	Local aArea	:= GetArea()
	Local lRet	:= .T.
	
	
	//��������������������������������������������������Ŀ
	//� Rotinas Monitoramento                            �
	//�                                                  �
	//� Faz alteracao do status do pedido.               �
	//����������������������������������������������������
	
	If	u_UseTrsf010()

		U_Trsf012()

	EndIf

	RestArea(aArea)
	
Return( lRet )