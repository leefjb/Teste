#include "rwmake.ch"


// BonFSrv1.PRW
// ßßßßßßßßßßß
// Emite a OS - Ordem de Servico ao Cliente
// 02 de Outubro de 2002
//
// Responsavel: SIGASUL/Reiner Trennepohl

User Function JmhSrv()        

Private cPerg := PadR("JMHSRV",Len(SX1->X1_GRUPO)) // Revisao Migracao MP8/P10 - 01/04/2009 - F.Briddi

Private oFont, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oPrn
Private nLin, nCol, nIncr, nIncrA, cOSI, cOSF
Private cTitulo, cTamanho, cDesc1, cDesc2, cDesc3, aReturn, lBold, lUnderline, cProcedi
Private nLastkey, NomeProg, cString, li, wNRel, nHeight10, nHeight12, nHeight15
Private cCodRep, cLojaRep, cNomeRep, cFoneRep, cEndRep, cCidRep, cUFRep, cDescClas
Private cEndCli, cNomeCli, cCodCli, cLojaCli, cCPFCli, cCidCli, cVendRev, cCidRev
Private cBairCli, cUFCli, cCidCli, cFoneCli, cCelCli, cCEPCli, dDtVenda, dDtInst, dDtGar
Private cCodProd, cNomeProd, cSerProd, cUFRev, cFoneRev, cNomeRev, cNFVenda, cNFAquis 
Private cCodTec, cNomeTec, dDtSoli, cCodProApo, cNomProApo, cCodSrvApo, cNomSrvApo, nQtdApon
Private cItApon, nVlUnitApo, nTotApon, dDtEntApo, dDtGarApo, cMensOb, cMensObs,cSintoma
Private aAponta, cFilAB6, nRecAB6, nRecAB7, cItemOS, cNumCham, cIteCham,cNumOS, cCodPrb
Private cNomePrb, nRecAB8, cSintomas, J, n1, cProcedim, cHrCham, cNTel, cMarcaProd, cDescClas
		
lPerg := ValidPerg(.T.) 

If lPerg
   
  	cTitulo  := "" 	
  	ctamanho := "P"
	cDesc1   := OemToAnsi("")
	Cdesc2   := OemToAnsi("")
	Cdesc3   := OemToAnsi("")
	aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1 }
	aOFCorte := {}
	aMsgPCP  := {}
	nLASTKEY := 0
	nomeprog := "JMHSRV"
	cstring  := "AA3"
	wnrel    := "JMHSRV"
	
	// wnrel:=SetPrint(cString,wnrel,nil,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho)
    
    nHeight10  := 10
    nHeight12  := 12
    nHeight15  := 15
    lBold	   := .F.
    lUnderLine := .F.

	oFont	:= TFont():New( "Arial",,nheight15,,lBold,,,,,lUnderLine )
    oFont2  := TFont():New( "Arial",,nheight15+12,,!lBold,,,,,lUnderLine )
    oFont3  := TFont():New( "Arial",,nheight15+10,,!lBold,,,,,lUnderLine )
    oFont4  := TFont():New( "Arial",,nheight15   ,,!lBold,,,,,lUnderLine ) 
    oFont5  := TFont():New( "Arial",,nheight12   ,,lBold,,,,,lUnderLine )
    oFont6  := TFont():New( "Arial",,nheight10   ,,lBold,,,,,lUnderLine ) 
    oFont7  := TFont():New( "Arial",,nheight10-2 ,,lBold,,,,,lUnderLine )

