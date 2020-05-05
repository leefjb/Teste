#include "rwmake.ch"
#include "protheus.ch"

#define NUM_ITENS_PAG   20

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ JORCFAT  ³ Autor ³ Herika Leal/Marllon   ³ Data ³10/04/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emissao do Orcamento de Vendas (Faturamento)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function JORCFAT()
Local na
Local aArea      := GetArea()
Local cPerg      := PadR("ORCFAT",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi
Private oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont10n := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont16  := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
Private nPag     := 1
Private nItens   := 0
Private oPrint
Private nIncrNeg := 0

ValidPerg(cPerg)
Pergunte(cPerg, .t.)

// testa se acessou pela rotina de Orcamento de venda (MATA415)
If FunName() = 'MATA415'
	MV_PAR01 := SCJ->CJ_NUM
	MV_PAR02 := SCJ->CJ_NUM
EndIf

oPrint:= TMSPrinter():New('Impressão do Orçamento de Venda')
oPrint:SetPortrait()
oPrint:Setup()

DbSelectArea("SCJ")
DbSetOrder(1) // CJ_FILIAL+CJ_NUM+CJ_CLIENTE+CJ_LOJA
DbSeek(xFilial("SCJ") + MV_PAR01 ,.T.)

While !EOF() .And. SCJ->CJ_NUM <= MV_PAR02 .and. SCJ->CJ_FILIAL == xFilial('SCJ')
	aAnexo  := Array(0)
	nLinhas := 70
	nLinhas++
	
	oPrint:StartPage()   // Inicia uma nova pagina

	CabOrc()
	
	************************************************************************
    DbSelectArea("SA1")   
    DbSeek(xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA)  
    
    oPrint:Say  (375,1000,"DADOS DOS CLIENTES" ,oFont10 )
	oPrint:Line (415,030,415,2400 )// horizontal
	oPrint:Say  (425,045,"Razão Social : " ,oFont10 )
	oPrint:Say  (425,425, SA1->A1_NOME ,oFont10 )
	oPrint:Line (465,030,465,2400 )// horizontal
	oPrint:Say  (475,045,"C.N.P.J/C.I.C : " ,oFont10 )
	oPrint:Say  (475,425, SA1->A1_CGC   ,oFont10 )    
	oPrint:Line (465,1200,515,1200 )// vertical
	oPrint:Say  (475,1230,"Insc.Estadual/RG :   "+ SA1->A1_INSCR ,oFont10 )
	oPrint:Line (515,030,515,2400 )// horizontal
	oPrint:Say  (520,045,"Enderenço : " ,oFont10 )
	oPrint:Say  (520,425, SA1->A1_END   ,oFont10 )    
	oPrint:Line (555,030,555,2400 )// horizontal
	oPrint:Say  (565,045,"Bairro : "    ,oFont10 ) 
	oPrint:Say  (565,425, SA1->A1_BAIRRO,oFont10 )      
	oPrint:Line (555,1880,605,1880 )// vertical
	oPrint:Say  (565,1900,"CEP :   " + SA1->A1_CEP,oFont10 )
	oPrint:Line (605,030,605,2400 )// horizontal
	oPrint:Say  (610,045,"Cidade : "   ,oFont10 )
	oPrint:Say  (610,425,  SA1->A1_MUN ,oFont10 ) 
	oPrint:Say  (610,1900,"Estado :    " + SA1->A1_ESTADO,oFont10 )
	oPrint:Line (605,1880,655,1880 )// vertical
	oPrint:Line (655,030,655,2400 )// horizontal
	oPrint:Say  (665,045,"Fone : " ,oFont10 ) 
	oPrint:Say  (665,425,  SA1->A1_TEL ,oFont10 ) 
	oPrint:Say  (665,1230,"FAX :    " + SA1->A1_FAX,oFont10 )
	oPrint:Line (655,1200,705,1200 )// vertical
	oPrint:Line (705,030,705,2400 )// horizontal
	oPrint:Say  (715,045,"Contato/Setor : "  ,oFont10 )
	oPrint:Say  (715,425,  AllTrim(MV_PAR11) + '   ' + SA1->A1_EMAIL ,oFont10 ) 
	oPrint:Line (415,400,755,400 )// vertical
	oPrint:Line (415,030,755,030 )// vertical
	oPrint:Line (415,2400,755,2400 )// vertical
	oPrint:Line (755,030,755,2400 )// horizontal
	*************************************************
	oPrint:Line (765,030,765,2400 )// horizontal   // 815
	oPrint:Say  (775,045,"Paciente : ", oFont10 )  // 825
	oPrint:Say  (775,425, SCJ->CJ_PACIENT ,oFont10 ) 
	oPrint:Line (825,030,825,2400 )// horizontal  // 875
	oPrint:Say  (835,045,"Convênio : ", oFont10 )  // 885
	oPrint:Say  (835,425, SCJ->CJ_CONVENI, oFont10 ) 
	oPrint:Line (885,030,885,2400 )// horizontal   // 935
	oPrint:Say  (895,045,"Procedimento : " ,oFont10 ) // 945
	oPrint:Say  (895,425, SCJ->CJ_PROCEDI, oFont10 ) 
	oPrint:Line (885,1880,885,1880 )// vertical   995
	oPrint:Say  (895,1900,"Data: " + Dtoc(SCJ->CJ_DTPROC)+" - "+Transform(SCJ->CJ_HORA,"@ER 99:99"), oFont10 )
	oPrint:Line (945,030,945,2400 )// horizontal  995
	oPrint:Say  (955,045,"Médico : ", oFont10 )  // 1005
	oPrint:Say  (955,425, SCJ->CJ_MEDICO, oFont10 ) 
	oPrint:Say  (955,1300,"Hospital : " + SCJ->CJ_HOSPITA, oFont10 )
	oPrint:Line (945,1280,945,1280 )// vertical  945
	oPrint:Line (765,400,1005,400 )// vertical  815
	oPrint:Line (765,030,1005,030 )// vertical
	oPrint:Line (765,2400,1005,2400 )// vertical
	oPrint:Line (1005,030,1005,2400 )// horizontal  1055
	************************************************
	// observacao
	oPrint:Line (1015,030,1015,2400 )             // horizontal
	oPrint:Line (1115,030,1115,2400 )             // horizontal
	oPrint:Line (1015,030,1115,030 )              // vertical
	oPrint:Line (1015,2400,1115,2400 )            // vertical
	oPrint:Line (1015,400,1115,400 )              // vertical
	oPrint:Say  (1025,045, "Observação:" ,oFont10 )
	oPrint:Say  (1025,425, Substr(SCJ->CJ_OBS,1,60) ,oFont10 )
	oPrint:Say  (1070,425, Substr(SCJ->CJ_OBS,61) ,oFont10 )
	************************************************
	oPrint:Line (1125,030,1125,2400 )             // horizontal
	oPrint:Line (1185,030,1185,2400 )             // horizontal
	oPrint:Line (1125,030,1185,030 )              // vertical
	oPrint:Line (1125,2400,1185,2400 )            // vertical
	oPrint:Say  (1135,045,"OPERAÇÃO:" ,oFont10 )
	oPrint:Line (1125,550,1185,550 )              // vertical
	oPrint:Say  (1135,600,"ORÇAMENTO" ,oFont10 )
	oPrint:Line (1125,1450,1185,1450 )            // vertical
	oPrint:Say  (1135,1500,"SUA COTAÇÃO:" ,oFont10 )
	oPrint:Say  (1135,1850, SCJ->CJ_COTCLI,oFont10 )
	
	*****************************************************
	oPrint:Say  (1195,1000,"DESCRIÇÃO DO PRODUTOS" ,oFont10 )
	oPrint:Line (1250,030,1250,2400 )// horizontal
	oPrint:Say  (1260,050, "Id" ,oFont10 )
	oPrint:Say  (1260,120, "Codigo" ,oFont10 )
	oPrint:Say  (1260,1000,"Produtos/Acessórios" ,oFont10 )
	oPrint:Say  (1260,1710,"Item" ,oFont10 )
	oPrint:Say  (1260,1800,"Qtde" ,oFont10 )
	oPrint:Say  (1260,1900,"Valor Unitário" ,oFont10 )
	oPrint:Say  (1260,2200,"Valor Total" ,oFont10 )
	oPrint:Line (1310,030,1310,2400 )  // horizontal

	oPrint:Line (1250,030,2540,030 )   // vertical
	oPrint:Line (1250,100,2540,100 )   // vertical
	oPrint:Line (1250,430,2540,430 )   // vertical
	oPrint:Line (1250,1700,2540,1700 ) // vertical
	oPrint:Line (1250,1780,2540,1780 ) // vertical
	oPrint:Line (1250,1880,2540,1880 ) // vertical
	oPrint:Line (1250,2140,2540,2140 ) // vertical
	oPrint:Line (1250,2400,2540,2400 ) // vertical
	oPrint:Line (2540,030,2540,2400 )  // horizontal
	
	// ITENS DO ORCAMENTO
	dbSelectArea('SCK')
	dbSeek(xFilial('SCK')+SCJ->CJ_NUM)
	nIncr   := 50
	nTotOrc := 0
	Do While !Eof() .and. SCJ->CJ_FILIAL+SCJ->CJ_NUM = SCK->CK_FILIAL+SCK->CK_NUM
		// a partir da segunda pagina
		If nItens == NUM_ITENS_PAG
			nItens   := 1
			nIncr    := 50
			nIncrNeg := 835
			oPrint:EndPage()   // Fecha a pagina
			oPrint:StartPage()   // Inicia uma nova pagina
			CabOrc()

			*****************************************************
			oPrint:Say  (375,1000,"DESCRIÇÃO DO PRODUTOS" ,oFont10 )

			oPrint:Line (415,030,415,2400 )// horizontal
			oPrint:Say  (425,050, "Id" ,oFont10 )
			oPrint:Say  (425,120, "Codigo" ,oFont10 )
			oPrint:Say  (425,1000,"Produtos/Acessórios" ,oFont10 )
			oPrint:Say  (425,1710,"Item" ,oFont10 )
			oPrint:Say  (425,1800,"Qtde" ,oFont10 )
			oPrint:Say  (425,1900,"Valor Unitário" ,oFont10 )
			oPrint:Say  (425,2200,"Valor Total" ,oFont10 )
			oPrint:Line (465,030,465,2400 )   // horizontal

			oPrint:Line (415,030,2540,030 )   // vertical
			oPrint:Line (415,100,2540,100 )   // vertical
			oPrint:Line (415,430,2540,430 )   // vertical
			oPrint:Line (415,1700,2540,1700 ) // vertical
			oPrint:Line (415,1780,2540,1780 ) // vertical
			oPrint:Line (415,1880,2540,1880 ) // vertical
			oPrint:Line (415,2140,2540,2140 ) // vertical
			oPrint:Line (415,2400,2540,2400 ) // vertical
			oPrint:Line (2540,030,2540,2400 ) // horizontal

		EndIf

		// posiciona no produto
		SB1->( dbSeek(xFilial('SB1')+SCK->CK_PRODUTO) )
		
		// verifica se deve imprimir a descricao tecnica
		lAnexo := .f.
		If MV_PAR06 = 1
			// testa no SB1 se tem descricao tecnica
			cDescrItem := MSMM(SB1->B1_DESC_P, 36)
			If ! Empty(cDescrItem)
				lAnexo := .t.
			EndIf
		EndIf
		
		oPrint:Say  (1260+nIncr-nIncrNeg, 050,  SCK->CK_ITEM + Iif(lAnexo, " *","") ,oFont10 )
		oPrint:Say  (1260+nIncr-nIncrNeg, 120,  SCK->CK_PRODUTO ,oFont10 )
		oPrint:Say  (1260+nIncr-nIncrNeg, 1710, SubStr(SCK->CK_PEDCLI,1,3) ,oFont10 )
		oPrint:Say  (1260+nIncr-nIncrNeg, 1750, Transform(SCK->CK_QTDVEN, "@ER 99,999.99") ,oFont10 )
		oPrint:Say  (1260+nIncr-nIncrNeg, 1900, Transform(SCK->CK_PRCVEN, "@ER 999,999,999.99") ,oFont10 )
		oPrint:Say  (1260+nIncr-nIncrNeg, 2150, Transform(SCK->CK_VALOR,  "@ER 999,999,999.99") ,oFont10 )
		nTotOrc += SCK->CK_VALOR
		
		cDesc := AllTrim(SCK->CK_DESCRI)
		If ! Empty(SB1->B1_RMS)
			cDesc += ' - RMS: '+SB1->B1_RMS
		EndIf
		Do While Len(cDesc) > 0
			oPrint:Say  (1260+nIncr-nIncrNeg, 450,  SubStr(cDesc,1,54) ,oFont10 )
			nItens++
			cDesc := SubStr(cDesc,55)
			If Len(cDesc) > 0
				nIncr += 50
			EndIf
		EndDo

		// prepara os anexos
		If lAnexo
			Aadd(aAnexo, {SCK->CK_PRODUTO, SCK->CK_ITEM})
		EndIf
				
		nIncr += 60
		dbSelectArea('SCK')
        dbSkip()
	EndDo
	
	*************************************************
	oPrint:Line (2590,030,2590,2400 )  // horizontal
	oPrint:Line (2650,030,2650,2400 )  // horizontal
	oPrint:Line (2590,030,2650,030 )   // vertical
	oPrint:Say  (2600,040,"Condição: " ,oFont10 )

	SE4->( dbSeek(xFilial('SE4')+SCJ->CJ_CONDPAG) )
	oPrint:Say  (2600,0250,SE4->E4_DESCRI ,oFont10 )

	oPrint:Say  (2600,1600,"TOTAL DO ORCAMENTO: " ,oFont10 )
	oPrint:Line (2590,1590,2650,1590 )// vertical
	oPrint:Say  (2600,2150,Transform(nTotOrc, "@ER 9,999,999,999.99") ,oFont10 )
	oPrint:Line (2590,2400,2650,2400 )// vertical

	__nLin := 2700
	If !Empty(MV_PAR03)
		oPrint:Say  (__nLin,040,"Garantia: "+MV_PAR03 ,oFont10 )
		__nLin += 60
	EndIf
	If !Empty(MV_PAR12)
		oPrint:Say  (__nLin,040,"Marca: "+MV_PAR12 ,oFont10 )
		__nLin += 60
	EndIf
	oPrint:Say  (__nLin,040,"Validade do Orçamento: "+MV_PAR05 ,oFont10 )
	__nLin += 60
	oPrint:Say  (__nLin,040,"Prazo de Entrega: "+MV_PAR04 ,oFont10 )
	__nLin += 60
	oPrint:Say  (__nLin,040,"Frete: "+MV_PAR10 ,oFont10 )
	__nLin += 40
	
	*************************************************
	oPrint:Line (__nLin,030,__nLin,2400 )// horizontal
	oPrint:Line (__nLin,030,__nLin+200,030 )// vertical
	oPrint:Line (__nLin,2400,__nLin+200,2400 )// vertical
	oPrint:Line (__nLin,1200,__nLin+200,1200 )// vertical
	__nLin += 10
	oPrint:Say  (__nLin,450,"CONFIRMAÇAO" ,oFont10 )
	oPrint:Say  (__nLin,1700,"ANÁLISE CRÍTICA" ,oFont10 )
	__nLin += 40
	oPrint:Line (__nLin,030,__nLin,2400 )// horizontal
	
	**********************************************
	__nLin += 100
	oPrint:Line (__nLin,130,__nLin,1100 )// horizontal assinatura
	oPrint:Line (__nLin,1300,__nLin,2300 )// horizontal assinatura
	__nLin += 10
	oPrint:Say  (__nLin,130,MV_PAR07 ,oFont10 )
	oPrint:Say  (__nLin,1300,MV_PAR08 ,oFont10 )
	__nLin += 40
	oPrint:Line (__nLin,030,__nLin,2400 )// horizontal
	
	oPrint:EndPage() // Finaliza a pagina
	
	// imprime os anexos
	If Len(aAnexo) > 0
		For nAnexo := 1 To Len(aAnexo)
			oPrint:StartPage()   // Inicia uma nova pagina
			CabOrc()
			
			// posiciona no produto
			SB1->( dbSeek(xFilial('SB1')+aAnexo[nAnexo,1]) )
			
			nLin := 415
			oPrint:Line (415,030,415,2400 ) // horizontal
			oPrint:Say  (425,045, "ANEXO DO ITEM: "+aAnexo[nAnexo,2]+' - '+SubStr(SB1->B1_DESC,1,60) ,oFont10 )
			oPrint:Line (465,030,465,2400 ) // horizontal
			
			// imprime a descricao tecnica
			cDesc := MSMM(SB1->B1_DESC_P, TamSx3("B1_VM_P")[1])
			cDesc += Chr(13)+Chr(10)
			
			nIncr := 0
			oPrint:Say(515, 040, aAnexo[nAnexo,1] ,oFont10 )
			
			Do While Len(cDesc) > 0
				// localizo o ENTER
				nCrLf := At(Chr(10), cDesc)
				nCtrl := 0
				cDescPrint := Space(0)
				If nCrLf > 0
					// verifico se o proximo caracter eh Chr(13)
					If Substr(cDesc, nCrLf-1, 1) = Chr(13)
						cDescPrint := Substr(cDesc,1,At(Chr(13)+Chr(10), cDesc)-1)
						nCtrl := 3
					Else
						cDescPrint := Substr(cDesc,1,At(Chr(10), cDesc)-1)
						nCtrl := 2
					EndIf
				EndIf
				
				oPrint:Say(515+nIncr, 260,  cDescPrint, oFont10)
				cDesc := SubStr(cDesc,Len(cDescPrint) + nCtrl)
				nIncr += 50
				
				If 515+nIncr >= 3150 .and. Len(cDesc) > 0
					// Quebra de pagina
					oPrint:EndPage()     // Inicia uma nova pagina
					oPrint:StartPage()   // Inicia uma nova pagina
					CabOrc()
					
					nLin := 415
					oPrint:Line (415,030,415,2400 ) // horizontal
					oPrint:Say  (425,045, "ANEXO DO ITEM: "+aAnexo[nAnexo,2]+' - '+SubStr(SB1->B1_DESC,1,60) ,oFont10 )
					oPrint:Line (465,030,465,2400 ) // horizontal
					nIncr := 0
					oPrint:Say(515, 040, aAnexo[nAnexo,1] ,oFont10 )
                EndIf
			EndDo
			nIncr += 50
			oPrint:Line(515+nIncr,030,515+nIncr,2400)  // horizontal
			oPrint:Line(nLin,030,515+nIncr,030)    // vertical
			oPrint:Line(nLin,2400,515+nIncr,2400)  // vertical
			
			oPrint:EndPage()   // Inicia uma nova pagina
		Next
	EndIf
	
	dbSelectArea("SCJ")
	dbSkip()
EndDo

oPrint:Preview()  // Visualiza antes de imprimi
//oPrint:Print()  // Visualiza antes de imprimi

RestArea( aArea )

Return


Static Function CabOrc()

	oPrint:Line (045,030,045,2400 ) // horizontal
	oPrint:Line (045,030,300,030 )  // vertical
	oPrint:Line (045,900,300,900 )  // vertical
	
	// logotipo da empresa
	cBitMap := U_JMHF060()
	oPrint:SayBitmap(80, 40, cBitMap, 800, 206 )
   	
   	//If cEmpAnt = '01'
	//   	oPrint:SayBitmap(80, 40, "logo_jomhedica.bmp", 800, 206 )
	//ElseIf cEmpAnt = '10'
	//   	oPrint:SayBitmap(80, 40, "logo_world.bmp", 800, 206 )
	//EndIf   
	
	oPrint:Say  (060,915,SM0->M0_NOMECOM ,oFont10)
	oPrint:Say  (095,915,Alltrim(SM0->M0_ENDCOB) + "  CEP : " + SM0->M0_CEPCOB + "  " + SM0->M0_CIDCOB + "  " + SM0->M0_ESTCOB ,oFont10)
	oPrint:Say  (130,915,"C.N.P.J. "+SM0->M0_CGC+"  -  Insc.Est. "+SM0->M0_INSC ,oFont10)
	oPrint:Say  (165,915,"FONE : " + AllTrim(SM0->M0_TEL) + "  -   FAX : " + AllTrim(SM0->M0_FAX)  ,oFont10)
	oPrint:Say  (200,915,"HOME - PAGE : www.jomhedica.com.br" ,oFont10)
	oPrint:Say  (235,915,"e-mail : "+MV_PAR09 ,oFont10)
	oPrint:Line (300,030,300,2400 )// horizontal
	oPrint:Line (045,2400,300,2400 )// vertical
	
	*******************************************************************************************
	oPrint:Line (315,030,315,2400 )// horizontal
	oPrint:Line (315,640,365,640 )// vertical
	oPrint:Line (315,030,365,030 )// vertical
	oPrint:Say  (320,045,"Orçamento Nº :   " + SCJ->CJ_NUM + "   Pag: " + Alltrim(Str(nPag, 5)),oFont10 )    //Pedido Numero
	nPag++
	oPrint:Say  (320,645,"Data de Emissão :   " + Dtoc(SCJ->CJ_EMISSAO) ,oFont10 )    //Pedido Numero
	oPrint:Say  (320,1710,"Codigo Cliente :   " + SCJ->CJ_CLIENTE+' - Loja  '+SCJ->CJ_LOJA,oFont10 )    //Pedido Numero
	oPrint:Line (315,2400,365,2400 )// vertical
	oPrint:Line (315,1700,365,1700 )// vertical
	oPrint:Line (365,030,365,2400 )// horizontal

Return



Static Function ValidPerg(cPerg)

If ! SX1->( dbseek(cPerg) )
	PutSx1( cPerg,"01","Orcamento de?        ", "","","mv_ch1","C",6,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"02","Orcamento ate?       ", "","","mv_ch2","C",6,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"03","Tempo de Garantia?   ", "","","mv_ch3","C",50,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"04","Prazo de entrega?    ", "","","mv_ch4","C",50,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"05","Validade Orcamento?  ", "","","mv_ch5","C",30,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"06","Descricao Tecnica?   ", "","","mv_ch6","N",1,0,0,"C","","","","","mv_par06","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","")
	PutSx1( cPerg,"07","Nome 1?              ", "","","mv_ch7","C",50,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"08","Nome 2?              ", "","","mv_ch8","C",50,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"09","e-mail para Resposta?", "","","mv_ch9","C",50,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"10","Informacao de Frete",   "","","mv_cha","C",50,0,0,"G","","","","","mv_par10","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"11","Aos Cuidados de:",      "","","mv_chb","C",50,0,0,"G","","","","","mv_par11","","","","","","","","","","","","","","","","",,,)
	PutSx1( cPerg,"12","Marca:",                "","","mv_chc","C",50,0,0,"G","","","","","mv_par12","","","","","","","","","","","","","","","","",,,)
EndIf

Return
