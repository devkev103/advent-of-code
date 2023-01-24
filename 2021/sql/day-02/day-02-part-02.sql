/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 02 (part 02)

********************************************************************************************/

USE [AventOfCode2021]
GO

/* load table with the script day-02-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[submarine_movement]

DECLARE 
	@counter [int] = 0
	, @movement [varchar](40) = ''
	, @value [int] = 0
	, @horizontal_position [int] = 0
	, @depth [int] = 0
	, @aim [int] = 0

DECLARE dataCur CURSOR LOCAL FOR
SELECT [id], [movement], [value] FROM [dbo].[submarine_movement]

OPEN dataCur  

FETCH NEXT FROM dataCur INTO @counter, @movement, @value

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @movement = 'down'
	BEGIN
		SET @aim += @value
	END
	ELSE IF @movement = 'up'
	BEGIN
		SET @aim -= @value
	END
	ELSE IF @movement = 'forward'
	BEGIN
		SET @horizontal_position += @value
		SET @depth = @depth + (@aim * @value)
	END
	-- PRINT CONVERT(varchar, @counter) + ' : ' + CONVERT(varchar, @value)
	FETCH NEXT FROM dataCur INTO @counter, @movement, @value
END
PRINT '@horizontal_position: ' + CONVERT([varchar], @horizontal_position)
PRINT '@depth: ' + CONVERT([varchar], @depth)
PRINT '@horizontal_position * @depth: ' + CONVERT([varchar], @depth * @horizontal_position)

CLOSE dataCur
DEALLOCATE dataCur

PRINT 'Using this new interpretation of the commands, calculate the horizontal position and depth you would have after following the planned course.'
PRINT 'What do you get if you multiply your final horizontal position by your final depth? ' + CONVERT([varchar], @depth * @horizontal_position)

/*OUTPUT
@horizontal_position: 2165
@depth: 738712
@horizontal_position * @depth: 1599311480
Using this new interpretation of the commands, calculate the horizontal position and depth you would have after following the planned course.
What do you get if you multiply your final horizontal position by your final depth? 1599311480
*/