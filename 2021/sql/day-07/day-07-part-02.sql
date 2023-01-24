/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 07 (part 02)

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

/* load table with the script day-07-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[crab_positions]

DROP TABLE IF EXISTS [dbo].[crab_position_tracker]

CREATE TABLE [dbo].[crab_position_tracker] (
	[position] [int] NOT NULL,
	[fuel] [int] NOT NULL
)

DROP TABLE IF EXISTS [dbo].[move_to_fuel]

-- if you move X blocks, it will cost X fuel
CREATE TABLE [dbo].[move_to_fuel] (
	[move] [int] NOT NULL,
	[fuel] [int] NOT NULL
)

DECLARE @current_position [int], @min_position [int], @max_position [int]
; WITH [data] AS (
	SELECT CONVERT([int], [value]) AS [position]
	FROM STRING_SPLIT((SELECT [row] FROM [dbo].[crab_positions]), ',')
	-- FROM STRING_SPLIT('16,1,2,0,4,2,7,1,2,14', ',') /* QA */
) 
SELECT @min_position = MIN([position]), @max_position = MAX([position])
FROM [data]

-- move to fuel lookup table
INSERT INTO [dbo].[move_to_fuel]
SELECT
	[Number],
	(SELECT SUM([Number]) FROM [dbo].[Numbers] AS n2 WHERE n2.[Number] <= n1.[Number])
FROM [dbo].[Numbers] AS n1
WHERE 
	[Number] >= @min_position
	AND [Number] <= @max_position

DECLARE positionCur CURSOR FOR
SELECT [Number]
FROM [dbo].[Numbers]
WHERE 
	[Number] >= @min_position
	AND [Number] <= @max_position


OPEN positionCur

FETCH NEXT FROM positionCur INTO @current_position

WHILE @@FETCH_STATUS = 0
BEGIN
	-- inline method
	-- with this inline it takes ~3 minutes; implemented a move to fuel lookup table
	/*
	; WITH [data] AS (
		SELECT 
			@current_position AS [position]
			, (SELECT SUM([Number]) FROM [dbo].[Numbers] AS n2 WHERE n2.[Number] <= ABS([value] - @current_position)) AS [fuel]
		FROM STRING_SPLIT((SELECT [row] FROM [dbo].[crab_positions]), ',') AS [data]
		-- FROM STRING_SPLIT('16,1,2,0,4,2,7,1,2,14', ',') /* QA */
	) 
	INSERT INTO [dbo].[crab_position_tracker]
	SELECT [position], SUM([fuel]) AS [total_fuel]
	FROM [data]
	GROUP BY [position]
	*/

	-- with lookup table it takes 4 seconds
	INSERT INTO [dbo].[crab_position_tracker]
	SELECT 
		@current_position AS [position]
		, SUM(MTF.[fuel]) AS [total_fuel]
	FROM STRING_SPLIT((SELECT [row] FROM [dbo].[crab_positions]), ',') AS [data]
	INNER JOIN [dbo].[move_to_fuel] AS MTF ON MTF.[move] = ABS([value] - @current_position)
	-- FROM STRING_SPLIT('16,1,2,0,4,2,7,1,2,14', ',') /* QA */

	FETCH NEXT FROM positionCur INTO @current_position
END

CLOSE positionCur
DEALLOCATE positionCur

/* QA */
-- SELECT * FROM [dbo].[crab_position_tracker]
DECLARE @fuel [int], @position [int]
SELECT TOP 1 @position = [position], @fuel = [fuel] FROM [dbo].[crab_position_tracker] ORDER BY [fuel] ASC -- get most fuel efficient
PRINT 'Determine the horizontal position that the crabs can align to using the least fuel possible.' 
PRINT 'How much fuel must they spend to align to that position? Align at position '+ CONVERT([varchar](40), @position) +' will use this much fuel: ' + CONVERT([varchar](40), @fuel)

/* OUTPUT
Determine the horizontal position that the crabs can align to using the least fuel possible.
How much fuel must they spend to align to that position? Align at position 500 will use this much fuel: 104149091
*/