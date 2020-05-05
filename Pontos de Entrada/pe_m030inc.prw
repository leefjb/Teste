#include "protheus.ch"
#define CRLF ( chr(13)+chr(10) )
#include 'tbiconn.ch'
#include "ap5mail.ch"


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M030Inc  �Autor  � Marllon figueiredo � Data �  11/07/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto Entrada com a finalidade de enviar um email a uma    ���
���          � lista de usuarios informando da inclusao de novo cliente   ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function _M030Inc()

	Local aArea    := GetArea()

	// envia email para inclusao de produtos PA
	AvisoMail( {SA1->A1_COD,;
	            SA1->A1_LOJA,;
	            SA1->A1_NOME,;
	            dDataBase} )
	
	RestArea(aArea)
	
Return



/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    � PACP010  � Autor � Marllon Figueiredo    � Data � 19/05/2006 ���
���������������������������������������������������������������������������Ĵ��
���Descricao � Funcao padrao para envio de e-mail (Pactum)                  ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � ESPECIFICO PARA O CLIENTE PACTUM						        ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function AvisoMail( aDados )
Local cServer   := GetMV("MV_RELSERV" )
Local cAccount  := Alltrim(GetMV("MV_RELACNT"))
Local cPassword := Alltrim(GetMV("MV_RELPSW"))
Local lAuth     := GetMV("MV_RELAUTH")
Local cAssunto  := "e-mail autom�tico referente a inclus�o de um novo Cliente (Protheus)"
Local cMensagem := ""
Local cEmailTo  := GetMV("JO_MAILCLI")    // "marllon@microsiga.com.br"
Local cEmailBcc := ""
Local cError    := ""
Local lResult   := .f.
Local cTipo     := Space(0)
Local nStart
Local nn
Local nPos
Local lFechaTb  := .f.


cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
cMensagem += '<html> '
cMensagem += '<head> '
cMensagem += '  <meta content="text/html; charset=ISO-8859-1" http-equiv="content-type"> '
cMensagem += '  <title></title> '
cMensagem += '</head> '
cMensagem += '<body> '
cMensagem += 'Aviso de inclus�o de novo Cliente.<br> '
cMensagem += '<br> '

// processa e-mails de aviso referente a atualizacao de comissoes
// estrutura de aDados
// 1 - Codigo 
// 2 - Loja
// 3 - Nome
// 4 - Data da inclusao

cMensagem += '<table style="text-align: left; width: 100%;" border="1" cellpadding="2" cellspacing="2"> '
cMensagem += '  <tbody> '

cMensagem += '    <tr> '
cMensagem += '      <td '
cMensagem += ' style="width: 60px; background-color: rgb(0, 102, 0); color: rgb(255, 255, 255);">C�digo</td> '
cMensagem += '      <td '
cMensagem += ' style="width: 30px; background-color: rgb(0, 102, 0); color: rgb(255, 255, 255);">Loja</td> '
cMensagem += '      <td '
cMensagem += ' style="width: 360px; background-color: rgb(0, 102, 0); color: rgb(255, 255, 255);">Nome</td> '
cMensagem += '      <td '
cMensagem += ' style="width: 80px; background-color: rgb(0, 102, 0); color: rgb(255, 255, 255);">Data Inclus�o</td> '
cMensagem += '    </tr> '

// monta a pagina
cMensagem += '<tr> '
cMensagem += '<td>'+aDados[1]+'</td> '
cMensagem += '<td>'+aDados[2]+'</td> '
cMensagem += '<td>'+aDados[3]+'</td> '
cMensagem += '<td>'+Dtoc(aDados[4])+'</td> '
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
MemoWrit('avisocli.html', cMensagem)

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
			Alert("Erro de autenticacao de e-mail no PE_M030INC: "+CRLF+cError+CRLF+'O e-mail nao foi enviado.')
			Return Nil
		Endif
	Else
		If !lResult
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			Alert("Erro de autenticacao de e-mail no PE_M030INC: "+CRLF+cError+CRLF+'O e-mail nao foi enviado.')
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
	  		GET MAIL ERROR cError
			//Conout("Erro de autenticacao de e-mail no PE_M030INC: "+cError)
			//Alert("Erro de autenticacao de e-mail no PE_M030INC: "+cError)
			Alert("Erro de autenticacao de e-mail no PE_M030INC: "+CRLF+cError+CRLF+'O e-mail nao foi enviado.')
	  	EndIf
	  	DISCONNECT SMTP SERVER
	EndIf
EndIf

Return(lResult)
