#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TBICONN.CH" 
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "rwmake.ch"
User Function FISTRFNFE()
// ****
Local _xaRotina:=aRotina
Local xxx := 1
Local _PrgRod :=""
For xxx:=1 to len(_xaRotina)
    if "DANFE"$Upper(_xaRotina[xxx,1])
	     _PrgRod:=_xaRotina[xxx,2] +',U_NFEBOL()' 
	    _xaRotina[xxx,2]:=_PrgRod
	endif
Next
aRotina:=_xaRotina
////**** 
//aadd(aRotina,{'(e)Boleto','U_NFEBOL()' , 0 , 3,0,NIL})
Return Nil              

User Function NFEBOL()
Local lSaidaLeef:= .F.   // Leef - Assis(160819)- Variavel para definir se tem registro na SE1(C.R.)
Local _xDoc:=""
Local _xSer:=""
Local _xFil := xFilial("SF2")
aArea:= getarea()
Pergunte("NFSIGW",.F.)
_xDoc:=MV_PAR01
_xSer:=MV_PAR03
SF2->(DbsetOrder(1))
SF2->(dbseek(xFilial("SF2") + _xDoc + _xSer))
SE1->(DbsetOrder(1))
SE1->(dbseek(xFilial("SE1") + _xSer + _xDoc))
Do While xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM == _xFil +_xSer + _xDoc .And. !(SE1->(Eof()))
	ConOut("#Leef-console# FISTRFNFE - Gerou SE1 - "+ SE1->E1_NUM)
	lSaidaLeef:= .T.  // Leef - Assis(10/09/19) - Tem Registro na SE1.
	SE1->(dbSkip())
EndDo
if lSaidaLeef
   u_LfGrvNN(lSaidaLeef,.T.,.T.,.F.) // fonte encontra-se no PE_M460FIM.PRW
else
   Alert("Não há Titulo para NF/Serie = "+ SF2->F2_DOC+"/"+SF2->F2_SERIE+"  da Filial "+SF2->F2_FILIAL)
end if
RestArea(aArea)
return
