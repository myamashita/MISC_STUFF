delimiter $$
drop procedure if exists spcadastrasetor$$
create procedure spcadastrasetor(s varchar(100), o decimal(10, 2))
begin
  insert into tbsetores 
    (setor, orcamento)
  values
    (s, o);
end$$
delimiter ;

--Visualizando todos os stored procedure
show procedure status;

--Visualizando o código fonte de um stored procedure
show create procedure spcadastrasetor;

--Executando um stored procedure
call spcadastrasetor('Novo Setor', 1236.55);

--Stored Procedure para realizar o cadastro de um novo funcionário
delimiter $$
drop procedure if exists spcadastrafunc$$
create procedure spcadastrafunc(st varchar(50), ca varchar(50), fu varchar(255), sx int, cp varchar(11), sa decimal(10,2))
begin
    declare ids int;
    declare idc int;
    select idsetor into ids from tbsetores where setor = st;
    select idcargo into idc from tbcargos  where cargo = ca;
    if isnull(ids) then
        select Concat('ERRO! Setor ', st, ' não localizado.') ATENÇÃO;
    elseif isnull(idc) then
        select Concat('ERRO! Cargo ', ca, ' não localizado.') ATENÇÃO;
    else
	insert into tbfuncionarios 
	values (null, ids, idc, fu, sx, cp, sa);
    end if;
end$$
delimiter ;

--executando o stored procedure
call spcadastrafunc('RH', 'Gerente', 'Super-Homem', 1, '12365445622', 2345.44);
call spcadastrafunc('RHxx', 'Gerente', 'Super-Homem', 1, '12365445622', 2345.44);
call spcadastrafunc('RH', 'Gerentexx', 'Super-Homem', 1, '12365445622', 2345.44);


--Stored procedure para alterar o salário de determinado funcionário
delimiter $$
drop procedure if exists spalterasalario$$
create procedure spalterasalario(idf int, sal decimal(10,2))
begin
  update tbfuncionarios set salario = sal where idfuncionario = idf;
end$$status
delimiter ;


select * from tbfuncionarios;
call spalterasalario(4, 4444.77);


--Criando uma Consulta para listar as Informações completas dos Funcionários
select f.idfuncionario ID, c.cargo Cargo, s.setor Setor, f.funcionario Funcionário, f.sexo Sexo, f.cpf CPF, f.salario Salário
from tbfuncionarios f inner join tbcargos  c on (c.idcargo = f.idcargo)
                      inner join tbsetores s on (s.idsetor = f.idsetor)
order by ID;


create view vwInfoFuncs as
select f.idfuncionario ID, c.cargo Cargo, s.setor Setor, f.funcionario Funcionário, f.sexo Sexo, f.cpf CPF, f.salario Salário
from tbfuncionarios f inner join tbcargos  c on (c.idcargo = f.idcargo)
                      inner join tbsetores s on (s.idsetor = f.idsetor)
order by ID;


show tables;

describe vwInfoFuncs;

select * from vwInfoFuncs;



--Aula 3 (30/09/2015)
--Criando um login para o Funcionário 1
insert into tblogins (idfuncionario, login, senha, acesso)
values (1, 'chuck', password('chuck'), 1);


--Verificando a existẽncia de determinado login e senha
select * from tblogins where (login = 'chuck') and (senha = 'chuck');
Empty set (0.00 sec)

select * from tblogins where (login = 'chuck') and (senha = password('chuck'));
+---------+---------------+-------+-------------------------------------------+---------------+
| idlogin | idfuncionario | login | senha                                     | acesso        |
+---------+---------------+-------+-------------------------------------------+---------------+
|       1 |             1 | chuck | *D637C3E16BFDAFEB8E9D9CE0499A71AE6A9020BA | administrador |
+---------+---------------+-------+-------------------------------------------+---------------+
1 row in set (0.00 sec)


--Criando um login para o Funcionário 1
insert into tblogins (idfuncionario, login, senha, acesso)
values (2, 'rambo', 'rambo', 2);

select * from tblogins where (login = 'rambo') and (senha = 'rambo');
+---------+---------------+-------+-------+--------------+
| idlogin | idfuncionario | login | senha | acesso       |
+---------+---------------+-------+-------+--------------+
|       2 |             2 | rambo | rambo | proprietario |
+---------+---------------+-------+-------+--------------+
1 row in set (0.00 sec)



