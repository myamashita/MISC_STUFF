--Período Matutino
--- Acessando o Mysql
mysql -uroot -pelaborata

-- Visualizando todos os bancos cadastrados para o usuário logado
show databases;

-- Criando um novo banco de dados
drop database if exists bdcontatos; --derruba o bdcontatos
create database bdcontatos;

-- Acessando determinado banco de dados
use bdcontatos;

-- Visualizando as tabelas no banco logado
show tables;

-- Criando a tabela de contatos
drop table if exists tbcontatos;
create table tbcontatos(
  idcontato int not null auto_increment,
  nome varchar(255) not null,
  datanasc date null,
  fone varchar(20) null,
  primary key (idcontato)
);

-- Visualizar a estrutura de determinada tabela
describe tbcontatos; --Analizar a tabela

-- Cadastrando alguns contatos
insert into tbcontatos (nome, datanasc,fone)
values('Hulk', '1980-05-22', '555555555');

-- Obs. Data Padrão Americano

insert into tbcontatos (nome)
values ('Homem-Aranha');

insert into tbcontatos (nome, fone)
values ('Homem de Ferro', '666666666');

insert into tbcontatos (datanasc, nome)
values ('2000-01-17', 'Chapolin Colorado');

insert into tbcontatos (nome, datanasc,fone)
values('Mulher Maravilha', '30/06/2015', '222222222');
-- Query OK, 1 row affected, 1 warning (0.04 sec)
-- Padrão errado na data

insert into tbcontatos (nome, datanasc, fone)
values ('Arqueiro', '1977-05-22', '4165653265'),
       ('Thor', '976-02-02', null),
       ('Viúva Negra', null, null);

select * from tbcontatos order by nome;

select * from tbcontatos order by nome asc;
select * from tbcontatos order by nome desc;

select nome, fone from tbcontatos;
       
       
select * from tbcontatos where nome='hulk';
 
-- Atualizando as informações do contato número 5
update tbcontatos set nome = 'Mulher Maravilha', datanasc = '200-08-30' where idcontato = 5;
       
-- Sintaxe de delete
delete from tbcontatos where idcontato = 8;
-- Uma vez deletado um id (o id não volta)
insert into tbcontatos (nome, datanasc, fone)
values ('Viúva Negra', null, null);

-- Sintaxe de busca
-- Forma incorreta
select * from tbcontatos where fone = null;
--Empty set (0.00 sec)

-- Forma correta
select * from tbcontatos where isnull(fone);
--isnull (function)

-- Selecionando apenas contatos começando por H
select * from tbcontatos where nome like 'h%';
-- Obs. Existe indexação

-- Selecionando qualquer contatos começando por H
select * from tbcontatos where nome like '%h%';
-- Obs. Não existe indexação

-- Selecionando terminando contatos começando por H
select * from tbcontatos where nome like '%h';
-- Obs. Não existe indexação

--Verificando quantos registros temos na tabela de contatos
select count(idcontato) from tbcontatos;
-- Nome temporário 
select count(idcontato) Total_Contatos from tbcontatos;
-- Nome composto
select count(idcontato) 'Total Contatos' from tbcontatos;

-- Verificar quantos nomes começam por h
select count(idcontato) Total_Contatos from tbcontatos where nome like 'h%';

-- Maior idcontato
select max(idcontato) as Maior_id from tbcontatos;

-- Menor idcontato
select min(idcontato) as Menor_id from tbcontatos;

-- Soma dos contatos
select sum(idcontato) as Soma_id from tbcontatos;

-- Média dos contatos
select avg(idcontato) 'Média_id' from tbcontatos;

-- Maior data nascimento (mais recente)
select max(datanasc) as Maior_data from tbcontatos;

-- Inserindo novas informações sem especificar os campos
insert into tbcontatos
values (null, 'Chuck Norris', CurDate(), '544578895633');
-- A função curdate() retorna a data atual

select curdate() as Data_Atual;
select curtime() as Data_Atual;

select 8*45;

