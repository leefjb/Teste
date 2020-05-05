#Include 'protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³JMHF049   ºAutor  ³Marcelo Tarasconi   º Data ³  19/01/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina para mostrar o Status por item do pedido. Blq Cred, Est±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP 8                                                       º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JmhF049()

Local aRet := {}
Local cChave := ''
Private oList, oDlg                            
Private aList := Array( 0 )
Private aButtons := {}

dbSelectArea('SC6')
dbSetOrder(1)
If dbSeek(xFilial('SC6')+SC5->C5_NUM,.f.)

	cMsgInt := SC5->C5_MSGINT
	
	cChave := SC6->C6_FILIAL + SC6->C6_NUM
	While !EOF() .and. cChave == xFilial('SC6') + SC6->C6_NUM

      //Chama rotina que irá retornar a linha e o Status, nesse fonte ele pode inclusive abrir várias linhas, de acordo com o SC9
      aRet := u_JmhF050(SC6->C6_NUM, SC6->C6_ITEM)

      For i:=1 to Len(aRet)

	      aAdd( aList, { aRet[i][1], aRet[i][2], aRet[i][3], aRet[i][4], aRet[i][5], aRet[i][6],  aRet[i][7], aRet[i][8], aRet[i][9] } )
	      //aAdd( aList, { SC6->C6_ITEM, SC6->C6_PRODUTO, SC6->C6_DESCRI, SC6->C6_QTDVEN, SC6->C6_PRCVEN, SC6->C6_TES, Data.Fat. } )
      Next i

	dbSelectArea('SC6')
	dbSkip()
	End

	Define msDialog oDlg Title "Status dos Itens do PV " From 0,0 To 25,120 Of oMainWnd

	@ 19, 010 SAY "Mensagem Interna: "   SIZE 50, 7                OF oDlg PIXEL
	@ 15, 070 MSGET cMsgInt              PICTURE '@!' SIZE  320,10 OF oDlg PIXEL 
	
	@ 31,00 ListBox oList ; 
    	     Fields Header  'Item', 'Sequen', 'Produto', 'Descricao', 'Quant.', 'Valor', 'TES', 'Status', 'Data Fat.' ; 
        	 Size 475,160 ; 
         	Pixel Of oDlg ;

	oList:SetArray( aList )
	oList:bLine := { || {   aList[ oList:nAt, 01 ], ;
	   	                    aList[ oList:nAt, 02 ], ;
						    aList[ oList:nAt, 03 ], ;
						    aList[ oList:nAt, 04 ], ;
						    Transform(aList[ oList:nAt, 05 ],"@E 999,999,999.99"), ;
						    Transform(aList[ oList:nAt, 06 ],"@E 999,999,999.99"), ;
						    aList[ oList:nAt, 07 ], ; 
						    aList[ oList:nAt, 08 ], ; 
						    dtoc(aList[ oList:nAt, 09 ]) }}
	
	oList:nFreeze	:= 1
	oList:Refresh()
	
	Activate msDialog oDlg Centered On Init EnchoiceBar( oDlg,  { ||  oDlg:End() }, { || oDlg:End() },, aButtons)
	
Else

   Alert('Erro integridade entre SC5 e SC6 !!!')
EndIf


//If !Empty(cMsgInt)
	RecLock("SC5")
	SC5->C5_MSGINT := cMsgInt
	SC5->(MsUnlock())
//EndIf


Return()