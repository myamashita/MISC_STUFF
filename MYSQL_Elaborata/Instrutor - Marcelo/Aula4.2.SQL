mysql -uroot -pelaborata

create database bdBancoFake;
--Query OK, 1 row affected (0.00 sec)

use bdBancoFake;
--Database changed

drop   table if exists tbpessoas;
--Query OK, 0 rows affected, 1 warning (0.00 sec) 
create table tbpessoas(
  idpessoa int not null auto_increment,
  pessoa varchar(255) not null,
  tipo enum('pf', 'pj') not null,
  primary key (idpessoa)
);
--Query OK, 0 rows affected (0.08 sec)

drop   table if exists tbcontas;
--Query OK, 0 rows affected, 1 warning (0.00 sec) 
create table tbcontas(
  idconta   int not null auto_increment,
  idpessoa  int not null,
  nragencia varchar(20) not null,
  nrconta   varchar(20) not null,
  tipo      enum('cc', 'cp') not null,
  saldo     decimal (10, 2) not null,
  limite    decimal (10, 2) not null default 0,
  primary key (idconta)
);
--Query OK, 0 rows affected (0.08 sec)

drop table if exists tbmovimentos;
--Query OK, 0 rows affected, 1 warning (0.00 sec)
create table tbmovimentos(
  idmovimento int not null auto_increment,
  idconta int not null,
  datamovimento date not null,
  valor decimal (10, 2) not null,
  tipo enum('c', 'd'),
  primary key (idmovimento)
);
--Query OK, 0 rows affected (0.08 sec)
show tables;
describe tbpessoas;
describe tbcontas;
describe tbmovimentos;

alter table tbmovimentos change tipo tipo enum('c', 'd') not null;
--Query OK, 0 rows affected (0.21 sec)
--Records: 0  Duplicates: 0  Warnings: 0

alter table tbcontas add foreign key (idpessoa)
references tbpessoas (idpessoa);
--Query OK, 0 rows affected (0.17 sec)
--Records: 0  Duplicates: 0  Warnings: 0

alter table tbmovimentos add foreign key (idconta)
references tbcontas (idconta);
--Query OK, 0 rows affected (0.14 sec)
--Records: 0  Duplicates: 0  Warnings: 0


create index idx_pessoa_pessoa on tbpessoas (pessoa);
--Query OK, 0 rows affected (0.16 sec)
--Records: 0  Duplicates: 0  Warnings: 0
create index idx_movimento_data on tbmovimentos (datamovimento);
--Query OK, 0 rows affected (0.14 sec)
--Records: 0  Duplicates: 0  Warnings: 0
create index idx_movimento_tipo on tbmovimentos (tipo);
--Query OK, 0 rows affected (0.15 sec)
--Records: 0  Duplicates: 0  Warnings: 0

create unique index idx_contas_nrc_nra on tbcontas (nrconta, nragencia);
--Query OK, 0 rows affected (0.14 sec)
--Records: 0  Duplicates: 0  Warnings: 0

show index in tbmovimentos;


delimiter $$
drop   trigger trmovimentosAI$$
create trigger trmovimentosAI After Insert on tbmovimentos for each row
begin
  update tbcontas set saldo = saldo + new.valor where idconta = new.idconta;
end$$
delimiter ;

delimiter $$
drop   trigger trmovimentosAD$$
create trigger trmovimentosAD After Delete on tbmovimentos for each row
begin
  update tbcontas set saldo = saldo - old.valor where idconta = old.idconta;
end$$
delimiter ;

delimiter $$
drop   trigger trmovimentosAU$$
create trigger trmovimentosAU After Update on tbmovimentos for each row
begin
  update tbcontas set saldo = saldo + new.valor where idconta = new.idconta;
  update tbcontas set saldo = saldo - old.valor where idconta = old.idconta;
end$$
delimiter ;


insert into tbpessoas 
  (pessoa, tipo)
values
  ('marcelo', 1),
  ('hulk', 1),
  ('vingadores', 2),
  ('liga da justiça', 2),
  ('thundercats', 2),
  ('chuck norris', 1);
  
select * from tbpessoas;
+----------+------------------+------+
| idpessoa | pessoa           | tipo |
+----------+------------------+------+
|        1 | marcelo          | pf   |
|        2 | hulk             | pf   |
|        3 | vingadores       | pj   |
|        4 | liga da justiça  | pj   |
|        5 | thundercats      | pj   |
|        6 | chuck norris     | pf   |
+----------+------------------+------+

insert into tbcontas values
(null, 1, '3366-x', '5544-2', 1, 10000.00, 2000.00),
(null, 4, '3366-x', '8888-7', 1, 80000.00, 8000.00),
(null, 1, '3366-x', '5544-9', 1, 15000.00, 3000.00),
(null, 6, '5522-8', '8877-2', 2, 100000.00, 20000.00),
(null, 1, '5599-4', '3333-3', 2, 12000.00, 2500.00);


