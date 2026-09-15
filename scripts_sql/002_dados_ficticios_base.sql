USE SalesIn;
GO

/* =========================================================
   SALESIN
   Dados Fictícios Iniciais - V1.0

   Todos os nomes e dados deste script são fictícios.
   ========================================================= */


/* =========================================================
   CATEGORIAS
   ========================================================= */

IF NOT EXISTS (SELECT 1 FROM dbo.CategoriasProduto WHERE Nome = 'Linguiças')
    INSERT INTO dbo.CategoriasProduto (Nome, Descricao)
    VALUES ('Linguiças', 'Linha de linguiças artesanais');

IF NOT EXISTS (SELECT 1 FROM dbo.CategoriasProduto WHERE Nome = 'Defumados')
    INSERT INTO dbo.CategoriasProduto (Nome, Descricao)
    VALUES ('Defumados', 'Produtos artesanais defumados');

IF NOT EXISTS (SELECT 1 FROM dbo.CategoriasProduto WHERE Nome = 'Curados')
    INSERT INTO dbo.CategoriasProduto (Nome, Descricao)
    VALUES ('Curados', 'Produtos de cura e maturação');

IF NOT EXISTS (SELECT 1 FROM dbo.CategoriasProduto WHERE Nome = 'Kits')
    INSERT INTO dbo.CategoriasProduto (Nome, Descricao)
    VALUES ('Kits', 'Kits comerciais e promocionais');
GO


/* =========================================================
   VENDEDORES
   ========================================================= */

IF NOT EXISTS (SELECT 1 FROM dbo.Vendedores WHERE Codigo = 'VEN001')
    INSERT INTO dbo.Vendedores
    (
        Codigo,
        Nome,
        Email,
        Telefone,
        Cargo,
        DataAdmissao
    )
    VALUES
    (
        'VEN001',
        'Mariana Alves',
        'mariana.alves@ficticio.com',
        '(11) 90000-1001',
        'Executiva Comercial',
        '2024-02-01'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Vendedores WHERE Codigo = 'VEN002')
    INSERT INTO dbo.Vendedores
    (
        Codigo,
        Nome,
        Email,
        Telefone,
        Cargo,
        DataAdmissao
    )
    VALUES
    (
        'VEN002',
        'Rafael Costa',
        'rafael.costa@ficticio.com',
        '(11) 90000-1002',
        'Executivo Comercial',
        '2023-08-15'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Vendedores WHERE Codigo = 'VEN003')
    INSERT INTO dbo.Vendedores
    (
        Codigo,
        Nome,
        Email,
        Telefone,
        Cargo,
        DataAdmissao
    )
    VALUES
    (
        'VEN003',
        'Bruno Martins',
        'bruno.martins@ficticio.com',
        '(11) 90000-1003',
        'Executivo Comercial',
        '2025-01-20'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Vendedores WHERE Codigo = 'VEN004')
    INSERT INTO dbo.Vendedores
    (
        Codigo,
        Nome,
        Email,
        Telefone,
        Cargo,
        DataAdmissao
    )
    VALUES
    (
        'VEN004',
        'Fernanda Lima',
        'fernanda.lima@ficticio.com',
        '(11) 90000-1004',
        'Executiva Comercial',
        '2024-06-10'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Vendedores WHERE Codigo = 'VEN005')
    INSERT INTO dbo.Vendedores
    (
        Codigo,
        Nome,
        Email,
        Telefone,
        Cargo,
        DataAdmissao
    )
    VALUES
    (
        'VEN005',
        'Lucas Ferreira',
        'lucas.ferreira@ficticio.com',
        '(11) 90000-1005',
        'Executivo Comercial',
        '2025-04-07'
    );
GO


/* =========================================================
   PRODUTOS
   ========================================================= */

DECLARE @Linguiças INT =
(
    SELECT CategoriaProdutoID
    FROM dbo.CategoriasProduto
    WHERE Nome = 'Linguiças'
);

DECLARE @Defumados INT =
(
    SELECT CategoriaProdutoID
    FROM dbo.CategoriasProduto
    WHERE Nome = 'Defumados'
);

