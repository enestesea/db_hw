WITH HotelCategories AS (
    SELECT 
        h.ID_hotel,
        CASE 
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_category
    FROM Hotel h
    JOIN Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY h.ID_hotel
),
ClientHotelPreferences AS (
    SELECT 
        c.ID_customer,
        c.name,
        CASE
            WHEN EXISTS (SELECT 1 FROM Booking b 
                         JOIN Room r ON b.ID_room = r.ID_room 
                         JOIN HotelCategories hc ON r.ID_hotel = hc.ID_hotel 
                         WHERE b.ID_customer = c.ID_customer AND hc.hotel_category = 'Дорогой') THEN 'Дорогой'
            WHEN EXISTS (SELECT 1 FROM Booking b 
                         JOIN Room r ON b.ID_room = r.ID_room 
                         JOIN HotelCategories hc ON r.ID_hotel = hc.ID_hotel 
                         WHERE b.ID_customer = c.ID_customer AND hc.hotel_category = 'Средний') THEN 'Средний'
            ELSE 'Дешевый'
        END AS preferred_hotel_type,
        STRING_AGG(DISTINCT h.name, ', ') AS visited_hotels
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    JOIN HotelCategories hc ON r.ID_hotel = hc.ID_hotel
    GROUP BY c.ID_customer, c.name
)

SELECT 
    c.ID_customer,
    c.name,
    c.preferred_hotel_type,
    c.visited_hotels
FROM ClientHotelPreferences c
ORDER BY 
    CASE c.preferred_hotel_type
        WHEN 'Дешевый' THEN 1
        WHEN 'Средний' THEN 2
        WHEN 'Дорогой' THEN 3
    END, id_customer;
