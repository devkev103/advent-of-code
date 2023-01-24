DROP TABLE IF EXISTS [dbo].[Numbers]
CREATE TABLE [dbo].[Numbers] (Number  [int]  NOT NULL, CONSTRAINT [pk_Numbers] PRIMARY KEY ([Number]))  

DECLARE @RowsToCreate [int] = 10000000 -- 10 million

--  "Table of numbers" data generator, as per Itzik Ben-Gan (from multiple sources)
;WITH
  Pass0 as (select 1 as C union all select 1), --2 rows
  Pass1 as (select 1 as C from Pass0 as A, Pass0 as B),--4 rows
  Pass2 as (select 1 as C from Pass1 as A, Pass1 as B),--16 rows
  Pass3 as (select 1 as C from Pass2 as A, Pass2 as B),--256 rows
  Pass4 as (select 1 as C from Pass3 as A, Pass3 as B),--65,536 rows
  Pass5 as (select 1 as C from Pass4 as A, Pass4 as B),--4,294,967,296 rows
  Tally as (select row_number() over(order by C) as Number from Pass5)
INSERT [Numbers] (Number)
SELECT Number
FROM Tally
WHERE Number <= @RowsToCreate

-- also zero
INSERT INTO [dbo].[Numbers] VALUES (0)