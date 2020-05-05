#include "rwmake.ch"

//============================================================================//=
//Programa.......: MSD2520//
//Objetivo.......: Ponto de Entrada para Excluir do Cadastro do Faturamento Especial
//               : Ponto de Entrada que passara a etiqueta para "FAT", ou "CON" 
//               : qdo c6_etqprod # "S" dependendo do Tipo do Pedido
//Autor..........: Reiner-SigaPoa
//Data...........: Outubro/2001
//-----------------------------------------------------------------------------
//Autor       |   Data   | Alteracao
//------------|----------|-----------------------------------------------------
User Function MSD2520()

Local aArea     := GetArea() 
Local cSituacao := Space(3)   
Local nRecZ3    := 0
                                                                                 
If SC6->C6_FATESP == "S"
   
   DbSelectArea("SZ2")
   DbSetOrder(2)
   DbSeek(xFilial("SZ2")+SD2->D2_DOC+SD2->D2_SERIE+DTOS(SD2->D2_EMISSAO))
   If !EOF()
		RecLock("SZ2",.F.,.T.)
      	dbDelete()
	 	MsUnlock()
	EndIf	
EndIf       
          
If SC6->C6_ETQPROD # "S" .AND. SC6->C6_ETQPROD # " "             

	DbSelectArea("SZ3")
	DbSetOrder(11)
	DbSeek(xFilial("SZ3")+SC6->C6_NUM+SC6->C6_ITEM)
    Do While Z3_PEDIDOV + Z3_ITEMPV  == SC6->C6_NUM+SC6->C6_ITEM .And. !EOF()
       If Z3_SITUACA == "FAT" .OR. Z3_SITUACA == "CON" .Or. Z3_SITUACA == "DVC" 
          cSituacao := Z3_SITUACA 
          nRecZ3    := RecNo()
          RecLock("SZ3",.F.)
			SZ3->Z3_NFSAIDA := Iif(Z3_SITUACA=="FAT".And.SC6->C6_ETQPROD=="R",Z3_NFSAIDA,Space(6))
			SZ3->Z3_SERISAI := Iif(Z3_SITUACA=="FAT".And.SC6->C6_ETQPROD=="R",Z3_SERISAI,Space(3))
		    SZ3->Z3_DATASAI := Iif(Z3_SITUACA=="FAT".And.SC6->C6_ETQPROD=="R",Z3_DATASAI,CToD("  /  /  "))
		    SZ3->Z3_CLIENTE := Iif(Z3_SITUACA=="FAT".And.SC6->C6_ETQPROD=="R",SC5->C5_CLIVALE,Space(6))
			SZ3->Z3_LOJACLI := Iif(Z3_SITUACA=="FAT".And.SC6->C6_ETQPROD=="R",SC5->C5_LJCVALE,Space(2))
			If Z3_SITUACA=="CON"
	           SZ3->Z3_NFSVAL := Space(6)
			   SZ3->Z3_SERVAL := Space(3)
		       SZ3->Z3_DATVAL := CToD("  /  /  ")
			   SZ3->Z3_CLIVAL := Space(6)
			   SZ3->Z3_LOJVAL := Space(2)
			EndIf
			SZ3->Z3_SITUACA := "RES"
	//		SZ3->Z3_SITUACA := Iif(Z3_SITUACA == "DVC",Iif(SZ3->Z3_ETQL == "S","EST","COM"),"RES")
		  MsUnLock("SZ3") 
		  
		  dbSelectArea("SZ7")
		  dbSetOrder(4)   // criar indice por Filial + Situacao + Etiqueta 
		  DbSeek( xFilial("SZ7")+cSituacao+SZ3->Z3_CODETIQ )
	      If !EOF()
	         Reclock("SZ7" ,.F.)
		  	   dbDelete()
		     MsUnlock()
	      EndIf
		        
		  dbSelectArea("SZ3")
		  dbGoTo(nRecZ3)				
	   EndIf 
	   dbSkip()
	EndDo	
EndIf

// retorna area original
RestArea(aArea)

Return


