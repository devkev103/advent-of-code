/* 
SELECT [dbo].[sort_word]('adbc') -- return 'abcd'
SELECT [dbo].[sort_word]('gabadc') -- return 'aabcdg'
*/
CREATE OR ALTER FUNCTION [dbo].[sort_word] (
	@input [varchar](10)
) RETURNS [varchar](10)
AS
BEGIN
RETURN (
	-- DECLARE @input [varchar](10) = 'dgbeaf'
	-- SELECT *
	-- https://stackoverflow.com/questions/8517816/t-sql-split-word-into-characters
	SELECT STRING_AGG (CONVERT([varchar](max),[char]), '')
	FROM (
		SELECT TOP 100 n.number+1 AS [id], SUBSTRING(a.b, n.number+1, 1) AS [char]
		FROM (SELECT @input b) a
		inner join [dbo].[Numbers] AS n ON n.[Number] < LEN(a.b)
		ORDER BY [char]
	) AS x 
)
END