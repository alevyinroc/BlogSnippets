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
);
INSERT INTO #States(StateName)
VALUES('Illinois'), ('New York'), ('Pennsylvania');
INSERT INTO #Airports(IATACode)
VALUES('ALB'), ('SYR'), ('JFK'), ('LGA'), ('ROC'), ('BUF');
INSERT INTO #Airports(IATACode)
VALUES('MDW'), ('ORD');
INSERT INTO #Airports(IATACode)
VALUES('PIT'), ('PHL');
INSERT INTO #StateAirports
(StateId,
 Airports
)
VALUES
(1,
 '7,8'
),
(2,
 '1,2,3,4,5,6'
),
(3,
 '9,10'
);
SELECT *
FROM #States;
SELECT *
FROM #Airports;
SELECT *
FROM #StateAirports;

SELECT s.statename,
       a.iatacode
FROM #StateAirports SA1
     CROSS APPLY string_split(SA1.airports, ',') AS SA2
     JOIN #Airports A ON A.Id = SA2.value
     JOIN #states S ON S.Id = SA1.stateid;
DROP TABLE #states;
DROP TABLE #Airports;
DROP TABLE #StateAirports;