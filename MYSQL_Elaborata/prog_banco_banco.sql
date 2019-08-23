INmysql -uroot -pelaborata

create database bdBancoFake;
--Query OK, 1 row affected (0.00 sec)

use bdBancoFake;
--Database changed

drop    table    if exists    tbpessoas;
create  table    tbpessoas(
  idpessoa  int      not null auto_increment,
  pessoa    varchar(255) not null,
  tipo      enum('pf','pj') not null,
  primary key (idpessoa)
);
--Query OK, 0 rows affected (0.06 sec)

drop    table    if exists    tbcontas;
create  table    tbcontas(
  idconta   int      not null auto_increment,
  idpessoa  int not null,
  nragencia varchar(20) not null,
  nrconta   varchar(20) not null,
  tipo      enum('cc','cp'),
  saldo     decimal(10,2) not null,
  limite    decimal(10,2) not null default 0,
  primary key (idconta)
);
--Query OK, 0 rows affected (0.06 sec)

drop    table    if exists    tbmovimentacoes;
create  table    tbmovimentacoes(
  idmovimento int not null auto_increment,
  idconta int not null,
  datamovimento date not null,
  valor decimal(10,2) not null,
  tipo enum('c','d') not null,
  primary key (idmovimento)
);
--Query OK, 0 rows affected (0.06 sec)

show tables;
describe tbpessoas;
describe tbcontas;
describe tbmovimentacoes;

-- propósito enum da tbcontas não tem not null
alter table tbcontas change tipo tipo enum('cc','cp') not null;
-- Query OK, 0 rows affected (0.15 sec)
-- Records: 0  Duplicates: 0  Warnings: 0

-- colocar chaves estrangeiras
alter table tbcontas add foreign key (idpessoa)
references tbpessoas (idpessoa);
-- Query OK, 0 rows affected (0.15 sec)
-- Records: 0  Duplicates: 0  Warnings: 0

alter table tbmovimentacoes add foreign key (idconta)
references tbcontas (idconta);
-- Query OK, 0 rows affected (0.13 sec)
-- Records: 0  Duplicates: 0  Warnings: 0

-- criando index
create index idx_pessoa_pessoa on tbpessoas(pessoa);
-- Query OK, 0 rows affected (0.14 sec)
-- Records: 0  Duplicates: 0  Warnings: 0

create index idx_movimento_data on tbmovimentacoes(datamovimento);
-- Query OK, 0 rows affected (0.13 sec)
-- Records: 0  Duplicates: 0  Warnings: 0

create index idx_movimento_tipo on tbmovimentacoes(tipo);
-- Query OK, 0 rows affected (0.11 sec)
-- Records: 0  Duplicates: 0  Warnings: 0

create unique index idx_contas_nrc_nr1 on tbcontas(nrconta, nragencia);
--Query OK, 0 rows affected (0.14 sec)
--Records: 0  Duplicates: 0  Warnings: 0

show index in tbpessoas;
show index in tbmovimentacoes;
show index in tbcontas;

-- Trigger after insert n>>1
delimiter $$
drop trigger if exists trmovimentosAI$$
create trigger trmovimentosAI after insert on tbmovimentacoes for each row
begin
  update tbcontas set saldo = saldo + new.valor where idconta = new.idconta;
end$$
delimiter ;

--Query OK, 0 rows affected (0.08 sec)

-- Trigger after delete n>>1
delimiter $$
drop trigger if exists trmovimentosAD$$
create trigger trmovimentosAD after delete on tbmovimentacoes for each row
begin
  update tbcontas set saldo = saldo - old.valor where idconta = old.idconta;
end$$
delimiter ;

--Query OK, 0 rows affected (0.04 sec)

-- Trigger after update n>>1
delimiter $$
drop trigger if exists trmovimentosAU$$
create trigger trmovimentosAU after update on tbmovimentacoes for each row
begin
  update tbcontas set saldo = saldo + new.valor where idconta = new.idconta;
  update tbcontas set saldo = saldo - old.valor where idconta = old.idconta;
end$$
delimiter ;

--Query OK, 0 rows affected (0.05 sec)

show triggers in bdBancoFake;

insert into tbpessoas(pessoa, tipo)
values ('marcelo', 1),
       ('hulk', 1),
       ('vingadores', 2),
       ('thundercats', 2),
       ('liga da justiça', 2),
       ('chuck', 1);

select * from tbpessoas;
--+----------+------------------+------+
--| idpessoa | pessoa           | tipo |
--+----------+------------------+------+
--|        1 | marcelo          | pf   |
--|        2 | hulk             | pf   |
--|        3 | vingadores       | pj   |
--|        4 | thundercats      | pj   |
--|        5 | liga da justiça  | pj   |
--|        6 | chuck            | pf   |
--+----------+------------------+------+
--6 rows in set (0.00 sec)

insert into tbcontas values
(null, 1, '3366-x', '5544-2', 1, 10000.00, 2000.00),
(null, 5, '3366-x', '8875-5', 1, 40000.00, 8000.00),
(null, 6, '9999-x', '9999-9', 1, 99999.00, 9.99),
(null, 3, '3166-4', '5758-2', 1, 10.00, 200.00);

