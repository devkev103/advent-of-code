/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 01 (part 02)

********************************************************************************************/

USE AventOfCode2021
GO

/* load table with the script day-01-load-input.sql */

SET NOCOUNT ON
GO

DROP TABLE IF EXISTS [dbo].[depths_part2]
GO

CREATE TABLE [dbo].[depths_part2] (
	[id] [int] NOT NULL,
	[value] [int] NOT NULL
)
GO

DECLARE @counter [int] = 0, @value [int] = 0

DECLARE dataCur CURSOR LOCAL FOR
SELECT [id] FROM [dbo].[depths]

OPEN dataCur  

FETCH NEXT FROM dataCur INTO @counter   

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @value = SUM([value]) FROM depths WHERE id >= @counter AND id < @counter + 3
	-- PRINT CONVERT(varchar, @counter) + ' : ' + CONVERT(varchar, @value)
	INSERT INTO [dbo].[depths_part2] VALUES (@counter, @value)
	FETCH NEXT FROM dataCur INTO @counter   
END

CLOSE dataCur
DEALLOCATE dataCur
GO

/* QA */
-- SELECT * FROM [dbo].[depths]
-- SELECT * FROM [dbo].[depths_part2]

DECLARE @counts [int] = 0
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
	FROM [dbo].[depths_part2]
)
-- SELECT [id], [value], [status]
SELECT @counts = COUNT(*)
FROM [depths]
WHERE [status] = 'increased'
GROUP BY [status]

PRINT 'Consider sums of a three-measurement sliding window.'
PRINT 'How many sums are larger than the previous sum? ' + CONVERT([varchar], @counts)

/* OUTPUT
Consider sums of a three-measurement sliding window.
How many sums are larger than the previous sum? 1491
*/