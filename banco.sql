CREATE DATABASE Minerium;
GO

CREATE TABLE dbo.Perfil (
    id_perfil  INT IDENTITY(1,1) NOT NULL,
    nome       VARCHAR(50)  NOT NULL,
    descricao  VARCHAR(150) NULL,
    CONSTRAINT PK_Perfil      PRIMARY KEY (id_perfil),
    CONSTRAINT UQ_Perfil_nome UNIQUE (nome)
);
GO

CREATE TABLE dbo.Permissao (
    id_permissao INT IDENTITY(1,1) NOT NULL,
    nome         VARCHAR(50)  NOT NULL,
    descricao    VARCHAR(150) NULL,
    CONSTRAINT PK_Permissao      PRIMARY KEY (id_permissao),
    CONSTRAINT UQ_Permissao_nome UNIQUE (nome)
);
GO

CREATE TABLE dbo.Perfil_Permissao (
    id_perfil    INT NOT NULL,
    id_permissao INT NOT NULL,
    CONSTRAINT PK_Perfil_Permissao PRIMARY KEY (id_perfil, id_permissao),
    CONSTRAINT FK_PP_Perfil    FOREIGN KEY (id_perfil)    REFERENCES dbo.Perfil (id_perfil),
    CONSTRAINT FK_PP_Permissao FOREIGN KEY (id_permissao) REFERENCES dbo.Permissao (id_permissao)
);
GO

CREATE TABLE dbo.Funcionario (
    id_funcionario INT IDENTITY(1,1) NOT NULL,
    id_perfil      INT          NOT NULL,
    nome           VARCHAR(100) NOT NULL,
    login          VARCHAR(50)  NOT NULL,
    senha_hash     VARCHAR(255) NOT NULL,
    status         VARCHAR(20)  NOT NULL CONSTRAINT DF_Funcionario_status DEFAULT 'Ativo',
    CONSTRAINT PK_Funcionario        PRIMARY KEY (id_funcionario),
    CONSTRAINT UQ_Funcionario_login  UNIQUE (login),
    CONSTRAINT FK_Funcionario_Perfil FOREIGN KEY (id_perfil) REFERENCES dbo.Perfil (id_perfil),
    CONSTRAINT CK_Funcionario_status CHECK (status IN ('Ativo', 'Inativo'))
);
GO

CREATE TABLE dbo.Mina (
    id_mina     INT IDENTITY(1,1) NOT NULL,
    nome        VARCHAR(100) NOT NULL,
    localizacao VARCHAR(150) NULL,
    status      VARCHAR(20)  NOT NULL CONSTRAINT DF_Mina_status DEFAULT 'Ativa',
    CONSTRAINT PK_Mina        PRIMARY KEY (id_mina),
    CONSTRAINT UQ_Mina_nome   UNIQUE (nome),
    CONSTRAINT CK_Mina_status CHECK (status IN ('Ativa', 'Inativa'))
);
GO

CREATE TABLE dbo.Mineral 
    id_mineral INT IDENTITY(1,1) NOT NULL,
    nome       VARCHAR(100) NOT NULL,
    descricao  VARCHAR(MAX) NULL,
    CONSTRAINT PK_Mineral      PRIMARY KEY (id_mineral),
    CONSTRAINT UQ_Mineral_nome UNIQUE (nome)
);
GO

CREATE TABLE dbo.Lote (
    id_lote        INT IDENTITY(1,1) NOT NULL,
    id_mina        INT NOT NULL,
    id_mineral     INT NOT NULL,
    id_funcionario INT NOT NULL,
    codigo_lote    AS ('LT-' + RIGHT('000000' + CAST(id_lote AS VARCHAR(10)), 6)) PERSISTED NOT NULL,
    quantidade     DECIMAL(12,2) NOT NULL,
    unidade_medida VARCHAR(10)   NOT NULL CONSTRAINT DF_Lote_unidade DEFAULT 'kg',
    status         VARCHAR(30)   NOT NULL CONSTRAINT DF_Lote_status  DEFAULT 'Extraido',
    data_extracao  DATE          NOT NULL,
    data_cadastro  DATETIME      NOT NULL CONSTRAINT DF_Lote_data_cadastro DEFAULT GETDATE(),
    CONSTRAINT PK_Lote             PRIMARY KEY (id_lote),
    CONSTRAINT UQ_Lote_codigo      UNIQUE (codigo_lote),
    CONSTRAINT FK_Lote_Mina        FOREIGN KEY (id_mina)        REFERENCES dbo.Mina (id_mina),
    CONSTRAINT FK_Lote_Mineral     FOREIGN KEY (id_mineral)     REFERENCES dbo.Mineral (id_mineral),
    CONSTRAINT FK_Lote_Funcionario FOREIGN KEY (id_funcionario) REFERENCES dbo.Funcionario (id_funcionario),
    CONSTRAINT CK_Lote_quantidade  CHECK (quantidade > 0),
    CONSTRAINT CK_Lote_unidade     CHECK (unidade_medida IN ('kg', 'g', 't', 'un')),
    CONSTRAINT CK_Lote_status      CHECK (status IN ('Extraido', 'Em processamento', 'Armazenado', 'Transportado', 'Entregue'))
);
GO

SELECT name FROM sys.tables ORDER BY name;

SELECT name FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Lote');