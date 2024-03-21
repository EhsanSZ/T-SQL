
USE WF;
GO

-- Island & Numeric Values

DROP TABLE IF EXISTS dbo.Island_Numeric;
GO

CREATE TABLE dbo.Island_Numeric
(
	Col1 INT PRIMARY KEY
);
GO

INSERT INTO dbo.Island_Numeric(Col1)
VALUES
	(2),(3),(11),(12),(13),(27),(33),(34),(35),(42);
GO

SELECT * FROM dbo.Island_Numeric;
GO

/*
Island_Numeric با توجه به مقادیر موجود در جدول
:به‌صورت زیر خواهد بود Island محدوده

Range_Start   Range_End
-----------  -----------
    2           3
    11          13
    27          27
    33          35
	42			42
*/

/*
WF روش حل مسئله بدون استفاده از قابلیت

خوانده می‌شود Island_Numeric به‌ازای هر ستونی که از جدول
مقدار متناظر آن برابر با کمینه مقداری بزرگ‌تر یا ‌برابر با خودش است
!که اختلافش با سایر مقادیر برابر با 1 نشود

در واقع در روش سنتی به‌ازای هر رکورد از جدول می‌خواهیم
! بدانیم که در هر لحظه انتهای بازه پیوسته به آن عدد چیست
*/
SELECT
	Col1,
	(SELECT MIN(I2.Col1) FROM dbo.Island_Numeric AS I2
		WHERE I2.Col1 >= I1.Col1
		AND NOT EXISTS (SELECT 1 FROM dbo.Island_Numeric AS I3
							WHERE I3.Col1 = I2.Col1 + 1)) AS Grp
FROM dbo.Island_Numeric AS I1;
GO

/*
برای آن‌که کوئری بالا را بهتر متوجه شوید
.به‌صورت گام‌به‌گام یکی دو مقدار را تست می‌کنیم

.خوانده می‌شود Island_Numeric ابتدا مقدار 2 از جدول
برایش انتخاب شود MIN(I2.Col1) حالا قرار است مقدار
.که می‌بایست دو شرط زیر برایش بررسی شود

:است که داریم I2.Col1 >= I1.Col1 یکی از شر‌ط‌ها
WHERE I2.Col1 >= 2
:یعنی مقادیری که این شرط برای‌شان برقرار است عبارت است از
2,3,11,12,13,27,33,34,35,42

است در واقع باید به‌ازای NOT EXISTS شرط دیگر که به‌صورت
.ارزیابی شود FALSE به‌صورت EXISTS جلو Subquery مقداری باشد که در
بنابراین هر یک از مقادیر 2,3,11,12,13,27,33,34,35,42 به داخل شرط
.شد انتخاب شود FALSE هدایت می‌شوند تا کم‌ترین مقداری که شرط برایش
WHERE I3.Col1 = I2.Col1 + 1

:برای مقدار 2 داریم
I3.Col1 = 2 + 1
این تساوی برقرار است چرا که در جدول
مقدار 3 وجود دارد Island_Numeric
ارزیابی می‌شود در TRUE پس این شرط
.بودیم FALSE حالی‌که به‌دنبال ارزیابی


:در ادامه برای مقدار 3 داریم
I3.Col1 = 3 + 1
این تساوی هیچ‌گاه برقرار است چرا که
مقدار 4 وجود ندارد Island_Numeric در جدول
ارزیابی می‌شود و مقدار 3 به‌عنوان ‌ ‌FALSE پس این شرط
.فیلد متناظر برای رکورد اول انتخاب می‌شود


:اکنون به‌صورت اجمالی مقدار بعدی را که 3 هست بررسی می‌کنیم
WHERE I2.Col1 >= 3
:یعنی مقادیری که این شرط برای‌شان برقرار است عبارت است از
3,11,12,13,27,33,34,35,42

WHERE I3.Col1 = I2.Col1 + 1
I3.Col1 = 3 + 1

این تساوی هیچ‌گاه برقرار است چرا که
مقدار 4 وجود ندارد Island_Numeric در جدول
ارزیابی می‌شود و مقدار 3 به‌عنوان ‌ ‌FALSE پس این شرط
.فیلد متناظر برای رکورد دوم انتخاب می‌شود

.ادامه می‌دهیم Island_Numeric و این روند را برای سایر مقادیر جدول
*/

