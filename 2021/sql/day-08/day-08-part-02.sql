/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 08 (part 02)

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

/* load table with the script day-08-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[seven_segment_display]

DROP TABLE IF EXISTS [dbo].[seven_segment_display_decoded]

CREATE TABLE [dbo].[seven_segment_display_decoded] (
	[id] [int] NOT NULL,
	[input] [varchar](100) NOT NULL,
	[value] [varchar](100) NOT NULL,
	[sorted_value] [varchar](100) NOT NULL,
	[number] [varchar](1) NOT NULL
)

DECLARE @count [int]

; WITH [display_input] AS (
	SELECT 
		[id]
		, SUBSTRING([row], 1, CHARINDEX('|', [row]) -2) AS [input_value]
		, SUBSTRING([row], CHARINDEX('|', [row]) + 2, LEN([row])) AS [output_value]
	FROM [dbo].[seven_segment_display]
), [split_input] AS (
	SELECT [id], [input_value], [value], [dbo].[sort_word]([value]) AS [value_sorted]
	FROM [display_input] AS do
	CROSS APPLY STRING_SPLIT(do.[input_value], ' ')  
), [split_output] AS (
	SELECT [id], [ordinal], [output_value], [value], [dbo].[sort_word]([value]) AS [value_sorted]
	FROM [display_input] AS do
	CROSS APPLY [dbo].[string_split2](do.[output_value], ' ')  
), [decode_1] AS (
	SELECT 
		si1.[id],
		si1.[input_value], 
		si1.[value],
		CASE 
			WHEN LEN([value]) = 2 THEN 1
			WHEN LEN([value]) = 4 THEN 4
			WHEN LEN([value]) = 3 THEN 7
			WHEN LEN([value]) = 7 THEN 8
			WHEN LEN([value]) = 6 
				AND [dbo].[does_contain](
					[value], 
					(SELECT [value] FROM [split_input] AS si2 WHERE LEN(si2.[value]) = 2 AND si2.[id] = si1.[id]) -- value for '1'
				) = 0
				THEN 6 -- does not contain any '1' values
			WHEN LEN([value]) = 6 
				AND [dbo].[does_contain](
					[value], 
					(SELECT [value] FROM [split_input] AS si2 WHERE LEN(si2.[value]) = 4 AND si2.[id] = si1.[id]) -- value for '4'
				) = 1 THEN 9 -- does contain '4' value
			WHEN LEN([value]) = 6 THEN 0 -- only digit left with LEN = 6
			ELSE -1
		END AS [number_value]
	FROM [split_input] AS si1
    -- WHERE si1.[id] IN (1) -- for debugging
), [decode_2] AS (
	SELECT 
		d1.[id],
		d1.[input_value], 
		d1.[value],
		CASE
			WHEN LEN([value]) = 5 
				AND [dbo].[does_contain](
					[value],
					(SELECT [value] FROM [decode_1] AS d2 WHERE d2.[id] = d1.[id] AND d2.number_value = 6) -- value for '6'
				) = 1 THEN 5
			WHEN LEN([value]) = 5 
				AND [dbo].[does_contain](
					[value],
					(SELECT [value] FROM [decode_1] AS d2 WHERE d2.[id] = d1.[id] AND d2.number_value = 9) -- value for '9'
				) = 1 THEN 3
			WHEN LEN([value]) = 5 THEN 2 -- only digit left with LEN = 5
			ELSE d1.[number_value] 
		END AS [number_value]
	FROM [decode_1] AS d1
), [decoded] AS (
	SELECT 
		d.[id]
		, d.[input_value] AS [input]
		, d.[value]
		, si.[value_sorted] AS [sorted_value]
		, d.[number_value]
		--, so.[output_value]
		--, so.[value] AS [output]
	FROM [decode_2] AS d
	INNER JOIN [split_input] AS si ON si.id = d.id AND si.[value] = d.[value]
	--LEFT JOIN [split_output] AS so ON d.[id] = so.[id] AND si.[value_sorted] = so.[value_sorted]
), numbers AS (
	SELECT TOP 10000 d.id, d.number_value
	FROM split_output AS so
	INNER JOIN decoded AS d ON d.id = so.id AND d.sorted_value = so.value_sorted
	ORDER BY so.[id], so.[ordinal]
), decoded_output_number AS (
	SELECT STRING_AGG (CONVERT([varchar](max),[number_value]), '') AS [decoded_output_number]
	FROM numbers
	GROUP BY [id]
)
SELECT @count = SUM(CONVERT([int], [decoded_output_number]))
FROM decoded_output_number

PRINT 'For each entry, determine all of the wire/segment connections and decode the four-digit output values.'
PRINT 'What do you get if you add up all of the output values? '+ CONVERT([varchar](40), @count)

/* OUTPUT
For each entry, determine all of the wire/segment connections and decode the four-digit output values.
What do you get if you add up all of the output values? 940724
*/