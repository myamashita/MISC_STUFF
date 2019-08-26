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
end$$
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