------------------------
-- Período Vespertino

-- Criando o banco de dados
drop   database if exists bdmun;
create database bdmun;

-- Usando o banco recém criado
use bdmun;

-- Criando as tabelas: Programamos "todos os campos" informando apenas a chave primária. Haves estrangeiras serão informadas a posteriori.

--Criando a tabela tipos (Sem FK)
drop   table if exists tbtipos;
create table tbtipos(
  idtipo int not null auto_increment,
  tipo   varchar(50) not null,
  primary key (idtipo)
);
-- Criando a tabela de regiões (Sem FK)
drop   table if exists tbregioes;
create table tbregioes(
  idregiao int not null auto_increment,
  região   varchar(50) not null,
  primary key (idregiao) 
);
-- Criando a tabela de Estados (1FK)
--Obs. Ainda não informada que idregião é uma FK
drop   table if exists tbestados;
create table tbestados(
  idestado int not null auto_increment,
  idregiao int not null,
  estado   varchar(100) not null,
  sigla    char(2) not null,
  primary key (idestado)
);
-- Criando a tabela municípios (2FKs)
drop   table if exists tbmunicipios;
create table tbmunicipios(
  idmunicipio int not null auto_increment,
  idtipo int not null,
  idestado int not null,
  municipio varchar(255) not null,
  primary key (idmunicipio)
);

--
-- Agora Analizar a estrutura de cada tabela
describe tbtipos;
+--------+-------------+------+-----+---------+----------------+
| Field  | Type        | Null | Key | Default | Extra          |
+--------+-------------+------+-----+---------+----------------+
| idtipo | int(11)     | NO   | PRI | NULL    | auto_increment |
| tipo   | varchar(50) | NO   |     | NULL    |                |
+--------+-------------+------+-----+---------+----------------+
2 rows in set (0.00 sec)
-- Obs: tudo ok

describe tbregioes;
+----------+-------------+------+-----+---------+----------------+
| Field    | Type        | Null | Key | Default | Extra          |
+----------+-------------+------+-----+---------+----------------+
| idregiao | int(11)     | NO   | PRI | NULL    | auto_increment |
| região   | varchar(50) | NO   |     | NULL    |                |
+----------+-------------+------+-----+---------+----------------+
2 rows in set (0.00 sec)

-- Obs: região com acento. (se tabela vazia drop)
-- verificamos que o campo região está incorreto, trocaremos para 'regiao'
alter table tbregioes change região regiao varchar(50) not null;
+----------+-------------+------+-----+---------+----------------+
| Field    | Type        | Null | Key | Default | Extra          |
+----------+-------------+------+-----+---------+----------------+
| idregiao | int(11)     | NO   | PRI | NULL    | auto_increment |
| regiao   | varchar(50) | NO   |     | NULL    |                |
+----------+-------------+------+-----+---------+----------------+
2 rows in set (0.00 sec)

describe tbestados;
+----------+--------------+------+-----+---------+----------------+
| Field    | Type         | Null | Key | Default | Extra          |
+----------+--------------+------+-----+---------+----------------+
| idestado | int(11)      | NO   | PRI | NULL    | auto_increment |
| idregiao | int(11)      | NO   |     | NULL    |                |
| estado   | varchar(100) | NO   |     | NULL    |                |
| sigla    | char(2)      | NO   |     | NULL    |                |
+----------+--------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)

describe tbmunicipios;
+-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| idmunicipio | int(11)      | NO   | PRI | NULL    | auto_increment |
| idtipo      | int(11)      | NO   |     | NULL    |                |
| idestado    | int(11)      | NO   |     | NULL    |                |
| municipio   | varchar(255) | NO   |     | NULL    |                |
+-------------+--------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)

