USE AventOfCode2021
GO

CREATE OR ALTER FUNCTION [dbo].[tvf_get_adjacent_coordinates] (
	@x [int]
	, @y [int]
)
RETURNS TABLE
AS
RETURN 
	SELECT
		[id]
		, [X]
		, [Y]
		, [Number]
	FROM [dbo].[heightmap_grid]
	WHERE
		(
			[y] = @y + 1 AND [x] = @x -- upper
			OR [y] = @y - 1 AND [x] = @x -- lower
			OR [y] = @y AND [x] = @x - 1  -- left
			OR [y] = @y AND [x] = @x + 1 -- right
		)