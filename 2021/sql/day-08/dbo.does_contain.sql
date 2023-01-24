/*
SELECT [dbo].[does_contain]('abcd', 'ag') -- return 0 - the input does not contain both 'a' and 'g' from the @search pattern
SELECT [dbo].[does_contain]('abcd', 'acb') -- return 1 - the input does contain both 'a', 'c' and 'b' from the @search pattern
SELECT [dbo].[does_contain]('eg', 'hgkdke') -- return 1 - the input does contain both 'e', 'g' from the @search pattern
SELECT [dbo].[does_contain]('bgdcaf', 'eg') -- return 0 - the input does not contain 'e' and 'g' from the @search pattern
SELECT [dbo].[does_contain]('dgbeaf', 'eg') -- return 1 - the input does contain 'e' and 'g' from the @search pattern
*/
CREATE OR ALTER FUNCTION [dbo].[does_contain] (
	@input [varchar](10) 
	, @search [varchar](10)
) RETURNS [bit]
AS
BEGIN
RETURN (
	-- DECLARE @input [varchar](10) = 'dgbeaf', @search [varchar](10) = 'eg'
	-- SELECT LEN(@input), LEN(@search), SUM([does_contain]) 
	SELECT CASE WHEN LEN(@input) = SUM([does_contain]) OR LEN(@search) = SUM([does_contain]) THEN 1 ELSE 0 END
	FROM (
		-- https://stackoverflow.com/questions/8517816/t-sql-split-word-into-characters
		SELECT n.number+1 AS [id], CASE WHEN CHARINDEX(SUBSTRING(a.b, n.number+1, 1), @search) = 0 THEN 0 ELSE 1 END AS [does_contain]
		FROM (SELECT @input b) a
		inner join [dbo].[Numbers] AS n ON n.[Number] < LEN(a.b)
	) AS x
)
END