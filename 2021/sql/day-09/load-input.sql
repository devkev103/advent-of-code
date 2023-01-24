/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 09 (load input)

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

DROP TABLE IF EXISTS [dbo].[heightmap]
GO

CREATE TABLE [dbo].[heightmap] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[row] [varchar](MAX) NULL
)
GO

/* load from file */
/*** POWERSHELL ***

$day = "day-09"
$path = "C:\git\gitlab-kevbenoit\advent-of-code\2021\sql\$($day)"
$table_name = "[dbo].[heightmap]"
Set-Location $path

bcp "$($table_name)" format nul -S 'localhost' -T -d 'AventOfCode2021' -f ".\format.fmt" -c -t'' -r'\n' 
#  remove the [id] column from the .fmt file; reduce "Host file field order" and "Number of columns" by 1 

bcp "$($table_name)" in ".\input.txt" -S "localhost" -T -d "AventOfCode2021" -f ".\format.fmt"

*/

/* QA */
SELECT * FROM [dbo].[heightmap]