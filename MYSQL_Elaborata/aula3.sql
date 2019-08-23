-- AUla 3
 mysql -uroot -pelaborata

 -- show databases
 show databases;
 
 --usando banco
use bdfunc;

describe vwInfoFuncs;

-- aula 3
--criando logins funcionario 6
insert into tblogins (idfuncionario, login, senha, acesso)
values (6, 'super-man', password('super-homem'),1);

-- como já esta cadastrado fazer um update

--verificando
select * from tblogins where (login= 'super-man') and (senha = 'super-homem');

Empty set (0.00 sec)

-- usando a mesma codificação
select * from tblogins where (login= 'super-man') and (senha = password( 'super-homem'));


-- store procedure para fazer pagamentos de todos os funcionarios
--em determinada data

-- 1 selecionar informações necessarias id funcionario, idsetor, idcargo e salario
select f.idfuncionario, f.idsetor, f.idcargo, f.salario from tbfuncionarios f;

--  id funcionario, idsetor, idcargo data e salario
select f.idfuncionario, f.idsetor, f.idcargo, '2015-09-05' DATA, f.salario from tbfuncionarios f;

-- criando store procedure
-- parametro de entrada data
--###############################******###############********
-- OBS sempre que realizarmos um INSERT a partir de um SELECT (como o modelo abaixo), NÃO utilizamos a palavra VALUES

delimiter $$
drop procedure if exists spRealizaPagamentos$$
create procedure spRealizaPagamentos (dt date)
begin
  insert into tbpagamentos(idfuncionario, idsetor, idcargo, datapagamento, salario)
  (select f.idfuncionario, f.idsetor, f.idcargo, dt, f.salario from tbfuncionarios f);
end$$
delimiter ;

--executando o procedimento spRealizaPagamentos
call spRealizaPagamentos('2015-09-30');

select * from tbpagamentos;


-- Tenho salario NULL então efetuado um if
delimiter $$
drop procedure if exists spRealizaPagamentos$$
create procedure spRealizaPagamentos (dt date)
begin
  insert into tbpagamentos(idfuncionario, idsetor, idcargo, datapagamento, salario)
  (select f.idfuncionario, f.idsetor, f.idcargo, dt, if(isnull(f.salario), 0.00, f.salario) from tbfuncionarios f);
end$$
delimiter ;

--executando o procedimento spRealizaPagamentos
call spRealizaPagamentos('2015-10-01');

select * from tbpagamentos;

--
select * from tbprodutos;

-- Dtore procedure para listar as informações de produtos com as linhas numeradas

delimiter $$
drop procedure if exists spInfoProduto$$
create procedure spInfoProduto()
begin
  declare linha int;
  set @linha = 0 ;
  select @linha := @linha + 1 'Linha', p.* from tbprodutos p;
end$$
delimiter ;
--executando o procedimento spInfoProduto
call spInfoProduto();




--***
--tip usa a variavel declarada
set @linha = 0;

-- criar um store procedure para listar as seguintes informações
-- numero da linha, funcionario, cargo, setor, salario, ferias R$, abono (20% ou 15% do salario) e total a receber

-- abono 20% salario ate 2000,00 e 15 para acima.

-- criar o select
select f.funcionario, c.cargo, s.setor, f.salario, 1/3*f.salario 'Férias R$ ', if(f.salario>2000.00, 0.15*f.salario, 0.2*f.salario) Abono, (f.salario + 1/3*f.salario + if(f.salario>2000.00, 0.15*f.salario, 0.2*f.salario) ) 'Total' 
from tbfuncionarios f inner join tbcargos c on c.idcargo = f.idcargo
 inner join tbsetores s on s.idsetor = f.idsetor;
--

--


delimiter $$
drop procedure if exists spFinaldeAno$$
create procedure spFinaldeAno()
begin
  declare linha int;
  set @linha =0;
  select @linha := @linha + 1 'Linha', f.funcionario, c.cargo, s.setor, f.salario, truncate(1/3*f.salario,2) 'Férias R$ ', truncate(if(f.salario>2000.00, 0.15*f.salario, 0.2*f.salario),2) Abono,  truncate((f.salario + 1/3*f.salario + if(f.salario>2000.00, 0.15*f.salario, 0.2*f.salario) ),2) 'Total' 
from tbfuncionarios f inner join tbcargos c on c.idcargo = f.idcargo
 inner join tbsetores s on s.idsetor = f.idsetor;

end$$
delimiter ;

-- Fazer alguns updates de salarios
call spalterarsalario(2,1900.00);
call spalterarsalario(3,500.00);
call spalterarsalario(4,1500.00);


call spFinaldeAno;



-- Tarde
-- Mostra os procedimentos ativos
show procedure status;

--
show create procedure spFinaldeAno;

show create table tbfuncionarios;

-- criando transações
--se não der comando será autocommit
start transaction; 
select * from tbcargos;
insert into tbcargos (cargo) values('novo_cargo');
select * from tbcargos;

-- Desfaz tudo o que foi alterado 
rollback;

