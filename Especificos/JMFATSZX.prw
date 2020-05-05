#include "protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � JMFATSZX � Autor � Cristiano Oliveira � Data �  31/05/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Procedimentos                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico JOMHEDICA                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function JMFATSZX()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cVldAlt   := ".T."   // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock
Local cVldExc   := ".T."   // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZX"

dbSelectArea("SZX")
dbSetOrder(1)

AxCadastro(cString, "Procedimentos", cVldAlt, cVldExc)

Return