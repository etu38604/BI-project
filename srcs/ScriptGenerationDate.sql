/********************************************************************************************/
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date 

DECLARE @StartDate DATETIME = '01/01/1990' --Starting value of Date Range
DECLARE @EndDate DATETIME = '01/01/2020' --End Value of Date Range

--Temporary Variables To Hold the Values During Processing of Each Date of Year
DECLARE
    @DayOfWeekInMonth INT,
    @DayOfWeekInYear INT,
    @WeekOfMonth INT,
    @CurrentYear INT,
    @CurrentMonth INT

DECLARE @DimDate TABLE (
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
)

/*Table Data type to store the day of week count for the month and year*/
DECLARE @DayOfWeek TABLE (DOW INT, MonthCount INT, YearCount INT)

INSERT INTO @DayOfWeek VALUES (1, 0, 0)
INSERT INTO @DayOfWeek VALUES (2, 0, 0)
INSERT INTO @DayOfWeek VALUES (3, 0, 0)
INSERT INTO @DayOfWeek VALUES (4, 0, 0)
INSERT INTO @DayOfWeek VALUES (5, 0, 0)
INSERT INTO @DayOfWeek VALUES (6, 0, 0)
INSERT INTO @DayOfWeek VALUES (7, 0, 0)

--Extract and assign various parts of Values from Current Date to Variable

DECLARE @CurrentDate AS DATETIME = @StartDate
SET @CurrentMonth = DATEPART(MM, @CurrentDate)
SET @CurrentYear = DATEPART(YY, @CurrentDate)

/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above

WHILE @CurrentDate < @EndDate
BEGIN
 
/*Begin day of week logic*/

         /*Check for Change in Month of the Current date if Month changed then 
          Change variable value*/
    IF @CurrentMonth != DATEPART(MM, @CurrentDate) 
    BEGIN
        UPDATE @DayOfWeek
        SET MonthCount = 0
        SET @CurrentMonth = DATEPART(MM, @CurrentDate)
    END
       
        /* Check for Change in Year of the Current date if Year changed then change 
         Variable value*/
    IF @CurrentYear != DATEPART(YY, @CurrentDate)
    BEGIN
        UPDATE @DayOfWeek
        SET YearCount = 0
        SET @CurrentYear = DATEPART(YY, @CurrentDate)
    END
    
        -- Set values in table data type created above from variables 

    UPDATE @DayOfWeek
    SET 
        MonthCount = MonthCount + 1,
        YearCount = YearCount + 1
    WHERE DOW = DATEPART(DW, @CurrentDate)

    SELECT
        @DayOfWeekInMonth = MonthCount,
        @DayOfWeekInYear = YearCount
    FROM @DayOfWeek
    WHERE DOW = DATEPART(DW, @CurrentDate)
    
/*End day of week logic*/


