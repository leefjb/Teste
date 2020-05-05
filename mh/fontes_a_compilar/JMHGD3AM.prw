#INCLUDE "TOTVS.CH"
                        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ JMHGD3AM บ Autor ณ Cristiano Oliveira บ Data ณ 21/03/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza o Armazem de Destino em Lote na Trasnf. Modelo 2  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JOMHEDICA                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function JMHGD3AM()

	Local lRet    := .T.
	Local cMemLoc := ""
	Local nPosLoc := 0
	Local nI      := 0

	// TRANSF.MOD.II	        
	If IsInCallStack("U_JMHGD3AM") .AND. aRotina[3,2] == "U_A261Inclui" // TYPE("aRotina[3,2]") == "C" //TYPE("aRotina[3,2]") <> "U"

		cMemLoc := M->D3_LOCAL             
		nPosLoc := aScan(aHeader, {|x| AllTrim(x[1])== "Armazem Destino"})
			     
		// TROCAR ARMAZEM P/ TODOS OS REGISTROS
		If MsgYesNo("Atualizar o armazem para todos os registros?")
		                                                                     
			For nI := 1 To Len(aCols)
				aCols[nI, nPosLoc] := cMemLoc	
			Next nI
			
		EndIf
		
	EndIf

Return(lRet)