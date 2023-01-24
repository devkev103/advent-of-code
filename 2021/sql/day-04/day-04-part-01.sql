/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 04 (part 01)

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

/* load table with the script day-04-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[bingo_boards_staging]

/* parse the data */
/* parse bingo numbers */
DROP TABLE IF EXISTS [dbo].[bingo_numbers]

CREATE TABLE [dbo].[bingo_numbers] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[value] [int] NOT NULL
)

DECLARE @bingo_numbers [varchar](max)
SELECT @bingo_numbers = [row] FROM [dbo].[bingo_boards_staging] WHERE [id] = 1

INSERT INTO [dbo].[bingo_numbers] ([value])
SELECT [value]  
FROM STRING_SPLIT(@bingo_numbers, ',')  

/* QA */
-- SELECT * FROM [dbo].[bingo_numbers]

/* parse bingo boards */
DROP TABLE IF EXISTS [dbo].[bingo_boards]

CREATE TABLE [dbo].[bingo_boards] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[board_id] [int] NOT NULL,
	[x] [int] NOT NULL,
	[y] [int] NOT NULL,
	[value] [int] NOT NULL,
	[is_called] [tinyint] NOT NULL
)

DECLARE @value [varchar](1000), @counter [int] = 0, @board_id [int] = 1
DECLARE numbersCur CURSOR FOR
SELECT [row] 
FROM [dbo].[bingo_boards_staging]
WHERE 
	[id] <> 1
	AND [row] IS NOT NULL
ORDER BY [id]

OPEN numbersCur

FETCH NEXT FROM numbersCur INTO @value

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @counter > 4
	BEGIN
		SET @counter = 0
		SET @board_id += 1
	END

	INSERT INTO [dbo].[bingo_boards] ([board_id], [x], [y], [value], [is_called])
	SELECT @board_id, 0, @counter, TRIM(SUBSTRING(@value, 1, 2)), 0

	INSERT INTO [dbo].[bingo_boards] ([board_id], [x], [y], [value], [is_called])
	SELECT @board_id, 1, @counter, TRIM(SUBSTRING(@value, 3, 3)), 0

	INSERT INTO [dbo].[bingo_boards] ([board_id], [x], [y], [value], [is_called])
	SELECT @board_id, 2, @counter, TRIM(SUBSTRING(@value, 6, 3)), 0

	INSERT INTO [dbo].[bingo_boards] ([board_id], [x], [y], [value], [is_called])
	SELECT @board_id, 3, @counter, TRIM(SUBSTRING(@value, 9, 3)), 0

	INSERT INTO [dbo].[bingo_boards] ([board_id], [x], [y], [value], [is_called])
	SELECT @board_id, 4, @counter, TRIM(SUBSTRING(@value, 12, 3)), 0

	SET @counter += 1
	FETCH NEXT FROM numbersCur INTO @value
END

CLOSE numbersCur
DEALLOCATE numbersCur

/* QA */
-- SELECT * FROM [dbo].[bingo_boards]
GO

-- reset boards
UPDATE x SET is_called = 0 FROM [dbo].[bingo_boards] x

DECLARE @id [int], @value [int], @winning_number [int] = -1, @winning_board [int] = -1, @sum_of_unmarked [int] = -1
DECLARE numbersCur CURSOR FOR
SELECT [id], [value] FROM [dbo].[bingo_numbers]

OPEN numbersCur

FETCH NEXT FROM numbersCur INTO @id, @value

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'Calling number: ' + CONVERT([varchar], @value)
	
	UPDATE x SET is_called = 1 FROM [dbo].[bingo_boards] AS x WHERE [value] = @value
	PRINT 'Updated rows: ' + CONVERT([varchar], @@ROWCOUNT)

	-- see if there are winners
	IF EXISTS (
		-- has any in the X postition won?
		SELECT [board_id], [x], SUM(is_called) AS total_called
		FROM [dbo].[bingo_boards]
		GROUP BY [board_id], [x] HAVING SUM(is_called) = 5)
	OR EXISTS (
		-- has any in the Y postition won?
		SELECT [board_id], [y], SUM(is_called) AS total_called
		FROM [dbo].[bingo_boards]
		GROUP BY [board_id], [y] HAVING SUM(is_called) = 5
	) 
	BEGIN
		SET @winning_number = @value
		BREAK
	END

	FETCH NEXT FROM numbersCur INTO @id, @value
END

CLOSE numbersCur
DEALLOCATE numbersCur

-- find winning board (this assumes only one board will be the winner)
SELECT TOP 1 @winning_board = [board_id]
FROM [dbo].[bingo_boards]
GROUP BY [board_id], [x] HAVING SUM(is_called) = 5

SELECT TOP 1 @winning_board = [board_id]
FROM [dbo].[bingo_boards]
GROUP BY [board_id], [y] HAVING SUM(is_called) = 5

SELECT @sum_of_unmarked = SUM([value])
FROM [dbo].[bingo_boards]
WHERE 
	[board_id] = @winning_board
	AND [is_called] = 0

PRINT ''
PRINT 'Winning numbner: ' + CONVERT([varchar], @winning_number)
PRINT 'Winning board_id: ' + CONVERT([varchar], @winning_board)
PRINT '@sum_of_unmarked: ' + CONVERT([varchar], @sum_of_unmarked)
PRINT 'Final score (@sum_of_unmarked * @winning_number): ' + CONVERT([varchar], @sum_of_unmarked * @winning_number)

PRINT ''
PRINT 'To guarantee victory against the giant squid, figure out which board will win first.' 
PRINT 'What will your final score be if you choose that board? ' + CONVERT([varchar], @sum_of_unmarked * @winning_number)

/* OUTPUT
Winning numbner: 51
Winning board_id: 26
@sum_of_unmarked: 784
Final score (@sum_of_unmarked * @winning_number): 39984

To guarantee victory against the giant squid, figure out which board will win first.
What will your final score be if you choose that board? 39984
*/