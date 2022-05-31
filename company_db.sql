create database Company;

use Company;
create table Employees(
id int,
firstName varchar(40) not null,
lastName varchar(40) not null,
experience int(2) check(experience > 0 AND experience <= 70),
salary decimal(9,2) check(salary > 0),

constraint PK_Employees primary key(id)
);

create table Teams(
id int,
tName varchar(60),

constraint PK_Teams primary key(id)
);

create table TeamsEmployees(
teamID int,
empID int,

constraint PK_TeamsEmployees primary key(teamID, empID)
);

alter table TeamsEmployees add constraint FK_TeamsEmployees_Teams foreign key(teamID)
references Teams(id),
add constraint FK_TeamsEmployees_Employees foreign key(empID)
references Employees(id);

create table Tasks(
id int,
description text,
startDate datetime not null,
dueDate datetime check(startDate <= dueDate),
teamId int,

constraint PK_Tasks primary key(id),
constraint FK_Tasks foreign key(teamId)
references Teams(id)
);