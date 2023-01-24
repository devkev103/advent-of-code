USE AventOfCode2021
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_decode_diagnostic_report] (
	@type [varchar](40) -- oxygen OR co2
	, @length [int] = 12
	, @sequence [varchar](50) OUTPUT 
)
AS
DECLARE 
	@counter [int] = 1
	, @current_sequence [varchar](50) = ''

TRUNCATE TABLE [dbo].[diagnostic_report_remaining]
INSERT INTO [dbo].[diagnostic_report_remaining] SELECT [id], [value] FROM [dbo].[diagnostic_report]

WHILE (1=1)
BEGIN
	; WITH [bits] AS (
		SELECT 
			SUBSTRING([value], @counter, 1) AS [bit]
		FROM [dbo].[diagnostic_report_remaining]
	), [grouped] AS (
		SELECT [bit], COUNT(*) AS counts
		FROM [bits]
		GROUP BY [bit]
	)
	SELECT 
		@current_sequence += 
			CASE 
				WHEN @type = 'oxygen' AND [0] > [1] THEN '0'
				WHEN @type = 'oxygen' AND [0] < [1] THEN '1'
				WHEN @type = 'oxygen' AND [0] = [1] THEN '1'

				WHEN @type = 'co2' AND [0] < [1] THEN '0'
				WHEN @type = 'co2' AND [0] > [1] THEN '1'
				WHEN @type = 'co2' AND [0] = [1] THEN '0'

				ELSE 'X' -- according to rules this should never happen
			END
	FROM [grouped]
	PIVOT
	(
		MAX([counts])
		FOR [bit] IN ([0], [1])
	) AS P

	-- exit early if there is only one type of sequence left
	IF (
		(SELECT COUNT(counts) FROM (
			SELECT COUNT(*) AS counts
			FROM [dbo].[diagnostic_report_remaining]
			GROUP BY [value]) AS x
		) = 1
	)
		BREAK

	DELETE X FROM [dbo].[diagnostic_report_remaining] AS X WHERE [value] NOT LIKE @current_sequence + '%'
	PRINT @type + ' - @current_sequence: "' + @current_sequence + '" - removed rows: ' + CONVERT([varchar], @@ROWCOUNT)

	SET @counter += 1
END

SELECT TOP 1 @sequence = [value] FROM [dbo].[diagnostic_report_remaining]

RETURN