--Acessando o Mysql
mysql -uroot -pelaborata

--Visualizando todos os bancos cadastrados para o usuário logado
show databases;

--criando um novo banco de dados
drop database if exists bdcontatos;
create database bdcontatos;

--Acessando determinado banco de dados
use bdcontatos;

--Visualizando as tabelas no banco logado
show tables;

--Criando a Tabela de Contatos
drop table if exists tbcontatos;
create table tbcontatos(
  idcontato int not null auto_increment,
  nome varchar(255) not null,
  datanasc date null,
  fone varchar(20) null,
  primary key (idcontato)
);


--Visualizando a Estrutura de determinada tabela
describe tbcontatos;



--Cadastrando alguns contatos
insert into tbcontatos (nome, datanasc, fone)
values ('Hulk', '1980-05-22', '5555555555');

insert into tbcontatos (nome)
values ('Homem-Aranha');

insert into tbcontatos (nome, fone)
values ('Homem de Ferro', '6666666666');


insert into tbcontatos (datanasc, nome)
values ('2000-01-17', 'Chapolin Colorado');


insert into tbcontatos (nome, datanasc, fone)
values ('Mulher maravilha', '30/06/2005', '22222222222');
Query OK, 1 row affected, 1 warning (0.03 sec)



insert into tbcontatos (nome, datanasc, fone)
values ('Arqueiro', '1977-05-22', '4165653265'),
       ('Thor', '976-02-02', null),
       ('Viúva Negra', null, null);

select * from tbcontatos order by nome;
select * from tbcontatos order by nome asc;

select * from tbcontatos order by nome desc;


select nome, fone from tbcontatos;


select * from tbcontatos where nome = 'hulk';


--Atualizando as informações do contano número 5
update tbcontatos set nome = 'Mulher Maravilha', datanasc = '2000-08-30'
where idcontato = 5;



delete from tbcontatos where idcontato = 8;


insert into tbcontatos (nome, datanasc, fone)
values ('Viúva Negra', null, null);


--Forma INCORRETA
select * from tbcontatos where fone = null;

--Forma CORRETA
select * from tbcontatos where isnull(fone);

--Selecionando apenas os contatos começados por h
--Obs: Existe indexação
select * from tbcontatos where nome like 'h%';

--Selecionando qualquer contatos que contenha h
--Obs: Não existe indexação
select * from tbcontatos where nome like '%h%';

--Selecionando apenas os contatos terminan por h
--Obs: Não existe indexação
select * from tbcontatos where nome like '%h';


--Verificando quantos registros temos na tabela de contatos
select count(idcontato) Total_Contatos from tbcontatos;
select count(idcontato) 'Total Contatos' from tbcontatos;

select count(idcontato) Total_Contatos from tbcontatos where nome like 'h%';

--Maior idcontato
select max(idcontato) as Maior_Id from tbcontatos;

--Menor idcontato
select min(idcontato) as 'Menor ID' from tbcontatos;

--Soma dos idcontato
select sum(idcontato) as 'Soma' from tbcontatos;


--Média dos idcontato
select avg(idcontato) 'Média' from tbcontatos;


--Maior idcontato
select max(datanasc) Maior_Nasc from tbcontatos;



--Inserindo novas Informações sem especificar os campos
insert into tbcontatos
values (null, 'Chuck Norris', CurDate(), '544578895633');

--A Função Curdate() retorna a data corrente


select curdate() as Data_Atual;
select curtime() as Hora_Atual;

select 8*45;

select 'Olá Marcelo!' as mensagem;