-- Fazer uma adicional a tabela municípios
-- adicionando o campo população à tabela de municípios
alter table tbmunicipios add populacao int null default 0;
+-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| idmunicipio | int(11)      | NO   | PRI | NULL    | auto_increment |
| idtipo      | int(11)      | NO   |     | NULL    |                |
| idestado    | int(11)      | NO   |     | NULL    |                |
| municipio   | varchar(255) | NO   |     | NULL    |                |
| populacao   | int(11)      | YES  |     | 0       |                |
+-------------+--------------+------+-----+---------+----------------+
5 rows in set (0.00 sec)


-- Agora criaremos as 3 chaves estrangeiras (Foreign Key)
alter table tbestados add foreign key (idregiao)
references tbregioes (idregiao);

alter table tbmunicipios add foreign key (idestado)
references tbestados (idestado);

alter table tbmunicipios add foreign key (idtipo)
references tbtipos (idtipo);

describe tbmunicipios;

-- tentando deletar tabela estados
drop table if exists tbestados;

ERROR 1217 (23000): Cannot delete or update a parent row: a foreign key constraint fails

-- Criando indexação
create unique index idxtipostipo on tbtipos (tipo);
-- criando index unique com nome idx na tabela tipos variavel tipo

create unique index idxestadosestado on tbestados (estado);
create unique index idxestadossigla on tbestados (sigla);


create unique index idxregioesregiao on tbregioes (regiao);


create index idxmunicipiosmunicipio on tbmunicipios (municipio);

create unique index idxmunicipios_mun_idestado on tbmunicipios (municipio, idestado);
-- cria indexação para municipios

-- tirar o index idxmunicipios_mun_idestado
drop index idxmunicipios_mun_idestado on tbmunicipios;
--
drop index NOME_DO_INDICE on NOME_DA_TABELA;
--


-- Cadastrando os 3 tipos na tabela de tipos
insert into tbtipos (tipo)
values ('Capital'),
       ('Interior'),
       ('Litoral');

Query OK, 3 rows affected (0.04 sec)
Records: 3  Duplicates: 0  Warnings: 0

-- Erro forçado, já existe o cadastro
insert into tbtipos (tipo)
values ('Capital');

ERROR 1062 (23000): Duplicate entry 'Capital' for key 'idxtipostipo'
 
-- Cadastro as 5 regiões
insert into tbregioes (regiao)
values ('Centro-oeste'),
       ('Nordeste'),
       ('Norte'),
       ('Sudeste'),
       ('Sul');

select * from tbregioes;
select * from tbtipos;

-- Cadastrando os 4 estados da região SUL
insert into tbestados (idregiao, estado, sigla)
values (5, 'Rio Grande do Sul', 'RS'),
       (5, 'Santa Catarina', 'SC'),
       (5, 'Parana', 'PR');

-- Cadastrando os 4 estados da região SUDESTE
insert into tbestados (idregiao, estado, sigla)
values (4, 'São Paulo', 'SP'),
       (4, 'Minas Gerais', 'MG'),
       (4, 'Espirito Santo', 'ES'),
       (4, 'Rio de Janeiro', 'RJ');
       
-- Cadastrando os 9 estados da região NORTE
insert into tbestados (idregiao, estado, sigla)
values (3, 'Maranhao', 'MA'),
       (3, 'Piaui', 'PI'),
       (3, 'Alagoas', 'AL'),
       (3, 'Sergipe', 'SE'),
       (3, 'Ceara', 'CE'),
       (3, 'Rio Grande do Norte', 'RN'),
       (3, 'Paraiba', 'PB'),
       (3, 'Pernambuco','PE'),
       (3, 'Bahia', 'BA');

-- Cadastrando os 7 estados da região NORTE
insert into tbestados (idregiao, estado, sigla)
values (2, 'Rondonia', 'RO'),
       (2, 'Amazonas', 'AM'),
       (2, 'Acre', 'AC'),
       (2, 'Amapa', 'AP'),
       (2, 'Tocantins', 'TO'),
       (2, 'Roraima', 'RR'),
       (2, 'Para', 'PA');      
          
          
