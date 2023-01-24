/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 02 (part 01)

********************************************************************************************/

USE [AventOfCode2021]
GO

/* load table with the script day-02-load-input.sql */

DECLARE @horizontal_position [int]
; WITH [sums] AS (
	SELECT [movement], SUM([value]) AS [sum]
	FROM [dbo].[submarine_movement]
	GROUP BY [movement]
), [pivots] AS (
	SELECT [up], [down], [forward]
	FROM [sums]
	PIVOT (
		MAX(sum)
		FOR movement in ([up], [down], [forward])
	) AS P
), calculation AS (
	SELECT [up], [down], [forward], ABS([down] - [up]) * [forward] AS [hotizontal_position]
	FROM pivots
) 
SELECT @horizontal_position = [hotizontal_position]
FROM calculation

PRINT 'Calculate the horizontal position and depth you would have after following the planned course.'
PRINT 'What do you get if you multiply your final horizontal position by your final depth? ' + CONVERT([varchar], @horizontal_position)

/* OUTPUT
Calculate the horizontal position and depth you would have after following the planned course.
What do you get if you multiply your final horizontal position by your final depth? 2019945
*/