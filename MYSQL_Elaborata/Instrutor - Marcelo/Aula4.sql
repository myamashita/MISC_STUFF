--Listando todos os eventos

show events;


--Verificando se o Monitor de eventos do mysql est habilitado
show processlist;
+----+------+-----------+-----------+---------+------+-------+----------------
| Id | User | Host      | db        | Command | Time | State | Info           
+----+------+-----------+-----------+---------+------+-------+----------------
| 50 | root | localhost | bdempresa | Query   |    0 | NULL  | show processlis
+----+------+-----------+-----------+---------+------+-------+----------------
1 row in set (0.00 sec)  

--Como o event_Scheduler não aparece na lista acima, precisamos habilitá-lo
set GLOBAL event_scheduler = 1;

show process_list;


--Para desabilitar o monitor de eventos
set GLOBAL event_scheduler = 0;

--Criando um evento que aumentará em 10% o orçamento de todos os setores exatamente no dia 01/10/2015 às 09:45:00

delimiter $$
drop   event if exists evAumentaOrc$$
create event evAumentaOrc on schedule at '2015-10-01 09:47:00' do
begin
  update tbsetores set orcamento = orcamento * 1.1;
end$$
delimiter ;

select * from tbsetores;


--Unidades temporais utilizadas em eventos
    --second, minute, hour, day, week, month, year


--Evento que aumenta o orçamenrto a cada 10 segundos com um início determinado
delimiter $$
drop   event if exists evAumentaOrc2$$
create event evAumentaOrc2 on schedule every 10 second starts '2015-10-01 10:00:00' do
begin
  update tbsetores set orcamento = orcamento * 1.001;
end$$
delimiter ;


show events;



--Evento para criar um novo cargo a cada 2 minutos comaçando daqui 27 segundos e finalizando daqui 12 minutos
delimiter $$
drop   event if exists evNovoCargo$$
create event evNovoCargo on schedule every 2 minute starts now() + interval 27 second
ends now() + interval 12 minute do
begin
  insert into tbcargos 
    (cargo) 
  values 
    (concat('Cargo ', now()));
end$$
delimiter ;


--Evento para realizar o pagamento mensal dos funcionários
delimiter $$
drop event if exists evRealizaPagamentos$$
create event evRealizaPagamentos on schedule every 1 month starts '2015-10-05 00:00:00' do
begin
  insert into tbpagamentos 
    (idfuncionario, idsetor, idcargo, datapagamento, salario)
  (select 
    idfuncionario, idsetor, idcargo, curdate(), salario 
    from tbfuncionarios);
end$$
delimiter ;



--Criação de usuários


show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| bdcontatos         |
| bdempresa          |
| bdmun              |
| mysql              |
| performance_schema |
| phpmyadmin         |
+--------------------+
7 rows in set (0.01 sec)

use mysql;

describe user;

select * from user;



--Criando um novo usuário 
create user 'marcelo'@'localhost' identified by 'mm';
--Usuário criado sem nenhuma permissão de acesso

--Criando permissões de acesso ao Usuário recém criado

grant select, insert, update, delete on bdempresa.* to 'marcelo'@'localhost'; 

show grants for 'marcelo'@'localhost';


--Removendo a permissão de delete para o usuário marcelo
revoke delete on bdempresa.* from 'marcelo'@'localhost';

show grants for 'marcelo'@'localhost';

--Excluindo determinado Usuário
drop user 'nome_do_usuario'@'host_name';


show grants for current_user();


--Backup e Restauração

--Gerando um arquivo texto a partir de um select
--gera um arquivo texto de largura fixa
select * from tbpagamentos into OUTFILE '/tmp/pagamentos.txt';

--Gera um arquivo delimitado por algum caractere especial
select * from tbpagamentos into OUTFILE '/tmp/pagamentos.csv' FIELDS TERMINATED BY ';'  LINES TERMINATED BY '\n';




--GERANDO BACKUP DE DETERMINADO BANDO
--SEMPRE FORA DO MYSQL

mysqldump -uroot -pelaborata --databases bdempresa > '/tmp/backup_empresa.sql'


drop database if exists bdempresa;
--restaurando o banco
--FORA DO MYSQL
mysql -uroot -pelaborata < '/tmp/backup_empresa.sql'


--DENTRO DO MYSQL
source /tmp/backup_empresa.sql;





