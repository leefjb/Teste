#include 'rwmake.ch'
/*
�����������������������������������������������������������������������������
���Programa  �PE_A410CONS�Autor  �Marcelo Tarasconi   � Data � 22/08/2008 ���
�������������������������������������������������������������������������͹��
���Descricao �PE para incluir botao na enchoice bar                        ��
�������������������������������������������������������������������������͹��
���Uso       � MP811                                                      ���
�����������������������������������������������������������������������������
*/
User Function A410CONS()

Local aButtons := {}

If Inclui
	aAdd( aButtons, { 'EDITABLE', { || u_JmhF020() }, 'Retornos' } )
EndIf
	
Return( aButtons )