//oFont2  := TFont():New( "Times New Roman",,nheight15+12,,!lBold,,,,,lUnderLine )
//oFont3  := TFont():New( "Times New Roman",,nheight15+10,,!lBold,,,,,lUnderLine )
//oFont4  := TFont():New( "Times New Roman",,nheight15   ,,!lBold,,,,,lUnderLine ) 
//oFont5  := TFont():New( "Times New Roman",,nheight12   ,,lBold,,,,,lUnderLine )
//oFont6  := TFont():New( "Times New Roman",,nheight10   ,,lBold,,,,,lUnderLine ) 
//oFont7  := TFont():New( "Times New Roman",,nheight10-2 ,,lBold,,,,,lUnderLine )

	oPrn 	:= TMSPrinter():New()
   
   DBSELECTAREA("SB1")		// Cadastro de Tabelas
   DBSETORDER(1)      
   
   DBSELECTAREA("AA5")		// Cadastro de Servicos
   DBSETORDER(1)   
   
   DBSELECTAREA("AA3")		// Cadastro da Base Instalada
   DBSETORDER(1)      
   
   DBSELECTAREA("AA4")		// Cadastro dos Acessorios da Base Instalada
   DBSETORDER(1)
                   
   DBSELECTAREA("AB7")     // Cadastro de Itens da Orden de Servico
   DBSETORDER(1)                   
   
   DBSELECTAREA("AB8")     // Cadastro de Sub - Itens da Orden de Servico
   DBSETORDER(1)      
   
   DBSELECTAREA("AAG")     // Cadastro de Ocorrencias
   DBSETORDER(1)    
    
   DBSELECTAREA("SA1")		// Cadastro de Clientes
   DBSETORDER(1) 
   
