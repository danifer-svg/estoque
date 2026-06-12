/* A base de código foi feita em SQL e PL/SQL através do software para banco de dados MySQL.
    Tentei estruturar de uma forma que fique entendível o passo a passo*/

-- criando um banco de dados para o projeto

create database estoque;

-- usando o banco de dados para a criação das tabelas

use estoque;

-- criando a tabela de produtos que serão registrados em sistema

create table produtos (id_produto int
                     , nome_produto varchar(100) not null
                     , categoria varchar(50)
                     , quantidade_estoque int not null
                     , disponibilidade enum('Em estoque', 'Baixo estoque', 'Sem estoque') not null default 'Em estoque'
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

-- criando a tabela do histórico de retirada dos produtos pelos funcionários

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

-- criando uma trigger para a variação da disponibilidade do estoque, nos quais apresentarão resultados diferentes dependendo da quantidade em estoque

-- trigger para inserts

delimiter //

create trigger trg_disponibilidade_insert
before insert on produtos
for each row
begin
    if new.quantidade_estoque = 0 then
        set new.disponibilidade = 'Sem estoque';
    elseif new.quantidade_estoque <= 10 then
        set new.disponibilidade = 'Baixo estoque';
    else
        set new.disponibilidade = 'Em estoque';
    end if;
end//

delimiter ;

-- trigger para updates

delimiter //

create trigger trg_disponibilidade_update
before update on produtos
for each row
begin
    if new.quantidade_estoque = 0 then
        set new.disponibilidade = 'Sem estoque';
    elseif new.quantidade_estoque <= 10 then
        set new.disponibilidade = 'Baixo estoque';
    else
        set new.disponibilidade = 'Em estoque';
    end if;
end//

delimiter ;

/* A arquitetura do banco de dados já foi montada, essa parte seguinte é apenas para fins de testes para checar se o banco está funcionando perfeitamente */

-- inicialmente precisa iniciar a transação ANTES do INSERT para que esses dados não sofram autocommit

start transaction;

-- inserindo alguns dados como teste

-- produtos

insert into produtos
       (nome_produto
      , categoria
      , quantidade_estoque)
values ('Placa de vídeo RTX 3060 Ti', 'Hardware', 5)
     , ('Memória RAM 16GB DDR4', 'Hardware', 30)
     , ('SSD 1TB SATA', 'Hardware', 0)
     , ('Teclado mecânico Logitch', 'Periféricos', 25)
     , ('Mouse sem fio Logitech', 'Periféricos', 40);

/* pode-se perceber que não foram necessários inserts tanto no id quanto na disponibilidade
   pois esses sistemas já foram automatizados para que o autopreenchimento
   o id é autoincrementado
   a disponibilidade é preenchida dependendo de valores preenchidos na quantidade de estoque */

-- consultando a tabela de produtos

select * from produtos;

-- funcionários

insert into funcionarios 
       (nome_funcionario)
values ('Gabriel Retrocesso')
     , ('Dani Kio')
     , ('Dreliy Orphe');

-- consultando a tabela de funcionários

select * from funcionarios;

-- retiradas

insert into retiradas
       (id_produto
      , id_funcionario
      , quantidade_retirada
      , data_retirada)
values (1, 2, 2, sysdate())
     , (2, 1, 5, sysdate())
     , (4, 3, 1, sysdate())
     , (2, 2, 3, sysdate())
     , (5, 1, 4, sysdate())
     , (1, 3, 1, sysdate())
     , (4, 2, 2, sysdate())
     , (5, 3, 5, sysdate());

-- consultando a tabela de retiradas

select * from retiradas;

-- agora será feita a consulta do histórico para checar as retiradas através de uma query

select r.id_retirada as 'Número da retirada'
     , p.nome_produto as 'Nome do produto'
     , f.nome_funcionario as 'Nome do funcionário'
     , r.quantidade_retirada as 'Quantidade retirada'
     , r.data_retirada as 'Data de retirada'
    from retiradas r
inner join produtos p
    on r.id_produto = p.id_produto
inner join funcionarios f
    on r.id_funcionario = f.id_funcionario -- join entre as tabelas 
order by r.data_retirada desc;

-- para serem feitas limpezas nos inserts

rollback;

-- para salvar os dados inseridos

commit;

-- caso não seja feita a transação inicialmente pode ser realizado o seguinte comando para apagar tudo e recomeçar

set foreign_key_checks = 0;
truncate table produtos;
truncate table funcionarios;
truncate table retiradas;
set foreign_key_checks = 1;
