/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 03 (part 01)

********************************************************************************************/

USE [AventOfCode2021]
GO

/* load table with the script day-03-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[diagnostic_report]

DECLARE 
	@length [int] =  0
	, @counter [int] = 1
	, @gamma_rate [varchar](50) = ''
	, @epsilon_rate [varchar](50) = ''

-- get length
SELECT TOP 1 @length = LEN([value]) FROM [dbo].[diagnostic_report]
-- PRINT 'sequence @length: ' + CONVERT([varchar], @length)

WHILE (1=1)
BEGIN
	; WITH [bits] AS (
		SELECT 
			SUBSTRING([value], @counter, 1) AS [bit]
		FROM [dbo].[diagnostic_report]
	), [grouped] AS (
		SELECT [bit], COUNT(*) AS counts
		FROM [bits]
		GROUP BY [bit]
	)
	-- SELECT [0], [1]
	SELECT 
		@gamma_rate += 
			CASE 
				WHEN [0] > [1] THEN '0'
				WHEN [0] < [1] THEN '1'
				ELSE 'X' -- according to rules this should never happen
			END,
		@epsilon_rate += 
			CASE 
				WHEN [0] < [1] THEN '0'
				WHEN [0] > [1] THEN '1'
				ELSE 'X' -- according to rules this should never happen
			END 
	FROM [grouped]
	PIVOT
	(
		MAX([counts])
		FOR [bit] IN ([0], [1])
	) AS P

	SET @counter += 1

	IF @counter > @length
		BREAK
END

-- could also calculate @epsilon_rate with inverse of @gamma_rate
PRINT '@gamma_rate binary: ' + @gamma_rate
PRINT '@epsilon_rate binary: ' + @epsilon_rate

PRINT ''
PRINT 'gamma_rate decimal: ' + CONVERT([varchar], [dbo].[BinaryToDecimal](@gamma_rate))
PRINT 'epsilon_rate decimal: ' + CONVERT([varchar], [dbo].[BinaryToDecimal](@epsilon_rate))
PRINT 'power_consumption rating: ' + CONVERT([varchar], [dbo].[BinaryToDecimal](@gamma_rate) * [dbo].[BinaryToDecimal](@epsilon_rate))

PRINT ''
PRINT 'Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together.'
PRINT 'What is the power consumption of the submarine? (Be sure to represent your answer in decimal, not binary.) ' + CONVERT([varchar], [dbo].[BinaryToDecimal](@gamma_rate) * [dbo].[BinaryToDecimal](@epsilon_rate)) 

/*OUTPUT
@gamma_rate binary: 011011110000
@epsilon_rate binary: 100100001111
 
gamma_rate decimal: 1776
epsilon_rate decimal: 2319
power_consumption rating: 4118544
 
Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together.
What is the power consumption of the submarine? (Be sure to represent your answer in decimal, not binary.) 4118544
*/