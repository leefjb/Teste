#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030TOK()   �Autor  �Eliane Carvalho  � Data �  02/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto Entrada para Valida�ao da inclusao/alteracao         ���
���          � de clientes                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Cadastro de Cliente                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

User Function MA030TOK() 

Local aAreaAtu := GetArea()
Local Ok    := .t.

If INCLUI .OR. ALTERA
	
	If M->A1_TIPO <> "X"
		If  M->A1_EST<>"EX"
			If Empty(M->A1_CGC)
				MsgBox("Obrigatorio Informar Campo CGC ")
				Ok 	:= .f.
			EndIf
			If Empty(M->A1_INSCR)
				MsgBox("Obrigatorio Informar Inscri��o Estadual")
				Ok 	:= .f.
			EndIf
		EndIf
	EndIf
EndIf

Restarea(aAreaAtu)

Return ok