//   DBSELECTAREA("SA2")		// Cadastro de Fornecedores
//   DBSETORDER(1)
      
   DBSELECTAREA("SB1")		// Cadastro de Produtos
   DBSETORDER(1)      
   
   DBSELECTAREA("AB6")		// Cadastro de Ordens de Servico
   DBSETORDER(1)
   DbSeek(xfilial("AB6") + cOSI, .T.)   
   cFilAB6 := AB6_FILIAL
   Do While xfilial("AB6") == cFilAB6 .And. AB6_NUMOS <= cOSF .And. !EOF() 
	      
       nRecAB6 := RecNo()
	   cNumOS  := AB6_NUMOS
	   cCodCli := AB6_CODCLI
	   cLojaCli:= AB6_LOJA
	   dDtSoli := AB6_EMISSA 
	   cMensOb := AB6_MSG
	   
	   DBSELECTAREA("SA1")	
	   DBSEEK(xFilial("SA1")+cCodCli+cLojaCli)
	   
	   cNomeCli := A1_NOME
	   cEndCli  := A1_END
	   cBairCli := A1_BAIRRO
	   cUFCli   := A1_EST
	   cCidCli  := A1_MUN 
	   cCEPCli  := A1_CEP
	   cFoneCli := A1_TEL  
	   cCPFCli  := A1_CGC
	//   cCelCli  := A1_
	
	   DBSELECTAREA("AB7")		
	   dbSeek(xfilial("AB7") + cNumOS)
	   Do While xfilial("AB7") == cFilAB6 .And. AB7_NUMOS == cNumOS .And. !EOF()
	     
  	      aAponta := {}		       
	   
	      nRecAB7  := RecNo() 
	      cItemOS  := AB7_ITEM
	      cCodProd := AB7_CODPRO   // SB1
	      cCodPrb  := AB7_CODPRB   // AAG
	      cSerProd := AB7_NUMSER
	      cNumCham := SubStr(AB7_NRCHAM,1,8)
	      cIteCham := SubStr(AB7_NRCHAM,9,2)
	      cSintom  := "VIDEO ESTA COM CHIADO"
	      cProcedi := "TROCAR DIFUSOR DE CANAIS"
  //	      cSintoma := AB7_MEMO2 
  //	      cProcedi := AB7_MEMO4

	      DBSELECTAREA("SB1")
	      dbSeek(xFilial("SB1")+cCodProd)
	      cNomeProd := B1_DESC
	      
	      DBSELECTAREA("AAG")
	      dbSeek(xFilial("AAG")+cCodPrb)
	      cNomePrb := AAG_DESCRI
	      
	      DBSELECTAREA("AB1")
	      dbSeek(xFilial("AB1")+cNumCham)
	      cHrCham := AB1_HORA
	      	     	      
	      DBSELECTAREA("AB2")
	      dbSeek(xFilial("AB2")+cNumCham+cIteCham+cCodProd+cSerProd)
	      cClassif := AB2_CLASSI 
	      
	      DBSELECTAREA("SX5")
          DBSETORDER(1)
          dbSeek(xFilial("SX5")+"A3"+cClassif)
          cDescClas := AllTrim(X5_DESCRI)
	       
	      DBSELECTAREA("AA3")
	      dbSeek(xFilial("AA3")+cCodCli+cLojaCli+cCodProd+cSerProd)
	      cCodRep  := AA3_CODFAB
	      cLojaRep := AA3_LOJAFA  
	      cNFVenda := AA3_NFVEND
	      cNFAquis := AA3_NFAQUI
	      dDtVenda := AA3_DTVEND
	      dDtInst  := AA3_DTINST
	      dDtGar   := AA3_DTGAR 
	      cNomeTec := "Reiner" 
	      cNomeRev := "Reiner"
	      cCidRev  := "PORTO ALEGRE"
	      cUFRev   := "RS"   
          cFoneRev := "30190900"
          cVendRev := "Reiner"
 //	      cNomeTec := AA3_NOMTEC
 //	      cNomeRev := AA3_NOMREV
 //	      cCidRev  := AA3_MUNREV
 //	      cUFRev   := AA3_ESTREV   
 //       cFoneRev := AA3_TELREV
 //       cVendRev := AA3_VENREV
          
          DBSELECTAREA("SX5")
          DBSETORDER(1)
          dbSeek(xFilial("SX5")+"Z2"+SubStr(cCodProd,1,2))
          cMarcaProd := AllTrim(X5_DESCRI)
	      
	      DBSELECTAREA("SA1")
	      dbSeek(xFilial("SA1")+cCodRep+cLojaRep)
   	      cNomeRep := A1_NOME 
	      cFoneRep := A1_TEL 
	      cEndRep  := A1_END
	      cCidRep  := A1_MUN
	      cUFRep   := A1_EST
	      
	      DBSELECTAREA("AB8")
	      dbSeek(xFilial("AB8")+cNumOS+cItemOS)
	      Do While xfilial("AB8") == cFilAB6 .And. AB8_NUMOS+AB8_ITEM == cNumOS+cItemOS .And. !EOF()
             nRecAB8    := RecNo() 
             cItApon    := AB8_ITEM
	         cCodProApo := AB8_CODPRO
	         cNomProApo := AB8_DESPRO
	         cCodSrvApo := AB8_CODSER  // AA5
	         nQtdApon   := AB8_QUANT
             nVlUnitApo := AB8_VUNIT
             nTotApon   := AB8_TOTAL
             dDtEntApo  := AB8_ENTREG
             dDtGarApo  := AB8_DTGAR
             
	         DBSELECTAREA("AA5")
	         dbSeek(xFilial("AA5")+cCodSrvApo)
	         cNomSrvApo  := AA5_DESCRI 
             
             AADD(aAponta,{cItApon,cCodProApo,cNomProApo,cCodSrvApo,cNomSrvApo,nQtdApon,nVlUnitApo,nTotApon,dDtEntApo,dDtGarApo})
             
             DBSELECTAREA("AB8")
             dbGoTo(nRecAB8)
	         dbSkip()
	      EndDo
	      
          Processa( {|| IMP_OS() },"Imprimindo Ordem de Servico ...","Aguarde....." )
          
          DBSELECTAREA("AB7")		// Cadastro de Ordens de Servico
          dbGoTo(nRecAB7)
          dbSkip()
       EndDo
       
       DBSELECTAREA("AB6")		// Cadastro de Ordens de Servico
       dbGoTo(nRecAB6)
       dbSkip()
   EndDo
   
   If aReturn[5] == 1
	  Set Printer To
	  ourspool(wnrel) 
   Endif
	
   MS_FLUSH() //Libera fila de relatorios em spool  
	
