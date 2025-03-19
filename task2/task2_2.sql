WITH AvgRacePositions AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        ROUND(AVG(r.position), 4) AS average_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country
    FROM results r
    JOIN cars c ON r.car = c.name
    JOIN classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
),
MinAvgPosition AS (
    SELECT
		MIN(average_position) AS min_avg_position
    FROM AvgRacePositions
)
SELECT 
    arp.car_name,
    arp.car_class,
    arp.average_position,
    arp.race_count,
    arp.car_country
FROM AvgRacePositions arp
JOIN MinAvgPosition map ON arp.average_position = map.min_avg_position
ORDER BY arp.car_name
LIMIT 1;
