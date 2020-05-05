#include "protheus.ch"
#define CRLF ( chr(13)+chr(10) )
#include 'tbiconn.ch'
#include "ap5mail.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT010INC ºAutor  ³ Marllon figueiredo º Data ³  11/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto Entrada com a finalidade de enviar um email a uma    º±±
±±º          ³ lista de usuarios informando da inclusao de um produto.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function _MT010INC( lFlag )

	Local aArea    := GetArea()
	
	Default lFlag  := .t.     // INCLUSAO

	// envia email para inclusao de produtos PA
	If SB1->B1_TIPO = 'PA'
		If lFlag
			AvisoMail( .t., {SB1->B1_COD,;
			                 SB1->B1_DESC,;
			                 SB1->B1_GRUPO,;
			                 dDataBase,;
			                 SB1->B1_LOCPAD,;
			                 SB1->B1_TIPO} )
    	Else
			AvisoMail( .f., VAR_IXB )
    	EndIf
	EndIf
	
	RestArea(aArea)
	
Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PACP010  ³ Autor ³ Marllon Figueiredo    ³ Data ³ 19/05/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao padrao para envio de e-mail (Pactum)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO PARA O CLIENTE PACTUM						        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AvisoMail( lFlag, aDados )
Local cServer   := GetMV("MV_RELSERV" )
Local cAccount  := Alltrim(GetMV("MV_RELACNT"))
Local cPassword := Alltrim(GetMV("MV_RELPSW"))
Local lAuth     := GetMV("MV_RELAUTH")
Local cAssunto  := "e-mail automático referente a inclusão de um novo Produto (Protheus)"
Local cMensagem := ""
Local cEmailTo  := GetMV("JO_MAILPRO")    // "marllon@microsiga.com.br"
Local cEmailBcc := ""
Local cError    := ""
Local lResult   := .f.
Local cTipo     := Space(0)
Local nStart
Local nn
Local nPos
Local lFechaTb    := .f.
Private lMsgError := .f.

If ! lFlag
	cAssunto  := "e-mail automático referente a exclusão de Produto (Protheus)"
EndIf

cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
cMensagem += '<html> '
cMensagem += '<head> '
cMensagem += '  <meta content="text/html; charset=ISO-8859-1" http-equiv="content-type"> '
cMensagem += '  <title></title> '
cMensagem += '</head> '
cMensagem += '<body> '
If lFlag
	cMensagem += 'Aviso de inclusão de novo Produto.<br> '
Else
	cMensagem += 'Aviso de exclusão de Produto.<br> '
EndIf
cMensagem += '<br> '

// processa e-mails de aviso referente a atualizacao de comissoes
// estrutura de aDados
// 1 - Codigo 
// 2 - Descricao produto
// 3 - Grupo
// 4 - Data da inclusao
// 5 - Familia

cMensagem += '<table style="text-align: left; width: 100%;" border="1" cellpadding="2" cellspacing="2"> '
cMensagem += '  <tbody> '

cMensagem += '    <tr> '
cMensagem += '      <td '
cMensagem += ' style="width: 84px; background-color: rgb(0, 102, 0); color: rgb(255, 255, 255);">Código</td> '
cMensagem += '      <td '
cMensagem += ' style="width: 360px; background-color: rgb(0, 102, 0); color: rgb(255, 255, 255);">Descrição</td> '
cMensagem += '      <td '
cMensagem += ' style="width: 60px; background-color: rgb(0, 102, 0); color: rgb(255, 255, 255);">Grupo</td> '
cMensagem += '      <td '
cMensagem += ' style="width: 80px; background-color: rgb(0, 102, 0); color: rgb(255, 255, 255);">Data Exclusão</td> '
cMensagem += '      <td '
cMensagem += ' style="width: 50px; background-color: rgb(0, 102, 0); color: rgb(255, 255, 255);">Local</td> '
cMensagem += '      <td '
cMensagem += ' style="width: 50px; background-color: rgb(0, 102, 0); color: rgb(255, 255, 255);">Tipo</td> '
cMensagem += '    </tr> '

// monta a pagina
cMensagem += '<tr> '
cMensagem += '<td>'+aDados[1]+'</td> '
cMensagem += '<td>'+aDados[2]+'</td> '
cMensagem += '<td>'+aDados[3]+'</td> '
cMensagem += '<td>'+Dtoc(aDados[4])+'</td> '
cMensagem += '<td>'+aDados[5]+'&nbsp;</td> '
cMensagem += '<td>'+aDados[6]+'&nbsp;</td> '
cMensagem += '</tr> '

cMensagem += '  </tbody> '
cMensagem += '</table> '
cMensagem += '<br> '
cMensagem += '<br> '
cMensagem += '<br> '
cMensagem += '<table style="text-align: left; width: 968px; height: 44px;" border="0" cellpadding="2" cellspacing="2"> '
cMensagem += '  <tbody> '
cMensagem += '    <tr> '
cMensagem += '      <td>e-mail gerado automaticamente pela ferramenta de e-mail do Protheus8.</td> '
cMensagem += '    </tr> '
cMensagem += '  </tbody> '
cMensagem += '</table> '
cMensagem += '</body> '
cMensagem += '</html> '


// salva a pagina HTML
MemoWrit('avisocom.html', cMensagem)

// somente envia e-mail se tiver alguma informacao a ser enviada
If Len( aDados ) > 0
	// conectando-se com o servidor de e-mail
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult
	
	// fazendo autenticacao 
	If lResult .And. lAuth
		lResult := MailAuth(cAccount, cPassword)
		If !lResult
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			Alert("Erro de autenticacao de e-mail no PE_MT010INC: "+CRLF+cError+CRLF+'O e-mail nao foi enviado.')
			Return Nil
		Endif
	Else
		If !lResult
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			Alert("Erro de autenticacao de e-mail no PE_MT010INC: "+CRLF+cError+CRLF+'O e-mail nao foi enviado.')
			Return Nil
		Endif
	EndIf
	
	// enviando e-mail
	If lResult
	  	SEND MAIL FROM cAccount ;
	  	          TO cEmailTo;
	  	          BCC cEmailBcc;
	  	          SUBJECT cAssunto;
	  	          BODY cMensagem;
		          RESULT lResult
		
	  	If !lResult
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			Alert("Erro de autenticacao de e-mail no PE_MT010INC: "+CRLF+cError+CRLF+'O e-mail nao foi enviado.')
	  	EndIf
	  	DISCONNECT SMTP SERVER
	EndIf
EndIf

Return(lResult)
