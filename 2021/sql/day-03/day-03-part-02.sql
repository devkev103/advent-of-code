/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 03 (part 02)

********************************************************************************************/
SET NOCOUNT ON
GO

USE [AventOfCode2021]
GO

/* load table with the script day-03-load-input.sql */

/* QA */
-- SELECT * FROM [dbo].[diagnostic_report]

DECLARE 
	@oxygen_generator_rating [varchar](50) = ''
	, @co2_scrubber_rating [varchar](50) = ''

DROP TABLE IF EXISTS [dbo].[diagnostic_report_remaining]
CREATE TABLE [dbo].[diagnostic_report_remaining] (
	[id] [int] NOT NULL,
	[value] [varchar](40) NOT NULL
)

-- find oxygen rating
EXECUTE [dbo].[usp_decode_diagnostic_report] 
	@type = 'oxygen'
	, @length = 12 -- length of bits in sequence
	, @sequence = @oxygen_generator_rating OUTPUT

-- find co2 rating
EXECUTE [dbo].[usp_decode_diagnostic_report] 
	@type = 'co2'
	, @length = 12 -- length of bits in sequence
	, @sequence = @co2_scrubber_rating OUTPUT

PRINT ''
PRINT '@oxygen_generator_rating binary: ' + @oxygen_generator_rating
PRINT '@co2_scrubber_rating binary: ' + @co2_scrubber_rating

PRINT ''
PRINT 'oxygen_generator_rating decimal: ' + CONVERT([varchar], [dbo].[BinaryToDecimal](@oxygen_generator_rating))
PRINT 'co2_scrubber_rating decimal: ' + CONVERT([varchar], [dbo].[BinaryToDecimal](@co2_scrubber_rating))
PRINT 'life support rating: ' + CONVERT([varchar], [dbo].[BinaryToDecimal](@oxygen_generator_rating) * [dbo].[BinaryToDecimal](@co2_scrubber_rating))

PRINT ''
PRINT 'Use the binary numbers in your diagnostic report to calculate the oxygen generator rating and CO2 scrubber rating, then multiply them together.' 
PRINT 'What is the life support rating of the submarine? (Be sure to represent your answer in decimal, not binary.) ' + CONVERT([varchar], [dbo].[BinaryToDecimal](@oxygen_generator_rating) * [dbo].[BinaryToDecimal](@co2_scrubber_rating))

/*OUTPUT
@oxygen_generator_rating binary: 010111110111
@co2_scrubber_rating binary: 100111001110
 
oxygen_generator_rating decimal: 1527
co2_scrubber_rating decimal: 2510
life support rating: 3832770
 
Use the binary numbers in your diagnostic report to calculate the oxygen generator rating and CO2 scrubber rating, then multiply them together.
What is the life support rating of the submarine? (Be sure to represent your answer in decimal, not binary.) 3832770
*/