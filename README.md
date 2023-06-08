# Dynamic-pivoting-in-SQL-server
```
DECLARE @total_col VARCHAR(MAX)
DECLARE @result NVARCHAR(MAX)
SET @total_col=''

SELECT @total_col = @total_col + QUOTENAME(item) + ',' FROM items
   
SET @result=LEFT(@total_col, (LEN(@total_col)-1))
PRINT @result
```
EXPECTED OUTPUT:-
```
[col_val1],[col_val2],[col_val3],[col_val4],....,[col_valN]
```

## Analisys:-
First we declared two variable of varchar and nvarchar to contain all the column values and net result value respectivily.
```SELECT @total_col = @total_col + QUOTENAME(item) + ',' FROM items``` This line actually iterate all the column values into @total_col variable by 
comma seperated. The initial value set as ```SET @total_col=''``` just like we do in normal programming language.

### QUOTENAME() 
This function returns a Unicode string with delimiters added to it. Here by the square brackets just like shown in EXPECTED OUTPUT.

### LEFT(@total_col, (LEN(@total_col)-1))
LEFT() is a sql server function that returns a number of string starting from the left.

*Syntax:-* ```LEFT('specified string', number of string to be extracted from left)```.

For example LEFT('My name is John Doe.',5) and it's output will be 'My na'.
If LEFT('My name is John Doe.',8) output 'My name '.

The intention to use this here because to return the delimited comma seperated column values without comma at the end.
So if we do not use this the result will occure like this below.
```
[col_val1],[col_val2],[col_val3],[col_val4],....,[col_valN],
```
This will create error at pivot query. To remove this last comma from this delimited string LEFT() is mandatory.
The final result is stored at @result.

```
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
```
The pivot query must be in string under @sql variable.
@result variable has to be concatinated to this query otherwise parameter will produce a syntax error. 
Finally Execute this statement dynamically using the stored procedure **sp_executesql.** 
**sp_executesql** is a built-in stored procedure in SQL Server that enables to execute the dynamically constructed SQL statements. (**sys.sp_executesql**)

Wrap it all together in a single Stored Procedure and execute that custom build Stored Procedure to get the result.
   
