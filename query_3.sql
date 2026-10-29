SELECT 
    order_id,
    booking_datetime::DATE AS order_date,
    EXTRACT(HOUR FROM booking_datetime)::INT AS order_hour,
    service_category,
    city_zone,
    order_status,
    partner_assigned,
    order_value,
    customer_rating,
    
    -- Calculated delivery speed in minutes
    ROUND((EXTRACT(EPOCH FROM (fulfillment_datetime - booking_datetime)) / 60)::NUMERIC, 1) AS tat_minutes,
    
    -- 1 if breached 60 mins, otherwise 0
    CASE 
        WHEN EXTRACT(EPOCH FROM (fulfillment_datetime - booking_datetime)) / 60 > 60 THEN 1 
        ELSE 0 
    END AS is_sla_breach

FROM marketplace_orders;
