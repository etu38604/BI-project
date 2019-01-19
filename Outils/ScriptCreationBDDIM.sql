Create Table [dbo].[DimProduct]
(
	Id int primary key identity(1,1),
	FrenchName nvarchar(50) NOT NULL,
	DutchName nvarchar(50) NOT NULL,
	GermanName nvarchar(50) NOT NULL,
	EnglishName nvarchar(50) NOT NULL,
	UnitPriceExcludingVAT decimal(5,2) NOT NULL,
	VATRate decimal(5,2) NOT NULL,
	CategoryFrenchName nvarchar(50) NOT NULL,
	CategoryDutchName nvarchar(50) NOT NULL,
	CategoryGermanName nvarchar(50) NOT NULL,
	CategoryEnglishName nvarchar(50) NOT NULL,
	DepartmentFrenchName nvarchar(50) NOT NULL,
	DepartmentDutchName nvarchar(50) NOT NULL,
	DepartmentGermanName nvarchar(50) NOT NULL,
	DepartmentEnglishName nvarchar(50) NOT NULL,
	Brand nvarchar(50) NOT NULL,
	OriginalId int NOT NULL
);

Create Table [dbo].[DimStore]
(
	Id int primary key identity(1,1),
	PostalCode nvarchar(50) NOT NULL,
	Province nvarchar(255) NOT NULL,
	Name nvarchar(50) NOT NULL,
	StreetAndNumber nvarchar(255) NOT NULL,
	SalesAeraSquareMeters decimal(5,2) NOT NULL,
	CityFrenchName nvarchar(50) NOT NULL,
	CityDutchName nvarchar(50) NOT NULL,
	CityGermanName nvarchar(50) NOT NULL,
	CityEnglishName nvarchar(50) NOT NULL,
	CountryFrenchName nvarchar(50) NOT NULL,
	CountryDutchName nvarchar(50) NOT NULL,
	CountryGermanName nvarchar(50) NOT NULL,
	CountryEnglishName nvarchar(50) NOT NULL,
	Brand nvarchar(50) NOT NULL,
	OriginalId int NOT NULL
);

Create Table [dbo].[DimCustomer]
(
	Id int primary key identity(1,1),
	LastName nvarchar(50) NOT NULL,
	FirstName nvarchar(50) NOT NULL,
	StreetAndNumber nvarchar(255) NOT NULL,
	PostalCode int NOT NULL,
	Province nvarchar(255) NOT NULL,
	CityName nvarchar(255) NOT NULL,
	HouseHoldsize int NOT NULL,
	LoyaltyCardNumber varchar(10) NOT NULL,
	LoyaltyCardCreationDate datetime NOT NULL,
	FrenchMaritalSatus nvarchar(50) NOT NULL,
	DutchMaritalSatus nvarchar(50) NOT NULL,
	GermanMaritalSatus nvarchar(50) NOT NULL,
	EnglishMaritalSatus nvarchar(50) NOT NULL,
	Brand nvarchar(50) NOT NULL,
	OriginalId int NOT NULL
);

Create Table [dbo].[DimDate]
(
	Id int primary key,
	FullDate date NOT NULL,
	DayNumberOfWeek int NOT NULL,
	DayNumberOfMonth int NOT NULL,
	DayNumberOfYear int NOT NULL,
	MonthNumberOfYear int NOT NULL,
	Year int NOT NULL,
	FrenchNameDayOfWeek nvarchar(50) NOT NULL,
	DutchNameDayOfWeek nvarchar(50) NOT NULL,
	GermanNameDayOfWeek nvarchar(50) NOT NULL,
	EnglishNameDayOfWeek nvarchar(50) NOT NULL,
	FrenchMonthName nvarchar(50) NOT NULL,
	DutchMonthName nvarchar(50) NOT NULL,
	GermanMonthName nvarchar(50) NOT NULL,
	EnglishMonthName nvarchar(50) NOT NULL
);

Create Table [dbo].[FactReceiptLine]
(
	Id int primary key identity(1,1),
	Quantity int NOT NULL,
	PurchaseDate int REFERENCES [dbo].[DimDate](id),
	Customer_fk int REFERENCES [dbo].[DimCustomer](id),
	Product_fk int REFERENCES [dbo].[DimProduct](id),
	Store_fk int REFERENCES [dbo].[DimStore](id),
	Brand nvarchar(50) NOT NULL,
	OriginalId int NOT NULL
);