--Stored Procedure para realizar o pagamento de todos os funcionários em determinada data

--Selecionando as informações necessárias para os pagamentos
select idfuncionario, idsetor, idcargo, '2015-09-30' DATA, salario from tbfuncionarios;

--OBS: sempre que realizamos um INSERT a partir de um SELECT (como no modelo abaixo), NÂO utilizamos a palavra VALUES

delimiter $$
drop procedure if exists spRealizaPagamentos$$
create procedure spRealizaPagamentos(dt date)
begin
  insert into tbpagamentos 
    (idfuncionario, idsetor, idcargo, datapagamento, salario)
  (select 
     idfuncionario, idsetor, idcargo, dt, if(isnull(salario), 0, salario) 
   from tbfuncionarios);
end$$
delimiter ;


--Executando o Procedimento spRealizaPagamentos
call spRealizaPagamentos('2015-09-30');
call spRealizaPagamentos('2015-08-30');

select * from tbpagamentos;

select * from tbpagamentos;


--*******************************************
Select * from tbprodutos;

--Stored Procedure para listar as informações de Produtos, com as linhas numeradas
delimiter $$
drop procedure if exists spInfoProdutos$$
create procedure spInfoProdutos()
begin
  declare linha int;
  set @linha = 0;
  select @linha := @linha + 1 as 'Linha', p.* from tbprodutos p;
end$$
delimiter ;

call spInfoProdutos();


--criar um Stored procedure para listar as seguintes informações
--Número da Linha, Funcionário, Cargo, Setor, Salário, Férias R$, Abono (20% ou 15% sobre o salário) e Total a Receber
-- Abono de 20% para salários até 2000.00 e 15% para salários acima de 2000.00

delimiter $$
drop procedure if exists spCalculaTudo$$
create procedure spCalculaTudo()
begin
  declare linha int;
  set @linha = 0;
  select @linha := @linha + 1 'Linha', f.funcionario Funcionário, c.cargo Cargo, s.setor Setor, f.salario 'Salário R$', truncate(f.salario*(1/3), 2) 'Ferias R$', truncate(if (f.salario < 2000.00, f.salario*0.2, f.salario*0.15), 2) 'Abono R$', truncate(f.salario*(1+1/3) + if (f.salario < 2000.00, f.salario*0.2, f.salario*0.15), 2) 'Total R$'
  from tbfuncionarios f inner join tbcargos  c on (c.idcargo = f.idcargo)
                        inner join tbsetores s on (s.idsetor = f.idsetor);
end$$
delimiter ;
call spCalculaTudo();


show procedure status;

show create procedure spCalculaTudo;


--Criando Transações

mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from tbcargos;
+---------+---------------+
| idcargo | cargo         |
+---------+---------------+
|       1 | Office Boy    |
|       2 | Gerente       |
|       3 | Segurança     |
|       4 | Administrador |
|       5 | Contador      |
+---------+---------------+
5 rows in set (0.00 sec)

mysql> insert into tbcargos (cargo)  values ('novo cargo');Query OK, 1 row affected (0.00 sec)
                                                       
mysql> select * from tbcargos;                              
+---------+---------------+                                      
| idcargo | cargo         |                                      
+---------+---------------+                                            
|       1 | Office Boy    |                                                   
|       2 | Gerente       |
|       3 | Segurança     |
|       4 | Administrador |
|       5 | Contador      |
|       6 | novo cargo    |
+---------+---------------+
6 rows in set (0.00 sec)


--Rollback, desfaz tudo o que foi alterado no banco desde a criação da última transação e finaliza a transação.
mysql> rollback;
Query OK, 0 rows affected (0.04 sec)

mysql> select * from tbcargos;
+---------+---------------+
| idcargo | cargo         |
+---------+---------------+
|       1 | Office Boy    |
|       2 | Gerente       |
|       3 | Segurança     |
|       4 | Administrador |
|       5 | Contador      |
+---------+---------------+
5 rows in set (0.00 sec)

mysql> start transaction;                                  
Query OK, 0 rows affected (0.00 sec)

mysql> insert into tbcargos (cargo)  values ('novo cargo');
Query OK, 1 row affected (0.00 sec)


