CREATE DATABASE SolarAnalysis;
USE SolarAnalysis;

CREATE TABLE SolarData (
    Time_value FlOAT,
    Ipv FLOAT,
    Vpv FLOAT,
    Vdc FLOAT,
    ia FLOAT,
    ib FLOAT,
    ic FLOAT,
    va FLOAT,
    vb FLOAT,
    vc FLOAT,
    Iabc FLOAT,
    If_value FLOAT,  -- Already renamed in CSV
    Vabc FLOAT,
    Vf FLOAT,
    Defective_NonDefective INT
);

Select * from SolarData limit 10;
SELECT COUNT(*) FROM solardatafsql;
select * from solardatafsql limit 10;

INSERT INTO SolarData 
SELECT * FROM solardatafsql;
select * from solardata limit 10;

SELECT COUNT(*) FROM SolarData;

DESCRIBE SolarData;
DESCRIBE SolarDatafsql;


DROP TABLE SolarDatafsql;


-- Count Total Records
SELECT COUNT(*) AS total_records FROM solardata;

-- Count Defective vs Non-Defective Panels

SELECT Defective_NonDefective , COUNT(*) AS count
FROM solardata
GROUP BY Defective_NonDefective ;

-- 0	20000  Non-defective 
-- 1	80000  Defective 

-- Average Voltage and Current Values

SELECT AVG(Vpv) AS avg_vpv, AVG(Vdc) AS avg_vdc, AVG(Ipv) AS avg_ipv
FROM solardata;

--   avg_vpv              avg_vdc                avg_ipv
-- 89.07431396484375	138.656291015625	1.7609529849243437

--  Maximum and Minimum Voltage Values

SELECT MAX(Vpv) AS max_vpv, MIN(Vpv) AS min_vpv,
       MAX(Vdc) AS max_vdc, MIN(Vdc) AS min_vdc
FROM solardata;

--    max_vpv      min_vpv    max_vdc     min_vdc
--   111.023	  -1.01929	  250.781	 0.585938

-- Trends in Voltage and Current Over Time

SELECT Time_value, AVG(Vpv) AS avg_vpv, AVG(Ipv) AS avg_ipv
FROM solardata
GROUP BY Time_value
ORDER BY Time_value;


 -- Identifying Faulty Trends
 
SELECT Time_value, Vpv, Vdc, Ipv
FROM solardata
WHERE Defective_NonDefective  = 1
ORDER BY Time_value;

-- : Data Validation and Cleaning

--  Check for Null or Missing Values

SELECT * FROM solardata
WHERE Vpv IS NULL OR Vdc IS NULL OR Ipv IS NULL;

-- Remove Duplicates

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;


DELETE FROM solardata
WHERE Time_value IN (
    SELECT Time_value FROM (
        SELECT Time_value, ROW_NUMBER() OVER (PARTITION BY Time_value ORDER BY Time_value) AS row_num
        FROM solardata
    ) t WHERE row_num > 0
);

SELECT COUNT(*) FROM SolarData;
SELECT COUNT(*) FROM SolarDatafsql;


DELETE FROM solardata
WHERE (Time_value, Ipv, Vpv, Vdc, ia, ib, ic, va, vb, vc, Iabc, If_value, Vabc, Vf, Defective_NonDefective) IN (
    SELECT Time_value, Ipv, Vpv, Vdc, ia, ib, ic, va, vb, vc, Iabc, If_value, Vabc, Vf, Defective_NonDefective
    FROM (
        SELECT Time_value, Ipv, Vpv, Vdc, ia, ib, ic, va, vb, vc, Iabc, If_value, Vabc, Vf, Defective_NonDefective,
               ROW_NUMBER() OVER (PARTITION BY Time_value, Ipv, Vpv, Vdc, ia, ib, ic, va, vb, vc, Iabc, If_value, Vabc, Vf, Defective_NonDefective 
                                  ORDER BY Time_value) AS row_num
        FROM solardata
    ) t WHERE row_num > 1
);

select count(*) from solardata;

SELECT 
    (SELECT COUNT(*) FROM solardata) AS total_records,
    (SELECT COUNT(*) FROM solardata WHERE Defective_Nondefective = 1) AS defective_count,
    (SELECT COUNT(*) FROM solardata WHERE  Defective_Nondefective = 0) AS non_defective_count,
    (SELECT AVG(Vpv) FROM solardata) AS avg_vpv,
    (SELECT AVG(Ipv) FROM solardata) AS avg_ipv;
    




    
 