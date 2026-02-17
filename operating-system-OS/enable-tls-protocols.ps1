<#
================================================================================
 Script:     enable-tls-protocols.ps1

 Description:
     Habilita os protocolos TLS 1.0, 1.1 e 1.2 no Windows Server
     via configuração direta no Registro (SCHANNEL).

     O script:
         - Cria as chaves de registro caso não existam
         - Define:
               Enabled = 1
               DisabledByDefault = 0
         - Configura tanto para:
               • Client
               • Server
         - Exibe o status final após a aplicação

 Objetivo:
         - Garantir que os protocolos TLS estejam ativos
         - Corrigir falhas de handshake SSL/TLS
         - Resolver problemas de conexão (SQL Server, APIs, aplicações)

 Caminho alterado:
     HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols

 Requisitos:
     - Executar como Administrador
     - Reiniciar o servidor após execução

 ⚠ Atenção:
     - TLS 1.0 e 1.1 são considerados inseguros e obsoletos
     - Recomenda-se manter apenas TLS 1.2 habilitado em ambientes produtivos
     - Avaliar impacto antes de aplicar em servidores críticos

 Uso recomendado:
     - Troubleshooting de falhas de conexão segura
     - Ajustes pós-atualização de sistema
     - Adequação a requisitos de segurança

================================================================================
#>

$protocols = @("TLS 1.0", "TLS 1.1", "TLS 1.2")
$roles = @("Client", "Server")

Write-Host "====================================="
Write-Host "Habilitando Protocolos TLS via Registro"
Write-Host "====================================="

foreach ($p in $protocols) {
    foreach ($r in $roles) {
        $path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$p\$r"

     
        if (-not (Test-Path $path)) {
            New-Item -Path $path -Force | Out-Null
            Write-Host "Criado: $path"
        }

        New-ItemProperty -Path $path -Name "Enabled" -Value 1 -PropertyType "DWord" -Force | Out-Null
        New-ItemProperty -Path $path -Name "DisabledByDefault" -Value 0 -PropertyType "DWord" -Force | Out-Null
    }
}

Write-Host ""
Write-Host "===== STATUS FINAL ====="

foreach ($p in $protocols) {
    foreach ($r in $roles) {
        $path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$p\$r"
        $props = Get-ItemProperty -Path $path
        Write-Host "$p - $r -> Enabled: $($props.Enabled), DisabledByDefault: $($props.DisabledByDefault)"
    }
}

Write-Host ""
Write-Host "Protocolos TLS configurados com sucesso!"
Write-Host "Reinicie o servidor para aplicar as alterações."

