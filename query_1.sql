SELECT 
    service_category,
    city_zone,
    COUNT(*) AS total_orders,
    
    -- Count completed orders
    COUNT(*) FILTER (WHERE order_status = 'Completed') AS completed_orders,
    
    -- Fulfillment Rate % = (Completed / Total) * 100
    ROUND(100.0 * COUNT(*) FILTER (WHERE order_status = 'Completed') / COUNT(*), 1) AS fulfillment_rate_pct,
    
    -- Average delivery time in minutes
    ROUND(AVG(EXTRACT(EPOCH FROM (fulfillment_datetime - booking_datetime)) / 60)::NUMERIC, 1) AS avg_tat_mins,
    
    -- Orders that breached 60 minutes
    COUNT(*) FILTER (WHERE EXTRACT(EPOCH FROM (fulfillment_datetime - booking_datetime)) / 60 > 60) AS sla_breaches,
    
    -- Total money collected from completed orders
    SUM(order_value) FILTER (WHERE order_status = 'Completed') AS net_gmv

FROM marketplace_orders
GROUP BY service_category, city_zone
ORDER BY fulfillment_rate_pct ASC;