EndIf	
	
Return(NIL)

/////////////////
/////////////////////////
////////////////

Static Function IMP_OS()    

   oPrn := TMSPrinter():New()     
//   oPrn:SetPortrait()
   oPrn:StartPage()	// INICIO DE PAGINA     
   
   nLin := 50       // em PIXEL
   nCol := 50
//               + 50                2950
   oPrn:Box( nLin+50, nCol+50, nLin+3000,nCol+2250 )
   
   cBitMap := JMHF060()  //"logo_jomhedica.bmp"
//                      35                 350,250
   oPrn:SayBitmap( nLin+60,nCol+70,cBitMap,250,200 )

   oPrn:Say( nLin+ 70, nCol+ 520, "SERVICO  DE  ATENDIMENTO  AO  CLIENTE", oFont4, 100 )	   
   oPrn:Say( nLin+180, nCol+ 450, "ORDEM DE SERVICO",                      oFont4, 100 )
   oPrn:Say( nLin+180, nCol+1120, cNumOS+" - "+cItemOS,                    oFont4, 100 )	   
   oPrn:Say( nLin+180, nCol+1620, cNTel,                                   oFont4, 100 )
 	
   nIncr := 200
 	
   oPrn:Line( nLin+nIncr+70, nCol+50, nLin+nIncr+70,nCol+2250 )    // Linha
 	
   nIncr += 80
 	
    // DADOS SOBRE O REPERSENTANTE
   oPrn:Say( nLin + nIncr,       nCol + 100, "Autorizada",                oFont4, 100 )
   oPrn:Say( nLin + nIncr +  70, nCol + 100, "Razao Social .: "+cNomeRep, oFont5, 100 )
   oPrn:Say( nLin + nIncr +  70, nCol +1370, "Telefone .: "+cFoneRep,     oFont5, 100 )
   oPrn:Say( nLin + nIncr + 120, nCol + 100, "Endereco .: "+cEndRep,      oFont5, 100 )
   oPrn:Say( nLin + nIncr + 120, nCol +1370, "Cidade .: "+cCidRep,        oFont5, 100 )
   oPrn:Say( nLin + nIncr + 120, nCol +1980, "Estado .: "+cUFRep,         oFont5, 100 )
   
   nIncr += 120
   
   oPrn:Line( nLin+nIncr+50, nCol+50, nLin+nIncr+50,nCol+2250 )    // Linha
   
   nIncr += 60
                                             
   // DADOS SOBRE O CLIENTE
   oPrn:Say( nLin + nIncr,       nCol + 100, "Dados do Cliente",          oFont4, 100 )
   oPrn:Say( nLin + nIncr +  70, nCol + 100, "Nome .: "+cNomeCli,         oFont5, 100 )
   oPrn:Say( nLin + nIncr +  70, nCol +1630, "C P F .: "+cCPFCli,         oFont5, 100 )
   oPrn:Say( nLin + nIncr + 120, nCol + 100, "Endereco .: "+cEndCli,      oFont5, 100 )
   oPrn:Say( nLin + nIncr + 120, nCol +1630, "Fone/Celular .: "+cFoneCli, oFont5, 100 )
   oPrn:Say( nLin + nIncr + 170, nCol + 100, "Cidade .: "+cCidCli,        oFont5, 100 )
   oPrn:Say( nLin + nIncr + 170, nCol + 700, "Bairro .: "+cBairCli,       oFont5, 100 )
   oPrn:Say( nLin + nIncr + 170, nCol +1630, "C E P .: "+cCEPCli,         oFont5, 100 )
   oPrn:Say( nLin + nIncr + 170, nCol +1980, "Estado .: "+cUFCli,         oFont5, 100 )
   
   nIncr += 170
   
   oPrn:Line( nLin+nIncr+50, nCol+50, nLin+nIncr+50,nCol+2250 )    // Linha
   
   nIncr += 60
   
   // DADOS SOBRE O PRODUTO
   oPrn:Say( nLin + nIncr,       nCol + 100, "Dados do Produto",                  oFont4, 100 )
   oPrn:Say( nLin + nIncr +  70, nCol + 100, "Item",                              oFont4, 100 )
   oPrn:Say( nLin + nIncr +  70, nCol + 250, "Produto",                           oFont4, 100 )
   oPrn:Say( nLin + nIncr +  70, nCol + 560, "Descricao",                         oFont4, 100 )
   oPrn:Say( nLin + nIncr +  70, nCol +1740, "Marca",                             oFont4, 100 )
   oPrn:Say( nLin + nIncr + 120, nCol + 110, cItemOS,                             oFont5, 100 )
   oPrn:Say( nLin + nIncr + 120, nCol + 250, cCodProd,                            oFont5, 100 )
   oPrn:Say( nLin + nIncr + 120, nCol + 560, cNomeProd,                           oFont5, 100 ) 
   oPrn:Say( nLin + nIncr + 120, nCol +1740, cMarcaProd,                          oFont5, 100 )    
   oPrn:Say( nLin + nIncr + 190, nCol + 100, "Revenda .: "+cNomeRev,              oFont5, 100 )
   oPrn:Say( nLin + nIncr + 190, nCol +1250, "Vendedor.: "+cVendRev,              oFont5, 100 )   
   oPrn:Say( nLin + nIncr + 240, nCol + 100, "Tel .: "+cFoneRev,                  oFont5, 100 )
   oPrn:Say( nLin + nIncr + 240, nCol + 560, "Cid .: "+cCidRev,                   oFont5, 100 )
   oPrn:Say( nLin + nIncr + 240, nCol +1250, "Estado .: "+cUFRev,                    oFont5, 100 )
   oPrn:Say( nLin + nIncr + 240, nCol +1740, "Data Garantia .: "+DToC(dDtGar),    oFont5, 100 )
   oPrn:Say( nLin + nIncr + 290, nCol + 100, "Data Venda .: "+DToC(dDtVenda),     oFont5, 100 )
   oPrn:Say( nLin + nIncr + 290, nCol + 560, "Data Instalacao .: "+DToC(dDtInst), oFont5, 100 )
   oPrn:Say( nLin + nIncr + 290, nCol +1250, "N.F. Venda .: "+cNFVenda,           oFont5, 100 ) 
   oPrn:Say( nLin + nIncr + 290, nCol +1740, "N.F. Aquisicao .: "+cNFAquis,       oFont5, 100 ) 

   nIncr += 290
   
   oPrn:Line( nLin+nIncr+50, nCol+50, nLin+nIncr+50,nCol+2250 )    // Linha
   
   nIncr += 60
   
   // DADOS SOBRE O SERVICO TECNICO
   oPrn:Say( nLin + nIncr,       nCol+100,  "Servico Tecnico",               oFont4, 100 )
   oPrn:Say( nLin + nIncr +  70, nCol+100,  "Tecnico .: "+cNomeTec,          oFont5, 100 )
   oPrn:Say( nLin + nIncr +  70, nCol+1250, "Solicitacao .: "+DToC(dDtSoli), oFont5, 100 ) 
   oPrn:Say( nLin + nIncr +  70, nCol+1740, "Hr. Chamada .: "+cHrCham,       oFont5, 100 ) 
   oPrn:Say( nLin + nIncr + 120, nCol+ 100, "Clas. Servico .: "+cDescClas,    oFont5, 100 )
   oPrn:Say( nLin + nIncr + 120, nCol+1250, "Ocorrencia .: "+cNomePrb,       oFont5, 100 )
   
   nIncr += 120
   
   oPrn:Line( nLin+nIncr+50, nCol+50, nLin+nIncr+50,nCol+2250 )    // Linha
   
   nIncr += 60
	
   oPrn:Say( nLin + nIncr, nCol + 100, "Sintomas",   oFont4, 100 ) 
