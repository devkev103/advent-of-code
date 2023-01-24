/*
SELECT *
FROM [dbo].[string_split2]('1, 2, 3, 4', ',')
*/
-- https://stackoverflow.com/questions/50061036/return-value-at-a-position-from-string-split-in-sql-server-2016
CREATE OR ALTER FUNCTION [dbo].[string_split2] (
  @input [varchar](max)
  , @seperator [varchar](1)
) RETURNS @t TABLE
(
  [ordinal] [int] PRIMARY KEY IDENTITY(1, 1)
  , [value] [varchar](50)
)
AS
BEGIN
    INSERT INTO @t (VALUE) 
    SELECT [Value] 
    FROM string_split(@input, @seperator)
    RETURN
END