--Rollback, efetiva tudo o que foi alterado no banco desde a criação da última transação e finaliza a transação.
mysql> commit;
Query OK, 0 rows affected (0.02 sec)

mysql> select * from tbcargos;
+---------+---------------+
| idcargo | cargo         |
+---------+---------------+
|       1 | Office Boy    |
|       2 | Gerente       |
|       3 | Segurança     |
|       4 | Administrador |
|       5 | Contador      |
|       7 | novo cargo    |
+---------+---------------+
6 rows in set (0.00 sec)



--Criando uma Função que retorne a soma dos salários de determinado Funcionário
delimiter $$
drop function if exists fSomaSalario$$
create function fSomaSalario(idf int) returns decimal (10,2)
begin
  declare soma decimal (10, 2);
  select sum(salario) into @soma from tbpagamentos where idfuncionario = idf;
  return @soma;
end$$
delimiter ;



--Acessando a Função recém criada
select concat('R$ ', fSomaSalario(1)) 'Total Salários';


select f.funcionario, fSomaSalario(f.idfuncionario) 'Total Salários'
from tbfuncionarios f;



show function status;


show create function fSomaSalario;


--Testando se uma função é, por natureza, GLOBAL
delimiter $$
drop   function if exists fSomar$$
create function fSomar(x int, y int) returns int
begin
  declare soma int;
  set @soma = x + y;
  return @soma;
end$$
delimiter ;

select fSomar(9, 8);

mysql> use bdmun;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select fSomar(9, 8);
ERROR 1305 (42000): FUNCTION bdmun.fSomar does not exist
mysql> select bdempresa.fSomar(9, 8);
+------------------------+
| bdempresa.fSomar(9, 8) |
+------------------------+
|                     17 |
+------------------------+
1 row in set (0.00 sec)



--criar uma função que receba como parêmetro de entrada uma data e retorne a soma dos salários do mês e ano específicos da data informada
delimiter $$
drop function if exists fSomaSalMesAno$$
create function fSomaSalMesAno(data date) returns decimal (10,2)
begin
  declare soma decimal (10,2);
  select sum(salario) into soma from tbpagamentos
  where (month(datapagamento) = month(data)) and (year(datapagamento) = year(data));
  return soma;
end$$
delimiter ;


select fSomaSalMesAno(curdate()) as 'Total Salários';


select datapagamento from tbpagamentos;

select distinct(datapagamento) from tbpagamentos;

select 
  month(t.datapagamento) 'Mês', year(t.datapagamento) 'Ano', 
  fSomaSalMesAno(t.datapagamento) 'Total Salário'
from 
  (select distinct(datapagamento) from statustbpagamentos) t;

--Consulta para listar as seguintes informações
Funcionário, Setor do Funcionário, Cargo, Setor da Despesa, Data da Despesa e valor da Despesa 

select f.funcionario Funcionário, s.setor 'Setor Func',
       c.cargo Cargo, sd.setor 'Setor Despesa',
       d.datadespesa Data, d.valordespesa Valor
from 
  tbfuncionarios f inner join tbsetores s on (s.idsetor = f.idsetor)
inner join tbcargos c on (c.idcargo = f.idcargo)
inner join tbdespesas d on (f.idfuncionario = d.idfuncionario)
inner join tbsetores sd on (sd.idsetor = d.idsetor);

--Triggers
-- São possíveis até 6 triggers distintas para cada tabela
--do Banco de dados
  --Before Insert
  --Before Update
  --Before Delete
  --After  Insert
  --After  Update
  --After  Delete

--Criando uma trigger para Atualizar o Orçamento de determinado setor sempre que uma nova despesa for realizada
--Obs: trigger é executada automaticamente após um evento Insert, Update ou Delete
delimiter $$
drop   trigger if exists trDespesasAI$$
create trigger trDespesasAI After Insert on tbdespesas for each row
begin
    update tbsetores set orcamento = orcamento - new.valordespesa
    where (idsetor = new.idsetor);
end$$
delimiter ;

select * from tbdespesas;
select * from tbsetores;

--Lançando uma nova despesa para o setor 2 (TI)
insert into tbdespesas 
  (idfuncionario, idsetor, datadespesa, valordespesa, descricao)