/* Populate Your Dimension Table with values*/
    
    INSERT INTO @DimDate
    SELECT
        CONVERT (char(8),@CurrentDate,112) as Id,
        @CurrentDate AS FullDate,
        DATEPART(DW, @CurrentDate) AS DayNumberOfWeek,
        DATEPART(DD, @CurrentDate) AS DayOfMonth,
        DATEPART(DY,@CurrentDate) AS DayNumberOfYear,
        DATEPART(MM, @CurrentDate) AS MonthNumberOfYear,
        DATEPART(YEAR, @CurrentDate) AS Year,
        CASE
            WHEN DATEPART(DW, @CurrentDate) = 1
            THEN 'Lundi'
            WHEN DATEPART(DW, @CurrentDate) = 2
            THEN 'Mardi'
            WHEN DATEPART(DW, @CurrentDate) = 3
            THEN 'Mercredi'
            WHEN DATEPART(DW, @CurrentDate) = 4
            THEN 'Jeudi'
            WHEN DATEPART(DW, @CurrentDate) = 5
            THEN 'Vendredi'
            WHEN DATEPART(DW, @CurrentDate) = 6
            THEN 'Samedi'
            WHEN DATEPART(DW, @CurrentDate) = 7
            THEN 'Dimanche'
        END AS FrenchNameDayOfWeek,
        CASE
            WHEN DATEPART(DW, @CurrentDate) = 1
            THEN 'NLLundi'
            WHEN DATEPART(DW, @CurrentDate) = 2
            THEN 'NLMardi'
            WHEN DATEPART(DW, @CurrentDate) = 3
            THEN 'NLMercredi'
            WHEN DATEPART(DW, @CurrentDate) = 4
            THEN 'NLJeudi'
            WHEN DATEPART(DW, @CurrentDate) = 5
            THEN 'NLVendredi'
            WHEN DATEPART(DW, @CurrentDate) = 6
            THEN 'NLSamedi'
            WHEN DATEPART(DW, @CurrentDate) = 7
            THEN 'NLDimanche'
        END AS DutchNameDayOfWeek,
        CASE
            WHEN DATEPART(DW, @CurrentDate) = 1
            THEN 'GELundi'
            WHEN DATEPART(DW, @CurrentDate) = 2
            THEN 'GEMardi'
            WHEN DATEPART(DW, @CurrentDate) = 3
            THEN 'GEMercredi'
            WHEN DATEPART(DW, @CurrentDate) = 4
            THEN 'GEJeudi'
            WHEN DATEPART(DW, @CurrentDate) = 5
            THEN 'GEVendredi'
            WHEN DATEPART(DW, @CurrentDate) = 6
            THEN 'GESamedi'
            WHEN DATEPART(DW, @CurrentDate) = 7
            THEN 'GEDimanche'
        END AS GermanNameDayOfWeek,
        CASE
            WHEN DATEPART(DW, @CurrentDate) = 1
            THEN 'ENLundi'
            WHEN DATEPART(DW, @CurrentDate) = 2
            THEN 'ENMardi'
            WHEN DATEPART(DW, @CurrentDate) = 3
            THEN 'ENMercredi'
            WHEN DATEPART(DW, @CurrentDate) = 4
            THEN 'ENJeudi'
            WHEN DATEPART(DW, @CurrentDate) = 5
            THEN 'ENVendredi'
            WHEN DATEPART(DW, @CurrentDate) = 6
            THEN 'ENSamedi'
            WHEN DATEPART(DW, @CurrentDate) = 7
            THEN 'ENDimanche'
        END AS EnglishNameDayOfWeek,

        CASE
            WHEN DATEPART(MM, @CurrentDate) = 1
            THEN 'Janvier'
            WHEN DATEPART(MM, @CurrentDate) = 2
            THEN 'Février'
            WHEN DATEPART(MM, @CurrentDate) = 3
            THEN 'Mars'
            WHEN DATEPART(MM, @CurrentDate) = 4
            THEN 'Avril'
            WHEN DATEPART(MM, @CurrentDate) = 5
            THEN 'Mai'
            WHEN DATEPART(MM, @CurrentDate) = 6
            THEN 'Juin'
            WHEN DATEPART(MM, @CurrentDate) = 7
            THEN 'Juillet'
            WHEN DATEPART(MM, @CurrentDate) = 8
            THEN 'Aout'
            WHEN DATEPART(MM, @CurrentDate) = 9
            THEN 'Septembre'
            WHEN DATEPART(MM, @CurrentDate) = 10
            THEN 'Octobre'
            WHEN DATEPART(MM, @CurrentDate) = 11
            THEN 'Novembre'
            WHEN DATEPART(MM, @CurrentDate) = 12
            THEN 'Décembre'
        END AS FrenchMonthName,
        CASE
            WHEN DATEPART(MM, @CurrentDate) = 1
            THEN 'NLJanvier'
            WHEN DATEPART(MM, @CurrentDate) = 2
            THEN 'NLFévrier'
            WHEN DATEPART(MM, @CurrentDate) = 3
            THEN 'NLMars'
            WHEN DATEPART(MM, @CurrentDate) = 4
            THEN 'NLAvril'
            WHEN DATEPART(MM, @CurrentDate) = 5
            THEN 'NLMai'
            WHEN DATEPART(MM, @CurrentDate) = 6
            THEN 'NLJuin'
            WHEN DATEPART(MM, @CurrentDate) = 7
            THEN 'NLJuillet'
            WHEN DATEPART(MM, @CurrentDate) = 8
            THEN 'NLAout'
            WHEN DATEPART(MM, @CurrentDate) = 9
            THEN 'NLSeptembre'
            WHEN DATEPART(MM, @CurrentDate) = 10
            THEN 'NLOctobre'
            WHEN DATEPART(MM, @CurrentDate) = 11
            THEN 'NLNovembre'
            WHEN DATEPART(MM, @CurrentDate) = 12
            THEN 'NLDécembre'
        END AS DutchMonthName,
        CASE
            WHEN DATEPART(MM, @CurrentDate) = 1
            THEN 'GEJanvier'
            WHEN DATEPART(MM, @CurrentDate) = 2
            THEN 'GEFévrier'
            WHEN DATEPART(MM, @CurrentDate) = 3
            THEN 'GEMars'
            WHEN DATEPART(MM, @CurrentDate) = 4
            THEN 'GEAvril'
            WHEN DATEPART(MM, @CurrentDate) = 5
            THEN 'GEMai'
            WHEN DATEPART(MM, @CurrentDate) = 6
            THEN 'GEJuin'
            WHEN DATEPART(MM, @CurrentDate) = 7
            THEN 'GEJuillet'
            WHEN DATEPART(MM, @CurrentDate) = 8
            THEN 'GEAout'
            WHEN DATEPART(MM, @CurrentDate) = 9
            THEN 'GESeptembre'
            WHEN DATEPART(MM, @CurrentDate) = 10
            THEN 'GEOctobre'
            WHEN DATEPART(MM, @CurrentDate) = 11
            THEN 'GENovembre'
            WHEN DATEPART(MM, @CurrentDate) = 12
            THEN 'GEDécembre'
        END AS GermanMonthName,
        CASE
            WHEN DATEPART(MM, @CurrentDate) = 1
            THEN 'ENJanvier'
            WHEN DATEPART(MM, @CurrentDate) = 2
            THEN 'ENFévrier'
            WHEN DATEPART(MM, @CurrentDate) = 3
            THEN 'ENMars'
            WHEN DATEPART(MM, @CurrentDate) = 4
            THEN 'ENAvril'
            WHEN DATEPART(MM, @CurrentDate) = 5
            THEN 'ENMai'
            WHEN DATEPART(MM, @CurrentDate) = 6
            THEN 'ENJuin'
            WHEN DATEPART(MM, @CurrentDate) = 7
            THEN 'ENJuillet'
            WHEN DATEPART(MM, @CurrentDate) = 8
            THEN 'ENAout'
            WHEN DATEPART(MM, @CurrentDate) = 9
            THEN 'ENSeptembre'
            WHEN DATEPART(MM, @CurrentDate) = 10
            THEN 'ENOctobre'
            WHEN DATEPART(MM, @CurrentDate) = 11
            THEN 'ENNovembre'
            WHEN DATEPART(MM, @CurrentDate) = 12
            THEN 'ENDécembre'
        END AS EnglishMonthName

    SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END

SELECT * FROM @DimDate
