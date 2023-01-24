/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 06 (part 02)

NOTE: I could never get this to finish with @days = 256. I let it execute for 20 minutes 
      but only got up to day ~130. See part two version two for solution

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
	[id] [int] IDENTITY(1,1) NOT NULL,
	[age] [smallint] NOT NULL,
	CONSTRAINT [pk_lantern_fish_tracker_id] PRIMARY KEY ([id])
)

-- CREATE NONCLUSTERED INDEX [age] ON [dbo].[lantern_fish_tracker] ([age])

-- day zero represents the "Initial State"
INSERT INTO [dbo].[lantern_fish_tracker] ([age])
SELECT [value]
FROM STRING_SPLIT((SELECT [row] FROM [dbo].[lanternfish]), ',')
-- FROM STRING_SPLIT('3,4,3,1,2', ',')

/* QA */
-- SELECT * FROM [dbo].[lantern_fish_tracker]

DECLARE 
	@days [int] = 80 -- 256
	, @day_counter [int] = 0
	, @new_fish [int] = 0
	, @count [int] = 0
	, @print [bit] = 0
	, @debug [bit] = 1
	, @start_time [datetime2]
	, @end_time [datetime2]
	, @message [nvarchar](MAX)

WHILE (1=1)
BEGIN
	SET @message = N'Starting day ' + CONVERT([nvarchar], @day_counter + 1)
	RAISERROR(@message, 0, 1) WITH NOWAIT 
	
	IF @debug = 1 SET @start_time = SYSDATETIME()

	UPDATE x SET 
		[age] = [age] - 1
	FROM [dbo].[lantern_fish_tracker] AS x
	OPTION (MAXDOP 8);

	IF @debug = 1 
	BEGIN
		SET @end_time = SYSDATETIME()
		SET @message = N'  Total seconds to set [age] - 1: ' + CONVERT([nvarchar], DATEDIFF(SECOND, @start_time, @end_time))
		RAISERROR(@message, 0, 1) WITH NOWAIT 
	END

	IF @debug = 1 SET @start_time = SYSDATETIME()

	UPDATE x SET [age] = CONVERT([smallint], 6)
	FROM [dbo].[lantern_fish_tracker] AS x
	WHERE [age] = -1
	OPTION (MAXDOP 8);
	SET @new_fish = @@ROWCOUNT
	IF @print = 1 PRINT 'New lanternfish created: ' + CONVERT([varchar](40), @new_fish)

	IF @debug = 1 
	BEGIN
		SET @end_time = SYSDATETIME()
		SET @message = N'  Total seconds to set [age] = 6: ' + CONVERT([nvarchar], DATEDIFF(SECOND, @start_time, @end_time))
		RAISERROR(@message, 0, 1) WITH NOWAIT 
	END

	IF @new_fish > 0
	BEGIN
		IF @debug = 1 SET @start_time = SYSDATETIME()

		INSERT INTO [dbo].[lantern_fish_tracker] ([age])
		SELECT CONVERT([smallint], 8) AS [age]
		FROM [dbo].[Numbers]
		WHERE Number > 0 AND Number <= @new_fish

		IF @debug = 1 
		BEGIN
			SET @end_time = SYSDATETIME()
			SET @message = N'  Total seconds to add new lanternfish: ' + CONVERT([nvarchar], DATEDIFF(SECOND, @start_time, @end_time))
			RAISERROR(@message, 0, 1) WITH NOWAIT 
		END
	END

	-- UPDATE STATISTICS [dbo].[lantern_fish_tracker] WITH FULLSCAN
	
	IF @print = 1 
	BEGIN
		SELECT @count = COUNT(*) FROM [dbo].[lantern_fish_tracker]
		SET @message = 'Total lanternfish after ' + CONVERT([varchar](40), @day_counter + 1) + ' days : ' + CONVERT([varchar](40), @count)
	END 

	IF @print = 1 PRINT ''
	SET @day_counter += 1
	IF @days = @day_counter BREAK
END

SELECT @count = COUNT(*) FROM [dbo].[lantern_fish_tracker]
PRINT ''
PRINT 'How many lanternfish would there be after ' + CONVERT([varchar](40), @days) + ' days? ' + CONVERT([varchar](40), @count)