select * from tbcontas;
--+---------+----------+-----------+---------+------+----------+---------+
--| idconta | idpessoa | nragencia | nrconta | tipo | saldo    | limite  |
--+---------+----------+-----------+---------+------+----------+---------+
--|       1 |        1 | 3366-x    | 5544-2  | cc   | 10000.00 | 2000.00 |
--|       2 |        5 | 3366-x    | 8875-5  | cc   | 40000.00 | 8000.00 |
--|       3 |        6 | 9999-x    | 9999-9  | cc   | 99999.00 |    9.99 |
--|       4 |        3 | 3166-4    | 5758-2  | cc   |    10.00 |  200.00 |
--+---------+----------+-----------+---------+------+----------+---------+
--4 rows in set (0.00 sec)

insert into tbcontas values
(null, 1, '3366-x', '554-2', 2, 10000.00, 2000.00),
(null, 5, '336-x', '8455-5', 2, 40000.00, 8000.00),
(null, 6, '99-x', '999-9', 2, 99999.00, 9.99),
(null, 3, '3266-4', '758-2', 2, 10.00, 200.00);

-- stored procedure para realizar movintações
delimiter $$
drop procedure if exists spmovimenta$$
create procedure spmovimenta(idc int, dt date, vl decimal (10,2), tp int)
begin
  declare total decimal(10,2);
  select (saldo + limite) into total from tbcontas where idconta = idc;
  if (tp = 2) and (total < vl*-1) then
    select 'Erro! Saldo Insulficiente!' ALERTA;
  else
    insert into tbmovimentacoes (idconta, datamovimento, valor, tipo)
    values(idc,dt,vl,tp);
  end if;
end$$
delimiter ;

--Query OK, 0 rows affected (0.00 sec)

call spmovimenta(1, curdate(), -8000.00, 2);
--Query OK, 1 row affected (0.04 sec)


-- funcao para retornar o valor total em determinada conta
delimiter $$
drop function if exists ftotalconta$$
create function ftotalconta(idc int) returns decimal(10,2)
begin
  declare total decimal (10,2);
  select (saldo + limite) into total from tbcontas where idconta = idc;
  return total;
end$$
delimiter ;


select ftotalconta(3) DISPONIVEL;
--+------------+
--| DISPONIVEL |
--+------------+
--|  100008.99 |
--+------------+
--1 row in set (0.00 sec)


select idconta, ftotalconta(idconta) DISPONIVEL from tbcontas order by idconta;
--
--+---------+------------+
--| idconta | DISPONIVEL |
--+---------+------------+
--|       1 |    4000.00 |
--|       2 |   48000.00 |
--|       3 |  100008.99 |
--|       4 |     210.00 |
--|       9 |   12000.00 |
--|      10 |   48000.00 |
--|      11 |  100008.99 |
--|      12 |     210.00 |
--+---------+------------+
--8 rows in set (0.00 sec)

select idconta, saldo, limite, ftotalconta(idconta) DISPONIVEL from tbcontas order by idconta;
--
--+---------+----------+---------+------------+
--| idconta | saldo    | limite  | DISPONIVEL |
--+---------+----------+---------+------------+
--|       1 |  2000.00 | 2000.00 |    4000.00 |
--|       2 | 40000.00 | 8000.00 |   48000.00 |
--|       3 | 99999.00 |    9.99 |  100008.99 |
--|       4 |    10.00 |  200.00 |     210.00 |
--|       9 | 10000.00 | 2000.00 |   12000.00 |
--|      10 | 40000.00 | 8000.00 |   48000.00 |
--|      11 | 99999.00 |    9.99 |  100008.99 |
--|      12 |    10.00 |  200.00 |     210.00 |
--+---------+----------+---------+------------+
--8 rows in set (0.00 sec)

-- create view
-- listar todas as contas cadastradas
drop view if exists vwInfocontas;
create view vwInfocontas as
select p.pessoa Pessoa, p.tipo TIPO, c.nrconta 'CONTA', c.nragencia 'AGENCIA', c.saldo SALDO, c.limite LIMITE, ftotalconta(c.idconta) TOTAL 
from tbpessoas p inner join tbcontas c on  p.idpessoa =  c.idpessoa
order by Pessoa;

select * from vwInfocontas;

-- create store procedure
-- Listar todas as movimentações de determinada conta com valor de lançamento acumulado
delimiter $$
drop procedure if exists spAcumulado$$
create procedure spAcumulado(idc int)
begin
  declare linha int;
  declare total decimal(10,2);
  set @linha = 0;
  set @total = 0.00;
  select @linha := @linha + 1 'LINHA', c.nrconta 'CONTA', c.nragencia 'AGENCIA', m.datamovimento 'DATA', m.valor 'VALOR', m.tipo 'TIPO'
  ,@total := @total + m.valor 'Total'
  from tbcontas c inner join tbmovimentacoes m on (c.idconta = m.idconta) ;
  
end$$
delimiter ;



call spmovimenta(1, curdate(), 800.00, 1);
call spmovimenta(1, curdate(), -10.00, 2);
call spmovimenta(1, curdate(), -85.0, 2);
call spmovimenta(1, curdate(), 800.00, 1);
call spmovimenta(1, curdate(), -1.00, 2);


select * from tbmovimentacoes;


call spAcumulado(1);

