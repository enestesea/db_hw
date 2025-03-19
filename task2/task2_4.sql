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
ClassAvgPosition AS (
    SELECT 
        car_class,
        ROUND(AVG(average_position), 4) AS class_avg_position
    FROM AvgRacePositions
    GROUP BY car_class
),
FilteredCars AS (
    SELECT 
        arp.car_name,
        arp.car_class,
        arp.average_position,
        arp.race_count,
        arp.car_country,
        cap.class_avg_position
    FROM AvgRacePositions arp
    JOIN ClassAvgPosition cap ON arp.car_class = cap.car_class
)
SELECT 
    fc.car_name,
    fc.car_class,
    fc.average_position,
    fc.race_count,
    fc.car_country
FROM FilteredCars fc
WHERE fc.average_position < fc.class_avg_position
AND (SELECT COUNT(*) FROM AvgRacePositions WHERE car_class = fc.car_class) >= 2
ORDER BY fc.car_class, fc.average_position;
