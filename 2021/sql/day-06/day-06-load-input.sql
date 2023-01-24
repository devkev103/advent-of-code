/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 06 (load input)

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

DROP TABLE IF EXISTS [dbo].[lanternfish]
GO

CREATE TABLE [dbo].[lanternfish] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[row] [varchar](1000) NULL
)
GO

/* load from file */
/*** POWERSHELL ***

$day = "day-06"
$path = "C:\git\gitlab-kevbenoit\advent-of-code\2021\sql\$($day)"
$table_name = "[dbo].[lanternfish]"
Set-Location $path

bcp "$($table_name)" format nul -S 'localhost' -T -d 'AventOfCode2021' -f ".\$($day)-format.fmt" -c -t'' -r'\n' 
#  remove the [id] column from the .fmt file; reduce "Host file field order" and "Number of columns" by 1 

bcp "$($table_name)" in ".\$($day)-input.txt" -S "localhost" -T -d "AventOfCode2021" -f ".\$($day)-format.fmt"

*/

/* QA */
SELECT * FROM [dbo].[lanternfish]