-- final solution using traditional query elements
/*
Derived Table نتایج حاصل از کوئری بالا را در قالب یک
Grp در کوئری دیگری پاس می‌دهیم و با گروه‌بندی بر روی فیلد
.را به‌دست می‌آوریم MAX و MIN هر یک از مقادیر
*/
SELECT
	MIN(Col1) AS Range_Start,
	MAX(Col1) AS Range_End
FROM (SELECT Col1,
			 (SELECT MIN(I2.Col1) FROM dbo.Island_Numeric AS I2
				WHERE I2.Col1 >= I1.Col1 
				AND NOT EXISTS (SELECT 1 FROM dbo.Island_Numeric AS I3
									WHERE I3.Col1 = I2.Col1 + 1)) AS Grp
	   FROM dbo.Island_Numeric AS I1
	   ) AS Tmp
GROUP BY Grp;
GO
--------------------------------------------------------------------

-- ROW_NUMBER روش حل مسئله با استفاده از
SELECT
	Col1,
	ROW_NUMBER() OVER(ORDER BY Col1) AS Row_Num
FROM dbo.Island_Numeric;
GO
/*
 Col1    Row_Num
------  --------
  2        1
  3        2
  11       3
  12       4
  13       5
  27       6
  33       7
  34       8
  35       9
  42       10
*/

-- ROW_NUMBER و رتبه تخصصیص داده‌شده از طریق Col1 محاسبه اختلاف میان ستون
SELECT
	Col1,
	Col1 - ROW_NUMBER() OVER(ORDER BY Col1) AS Diff
FROM dbo.Island_Numeric;
GO
/*
 Col1    Diff
------  ------
  2       1
  3       1
  11      8
  12      8
  13      8
  27      21
  33      26
  34      26
  35      26
  42      32
*/

-- .استفاده نکرده‌ایم WF دقیقا مشابه با حالتی که از قابلیت
-- Derived Table
SELECT
	MIN(Col1) AS Range_Start,
	MAX(Col1) AS Range_End
FROM (SELECT
		Col1,
        Col1 - ROW_NUMBER() OVER(ORDER BY Col1) AS Grp
      FROM dbo.Island_Numeric
	  ) AS Tmp
GROUP BY Grp;
GO

-- CTE
WITH CTE
AS
(
	SELECT
		Col1,
		Col1 - ROW_NUMBER() OVER(ORDER BY Col1) AS Grp
	FROM dbo.Island_Numeric
)
SELECT
	MIN(Col1) AS Range_Start,
	MAX(Col1) AS Range_End
FROM CTE
GROUP BY Grp;
GO
--------------------------------------------------------------------

-- Island & Date Values
DROP TABLE IF EXISTS dbo.Island_Date;
GO

CREATE TABLE dbo.Island_Date
(
  Col1 DATE NOT NULL PRIMARY KEY
);
GO

INSERT INTO dbo.Island_Date(Col1)
VALUES
	('20180402'),
	('20180403'),
	('20180407'),
	('20180408'),
	('20180409'),
	('20180411'),
	('20180415'),
	('20180416'),
	('20180417'),
	('20180428');
GO

SELECT * FROM dbo.Island_Date;
GO

/*
Island_Date با توجه به مقادیر موجود در جدول
:به‌صورت زیر خواهد بود Island محدوده

Range_Start   Range_End
-----------   ----------
2018-04-02    2018-04-03
2018-04-07    2018-04-09
2018-04-11    2018-04-11
2018-04-15    2018-04-17
2018-04-28    2018-04-28
*/

WITH CTE
AS
(
	SELECT
		Col1,
		DATEADD(DAY, -1 * ROW_NUMBER() OVER(ORDER BY Col1), Col1) AS Grp
	FROM dbo.Island_Date
)
SELECT
	MIN(Col1) AS Range_Start,
	MAX(Col1) AS Range_End
FROM CTE
GROUP BY Grp;
GO