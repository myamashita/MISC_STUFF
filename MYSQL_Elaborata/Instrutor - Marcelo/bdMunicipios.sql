--Criando um novo banco de dados
drop   database if exists bdmun;
create database bdmun;

--Acessando o Banco de dados recém criado
use bdmun;

--Criação das tabelas: Programamos "todos os campos" informando apenas a chave primária. Chaves estrangeiras serão informadas a posteriori.

--Criando a tabela de tipos (Sem FK)
drop   table if exists tbtipos;
create table tbtipos(
  idtipo int not null auto_increment,
  tipo varchar(50) not null,
  primary key (idtipo)
);

--Criando a tabela de Regiões (Sem FK)
drop   table if exists tbregioes;
create table tbregioes(
  idregiao int not null auto_increment,
  região varchar(50) not null,
  primary key (idregiao)
);

--Criando a tabela de Estados (1 FK)
--Obs: Ainda não informamos que idregiao é uma FK
drop   table if exists tbestados;
create table tbestados(
  idestado int not null auto_increment,
  idregiao int not null,
  estado   varchar(100) not null,
  sigla    char(2) not null,
  primary key (idestado)
);
describe tbestados;
--Criando a tabela de Municípios (2 FKs)
--Obs: também não informamos que idtipo e idestado são FKs
drop table if exists tbmunicipios;
create table tbmunicipios(
  idmunicipio int not null auto_increment,
  idtipo   int not null,
  idestado int not null,
  municipio varchar (255) not null,
  primary key (idmunicipio)
);


--Agora analisamos a estrutura de da cada tabela

describe tbtipos;
+--------+-------------+------+-----+---------+----------------+
| Field  | Type        | Null | Key | Default | Extra          |
+--------+-------------+------+-----+---------+----------------+
| idtipo | int(11)     | NO   | PRI | NULL    | auto_increment |
| tipo   | varchar(50) | NO   |     | NULL    |                |
+--------+-------------+------+-----+---------+----------------+
2 rows in set (0.00 sec)

describe tbregioes;
+----------+-------------+------+-----+---------+----------------+
| Field    | Type        | Null | Key | Default | Extra          |
+----------+-------------+------+-----+---------+----------------+
| idregiao | int(11)     | NO   | PRI | NULL    | auto_increment |
| região   | varchar(50) | NO   |     | NULL    |                |
+----------+-------------+------+-----+---------+----------------+
2 rows in set (0.00 sec)

--verificamos que o campo região está incorreto, trocaremos para regiao
alter table tbregioes change região regiao varchar(50) not null;


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


--adicionando o campo populacao à tabela de municipios
alter table tbmunicipios add populacao int null default 0;


--Agora criaremos as 3 Chaves estrangeiras (Foreign Key)
alter table tbestados add foreign key (idregiao)
references tbregioes (idregiao);

alter table tbmunicipios add foreign key (idestado)
references tbestados (idestado);

alter table tbmunicipios add foreign key (idtipo)
references tbtipos (idtipo);


describe tbestados;

--criação dos Índices
create unique index idxtipostipo on tbtipos (tipo);
create unique index idxregioesregiao on tbregioes (regiao);
create unique index idxestadosestado on tbestados (estado);
create unique index idxestadossigla on tbestados (sigla);

create index idxmunicipiosmunicipio on tbmunicipios (municipio);

create unique index idxmunicipios_mun_idestado on tbmunicipios (municipio, idestado);

--Visualizando os Índices em determinada tabela
show indexes in tbmunicipios;

--excluindo determinado índice de determinada tabela
drop index NOME_DO_ÍNDICE on NOME_DA_TABELA;



--CADASTRANDO OS 3 TIPOS NA TABELA DE TIPOS
insert into tbtipos (tipo)
values ('Capital'), 
       ('Interior'), 
       ('Litoral');
Query OK, 3 rows affected (0.04 sec)
Records: 3  Duplicates: 0  Warnings: 0

insert into tbtipos (tipo)
values ('Capital');
ERROR 1062 (23000): Duplicate entry 'Capital' for key 'idxtipostipo'


--CADASTRANDO AS 5 REGIÕES
insert into tbregioes (regiao)
values ('Centro-Oeste'),
       ('Nordeste'),
       ('Norte'),
       ('Sudeste'),
       ('Sul');

