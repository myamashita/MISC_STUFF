--Aula 2
--Tabela de Funcionários

-- Acessando Banco

mysql -uroot -pelaborata

-- Visualizando Banco
show databases;

-- Criar Banco
drop database if exists bdfunc;
create database bdfunc;

-- Usar Banco
use bdfunc;

-- Criando tabelas
-- TABLE TBLOGINS
drop table if exists tblogins;
create table tblogins(
  idlogin int not null auto_increment,
  idfuncionario int not null,
  login varchar(10) not null,
  senha varchar(10) not null,
  acesso varchar(50) not null,
  primary key (idlogin)
);

-- TABLE TBDETPEDIDOS
drop table if exists tbdetpedidos;
create table tbdetpedidos(
  iddetpedido int not null auto_increment,
  idpedido int not null,
  idproduto int not null,
  quantidade int not null,
  valorproduto decimal(10,2) not null,
  primary key (iddetpedido)
);

-- TABLE TBPRODUTOS
drop table if exists tbprodutos;
create table tbprodutos(
  idproduto int not null auto_increment,
  produto varchar(255) not null,
  estoque int null,
  valorproduto decimal(10,2) null,
  primary key (idproduto)
);

-- TABLE TBCLIENTES
drop table if exists tbclientes;
create table tbclientes(
  idcliente int not null auto_increment,
  cliente varchar(255) not null,
  sexo varchar(10) not null,
  cpf varchar(11) null,
  primary key (idcliente)
);

-- TABLE TBPEDIDOS
drop table if exists tbpedidos;
create table tbpedidos(
  idpedido int not null auto_increment,
  idfuncionario int not null,
  idcliente int not null,
  datapedido date not null,
  primary key (idpedido)
);

-- TABLE TBDETCOMPRAS
drop table if exists tbdetcompras;
create table tbdetcompras(
  iddetcompra int not null auto_increment,
  idcompra int not null,
  idproduto int not null,
  quantidade int not null,
  valorproduto decimal(10,2) not null,
  primary key (iddetcompra)
);

-- TABLE TBPAGAMENTOS
drop table if exists tbpagamentos;
create table tbpagamentos(
  idpagamento int not null auto_increment,
  idfuncionario int not null,
  idsetor int not null,
  idcargo int not null,
  datapagamento date not null,
  salario decimal(10,2) not null,
  primary key (idpagamento)
);

-- TABLE TBCOMPRAS
drop table if exists tbcompras;
create table tbcompras(
  idcompra int not null auto_increment,
  idfuncionario int not null,
  idfornecedor int not null,
  datacompra date not null,
  primary key (idcompra)
);

-- TABLE TBFORNECEDORES
drop table if exists tbfornecedores;
create table tbfornecedores(
  idfornecedor int not null auto_increment,
  fornecedor varchar(255) not null,
  cnpj varchar(20) null,
  primary key(idfornecedor)
);

-- TABLE TBCARGOS
drop table if exists tbcargos;
create table tbcargos(
  idcargo int not null auto_increment,
  cargo varchar(100) not null,
  primary key (idcargo)
);

-- TABLE TBSETORES
drop table if exists tbsetores;
create table tbsetores(
  idsetor int not null auto_increment,
  setor varchar(100) not null,
  orcamento decimal(10,2) null,
  primary key (idsetor)
);

-- TABLE TBDESPESAS
drop table if exists tbdespesas;
create table tbdespesas(
  iddespesa int not null auto_increment,
  idfuncionario int not null,
  idsetor int not null,
  datadespesa date not null,
  valordespesa decimal(10,2) not null,
  descricao varchar(255) null,
  primary key (iddespesa)
);

-- TABLE TBFUNCIONARIOS
drop table if exists tbfuncionarios;
create table tbfuncionarios(
  idfuncionario int not null auto_increment,
  idsetor int not null,
  idcargo int not null,
  Funcionários varchar(255) not null,
  sexo varchar(10) not null,
  cpf varchar(11) null,
  salario decimal(10,2) null,
  primary key (idfuncionario)
);

-- visualizar as tabelas criadas
show tables;

