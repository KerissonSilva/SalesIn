USE SalesIn;
GO

/* =========================================================
   SALESIN
   Estrutura Core - V1.0
   ========================================================= */


/* =========================================================
   PERFIS
   ========================================================= */

IF OBJECT_ID('dbo.Perfis', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Perfis
    (
        PerfilID        INT IDENTITY(1,1) PRIMARY KEY,
        Nome            NVARCHAR(100) NOT NULL,
        Descricao       NVARCHAR(300) NULL,
        Ativo           BIT NOT NULL
            CONSTRAINT DF_Perfis_Ativo DEFAULT (1),
        CriadoEm        DATETIME2 NOT NULL
            CONSTRAINT DF_Perfis_CriadoEm DEFAULT (SYSDATETIME())
    );

    CREATE UNIQUE INDEX UX_Perfis_Nome
        ON dbo.Perfis(Nome);
END;
GO


/* =========================================================
   USUARIOS
   ========================================================= */

IF OBJECT_ID('dbo.Usuarios', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Usuarios
    (
        UsuarioID       INT IDENTITY(1,1) PRIMARY KEY,
        PerfilID        INT NOT NULL,
        Nome            NVARCHAR(150) NOT NULL,
        Email           NVARCHAR(200) NOT NULL,
        Login           NVARCHAR(100) NOT NULL,
        SenhaHash       NVARCHAR(500) NULL,
        Ativo           BIT NOT NULL
            CONSTRAINT DF_Usuarios_Ativo DEFAULT (1),
        UltimoLoginEm   DATETIME2 NULL,
        CriadoEm        DATETIME2 NOT NULL
            CONSTRAINT DF_Usuarios_CriadoEm DEFAULT (SYSDATETIME()),
        AtualizadoEm    DATETIME2 NULL,

        CONSTRAINT FK_Usuarios_Perfis
            FOREIGN KEY (PerfilID)
            REFERENCES dbo.Perfis(PerfilID)
    );

    CREATE UNIQUE INDEX UX_Usuarios_Email
        ON dbo.Usuarios(Email);

    CREATE UNIQUE INDEX UX_Usuarios_Login
        ON dbo.Usuarios(Login);
END;
GO


/* =========================================================
   VENDEDORES
   ========================================================= */

IF OBJECT_ID('dbo.Vendedores', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Vendedores
    (
        VendedorID      INT IDENTITY(1,1) PRIMARY KEY,
        Codigo          NVARCHAR(30) NOT NULL,
        Nome            NVARCHAR(150) NOT NULL,
        Email           NVARCHAR(200) NULL,
        Telefone        NVARCHAR(30) NULL,
        Cargo           NVARCHAR(100) NULL,
        DataAdmissao    DATE NULL,
        Ativo           BIT NOT NULL
            CONSTRAINT DF_Vendedores_Ativo DEFAULT (1),
        CriadoEm        DATETIME2 NOT NULL
            CONSTRAINT DF_Vendedores_CriadoEm DEFAULT (SYSDATETIME())
    );

    CREATE UNIQUE INDEX UX_Vendedores_Codigo
        ON dbo.Vendedores(Codigo);
END;
GO


/* =========================================================
   CANAIS DE VENDA
   ========================================================= */

IF OBJECT_ID('dbo.CanaisVenda', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CanaisVenda
    (
        CanalVendaID    INT IDENTITY(1,1) PRIMARY KEY,
        Nome            NVARCHAR(100) NOT NULL,
        Descricao       NVARCHAR(300) NULL,
        Ativo           BIT NOT NULL
            CONSTRAINT DF_CanaisVenda_Ativo DEFAULT (1)
    );

    CREATE UNIQUE INDEX UX_CanaisVenda_Nome
        ON dbo.CanaisVenda(Nome);
END;
GO


/* =========================================================
   CLIENTES
   ========================================================= */

IF OBJECT_ID('dbo.Clientes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Clientes
    (
        ClienteID       INT IDENTITY(1,1) PRIMARY KEY,
        VendedorID      INT NULL,
        CanalVendaID    INT NULL,

        Codigo          NVARCHAR(30) NOT NULL,
        RazaoSocial     NVARCHAR(200) NOT NULL,
        NomeFantasia    NVARCHAR(200) NULL,
        Documento       NVARCHAR(20) NULL,

        Segmento        NVARCHAR(100) NULL,

        Cidade          NVARCHAR(100) NULL,
        Estado          CHAR(2) NULL,
        Regiao          NVARCHAR(50) NULL,

        Email           NVARCHAR(200) NULL,
        Telefone        NVARCHAR(30) NULL,

        DataCadastro    DATE NOT NULL
            CONSTRAINT DF_Clientes_DataCadastro DEFAULT (CONVERT(DATE, GETDATE())),

        Ativo           BIT NOT NULL
            CONSTRAINT DF_Clientes_Ativo DEFAULT (1),

        CriadoEm        DATETIME2 NOT NULL
            CONSTRAINT DF_Clientes_CriadoEm DEFAULT (SYSDATETIME()),

        AtualizadoEm    DATETIME2 NULL,

        CONSTRAINT FK_Clientes_Vendedores
            FOREIGN KEY (VendedorID)
            REFERENCES dbo.Vendedores(VendedorID),

        CONSTRAINT FK_Clientes_CanaisVenda
            FOREIGN KEY (CanalVendaID)
            REFERENCES dbo.CanaisVenda(CanalVendaID)
    );

    CREATE UNIQUE INDEX UX_Clientes_Codigo
        ON dbo.Clientes(Codigo);

    CREATE INDEX IX_Clientes_VendedorID
        ON dbo.Clientes(VendedorID);

    CREATE INDEX IX_Clientes_CanalVendaID
        ON dbo.Clientes(CanalVendaID);
END;
GO


/* =========================================================
   CATEGORIAS DE PRODUTO
   ========================================================= */

IF OBJECT_ID('dbo.CategoriasProduto', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CategoriasProduto
    (
        CategoriaProdutoID INT IDENTITY(1,1) PRIMARY KEY,
        Nome               NVARCHAR(100) NOT NULL,
        Descricao          NVARCHAR(300) NULL,
        Ativo              BIT NOT NULL
            CONSTRAINT DF_CategoriasProduto_Ativo DEFAULT (1)
    );

    CREATE UNIQUE INDEX UX_CategoriasProduto_Nome
        ON dbo.CategoriasProduto(Nome);
END;
GO


/* =========================================================
   PRODUTOS
   ========================================================= */

IF OBJECT_ID('dbo.Produtos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Produtos
    (
        ProdutoID           INT IDENTITY(1,1) PRIMARY KEY,
        CategoriaProdutoID  INT NOT NULL,

        Codigo              NVARCHAR(30) NOT NULL,
        Nome                NVARCHAR(200) NOT NULL,
        UnidadeMedida       NVARCHAR(20) NOT NULL,

        PrecoLista          DECIMAL(18,2) NOT NULL,
        CustoPadrao         DECIMAL(18,2) NOT NULL,

        Ativo               BIT NOT NULL
            CONSTRAINT DF_Produtos_Ativo DEFAULT (1),

        CriadoEm            DATETIME2 NOT NULL
            CONSTRAINT DF_Produtos_CriadoEm DEFAULT (SYSDATETIME()),

        AtualizadoEm        DATETIME2 NULL,

        CONSTRAINT FK_Produtos_CategoriasProduto
            FOREIGN KEY (CategoriaProdutoID)
            REFERENCES dbo.CategoriasProduto(CategoriaProdutoID),

        CONSTRAINT CK_Produtos_PrecoLista
            CHECK (PrecoLista >= 0),

        CONSTRAINT CK_Produtos_CustoPadrao
            CHECK (CustoPadrao >= 0)
    );

    CREATE UNIQUE INDEX UX_Produtos_Codigo
        ON dbo.Produtos(Codigo);

    CREATE INDEX IX_Produtos_CategoriaProdutoID
        ON dbo.Produtos(CategoriaProdutoID);
END;
GO


/* =========================================================
   VENDAS
   ========================================================= */

IF OBJECT_ID('dbo.Vendas', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Vendas
    (
        VendaID          BIGINT IDENTITY(1,1) PRIMARY KEY,

        ClienteID        INT NOT NULL,
        VendedorID       INT NOT NULL,
        CanalVendaID     INT NOT NULL,

        NumeroPedido     NVARCHAR(50) NOT NULL,
        DataVenda        DATE NOT NULL,

        StatusVenda      NVARCHAR(30) NOT NULL
            CONSTRAINT DF_Vendas_StatusVenda DEFAULT ('Faturada'),

        ValorBruto       DECIMAL(18,2) NOT NULL
            CONSTRAINT DF_Vendas_ValorBruto DEFAULT (0),

        ValorDesconto    DECIMAL(18,2) NOT NULL
            CONSTRAINT DF_Vendas_ValorDesconto DEFAULT (0),

        ValorLiquido     DECIMAL(18,2) NOT NULL
            CONSTRAINT DF_Vendas_ValorLiquido DEFAULT (0),

        CustoTotal       DECIMAL(18,2) NOT NULL
            CONSTRAINT DF_Vendas_CustoTotal DEFAULT (0),

        MargemValor      DECIMAL(18,2) NOT NULL
            CONSTRAINT DF_Vendas_MargemValor DEFAULT (0),

        MargemPercentual DECIMAL(9,4) NULL,

        CriadoEm         DATETIME2 NOT NULL
            CONSTRAINT DF_Vendas_CriadoEm DEFAULT (SYSDATETIME()),

        CONSTRAINT FK_Vendas_Clientes
            FOREIGN KEY (ClienteID)
            REFERENCES dbo.Clientes(ClienteID),

        CONSTRAINT FK_Vendas_Vendedores
            FOREIGN KEY (VendedorID)
            REFERENCES dbo.Vendedores(VendedorID),

        CONSTRAINT FK_Vendas_CanaisVenda
            FOREIGN KEY (CanalVendaID)
            REFERENCES dbo.CanaisVenda(CanalVendaID),

        CONSTRAINT CK_Vendas_Valores
            CHECK
            (
                ValorBruto >= 0
                AND ValorDesconto >= 0
                AND ValorLiquido >= 0
                AND CustoTotal >= 0
            )
    );

    CREATE UNIQUE INDEX UX_Vendas_NumeroPedido
        ON dbo.Vendas(NumeroPedido);

    CREATE INDEX IX_Vendas_DataVenda
        ON dbo.Vendas(DataVenda);

    CREATE INDEX IX_Vendas_ClienteID
        ON dbo.Vendas(ClienteID);

    CREATE INDEX IX_Vendas_VendedorID
        ON dbo.Vendas(VendedorID);
END;
GO


/* =========================================================
   ITENS DA VENDA
   ========================================================= */

IF OBJECT_ID('dbo.ItensVenda', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ItensVenda
    (
        ItemVendaID        BIGINT IDENTITY(1,1) PRIMARY KEY,

        VendaID            BIGINT NOT NULL,
        ProdutoID          INT NOT NULL,

        Quantidade         DECIMAL(18,3) NOT NULL,
        PrecoUnitario      DECIMAL(18,4) NOT NULL,

        PercentualDesconto DECIMAL(9,4) NOT NULL
            CONSTRAINT DF_ItensVenda_PercentualDesconto DEFAULT (0),

        ValorBruto         DECIMAL(18,2) NOT NULL,
        ValorDesconto      DECIMAL(18,2) NOT NULL
            CONSTRAINT DF_ItensVenda_ValorDesconto DEFAULT (0),

        ValorLiquido       DECIMAL(18,2) NOT NULL,
        CustoTotal         DECIMAL(18,2) NOT NULL,
        MargemValor        DECIMAL(18,2) NOT NULL,
        MargemPercentual   DECIMAL(9,4) NULL,

        CONSTRAINT FK_ItensVenda_Vendas
            FOREIGN KEY (VendaID)
            REFERENCES dbo.Vendas(VendaID),

        CONSTRAINT FK_ItensVenda_Produtos
            FOREIGN KEY (ProdutoID)
            REFERENCES dbo.Produtos(ProdutoID),

        CONSTRAINT CK_ItensVenda_Quantidade
            CHECK (Quantidade > 0)
    );

    CREATE INDEX IX_ItensVenda_VendaID
        ON dbo.ItensVenda(VendaID);

    CREATE INDEX IX_ItensVenda_ProdutoID
        ON dbo.ItensVenda(ProdutoID);
END;
GO


/* =========================================================
   METAS DE VENDEDORES
   ========================================================= */

IF OBJECT_ID('dbo.MetasVendedores', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.MetasVendedores
    (
        MetaVendedorID   INT IDENTITY(1,1) PRIMARY KEY,
        VendedorID       INT NOT NULL,

        Ano              SMALLINT NOT NULL,
        Mes              TINYINT NOT NULL,

        MetaFaturamento  DECIMAL(18,2) NOT NULL,
        MetaMargem       DECIMAL(18,2) NULL,
        MetaNovosClientes INT NULL,

        CriadoEm         DATETIME2 NOT NULL
            CONSTRAINT DF_MetasVendedores_CriadoEm DEFAULT (SYSDATETIME()),

        CONSTRAINT FK_MetasVendedores_Vendedores
            FOREIGN KEY (VendedorID)
            REFERENCES dbo.Vendedores(VendedorID),

        CONSTRAINT CK_MetasVendedores_Mes
            CHECK (Mes BETWEEN 1 AND 12),

        CONSTRAINT CK_MetasVendedores_Ano
            CHECK (Ano >= 2020)
    );

    CREATE UNIQUE INDEX UX_MetasVendedores_Periodo
        ON dbo.MetasVendedores
        (
            VendedorID,
            Ano,
            Mes
        );
END;
GO


/* =========================================================
   AUDITORIA
   ========================================================= */

IF OBJECT_ID('dbo.Auditoria', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Auditoria
    (
        AuditoriaID      BIGINT IDENTITY(1,1) PRIMARY KEY,

        UsuarioID        INT NULL,

        Modulo           NVARCHAR(100) NOT NULL,
        Acao             NVARCHAR(100) NOT NULL,

        Entidade         NVARCHAR(100) NULL,
        RegistroID       NVARCHAR(100) NULL,

        Descricao        NVARCHAR(MAX) NULL,

        DataHora         DATETIME2 NOT NULL
            CONSTRAINT DF_Auditoria_DataHora DEFAULT (SYSDATETIME()),

        CONSTRAINT FK_Auditoria_Usuarios
            FOREIGN KEY (UsuarioID)
            REFERENCES dbo.Usuarios(UsuarioID)
    );

    CREATE INDEX IX_Auditoria_DataHora
        ON dbo.Auditoria(DataHora);
END;
GO


/* =========================================================
   DADOS BÁSICOS
   ========================================================= */

IF NOT EXISTS (SELECT 1 FROM dbo.Perfis WHERE Nome = 'Administrador')
    INSERT INTO dbo.Perfis (Nome, Descricao)
    VALUES ('Administrador', 'Acesso completo ao SalesIn');

IF NOT EXISTS (SELECT 1 FROM dbo.Perfis WHERE Nome = 'Diretor Comercial')
    INSERT INTO dbo.Perfis (Nome, Descricao)
    VALUES ('Diretor Comercial', 'Visão executiva da operação comercial');

IF NOT EXISTS (SELECT 1 FROM dbo.Perfis WHERE Nome = 'Gerente Comercial')
    INSERT INTO dbo.Perfis (Nome, Descricao)
    VALUES ('Gerente Comercial', 'Gestão da equipe e carteira comercial');

IF NOT EXISTS (SELECT 1 FROM dbo.Perfis WHERE Nome = 'Analista de Dados')
    INSERT INTO dbo.Perfis (Nome, Descricao)
    VALUES ('Analista de Dados', 'Análises e inteligência comercial');

IF NOT EXISTS (SELECT 1 FROM dbo.Perfis WHERE Nome = 'Vendedor')
    INSERT INTO dbo.Perfis (Nome, Descricao)
    VALUES ('Vendedor', 'Operação da carteira de clientes');
GO


IF NOT EXISTS (SELECT 1 FROM dbo.CanaisVenda WHERE Nome = 'Distribuidor')
    INSERT INTO dbo.CanaisVenda (Nome)
    VALUES ('Distribuidor');

IF NOT EXISTS (SELECT 1 FROM dbo.CanaisVenda WHERE Nome = 'Empório')
    INSERT INTO dbo.CanaisVenda (Nome)
    VALUES ('Empório');

IF NOT EXISTS (SELECT 1 FROM dbo.CanaisVenda WHERE Nome = 'Restaurante')
    INSERT INTO dbo.CanaisVenda (Nome)
    VALUES ('Restaurante');

IF NOT EXISTS (SELECT 1 FROM dbo.CanaisVenda WHERE Nome = 'Mercado')
    INSERT INTO dbo.CanaisVenda (Nome)
    VALUES ('Mercado');

IF NOT EXISTS (SELECT 1 FROM dbo.CanaisVenda WHERE Nome = 'Venda Direta')
    INSERT INTO dbo.CanaisVenda (Nome)
    VALUES ('Venda Direta');
GO


/* =========================================================
   VALIDAÇÃO
   ========================================================= */

SELECT
    t.name AS Tabela
FROM sys.tables t
ORDER BY t.name;
GO