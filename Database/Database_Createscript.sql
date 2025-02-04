use master

create database iproject15
go

use iproject15
go

create table Bestand (
	Filenaam			varchar(200)	not null,
	Voorwerp			bigint			not null,
	constraint PK_Bestand primary key (filenaam)
)
go

create table Bod (
	Voorwerp			bigint			not null,
	Bodbedrag			numeric(8,2)	not null,
	Gebruiker			varchar(25)		not null,
	BodDag				date			not null,
	BodTijdstip			time			not null,
	constraint PK_Bod primary key (Voorwerp, Bodbedrag),
	constraint AK_VoorwerpBodDatum unique (Voorwerp, BodDag, BodTijdstip),
	constraint AK_GebruikerBodDatum unique (Gebruiker, BodDag, BodTijdstip),
	constraint CK_Bodbedrag_min check (Bodbedrag > 000000.00),
	constraint CK_Boddag_curr check (BodDag <= GETDATE())
)
go

create table Feedback (
	Voorwerp			bigint			not null,
	Soort_Gebruiker		char(8)			not null, /* moet altijd koper of verkoper in staan */
	Feedbacksoort		numeric(1)		not null, /* 1 tot 5 */
	Dag					date			not null,
	Tijdstip			time			not null,
	Commentaar			varchar(300)	null,
	constraint PK_Feedback primary key (Voorwerp, Soort_Gebruiker),
	constraint CK_SoortGebruiker check (Soort_Gebruiker IN ('Koper', 'Verkoper')),
	constraint CK_Feedback_min check (Feedbacksoort >= 1),
	constraint CK_Feedback_max check (Feedbacksoort <= 5)
)
go

create table Gebruiker (
	Gebruikersnaam		varchar(25)		not null,
	Voornaam			varchar(30)		not null,
	Achternaam			varchar(30)		not null,
	Adresregel1			varchar(40)		not null,
	Adresregel2			varchar(40)		null,
	Postcode			char(12)		not null,
	Plaatsnaam			varchar(50)		not null,
	Land				varchar(40)		not null,
	GeboorteDag			date			not null,
	Mailbox				varchar(255)	not null,
	Wachtwoord			varchar(300)	not null, /* hashed */
	Vraag				tinyint			not null,
	Antwoordtext		varchar(300)	not null,
	Verkoper			bit				not null,
	Geactiveerd			bit				not null,
	constraint PK_Gebruiker primary key (Gebruikersnaam),
	constraint CK_GeboorteDag_currdate check (GeboorteDag <= GETDATE()),
	constraint CK_Mailbox_Gebruiker check (Mailbox LIKE '%@%')
)
go

create table Admin (
	Gebruikersnaam		varchar(25)		not null,
	Voornaam			varchar(30)		not null,
	Achternaam			varchar(30)		not null,
	Mailbox				varchar(255)	not null,
	Wachtwoord			varchar(300)	not null /* hashed */
	constraint PK_Admin primary key (Gebruikersnaam),
	constraint CK_Mailbox_Admin check (Mailbox LIKE '%@%')
)
go

create table Gebruikerstelefoon (
	Volgnr				tinyint			not null,
	Gebruiker			varchar(25)		not null,
	Telefoon			varchar(15)		not null
	constraint PK_Gebruikerstelefoon primary key (Volgnr, Gebruiker),
)
go

create table Rubriek (
	Rubrieknummer		int				not null,
	Rubrieknaam			varchar(50)		not null,
	Hoofdrubriek		int				null,
	Volgnr				int				not null,
	constraint PK_Rubriek primary key (rubrieknummer),
	constraint CK_Hoofdrubriek check (Hoofdrubriek <> Rubrieknummer)
)
go

create table Verkoper (
	Gebruiker			varchar(25)		not null,
	Bank				varchar(20)		null,
	Bankrekening		varchar(50)		null,
	Controle_optie		varchar(20)		not null,
	Creditcard			varchar(20)		null
	constraint PK_Verkoper primary key (Gebruiker),
	constraint CK_Controleoptie check (Controle_optie IN ('Goedgekeurd', 'In afwachting', 'Afgekeurd')),
	constraint CK_Bank check (Bank IN ('ING','Rabobank', 'ABN-Amro', 'ASN', 'SNS', 'DHB', 'Bunq', 'Knab', 'Triodos bank'))
)
go

create table Voorwerp (
	Voorwerpnummer			bigint			IDENTITY(0,1),
	Titel					varchar(100)	not null,
	Beschrijving			varchar(2000)	not null,
	Startprijs				numeric(8,2)	not null,
	Betalingswijze			varchar(40)		not null,
	Betalingsinstructie		varchar(200)	null,
	Plaatsnaam				varchar(50)		not null,
	Land					varchar(40)		not null,
	Looptijd				tinyint			not null,
	LooptijdbeginDag		date			not null,
	LooptijdbeginTijdstip	time			not null,
	Verzendkosten			numeric(8,2)	null,
	Verzendinstructies		varchar(200)	null,
	Verkoper				varchar(25)		not null,
	Koper					varchar(25)		null,
	LooptijdeindeDag		date			not null,
	LooptijdeindeTijdstip	time			not null,
	VeiligGesloten			bit				not null,
	Verkoopprijs			numeric(8,2)	null
	constraint PK_Voorwerp primary key (Voorwerpnummer),
	constraint CK_Startprijs_min CHECK (Startprijs > 000000.00),
	constraint CK_LooptijdeindeDag CHECK (LooptijdeindeDag > GETDATE()),
	constraint CK_LooptijdWaarde CHECK (Looptijd IN (1, 3, 5, 7, 10))
)
go