-- Descrição das tabelas;
describe tbcargos;
describe tbclientes;       
describe tbcompras;
describe tbdepedidos;
describe tbdespesas;
describe tbdetcompras;
describe tbfornecedores;
describe tbfuncionarios;
describe tblogins;
describe tbpagamentos;
describe tbpedidos;
describe tbprodutos;
describe tbsetores;
-- OBS tabelas conforme diagrama


-- Criação de chaves estrangeiras
-- Chaves da TBDESPESAS
alter table tbdespesas add foreign key (idfuncionario)
references tbfuncionarios(idfuncionario);

alter table tbdespesas add foreign key (idsetor)
references tbsetores(idsetor);

-- Chaves da tbcompras
alter table tbcompras add foreign key (idfuncionario)
references tbfuncionarios(idfuncionario);

alter table tbcompras add foreign key (idfornecedor)
references tbfornecedores(idfornecedor);

-- Chaves da TBDETCOMPRAS
alter table tbdetcompras add foreign key (idcompra)
references tbcompras(idcompra);

alter table tbdetcompras add foreign key (idproduto)
references tbprodutos(idproduto);

-- Chaves da TBPEDIDOS
alter table tbpedidos add foreign key (idfuncionario)
references tbfuncionarios(idfuncionario);

alter table tbpedidos add foreign key (idcliente)
references tbclientes(idcliente);

-- Chaves da TBDETPEDIDOS
alter table tbdetpedidos add foreign key (idpedido)
references tbpedidos(idpedido);

alter table tbdetpedidos add foreign key (idproduto)
references tbprodutos(idproduto);

-- Chaves da TBLOGINS
alter table tblogins add foreign key (idfuncionario)
references tbfuncionarios(idfuncionario);

-- Chaves da TBPAGAMENTOS
alter table tbpagamentos add foreign key (idfuncionario)
references tbfuncionarios(idfuncionario);

alter table tbpagamentos add foreign key (idsetor)
references tbsetores(idsetor);

alter table tbpagamentos add foreign key (idcargo)
references tbcargos(idcargo);

--Chaves da TBFUNCIONARIOS
alter table tbfuncionarios add foreign key (idsetor)
references tbsetores(idsetor);

alter table tbfuncionarios add foreign key (idcargo)
references tbcargos(idcargo);

----- CHAVES FK ok


-- Criando indexações

create  index idxtbdespesasdatadespesa on tbdespesas (datadespesa);
show index in tbdespesas;

create unique index idxtbfornecedores_fornecedor_cnpj on tbfornecedores (fornecedor,cnpj);
show index in tbfornecedores;

create index idxtbcomprasdatacompra on tbcompras (datacompra);

create unique index idxtbprodutosproduto on tbprodutos (produto);

create unique index idxtbsetoressetor on tbsetores (setor);

create unique index idxtbcargoscargo on tbcargos (cargo);

create index idxtbpagamentosdatapagamento on tbpagamentos(datapagamento);

create unique index idxtbclientescpf on tbclientes(cpf);

create unique index idxtbloginslogin on tblogins(login);

create index idxtbpedidosdatapedido on tbpedidos(datapedido);

create unique index idxtbfuncionarios_funcionario_cpf on tbfuncionarios(funcionario,cpf);
-- Erro de escrita na tabela (Funcionários) deveria ser funcionario

--FIX
alter table tbfuncionarios change Funcionários funcionario varchar(255) not null;


-- Exercicios
-- 1) alterar a tabela de logins 
-- trocar o campo senha de varchar(10) para 50
alter table tblogins change senha senha varchar(50) not null;

--2) alterar a tabela funcionarios, trocar o campo sexo de varchar para enum
alter table tbfuncionarios change sexo sexo enum('masculino', 'feminino') not null;

--3) alterar a tabela clientes, trocar o campo sexo varchar p enum
alter table tbclientes change sexo sexo enum('masculino', 'feminino') not null;

--4) alterar a tabela de logins, trocar o campo de acesso de varchar p emun
alter table tblogins change acesso acesso enum('administrador', 'proprietario', 'usuario') not null;