values
  (1, 2, CurDate(), 2714.37, 'Bolacha Maria');

select * from tbdespesas;
select * from tbsetores;

--Trigger para atualizar o Orçamento de determinado setor sempre que uma despesa for excluída
delimiter $$
drop   trigger if exists trDespesasAD$$
create trigger trDespesasAD After Delete on tbdespesas for each row
begin
  update tbsetores set orcamento = orcamento + old.valordespesa
  where idsetor = old.idsetor;
end$$
delimiter ;
  
--Excluindo a despesa número 1
delete from tbdespesas where iddespesa = 1;

select * from tbsetores;

--Trigger para atualizar a tabela de setores sempre que uma despesa for atualizada
delimiter $$
drop trigger if exists trDespesasAU$$
create trigger trDespesasAU After Update on tbdespesas for each row
begin
  update tbsetores set orcamento = orcamento - new.valordespesa
  where idsetor = new.idsetor;
  update tbsetores set orcamento = orcamento + old.valordespesa
  where idsetor = old.idsetor;
end$$
delimiter ;

insert into tbdespesas 
  (idfuncionario, idsetor, datadespesa, valordespesa, descricao)
values
  (1, 2, CurDate(), 2714.37, 'Bolacha Maria');  
    
 select * from tbsetores;
 select * from tbdespesas;
 update tbdespesas set idsetor = 1 where iddespesa = 2;
 select * from tbsetores;
 
  
 --trigger para a tabela de setores para bloquer criação de setores com orçamento negativo
delimiter $$
drop trigger if exists trSetoresBI$$
create trigger trSetoresBI Before Insert on tbsetores for each row
begin
  if (new.orcamento < 0) then
    set new.setor = null;
  end if;
end$$
delimiter ;
  
select * from tbsetores;

insert into tbsetores (setor, orcamento)
values ('Setor X', -98.00);
ERROR 1048 (23000): Column 'setor' cannot be null


delimiter $$
drop trigger if exists trDetPedidosAI$$
create trigger trDetPedidosAI After Insert on tbdetpedidos for each row
begin
  update tbprodutos set estoque = estoque - new.quantidade
  where idproduto = new.idproduto;
end$$
delimiter ;

delimiter $$
drop trigger if exists trDetPedidosAD$$
create trigger trDetPedidosAD After Delete on tbdetpedidos for each row
begin
  update tbprodutos set estoque = estoque + old.quantidade
  where idproduto = old.idproduto;
end$$
delimiter ;

delimiter $$
drop trigger if exists trDetPedidosAU$$
create trigger trDetPedidosAU After Update on tbdetpedidos for each row
begin
  update tbprodutos set estoque = estoque - new.quantidade
  where idproduto = new.idproduto;
  update tbprodutos set estoque = estoque + old.quantidade
  where idproduto = old.idproduto;
end$$
delimiter ;

insert into tbpedidos (idfuncionario, idcliente, datapedido)
values (1, 2, Curdate());

insert into tbdetpedidos values (null, 1, 3, 274, 2.22);
insert into tbdetpedidos values (null, 1, 5, 100, 1.22);


update tbdetpedidos set idproduto = 4 where iddetpedido = 2;


delete from tbdetpedidos where iddetpedido = 2;



delimiter $$
drop trigger if exists trDetComprasAI$$
create trigger trDetComprasAI After Insert on tbdetcompras for each row
begin
  update tbprodutos set estoque = estoque + new.quantidade
  where idproduto = new.idproduto;
end$$
delimiter ;

delimiter $$
drop trigger if exists trDetComprasAD$$
create trigger trDetComprasAD After Delete on tbdetcompras for each row
begin
  update tbprodutos set estoque = estoque - old.quantidade
  where idproduto = old.idproduto;
end$$
delimiter ;

delimiter $$
drop trigger if exists trDetComprasAU$$
create trigger trDetComprasAU After Update on tbdetcompras for each row
begin
  update tbprodutos set estoque = estoque - new.quantidade
  where idproduto = new.idproduto;
  update tbprodutos set estoque = estoque + old.quantidade
  where idproduto = old.idproduto;
end$$
delimiter ;


show triggers in NOME_DO_BANCO;


show create trigger trDespesasAD;