select * from tbtipos;
select * from tbregioes;


--cadastrando os 3 estados da região SUL
insert into tbestados (idregiao, estado, sigla)
values (5, 'Paraná', 'PR'),
       (5, 'Rio Grande Do Sul', 'RS'),
       (5, 'Santa Catarina', 'SC');

       
--cadastrando os 4 estados da região SUDESTE
insert into tbestados (idregiao, estado, sigla)
values (4, 'Espírito Santo', 'ES'),
       (4, 'Minas Gerais', 'MG'),
       (4, 'Rio de Janeiro', 'RJ'),
       (4, 'São Paulo', 'SP');

--cadastrando os 3 estados da região Centro-Oeste
insert into tbestados (idregiao, estado, sigla)
values (1, 'Mato Grosso', 'MT'),
       (1, 'Mato Grosso Do Sul', 'MS'),
       (1, 'Goías', 'GO'),
       (1, 'Distrito Federal', 'DF');
       
       
--cadastrando os 9 estados da região Nordeste
insert into tbestados (idregiao, estado, sigla)
values (2, 'Maranhão', 'MA'),
       (2, 'Piauí', 'PI'),
       (2, 'Ceará', 'CE'),
       (2, 'Rio Grande do Norte', 'RN'),
       (2, 'Paraíba', 'PB'),
       (2, 'Pernambuco', 'PE'),
       (2, 'Alagoas', 'AL'),
       (2, 'Sergipe', 'SE'),
       (2, 'Bahia', 'BA');
       
--cadastrando os 7 estados da região Norte
insert into tbestados (idregiao, estado, sigla)
values (3, 'Tocantins', 'TO'),
       (3, 'Amazonas', 'AM'),
       (3, 'Acre', 'AC'),
       (3, 'Roraima', 'RR'),
       (3, 'Rondônia', 'RO'),
       (3, 'Pará', 'PA'),
       (3, 'Amapá', 'AP');
       
       
--Cadastrando alguns municípios no Paraná
insert into tbmunicipios (idtipo, idestado, municipio, populacao)
values (1, 1, 'Curitiba', 1000000),
       (2, 1, 'Pinhais', 100000),
       (2, 1, 'Quatro Barras', 500000),
       (2, 1, 'Gurapuava', 100000),
       (2, 1, 'Lapa', 10000),
       (3, 1, 'Praia de Leste', 22547),
       (3, 1, 'Guaratuba', 5000),
       (3, 1, 'Antonina', 11274);

--Cadastrando alguns municípios em São Paulo
insert into tbmunicipios (idtipo, idestado, municipio, populacao)
values (1, 7, 'São Paulo', 20000000),
       (2, 7, 'Campinas', 1000000),
       (2, 7, 'Santo André', 500000),
       (2, 7, 'São Bernardo', 100000),
       (2, 7, 'Diadema', 10000),
       (3, 7, 'Santos', 225470),
       (3, 7, 'Ubatuba', 50000),
       (3, 7, 'Guarujá', 112741);

--Cadastrando alguns municípios em São Paulo
insert into tbmunicipios (idtipo, idestado, municipio, populacao)
values (1, 6, 'Rio de Janeiro', 1040000),
       (3, 6, 'Macaé', 551174),
       (2, 6, 'Resende', 77258),
       (3, 6, 'Rio das Ostras', 225470),
       (2, 6, 'Magé', 50000),
       (2, 6, 'Campos', 50000);


insert into tbmunicipios (idtipo, idestado, municipio, populacao)
values (1, 21, 'Palmas', 1040000),
       (2, 1, 'Palmas', 551174),
       (2, 2, 'Palmas', 77258);

       
       
select * from tbestados;
       
--criando uma Consulta para listar as seguintes informações
  --idestado, estado, sigla e regiao

  --FORMA ERRADA
select tbestados.idestado, tbestados.estado, tbestados.sigla, tbregioes.regiao
from tbestados, tbregioes;

  --FORMA CORRETA
select tbestados.idestado, tbestados.estado, tbestados.sigla, tbregioes.regiao
from tbestados inner join tbregioes on tbregioes.idregiao = tbestados.idregiao;  


--inserindo uma região XXXX
insert into tbregioes (regiao)
values ('XXXX');


