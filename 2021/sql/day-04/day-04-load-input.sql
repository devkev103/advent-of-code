/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 04 (load input)

********************************************************************************************/

USE [AventOfCode2021]
GO

SET NOCOUNT ON
GO

DROP TABLE IF EXISTS [dbo].[bingo_boards_staging]
GO

CREATE TABLE [dbo].[bingo_boards_staging] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[row] [varchar](1000) NULL
)
GO

/* load from file */
/*** POWERSHELL ***

$day = "day-04"
$path = "C:\git\gitlab-kevbenoit\advent-of-code\2021\sql\$($day)"
$table_name = "[dbo].[bingo_boards_staging]"
Set-Location $path

bcp "$($table_name)" format nul -S 'localhost' -T -d 'AventOfCode2021' -f ".\$($day)-format.fmt" -c -t'' -r'\n' 
#  remove the [id] column from the .fmt file; reduce "Host file field order" and "Number of columns" by 1 

bcp "$($table_name)" in ".\$($day)-input.txt" -S "localhost" -T -d "AventOfCode2021" -f ".\$($day)-format.fmt"

*/

/* QA */
SELECT * FROM [dbo].[bingo_boards_staging]