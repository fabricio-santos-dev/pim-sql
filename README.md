# Projeto Integrado Multidisciplinar

## PIM – Minerium (banco de dados)

Sistema de rastreabilidade por lote para uma mineradora fictícia de terras raras: do ponto de extração (mina) até o produto entregue ao cliente industrial.

Banco de dados em SQL Server (T-SQL), criado e testado no SQL Server Management Studio (SSMS).

Modelo (DER lógico)

## DER lógico

13 tabelas: Perfil, Permissao, Perfil_Permissao, Funcionario, Mina, Mineral, Lote, Historico_Lote, Produto, Cliente, Pedido_cliente, Entrega e Pagamento.

Cadeia de rastreabilidade: Mina + Mineral → Lote → Historico_Lote → Produto → Entrega → Pedido_cliente → Cliente.

**Como executar**

Pré-requisitos: SQL Server (a edição Express serve) e SSMS. Execute nesta ordem (SSMS: Arquivo > Abrir > Arquivo, depois F5).

O arquivo SQLQuery1.sql reúne, em ordem cronológica e comentados, todos os comandos usados na construção do banco (tabelas, correções, índices, views, procedure, dados, testes e backup), para consulta.

## Requisitos atendidos e onde está

RF01 Cadastro de lotes: tabela Lote (mina de origem, mineral, responsável, quantidade, unidade e data)

RF02 Identificação única: coluna calculada codigo_lote (LT-000001…) com UNIQUE

RF03 Cadastro de funcionários: tabela Funcionario

RF04 Controle de acesso:	Perfil, Permissao e Perfil_Permissao

RF05 Registro de etapas:	Historico_Lote e procedure sp_registrar_etapa

RF06 Atualização de status:	coluna Lote.status, atualizada pela procedure

RF07 Consulta de rastreabilidade:	view vw_rastreabilidade_lote

RF08 Cadastro de clientes:	Cliente, Pedido_cliente, Entrega e view vw_entregas_realizadas

RF09 Registro de quantidade:	qtd_movimentada e qtd_perda no histórico; quantidade em Produto e Entrega

RF10 Relatórios	views: vw_origem_materiais e vw_entregas_realizadas

RNF01 Segurança:	senha_hash (nunca texto puro)

RNF02 Integridade:	PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK (provados em testes.sql)

RNF06 Backup:	backup.sql

## DER:

<img width="2650" height="1760" alt="DER_Minerium" src="https://github.com/user-attachments/assets/eb2de785-940d-4d47-a70b-5e69c6789bfe" />

