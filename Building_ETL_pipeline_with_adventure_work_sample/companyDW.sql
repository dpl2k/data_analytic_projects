USE master
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CompanyXDW')
BEGIN
    ALTER DATABASE [CompanyXDW] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE [CompanyXDW]
END
GO
CREATE DATABASE [CompanyXDW]
GO
USE CompanyXDW
GO
-----------------------------------
CREATE TABLE [DimProductCategory](
	[ProductCategoryKey] [int] NOT NULL,
	[ProductCategoryAlternateKey] [int] NULL,
	[ProductCategoryName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DimProductCategory_ProductCategoryKey] PRIMARY KEY CLUSTERED
(
	[ProductCategoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimProductCategory_ProductCategoryAlternateKey] UNIQUE NONCLUSTERED 
(
	[ProductCategoryAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
------------------------------------
CREATE TABLE [DimProductSubcategory](
	[ProductSubcategoryKey] [int] NOT NULL,
	[ProductSubcategoryAlternateKey] [int] NULL,
	[ProductCategoryKey] [int] NULL,
	[ProductSubcategoryName] [nvarchar](50) NOT NULL,
	FOREIGN KEY([ProductCategoryKey]) REFERENCES [DimProductCategory] ([ProductCategoryKey]),
 CONSTRAINT [PK_DimProductSubcategory_ProductSubcategoryKey] PRIMARY KEY CLUSTERED 
(
	[ProductSubcategoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimProductSubcategory_ProductSubcategoryAlternateKey] UNIQUE NONCLUSTERED 
(
	[ProductSubcategoryAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-------------------------------------------
CREATE TABLE [DimProduct](
	[ProductKey] [int] NOT NULL,
	[ProductAlternateKey] [nvarchar](25) NULL,
	[ProductSubcategoryKey] [int] NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[StandardCost] [money] NULL,
	[ListPrice] [money] NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductLine] [nchar](2) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	FOREIGN KEY([ProductSubcategoryKey]) REFERENCES [DimProductSubcategory] ([ProductSubcategoryKey]),
 CONSTRAINT [PK_DimProduct_ProductKey] PRIMARY KEY CLUSTERED 
(
	[ProductKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimProduct_ProductAlternateKey_StartDate] UNIQUE NONCLUSTERED 
(
	[ProductAlternateKey] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-------------------------------------------------------------
CREATE TABLE [DimDate](
	[DateKey] [int] NOT NULL,
	[DateValue] [date] NOT NULL,
	[DayOfWeek] [nvarchar](10) NOT NULL,
	[DayOfMonth] [tinyint] NOT NULL,
	[WeekOfYear] [tinyint] NOT NULL,
	[MonthName] [nvarchar](10) NOT NULL,
	[MonthOfYear] [tinyint] NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[Year] [smallint] NOT NULL,
 CONSTRAINT [PK_DimDate_DateKey] PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [AK_DimDate_FullDateAlternateKey] ON [DimDate]
(
	[DateValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

----------------------------------------------------------------
CREATE TABLE [DimDiscount](
	[DiscountKey] [int] NOT NULL,
	[DiscountAlternateKey] [int] NULL,
	[DiscountName] [nvarchar](255) NULL,
	[DiscountPct] [float] NULL,
	[DiscountType] [nvarchar](50) NULL,
	[DiscountCategory] [nvarchar](50) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[MinQty] [int] NULL,
	[MaxQty] [int] NULL,
 CONSTRAINT [PK_DimDiscount_DiscountKey] PRIMARY KEY CLUSTERED 
(
	[DiscountKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimDiscount_DiscountAlternateKey] UNIQUE NONCLUSTERED 
(
	[DiscountAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-------------------------------------------------------------------
CREATE TABLE [DimSalesTerritory](
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesTerritoryAlternateKey] [int] NULL,
	[SalesTerritoryRegion] [nvarchar](50) NOT NULL,
	[SalesTerritoryCountry] [nvarchar](50) NOT NULL,
	[SalesTerritoryGroup] [nvarchar](50) NULL,
 CONSTRAINT [PK_DimSalesTerritory_SalesTerritoryKey] PRIMARY KEY CLUSTERED 
(
	[SalesTerritoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimSalesTerritory_SalesTerritoryAlternateKey] UNIQUE NONCLUSTERED 
(
	[SalesTerritoryAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
---------------------------------------------------------------
CREATE TABLE [DimAddress](
	[AddressKey] [int] NOT NULL,
	[City] [nvarchar](30) NULL,
	[StateProvinceCode] [nvarchar](3) NULL,
	[StateProvinceName] [nvarchar](50) NULL,
	[CountryRegionCode] [nvarchar](3) NULL,
	[CountryRegionName] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](15) NULL,
	[SalesTerritoryKey] [int] NULL,
	FOREIGN KEY([SalesTerritoryKey]) REFERENCES [DimSalesTerritory] ([SalesTerritoryKey]),
 	CONSTRAINT [PK_DimGeography_AddressKey] PRIMARY KEY CLUSTERED 
(
	[AddressKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-------------------------------------------------
CREATE TABLE [DimReseller](
	[ResellerKey] [int] NOT NULL,
	[AddressKey] [int] NULL,
	[ResellerAlternateKey] [nvarchar](15) NULL,
	[ResellerName] [nvarchar](50) NOT NULL,
	[NumberEmployees] [int] NULL,
	[LastOrderMonth] [tinyint] NULL,
	[FirstOrderYear] [int] NULL,
	[LastOrderYear] [int] NULL,
	[BusinessType] [varchar](20) NOT NULL,
	[ProductLine] [nvarchar](50) NULL,
	[YearOpened] [int] NULL,
	FOREIGN KEY([AddressKey]) REFERENCES [DimAddress] ([AddressKey]),
 CONSTRAINT [PK_DimReseller_ResellerKey] PRIMARY KEY CLUSTERED 
(
	[ResellerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimReseller_ResellerAlternateKey] UNIQUE NONCLUSTERED 
(
	[ResellerAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
--------------------------------------------------------------------------
CREATE TABLE [DimEmployee](
	[EmployeeKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NULL,
	[EmployeeNumber] [nvarchar](15) NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Gender] [nchar](1) NULL,
	[Title] [nvarchar](50) NULL,
	[BirthDate] [date] NULL,
	[HireDate] [date] NULL,
	[ActiveFlag] [bit] NOT NULL,
	[SalesPersonFlag] [bit] NOT NULL,
	FOREIGN KEY([SalesTerritoryKey]) REFERENCES [DimSalesTerritory] ([SalesTerritoryKey]),
 CONSTRAINT [PK_DimEmployee_EmployeeKey] PRIMARY KEY CLUSTERED 
(
	[EmployeeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-------------------------------------------------------------------------------------
CREATE TABLE [FactResellerSales](
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[ResellerKey] [int] NOT NULL,
	[EmployeeKey] [int] NOT NULL,
	[DiscountKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NULL,
	[UnitPrice] [money] NULL,
	[ExtendedAmount] [money] NULL,
	[UnitPriceDiscountPct] [float] NULL,
	[DiscountAmount] [float] NULL,
	[SalesAmount] [money] NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,
	FOREIGN KEY([OrderDateKey]) REFERENCES [DimDate] ([DateKey]),
	FOREIGN KEY([DueDateKey]) REFERENCES [DimDate] ([DateKey]),
	FOREIGN KEY([ShipDateKey]) REFERENCES [DimDate] ([DateKey]),
	FOREIGN KEY([EmployeeKey]) REFERENCES [DimEmployee] ([EmployeeKey]),
	FOREIGN KEY([ProductKey]) REFERENCES [DimProduct] ([ProductKey]),
	FOREIGN KEY([DiscountKey]) REFERENCES [DimDiscount] ([DiscountKey]),
	FOREIGN KEY([ResellerKey]) REFERENCES [DimReseller] ([ResellerKey]),
	FOREIGN KEY([SalesTerritoryKey]) REFERENCES [DimSalesTerritory] ([SalesTerritoryKey]),
 CONSTRAINT [PK_FactResellerSales_SalesOrderNumber_SalesOrderLineNumber] PRIMARY KEY CLUSTERED 
(
	[SalesOrderNumber] ASC,
	[SalesOrderLineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
---------------------------------------------------------------

CREATE TABLE [FactClassifiedReseller](
	[ResellerKey] [int] NOT NULL,
	[NumberEmployees] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[TotalSalesAmount] [money] NULL,
	[SalesLastMonth] [money] NULL,
	[SalesOf2MonthsAgo] [money] NULL,
	[Label] [varchar] (10) NULL,
	FOREIGN KEY([ResellerKey]) REFERENCES [DimReseller] ([ResellerKey])
)