DECLARE @Curados INT =
(
    SELECT CategoriaProdutoID
    FROM dbo.CategoriasProduto
    WHERE Nome = 'Curados'
);

DECLARE @Kits INT =
(
    SELECT CategoriaProdutoID
    FROM dbo.CategoriasProduto
    WHERE Nome = 'Kits'
);


IF NOT EXISTS (SELECT 1 FROM dbo.Produtos WHERE Codigo = 'PROD001')
    INSERT INTO dbo.Produtos
    VALUES
    (
        @Linguiças,
        'PROD001',
        'Linguiça Toscana Artesanal',
        'KG',
        39.90,
        23.50,
        1,
        SYSDATETIME(),
        NULL
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Produtos WHERE Codigo = 'PROD002')
    INSERT INTO dbo.Produtos
    (
        CategoriaProdutoID,
        Codigo,
        Nome,
        UnidadeMedida,
        PrecoLista,
        CustoPadrao
    )
    VALUES
    (
        @Linguiças,
        'PROD002',
        'Linguiça Calabresa Artesanal',
        'KG',
        42.90,
        24.80
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Produtos WHERE Codigo = 'PROD003')
    INSERT INTO dbo.Produtos
    (
        CategoriaProdutoID,
        Codigo,
        Nome,
        UnidadeMedida,
        PrecoLista,
        CustoPadrao
    )
    VALUES
    (
        @Linguiças,
        'PROD003',
        'Linguiça de Pernil',
        'KG',
        44.90,
        26.50
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Produtos WHERE Codigo = 'PROD004')
    INSERT INTO dbo.Produtos
    (
        CategoriaProdutoID,
        Codigo,
        Nome,
        UnidadeMedida,
        PrecoLista,
        CustoPadrao
    )
    VALUES
    (
        @Defumados,
        'PROD004',
        'Pancetta Defumada',
        'KG',
        69.90,
        41.00
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Produtos WHERE Codigo = 'PROD005')
    INSERT INTO dbo.Produtos
    (
        CategoriaProdutoID,
        Codigo,
        Nome,
        UnidadeMedida,
        PrecoLista,
        CustoPadrao
    )
    VALUES
    (
        @Defumados,
        'PROD005',
        'Costelinha Suína Defumada',
        'KG',
        54.90,
        34.00
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Produtos WHERE Codigo = 'PROD006')
    INSERT INTO dbo.Produtos
    (
        CategoriaProdutoID,
        Codigo,
        Nome,
        UnidadeMedida,
        PrecoLista,
        CustoPadrao
    )
    VALUES
    (
        @Curados,
        'PROD006',
        'Salame Italiano',
        'KG',
        89.90,
        52.00
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Produtos WHERE Codigo = 'PROD007')
    INSERT INTO dbo.Produtos
    (
        CategoriaProdutoID,
        Codigo,
        Nome,
        UnidadeMedida,
        PrecoLista,
        CustoPadrao
    )
    VALUES
    (
        @Curados,
        'PROD007',
        'Copa Curada',
        'KG',
        94.90,
        56.00
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Produtos WHERE Codigo = 'PROD008')
    INSERT INTO dbo.Produtos
    (
        CategoriaProdutoID,
        Codigo,
        Nome,
        UnidadeMedida,
        PrecoLista,
        CustoPadrao
    )
    VALUES
    (
        @Kits,
        'PROD008',
        'Kit Churrasco Premium',
        'UN',
        149.90,
        88.00
    );
GO


/* =========================================================
   CLIENTES
   ========================================================= */

DECLARE @VEN001 INT =
(
    SELECT VendedorID
    FROM dbo.Vendedores
    WHERE Codigo = 'VEN001'
);

DECLARE @VEN002 INT =
(
    SELECT VendedorID
    FROM dbo.Vendedores
    WHERE Codigo = 'VEN002'
);

DECLARE @VEN003 INT =
(
    SELECT VendedorID
    FROM dbo.Vendedores
    WHERE Codigo = 'VEN003'
);

DECLARE @VEN004 INT =
(
    SELECT VendedorID
    FROM dbo.Vendedores
    WHERE Codigo = 'VEN004'
);

