/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北砅rograma  � MTASF2   � Autor � Fabio Briddi          � Data � Jun/2015  潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北篋esc.     � Ponto de Entrada na Gera玢o de registros em SF2            罕�
北�            Este P.E. esta localizado na funcao A460GeraF2             罕�
北�          � E executado apos a atualizacao de quase todos os campos do 罕�
北�          � SF2                                                        罕�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros�                                                             潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   �                                                             潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       � Materiais                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

User Function MTASF2()

	Local aArea := GetArea()

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪腡�
	//� Em Operacoes que foram utilizadas Processo de Autorizacao de Faturamento  �
	//� Grava no Numero da Nota e Serie em SZO                                    �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪腡�

	If	(SC5->( FieldPos( "C5_AF" ) ) <> 0) .And. !Empty( SC5->C5_AF )

		dbSelectArea("SZO")
		dbSetOrder(1)
		If	dbSeek( xFilial("SZO") + SC5->C5_AF )

			RecLock( "SZO", .F. )
				SZO->ZO_NFSAISA := SF2->F2_DOC
				SZO->ZO_SERSAID := SF2->F2_SERIE
			MsUnLock()

		EndIf

	EndIf
	
	RestArea( aArea )

Return()

/*
--------------------------------------------------------------------------------
*/
