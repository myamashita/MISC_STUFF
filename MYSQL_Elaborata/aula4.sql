-- Aula 4
-- listando todos os eventos

show events;

-- Verificando se o monitor de eventos do mysql esta habilitado
show processlist;
+----+------+-----------+--------+---------+------+-------+------------------+
| Id | User | Host      | db     | Command | Time | State | Info             |
+----+------+-----------+--------+---------+------+-------+------------------+
| 50 | root | localhost | bdfunc | Query   |    0 | NULL  | show processlist |
+----+------+-----------+--------+---------+------+-------+------------------+
1 row in set (0.00 sec)

-- Como o event_Scheduler não aparece na lista acima, precisamos habilita-lo
set GLOBAL event_scheduler = 1;

show processlist;
+----+-----------------+-----------+--------+---------+------+------------------------+------------------+
| Id | User            | Host      | db     | Command | Time | State                  | Info             |
+----+-----------------+-----------+--------+---------+------+------------------------+------------------+
| 50 | root            | localhost | bdfunc | Query   |    0 | NULL                   | show processlist |
| 51 | event_scheduler | localhost | NULL   | Daemon  |   23 | Waiting on empty queue | NULL             |
+----+-----------------+-----------+--------+---------+------+------------------------+------------------+
2 rows in set (0.00 sec)


-- Para desabilitar o monitor de eventos
set GLOBAL event_scheduler = 0 ;
show processlist;
+----+------+-----------+--------+---------+------+-------+------------------+
| Id | User | Host      | db     | Command | Time | State | Info             |
+----+------+-----------+--------+---------+------+-------+------------------+
| 50 | root | localhost | bdfunc | Query   |    0 | NULL  | show processlist |
+----+------+-----------+--------+---------+------+-------+------------------+
1 row in set (0.00 sec)


-- Criando um evento que aumentara em 10% o orcamento de todos os setores exatamente no dia 01/10/2015 às 09:45:00

delimiter $$
drop event if exists evAumentaOrc$$
create event evAumentaOrc on schedule at '2015-10-01 09:47:00' do
begin
  update tbsetores set orcamento = orcamento *1.1;
end$$
delimiter ;

set GLOBAL event_scheduler = 1 ;

select * from tbsetores;


--- Unidades temporais utilizadas em eventos
-- second, minute, hour, day, week, month, year

-- Evento que aumenta o orcamento a cada 10 segundos com um inicio determinado

delimiter $$
drop event if exists evAumentaOrc2$$
create event evAumentaOrc2 on schedule every 10 second starts '2015-10-01 10:00:00' do
begin
  update tbsetores set orcamento = orcamento*1.001;
end$$
delimiter ;

show events;

mysql> show events\G;
*************************** 1. row ***************************
                  Db: bdfunc
                Name: evAumentaOrc2
             Definer: root@localhost
           Time zone: SYSTEM
                Type: RECURRING
          Execute at: NULL
      Interval value: 10
      Interval field: SECOND
              Starts: 2015-10-01 10:00:00
                Ends: NULL
              Status: ENABLED
          Originator: 0
character_set_client: utf8
collation_connection: utf8_general_ci
  Database Collation: latin1_swedish_ci
1 row in set (0.01 sec)


-- evento para criar um novo cargo a cada dois minutos começando daqui 27 segundos e finalizando daqui 12 minutos
delimiter $$
drop event if exists evNovoCargo$$
create event evNovoCargo on schedule every 2 minute starts now() + interval 27 second  ends now() + interval 12 minute do
begin
  insert into tbcargos (cargo)
  values (concat('Cargo', now()));
end$$
delimiter ;

show events;
+--------+---------------+----------------+-----------+-----------+------------+----------------+----------------+---------------------+------+---------+------------+----------------------+----------------------+--------------------+
| Db     | Name          | Definer        | Time zone | Type      | Execute at | Interval value | Interval field | Starts              | Ends | Status  | Originator | character_set_client | collation_connection | Database Collation |
+--------+---------------+----------------+-----------+-----------+------------+----------------+----------------+---------------------+------+---------+------------+----------------------+----------------------+--------------------+
| bdfunc | evAumentaOrc2 | root@localhost | SYSTEM    | RECURRING | NULL       | 10             | SECOND         | 2015-10-01 10:00:00 | NULL | ENABLED |          0 | utf8                 | utf8_general_ci      | latin1_swedish_ci  |
| bdfunc | evNovoCargo   | root@localhost | SYSTEM    | RECURRING | NULL       | 2              | MINUTE         | 2015-10-01 10:26:33 | NULL | ENABLED |          0 | utf8                 | utf8_general_ci      | latin1_swedish_ci  |
+--------+---------------+----------------+-----------+-----------+------------+----------------+----------------+---------------------+------+---------+------------+----------------------+----------------------+--------------------+


