/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 01 (part 01)

********************************************************************************************/

USE [AventOfCode2021]
GO

/* load table with the script day-01-load-input.sql */

DECLARE @counts [int]

; WITH [depths] AS (
	SELECT 
		[id]
		, [value]
		, LAG([value], 1) OVER (ORDER BY YEAR([id])) AS [value_previous]
		, CASE 
			WHEN [value] > LAG([value], 1) OVER (ORDER BY YEAR([id])) THEN 'increased'
			WHEN [value] < LAG([value], 1) OVER (ORDER BY YEAR([id])) THEN 'decreased'
			WHEN [value] = LAG([value], 1) OVER (ORDER BY YEAR([id])) THEN 'no change'
		END AS [status]
	FROM [dbo].[depths]
)
-- SELECT [id], [value], [status]
SELECT @counts = COUNT(*)
FROM [depths]
WHERE [status] = 'increased'
GROUP BY [status]

PRINT 'How many measurements are larger than the previous measurement? ' + CONVERT([varchar], @counts)

/* OUTPUT
How many measurements are larger than the previous measurement? 1466
*/