-- Cadastrando os 4 estados da região Centro OESTE
insert into tbestados (idregiao, estado, sigla)
values (1, 'Mato Grosso', 'MT'),
       (1, 'Mato Grosso do Sul', 'MS'),
       (1, 'Goias', 'GO'),
       (1, 'Distrito Federal', 'DF'); 
       
--Cadastrando alguns municipios no Paraná
insert into tbmunicipios (idtipo, idestado, municipio, populacao)
values (1, 3, 'Curitiba', 1000000),
       (2, 3, 'Pinhais', 100000),
       (2, 3, 'Quatro Barra', 50000),
       (2, 3, 'Gurapuava', 100000),
       (2, 3, 'Lapa', 10000),
       (3, 3, 'Praia Leste', 22547),
       (3, 3, 'Guaratuba', 25960),
       (3, 3, 'Antonina', 24530);
       
--Cadastrando alguns municipios no São Paulo
insert into tbmunicipios (idtipo, idestado, municipio, populacao)
values (1, 4, 'São Paulo', 15000000),
       (2, 4, 'Campinas', 1000000),
       (2, 4, 'Santo André', 650000),
       (2, 4, 'São Bernardo', 2100000),
       (2, 4, 'Diadema', 510000),
       (3, 4, 'Guaruja', 222547),
       (3, 4, 'Ubatuba', 235960),
       (3, 4, 'Santos', 24530);  

       
--Cadastrando alguns municipios no Rio de Janeiro
insert into tbmunicipios (idtipo, idestado, municipio, populacao)
values (1, 7, 'Rio de Janeiro', 11000000),
       (2, 7, 'Magé', 10000),
       (2, 7, 'Campos', 65000),
       (2, 7, 'Itaboraí', 21000),
       (2, 7, 'Natividade', 5100),
       (3, 7, 'Macaé', 252547),
       (3, 7, 'Rio das Ostras', 23960),
       (3, 7, 'Niteroi', 84530);    
       
insert into tbmunicipios (idtipo, idestado, municipio, populacao)
values (2, 3, 'Palmas', 110000),   
       (1, 43, 'Palmas', 150000),   
       (2, 1, 'Palmas', 150000);

--visualizar os dados
select * from tbmunicipios;
--
select * from tbestados;

-- criando uma consulta para listar as seguintes informações
--idestado, estado, sigla e regiao
--3 inf. da tabela de estado e 1 inf da tabela regiao.

-- FORMA ERRADA
select tbestados.idestado, tbestados.estado, tbestados.sigla, tbregioes.regiao from tbestados, tbregioes;

-- FORMA CORRETA
select tbestados.idestado, tbestados.estado, tbestados.sigla, tbregioes.regiao from tbestados inner join tbregioes on tbregioes.idregiao = tbestados.idregiao;

-- JOIN
-- inner join  / só  tras o que esta relacionado
-- left  join  / esquerda do join
-- rigth join  / direita do join


-- inserindo uma regiao XXXX
insert into tbregioes (regiao)
values ('XXXX');

select tbestados.idestado, tbestados.estado, tbestados.sigla, tbregioes.regiao from tbestados right join tbregioes on tbregioes.idregiao = tbestados.idregiao;

--O comando abaixo é equivalente ao inner  join

select tbestados.idestado, tbestados.estado, tbestados.sigla, tbregioes.regiao from tbestados left join tbregioes on tbregioes.idregiao = tbestados.idregiao;

-- Alternativa criar 'alias'
select e.idestado, e.estado, e.sigla, r.regiao from tbestados e left join tbregioes r on r.idregiao = e.idregiao;

-- Criar consulta para listar os seguintes campos
-- idmunicipio, municipio, tipo, populacao

select m.idmunicipio, m.municipio, t.tipo, m.populacao from tbmunicipios m inner join tbtipos t on t.idtipo = m.idtipo;

-- Ordenação diferente
select m.idmunicipio, m.municipio, t.tipo, m.populacao from tbmunicipios m inner join tbtipos t on t.idtipo = m.idtipo order by m.municipio;

