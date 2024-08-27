-- Who has competed in the most races 
SELECT driverid, count(driverid) as totalRaces
FROM results
GROUP BY driverid
ORDER BY totalRaces DESC;

-- Amount of wins for drivers 
SELECT DriverID, COUNT(Position) AS Wins
FROM results
WHERE Position = 1
GROUP BY DriverID
Order BY wins Desc;

-- Drivers nationality
SELECT Nationality, count(Nationality) AS Nationality_Total
FROM drivers
GROUP BY Nationality
ORDER BY Nationality_Total DESC;

-- Drivers nationality and wins
SELECT t1.Nationality, count(t1.Nationality) AS Nationality_Wins
FROM drivers t1
INNER JOIN results t2
ON t1.DriverID = t2.DriverID
WHERE t2.Position = 1
GROUP BY Nationality
ORDER BY Nationality_Wins DESC;

-- Drivers nationality over the years
SELECT t2.Season, t1.Nationality, count(t1.Nationality) AS Nationality_Wins
FROM drivers t1
INNER JOIN results t2
ON t1.DriverID = t2.DriverID
WHERE t2.Position = 1
GROUP BY Season, Nationality
ORDER BY Season, Nationality_Wins DESC;

-- Reasons why they havent finished a race 
SELECT Status, count(Status) AS Status_count
FROM results_history
WHERE Status NOT IN ('Finished'
, '+1 LAP'
, '+2 LAPS'
, '+3 LAPS'
, '+4 LAPS'
, '+5 LAPS'
, '+6 LAPS'
, '+7 LAPS'
, '+8 LAPS'
, '+9 LAPS'
, '+10 LAPS'
, '+11 LAPS'
, '+12 LAPS'
, '+14 LAPS'
, '+17 LAPS'
, '+26 LAPS'
, '+42 LAPS')
Group by Status
Order by Status_count DESC
;

-- Points by drivers per year 
SELECT season, driverId, max(points) AS total_points
FROM driver_standings
GROUP BY season, driverid
ORDER BY season DESC, total_points DESC;

-- Drivers wins per year 
SELECT season, driverid, position, count(position) AS wins
FROM results
WHERE position = 1
GROUP BY season, driverid
ORDER BY season DESC, wins DESC;

-- Fastest lap at each circuit
WITH fastest_lap AS (
SELECT CircuitID, driverid, fastestlaptime,
	RANK() OVER ( PARTITION BY circuitid
    ORDER BY fastestlaptime
    ) as LapRank
FROM results
WHERE FastestLapTime != 0
)
select fastest_lap.circuitid,
GROUP_CONCAT(distinct fastest_lap.driverid) as driver,
MIN(fastest_lap.fastestlaptime) as Laptime
FROM fastest_lap
WHERE LapRank = 1
GROUP BY fastest_lap.circuitid
ORDER BY circuitid;

-- Constructor with the most F1 wins
SELECT constructorId, sum(ConWINS.totalWins) AS total
FROM (
SELECT season, constructorid, position, max(wins) as totalWins
    FROM  constructor_standings
    where wins != 0 
     GROUP BY season, constructorid, position
     ORDER BY max(wins) DESC) as ConWINS
WHERE position = 1
GROUP BY constructorID
ORDER BY total DESC
;

-- Fastest pitstop 
WITH fastest_pitstop AS (
SELECT CircuitID, driverid, duration,
	RANK() OVER ( PARTITION BY circuitid
    ORDER BY duration
    ) as PitstopRank
FROM pitstops
WHERE duration != 0
)
select fastest_pitstop.circuitid,
GROUP_CONCAT(distinct fastest_pitstop.driverid) as driver,
MIN(fastest_pitstop.duration) as pitstoptime
FROM fastest_pitstop
GROUP BY fastest_pitstop.circuitid
ORDER BY circuitid;