--
start transaction; --se não der comando será autocommit

insert into tbcargos (cargo) values('novo_cargo');
commit;
select * from tbcargos;

-- FUNCÔES
 -- Criando uma função que retorne a soma dos salarios de determinado funcionario
 
delimiter $$
drop function if exists fSomaSalario$$
create function fSomaSalario(idf int) returns decimal (10,2)
begin
  declare soma decimal(10,2);
  select sum(salario) into @soma from tbpagamentos where idfuncionario = idf;
  return @soma;
end$$
delimiter ;


-- acessando a function recem criada

select fSomaSalario(1) 'Total Salários';

select concat('R$ ', fSomaSalario(1)) 'Total Salários';

select f.funcionario, fSomaSalario(f.idfuncionario) 'Total Salários'
from tbfuncionarios f;

show function status;
show create function fSomaSalario;

-- Testando se ela se torna GLOBAL
delimiter $$
drop function if exists fSomar$$
create function fSomar(x int , y int) returns int
begin
  declare soma int;
  set @soma = x + y;
  return @soma;
end$$
delimiter ;

select fSomar(9,5);
+-------------+
| fSomar(9,5) |
+-------------+
|          14 |
+-------------+
1 row in set (0.00 sec)

show create function fSomar;

use bdmun
select fSomar(9,5);
ERROR 1305 (42000): FUNCTION bdmun.fSomar does not exist

-- A função esta em outro banco bdfunc

select bdfunc.fSomar(9,5);

+--------------------+
| bdfunc.fSomar(9,5) |
+--------------------+
|                 14 |
+--------------------+
1 row in set (0.00 sec)


--
select month(curdate());



-- criar uma função que receba parametro de entrada uma data e retorne
-- a soma dos salarios do mes e ano especifico da data informada

delimiter $$
drop function if exists fSomadomes$$
create function fSomadomes(data date) returns decimal(10,2)
begin
  declare gasto decimal(10,2);
  select sum(p.salario) into gasto from tbpagamentos p 
  where (month(p.datapagamento) =  month(data))
  and (year(p.datapagamento) =  year(data));
  return gasto;
  
end$$
delimiter ;


select fSomadomes(curdate()) 'Gasto do mês';

select datapagamento from tbpagamentos;

select distinct(datapagamento) from tbpagamentos;

select month(t.datapagamento) 'Mês', year(t.datapagamento) 'Ano', fSomadomes(t.datapagamento) from (select distinct(datapagamento) from tbpagamentos) t;

-- consulta para listar as seguintes informações
-- funcionario, setor do funcionario, cargo, setor da despesa, data da despesa e valor da despesa

select f.funcionario 'funcionario', s.setor 'setor do funcionario',
c.cargo 'cargo', sd.setor 'Setor de despesa',
d.datadespesa 'Data', d.valordespesa 'Valor'
from tbfuncionarios f inner join tbsetores s on s.idsetor = f.idsetor
inner join tbcargos c on c.idcargo = f.idcargo
inner join tbdespesas d on f.idfuncionario = d.idfuncionario 
inner join tbsetores sd on sd.idsetor = d.idsetor;

--TRIGGER
-- se a trigger for insert new
-- se a trigger for update old
-- se a trigger for delete new e old

-- Trigger são possiveis até 6 triggers distintas 
-- para cada tabela do banco:

-- Before Insert
-- Before Update
-- Before Delete
-- After Insert
-- After Update
-- After Delete

-- Criando uma trigger para Atualizar o Orçamento de determinado setor
-- sempre que uma nova despesa for realizada
-- Obs: Trigger é executada automaticamente após um evento Insert, Update ou Delete

delimiter $$
drop trigger if exists trDespesasAI$$
create trigger trDespesasAI After Insert on tbdespesas for each row
begin
    update tbsetores set orcamento = orcamento - new.valordespesa
    where (idsetor = new.idsetor);

end$$
delimiter ;

select * from tbdespesas;
select * from tbsetores;
+---------+------------+-----------+                                                   
| idsetor | setor      | orcamento |
+---------+------------+-----------+
|       1 | compras    |      NULL |
|       2 | estoque    |      NULL |
|       3 | vendas     |      NULL |
|       4 | negocios   |      NULL |
|       5 | Novo Setor |  12566.55 |
|       6 | RH         |  12566.55 |
+---------+------------+-----------+
6 rows in set (0.00 sec)

-- Lançando uma nova despesa setor 6 RH id funcionario 6 

insert into tbdespesas(idfuncionario,idsetor,datadespesa,valordespesa,descricao)
values(6,6,curdate(),21453.88,'papel');

select * from tbdespesas;
select * from tbsetores;


-- Trigger para atualizar o orcamento de determinado setor sempre que uma despesa for exluída
delimiter $$
drop trigger if exists trDespesasAD$$
create trigger trDespesasAD After Delete on tbdespesas for each row
begin
  update tbsetores set orcamento = orcamento + old.valordespesa
  where idsetor = old.idsetor;
end$$
delimiter ;