//   oPrn:Say( nLin + nIncr+50, nCol + 100, MemoLine(cSintoma,110,1,1,.T.),  oFont6, 100 )
   nIncr += 50
   n1 := 2
   j  := 0
   /*
   Do While .t.
	  cSintomas := Memoline(cSintoma,110,n1,1,.T.)
	  If empty(cSintomas)
 		 Exit                                  
	  EndIf  
	  nIncr += 50
	  oPrn:Say( nLin + nIncr, nCol + 100, LTrim(cSintomas),  oFont6, 100 )
	  J  := J + 1
	  n1 := n1 + 1
	  If J == 4 .Or. empty(Memoline(cSintoma,110,n1,1,.T.))
	 	 Exit
	  EndIf
  EndDo
  */
  If J < 5
     J := 5 - J
  Else
     J := 1   
  EndIf   
     
  nIncr += (50 * J) 
	
  oPrn:Line( nLin+nIncr+50, nCol+50, nLin+nIncr+50,nCol+2250 )    // Linha
   
   nIncr += 60
	
   oPrn:Say( nLin + nIncr, nCol + 100, "Procedimentos",   oFont4, 100 )
//   oPrn:Say( nLin + nIncr+50, nCol + 100, MemoLine(cProcedi,110,1,1,.T.),  oFont6, 100 )
   nIncr += 50
   J  := 0
   n1 := 2 
   /*
   Do While .t.
	  cProcedim := Memoline(cProcedi,110,n1,1,.T.)
	  If empty(cProcedim)
 		 Exit                                  
	  EndIf  
	  nIncr += 50
	  oPrn:Say( nLin + nIncr, nCol + 100, LTrim(cProcedim),  oFont6, 100 )
	  J  := J + 1
	  n1 := n1 + 1
	  If J == 4 .Or. empty( Memoline(cProcedi,110,n1,1,.T.) )
	 	 Exit
	  EndIf
  EndDo
  */
  
  If J < 4
     J := 4 - J
  Else
     J := 1   
  EndIf   
     
  nIncr += (50 * J)  
 
  oPrn:Line( nLin+nIncr+50, nCol+50, nLin+nIncr+50,nCol+2250 )    // Linha
   
  nIncr += 60
   
  oPrn:Say( nLin + nIncr, nCol +100, "Solicitacao de Pecas",   oFont4, 100 ) 
  oPrn:Say( nLin + nIncr+70, nCol +  95, "Qtd",                oFont5, 100 )  
  oPrn:Say( nLin + nIncr+70, nCol + 180, "Codigo",             oFont5, 100 )
  oPrn:Say( nLin + nIncr+70, nCol + 450, "Produto",            oFont5, 100 )  
  oPrn:Say( nLin + nIncr+70, nCol + 980, "Servico",            oFont5, 100 )
  oPrn:Say( nLin + nIncr+70, nCol +1735, "Valor",              oFont5, 100 )
  oPrn:Say( nLin + nIncr+70, nCol +2035, "Total",              oFont5, 100 )
  
  nIncr += 120
  
  For J := 1 To Len(aAponta)
  
      oPrn:Say( nLin + nIncr, nCol + 100, StrZero(aAponta[J][6],3), oFont6, 100 )
      oPrn:Say( nLin + nIncr, nCol + 180, aAponta[J][2],            oFont6, 100 )
      oPrn:Say( nLin + nIncr, nCol + 450, aAponta[J][3],            oFont7, 100 )
      oPrn:Say( nLin + nIncr, nCol + 980, aAponta[J][5],            oFont6, 100 ) 
      oPrn:Say( nLin + nIncr, nCol +1700, Str(aAponta[J][7],12,2),  oFont6, 100 )
      oPrn:Say( nLin + nIncr, nCol +2000, Str(aAponta[J][8],12,2),  oFont6, 100 )
      nIncr += 35
  Next

 If J < 10
     J := 10 - J
  Else
     J := 1   
  EndIf   
     
  nIncr += (50 * J) + (15 * J)
 
  oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
   
  nIncr += 30    
   
  oPrn:Say( nLin + nIncr, nCol + 100, "Observacao",   oFont4, 100 )
