/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 06 (part 02 v2)

NOTE: Although faster than v1, I could never get this to finish with @days = 256. I let it execute for 40 minutes 
      but only got up to day ~231. See part two version three for solution

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

/* load table with the script day-06-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[lanternfish]

DROP TABLE IF EXISTS [dbo].[lanternfish_projection]

CREATE TABLE [dbo].[lanternfish_projection] (
	[initial_age] [int] NOT NULL, 
	[age] [int] NOT NULL,
	[population] [int] NOT NULL,
	CONSTRAINT [pk_lanternfish_projection] PRIMARY KEY ([initial_age])
)

DECLARE 
	@value [int]
	, @days [int] = 80 -- 256
	, @population [int]
DECLARE ageCursor CURSOR LOCAL FAST_FORWARD FOR
SELECT DISTINCT [value]
FROM STRING_SPLIT((SELECT [row] FROM [dbo].[lanternfish]), ',')

OPEN ageCursor

FETCH NEXT FROM ageCursor INTO @value

WHILE @@FETCH_STATUS = 0
BEGIN
	EXECUTE [dbo].[usp_lanternfish_population_projection]
		@initial_age = @value
		, @days = @days
		, @print = 0
		, @debug = 0
		, @population = @population OUTPUT

	INSERT INTO [dbo].[lanternfish_projection] ([initial_age], [age], [population]) VALUES
	(@value, @days, @population)
	
	FETCH NEXT FROM ageCursor INTO @value
END 

CLOSE ageCursor
DEALLOCATE ageCursor

/* QA */
-- SELECT * FROM [dbo].[lanternfish_projection]

; WITH projection AS (
	SELECT 
		i.[value] AS [initial_age]
		, p.[age] AS [current_age]
		, p.[population]
	FROM STRING_SPLIT((SELECT [row] FROM [dbo].[lanternfish]), ',') AS [i]
	INNER JOIN [dbo].[lanternfish_projection] AS [p] ON p.[initial_age] = i.[value]
)
SELECT @population = SUM([population])
FROM projection

PRINT ''
PRINT 'How many lanternfish would there be after ' + CONVERT([varchar](40), @days) + ' days? ' + CONVERT([varchar](40), @population)

/* OUTPUT

*/