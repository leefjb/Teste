//*============================================================================
// Programa.......: FITFAT00.PRW
// Objetivo.......: Abre Tela de Parametros
// Autor..........: 
// Data...........: 
//------------------------------------------------------------------------------
// Autor      |   Data     | Alteracao
//------------|------------|----------------------------------------------------
//            |            |
//============================================================================*/

#Include "RwMake.Ch"

User Function JmhFin3X()           

DbSelectArea("SX1")
DbSetOrder(1)
IF !DBSEEK(cPerg)
	RECLOCK("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "01"
	SX1->X1_PERGUNTA := "Data Inicio   ?"
	SX1->X1_TIPO     := "D"
	SX1->X1_TAMANHO  := 8
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR01"
	SX1->X1_VARIAVL  := "mv_ch1"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "02"
	SX1->X1_PERGUNTA := "Data Fim      ?"
	SX1->X1_TIPO     := "D"
	SX1->X1_TAMANHO  := 8
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR02"
	SX1->X1_VARIAVL  := "mv_ch2"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := cPerg
	SX1->X1_ORDEM    := "03"
	SX1->X1_PERGUNTA := "Informe o CRM ?"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 6
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "MV_PAR03"
	SX1->X1_VARIAVL  := "mv_ch3"
	MsUnlock()

ENDIF

Pergunte(cPerg,.T.)
dDataI := MV_PAR01    // Data Inicial
dDataF := MV_PAR02    // Data Final
cCRM   := MV_PAR03    // Codigo do CRM
lPerg  := .T.

Return
