/* A base de código foi feita em SQL e PL/SQL através do software MySQL
    tentei estruturar de uma forma que fique estendível o passo a passo*/

-- criando um banco de dados para o projeto

create database estoque
    
-- usando o banco de dados para a criação das tabelas

use estoque
    
-- criando a tabela de produtos que serão registrados em sistema

create table produtos (id_produto int
                     , nome_produto varchar(100) not null
                     , categoria varchar(50)
                     , quantidade_estoque int not null
                     , disponibilidade varchar(50)
                      );
-- criação da chave primária para a tabela de produtos

alter table produtos
    modify id_produto int auto_increment,
    add constraint PK_produtos primary key (id_produto);
-- criando a tabela de funcionários que serão registrados em sistema

create table funcionarios (id_funcionario int
                         , nome_funcionario varchar(250) not null
                          );
-- criação da chave primária para a tabela de funcionários

alter table funcionarios
    modify id_funcionario int auto_increment,
    add constraint PK_funcionarios primary key (id_funcionario);
-- criando a tablea do histórico de retirada dos produtos pelos funcionários

create table retiradas (id_retirada int
                      , id_produto int not null
                      , id_funcionario int not null
                      , quantidade_retirada int not null
                      , data_retirada datetime not null
                       );
-- criação da chave primária para a tabela de retiradas

alter table retiradas
    modify id_retirada int auto_increment,
    add constraint PK_retiradas primary key (id_retirada);
-- adicionando as chaves estrangeiras dos produtos e dos funcionários

alter table retiradas
    add constraint FK_produto foreign key (id_produto) references produtos(id_produto);
alter table retiradas
    add constraint FK_funcionario foreign key (id_funcionario) references funcionarios(id_funcionario);



--consultando historico

SELECT
    r.id_retirada,
    p.nome_produto,
    f.nome_funcionario,
    r.quantidade_retirada,
    r.data_retirada
FROM retiradas r
INNER JOIN produtos p
    ON r.id_produto = p.id_produto
INNER JOIN funcionarios f
    ON r.id_funcionario = f.id_funcionario
ORDER BY r.data_retirada DESC;

UPDATE produtos
SET quantidade_estoque = quantidade_estoque - 5
WHERE id_produto = 1;

CREATE TRIGGER trg_baixa_estoque
AFTER INSERT ON retiradas
FOR EACH ROW
UPDATE produtos
SET quantidade_estoque = quantidade_estoque - NEW.quantidade_retirada
WHERE id_produto = NEW.id_produto;