insert into tbcontas values
(null, 3, '4444-x', '5544-2', 1, 40000.00, 1000.00),
(null, 2, '5555-x', '8788-3', 2, 20000.00, 2000.00),
(null, 4, '3366-x', '8884-9', 1, 5000.00, 5000.00),
(null, 5, '5522-8', '8847-9', 2, 150000.00, 10000.00),
(null, 2, '5599-4', '3563-x', 1, 12000.00, 1500.00);
  
select * from tbcontas;


--Stored procedure para realizar movimentações
delimiter $$
drop procedure if exists spmovimenta$$
create procedure spmovimenta(idc int, dt date, vl decimal (10, 2), tp int)
begin
    declare total decimal(10, 2);
    select (saldo + limite) into total from tbcontas where idconta = idc;
    if (tp = 2) and (total < vl*-1) then
      select 'ERRO! Saldo Insuficiente!' ALERTA;
    else
      insert into tbmovimentos 
	(idconta, datamovimento, valor, tipo)
      values
	(idc, dt, vl, tp);
    end if;
end$$
delimiter ;


call spmovimenta(1, CurDate(), -2566.22, 2);
--Query OK, 0 rows affected (0.00 sec)

call spmovimenta(4, CurDate(), 5698.13, 1);
--Query OK, 0 rows affected (0.00 sec)

call spmovimenta(1, CurDate(), -25000.00, 2);
+---------------------------+
| ALERTA                    |
+---------------------------+
| ERRO! Saldo Insuficiente! |
+---------------------------+


--Função para retornar o Valor total em determinada conta
delimiter $$
drop   function if exists ftotalconta$$
create function ftotalconta(idc int) returns decimal (10, 2)
begin
  declare total decimal (10, 2);
  select (saldo + limite) into total from tbcontas where idconta = idc;
  return total;
end$$
delimiter ;

select ftotalconta(3) SALDO_TOTAL;
+-------------+
| SALDO_TOTAL |
+-------------+
|    18000.00 |
+-------------+

select idconta, ftotalconta(idconta) SALDO_TOTAL from tbcontas order by idconta;
+---------+-------------+
| idconta | SALDO_TOTAL |
+---------+-------------+
|       1 |     9433.78 |
|       2 |    88000.00 |
|       3 |    18000.00 |
|       4 |   125698.13 |
|       5 |    14500.00 |
|       6 |    41000.00 |
|       7 |    22000.00 |
|       8 |    10000.00 |
|       9 |   160000.00 |
|      10 |    13500.00 |
+---------+-------------+
10 rows in set (0.00 sec)


select idconta, saldo, limite, ftotalconta(idconta) SALDO_TOTAL from tbcontas order by idconta;
+---------+-----------+----------+-------------+
| idconta | saldo     | limite   | SALDO_TOTAL |
+---------+-----------+----------+-------------+
|       1 |   7433.78 |  2000.00 |     9433.78 |
|       2 |  80000.00 |  8000.00 |    88000.00 |
|       3 |  15000.00 |  3000.00 |    18000.00 |
|       4 | 105698.13 | 20000.00 |   125698.13 |
|       5 |  12000.00 |  2500.00 |    14500.00 |
|       6 |  40000.00 |  1000.00 |    41000.00 |
|       7 |  20000.00 |  2000.00 |    22000.00 |
|       8 |   5000.00 |  5000.00 |    10000.00 |
|       9 | 150000.00 | 10000.00 |   160000.00 |
|      10 |  12000.00 |  1500.00 |    13500.00 |
+---------+-----------+----------+-------------+
10 rows in set (0.00 sec)

--View para listar todas as contas cadastradas
drop   view if exists vwInfoContas;
create view vwInfoContas as
select p.pessoa Pessoa, p.tipo TIPO, c. nrconta Conta, c.nragencia Agência, c.saldo Saldo, c.limite Limite, ftotalconta(c.idconta) TOTAL
from tbpessoas p inner join tbcontas c on (p.idpessoa = c.idpessoa)
order by Pessoa;

select * from vwInfoContas;

--Stored procedure para listar todas as movimentações de determinada conta com valor de lançamento acumulado

delimiter $$
drop   procedure if exists spInfoMovimentos$$
create procedure spInfoMovimentos(idc int)
begin
  declare linha int;
  declare total decimal (10, 2);
  set @linha = 0;
  set @total = 0.00;
  select @linha := @linha + 1 'LINHA', c.nrconta 'CONTA', c.nragencia 'AGẼNCIA',
  m.datamovimento 'DATA', m.valor 'VALOR', m.tipo 'TIPO', truncate(@total := @total + m.valor, 2) 'TOTAL'
  from tbcontas c inner join tbmovimentos m on (c.idconta = m.idconta);  
end$$
delimiter ;


call spmovimenta(1, CurDate(), -200.00, 2);
call spmovimenta(1, CurDate(), 300.00, 1);
call spmovimenta(1, CurDate(), -120.00, 2);
call spmovimenta(1, CurDate(), 400.00, 1);
call spmovimenta(1, CurDate(), 33.00, 1);


call spInfoMovimentos(1);




