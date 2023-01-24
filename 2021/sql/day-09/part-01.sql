/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 09 (part 01)

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

/* load table with the script day-09-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[heightmap]

DROP TABLE IF EXISTS [dbo].[heightmap_grid]

CREATE TABLE [dbo].[heightmap_grid] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[x] [int] NOT NULL,
	[y] [int] NOT NULL,
	[number] [int] NOT NULL,
	[is_low_point] [bit] NOT NULL,
	[low_point_basin_id] [int] NULL,
	[node_id] [int] NULL
)

DECLARE @risk_level [int] = 0, @this_risk_level [int] = 0, @x [int], @y [int], @number [int]

INSERT INTO [dbo].[heightmap_grid] ([Y], [X], [number], [is_low_point])
SELECT 
	x.id AS [Y]
	, n.number+1 AS [X]
	, SUBSTRING(x.[row], n.number+1, 1) AS [number]
	, 0 AS [is_low_point]
FROM [dbo].[heightmap] AS x
inner join [dbo].[Numbers] AS n ON n.[Number] < LEN(x.[row])
ORDER BY x.[id]

DECLARE gridCur CURSOR FOR
SELECT [X], [Y], [number]
FROM [dbo].[heightmap_grid]
-- WHERE Y = 1 AND X = 2 -- debug
ORDER BY [x], [y]

OPEN gridCUR

FETCH NEXT FROM gridCur INTO @x, @y, @number

WHILE @@FETCH_STATUS = 0
BEGIN
	-- PRINT '@x = ' + CONVERT([varchar], @x) + '; @y = ' + CONVERT([varchar], @y) + '; @number = ' + CONVERT([varchar], @number)
	; WITH [coordinates] AS (
		SELECT [X], [Y], [Number]
		FROM [dbo].[tvf_get_adjacent_coordinates](@x, @y)
	), [points] AS (
		SELECT 
			COUNT(*) AS [total_points], 
			SUM(CASE WHEN [number] > @number THEN 1 ELSE 0 END) AS [low_points]
		FROM [coordinates]
	)
	SELECT @this_risk_level = CASE WHEN [total_points] = [low_points] THEN @number + 1 ELSE 0 END
	FROM [points]

	SET @risk_level += @this_risk_level

	IF @this_risk_level > 0 
		UPDATE x SET [is_low_point] = 1, [node_id] = 0, [low_point_basin_id] = [id] FROM [dbo].[heightmap_grid] AS x WHERE [x] = @x AND [y] = @y


	FETCH NEXT FROM gridCur INTO @x, @y, @number
END

CLOSE gridCUR
DEALLOCATE gridCUR

/* QA */
-- SELECT * FROM [dbo].[heightmap_grid] WHERE [is_low_point] = 1

PRINT 'Find all of the low points on your heightmap.'
PRINT 'What is the sum of the risk levels of all low points on your heightmap? ' + CONVERT([varchar](40), @risk_level)