#include "protheus.ch"
#include "sigawin.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡„o    ³ JMHF060  ³ Adap  ³ Marllon Figueiredo    ³ Data ³22.08.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna o arquivo de logotipo correto da empresa           ³±±
±±³          ³                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function JMHF060( nTipoLogo )
	
	Local cNomeDefaul  := "logo_default.bmp"
	Local cNomeLogo    := "logo_"
    
	// nTipoLogo := 1 = relatorios e orcamentos
	// ntipoLogo := 2 = Nota fiscal eletronica

	Default nTipoLogo  := 1

	If nTipoLogo = 1
		cNomeLogo := cNomeLogo+cEmpAnt+cFilAnt+'.bmp'
		If ! File(cNomeLogo)
			cNomeLogo := cNomeDefault
		EndIf
	Else
		cNomeLogo := 'logonfe_'+cEmpAnt+cFilAnt+'.bmp'
		If ! File(cNomeLogo)
			cNomeLogo := ""
		EndIf
	EndIf
	
Return( cNomeLogo )