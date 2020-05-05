/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � M261D3O  � Autor � Fabio Briddi          � Data � Jun/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Atualiza campos no momento da gravacao das Transferencias  ���
�������������������������������������������������������������������������Ĵ��
���Localiz.  � Utilizado para manipulacao do Registro de movimenta��o     ���
���          � interna de transfer�ncia (RE4) gerado pela rotina MATA261  ���
���          �                                                            ���
���          � Chamado apos a gravacao dos movimentos do registro de      ���
���          � de Saida RE4.                                              ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � M261D3O()                                                  ���
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

User Function M261D3O( )

	Local nPosAcols    := ParamIXB	//-- Numero da linha do aCols que esta sendo processado
	
	Local nPosLtcOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_LTCTORI"})
	Local nPosDtVOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_DTVORI"})
	Local nPosDocOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_DOCORI"})
	Local nPosSerOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_SERORI"})
	Local nPosForOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_FORORI"})
	Local nPosLojOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_LOJORI"})
	Local nPosLanOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_LANORI"})  

	RecLock( "SD3", .F. )  
		SD3->D3_LTCTORI	:= aCols[nPosAcols, nPosLtcOri]
		SD3->D3_DTVORI	:= aCols[nPosAcols, nPosDtVOri]
		SD3->D3_DOCORI	:= aCols[nPosAcols, nPosDocOri]
		SD3->D3_SERORI	:= aCols[nPosAcols, nPosSerOri]
		SD3->D3_FORORI	:= aCols[nPosAcols, nPosForOri]
		SD3->D3_LOJORI	:= aCols[nPosAcols, nPosLojOri]
		SD3->D3_LANORI	:= aCols[nPosAcols, nPosLanOri]
	MsUnLock()

Return( Nil )
