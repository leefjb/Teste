/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MA261D3  ³ Autor ³ Fabio Briddi          ³ Data ³ Jun/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza campos no momento da gravacao das Transferencias  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Localiz.  ³ Na funcao A261Grava( ) apos a gravacao dos movimentos de o ³±±
±±³          ³ origem e destino do SD3.                                   ³±±
±±³          ³                                                            ³±±
±±³          ³ Chamado apos a gravacao dos movimentos de origem e destino ³±±
±±³          ³ de cada item de transferencia.                             ³±±
±±³          ³ Pode ser utilizado para atualizar campos no momento da     ³±±
±±³          ³ gravacao                                                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MA261D3()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Jomhedica                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                          ULTIMAS ALTERACOES                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA261D3( )

	Local nPosAcols	:= ParamIXB	//-- Numero da linha do aCols que esta sendo processado
	
 	Local nPosLtcOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_LTCTORI"})
	Local nPosDtVOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_DTVORI"})
	Local nPosDocOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_DOCORI"})
	Local nPosSerOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_SERORI"})
	Local nPosForOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_FORORI"})
	Local nPosLojOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_LOJORI"})
	Local nPosLanOri	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))== "D3_LANORI"})  

	Local cSeek 		:= ""


	RecLock( "SD3", .F. ) 
		SD3->D3_LTCTORI	:= aCols[nPosAcols, nPosLtcOri]
		SD3->D3_DTVORI	:= aCols[nPosAcols, nPosDtVOri]
		SD3->D3_DOCORI	:= aCols[nPosAcols, nPosDocOri]
		SD3->D3_SERORI	:= aCols[nPosAcols, nPosSerOri]
		SD3->D3_FORORI	:= aCols[nPosAcols, nPosForOri]
		SD3->D3_LOJORI	:= aCols[nPosAcols, nPosLojOri]
		SD3->D3_LANORI	:= aCols[nPosAcols, nPosLanOri]	
	MsUnLock()
	
	cSeek := SD3->D3_COD
	cSeek += SD3->D3_LOCAL
	cSeek += DtoS(SD3->D3_DTVALID)
	cSeek += SD3->D3_LOTECTL
	cSeek += SD3->D3_NUMLOTE
	
	SB8->(dbSetOrder(1))
	
	If SB8->( dbSeek(xFilial("SB8")+ cSeek ) )
	
		RecLock( "SB8", .F. )  
			SB8->B8_LTCTORI	:= aCols[nPosAcols, nPosLtcOri]
			SB8->B8_DTVORI	:= aCols[nPosAcols, nPosDtVOri]
			SB8->B8_DOCORI	:= aCols[nPosAcols, nPosDocOri]
			SB8->B8_SERORI	:= aCols[nPosAcols, nPosSerOri]
			SB8->B8_FORORI	:= aCols[nPosAcols, nPosForOri]
			SB8->B8_LOJORI	:= aCols[nPosAcols, nPosLojOri]
			SB8->B8_LANORI	:= aCols[nPosAcols, nPosLanOri]
			SB8->B8_LOTEUNI := "S" 
		MsUnLock()
	
	EndIf 

Return( Nil )