DECLARE @VEN005 INT =
(
    SELECT VendedorID
    FROM dbo.Vendedores
    WHERE Codigo = 'VEN005'
);

DECLARE @Emporio INT =
(
    SELECT CanalVendaID
    FROM dbo.CanaisVenda
    WHERE Nome = 'Empório'
);

DECLARE @Mercado INT =
(
    SELECT CanalVendaID
    FROM dbo.CanaisVenda
    WHERE Nome = 'Mercado'
);

DECLARE @Restaurante INT =
(
    SELECT CanalVendaID
    FROM dbo.CanaisVenda
    WHERE Nome = 'Restaurante'
);

DECLARE @Distribuidor INT =
(
    SELECT CanalVendaID
    FROM dbo.CanaisVenda
    WHERE Nome = 'Distribuidor'
);


IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE Codigo = 'CLI001')
    INSERT INTO dbo.Clientes
    (
        VendedorID,
        CanalVendaID,
        Codigo,
        RazaoSocial,
        NomeFantasia,
        Documento,
        Segmento,
        Cidade,
        Estado,
        Regiao,
        Email,
        Telefone
    )
    VALUES
    (
        @VEN001,
        @Emporio,
        'CLI001',
        'Empório Vila Nova Alimentos Ltda',
        'Empório Vila Nova',
        '11.111.111/0001-01',
        'Empório',
        'São Paulo',
        'SP',
        'Sudeste',
        'compras@emporiovilanova.ficticio',
        '(11) 4000-1001'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE Codigo = 'CLI002')
    INSERT INTO dbo.Clientes
    (
        VendedorID,
        CanalVendaID,
        Codigo,
        RazaoSocial,
        NomeFantasia,
        Documento,
        Segmento,
        Cidade,
        Estado,
        Regiao
    )
    VALUES
    (
        @VEN001,
        @Mercado,
        'CLI002',
        'Mercado Santa Clara Ltda',
        'Mercado Santa Clara',
        '22.222.222/0001-02',
        'Supermercado',
        'Osasco',
        'SP',
        'Sudeste'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE Codigo = 'CLI003')
    INSERT INTO dbo.Clientes
    (
        VendedorID,
        CanalVendaID,
        Codigo,
        RazaoSocial,
        NomeFantasia,
        Documento,
        Segmento,
        Cidade,
        Estado,
        Regiao
    )
    VALUES
    (
        @VEN002,
        @Restaurante,
        'CLI003',
        'Bistrô Paulista Gastronomia Ltda',
        'Bistrô Paulista',
        '33.333.333/0001-03',
        'Restaurante',
        'São Paulo',
        'SP',
        'Sudeste'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE Codigo = 'CLI004')
    INSERT INTO dbo.Clientes
    (
        VendedorID,
        CanalVendaID,
        Codigo,
        RazaoSocial,
        NomeFantasia,
        Documento,
        Segmento,
        Cidade,
        Estado,
        Regiao
    )
    VALUES
    (
        @VEN002,
        @Distribuidor,
        'CLI004',
        'Distribuidora Horizonte Ltda',
        'Distribuidora Horizonte',
        '44.444.444/0001-04',
        'Distribuidor',
        'Campinas',
        'SP',
        'Sudeste'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE Codigo = 'CLI005')
    INSERT INTO dbo.Clientes
    (
        VendedorID,
        CanalVendaID,
        Codigo,
        RazaoSocial,
        NomeFantasia,
        Documento,
        Segmento,
        Cidade,
        Estado,
        Regiao
    )
    VALUES
    (
        @VEN003,
        @Emporio,
        'CLI005',
        'Casa Gourmet Santana Ltda',
        'Casa Gourmet Santana',
        '55.555.555/0001-05',
        'Empório',
        'São Paulo',
        'SP',
        'Sudeste'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE Codigo = 'CLI006')
    INSERT INTO dbo.Clientes
    (
        VendedorID,
        CanalVendaID,
        Codigo,
        RazaoSocial,
        NomeFantasia,
        Documento,
        Segmento,
        Cidade,
        Estado,
        Regiao
    )
    VALUES
    (
        @VEN003,
        @Mercado,
        'CLI006',
        'Rede Bom Sabor Comércio Ltda',
        'Rede Bom Sabor',
        '66.666.666/0001-06',
        'Supermercado',
        'Guarulhos',
        'SP',
        'Sudeste'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE Codigo = 'CLI007')
    INSERT INTO dbo.Clientes
    (
        VendedorID,
        CanalVendaID,
        Codigo,
        RazaoSocial,
        NomeFantasia,
        Documento,
        Segmento,
        Cidade,
        Estado,
        Regiao
    )
    VALUES
    (
        @VEN004,
        @Restaurante,
        'CLI007',
        'Casa do Churrasco Restaurante Ltda',
        'Casa do Churrasco',
        '77.777.777/0001-07',
        'Restaurante',
        'Santo André',
        'SP',
        'Sudeste'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE Codigo = 'CLI008')
    INSERT INTO dbo.Clientes
    (
        VendedorID,
        CanalVendaID,
        Codigo,
        RazaoSocial,
        NomeFantasia,
        Documento,
        Segmento,
        Cidade,
        Estado,
        Regiao
    )
    VALUES
    (
        @VEN004,
        @Emporio,
        'CLI008',
        'Empório Bela Serra Ltda',
        'Empório Bela Serra',
        '88.888.888/0001-08',
        'Empório',
        'Jundiaí',
        'SP',
        'Sudeste'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE Codigo = 'CLI009')
    INSERT INTO dbo.Clientes
    (
        VendedorID,
        CanalVendaID,
        Codigo,
        RazaoSocial,
        NomeFantasia,
        Documento,
        Segmento,
        Cidade,
        Estado,
        Regiao
    )
    VALUES
    (
        @VEN005,
        @Mercado,
        'CLI009',
        'Mercado Primavera Ltda',
        'Mercado Primavera',
        '99.999.999/0001-09',
        'Supermercado',
        'Sorocaba',
        'SP',
        'Sudeste'
    );


IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE Codigo = 'CLI010')
    INSERT INTO dbo.Clientes
    (
        VendedorID,
        CanalVendaID,
        Codigo,
        RazaoSocial,
        NomeFantasia,
        Documento,
        Segmento,
        Cidade,
        Estado,
        Regiao
    )
    VALUES
    (
        @VEN005,
        @Distribuidor,
        'CLI010',
        'Alimentos Vale Verde Distribuição Ltda',
        'Vale Verde Distribuição',
        '10.101.010/0001-10',
        'Distribuidor',
        'São José dos Campos',
        'SP',
        'Sudeste'
    );
GO


/* =========================================================
   METAS - SETEMBRO/2026
   ========================================================= */

INSERT INTO dbo.MetasVendedores
(
    VendedorID,
    Ano,
    Mes,
    MetaFaturamento,
    MetaMargem,
    MetaNovosClientes
)
SELECT
    VendedorID,
    2026,
    9,
    CASE Codigo
        WHEN 'VEN001' THEN 450000
        WHEN 'VEN002' THEN 420000
        WHEN 'VEN003' THEN 390000
        WHEN 'VEN004' THEN 410000
        WHEN 'VEN005' THEN 350000
    END,
    30,
    5
FROM dbo.Vendedores V
WHERE Codigo IN
(
    'VEN001',
    'VEN002',
    'VEN003',
    'VEN004',
    'VEN005'
)
AND NOT EXISTS
(
    SELECT 1
    FROM dbo.MetasVendedores M
    WHERE M.VendedorID = V.VendedorID
      AND M.Ano = 2026
      AND M.Mes = 9
);
GO


/* =========================================================
   VALIDAÇÃO
   ========================================================= */

SELECT COUNT(*) AS TotalVendedores
FROM dbo.Vendedores;

SELECT COUNT(*) AS TotalClientes
FROM dbo.Clientes;

SELECT COUNT(*) AS TotalProdutos
FROM dbo.Produtos;

SELECT COUNT(*) AS TotalMetas
FROM dbo.MetasVendedores;
GO