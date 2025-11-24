
--Car Sales Analysis---------------------------------------------------------------------------------------------------------------------------


-- Confirming if all my data is uploaded fine with data type correct
    
    SELECT * 
     FROM car_sale_table;
     
-----------------------------------------------------------------------------------------------------------------------------------------------

-- Dates
--Operating days

SELECT 
    -- First and Last Operating Dates
    MIN(TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS')) AS First_Operating_Date,                 --2014-01-01 09:15:00.000
    MAX(TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS')) AS Last_Operating_Date,                  --2015-07-21 02:30:00.000
    
    -- Month Name
    TO_CHAR(MIN(TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS')), 'MON') AS First_MonthName,       --Jan
    TO_CHAR(MAX(TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS')), 'MON') AS Last_MonthName,        --Jul

    -- Hour of the Day (0–23)
    EXTRACT(HOUR FROM MIN(TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS'))) AS First_Hour,         --= 9
    EXTRACT(HOUR FROM MAX(TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS'))) AS Last_Hour           --= 2

FROM car_sale_table;



-----------------------------------------------------------------------------------------------------------------------------------------------

-- Total Cars we have        Total_Cars = 550296

    SELECT count(distinct(vin_id)) as Total_Cars_Sold                               ---Total_Cars = 550296
     FROM car_sale_table;

-----------------------------------------------------------------------------------------------------------------------------------------------

--  Unique Cars Sold  = 973 

    SELECT  DISTINCT(model)                                                                --= 973 
     FROM car_sale_table;
     
-----------------------------------------------------------------------------------------------------------------------------------------------

--  Day Name, Month Name, Hour Columns (Per Row)

SELECT 
    saledate,

    -- Convert your string to a real timestamp
    TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS') AS sale_timestamp,

    -- Day Name (Mon, Tue, Wed...)
    TO_CHAR(TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS'), 'DY') AS Day_Name,

    -- Month Name (Jan, Feb...)
    TO_CHAR(TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS'), 'MON') AS Month_Name,

    -- Hour of Day (0–23)
    EXTRACT(HOUR FROM TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS')) AS Hour_Of_Day

FROM car_sale_table;  

-----------------------------------------------------------------------------------------------------------------------------------------------

--Total Revenue

SELECT 
    SUM(sellingprice) AS total_revenue                                                         -- = 7 606 012 287
FROM car_sale_table;


-----------------------------------------------------------------------------------------------------------------------------------------------

--Final code for Data ingestion


SELECT
    -- Coalesce for Null handling
    year,
    COALESCE(brand, 'Unknown') AS brand,
    COALESCE(model, 'Unknown') AS model,
    COALESCE(trim, 'Unknown') AS trim,
    COALESCE(body, 'Unknown') AS body,
    COALESCE(transmission, 'Unknown') AS transmission,
    COALESCE(state, 'Unknown') AS region,
    condition,
    COALESCE(odometer, 0) AS odometer,
    COALESCE(color, 'Unknown') AS color,
    COALESCE(interior, 'Unknown') AS interior,
    COALESCE(seller, 'Unknown') AS seller,
    
    
    market_value AS market_value,
    sellingprice AS total_revenue,
    
    -- Revenue & profit calculations
    ROUND((sellingprice - market_value) / NULLIF(sellingprice, 0) * 100, 2) AS profit_margin,
    
    -- Profit margin category
    CASE 
        WHEN ROUND((sellingprice - market_value) / NULLIF(sellingprice, 0) * 100, 2) >= 20 THEN 'High Margin'
        WHEN ROUND((sellingprice - market_value) / NULLIF(sellingprice, 0) * 100, 2) BETWEEN 10 AND 20 THEN 'Medium Margin'
        ELSE 'Low Margin'
    END AS margin_category,
    
    -- Price difference from market value
    sellingprice - market_value AS price_diff,
    
    -- Units sold per VIN
    1 AS units_sold,
    
   cv@khomeliwa.co.za


 -- Date parsing & breakdown
    TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS') AS sale_timestamp,
    TO_DATE(TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS')) AS sale_date,
    INITCAP(TO_CHAR(TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS'), 'DY')) AS day_name,
    INITCAP(TO_CHAR(TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS'), 'MON')) AS month_name,
    DATE_PART('QUARTER', TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS')) AS quarter,
    DATE_PART('YEAR', TO_TIMESTAMP(saledate, 'DY MON DD YYYY HH24:MI:SS')) AS sale_year,
    
    -- Data quality flag
    CASE 
        WHEN brand IS NULL OR model IS NULL OR sellingprice IS NULL OR market_value IS NULL THEN 'Incomplete'
        ELSE 'Complete'
    END AS data_quality

FROM car_sale_table;



---------------------------------------------------------------------------------------------------------------------------------------------



