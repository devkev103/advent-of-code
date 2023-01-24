/********************************************************************************************

ADVENT OF CODE - 2021 : DAY 00 (INIT)

********************************************************************************************/
USE master
GO

DROP DATABASE IF EXISTS [AventOfCode2021]
GO

CREATE DATABASE [AventOfCode2021]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AventOfCode2021_data01', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AventOfCode2021_data01.mdf' , SIZE = 512MB , MAXSIZE = 512MB , FILEGROWTH = 128MB ),
( NAME = N'AventOfCode2021_data02', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AventOfCode2021_data02.mdf' , SIZE = 512MB , MAXSIZE = 512MB , FILEGROWTH = 128MB ),
( NAME = N'AventOfCode2021_data03', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AventOfCode2021_data03.mdf' , SIZE = 512MB , MAXSIZE = 512MB , FILEGROWTH = 128MB ),
( NAME = N'AventOfCode2021_data04', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AventOfCode2021_data04.mdf' , SIZE = 512MB , MAXSIZE = 512MB , FILEGROWTH = 128MB )
 LOG ON 
( NAME = N'AventOfCode2021_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AventOfCode2021_log.ldf' , SIZE = 8192KB , MAXSIZE = 20480000KB , FILEGROWTH = 102400KB )
GO
ALTER DATABASE [AventOfCode2021] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [AventOfCode2021] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AventOfCode2021] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AventOfCode2021] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AventOfCode2021] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AventOfCode2021] SET ARITHABORT OFF 
GO
ALTER DATABASE [AventOfCode2021] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AventOfCode2021] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AventOfCode2021] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [AventOfCode2021] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AventOfCode2021] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AventOfCode2021] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AventOfCode2021] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AventOfCode2021] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AventOfCode2021] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AventOfCode2021] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AventOfCode2021] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AventOfCode2021] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AventOfCode2021] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AventOfCode2021] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AventOfCode2021] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AventOfCode2021] SET  READ_WRITE 
GO
ALTER DATABASE [AventOfCode2021] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [AventOfCode2021] SET  MULTI_USER 
GO
ALTER DATABASE [AventOfCode2021] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AventOfCode2021] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AventOfCode2021] SET DELAYED_DURABILITY = DISABLED 
GO
USE [AventOfCode2021]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = On;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = Primary;
GO
USE [AventOfCode2021]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [AventOfCode2021] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO