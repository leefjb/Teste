/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PE_M410GET �Autor  � Fabio Briddi      � Data �  Jun/2015   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada pertence a rotina de pedidos de venda,    ���
���          � MATA410()                                                  ���
���          � Localizado na rotina de Visualizacao do pedido, na Funcao  ���
���          � A410ALTERA().                                              ���
���          � Executado Antes de montar tela de aprensentacao de pedidos.���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������͹��
���Analista  � Manutencao                                                 ���
�������������������������������������������������������������������������͹��
��� F.Briddi � Utilizado para Inicializar o Campo Quantidade Liberada     ���
��� Jun/2015 � C6_QTDLIB, sugerindo a quantidade disponivel no estoque.   ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M410GET()

	Local aAreaSC6    := SC6->( GetArea() )
	Local nPosItem    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"})
	Local nPosProduto := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	Local nPosQtdVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
	Local nPosQtdLib  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB"})
	Local nPosOper    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_OPER"})
	Local nPosOperFat := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_OPERFAT"})

	If	("JMHA230" $ FunName())
	
		For nLinha:= 1 To Len(aCols)
	
			dbSelectArea("SC6")
			dbSetOrder(1) //-- C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			dbSeek( xFilial("SC6") + SC5->C5_NUM + aCols[nLinha,nPosItem] + aCols[nLinha,nPosProduto] )

			//����������������������������������������������������������������������������������Ŀ
			//� Carrega Campo Virtual Tipo de Operacao com o conteudo do Reail                   �
			//������������������������������������������������������������������������������������
			aCols[nLinha,nPosOper] := SC6->C6_OPERFAT

			If	!aCols[nLinha, Len(aHeader) + 1 ] //-- Despreso os Deletados
			
				If	SC5->C5_LIBEROK = 'S'

					aCols[nLinha,nPosQtdLib] := SC6->C6_QTDEMP

				Else

					If	SC6->C6_QTDEMP = 0
	
						//����������������������������������������������������������������������������������Ŀ
						//� Apura Quantidade Restante a ser Entregue                                         �
						//������������������������������������������������������������������������������������
						nQtdVen := aCols[nLinha,nPosQtdVen]
						nQtdEnt := SC6->C6_QTDENT //-- aCols[nLinha,nPosQtdEnt] //-- Nao esta no GetDados
						nQtdLib := (nQtdVen - nQtdEnt)
			
						//����������������������������������������������������������������������������������Ŀ
						//� Sugere a Quantidade Menor entre a Disponivel e a Vendida - Restante para Entrega �
						//������������������������������������������������������������������������������������
						aCols[nLinha,nPosQtdLib] := nQtdLib
	
					Else
						//����������������������������������������������������������������������������������Ŀ
						//� Sugere a como Quantidade Liberada a Empenhada anteriormente                      �
						//������������������������������������������������������������������������������������
						aCols[nLinha,nPosQtdLib] := SC6->C6_QTDEMP
	
					EndIf

				EndIf
				
			EndIf

		Next nLinha
		
		RestArea( aAreaSC6 )
		
	EndIf

Return()
/*
----------------------------------------------------------------------------------------------------
*/
