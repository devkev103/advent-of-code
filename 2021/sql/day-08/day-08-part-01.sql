/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 08 (part 01)

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

/* load table with the script day-08-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[seven_segment_display]

DECLARE @count [int]

; WITH [display_output] AS (
	SELECT [id], SUBSTRING([row], CHARINDEX('|', [row]) + 2, LEN([row])) AS [output_value]
	FROM [dbo].[seven_segment_display]
), [split_output] AS (
	SELECT [id], [output_value], [value]
	FROM [display_output] AS do
	CROSS APPLY STRING_SPLIT(do.[output_value], ' ')  
) 
SELECT @count = COUNT(*)
FROM [split_output]
WHERE LEN([value]) IN (2, 4, 3, 7) -- we know that digits 1, 4, 7, 8 have specific lengths

PRINT 'In the output values, how many times do digits 1, 4, 7, or 8 appear? '+ CONVERT([varchar](40), @count)

/* OUTPUT
In the output values, how many times do digits 1, 4, 7, or 8 appear? 288
*/