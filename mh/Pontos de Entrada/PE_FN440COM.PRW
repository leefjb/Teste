#INCLUDE "PROTHEUS.CH"


User function FN440COM()
   
		//Sempre excluo os movimentos, antes de comecar o calculo
   	cDelete := " DELETE "
   	cDelete += " FROM " + RetSqlName("SE3")
	cDelete += " WHERE   E3_FILIAL     = '" + xFilial('SE3') + "'"
	cDelete += "   AND   E3_DATA       = ''"
	cDelete += "   AND   E3_EMISSAO    >= '" + DtoS(MV_PAR01)	+ "'"
	cDelete += "   AND   E3_EMISSAO    <= '" + DtoS(MV_PAR02)	+ "'"
	cDelete += "   AND   E3_VEND       >= '" + MV_PAR03       	+ "'"
	cDelete += "   AND   E3_VEND       <= '" + MV_PAR04        	+ "'"
	cDelete += "   AND   E3_ORIPROG     = 'JMHA210'"  //Campo Especifico
	TcSqlExec( cDelete )

Return
