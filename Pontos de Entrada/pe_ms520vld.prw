/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MS520VLD � Autor � Denis Rodrigues     � Data �  22/10/2014���
�������������������������������������������������������������������������Ĵ��
���Descricao � pe que executa na exclusao da NF de Saida                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Cliente Jomhedica                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function MS520VLD()

	Local aArea  := GetArea()
	Local lRet   := .T.

	//��������������������������������������������������Ŀ
	//� Rotinas Monitoramento                            �
	//�                                                  �
	//� Faz alteracao do status do pedido.               �
	//����������������������������������������������������
	// lRet := U_Trsf012()
	
	RestArea( aArea )

Return( lRet )
