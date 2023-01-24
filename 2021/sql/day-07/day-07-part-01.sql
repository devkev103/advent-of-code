/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 07 (part 01)

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

DECLARE @current_position [int], @min_position [int], @max_position [int]
; WITH [data] AS (
	SELECT CONVERT([int], [value]) AS [position]
	FROM STRING_SPLIT((SELECT [row] FROM [dbo].[crab_positions]), ',')
	-- FROM STRING_SPLIT('16,1,2,0,4,2,7,1,2,14', ',') /* QA */
) 
SELECT @min_position = MIN([position]), @max_position = MAX([position])
FROM [data]

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
	INSERT INTO [dbo].[crab_position_tracker]
	SELECT @current_position AS [position],  SUM(ABS([value] - @current_position)) AS [fuel]
	FROM STRING_SPLIT((SELECT [row] FROM [dbo].[crab_positions]), ',')
	-- FROM STRING_SPLIT('16,1,2,0,4,2,7,1,2,14', ',') /* QA */

	FETCH NEXT FROM positionCur INTO @current_position
END

CLOSE positionCur
DEALLOCATE positionCur

/* QA */
-- SELECT * FROM [dbo].[crab_position_tracker]
DECLARE @fuel [int], @position [int]
SELECT TOP 1 @position = [position], @fuel = [fuel] FROM [dbo].[crab_position_tracker] ORDER BY [fuel] ASC
PRINT 'Determine the horizontal position that the crabs can align to using the least fuel possible.' 
PRINT 'How much fuel must they spend to align to that position? Align at position '+ CONVERT([varchar](40), @position) +' will use this much fuel: ' + CONVERT([varchar](40), @fuel)

/* OUTPUT
Determine the horizontal position that the crabs can align to using the least fuel possible.
How much fuel must they spend to align to that position? Align at position 361 will use this much fuel: 364898
*/