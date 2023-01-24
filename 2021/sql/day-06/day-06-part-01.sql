/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 06 (part 01)

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

/* load table with the script day-06-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[lantern_fish]

DROP TABLE IF EXISTS [dbo].[lantern_fish_tracker]

CREATE TABLE [dbo].[lantern_fish_tracker] (
	[day] [int] NOT NULL,
	[age] [int] NOT NULL
)

CREATE CLUSTERED INDEX [day] ON [dbo].[lantern_fish_tracker] ([day])

-- day zero represents the "Initial State"
INSERT INTO [dbo].[lantern_fish_tracker] ([day], [age])
SELECT 0, [value]
FROM STRING_SPLIT((SELECT [row] FROM [dbo].[lanternfish]), ',')
-- FROM STRING_SPLIT('3,4,3,1,2', ',')

/* QA */
-- SELECT * FROM [dbo].[lantern_fish_tracker]

DECLARE @days [int] = 80, @day_counter [int] = 0, @new_fish [int] = 0, @count [int] = 0
WHILE (1=1)
BEGIN
	INSERT INTO [dbo].[lantern_fish_tracker] ([day], [age])
	SELECT @day_counter + 1 AS [day], [age] - 1 AS [age] 
	FROM [dbo].[lantern_fish_tracker]
	WHERE [day] = @day_counter 

	UPDATE x SET [age] = 6
	FROM [dbo].[lantern_fish_tracker] AS x
	WHERE [day] = @day_counter + 1 AND [age] = -1
	SET @new_fish = @@ROWCOUNT
	PRINT 'New lanternfish created: ' + CONVERT([varchar](40), @new_fish)

	IF @new_fish > 0
	BEGIN
		INSERT INTO [dbo].[lantern_fish_tracker] ([day], [age])
		SELECT  @day_counter + 1 AS [day], 8 As [age]
		FROM [dbo].[Numbers]
		WHERE Number > 0 AND Number <= @new_fish
	END

	SELECT @count = COUNT(*) FROM [dbo].[lantern_fish_tracker] WHERE [day] = @day_counter + 1
	PRINT 'Total lanternfish after ' + CONVERT([varchar](40), @day_counter + 1) + ' days : ' + CONVERT([varchar](40), @count)

	PRINT ''
	SET @day_counter += 1
	IF @days = @day_counter BREAK
END

SELECT @count = COUNT(*) FROM [dbo].[lantern_fish_tracker] WHERE [day] = @days
PRINT 'How many lanternfish would there be after ' + CONVERT([varchar](40), @days) + ' days? ' + CONVERT([varchar](40), @count)

/* OUTPUT 
How many lanternfish would there be after 80 days? 389726 
*/