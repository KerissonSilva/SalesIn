-- ============================================================
-- SALESIN
-- SNAPSHOT INICIAL DO BANCO DE DADOS
-- ============================================================
--
-- Projeto:
-- SalesIn - InteligÃªncia Comercial 360
--
-- Servidor de origem:
-- localhost\SQLEXPRESS
--
-- Banco:
-- SalesIn
--
-- Data de geraÃ§Ã£o:
-- 2026-09-15 13:46:41
--
-- IMPORTANTE:
--
-- Este arquivo contÃ©m SOMENTE A ESTRUTURA do banco.
--
-- NÃ£o contÃ©m dados de clientes.
-- NÃ£o contÃ©m dados de vendas.
-- NÃ£o contÃ©m dados de usuÃ¡rios.
-- NÃ£o contÃ©m dados comerciais.
--
-- Objetivo:
--
-- Registrar no GitHub a estrutura inicial do banco SalesIn.
--
-- ============================================================

USE [SalesIn];
GO

/****** Object:  Table [dbo].[Vendas]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[Vendas](
	[VendaID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClienteID] [int] NOT NULL,
	[VendedorID] [int] NOT NULL,
	[CanalVendaID] [int] NOT NULL,
	[NumeroPedido] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[DataVenda] [date] NOT NULL,
	[StatusVenda] [nvarchar](30) COLLATE Latin1_General_CI_AS NOT NULL,
	[ValorBruto] [decimal](18, 2) NOT NULL,
	[ValorDesconto] [decimal](18, 2) NOT NULL,
	[ValorLiquido] [decimal](18, 2) NOT NULL,
	[CustoTotal] [decimal](18, 2) NOT NULL,
	[MargemValor] [decimal](18, 2) NOT NULL,
	[MargemPercentual] [decimal](9, 4) NULL,
	[CriadoEm] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[VendaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


GO

/****** Object:  View [dbo].[vw_DashboardExecutivo]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO



/* ============================================================
   1. DASHBOARD EXECUTIVO
   ============================================================ */

CREATE   VIEW dbo.vw_DashboardExecutivo
AS

SELECT
    COUNT(*) AS TotalPedidos,

    COUNT(DISTINCT ClienteID) AS ClientesComCompra,

    SUM(ValorBruto) AS FaturamentoBruto,

    SUM(ValorDesconto) AS TotalDescontos,

    SUM(ValorLiquido) AS FaturamentoLiquido,

    SUM(CustoTotal) AS CustoTotal,

    SUM(MargemValor) AS MargemValor,

    CASE
        WHEN SUM(ValorLiquido) > 0
        THEN
            (
                SUM(MargemValor)
                /
                SUM(ValorLiquido)
            ) * 100
        ELSE 0
    END AS MargemPercentual,

    AVG(ValorLiquido) AS TicketMedio,

    MIN(DataVenda) AS PrimeiraVenda,

    MAX(DataVenda) AS UltimaVenda

FROM dbo.Vendas
WHERE StatusVenda = 'Faturada';


GO

/****** Object:  View [dbo].[vw_FaturamentoMensal]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO




/* ============================================================
   2. FATURAMENTO MENSAL
   ============================================================ */

CREATE   VIEW dbo.vw_FaturamentoMensal
AS

SELECT
    YEAR(DataVenda) AS Ano,

    MONTH(DataVenda) AS Mes,

    COUNT(*) AS TotalPedidos,

    COUNT(DISTINCT ClienteID) AS ClientesAtendidos,

    SUM(ValorBruto) AS FaturamentoBruto,

    SUM(ValorDesconto) AS Descontos,

    SUM(ValorLiquido) AS FaturamentoLiquido,

    SUM(CustoTotal) AS CustoTotal,

    SUM(MargemValor) AS MargemValor,

    CASE
        WHEN SUM(ValorLiquido) > 0
        THEN
            (
                SUM(MargemValor)
                /
                SUM(ValorLiquido)
            ) * 100
        ELSE 0
    END AS MargemPercentual,

    AVG(ValorLiquido) AS TicketMedio

FROM dbo.Vendas

WHERE StatusVenda = 'Faturada'

GROUP BY
    YEAR(DataVenda),
    MONTH(DataVenda);


GO

