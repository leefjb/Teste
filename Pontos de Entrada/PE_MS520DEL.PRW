//����������������������������������������������������Ŀ
//� Constantes Codigos de Status de Pedidos de Vendas  �
//������������������������������������������������������
                                               
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PE_MS520DEL �Autor  �Manoel M          � Data �  set/2012   ���
�������������������������������������������������������������������������͹��
���Desc.     �exclusao da tabela de pontuacao do SIGACRD                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � faturamento                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MS520DEL()
                                                    
	If .T. // LPARDEL // MsgYesNo("EXECUTAR MS520DEL?", "MS520DEL")	                                                                                   
		//��������������������������������������������������Ŀ
		//� Rotinas Monitoramento                            �
		//�                                                  �
		//� Faz alteracao do status do pedido.               �
		//����������������������������������������������������
		If	u_UseTrsf010() .And. !Empty( SC5->C5_PVSTAT )
	
			If	U_TemLiberPv( SC5->C5_NUM ) //-- Retorna se o Pv passou por liberacao na alteracao
	
				//������������������������������������������������������������Ŀ
				//�Gravacao Status Atual do Pedido de Venda                    �
				//�Funcao Localizada no JMHA220.PRW                            �
				//�Status 040 = Liberacao Estoque Automatica pelo Comercial    �
				//��������������������������������������������������������������
	
				U_A220AtuStat(	SC5->C5_NUM,;
								SC5->C5_CLIENTE,;
								SC5->C5_LOJACLI,;
								SC5->C5_TIPO,;
								SEPARADO)
	
			Else
			
					//������������������������������������������������������������Ŀ
					//�Gravacao Status Atual do Pedido de Venda                    �
					//�Funcao Localizada no JMHA220.PRW                            �
					//��������������������������������������������������������������
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