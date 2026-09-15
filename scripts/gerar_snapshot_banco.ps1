# ============================================================
# SalesIn
# Gerador de Snapshot do Banco SQL Server
#
# Objetivo:
# Gerar um arquivo .sql contendo a estrutura atual do banco
# SalesIn sem exportar os dados.
#
# Servidor:
# localhost\SQLEXPRESS
#
# Banco:
# SalesIn
#
# Projeto:
# C:\SalesIn
# ============================================================

$ErrorActionPreference = "Stop"


# ============================================================
# CONFIGURAÇÕES
# ============================================================

$ServerName = "localhost\SQLEXPRESS"
$DatabaseName = "SalesIn"

$ProjectPath = "C:\SalesIn"

$ScriptsDirectory = Join-Path `
    $ProjectPath `
    "scripts"

$OutputDirectory = Join-Path `
    $ProjectPath `
    "sql\00_snapshot_inicial"

$OutputFile = Join-Path `
    $OutputDirectory `
    "00_salesin_snapshot_inicial.sql"


# ============================================================
# CABEÇALHO
# ============================================================

Clear-Host

Write-Host ""
Write-Host "============================================================"
Write-Host "SalesIn - Gerador de Snapshot SQL Server"
Write-Host "============================================================"
Write-Host ""

Write-Host "[INFO] Servidor:"
Write-Host "       $ServerName"
Write-Host ""

Write-Host "[INFO] Banco:"
Write-Host "       $DatabaseName"
Write-Host ""

Write-Host "[INFO] Projeto:"
Write-Host "       $ProjectPath"
Write-Host ""

Write-Host "[INFO] Arquivo de saída:"
Write-Host "       $OutputFile"
Write-Host ""


# ============================================================
# CRIA ESTRUTURA DE PASTAS
# ============================================================

Write-Host "[INFO] Validando estrutura de pastas..."
Write-Host ""

if (-not (Test-Path $ProjectPath)) {

    Write-Host "[CRIANDO] $ProjectPath"

    New-Item `
        -ItemType Directory `
        -Path $ProjectPath `
        -Force | Out-Null
}

if (-not (Test-Path $ScriptsDirectory)) {

    Write-Host "[CRIANDO] $ScriptsDirectory"

    New-Item `
        -ItemType Directory `
        -Path $ScriptsDirectory `
        -Force | Out-Null
}