/****** Object:  Table [dbo].[Vendedores]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[Vendedores](
	[VendedorID] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](30) COLLATE Latin1_General_CI_AS NOT NULL,
	[Nome] [nvarchar](150) COLLATE Latin1_General_CI_AS NOT NULL,
	[Email] [nvarchar](200) COLLATE Latin1_General_CI_AS NULL,
	[Telefone] [nvarchar](30) COLLATE Latin1_General_CI_AS NULL,
	[Cargo] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[DataAdmissao] [date] NULL,
	[Ativo] [bit] NOT NULL,
	[CriadoEm] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[VendedorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


GO

/****** Object:  View [dbo].[vw_RankingVendedores]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO




/* ============================================================
   3. RANKING DE VENDEDORES
   ============================================================ */

CREATE   VIEW dbo.vw_RankingVendedores
AS

SELECT
    VD.VendedorID,

    VD.Codigo,

    VD.Nome AS Vendedor,

    COUNT(V.VendaID) AS TotalPedidos,

    COUNT(DISTINCT V.ClienteID) AS ClientesAtendidos,

    SUM(V.ValorLiquido) AS Faturamento,

    SUM(V.CustoTotal) AS CustoTotal,

    SUM(V.MargemValor) AS MargemValor,

    CASE
        WHEN SUM(V.ValorLiquido) > 0
        THEN
            (
                SUM(V.MargemValor)
                /
                SUM(V.ValorLiquido)
            ) * 100
        ELSE 0
    END AS MargemPercentual,

    AVG(V.ValorLiquido) AS TicketMedio,

    MAX(V.DataVenda) AS UltimaVenda

FROM dbo.Vendedores VD

LEFT JOIN dbo.Vendas V
    ON V.VendedorID = VD.VendedorID
    AND V.StatusVenda = 'Faturada'

WHERE VD.Ativo = 1

GROUP BY
    VD.VendedorID,
    VD.Codigo,
    VD.Nome;


GO

/****** Object:  Table [dbo].[CanaisVenda]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[CanaisVenda](
	[CanalVendaID] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [nvarchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
	[Descricao] [nvarchar](300) COLLATE Latin1_General_CI_AS NULL,
	[Ativo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CanalVendaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


GO

/****** Object:  Table [dbo].[Clientes]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[Clientes](
	[ClienteID] [int] IDENTITY(1,1) NOT NULL,
	[VendedorID] [int] NULL,
	[CanalVendaID] [int] NULL,
	[Codigo] [nvarchar](30) COLLATE Latin1_General_CI_AS NOT NULL,
	[RazaoSocial] [nvarchar](200) COLLATE Latin1_General_CI_AS NOT NULL,
	[NomeFantasia] [nvarchar](200) COLLATE Latin1_General_CI_AS NULL,
	[Documento] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Segmento] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Cidade] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Estado] [char](2) COLLATE Latin1_General_CI_AS NULL,
	[Regiao] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Email] [nvarchar](200) COLLATE Latin1_General_CI_AS NULL,
	[Telefone] [nvarchar](30) COLLATE Latin1_General_CI_AS NULL,
	[DataCadastro] [date] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[CriadoEm] [datetime2](7) NOT NULL,
	[AtualizadoEm] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[ClienteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


GO

/****** Object:  View [dbo].[vw_Clientes360]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO




/* ============================================================
   4. CLIENTES 360
   ============================================================ */

CREATE   VIEW dbo.vw_Clientes360
AS

SELECT
    C.ClienteID,

    C.Codigo,

    C.NomeFantasia AS Cliente,

    C.RazaoSocial,

    C.Segmento,

    C.Cidade,

    C.Estado,

    C.Regiao,

    VD.Nome AS Vendedor,

    CV.Nome AS CanalVenda,

    COUNT(V.VendaID) AS TotalPedidos,

    MIN(V.DataVenda) AS PrimeiraCompra,

    MAX(V.DataVenda) AS UltimaCompra,

    DATEDIFF
    (
        DAY,
        MAX(V.DataVenda),
        GETDATE()
    ) AS DiasSemComprar,

    SUM(V.ValorLiquido) AS FaturamentoTotal,

    SUM(V.CustoTotal) AS CustoTotal,

    SUM(V.MargemValor) AS MargemValor,

    CASE
        WHEN SUM(V.ValorLiquido) > 0
        THEN
            (
                SUM(V.MargemValor)
                /
                SUM(V.ValorLiquido)
            ) * 100
        ELSE 0
    END AS MargemPercentual,

    AVG(V.ValorLiquido) AS TicketMedio

