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

DECLARE @risk_level [int] = 0, @x [int], @y [int], @number [int]

-- create grid
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

INSERT INTO [dbo].[heightmap_grid] ([Y], [X], [number], [is_low_point])
SELECT 
	x.id AS [Y]
	, n.number+1 AS [X]
	, SUBSTRING(x.[row], n.number+1, 1) AS [number]
	, 0 AS [is_low_point]
FROM [dbo].[heightmap] AS x
inner join [dbo].[Numbers] AS n ON n.[Number] < LEN(x.[row])
ORDER BY x.[id]

-- Get risk levels
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
	SELECT @risk_level = CASE WHEN [total_points] = [low_points] THEN @number + 1 ELSE 0 END
	FROM [points]

	IF @risk_level > 0 
		UPDATE x SET [is_low_point] = 1, [node_id] = 0, [low_point_basin_id] = [id] FROM [dbo].[heightmap_grid] AS x WHERE [x] = @x AND [y] = @y

	FETCH NEXT FROM gridCur INTO @x, @y, @number
END

CLOSE gridCUR
DEALLOCATE gridCUR

/* QA */
-- SELECT * FROM [dbo].[heightmap_grid] WHERE [is_low_point] = 1
-- SELECT * FROM [dbo].[heightmap_grid]

-- find basins
DECLARE @counter [int] = 1, @id [int], @row_returned [int] = 1
DECLARE gridCur CURSOR FOR
SELECT [id], [X], [Y], [number]
FROM [dbo].[heightmap_grid] 
WHERE 
	[is_low_point] = 1
	-- AND [id] = 23-- debug
ORDER BY [x], [y]

OPEN gridCUR

FETCH NEXT FROM gridCur INTO @id, @x, @y, @number

WHILE @@FETCH_STATUS = 0
BEGIN
	-- PRINT '@x = ' + CONVERT([varchar], @x) + '; @y = ' + CONVERT([varchar], @y) + '; @number = ' + CONVERT([varchar], @number) -- debug

	UPDATE hmg SET 
		[node_id] = @counter
		, [low_point_basin_id] = @id
	-- SELECT ac.[X], ac.[Y], ac.[Number]
	FROM [dbo].[tvf_get_adjacent_coordinates](@x, @y) AS ac
	inner join [dbo].[heightmap_grid] AS hmg ON hmg.[id] = ac.[id] AND ac.[number] >= @number + @counter AND ac.number !=9

	WHILE @row_returned > 0
	BEGIN
		UPDATE hmg2 SET 
			[node_id] = @counter
			, [low_point_basin_id] = @id
		-- SELECT DISTINCT coor.[id]
		FROM [dbo].[heightmap_grid] AS hmg
		CROSS APPLY [dbo].[tvf_get_adjacent_coordinates](hmg.[x], hmg.[y]) AS coor
		INNER JOIN [dbo].[heightmap_grid] AS hmg2 ON hmg2.[id] = coor.[id]
		WHERE hmg.[node_id] = @counter - 1 AND hmg.[low_point_basin_id] = @id AND coor.Number >= @number + @counter AND hmg2.number != 9
		SET @row_returned = @@ROWCOUNT

		SET @counter += 1
	END

	-- reset for next low_point
	SET @counter = 1
	SET @row_returned = 1

	FETCH NEXT FROM gridCur INTO @id, @x, @y, @number
END

CLOSE gridCUR
DEALLOCATE gridCUR

DECLARE @basin_sizes [int] = 0
; WITH top_three AS (
	SELECT TOP 3 [low_point_basin_id], COUNT(*) AS [counts]
	FROM [dbo].[heightmap_grid] 
	WHERE [low_point_basin_id] IS NOT NULL
	GROUP BY [low_point_basin_id]
	ORDER BY [counts] DESC
), row_num AS (
	SELECT [1], [2], [3]
	FROM (
		SELECT ROW_NUMBER() OVER(ORDER BY counts) AS id, counts
		FROM top_three
	) AS [data]
	PIVOT (
		MAX(counts)
		FOR [id] IN ([1], [2], [3])
	) AS pvt
) 
SELECT @basin_sizes = [1] * [2] * [3] 
FROM [row_num]

PRINT 'What do you get if you multiply together the sizes of the three largest basins? ' + CONVERT([varchar](40), @basin_sizes)