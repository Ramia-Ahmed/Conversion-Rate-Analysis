CREATE Table shoppers AS
SELECT * FROM read_csv_auto('online_shoppers_intention.csv');

SELECT * FROM shoppers;

CREATE VIEW cr_overall AS
SELECT
    COUNT(*) AS total_sessions,
    SUM(CASE WHEN Revenue THEN TRUE ELSE FALSE END) AS converted_sessions,
    ROUND(100.0 * converted_sessions / total_sessions, 2) AS conversion_rate_pct
FROM shoppers;

CREATE VIEW cr_by_visitor_type AS
SELECT
    VisitorType,
    COUNT(*) AS total_sessions,
    SUM(CASE WHEN Revenue THEN TRUE ELSE FALSE END) AS converted_sessions,
    ROUND(100.0 * converted_sessions / total_sessions, 2) AS conversion_rate_pct
FROM shoppers
GROUP BY VisitorType
ORDER BY conversion_rate_pct;

CREATE VIEW cr_by_month AS
SELECT
    Month,
    COUNT(*) AS total_sessions,
    SUM(CASE WHEN Revenue THEN TRUE ELSE FALSE END) AS converted_sessions,
    ROUND(100.0 * converted_sessions / total_sessions, 2) AS conversion_rate_pct,
    CASE Month
        WHEN 'Jan' THEN 1
        WHEN 'Feb' THEN 2
        WHEN 'Mar' THEN 3
        WHEN 'Apr' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'Jul' THEN 7
        WHEN 'Aug' THEN 8
        WHEN 'Sep' THEN 9
        WHEN 'Oct' THEN 10
        WHEN 'Nov' THEN 11
        WHEN 'Dec' THEN 12
    END AS month_order
FROM shoppers
GROUP BY Month
ORDER BY conversion_rate_pct;

CREATE VIEW cr_by_weekend AS
SELECT
    Weekend,
    COUNT(*) AS total_sessions,
    SUM(CASE WHEN Revenue THEN TRUE ELSE FALSE END) AS converted_sessions,
    ROUND(100.0 * converted_sessions / total_sessions, 2) AS conversion_rate_pct
FROM shoppers
GROUP BY Weekend
ORDER BY conversion_rate_pct;

CREATE VIEW cr_by_traffic_type AS
SELECT
    TrafficType,
    COUNT(*) AS total_sessions,
    SUM(CASE WHEN Revenue THEN TRUE ELSE FALSE END) AS converted_sessions,
    ROUND(100.0 * converted_sessions / total_sessions, 2) AS conversion_rate_pct
FROM shoppers
GROUP BY TrafficType
ORDER BY conversion_rate_pct;

CREATE VIEW cr_by_region AS
SELECT
    Region,
    COUNT(*) AS total_sessions,
    SUM(CASE WHEN Revenue THEN TRUE ELSE FALSE END) AS converted_sessions,
    ROUND(100.0 * converted_sessions / total_sessions, 2) AS conversion_rate_pct
FROM shoppers
GROUP BY Region
ORDER BY conversion_rate_pct;

CREATE VIEW behavior_by_revenue AS
SELECT
    Revenue,
    ROUND(AVG(PageValues), 2) AS avg_page_values,
    ROUND(AVG(ExitRates), 2) AS avg_exit_rate,
    ROUND(AVG(BounceRates), 2) AS avg_bounce_rate,
    ROUND(AVG(ProductRelated_Duration), 2) AS avg_duration_on_product_page
FROM shoppers
GROUP BY Revenue;

CREATE VIEW behavior_by_visitor_type AS
SELECT
    VisitorType,
    ROUND(AVG(PageValues), 2) AS avg_page_values,
    ROUND(AVG(ExitRates), 2) AS avg_exit_rate,
    ROUND(AVG(BounceRates), 2) AS avg_bounce_rate,
    ROUND(AVG(ProductRelated_Duration), 2) AS avg_duration_on_product_page
FROM shoppers
GROUP BY VisitorType
ORDER BY avg_page_values;

COPY cr_overall TO 'exports/cr_overall.csv' (HEADER, DELIMITER ',');
COPY cr_by_visitor_type TO 'exports/cr_by_visitor_type.csv' (HEADER, DELIMITER ',');
COPY cr_by_month TO 'exports/cr_by_month.csv' (HEADER, DELIMITER ',');
COPY cr_by_weekend TO 'exports/cr_by_weekend.csv' (HEADER, DELIMITER ',');
COPY cr_by_traffic_type TO 'exports/cr_by_traffic_type.csv' (HEADER, DELIMITER ',');
COPY cr_by_region TO 'exports/cr_by_region.csv' (HEADER, DELIMITER ',');
COPY behavior_by_revenue TO 'exports/behavior_by_revenue.csv' (HEADER, DELIMITER ',');
COPY behavior_by_visitor_type TO 'exports/behavior_by_visitor_type.csv' (HEADER, DELIMITER ',');