///////////
   oPrn:Say( nLin + nIncr+50, nCol + 100, MemoLine(cMensOb,120,1,1,.T.),  oFont6, 100 )
   nIncr += 50
   n1 := 2
   j  := 1
   Do While .t.
	  cMensObs := Memoline(cMensOb,120,n1,1,.T.)
	  If empty(cMensObs)
 		 Exit                                  
	  EndIf  
	  nIncr += 50
	  oPrn:Say( nLin + nIncr, nCol + 100, LTrim(cMensObs),  oFont6, 100 )
	  J  := J + 1
	  n1 := n1 + 1
	  If J == 3 .Or. empty(Memoline(cMensOb,120,n1,1,.T.))
	 	 Exit
	  EndIf
  EndDo
  
  If J < 3
     J := 3 - J
  Else
     J := 1   
  EndIf   
     
  nIncr += (50 * J) 	
  
  oPrn:Line( nLin+nIncr, nCol+50, nLin+nIncr,nCol+2250 )    // Linha
////////////////
		
//  nIncr += 150	 
   
//  oPrn:Line( nLin+nIncr+50, nCol+50, nLin+nIncr+50,nCol+2250 )    // Linha
   
  nIncr += 120	
   
  oPrn:Line( nLin+nIncr, nCol+300, nLin+nIncr,nCol+1000 )    // Linha
  oPrn:Line( nLin+nIncr, nCol+1400, nLin+nIncr,nCol+2050 )    // Linha
   
  nIncr += 10    
   
  oPrn:Say( nLin + nIncr, nCol + 460, "Assinatura do Tecnico",   oFont6, 100 )
  oPrn:Say( nLin + nIncr, nCol +1560, "Assinatura do Cliente",   oFont6, 100 )
   
  oPrn:EndPage()  // FECHAMENTO DA PAGINA 
         
  oPrn:Preview()
