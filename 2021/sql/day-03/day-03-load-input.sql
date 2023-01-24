/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 03 (load input)

********************************************************************************************/

USE [AventOfCode2021]
GO

DROP TABLE IF EXISTS [dbo].[diagnostic_report]
GO

CREATE TABLE [dbo].[diagnostic_report] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[value] [varchar](40) NOT NULL
)
GO

/* load from file */
/*** POWERSHELL ***

$day = "day-03"
$path = "C:\git\gitlab-kevbenoit\advent-of-code\2021\sql\$($day)"
$table_name = "[dbo].[diagnostic_report]"
Set-Location $path

bcp "$($table_name)" format nul -S 'localhost' -T -d 'AventOfCode2021' -f ".\$($day)-format.fmt" -c -t'' -r'\n' 
#  remove the [id] column from the .fmt file; reduce "Host file field order" and "Number of columns" by 1 

bcp "$($table_name)" in ".\$($day)-input.txt" -S "localhost" -T -d "AventOfCode2021" -f ".\$($day)-format.fmt"

*/

/* QA */
SELECT * FROM [dbo].[diagnostic_report]