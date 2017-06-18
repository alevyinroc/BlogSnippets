# I Finally Get Cross Apply!
For *years* I've looked at various queries online in sample code, diagnostic queries using DMVs, and the like and seen  `CROSS APPLY` in the `FROM` clauses. But I've never really managed to comprehend what it was for or how it worked because I never saw a case where it was directly applied to something I was doing.

Finally, this week I had a breakthrough. I was working on updating a bunch of data but it was breaking on a small subset of that data. In this case, I was attempting to `JOIN` two tables on fields that *should* have been `INT`s, but in a very small number of cases one side was using a comma-delimited string. The user told me that someone else had done these updates in the past and didn't encounter the problem I was having (so I knew that it was something i was doing "wrong"), but given that it was only a handful of broken updates she was OK with manually doing the updates (we were scripting it because we were updating potentially tens of thousands of records).

I am not OK with manually fixing this in the future. I wanted to know how the other DBA had done it before. I dug into some history and found `CROSS APPLY`. My nemesis. I was determined to figure out how to use it this time.

## Setting the Stage
Let's set up three simple tables to keep track of airports and what state each airport is in. But Jimmy the Developer doesn't *totally* get good database design and in the table that he uses to map states to airports in a one-to-many relationship, he allows for a comma-separated list of airports associated with each state.

    CREATE TABLE #States
    ([Id]      INT IDENTITY(1, 1),
    StateName NVARCHAR(30) NOT NULL
    );
    CREATE TABLE #Airports
    ([Id]     INT IDENTITY(1, 1),
    IATACode CHAR(3) NOT NULL
    );
    CREATE TABLE #StateAirports
    (StateId  INT PRIMARY KEY NOT NULL,
    Airports NVARCHAR(50)
    )
[Image here]

This makes getting a list of airports and their associated state names tricky at best if we don't know about `CROSS APPLY`. With `CROSS APPLY`, it's pretty straightforward.

## Solution
Here's the query, and then I'll explain what's happening.

    SELECT s.statename,
        a.iatacode
    FROM #StateAirports SA1
        CROSS APPLY string_split(SA1.airports, ',') AS SA2
        JOIN #Airports A ON A.Id = SA2.value
        JOIN #states S ON S.Id = SA1.stateid
`string_split()` is a Table Valued Function which we *finally* got in SQL Server 2016 after far too many years of having to write (or, let's face it, copy from someone's blog post) inefficient string splitting functions. Important note: even if your database engine is SQL Server 2016, the database you're operating in [must be at `CompatibilityLevel 130`](https://www.mssqltips.com/sqlservertip/4350/parsing-string-data-with-the-new-sql-server-2016-stringsplit-function/)
## Breaking it down
If we take the term `CROSS APPLY` and break it down into its parts, it finally starts to make sense.
* `APPLY` the `string_split()` function to the `Airports` field of the `#StateAirports` table
* Perform a `CROSS JOIN` between the `#StateAirports`  table and the output of `string_split`

So now I have N rows for each `StateId` in `#StateAirports`, where `N` is the number of values in the comma-separated field. And `JOIN`ed to each row is one of the rows from the output of `string_split()`

[Image of just the cross apply here]

From there, the query is pretty normal otherwise. I `JOIN` to the other two tables so that I can translate the state & airport ID numbers to their text values.

[Image of final output]

Hopefully this helps others get a handle on `CROSS APPLY` and find useful places for it. This had been a head-scratched for me for years, but only because I didn't have an example that clearly broke down how to use it and what was going on. In hindsight, I probably could have used it in some analysis I did at a previous job but instead resorted to parsing & processing comma-separated data in a PowerShell script.