select tbestados.idestado, tbestados.estado, tbestados.sigla, tbregioes.regiao
from tbestados right join tbregioes on tbregioes.idregiao = tbestados.idregiao; 
  
--O camando abaixo é equivalente ao inner join  
select tbestados.idestado, tbestados.estado, tbestados.sigla, tbregioes.regiao
from tbestados left join tbregioes on tbregioes.idregiao = tbestados.idregiao;


--Alternativa
select e.idestado, e.estado, e.sigla, r.regiao
from tbestados e inner join tbregioes r on r.idregiao = e.idregiao;


--Criar uma consulta para listar os seguintes campos
  --idmunicipio, municipio, tipo, populacao
select m.idmunicipio, m.municipio, t.tipo, m.populacao
from tbmunicipios m inner join tbtipos t on t.idtipo = m.idtipo
order by m.idmunicipio;

--Criar uma consulta para listar os seguintes campos
  --idmunicipio, municipio, tipo, populacao, estado, sigla
select m.idmunicipio, m.municipio, t.tipo, e.estado, e.sigla, m.populacao
from tbtipos t inner join tbmunicipios m on t.idtipo = m.idtipo
	       inner join tbestados    e on e.idestado = m.idestado;

--Criar uma consulta para listar os seguintes campos
  --idmunicipio, municipio, tipo, populacao, estado, sigla, regiao
select m.idmunicipio, m.municipio, t.tipo, e.estado, e.sigla, r.regiao, m.populacao
from tbtipos t inner join tbmunicipios m on t.idtipo = m.idtipo
	       inner join tbestados    e on e.idestado = m.idestado
	       inner join tbregioes    r on r.idregiao = e.idregiao;
	       
	       
select m.idmunicipio, m.municipio, t.tipo, e.estado, e.sigla, m.populacao
from tbtipos t inner join tbmunicipios m on t.idtipo = m.idtipo
	       right join tbestados    e on e.idestado = m.idestado;
       
       
       
--Consulta para listar as seguintes informações
  --idmunicipio, municipio
--apenas dos municipíos da região Sul
select m.idmunicipio, m.municipio
from tbmunicipios m inner join tbestados e on e.idestado = m.idestado
                    inner join tbregioes r on r.idregiao = e.idregiao
where r.regiao = 'Sul';

--Consulta para listar as seguintes informações
  --idmunicipio, municipio, estado, sigla
--apenas dos municipíos da região Sul       
select m.idmunicipio, m.municipio, e.estado, e.sigla
from tbmunicipios m inner join tbestados e on e.idestado = m.idestado
                    inner join tbregioes r on r.idregiao = e.idregiao
where (r.regiao = 'Sul') and (m.idtipo = 1) ;       





select * from tbestados;

select * from tbestados limit 0, 5;

select * from tbestados limit 5, 5;


--Select para listar quantos estados temos cadastrados em cada região

select r.regiao Região, count(e.idregiao) Total_Estados
from tbestados e inner join tbregioes r on r.idregiao = e.idregiao
group by r.regiao;

--using(idestado) é equivalente a: on e.idestado = m.idestado
--pode ser utilizado desde que os campos PK e FK tenham nomes idênticos
select e.estado, sum(m.populacao)
from tbestados e inner join tbmunicipios m using(idestado)
group by e.estado;

--Mostra TODOS os estados, inclusives os que não tem municipios cadastrados
select e.estado, sum(m.populacao)
from tbestados e left join tbmunicipios m using(idestado)
group by e.estado;



--Listando todos os estados com municipios cadastrados
select distinct(e.idestado), e.estado, e.sigla
from tbestados e inner join tbmunicipios m on e.idestado = m.idestado;


--Listando todos os estados SEM municipios cadastrados
--1º Encontramos os ID dos estados que tem municipio
select distinct(idestado) from tbmunicipios;


select e.idestado, e.estado, e.sigla
from tbestados e
where e.idestado not in (select distinct(idestado) from tbmunicipios);



--Selecionando somente as Regiões sem estados cadastrados
select r.regiao from tbregioes r
where r.idregiao not in (select distinct(idregiao) from tbestados);

--Qual o município com maior população em cada estado?
select e.estado, m.municipio, max(m.populacao)
from tbestados e inner join tbmunicipios m on e.idestado = m.idestado
group by e.estado
order by m.populacao;