FROM dbo.Clientes C

LEFT JOIN dbo.Vendedores VD
    ON VD.VendedorID = C.VendedorID

LEFT JOIN dbo.CanaisVenda CV
    ON CV.CanalVendaID = C.CanalVendaID

LEFT JOIN dbo.Vendas V
    ON V.ClienteID = C.ClienteID
    AND V.StatusVenda = 'Faturada'

WHERE C.Ativo = 1

GROUP BY
    C.ClienteID,
    C.Codigo,
    C.NomeFantasia,
    C.RazaoSocial,
    C.Segmento,
    C.Cidade,
    C.Estado,
    C.Regiao,
    VD.Nome,
    CV.Nome;


GO

/****** Object:  Table [dbo].[CategoriasProduto]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[CategoriasProduto](
	[CategoriaProdutoID] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [nvarchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
	[Descricao] [nvarchar](300) COLLATE Latin1_General_CI_AS NULL,
	[Ativo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoriaProdutoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


GO

/****** Object:  Table [dbo].[Produtos]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[Produtos](
	[ProdutoID] [int] IDENTITY(1,1) NOT NULL,
	[CategoriaProdutoID] [int] NOT NULL,
	[Codigo] [nvarchar](30) COLLATE Latin1_General_CI_AS NOT NULL,
	[Nome] [nvarchar](200) COLLATE Latin1_General_CI_AS NOT NULL,
	[UnidadeMedida] [nvarchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[PrecoLista] [decimal](18, 2) NOT NULL,
	[CustoPadrao] [decimal](18, 2) NOT NULL,
	[Ativo] [bit] NOT NULL,
	[CriadoEm] [datetime2](7) NOT NULL,
	[AtualizadoEm] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProdutoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


GO

/****** Object:  Table [dbo].[ItensVenda]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[ItensVenda](
	[ItemVendaID] [bigint] IDENTITY(1,1) NOT NULL,
	[VendaID] [bigint] NOT NULL,
	[ProdutoID] [int] NOT NULL,
	[Quantidade] [decimal](18, 3) NOT NULL,
	[PrecoUnitario] [decimal](18, 4) NOT NULL,
	[PercentualDesconto] [decimal](9, 4) NOT NULL,
	[ValorBruto] [decimal](18, 2) NOT NULL,
	[ValorDesconto] [decimal](18, 2) NOT NULL,
	[ValorLiquido] [decimal](18, 2) NOT NULL,
	[CustoTotal] [decimal](18, 2) NOT NULL,
	[MargemValor] [decimal](18, 2) NOT NULL,
	[MargemPercentual] [decimal](9, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[ItemVendaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


GO

/****** Object:  View [dbo].[vw_Produtos360]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO




/* ============================================================
   5. PRODUTOS 360
   ============================================================ */

CREATE   VIEW dbo.vw_Produtos360
AS

SELECT
    P.ProdutoID,

    P.Codigo,

    P.Nome AS Produto,

    CP.Nome AS Categoria,

    P.UnidadeMedida,

    SUM(I.Quantidade) AS QuantidadeVendida,

    COUNT(DISTINCT I.VendaID) AS PedidosComProduto,

    COUNT(DISTINCT V.ClienteID) AS ClientesCompradores,

    SUM(I.ValorBruto) AS FaturamentoBruto,

    SUM(I.ValorDesconto) AS Descontos,

    SUM(I.ValorLiquido) AS FaturamentoLiquido,

    SUM(I.CustoTotal) AS CustoTotal,

    SUM(I.MargemValor) AS MargemValor,

    CASE
        WHEN SUM(I.ValorLiquido) > 0
        THEN
            (
                SUM(I.MargemValor)
                /
                SUM(I.ValorLiquido)
            ) * 100
        ELSE 0
    END AS MargemPercentual,

    AVG(I.PrecoUnitario) AS PrecoMedioVenda

FROM dbo.Produtos P

INNER JOIN dbo.CategoriasProduto CP
    ON CP.CategoriaProdutoID = P.CategoriaProdutoID

LEFT JOIN dbo.ItensVenda I
    ON I.ProdutoID = P.ProdutoID

LEFT JOIN dbo.Vendas V
    ON V.VendaID = I.VendaID
    AND V.StatusVenda = 'Faturada'

