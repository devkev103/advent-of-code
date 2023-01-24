USE AventOfCode2021
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_lanternfish_population_projection]
(
	@initial_age [int]
	, @days [int]
	, @print [bit] = 1
	, @debug [bit] = 0
	, @population [int] OUTPUT
)
AS

DECLARE 
	@day_counter [int] = 0
	, @new_fish [int] = 0
	, @count [int] = 0
	, @start_time [datetime2]
	, @end_time [datetime2]
	, @message [nvarchar](MAX)

-- drop table and create new
DROP TABLE IF EXISTS [dbo].[lanternfish_tracker]
DROP TABLE IF EXISTS [dbo].[lanternfish_tracker_dump]

CREATE TABLE [dbo].[lanternfish_tracker] (
	-- [id] [int] IDENTITY(1,1) NOT NULL,
	[age] [tinyint] NOT NULL
	-- CONSTRAINT [pk_lanternfish_tracker] PRIMARY KEY ([id])
) -- WITH (DATA_COMPRESSION = PAGE)

-- CREATE NONCLUSTERED INDEX [age] ON [dbo].[lanternfish_tracker] ([age])

INSERT INTO [dbo].[lanternfish_tracker] ([age]) VALUES (@initial_age)

WHILE (1=1)
BEGIN
	SET @message = N'@initial_age '+ CONVERT([nvarchar], @initial_age)  +' - starting day ' + CONVERT([nvarchar], @day_counter + 1) 
	RAISERROR(@message, 0, 1) WITH NOWAIT 
	
	IF @debug = 1 SET @start_time = SYSDATETIME()

	SELECT @new_fish = COUNT(*)
	FROM [dbo].[lanternfish_tracker] AS x
	WHERE [age] = 0 -- about to be -1
	OPTION (MAXDOP 8);
	IF @print = 1 PRINT '  New lanternfish created: ' + CONVERT([varchar](40), @new_fish)

	UPDATE x SET 
		[age] = CASE WHEN [age] = 0 THEN 6 ELSE [age] - 1 END
	FROM [dbo].[lanternfish_tracker] AS x

	IF @debug = 1 
	BEGIN
		SET @end_time = SYSDATETIME()
		SET @message = N'  Total seconds to set [age]: ' + CONVERT([nvarchar], DATEDIFF(SECOND, @start_time, @end_time))
		RAISERROR(@message, 0, 1) WITH NOWAIT 
	END

	IF @new_fish > 0
	BEGIN
		IF @debug = 1 SET @start_time = SYSDATETIME()

		IF @new_fish > 100000000 BEGIN RAISERROR('@new_fish to be added bigger than our numbers table ... expand it!', 16, 16); RETURN END

		INSERT INTO [dbo].[lanternfish_tracker] ([age])
		SELECT CONVERT([tinyint], 8) AS [age]
		FROM [dbo].[Numbers]
		WHERE Number > 0 AND Number <= @new_fish

		IF @debug = 1 
		BEGIN
			SET @end_time = SYSDATETIME()
			SET @message = N'  Total seconds to add new lanternfish: ' + CONVERT([nvarchar], DATEDIFF(SECOND, @start_time, @end_time))
			RAISERROR(@message, 0, 1) WITH NOWAIT 
		END
	END

	-- UPDATE STATISTICS [dbo].[lanternfish_tracker] WITH FULLSCAN
	-- DBCC SHRINKFILE (N'AventOfCode2021_log' , 0) WITH NO_INFOMSGS 
	
	IF @print = 1 
	BEGIN
		SELECT @count = SUM(st.row_count) FROM sys.dm_db_partition_stats st WHERE object_name(object_id) = 'lanternfish_tracker' AND (index_id < 2) -- quick count
		-- SELECT @count = COUNT(*) FROM [dbo].[lanternfish_tracker]
		SET @message = '  Total lanternfish after ' + CONVERT([varchar](40), @day_counter + 1) + ' days : ' + CONVERT([varchar](40), @count)
		RAISERROR(@message, 0, 1) WITH NOWAIT 
	END 

	IF @print = 1 PRINT ''
	SET @day_counter += 1
	IF @days = @day_counter BREAK
END

SELECT @population = COUNT(*) FROM [dbo].[lanternfish_tracker]
PRINT 'Population after '+ CONVERT([varchar], @days) + ' days with @initial_age of ' + CONVERT([varchar], @initial_age) + ': ' + CONVERT([varchar], @population)