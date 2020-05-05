#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOTVS.CH"           
#INCLUDE 'FONT.CH'
#DEFINE  ENTER CHR(13)+CHR(10)

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

User Function MTA410()

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
Local nPosItem  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_ITEM" } )
Local nPosLCLT  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_LOTECTL" } )
Local nPosLote  := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_LOTE" } )

Local nPDeleted	:= Len( aHeader ) + 1
Local lAllTip3 	:= .F. 
Local nCont := 0
Private aItxLote	:=	{}     
Private lBloqPV     := .F.


IIF(!ExisteSX6('MV_CHKTPPV'),CriarSX6('MV_CHKTPPV', 'C', 'Tipo do PV para verifica Lote X PV  - MTA410', "N"), )
cParTpPV := AllTrim(GetMv('MV_CHKTPPV'))


// TRATAMENTO PARA NAO ENTRAR EM RECURSIVIDADE, POIS ESTE PROCESSO UTILIZA EXECAUTO DO MATA410
// E DESTA FORMA VAI EXECUTAR ESTE PE NOVAMENTE O QUE IRA GERAR A INCLUSAO DE PEDIDOS INVALIDOS NO SISTEMA
// ESTE TRECHO DE PROGRAMA DEVE SER COLOCADO NO PE_M410STTS
If Type('lRecurs') <> "U"
	
	For nCont := 1 To Len(aCols)
		If M->C5_TIPO $ cParTpPV .And. Empty(aCols[nCont][nPosLCLT]) .Or. Empty(aCols[nCont][nPosLote])
			Aadd(aItxLote, {'', aCols[nCont][nPosItem], AllTrim(aCols[nCont][nPProduto])+' - '+AllTrim(aCols[nCont][nPDescri]), aCols[nCont][nPosLCLT], aCols[nCont][nPosLote] })
	    EndIf
	Next

/*	
	If Len(aItxLote) > 0	
		BrwPVxLote()
	EndIf
*/
	
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
        EndIf
		
        If M->C5_TIPO $ cParTpPV .And. Empty(aCols[nCont][nPosLCLT]) .Or. Empty(aCols[nCont][nPosLote])
			Aadd(aItxLote, {'', aCols[nCont][nPosItem], AllTrim(aCols[nCont][nPProduto])+' - '+AllTrim(aCols[nCont][nPDescri]), aCols[nCont][nPosLCLT], aCols[nCont][nPosLote] })
        EndIf

  EndIf
Next

If Inclui

//  Assis - Leef, Teste de Varinfo - 09/03/2020
varinfo("MTA410 " + str(len(aCols)), aCols)
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
            // ********************************************************************
			// REMOVIDO DAQUI E COLOCADO EM VALIDACAO DE CAMPO C6_CLVL - 22/01/2018
            // ********************************************************************
            /*
            cMsg := ""
            cMsg += cUserName + ", " + CRLF + CRLF
            cMsg += "A CLASSE DE VALOR é inválida para este representante. " + CRLF + CRLF
 	        cMsg += "As classes válidas são: " + Alltrim(SA3->A3_CCUSTO)                                                         
			
			SA3->( dbSeek(xFilial('SA3')+M->C5_VEND1) )
			If ! Empty(SA3->A3_CCUSTO) .and. ! Alltrim(aCols[nCont,nPosClvl]) $ SA3->A3_CCUSTO                                                         

				MSGALERT(cMsg)			

				lBloqPV := .T.
				
				Exit
			EndIf	
			*/
			
		EndIf                                        
	Next
EndIf

/*      
If Len(aItxLote) > 0
	lReturn := BrwPVxLote()
EndIf
*/

If lBloqPV
	lReturn := .F.
EndIf

Return(lReturn)          

**********************************************************************
Static Function BrwPVxLote()
**********************************************************************
Local lRetorno := .T.

Define Dialog oDlgBlq Title "Pedido de Venda X Lote." From 120,120 To 380,943 Pixel 

	oFont1	:= TFont():New( "Arial",0,18,,.F.,0,,700,.F.,.F.,,,,,, )
    oSay1   := TSay():New( 004,011,{|| 'PEDIDO DE VENDA SEM LOTE INFORMADO'},,,oFont1,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,300,020 )
    
    oBrowse := TcBrowse():New(015, 005, 405, 093,,{'','Item','Produto', 'Lote', 'Num. Lote'},{/*50,50,50*/},oDlgBlq,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
    oBrowse:SetArray(aItxLote)

    oBrowse:AddColumn(TcColumn():New(''				,{|| aItxLote[oBrowse:nAt][01] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
    oBrowse:AddColumn(TcColumn():New('Item'			,{|| aItxLote[oBrowse:nAt][02] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
    oBrowse:AddColumn(TcColumn():New('Produto'		,{|| aItxLote[oBrowse:nAt][03] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
    oBrowse:AddColumn(TcColumn():New('Lote'			,{|| aItxLote[oBrowse:nAt][04] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
    oBrowse:AddColumn(TcColumn():New('Num Lote'		,{|| aItxLote[oBrowse:nAt][05] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
        
    TButton():New( 113, 290, '&Retornar',   oDlgBlq,{|| lRetorno:= .F.,oDlgBlq:End() },35,012,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 113, 370, '&Confirmar',  oDlgBlq,{|| oDlgBlq:End() },35,012,,,.F.,.T.,.F.,,.F.,,,.F. )

Activate Dialog oDlgBlq Centered

Return(lRetorno)