--5) cadastrar cargos

insert into tbcargos(cargo)
values('gerente geral'),
      ('gerente setorial'),
      ('lider'),
      ('vendedor');

--6) cadastrar setores
insert into tbsetores(setor)
values('compras'),
      ('estoque'),
      ('vendas'),
      ('negocios');
      
--7) cadastrar funcionarios
insert into tbfuncionarios(idsetor, idcargo, funcionario, sexo)
values(4, 1, 'Marcos', 'masculino'),
      (4, 2, 'Andrei', 'masculino'),
      (3, 4, 'Ronaldo', 'masculino'),
      (3, 4, 'Natalia', 'feminino'),
      (3, 4, 'Mariana', 'feminino');

--8 cadastrar clientes
insert into tbclientes(cliente, sexo, cpf)
values('Rafael', 'masculino', null),
      ('Thiago', 'masculino', '75236541298'),
      ('Daniel', 'masculino', '85296315935'),
      ('Thalita', 'feminino', '98523674158'),
      ('Jessika', 'feminino', null);

--9) cadastrar produtos
insert into tbprodutos(produto, estoque, valorproduto)
values('mouse', 50, 15.00),
      ('teclado', 100, 95.60),
      ('webcam', null, null),
      ('monitor', 300, 750.00),
      ('monitor_15', 250, null),
      ('monitor_19', 300, 850.00);

--10) cadastrar fornecedores
insert into tbfornecedores(fornecedor, cnpj)
values('LG', '357159852336001'),
      ('Sony', '35785266684001'),
      ('HP', '465432832111001'),
      ('Dell', null),
      ('lenovo', null);
      
      
--11) cadastrar despesas
insert into tbdespesas(idfuncionario,idsetor,datadespesa,valordespesa,descricao)
values(1, 4, '2015-09-25',50.50, 'portifolio'),
      (2, 4, '2015-09-22', 150.00, 'pastas e caixas'),
      (2, 4, '2015-09-22', 10.00, 'pastas'),
      (5, 3, '2015-09-22', 200.00, 'impressao banner'),
      (5, 3, '2015-09-15', 150.00, 'impressao carta'),
      (5, 3, '2015-09-15', 10000.00, null),
      (4, 4, '2015-07-01', 250.00, 'impressao');


--12) cadastrar pagamentos
insert into tbpagamentos(idfuncionario, idsetor, idcargo, datapagamento, salario)
values(1, 4, 1, '2015-09-05', 15000.00),
      (2, 4, 2, '2015-09-05', 09000.00),
      (3, 3, 4, '2015-09-15', 04500.00),
      (5, 3, 4, '2015-09-15', 04500.00),
      (4, 3, 4, '2015-09-15',  5900.00);

--13) cadastrar logins
insert into tblogins(idfuncionario,login, senha, acesso)
values(1, 'A118', 'e18i99', 'proprietario'),
      (3, 'AIB4', '36a8u1', 'administrador'),
      (2, 'AMLZ', 'f8ujkw', 'usuario'),
      (4, 'V71N', 'd98ikn', 'usuario');

--14 criar um select para mostrar todas informações da tabela cliente
select * from tbclientes;

--15 criar um select para mostrar todas informações da tabela despesas
select * from tbdespesas;

--16 criar um select para mostrar todas informações da tabela funcionarios
select * from tbfuncionarios;

--17 criar um select para mostrar todas informações da tabela logins
select * from tblogins;

--18 criar um select para mostrar funcionario no setor 2
select f.funcionario from tbfuncionarios f where f.idsetor=2;

--19 criar select para mostrar produtos com estoque acima de 100
select prod.produto from tbprodutos prod where prod.estoque > 100; 

--20 criar um select para mostrar todas informações:
-- idpagamento,funcionario, datapagamento e salario
select p.idpagamento, f.funcionario, p.datapagamento, p.salario
from tbpagamentos p inner join tbfuncionarios f on f.idfuncionario = p.idfuncionario ;