WHERE P.Ativo = 1

GROUP BY
    P.ProdutoID,
    P.Codigo,
    P.Nome,
    CP.Nome,
    P.UnidadeMedida;


GO

/****** Object:  Table [dbo].[MetasVendedores]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[MetasVendedores](
	[MetaVendedorID] [int] IDENTITY(1,1) NOT NULL,
	[VendedorID] [int] NOT NULL,
	[Ano] [smallint] NOT NULL,
	[Mes] [tinyint] NOT NULL,
	[MetaFaturamento] [decimal](18, 2) NOT NULL,
	[MetaMargem] [decimal](18, 2) NULL,
	[MetaNovosClientes] [int] NULL,
	[CriadoEm] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MetaVendedorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


GO

/****** Object:  View [dbo].[vw_MetasRealizado]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO


CREATE   VIEW dbo.vw_MetasRealizado
AS

WITH Realizado AS
(
    SELECT
        VendedorID,
        YEAR(DataVenda) AS Ano,
        MONTH(DataVenda) AS Mes,

        COUNT(*) AS TotalPedidos,

        COUNT(DISTINCT ClienteID) AS ClientesAtendidos,

        SUM(ValorLiquido) AS FaturamentoRealizado,

        SUM(MargemValor) AS MargemRealizada

    FROM dbo.Vendas

    WHERE StatusVenda = 'Faturada'

    GROUP BY
        VendedorID,
        YEAR(DataVenda),
        MONTH(DataVenda)
)

SELECT
    M.MetaVendedorID,

    M.VendedorID,

    V.Codigo AS CodigoVendedor,

    V.Nome AS Vendedor,

    M.Ano,

    M.Mes,

    M.MetaFaturamento,

    ISNULL(R.FaturamentoRealizado, 0) AS FaturamentoRealizado,

    M.MetaFaturamento
        - ISNULL(R.FaturamentoRealizado, 0) AS FaltaParaMeta,

    CASE
        WHEN M.MetaFaturamento > 0
        THEN
            (
                ISNULL(R.FaturamentoRealizado, 0)
                / M.MetaFaturamento
            ) * 100
        ELSE 0
    END AS PercentualAtingimento,

    ISNULL(R.TotalPedidos, 0) AS TotalPedidos,

    ISNULL(R.ClientesAtendidos, 0) AS ClientesAtendidos,

    ISNULL(R.MargemRealizada, 0) AS MargemRealizada,

    CASE
        WHEN ISNULL(R.FaturamentoRealizado, 0)
             >= M.MetaFaturamento
        THEN 'Meta Atingida'

        WHEN
            (
                ISNULL(R.FaturamentoRealizado, 0)
                / NULLIF(M.MetaFaturamento, 0)
            ) >= 0.90
        THEN 'Próximo da Meta'

        ELSE 'Abaixo da Meta'
    END AS StatusMeta

FROM dbo.MetasVendedores M

INNER JOIN dbo.Vendedores V
    ON V.VendedorID = M.VendedorID

LEFT JOIN Realizado R
    ON R.VendedorID = M.VendedorID
    AND R.Ano = M.Ano
    AND R.Mes = M.Mes;


GO

/****** Object:  View [dbo].[vw_ResumoExecutivoMensal]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO


CREATE   VIEW dbo.vw_ResumoExecutivoMensal
AS

SELECT
    M.Ano,
    M.Mes,

    SUM(M.MetaFaturamento) AS MetaEquipe,

    SUM(M.FaturamentoRealizado) AS FaturamentoRealizado,

    SUM(M.FaltaParaMeta) AS SaldoMeta,

    CASE
        WHEN SUM(M.MetaFaturamento) > 0
        THEN
            (
                SUM(M.FaturamentoRealizado)
                /
                SUM(M.MetaFaturamento)
            ) * 100
        ELSE 0
    END AS PercentualAtingimento,

    SUM(M.TotalPedidos) AS TotalPedidos,

    SUM(M.ClientesAtendidos) AS SomaClientesAtendidos,

    SUM(M.MargemRealizada) AS MargemRealizada,

    SUM
    (
        CASE
            WHEN M.StatusMeta = 'Meta Atingida'
            THEN 1
            ELSE 0
        END
    ) AS VendedoresMetaAtingida,

    SUM
    (
        CASE
            WHEN M.StatusMeta = 'Próximo da Meta'
            THEN 1
            ELSE 0
        END
    ) AS VendedoresProximosMeta,

    SUM
    (
        CASE
            WHEN M.StatusMeta = 'Abaixo da Meta'
            THEN 1
            ELSE 0
        END
    ) AS VendedoresAbaixoMeta

FROM dbo.vw_MetasRealizado M

GROUP BY
    M.Ano,
    M.Mes;


GO

/****** Object:  Table [dbo].[Auditoria]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[Auditoria](
	[AuditoriaID] [bigint] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[Modulo] [nvarchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
	[Acao] [nvarchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
	[Entidade] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[RegistroID] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Descricao] [nvarchar](max) COLLATE Latin1_General_CI_AS NULL,
	[DataHora] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditoriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


GO

/****** Object:  Table [dbo].[Perfis]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[Perfis](
	[PerfilID] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [nvarchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
	[Descricao] [nvarchar](300) COLLATE Latin1_General_CI_AS NULL,
	[Ativo] [bit] NOT NULL,
	[CriadoEm] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PerfilID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


GO

/****** Object:  Table [dbo].[Usuarios]    Script Date: 15/09/2026 13:46:52 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[Usuarios](
	[UsuarioID] [int] IDENTITY(1,1) NOT NULL,
	[PerfilID] [int] NOT NULL,
	[Nome] [nvarchar](150) COLLATE Latin1_General_CI_AS NOT NULL,
	[Email] [nvarchar](200) COLLATE Latin1_General_CI_AS NOT NULL,
	[Login] [nvarchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
	[SenhaHash] [nvarchar](500) COLLATE Latin1_General_CI_AS NULL,
	[Ativo] [bit] NOT NULL,
	[UltimoLoginEm] [datetime2](7) NULL,
	[CriadoEm] [datetime2](7) NOT NULL,
	[AtualizadoEm] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[UsuarioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


GO

/****** Object:  Index [IX_Auditoria_DataHora]    Script Date: 15/09/2026 13:46:52 ******/
CREATE NONCLUSTERED INDEX [IX_Auditoria_DataHora] ON [dbo].[Auditoria]
(
	[DataHora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

SET ANSI_PADDING ON


GO

/****** Object:  Index [UX_CanaisVenda_Nome]    Script Date: 15/09/2026 13:46:52 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_CanaisVenda_Nome] ON [dbo].[CanaisVenda]
(
	[Nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

SET ANSI_PADDING ON


GO

/****** Object:  Index [UX_CategoriasProduto_Nome]    Script Date: 15/09/2026 13:46:52 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_CategoriasProduto_Nome] ON [dbo].[CategoriasProduto]
(
	[Nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

/****** Object:  Index [IX_Clientes_CanalVendaID]    Script Date: 15/09/2026 13:46:52 ******/
CREATE NONCLUSTERED INDEX [IX_Clientes_CanalVendaID] ON [dbo].[Clientes]
(
	[CanalVendaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

/****** Object:  Index [IX_Clientes_VendedorID]    Script Date: 15/09/2026 13:46:52 ******/
CREATE NONCLUSTERED INDEX [IX_Clientes_VendedorID] ON [dbo].[Clientes]
(
	[VendedorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

SET ANSI_PADDING ON


GO

/****** Object:  Index [UX_Clientes_Codigo]    Script Date: 15/09/2026 13:46:52 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Clientes_Codigo] ON [dbo].[Clientes]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

/****** Object:  Index [IX_ItensVenda_ProdutoID]    Script Date: 15/09/2026 13:46:52 ******/
CREATE NONCLUSTERED INDEX [IX_ItensVenda_ProdutoID] ON [dbo].[ItensVenda]
(
	[ProdutoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

/****** Object:  Index [IX_ItensVenda_VendaID]    Script Date: 15/09/2026 13:46:52 ******/
CREATE NONCLUSTERED INDEX [IX_ItensVenda_VendaID] ON [dbo].[ItensVenda]
(
	[VendaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

/****** Object:  Index [UX_MetasVendedores_Periodo]    Script Date: 15/09/2026 13:46:52 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_MetasVendedores_Periodo] ON [dbo].[MetasVendedores]
(
	[VendedorID] ASC,
	[Ano] ASC,
	[Mes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

SET ANSI_PADDING ON


GO

/****** Object:  Index [UX_Perfis_Nome]    Script Date: 15/09/2026 13:46:52 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Perfis_Nome] ON [dbo].[Perfis]
(
	[Nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

/****** Object:  Index [IX_Produtos_CategoriaProdutoID]    Script Date: 15/09/2026 13:46:52 ******/
CREATE NONCLUSTERED INDEX [IX_Produtos_CategoriaProdutoID] ON [dbo].[Produtos]
(
	[CategoriaProdutoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

SET ANSI_PADDING ON


GO

/****** Object:  Index [UX_Produtos_Codigo]    Script Date: 15/09/2026 13:46:52 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Produtos_Codigo] ON [dbo].[Produtos]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

SET ANSI_PADDING ON


GO

/****** Object:  Index [UX_Usuarios_Email]    Script Date: 15/09/2026 13:46:52 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Usuarios_Email] ON [dbo].[Usuarios]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

SET ANSI_PADDING ON


GO

/****** Object:  Index [UX_Usuarios_Login]    Script Date: 15/09/2026 13:46:52 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Usuarios_Login] ON [dbo].[Usuarios]
(
	[Login] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

/****** Object:  Index [IX_Vendas_ClienteID]    Script Date: 15/09/2026 13:46:52 ******/
CREATE NONCLUSTERED INDEX [IX_Vendas_ClienteID] ON [dbo].[Vendas]
(
	[ClienteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

/****** Object:  Index [IX_Vendas_DataVenda]    Script Date: 15/09/2026 13:46:52 ******/
CREATE NONCLUSTERED INDEX [IX_Vendas_DataVenda] ON [dbo].[Vendas]
(
	[DataVenda] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

/****** Object:  Index [IX_Vendas_VendedorID]    Script Date: 15/09/2026 13:46:52 ******/
CREATE NONCLUSTERED INDEX [IX_Vendas_VendedorID] ON [dbo].[Vendas]
(
	[VendedorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

SET ANSI_PADDING ON


GO

/****** Object:  Index [UX_Vendas_NumeroPedido]    Script Date: 15/09/2026 13:46:52 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Vendas_NumeroPedido] ON [dbo].[Vendas]
(
	[NumeroPedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

SET ANSI_PADDING ON


GO

/****** Object:  Index [UX_Vendedores_Codigo]    Script Date: 15/09/2026 13:46:52 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Vendedores_Codigo] ON [dbo].[Vendedores]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Auditoria] ADD  CONSTRAINT [DF_Auditoria_DataHora]  DEFAULT (sysdatetime()) FOR [DataHora]

GO

ALTER TABLE [dbo].[CanaisVenda] ADD  CONSTRAINT [DF_CanaisVenda_Ativo]  DEFAULT ((1)) FOR [Ativo]

GO

ALTER TABLE [dbo].[CategoriasProduto] ADD  CONSTRAINT [DF_CategoriasProduto_Ativo]  DEFAULT ((1)) FOR [Ativo]

GO

ALTER TABLE [dbo].[Clientes] ADD  CONSTRAINT [DF_Clientes_DataCadastro]  DEFAULT (CONVERT([date],getdate())) FOR [DataCadastro]

GO

ALTER TABLE [dbo].[Clientes] ADD  CONSTRAINT [DF_Clientes_Ativo]  DEFAULT ((1)) FOR [Ativo]

GO

ALTER TABLE [dbo].[Clientes] ADD  CONSTRAINT [DF_Clientes_CriadoEm]  DEFAULT (sysdatetime()) FOR [CriadoEm]

GO

ALTER TABLE [dbo].[ItensVenda] ADD  CONSTRAINT [DF_ItensVenda_PercentualDesconto]  DEFAULT ((0)) FOR [PercentualDesconto]

GO

ALTER TABLE [dbo].[ItensVenda] ADD  CONSTRAINT [DF_ItensVenda_ValorDesconto]  DEFAULT ((0)) FOR [ValorDesconto]

GO

ALTER TABLE [dbo].[MetasVendedores] ADD  CONSTRAINT [DF_MetasVendedores_CriadoEm]  DEFAULT (sysdatetime()) FOR [CriadoEm]

GO

ALTER TABLE [dbo].[Perfis] ADD  CONSTRAINT [DF_Perfis_Ativo]  DEFAULT ((1)) FOR [Ativo]

GO

ALTER TABLE [dbo].[Perfis] ADD  CONSTRAINT [DF_Perfis_CriadoEm]  DEFAULT (sysdatetime()) FOR [CriadoEm]

GO

ALTER TABLE [dbo].[Produtos] ADD  CONSTRAINT [DF_Produtos_Ativo]  DEFAULT ((1)) FOR [Ativo]

GO

ALTER TABLE [dbo].[Produtos] ADD  CONSTRAINT [DF_Produtos_CriadoEm]  DEFAULT (sysdatetime()) FOR [CriadoEm]

GO

ALTER TABLE [dbo].[Usuarios] ADD  CONSTRAINT [DF_Usuarios_Ativo]  DEFAULT ((1)) FOR [Ativo]

GO

ALTER TABLE [dbo].[Usuarios] ADD  CONSTRAINT [DF_Usuarios_CriadoEm]  DEFAULT (sysdatetime()) FOR [CriadoEm]

GO

ALTER TABLE [dbo].[Vendas] ADD  CONSTRAINT [DF_Vendas_StatusVenda]  DEFAULT ('Faturada') FOR [StatusVenda]

GO

ALTER TABLE [dbo].[Vendas] ADD  CONSTRAINT [DF_Vendas_ValorBruto]  DEFAULT ((0)) FOR [ValorBruto]

GO

ALTER TABLE [dbo].[Vendas] ADD  CONSTRAINT [DF_Vendas_ValorDesconto]  DEFAULT ((0)) FOR [ValorDesconto]

GO

ALTER TABLE [dbo].[Vendas] ADD  CONSTRAINT [DF_Vendas_ValorLiquido]  DEFAULT ((0)) FOR [ValorLiquido]

GO

ALTER TABLE [dbo].[Vendas] ADD  CONSTRAINT [DF_Vendas_CustoTotal]  DEFAULT ((0)) FOR [CustoTotal]

GO

ALTER TABLE [dbo].[Vendas] ADD  CONSTRAINT [DF_Vendas_MargemValor]  DEFAULT ((0)) FOR [MargemValor]

GO

ALTER TABLE [dbo].[Vendas] ADD  CONSTRAINT [DF_Vendas_CriadoEm]  DEFAULT (sysdatetime()) FOR [CriadoEm]

GO

ALTER TABLE [dbo].[Vendedores] ADD  CONSTRAINT [DF_Vendedores_Ativo]  DEFAULT ((1)) FOR [Ativo]

GO

ALTER TABLE [dbo].[Vendedores] ADD  CONSTRAINT [DF_Vendedores_CriadoEm]  DEFAULT (sysdatetime()) FOR [CriadoEm]

GO

ALTER TABLE [dbo].[Auditoria]  WITH CHECK ADD  CONSTRAINT [FK_Auditoria_Usuarios] FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])

GO

ALTER TABLE [dbo].[Auditoria] CHECK CONSTRAINT [FK_Auditoria_Usuarios]

GO

ALTER TABLE [dbo].[Clientes]  WITH CHECK ADD  CONSTRAINT [FK_Clientes_CanaisVenda] FOREIGN KEY([CanalVendaID])
REFERENCES [dbo].[CanaisVenda] ([CanalVendaID])

GO

ALTER TABLE [dbo].[Clientes] CHECK CONSTRAINT [FK_Clientes_CanaisVenda]

GO

ALTER TABLE [dbo].[Clientes]  WITH CHECK ADD  CONSTRAINT [FK_Clientes_Vendedores] FOREIGN KEY([VendedorID])
REFERENCES [dbo].[Vendedores] ([VendedorID])

GO

ALTER TABLE [dbo].[Clientes] CHECK CONSTRAINT [FK_Clientes_Vendedores]

GO

ALTER TABLE [dbo].[ItensVenda]  WITH CHECK ADD  CONSTRAINT [FK_ItensVenda_Produtos] FOREIGN KEY([ProdutoID])
REFERENCES [dbo].[Produtos] ([ProdutoID])

GO

ALTER TABLE [dbo].[ItensVenda] CHECK CONSTRAINT [FK_ItensVenda_Produtos]

GO

ALTER TABLE [dbo].[ItensVenda]  WITH CHECK ADD  CONSTRAINT [FK_ItensVenda_Vendas] FOREIGN KEY([VendaID])
REFERENCES [dbo].[Vendas] ([VendaID])

GO

ALTER TABLE [dbo].[ItensVenda] CHECK CONSTRAINT [FK_ItensVenda_Vendas]

GO

ALTER TABLE [dbo].[MetasVendedores]  WITH CHECK ADD  CONSTRAINT [FK_MetasVendedores_Vendedores] FOREIGN KEY([VendedorID])
REFERENCES [dbo].[Vendedores] ([VendedorID])

GO

ALTER TABLE [dbo].[MetasVendedores] CHECK CONSTRAINT [FK_MetasVendedores_Vendedores]

GO

ALTER TABLE [dbo].[Produtos]  WITH CHECK ADD  CONSTRAINT [FK_Produtos_CategoriasProduto] FOREIGN KEY([CategoriaProdutoID])
REFERENCES [dbo].[CategoriasProduto] ([CategoriaProdutoID])

GO

ALTER TABLE [dbo].[Produtos] CHECK CONSTRAINT [FK_Produtos_CategoriasProduto]

GO

ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_Perfis] FOREIGN KEY([PerfilID])
REFERENCES [dbo].[Perfis] ([PerfilID])

GO

ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_Perfis]

GO

ALTER TABLE [dbo].[Vendas]  WITH CHECK ADD  CONSTRAINT [FK_Vendas_CanaisVenda] FOREIGN KEY([CanalVendaID])
REFERENCES [dbo].[CanaisVenda] ([CanalVendaID])

GO

ALTER TABLE [dbo].[Vendas] CHECK CONSTRAINT [FK_Vendas_CanaisVenda]

GO

ALTER TABLE [dbo].[Vendas]  WITH CHECK ADD  CONSTRAINT [FK_Vendas_Clientes] FOREIGN KEY([ClienteID])
REFERENCES [dbo].[Clientes] ([ClienteID])

GO

ALTER TABLE [dbo].[Vendas] CHECK CONSTRAINT [FK_Vendas_Clientes]

GO

ALTER TABLE [dbo].[Vendas]  WITH CHECK ADD  CONSTRAINT [FK_Vendas_Vendedores] FOREIGN KEY([VendedorID])
REFERENCES [dbo].[Vendedores] ([VendedorID])

GO

ALTER TABLE [dbo].[Vendas] CHECK CONSTRAINT [FK_Vendas_Vendedores]

GO

ALTER TABLE [dbo].[ItensVenda]  WITH CHECK ADD  CONSTRAINT [CK_ItensVenda_Quantidade] CHECK  (([Quantidade]>(0)))

GO

ALTER TABLE [dbo].[ItensVenda] CHECK CONSTRAINT [CK_ItensVenda_Quantidade]

GO

ALTER TABLE [dbo].[MetasVendedores]  WITH CHECK ADD  CONSTRAINT [CK_MetasVendedores_Ano] CHECK  (([Ano]>=(2020)))

GO

ALTER TABLE [dbo].[MetasVendedores] CHECK CONSTRAINT [CK_MetasVendedores_Ano]

GO

ALTER TABLE [dbo].[MetasVendedores]  WITH CHECK ADD  CONSTRAINT [CK_MetasVendedores_Mes] CHECK  (([Mes]>=(1) AND [Mes]<=(12)))

GO

ALTER TABLE [dbo].[MetasVendedores] CHECK CONSTRAINT [CK_MetasVendedores_Mes]

GO

ALTER TABLE [dbo].[Produtos]  WITH CHECK ADD  CONSTRAINT [CK_Produtos_CustoPadrao] CHECK  (([CustoPadrao]>=(0)))

GO

ALTER TABLE [dbo].[Produtos] CHECK CONSTRAINT [CK_Produtos_CustoPadrao]

GO

ALTER TABLE [dbo].[Produtos]  WITH CHECK ADD  CONSTRAINT [CK_Produtos_PrecoLista] CHECK  (([PrecoLista]>=(0)))

GO

ALTER TABLE [dbo].[Produtos] CHECK CONSTRAINT [CK_Produtos_PrecoLista]

GO

ALTER TABLE [dbo].[Vendas]  WITH CHECK ADD  CONSTRAINT [CK_Vendas_Valores] CHECK  (([ValorBruto]>=(0) AND [ValorDesconto]>=(0) AND [ValorLiquido]>=(0) AND [CustoTotal]>=(0)))

GO

ALTER TABLE [dbo].[Vendas] CHECK CONSTRAINT [CK_Vendas_Valores]

GO

