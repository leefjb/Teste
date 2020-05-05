#include "protheus.ch"
#include "sigawin.ch"

/*���������������������������������������������������������������������������
���Fun��o    � JMHF060  � Adap  � Marllon Figueiredo    � Data �22.08.2008���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna o arquivo de logotipo correto da empresa           ���
���          �                                                            ���
���������������������������������������������������������������������������*/
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