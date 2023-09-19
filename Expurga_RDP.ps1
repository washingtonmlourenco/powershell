# Seta o diretório de atual para o diretório de downloads!
Set-Location 'C:\Users\washington.lourenco\Downloads'

# Lista todos os arquivos .RDP no diretório de downloads e, subpastas!
Get-ChildItem -Recurse -File -Filter *.rdp

# Remove todos os arquivos com extensão .RDP da pasta de Downloads
Remove-Item -Path *.rdp






