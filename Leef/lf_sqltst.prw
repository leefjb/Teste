//{IX} ================================================================================
//{IX} 000009 = User Function LfSqlC()
//{IX} 000058 = Static Function SQLqCMP(cAlias)
//{IX} 000070 = Static Function SQLNMCP(cAlias,_aNCampo,_NCmpX3,_NCmpSQ)
//{IX} ================================================================================
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

User Function LfSqlC()
   // Local aAreaX2  := SX2->(GetArea())
   // Local aAreaX3  := SX3->(GetArea())
   Local _cAlias   :="SC6"
   Local _nCamSQL  :=0
   Local _nCamSX3  :=0
   Local _nCMP     :=0
   Local aNCampo   :={}
   Local cArqDes   := "c:\temp\DV_"+cEmpAnt +"_TAB.TXT"
   Local _kk := 0
   nArqDes := FCreate( cArqDes )
   If nArqDes < 1
      MsgAlert("Erro na criação do arquivo de configuração de e-mail!","Atencao!")
      Return
   EndIf
   a_alias:= {"SA1","SA2","SF2","SD2","SF1","SD1","SC0","SC5","SC6","SC7","SZO","SZP"}
   
   For _kk:=1 to len(a_alias)
      aNCampo:={}
      _cAlias:=a_alias[_kk]
      _nCamSQL  :=0
      _nCamSX3  :=0
      DbSelectArea("SX3")
      SX3->(DbSetOrder(1)) //X3_ARQUIVO - Alias
      SX3->(DbGoTop())
      SX3->(dbSeek(_cAlias))
      _nCamSQL:=SQLqCMP(_cAlias)
      DbSelectArea("SX3")
      While !SX3->(Eof()) .and. SX3->X3_ARQUIVO = _cAlias
         if X3_CONTEXT="V"
            SX3->(DbSkip())
            loop
         endif
         _nCamSX3++
         SX3->(Dbskip())
      enddo
      if (_nCamSQL >0) .and. (_nCamSQL <>_nCamSX3)
         SQLNMCP(_cAlias,@aNCampo,_nCamSX3,_nCamSQL)
      endif
      if (_nCamSQL >0) .and. (_nCamSQL <>_nCamSX3)
         fWrite( nArqDes, 'Tabela '+ _cAlias + ' Diferença Campos SX3 ='+str(_nCamSX3,4) + " e SQL ->" + str(_nCamSQL,4) + Chr(13)+ chr(10) )
         for _nCMP := 1 to len(aNCampo)
            fWrite( nArqDes, '      Campo '+ aNCampo[_nCMP] + Chr(13)+ chr(10) )
         Next _nCMP
         aNCampo :={}
      endif
   Next _kk
   fClose( nArqDes )
return


Static Function SQLqCMP(cAlias)
   Local nTabAtual := 0
   Local cQuery    := ""
   cQuery := "SELECT COUNT (*)  AS N_CAMPO FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '" + RetSqlName(cAlias) + "' AND COLUMN_NAME NOT IN ('D_E_L_E_T_', 'R_E_C_N_O_', 'R_E_C_D_E_L_')"
   TcQuery cQuery New Alias "QRY_COM"
   dbSelectArea("QRY_COM")
   QRY_COM->(DbGotop())
   nTabAtual:=QRY_COM->N_CAMPO
   QRY_COM->(DbCloseArea())
Return(nTabAtual)

Static Function SQLNMCP(cAlias,_aNCampo,_NCmpX3,_NCmpSQ)
   Local nTabAtual := 0
   Local cQuery    := ""
   Alert(cAlias + " Difere ")
   cQuery := "SELECT COLUMN_NAME AS NOMECAMPO FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '" + RetSqlName(cAlias) + "' AND COLUMN_NAME NOT IN ('D_E_L_E_T_', 'R_E_C_N_O_', 'R_E_C_D_E_L_')"
   TcQuery cQuery New Alias "QRY_COM"
   dbSelectArea("QRY_COM")
   count to nTabAtual
   if _NCmpSQ >_NCmpX3
      QRY_COM->(DbGotop())
      While !QRY_COM->(Eof())
         SX3->(DbSetOrder(2))
         SX3->(DbGoTop())
         SX3->(dbSeek(ALLTRIM(QRY_COM->NOMECAMPO)))
         IF SX3->(EOF())
            aadd(_aNCampo,"SQL TEM "+ALLTRIM(QRY_COM->NOMECAMPO) + " NA SX3 NAO TEM ")
         ENDIF
         QRY_COM->(Dbskip())
      enddo
   else
      SX3->(DbSetOrder(1)) //X3_ARQUIVO - Alias
      SX3->(DbGoTop())
      SX3->(dbSeek(cAlias))
      While !SX3->(Eof()) .and. SX3->X3_ARQUIVO = cAlias
         if SX3->X3_CONTEXT="V"
            SX3->(DbSkip())
            loop
         endif
         N_CAMPO:=alltrim(SX3->X3_CAMPO)
         NAOTSQL:=.T.
         QRY_COM->(DbGotop())
         While !QRY_COM->(Eof())
            if ALLTRIM(QRY_COM->NOMECAMPO) = N_CAMPO
               NAOTSQL:=.F.
            ENDIF
            QRY_COM->(Dbskip())
         enddo
         IF NAOTSQL
            aadd(_aNCampo,"SX3 TEM "+ N_CAMPO+ " E NAO TEM NO SQL ")
         ENDIF
         SX3->(Dbskip())
      enddo
   endif
   //  Alert("SQL -> nTabAtual = "+str(nTabAtual,4))
   QRY_COM->(DbCloseArea())
Return


