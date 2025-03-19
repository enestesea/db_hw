WITH AvgRacePositions AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        ROUND(AVG(r.position), 4) AS average_position,
        COUNT(r.race) AS race_count
    FROM results r
    JOIN cars c ON r.car = c.name
    GROUP BY c.name, c.class
),
MinAvgPositions AS (
    SELECT 
        car_class,
        MIN(average_position) AS min_avg_position
    FROM AvgRacePositions
    GROUP BY car_class
)
SELECT 
    arp.car_name,
    arp.car_class,
    arp.average_position,
    arp.race_count
FROM AvgRacePositions arp
JOIN MinAvgPositions map ON arp.car_class = map.car_class
WHERE arp.average_position = map.min_avg_position
ORDER BY arp.average_position;
