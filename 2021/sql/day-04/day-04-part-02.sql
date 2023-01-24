/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 04 (part 02)

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

/* uses tables from part 01 */

/* QA */
-- SELECT * FROM [dbo].[bingo_numbers]
-- SELECT * FROM [dbo].[bingo_boards]

DROP TABLE IF EXISTS [dbo].[bingo_boards_win_order]

CREATE TABLE [dbo].[bingo_boards_win_order] (
	[board_id] [int] NOT NULL,
	[winning_number] [int] NOT NULL,
	[winning_placement] [int] NOT NULL,
	CONSTRAINT [pk_board_id] PRIMARY KEY ([board_id])
)

-- reset boards
UPDATE x SET is_called = 0 FROM [dbo].[bingo_boards] x
TRUNCATE TABLE [dbo].[bingo_boards_win_order]

DECLARE 
	@id [int]
	, @value [int]
	, @winning_number [int] = -1
	, @winning_board [int] = -1
	, @sum_of_unmarked [int] = -1
	, @number_of_boards [int] = -1
	, @number_currently_won [int] = -1
	, @placement [int] = NULL

-- set @number_of_boards to total number of boards to get last winning number
-- set @number_of_boards to ONE to get first winning number
SELECT @number_of_boards = COUNT(DISTINCT [board_id]) FROM [dbo].[bingo_boards] 
-- SET @number_of_boards = 1

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
		IF @placement IS NULL 
			SET @placement = 1 -- covers when there isn't a row in [dbo].[bingo_boards_win_order] yet
		ELSE 
			SELECT @placement = MAX([winning_placement]) + 1 FROM [dbo].[bingo_boards_win_order]

		-- get current winners excluding those previously won
		; WITH [current_winning_boards] AS (
			SELECT DISTINCT [board_id]
			FROM [dbo].[bingo_boards]
			GROUP BY [board_id], [x] HAVING SUM(is_called) = 5
			UNION
			SELECT DISTINCT [board_id]
			FROM [dbo].[bingo_boards]
			GROUP BY [board_id], [y] HAVING SUM(is_called) = 5
		)
		INSERT INTO [dbo].[bingo_boards_win_order]
		SELECT cwb.[board_id], @value, @placement
		FROM [current_winning_boards] AS cwb
		LEFT JOIN [dbo].[bingo_boards_win_order] AS bbwo ON bbwo.[board_id] = cwb.[board_id]
		WHERE bbwo.board_id IS NULL

		SELECT @number_currently_won = COUNT(*) FROM [dbo].[bingo_boards_win_order]
		PRINT '@number_currently_won: ' + CONVERT([varchar], @number_currently_won)
		IF @number_currently_won = @number_of_boards
			BREAK
	END

	PRINT ''
	FETCH NEXT FROM numbersCur INTO @id, @value
END

CLOSE numbersCur
DEALLOCATE numbersCur

/* QA */
-- SELECT * FROM [dbo].[bingo_boards_win_order] ORDER BY [winning_placement]

-- find last winning board (this assumes only one board will be the winner)
SELECT TOP 1 
	@winning_board = [board_id], 
	@winning_number = [winning_number]
FROM [dbo].[bingo_boards_win_order] 
ORDER BY [winning_placement] DESC

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
PRINT 'Figure out which board will win last.'
PRINT 'Once it wins, what would its final score be? ' + CONVERT([varchar], @sum_of_unmarked * @winning_number)

/*OUTPUT
Winning numbner: 73
Winning board_id: 44
@sum_of_unmarked: 116

Final score (@sum_of_unmarked * @winning_number): 8468
Figure out which board will win last.
Once it wins, what would its final score be? 8468
*/