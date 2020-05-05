#include "protheus.ch"
#INCLUDE "ACDV180.ch" 
#include "apvt100.ch"
       
/*/{Protheus.doc} xACDV180
//Customizando rotina ACD180 - recebimento mensagens - tarefas
@author Celso Rene
@since 14/02/2019
@version 1.0
@type function
/*/
User Function xACDV180()

Local aTela			:= VtSave()
Local aFields 		:= {"CBF_DATA","CBF_XPED","CBF_XCLI","CBF_MSG","CBF_DE","CBF_DATA","CBF_HORA","CBF_STATUS"}
Local aSize   		:= {5,6,6,20,6,8,5,6} //{6,8,8,8,20,20,12}
Local aHeader 		:= {"Data","P.V.","Cliente","Mensag.","De","Data","Hora","Status"} //"De"###"Data"###"Hora"###"Assunto"###"Rotina"###"Pendencia"
Local cCodOpe 		:= CBRetOpe()
Local cTop,cBottom
Local nRecno   
Local cRotMsg		:= ""

CBF->(dbSetOrder(3))
If CBF->(dbSeek(xFilial("CBF")+cCodOpe))
	
	nRecno := CBF->(Recno())
	ctop := "xfilial('CBF')+CB1->CB1_CODOPE"
	cBottom := "xfilial('CBF')+CB1->CB1_CODOPE"
	
	
	While .T.
		
		VtClear()
		
		If VTModelo() == "RF"
			@ 0,0 VTSay STR0001 //"Recebidas"
			nRecno := VTDBBrowse(1,0,VTMaxRow(),VTMaxCol(),"CBF",aHeader,aFields,aSize,,cTop,cBottom)
		Else
			nRecno := VTDBBrowse(0,0,VTMaxRow(),VTMaxCol(),"CBF",aHeader,aFields,aSize,,cTop,cBottom)
		EndIf
		
		If VtLastkey() == 27
			Exit
		EndIf
		
		CBF->(RecLock("CBF"))
		CBF->CBF_STATUS:= '2'
		CBF->(MsUnlock())
		VtAlert(CBF->CBF_MSG,STR0006+CBF->CBF_DE,.T.) //"DE:"    
		
		If (! Empty(CBF->CBF_ROTINA) ) //.AND. VtYesNo(STR0009,STR0010,.t.) )  //###"Deseja executar a tarefa agora?"###"Mensagem
		 
			If ! Empty(CBF->CBF_KEYB)
				VTKeyBoard(Alltrim(CBF->CBF_KEYB))
			EndIf 
			
			cRotMsg := Alltrim(CBF->CBF_ROTINA) 
			cRotMsg += If(Empty(at("(",cRotMsg)),"()","")
			VTAtuSem("SIGAACD",cRotMsg+" - ["+Alltrim(CBF->CBF_MSG)+']') //##"SIGAACD"
		
			If !(FindFunction(Alltrim(cRotMsg)))
			     VTAlert(STR0011+cRotMsG+STR0012,STR0013,.t.,4000) //##"Função"##" Não existe! Verifique o Controle de Tarefas"##"Atencao"
			     Exit
			Else     
				&(Alltrim(cRotMsg))                                             
			EndIf
		
			VTAtuSem("SIGAACD","")   
			CBF->(RecLock("CBF"))
			CBF->CBF_PENDEN:= ' '
			CBF->(MsUnlock())    
			

			Return() //forcando saida apos rotina separacao
				
		EndIf
		
	End
	
EndIf


VTRestore(,,,,aTela)


Return()
