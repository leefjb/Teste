/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MA261D3  � Autor � Fabio Briddi          � Data � Jun/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Atualiza campos no momento da gravacao das Transferencias  ���
�������������������������������������������������������������������������Ĵ��
���Localiz.  � Na funcao A261Grava( ) apos a gravacao dos movimentos de o ���
���          � origem e destino do SD3.                                   ���
���          �                                                            ���
���          � Chamado apos a gravacao dos movimentos de origem e destino ���
���          � de cada item de transferencia.                             ���
���          � Pode ser utilizado para atualizar campos no momento da     ���
���          � gravacao                                                   ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MA261D3()                                                  ���
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

User Function MA261D3( )

	Local nPosAcols	:= ParamIXB	//-- Numero da linha do aCols que esta sendo processado
	
 	Local nPosLtcOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_LTCTORI"})
	Local nPosDtVOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_DTVORI"})
	Local nPosDocOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_DOCORI"})
	Local nPosSerOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_SERORI"})
	Local nPosForOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_FORORI"})
	Local nPosLojOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_LOJORI"})
	Local nPosLanOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_LANORI"})  

	Local cSeek 		:= ""


	RecLock( "SD3", .F. ) 
		SD3->D3_LTCTORI	:= aCols[nPosAcols, nPosLtcOri]
		SD3->D3_DTVORI	:= aCols[nPosAcols, nPosDtVOri]
		SD3->D3_DOCORI	:= aCols[nPosAcols, nPosDocOri]
		SD3->D3_SERORI	:= aCols[nPosAcols, nPosSerOri]
		SD3->D3_FORORI	:= aCols[nPosAcols, nPosForOri]
		SD3->D3_LOJORI	:= aCols[nPosAcols, nPosLojOri]
		SD3->D3_LANORI	:= aCols[nPosAcols, nPosLanOri]	
	MsUnLock()
	
	cSeek := SD3->D3_COD
	cSeek += SD3->D3_LOCAL
	cSeek += DtoS(SD3->D3_DTVALID)
	cSeek += SD3->D3_LOTECTL
	cSeek += SD3->D3_NUMLOTE
	
	SB8->(dbSetOrder(1))
	
	If SB8->( dbSeek(xFilial("SB8")+ cSeek ) )
	
		RecLock( "SB8", .F. )  
			SB8->B8_LTCTORI	:= aCols[nPosAcols, nPosLtcOri]
			SB8->B8_DTVORI	:= aCols[nPosAcols, nPosDtVOri]
			SB8->B8_DOCORI	:= aCols[nPosAcols, nPosDocOri]
			SB8->B8_SERORI	:= aCols[nPosAcols, nPosSerOri]
			SB8->B8_FORORI	:= aCols[nPosAcols, nPosForOri]
			SB8->B8_LOJORI	:= aCols[nPosAcols, nPosLojOri]
			SB8->B8_LANORI	:= aCols[nPosAcols, nPosLanOri]
			SB8->B8_LOTEUNI := "S" 
		MsUnLock()
	
	EndIf 

Return( Nil )