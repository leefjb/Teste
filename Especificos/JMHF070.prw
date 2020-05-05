#include 'protheus.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � ProdComp � Autor � Marllon Figueiredo    � Data �22/02/2006���
�������������������������������������������������������������������������Ĵ��
���Descricao � Informa quem � o produto KIT (c6_kitpai)                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function JMHF070()
Local aArea       := GetArea()
Local oBtOk, oBtCancel, oBtn
Local oList
Local oDlgF3
Local cKitPai     := Space(15)
Local aComp       := Array(0)
Local oOk         := Loadbitmap(GetResources(), 'LBOK')
Local oNo         := Loadbitmap(GetResources(), 'LBNO')
Local nL          := 0
Local nPosImpNF   := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_IMPNF" } )
Local nPosCod     := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_PRODUTO" } )
Local nPosKit     := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_KITPAI" } )


// carrega os dados
If aCols[N, nPosImpNF] == '2'  // somente amarro com o Kit quando for Componente

	For nL := 1 To Len(aCols)
		// verifica se o produto � KIT
		If aCols[nL, nPosImpNF] <> '1' .or. GDDeleted(nL)
			Loop
		EndIf
		
		SB1->( dbSeek(xFilial('SB1')+GDFieldGet( 'C6_PRODUTO', nL )) )
		Aadd(aComp, {.f., aCols[nL, nPosCod], SB1->B1_DESC})
	Next
	
	If Len(aComp) > 1  // mostro para selecionar somente se tiver mais de um Kit no pedido
		DEFINE MSDIALOG oDlgF3 TITLE "Kits/Produtos" FROM 00,00 TO 300,700 PIXEL
	
		@ 03,03 LISTBOX oList Fields HEADER "", "Kit/Produto", "Descri��o"  SIZE 300,145 NOSCROLL OF oDlgF3 PIXEL ;
			        ON dblClick(aComp := SDTroca(aComp, oList:nAt, @cKitPai), oList:Refresh()) 
		
		oList:SetArray( aComp )
		oList:bLine:={|| {If(aComp[oList:nAt, 1],oOk,oNo),;
		                     aComp[oList:nAt, 2],;
		                     aComp[oList:nAt, 3] }}
		
		define sbutton oBtOk     from 003,320 type 1 enable action ( oDlgF3:End() ) of oDlgF3 pixel
		//define sbutton oBtCancel from 017,320 type 2 enable action ( oDlgF3:End() ) of oDlgF3 pixel
		
		ACTIVATE MSDIALOG oDlgF3 CENTER
	Else
		If Len(aComp) = 1
			aCols[N,nPosKit] := aComp[1, 2]
			cKitPai          := aComp[1, 2]
		Else
			MsgInfo('N�o existem Kits definidos entre os itens desde Documento/Pedido!')
		EndIf
	EndIf

EndIf

RestArea(aArea)

Return( cKitPai )



/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � SDTroca  � Autor � Marllon Figueiredo    � Data �01/02/2006���
�������������������������������������������������������������������������Ĵ��
���Descricao � efetua a marcacao do browse                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function SDTroca( aComp, nAt, cKitPai )
Local nPosKit     := aScan( aHeader, { |x| AllTrim( x[ 2 ] ) == "C6_KITPAI" } )

aComp[nAt, 1]    := ! aComp[nAt, 1]

If aComp[nAt, 1]
	cKitPai          := aComp[nAt, 2]  // kit selecionado
	aCols[N,nPosKit] := aComp[nAt, 2]
EndIf

Return( aComp )
