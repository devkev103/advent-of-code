/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 02 (load input)

********************************************************************************************/

USE [AventOfCode2021]
GO

DROP TABLE IF EXISTS [dbo].[submarine_movement]
GO

CREATE TABLE [dbo].[submarine_movement] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[movement] [varchar](40) NOT NULL,
	[value] [int] NOT NULL
)

/* load from file */
/*** POWERSHELL ***

$day = "day-02"
$path = "C:\git\gitlab-kevbenoit\advent-of-code\2021\sql\$($day)"
$table_name = "[dbo].[submarine_movement]"
Set-Location $path

bcp "$($table_name)" format nul -S 'localhost' -T -d 'AventOfCode2021' -f ".\$($day)-format.fmt" -c -t'' -r'\n' 
#  remove the [id] column from the .fmt file; reduce "Host file field order" and "Number of columns" by 1 

bcp "$($table_name)" in ".\$($day)-input.txt" -S "localhost" -T -d "AventOfCode2021" -f ".\$($day)-format.fmt"

*/

/* QA */
SELECT * FROM [dbo].[submarine_movement]