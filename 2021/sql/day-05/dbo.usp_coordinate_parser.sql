USE AventOfCode2021
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_coordinate_parser] (
	@input [varchar](1000),
	@x1 [int] OUTPUT,
	@y1 [int] OUTPUT,
	@x2 [int] OUTPUT,
	@y2 [int] OUTPUT,
	@slope [varchar](25) OUTPUT,
	@print [bit] = 1
)
AS

IF @print = 1 PRINT 'Parsing: ' + @input

DECLARE 
	@coordinate1 [varchar](1000),
	@coordinate2 [varchar](1000)

SELECT @coordinate1 = SUBSTRING(@input, 0, CHARINDEX('->', @input)-1); 
SELECT @coordinate2 = SUBSTRING(@input, CHARINDEX('->', @input) + 3, LEN(@input)); 

-- x/y 1
SELECT @x1 = SUBSTRING(@coordinate1, 0, CHARINDEX(',', @coordinate1))
SELECT @y1 = SUBSTRING(@coordinate1, CHARINDEX(',', @coordinate1)+1, LEN(@coordinate1))

-- x/y 2
SELECT @x2 = SUBSTRING(@coordinate2, 0, CHARINDEX(',', @coordinate2))
SELECT @y2 = SUBSTRING(@coordinate2, CHARINDEX(',', @coordinate2)+1, LEN(@coordinate2))

IF @x1 = @x2 SET @slope = 'horizontal'
ELSE IF @y1 = @y2 SET @slope = 'vertical'
ELSE SELECT @slope = CASE WHEN (@y1 - @y2) / (@x1 - @x2) < 0 THEN 'diagonal negative' ELSE 'diagonal positive' END

IF @print = 1
	PRINT '@x1: ' + CONVERT([varchar], @x1) 
		+ '; @y1: ' + CONVERT([varchar], @y1) 
		+ '; @x2: ' + CONVERT([varchar], @x2) 
		+ '; @y2: ' + CONVERT([varchar], @y2) 
		+ '; @slope: ' + @slope

RETURN