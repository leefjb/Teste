#INCLUDE "PROTHEUS.CH"

// ponto de entrada para dimensionar o tamanho das colunas referente aos produtos da DANFE
// este ponto de entrada nao é padrao Totvs - Foi criado especificamente para o cliente
// qualquer atualização do programa DANFEII.PRW a chamada deste ponto de entrada deve ser refeita no mesmo

User Function DANFETAMCOL()
Local aParam := PARAMIXB

aParam[1] := 70    // coluna COD. PROD
aParam[2] := 172   // coluna DESC. PROD/SERVICO

Return( aParam )
