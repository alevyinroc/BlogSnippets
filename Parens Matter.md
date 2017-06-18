In the course of testing a major upgrade, one of my users in Accounting happened upon a problem with one of the tasks she was attempting to perform. The web-based system we were working on had a habit of "locking up" on people when loading some pages; in most cases, it was because the server was pushing a *huge* HTML table to the client, and most web browsers struggle when faced with several megabytes of markup and thousands of rows in a single table. Digging into the source code for the page and SQL Profiler (yes, I know Extended Events are a thing), we were able to isolate the query.

It starts innocently enough.

[code language="sql"]
    
    SELECT TOP 301 Field1, Field2 FROM Ledger1

[/code]

This system uses `TOP` every now and then in an attempt to limit the number of records it gets back (and the developers always seem to use the arbitrary `301` - I'm guessing some degree of [cargo cult programming](https://en.wikipedia.org/wiki/Cargo_cult_programming) going on). I'd prefer a well-constructed `WHERE` clause to limit the result set but beggars can't be choosers when working with vendor code.

But where it gets weird is that the `Ledger1` table doesn't get a lot of traffic - with the `WHERE` clause in use (omitted here for brevity), you'd only get a handful of records, maybe a dozen at most. The query continued...

[code language="sql"]

    SELECT TOP 301 Field1, Field2 FROM Ledger1
    UNION ALL
    SELECT Field1, Field2 FROM Ledger2 ORDER BY Field1 DESC

[/code]

Here's where things get interesting. In comparison to `Ledger1`, `Ledger2` is *huge* - we're talking one or two orders of magnitude larger. And with that same `WHERE` clause, you could easily pull back a couple hundred to a couple thousand records from `Ledger2`.

Where did the developers go wrong? In a query with `UNION`s, you really have multiple independent, distinct queries whose results are getting glued together before being sent back to the client. In this case, the `TOP 301` was only applied to the first subquery. I *suspect* that the developers' intent was to limit the entire result set to 301 records, but never tested with enough data in either table to know for certain that this was working properly.

To properly limit the results of a `UNION` query, we have to wrap the whole thing in parenthesis and treat it as a subquery.

[code language="sql"]

    SELECT TOP 301 Field1, Field2 FROM (
        SELECT Field1, Field2 from Ledger1
        UNION ALL
        SELECT Field1, Field2 from Ledger2
    )
[/code]

