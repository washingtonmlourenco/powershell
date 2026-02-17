<#
================================================================================
 Script:     top-memory-processes.ps1

 Description:
     Lista os 10 processos que mais consomem memória (Working Set)
     no servidor Windows.

     O script:
         - Obtém todos os processos ativos
         - Ordena pelo consumo de memória (WorkingSet)
         - Converte o valor para MB
         - Retorna apenas os 10 maiores consumidores

     Objetivo:
         - Identificar consumo excessivo de memória
         - Auxiliar troubleshooting de pressão de memória
         - Verificar impacto de processos externos ao SQL Server

 Usage:
     - Executar em PowerShell com permissão adequada
     - Pode ser usado durante incidentes de performance
     - Útil para análise rápida em servidores de banco

 Notes:
     - WorkingSet representa memória física atualmente alocada
     - Pode ser complementado com análise de CPU (Get-Process | Sort CPU)
     - Ideal para ambientes dedicados a SQL Server
================================================================================
#>

Get-Process | Sort-Object -Descending WorkingSet | Select-Object -First 10 Name, @{Name = "WorkingSet (MB)"; Expression = { [math]::round($_.WorkingSet64 / 1MB, 2) } }
