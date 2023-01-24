/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 06 (part 02 v3)

NOTE: Now to do this the smart way ....

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

/* load table with the script day-06-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[lanternfish]

DROP TABLE IF EXISTS [dbo].[lanternfish_population]

CREATE TABLE [dbo].[lanternfish_population] (
	[age_0] [bigint] NOT NULL,
	[age_1] [bigint] NOT NULL,
	[age_2] [bigint] NOT NULL,
	[age_3] [bigint] NOT NULL,
	[age_4] [bigint] NOT NULL,
	[age_5] [bigint] NOT NULL,
	[age_6] [bigint] NOT NULL,
	[age_7] [bigint] NOT NULL,
	[age_8] [bigint] NOT NULL
)

INSERT INTO [dbo].[lanternfish_population]
SELECT ISNULL([0], 0) AS [0], [1], [2], [3], [4], [5], ISNULL([6], 0) AS [6], ISNULL([7], 0) AS [7], ISNULL([8], 0) AS [8]
FROM (
	SELECT [value] AS [age], COUNT(*) AS [population]
	FROM STRING_SPLIT((SELECT [row] FROM [dbo].[lanternfish]), ',')
	GROUP BY [value]
) AS [data]
PIVOT ( 
	MAX([population])
	FOR [age] IN ([0], [1], [2], [3], [4], [5], [6], [7], [8])
) AS P

/* QA */
-- SELECT * FROM [dbo].[lanternfish_population] 

DECLARE @days [int] = 256, @population [bigint] = 0, @counter [int] = 0

-- tried using GO, but something funky was happening selecting the table with one execution
WHILE (1=1)
BEGIN
	UPDATE x SET 
		[age_0] = [age_1],
		[age_1] = [age_2],
		[age_2] = [age_3],
		[age_3] = [age_4],
		[age_4] = [age_5],
		[age_5] = [age_6],
		[age_6] = [age_7] + [age_0],
		[age_7] = [age_8],
		[age_8] = [age_0]
	FROM [dbo].[lanternfish_population] AS x
	SET @counter += 1
	IF @counter >= @days BREAK
END

SELECT @population = [age_0] + [age_1] + [age_2] + [age_3] + [age_4] + [age_5] + [age_6] + [age_7] + [age_8]
FROM [dbo].[lanternfish_population] 

PRINT ''
PRINT 'How many lanternfish would there be after ' + CONVERT([varchar](40), @days) + ' days? ' + CONVERT([varchar](40), @population)

/* OUTPUT
How many lanternfish would there be after 256 days? 1743335992042
*/