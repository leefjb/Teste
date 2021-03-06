/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MTA416PV  � Autor � Marllon Figueiredo � Data � 08/11/2005 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualizacao de campos no SC5 com base no SCJ               ���
��           �                                                             ��
�� Altera�ao �Autor � Eliane Carvalho  Data � 02/12/2005 �                 ��
��           � Atualiza campo   C6_CONTA acols pedido de venda             ��
��           � Eliane Carvalho  Data 24/01/2006                            ��
��           � Atualiza campos  C6_CLVL acols pedido de venda              ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MTA416PV()
Local aAreaAtu := GetArea()
Local _n
Local _cFilB1	:= xFilial("SB1")

M->C5_CRM      := M->CJ_CRM
M->C5_CRMNOM   := M->CJ_MEDICO
M->C5_SACADO   := M->CJ_CLIENTE
M->C5_LSACADO  := M->CJ_LOJA
M->C5_CLIVALE  := M->CJ_CLIENTE
M->C5_LJVALE   := M->CJ_LOJA
M->C5_DTCIRUG  := M->CJ_DTPROC
M->C5_PACIENT  := M->CJ_PACIENT
M->C5_CONVENI  := M->CJ_CODCON
M->C5_DESCCON  := M->CJ_CONVENI


FOR _n:=1 TO Len(_aCols)
	
	_aCols[_n, Ascan(_aHeader, {|x| Alltrim(x[2])=="C6_CONTA" } ) ] := ;
	Posicione("SB1", 1, _cFilB1 + ;
	_aCols[_n, Ascan(_aHeader, {|x| Alltrim(x[2])=="C6_PRODUTO" } ) ],"B1_CTAREC")
  
	_aCols[_n, Ascan(_aHeader, {|x| Alltrim(x[2])=="C6_CLVL" } ) ] := ;
	Posicione("SB1", 1, _cFilB1 + ;
	_aCols[_n, Ascan(_aHeader, {|x| Alltrim(x[2])=="C6_PRODUTO" } ) ],"B1_CLVL") 
NEXT

Restarea(aAreaAtu)
Return
