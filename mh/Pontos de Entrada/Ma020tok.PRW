#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA020TOK  �Autor  �Eliane Carvalho     � Data �  02/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto Entrada para Valida�ao da inclusao/alteracao         ���
���          � de fornecedores                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cadastro de Fornecedores                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User  Function MA020TOK()

Local aAreaAtu := GetArea()
Local Ok    := .t.

If Inclui .OR. Altera
	If M->A2_TIPO <> "X"
		If M->A2_EST <> "EX"
			If Empty(M->A2_CGC)
				MsgBox("Obrigatorio Informar Campo CGC ")
				Ok 	:= .f.
			Endif
			If Empty(M->A2_INSCR)
				MsgBox("Obrigatorio Informar Inscri��o Estadual")
				Ok 	:= .f.
			Endif
		Endif
	Endif
Endif

Restarea(aAreaAtu)
Return ok