-- criar para pagamento a partir de um dia do mes

delimiter $$
drop event if exists evPagmensal$$
create event evPagmensal on schedule every 1 month starts '2015-10-01 11:02:00' do
begin

  insert into tbpagamentos(idfuncionario, idsetor, idcargo, datapagamento, salario)
  (select f.idfuncionario, f.idsetor, f.idcargo , curdate(), f.salario from tbfuncionarios f);

end$$
delimiter ;


--fazer alguns testes
start transaction;
  insert into tbpagamentos(idfuncionario, idsetor, idcargo, datapagamento, salario)
  select f.idfuncionario, f.idsetor, f.idcargo ,now(), f.salario from tbfuncionarios f ;
select * from tbpagamentos;
rollback;
----------


show events;


-- Ceiação de Usuarios

show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| bdcontatos         |
| bdfunc             |
| bdmun              |
| mysql              |
| performance_schema |
| phpmyadmin         |
+--------------------+

-- Tabela mysql
use mysql;

-- conteudo
show tables;
+---------------------------+
| Tables_in_mysql           |
+---------------------------+
| columns_priv              |
| db                        |
| event                     |
| func                      |
| general_log               |
| help_category             |
| help_keyword              |
| help_relation             |
| help_topic                |
| host                      |
| ndb_binlog_index          |
| plugin                    |
| proc                      |
| procs_priv                |
| proxies_priv              |
| servers                   |
| slow_log                  |
| tables_priv               |
| time_zone                 |
| time_zone_leap_second     |
| time_zone_name            |
| time_zone_transition      |
| time_zone_transition_type |
| user                      |
+---------------------------+

describe user;

select * from user;

-- criando um novo Usuarios
create user 'marcio'@'localhost' identified by 'mm';
-- Usuarios criado sem NENHUMA PERMISSÃO DE ACESSO

-- criando permissões de acesso ao Usuarios recem criado

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| bdcontatos         |
| bdfunc             |
| bdmun              |
| mysql              |
| performance_schema |
| phpmyadmin         |
+--------------------+
-- Deixar apenas no banco bdfunc

grant select, insert, update, delete on bdfunc.* to 'marcio'@'localhost';

show grants for 'marcio'@'localhost';

-- Removendo a permissão de delete para o Usuarios marcio
revoke delete on bdfunc.* from 'marcio'@'localhost';

show grants for 'marcio'@'localhost';

-- Excluindo determinado Usuario
drop user 'nome_do_usuario'@'host_name';

--Acessando pelo novo usuario
mysql -umarcio -pmm

show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| bdfunc             |
+--------------------+

use bdfunc;
select * from tbcargos;


delete from tbcargos where idcargo =4;
ERROR 1142 (42000): DELETE command denied to user 'marcio'@'localhost' for table 'tbcargos'


show grants for 'marcio'@'localhost';

show grants for current_user();


-- Backup e Restauração


-- Geração de arquivo txt de um select
-- gera um arquivo texto de largura fixa
select * from tbpagamentos into OUTFILE '/tmp/pagamento.txt';

-- gera um arquivo delimitado por algum caracter especial
select * from tbpagamentos into OUTFILE '/tmp/pagamento.csv' FIELDS terminated by ';' lines terminated by '\n';


--Gerando backup de determinado banco
-- 	SEMPRE FORA DO MYSQL	
mysqldump -uroot -pelaborata --databases bdfunc > '/tmp/backup_bdfunc.sql'


drop database if exists bdfunc;
-- Restauração
--Fora do mysql

mysql -uroot -pelaborata < '/tmp/backup_bdfunc.sql'

-- Dentro do MYSQL

source /tmp/backup_dbfunc.sql;





















