//  oPrn:Print()
	   
Return
      
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  26/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(lOK)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j
Local lRet := .F.

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)

//          Grupo/Ordem/Pergunta/            Variavel/Tipo/Tam/Dec/Pres/GSC/ Valid/       Var01/     Def01___/ Cnt01/Var02/Def02___/ Cnt02/Var03/Def03___/ Cnt03/Var04/Def04___/ Cnt04/ Var05/Def05___/ Cnt05/F3
aAdd(aRegs,{cPerg,"01","Da O.S.",      "","","mv_ch1","C", 06,  0, 0,  "G", "",          "MV_PAR01", "","","", "",   "",   "","","", "",   "",   "","","", "",   "",   "","","", "",    "",   "","","", "",  "AB6"})
aAdd(aRegs,{cPerg,"02","Ate a O.S.",   "","","mv_ch2","C", 06,  0, 0,  "G", "",          "MV_PAR02", "","","", "",   "",   "","","", "",   "",   "","","", "",   "",   "","","", "",    "",   "","","", "",  "AB6"})
aAdd(aRegs,{cPerg,"03","Telefone SAC", "","","mv_ch3","C", 15,  0, 0,  "G", "",          "MV_PAR03", "","","", "",   "",   "","","", "",   "",   "","","", "",   "",   "","","", "",    "",   "","","", "",  ""   })

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

lret := Pergunte(cPerg,.T.)

	cOSI := MV_PAR01
	cOSF := MV_PAR02
	cNTel:= MV_PAR03

dbSelectArea(_sAlias)

Return(lRet)
