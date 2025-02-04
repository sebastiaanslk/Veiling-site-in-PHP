use iproject15
go

CREATE TABLE Users
( 
  Username VARCHAR(200),
  Postalcode VARCHAR(9),
  Location VARCHAR(MAX),
  Country VARCHAR(100),
  Rating NUMERIC(4,1) 
)
Go

CREATE TABLE Categorieen
(
	ID int NOT NULL,
	Name varchar(100) NULL,
	Parent int NULL,
	CONSTRAINT PK_Categorieen PRIMARY KEY (ID)
)
Go

CREATE TABLE Items
(
	ID bigint NOT NULL,
	Titel varchar(max) NULL,
	Beschrijving nvarchar(max) NULL,
	Categorie int NULL,
	Postcode varchar(max) NULL,
	Locatie varchar(max) NULL,
	Land varchar(max) NULL,
	Verkoper varchar(max) NULL,
	Prijs varchar(max) NULL,
	Valuta varchar(max) NULL,
	Conditie varchar(max) NULL,
	Thumbnail varchar(max) NULL,
	CONSTRAINT PK_Items PRIMARY KEY (ID),
)
Go

CREATE TABLE Illustraties
(
	ItemID bigint NOT NULL,
	IllustratieFile varchar(100) NOT NULL,
    CONSTRAINT PK_ItemPlaatjes PRIMARY KEY (ItemID, IllustratieFile),
)
Go

CREATE TABLE tblIMAOLand
(
  GBA_CODE CHAR(4) NOT NULL,
  NAAM_LAND VARCHAR(40) NOT NULL,
  BEGINDATUM DATE NULL,
  EINDDATUM DATE NULL,
  EER_Lid BIT NOT NULL DEFAULT 0,
  CONSTRAINT PK_tblIMAOLand PRIMARY KEY (NAAM_LAND),
  CONSTRAINT UQ_tblIMAOLand UNIQUE (GBA_CODE),
  CONSTRAINT CHK_CODE CHECK ( LEN(GBA_CODE) = 4 ),
  CONSTRAINT CHK_DATUM CHECK ( BEGINDATUM < EINDDATUM )
)
Go

alter table Items
	add constraint FK_items_In_Categorie foreign key (Categorie)
			references Categorieen (ID)
			on update no action on delete no action
Go

alter table Illustraties
	add constraint [ItemsVoorPlaatje] foreign key (ItemID)
			references Items (ID)
			on update no action on delete no action
Go
