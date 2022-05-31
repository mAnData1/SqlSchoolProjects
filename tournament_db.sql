drop database TournamentDB;
create database TournamentDB;
use TournamentDB;

create table Nationalities(
	id int,
    nationality varchar(30),
    
    constraint PK_Nationalities primary key (id)
);

create table Players(
	id int,
    age int check(age > 0),
    nationalityId int,
    
    constraint PK_Players primary key(id),
    constraint FK_Players foreign key (nationalityId)
    references Nationalities(id)
);

create table Tournaments(
	id int,
    tournamentName varchar(30),
    dateOpen datetime,
    dateClose datetime check(dateClose > dateOpen),
    price decimal check (price > 0),
    
    constraint PK_Tournaments primary key (id)
);

create table TournamentsPlayers(
	tournamentID int,
    playerID int,
    tournamentRank int,
    tournamentWin bool,
    tournamentPoints int check(tournamentPoints > 0),
    
    
    constraint PK_TournamentsPlayers primary key(tournamentID, playerID)
    );
    
alter table TournamentsPlayers add foreign key(tournamentID)
    references Tournaments(id);
alter table TournamentsPlayers add foreign key(playerID)
    references Players(id);