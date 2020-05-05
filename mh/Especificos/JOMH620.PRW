#include "rwmake.ch"

User Function JOMH620()
//User Function SCH620( nVal )
                            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aArea:=GetArea()
Local aAreaSf2:=GetArea("SF2")
Local aAreaSe1:=GetArea("SE1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ary - 06/08/2010.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_VALOR,xCofins,xPIS,xCsll,xSERIE,xNUM_DUPLIC,xDUPLICATAS")

//If nVal == Nil
	nVal := 0
//EndIf

//IF SF4->F4_CONTAB=="S" .AND. Right(Trim(SF4->F4_CF),3) $ "933"
//	_valor :=  SF2->F2_VALBRUT
	
//ELSE
	IF(SF4->F4_CONTAB=="S" .AND. SF2->F2_VALINSS > 25)
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xCofins     := 0
		xPIS        := 0
		xCsll       := 0
		xSERIE  := SF2->F2_SERIE
		xNUM_DUPLIC  :=  SF2->F2_DUPL
		DbSeek(xFilial("SE1") + xSerie + xNUM_DUPLIC, .t. )
		while !eof() .and. SE1->E1_NUM == xNUM_DUPLIC .and. Se1->E1_Prefixo == xSerie
			If SE1->E1_TIPO $ 'CF-'
				xCofins := Se1->E1_Valor
			EndIf
			If SE1->E1_TIPO $ 'PI-'
				xPis := Se1->E1_Valor
			EndIf
			If SE1->E1_TIPO $ 'CS-'
				xCsll := Se1->E1_Valor
		   	EndIf
			dbSkip()                           
		EndDo                                       
		
        _valor :=  SF2->F2_VALBRUT - SF2->F2_VALINSS - SF2->F2_VALIRRF - IF(SF2->F2_RECISS =="1",SF2->F2_VALISS,0) - xCofins - xPis - xCsll

	ElseIF (SF4->F4_CONTAB=="S" .AND. SF2->F2_VALINSS < 25)
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xCofins     := 0
		xPIS        := 0
		xCsll       := 0
		xSERIE  := SF2->F2_SERIE
		xNUM_DUPLIC  :=  SF2->F2_DUPL
		DbSeek(xFilial("SE1") + xSerie + xNUM_DUPLIC, .t. )
		while !eof() .and. SE1->E1_NUM == xNUM_DUPLIC .and. Se1->E1_Prefixo == xSerie
			If SE1->E1_TIPO $ 'CF-'
				xCofins := Se1->E1_Valor
			EndIf
			If SE1->E1_TIPO $ 'PI-'
				xPis := Se1->E1_Valor
			EndIf
			If SE1->E1_TIPO $ 'CS-'
				xCsll := Se1->E1_Valor
			EndIf
			dbSkip()
		EndDo
		
		_valor :=  SF2->F2_VALBRUT - SF2->F2_VALIRRF - IF(SF2->F2_RECISS =="1",SF2->F2_VALISS,0) - xCofins - xPis - xCsll

	EndIf
//Endif

If nVal == 1 // Pis
	_valor := xPis
ElseIf nVal == 2 // Cofins
	_valor := xCofins
ElseIf nVal == 3 // CSLL
	_valor := xCSLL
EndIf

SE1->(RestArea(aAreaSE1))
SF2->(RestArea(aAreaSF2))
RestArea(aArea)

Return( _valor )