--21 criar um select para mostrar todas informações:
-- iddespesa,funcionario, datadespesa e valordespesa
select d.iddespesa, f.funcionario, d.datadespesa, d.valordespesa
from tbdespesas d inner join tbfuncionarios f on f.idfuncionario = d.idfuncionario;

--22 criar um select para mostrar todas informações:
-- idfuncionario, cargo, setor, nome do funcionario, sexo e salario ordenado pelo nome do funcionario
select f.idfuncionario, c.cargo, s.setor, f.funcionario, f.sexo, f.salario 
from tbfuncionarios f inner join tbcargos c on c.idcargo = f.idcargo
inner join tbsetores s on s.idsetor = f.idsetor
order by f.funcionario;

--23 criar um select para mostrar todas informações:
--iddespesa, setor, funcionario, data da despesa, valordespesa
select d.iddespesa, s.setor, f.funcionario, d.datadespesa, d.valordespesa
from tbdespesas d inner join tbfuncionarios f on f.idfuncionario = d.idfuncionario inner join tbsetores s on d.idsetor = s.idsetor;

--24 criar um select para mostrar todas informações:
--iddespesa, setor, funcionario, cargo, data da despesa, valordespesa
select d.iddespesa, s.setor, f.funcionario, c.cargo, d.datadespesa, d.valordespesa
from tbdespesas d inner join tbfuncionarios f on f.idfuncionario = d.idfuncionario inner join tbsetores s on d.idsetor = s.idsetor inner join tbcargos c on f.idcargo = c.idcargo;

select d.iddespesa, s.setor, f.funcionario, c.cargo, d.datadespesa, d.valordespesa
from tbdespesas d inner join tbfuncionarios f on f.idfuncionario = d.idfuncionario inner join tbsetores s on d.idsetor = s.idsetor inner join tbcargos c on c.idcargo = f.idcargo;
-- Qual a diferença?

--25 criar um select para mostrar todas informações:
--idpagamento, funcionario, cargo, setor, datapagamento e salario
select p.idpagamento, f.funcionario, c.cargo, s.setor, p.datapagamento, p.salario 
from tbpagamentos p inner join tbfuncionarios f on f.idfuncionario = p.idfuncionario inner join tbcargos c on c.idcargo = f.idcargo inner join tbsetores s on f.idsetor = s.idsetor;


insert into tbpagamentos(idfuncionario, idsetor, idcargo, datapagamento, salario)
values(1, 4, 1, '2015-08-05', 15000.00),
      (2, 4, 2, '2015-08-05', 09000.00),
      (3, 3, 4, '2015-08-15', 04500.00),
      (5, 3, 4, '2015-08-15', 04500.00),
      (4, 3, 4, '2015-08-15',  5900.00);

--26 criar um select para mostrar quantos funcionario no setor 2
select count(f.funcionario) 
from tbfuncionarios f inner join tbsetores s on f.idsetor = s.idsetor
where s.setor = 2;

--27 criar um select para mostrar quantos funcionario cada setor
select s.setor ,count(f.funcionario) 'n funcionario'
from tbfuncionarios f inner join tbsetores s on f.idsetor = s.idsetor
group by s.setor;

--28 criar um select para mostrar todos os funcionario que começam com c
select f.funcionario from tbfuncionarios f where f.funcionario like ('C%');
select * from tbfuncionarios f where f.funcionario like ('m%');

--29 criar um select para mostrar todos os funcionario que começam com r
select f.funcionario from tbfuncionarios f where f.funcionario like ('r%');

--30 criar um select para mostrar todos os clientes que tenham cpf que contenham '33'
select cli.cpf from tbclientes cli 
where (cli.cpf like ('33%')) or
      (cli.cpf like ('%33')) or
      (cli.cpf like ('%33%'));

--31 criar um select para mostrar todos os fornecedor que terminam  com m
select f.fornecedor from tbfornecedores f where f.fornecedor like ('%m');

--32 criar um select para mostrar
--idfuncionario, cargo, setor, nome do funcionario, sexo, salario dos funcionario do sexo masculino