if (-not (Test-Path $OutputDirectory)) {

    Write-Host "[CRIANDO] $OutputDirectory"

    New-Item `
        -ItemType Directory `
        -Path $OutputDirectory `
        -Force | Out-Null
}

Write-Host "[OK] Estrutura de pastas validada."
Write-Host ""


# ============================================================
# CARREGA MÓDULO SQL SERVER
# ============================================================

Write-Host "[INFO] Carregando módulo SqlServer..."
Write-Host ""

try {

    Import-Module SqlServer `
        -Force `
        -ErrorAction Stop

    Write-Host "[OK] Módulo SqlServer carregado com sucesso."
}
catch {

    Write-Host ""
    Write-Host "============================================================"
    Write-Host "[ERRO] Módulo SqlServer não disponível"
    Write-Host "============================================================"
    Write-Host ""

    Write-Host "Execute este comando no PowerShell:"
    Write-Host ""

    Write-Host "Install-Module SqlServer -Scope CurrentUser -Force -AllowClobber"
    Write-Host ""

    Write-Host "Mensagem técnica:"
    Write-Host $_.Exception.Message

    Write-Host ""

    exit 1
}

Write-Host ""


# ============================================================
# CONEXÃO COM SQL SERVER
# ============================================================

Write-Host "[INFO] Conectando ao SQL Server..."
Write-Host ""

try {

    $Server = New-Object `
        Microsoft.SqlServer.Management.Smo.Server `
        $ServerName

    # Força tentativa real de conexão
    $ServerVersion = $Server.ConnectionContext.ServerVersion

    Write-Host "[OK] Conexão estabelecida."
    Write-Host "[INFO] Versão SQL Server: $ServerVersion"
}
catch {

    Write-Host ""
    Write-Host "============================================================"
    Write-Host "[ERRO] Falha na conexão com SQL Server"
    Write-Host "============================================================"
    Write-Host ""

    Write-Host "Servidor tentado:"
    Write-Host "$ServerName"
    Write-Host ""

    Write-Host "Mensagem:"
    Write-Host $_.Exception.Message
    Write-Host ""

    exit 1
}

Write-Host ""


# ============================================================
# LOCALIZA BANCO
# ============================================================

Write-Host "[INFO] Localizando banco '$DatabaseName'..."
Write-Host ""

try {

    $Database = $Server.Databases[$DatabaseName]

}
catch {

    Write-Host "[ERRO] Não foi possível consultar os bancos."
    Write-Host $_.Exception.Message
    exit 1
}


if ($null -eq $Database) {

    Write-Host ""
    Write-Host "============================================================"
    Write-Host "[ERRO] Banco não encontrado"
    Write-Host "============================================================"
    Write-Host ""

    Write-Host "Banco:"
    Write-Host "$DatabaseName"
    Write-Host ""

    Write-Host "Servidor:"
    Write-Host "$ServerName"
    Write-Host ""

    exit 1
}


Write-Host "[OK] Banco '$DatabaseName' localizado."
Write-Host ""


# ============================================================
# IDENTIFICA TABELAS E VIEWS
# ============================================================

Write-Host "[INFO] Lendo objetos do banco..."
Write-Host ""

$UserTables = @(
    $Database.Tables |
    Where-Object {
        $_.IsSystemObject -eq $false
    }
)

$UserViews = @(
    $Database.Views |
    Where-Object {
        $_.IsSystemObject -eq $false
    }
)

$StoredProcedures = @(
    $Database.StoredProcedures |
    Where-Object {
        $_.IsSystemObject -eq $false
    }
)

$Functions = @(
    $Database.UserDefinedFunctions |
    Where-Object {
        $_.IsSystemObject -eq $false
    }
)


Write-Host "[OK] Objetos encontrados:"
Write-Host ""

Write-Host "     Tabelas ............. $($UserTables.Count)"
Write-Host "     Views ............... $($UserViews.Count)"
Write-Host "     Procedures .......... $($StoredProcedures.Count)"
Write-Host "     Funções ............. $($Functions.Count)"

Write-Host ""


# ============================================================
# CONFIGURA TRANSFERÊNCIA
# ============================================================

Write-Host "[INFO] Preparando geração do snapshot..."
Write-Host ""

try {

    $Transfer = New-Object `
        Microsoft.SqlServer.Management.Smo.Transfer `
        $Database

}
catch {

    Write-Host "[ERRO] Não foi possível inicializar o objeto Transfer."
    Write-Host $_.Exception.Message
    exit 1
}


# ============================================================
# OBJETOS PARA SCRIPT
# ============================================================

$Transfer.CopyAllObjects = $false

$Transfer.CopyAllTables = $true
$Transfer.CopyAllViews = $true

$Transfer.CopyAllStoredProcedures = $true
$Transfer.CopyAllUserDefinedFunctions = $true

$Transfer.CopyAllDefaults = $true
$Transfer.CopyAllRules = $true
$Transfer.CopyAllUserDefinedDataTypes = $true


# ============================================================
# OPÇÕES DE SCRIPT
# ============================================================

# ------------------------------------------------------------
# SOMENTE ESTRUTURA
# ------------------------------------------------------------

$Transfer.Options.ScriptSchema = $true
$Transfer.Options.ScriptData = $false


# ------------------------------------------------------------
# CHAVES / RELACIONAMENTOS / CONSTRAINTS
# ------------------------------------------------------------

$Transfer.Options.DriAll = $true

$Transfer.Options.DriPrimaryKey = $true
$Transfer.Options.DriForeignKeys = $true
$Transfer.Options.DriUniqueKeys = $true

$Transfer.Options.DriChecks = $true
$Transfer.Options.DriDefaults = $true


# ------------------------------------------------------------
# ÍNDICES
# ------------------------------------------------------------

$Transfer.Options.Indexes = $true

$Transfer.Options.ClusteredIndexes = $true
$Transfer.Options.NonClusteredIndexes = $true


# ------------------------------------------------------------
# OUTROS OBJETOS
# ------------------------------------------------------------

$Transfer.Options.Triggers = $true

$Transfer.Options.SchemaQualify = $true

$Transfer.Options.IncludeHeaders = $true

$Transfer.Options.IncludeDatabaseContext = $false

$Transfer.Options.NoCommandTerminator = $false

$Transfer.Options.ScriptBatchTerminator = $false


Write-Host "[OK] Configuração do snapshot concluída."
Write-Host ""


# ============================================================
# CABEÇALHO DO ARQUIVO SQL
# ============================================================

$DataGeracao = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$Header = @"
-- ============================================================
-- SALESIN
-- SNAPSHOT INICIAL DO BANCO DE DADOS
-- ============================================================
--
-- Projeto:
-- SalesIn - Inteligência Comercial 360
--
-- Servidor de origem:
-- $ServerName
--
-- Banco:
-- $DatabaseName
--
-- Data de geração:
-- $DataGeracao
--
-- IMPORTANTE:
--
-- Este arquivo contém SOMENTE A ESTRUTURA do banco.
--
-- Não contém dados de clientes.
-- Não contém dados de vendas.
-- Não contém dados de usuários.
-- Não contém dados comerciais.
--
-- Objetivo:
--
-- Registrar no GitHub a estrutura inicial do banco SalesIn.
--
-- ============================================================

USE [$DatabaseName];
GO

"@


# ============================================================
# GERA SCRIPT
# ============================================================

Write-Host "============================================================"
Write-Host "GERANDO SNAPSHOT"
Write-Host "============================================================"
Write-Host ""

Write-Host "[PROCESSANDO] Aguarde..."
Write-Host ""

try {

    $ScriptCollection = $Transfer.ScriptTransfer()

}
catch {

    Write-Host ""
    Write-Host "============================================================"
    Write-Host "[ERRO] Falha ao gerar snapshot"
    Write-Host "============================================================"
    Write-Host ""

    Write-Host "Mensagem:"
    Write-Host $_.Exception.Message
    Write-Host ""

    if ($null -ne $_.Exception.InnerException) {

        Write-Host "Detalhe interno:"
        Write-Host $_.Exception.InnerException.Message
        Write-Host ""
    }

    exit 1
}


# ============================================================
# MONTA ARQUIVO SQL
# ============================================================

Write-Host "[INFO] Montando arquivo SQL..."
Write-Host ""

$Builder = New-Object System.Text.StringBuilder

[void]$Builder.AppendLine($Header)


foreach ($Line in $ScriptCollection) {

    if (-not [string]::IsNullOrWhiteSpace($Line)) {

        [void]$Builder.AppendLine($Line)

        [void]$Builder.AppendLine("")
        [void]$Builder.AppendLine("GO")
        [void]$Builder.AppendLine("")
    }
}


# ============================================================
# SALVA ARQUIVO
# ============================================================

Write-Host "[INFO] Salvando snapshot..."
Write-Host ""

try {

    $Utf8Encoding = New-Object `
        System.Text.UTF8Encoding($false)

    [System.IO.File]::WriteAllText(
        $OutputFile,
        $Builder.ToString(),
        $Utf8Encoding
    )

}
catch {

    Write-Host ""
    Write-Host "============================================================"
    Write-Host "[ERRO] Falha ao salvar arquivo"
    Write-Host "============================================================"
    Write-Host ""

    Write-Host "Arquivo:"
    Write-Host "$OutputFile"
    Write-Host ""

    Write-Host "Mensagem:"
    Write-Host $_.Exception.Message
    Write-Host ""

    exit 1
}


