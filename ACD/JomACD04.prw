#include 'protheus.ch'


/*/{Protheus.doc} ACD004
//bloqueio / desbloqueio de lote - SDD
@author solutio
@since 08/11/2018
@version 1.0
@type function
/*/
User Function JomACD04(_lRetP,_cDoc,_aItens)

	Local _aVetor := {}
	  
	lMsErroAuto := .F.  

	DbSelectArea("SX6")
	DbSetOrder(1)
	If ( !dBseek("  "+"MV_DOCSDD") )
		RecLock("SX6", .T.)
		SX6->X6_FIL    := "  "
		SX6->X6_VAR    := "MV_DOCSDD"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Controle Numercao Doc - SSD - Bloqueio Lote"
		SX6->X6_CONTEUD:= "00000003"
		MsUnLock()
	EndIf       


	If (_lRetP == .T.) //bloqueando lote

		_cDoc := Alltrim(GetMv("MV_DOCSDD"))

		_aVetor := {;                
		{"DD_DOC"		, _cDoc      ,NIL},;
		{"DD_PRODUTO" 	, _aItens[1] ,NIL},;
		{"DD_LOCAL"     , _aItens[2] ,NIL},;    
		{"DD_LOTECTL"	, _aItens[3] ,NIL},;
		{"DD_QUANT"		, _aItens[4] ,NIL},;
		{"DD_MOTIVO"	,"ND",NIL}}                                               	

		MSExecAuto({|x, y| mata275(x, y)},_aVetor, 3)       

	Else //desbloqueando lote

		_aVetor := {;                
		{"DD_DOC"		, Padr(_cDoc,  TamSx3("DD_DOC")[1] )	,NIL}}
		MSExecAuto({|x, y| mata275(x, y)},_aVetor, 4)  

	EndIf


	If ( lMsErroAuto )
		_cDoc := ""    
		Mostraerro() 
	Else    
		If (_lRetP == .T.) //bloqueio
			PUTMV("MV_DOCSDD", Soma1(_cDoc))
			Conout( "Gerou Bloqueio Lote - Documento: " + _cDoc )
		Else
			Conout( "Gerou Desbloqueio Lote - Documento: " + _cDoc )
		EndIf	
	Endif


Return(_cDoc)
