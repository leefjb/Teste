#Define CRLF ( Chr(13)+Chr(10) )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ F010EFIM ³ Autor ³ Jeferson Dambros      ³ Data ³ Abr/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada fonte TRSF010, na funcao F010EnvSep,      ³±±
±±³          ³ responsavel por enviar o pedido selecionado a separacao.   ³±±
±±³          ³ Executado no final da funcao e apos a gravacao do status.  ³±±
±±³          ³ Utilizado para gravar campos especificos, mostrar mensagem,³±±
±±³          ³ entre outros.                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ u_F010EFIM                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ PARAMIXB                                                   ³±±
±±³          ³ [1] ( Origem do registro ( FAT ou LOJ )                    ³±±
±±³          ³ [2] ( Numero do pedido / orcamento na filial corrente )    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F010EFIM()

	Local nTamCpo		:= TamSX3("C5_COLETOR")[1]
	Local aRetT1		:= {}
	Local aRetT2		:= {}
	Local aPergs		:= {}
	Local aCombo		:= StrToKArr( Upper( SuperGetMv( "ES_COLETOR", .F., "", ) ), "|" )
	Local lOk			:= .T.		

		
	If Len( aCombo ) = 0
	
		Aviso( "Atenção", "Informe o parametro ES_COLETOR, com os codigos dos coletores.", {"Ok"}, 3 )
	
	Else 
	
		aEval( aCombo, { |x|  IIf( Len(x) > nTamCpo, lOk := .F., Nil )  } )
	
		If !lOk
		
			Aviso( "Atenção",;
					 "O conteúdo do parametro ES_COLETOR,"; 
					 + " não coincide com o tamanho definido"; 
					 + " no campo C5_COLETOR.";
					 + CRLF;
					 + CRLF;
					 + "Cadastre o(s) código(s) com o tamanho de: " + cValToChar(nTamCpo),;
					 {"Ok"},;
					 3 )
		
		Else
			
			aAdd(aPergs,{1,"Qtde Pedido", cValToChar(Len(PARAMIXB)),"@R 9999", "", "", ".F.", 30, .F.})
			aAdd(aPergs,{2,"Informe o coletor",0,aCombo,45,"",.T.})
			
			While .T.

				If	ParamBox(aPergs, "Definição do coletor", @aRetT1,,,.T.,,,,,.F.)
				
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
				
					If Aviso(	"Atenção",;
								"Ao cancelar a definição do Coletor,"; 
								+ " o(s) pedido(s) será(ram) direcionado(s) ao(s) separador(es)"; 
						 		+ " na forma Padrão.";
						 		+ CRLF;
						 		+ CRLF;
						 		+ " Confirma ?",;
						 		{"Sim", "Não"},;
						 		3 ) = 1
						
					EndIf
					
					Exit
					
				EndIf//ParamBox
			
			EndDo
			
		EndIf//lOk

	EndIf//Len(aCombo)

Return()