SELECT 
    c.name, 
    c.email, 
    c.phone,
    STRING_AGG(DISTINCT h.name, ', ') AS hotels,
    AVG(b.check_out_date - b.check_in_date) AS avg_stay_duration
FROM 
    Customer c
JOIN 
    Booking b ON c.ID_customer = b.ID_customer
JOIN 
    Room r ON b.ID_room = r.ID_room
JOIN 
    Hotel h ON r.ID_hotel = h.ID_hotel
GROUP BY 
    c.ID_customer
HAVING 
    COUNT(DISTINCT h.ID_hotel) > 1 AND COUNT(*) > 2
ORDER BY 
    COUNT(*) DESC;