create table Voorwerp_in_Rubriek (
	Voorwerp					bigint			not null,
	Rubriek_op_Laagste_Niveau	int				not null
	constraint PK_VoorwerpInRubriek primary key (Voorwerp, Rubriek_op_Laagste_Niveau)
)
go

create table Vraag (
	Vraagnummer					tinyint			not null,
	Tekst_vraag					varchar(100)	not null
	constraint PK_Vraag primary key (Vraagnummer)
)
go

create table Verificatie (
	Gebruikersnaam				varchar(25)		not null,
	Verificatiecode				int				null
	constraint PK_Verificatie primary key (Gebruikersnaam)
)
go

CREATE TABLE geblokkeerdeVeilingen (
    AdvertentieID				BIGINT			NOT NULL,
    Datum						date			NOT NULL,
    Reden						VARCHAR (1000)	NOT NULL
    CONSTRAINT PK_geblokkeerdeVeilingen PRIMARY KEY (AdvertentieID),
    constraint FK_geblokkeerdeVeilingen_AdvertentieID foreign key (AdvertentieID)
		references Voorwerp (Voorwerpnummer)
            on update no action on delete no action
);


CREATE TABLE Rapporteren (
    AdvertentieID				BIGINT			NOT NULL,
    Rapporteerde				VARCHAR (25)	NOT NULL,
    Omschrijving				VARCHAR (1000)	NOT NULL
    CONSTRAINT PK_Rapporteren PRIMARY KEY (AdvertentieID, Rapporteerde),
    constraint FK_Rapporteren_Rappoteerde foreign key (Rapporteerde)
		references Gebruiker (Gebruikersnaam)
            on update no action on delete no action,
        constraint FK_Rapporteren_AdvertentieID foreign key (AdvertentieID)
		references Voorwerp (Voorwerpnummer)
            on update no action on delete no action

);

CREATE TABLE geblokkeerd (
    Gebruiker					VARCHAR (25)	NOT NULL,
    Datum						date			NOT NULL,
    Reden						VARCHAR (1000)	NOT NULL,
	Duur						int				NOT NULL 
    CONSTRAINT PK_geblokkeerd PRIMARY KEY (Gebruiker),
    constraint FK_Geblokkeerd_Gebruiker foreign key (Gebruiker)
		references Gebruiker (Gebruikersnaam)
            on update no action on delete no action
);



alter table Bestand
	add constraint FK_Bestand_Ref_Voorwerp foreign key (Voorwerp)
			references Voorwerp (Voorwerpnummer)
			on update no action on delete no action

alter table Bod
	add constraint FK_Bod_Ref_Voorwerp foreign key (Voorwerp)
			references Voorwerp (Voorwerpnummer)
			on update no action on delete no action,
		constraint FK_Bod_Ref_Gebruikersnaam foreign key (Gebruiker)
			references Gebruiker (Gebruikersnaam)
			on update no action on delete no action

alter table Feedback
	add constraint FK_Feedback_Ref_Voorwerpnummer foreign key (Voorwerp)
			references Voorwerp (Voorwerpnummer)
			on update no action on delete no action

alter table Gebruiker
	add constraint FK_Gebruiker_Ref_Vraagnummer foreign key (Vraag)
			references Vraag (Vraagnummer)
			on update cascade on delete cascade, /* veranderingen aan een gebruiker moeten overal komen */
		constraint UNIQUE_Mail unique (Mailbox)

alter table Gebruikerstelefoon
	add constraint FK_Gebruikerstelefoon_Ref_Gebruikersnaam foreign key (Gebruiker)
			references Gebruiker (Gebruikersnaam)
			on update no action on delete no action

alter table Rubriek
	add constraint FK_Rubriek_Ref_Rubrieknummer foreign key (Hoofdrubriek)
			references Rubriek (Rubrieknummer)
			on update no action on delete no action

alter table Verkoper
	add constraint FK_Verkoper_Ref_Gebruikersnaam foreign key (Gebruiker)
			references Gebruiker (Gebruikersnaam)
			on update no action on delete no action

alter table Voorwerp
	add constraint FK_Voorwerp_Ref_Verkoper foreign key (Verkoper)
			references Verkoper (Gebruiker)
			on update no action on delete no action,
		constraint FK_Voorwerp_Ref_Gebruiker foreign key (Koper)
			references Gebruiker (Gebruikersnaam)
			on update no action on delete no action

alter table Voorwerp_in_Rubriek
	add constraint FK_VRubriek_Ref_Voorwerpnummer foreign key (Voorwerp)
			references Voorwerp (Voorwerpnummer)
			on update no action on delete no action,
		constraint FK_VRubriek_Ref_Rubrieknummer foreign key (Rubriek_op_Laagste_Niveau)
			references Rubriek (Rubrieknummer)
			on update cascade on delete no action

alter table Verificatie
	add constraint FK_Verificatie_Ref_Gebruiker foreign key (Gebruikersnaam)
			references Gebruiker (Gebruikersnaam)
			on update no action on delete no action

