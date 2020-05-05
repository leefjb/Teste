#INCLUDE "PROTHEUS.CH"
/*
Jean Rehermann - Solutio IT - 27/03/2018
Ponto de entrada para manipular o array aRotina do menu da rotina MATA270 - Programa de digitacao do inventario
*/
User Function MTA270MNU()
	
	// Acessar tela com campos para gravar parametro ES_PARINV com dados do inventario
	aAdd( aRotina, { "Param.Coletor", "U_GETPARCO", 0 , 2, 0, Nil } )

Return

/*
Jean Rehermann - Solutio IT - 27/03/2018
Acessar tela com campos para gravar parametro ES_PARINV com dados do inventario
*/
User Function GETPARCO()

	Local nOpt    := 0
	Local cPar01  := ""
	Local cPar02  := ""
	Local cPar03  := ""
	Local cStrPar := ""
	Local cLocal  := Space(2)
	Local cDocInv := Space(9)
	Local dDtInv  := Date()
	Local cParInv := SuperGetMv("ES_PARINV", .F., " ") 
    Local aArea   := GetArea()
	Local oDlg1, oGrp1, oSay1, oSay2, oSay3, oGet1, oGet2, oGet3, oSBtn1, oSBtn2
    
	If !Empty( cParInv )
	
		// Local
		cPar01 := SubStr( cParInv, 01, 02 )
		cLocal  := Iif( !Empty( cPar01 ), cPar01, cLocal )
		
		// Data
		cPar02 := SubStr( cParInv, 03, 08 )
		dDtInv  := Iif( !Empty( cPar02 ), StoD( cPar02 ), dDtInv )
	
		// Documento
		cPar03 := SubStr( cParInv, 11, 09 )
		cDocInv := Iif( !Empty( cPar03 ), cPar03, cDocInv )
    
    EndIf
    
	oDlg1  := MSDialog():New( 161,342,401,607,"Parametros do Inventario",,,.F.,,,,,,.T.,,,.T. )
	oGrp1  := TGroup():New( 004,004,092,124,"Parametro Fixo no Coletor",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1  := TSay():New( 028,008,{||"Local Padrao"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay2  := TSay():New( 048,008,{||"Documento"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay3  := TSay():New( 068,008,{||"Data"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet1  := TGet():New( 028,048,{|u| Iif(PCount()>0,cLocal:=u,cLocal)}  ,oGrp1,020,008,'@!',{|| !Empty( cLocal  ) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cLocal" )
	oGet2  := TGet():New( 048,048,{|u| Iif(PCount()>0,cDocInv:=u,cDocInv)},oGrp1,060,008,'@!',{|| !Empty( cDocInv ) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDocInv")
	oGet3  := TGet():New( 068,048,{|u| Iif(PCount()>0,dDtInv:=u,dDtInv)}  ,oGrp1,060,008,'@!',{|| !Empty( dDtInv  ) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtInv" )
	oSBtn1 := SButton():New( 096,095,1,{|| nOpt := 1, oDlg1:End() },oDlg1,,"", )
	oSBtn2 := SButton():New( 096,063,2,{|| nOpt := 0, oDlg1:End() },oDlg1,,"", )
	
	oDlg1:Activate(,,,.T.)

	If nOpt == 1
		
		cStrPar += cLocal + DtoS( dDtInv ) + cDocInv
		
		If !GetMv("ES_PARINV", .T.)
			CriaMv()
		EndIf
		
		PutMv("ES_PARINV",cStrPar)
		GetMv("ES_PARINV")
		
	EndIf
    
	RestArea( aArea )

Return

// Cria o parametro se este nao existir
Static Function CriaMv()

	dbSelectArea("SX6")
	RecLock("SX6", .T.)
		SX6->X6_VAR     := "ES_PARINV"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := SX6->X6_DSCSPA  := SX6->X6_DSCENG  := "Parametros para inventario no coletor"
		SX6->X6_PROPRI  := 'U'
	SX6->( MsUnlock() )

Return