select m.idmunicipio, m.municipio, t.tipo, m.populacao from tbmunicipios m inner join tbtipos t on t.idtipo = m.idtipo order by m.idmunicipio;

-- Consulta as informações de tres tabelas
--idmunicipio, municipio, tipo, populacao, estado, sigla

select m.idmunicipio, m.municipio, t.tipo, m.populacao, e.estado, e.sigla from tbtipos t inner join tbmunicipios m on t.idtipo = m.idtipo inner join tbestados e on e.idestado = m.idestado;

-- Consulta as informações de tres tabelas
--idmunicipio, municipio, tipo, populacao, estado, sigla e regiao

select m.idmunicipio, m.municipio, t.tipo, m.populacao, e.estado, e.sigla, r.regiao from tbtipos t inner join tbmunicipios m on t.idtipo = m.idtipo inner join tbestados e on e.idestado = m.idestado inner join tbregioes r on r.idregiao = e.idregiao;

---

select m.idmunicipio, m.municipio, t.tipo, m.populacao, e.estado, e.sigla from tbtipos t inner join tbmunicipios m on t.idtipo = m.idtipo right join tbestados e on e.idestado = m.idestado;

-- Consulta para listar as seguintes informações
-- idmunicipio, municipio
-- apenas dos municipios da regiao Sul

select m.idmunicipio, m.municipio from tbmunicipios m inner join tbestados e on e.idestado = m.idestado inner join tbregioes r on r.idregiao = e.idregiao where r.regiao= 'Sul';


select m.idmunicipio, m.municipio, e.sigla from tbmunicipios m inner join tbestados e on e.idestado = m.idestado inner join tbregioes r on r.idregiao = e.idregiao where r.regiao= 'Sul';

select m.idmunicipio, m.municipio, e.sigla from tbmunicipios m inner join tbestados e on e.idestado = m.idestado inner join tbregioes r on r.idregiao = e.idregiao where (r.regiao= 'Sul') and (m.idtipo =1);

select * from tbestados;
select * from tbestados limit 5;
select * from tbestados limit 5,4;--pule 5 e traga 4

-- select para listar quantos estados temos cadastrados em cada regiao

describe tbregioes;
describe tbestados;

select r.regiao, count(e.idregiao) from tbestados e inner join tbregioes r on r.idregiao = e.idregiao group by r.regiao;

-- alias
select r.regiao Região, count(e.idregiao) 'Total estados' from tbestados e inner join tbregioes r on r.idregiao = e.idregiao group by r.regiao;

--usind(idestado) é equivalente a : on e.idestado = m.idestado
-- pode ser utilizado desde que os campos PK e FK tenham nomes idênticos 
select e.estado, sum(m.populacao) 'Total populacao' from tbestados e inner join tbmunicipios m using(idestado) group by e.estado;

--Mostra todos os estados (mesmo sem populacao/ sem municipios cadastrados)
select e.estado, sum(m.populacao) 'Total populacao' from tbestados e left join tbmunicipios m using(idestado) group by e.estado;

--
select e.idestado, e.estado, e.sigla from tbestados e inner join tbmunicipios m on e.idestado =m.idestado;

-- Listando todos os municipios cadastrados
select distinct(e.idestado), e.estado, e.sigla from tbestados e inner join tbmunicipios m on e.idestado =m.idestado;

-- Listando todos os estados SEM municipios cadastrados
-- 1 encontramos is ID dos estados que tem municipio

select distinct(idestado) from tbmunicipios;

select e.idestado, e.estado, e.sigla
from tbestados e 
where e.idestado not in (select distinct(idestado) from tbmunicipios);

-- selecionando apenas as regioes sem estados cadastrados
select distinct(idregiao) from tbestados;

select tbregioes.regiao from tbregioes 
where tbregioes.idregiao not in (select distinct(idregiao) from tbestados);


-- Qual o municipio com maior populacao em cada estado?

select e.estado, m.municipio, max(m.populacao) from tbestados e inner join tbmunicipios m on e.idestado = m.idestado
group by e.estado
order by m.populacao;