delete from tbdespesas where iddespesa=3;
delete from tbdespesas where iddespesa=9;
delete from tbdespesas where iddespesa=8;

insert into tbdespesas(idfuncionario,idsetor,datadespesa,valordespesa,descricao)
values(6,6,curdate(),21453.88,'papel');

-- Trigger para atualizar a tabela de setores sempre que uma despesa
-- for atualizada

delimiter $$
drop trigger if exists trDespesasAU$$
create trigger trDespesasAU After update on tbdespesas for each row
begin
 update tbsetores set orcamento = orcamento + old.valordespesa
 where idsetor = old.idsetor;
 update tbsetores set orcamento = orcamento - new.valordespesa
 where idsetor = new.idsetor;
end$$
delimiter ;

select * from tbdespesas;
select * from tbsetores;

-- a despesa 10 é do setor 5 ao inves do setor 6
update tbdespesas set idsetor = 5 where iddespesa=10;


-- trigger para a tabela de setores, para bloquear criação de setores com Orçamento negativo

delimiter $$
drop trigger if exists trDespesasBI$$
create trigger trSetoresBI Before Insert on tbsetores for each row
begin
  if (new.orcamento < 0) then
    set new.setor = null;
  end if;
end$$
delimiter ;

select * from tbsetores;

insert into tbsetores (setor, orcamento)
values ('setor x', -98.00);


-----
-- criando trigger em tabela de compras para atualizar estoque na tabela de produtos

delimiter $$
drop trigger if exists trDetcomprasAI$$
create trigger trDetcomprasAI after Insert on tbdetcompras for each row
begin
  update tbprodutos set estoque = estoque + new.quantidade
  where idproduto = new.idproduto;
end$$
delimiter ;


delimiter $$
drop trigger if exists trDetcomprasAD$$
create trigger trDetcomprasAD after delete on tbdetcompras for each row
begin
  update tbprodutos set estoque = estoque - old.quantidade
  where idproduto = old.idproduto;
end$$
delimiter ;


delimiter $$
drop trigger if exists trDetcomprasAU$$
create trigger trDetcomprasAU after update on tbdetcompras for each row
begin
  update tbprodutos set estoque = estoque - old.quantidade
  where idproduto = old.idproduto;
  update tbprodutos set estoque = estoque + new.quantidade
  where idproduto = new.idproduto;
end$$
delimiter ;

-- fazer testes
select * from tbdetcompras;
select * from tbprodutos;
+-----------+------------+---------+--------------+
| idproduto | produto    | estoque | valorproduto |
+-----------+------------+---------+--------------+
|         1 | mouse      |    1000 |        15.00 |
|         2 | teclado    |    1000 |        95.60 |
|         3 | webcam     |    NULL |         NULL |
|         4 | monitor    |     300 |       750.00 |
|         5 | monitor_15 |     250 |         NULL |
|         6 | monitor_19 |     300 |       850.00 |
+-----------+------------+---------+--------------+

-- criar compras
insert into tbcompras (idfuncionario,idfornecedor,datacompra)
values(5, 1, '2015-09-28');

-- acertar tbdet compras
insert into tbdetcompras (idcompra, idproduto, quantidade, valorproduto)
values(1, 5 , 80, 250.00);

select * from tbprodutos
+-----------+------------+---------+--------------+
| idproduto | produto    | estoque | valorproduto |
+-----------+------------+---------+--------------+
|         1 | mouse      |    1000 |        15.00 |
|         2 | teclado    |    1000 |        95.60 |
|         3 | webcam     |    NULL |         NULL |
|         4 | monitor    |     300 |       750.00 |
|         5 | monitor_15 |     330 |         NULL |
|         6 | monitor_19 |     300 |       850.00 |
+-----------+------------+---------+--------------+

ok

--fazendo um update produto 6 
update tbdetcompras set idproduto = 6 where iddetcompra = 1;


select * from tbprodutos;
+-----------+------------+---------+--------------+
| idproduto | produto    | estoque | valorproduto |
+-----------+------------+---------+--------------+
|         1 | mouse      |    1000 |        15.00 |
|         2 | teclado    |    1000 |        95.60 |
|         3 | webcam     |    NULL |         NULL |
|         4 | monitor    |     300 |       750.00 |
|         5 | monitor_15 |     250 |         NULL |
|         6 | monitor_19 |     380 |       850.00 |
+-----------+------------+---------+--------------+
ok


--fazendo delete
delete from tbdetcompras where iddetcompra=1;
+-----------+------------+---------+--------------+
| idproduto | produto    | estoque | valorproduto |
+-----------+------------+---------+--------------+
|         1 | mouse      |    1000 |        15.00 |
|         2 | teclado    |    1000 |        95.60 |
|         3 | webcam     |    NULL |         NULL |
|         4 | monitor    |     300 |       750.00 |
|         5 | monitor_15 |     250 |         NULL |
|         6 | monitor_19 |     300 |       850.00 |
+-----------+------------+---------+--------------+

ok

------------------------------------------
show triggers in bdfunc;

show create trigger trDespesasAD;




















































