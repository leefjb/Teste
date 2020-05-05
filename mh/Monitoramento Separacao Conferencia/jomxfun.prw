#include 'protheus.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao   � PVScan     � Autor � Marllon Figueiredo   � Data �16/09/2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o� Funcao utilizada para separar strings delimitadas por um    ���
���         � marcador e retornar as mesmas em um array simples           ���
�������������������������������������������������������������������������Ĵ��
���Paramentr� cString      -  String passada para ser processada          ���
���         �                                                             ���
���         � nTamax       -  Tamanho maximo da string                    ���
���         �                                                             ���
���         � cQuebra      -  marcador para quebra de linha               ���
�������������������������������������������������������������������������Ĵ��
���Retorno  � Retorna um array simples com as strings separadas           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function PVScan( cString, nTamax, cCarLinha )
Local aString   := Array(0)
Local cParte    := Space(0)
Local nPos      := 0


DEFAULT cCarLinha := ';'

// processa a separacao da string
Do While Len(cString) > 0
	// posicao da marca delimitadora dentro da string
	nPos := At(cCarLinha, cString)
	If nPos > 0
		// pega a parte da string
		cParte := SubStr(cString, 1, nPos-1)
		// limpo a string
		cString := SubStr(cString, At(cCarLinha, cString)+Len(cCarLinha))
		// adiciono no array de retorno
		Aadd(aString, cParte)
	Else
		If Len(cString) > 0
			Aadd(aString, cString)
			Exit
		EndIf
    EndIf
EndDo

Return(aString)


//��������������������������������������������������Ŀ
//� Rotinas Monitoramento                            �
//�                                                  �
//� Verifica se a filial utiliza o processo de       �
//� Monitor / Separacao / Conferencia                �
//����������������������������������������������������
User Function UseTrsf010()

	Local lUseTrsf010 := ( AllTrim( SuperGetMV( "TRS_MON001", .F., "" ) ) $ "12" )
	
Return( lUseTrsf010 )
