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
MinClassAvgPosition AS (
    SELECT 
        MIN(class_avg_position) AS min_class_avg_position
    FROM ClassAvgPosition
)
SELECT 
    arp.car_name,
    arp.car_class,
    arp.average_position,
    arp.race_count,
    arp.car_country,
    COUNT(race) AS total_race_count
FROM AvgRacePositions arp
JOIN ClassAvgPosition cap ON arp.car_class = cap.car_class
JOIN MinClassAvgPosition mcap ON cap.class_avg_position = mcap.min_class_avg_position
JOIN results r ON r.car = arp.car_name
GROUP BY arp.car_name, arp.car_class, arp.average_position, arp.race_count, arp.car_country
ORDER BY arp.car_class, arp.average_position;
