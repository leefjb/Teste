//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Constantes Codigos de Status de Pedidos de Vendas  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
                                               
#INCLUDE "TOTVS.CH"

#Define PEDIDO_INCLUIDO      "010"
#Define LIB_COMERCIAL        "020"
#Define LIB_CREDITO          "030"
#Define LIB_ESTOQUE          "040"
#Define ENVIADO_SEPARACAO    "050"
#Define EM_SEPARACAO         "055"
#Define SEPARADO             "059"
#Define ENVIADO_CONFERENCIA  "060"
#Define EM_CONFERENCIA       "065"
#Define CONFERIDO            "070"
#Define FATURADO             "080"
#Define FATURAMENTO_EXCLUIDO "089"
#Define PEDIDO_EXCLUIDO      "999"
// #Define LPARDEL              .F.

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿛E_MS520DEL 튍utor  쿘anoel M          � Data �  set/2012   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     쿮xclusao da tabela de pontuacao do SIGACRD                  볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � faturamento                                                볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

User Function MS520DEL()
                                                    
	If .T. // LPARDEL // MsgYesNo("EXECUTAR MS520DEL?", "MS520DEL")	                                                                                   
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Rotinas Monitoramento                            �
		//�                                                  �
		//� Faz alteracao do status do pedido.               �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If	u_UseTrsf010() .And. !Empty( SC5->C5_PVSTAT )
	
			If	U_TemLiberPv( SC5->C5_NUM ) //-- Retorna se o Pv passou por liberacao na alteracao
	
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//쿒ravacao Status Atual do Pedido de Venda                    �
				//쿑uncao Localizada no JMHA220.PRW                            �
				//쿞tatus 040 = Liberacao Estoque Automatica pelo Comercial    �
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	
				U_A220AtuStat(	SC5->C5_NUM,;
								SC5->C5_CLIENTE,;
								SC5->C5_LOJACLI,;
								SC5->C5_TIPO,;
								SEPARADO)
	
			Else
			
					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
					//쿒ravacao Status Atual do Pedido de Venda                    �
					//쿑uncao Localizada no JMHA220.PRW                            �
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
					U_A220AtuStat(	SC5->C5_NUM,;
									SC5->C5_CLIENTE,;
									SC5->C5_LOJACLI,;
									SC5->C5_TIPO,;
									PEDIDO_INCLUIDO)				//-- Retorna Pedido Incluido
	
			EndIf
	
		EndIf
	
    EndIf

Return()
/*
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
*/
