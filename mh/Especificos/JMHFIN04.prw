#INCLUDE "rwmake.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �JMHFIN04  � Autor � AP5 IDE            � Data �  25/08/2010 ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de class de risco de cliente x banco cobranca     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function JMHFIN04()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cVldAlt   := ".T."   // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock
Local cVldExc   := ".T."   // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZC"

dbSelectArea("SZC")
dbSetOrder(1)

AxCadastro(cString, "Classe Risco Cliente x Banco Cobran�a", cVldAlt, cVldExc)

Return
