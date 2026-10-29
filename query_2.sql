SELECT 
    EXTRACT(HOUR FROM booking_datetime)::INT AS order_hour,
    COUNT(*) AS total_orders,
    
    -- Orders where no delivery partner accepted
    COUNT(*) FILTER (WHERE partner_assigned = FALSE) AS unassigned_orders,
    
    -- Orders dropped by partners
    COUNT(*) FILTER (WHERE order_status = 'Cancelled_Provider') AS provider_cancellations,
    
    -- Average delivery speed this hour
    ROUND(AVG(EXTRACT(EPOCH FROM (fulfillment_datetime - booking_datetime)) / 60)::NUMERIC, 1) AS avg_tat_mins

FROM marketplace_orders
WHERE city_zone = 'Zone East'
GROUP BY order_hour
ORDER BY order_hour ASC;