# ============================================================
# VALIDA ARQUIVO
# ============================================================

if (-not (Test-Path $OutputFile)) {

    Write-Host ""
    Write-Host "[ERRO] Arquivo de snapshot não foi criado."
    Write-Host ""

    exit 1
}


$FileInfo = Get-Item $OutputFile

$FileSizeKB = [math]::Round(
    $FileInfo.Length / 1KB,
    2
)


# ============================================================
# VALIDA CONTEÚDO
# ============================================================

$ConteudoSnapshot = Get-Content `
    $OutputFile `
    -Raw

$QtdCreateTable = (
    [regex]::Matches(
        $ConteudoSnapshot,
        "CREATE TABLE",
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )
).Count

$QtdCreateView = (
    [regex]::Matches(
        $ConteudoSnapshot,
        "CREATE VIEW",
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )
).Count

$QtdForeignKey = (
    [regex]::Matches(
        $ConteudoSnapshot,
        "FOREIGN KEY",
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )
).Count


# ============================================================
# RESULTADO
# ============================================================

Write-Host ""
Write-Host "============================================================"
Write-Host "SNAPSHOT GERADO COM SUCESSO"
Write-Host "============================================================"
Write-Host ""

Write-Host "Arquivo:"
Write-Host "$OutputFile"
Write-Host ""

Write-Host "Tamanho:"
Write-Host "$FileSizeKB KB"
Write-Host ""

Write-Host "Objetos encontrados no banco:"
Write-Host ""

Write-Host "Tabelas ................. $($UserTables.Count)"
Write-Host "Views ................... $($UserViews.Count)"
Write-Host "Procedures .............. $($StoredProcedures.Count)"
Write-Host "Funções ................. $($Functions.Count)"

Write-Host ""

Write-Host "Objetos identificados no arquivo:"
Write-Host ""

Write-Host "CREATE TABLE ............ $QtdCreateTable"
Write-Host "CREATE VIEW ............. $QtdCreateView"
Write-Host "FOREIGN KEY ............. $QtdForeignKey"

Write-Host ""

Write-Host "============================================================"
Write-Host "SalesIn - Snapshot concluído"
Write-Host "============================================================"
Write-Host ""

Write-Host "Próximo passo:"
Write-Host ""
Write-Host "Versionar este arquivo no GitHub."
Write-Host ""