select f.idfuncionario, c.cargo, s.setor, f.funcionario, f.sexo, f.salario
from tbfuncionarios f inner join tbsetores s on s.idsetor = f.idsetor inner join tbcargos c on c.idcargo = f.idcargo 
where f.sexo = 'masculino';

--33 alterar para 2 os cargos dos funcionarios lotados no setor 3
--1 selecionar funcionarios do setor 3
select f.funcionario from tbsetores s right join tbfuncionarios f on s.idsetor = f.idsetor where s.idsetor=3;
--2 alterar os cargos dos funcionarios
update tbfuncionarios f set f.idcargo = 2 where f.idsetor =3; 


--35 alterar o nome  o salario e o cpf do funcionario 1
update tbfuncionarios f set f.funcionario = 'Vitor',  f.salario=7500.00,  f.cpf='78998785266' where f.idfuncionario=1;

--36 alterar para 100 o estoque dos produtos com estoque menor q 500
update tbprodutos prod set prod.estoque = 1000 where prod.estoque < 150;
 
--37 excluir o cliente 3
delete from tbclientes where idcliente=3; 

--38 excluir os pagamentos do funcionario 2
delete from tbpagamentos where idfuncionario =2;

--39 excluir os fornecedores terminados por lo
delete from tbfornecedores where fornecedor like ('%lo');

-- STORE PROCEDURE

delimiter $$
drop procedure if exists spcadastrosetor$$
create procedure spcadastrosetor(s varchar(100), o decimal (10,2))
begin
  insert into tbsetores (setor, orcamento)
  values (s, o);
end$$
delimiter ;

-- Visualizando todos os store procedure
show procedure status;

-- Visualizando o código de um store procedure
show create procedure spcadastrosetor;

--executando um store procedure
call spcadastrosetor('Novo Setor', 12566.55);

-- \G no final do comando faz uma lista



-- Store Procedure para criar funcionario

delimiter $$
drop procedure if exists spcadastrafunc$$
create procedure spcadastrafunc (st varchar(50), ca varchar(50), fu varchar(255), sx int, cp varchar(11), sa decimal (10,2))
begin
    declare ids int;
    declare idc int;
    select idsetor into ids from tbsetores where setor = st;
    select idcargo into idc from tbcargos where cargo = ca;
    if isnull(ids) then
	select Concat('ERRO! Setor ', st, ' não localizado') ATENÇÂO;
    elseif isnull(idc) then
	select Concat('ERRO! Cargo ', ca, ' não localizado') ATENÇÂO;
    else
	insert into tbfuncionarios
	values(null, ids, idc, fu, sx, cp, sa);
    end if;

end$$
delimiter ;

-- executando o store procedure
call spcadastrafunc('RH','lider', 'Super-Homem', 1, '15483585266',3698.66);

-- Não tem RH 
call spcadastrosetor('RH', 12566.55);


--45 criar procedure para alterar salario de determinado funcionario
delimiter $$
drop procedure if exists spalterarsalario$$
create procedure spalterarsalario(idfunc int, valor decimal(10,2))
begin
    update tbfuncionarios set tbfuncionarios.salario = valor
    where (idfuncionario = idfunc);

end$$
delimiter ;

-- aplicar  o procedure
call spalterarsalario(1,3500.00);

-- Criando uma consulta para listar as informações completas dos funcionarios

select f.idfuncionario ID, c.cargo CARGO, s.setor SETOR, f.funcionario FUNCIONARIO, f.sexo SEXO, f.cpf CPF, f.salario SALARIO
from tbfuncionarios f inner join tbcargos c on c.idcargo = f.idcargo
inner join tbsetores s on s.idsetor = f.idsetor
order by ID;


-- transformar numa visão
create view vwInfoFuncs as
select f.idfuncionario ID, c.cargo CARGO, s.setor SETOR, f.funcionario FUNCIONARIO, f.sexo SEXO, f.cpf CPF, f.salario SALARIO
from tbfuncionarios f inner join tbcargos c on c.idcargo = f.idcargo
inner join tbsetores s on s.idsetor = f.idsetor
order by ID;

describe  vwInfoFuncs ;

select * from vwInfoFuncs;






































