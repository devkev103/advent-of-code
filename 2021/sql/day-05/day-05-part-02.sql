/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 05 (part 02)

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

/* load table with the script day-05-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[hydrothermal_vent_coordinates]

DROP TABLE IF EXISTS [dbo].[hydrothermal_vent_coordinates_marked_v2]

CREATE TABLE [dbo].[hydrothermal_vent_coordinates_marked_v2] (
	[vents_input] [varchar](1000) NOT NULL,
	[x] [int] NOT NULL,
	[y] [int] NOT NULL
)

DECLARE @value [varchar](1000)
DECLARE @x1 [int], @y1 [int], @x2 [int], @y2 [int], @slope [varchar](25)

DECLARE ventsCur CURSOR FOR
SELECT [row] FROM [dbo].[hydrothermal_vent_coordinates]

OPEN ventsCur

FETCH NEXT FROM ventsCur INTO @value

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'Vent coordinate: ' + CONVERT([varchar], @value)

	EXECUTE [dbo].[usp_coordinate_parser]
		@input = @value
		, @x1 = @x1 OUTPUT
		, @y1 = @y1 OUTPUT
		, @x2 = @x2 OUTPUT
		, @y2 = @y2 OUTPUT
		, @slope = @slope OUTPUT
		, @print = 1

	-- only dealing with vertical or horizontal lines
	IF @slope = 'horizontal' -- horizontal lines
	BEGIN
		INSERT INTO [hydrothermal_vent_coordinates_marked_v2] ([vents_input], [x], [y])
		SELECT @value, @x1 AS [x], [number] AS [y]
		FROM [dbo].[numbers] 
		WHERE 
			([number] >= @y1 AND [number] <= @y2)
			OR ([number] >= @y2 AND [number] <= @y1) -- case when @y2 is smaller than @y1
	END
	ELSE IF @slope = 'vertical' -- vertical lines
	BEGIN
		INSERT INTO [hydrothermal_vent_coordinates_marked_v2] ([vents_input], [x], [y])
		SELECT @value, [number] AS [x], @y1 AS [y]
		FROM [dbo].[numbers] 
		WHERE 
			([number] >= @x1 AND [number] <= @x2)
			OR ([number] >= @x2 AND [number] <= @x1) -- case when @x2 is smaller than @x1 
	END
	-- when we do math for calculating the [y] we need do invert because we are using "quadrant 4" per instructions
	ELSE IF @slope = 'diagonal negative'
	BEGIN
		INSERT INTO [hydrothermal_vent_coordinates_marked_v2] ([vents_input], [x], [y])
		SELECT @value, [number] AS [x], (@x1 - [number]) + @y1 AS [y]
		FROM [dbo].[numbers] 
		WHERE 
			([number] >= @x1 AND [number] <= @x2) 
			OR ([number] >= @x2 AND [number] <= @x1) -- case when @x2 is smaller than @x1 
	END
	ELSE IF @slope = 'diagonal positive'
	BEGIN
		INSERT INTO [hydrothermal_vent_coordinates_marked_v2] ([vents_input], [x], [y])
		SELECT @value, [number] AS [x], (@y2 + [number]) - @x2 AS [y]
		FROM [dbo].[numbers] 
		WHERE 
			([number] >= @x1 AND [number] <= @x2)
			OR ([number] >= @x2 AND [number] <= @x1) -- case when @x2 is smaller than @x1 
	END
	
	PRINT ''
	FETCH NEXT FROM ventsCur INTO @value
END

CLOSE ventsCur
DEALLOCATE ventsCur

/* QA */
/*
@slope: diagonal negative
SELECT * 
FROM [dbo].[hydrothermal_vent_coordinates_marked]
WHERE vents_input = '565,562 -> 660,467'
*/

/*
SELECT [x], [y], COUNT(*) AS counts
FROM [dbo].[hydrothermal_vent_coordinates_marked]
GROUP BY [x], [y] HAVING COUNT(*) > 1
ORDER BY counts DESC
*/

DECLARE @overlapping_lines_count [int] = 0
SELECT @overlapping_lines_count = COUNT(*) 
FROM (
	SELECT [x], [y], COUNT(*) AS counts
	FROM [dbo].[hydrothermal_vent_coordinates_marked_v2]
	GROUP BY [x], [y] HAVING COUNT(*) > 1
) AS x 

PRINT 'Consider all of the lines.'
PRINT 'At how many points do at least two lines overlap? ' + CONVERT([varchar], @overlapping_lines_count)

/* OUTPUT
Consider all of the lines.
At how many points do at least two lines overlap? 20271
*/