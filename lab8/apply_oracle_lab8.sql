-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab8.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab7/apply_oracle_lab7.sql

-- START SPOOLING
SPOOL apply_oracle_lab8.txt

-- STEP 1

CREATE SEQUENCE price_s1 START WITH 1001;

INSERT INTO price
SELECT
  price_s1.nextval
, i.item_id
, cl.common_lookup_id
, af.active_flag
, i.release_date
, (SELECT (i.release_date + 30) FROM dual WHERE af.active_flag = 'N') AS end_date
, (SELECT 
     CASE 
       WHEN i.item_id IN (1022, 1023, 1024) AND cl.common_lookup_type = '1-DAY RENTAL' THEN 3
       WHEN i.item_id IN (1022, 1023, 1024) AND cl.common_lookup_type = '3-DAY RENTAL' THEN 10
       WHEN i.item_id IN (1022, 1023, 1024) AND cl.common_lookup_type = '5-DAY RENTAL' THEN 15
       WHEN af.active_flag = 'N' AND cl.common_lookup_type = '1-DAY RENTAL' THEN 3
       WHEN af.active_flag = 'N' AND cl.common_lookup_type = '3-DAY RENTAL' THEN 10
       WHEN af.active_flag = 'N' AND cl.common_lookup_type = '5-DAY RENTAL' THEN 15
       WHEN af.active_flag = 'Y' AND cl.common_lookup_type = '1-DAY RENTAL' THEN 1
       WHEN af.active_flag = 'Y' AND cl.common_lookup_type = '3-DAY RENTAL' THEN 3
       WHEN af.active_flag = 'Y' AND cl.common_lookup_type = '5-DAY RENTAL' THEN 5
     ELSE NULL END
   FROM dual)
, 1001
, SYSDATE
, 1001
, SYSDATE
FROM     item i CROSS JOIN
        (SELECT 'Y' AS active_flag FROM dual
         UNION ALL
         SELECT 'N' AS active_flag FROM dual) af CROSS JOIN
        (SELECT '1' AS rental_days FROM dual
         UNION ALL
         SELECT '3' AS rental_days FROM dual
         UNION ALL
         SELECT '5' AS rental_days FROM dual) dr INNER JOIN
         common_lookup cl ON dr.rental_days = SUBSTR(cl.common_lookup_type,1,1)
WHERE    cl.common_lookup_table = 'PRICE'
AND      cl.common_lookup_column = 'PRICE_TYPE'
AND NOT  (i.item_id IN (1022, 1023, 1024) AND af.active_flag = 'N');

-- CONFIRM 
SELECT  'OLD Y' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND      end_date IS NULL
UNION ALL
SELECT  'OLD N' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND NOT end_date IS NULL
UNION ALL
SELECT  'NEW Y' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      end_date IS NULL
UNION ALL
SELECT  'NEW N' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      NOT (end_date IS NULL);

-- STEP 2
ALTER TABLE price
MODIFY price_type NUMBER CONSTRAINT nn_price_10 NOT NULL;

-- CONFIRM
COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'PRICE'
AND      column_name = 'PRICE_TYPE';

-- STEP 3
UPDATE   rental_item ri
SET      rental_item_price =
          (SELECT 
              CASE
                WHEN rental_item_id IN (1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009) THEN 5
                WHEN rental_item_id IN (1010) THEN 1
                WHEN rental_item_id IN (1011) THEN 3
                WHEN rental_item_id IN (1012) THEN 10
                WHEN rental_item_id IN (1013) THEN 15
              ELSE NULL END
           FROM DUAL);
-- CONFIRM
-- Widen the display console.
SET LINESIZE 110
 
-- Set the column display values.
COL customer_name          FORMAT A20  HEADING "Contact|--------|Customer Name"
COL contact_id             FORMAT 9999 HEADING "Contact|--------|Contact|ID #"
COL customer_id            FORMAT 9999 HEADING "Rental|--------|Customer|ID #"
COL r_rental_id            FORMAT 9999 HEADING "Rental|------|Rental|ID #"
COL ri_rental_id           FORMAT 9999 HEADING "Rental|Item|------|Rental|ID #"
COL rental_item_id         FORMAT 9999 HEADING "Rental|Item|------||ID #"
COL price_item_id          FORMAT 9999 HEADING "Price|------|Item|ID #"
COL rental_item_item_id    FORMAT 9999 HEADING "Rental|Item|------|Item|ID #"
COL rental_item_price      FORMAT 9999 HEADING "Rental|Item|------||Price"
COL amount                 FORMAT 9999 HEADING "Price|------||Amount"
COL price_type_code        FORMAT 9999 HEADING "Price|------|Type|Code"
COL rental_item_type_code  FORMAT 9999 HEADING "Rental|Item|------|Type|Code"
SELECT   c.last_name||', '||c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name
         END AS customer_name
,        c.contact_id
,        r.customer_id
,        r.rental_id AS r_rental_id
,        ri.rental_id AS ri_rental_id
,        ri.rental_item_id
,        p.item_id AS price_item_id
,        ri.item_id AS rental_item_item_id
,        ri.rental_item_price
,        p.amount
,        TO_NUMBER(cl2.common_lookup_code) AS price_type_code
,        TO_NUMBER(cl2.common_lookup_code) AS rental_item_type_code
FROM     price p INNER JOIN common_lookup cl1
ON       p.price_type = cl1.common_lookup_id
AND      cl1.common_lookup_table = 'PRICE'
AND      cl1.common_lookup_column = 'PRICE_TYPE' FULL JOIN rental_item ri 
ON       p.item_id = ri.item_id INNER JOIN common_lookup cl2
ON       ri.rental_item_type = cl2.common_lookup_id
AND      cl2.common_lookup_table = 'RENTAL_ITEM'
AND      cl2.common_lookup_column = 'RENTAL_ITEM_TYPE' RIGHT JOIN rental r
ON       ri.rental_id = r.rental_id FULL JOIN contact c
ON       r.customer_id = c.contact_id
WHERE    cl1.common_lookup_code = cl2.common_lookup_code
AND      r.check_out_date
BETWEEN  p.start_date AND NVL(p.end_date,TRUNC(SYSDATE) + 1)
ORDER BY 2, 3;
 
-- Reset the column display values to their default value.
SET LINESIZE 80

-- STEP 4
ALTER TABLE rental_item
MODIFY rental_item_price NUMBER CONSTRAINT nn_rental_item_7 NOT NULL;

-- CONFIRM
COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM'
AND      column_name = 'RENTAL_ITEM_PRICE';


SPOOL OFF
