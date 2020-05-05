#INCLUDE 'RWMAKE.CH'

User Function JOMG100()

Local cRet := ''
Local cCod := ''
Local cLinhaDig := Alltrim(M->E2_LINHAD)

cCod := Substr(cLinhaDig,1,4) + Substr(cLinhaDig,33,1) + Right(cLinhaDig,14) + Substr(cLinhaDig,5,5) + Substr(cLinhaDig,11,10) + ;
        Substr(cLinhaDig,22,10)// + Substr(cLinhaDig,28,9)

cRet := Alltrim( cCod )

Return(cRet)