#Define CRLF ( Chr(13)+Chr(10) )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � F010EFIM � Autor � Jeferson Dambros      � Data � Abr/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada fonte TRSF010, na funcao F010EnvSep,      ���
���          � responsavel por enviar o pedido selecionado a separacao.   ���
���          � Executado no final da funcao e apos a gravacao do status.  ���
���          � Utilizado para gravar campos especificos, mostrar mensagem,���
���          � entre outros.                                              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � u_F010EFIM                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� PARAMIXB                                                   ���
���          � [1] ( Origem do registro ( FAT ou LOJ )                    ���
���          � [2] ( Numero do pedido / orcamento na filial corrente )    ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
���                          ULTIMAS ALTERACOES                           ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � Motivo da Alteracao                             ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function F010EFIM()

	Local nTamCpo		:= TamSX3("C5_COLETOR")[1]
	Local aRetT1		:= {}
	Local aRetT2		:= {}
	Local aPergs		:= {}
	Local aCombo		:= StrToKArr( Upper( SuperGetMv( "ES_COLETOR", .F., "", ) ), "|" )
	Local lOk			:= .T.		

		
	If Len( aCombo ) = 0
	
		Aviso( "Aten��o", "Informe o parametro ES_COLETOR, com os codigos dos coletores.", {"Ok"}, 3 )
	
	Else 
	
		aEval( aCombo, { |x|  IIf( Len(x) > nTamCpo, lOk := .F., Nil )  } )
	
		If !lOk
		
			Aviso( "Aten��o",;
					 "O conte�do do parametro ES_COLETOR,"; 
					 + " n�o coincide com o tamanho definido"; 
					 + " no campo C5_COLETOR.";
					 + CRLF;
					 + CRLF;
					 + "Cadastre o(s) c�digo(s) com o tamanho de: " + cValToChar(nTamCpo),;
					 {"Ok"},;
					 3 )
		
		Else
			
			aAdd(aPergs,{1,"Qtde Pedido", cValToChar(Len(PARAMIXB)),"@R 9999", "", "", ".F.", 30, .F.})
			aAdd(aPergs,{2,"Informe o coletor",0,aCombo,45,"",.T.})
			
			While .T.

				If	ParamBox(aPergs, "Defini��o do coletor", @aRetT1,,,.T.,,,,,.F.)
				
//					If	Type("aRetT1[2]")<>"U" .And. ValType(aRetT1[2]) = "C" .And. !Empty( aRetT1[2] )
					If	ValType(aRetT1[2]) = "C" .And. !Empty( aRetT1[2] )

						For nX := 1 To Len(PARAMIXB)
		
							dbSelectArea("SC5")
							dbSetOrder(1)
							
							dbSeek( xFilial("SC5") + PARAMIXB[nX,2] )
							
							RecLock("SC5", .F.)
								SC5->C5_COLETOR := aRetT1[2]
							MsUnLock()
						
						Next nX
						
						Exit
					
					EndIf
	
				Else
				
					If Aviso(	"Aten��o",;
								"Ao cancelar a defini��o do Coletor,"; 
								+ " o(s) pedido(s) ser�(ram) direcionado(s) ao(s) separador(es)"; 
						 		+ " na forma Padr�o.";
						 		+ CRLF;
						 		+ CRLF;
						 		+ " Confirma ?",;
						 		{"Sim", "N�o"},;
						 		3 ) = 1
						
					EndIf
					
					Exit
					
				EndIf//ParamBox
			
			EndDo
			
		EndIf//lOk

	EndIf//Len(aCombo)

Return()