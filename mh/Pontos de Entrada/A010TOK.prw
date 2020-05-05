#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A010TOK() �Autor  �Eliane              � Data �  02/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto Entrada para Validacao da inclusao/alteracao         ���
���          � de Produto                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Cadastro de Produto                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A010TOK()    

_lRet   := .t.
_aAlias := GetArea()

IF M->B1_TIPO $ "MC"
	IF EMPTY(M->B1_CLVL)
		MsgBox("Obrigatorio Informar o campo Classe de Valor!")
		_lRet := .f.
	ENDIF
ENDIF

If _lRet .And. INCLUI
	cQuery := "SELECT MAX(B1_CODBAR) AS TB_CODBAR "
	cQuery += "FROM   " + RetSqlName("SB1") + " SB1 "
	cQuery += "WHERE  B1_FILIAL      =  '" + xFilial("SB1") + "' "
	cQuery += "AND    SB1.D_E_L_E_T_ <> '*' "
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TRB01", .F., .T.)
	TRB01->(DbGoTop())
	nProximo := StrZero((Val(TRB01->TB_CODBAR) + 1),6)
	TRB01->(DbCloseArea())
	M->B1_CODBAR := nProximo
EndIf

RestArea(_aAlias)

Return(_lRet)
