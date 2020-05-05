#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} CBRETET2
//Ponto de entrada para alterar get etiqueta
@author Celso Rene
@since 28/11/2018
@version 1.0
@type function
/*/

User Function CBRETET2()

	Local cID    := paramixb[1]  
	Local cTipID := paramixb[2]  
	Local aRetPE := {} // Array com os dados da localizada na tabela CB0.
	//Local _aArea := GertArea()



	//VtAlert("Passou pelo ponto de entrada = CBRETET2 = ","Aviso!",.t.,4000)


	If ( cTipID == '01' )   			// produto

		If (Len(Alltrim(cID)) >= 25) //etiqueta do cliente - Jomhedica 

			_cEtiqLot	 := Substr(cID,TamSx3("B1_COD")[1] + 1,TamSx3("CB0_CODETI")[1] ) //codigo etiqueta e lotectl = mesmo tamanho	

			dbSelectArea("CB0")
			dbSetOrder(1)
			dbSeek( xFilial("CB0") + _cEtiqLot )
			If ( Found() )
				_cEtiqprod :=  CB0->CB0_CODETI //Padr( CB0->CB0_CODETI , TamSx3("CB0_CODETI2")[1] ) 


				_aArea:= GetArea()
				
				//tira empenho para liberacao leitura etiqueta
				dbSelectArea("CB9")
				dbSetOrder(3) //CB9_FILIAL+CB9_PROD+CB9_CODETI 
				dbSeek(xFilial("CB9") + CB0->CB0_CODPRO + CB0->CB0_CODETI )                                                                                                                                 
				If ( ! Found() )

					dbselectARea("SB8")
					dbSetOrder(5) //B8_FILIAL+B8_PRODUTO+B8_LOTECTL
					dbSeek(xFilial("SB8") + CB0->CB0_CODPRO + CB0->CB0_LOTE)
					If ( Found() .and. (SB8->B8_SALDO - SB8->B8_EMPENHO) <= CB0->CB0_QTDE .and. SB8->B8_SALDO >= CB0->CB0_QTDE .and. SB8->B8_EMPENHO >= CB0->CB0_QTDE  )

						dbSelectArea("SB8")
						RECLOCK("SB8",.F.)
						SB8->B8_EMPENHO := SB8->B8_EMPENHO - CB0->CB0_QTDE
						SB8->(MsUnlock())

					EndIf

				EndIf

				RestArea(_aArea)

			EndIf
		Else
			dbSelectArea("CB0")
			dbSetOrder(1)
			dbSeek( xFilial("CB0") + cID )
			If (Found() )
				_cEtiqprod :=  CB0->CB0_CODETI
			EndIf
		EndIf


		aadd(aRetPE,CB0->CB0_CODPRO)    //1-código do produto	
		aadd(aRetPE,CB0->CB0_QTDE)      //2-quantidade	
		aadd(aRetPE,CB0->CB0_USUARIO)   //3-código do usuário	
		aadd(aRetPE,CB0->CB0_NFENT)     //4-Nota Fiscal de entrada	
		aadd(aRetPE,CB0->CB0_SERIEE)    //5-Série da NF de entrada	
		aadd(aRetPE,CB0->CB0_FORNEC)    //6-Código do fornecedor	
		aadd(aRetPE,CB0->CB0_LOJAFO)    //7-Loja do fornecedor	
		aadd(aRetPE,CB0->CB0_PEDCOM)    //8-Pedido de compra	
		aadd(aRetPE,CB0->CB0_LOCALI)    //9-Localização	
		aadd(aRetPE,CB0->CB0_LOCAL)     //10-Almoxarifado	
		aadd(aRetPE,CB0->CB0_OP)        //11-OP	
		aadd(aRetPE,CB0->CB0_NUMSEQ)    //12-Número de Seqüência	
		aadd(aRetPE,CB0->CB0_NFSAI)     //13-Nota Fiscal de Saída	
		aadd(aRetPE,CB0->CB0_SERIES)    //14-Série da NF de Saída	
		aadd(aRetPE,CB0->CB0_CODET2)    //15-Código da etiqueta do cliente	
		aadd(aRetPE,CB0->CB0_LOTE)      //16-Lote	
		aadd(aRetPE,CB0->CB0_SLOTE)     //17-Sub-Lote	
		aadd(aRetPE,CB0->CB0_DTVLD)     //18-Data de validade	
		aadd(aRetPE,CB0->CB0_CC)        //19-Centro de custo	
		aadd(aRetPE,CB0->CB0_LOCORI)    //20-Armazém Original	
		aadd(aRetPE,CB0->CB0_PALLET)    //21-Código do Pallet	
		aadd(aRetPE,CB0->CB0_OPREQ)     //22-OP para qual o produto foi requisitado	
		aadd(aRetPE,CB0->CB0_NUMSER)    //23-Número de Série	
		aadd(aRetPE,CB0->CB0_ORIGEM)    //24-Origem  


	ElseIf cTipID == '02' // LOCALIZAÇÃO	
		aRetPE := {CB0->CB0_LOCALI,CB0->CB0_LOCAL}
	ElseIf cTipID == '03' // UNITIZADOR	
		aRetPE := {CB0->CB0_DISPID}
	ElseIf cTipID == '04' // USUÁRIO	
		aRetPE := {CB0->CB0_USUARIO}
	ElseIf cTipID == '05' //VOLUME	
		aRetPE := {CB0->CB0_VOLUME,;		
		CB0->CB0_PEDVEN,;		
		CB0->CB0_NFSAI,;		
		CB0->CB0_SERIES}
	ElseIf cTipID == '06'	
		aRetPE := {CB0->CB0_TRANSP}
	ElseIf cTipID == '07' //VOLUME	
		aRetPE := {CB0->CB0_VOLUME,;		
		CB0->CB0_NFENT,;     //3-Nota Fiscal de Entrada		
		CB0->CB0_SERIEE,;    //4-Série da Nota Fiscal de Entrada		
		CB0->CB0_FORNEC,;    //5-Código do fornecedor		
		CB0->CB0_LOJAFO}     //6-Loja do fornecedor
	EndIf


	//RestArea( _aArea )


Return (aRetPE)



/*/{Protheus.doc} Return
//Ponto de entrada leitura codigo da etiqueta
@author Celso Rene
@since 28/11/2018
@version 1.0
@type function
/*/

User Function CBRETETI()

	Local _cEtiqprod := PARAMIXB[1] 
	//Local _aArea	 := GetArea()
	Local _cEtiqLot	 := Substr(_cEtiqprod,TamSx3("B1_COD")[1] + 1,TamSx3("CB0_CODETI")[1] ) //codigo etiqueta e lotectl = mesmo tamanho	

	//If ( "ACD" $ _cEtiqprod ) 
	If (Len(Alltrim(_cEtiqprod)) >= 25) //etiqueta do cliente - Jomhedica 
		dbSelectArea("CB0")
		dbSetOrder(1)
		dbSeek( xFilial("CB0") + _cEtiqLot )
		If ( Found() )
			_cEtiqprod := CB0->CB0_CODETI // Padr( CB0->CB0_CODETI , TamSx3("CB0_CODETI2")[1] ) 
		EndIf
		//EndIf
		PARAMIXB[1]  := _cEtiqprod
	EndIf

	//RestArea(_aArea)

Return( {  _cEtiqprod , PARAMIXB[2] } )
