CREATE OR ALTER PROCEDURE dynamic_pivoting
AS
BEGIN
   DECLARE @total_col VARCHAR(MAX)
   DECLARE @result NVARCHAR(MAX)
   DECLARE @sql NVARCHAR(MAX)
   SET @total_col=''
   
   SELECT @total_col = @total_col + QUOTENAME(item) + ',' FROM items
   
   SET @result=LEFT(@total_col, (LEN(@total_col)-1))
   --PRINT @result

   SET @sql='SELECT * FROM (
     SELECT
         [item]
         ,[num_items]
     FROM [practice].[dbo].[items]
   ) AS pvt_tbl
   PIVOT (
     MAX(num_items)
     --FOR item IN ([shoes],[toy],[cloaths])
     FOR item IN ('+@result+')
   ) AS abc' 
   
   EXECUTE sp_executesql @sql
END

EXEC dynamic_pivoting
