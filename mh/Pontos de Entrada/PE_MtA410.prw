#include 'rwmake.ch'
/*___________________________________________________________________________
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||-------------------------------------------------------------------------||
|| Função: MtA410       || Autor: Marcelo Tarasconi     || Data: 22/08/2008||
||-------------------------------------------------------------------------||
|| Descrição: PE para validar inclusão/alteração de Pedidos de Venda       ||
||-------------------------------------------------------------------------||
|| Uso: Rotina para automatizar entradas de remessa e gerar novo pedido    ||
||-------------------------------------------------------------------------||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function MtA410()

Local lReturn	:= .T.
Local lOutTip	:= .F.
Local nPProduto	:= aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == 'C6_PRODUTO' } )
Local nPLocal   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_LOCAL" } )
Local nPUM      := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_UM" } )
Local nPLocal   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_LOCAL" } )
Local nPDescri  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_DESCRI" } )
Local nPSegUM   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_SEGUM" } )
Local nPConta   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_CONTA" } )
Local nPCCusto  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_CCUSTO" } )
Local nPItemCTB := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_ITEMCTB" } )
Local nPQtdVen  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_QTDVEN" } )
Local nPIdentB6 := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_IDENTB6" } )
Local nPTipFat  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_TIPFAT" } )
Local nPQtdRep  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_QTDREP" } )
Local nPTesRep  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_TESREP" } )
Local nPNfOri   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_NFORI" } )
Local nPSerOri  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_SERIORI" } )
Local nPItemOri := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_ITEMORI" } )
Local nPPrcVen  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_PRCVEN" } )
Local nPosClvl  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_CLVL" } )
Local nPDeleted	:= Len( aHeader ) + 1
Local lAllTip3 := .F. 


// TRATAMENTO PARA NAO ENTRAR EM RECURSIVIDADE, POIS ESTE PROCESSO UTILIZA EXECAUTO DO MATA410
// E DESTA FORMA VAI EXECUTAR ESTE PE NOVAMENTE O QUE IRA GERAR A INCLUSAO DE PEDIDOS INVALIDOS NO SISTEMA
// ESTE TRECHO DE PROGRAMA DEVE SER COLOCADO NO PE_M410STTS
If Type('lRecurs') <> "U"
	// esta rotina nja esta em execucao
	Return( lReturn )
Else
	Public lRecurs := .f.
EndIf

// variavel para tratamento dos tipos de pedido
Public aTipRem := {} //aqui entram os items com tipo 1 e 3, pois em ambos iremos gerar um novo pedido para remessa

//problema, caso eu informe somente itens do tipo 3, nao preciso deleta-los e criar um novo pedido....posso eixar no memso pediddo
//antes de iniciar faco um for e testo se todos sao tipo 3, caso sim, nao deleto nenhum
For nCont := 1 To Len(aCols)
	// desconsidera as linhas deletadas...
	If !aCols[ nCont, nPDeleted ]
		If aCols[nCont,nPTipFat] == '3' 
		   lAllTip3 := .T.
        Else
	        lAllTip3 := .F.
	        nCont := Len(aCols) //ja posso sair do for
        endIf
  EndIf
Next

If Inclui

	For nCont := 1 To Len(aCols)
		// desconsidera as linhas deletadas...
		If !aCols[ nCont, nPDeleted ]
			If aCols[nCont,nPTipFat] $ '1/3' .and. !lAllTip3 //Se for do tipo 1 ou 3 , ira agrupar deletar daqui e colocar num novo PV de remessa
			        
					AAdd(aTipRem,{M->C5_CLIENTE,;           
							M->C5_LOJACLI,; 
							aCols[ nCont,nPNfOri ],; 
							aCols[ nCont,nPSerOri ],; 
							aCols[ nCont,nPItemOri ],; 
							aCols[ nCont,nPProduto ],;
							aCols[ nCont,nPQtdVen ],; 
							aCols[ nCont,nPItemCTB ],; 
							aCols[ nCont,nPCCusto ],; 
							aCols[ nCont,nPItemOri ],; 
							aCols[ nCont,nPIdentB6 ],;
							aCols[ nCont,nPTipFat ] ,;
							aCols[ nCont,nPQtdRep ] ,;
							aCols[ nCont,nPTesRep ] ,;
							aCols[ nCont,nPPrcVen ] })
			
					If aCols[nCont,nPTipFat] == '3'  //Se for do tipo 3 , ira agrupar deletar daqui e colocar num novo PV de remessa
						aCols[ nCont, nPDeleted ] := .t. //Se for do tipo 3 , ira agrupar deletar daqui e colocar num novo PV de remessa			
			        EndIf

			ElseIf aCols[nCont,nPTipFat] <> '3'
			   lOutTip := .T.//Nao podera ter somente tipo no pedido de venda, pois estes serao deletados, e o pedido ficara sem itens....
			EndIf                                        
		
			// Validacao do Centro de Custo do vendedor 1
// CRISTIANO OLIVEIRA - 28/12/2016 - LIBERADO VALIDAR CC
/*
			SA3->( dbSeek(xFilial('SA3')+M->C5_VEND1) )
			If ! Empty(SA3->A3_CCUSTO) .and. ! Alltrim(aCols[nCont,nPCCusto]) $ SA3->A3_CCUSTO
				MsgBox("Centro de Custo inválido para este Representante! Os CC válidos são: " + Alltrim(SA3->A3_CCUSTO))
				lReturn := .f.
				Exit
			EndIf
*/
			// Jean Rehermann - Utiliza o mesmo campo porém agora valida a classe de valor com o representante
			If !Empty( aCols[ nCont, nPosClvl ] )
				
				SA3->( dbSeek( xFilial('SA3') + M->C5_VEND1 ) )
				
				If !Empty( SA3->A3_CCUSTO ) .And. !Alltrim( aCols[ nCont, nPosClvl ] ) $ SA3->A3_CCUSTO
					MsgBox("Classe de valor inválida para este Representante! As Classes válidas são: " + Alltrim( SA3->A3_CCUSTO ) )
					lReturn := .F.
				EndIf
			
			EndIf
	
		EndIf                                        
	Next
EndIf

Return(lReturn)
